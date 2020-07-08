Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CDD218DF5
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbgGHRK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730380AbgGHRK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:10:27 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27942C08C5CE
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 10:10:27 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id k27so5882416pgm.2
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 10:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0rEN23cbd1SKA3NGgD72iDuMJC8fxPRHEEwlwQ22hpY=;
        b=n3f7ckSQTYxY4oOO8C4Z4sELvQoSxfPuNNn5dS5itgz86q7oeo6QAE5dnY3J8ean9i
         6dvZUT2D5UoOUQYFMRIphN2tg3/E0o0u05fgXWbfYNdG3CZngyfAq7WUJOYeAFMlC0Zd
         N77A/v1AFDsWhOHGZQ9z/9FmP3EU77jnkVYGxPDCa4WffEdnSowEm+8OqO4TLltztoio
         b6DPBKGnr/2gByDXf3TsF4fRI+44HDCNThtu2KIhKTXKLKqVFz0RbdfSz6DjYy9nWF43
         hWKIf1qRkcfvq+So1oikHSAY2Reos3ReB+a+Yu7L00yMWsIWoJOCDTFU0T5jy1NAIZrn
         CWOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0rEN23cbd1SKA3NGgD72iDuMJC8fxPRHEEwlwQ22hpY=;
        b=nSY4lFakj/NBUiG7bSc21YW/pGGty2adJ+jmb/pmi65TFKLZBrC0dclJTx5PTVfP3R
         6OZJgY5Ju3LcNKQDn437t6eZOqV6yhZlJepcHy1HSXkWyneWjV7JOzhk1m7H37HjF5Kg
         OPgEVgcNWtpVfcteh4k8f+7k9tOehBPbq6NE+5PvSopStqJ6Q+UuPLvAdlOlAXOwb135
         CyR4yOjqfSp56BXlpda+0T9IEFt4sdO2b24vOnOqPmsRxt8wK1xPV7MnKWszp7sxL1H+
         2cyAAEoY1XOxnjTNCvk+ok5fPcWthPCW/nDKR4Et+4rOk5OjFVSOF7H2OH659qoMYbhg
         spPQ==
X-Gm-Message-State: AOAM532bikrylwF8yFA670R0bYSrMb3GU9KXz+LWWijO5GqkVQ3cReWe
        be0hxxjNAi//xihowL27C74+NydNKK3nYFtwxH7znQ==
X-Google-Smtp-Source: ABdhPJzv8hmcPMQH68pT1oCrLz0ZeqUbfp5c1EkwtUlJxi7EMIom41s9drUIMd+EWqnR/3xanznSqmzVFWme8WK7OaA=
X-Received: by 2002:aa7:9303:: with SMTP id 3mr45101796pfj.108.1594228226197;
 Wed, 08 Jul 2020 10:10:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200707211642.1106946-1-ndesaulniers@google.com> <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org>
In-Reply-To: <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 8 Jul 2020 10:10:14 -0700
Message-ID: <CAKwvOdmtv2EdNQz+c_DZm_47EEibkaXfDW8dGPwNPA3OrcoC9g@mail.gmail.com>
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in FIELD_FIT
To:     Alex Elder <elder@linaro.org>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
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

On Tue, Jul 7, 2020 at 3:43 PM Alex Elder <elder@linaro.org> wrote:
>
> On 7/7/20 4:16 PM, Nick Desaulniers wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> >
> > When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
> > compiler to deduce a case where _val can only have the value of -1 at
> > compile time. Specifically,
> >
> > /* struct bpf_insn: _s32 imm */
> > u64 imm = insn->imm; /* sign extend */
> > if (imm >> 32) { /* non-zero only if insn->imm is negative */
> >   /* inlined from ur_load_imm_any */
> >   u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
> >   if (__builtin_constant_p(__imm) && __imm > 255)
> >     compiletime_assert_XXX()
> >
> > This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
> > checks that a given value is representable in one byte (interpreted as
> > unsigned).

Hi Alex,
Thanks for taking a look. They're good and fair questions.

>
> Why does FIELD_FIT() pass an unsigned long long value as the second
> argument to __BF_FIELD_CHECK()?

Was Jakub's suggestion; I don't feel strongly against it either way, though...

> Could it pass (typeof(_mask))0 instead?

...might be nice to avoid implicit promotions and conversions if _mask
is not the same sizeof _val.

> It wouldn't fix this particular case, because UR_REG_IMM_MAX is also
> defined with that type.  But (without working through this in more
> detail) it seems like there might be a solution that preserves the
> compile-time checking.

I'd argue the point of the patch is to not check at compile time for
FIELD_FIT, since we have a case in
drivers/net/ethernet/netronome/nfp/bpf/jit.c (jeq_imm()) that will
always pass -1 (unintentionally due to compiler optimization).

> A second comment about this is that it might be nice to break
> __BF_FIELD_CHECK() into the parts that verify the mask (which
> could be used by FIELD_FIT() here) and the parts that verify
> other things.

Like so? Jakub, WDYT? Or do you prefer v1+Alex's suggestion about
using `(typeof(_mask))0` in place of 0ULL?

diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
index 311a5be25acb..938fc733fccb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
@@ -492,11 +492,12 @@ nfp_eth_set_bit_config(struct nfp_nsp *nsp,
unsigned int raw_idx,
        return 0;
 }

-#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)      \
-       ({                                                              \
-               __BF_FIELD_CHECK(mask, 0ULL, val, "NFP_ETH_SET_BIT_CONFIG: "); \
-               nfp_eth_set_bit_config(nsp, raw_idx, mask, __bf_shf(mask), \
-                                      val, ctrl_bit);                  \
+#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)
         \
+       ({
         \
+               __BF_FIELD_CHECK_MASK(mask, "NFP_ETH_SET_BIT_CONFIG:
");        \
+               __BF_FIELD_CHECK_VAL(mask, val,
"NFP_ETH_SET_BIT_CONFIG: ");    \
+               nfp_eth_set_bit_config(nsp, raw_idx, mask,
__bf_shf(mask),      \
+                                      val, ctrl_bit);
         \
        })

 /**
diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 48ea093ff04c..79651867beb3 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -41,18 +41,26 @@

 #define __bf_shf(x) (__builtin_ffsll(x) - 1)

-#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                      \
+#define __BF_FIELD_CHECK_MASK(_mask, _pfx)                             \
        ({                                                              \
                BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),          \
                                 _pfx "mask is not constant");          \
                BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");    \
+               __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
+                                             (1ULL << __bf_shf(_mask))); \
+       })
+
+#define __BF_FIELD_CHECK_VAL(_mask, _val, _pfx)
         \
+       ({                                                              \
                BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
                                 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
                                 _pfx "value too large for the field"); \
-               BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
+       })
+
+#define __BF_FIELD_CHECK_REG(_mask, _reg, _pfx)
         \
+       ({                                                              \
+               BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ULL,         \
                                 _pfx "type of reg too small for mask"); \
-               __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
-                                             (1ULL << __bf_shf(_mask))); \
        })

 /**
@@ -64,7 +72,7 @@
  */
 #define FIELD_MAX(_mask)                                               \
        ({                                                              \
-               __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");     \
+               __BF_FIELD_CHECK_MASK(_mask, "FIELD_MAX: ");            \
                (typeof(_mask))((_mask) >> __bf_shf(_mask));            \
        })

@@ -77,7 +85,7 @@
  */
 #define FIELD_FIT(_mask, _val)                                         \
        ({                                                              \
-               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
+               __BF_FIELD_CHECK_MASK(_mask, "FIELD_FIT: ");            \
                !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
        })
 @@ -91,7 +99,8 @@
  */
 #define FIELD_PREP(_mask, _val)
         \
        ({                                                              \
-               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
+               __BF_FIELD_CHECK_MASK(_mask, "FIELD_PREP: ");           \
+               __BF_FIELD_CHECK_VAL(_mask, _val, "FIELD_PREP: ");      \
                ((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);   \
        })

@@ -105,7 +114,8 @@
  */
 #define FIELD_GET(_mask, _reg)                                         \
        ({                                                              \
-               __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");       \
+               __BF_FIELD_CHECK_MASK(_mask, "FIELD_GET: ");            \
+               __BF_FIELD_CHECK_REG(_mask, _reg,  "FIELD_GET: ");      \
                (typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask)); \
        })



>
> That's all--just questions, I have no problem with the patch...
>
>                                         -Alex
>
>
>
>
> > FIELD_FIT() should return true or false at runtime for whether a value
> > can fit for not. Don't break the build over a value that's too large for
> > the mask. We'd prefer to keep the inlining and compiler optimizations
> > though we know this case will always return false.
> >
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
> > Reported-by: Masahiro Yamada <masahiroy@kernel.org>
> > Debugged-by: Sami Tolvanen <samitolvanen@google.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  include/linux/bitfield.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> > index 48ea093ff04c..4e035aca6f7e 100644
> > --- a/include/linux/bitfield.h
> > +++ b/include/linux/bitfield.h
> > @@ -77,7 +77,7 @@
> >   */
> >  #define FIELD_FIT(_mask, _val)                                               \
> >       ({                                                              \
> > -             __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
> > +             __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");     \
> >               !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
> >       })
> >
> >
>


--
Thanks,
~Nick Desaulniers
