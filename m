Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B30F5894E2
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238429AbiHCXgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHCXgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:36:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF2851A3A
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:36:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id a89so23304361edf.5
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=XMwxz3mctao86/tOVJnX+lr9oNAxjmTmU2XKIuTJvTs=;
        b=cuI7HYbj9DxO6OtTMlxZc/FNkNFPenx0NQFsrPDz8WENrSphM4LqOkZvt6DNnQZmap
         CrWjdWQiJ+sciY3/mqTCW7cVJvpAkxqzWfkqeu8nhN0y0eb05OCoJWpo51F0INdKTU2q
         olHiz1ntdc+EM33zSE/MFNaFmd+T6r3RV/tQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=XMwxz3mctao86/tOVJnX+lr9oNAxjmTmU2XKIuTJvTs=;
        b=btyI7OUsX4HreqI1tBSjPqY79VcgGYztb01S256ISYvkOJ2jVD1laCw+q/2T9UXpBH
         XyhHMeC1V4XoNKbhbCsyulhtXeg+/lTmrwyLlOop8gz1wq3kKL0Yo23NPkIddK7pm1lT
         Gqdjxc3BsmbWBY2d4SSJWXZUjEu1W5OBRC99Cn4qsfoa0fO/BuRmoIFeZw8gEuASe2vk
         z7mW/Y7rRlXHH5y7PD5fD3PZXax9UXKirglAoBoAGhs0M/sqiOwiPXa/Tnxk3fVDAZKt
         OCM0Kw6t/c1iM5eVWAl5M4ENHIX6OZlWaXW8Q04hJ0yWtUeUuLHiZwS/7bCYJSLeypGL
         uK6Q==
X-Gm-Message-State: AJIora82Ng0rs21GSkP04c1kiIL/K/qW7kqSwlV3V0PyIJ91d6/4XppF
        TsrF89pUvCUioB1hsVioNyk4VoZcJd9fs9zt
X-Google-Smtp-Source: AGRyM1vaR/TKpTVE5Adq0hd3VyFDVEfMdJ9NjdBrz4jYqMtKFnbwIigfuRoV5bK0OcoovlxtlUcJMg==
X-Received: by 2002:aa7:da93:0:b0:43d:1d9d:1e5 with SMTP id q19-20020aa7da93000000b0043d1d9d01e5mr27746080eds.55.1659569773534;
        Wed, 03 Aug 2022 16:36:13 -0700 (PDT)
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com. [209.85.221.44])
        by smtp.gmail.com with ESMTPSA id f4-20020a056402328400b0043d18a875d1sm8913305eda.79.2022.08.03.16.36.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 16:36:12 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id j7so23305132wrh.3
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 16:36:12 -0700 (PDT)
X-Received: by 2002:adf:edcb:0:b0:21e:d043:d271 with SMTP id
 v11-20020adfedcb000000b0021ed043d271mr17545888wro.274.1659569772201; Wed, 03
 Aug 2022 16:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220803101438.24327-1-pabeni@redhat.com>
In-Reply-To: <20220803101438.24327-1-pabeni@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 3 Aug 2022 16:35:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiwRtpyMVn1F9KT14H64tajiWsPnd0FfL5-BFnPOuFa_w@mail.gmail.com>
Message-ID: <CAHk-=wiwRtpyMVn1F9KT14H64tajiWsPnd0FfL5-BFnPOuFa_w@mail.gmail.com>
Subject: Re: [GIT PULL] Networking for 6.0
To:     Paolo Abeni <pabeni@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wojciech Drewek <wojciech.drewek@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 3:15 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> At the time of writing we have two known conflicts, one with arm-soc:

Hmm. There's actually a third one, this one semantic (but mostly
harmless). I wonder how it was overlooked.

It causes an odd gcc "note" report:

  net/core/flow_dissector.c: In function =E2=80=98is_pppoe_ses_hdr_valid=E2=
=80=99:
  net/core/flow_dissector.c:898:13: note: the ABI of passing struct
with a flexible array member has changed in GCC 4.4
  898 | static bool is_pppoe_ses_hdr_valid(struct pppoe_hdr hdr)
      |             ^~~~~~~~~~~~~~~~~~~~~~

and it looks like a semantic merge conflict between commits

  94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
flexible-array members")
  46126db9c861 ("flow_dissector: Add PPPoE dissectors")

where that first commit makes 'struct pppoe_hdr' have a flexible array
member at the end, and the second second commit passes said pppoe_hdr
by value as an argument.

I don't think there is any reason to pass that 'struct pppoe_hdr' by
value in the first place, and that is not a normal pattern for the
kernel. Sure, we sometimes do use opaque types that may be structures
(eg 'pte_t') by value as arguments, but that is not how that code is
written.

Any sane compiler will inline that thing anyway, so the end result
ends up being the same, but passing a structure with an array at the
end (whether zero-sized or flexible) by value is just cray-cray, to
use the technical term.

So I resolved this semantic conflict by simply making that function
take a 'const struct pppoe_hdr *hdr' argument instead. That's the
proper way.

Why was this not noticed in linux-next? Is it because nobody actually
*looks* at the output? Because it's a "note" and not a "warning", it
ends up not aborting the build, but I do think the compiler is
pointing out a very real issue.

It would be perhaps worthwhile looking at code that passes structures
by value as arguments (or as return values). It can generate truly
horrendously bad code, and even when said structures are small, it's
uisually not the right thing to do.

And yes, as noted, we sometimes do have that pattern very much on
purpose, sometimes because of abstraction reasons (pte_t) and
sometimes because we explicitly want the magic "two words of result"
('struct fd' and fdget()).

So it's not a strict no-no, but it's not generally a good idea unless
you have a very good reason for it (and it's particularly not a good
idea when there's an array at the end).

I've fixed this up in my tree, and it's all fine (and while I'm not
*happy* with the fact that apparently nobody looks at linux-next
output, I guess it is what it is).

              Linus
