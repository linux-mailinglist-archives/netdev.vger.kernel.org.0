Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96162473CD2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhLNF6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhLNF6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:58:37 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7C4C061574;
        Mon, 13 Dec 2021 21:58:37 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so15204381pjb.5;
        Mon, 13 Dec 2021 21:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uE8tm7fba5U6NBtNlVs+75ZMG9iOEUJb31FfCod84+w=;
        b=dCYD2p897oCg0sRe1lmek/4jFC+FOSIkEee2sTpRc6SP1ff9GiS90q8sDeKKlPfIdv
         3QCeDPSWw+94OEan2cXREv4sAw+6KQQz931C9FZU1TDUN3fNL9eescfMg58gPsE217zK
         SFYD1ivheYnLXTjnTNXlKrSq29uEJc+EA9wDeokdKudFDT6fIPEHq4OlFtz+9Y2jvlEQ
         N0l4XWVXK8kMADWcFI+67iuusPs4K+GMdgMDyDA+HHm4zm3iuMqKzGhhY5xDDBxW9gpX
         kASBhlhS2jwJdgNex7uDYnU3gMeonWhCIATBNE6ICyaxGAsD5hqZyfUsqwV+s32wo0Rx
         ZHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uE8tm7fba5U6NBtNlVs+75ZMG9iOEUJb31FfCod84+w=;
        b=XkslM/elFFE+/y7kls5PMybEx+h/1z2iETObg/YoH+7nzgOxFaPP3mm8ZWIV7wy8Z9
         pAAm6Z+TsSto1mNjymXeGwIk0raFCAqgjDzgVw2Y3zcn8knlY/li/Xz+WXMC/sjefJJV
         nWl1sNcdTMKdFnPGAIwZ9k+O2d67SyqB13LsKUkNiWlxVnzmWLrR/WL1siAQoJpa8Gzn
         64YMUJIswatUz0Vyk1K0xQqApdSCF4kRQDkbbclsNKqR+yaj84dkuDFOb4UyMeyHMprc
         zrWKOF/vzgW/DT4zLTyeST5higHkVlT1MP8dcR1ypeGdJa4X1Hdr0VyJn9YhwO/1eDB4
         2sqQ==
X-Gm-Message-State: AOAM533yhbkKCz6gslPwoIWlQnRyhq2p6F74vb17f33eanrONzESZP6k
        83G+jIG7PL1z5VQUTe8qNzQ=
X-Google-Smtp-Source: ABdhPJw6AuSqH/TZUjqfvsk1KhigqT3WeS/B3avdSl+QZpNNsPQ1+e71qbUYWXziTJBd0aPeGSopHA==
X-Received: by 2002:a17:90b:230c:: with SMTP id mt12mr3398651pjb.63.1639461516315;
        Mon, 13 Dec 2021 21:58:36 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id nn4sm1071069pjb.38.2021.12.13.21.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:58:35 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:58:32 +1100
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
Subject: Re: [PATCH v2 4/7] connector/cn_proc: Use task_is_in_init_pid_ns()
Message-ID: <YbgyiIZDDaOB93Em@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-5-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-5-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:17PM +0800, Leo Yan wrote:
> This patch replaces open code with task_is_in_init_pid_ns() to check if
> a task is in root PID namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  drivers/connector/cn_proc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index 646ad385e490..ccac1c453080 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -358,7 +358,7 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  	 * other namespaces.
>  	 */
>  	if ((current_user_ns() != &init_user_ns) ||
> -	    (task_active_pid_ns(current) != &init_pid_ns))
> +	    !task_is_in_init_pid_ns(current))
>  		return;
>

Sounds like there might scope for other wrappers - is_current_in_user_init_ns()

Acked-by: Balbir Singh <bsingharora@gmail.com>

