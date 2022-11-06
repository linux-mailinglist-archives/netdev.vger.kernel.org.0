Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C217F61E53B
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 19:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiKFSLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 13:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiKFSLa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 13:11:30 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D53BC97
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 10:11:29 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso5946596wmp.5
        for <netdev@vger.kernel.org>; Sun, 06 Nov 2022 10:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=KSBPn3oI6xt0u/BUCpHO84zZIwAmzzWu63Et5EvxoDk=;
        b=T6tQ5BMoeoe07Qktjq37h3SagOyx+58g5A8TcTF/CwuI1eJiohIJDMaVrLUn1DgCps
         yGFpPDtQ4uZ8SeFW42q0vRx7dQw0UN0MGM2OAbxf+6n5Q/faZOSp76ifaetH+/wiQZQw
         U+aN9EDMhes0ureTGhBBsgJXfpPToV+o/V2rpIvhOUbyEM42DD53zXc4E4LS8RA2yBnC
         FcFtJ/ntKT4T0Mo6DZyESanlPGuBFLicH1Kimq+NCGq7afD25xdZpb5j2orkgS2qSKBq
         GOdCvw3vKMKqEhR4v3YdLZckSHGlaya0+sjKxfhm0EU57PHGFNu5FPwfaYupvNXl3G5c
         Z+OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KSBPn3oI6xt0u/BUCpHO84zZIwAmzzWu63Et5EvxoDk=;
        b=bgalL6+ojN2TF1KAi2dEay3d0IiCfbbOEaHO7hu4eoKgqIlNwsTg8k3e8bnyGy7JhZ
         QTeGHsHvpQo2nQlpn3nyUVPZn9moGgJZX08dVa3mVd507pYqh5sjCgRbsOGDWNoYt0fM
         EIHprNUSxCHX9OkDGAw+9GoQGXb9JFAF5LyxpYCU8JWFRfHcfbn19EEAahqPFj1fq0FS
         +0nfdbVTAN0A0bso+YholArVzIM2vQj3khRNazo9aV3j3ADp10Ur+gkTiCj8DfFxKpqZ
         Efv2X+5mbBcfUKdBlWkzD4NbKwMAx/E6zkROU5yU7Its4aEH6MSQDUF+PaY+kV0VesJW
         A7YQ==
X-Gm-Message-State: ANoB5pkWJrf2sVs9nuGNwAyFtjweikTwihlM1t+pvlGQW30yjudNBC9I
        oPfNzTJYM8R0Sj4zoRWrh2Rn4JdJARFlMw==
X-Google-Smtp-Source: AA0mqf4rmCMyQrvLNcd7/F1ObtF1V48DG4ey8MbXQCEk2oovBbVIPYAodVpueevp5RSkeJrDjQc42Q==
X-Received: by 2002:a05:600c:43c4:b0:3cf:a4f3:e00d with SMTP id f4-20020a05600c43c400b003cfa4f3e00dmr3420798wmn.162.1667758287925;
        Sun, 06 Nov 2022 10:11:27 -0800 (PST)
Received: from zbpt9gl1 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id q12-20020a5d61cc000000b002238ea5750csm6147684wrv.72.2022.11.06.10.11.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Nov 2022 10:11:27 -0800 (PST)
From:   <piergiorgio.beruto@gmail.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>
References: <026701d8f13d$ef0c2800$cd247800$@gmail.com> <Y2fp9Eqe9icT/7DE@lunn.ch>
In-Reply-To: <Y2fp9Eqe9icT/7DE@lunn.ch>
Subject: RE: Adding IEEE802.3cg Clause 148 PLCA support to Linux
Date:   Sun, 6 Nov 2022 19:11:32 +0100
Message-ID: <000001d8f20b$33f0f0e0$9bd2d2a0$@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIkukaByH4maS1tffwWlBx1lV4jaQFV2uSArY/wrCA=
Content-Language: en-us
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I suggest you define new ethtool netlink messages. I don't think PHY =
tunables would make a good interface, since you have > multiple values =
which need configuring, and you also have some status information.

That sounds fair to me, thanks for your advice.

> So you probably want a message to set the configuration, and another =
to get the current configuration. For the set, you=20
> probably want an attribute per configuration value, and allow a subset =
of attributes to be included in the message. The get=20
> configuration should by default return all the attributes, but not =
enforce this, since some vendor will implement it wrong=20
> and miss something out.

Yes, that sounds about right. If you have any hint on where in the code =
to start looking at, I'll start from there.

> The get status message should return the PST value. This is something =
you might also want to append to the linkstate=20
> message, next to the SQI values.

Sure.

> What I don't see in the Open Alliance spec is anything about =
interrupts. It would be interesting to see if any vendor triggers=20
> an interrupt when PST changes. A PHY which has this should probably =
send a linkstate message to userspace reporting the=20
> state change. For PHYs without interrupts, phylib will poll the =
read_status method once per second. You probably want to=20
> check the PST bit during that poll. If EN is true, but PST is false, =
is the link considered down?

This is actually an interesting point. First of all, yes, vendors do =
have IRQs for the PST. At least, the products I'm working on do, =
including the already released NCN26010.

My thinking is that the PST should be taken into account to evaluate the =
status of the link. On a multi-drop network with no autoneg and no link =
training the link status would not make much sense anyway, just like the =
connected status of an UDP socket wouldn't make sense.

My thinking is that we should enable the PHY drivers to report a link =
status evaluating PST as well.

> I would also include a check in the phylib core. If the set request =
tries to set EN to true, check the current link mode and if it
> is not half duplex return -EINVAL. An extack messages would be good =
here as well.

Yes, that makes sense.

> For the interface between phylib and the PHY driver, you should =
probably add to the struct phy_driver a set configuration=20
> method, a get configuration method, and maybe a get status method. You =
can provide implementations for these methods=20
> in phy-c45.c which any PHY driver which conforms to the standard can =
use.

Roger, thanks for the hint!

Piergiorgio

