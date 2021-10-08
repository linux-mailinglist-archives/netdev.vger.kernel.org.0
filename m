Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B904265AC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233780AbhJHIQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:16:34 -0400
Received: from mail-ua1-f45.google.com ([209.85.222.45]:34723 "EHLO
        mail-ua1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbhJHIQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 04:16:32 -0400
Received: by mail-ua1-f45.google.com with SMTP id h4so6198069uaw.1;
        Fri, 08 Oct 2021 01:14:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7wO+xcQh6vNN08iok37rOCPRwho9ClVLbVfs6DvZcoU=;
        b=1V+mwmje0bbAVYIweZ9k+xoyyotUOqd0jO9GkvoXdg6/lVr/Bvc6/ykGQFLBE/BEm2
         LdDqqh1LbwB8g5uDQkB8vTOOVvNMBKfqKyWhZkp9mpqIniq/jNlrp1sufYnkyyy7GGS3
         jBvk+7QCLD2+oEKKAaOql3OEDuRpqrJAKpIKPNXNHlIVnFZva2qpJtKeu/84TVgFoMsq
         Xq9PehJrJvSWAjnjLKjvLWk17nmu7oMfM3LJWMVaeu2n9Oc78YS8cfiAd6QF8xgwVg90
         S5jMmhiiFhajs3ZBuHe3c62PV9Y3uPXEmywRwzK8makrR81SV4ENCI6LPgKUyEQ1Sfa1
         Nvxw==
X-Gm-Message-State: AOAM530UZyevZG0l6HMETNPC7NcScgs/sMbTv/b//XEycgYjweX09j9W
        S+mqOcRkkyX1hXlj5g419Pip0EorYDALjJrX/MJHImVBioo=
X-Google-Smtp-Source: ABdhPJxD3cm5x6NWNfsGlyqVJout9BqXENj3uvqqT6UeA6jfU03wynvPPBTZw2mQph2TScrcb7ByvBjOn/L2fjppPQ4=
X-Received: by 2002:ab0:16d4:: with SMTP id g20mr1204838uaf.114.1633680876846;
 Fri, 08 Oct 2021 01:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211008162103.1921a7a7@canb.auug.org.au> <87tuhs5ah8.fsf@codeaurora.org>
In-Reply-To: <87tuhs5ah8.fsf@codeaurora.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Oct 2021 10:14:25 +0200
Message-ID: <CAMuHMdUZa9o15_fGJ7Si_-bOQVcFOxtWgo_MOiKsV0FjoPeX6Q@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        ath11k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Fri, Oct 8, 2021 at 7:55 AM Kalle Valo <kvalo@codeaurora.org> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>
> > After merging the net-next tree, today's linux-next build (xtensa,
> > m68k allmodconfig) failed like this:
> >
> > In file included from <command-line>:0:0:
> > In function 'ath11k_peer_assoc_h_smps',
> >     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2362:2:
> > include/linux/compiler_types.h:317:38: error: call to '__compiletime_assert_650' declared with attribute error: FIELD_GET: type of reg too small for mask
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >                                       ^
> > include/linux/compiler_types.h:298:4: note: in definition of macro '__compiletime_assert'
> >     prefix ## suffix();    \
> >     ^
> > include/linux/compiler_types.h:317:2: note: in expansion of macro '_compiletime_assert'
> >   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> >   ^
> > include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
> >  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> >                                      ^
> > include/linux/bitfield.h:52:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
> >    BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,  \
> >    ^
> > include/linux/bitfield.h:108:3: note: in expansion of macro '__BF_FIELD_CHECK'
> >    __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: "); \
> >    ^
> > drivers/net/wireless/ath/ath11k/mac.c:2079:10: note: in expansion of macro 'FIELD_GET'
> >    smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
> >           ^
> >
> > Caused by commit
> >
> >   6f4d70308e5e ("ath11k: support SMPS configuration for 6 GHz")
>
> Thanks for the report, weird that I don't see it on x86. I can't look at
> this in detail now, maybe later today, but I wonder if the diff below
> fixes the issue?

It seems to be related to passing "le16_to_cpu(sta->he_6ghz_capa.capa)".
Probably typeof(le16_to_cpu(sta->he_6ghz_capa.capa)) goes berserk.
le16_to_cpu() is a complex macro on big-endian. I had expected to see
a similar issue on powerpc, but I don't.
Using an intermediate "u16 capa = le16_to_cpu(sta->he_6ghz_capa.capa)"
fixes the problem.

> At least it's cleaner than using FIELD_GET(), actually ath11k should be
> cleaned up to use xx_get_bits() all over.
>
> Kalle
>
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
> index d897020dd52d..3e7e569f284b 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -2076,8 +2076,8 @@ static void ath11k_peer_assoc_h_smps(struct ieee80211_sta *sta,
>                 smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
>                 smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
>         } else {
> -               smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
> -                                le16_to_cpu(sta->he_6ghz_capa.capa));
> +               smps = le16_get_bits(sta->he_6ghz_capa.capa,
> +                                    IEEE80211_HE_6GHZ_CAP_SM_PS);
>         }

Thanks, that works, too, so (compile)
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
