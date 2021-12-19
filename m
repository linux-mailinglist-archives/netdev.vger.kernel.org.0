Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B54D479ED3
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhLSC2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:28:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbhLSC2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:28:42 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64273C061574;
        Sat, 18 Dec 2021 18:28:42 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 205so1392438pfu.0;
        Sat, 18 Dec 2021 18:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y4hHdVW6kFMSr88EUtR87PERTsdaKJSyRdbTWu3G75A=;
        b=R9wIOK3LOLzHxDhKH336jhn0/+SPxg6JGFeh7zNw4QA1TmhVOfJU3oCvOeTLzpXM7z
         ZKBAlijBCj/C6tnMmKbmtXBXVAQK1lH3Y0knonyXBlL/3JQIYNOejaMGw2ytjty8Dtgw
         MwDWUmuQTD9QiOFi8tPudtLps+FSNAsQqNrpbvX7cWPHkXMnHyqQ7Uehm3dbp29MAN0j
         3O++oX8OjP4FyqbK+D5UBKV0750ngFx8jmfocZxiklBt9ig9UxfzH6SdIvS8eF0cCrL2
         trWwqGFL68ZYKzEL6daf+b7EGAvvvwKSDbvksHtGEQJJeVUxEqEUFzDLLN90uvY5Vgdi
         OrRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y4hHdVW6kFMSr88EUtR87PERTsdaKJSyRdbTWu3G75A=;
        b=riq6Vh4HN52USeU7iEaje9tSHD5EqEGAF6mM7OoB3SZJjGw5dtpFPf2Wuo4zFov/Uo
         EojiXG/VC4NJ4e0rXFgYlOdbCj+5zLJp7AZBVvwvDoI3VR044imz3V1mlepH62b/m6wn
         /FlsUfNySFETKlerznDTPTRmJXiFT297nfZIE/pCJKF7GIBgibUd1RC+0CorM9rU88nO
         RUwpKAiHJuZLrzejNnH0ekHWDe6QPosSxSbTiN64DEJRDzGSUUDYQxI/sPCkxRj9blzc
         xZBeeK1TUlsZaErVHV+muscFZPbVTVdVAtdnPghnPjISknEnhWzg76l5m2iFJuT31AQo
         11lQ==
X-Gm-Message-State: AOAM531Jp/KrgPwG/yRktKB4ebkC7N3DxYM1XmKvp0NJPvQAUfv7ko4J
        OA708+NtDoby/fBT1bS27nzFEiCQ0gY=
X-Google-Smtp-Source: ABdhPJz1hjjHQ0aKRyWETED1pdruYylEut2YEbaDofuT2+BdVZl5FMVx7Wbv+awTkzJP/3BjhT9UXg==
X-Received: by 2002:a63:dc0a:: with SMTP id s10mr9140717pgg.187.1639880921900;
        Sat, 18 Dec 2021 18:28:41 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:e30])
        by smtp.gmail.com with ESMTPSA id z4sm14777724pfh.15.2021.12.18.18.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 18:28:41 -0800 (PST)
Date:   Sat, 18 Dec 2021 18:28:39 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20211219022839.kdms7k3jte5ajubt@ast-mbp>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-7-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-7-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:27AM +0530, Kumar Kartikeya Dwivedi wrote:
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index b80fe5bf2a02..a6ef11db6823 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -128,6 +128,16 @@ struct bpf_reg_state {
>  	 * allowed and has the same effect as bpf_sk_release(sk).
>  	 */
>  	u32 ref_obj_id;
> +	/* This is set for pointers which are derived from referenced
> +	 * pointer (e.g. PTR_TO_BTF_ID pointer walking), so that the
> +	 * pointers obtained by walking referenced PTR_TO_BTF_ID
> +	 * are appropriately invalidated when the lifetime of their
> +	 * parent object ends.
> +	 *
> +	 * Only one of ref_obj_id and parent_ref_obj_id can be set,
> +	 * never both at once.
> +	 */
> +	u32 parent_ref_obj_id;

How would it handle parent of parent?
Did you consider map_uid approach ?
Similar uid can be added for PTR_TO_BTF_ID.
Then every such pointer will be unique. Each deref will get its own uid.
I think the advantage of parent_ref_obj_id approach is that the program
can acquire a pointer through one kernel type, do some deref, and then
release it through a deref of other type. I'm not sure how practical is that
and it feels a bit dangerous.
