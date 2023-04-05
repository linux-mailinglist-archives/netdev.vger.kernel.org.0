Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5FC6D8761
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjDETwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbjDETwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:52:14 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7CA7EC3;
        Wed,  5 Apr 2023 12:51:53 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b20so143897829edd.1;
        Wed, 05 Apr 2023 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680724311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4jmTZjX1X3FXg9H1sf4UQGBO5sXLFiiXCVY7aW+kHp8=;
        b=NjVCqpRAnFoEBZ48ogXGEW+4YfZqT5zxR0Pov6GzrC7aEWY7UPRmCspppFii6tQgko
         cYOhq/2uC1j2CHd96MggprggDrHTyihwzuZMMGMTul1HTJV7B2HMbOrZm0hPA3FOz3It
         TG7evng49bkGYf8FNi81zODWZpluQgUGSfhjOk05N0/7VyN8ig2i9QW1jji6Dnf9Pm2r
         JF6UpZ3kl8Qh+b7/6q8+jTlv5iF/RRDT53sSHXfjyheyUbb15YDsZ1UjoXuB7vVSeB+n
         B0z6T+WdereYMCMdYo2CeAfjRUj4cPYboYfNEb38i3e5yEl0HXIaGAh8k+ghaJ/raM+S
         RMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680724311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4jmTZjX1X3FXg9H1sf4UQGBO5sXLFiiXCVY7aW+kHp8=;
        b=AQGbQ1/AzH06y/+TeJGZpoonLfbhljlUcQaY0aA+J4SOL6ogq2LEI5XMJrNs7qYSHk
         u9IxUyCl7QGruztf0hJBLMOboTAki77UE/8X/W0WvKjdUuT1YTOoSqr9gvHZ1CrdIS1+
         KEAE301JXJn0cFHNpynqxfL9Arfo9eUZ3+HVKLUNb4ZAYoZdpTAHpRHNaTtAl1B3QkAO
         INTyewP3InzyXTuu7112CJis7e0/Jvq60vlVVpCAIh5OnVTrFn0qFl6QJ2GP4ecayldP
         UrNU4ovVeNIzvsmAJyQ6KHi+B1j9eTJXDuTxncRa0dsntXM1vpjTcwf8F0urNQOnHtgQ
         Fk1Q==
X-Gm-Message-State: AAQBX9fTiLXQp8dJSI+U+DCOgBdGBs5h/VtI8WlsUfEm4We+A2P8TDVQ
        W8+6tvrohjHaVPFG4eGcsaPkBzXKfhH7g2vKOLtLAJsF
X-Google-Smtp-Source: AKy350aArCCGAkSm5shKTMDLiqTFoeH+3CrxDyIaynshqyzBOjNchcKOmWgN9FetYNJgIBsi/zu28gfNbbIA9eAZ7m8=
X-Received: by 2002:a17:907:c80b:b0:8f5:2e0e:6def with SMTP id
 ub11-20020a170907c80b00b008f52e0e6defmr3032264ejc.0.1680724311314; Wed, 05
 Apr 2023 12:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230403202440.276757-1-martin.blumenstingl@googlemail.com>
 <20230403202440.276757-10-martin.blumenstingl@googlemail.com>
 <642c609d.050a0220.46d72.9a10@mx.google.com> <CADcbR4LMY3BF_aNZ-gAWsvYHnRjV=qgWW_qmJhH339L_NgmqUQ@mail.gmail.com>
 <CAFBinCC2fr42FiC_LqqMf2ASDA_vY1d-NJJLHOF6pW1MjFRAzw@mail.gmail.com> <642d8d76.ca0a0220.c2c2e.0f02@mx.google.com>
In-Reply-To: <642d8d76.ca0a0220.c2c2e.0f02@mx.google.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 5 Apr 2023 21:51:40 +0200
Message-ID: <CAFBinCAVSQjS9tzmLuN0xeEQacnb69Bh2CYaxqgMxXR1KtFD0g@mail.gmail.com>
Subject: Re: [PATCH v4 9/9] wifi: rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Chris Morgan <macroalpha82@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 5:02=E2=80=AFPM Chris Morgan <macroalpha82@gmail.com=
> wrote:
>
> On Tue, Apr 04, 2023 at 11:27:49PM +0200, Martin Blumenstingl wrote:
> > Hello Chris,
> >
> > On Tue, Apr 4, 2023 at 8:16=E2=80=AFPM Chris Morgan <macroalpha82@gmail=
.com> wrote:
> > >
> > > Please disregard. I was building against linux main not wireless-next=
.
> > > I have tested and it appears to be working well, even suspend works n=
ow.
> > Thanks for this update - this is great news!
> > It's good to hear that suspend is now also working fine for you.
> >
> > It would be awesome if I could get a Tested-by for this patch. This
> > works by replying to the patch with a line that consists of
> > "Tested-by: your name <your email address>". See [0] for an example.
>
> Sorry, bad manners on my part.
>
> Tested-by: Chris Morgan <macromorgan@hotmail.com>
awesome - thank you! I'll include that in v5
