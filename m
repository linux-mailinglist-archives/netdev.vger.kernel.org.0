Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9947E6A1F35
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 17:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBXQBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 11:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBXQBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 11:01:24 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0368D305;
        Fri, 24 Feb 2023 08:01:01 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id d73so6778487iof.4;
        Fri, 24 Feb 2023 08:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=24SeSYQMuEBW/rMjuq7m2xf9oOdtGU4bOMH/EOR5RMM=;
        b=DSZTB2NU8s3meyG/2StSkJrrUI30HnUJcgtbd+4Vn8rYkDPNSaMZhX5fQwoGe3N7Bh
         wPXhWTdWD51fheCMWkUp4vIWVqL8DZliEo2LTuVFin8hKczdNwXJlaFJBj7WSJgUr0Ot
         TcZ1shCiBZ8Sw4vvVHH69ylthf+OozpZ2kVXcw8e9e3o91lWOmkiNvaDkIze33hVzYFE
         I19+sKwEbK/kAOVmYkp6gfXEahKPa4XTjB2HBVmGZDyMIZNcL2ElkP9MApTlOflTWA8+
         1MRiSXCICRKO2q7wd/93uKPQ7A2CF50yIMf8XK6hBQQr7xFv41DNq5OUsDPNkwl02/ku
         +ehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24SeSYQMuEBW/rMjuq7m2xf9oOdtGU4bOMH/EOR5RMM=;
        b=VGXVkaHhnEGTVCgpxZbYGFj5aR9Okvgh9GwXM/0t4EboJt+BPvliPCKFqtK9962H2T
         WJOsgPzfotgXeiN4B4+raIZOpaMZi9d4WizZQxyEz5kHvTVHFBEEWnKFTTyOkm2N/76q
         EoM8XS5VPtmppwKFdj+IKHemi+0vFhR6eGp4XjtWaYElcV3JyK77swKCmUU/SreVoLID
         otO736PESi/ITSIWSqD+ENu2fzZR+VtcjVwuSY/Obn0ZUu6m8U4v38S2v0Z9SSnCFrHx
         doboatmuYYRIP5gznDiTFwxaUBEYpQr+SC/VblgSQ8Ioqk1KtQ21jyCR3rFYs+sM6HZn
         tALQ==
X-Gm-Message-State: AO0yUKXgVVe5y48m4PhlZdxW7smfVaJpTV2Nqh3fLaYN5zWA9GAZ0KHT
        qZqfW1ZSTfEgUg9yW28iGeo=
X-Google-Smtp-Source: AK7set+mfd10UDgs4fKqzp8/U0ux4eBGCSMZN60VS9/2fLwNL1WYyotYyAoQrFqyf547U9bH7+wZWg==
X-Received: by 2002:a6b:fe10:0:b0:74c:a38e:b210 with SMTP id x16-20020a6bfe10000000b0074ca38eb210mr4359938ioh.2.1677254461044;
        Fri, 24 Feb 2023 08:01:01 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n9-20020a5e8c09000000b00740710c0a65sm3503872ioj.47.2023.02.24.08.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:01:00 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
Date:   Fri, 24 Feb 2023 08:00:57 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20230211074113.2782508-1-o.rempel@pengutronix.de>
 <20230211074113.2782508-7-o.rempel@pengutronix.de>
 <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
In-Reply-To: <20230224045340.GN19238@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/23 20:53, Oleksij Rempel wrote:
> Hallo Guenter,
> 
> On Thu, Feb 23, 2023 at 08:16:04PM -0800, Guenter Roeck wrote:
>> On Thu, Feb 23, 2023 at 07:55:55PM -0800, Guenter Roeck wrote:
>>> On Sat, Feb 11, 2023 at 08:41:10AM +0100, Oleksij Rempel wrote:
>>>> Migrate from genphy_config_eee_advert() to genphy_c45_write_eee_adv().
>>>>
>>>> It should work as before except write operation to the EEE adv registers
>>>> will be done only if some EEE abilities was detected.
>>>>
>>>> If some driver will have a regression, related driver should provide own
>>>> .get_features callback. See micrel.c:ksz9477_get_features() as example.
>>>>
>>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>>>
>>> This patch causes network interface failures with all my xtensa qemu
>>> emulations. Reverting it fixes the problem. Bisect log is attached
>>> for reference.
>>>
>>
>> Also affected are arm:cubieboard emulations, with same symptom.
>> arm:bletchley-bmc emulations crash. In both cases, reverting this patch
>> fixes the problem.
> 
> Please test this fixes:
> https://lore.kernel.org/all/167715661799.11159.2057121677394149658.git-patchwork-notify@kernel.org/
> 

Applied and tested

77c39beb5efa (HEAD -> master) net: phy: c45: genphy_c45_ethtool_set_eee: validate EEE link modes
068a35a8d62c net: phy: do not force EEE support
66d358a5fac6 net: phy: c45: add genphy_c45_an_config_eee_aneg() function
ecea1bf8b04c net: phy: c45: use "supported_eee" instead of supported for access validation

on top of

d2980d8d8265 (upstream/master, origin/master, origin/HEAD, local/master) Merge tag 'mm-nonmm-stable-2023-02-20-15-29' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

No change for xtensa and arm:cubieboard; network interfaces still fail.
On the plus side, the failures with arm:bletchley-bmc (warnings, crash)
are longer seen.

Guenter

