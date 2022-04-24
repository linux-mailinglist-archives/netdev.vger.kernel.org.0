Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CBC50D278
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 16:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbiDXO4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 10:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239480AbiDXO4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:56:19 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218DEDAA03
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 07:53:17 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id m20so4344302ejj.10
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 07:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PljnxRUh81pT/VZFsSxpCxfxThaMnEo3K5gwtxML1T4=;
        b=HPK1Fjl//ahLaP1lNA4NCbDVTK5dLYlXgM5pM42npxjQZKjO5L9/PdF8l7lGR+id0d
         ZnvgI0tC1zbFtZrmiJK2y52v84g9Y+w0AF5Zt9IAPvXJ1gHzny119IxGNvrK+e3TYJ4u
         Y8rptqx/qBwsXxnS7f3mTiPtWUBlHBlQ8JkfVLwxpVb/UrRFErhEaZRwiX5S5Rv6vPXW
         VQNWs1UCCJCC+rblI5xV7mDQLGIlW1+IdMc9fRmwH3q4frHl5f/WsbO1PmH/Hc+HBLm+
         UOmY6g+Q/jK77zTLxpstRUKCEecv/HgTLR/EgcdKccd6Gp1y71jMUnHcF/iHoANcNRBN
         BFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PljnxRUh81pT/VZFsSxpCxfxThaMnEo3K5gwtxML1T4=;
        b=Mayp2yB0qyGJCDUE/D3miy4rbUelUfsqo4ZG8wusGvbd4W0XVYH2uVCdF2S9oGQXuZ
         7C7wKMos9daSHODfUqNAlCeCJGHhtfvEVhlGpwSQR8t+7WG1orHMrIBdgFIkhpEIC0MP
         PO3Il+HOnnvtRCJtJDZarjppwH8v2FjodTf9J0g/UPLllYldgqTBasMyGZbim0dgOt9U
         0wipngddl7ZDZlZn4sgyfyMkcDYYbfeCtbqUUyK9OuIktHuSkoKKM8wadDbPwtJrFA7F
         XBn7k+ZTU/+AnWwkB5X6/q+qNXuBgqc5xY2ilHM1J+EgRq0izKMX7soffab7NFYF3Aut
         NwDA==
X-Gm-Message-State: AOAM5321AVKnvYY6th7u0103hzPaFdQNBDTJ3g5U53coDEa0RCrfkjhH
        eXspASt8BszOAVLNBk3QFYyRefLrOGoydvpqQ4Q=
X-Google-Smtp-Source: ABdhPJxP6gdki3QWyI62X0hWhCeuw+jp1SO/FmJ3sHN5jeLes6QLGVCoRpETcIf1m/9BtNHG/zYBEg==
X-Received: by 2002:a17:907:6e25:b0:6f0:99d4:9711 with SMTP id sd37-20020a1709076e2500b006f099d49711mr12019128ejc.511.1650811995192;
        Sun, 24 Apr 2022 07:53:15 -0700 (PDT)
Received: from leoy-ThinkPad-X240s ([104.245.96.34])
        by smtp.gmail.com with ESMTPSA id gz15-20020a170906f2cf00b006f3802a963fsm1161681ejb.21.2022.04.24.07.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 07:53:14 -0700 (PDT)
Date:   Sun, 24 Apr 2022 22:53:07 +0800
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
Subject: Re: [PATCH 3/3] perf test: Add perf_event_attr test for Arm SPE
Message-ID: <20220424145307.GE978927@leoy-ThinkPad-X240s>
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-4-timothy.hayes@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421165205.117662-4-timothy.hayes@arm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 21, 2022 at 05:52:05PM +0100, Timothy Hayes wrote:
> Adds a perf_event_attr test for Arm SPE in which the presence of
> physical addresses are checked when SPE unit is run with pa_enable=1.
> 
> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>

Reviewed-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>

> ---
>  tools/perf/tests/attr/README                         |  1 +
>  .../perf/tests/attr/test-record-spe-physical-address | 12 ++++++++++++
>  2 files changed, 13 insertions(+)
>  create mode 100644 tools/perf/tests/attr/test-record-spe-physical-address
> 
> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> index 454505d343fa..eb3f7d4bb324 100644
> --- a/tools/perf/tests/attr/README
> +++ b/tools/perf/tests/attr/README
> @@ -60,6 +60,7 @@ Following tests are defined (with perf commands):
>    perf record -R kill                           (test-record-raw)
>    perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
>    perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
> +  perf record -e arm_spe_0/pa_enable=1/ -- kill (test-record-spe-physical-address)
>    perf stat -e cycles kill                      (test-stat-basic)
>    perf stat kill                                (test-stat-default)
>    perf stat -d kill                             (test-stat-detailed-1)
> diff --git a/tools/perf/tests/attr/test-record-spe-physical-address b/tools/perf/tests/attr/test-record-spe-physical-address
> new file mode 100644
> index 000000000000..7ebcf5012ce3
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-spe-physical-address
> @@ -0,0 +1,12 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -e arm_spe_0/pa_enable=1/ -- kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event-10:base-record-spe]
> +# 622727 is the decimal of IP|TID|TIME|CPU|IDENTIFIER|DATA_SRC|PHYS_ADDR
> +sample_type=622727
> +
> +# dummy event
> +[event-1:base-record-spe]
> \ No newline at end of file
> -- 
> 2.25.1
> 
