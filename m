Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB4B50C009
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 20:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiDVSxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 14:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiDVSxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 14:53:32 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986191FC1E2;
        Fri, 22 Apr 2022 11:46:28 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id p21so9523789ioj.4;
        Fri, 22 Apr 2022 11:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VZJZWU/RxygMbphG0Oj9zjd06v34ardwpbG1ITBoIDw=;
        b=YZrWTzrqWk1rSABVylk7srJID3fDK9uMYJG42OPvae8wfCRKj7ksYtYZn7xN0yrP8i
         e41Zp35cubbwqYSgd29HYOnVMmbr5qt6fEZ8X/yNW7wvKE6Of2E2X84vq2sbLpm0v1ft
         7Yc10MU2AuvdmmQhwLN/afW/ybLHkuYWzff9R78t3w/+XyhG60uKEsY2w5UdcUX6Fu2J
         LMy2HV3lFWnIFWErseiwxIAg5WQVCIyoHpY/usBPF0WEoB6IZcWuDlIdWhOUBNbbC3U9
         o1RNHfw+J/BuziFmLiNgBRaa2DJDNESPnhnvUgumXYSBsoCUt6ByYC2DxaEy9zCJP3wE
         T5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VZJZWU/RxygMbphG0Oj9zjd06v34ardwpbG1ITBoIDw=;
        b=kHZH3WGNLzMYnQKcX8w+DjR3WAXSQpLinbGqW5w6I+rEOnh/ZT64SWJeh7jkE1ri7j
         /iwRNcrdmd97m71ku5XJFNqyrMxi6BVVW0jGxKaXVSnV2t/66ka04Vp2aLIlErHhVgnC
         +OGvv8fw17i7m7UnCgvFD+rYGoa0L5jQWh1QsUVIZKmhT+BvANvGQQcij+xy6Orper7K
         Hoaqy2IDoz/f2oXlF2a5CklBXkODa3cwecJP86EFBqxjZBptJ6DFmqGf2c8UORPPtNe0
         dUeTaKqxyUz+Z5fYw8btueZwrfZzPwxp0xeb5xwicVl13DuW/pb/jgOjet2PpmGBtzu5
         9sZQ==
X-Gm-Message-State: AOAM532BUKYCl2ZIoeMNB2cEkA9lRvdRRPihzegTQz15+rknz0Fo4eYD
        LjU777hxgeqezvjk64N+zI41Sghjp+I=
X-Google-Smtp-Source: ABdhPJzt8+ULZ4U/JS1QogjvrFZ9RPxY2qsOw5RmC0oJk1pCiWYhJttEH2fg8OhbQGWlcVH7Xy1Pxw==
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id b3-20020a6541c3000000b003635711e234mr5039062pgq.386.1650652113575;
        Fri, 22 Apr 2022 11:28:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm3593300pfl.70.2022.04.22.11.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 11:28:32 -0700 (PDT)
Message-ID: <68c4710d-013e-85e0-154d-413f4e13b27e@gmail.com>
Date:   Fri, 22 Apr 2022 11:28:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/5] net: dsa: add out-of-band tagging protocol
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
 <20220422180305.301882-3-maxime.chevallier@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220422180305.301882-3-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/22 11:03, Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
> 
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
> 
> This tagging protocol relies on a new set of fields in skb->shinfo to
> transmit the dsa tagging information to and from the MAC driver.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

First off, I am not a big fan of expanding skb::shared_info because it 
is sensitive to cache line sizes and is critical for performance at much 
higher speeds, I would expect Eric and Jakub to not be terribly happy 
about it.

The Broadcom systemport (bcmsysport.c) has a mode where it can extract 
the Broadcom tag and put it in front of the actual packet contents which 
appears to be very similar here. From there on, you can have two strategies:

- have the Ethernet controller mangle the packet contents such that the 
QCA tag is located in front of the actual Ethernet frame and create a 
new tagging protocol variant for QCA, similar to the TAG_BRCM versus 
TAG_BRCM_PREPEND

- provide the necessary information for the tagger to work using an out 
of band mechanism, which is what you have done, in which case, maybe you 
can use skb->cb[] instead of using skb::shared_info?
-- 
Florian
