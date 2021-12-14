Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17A3473CC5
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbhLNFzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:55:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhLNFzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:55:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B636C061574;
        Mon, 13 Dec 2021 21:55:04 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id o14so12808518plg.5;
        Mon, 13 Dec 2021 21:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qygzG3i+Q2dKqcPeTWcYmqHjvIDf/rLwYsDEhwU2v0E=;
        b=hFcA5f5+yuNXm2EkQENEAR8jXJdUhAhICIdWNJ3iNK2wsePdOgJIuMjloMxi4Hpvww
         lDr+TFLmXpD7O1L+v2l8qWmMDQ5c0T/ic7Vubt7VRskw9CjNk+uFR3sU0Wa6jP7gRYYr
         C5IxEP53iXvaGtH5KDqtKCpXvZ10Io+NOtoDNTcmkQMlTfYwMFQ8/+ULXmIRAQ02ig7B
         isdehYHTMibYLH8BVaZg4Oz0pPaGDClcA80VYmUsa6sj29jdu5larGvAY+yhi3aeIB51
         i4tcGJOjG3A/3H0C3KfRIMo2gCVB059Tbx8gHv6zTzXpXJPomb6loRJPd9ZCu34WG0Eb
         DPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qygzG3i+Q2dKqcPeTWcYmqHjvIDf/rLwYsDEhwU2v0E=;
        b=UYk5HAzVIWnL8yVQPbQJtmExrA8P/pqnM1SuG3icg9vJOMhKbOl+V7g1CUaBPcgMmn
         yd9vTq88zuA3PBRrsr0dilf++wXD5oQb8bbMJbaRXvhyOdITPJ5kFjNH3eNj3+8ICDuK
         MJ+y5KBObKdreZdmIhHBJZP3PIUEgGtDQY18s83XJ854UxOe09xa7HUc+AM39mVmf/Ys
         h/DTvLEmB6b1Lc7HZMtql8AbcmJYL7oUA6pyswhKF32TcJz3xUxcSXPeYHhZMrFb7XV1
         hkE2pBj7urnqkIHQj8zfdN4t7Ll4NeCZgPGUQlWp98cZNqa3zTSkoX43BSmdaFLyW7eY
         r/9Q==
X-Gm-Message-State: AOAM5338rdlX3li6mhjWHH2zoyHC/LYzcdQq3BohcTsgHASu8JHmzv22
        t6vKIbxJrRhTvAwfoHDBJBk=
X-Google-Smtp-Source: ABdhPJzSdxEnUOjNJKDc/bReM7aNHVb5aLCdbU+rNH3K0mlsefPQKSUOeP7h1RrGEH04avmyo224RA==
X-Received: by 2002:a17:902:ea03:b0:146:6bd8:7de3 with SMTP id s3-20020a170902ea0300b001466bd87de3mr3921113plg.29.1639461303807;
        Mon, 13 Dec 2021 21:55:03 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id b11sm14378414pfm.7.2021.12.13.21.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:55:02 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:55:00 +1100
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
Subject: Re: [PATCH v2 2/7] coresight: etm3x: Use task_is_in_init_pid_ns()
Message-ID: <YbgxtIXwx7TZR88Y@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-3-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-3-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:15PM +0800, Leo Yan wrote:
> This patch replaces open code with task_is_in_init_pid_ns() to check if
> a task is in root PID namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  drivers/hwtracing/coresight/coresight-etm3x-sysfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
> index e8c7649f123e..ff76cb56b727 100644
> --- a/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
> +++ b/drivers/hwtracing/coresight/coresight-etm3x-sysfs.c
> @@ -1030,7 +1030,7 @@ static ssize_t ctxid_pid_show(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	spin_lock(&drvdata->spinlock);
> @@ -1058,7 +1058,7 @@ static ssize_t ctxid_pid_store(struct device *dev,
>  	 * As such refuse to use the feature if @current is not in the initial
>  	 * PID namespace.
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	ret = kstrtoul(buf, 16, &pid);
> @@ -1084,7 +1084,7 @@ static ssize_t ctxid_mask_show(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	val = config->ctxid_mask;
> @@ -1104,7 +1104,7 @@ static ssize_t ctxid_mask_store(struct device *dev,
>  	 * Don't use contextID tracing if coming from a PID namespace.  See
>  	 * comment in ctxid_pid_store().
>  	 */
> -	if (task_active_pid_ns(current) != &init_pid_ns)
> +	if (!task_is_in_init_pid_ns(current))
>  		return -EINVAL;
>  
>  	ret = kstrtoul(buf, 16, &val);
> -- 
> 2.25.1
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

