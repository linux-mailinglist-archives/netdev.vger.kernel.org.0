Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB0F479EC7
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhLSCR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhLSCR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:17:26 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E90C061574;
        Sat, 18 Dec 2021 18:17:26 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id q17so5172563plr.11;
        Sat, 18 Dec 2021 18:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qQ8Ew9mBF9z/DRnKMBFI6rAWxCp6gXAhEU1PXdc3WIY=;
        b=XP8wbBaXYgRfcOFRxrYV4Ugih/0UdURQt9MrjChSrgQ6CMgwhR2PN9wcCcex/CjvSs
         FeU7ydp8OJSy5DvaSwygQPRTGEvo+qSSvMmLCRVd86s5Uob2+U2tj4lgUcSdrttx7qZT
         05Uvsf3WqsW18YB0BZLfzqT2pY6IV4fjoyNahh7nfToDELmO0hFljYIZkR4u7/yNLa3r
         XjNmIQ6VUv63fbzpy7sOpkxTD+Tpj2Zc3MB8t3Y3OYtO2xBcebIkIFlDxDTdAaC19xok
         A7OsOC9AhneJ5+ZJc8hm/rdd68FnElORo5xxtI1FwBVUhuiJCCz4ryJn6+v8fc/+Z+RX
         LEJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qQ8Ew9mBF9z/DRnKMBFI6rAWxCp6gXAhEU1PXdc3WIY=;
        b=TQ9BZkQp+kMG9tUmM7VXAtGqJUkKcf4YBgSpWeamBNjQ3I56wqQ3yH2p4PJ8JkZi9M
         Le/+XhaH9R6EPMd5ydEs9A7HIdyXFzp/p+4AU+soajVbXqckqBSWPa0oJKIvx2n1zSbL
         g4zE2tZiM24VLn28Pte4AZP2aN4kfiqRaeQRCtk2shvHHazAnB4Sqsn7rOGXmp5MeZ5Z
         9kAW0ooas/ImxUf+YaBKMqOl5vIkR8XkSbCYdc7GY2Nj08Ns3j0JUZYvA+xLU44fHrCt
         1lGb01TfaZq1wSYCoG/OQrgcku36oYmcOHizvsmnJCSv/irX5QiEiVTXoUqyd3XUwF7p
         VF+A==
X-Gm-Message-State: AOAM532b1QhJhwknG2T3hA8v3rXXhURek9yHZdbZf71Ca1DRN+xIB5Am
        OQB/3j+EQG2QO0GcbwUZ6SA=
X-Google-Smtp-Source: ABdhPJw+dmNfkoRSjdsAsfAg0BHMSaN+NeBqWQTfJaspdbjVMjVjlVi134CC1IGHOTVCiagzd6UNeg==
X-Received: by 2002:a17:902:a70b:b0:148:a2e8:2793 with SMTP id w11-20020a170902a70b00b00148a2e82793mr10444246plq.154.1639880245814;
        Sat, 18 Dec 2021 18:17:25 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:e30])
        by smtp.gmail.com with ESMTPSA id r10sm12963745pff.120.2021.12.18.18.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 18:17:25 -0800 (PST)
Date:   Sat, 18 Dec 2021 18:17:22 -0800
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
Subject: Re: [PATCH bpf-next v4 03/10] bpf: Extend kfunc with PTR_TO_CTX,
 PTR_TO_MEM argument support
Message-ID: <20211219021722.yf4cnmar33lrpcje@ast-mbp>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-4-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-4-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:24AM +0530, Kumar Kartikeya Dwivedi wrote:
>  
> +/* Returns true if struct is composed of scalars, 4 levels of nesting allowed */
> +static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
> +					const struct btf *btf,
> +					const struct btf_type *t, int rec)
> +{
> +	const struct btf_type *member_type;
> +	const struct btf_member *member;
> +	u16 i;
> +
> +	if (rec == 4) {
> +		bpf_log(log, "max struct nesting depth 4 exceeded\n");
> +		return false;
> +	}

As Matteo found out that saves stack with gcc only,
so I moved this check few lines below, just before recursive call.

> +			if (is_kfunc) {
> +				/* Permit pointer to mem, but only when argument
> +				 * type is pointer to scalar, or struct composed
> +				 * (recursively) of scalars.
> +				 */
> +				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {

... and reformatted this line to fit screen width.

... and applied.

Please add individual selftest for this feature
(not tied into refcnted kfuncs and CT).
