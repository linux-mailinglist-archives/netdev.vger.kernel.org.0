Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8BF6584460
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiG1QvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiG1QvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:51:10 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FFEF21246;
        Thu, 28 Jul 2022 09:51:09 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id f11so1967125pgj.7;
        Thu, 28 Jul 2022 09:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=g2JvEqu4lPB/13fJF7Pbh4plTZKsg+4Z5jgyLFAQt2M=;
        b=Vde+gVxL9KlBhtfP9xUCLxMLGERnDOtm6qMfUz5TxxyQX2iBoFvmbzpnli5CQPLA+U
         fflE7YnPv0y9SVveELW2O1oVzGvj8oebdlInFI/DBAp0Z+9MHqxz6DAWcSH+WUb+ddt/
         awmZOPhtYxRGWWM+b6gc8Y0q42/iKXOdATHyWtMU5oz00Wwmr1mP9eIo6zSEA90eUVnD
         buCqmiwqL01yysHQy15AatDCFXTlbY+vvyCJy4D/a97t1MZGhnG8N9KuocMStGJe2Y3s
         L9cpmldbhJlj2y9yg1BzYizbubsK+b/HJzWEeknAdptsFvxXuedLV4dDtPBysJD0v6Tc
         J0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=g2JvEqu4lPB/13fJF7Pbh4plTZKsg+4Z5jgyLFAQt2M=;
        b=x/KvZKD/yGuL3zL1p2jhf24AbyVn6oFBO4k5CSX8d3wUGdQyQEZUs1AlN5GQK30Wdd
         ULPBSmThbmpvlS1Bqy9h5p89VnfSXOhCr/szFvsthqNpJM1Ty1O5kva17SaGvAvOntOX
         c1bcpiH5VdCXpoQ9eWAiYFh+amKSpipgrJGIbzRmT34TT+NE69r/O41Xeb4EBhTqRm2t
         WRvSDwgJv4YtaSvT5xmFO6BBjqqFxTIoBwwt//vw0QBUHvnzTKVUi16qUkK/+ZyH1hFG
         KDQfKRXypbg0HsB/OlaCGmg8nTGvN9yAZ4wViyaFK7HMVgjfL2humTKHuvad7y75sqAH
         Je/Q==
X-Gm-Message-State: AJIora8vsUHmH7Z4jziBQbHDhJZaTsfYMHkXCB4E7yXmR8zILrggWiNo
        ViYKIJHhVUAL4q8oVcM4NPg=
X-Google-Smtp-Source: AGRyM1t1fADbNQh3PuuzPfqOUvnAvPysscOkvBgHrmjjYhYYarFiFhqmCTyXrSKD4YLNMs9XP1Bmvw==
X-Received: by 2002:a63:171d:0:b0:41a:b564:a1d6 with SMTP id x29-20020a63171d000000b0041ab564a1d6mr22352367pgl.109.1659027068889;
        Thu, 28 Jul 2022 09:51:08 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id n9-20020a056a00212900b0052844157f09sm1021013pfj.51.2022.07.28.09.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 09:51:08 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 28 Jul 2022 06:51:06 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Message-ID: <YuK+eg3lgwJ2CJnJ@slm.duckdns.org>
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220722174829.3422466-5-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Jul 22, 2022 at 05:48:25PM +0000, Yosry Ahmed wrote:
> +
> +	/* cgroup_iter walks either the live descendants of a cgroup subtree, or the
> +	 * ancestors of a given cgroup.
> +	 */
> +	struct {
> +		/* Cgroup file descriptor. This is root of the subtree if walking
> +		 * descendants; it's the starting cgroup if walking the ancestors.
> +		 * If it is left 0, the traversal starts from the default cgroup v2
> +		 * root. For walking v1 hierarchy, one should always explicitly
> +		 * specify the cgroup_fd.
> +		 */
> +		__u32	cgroup_fd;

So, we're identifying the starting point with an fd.

> +		__u32	traversal_order;
> +	} cgroup;
>  };
>  
>  /* BPF syscall commands, see bpf(2) man-page for more details. */
> @@ -6136,6 +6156,16 @@ struct bpf_link_info {
>  					__u32 map_id;
>  				} map;
>  			};
> +			union {
> +				struct {
> +					__u64 cgroup_id;
> +					__u32 traversal_order;
> +				} cgroup;

but iterating the IDs. IDs are the better choice for cgroup2 as there's
nothing specific to the calling program or the fds it has, but I guess this
is because you want to use it for cgroup1, right? Oh well, that's okay I
guess.

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
