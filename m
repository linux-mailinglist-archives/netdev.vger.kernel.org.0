Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76482479EFB
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 04:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhLSDS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 22:18:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLSDS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 22:18:26 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6336C061574;
        Sat, 18 Dec 2021 19:18:25 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id g2so3457781pgo.9;
        Sat, 18 Dec 2021 19:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HgO/AnLTebkvZgBliOdVUV9xb0z/JsGE4nYCPR0M4co=;
        b=RRm4bIi22UPgJ3SR1WkTNHCGRFnxCVcyHCIs3CzGR9JMwSP2W5LJW5uEStvEWSM7gJ
         kmk2e/6nouGdWNsCEnyIP0eb2AP9SjKeMiz5Lpeot7uH7qvPoMMNbtB0qzYWuuo2cSfb
         wp0JZ9rstGMnUwyFyfopXvdEJvW3Re3RerXoVwQQYE+uytCJF/pfQGDXMCczyr5Np2fp
         NNwad6hZMtSZ69ElrLVUQEcLqEmtUlNwzWt8hTTX5LIe1O7V1oBE4B2AY02RyDf7VkA1
         xWDnm/8ooPJ6H2AZOlIYlSp9G1TAgPzbijLaoZ0lm4fSJGakf2gXTlz4xQd2CSQKu0as
         6gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HgO/AnLTebkvZgBliOdVUV9xb0z/JsGE4nYCPR0M4co=;
        b=XMK9LeMHN+XzO8IRJYgwFdgyjuBK8QqUNRltGlTPK/WSoeB/QxoGI7UYRAbg59Cp79
         h5nG7lWh3qraFldIoUMQn1ylj04AGSXqtyOk/WtQtmzu6HP9K7/Ij+bgePWODclLMu7F
         HRWWpMFMxkJ3UcF3gmZQlURHuAZJnUPB61GEV7NGa8EET8E/zkDad9jO4kpesB99FG79
         pFgQQXjXFhtpWpfLGXRzmOWz9q1KW3sgxAmiRAN4SFhcBx7/vTIqlRdT6fQYxWGGrQZa
         0/vbVeynkum21WBDyXS9tZK/FU4ooeJo0nqtgqOPgVDr7uCcxY2Xf61+tEvSvBYP7xsC
         PYtg==
X-Gm-Message-State: AOAM530LjX5a2QRC+3u4hJTTZEko8C9WK9WTh6+vGY1Um0sNGbILFkow
        kb7bwXhEkmV+0bOT69bzixU=
X-Google-Smtp-Source: ABdhPJzBCopHFF+t0D1Kn63jUmkExQ8IQhfPqfA+PPyBgKrtkDh/1GLhXV934BzvpjtVZkaakX1V3g==
X-Received: by 2002:a63:6a83:: with SMTP id f125mr9253534pgc.340.1639883904716;
        Sat, 18 Dec 2021 19:18:24 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id d12sm14971705pfu.91.2021.12.18.19.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 19:18:24 -0800 (PST)
Date:   Sun, 19 Dec 2021 08:48:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
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
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 06/10] bpf: Track provenance for pointers
 formed from referenced PTR_TO_BTF_ID
Message-ID: <20211219031822.k2bfjhgazvvy5r7l@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
 <20211219022839.kdms7k3jte5ajubt@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219022839.kdms7k3jte5ajubt@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 07:58:39AM IST, Alexei Starovoitov wrote:
> On Fri, Dec 17, 2021 at 07:20:27AM +0530, Kumar Kartikeya Dwivedi wrote:
> > diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> > index b80fe5bf2a02..a6ef11db6823 100644
> > --- a/include/linux/bpf_verifier.h
> > +++ b/include/linux/bpf_verifier.h
> > @@ -128,6 +128,16 @@ struct bpf_reg_state {
> >  	 * allowed and has the same effect as bpf_sk_release(sk).
> >  	 */
> >  	u32 ref_obj_id;
> > +	/* This is set for pointers which are derived from referenced
> > +	 * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
> > +	 * pointers obtained by walking referenced PTR_TO_BTF_ID
> > +	 * are appropriately invalidated when the lifetime of their
> > +	 * parent object ends.
> > +	 *
> > +	 * Only one of ref_obj_id and parent_ref_obj_id can be set,
> > +	 * never both at once.
> > +	 */
> > +	u32 parent_ref_obj_id;
>
> How would it handle parent of parent?

When you do:

r1 = acquire();

it gets ref_obj_id as N, then when you load r1->next, it does mark_btf_ld_reg
with reg->ref_obj_id ?: reg->parent_ref_obj_id, the latter is zero so it copies
ref, but into parent_ref_obj_id.

r2 = r1->next;

From here on, parent_ref_obj_id is propagated into all further mark_btf_ld_reg,
so if we do since ref_obj_id will be zero from previous mark_btf_ld_reg:

r3 = r2->next; // it will copy parent_ref_obj_id

I think it even works fine when you reach it indirectly, like foo->bar->foo,
if first foo is referenced.

... but maybe I missed some detail, do you see a problem in this approach?

> Did you consider map_uid approach ?
> Similar uid can be added for PTR_TO_BTF_ID.
> Then every such pointer will be unique. Each deref will get its own uid.

I'll look into it, I didn't consider it before. My idea was to invalidate
pointers obtained from a referenced ptr_to_btf_id so I copied the same
ref_obj_id into parent_ref_obj_id, so that it can be matched during release. How
would that work in the btf_uid approach if they are unique? Do we copy the same
ref_obj_id into btf_uid? Then it's not very different except being btf_id ptr
specific state, right?

Or we can copy ref_obj_id and also set uid to disallow it from being released,
but still allow invalidation.

> I think the advantage of parent_ref_obj_id approach is that the program
> can acquire a pointer through one kernel type, do some deref, and then
> release it through a deref of other type. I'm not sure how practical is that
> and it feels a bit dangerous.

I think I don't allow releasing when ref_obj_id is 0 (which would be the case
when parent_ref_obj_id is set), only indirectly invalidating them.

--
Kartikeya
