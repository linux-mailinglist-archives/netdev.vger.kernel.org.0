Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C5041D08C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 02:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345939AbhI3A1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhI3A1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:27:46 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3548C06161C;
        Wed, 29 Sep 2021 17:26:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id r7so2910531pjo.3;
        Wed, 29 Sep 2021 17:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Si+enC3ihbndaFjWYETR7gIMhJfdbBupyIvK0yUlG0=;
        b=Qqb/LL7H/jUp5+4CORSup1uDFMEJExj0hpPudz6PLpmFU9R6KfnmKMQ5+jv0rN53W0
         ycCkP+bMAPhy6gWQ3RaeaZ0nihsY4ndtp6DHsOYq1ww7QsLXIEWHlf4sZ0hB9ZbfDzE5
         /7qFCqcKem+TX2Bw+CEaPa3UjLpQHLB7sz0r6t1k0hYVwkvBxPizqbHX2Gn5zPzIs2gV
         O+nyJP57vZ8mf07DDkARL+Qsz+eXmDxwDU0cF3R4ijCx4UO6NoUkeTcgnzymxj0RTffu
         EAiaQD/50HPT5rzXu9JspUmZdfoVoxRX04XPlB+8+yxWk8BxqZoh+4DcxRYjF429FrSK
         UiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Si+enC3ihbndaFjWYETR7gIMhJfdbBupyIvK0yUlG0=;
        b=LYOMxr45ou+VVVOfizqM2l0vI/8hOcdaRibu5PjuS/rI/mlltNDqhGqFKlzMkhflQ5
         K0cYYcVeNjJfYH7NycOCia2nVsR/vhe6twW5O3RK0CYgP2ldfRaPmEjnj+TAAMZNbTZ9
         PhXPVrBIRFf/fADBP0HYETxI/QD0fnnAKiSNutf/c6R/+IFBFSmBLS255+oazlH4VP7r
         yFNXziDJzqgrTF3/Y0ieh6OkOvjsZzFb3MfACOl9wgNd6vxbiPWi1jcePiJ40UbBLA77
         0WZxAkNg3lb0FSaV0KH1dn067LtOu0i/d7YlcMdNpb4UQf+cPxSTaQGZJWPEFdq1JA03
         EDbg==
X-Gm-Message-State: AOAM533Wx2/cuiCexpohPDCi6KmvZV4h87W6Mpm23mCu4wD/vLOMk5lx
        xX0oSrOPCRAz5rbnxUIWkt8=
X-Google-Smtp-Source: ABdhPJy4tkGHHk2Kf9F3yXWhc990GBPIZiEhEPIfJ6XAnDu8vSbGcSpSKmA+ekN3zSmJxNcb9sml0g==
X-Received: by 2002:a17:903:11cd:b0:13e:596c:d9a7 with SMTP id q13-20020a17090311cd00b0013e596cd9a7mr2591273plh.37.1632961564313;
        Wed, 29 Sep 2021 17:26:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b10sm806698pfi.122.2021.09.29.17.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 17:26:03 -0700 (PDT)
Subject: Re: [RFC PATCH v2 04/13] bpf: Define a few bpf_link_ops for
 BPF_TRACE_MAP
To:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
 <20210929235910.1765396-5-jevburton.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1c148ba0-0b74-2d48-c94b-3e7ea42e8238@gmail.com>
Date:   Wed, 29 Sep 2021 17:26:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929235910.1765396-5-jevburton.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/21 4:59 PM, Joe Burton wrote:
> From: Joe Burton <jevburton@google.com>
> 
> Define release, dealloc, and update_prog for the new tracing programs.
> Updates are protected by a single global mutex.
> 
> Signed-off-by: Joe Burton <jevburton@google.com>
> ---
>  kernel/bpf/map_trace.c | 71 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
> index 7776b8ccfe88..35906d59ba3c 100644
> --- a/kernel/bpf/map_trace.c
> +++ b/kernel/bpf/map_trace.c
> @@ -14,6 +14,14 @@ struct bpf_map_trace_target_info {
>  static struct list_head targets = LIST_HEAD_INIT(targets);
>  static DEFINE_MUTEX(targets_mutex);
>  
> +struct bpf_map_trace_link {
> +	struct bpf_link link;
> +	struct bpf_map *map;
> +	struct bpf_map_trace_target_info *tinfo;
> +};
> +
> +static DEFINE_MUTEX(link_mutex);
> +
>  int bpf_map_trace_reg_target(const struct bpf_map_trace_reg *reg_info)
>  {
>  	struct bpf_map_trace_target_info *tinfo;
> @@ -77,3 +85,66 @@ int bpf_map_initialize_trace_progs(struct bpf_map *map)
>  	return 0;
>  }
>  
> +static void bpf_map_trace_link_release(struct bpf_link *link)
> +{
> +	struct bpf_map_trace_link *map_trace_link =
> +			container_of(link, struct bpf_map_trace_link, link);
> +	enum bpf_map_trace_type trace_type =
> +			map_trace_link->tinfo->reg_info->trace_type;
> +	struct bpf_map_trace_prog *cur_prog;
> +	struct bpf_map_trace_progs *progs;
> +
> +	progs = map_trace_link->map->trace_progs;
> +	mutex_lock(&progs->mutex);
> +	list_for_each_entry(cur_prog, &progs->progs[trace_type].list, list) {

You might consider using list_for_each_entry_safe(), or ...

> +		if (cur_prog->prog == link->prog) {
> +			progs->length[trace_type] -= 1;
> +			list_del_rcu(&cur_prog->list);
> +			kfree_rcu(cur_prog, rcu);

or add a break; if you do not expect to find multiple entries.

> +		}
> +	}
> +	mutex_unlock(&progs->mutex);
> +	bpf_map_put_with_uref(map_trace_link->map);
> +}
> +
> +static void bpf_map_trace_link_dealloc(struct bpf_link *link)
> +{
> +	struct bpf_map_trace_link *map_trace_link =
> +			container_of(link, struct bpf_map_trace_link, link);
> +
> +	kfree(map_trace_link);
> +}
> +
> +static int bpf_map_trace_link_replace(struct bpf_link *link,
> +				      struct bpf_prog *new_prog,
> +				      struct bpf_prog *old_prog)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&link_mutex);
> +	if (old_prog && link->prog != old_prog) {
> +		ret = -EPERM;
> +		goto out_unlock;
> +	}
> +
> +	if (link->prog->type != new_prog->type ||
> +	    link->prog->expected_attach_type != new_prog->expected_attach_type ||
> +	    link->prog->aux->attach_btf_id != new_prog->aux->attach_btf_id) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}
> +
> +	old_prog = xchg(&link->prog, new_prog);
> +	bpf_prog_put(old_prog);
> +
> +out_unlock:
> +	mutex_unlock(&link_mutex);
> +	return ret;
> +}
> +
> +static const struct bpf_link_ops bpf_map_trace_link_ops = {
> +	.release = bpf_map_trace_link_release,
> +	.dealloc = bpf_map_trace_link_dealloc,
> +	.update_prog = bpf_map_trace_link_replace,
> +};
> +
> 
