Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C14397384
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 14:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233898AbhFAMuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 08:50:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46026 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233828AbhFAMuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 08:50:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622551710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lZcGsUjeM17DF8Y23KBJIyU7YsG9IgMqzsnjGbIxDCQ=;
        b=QHHRLlxOJmTj/I1l/+vW/+LnPPniSRvuC7V1CsBnF6GcNdsmqSZvaV/WNqibgGfShHzYmt
        mPJVZpkKbGwECNf4b2TLgvpri6joxg9DKfVg40ITX6zIeDb+w+Da2cw2stqoCqBw808Pny
        C3ETyNmRayQbl7Wq8iaKQYEyPfw/yhE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-lhCEqacLNEmy2Q3RkBd5fw-1; Tue, 01 Jun 2021 08:48:27 -0400
X-MC-Unique: lhCEqacLNEmy2Q3RkBd5fw-1
Received: by mail-ed1-f70.google.com with SMTP id s18-20020a0564020372b029038febc2d475so2093057edw.3
        for <netdev@vger.kernel.org>; Tue, 01 Jun 2021 05:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lZcGsUjeM17DF8Y23KBJIyU7YsG9IgMqzsnjGbIxDCQ=;
        b=UJJ29/GcllR2pWc32okJlEfrxmmVs2jy7jIRz969J6UL+6TNBYSns8MtJhRt108ECZ
         X4+WDfokWPh2SSNnpjvq/eANCvTqW6M7LYcFgdMIWyNXoDHVRBobqTM9PDNxsgA1ad3w
         JfTEtsVdMROys+nd4lMyZYkkR5qf+TAs5E7w5hyfvc2fC5lsiYp7loVwac6nwlUJSSg5
         WbSPpBF7lgZQMoV3UaV32RvIcjl2bOS9trL5LaBFXDygvZUWt5Bttbfw2lHFYJ3/dOBJ
         +sh+I0bPEeKJvhAt2QJ5SG/NEAi2FkqXeGGD4iI3HPOR6PN5WJOF7eKCnsCadKkHKaLX
         GYIQ==
X-Gm-Message-State: AOAM5314Ifq3rNiOUK4c+VC2irJK3veUorZdKMcA5atJnWQ7Lok/7EkC
        +hIFAqbeF90YAJ6nLU3gOYKnKgNm5H63EWo4/9JifW37sCqIwMolo/dzJdYCMoocxW9vRq6F7YO
        FDFOVy6S6aztn2D/i
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr32858523edb.104.1622551706241;
        Tue, 01 Jun 2021 05:48:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT4o9fCef8iJstNGh0eh3PY+VROINQBqI1ea71IgfXv5FOIRwxrDjTd1abug9x7HPjelh/Vg==
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr32858494edb.104.1622551706099;
        Tue, 01 Jun 2021 05:48:26 -0700 (PDT)
Received: from localhost (net-188-218-12-178.cust.vodafonedsl.it. [188.218.12.178])
        by smtp.gmail.com with ESMTPSA id k21sm7216391ejp.23.2021.06.01.05.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 05:48:25 -0700 (PDT)
Date:   Tue, 1 Jun 2021 14:48:24 +0200
From:   Davide Caratti <dcaratti@redhat.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH net-next v3 2/3] net/sched: act_vlan: No dump for unset
 priority
Message-ID: <YLYsmMw9x2kXLIpk@dcaratti.users.ipa.redhat.com>
References: <20210530114052.16483-1-boris.sukholitko@broadcom.com>
 <20210530114052.16483-3-boris.sukholitko@broadcom.com>
 <20210531222136.26670598@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20210601123510.GA3940@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601123510.GA3940@builder>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 03:35:10PM +0300, Boris Sukholitko wrote:
> Hi Jacub,
> 
> On Mon, May 31, 2021 at 10:21:36PM -0700, Jakub Kicinski wrote:
> > On Sun, 30 May 2021 14:40:51 +0300 Boris Sukholitko wrote:
> > > diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c

[...]

> > > @@ -362,10 +362,19 @@ static int tcf_vlan_search(struct net *net, struct tc_action **a, u32 index)
> > >  
> > >  static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
> > >  {
> > > -	return nla_total_size(sizeof(struct tc_vlan))
> > > +	struct tcf_vlan *v = to_vlan(act);
> > > +	struct tcf_vlan_params *p;
> > > +	size_t ret = nla_total_size(sizeof(struct tc_vlan))
> > >  		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_ID */
> > > -		+ nla_total_size(sizeof(u16)) /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> > > -		+ nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> > > +		+ nla_total_size(sizeof(u16)); /* TCA_VLAN_PUSH_VLAN_PROTOCOL */
> > > +
> > > +	spin_lock_bh(&v->tcf_lock);
> > > +	p = rcu_dereference_protected(v->vlan_p, lockdep_is_held(&v->tcf_lock));
> > > +	if (p->tcfv_push_prio_exists)
> > > +		ret += nla_total_size(sizeof(u8)); /* TCA_VLAN_PUSH_VLAN_PRIORITY */
> > > +	spin_unlock_bh(&v->tcf_lock);
> > 
> > This jumps out a little bit - if we need to take this lock to inspect
> > tcf_vlan_params, then I infer its value may change. And if it may
> > change what guarantees it doesn't change between calculating the skb
> > length and dumping?
> > 
> > It's common practice to calculate the max skb len required when
> > attributes are this small.
> > 
> 
> I believe you are right.

ouch, that's my fault actually - it's true, TC rules can be
modified and dumped at the same time. Then the only thing we can
do is to account for TCA_VLAN_PUSH_VLAN_PRIORITY even if we will not
fill it.

thanks for spotting this,
-- 
davide


