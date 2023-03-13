Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE546B8268
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjCMUMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCMUMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:12:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D77187D81;
        Mon, 13 Mar 2023 13:11:56 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id x3so53498070edb.10;
        Mon, 13 Mar 2023 13:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1678738314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhNghR12Doc7EYuGR8r4Vteb6OOTNo1fI6PKH8ZpZK0=;
        b=gonHkX7Yhe72Ie531l/HxB0Vd26zSeA4TGU3AoW1HEATK5jseXU3RGul1Z4oo9/X4A
         oIv3rd6pQsJokXef2rVXAuZxYO8LYsK1khitF++SayAlYXbbenAMkWQa5hCtwCXV5b1e
         FBBZpQlwljguIskB3xiapTEz5F56IZkqFTRAIxQKzFJeh8fnWZjnhm2WnE3UsnQ2cX+1
         3vs5Wy7UhfYnEYgoNMJYBVbp6BIxKuvnlBoFR73+rr9IkPYfyMLG+BFDqcePvl6LDM1F
         Yoe1ik1yZyj0GADpi0bnnSI0n+0ZZVtVTrE8KwjpD/bhRdgdTZ9KjZmTqzt3WAAu1F5j
         KNUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738314;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IhNghR12Doc7EYuGR8r4Vteb6OOTNo1fI6PKH8ZpZK0=;
        b=8HGGtD4rWnWnkewLZUte/zB8bW9wMuiFVyn/Xn4+TqEl+bi99kordV8Fsda05e5aOJ
         oeCl2cjErh72YwB344ZOhha7wgm6UljsuxFT0mjF6wuQHed9XTo4Ml8GhR5GCZB1aHB/
         ImADtk8Ulo+W54fMQTWj0j4Pa3Q+dhWY7hMjEME2gYv/5shczKoF1LXB1Fv4qz/fnEPz
         tKB0sQThpaZn2s179lu/Ug9zT9NdIEih0w+gY53TarH65fPZt9qas8X+ezcIRuzLysLn
         OBLqB9HroDmgSFVf37gDeb+admzlNUAkwJ9AYjW4PMJ3802SeXbWuceGv0MF6Ux92gVk
         px8g==
X-Gm-Message-State: AO0yUKWOd5eC/JJ8PvC5QaPldaD3HpTrP9+jUUiX5TkhxATRnoF8lRRE
        9/Fmv9RbB4SlRcQ5kkUXARah34rxAwZTo5D/iFg=
X-Google-Smtp-Source: AK7set/DTcyZfjovezCMaS0m/zslIPL2EYyyypZPlsR45JWZYAH35nG/3f4bbTQcodJEiI2AwpZZ5m7541l8Pwgw8O4=
X-Received: by 2002:a50:9f04:0:b0:4fa:3c0b:73f with SMTP id
 b4-20020a509f04000000b004fa3c0b073fmr4720292edf.4.1678738314232; Mon, 13 Mar
 2023 13:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-4-martin.blumenstingl@googlemail.com> <7330960d32664bf0bce8446aa93d10c8@realtek.com>
In-Reply-To: <7330960d32664bf0bce8446aa93d10c8@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 13 Mar 2023 21:11:43 +0100
Message-ID: <CAFBinCA-OHPbwdxdDe50og787LMSnbPhYbsRL6UzQUhxWgxWbQ@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 3/9] wifi: rtw88: mac: Support SDIO specific bits
 in the power on sequence
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
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

Hello Ping-Ke,

On Mon, Mar 13, 2023 at 10:05=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> =
wrote:
[...]
> >         pwr_seq =3D pwr_on ? chip->pwr_on_seq : chip->pwr_off_seq;
> >         ret =3D rtw_pwr_seq_parser(rtwdev, pwr_seq);
> > -       if (ret)
> > -               return ret;
> > +
> > +       if (rtw_hci_type(rtwdev) =3D=3D RTW_HCI_TYPE_SDIO)
> > +               rtw_write32(rtwdev, REG_SDIO_HIMR, imr);
> >
> >         if (pwr_on)
> >                 set_bit(RTW_FLAG_POWERON, rtwdev->flags);
>
> If failed to power on, it still set RTW_FLAG_POWERON. Is it reasonable?
That sounds very reasonable to me!

> Did you meet real problem here?
>
> Maybe, here can be
>
>          if (pwr_on && !ret)
>                  set_bit(RTW_FLAG_POWERON, rtwdev->flags);
I can't remember any issue that I've seen. I'll verify this at the end
of the week (until then I am pretty busy with my daytime job) and then
go with your suggestion.
Thanks again as always - your feedback is really appreciated!

Also thank you for commenting on the other patches. I'll take a closer
look at your feedback at the end of the week and send another version
of this series.


Best regards,
Martin
