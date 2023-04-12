Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA886E01B5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDLWMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDLWMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:12:32 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619205FCF
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:12:31 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id i3so3026295wrc.4
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681337550; x=1683929550;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=essKQuXxDtieCxQDtmYipHzoK04lYrEVzCkZ/EhuZBU=;
        b=dPQL+9PKv0qBIINTIQDi2gTgA8SMTU8AH0rP2uuqRU64MDISeHuNYpY+ozTtGDiOuv
         hSYmaRi8eDg/0/uMpafL9+pRn8KGeYmfNhmUZQ/IICSrXqyVSBGcVs6epsxDYgZQ0bvW
         /L5Fle9tf94inf07tcqWAmBQ7BksuBrutZUnmiPAz4ELW2zlZmLaOmy6k9NGnaKLbzqU
         mDJJ6Abq3WXOCtjOA05evUv2jwKEU8dPm4J2uKLX2eTwvCLur3n5fyWWBSILhYYDUSN2
         7DDT1DHrd6ukXHPFYjauVp/oFaa2xgjuFiBT7+PADSt9G4Yk5lXWpX1fcvTqGlWcP57e
         +lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681337550; x=1683929550;
        h=content-transfer-encoding:in-reply-to:subject:from:references:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=essKQuXxDtieCxQDtmYipHzoK04lYrEVzCkZ/EhuZBU=;
        b=FBUnRTwc7f61sbirrRTRojdTQxb7Dptx0xi06OZK3AcMEpp7GmUZL4b8WIt/82w0KK
         7dnv4LFuHaIBcXcVZrHACzx7iEy6A98Kxzs+M74fBdd/Oi7Jc/Mdgk9DL6XMQaz4Zrb4
         gpk1Pl+EmvJKwCKpps3V4KLl3sQYSk6JZymh+TCY6ZyyLfXehp++lsn9S6UCKFxcFVrk
         cs9W9+rA5VkLRvOiPzrbkhL78T+/ugZkivziZtkASU2SJMZwzFJ7g8uvxwS+KyOd+bWg
         7DAlG9f622Fvv3VpxGRYZWSd2IYUKgBAgxyK3gjsvE5kJZYpI4zr2G2hLjxwS7Bw5q+q
         wFxg==
X-Gm-Message-State: AAQBX9fS8EZXGArCLoKYP53fMjSuA7YhRKcna6T24Y/EnfYkP44Z5R3a
        nMXI/bsSNowa4j7tL7Q3Sla0RFp2IE4=
X-Google-Smtp-Source: AKy350ZmF+kqSpA9zmTsur2fIYiEXOInzDhXKcH6ypfXsieLPsEqD8xgP9McAMJ9t/xsh1kgFsZmkA==
X-Received: by 2002:a5d:5001:0:b0:2f5:6fb1:c8e5 with SMTP id e1-20020a5d5001000000b002f56fb1c8e5mr562931wrt.25.1681337549758;
        Wed, 12 Apr 2023 15:12:29 -0700 (PDT)
Received: from ?IPV6:2a02:3100:903d:3d00:b0e7:6bd7:f613:784b? (dynamic-2a02-3100-903d-3d00-b0e7-6bd7-f613-784b.310.pool.telefonica.de. [2a02:3100:903d:3d00:b0e7:6bd7:f613:784b])
        by smtp.googlemail.com with ESMTPSA id n11-20020adfe34b000000b002e5f3d81c06sm18188281wrj.89.2023.04.12.15.12.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 15:12:29 -0700 (PDT)
Message-ID: <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
Date:   Thu, 13 Apr 2023 00:12:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Content-Language: en-US
To:     Ron Eggler <ron.eggler@mistywest.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: issues to bring up two VSC8531 PHYs
In-Reply-To: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.2023 22:11, Ron Eggler wrote:
> Hi,
> I am trying to bring up a pair of VSC9531 PHYs on an embedded system. I'm using a Yocto build and have altered the device tree with the following patch:
> https://github.com/MistySOM/meta-mistysom/blob/phy-enable/recipes-kernel/linux/smarc-rzg2l/0001-add-vsc8531-userspace-dts.patch
> I installed mdio-tools and can see the interfaces like:
> # mdio
> 11c20000.ethernet-ffffffff
> 11c30000.ethernet-ffffffff
> 
> Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
> # mdio 11c20000.ethernet-ffffffff
>  DEV      PHY-ID  LINK
> 0x00  0x00070572  up
> 
AFAICS there's no PHY driver yet for this model. The generic driver may or may not work.
Best add a PHY driver.

> Yet, ifconfig doesn't show the interfaces and I get:
> # ifconfig eth0 up
> [  140.542939] ravb 11c20000.ethernet eth0: failed to connect PHY
> SIOCSIFFLAGS: No such file or directory
> When I try to bring it up
> 
> # ip l displays the interfaces as:
> 4: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 9a:ab:83:16:65:36 brd ff:ff:ff:ff:ff:ff
> 5: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether 2a:9d:bf:09:8d:c3 brd ff:ff:ff:ff:ff:ff
> 
> Where am I going from here? I have experimented with drilling down into bitwise analysis of the MDIO communications. I'm uncertain though if this is my best bet, does someone here have any insight and can provide me with some guidance?
> 
Any specific reason why you set the compatible to ethernet-phy-ieee802.3-c45 for a c22 PHY?

> Thanks a lot!

It would be advisable to include the phylib maintainers when asking phylib-related questions.

