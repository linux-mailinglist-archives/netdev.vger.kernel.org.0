Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFBC473CC3
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhLNFyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhLNFyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:54:40 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10655C061574;
        Mon, 13 Dec 2021 21:54:40 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso15210918pjl.3;
        Mon, 13 Dec 2021 21:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R1Fbcs2PkAzxnxr2SD1nIRjZeiJzFKllZFg8W2MhEa4=;
        b=f31dRgVVLcnOpSdPmRXV5OrNE3tKzDUx9GIBP8WXjcaa1CE7TJNLUstR9/LWNogZz5
         UdGrsAK5UaeODNHriSquMzJrUQcSM9vu6CvixYmk7Wsb8y7858f8EcNqTP3InZoYAghY
         MKJ329LZ66SVlUv2QjJRzk0Eyy1GPUyBg7i5vbXBiC07Vzo1zL3j87/OSPo/ByTDYgXb
         nZCcGO8QUa2P9wOBBc/2VCio2X9Upb0napZ1Zcj6YwFzVFWzOF9RbEVfJFQOIZrRisSX
         o+M5tZn3vmQdeZtA1N9Rzd/D4AKIqypgVSUG6zEqiiKjAr5MF0PhzRYghausmF8MXrIC
         ziLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R1Fbcs2PkAzxnxr2SD1nIRjZeiJzFKllZFg8W2MhEa4=;
        b=t8I3tnogIQ9LkfjixIoe2LZMMGWvmuN6Eoy9cvj8qseCho9KUzRWP2OvnzeIQpNlHi
         M5m4bo3KffSnWcfhBiRpCq5ND1xHSKyGy+VGyye5yETEEJtm1d2zUELvoL7YPGEsV2EM
         fJb+gF3CKBBYQZMRWrzT5vqR3rnFGC8kOgms+e5005ErCQxWYc/7gSVzjblXO0O8uPyJ
         ZBXFnSt5SjggqJ8oKgEGyt35p0j4V8I6KwoiuOA8QsYulsGLt6BcwMY8OJ1OM4SQBhiq
         Lrd8MAXU+VFc7KWoWXwNtEFISG9+UdZHpYNSUSIz1SuGM1g60adq69Eb3oZWdlFaUk9+
         cYtA==
X-Gm-Message-State: AOAM531HwpAROXW8tXCiOUQKvoWuVAZznm9h1YleNezWDGXbUHUxS6mf
        vJ8m+esRT4CCu6ucK2TcmHM=
X-Google-Smtp-Source: ABdhPJzmNeU8tuF6oceL4w9UBP6NmorClr6I1o6JhnvNSREoQpNWLILs9bOV3hnbB07xMd55xQ7GLQ==
X-Received: by 2002:a17:902:a714:b0:143:d007:412f with SMTP id w20-20020a170902a71400b00143d007412fmr3185130plq.18.1639461279440;
        Mon, 13 Dec 2021 21:54:39 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id l25sm11090819pgt.62.2021.12.13.21.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:54:38 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:54:35 +1100
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
Subject: Re: [PATCH v2 3/7] coresight: etm4x: Use task_is_in_init_pid_ns()
Message-ID: <Ybgxm6o+yLhP+f6L@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-4-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-4-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:16PM +0800, Leo Yan wrote:
> This patch replaces open code with task_is_in_init_pid_ns() to check if
> a task is in root PID namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  drivers/hwtracing/coresight/coresight-etm4x-sysfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> index a0640fa5c55b..10ef2a29006e 100644
> --- a/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> +++ b/drivers/hwtracing/coresight/coresight-etm4x-sysfs.c
> @@ -1890,7 +1890,7 @@ static ssize_t ctxid_pid_show(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	spin_lock(&drvdata->spinlock);
> @@ -1918,7 +1918,7 @@ static ssize_t ctxid_pid_store(struct device *dev,
>  	 * As such refuse to use the feature if @current is not in the initial
>  	 * PID namespace.
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	/*
> @@ -1951,7 +1951,7 @@ static ssize_t ctxid_masks_show(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	spin_lock(&drvdata->spinlock);
> @@ -1975,7 +1975,7 @@ static ssize_t ctxid_masks_store(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	/*

Acked-by: Balbir Singh <bsingharora@gmail.com>
