Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4861E50D1C0
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 15:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiDXNDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 09:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiDXNDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 09:03:02 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F00F17E0C
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:00:00 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id be20so7181441edb.12
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 06:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xiS7jXTGQnjBRoWj5ugUGTqfRqlbiuFUwXWLNi1EeJU=;
        b=SoA9P8/6lxB7hLukKtbzsp9CZjR0hxa/1dGYCHYuHry7e1fzAxQ6TYBM8js3bDZUdT
         iOm61Ysfp+VWCcf+9mqf0kUzLrJUYw7YuJ15uXa1Qg/j5yGudMfYL9/jYojurUwjC/PT
         EF4eq9ZGJxtYkojhD+sVMg2nwuFOqrgxJSR6D5TaQWwjSD288Y4Ge6oKuMs4n8E7w6aM
         xlBuR90SsvtbwqDUVbaqEvYNuhXy9uc6zPZnL2UfwXO7tlG42uwMzk9iwiMgihzm2CQo
         Q3x7R66oab/+2CtRiaVN33ycNZmpYEmz8Y7GZZ01aEkb9YareOofyAESNR8hK7Nytuwx
         horA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xiS7jXTGQnjBRoWj5ugUGTqfRqlbiuFUwXWLNi1EeJU=;
        b=rhLJz2rlUYQcHf99dA9bs18Wz7MI6jOBNFmcPsShzyN8XoFjv3M8auGuWX1/hUUskX
         STmjZAcL835t/RyDUf1eD8lBAwfsq47ygwcwhqmi3xzY6mkTejKau7qkpWYHIUGNq/Rm
         CD+Nrnnxn1t1pyysyAOplfP7YdTtHtSNvoJ+uHyVvs5HBsGU6Tb0i7/BFFYzJIAGdhEd
         zxrHT6haPt4T37BOajdqiLTSNvDAmJoI93/8gDqdhiVVtf0s5LbB2VLYQx/WxjrYb7JQ
         rXnYaG/tTcrTakNjWxhqvZH3JRJLIlD8QWBqA9xOHwi/gbg2s5OnSfCcSY5N2Uiw+33n
         xB+g==
X-Gm-Message-State: AOAM533HwSM+Lxbb+WeIyybBJeJGCmRzoj2MQBHWNyUCWXdwb8YzxxsZ
        3qpi1PRiUH1zwQQXue9rirSpeg==
X-Google-Smtp-Source: ABdhPJzWd6TnX8cfWuoEpPnonVAdlLmH1faYJGpdsybfh5SgAIg5RUp8Wh3mjpXz0jixZJTcziCJFw==
X-Received: by 2002:a05:6402:2985:b0:425:d51f:ae4 with SMTP id eq5-20020a056402298500b00425d51f0ae4mr6102711edb.379.1650805198838;
        Sun, 24 Apr 2022 05:59:58 -0700 (PDT)
Received: from leoy-ThinkPad-X240s ([104.245.96.34])
        by smtp.gmail.com with ESMTPSA id y14-20020a056402440e00b00416046b623csm3408984eda.2.2022.04.24.05.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 05:59:58 -0700 (PDT)
Date:   Sun, 24 Apr 2022 20:59:51 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Timothy Hayes <timothy.hayes@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH 2/3] perf: arm-spe: Fix SPE events with phys addresses
Message-ID: <20220424125951.GD978927@leoy-ThinkPad-X240s>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-3-timothy.hayes@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421165205.117662-3-timothy.hayes@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Timothy,

On Thu, Apr 21, 2022 at 05:52:04PM +0100, Timothy Hayes wrote:
> This patch corrects a bug whereby SPE collection is invoked with
> pa_enable=1 but synthesized events fail to show physical addresses.
> 
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
> ---
>  tools/perf/arch/arm64/util/arm-spe.c | 10 ++++++++++
>  tools/perf/util/arm-spe.c            |  3 ++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
> index af4d63af8072..e8b577d33e53 100644
> --- a/tools/perf/arch/arm64/util/arm-spe.c
> +++ b/tools/perf/arch/arm64/util/arm-spe.c
> @@ -148,6 +148,7 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
>  	bool privileged = perf_event_paranoid_check(-1);
>  	struct evsel *tracking_evsel;
>  	int err;
> +	u64 bit;
>  
>  	sper->evlist = evlist;
>  
> @@ -245,6 +246,15 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
>  	 */
>  	evsel__set_sample_bit(arm_spe_evsel, DATA_SRC);
>  
> +	/*
> +	 * The PHYS_ADDR flag does not affect the driver behaviour, it is used to
> +	 * inform that the resulting output's SPE samples contain physical addresses
> +	 * where applicable.
> +	 */
> +	bit = perf_pmu__format_bits(&arm_spe_pmu->format, "pa_enable");
> +	if (arm_spe_evsel->core.attr.config & bit)
> +		evsel__set_sample_bit(arm_spe_evsel, PHYS_ADDR);
> +
>  	/* Add dummy event to keep tracking */
>  	err = parse_events(evlist, "dummy:u", NULL);
>  	if (err)
> diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
> index 151cc38a171c..1a80151baed9 100644
> --- a/tools/perf/util/arm-spe.c
> +++ b/tools/perf/util/arm-spe.c
> @@ -1033,7 +1033,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>  	attr.size = sizeof(struct perf_event_attr);
>  	attr.type = PERF_TYPE_HARDWARE;
> -	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
> +	attr.sample_type = evsel->core.attr.sample_type &
> +				(PERF_SAMPLE_MASK | PERF_SAMPLE_PHYS_ADDR);

I verified this patch and I can confirm the physical address can be
dumped successfully.

I have a more general question, seems to me, we need to change the
macro PERF_SAMPLE_MASK in the file util/event.h as below, so
here doesn't need to 'or' the flag PERF_SAMPLE_PHYS_ADDR anymore.

@Arnaldo, @Jiri, could you confirm if this is the right way to move
forward?  I am not sure why PERF_SAMPLE_MASK doesn't contain the bit
PERF_SAMPLE_PHYS_ADDR in current code.

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cdd72e05fd28..c905ac32ebad 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -39,7 +39,7 @@ struct perf_event_attr;
         PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |          \
        PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |        \
         PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |         \
-        PERF_SAMPLE_IDENTIFIER)
+        PERF_SAMPLE_IDENTIFIER | PERF_SAMPLE_PHYS_ADDR)

Thanks,
Leo

>  	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
>  			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
>  			    PERF_SAMPLE_WEIGHT | PERF_SAMPLE_ADDR;
> -- 
> 2.25.1
> 
