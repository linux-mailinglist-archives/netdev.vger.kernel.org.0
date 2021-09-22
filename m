Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53415414184
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 08:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhIVGHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 02:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbhIVGHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 02:07:41 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5797DC061574;
        Tue, 21 Sep 2021 23:06:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so3225344pjb.1;
        Tue, 21 Sep 2021 23:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qrofLkocX3lRzv2kI0POtIg2TGvdOVuC4VYa9wJlFIM=;
        b=S1rB89zbNg20k5NgOquw+uJf4DggcuYS03kf3xOBr210qRv3o1ol555JbwAQ8roIjx
         K5Os5/8/UAlOZwbpy2hJs1pSf5aOKaQMf3p7XSpfKB7vHEObhJ3FV4y4BNVBvf9EI2Ri
         4AdCemQDocB9skiskdQ55YWYEcIEgEoFrWMnkT2UubJcyDtXzSk4NqIZ9tpfAaUQLBPl
         speIB4nhEvwehRyLyJ+7mABufy0EC+Z0EqlRz0ND+c8aOKGMpco2xTFetxl90F20ApqJ
         BzqrhDFe8rUJcWaDMWSG2BWFgSanWT8ASIqSq5fpJdvTj3s9eW8NfdQBnRlMaPdaLoBb
         Xplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qrofLkocX3lRzv2kI0POtIg2TGvdOVuC4VYa9wJlFIM=;
        b=4recMWKuUC22MvYlyFP56D1OzasI2NyLWHC3UlFeWm/f1gUxElmaQq2s1o1Ru25Pni
         oqWfBSsxagis8Ic70ogQfaJYZ1v/6GuaOwPzQe6OE+GEmY9JiGGWu4qQzxV3xUmBFPhJ
         fLHbtb5nrc2iy0piF7nL2wDASJAaVWcQMbLo29mqLHAu0JqRsG6Nrhs9tLmojhum91Ac
         Br/a8l0gabhYPstnHCH4xdsS+oNlp04HkIzaE3Qjb6LU4Vo66K/rTkrQrOCI7hpvLLQC
         FuPwiFXvinOWXD/rtyc2EI3v0HnkA1nPXpw3pM6yex6T3nvyCvkbCZPsbe35Im9n38JH
         DjMw==
X-Gm-Message-State: AOAM531WzyrP5hYyRxjKgAbsJSBhSPBa9p68do3z0MZ1lzLRA1+PblEE
        DllBZ/jG8ZvL679azrjhT0A=
X-Google-Smtp-Source: ABdhPJzjrU4YNEnfUn+Fn1Gzi6yFjc0+LTkBmjN28+g8Jx3Ep7WxhXrO+fyeo+lp9a9KraasJBjTAQ==
X-Received: by 2002:a17:90a:460a:: with SMTP id w10mr9310536pjg.132.1632290771649;
        Tue, 21 Sep 2021 23:06:11 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id l24sm1133054pgc.93.2021.09.21.23.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 23:06:11 -0700 (PDT)
Date:   Wed, 22 Sep 2021 11:36:08 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 11/11] bpf: selftests: Add selftests for
 module kfunc support
Message-ID: <20210922060608.fxdaeguiako4oixb@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <20210920141526.3940002-12-memxor@gmail.com>
 <CAEf4Bza5GxHb+=PQUOKWQ=BD3kCCEOYjDLKSdsPRZu468KAePg@mail.gmail.com>
 <20210921231320.pgmbhmh4bjgvxwvp@apollo.localdomain>
 <CAEf4BzaAjHNoEPFBCmPFQm_vqk_Tj0YYEF8X0ZX9RpmzeeJnhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaAjHNoEPFBCmPFQm_vqk_Tj0YYEF8X0ZX9RpmzeeJnhw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 05:33:26AM IST, Andrii Nakryiko wrote:
> > [...]
> > Hmm, good idea, I'd just need to fill in the BTF id dynamically at runtime,
> > but that should be possible.
> >
> > Though we still need to craft distinct calls (I am trying to test the limit
> > where insn->off is different for each case). Since we try to reuse index in both
> > gen_loader and libbpf, just generating same call 256 times would not be enough.
>
> You just need to generate one instruction with offset = 257 to test
> this. And separately one call with fd_array that has module BTF fd at
> fd_array[256] (to check that 256 is ok). Or am I missing something?
>

That won't be enough, if I just pass insn->imm = id, insn->off = 257, it becomes
first descriptor in kfunc_tab and kfunc_btf_tab. The total limit is 256, and
they are kept in sorted order by based on id and off for the first, off for the
second. So 256 different offs are needed (imm may be same actually), so that
both fill up.

--
Kartikeya
