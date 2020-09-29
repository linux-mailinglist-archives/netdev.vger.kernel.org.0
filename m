Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64A27B8A0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgI2AF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgI2AF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 20:05:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36F1C0613D3;
        Mon, 28 Sep 2020 17:05:25 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id q123so2791047pfb.0;
        Mon, 28 Sep 2020 17:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ky3GHtUnDiMuVik4STrZUm38B7aK49ldf1V6Z9L4Zdk=;
        b=s9j2J2aXKxp1g4LHwnttUUWGL3N3AtPQaXmu9BaPu5BPu47hGJozo37+boZn0QXXc/
         6ogcH2XWQ1/uPvRTu7AgAHUna4dSVfXnYKrXv8q5VXVQSeUS8z2flRjrXdj7AkrRALih
         SVvD3b+PegqDDBm9n6EvjHy/XpPiC9hCv7LqCI+DDQ7jCand9W4CPWNGhqW8AgxWswch
         CnzVArZQ9PvOySsSeA2lBrv2xprA7o3mCQY1mqAnQSWiH2DWDbFqyYKuyqUo327gAcSE
         G/WxsZ2jl7m88rVrgpzxTr96P79sUVlEGKhlr+wh7PltM3JuAC1HNBQ1zAkNhkUsgUGx
         rREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ky3GHtUnDiMuVik4STrZUm38B7aK49ldf1V6Z9L4Zdk=;
        b=MedXJTV6g5CAYdiNWzAUCfN8scuIwLIwcNVzNieUUTxBxDNe3u8akb+q7Ccp39nJd9
         mCnpxlgz8Y3T6XHxT0BbrvYWvqKBRJbZ5Kpb7bclHYYP3dyv3RtgmE7mbsNSluHtO7NB
         jj9B8LEhdMhnlIc4k6xGmb4HRyLQPU8rw1sW71XtUj8WUM7f5Pwqk1Z3TmNbcnyU/iPb
         5X81TIgVuTUySJwGVSeSAcHH9paSkq/EGz1pZ/kJYtpKtIT+A+KHPTaGb0YMAxhI1/FH
         gNz1xRMU90Qmkt9kT7Z5GgLBG1dz0MRVURRytirekDsBksAiaohImYGE8GymHnuGRZb5
         n3/g==
X-Gm-Message-State: AOAM5335qoFDR2TCVgCNfic2K50x3epBrZ8Hp4MNe8x1FzpbVOylQvUk
        5jNseOCIO+4cV4yrRALStFA=
X-Google-Smtp-Source: ABdhPJwfknYYssFMj624Af5APdIzJrkQOq6bosw2DUg1lZ7mE5Pt1xm5/Uyov3Evxjyw1gfwpK8Uyg==
X-Received: by 2002:a62:cd49:0:b029:150:7742:c6c8 with SMTP id o70-20020a62cd490000b02901507742c6c8mr1598462pfg.61.1601337925417;
        Mon, 28 Sep 2020 17:05:25 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:8e77])
        by smtp.gmail.com with ESMTPSA id d12sm2306603pgd.93.2020.09.28.17.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 17:05:24 -0700 (PDT)
Date:   Mon, 28 Sep 2020 17:05:22 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v9 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
Message-ID: <20200929000522.n5g2hcahqjxwseye@ast-mbp.dhcp.thefacebook.com>
References: <160106909952.27725.8383447127582216829.stgit@toke.dk>
 <160106910382.27725.8204173893583455016.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160106910382.27725.8204173893583455016.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 11:25:03PM +0200, Toke Høiland-Jørgensen wrote:
>  
>  int bpf_check_attach_target(struct bpf_verifier_log *log,
>  			    const struct bpf_prog *prog,
> -			    const struct bpf_prog *tgt_prog,
> +			    const struct bpf_prog *dst_prog,

so you really did blind search and replace?
That's not at all what I was asking.
The function is called check_attach_target and the argument name
'tgt_prog' fits perfectly.

>  			    u32 btf_id,
>  			    struct bpf_attach_target_info *tgt_info);
>  
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 868c03a24d0a..faf57c6f8804 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3706,10 +3706,10 @@ struct btf *btf_parse_vmlinux(void)
>  
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>  {
> -	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> +	struct bpf_prog *dst_prog = prog->aux->dst_prog;

same here. tgt_prog fits just fine as a name.

>  
> -	if (tgt_prog) {
> -		return tgt_prog->aux->btf;
> +	if (dst_prog) {
> +		return dst_prog->aux->btf;
>  	} else {
>  		return btf_vmlinux;
>  	}
> @@ -3733,7 +3733,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		    struct bpf_insn_access_aux *info)
>  {
>  	const struct btf_type *t = prog->aux->attach_func_proto;
> -	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> +	struct bpf_prog *dst_prog = prog->aux->dst_prog;

here as well.
it's a tgt_prog being checked.

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 2740df19f55e..099a651efe8b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2154,14 +2154,14 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>  	prog->expected_attach_type = attr->expected_attach_type;
>  	prog->aux->attach_btf_id = attr->attach_btf_id;
>  	if (attr->attach_prog_fd) {
> -		struct bpf_prog *tgt_prog;
> +		struct bpf_prog *dst_prog;
>  
> -		tgt_prog = bpf_prog_get(attr->attach_prog_fd);
> -		if (IS_ERR(tgt_prog)) {
> -			err = PTR_ERR(tgt_prog);
> +		dst_prog = bpf_prog_get(attr->attach_prog_fd);
> +		if (IS_ERR(dst_prog)) {
> +			err = PTR_ERR(dst_prog);
>  			goto free_prog_nouncharge;
>  		}
> -		prog->aux->linked_prog = tgt_prog;
> +		prog->aux->dst_prog = dst_prog;

Here 'dst_prog' makes logical sense, but I wouldn't bother renaming.
You can keep this hunk, if you like.

>  int bpf_check_attach_target(struct bpf_verifier_log *log,
>  			    const struct bpf_prog *prog,
> -			    const struct bpf_prog *tgt_prog,
> +			    const struct bpf_prog *dst_prog,

pls keep it as 'tgt_prog' here and through the function.

>  static int check_attach_btf_id(struct bpf_verifier_env *env)
>  {
>  	struct bpf_prog *prog = env->prog;
> -	struct bpf_prog *tgt_prog = prog->aux->linked_prog;
> +	struct bpf_prog *dst_prog = prog->aux->dst_prog;

no need to rename either. It's a target program being checked.
