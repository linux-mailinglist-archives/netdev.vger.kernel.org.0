Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C67C649974
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 08:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiLLHUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 02:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiLLHUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 02:20:11 -0500
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5DFB1C1;
        Sun, 11 Dec 2022 23:20:08 -0800 (PST)
Received: by mail-vs1-xe2f.google.com with SMTP id a66so1775516vsa.6;
        Sun, 11 Dec 2022 23:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6pEpoRmE1J0rcy6KXJBpJmGiPCXJTOQYInEfKuHgFg=;
        b=j/7qqzGE/fkep4jyatGZkxq9W3Bdj+qT3toLeHu/rgb6vfpfeZgGOlmJBzVU+gIOYf
         VJmwtx/wby4JD32dGdmay/St2F+k6Szf2Oc6c09B/X3McsB0y9b/1onyrryexYFppBG6
         2AFPTgUchRTTZbQkfw/vOy5NTLodhF/HdrLierEsQB7O17Dd7i7xg+l/p7VrQDRxRTk9
         KHWKgVo9HqQhsgd51q4JnT+50S540zkfdi2h3eOZR/JaQd5JLPW1QgCeFb7+Nk5DveVg
         o4JZq/QtudmyGGzO+mRHFpXRRhiY3w6sB6o3hmkNPB59gi1mjG0jL2oXIE7489iwcYQS
         GxSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6pEpoRmE1J0rcy6KXJBpJmGiPCXJTOQYInEfKuHgFg=;
        b=tDOXpuw5xmQib8+cW/2L5diVRS1pzoRQi5KQGmSxHYWDhyegmW5nMG5aN/24OwoL8T
         cFly9XG0SWuoNe+CXEFdxCUMevMTU5Nv5PdfQPazCvsX1JCLDedmn4AS9k+IYLsG+UXV
         jRzco9mUlZHjdzRw2ht2LSwr/U+7iqGPhpz9wVaa2tz8CXHIoixm44w4176Zve68YCRw
         ytYuYFuMP13N+xaHa26PC9vYE4RwBoxnYj0WfbOZy8SG4SEcihwG4+bcXdDsHSMpcIqw
         CWOpadSKQtoB+eY50UHsMUvwAlnlSjWfmB3QAJLSsoutXPd43GBFaJC/vWCUMKztULpM
         H/xw==
X-Gm-Message-State: ANoB5plNe05xIkQro2WcoonbQ4sYT405+OlsgCsrJnlAyApegnL/c9rp
        tDqbjH9bldSvMSzEj0dKEAfz61Uz8OOdVp8w4XFsAoglUlfGzQw+
X-Google-Smtp-Source: AA0mqf7vig656jN9kSCxRjAUvSo15BsH3iZKdQpCKKSVHOgz6G9XAUC17hK7B1lnKkqksTK+xpywQjQ+5b4/QQXFEwg=
X-Received: by 2002:a67:fb59:0:b0:3b2:f408:e31d with SMTP id
 e25-20020a67fb59000000b003b2f408e31dmr5835913vsr.0.1670829607226; Sun, 11 Dec
 2022 23:20:07 -0800 (PST)
MIME-Version: 1.0
References: <20221211144722.754398-1-tegongkang@gmail.com> <f04435d8-9af3-1fde-c2bf-fadd045b10a1@gmail.com>
In-Reply-To: <f04435d8-9af3-1fde-c2bf-fadd045b10a1@gmail.com>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Mon, 12 Dec 2022 16:19:56 +0900
Message-ID: <CA+uqrQBfS4J7r==za_82ddErGXVK+smJaMjbhPq6DByDWYyC-g@mail.gmail.com>
Subject: Re: [PATCH] net: ipa: Remove redundant dev_err()
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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

2022=EB=85=84 12=EC=9B=94 12=EC=9D=BC (=EC=9B=94) =EC=98=A4=EC=A0=84 1:34, =
Heiner Kallweit <hkallweit1@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1=
:
>
> On 11.12.2022 15:47, Kang Minchul wrote:
> > Function dev_err() is redundant because platform_get_irq_byname()
> > already prints an error.
> >
> > Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> > ---
> >  drivers/net/ipa/gsi.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> > index 55226b264e3c..585cfd3f9ec0 100644
> > --- a/drivers/net/ipa/gsi.c
> > +++ b/drivers/net/ipa/gsi.c
> > @@ -1967,11 +1967,8 @@ int gsi_init(struct gsi *gsi, struct platform_de=
vice *pdev, bool prefetch,
> >
> >       /* Get the GSI IRQ and request for it to wake the system */
> >       ret =3D platform_get_irq_byname(pdev, "gsi");
> > -     if (ret <=3D 0) {
> > -             dev_err(gsi->dev,
> > -                     "DT error %d getting \"gsi\" IRQ property\n", ret=
);
> > +     if (ret <=3D 0)
>
> According to the function description it can't return 0.
> You can further simplify the code.
> And you patch should be annotated net-next.

Thanks for your feedback!
I just amended and sent v2.

Regards,
Kang Minchul
