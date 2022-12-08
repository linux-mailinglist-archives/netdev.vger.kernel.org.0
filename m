Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5889B646BD5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbiLHJZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiLHJZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:25:23 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D355E3C6;
        Thu,  8 Dec 2022 01:25:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id E53C7121;
        Thu,  8 Dec 2022 10:25:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1670491520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1R2dyYxzFhTIG+A8uIWMszimPhlmvmzOf72P/mWZG20=;
        b=WWzaQC5FSCThOD80qrlOnaDg5TEe90uAYe9upqXMtTsWHeZ6xq37w6pbdVjNevmxxqv+lx
        yfnO/ipjt1LPdDxrqPFh1vyz1Gfps5GR1FETtCt67iXNoWvzCsTNmI57u1+uWTNZy04Lfp
        zv99DXRcq7a+AlqsGYYzcGLN3HLx1RL3d9zaXXOGUh2JuVH9+lX+IZgkv2ziHbdyNIPRgT
        nXD1nubC7NPIR4q3Zt3bzzt3yBE+cxFxckF6XdUTq0olqnkumOs4zcXMFt1WLEqilkBWDz
        /+uA0B312rzUUcPnVUMY71cE48bQiXnHa4XDpiYgtp65KrqH+eRVpVTXy0aBqQ==
From:   Michael Walle <michael@walle.cc>
To:     horatiu.vultur@microchip.com
Cc:     Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        daniel.machon@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        richardcochran@gmail.com, michael@walle.cc
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Date:   Thu,  8 Dec 2022 10:25:11 +0100
Message-Id: <20221208092511.4122746-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

> Currently lan966x, doesn't allow to run PTP over interfaces that are
> part of the bridge. The reason is when the lan966x was receiving a
> PTP frame (regardless if L2/IPv4/IPv6) the HW it would flood this
> frame.
> Now that it is possible to add VCAP rules to the HW, such to trap these
> frames to the CPU, it is possible to run PTP also over interfaces that
> are part of the bridge.

This gives me:

# /etc/init.d/S65ptp4l start
Starting linuxptp daemon: OK
[   44.136870] vcap_val_rule:1678: keyset was not updated: -22
[   44.140196] vcap_val_rule:1678: keyset was not updated: -22
#

# ptp4l -v
3.1.1
# uname -a
Linux buildroot 6.1.0-rc8-next-20221208+ #924 SMP Thu Dec  8 10:08:58 CET 2022 armv7l GNU/Linux

I don't know whats going on, but I'm happy to help with debugging with some
guidance.

-michael
