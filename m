Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F251FE993
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 05:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgFRDn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 23:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgFRDn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 23:43:27 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE16CC06174E;
        Wed, 17 Jun 2020 20:43:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 35so1881489ple.0;
        Wed, 17 Jun 2020 20:43:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=J5cvxrzCLgTlUHLfCpZKAy3wis7AXnYdA2P7fhjE0Nk=;
        b=dV6uJg5WuQe4tVYorO/Z6xUXDg8vZge+Gqlno5N1UBsqP4lq3jKBB/F/fa2vY5YXhL
         ADHA9sQdvAM6Fph0T8uS1yr980KVI/gyf8Vig7Yv70eEZQ0vW0MbeFcPBkDdrn7gwZot
         egObllx0eoLOrjbuuGtTpmUdhEHmXi/D/otCG8kcK1dfft6kztUutYKPNn7qMNhC137E
         7xA/YdMMC9XLy4bQnlhjtWm16o19zm1+KueEFSJmVc5aH6CQXkSGVptPVXgoA5kTxBLX
         CvKpViFL3y6NW3ap15KPjdOX4pi8pl2nMzBPWP4DUOuCOSpt/3zauTRSSsOItlSO35nS
         sThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J5cvxrzCLgTlUHLfCpZKAy3wis7AXnYdA2P7fhjE0Nk=;
        b=K6hh9+PC0w4/VdXPqe6EtmpxmjHver5D2tUQJzMdbXciTUP3PdHJZgEhiSuHpCFEZe
         pcjgVaROZ9DWM6noC0E9KACcC1e0sTcy5jH+utFCIwejSNqSwYMDTLXPNfqGhWxbAL+M
         +J4T3E/hE5kqSzpWAj2k3A06RwI7mDYGHTrtB7H3d1iQ1w00J1T4hC8CZVT97icrfEtr
         eMYLc4VPvj5pXucptFjJm9dznwL+ZRuCfczIEVCyE5lqzdqsQsOmdawetjLxXTZbQ/dI
         aS3G1STHeBb8XdZDUsGvJ41QTFkT7VvkKCB1QOY9JfdEY9xt3o64iM+GTJTPb9LMltCF
         KReA==
X-Gm-Message-State: AOAM533CkmxJLfg6az+9b7OKI+fMdJ5iduHqOU0olNwdll3Wd48wcF26
        96ExQBVeyfykAnkMD2wOq/9gGlQz
X-Google-Smtp-Source: ABdhPJxAy0TXYLYLlcgFgV5lqSP8DNLQHzavrtUFbZvQ3Ni+RicJtuBXx7ZcOCr5lr0XxMVViU1a6g==
X-Received: by 2002:a17:90a:36cf:: with SMTP id t73mr2293461pjb.100.1592451807083;
        Wed, 17 Jun 2020 20:43:27 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s15sm1061307pgv.5.2020.06.17.20.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 20:43:26 -0700 (PDT)
Subject: Re: [PATCH] [net/sched]: Remove redundant condition in qdisc_graft
To:     Gaurav Singh <gaurav1086@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:TC subsystem" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200618005526.27101-1-gaurav1086@gmail.com>
 <20200618012308.28153-1-gaurav1086@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f3f40022-6f61-0434-d4b8-63b5c39eef0a@gmail.com>
Date:   Wed, 17 Jun 2020 20:43:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200618012308.28153-1-gaurav1086@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/17/20 6:23 PM, Gaurav Singh wrote:
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>

Two Signed-off-by ?

> 
> Fix build errors

Your patch does not fix a build error.

> 
> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  net/sched/sch_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 9a3449b56bd6..be93ebcdb18d 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1094,7 +1094,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>  
>  		/* Only support running class lockless if parent is lockless */
>  		if (new && (new->flags & TCQ_F_NOLOCK) &&
> -		    parent && !(parent->flags & TCQ_F_NOLOCK))
> +			!(parent->flags & TCQ_F_NOLOCK))
>  			qdisc_clear_nolock(new);
>  
>  		if (!cops || !cops->graft)
> 
