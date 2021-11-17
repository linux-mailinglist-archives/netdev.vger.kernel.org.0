Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF168454223
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 08:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbhKQHzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 02:55:08 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:58779 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbhKQHzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 02:55:07 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MYNW8-1n9oxW1yV8-00VPkY; Wed, 17 Nov 2021 08:52:08 +0100
Received: by mail-wr1-f48.google.com with SMTP id b12so2842829wrh.4;
        Tue, 16 Nov 2021 23:52:08 -0800 (PST)
X-Gm-Message-State: AOAM533hqx0xaEglkXOUTHf4G8VOJF/v4cv1KY6Y9zj9ANVjKxATSVPs
        6lu4zKCbANlFH5hkKq6DZaqllUCVKYJTqTo968o=
X-Google-Smtp-Source: ABdhPJxSEhmOEG2At2Qpv9ehXJ2gMv9z+ztXEndPhKnCn0xjFqNoJBfrRBZgU9Q5Vu+jTIatGNY4B54vHi0fnKoOTHQ=
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr17725726wrd.369.1637135528065;
 Tue, 16 Nov 2021 23:52:08 -0800 (PST)
MIME-Version: 1.0
References: <20211117033738.28734-1-starmiku1207184332@gmail.com>
In-Reply-To: <20211117033738.28734-1-starmiku1207184332@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 17 Nov 2021 08:51:52 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2b9F5E8EEK4cBWpmK7X463GSYj3VBPqOz_jEu_Mad-Nw@mail.gmail.com>
Message-ID: <CAK8P3a2b9F5E8EEK4cBWpmK7X463GSYj3VBPqOz_jEu_Mad-Nw@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: dec: tulip: de4x5: fix possible array
 overflows in type3_infoblock()
To:     Teng Qi <starmiku1207184332@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, tanghui20@huawei.com,
        Networking <netdev@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>, islituo@gmail.com,
        TOTE Robot <oslab@tsinghua.edu.cn>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:YXUj9swxAphR+zDeXhTD9rV5F6HGsA4IsTy59gxAxCk0p08c27b
 XwO3qwnxaKo0LMFpcGzjKchFfgBHa57AhDA1B8QP+XUfBZobFW/qaaub88c4sFE2E3rqNcP
 fDxlTC/8GJ6lkjrJCKGRl5n43aDBDUxPDhciXxrP6h/Jha2OzHkcRbQT04zl8I0vIxlrQ6A
 USvKTfneT6KeOawXC86SA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:QkVpiIC31Xc=:ugunMVEF6b9KNzn0Pm1yCU
 wBdRfpX+8fSG3A9uP4xy9JTf1AORcqKXzFkQTPtZjL6MM7ullY4KYVBDtbWCedaAT9Vttru9G
 U2Sq48bL80HpFdJ1rZjTxAVfs/8pCEO56mohRj9/w2E+ew2kJ22Ry/fKbC9ywFTqMH6Qy2J9p
 XuRCA79nLVO3At2P7QxRthUQY6UkjzAqh89124++q/wfOwkpAU0FXvUtvbRDXXFlW93sy7llP
 LXZecPv+XZBKDsUu6xgXmhWD5lMhsRutbaVWTY6l7Jq/hO7uRPpCVKd2qiYqEk3zsJ7Tf8HF2
 k7jWTKcWVfv8HEGMa20CQRiy1zopYzyDrXlFXUa9/l9X0xSbQuTDOQkfWEpL46aWZ+q2kft2h
 kXvCsFXLE/52EiTOBb2odgsM1WHyUjfD5UoMPl2H5sbsjTPJF0ZeCA++P7NL59U8WI5MftCz2
 XOwKE1rBJHsThlY+W3iF+sPI8bUZpFTthBhQzK7Zza7b2F6xf10LrXtqQZvnH6ID/5dwnRXYz
 GI57vOgQ9kdIbyvVNHHptlHrJQL/29zvLU/EJo8DsBqpS/hVPzcf1QbWrATlX6f1xc7afDRYE
 7H0IDI/BWv+ooxkAk0U7E5W4QAfHF4VLebdl00V6YaGFpZHKw7veuvLMKNLn07LNNwk8D+RsJ
 JUDrq/rmauEEyoEyFxYVxH0JmHDal9Ti85RGPSdgNH1c4TMZ9K9vLLuCIDVJbzovuqnFA9NqN
 f6hkBzdzZkZlFBWaVWibNSq2OOp2I35QW8xirwzge/2Ie+nV2rjrIxHPMGUCzsnMqiiN/e7z3
 IE1/o5WY52aszLkFj7xxgHOLnPLx2eyzc0tc+0sWg0ejMmJlo4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 4:37 AM Teng Qi <starmiku1207184332@gmail.com> wrote:
>
> The definition of macro MOTO_SROM_BUG is:
>   #define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(
>   dev->dev_addr) & 0x00ffffff) == 0x3e0008)
>
> and the if statement
>   if (MOTO_SROM_BUG) lp->active = 0;
>
> using this macro indicates lp->active could be 8. If lp->active is 8 and
> the second comparison of this macro is false. lp->active will remain 8 in:
>   lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
>   lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
>   lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
>   lp->phy[lp->active].mci = *p;

This is a very nice analysis of the problem!

> However, the length of array lp->phy is 8, so array overflows can occur.
> To fix these possible array overflows, we first check lp->active and then
> set it to 0 if it is equal to DE4X5_MAX_PHY (i.e., 8).
>
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Teng Qi <starmiku1207184332@gmail.com>

> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
> index 13121c4dcfe6..18132deac2bf 100644
> --- a/drivers/net/ethernet/dec/tulip/de4x5.c
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c
> @@ -4708,7 +4708,8 @@ type3_infoblock(struct net_device *dev, u_char count, u_char *p)
>      if (lp->state == INITIALISED) {
>          lp->ibn = 3;
>          lp->active = *p++;
> -       if (MOTO_SROM_BUG) lp->active = 0;
> +       /* The DE4X5_MAX_PHY is length of lp->phy, and its value is 8 */
> +       if (MOTO_SROM_BUG || lp->active == DE4X5_MAX_PHY) lp->active = 0;

I don't think this is a good fix, since this is technically the same as leaving
out the 'if (MOTO_SROM_BUG)' check and just checking for lp->active==8.

I would suggest leaving the existing logic in place (as I have no idea where
that came from), but adding a more defensive range check like:

       if (WARN_ON(lp->active >= ARRAY_SIZE(lp->phy))
                   return -EINVAL;

Note also that this driver is already very old and orphaned, if your bot has a
lot more findings like this one, it may be best to prioritize fixing
drivers that
are actively used and maintained.

      Arnd
