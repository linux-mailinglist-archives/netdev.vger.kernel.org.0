Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25B084ECE12
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiC3UjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiC3UjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:39:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA95BCAC;
        Wed, 30 Mar 2022 13:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C96AB81D51;
        Wed, 30 Mar 2022 20:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F21FC340EE;
        Wed, 30 Mar 2022 20:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648672638;
        bh=2OeXterTVdG7yZJXGHnJmgP6K9/UMkU1Gwb3/aTD6Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RcZ/gxFiJ4jah5Bwk/7kOBZesy+FNqv7pBPsz8dpalrp2pd63GWLQUzI5nZFEqNWw
         7t8IswFJpHM0FTsN7evQzK9Kmw6KOUgSfpqm7/AwuIHFmPO4yXC82pHwXKj2+VO7V1
         RvTpvHUc+aNitaBUZg5zHoWfAG8b1cqm2woM7Lw1zMsEeJbua9DkmClV1puYbYkdAa
         pUnkIU652p9OFxTyGvTfzjEpMfaIqtgKqW5bVtc14hNuDuL3nH+lECM5dgzD6e0ZT4
         S2r/UHFi7pewkNmXnt1wJ17gdpXhq46aNSOfAaThVwYDsDy7hpg5c7khsyDOkprEC7
         ePwJn5LSX6llQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id DEFB640407; Wed, 30 Mar 2022 17:37:15 -0300 (-03)
Date:   Wed, 30 Mar 2022 17:37:15 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     peterz@infradead.org, mingo@redhat.com, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf evlist: Directly return instead of using local ret
 variable
Message-ID: <YkS/ez1o9QC2AcJ5@kernel.org>
References: <1648432532-23151-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648432532-23151-1-git-send-email-baihaowen@meizu.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Mar 28, 2022 at 09:55:32AM +0800, Haowen Bai escreveu:
> fixes coccinelle warning:
> ./tools/perf/util/evlist.c:1333:5-8: Unneeded variable: "err". Return
> "- ENOMEM" on line 1358

Thanks, applied.

- Arnaldo

 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  tools/perf/util/evlist.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 9bb79e0..1883278 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1330,7 +1330,6 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
>  {
>  	struct perf_cpu_map *cpus;
>  	struct perf_thread_map *threads;
> -	int err = -ENOMEM;
>  
>  	/*
>  	 * Try reading /sys/devices/system/cpu/online to get
> @@ -1355,7 +1354,7 @@ static int evlist__create_syswide_maps(struct evlist *evlist)
>  out_put:
>  	perf_cpu_map__put(cpus);
>  out:
> -	return err;
> +	return -ENOMEM;
>  }
>  
>  int evlist__open(struct evlist *evlist)
> -- 
> 2.7.4

-- 

- Arnaldo
