Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8B86E7FB6
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbjDSQeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbjDSQeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:34:04 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65382421C;
        Wed, 19 Apr 2023 09:33:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a682eee3baso1545325ad.0;
        Wed, 19 Apr 2023 09:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681922039; x=1684514039;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hejd87Jll0E8NOGuMljt4taTMik1yKpFSOJV8ogm+QU=;
        b=otvUaF7ejsijSly4r1bE5p0DcDAEY+dCK+KVYM+TKOnGIRDPkokhlWhv1Y4lwB+ZkJ
         J+rF08EQd1xv3uuCAYfuKfepDM3Eusu6Uzl+SkCDbVx4j8Kn6sz+XuG7ALq2caYTgvj8
         08wPhYvwIHTxLDZdYdxa2Xd5iDpIHEpZDQQLzd8+mvwCpOCz+WsrdOTTJ2/6cA9LYgzN
         7NDAmo86b0SDi1sLACOkw9YxuxQHprwevC+PiLw6AfCihrx2IR9ovUWUsBFPeUWvsix0
         FhdUPHDgv7r1UhOtdh8KkQQQN/cNQEWYyJrQZ1/9O7ON5XBMjvxAcMuAzNGWcDRBFKOz
         QhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922039; x=1684514039;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hejd87Jll0E8NOGuMljt4taTMik1yKpFSOJV8ogm+QU=;
        b=SkD3fujLoSe/rbrQEzHt9fmQ/uapgcltvPA8LfqBZq65QvvXKWlwJx7A9rkJS2xxU8
         Pyn3vSrT1R/69qETu5ctUGQYCzpgCWvEbeqSJrOpbw9TWAHpJprXmK1EMW4m6LKxeowU
         jVsPNPTdf1tm2CtwR1UFCG5zmyKOWSM3ZSGD0+Hq+VAHCJLq+3N9oKJiol41f2+We73u
         GbornskRAj3qUAFu/fsQg8FCiOodLvGnABSBelGARWoAJVxaK3ex8k2cGZv3OryGhzjF
         rIRhvRbZODudUooXZqlF4CqF9y0QcQFXX0yOdDUW7SS8+UbHhCPIPatcjsQ1yeDYpbIX
         yflQ==
X-Gm-Message-State: AAQBX9dbAFpJFulHlOaAjUcXoJ3/jPpIFJoy76zlhFVvJ6dlICK8TpR+
        RbiUKhmhD7tIbP+mLUv5TMY=
X-Google-Smtp-Source: AKy350Yh+6NbKPw4KD+UsFvenBCaCDaUcheuDcqPn53EST9vXg5qyuw0UcOKYiNkqaXz2dPOz64XMQ==
X-Received: by 2002:a17:902:f689:b0:1a6:f5d5:b80a with SMTP id l9-20020a170902f68900b001a6f5d5b80amr7744678plg.38.1681922038707;
        Wed, 19 Apr 2023 09:33:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id p10-20020a1709026b8a00b0019a6cce2060sm11631338plk.57.2023.04.19.09.33.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 09:33:58 -0700 (PDT)
Message-ID: <932bb2c6-71ce-525f-fbb2-a0a742ee8e12@gmail.com>
Date:   Wed, 19 Apr 2023 09:33:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/6] net: bcmasp: Add support for ASP2.0 Ethernet
 controller
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, linux@armlinux.org.uk, richardcochran@gmail.com,
        sumit.semwal@linaro.org, christian.koenig@amd.com
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-4-git-send-email-justinpopo6@gmail.com>
 <03dadae3-3a89-cdb0-7cd1-591d62735836@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <03dadae3-3a89-cdb0-7cd1-591d62735836@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/18/23 23:35, Heiner Kallweit wrote:
> On 19.04.2023 02:10, Justin Chen wrote:
>> Add support for the Broadcom ASP 2.0 Ethernet controller which is first
>> introduced with 72165. This controller features two distinct Ethernet
>> ports that can be independently operated.
>>
>> This patch supports:
[snip]
>> +	intf->tx_spb_index = spb_index;
>> +	intf->tx_spb_dma_valid = valid;
>> +	bcmasp_intf_tx_write(intf, intf->tx_spb_dma_valid);
>> +
>> +	if (tx_spb_ring_full(intf, MAX_SKB_FRAGS + 1))
>> +		netif_stop_queue(dev);
>> +
> 
> Here it may be better to use the new macros from include/net/netdev_queues.h.
> It seems your code (together with the related part in tx_poll) doesn't consider
> the queue restart case.
> In addition you should check whether using READ_ONCE()/WRITE_ONCE() is needed,
> e.g. in ring_full().

Thanks Heiner. Can you trim the parts you are not quoting otherwise one 
has to scroll all the way down to where you responded. Thanks!
-- 
Florian

