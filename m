Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231045A3732
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 13:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbiH0LMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 07:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiH0LMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 07:12:43 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F11954C99;
        Sat, 27 Aug 2022 04:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1661598744;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=VaJk7sINEIae+TNpvJ5IvFGcM4VJpS4JY8vRgYaAwNo=;
    b=B2xS/I0gWOpeNipmsYABfVSUN4RhWuEBF0eWc1yd0Qds8tdmY8YN0ZUKtdY4EN7Eno
    72jNfgxe8AOs84207oWUp6zr8pQetJfVceqPiV9t8CZ4Gf2DnxXUzwuFCFonX7L2Zf/1
    2whgR4oUgVALbgv1PAn2FvCv7RSddA70MF01/GT98RRfO5DMEkOHNF4noKBZHaLCgkg0
    ds2DkcE7F5iErMj/hTUY8V8vPZZh4BMIaeW6GLeo8+F8dID2A+3rDh/H3O67Qz5AyoOr
    Kx/VSTHLHuwW/sl0dnGb7+J5GRsxDdKP82wqkVY38k3g4b3hmQHzAR3iCF3Sx9wYPhfa
    2Img==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdIrpKytISr6jamATg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfd:d104::1e4]
    by smtp.strato.de (RZmta 47.47.0 AUTH)
    with ESMTPSA id Icb1b0y7RBCNIdT
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Aug 2022 13:12:23 +0200 (CEST)
Message-ID: <33cab5f4-8391-a59f-0873-b359c9c13917@hartkopp.net>
Date:   Sat, 27 Aug 2022 13:12:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [RFC PATCH 1/1] can: virtio: Initial virtio CAN driver.
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Harald Mommer <harald.mommer@opensynergy.com>
Cc:     virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dariusz Stojaczyk <Dariusz.Stojaczyk@opensynergy.com>,
        Harald Mommer <hmo@opensynergy.com>
References: <20220825134449.18803-1-harald.mommer@opensynergy.com>
 <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20220827093909.ag3zi7k525k4zuqq@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/22 11:39, Marc Kleine-Budde wrote:
> On 25.08.2022 15:44:49, Harald Mommer wrote:
>> - CAN Control
>>
>>    - "ip link set up can0" starts the virtual CAN controller,
>>    - "ip link set up can0" stops the virtual CAN controller
>>
>> - CAN RX
>>
>>    Receive CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN TX
>>
>>    Send CAN frames. CAN frames can be standard or extended, classic or
>>    CAN FD. Classic CAN RTR frames are supported.
>>
>> - CAN Event indication (BusOff)
>>
>>    The bus off handling is considered code complete but until now bus off
>>    handling is largely untested.
> 
> Is there an Open Source implementation of the host side of this
> interface?
> 
> Please fix these checkpatch warnings:
> 
> | WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> | #65:
> | new file mode 100644
> |
> | WARNING: Use #include <linux/atomic.h> instead of <asm/atomic.h>
> | #105: FILE: drivers/net/can/virtio_can/virtio_can.c:7:
> | +#include <asm/atomic.h>
> |
> | WARNING: __always_unused or __maybe_unused is preferred over __attribute__((__unused__))
> | #186: FILE: drivers/net/can/virtio_can/virtio_can.c:88:
> | +static void __attribute__((unused))
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #263: FILE: drivers/net/can/virtio_can/virtio_can.c:165:
> | +	BUG_ON(prio != 0); /* Currently only 1 priority */
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #264: FILE: drivers/net/can/virtio_can/virtio_can.c:166:
> | +	BUG_ON(atomic_read(&priv->tx_inflight[0]) >= priv->can.echo_skb_max);
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #279: FILE: drivers/net/can/virtio_can/virtio_can.c:181:
> | +	BUG_ON(prio >= VIRTIO_CAN_PRIO_COUNT);
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #280: FILE: drivers/net/can/virtio_can/virtio_can.c:182:
> | +	BUG_ON(idx >= priv->can.echo_skb_max);
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #281: FILE: drivers/net/can/virtio_can/virtio_can.c:183:
> | +	BUG_ON(atomic_read(&priv->tx_inflight[prio]) == 0);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #288: FILE: drivers/net/can/virtio_can/virtio_can.c:190:
> | +/*
> | + * Create a scatter-gather list representing our input buffer and put
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #309: FILE: drivers/net/can/virtio_can/virtio_can.c:211:
> | +/*
> | + * Send a control message with message type either
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #332: FILE: drivers/net/can/virtio_can/virtio_can.c:234:
> | +	/*
> | +	 * The function may be serialized by rtnl lock. Not sure.
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #382: FILE: drivers/net/can/virtio_can/virtio_can.c:284:
> | +/*
> | + * See also m_can.c/m_can_set_mode()
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #408: FILE: drivers/net/can/virtio_can/virtio_can.c:310:
> | +/*
> | + * Called by issuing "ip link set up can0"
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #443: FILE: drivers/net/can/virtio_can/virtio_can.c:345:
> | +	/*
> | +	 * Keep RX napi active to allow dropping of pending RX CAN messages,
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #481: FILE: drivers/net/can/virtio_can/virtio_can.c:383:
> | +	/*
> | +	 * No local check for CAN_RTR_FLAG or FD frame against negotiated
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #521: FILE: drivers/net/can/virtio_can/virtio_can.c:423:
> | +		/*
> | +		 * May happen if
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #533: FILE: drivers/net/can/virtio_can/virtio_can.c:435:
> | +	BUG_ON(can_tx_msg->putidx < 0);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #613: FILE: drivers/net/can/virtio_can/virtio_can.c:515:
> | +		/*
> | +		 * Here also frames with result != VIRTIO_CAN_RESULT_OK are
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #646: FILE: drivers/net/can/virtio_can/virtio_can.c:548:
> | +/*
> | + * Poll TX used queue for sent CAN messages
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #675: FILE: drivers/net/can/virtio_can/virtio_can.c:577:
> | +/*
> | + * This function is the NAPI RX poll function and NAPI guarantees that this
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #698: FILE: drivers/net/can/virtio_can/virtio_can.c:600:
> | +	BUG_ON(len < header_size);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #813: FILE: drivers/net/can/virtio_can/virtio_can.c:715:
> | +/*
> | + * See m_can_poll() / m_can_handle_state_errors() m_can_handle_state_change().
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #855: FILE: drivers/net/can/virtio_can/virtio_can.c:757:
> | +/*
> | + * Poll RX used queue for received CAN messages
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #897: FILE: drivers/net/can/virtio_can/virtio_can.c:799:
> | +		/*
> | +		 * The interrupt function is not assumed to be interrupted by
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #904: FILE: drivers/net/can/virtio_can/virtio_can.c:806:
> | +		BUG_ON(len < sizeof(struct virtio_can_event_ind));
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #966: FILE: drivers/net/can/virtio_can/virtio_can.c:868:
> | +	/*
> | +	 * The order of RX and TX is exactly the opposite as in console and
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #976: FILE: drivers/net/can/virtio_can/virtio_can.c:878:
> | +	BUG_ON(!priv);
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #977: FILE: drivers/net/can/virtio_can/virtio_can.c:879:
> | +	BUG_ON(!priv->vdev);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1004: FILE: drivers/net/can/virtio_can/virtio_can.c:906:
> | +	/*
> | +	 * From here we have dead silence from the device side so no locks
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1025: FILE: drivers/net/can/virtio_can/virtio_can.c:927:
> | +	/*
> | +	 * Is keeping track of allocated elements by an own linked list
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #1060: FILE: drivers/net/can/virtio_can/virtio_can.c:962:
> | +	BUG_ON(!vdev);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1063: FILE: drivers/net/can/virtio_can/virtio_can.c:965:
> | +	/*
> | +	 * CAN needs always access to the config space.
> |
> | WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code rather than BUG() or BUG_ON()
> | #1090: FILE: drivers/net/can/virtio_can/virtio_can.c:992:
> | +	BUG_ON(!vdev);
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1144: FILE: drivers/net/can/virtio_can/virtio_can.c:1046:
> | +	/*
> | +	 * It is possible to consider the number of TX queue places to
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1185: FILE: drivers/net/can/virtio_can/virtio_can.c:1087:
> | +/*
> | + * Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
> |
> | WARNING: networking block comments don't use an empty /* line, use /* Comment...
> | #1210: FILE: drivers/net/can/virtio_can/virtio_can.c:1112:
> | +/*
> | + * Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
> |
> | WARNING: Prefer "GPL" over "GPL v2" - see commit bf7fbeeae6db ("module: Cure the MODULE_LICENSE "GPL" vs. "GPL v2" bogosity")
> | #1273: FILE: drivers/net/can/virtio_can/virtio_can.c:1175:
> | +MODULE_LICENSE("GPL v2");

Btw. @Harald:

When you want to express your code to be GPLv2 why is your code GPL-2.0+ 
then?

diff --git a/drivers/net/can/virtio_can/virtio_can.c 
b/drivers/net/can/virtio_can/virtio_can.c
new file mode 100644
index 000000000000..dafbe5a36511
--- /dev/null
+++ b/drivers/net/can/virtio_can/virtio_can.c
@@ -0,0 +1,1176 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * CAN bus driver for the Virtio CAN controller
+ * Copyright (C) 2021 OpenSynergy GmbH
+ */

Best regards,
Oliver

> |
> | WARNING: From:/Signed-off-by: email address mismatch: 'From: Harald Mommer <harald.mommer@opensynergy.com>' != 'Signed-off-by: Harald Mommer <hmo@opensynergy.com>'
> |
> | total: 0 errors, 38 warnings, 1275 lines checked
> 
> regards,
> Marc
> 
