Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3B473CCC
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhLNF5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhLNF5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:57:02 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3CFC061574;
        Mon, 13 Dec 2021 21:57:01 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so15233217pjb.1;
        Mon, 13 Dec 2021 21:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WfE+wbkqI+wZX/Nt24yen2hhvEvQ62avzsLaxrCH6po=;
        b=LX/rZ2XNoZ8aZDADViviPIV7fUNYgAFRpeK6fHXvu0+OKM29oi66PUKjvjKsb41T/Q
         8Y2qf0mU4AXnfyH7xyyp5lWq7K8csvLN3LOJC9sdfFlL0op4MgGFC2l3WfRkX3NosmYw
         HXAmou7os73kBsBNZga4lvnIst4vksdkmkSS9tNQ4pWgZI6d9Evg0q9pkfjLofJa1/VN
         0hn+Fm9lGMRNUIw6NgpqwaukQvtIrWfnDYR397xwDDSZMmpQJcqy7mfdk5jmQw4HHJ2y
         o0uaW0i6P3PngX9yXjB168q/cCa5Taxwl7gx0FlVlr8x6CNxJjlGhGT4DtrTu0t/ftat
         4a4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WfE+wbkqI+wZX/Nt24yen2hhvEvQ62avzsLaxrCH6po=;
        b=mMl2WL7w28U85iweFftG82KeoGIvokjAzloZlVIywhIRvOOhv6BeXSmd4G6uX7lWxc
         BRWzHPrkaUHFikmA+ZBd/n5hh6IStvlTIwDrUQfIgGISXdJqkZCLglVb8e1e6tNw87ue
         6OnLz6+g5KIe22qom1OyojuduvCWDnxHeIFZY8UWg8sBgxzil19RGoqOhsHfjYJxYHra
         DAFKIfdsFfPDc8t+nf4TGL6PgOROGpRomieCH92LhQDfXV42sIO+iUBov9m24sAYb7sn
         hPhy/i0FsLAqbHeWk02puHRB21h2Vwx60ydFndLqhNbYa/BHh94oTvRCK+l3eFkFpqqN
         IfiA==
X-Gm-Message-State: AOAM533wzAe2uRm+ajXlE8iFpaXAF3P+gHmb9nvQOpu98kpr50VIBtZ0
        z2lHaX0HKY2uxwqKWmFpInw=
X-Google-Smtp-Source: ABdhPJzUmbQbD/etyqZzwo4+YKtCeADyU5CmvMU6nfCUIlCCyuPHtKpfnsqlS9l0fgqHq9Vxn0wnig==
X-Received: by 2002:a17:902:da8e:b0:141:fa9d:806d with SMTP id j14-20020a170902da8e00b00141fa9d806dmr3267729plx.26.1639461421243;
        Mon, 13 Dec 2021 21:57:01 -0800 (PST)
Received: from localhost ([110.141.142.237])
        by smtp.gmail.com with ESMTPSA id k18sm16155735pfc.155.2021.12.13.21.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:57:00 -0800 (PST)
Date:   Tue, 14 Dec 2021 16:56:57 +1100
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
Subject: Re: [PATCH v2 6/7] audit: Use task_is_in_init_pid_ns()
Message-ID: <YbgyKanmxZWj4HXk@balbir-desktop>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-7-leo.yan@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208083320.472503-7-leo.yan@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 04:33:19PM +0800, Leo Yan wrote:
> Replace open code with task_is_in_init_pid_ns() for checking root PID
> namespace.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  kernel/audit.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 121d37e700a6..56ea91014180 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1034,7 +1034,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>  	case AUDIT_MAKE_EQUIV:
>  		/* Only support auditd and auditctl in initial pid namespace
>  		 * for now. */
> -		if (task_active_pid_ns(current) != &init_pid_ns)
> +		if (!task_is_in_init_pid_ns(current))
>  			return -EPERM;
>  
>  		if (!netlink_capable(skb, CAP_AUDIT_CONTROL))
> -- 
> 2.25.1
>

Acked-by: Balbir Singh <bsingharora@gmail.com>

