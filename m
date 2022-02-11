Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB3AF4B231D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbiBKKaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:30:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiBKKae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:30:34 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B639E9E
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:30:33 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id bt13so23514490ybb.2
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mSVQKCIhtdDzzhobIcYFiml7D4wPdPGcvRbaNnU5CUs=;
        b=Bqvh4RO/O+jGZyQzdzLN8xDBdwadSnZneaVsfx4xCN+ov26Zr4IDrJb1o1xXyEnpCE
         E1kZGQBob8NHQ+agBh824itQCZgtd2fA/P3QnxITcyUgV84NIWWKpCs09Z3/jHHrzLqa
         sVhVu6IlcsDxgR81sbJUsNn1gdMxtsdefoUNdIQfIAYeu+icqzLaLoy49ah0812gxHzr
         TRmF6kj8aBOuOH6IG0qtSoEOZOI+J/PFczR9vQ6xvkU33JABS5zBPF+SCMzVeEYAaR2f
         NNZlfq4MkY5tE5HKWFc9cLO8fn3jEQVjZld3idol93bA9Cw4VEzaEdDRBNRfX5UrPjSp
         D3yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mSVQKCIhtdDzzhobIcYFiml7D4wPdPGcvRbaNnU5CUs=;
        b=ImBJZeooLndWc7kS5VXAV2o62nnP6lo0iSJ40WflwB1yGxKH1FLHJItRsdKhAHR0K2
         kgwpVSrK7wu+qdHxf/J93VNOuXnnopdMwo2Zz54bKg9SYMLCJDIfMm1e2UzQopB07ozX
         aLbcZQWKq/vT0PaQuvxgkJK/JLozUqc+W/42KFnrklNSYid38u6sAOq1zzCQSVMYfw0E
         uvSVhCDPBAvSlyFJqgtkIEcgr1gQ/b5GsJt35u03rxfPFPvRj8r50co3xU+Hgwgj4T/r
         qfv7cvBraimnkCfDkhqejkOrdasRjvV+UiPolACm1YqkWVQOyBTxortnV/1EdC2ebA2Y
         65Ig==
X-Gm-Message-State: AOAM531qf+VrYZ430sPn2+atiLchMbI+3qCbRabHcJzOLd8CCR5uDtJQ
        Zk2ng/KL5QvvtU0DSsYzbE0Z74ofrNfBRTQBdaqEkA==
X-Google-Smtp-Source: ABdhPJy+m38ezp3Uh3l1G7Uldezah39PdPEsCZYeiIqRSqodMOAGYzCr6GqLXU4uA1XFR9XeF5B2JGPkfnScZUq4Qzk=
X-Received: by 2002:a25:5143:: with SMTP id f64mr739038ybb.520.1644575432802;
 Fri, 11 Feb 2022 02:30:32 -0800 (PST)
MIME-Version: 1.0
References: <20220211051403.3952-1-luizluca@gmail.com> <87a6exwwxl.fsf@bang-olufsen.dk>
In-Reply-To: <87a6exwwxl.fsf@bang-olufsen.dk>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 11 Feb 2022 11:30:21 +0100
Message-ID: <CACRpkdbL5z50pTXcKqXwbNaYhW1_SvipBY4_nfzeOjAi8cW1Xw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: realtek-mdio: reset before setup
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 10:54 AM Alvin =C5=A0ipraga <ALSI@bang-olufsen.dk> =
wrote:
> Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> > +     if (priv->reset) {
>
> gpiod_set_value seems tolerant of a NULL gpio_desc pointer, but perhaps
> you would like to add the same if statement to realtek-smi so that it
> doesn't pretend to reset the chip when the reset GPIO is absent?

That is fine by me and you can keep my review tag if you also
add this.

Yours,
Linus Walleij
