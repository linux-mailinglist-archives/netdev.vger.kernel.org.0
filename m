Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C241A6C0271
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 15:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjCSOko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 10:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjCSOkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 10:40:43 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4528419117
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 07:40:42 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id i5-20020a05600c354500b003edd24054e0so934940wmq.4
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 07:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679236840;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IxCmM3SKdmbzm7J9LEtnkGUfFi3qL8vZjsjLD7+oUxc=;
        b=Q2gf8Z+cPtZw62XS+cw4iZPyi00q/V3aoV6dpvDhXAOPW6Wf/rPiCn8LVP0ZwqGAXU
         33DRkC/3oLtJMEKa1Ryevc39TWie59efmG104+1RzKYQ91PVu6C7xK1Ee+7yraz1UAWn
         +5qY9P0HwPipa2fTw3CICT1WJw63wa8Trbewt1yoSr3iuN38ziSlT20cVuL2qlabx4t0
         T9df5gRUclauvGHbHbFMprI0BrNqiRpBQu3/uTrNexEWTyM3SV85l/PI4rmcutzjWMQS
         OGFz617FW6XvkmZ2qUDuqLdzVxsSM2bcvu5DRd7tBuMLnWVgMlkuWaqs7hxpep/o7poi
         V+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679236840;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IxCmM3SKdmbzm7J9LEtnkGUfFi3qL8vZjsjLD7+oUxc=;
        b=zocW+LeFraelE+XpSOGCyLTpBABelD88T40EsSx6AJOov2OCUb/kOX+fxsrp3LHGDJ
         jq4n/NDPtJkD6u6lzTQaLVNH5bo74Fc6fyD19nQais+u4ELCi3fsZF4ntZtnY+JAHyEi
         vgMX9w1OqZnf4i9p/PfYkTv4j/nrUHkEkC7zKGgeT1AvZ7A8O+T1PPvf8J+4GTt2bAPE
         HoHoFZ/cCAJRyN/PAJlaA+uy5kLe9D8Px+2UWgKeLz7VqgtMVFwg3VacT85U+jUUeAZR
         TLCPIl4Kd/Or4r/Vttniv3bQIrWBiWkfBSjdhXIw302oV35gbSUUssN3AVvhIWDug8BB
         dTtw==
X-Gm-Message-State: AO0yUKW2KuGZUv+zYvKBTiw+rQvr6kAWosV2i26+P3V7G/ikbYR5HEWX
        YEgRdh0a6mP0bkFbFqQO0P6JJTy/RB8=
X-Google-Smtp-Source: AK7set/BbMenXivYXs2OiZ97X07b748SunIkNoFAgBzUYlEY3cIHAA7ud4C6HTdFW326+GbAzp4Esw==
X-Received: by 2002:a05:600c:c2:b0:3ed:a583:192a with SMTP id u2-20020a05600c00c200b003eda583192amr4527943wmm.9.1679236840420;
        Sun, 19 Mar 2023 07:40:40 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:e11f:5bbd:927b:2a7? ([2a02:168:6806:0:e11f:5bbd:927b:2a7])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c154900b003ede03e4369sm1615773wmg.33.2023.03.19.07.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 07:40:40 -0700 (PDT)
Message-ID: <973c3eb6017c4e6f9551c70b7268cf4b4b2a0324.camel@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix mdio bus' phy_mask
 member
From:   Klaus Kudielka <klaus.kudielka@gmail.com>
To:     Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun, 19 Mar 2023 15:40:39 +0100
In-Reply-To: <20230319140238.9470-1-kabel@kernel.org>
References: <20230319140238.9470-1-kabel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-03-19 at 15:02 +0100, Marek Beh=C3=BAn wrote:
> Commit 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing
> phys during probing") added non-trivial bus->phy_mask in
> mv88e6xxx_mdio_register() in order to avoid excessive mdio bus
> transactions during probing.
>=20
> But the mask is incorrect for switches with non-zero phy_base_addr (such
> as 88E6341).
>=20
> Fix this.
>=20
> Fixes: 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing p=
hys during probing")
> Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
> ---
> I was unable to test this now, so this change needs testing.

Thanks for spotting.
I can only test this on Turris Omnia with 88E6176.
All 5 ports Ok, phy probe time unchanged.

Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
