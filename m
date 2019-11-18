Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A51100EE8
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 23:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKRWlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 17:41:00 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:43016 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfKRWlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 17:41:00 -0500
Received: by mail-qv1-f66.google.com with SMTP id cg2so7289864qvb.10;
        Mon, 18 Nov 2019 14:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sZdC4vqQ43VNOnMIxV/dGjIpbV52hvN58hPGe7bOOWI=;
        b=AyNlBipnz5IA0/CKWwCQWcYqz1/TsqZ2E10s9HYOf9vv+Kb0tWk12yIqAJAYwh1r6d
         JLAfv9qig9BLvJy4AB9fKNPRFu+kbHp7NLPBfspNRljdxfrLpUchc6N/pEA1QUCF1QW4
         U5AROxmrIr4bN5F+4SvjlaJseXwGjyXBJZEWysCi6BOMgJnkQzt3zdNvz8t07WchTdh0
         4P9b+dVFhsVg0acFhOA59U8l8pGN2gS90bA/FDsCPwsBWZB0tzbjklp7ZBaUBJsSYBDn
         x0SYktB2QvYK1s0a8g2r+Pk26fQfBPj1ui8W/XRyS5JY9y3bzYKU5mZVuEC93XIDlcmR
         T+AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sZdC4vqQ43VNOnMIxV/dGjIpbV52hvN58hPGe7bOOWI=;
        b=TtM/uQ+kT/nXuIXPj0ZshDDHiNpAyDK0VOodTzk08Rx1iqf6I0gsdzepYjzAcKf+I9
         bIiBm0Qz9pEZ3axPSh/eIjBK3oE6y2vYmcqkHKWYa9SveuDgKATQrIPzrkycPX/u7V+x
         F0kLGCIRbNiBWdGG7Bm7qpRKFCfGXXNvAUqwzqknz5M2LhUw/bJK8JartWhFplaUPHTe
         rUwkiFDglNCwdqPJX9+mvfMli/pRUYvdeI0p4Myfr+pPushwvBP2VDn4jS2Bo8vCTIr4
         Okmj4VUz85ZuPWrRTWw5Edn6DinrRbam/IlhNS+Z27rhwJEKLQoCZ+rD3mlnTt0XgJ50
         HDKg==
X-Gm-Message-State: APjAAAVnzKW+5FVgUmvf44kG+U7TYHysWcz1NbBTSG9MyZdEizgbQ3vA
        JS8+7DqbLqsUW+JA3tF26ww=
X-Google-Smtp-Source: APXvYqyg2giaP82C5jnycov/YY7fMGLh9p2IZ6cW/LF+VLItK4d/vxgfOu1NIK7XIBV0YJUj7lhheg==
X-Received: by 2002:a0c:c211:: with SMTP id l17mr9032327qvh.55.1574116858313;
        Mon, 18 Nov 2019 14:40:58 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f022:db90:e53b:1344:8965:c548])
        by smtp.gmail.com with ESMTPSA id y24sm9134326qki.104.2019.11.18.14.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 14:40:57 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id EED10C4B42; Mon, 18 Nov 2019 19:40:54 -0300 (-03)
Date:   Mon, 18 Nov 2019 19:40:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, paulb@mellanox.com,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
Message-ID: <20191118224054.GB388551@localhost.localdomain>
References: <20191108210714.12426-1-aconole@redhat.com>
 <20191108210714.12426-2-aconole@redhat.com>
 <20191114162949.GB3419@localhost.localdomain>
 <f7to8x8yj6k.fsf@dhcp-25.97.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7to8x8yj6k.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 04:21:39PM -0500, Aaron Conole wrote:
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:
> 
> > On Fri, Nov 08, 2019 at 04:07:14PM -0500, Aaron Conole wrote:
> >> The act_ct TC module shares a common conntrack and NAT infrastructure
> >> exposed via netfilter.  It's possible that a packet needs both SNAT and
> >> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> >> this because it runs through the NAT table twice - once on ingress and
> >> again after egress.  The act_ct action doesn't have such capability.
> >> 
> >> Like netfilter hook infrastructure, we should run through NAT twice to
> >> keep the symmetry.
> >> 
> >> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> >> 
> >> Signed-off-by: Aaron Conole <aconole@redhat.com>
> >> ---
> >>  net/sched/act_ct.c | 13 ++++++++++++-
> >>  1 file changed, 12 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> index fcc46025e790..f3232a00970f 100644
> >> --- a/net/sched/act_ct.c
> >> +++ b/net/sched/act_ct.c
> >> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >>  			  bool commit)
> >>  {
> >>  #if IS_ENABLED(CONFIG_NF_NAT)
> >> +	int err;
> >>  	enum nf_nat_manip_type maniptype;
> >>  
> >>  	if (!(ct_action & TCA_CT_ACT_NAT))
> >> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >>  		return NF_ACCEPT;
> >>  	}
> >>  
> >> -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> +	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> +	if (err == NF_ACCEPT &&
> >> +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> >> +		if (maniptype == NF_NAT_MANIP_SRC)
> >> +			maniptype = NF_NAT_MANIP_DST;
> >> +		else
> >> +			maniptype = NF_NAT_MANIP_SRC;
> >> +
> >> +		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> +	}
> >
> > I keep thinking about this and I'm not entirely convinced that this
> > shouldn't be simpler. More like:
> >
> > if (DNAT)
> > 	DNAT
> > if (SNAT)
> > 	SNAT
> >
> > So it always does DNAT before SNAT, similarly to what iptables would
> > do on PRE/POSTROUTING chains.
> 
> I can rewrite the whole function, but I wanted to start with the smaller
> fix that worked.  I also think it needs more testing then (since it's
> something of a rewrite of the function).
> 
> I guess it's not too important - do you think it gives any readability
> to do it this way?  If so, I can respin the patch changing it like you
> describe.

I didn't mean a rewrite, but just to never handle SNAT before DNAT. So
the fix here would be like:

-	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+	if (err == NF_ACCEPT && maniptype == NF_NAT_MANIP_DST &&
+	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
+		maniptype = NF_NAT_MANIP_SRC;
+		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+	}
+	return err;

> >> +	return err;
> >>  #else
> >>  	return NF_ACCEPT;
> >>  #endif
> >> -- 
> >> 2.21.0
> >> 
> 
