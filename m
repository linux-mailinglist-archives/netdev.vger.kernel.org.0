Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28859390A93
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 22:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhEYUh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 16:37:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33301 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233298AbhEYUh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 16:37:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621974955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=22qIiG6cEhb+GlRsXlSpsbspBqvDtahZHcIwEfm+14I=;
        b=caA3/Yu6DZ43FHUtBcPoAFguVgEyQec2KsjYsDioxbrphPKcv9WiuVbprimp6wredvOPYl
        MPm+LHbuGSsHS9EGbd3cafkhV+RXj31OJjgFFp3LBme12Bwt39QmaUFlf8p6IvN9hmsCHM
        L75ajaiARlbYZIKWrnwbvvH6Jc7b5ds=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-z4Y2wREKOXO_wgwK_2LoqQ-1; Tue, 25 May 2021 16:35:53 -0400
X-MC-Unique: z4Y2wREKOXO_wgwK_2LoqQ-1
Received: by mail-ed1-f71.google.com with SMTP id n6-20020a0564020606b029038cdc241890so17915227edv.20
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 13:35:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=22qIiG6cEhb+GlRsXlSpsbspBqvDtahZHcIwEfm+14I=;
        b=JOrmw+UCscG3ZIuqyaWm3OGB/iWO52JGU5Zw1QHuJQLiJpbcpOhLyhFO//pTxCY/R+
         E+L9dITh8+4HCRlcLboWeuBjWuPpTsu+NZSsbqYamsErf/6pPrZJRMJTyjBJumTBVI1n
         XsQPvyq7uVTMANll3udRi2NUlLgZSEHzRuah7MmAH5yUmzhGUZKW0aN4gxFLb9Yi2lry
         H5pqSly2pkmz5kshyHzHyk7y8lFW3bve2IHdFVU+3dfvmaPto+kNk7MCNLGka1fzNDxu
         oOF+Pw8X6U1s/4WeeduEIIdmDVQLrHDaRvzhiNfldH0ScwzDZBFWLRJS7z97P+gigNQ8
         skrw==
X-Gm-Message-State: AOAM5339xumqeZHXPA19Gtcl7gymbNClyyXeZO1P5Ri5PVx1kkWh7DUV
        QSMKOLabdrPHGAHsjc+MOb+2TrOKkgFyjw4gLfQwsFgpsnGiGWznSxqE3lsi+BywvNN7LBsGLlm
        hRtgDmqITcbTgYUz7
X-Received: by 2002:a17:906:f2ca:: with SMTP id gz10mr31375768ejb.317.1621974952063;
        Tue, 25 May 2021 13:35:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBERx9WKHJ3MhsteYaEmaUR2gDjGgXiROw2ELNjcI7XZUJm0sDSxeLyTK9hsOKZ2vVvNh6xw==
X-Received: by 2002:a17:906:f2ca:: with SMTP id gz10mr31375760ejb.317.1621974951845;
        Tue, 25 May 2021 13:35:51 -0700 (PDT)
Received: from localhost (net-188-218-24-141.cust.vodafonedsl.it. [188.218.24.141])
        by smtp.gmail.com with ESMTPSA id p10sm1022574ejc.14.2021.05.25.13.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 13:35:51 -0700 (PDT)
Date:   Tue, 25 May 2021 22:35:50 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net/sched: act_vlan: Fix modify to allow
 0
Message-ID: <YK1fpkmyiITfaVpr@dcaratti.users.ipa.redhat.com>
References: <20210525153601.6705-1-boris.sukholitko@broadcom.com>
 <20210525153601.6705-2-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525153601.6705-2-boris.sukholitko@broadcom.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 06:35:59PM +0300, Boris Sukholitko wrote:
> Currently vlan modification action checks existence of vlan priority by
> comparing it to 0. Therefore it is impossible to modify existing vlan
> tag to have priority 0.
> 
> For example, the following tc command will change the vlan id but will
> not affect vlan priority:
> 
> tc filter add dev eth1 ingress matchall action vlan modify id 300 \
>         priority 0 pipe mirred egress redirect dev eth2

hello Boris, thanks a lot for following up! A small nit below:
 
> diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
> index 1cac3c6fbb49..cca10b5e99c9 100644
> --- a/net/sched/act_vlan.c
> +++ b/net/sched/act_vlan.c

[...]

> @@ -121,6 +121,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
>  	struct tc_action_net *tn = net_generic(net, vlan_net_id);
>  	struct nlattr *tb[TCA_VLAN_MAX + 1];
>  	struct tcf_chain *goto_ch = NULL;
> +	bool push_prio_exists = false;
>  	struct tcf_vlan_params *p;
>  	struct tc_vlan *parm;
>  	struct tcf_vlan *v;
> @@ -189,7 +190,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
>  			push_proto = htons(ETH_P_8021Q);
>  		}
>  
> -		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
> +		push_prio_exists = !!tb[TCA_VLAN_PUSH_VLAN_PRIORITY];

when the VLAN tag is pushed, not modified, the value of 'push_prio' is
used in the traffic path regardless of the true/false value of
'push_prio_exists'. See below:

 50         case TCA_VLAN_ACT_PUSH:
 51                 err = skb_vlan_push(skb, p->tcfv_push_proto, p->tcfv_push_vid |
 52                                     (p->tcfv_push_prio << VLAN_PRIO_SHIFT));

So, I think that 'p->push_prio_exists' should be identically set to
true when 'v_action' is TCA_VLAN_ACT_PUSH. That would allow a better
display of rules once patch 2 of your series is applied: otherwise,
2 rules configuring the same TCA_VLAN_ACT_PUSH rule would be displayed
differently, depending on whether userspace provided or not the
TCA_VLAN_PUSH_VLAN_PRIORITY attribute set to 0. In other words, the
last hunk should be something like:

@@ -241,6 +243,7 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
 	p->tcfv_action = action;
 	p->tcfv_push_vid = push_vid;
 	p->tcfv_push_prio = push_prio;
+	p->tcfv_push_prio_exists = push_prio_exists || action == TCA_VLAN_ACT_PUSH;


WDYT?

thanks!
-- 
davide

