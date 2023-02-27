Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3126A3626
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 02:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjB0B1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 20:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjB0B1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 20:27:01 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA1B4F944;
        Sun, 26 Feb 2023 17:26:58 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id ec43so19548809edb.8;
        Sun, 26 Feb 2023 17:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHXURtJ6XWFKOSxnrF6y7AT9ts71qMylQ2e1Gr7C6LE=;
        b=ew9FQtWcS7t4Fc9bbKaL+T4vv5X6hAoYzUYtZAM9JPVzgqM8Lk7LS4jYIrQY3MxsXg
         o7buuoHhvQ1mEfEdWDslI8l/PNRuteIZEBq+SLpWB27N12Z1j9Y8DVW+tUG/L1yBTCce
         niypySvnuXAippaaamMTltj77zlpsNs2xldJyqynmGch0uEF4BEPRIHbB4fq2HNoik+k
         oAtVfGGdMKi4CREiBkDZ5WZk12LbOuNqrNyL0Z8WyzM+KLEOoawoAyhlgpR7LmVCJNxx
         YGmVjGnoeIu5XCDJlwsgfowinXCh5h1agFCo8Meh1jwnLwzPTGgH2QbvPXJh60v0Nt0U
         Xd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHXURtJ6XWFKOSxnrF6y7AT9ts71qMylQ2e1Gr7C6LE=;
        b=zZlkV6RXB1lTgQwhd6z4Pv2ZWpjZJ3UsJhunTlnd4JpG3MiGeGo2LiQahZnqKehplE
         VrJ/u4TCfLj2eMMKch5k1Agvw5Ryzpd6SXtR93uhOftiDvRd7gjVgq708yTFiFhY4YhQ
         BX1qOYQzPY7adovPeqzQQy9AfudQZ4NcnB4om3wsyy7zWYvAXnBXfdX29UmZRBBV6E9e
         58PssVZNVd0g+Kig2PKmXv4wQl3DlX6N9PUPuCZuXfwQfjDWGClNzFbgLnz8CNKGHXOa
         Qwwy5v8SoRfA3Em1UfJo51AdMkb196fUnY9cyc+Lh7cOK5t9qHMICMAsUL7K/Egmc+h2
         9OtA==
X-Gm-Message-State: AO0yUKXJy3LAPi8MXg22NhU+f/fzce9Fm6fpP3nyEO1g1E7J0Nl3hOgZ
        Ou7WT6R+adNI7y2kwNVLd0DiZvsXSr+sjam5cLISzfYcDPw/RwHi
X-Google-Smtp-Source: AK7set9nb9sahEv+ZjT/3uOgVmK2s7yoPcsQgaiKLv3msuWPVTK4wMz7HYJhDKDvlzU2d6aHl9jAUECemnf6qappIfI=
X-Received: by 2002:a17:907:2be6:b0:8b1:3cdf:29cd with SMTP id
 gv38-20020a1709072be600b008b13cdf29cdmr14033140ejc.6.1677461216996; Sun, 26
 Feb 2023 17:26:56 -0800 (PST)
MIME-Version: 1.0
References: <20230226095933.3286710-1-void0red@gmail.com> <Y/t729AIYjxuP6X6@corigine.com>
In-Reply-To: <Y/t729AIYjxuP6X6@corigine.com>
From:   Kang Chen <void0red@gmail.com>
Date:   Mon, 27 Feb 2023 09:26:45 +0800
Message-ID: <CANE+tVrFOev4GjjbM1=P4gPHJEqLvbMHJfYfVH_L6NVVDnu0DA@mail.gmail.com>
Subject: Re: [PATCH] nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
To:     Simon Horman <simon.horman@corigine.com>
Cc:     krzysztof.kozlowski@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Hi Simon,

I will update the patch later.
Thank you for your review.

On Sun, Feb 26, 2023 at 11:33=E2=80=AFPM Simon Horman <simon.horman@corigin=
e.com> wrote:
>
> On Sun, Feb 26, 2023 at 05:59:33PM +0800, Kang Chen wrote:
> > devm_kmalloc_array may fails, *fw_vsc_cfg might be null and cause
> > out-of-bounds write in device_property_read_u8_array later.
> >
> > Signed-off-by: Kang Chen <void0red@gmail.com>
>
> I'm not sure if this is a bug-fix (for stable).
> But if so, I think the following is the appropriate fixes tag.
>
> Fixes: a06347c04c13 ("NFC: Add Intel Fields Peak NFC solution driver")
>
> > ---
> >  drivers/nfc/fdp/i2c.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/nfc/fdp/i2c.c b/drivers/nfc/fdp/i2c.c
> > index 2d53e0f88..d95d20efa 100644
> > --- a/drivers/nfc/fdp/i2c.c
> > +++ b/drivers/nfc/fdp/i2c.c
> > @@ -247,6 +247,9 @@ static void fdp_nci_i2c_read_device_properties(stru=
ct device *dev,
> >                                          len, sizeof(**fw_vsc_cfg),
> >                                          GFP_KERNEL);
> >
> > +             if (!*fw_vsc_cfg)
> > +                     goto vsc_read_err;
>
> This leads to:
>
>         dev_dbg(dev, "FW vendor specific commands not present\n");
>
> Which seems a little misleading for this error condition.
>
> > +
> >               r =3D device_property_read_u8_array(dev, FDP_DP_FW_VSC_CF=
G_NAME,
> >                                                 *fw_vsc_cfg, len);
> >
> > --
> > 2.34.1
> >
