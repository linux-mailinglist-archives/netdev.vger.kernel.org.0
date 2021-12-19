Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4547A19F
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 18:43:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhLSRnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 12:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhLSRna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 12:43:30 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA4AC061574;
        Sun, 19 Dec 2021 09:43:30 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id p18so6234680pld.13;
        Sun, 19 Dec 2021 09:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqclcLDh7y649q302xY/BciSc2aT0f2PUrNBYpElPao=;
        b=I7CrtPzAUJBKtrdAazNMEjilSJOXzYjbdzHOC9pRCa2sFfSOitRGEd3yz+QWCAnzEh
         +SLeuD5FMbVrMVb4KndxbWU6SRhdS4aoNWmjT0hpIBd5oMMrIZ7Jf5cHOWUK248A04Gt
         sTKK+EocmpC9W1dnpEI2fzwE1nB3Ll2cifrp3xV6/t+rjqJToRyl5V+NXoLdYy5267hL
         8p6VA87QGGFnOqGEyYSKz2G+M1BNNn6snZxPP1B+mbvqplmlca47s3ZhwiQkcQOfuOni
         /eLHmLwzQibUPxsh3X7gNK7KcDsOvMihkZrwrQQrKEn2hOWYtnL09EwdmZ/CFAsJzHLy
         nm0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqclcLDh7y649q302xY/BciSc2aT0f2PUrNBYpElPao=;
        b=t7Vzlvr26qmi06Z0yXn+mbsaOt2isSSnRDpnsnZidfLnF/iY3+U0K1/saxqomb3nS/
         0QNZ739NdP93knme0/tIFIOwoVThfVk4ytz6sF+OYR7tMwgVTEoN1RqZna6KGw/m7Z47
         qX3eMfaZdcGpk/DQUH+ym9NUxLMkhcdC8dNuH0jzC4UZPKMmwK02c8Jrd3TTi5bLURZu
         lkQTVwjsYWFV6Yum7lkHNn0Yn1hY9UCJ5jBuMvCZ050GOR4X3tC319ncZV1+5fpokaxV
         PrFF4T3TaXS4RE7eCn3ujXbycGU4q7Cdk4jc8GARzW5BLDrUGoyupAilhadwmzL2wOlg
         8HCg==
X-Gm-Message-State: AOAM53370mtPyr4evNLgn+PDFW55I3rCi3060Y7tenBO+IFWGE35JN15
        S9xBbo5y4Pcq7UHWSsisttpaCgSq9/f71p6XEzM=
X-Google-Smtp-Source: ABdhPJx+74RnnIl/HXoOoesuvuVPKgaJf8l/myPuDorbR+qlVeG9xGQ1FyaV3IAVdt5E9ZkLHj8qcSJ44k/5gPzFj80=
X-Received: by 2002:a17:90b:798:: with SMTP id l24mr23724565pjz.122.1639935809762;
 Sun, 19 Dec 2021 09:43:29 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp> <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
 <CAADnVQJ43O-eavsMuqW0kCiBZMf4PFHbFhSPa7vRWY1cjwqFAg@mail.gmail.com>
 <20211219043349.mmycwjnxcqc7lc2c@apollo.legion> <CAADnVQ+zWgUj5C=nJuzop2aOHj04eVH+Y4x+H3RyGwWjost9ZQ@mail.gmail.com>
 <20211219052540.yuqbxldypj4quhhd@apollo.legion>
In-Reply-To: <20211219052540.yuqbxldypj4quhhd@apollo.legion>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 19 Dec 2021 09:43:18 -0800
Message-ID: <CAADnVQ+EtYjnH+=tZCOYX+ioyx=d4NAxFFpRpN2PVfvye6thTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 18, 2021 at 9:25 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Sun, Dec 19, 2021 at 10:35:18AM IST, Alexei Starovoitov wrote:
> > On Sat, Dec 18, 2021 at 8:33 PM Kumar Kartikeya Dwivedi
> > <memxor@gmail.com> wrote:
> > >
> > > It is, but into parent_ref_obj_id, to match during release_reference.
> > >
> > > > Shouldn't r2 get a different ref_obj_id after r2 = r1->next ?
> > >
> > > It's ref_obj_id is still 0.
> > >
> > > Thinking about this more, we actually only need 1 extra bit of information in
> > > reg_state, not even a new member. We can simply copy ref_obj_id and set this
> > > bit, then we can reject this register during release but consider it during
> > > release_reference.
> >
> > It seems to me that this patch created the problem and it's trying
> > to fix it at the same time.
> >
>
> Yes, sort of. Maybe I need to improve the commit message? I give an example
> below, and the first half of commit explains that if we simply did copy
> ref_obj_id, it would lead to the case in the previous mail (same BTF ID ptr can
> be passed), so we need to do something different.
>
> Maybe that is what is confusing you.

I'm still confused.
Why does mark_btf_ld_reg() need to copy ref_obj_id ?
It should keep it as zero.
mark_btf_ld_reg() is used in deref only.
The ref_obj_id is assigned by check_helper_call().
r2 = r0; will copy it, but
r2 = r0->next; will keep r2->ref_obj_id as zero.

> > mark_btf_ld_reg() shouldn't be copying ref_obj_id.
> > If it keeps it as zero the problem will not happen, no?
>
> It is copying it but writing it to parent_ref_obj_id. It keeps ref_obj_id as 0
> for all deref pointers.
>
> r1 = acq(); // r1.ref = acquire_reference_state();
>  ref = N
> r2 = r1->a; // mark_btf_ld_reg -> copy r1.(ref ?: parent_ref) -> so r2.parent_ref = r1.ref
> r3 = r2->b; // mark_btf_ld_reg -> copy r2.(ref ?: parent_ref) -> so r3.parent_ref = r2.parent_ref
> r4 = r3->c; // mark_btf_ld_reg -> copy r3.(ref ?: parent_ref) -> so r4.parent_ref = r3.parent_ref
> rel(r1);    // if (reg.ref == r1.ref || reg.parent_ref == r1.ref) invalidate(reg)
>
> As you see, mark_btf_ld_reg only ever writes to parent_ref_obj_id, not
> ref_obj_id. It just copies ref_obj_id when it is set, over parent_ref_obj_id,
> and only one of two can be set.

I don't understand why such logic is needed.
