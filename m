Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA71393471
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbhE0RCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:02:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29552 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233674AbhE0RC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 13:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622134856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/pfkEhsGHCmarxi4wcTp/4nOypsC/xcc1HHgSSCttJs=;
        b=i+KHcnRJh+jw5eJhB+VFXvjggT4NFPUxvZ4fzpL+qHdBlr5Qnx4RxM1+VLxqolkRi/AS3v
        k6qv8FE07xD+MCAbTuCCVdRG+fiyDJZnW8RLPgQYwrwrYoIvicoyz3860dqdOYJI60qnby
        3p8hqUwOC1ONsAsqsX6FE9AvQezQKx8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-596--0pYWHrnPzKW49NS0gVr-w-1; Thu, 27 May 2021 13:00:54 -0400
X-MC-Unique: -0pYWHrnPzKW49NS0gVr-w-1
Received: by mail-ej1-f72.google.com with SMTP id i8-20020a1709068508b02903d75f46b7aeso264280ejx.18
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 10:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/pfkEhsGHCmarxi4wcTp/4nOypsC/xcc1HHgSSCttJs=;
        b=IM0KN983eA3XzkgYcgP7AEdfLeDm/Vp/F6ketbhglfU136fJJx6RDmkMHH2JWJTWYp
         yGR9+xGEs+MQ4+X5klkvLqZwieLytQ3/9XogkU7jtldDDzFdXDQYL6yk42R6jZgVj8mM
         HUgfkX90+1mF80zwqHSL8VYe4ur+atPcz7X8qD7D9+EpdD7a1R32WIzPcJ+APnj54GCl
         8yLs6SqPB7gONQ67bKA05HGNOlCtBgXqAqCHMtden4o/9B6q+bEccYJ2+4xM5oicr2i7
         2sioli0RFYMUYi4zRif1CtWVCVkTdbWut4ef33h9OJBtiIrrbgSrrONPp7p9wcQuybtP
         Ic/w==
X-Gm-Message-State: AOAM533eZVHbvnLHVRfzQXTrp5YBu/ww7QaAU2Dlw8SF/Py3nw2J5nca
        IvhYgz/TUypxuD+7PyebLWs1Pw/BJRX5E5b90FESDUX4b8KYUTNZ+zonSZ1dRCPqOgjTwqy2aVL
        d0OEL9kdrpBf3+2t0
X-Received: by 2002:a17:906:4714:: with SMTP id y20mr5002207ejq.235.1622134853468;
        Thu, 27 May 2021 10:00:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynxUQREYcX6RRZ/ydvxy/Buztzgcx5N1TehTBLvsecCIALNIC+pf/iwgoqamKJsRRHa/6cuQ==
X-Received: by 2002:a17:906:4714:: with SMTP id y20mr5002185ejq.235.1622134853293;
        Thu, 27 May 2021 10:00:53 -0700 (PDT)
Received: from localhost (net-188-218-12-178.cust.vodafonedsl.it. [188.218.12.178])
        by smtp.gmail.com with ESMTPSA id p7sm1418032edw.43.2021.05.27.10.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:00:52 -0700 (PDT)
Date:   Thu, 27 May 2021 19:00:52 +0200
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
Message-ID: <YK/QRFAcMMcXBvw9@dcaratti.users.ipa.redhat.com>
References: <20210525153601.6705-1-boris.sukholitko@broadcom.com>
 <20210525153601.6705-2-boris.sukholitko@broadcom.com>
 <YK1fpkmyiITfaVpr@dcaratti.users.ipa.redhat.com>
 <20210526114553.GA31019@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526114553.GA31019@builder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 02:45:53PM +0300, Boris Sukholitko wrote:
> Hi Davide,
> 
> On Tue, May 25, 2021 at 10:35:50PM +0200, Davide Caratti wrote:
> > On Tue, May 25, 2021 at 06:35:59PM +0300, Boris Sukholitko wrote:

hello Boris,

[...]

> > > @@ -189,7 +190,8 @@ static int tcf_vlan_init(struct net *net, struct nlattr *nla,
> > >  			push_proto = htons(ETH_P_8021Q);
> > >  		}
> > >  
> > > -		if (tb[TCA_VLAN_PUSH_VLAN_PRIORITY])
> > > +		push_prio_exists = !!tb[TCA_VLAN_PUSH_VLAN_PRIORITY];
> > 
> > when the VLAN tag is pushed, not modified, the value of 'push_prio' is
> > used in the traffic path regardless of the true/false value of
> > 'push_prio_exists'. See below:
> > 
> >  50         case TCA_VLAN_ACT_PUSH:
> >  51                 err = skb_vlan_push(skb, p->tcfv_push_proto, p->tcfv_push_vid |
> >  52                                     (p->tcfv_push_prio << VLAN_PRIO_SHIFT));
> > 
> 
> Yes, the tcfv_push_prio is 0 here by default.
> 
> > So, I think that 'p->push_prio_exists' should be identically set to
> > true when 'v_action' is TCA_VLAN_ACT_PUSH. That would allow a better
> > display of rules once patch 2 of your series is applied: otherwise,
> > 2 rules configuring the same TCA_VLAN_ACT_PUSH rule would be displayed
> > differently, depending on whether userspace provided or not the
> > TCA_VLAN_PUSH_VLAN_PRIORITY attribute set to 0.
> 
> Sorry for being obtuse, but I was under impression that we want to
> display priority if and only if it has been set by the userspace.

don't get me wrong, I don't have strong opinions on this (I don't have
strong opinions at all :) ). In my understanding, the patch was adding
'push_prio_exists' to allow using 0 in 'p->tcfv_push_prio' in the
traffic path, instead of assuming that '0' implies no configuration by
the user.

My suggestion was just to simplify the end-user dump experience, so
that the value of 'p->tcfv_push_prio' is dumped always in case of
TCA_VLAN_ACT_PUSH. In this way, rules with equal "behavior" in the
traffic path are always dumped in the same way. IOW,

# tc action add action vlan push id 42 prio 0 index 1

and

# tc action add action vlan push id 42 index 1

do exactly the same thing in the traffic path, so there is no need to
dump them differently. On the contrary, these 2 rules:

# tc action add action vlan modify id 42 prio 0 index 1

and

# tc action add action vlan modify id 42 index 1

don't do the same thing, because packet hitting the first rule will have
their priority identically set to 0, while the second one will leave the
VLAN priority unmodified. So, I think it makes sense to have different
dumps here (that was my comment to your v1).

Another small nit - forgive me, I didn't spot it in the first review:

not 100% sure, but I think that in tcf_vlan_get_fill_size() we need
to avoid accounting for TCA_VLAN_PUSH_VLAN_PRIORITY in case the rule
has 'push_prio_exists' equal to false. Otherwise we allocate an
extra u8 netlink attribute in case of batch dump. Correct?

thanks!
-- 
davide



