Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1D473CCA
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhLNF4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhLNF4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:56:36 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D41C061574;
        Mon, 13 Dec 2021 21:56:35 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id v19so12820298plo.7;
        Mon, 13 Dec 2021 21:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NIM7gH+mWve7U4rqetzbz5Hnwl1+TH0EFEyUrpMHQUE=;
        b=R6W7a6zCSTaqnBmLYrEuhlQJ7Op0kMaP0shkF54FmD3QotmJ75+IjWmVV7g7Pqacom
         XFWTzljZdpf3hwjfyTwxsXGC+2UjwxGndyQbt9OOnSYiCF8QptVTyKG+EsJrp2AGT5nc
         eDh+p4pVLEFJlwF5osr5ERjwCnmbpnyp0QxvbKQTpXDDbTpgUdXH1BuaQC2I1KXMKclJ
         sfgCpuE9Pvnc0x1zNBkgIQNMFdeYJWcfvNcDeUbQGwRfJlXlMr3OgjP0FzIvT+oH4xFB
         njChqC1ZU0okB4kFd+FXHDLkB4U33FnZAk8gJFJhgY9GuEKjncCe1i4K/oHXqZ6YU9GG
         NhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NIM7gH+mWve7U4rqetzbz5Hnwl1+TH0EFEyUrpMHQUE=;
        b=GoftRKEWAv5Lny+5PG7ieA0GSJksIaIbGRcGeow30F39WoHivVN0wm4jmhAZ5B1Yxq
         k2xaed8UX9wO3nXK3TgDlW+HqpYlk6B1VmJo7hmTbMvfSDsGe6zwdP+2tnvfrg5BckOB
         DHvsS+bGMpeRY7zoa+NL1dTNCeo+Fvi+DGAsj1bp39jxml91ryGd082KQ94pIWVh5MkZ
         pbrmR7Axz7jxx8yr8GHeYCECOCm78KYJ9sdalk55W2z1m+dn1jqd//lL/chOwijrMIr+
         EXoZjq7jGn8g1l48/4tPaHTSftrzO7tF/nQju7QSiv1RLFwXf9CbMISfZJjmUBD3w/YM
         C9IQ==
X-Gm-Message-State: AOAM5301GWefm0JuXCzM8bC1LGPYl/2FDpognXNkcP9a2HK7+3+4SDiG
        at1bXLcPZcDwe3kursSNtFI=
X-Google-Smtp-Source: ABdhPJwYVpxwaIexwwBOXhDSDOwdU9pcdVcstWKnpGkOkE1KrxXSYkS5/RnE4UyZ+KGNhL2Y6Up6WQ==
X-Received: by 2002:a17:90a:e00c:: with SMTP id u12mr3340072pjy.139.1639461395295;
        Mon, 13 Dec 2021 21:56:35 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id j6sm13923385pfu.205.2021.12.13.21.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:56:34 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:56:31 +1100
From:   Balbir Singh <bsingharora@gmail.com>
To:     Leo Yan <leo.yan@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v2 7/7] taskstats: Use task_is_in_init_pid_ns()
Message-ID: <YbgyD6cK/ZkMPCDb@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-8-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-8-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:20PM +0800, Leo Yan wrote:
> Replace open code with task_is_in_init_pid_ns() for checking root PID
> namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  kernel/taskstats.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 2b4898b4752e..f570d8e1f001 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -284,7 +284,7 @@ static int add_del_listener(pid_t pid, const struct cpumask *mask, int isadd)
>  	if (current_user_ns() != &init_user_ns)
>  		return -EINVAL;
>  
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	if (isadd == REGISTER) {
> -- 
> 2.25.1
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

