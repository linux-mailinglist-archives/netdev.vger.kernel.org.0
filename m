Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEC625F954
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 13:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgIGLZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 07:25:23 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52626 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728588AbgIGLZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 07:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599477910;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DVXpD394ENZfUXuAbhjrpM4nV+8/n/+Aiiu1MAlDqfY=;
        b=baiRR+HEK99LG8kiq3biikFJQlm3wjJzYRgTRoww/MgtrlDTpLtZSoJSK9LNY9kfdj364V
        jy+AVP8kUi/bKbICpM0kyDHs1bqQrtpBa62ZUAwdyr1YwtLfCPwaNqnViyDP/wmeTaqIvR
        9gBk4uV81i+Pvx7nwZs6FMva2x/vtWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-2AYx_M5GO3KM1K91XFl6cQ-1; Mon, 07 Sep 2020 07:05:58 -0400
X-MC-Unique: 2AYx_M5GO3KM1K91XFl6cQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4599C2FD0B;
        Mon,  7 Sep 2020 11:05:56 +0000 (UTC)
Received: from krava (ovpn-112-180.ams2.redhat.com [10.36.112.180])
        by smtp.corp.redhat.com (Postfix) with SMTP id 682E29CBA;
        Mon,  7 Sep 2020 11:05:50 +0000 (UTC)
Date:   Mon, 7 Sep 2020 13:05:49 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH] perf tools: Do not use deprecated bpf_program__title
Message-ID: <20200907110549.GI1199773@krava>
References: <20200907110237.1329532-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907110237.1329532-1-jolsa@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 01:02:37PM +0200, Jiri Olsa wrote:
> The bpf_program__title function got deprecated in libbpf,
> use the suggested alternative.
> 
> Fixes: 521095842027 ("libbpf: Deprecate notion of BPF program "title" in favor of "section name"")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Arnaldo,
the commit in 'Fixes' is not yet in your tree yet and the patch
below will make the perf compilation fail in your perf/core..

it fixes perf compilation on top of bpf-next tree.. so I think it
should go in through bpf-next tree

thanks,
jirka

> ---
>  tools/perf/util/bpf-loader.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index 2feb751516ab..73de3973c8ec 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -328,7 +328,7 @@ config_bpf_program(struct bpf_program *prog)
>  	probe_conf.no_inlines = false;
>  	probe_conf.force_add = false;
>  
> -	config_str = bpf_program__title(prog, false);
> +	config_str = bpf_program__section_name(prog);
>  	if (IS_ERR(config_str)) {
>  		pr_debug("bpf: unable to get title for program\n");
>  		return PTR_ERR(config_str);
> @@ -454,7 +454,7 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
>  	if (err) {
>  		const char *title;
>  
> -		title = bpf_program__title(prog, false);
> +		title = bpf_program__section_name(prog);
>  		if (!title)
>  			title = "[unknown]";
>  
> -- 
> 2.26.2
> 

