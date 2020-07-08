Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082AB218F59
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbgGHR44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGHR44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:56:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEB9C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 10:56:56 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z3so11000643pfn.12
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 10:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KFZpY681inDypA2LYvEVNVJEszHTfc/UjNXbYEWopm4=;
        b=tL5rdDIIvL7NgwMR9ubYdHDjODQac7uQ2v8GBeHDf2Tn9kJcIAsydShvdY+g6dcg9h
         d4z1KbV5x1NdZZSf8QcDtE/99f/9J/4JCfIpTve2g2MO9/sMc26j0Kb7UXQ4EEuVqgQw
         Od4S2hpQgi1/Q+UbShoxbdPVJsSYYTXmAi1pnAv11Lyftvq6ejJv8YSCa0U9a0ACFQmg
         hSIqWu7TuuHBQneUxcaYCRZIiTiMz2mEbGygdeMFQbuEY6/KKGG3U4Chw91Ef1W9umk+
         qZgbOU2KWawJbNFtYNUodoErqMOL+BUCNxZ4xBOkXbItFzwgHfGeg9udZZo4FHGqGSY8
         zraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KFZpY681inDypA2LYvEVNVJEszHTfc/UjNXbYEWopm4=;
        b=e36u7/SzMsBpWUW6FX2DbNZ0taYTtmWXgAifT3pBRay9POBO1FCyzlMVn4KNqYgPey
         5WiTq3hnlrnE1lAHcSspa9LnOBBblmMtE1wGBtK/m2+R6HWH9qKLfEVyJuRWAL+yFWRJ
         Bqu7xzhy647VOsiP+npj/AAlMV/+wnp5l3P5mc6dGFXxkiDlkaiZ2/tTVLJECJGNCavc
         yKZ2aQxXZ3XiwgSw5asRWa1KXOwtIjSEWkZCimQPRTHfqSufoA53lSoP51npy5vEAQ7B
         mRSypmcpMViX7RLrXjrYGKPr8SgWrJVymigbg+MOhmdWIr4ZrWU2260is1Vgeou7hf5e
         rR7w==
X-Gm-Message-State: AOAM531p8zqiCIElNoxfYLB+6cnxnAOlpsoGA7jlfJXZ4PdbwMWZyjoA
        F9SF+mTRGaXElYeDdBSbP9ti2XtAV/wtQPNQpr7B+A==
X-Google-Smtp-Source: ABdhPJz3qZ0R9CdScEvi6luqWSPLgualQyiV/WOJObuwgv4BQwFpHN2jFXYiBWikVExNO/FQ07vGF30QykV0INt/TrA=
X-Received: by 2002:a62:86cc:: with SMTP id x195mr47595529pfd.39.1594231015327;
 Wed, 08 Jul 2020 10:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200707211642.1106946-1-ndesaulniers@google.com>
 <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org> <CAKwvOdmtv2EdNQz+c_DZm_47EEibkaXfDW8dGPwNPA3OrcoC9g@mail.gmail.com>
 <20997cd9-91e5-ca83-218d-4fd5af128893@linaro.org>
In-Reply-To: <20997cd9-91e5-ca83-218d-4fd5af128893@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 8 Jul 2020 10:56:43 -0700
Message-ID: <CAKwvOd=PrNG9WqBc4P43-XK7pOD4rQg4FA8Gd27OdUYb2qMDdw@mail.gmail.com>
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in FIELD_FIT
To:     Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 10:34 AM Alex Elder <elder@linaro.org> wrote:
>
> I understand why something needs to be done to handle that case.
> There's fancy macro gymnastics in "bitfield.h" to add convenient
> build-time checks for usage problems; I just thought there might
> be something we could do to preserve the checking--even in this
> case.  But figuring that out takes more time than I was willing
> to spend on it yesterday...

I also find the use of 0U in FIELD_GET sticks out from the use of 0ULL
or (0ull) in these macros (hard to notice, but I changed it in my diff
to 0ULL).  Are there implicit promotion+conversion bugs here?  I don't
know, but I'd rather not think about it by just using types of the
same width and signedness.

> >> A second comment about this is that it might be nice to break
> >> __BF_FIELD_CHECK() into the parts that verify the mask (which
> >> could be used by FIELD_FIT() here) and the parts that verify
> >> other things.
> >
> > Like so? Jakub, WDYT? Or do you prefer v1+Alex's suggestion about
> > using `(typeof(_mask))0` in place of 0ULL?
>
> Yes, very much like that!  But you could do that as a follow-on
> instead, so as not to delay or confuse things.

No rush; let's get it right.

So I can think of splitting this into maybe 3 patches, based on feedback:
1. there's a bug in compile time validating _val in FIELD_FIT, since
we want to be able to call it at runtime with "bad" values.
2. the FIELD_* macros use constants (0ull, 0ULL, 0U) that don't match
typeof(_mask).
3. It might be nice to break up __BF_FIELD_CHECK.

I don't think anyone's raised an objection to 1.

Assuming Jakub is ok with 3, fixing 3 will actually also address 2.
So then we don't need 3 patches; only 2.  But if we don't do 3 first,
then I have to resend a v2 of 1 anyways to address 2 (which was Alex's
original feedback).

My above diff was all three in one go, but I don't think it would be
unreasonable to break it up into 3 then 1.

If we prefer not to do 3, then I can send a v2 of 1 that addresses the
inconsistent use of types, as one or two patches.

Jakub, what is your preference?

(Also, noting that I'm sending to David, assuming he'll pick up the
patches once we have everyone's buy in? Or is there someone else more
appropriate to accept changes to this header? I guess Jakub and David
are the listed maintainers for
drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c)
-- 
Thanks,
~Nick Desaulniers
