Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785325933A8
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 18:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbiHOQ5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 12:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiHOQ5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 12:57:22 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F5A27171
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:57:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id d5so1807417wms.5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 09:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc;
        bh=Wz8FtmzVE71afdJyd32SYYvhTJFRBu1d+IAc4KxftWk=;
        b=g17K+aqFZ0uoqC3D3blRXZMYWuXb6OabLSt3MnixauJf3aARPiWFBH79e8V2xbJmBU
         lqXm4klL+6z210oRHBEKx4ObE+TUOzzasY1breZAnGUbLZ/gmd287rW1cu+UAMO6Xs2n
         bUMV+Y0LDDqLy4gKh46yjPkYyyf03PBT0vQlbYW4zNPfZHdzVPdVFdFuHzTzybDUVYzI
         S3l3/gokMu/2bZ9qkykjbpwrgKCuGfeQSSvI4cU7vqWrvDCpcWHd9QMXeLDLx91jNPNZ
         OHJuqn812L9eCO4VNO6JFC0IBTvG5zzYGdufyMkHp3BjCWhPkCzHPgfPNWUobfPhgjZX
         pZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc;
        bh=Wz8FtmzVE71afdJyd32SYYvhTJFRBu1d+IAc4KxftWk=;
        b=HG/rFb36rN3PQ0rwQ8Jofd6tVWSLQ8kO/AkhT7OoY4ZBx4XdZmhdkPKK+C7HkGdF3r
         Ed4Vu0b4yBCkmyQAGfvtC45Tf9M5FxioiYKaO9FfbTeCSjMeTXgNU2ik5Z3kaHA25E/B
         Yipff79K9+08RtY3y38Y2SEvdK4X8OG24SZN5FTOjcD+G2hGYF7ullnNqiV/bs/UTcqy
         RvYhcVVGFR/9L6Z3M6Wpv0o4EdgLrj7kF5S0m08RYUsSvTyhG6/HwR0XNC4Ght9OpKUx
         nJqrcDvqzk5klmiaTL2U6LphBymedgzf4zfIVp7RQerdRwLI41DNSqIHnfYkr8h6nq0A
         mxHA==
X-Gm-Message-State: ACgBeo2OtTCBf/D2G/6nkvzE0qu4FizOnDfx/JbKrWSyoJStEbFctISO
        k0BGxNM1xPUeuJxf1e05dH0NUA==
X-Google-Smtp-Source: AA6agR7Ue6fhORNGVE/KVn3dSe3y7+kAUbN1R8ytqPit2armINrfIOPt/XGSqL69zrvimtRhOw/BoQ==
X-Received: by 2002:a05:600c:1d12:b0:3a5:eb79:edc3 with SMTP id l18-20020a05600c1d1200b003a5eb79edc3mr4597797wms.136.1660582638858;
        Mon, 15 Aug 2022 09:57:18 -0700 (PDT)
Received: from localhost (217-149-171-129.nat.highway.telekom.at. [217.149.171.129])
        by smtp.gmail.com with ESMTPSA id p185-20020a1c29c2000000b003a4f1385f0asm10599483wmp.24.2022.08.15.09.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 09:57:18 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 15 Aug 2022 18:57:16 +0200
Message-Id: <CM6REZS9Z8AC.2KCR9N3EFLNQR@otso>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        "Kevin Hilman" <khilman@kernel.org>,
        "Ulf Hansson" <ulf.hansson@linaro.org>,
        "Pavel Machek" <pavel@ucw.cz>, "Len Brown" <len.brown@intel.com>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <naresh.kamboju@linaro.org>,
        <kernel-team@android.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 0/3] Bring back driver_deferred_probe_check_state()
 for now
From:   "Luca Weiss" <luca.weiss@fairphone.com>
To:     "Tony Lindgren" <tony@atomide.com>,
        "Saravana Kannan" <saravanak@google.com>
X-Mailer: aerc 0.11.0
References: <20220727185012.3255200-1-saravanak@google.com>
 <Yvonn9C/AFcRUefV@atomide.com>
In-Reply-To: <Yvonn9C/AFcRUefV@atomide.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon Aug 15, 2022 at 1:01 PM CEST, Tony Lindgren wrote:
> * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > More fixes/changes are needed before driver_deferred_probe_check_state(=
)
> > can be deleted. So, bring it back for now.
> >=20
> > Greg,
> >=20
> > Can we get this into 5.19? If not, it might not be worth picking up thi=
s
> > series. I could just do the other/more fixes in time for 5.20.
>
> Yes please pick this as fixes for v6.0-rc series, it fixes booting for
> me. I've replied with fixes tags for the two patches that were causing
> regressions for me.
>

Hi,

for me Patch 1+3 fix display probe on Qualcomm SM6350 (although display
for this SoC isn't upstream yet, there are lots of other SoCs with very
similar setup).

Probe for DPU silently fails, with CONFIG_DEBUG_DRIVER=3Dy we get this:

msm-mdss ae00000.mdss: __genpd_dev_pm_attach() failed to find PM domain: -2

While I'm not familiar with the specifics of fw_devlink, the dtsi has
power-domains =3D <&dispcc MDSS_GDSC> for this node but it doesn't pick
that up for some reason.

We can also see that a bit later dispcc finally probes.

Regards
Luca

> Regards,
>
> Tony
