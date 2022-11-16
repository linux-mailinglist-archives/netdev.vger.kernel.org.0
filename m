Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F262CEB1
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 00:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbiKPX1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 18:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiKPX1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 18:27:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A68467F75;
        Wed, 16 Nov 2022 15:27:49 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so3833138pjk.2;
        Wed, 16 Nov 2022 15:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2a/iI0oa5cBCopIhIhM2fR5QThEYXCGWU4iGbV6dAqI=;
        b=EZKH+Gu9u3UXBzi9tvk+O+r9JVp9dbm7tyYCio/+zbGH7qI1psI0x9mCiBM92AsnKS
         F4ex0F5TGUuBOmo4MU+6pITPFgGvoyus/aB+9HKZbOd6TKeX0GFpAGKlmWbHitBcsd5e
         5Yjr8xWu5XQTop928x9qN3McdahpGIaZOITaPDJvytuFh9sxk5X77/BYI5Hc04B9FHUR
         UMQeePeigqZGdhm4vasPvmd1tfXhes/NP+NakNnLEs2cqQqhYWdatQKVUkIvP6a5MnKV
         N23m20rDahzBvE76DJcLpsWWvqsMHSAClmZjZ1TasTAig5AfRh59v8J25P0J3z4N9fyl
         GrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2a/iI0oa5cBCopIhIhM2fR5QThEYXCGWU4iGbV6dAqI=;
        b=oDwjv/ul1S/6j61pguRiLr+uHg63o+HoYrwCaNJ1rQQ56/gCjEFJ4gK+KuGJnOVPFp
         tO+gvlE/4eFwHfTprcxu8+jXtEY0ug9ck419H8Hm7QeV9eWYK3KSpbQkhsZTfiCNSDr1
         dxtMp1PHJy2mh16M8XJOV67vegPanAZVPmQDRhOPWKJiC5SAS4ijau91cFowvcVgU+h6
         U4A6PAayzdki3Zf9/R/UUEC2bDT9Eil2Nzw6RlxBI1HX9OoTozMRKk7FhDKKpumBKdYQ
         ar/AU36eX1A9TIa6XW272WPyvEfZiZdqhT+ELK9/1oEKhm9mUvmjlK3SbEPCsu87Xwbb
         su+Q==
X-Gm-Message-State: ANoB5plO3vqXVMTg1u1xCJXU7BZZFbVtpLfCJw+jps78sm3CUDpYqG2Y
        FBu7ow5fNxv83HSs9Xl7YmA=
X-Google-Smtp-Source: AA0mqf7HqBsVW9+1F48OIURtAiK3KXCIie6/+wK2RJWPiYZeRBkSSdF0lpquCoWN2I5XTTdkdkB07Q==
X-Received: by 2002:a17:90a:4a85:b0:20a:dba9:ebe2 with SMTP id f5-20020a17090a4a8500b0020adba9ebe2mr6182701pjh.136.1668641268400;
        Wed, 16 Nov 2022 15:27:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c65-20020a621c44000000b005624e2e0508sm11323822pfc.207.2022.11.16.15.27.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 15:27:47 -0800 (PST)
Message-ID: <355a8611-b60e-1166-0f7b-87a194debd07@gmail.com>
Date:   Wed, 16 Nov 2022 15:27:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2] net: fec: Create device link between phy dev and mac
 dev
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Xiaolei Wang <xiaolei.wang@windriver.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221116144305.2317573-1-xiaolei.wang@windriver.com>
 <20221116144305.2317573-3-xiaolei.wang@windriver.com>
 <Y3T8wliAKdl/paS6@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Y3T8wliAKdl/paS6@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/22 07:07, Andrew Lunn wrote:
> On Wed, Nov 16, 2022 at 10:43:05PM +0800, Xiaolei Wang wrote:
>> On imx6sx, there are two fec interfaces, but the external
>> phys can only be configured by fec0 mii_bus. That means
>> the fec1 can't work independently, it only work when the
>> fec0 is active. It is alright in the normal boot since the
>> fec0 will be probed first. But then the fec0 maybe moved
>> behind of fec1 in the dpm_list due to various device link.

Humm, but if FEC1 depends upon its PHY to be available by the FEC0 MDIO 
bus provider, then surely we will need to make sure that FEC0's MDIO bus 
is always functional, and that includes surviving re-ordering as well as 
any sort of run-time power management that can occur.

>> So in system suspend and resume, we would get the following
>> warning when configuring the external phy of fec1 via the
>> fec0 mii_bus due to the inactive of fec0. In order to fix
>> this issue, we create a device link between phy dev and fec0.
>> This will make sure that fec0 is always active when fec1
>> is in active mode.

Still not clear to me how the proposed fix works, let alone how it does 
not leak device links since there is no device_link_del(), also you are 
going to be creating guaranteed regressions by putting that change in 
the PHY library.

It seems to me that you need to address a more fundamental issue within 
the FEC driver and how it registers its internal MDIO busses.

The device link between the PHY and MAC does have the MDIO bus in 
between as a device.

Have you verified your patch is still needed even with 
557d5dc83f6831b4e54d141e9b121850406f9a60 ("net: fec: use mac-managed PHY 
PM")?
-- 
Florian

