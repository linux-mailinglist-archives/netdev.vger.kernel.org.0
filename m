Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762B86BECF1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjCQPa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjCQPaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:30:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523FE9AFFC;
        Fri, 17 Mar 2023 08:30:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id ce7so3332553pfb.9;
        Fri, 17 Mar 2023 08:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679067009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ikL8pf0qWdeF+ZcYar80Mo2WrWWeMp1sI3VO/0rkppQ=;
        b=YgeRen+2rkm5XNEj+eG0hmzSlGmzjP1XwikH46gZ7AtZZZbRJoegLSRK34MP8QJOcs
         gQUr4GqI3l7degc0UN61Yybifo9RYs5Y8UZg8Fol96QB6SkcFl2BvBDdVIHWO43ylj4T
         QRQtNDAZD5TOTUtkuImmmTXK9vzniOswdqHIVoTKMoeCypKkspE73RfL3bNez1w+sNLt
         QqcRF3wgVVKfNb6tDJAOFx04gCZ+sZv1OIEt6ArvncXTaVh3IgAr8tOxZ7j2ivDI3Mgl
         xZ2MCfPwbC5Cg49HXXf2QQZJYBqbS+C9jaoSmODaB+KSXc/9r4WRthWZiAgxWzgW/XrH
         tVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679067009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ikL8pf0qWdeF+ZcYar80Mo2WrWWeMp1sI3VO/0rkppQ=;
        b=Xybo40Ck0kL0PP2ozD6abYTZF2M1+XUVzqu1B03HRfpnCPElT6oqFMI75Y1ecc26sU
         h7e4ZJGebkZwgirzyOcqRLcynF7hO6luCj16JWcqFBtsy1ZiotJONON0gB/4YSOwfNXg
         O2NETDyLUkPWvrKq4xfVBrtcRCcfJObpCm2M29iUSWSwTWyOOlCOoioV4a/Q1SmhDhof
         i+1kBIeX8iEW4a50A73yxOpl1HdCmdMAZr4viQZUf5OXs712A2gma6xi/ceu5c2Q8Mg+
         A37w7fm/jCZ6bggGXdeAnKrlQtYl/C1fOkJZxwekKZhHYjwXaLNw0g1EECSajleA1/0g
         4svQ==
X-Gm-Message-State: AO0yUKWFT82eNsWcDgEsyeG84pyW5hpPBsnc6V8aggjOdN+mOjdbLDiP
        VEpYHRAOa9NQdAuqjeFgfxvvaw9iCnlT/1na1Lk=
X-Google-Smtp-Source: AK7set8x1paacse0JRs1YZkmbzZozCuO14qbPAhGmT/bbws/Hsv0pREy29Sz8cyPv87Saa0ofd6sHlnXayvLPuTuuyg=
X-Received: by 2002:a05:6a00:2da2:b0:622:b78d:f393 with SMTP id
 fb34-20020a056a002da200b00622b78df393mr3539592pfb.2.1679067008762; Fri, 17
 Mar 2023 08:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230317143042.291260-1-mmyangfl@gmail.com> <d5ec2ec2-65a0-6ad3-a0a3-cad57d7f6616@gmail.com>
In-Reply-To: <d5ec2ec2-65a0-6ad3-a0a3-cad57d7f6616@gmail.com>
From:   Yangfl <mmyangfl@gmail.com>
Date:   Fri, 17 Mar 2023 23:29:32 +0800
Message-ID: <CAAXyoMNhG_4vYxxrHHHLHoSseCRGuEJPhRCOKXVv_LFrFXnyRw@mail.gmail.com>
Subject: Re: [PATCH] net: phy: hisi-festa: Add support for HiSilicon Festa PHYs
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> =E4=BA=8E2023=E5=B9=B43=E6=9C=8817=
=E6=97=A5=E5=91=A8=E4=BA=94 22:59=E5=86=99=E9=81=93=EF=BC=9A
>
> On 17.03.2023 15:30, David Yang wrote:
> > HiSilicon Festa PHYs were used on some HiSilicon SoCs. This patch injec=
ts
> > firmwares found on vendor kernels.
> >
> What's the status of adding the firmware files to linux-firmware?
> I don't see any related patch in the linux-firmware mailing list archive.
>
> Any info on purpose of firmware? Does the PHY work normally also
> w/o firmware? Or is the firmware required?

I don't know if this patch is feasible; if yes, I will post files to
linux-firmware.

The firmware is optional; vendor kernel source simply said "improve
performance".
