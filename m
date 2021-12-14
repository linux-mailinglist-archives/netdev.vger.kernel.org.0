Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3A473CC7
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhLNFzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:55:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhLNFzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:55:42 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70ADC061574;
        Mon, 13 Dec 2021 21:55:42 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id iq11so13538226pjb.3;
        Mon, 13 Dec 2021 21:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mOz2n15l7yDI+2sTaql2TW0ZegS4iVHrtlIatnwxZak=;
        b=JKbBjpTcOheo4O1Tm2aQLZIg7Km7Aw8/gAEC7Uh6B4zFk1IywU2qs0VI53wNYvyB+J
         MqvUC3pGSLrTyTEJqg134zkq8ffV7kTdHo0f1dSAF891KwZc/gIWLKiRdx7mk25KZMpR
         d3x9us09mUW8t4F507N2z72zbR7EUlIxSrvc61xfg5Iq7JZQX2BM2b/B1wQsbjYj44AA
         7W/xCqQhLFPsEPZz8/1aDsCOgtWWKBZr7dQxQoxNu/v3gXCFsAn42hW9CahMFYi6/5v5
         ToamyTTcqlUM/M14avRWVrqy/zAQ0OPvy7N/Y7hjdBfz/PfUiXiGvYwJVXryPCNnNVWP
         4yYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mOz2n15l7yDI+2sTaql2TW0ZegS4iVHrtlIatnwxZak=;
        b=H4DumrJGCD3m4HZhMmcEHy69xzXx46ldDgVGc/FQMqgbK6u8BHwp35yNkeCrKQ8uM+
         Fn22oNWEfaZciVX5fkiUY/kxFMueMnoJGyDEsiENU1ZEX+yIiD2tQ3+u5JzHTx5BDnEf
         wsdecGWCwdP1WBe4pmlcWsulLUbzxKDxCSP9v6IVrz1Pvwv1uFeWuY+YOwZSwke1DEK0
         po0Cj8ZtUY961EeKT3yiVC2K1rXR4Jpn9kaurndTyIRBjob8SSFQ5/41/Jr73FAVn0S8
         2k99i6uJ/wt12BSy2HUnc0w3UiOOaPltZ9HOqUIVORc5YxN5oQce7BNtKCX5/DV5WuVN
         pwaQ==
X-Gm-Message-State: AOAM530BVjvMcog2MAR8EEM6q8VrLZTKzl5kT9rhZgu8JRUdiSGD6/0V
        tkKWZM4P2nr1yN97yfZuirE=
X-Google-Smtp-Source: ABdhPJwR7OAh6kARLVf4WgF3DrQmjQDIPb+uBpwn/LUpUvw8DOFFteE1EgPHeyPCAT7ULeMuvkYdWQ==
X-Received: by 2002:a17:90a:ec15:: with SMTP id l21mr3315172pjy.48.1639461342170;
        Mon, 13 Dec 2021 21:55:42 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id y12sm13983437pfe.140.2021.12.13.21.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:55:41 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:55:38 +1100
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
Subject: Re: [PATCH v2 1/7] pid: Introduce helper task_is_in_init_pid_ns()
Message-ID: <Ybgx2txdvfLzruFr@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-2-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-2-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:14PM +0800, Leo Yan wrote:
> Currently the kernel uses open code in multiple places to check if a
> task is in the root PID namespace with the kind of format:
> 
>   if (task_active_pid_ns(current) == &init_pid_ns)
>       do_something();
> 
> This patch creates a new helper function, task_is_in_init_pid_ns(), it
> returns true if a passed task is in the root PID namespace, otherwise
> returns false.  So it will be used to replace open codes.
> 
> Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  include/linux/pid_namespace.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 7c7e627503d2..07481bb87d4e 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -86,4 +86,9 @@ extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
>  void pidhash_init(void);
>  void pid_idr_init(void);
>  
> +static inline bool task_is_in_init_pid_ns(struct task_struct *tsk)
> +{
> +	return task_active_pid_ns(tsk) == &init_pid_ns;
> +}
> +
>  #endif /* _LINUX_PID_NS_H */
> -- 
> 2.25.1
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

