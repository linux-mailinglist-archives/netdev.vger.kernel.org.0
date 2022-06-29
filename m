Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DA955F40E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 05:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiF2DXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 23:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiF2DXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 23:23:23 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9572C1161;
        Tue, 28 Jun 2022 20:23:08 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id k14so12853832plh.4;
        Tue, 28 Jun 2022 20:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NxEYTV5XaHlvQ6SClhq7DbGXKrVTnCi9AeoTaN417P4=;
        b=LC+jLqtg/KFZgUbUa1pd6NdegM0TT6JQEuJS6HAqrQoQOYSZyiMXXEuYErJZH0lxBc
         Rgpj/IvgLgNBYEg5EFdpawHtGDP5qG9fVoMtOjYQqZ9qeHhWRZW1FlRov4ZVKiapsscR
         W8VV9enNv+1BzDOKmRo4xDUTPAO8QDMo7DsxguKW2vbcYJ9GTsEaFRaBVo7UrDTE2yvv
         UwWeWaknK4yi0AQV/bPVjgro7B8YxfKCe9lhjMWXtnMfG29pNlxWmeVbpj5Yd3bhxXgu
         vghC5LxJ9ToX+CLAHv8RyLGuyI6d0YcDfj3hh3IZcFsfdnmA5PltqU249zOLm5cTEuBv
         24cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NxEYTV5XaHlvQ6SClhq7DbGXKrVTnCi9AeoTaN417P4=;
        b=7Ut5M8C7uyOr5HQdyvLJbRBBqLpIt+d0FdwJkHDCWh8mUsZGzv+tDvlSMwf6p7nddV
         kCuSXjFusjuWNcy8dUkK83dghAX1cG2WIVszY/Pk25+3UGDWn5FA6XPfO4uQdvsL1r2z
         QGsGhsVvarcxv0/kZDyYxNYX1F0WSbaGLNgSyq8ULAqlEnjJPaVEktv4wLCSddu3g3/+
         CzS0AGFw+LdKeyhxPFGtlFnjzq2qzbq2Eei6dojTROSC9RrhOm8xTdpjd3adiVjbNqqd
         B6GgtpEP73Q6c3cY7ILLiBDllZaSVGlwkJHsOMP9TulEIj2OAeTgGkwW1j+tIlMAN0ma
         RriQ==
X-Gm-Message-State: AJIora+M2IoaN268ODQFV13GK+Lm3EpLrKo7CttOIBgzDem5C4P5qlAB
        agKhhc61sCvBPR3GNF0T0hw=
X-Google-Smtp-Source: AGRyM1s8T50ZrH+JFuqnAVZSZInwjmbYfb1FtxQ49H5wx8jAm+7e7flb83p2EDjiT+JAYTYo1op1ow==
X-Received: by 2002:a17:90b:503:b0:1e2:f129:5135 with SMTP id r3-20020a17090b050300b001e2f1295135mr1404738pjz.22.1656472987950;
        Tue, 28 Jun 2022 20:23:07 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:28a7])
        by smtp.gmail.com with ESMTPSA id a20-20020a170903101400b001641670d1adsm10022345plb.131.2022.06.28.20.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 20:23:07 -0700 (PDT)
Date:   Tue, 28 Jun 2022 20:23:04 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 1/8] bpf: Add support for forcing kfunc args
 to be referenced
Message-ID: <20220629032304.h5ck7tizbfehiwut@macbook-pro-3.dhcp.thefacebook.com>
References: <20220623192637.3866852-1-memxor@gmail.com>
 <20220623192637.3866852-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623192637.3866852-2-memxor@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 12:56:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> Similar to how we detect mem, size pairs in kfunc, teach verifier to
> treat __ref suffix on argument name to imply that it must be a
> referenced pointer when passed to kfunc. This is required to ensure that
> kfunc that operate on some object only work on acquired pointers and not
> normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> walking. Release functions need not specify such suffix on release
> arguments as they are already expected to receive one referenced
> argument.
> 
> Note that we use strict type matching when a __ref suffix is present on
> the argument.
... 
> +		/* Check if argument must be a referenced pointer, args + i has
> +		 * been verified to be a pointer (after skipping modifiers).
> +		 */
> +		arg_ref = is_kfunc_arg_ref(btf, args + i);
> +		if (is_kfunc && arg_ref && !reg->ref_obj_id) {
> +			bpf_log(log, "R%d must be referenced\n", regno);
> +			return -EINVAL;
> +		}
> +

imo this suffix will be confusing to use.
If I understand the intent the __ref should only be used
in acquire (and other) kfuncs that also do release.
Adding __ref to actual release kfunc will be a nop.
It will be checked, but it's not necessary.

At the end
+struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct__ref)
will behave like kptr_xchg with exception that kptr_xchg takes any btf_id
while here it's fixed.

The code:
 if (rel && reg->ref_obj_id)
        arg_type |= OBJ_RELEASE;
should probably be updated with '|| arg_ref'
to make sure reg->off == 0 ?
That looks like a small bug.

But stepping back... why __ref is needed ?
We can add bpf_ct_insert_entry to acq and rel sets and it should work?
I'm assuming you're doing the orthogonal cleanup of resolve_btfid,
so we will have a single kfunc set where bpf_ct_insert_entry will
have both acq and rel flags.
I'm surely missing something.
