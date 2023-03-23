Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90BC6C6656
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjCWLRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCWLRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:17:07 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A981FD6;
        Thu, 23 Mar 2023 04:17:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id cn12so39176438edb.4;
        Thu, 23 Mar 2023 04:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679570224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J94DVvXLmoO7G1V2dC75KcwQU+CCpASOOrLHN/asfzI=;
        b=D9exNrXPQl1jkSyRsxOqwl6kzDdjYGg2xsdik1U29uV9SFeGSbTYI5OXisAwZTq6Hr
         EojOAw7Qu/9Bs5QOC2J8FN1znMUdRmemrfC2dDYfGzF/Nv/6P5fOnj4VoUXf38j8ACGc
         3g1+3K2O0YjFYqcn4+kKdCn7wmH/4rHGFxq/+uypsZMCXCXErDxG0vHkUaNrEFDeyoNw
         bF2ew0zQdpwIn69sqbtoJ7Ywgxy6I0hrPc6RkwoPmUrxaLA4Hteoo4uLEOQh0KdOIk1U
         dGcpoj0q3jnnAnH2aoQI75qg4ds1mnV2u8ajVJ9XxTF28+eXoDV3Rpps2ZjoHXyDicJz
         NLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679570224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J94DVvXLmoO7G1V2dC75KcwQU+CCpASOOrLHN/asfzI=;
        b=S3jEkK/3KwLwOoBkb6gqSbeo6N/qADLXselGDuh5lcIHkctuwMe8QFMJY+PJhsG8ri
         nFIwg5rif99x0PNtVa5+nO9SuEzJ93/odpjp8dATnsuWEbp1DbXEf0qhN+8ogE0uvNiW
         xbF2Ag22fcHPtbbpDUNZf0zRvVWdOztplu8ef7xU3rjeglf3lBzzDMrG9FB5flgv5Twm
         pe/VMCVlr6Gl9BC4LNR426rvO+1JlVwWlWTjZBtmVomXGU+hbPvYGAirjOCjA3BJZWj2
         VEmH0/I2MkirXZo8BVppjgHJ7iQ+KbYwOQrF3lMZJrnNPHhn5N7UIcFK5ehyumxzkEm3
         HYYQ==
X-Gm-Message-State: AO0yUKWlVqDPSro/cpg5rzf6Y5+WF3rHXK3ZBEMXW29hQFtdUpJmG1ze
        eGH+MlUZfBAy+Z9bO0UDsG3+qjnCDHrDUZfX599kzmX9Hkc=
X-Google-Smtp-Source: AK7set9BZ8J26v4kv8HvbwdVYtOZn5D9hzr2HiAEcH4KE7qc3pDKtLeMJeanzYlkTAwfF8GdOccsh8Xv1fTdkQg0MwQ=
X-Received: by 2002:a50:9e0d:0:b0:4fa:3c0b:73f with SMTP id
 z13-20020a509e0d000000b004fa3c0b073fmr5064566ede.4.1679570223810; Thu, 23 Mar
 2023 04:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230320213508.2358213-1-martin.blumenstingl@googlemail.com>
 <20230320213508.2358213-3-martin.blumenstingl@googlemail.com> <f7b9dda9d852456caffc3c0572f88947@realtek.com>
In-Reply-To: <f7b9dda9d852456caffc3c0572f88947@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 23 Mar 2023 12:16:52 +0100
Message-ID: <CAFBinCCspK=GaCMEiHsXi=0H4Sbp2vg_4EK=8bqQLWR8+qg7Sw@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO
 based chipsets
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
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
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

Hello Ping-Ke,

On Thu, Mar 23, 2023 at 3:23=E2=80=AFAM Ping-Ke Shih <pkshih@realtek.com> w=
rote:
[...]
> > +       if (direct) {
> > +               addr =3D rtw_sdio_to_bus_offset(rtwdev, addr);
> > +               val =3D rtw_sdio_readl(rtwdev, addr, &ret);
> > +       } else if (addr & 3) {
>
> else if (IS_ALIGNED(addr, 4) {
I'll add these IS_ALIGNED in v4
Also I found an issue with RTW_WCPU_11N devices where indirect read
works differently (those can't use
REG_SDIO_INDIRECT_REG_CFG/REG_SDIO_INDIRECT_REG_DATA but need to go
through the normal path with WLAN_IOREG_OFFSET instead). I'll also
include that fix in v4

[...]
> > +       ret =3D rtw_register_hw(rtwdev, hw);
> > +       if (ret) {
> > +               rtw_err(rtwdev, "failed to register hw");
> > +               goto err_destroy_txwq;
> > +       }
> > +
>
> Today, people reported there is race condition between register netdev an=
d NAPI
> in rtw89 driver. I wonder if there will be in register netdev and request=
 IRQ.
>
> You can add a msleep(10 * 100) here, and then do 'ifconfig up' and 'iw sc=
an'
> quickly right after SDIO probe to see if it can work well. Otherwise, swi=
tching
> the order of rtw_register_hw() and rtw_sdio_request_irq() could be a poss=
ible
> solution.
I tried with 1 second and 10 second delays here and could not find any prob=
lems.
That said, I am still going to swap the order because a) it seems to
be what most drivers do (ath9k for example) and b) SDIO is a slow bus
and especially slow on my Amlogic SM1 SoC which has some SDIO DMA
errata.
Also testing this made me find another bug during module unregister (I
thought I caught all of them by now) and will include this fix in v4
as well.


As always: thank you for all your inputs!

Best regards,
Martin
