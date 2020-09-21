Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5670271C3D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIUHqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 03:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgIUHqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 03:46:43 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B26C0613CE
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:46:43 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g29so8315560pgl.2
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 00:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KEQZ+0+MjbwK1ElZms1Qgb4W3im9WPY9mb97cPZoGK0=;
        b=uQbRytZokTI9uAROSbK3E3kPhHy0k8+bTpZNDdwFsDvSZV9ClRnTaGzPeJl+3iL46B
         B/W1PYvR4awrXTO9WDeUI88a4/UFNeFxMrmqMDYXOB+ZSF/dCv2jPWqMZnfgtYmwsgVA
         tiYAfKvnau0HbFLtG4zTFIPFGIDhMDYYxIVkDn9TFoYUJAlUrA+ThMqO47z/LPDN8XwY
         l/iueAjhsKKKTrKAnXkxA1Yd+11IsSnnNywcrSMMUQzhvsXpBteBJVvuSax7CrXyep0j
         enckp5UJM3mwjWfsZyMJo1NBUXfDvdBDoGt4/OwUT0OGM6UtAQcnMTDN5habb2LtNXdZ
         LbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KEQZ+0+MjbwK1ElZms1Qgb4W3im9WPY9mb97cPZoGK0=;
        b=Nas5Agn0WAtI8f/R+8sQ2/sakecdFq+KG5mgkV4DqlAE6KnX8IDAv8FmDbBsH9nqFP
         P3uaVNc7iSCsCFBhP7x/y2ZEE3ONaXjfrX6O2aNv/5r9ibWGmXKfhJZ5NdvNOZbQ73nE
         cAgd9Eah61HKasooffrpZU2a8euKkKkFfdejTfwRJMEq0jKMPs94LiuY/hJJ55+EEC1j
         7rBIUdXnp7xrdozJEC7FNI5wA8PjSUr9E63RNH1W+MVVL4IRUZ09Q7PV8nNk/q9wi3j6
         ZuYpE60zGbN3lU/w2toYOLIEsh/ZJJwm6GRcNkvX0X+drbgUTpFHo0KxAJ8yL2deGDSQ
         s6IQ==
X-Gm-Message-State: AOAM530v0PTLOqUrLKErakeCmgMUN8yTAl4DcXkGCTdcpjR6JBZDUzTM
        qt6DZXodTQPC/vkBm5pkeq7A9c2uu4Brpq4S+l2DCg==
X-Google-Smtp-Source: ABdhPJyQpA8ZjwSRlnLg26q0TprnPeXcNQVwncIaeBqK+eZsI4FvBtCOdSwD5EFWTY+UqkN7XkuLHtDjs+xndIYZS4M=
X-Received: by 2002:a17:902:758b:b029:d2:29fc:c841 with SMTP id
 j11-20020a170902758bb02900d229fcc841mr2054484pll.39.1600674403207; Mon, 21
 Sep 2020 00:46:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200916071950.1493-3-gilad@benyossef.com> <202009162154.fxQ0Z6wT%lkp@intel.com>
 <CAOtvUMdv9QNVdaU7N6wJVq27Asyrckuu9bf15fO=+oZUh5iKOg@mail.gmail.com> <CAKwvOdmW+n_g4C_pXnF+8wh2q0gZZyXAfaYR9cVNm3p1QeJ-xA@mail.gmail.com>
In-Reply-To: <CAKwvOdmW+n_g4C_pXnF+8wh2q0gZZyXAfaYR9cVNm3p1QeJ-xA@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 21 Sep 2020 10:46:32 +0300
Message-ID: <CAOtvUMe1zj+sGhZfvjYD=PciWDby9uKvH70i01FrfVVR6cC_Tg@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccree - add custom cache params from DT file
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Network Development <netdev@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Sep 18, 2020 at 10:39 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Sep 17, 2020 at 12:20 AM Gilad Ben-Yossef <gilad@benyossef.com> w=
rote:
> >
...
> >
> > I am unable to understand this warning. It looks like it is
> > complaining about a FIELD_GET sanity check that is always false, which
> > makes sense since we're using a constant.
> >
> > Anyone can enlighten me if I've missed something?
>
> Looked at some of this code recently.  I think it may have an issue
> for masks where sizeof(mask) < sizeof(unsigned long long).
>
> In your code, via 0day bot:
>
>    107          u32 cache_params, ace_const, val, mask;
> ...
> > 120          cache_params |=3D FIELD_PREP(mask, val);
>
> then in include/linux/bitfield.h, we have:
>
>  92 #define FIELD_PREP(_mask, _val)           \
>  93   ({                \
>  94     __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");  \
>
>  44 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)     \
> ...
>  52     BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,   \
>  53          _pfx "type of reg too small for mask"); \
>
> so the 0ULL in FIELD_PREP is important.  In __BF_FIELD_CHECK, the
> typeof(_reg) is unsigned long long (because 0ULL was passed).  So we
> have a comparison between a u32 and a u64; indeed any u32 can never be
> greater than a u64 that we know has the value of ULLONG_MAX.
>
> I did send a series splitting these up, I wonder if they'd help here:
> https://lore.kernel.org/lkml/20200708230402.1644819-3-ndesaulniers@google=
.com/
> --

Thanks!

This indeed explains this. It seems there is nothing for me to do
about it in the driver code though, as it seems the issue is in the
macro and you have already posted a fix for it.

Thanks again,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
