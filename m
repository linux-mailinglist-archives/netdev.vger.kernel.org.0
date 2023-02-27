Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7A6A4463
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjB0O3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjB0O3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:29:10 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF12AD304;
        Mon, 27 Feb 2023 06:29:08 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id ck15so26839337edb.0;
        Mon, 27 Feb 2023 06:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3owx8bm935W6dFgfi76X403PJDDk983z5ZT3LHH1Acw=;
        b=IJmZsh7fYD7T16wncmSllWFtkg8kJqqVSHOhmRRb5OcSnsLnAtAHSE2/qeXUGX8xdk
         tISARXjOjZypqmIb64hTDftc1PTiaSBzjiX7IDLENKao0z+q8hD9nIVwpflTZF3042sV
         ktNlgFg7hEprtUmKsQo9UTc51Pw7G216iGd3pxHLCbthIhBXLAQ4he2bGfJrfHLPoh14
         mZGx3ZqVp5VpQsdLR6jq+Fzq90IAna8KFRSSDmRRdltIosjYs7F3Vnb8qPaiARYJeAFL
         rpWyA7vH/8UwZuC9DLJok/NXICAmKGJMHwn/d5jALIU7LLgivEZRZQev7m8sq4xv7DCh
         zXuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3owx8bm935W6dFgfi76X403PJDDk983z5ZT3LHH1Acw=;
        b=eW7RuEsSY55XkwBFIW7dN1kKlL1yjfUgdO7JmOiKlJBVB6lE5KDigapNbpUr1wZslX
         ZCQsI8AN5ODTo2tC2zxXsRNGgV/G7mnr1XceuC+B2Ipjk8E76R2r2KihQwhZ8XWeAAxS
         WaK7ANYuKb49iAUb6tVkak1Rw2rD5mx89d7OihO1q0BAXRNsn4SEDhImSejmbcEi+wMj
         1dXt5sKSZ/7DMLHZBzr0CkTQICTJKKbo4/4hKFykPohQXqAAOeBj7wx8HYVc91dlksZg
         dkmN6B2coVDPll/MCNtWXTlEOhHip2Qnjk50O6KeKYxQNzMSvLI7BPX8g7DEMmQqib44
         5k2w==
X-Gm-Message-State: AO0yUKWUVbq1ZxfBfAwSGcHCH2cavn8pfm3mzjPsZ95W9Aci10OgPj6F
        PoKCfhl3mOLKlg25eumoHrCi3bb566nV0H8a9Mg=
X-Google-Smtp-Source: AK7set+0CkCmG9Ei5HQCw/IfAgBc87KenY2hXkZDhwv1TKtYAnJrh+LmG+gnLJZC6R3xgxWU0R0R0p5BHh5UHdH/V5M=
X-Received: by 2002:a17:906:195b:b0:889:dc4d:e637 with SMTP id
 b27-20020a170906195b00b00889dc4de637mr14651060eje.6.1677508147369; Mon, 27
 Feb 2023 06:29:07 -0800 (PST)
MIME-Version: 1.0
References: <Y/yxGMvBbMGiehC6@lore-desk> <20230227135241.947052-1-void0red@gmail.com>
 <Y/y5Asxw3T3m4jCw@lore-desk>
In-Reply-To: <Y/y5Asxw3T3m4jCw@lore-desk>
From:   Kang Chen <void0red@gmail.com>
Date:   Mon, 27 Feb 2023 22:28:55 +0800
Message-ID: <CANE+tVq=djTShowm1o86184c34QYEax0_4Ls=y0_qFL=wo+EsQ@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mt76: add a check of vzalloc in mt7615_coredump_work
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        lorenzo@kernel.org, matthias.bgg@gmail.com, nbd@nbd.name,
        netdev@vger.kernel.org, pabeni@redhat.com, ryder.lee@mediatek.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com
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

Hi, Lorenzo

Thanks for your suggestions.
I totally agree with you.

Best regards,
Kang Chen

On Mon, Feb 27, 2023 at 10:07=E2=80=AFPM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > From: Kang Chen <void0red@gmail.com>
> >
> > vzalloc may fails, dump might be null and will cause
> > illegal address access later.
> >
> > Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
> > Signed-off-by: Kang Chen <void0red@gmail.com>
> > ---
> > v2 -> v1: add Fixes tag
> >
> >  drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/=
net/wireless/mediatek/mt76/mt7615/mac.c
> > index a95602473..73d84c301 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> > @@ -2367,6 +2367,9 @@ void mt7615_coredump_work(struct work_struct *wor=
k)
> >       }
> >
> >       dump =3D vzalloc(MT76_CONNAC_COREDUMP_SZ);
> > +     if (!dump)
> > +             return;
> > +
> >       data =3D dump;
> >
> >       while (true) {
> > --
> > 2.34.1
> >
>
> revieweing the code I guess the right approach would be the one used in
> mt7921_coredump_work():
> - free pending skbs
> - not run dev_coredumpv()
>
> What do you think?
>
> Regards,
> Lorenzo
