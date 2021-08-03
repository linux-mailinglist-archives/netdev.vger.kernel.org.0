Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575F23DEB3E
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhHCKvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235477AbhHCKug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 06:50:36 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC037C06175F
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 03:50:02 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id a19so980592qkg.2
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 03:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JmJH9S8AoJGm+38o4pTb7CuCnCa5pOHvKuJqVdN6Ncg=;
        b=xr+05NiyJn865qcyne/Rs2kdGPcGlhTvPXAH4s3othmo7w4mOlxr4eqqmtVK1sF+Do
         P1tT1h+rD2D9CogPifzlbXF72+vyuTyK+22rwhyv8hyoOcGiSyPJKWD2xvWQEh2V8Wyj
         FwwqUyJ5TNLPF7odoeUJojH7A+Y2zIdV4c3lqIiYId5N2m/k78kxTzvgtm4k3oi1/OfR
         HJGVZ1gycwqqqz2cwTqcCuRQiNtWfSh5fnfeUZ0sLrqNSoxID5/Sqb37DRibCw6mI0/V
         2I5sESmEJYwtTK75ArPG6MmBRih/2FTZqfZjBUqtjEO18sH9JWSyo7bS9E00R8qPS891
         6pTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JmJH9S8AoJGm+38o4pTb7CuCnCa5pOHvKuJqVdN6Ncg=;
        b=mwt2Fnsfl4K1ND2hU1P/V+AzGvQQuzBSj/+0BZBcbIBoMjJSUDyabiWpuQoTfKypdj
         ozv10cIFNC5dDeJrSXfsM4ExlcjaANIRKS3wxwIPH1Fh8lsD/Z/Q1Te1DRyerUqlVn5n
         TxZ+YSY/A4fVFDYvIKS92IOH/oEnxsfne+pD3OSaW8T+PX24FeR5JgaWgnSdjTBcj62t
         V8KQLcKL2En5TtpW2Nz3lMn504n1lcw5pl7jEEilqH8LcYRnRMYEH+swhHGEqH6lsyig
         edqxcGnSIjINqC8Qt+b3+/419LFjbjUS4ERygRNPoHue7VmaMSPBAor6s31RMKaQcMQX
         6STQ==
X-Gm-Message-State: AOAM5326pPfmbE4yJEkH5BDztfK5rKrjMygtxwV4qbEjnBnMrUYz/4QT
        5fhzoh2Og7xzvZk6KKWMcp9mSQ==
X-Google-Smtp-Source: ABdhPJz9rhHdZdEQ9GBtXd2SoovQy5HWgMxOKpyHSi5rhTyBNs0uiRKBvX5IFEBerVG//3v4FUfk9g==
X-Received: by 2002:a05:620a:4441:: with SMTP id w1mr19891311qkp.272.1627987802028;
        Tue, 03 Aug 2021 03:50:02 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id g10sm5936116qtp.67.2021.08.03.03.50.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 03:50:01 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <3510d005-5836-cfb5-98c8-bea9a379c113@mojatatu.com>
Date:   Tue, 3 Aug 2021 06:50:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722091938.12956-2-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-22 5:19 a.m., Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> Use flow_indr_dev_register/flow_indr_dev_setup_offload to
> offload tc action.
> 
> We offload the tc action mainly for ovs meter configuration.
> Make some basic changes for different vendors to return EOPNOTSUPP.
> 
> We need to call tc_cleanup_flow_action to clean up tc action entry since
> in tc_setup_action, some actions may hold dev refcnt, especially the mirror
> action.
> 


[..]

> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1060,6 +1060,36 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>   	return ERR_PTR(err);
>   }
>   
> +/* offload the tc command after inserted */
> +int tcf_action_offload_cmd(struct tc_action *actions[],
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct flow_offload_action *fl_act;
> +	int err = 0;
> +
> +	fl_act = flow_action_alloc(tcf_act_num_actions(actions));
> +	if (!fl_act)
> +		return -ENOMEM;
> +
> +	fl_act->extack = extack;
> +	err = tc_setup_action(&fl_act->action, actions);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Failed to setup tc actions for offload\n");
> +		goto err_out;
> +	}
> +	fl_act->command = FLOW_ACT_REPLACE;
> +

The fn name is a bit misleading with _cmd suffix when it is
only targeting one command: REPLACE (and not the other two).

cheers,
jamal
