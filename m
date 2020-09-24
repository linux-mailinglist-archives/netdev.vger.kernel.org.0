Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304862764EB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 02:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIXAOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 20:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIXAOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 20:14:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536AAC0613CE;
        Wed, 23 Sep 2020 17:14:43 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d19so662765pld.0;
        Wed, 23 Sep 2020 17:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bT8+YI4bmy4AAbp3wIY/xwd6ruz4uupt5/kHQiMd+v0=;
        b=O4LKlBBcfhX6PeL4mDKjPke5zGOSBK92YOge1iuYL3i7FvlIkunokHalzEJAxnNVjl
         c/CaKJv48XgvCBeZMydVxSVKOIxxI5WP3TQdU6SrTErWUY88lhHxs6NJvWy+yE96MrpC
         Jaic6lOQxdwjd1RZ5+FOkXUy90x0JR0RqQx+p5lKqJSZe1zoLoe41leQhlHGYyIf0sG4
         ZTIsEnY6SrMMNyAWil6bwRMaHUvGIZvpUJzr3zs3ms4fy0JhChb2W2bI2UzWOsDKEGba
         bE+a1OYuawlAi2dvoyx4N/vkCYnMiTWE9f6lgwLnPQidwjMxfqRJScWRTPqtGFOPPlyA
         z5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bT8+YI4bmy4AAbp3wIY/xwd6ruz4uupt5/kHQiMd+v0=;
        b=dgGsB4WJP6v4Uwicma//q6cabubYZ5I0c9iJDsOVUFm9b/XGhDLr44Gb49FBAxpqmD
         DS5+MmjM6f7FbT3EcSK0nOH1fJTtCNaCHKVC5cCQrRtAnkx7y+TCF6X8GC7N+oKJNjs2
         UfCIuauv5yrztInhpiEkmJ1HHwMwxLmWZcpve2S7SSuQL9QtQzEZvBTaTXvJoI1xZtY4
         Rv0VmO3kMsGKdQ4LpkJEyiOsy8X878Z4XAhHcBHHQs8G2u+CXnPTz9mHL8G3FGeOswAi
         ijF3/tPbvAcCDDj+CooYADGhabmNe4mPjbAKFLU791okgX3LXTQ62YVXWb3GaOfmBGCq
         Xwdw==
X-Gm-Message-State: AOAM530oQUyyTjVPpGkVVqz0ekJ5XGFoRcCBNsnSQHXNHzQP/0fF2zys
        o9lEMJG5UOrIuEGM6PfkoYRa49eWnCo=
X-Google-Smtp-Source: ABdhPJwukSnTWIKx8WaXmkoi/VV9I1EuTD+xktj8M6Hl1iInNiOzKeGU9kHYxnOIv4A66EEuNkIa5w==
X-Received: by 2002:a17:902:7281:b029:d2:2a0b:f050 with SMTP id d1-20020a1709027281b02900d22a0bf050mr2119346pll.42.1600906482682;
        Wed, 23 Sep 2020 17:14:42 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id u14sm720653pfc.203.2020.09.23.17.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 17:14:41 -0700 (PDT)
Date:   Wed, 23 Sep 2020 17:14:39 -0700
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
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
Message-ID: <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <160079991808.8301.6462172487971110332.stgit@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 08:38:38PM +0200, Toke Høiland-Jørgensen wrote:
> @@ -746,7 +748,9 @@ struct bpf_prog_aux {
>  	u32 max_rdonly_access;
>  	u32 max_rdwr_access;
>  	const struct bpf_ctx_arg_aux *ctx_arg_info;
> -	struct bpf_prog *linked_prog;

This change breaks bpf_preload and selftests test_bpffs.
There is really no excuse not to run the selftests.

I think I will just start marking patches as changes-requested when I see that
they break tests without replying and without reviewing.
Please respect reviewer's time.

> +	struct mutex tgt_mutex; /* protects tgt_* pointers below, *after* prog becomes visible */
> +	struct bpf_prog *tgt_prog;
> +	struct bpf_trampoline *tgt_trampoline;
>  	bool verifier_zext; /* Zero extensions has been inserted by verifier. */
>  	bool offload_requested;
>  	bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp */
...
>  struct bpf_tracing_link {
>  	struct bpf_link link;
>  	enum bpf_attach_type attach_type;
> +	struct bpf_trampoline *trampoline;
> +	struct bpf_prog *tgt_prog;

imo it's confusing to have 'tgt_prog' to mean two different things.
In prog->aux->tgt_prog it means target prog to attach to in the future.
Whereas here it means the existing prog that was used to attached to.
They kinda both 'target progs' but would be good to disambiguate.
May be keep it as 'tgt_prog' here and
rename to 'dest_prog' and 'dest_trampoline' in prog->aux ?

>  };
>  
>  static void bpf_tracing_link_release(struct bpf_link *link)
>  {
> -	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
> +	struct bpf_tracing_link *tr_link =
> +		container_of(link, struct bpf_tracing_link, link);
> +
> +	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog,
> +						tr_link->trampoline));
> +
> +	bpf_trampoline_put(tr_link->trampoline);
> +
> +	if (tr_link->tgt_prog)
> +		bpf_prog_put(tr_link->tgt_prog);

I had to scratch my head quite a bit before I understood this NULL check.
Could you add a comment saying that tr_link->tgt_prog can be NULL
when trampoline is for kernel function ?
