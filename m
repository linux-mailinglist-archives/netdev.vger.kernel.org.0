Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFBD5A1AEB
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbiHYVSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiHYVSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:18:39 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E47B8F1E;
        Thu, 25 Aug 2022 14:18:38 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-11cb3c811d9so24899618fac.1;
        Thu, 25 Aug 2022 14:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wv7F1mURVOPFUom8cOskUJUVZTeDHF4qcxmAIjgMKDI=;
        b=RE9t++IdjxvmNeggjbdrxzgXjVah9qfoCNYahdWLDB5ZVXGzt7lcP+GPf+FGzVLE1O
         gOECla9RlVFCwIXymW8ecrC8+U/DR81uM9rITYzhmYLzqEWwh9dxUQkY+ynPUSvnNdwc
         YcaoW6pwr3358Yf7Q8MW0P/1IE18TnhYt5moukUtXW2m9cj8aWDLbHWMf84hJBwlXAi/
         5GzxiefJT2tiLolOJivqM4XT88FPOqIETIuzWwUO+xZpSJEXnZxpnjKYBUoebwBerJtB
         CbjHU2l13S8Ci8goQCmZv0SBpAFpscmYAKX8uRVe/eu6EpqR0Cn3cDZc2gcDj/L37uN0
         +sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wv7F1mURVOPFUom8cOskUJUVZTeDHF4qcxmAIjgMKDI=;
        b=T/1MBE28djklILrgvDxWStT0RVWMvBZ+UxDqSmQHWmX9CrxVIELj9cqYwDuggx8mYt
         dK2vm8GhUgoovRqm/GZXCqVl4Rn23A+J4W6cjlrJnr9W8O4b7wcxDx+sSq2wisQqY8U5
         C25xgGwRsCSyG3hgNxW2cR5KFi5Tbi2qlj2c/BEqVK3E0kDMcX1Cs6HLwg9IYotEEysb
         HM5Bj6VWwceuI6QfVXQdKf2/VnpynJVUJY0sByvLa54Iy1Y/BWId0tmQaRESw3jjW1n7
         hwhHW82QBKrQ2wWzBSeyKYqjEg2oFdnGEvyQN4hrq1hjOyyvRoFSfsH68q2Qbn8ACfrR
         NfQw==
X-Gm-Message-State: ACgBeo1y+FhW570TPXIAuWZrUntXj+20hh7YZVU9wrhS7VMmftd8/Elw
        XJ7qMuno3FBjlpUH/0a6kSfrskhCN0Y=
X-Google-Smtp-Source: AA6agR7+d+x2j3iCLme/svKGo8nGeHP5lzSv0lKMR/4QBSF7TjSXpSmFoP4EyF2B9dXr8mhVN1At1g==
X-Received: by 2002:a05:6870:4608:b0:10e:2c6:afa2 with SMTP id z8-20020a056870460800b0010e02c6afa2mr409480oao.149.1661462317631;
        Thu, 25 Aug 2022 14:18:37 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id c38-20020a9d27a9000000b0061c80e20c7dsm46888otb.81.2022.08.25.14.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:18:37 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:16:25 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 6/9] sched/core: Merge cpumask_andnot()+for_each_cpu()
 into for_each_cpu_andnot()
Message-ID: <YwfmqT70LsZmCiiG@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-7-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825181210.284283-7-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 07:12:07PM +0100, Valentin Schneider wrote:
> This removes the second use of the sched_core_mask temporary mask.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>

Suggested-by: Yury Norov <yury.norov@gmail.com>

> ---
>  kernel/sched/core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ee28253c9ac0..b4c3112b0095 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -360,10 +360,7 @@ static void __sched_core_flip(bool enabled)
>  	/*
>  	 * Toggle the offline CPUs.
>  	 */
> -	cpumask_copy(&sched_core_mask, cpu_possible_mask);
> -	cpumask_andnot(&sched_core_mask, &sched_core_mask, cpu_online_mask);
> -
> -	for_each_cpu(cpu, &sched_core_mask)
> +	for_each_cpu_andnot(cpu, cpu_possible_mask, cpu_online_mask)
>  		cpu_rq(cpu)->core_enabled = enabled;
>  
>  	cpus_read_unlock();
> -- 
> 2.31.1
