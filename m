Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A81107993
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbfKVUnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:43:13 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43916 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfKVUnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:43:13 -0500
Received: by mail-qk1-f194.google.com with SMTP id p14so7453515qkm.10;
        Fri, 22 Nov 2019 12:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nEv2txPCVLSV4T8XOiHXL1dnMJXAnHX5LR4vdUFzACU=;
        b=oM6RXqw8iLUj+Ehpij017e9+fohwwSATEdVEux0stfyhSaBNuVE4s2ePhoaz9gQ+eq
         w5NqPEJNCP7qvXVDFjISFHQDQospQu4Bae0VYYelBzc45G5XLegFqss/jpkSiqRpbKG2
         4EmXGtuDST1iGrfeU3YcNafHvAElHMXBucuCN0MjmcZZsLmbMaU2ZKKDKoOoeVpywgfw
         0MeQLkcrnL8oaHJPmVE8quA35e0RX9znxT+PGYCp5yHhVYty961LC5uI5eTbWDIlE2Tp
         ghAM2dC9GJwvm3tZbMNVNN+WkBcvf6LP4++VoHMpT1kJfOsJi7PDSot0TGC8zA86X8L5
         FBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nEv2txPCVLSV4T8XOiHXL1dnMJXAnHX5LR4vdUFzACU=;
        b=QipIfKs2yjEIfOFmOpPujXzRQvuVgZ0Ee3AGuUHE/EEz8rFAb/PeOYnVUImkYNtZ1U
         QjrzRkZ0EptODQEkJ7XJkg5nKCc1J4VlwX44hpLJ7T9N41IEZS78iv2v7xyy9+2HkIq5
         T0slJ9CD/O5LLpdyw1+FtpJBMtjarZGWBsfrMjZtDDB1YlJVq5J1WihixfUhBeHiEETf
         w/ilN7QZZQlzVGZn6r50gw2H3cQ1sxuCJaGBJNStHEJefqX49IMNmYLswRbaYhtzAUSY
         O6iiX5LKkUJ23UPVM6iH9ZiSJjVucs5pzK9YP08KlVfMIKn372NGMxhWxIAav4IX+4qX
         f9yA==
X-Gm-Message-State: APjAAAUZOZdJ5k6CDxzM5UcwIbDJS/MMo7TlLbh4pChTFUKK6CZf31F8
        xQJWEPyvDUGxetSEM1QyxGPJZI8Cd177Rw==
X-Google-Smtp-Source: APXvYqzZ+Vrc859YA7hWLp2f/AWDMMqsUIwomolrDMwRF6M3dwopg7/M920/sk0ddph/3rw7YjcR5g==
X-Received: by 2002:a37:9146:: with SMTP id t67mr9276700qkd.98.1574455391169;
        Fri, 22 Nov 2019 12:43:11 -0800 (PST)
Received: from localhost.localdomain ([177.220.176.157])
        by smtp.gmail.com with ESMTPSA id d18sm3461078qko.112.2019.11.22.12.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 12:43:10 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 61954C3AB5; Fri, 22 Nov 2019 17:43:07 -0300 (-03)
Date:   Fri, 22 Nov 2019 17:43:07 -0300
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
Message-ID: <20191122204307.GG388551@localhost.localdomain>
References: <20191108210714.12426-1-aconole@redhat.com>
 <20191108210714.12426-2-aconole@redhat.com>
 <20191114162949.GB3419@localhost.localdomain>
 <f7to8x8yj6k.fsf@dhcp-25.97.bos.redhat.com>
 <20191118224054.GB388551@localhost.localdomain>
 <f7tv9rbmyrv.fsf@dhcp-25.97.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7tv9rbmyrv.fsf@dhcp-25.97.bos.redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 03:39:16PM -0500, Aaron Conole wrote:
> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:
> 
> > On Mon, Nov 18, 2019 at 04:21:39PM -0500, Aaron Conole wrote:
> >> Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> writes:
> >> 
> >> > On Fri, Nov 08, 2019 at 04:07:14PM -0500, Aaron Conole wrote:
> >> >> The act_ct TC module shares a common conntrack and NAT infrastructure
> >> >> exposed via netfilter.  It's possible that a packet needs both SNAT and
> >> >> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> >> >> this because it runs through the NAT table twice - once on ingress and
> >> >> again after egress.  The act_ct action doesn't have such capability.
> >> >> 
> >> >> Like netfilter hook infrastructure, we should run through NAT twice to
> >> >> keep the symmetry.
> >> >> 
> >> >> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> >> >> 
> >> >> Signed-off-by: Aaron Conole <aconole@redhat.com>
> >> >> ---
> >> >>  net/sched/act_ct.c | 13 ++++++++++++-
> >> >>  1 file changed, 12 insertions(+), 1 deletion(-)
> >> >> 
> >> >> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> >> >> index fcc46025e790..f3232a00970f 100644
> >> >> --- a/net/sched/act_ct.c
> >> >> +++ b/net/sched/act_ct.c
> >> >> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >> >>  			  bool commit)
> >> >>  {
> >> >>  #if IS_ENABLED(CONFIG_NF_NAT)
> >> >> +	int err;
> >> >>  	enum nf_nat_manip_type maniptype;
> >> >>  
> >> >>  	if (!(ct_action & TCA_CT_ACT_NAT))
> >> >> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
> >> >>  		return NF_ACCEPT;
> >> >>  	}
> >> >>  
> >> >> -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> >> +	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> >> +	if (err == NF_ACCEPT &&
> >> >> +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> >> >> +		if (maniptype == NF_NAT_MANIP_SRC)
> >> >> +			maniptype = NF_NAT_MANIP_DST;
> >> >> +		else
> >> >> +			maniptype = NF_NAT_MANIP_SRC;
> >> >> +
> >> >> +		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> >> >> +	}
> >> >
> >> > I keep thinking about this and I'm not entirely convinced that this
> >> > shouldn't be simpler. More like:
> >> >
> >> > if (DNAT)
> >> > 	DNAT
> >> > if (SNAT)
> >> > 	SNAT
> >> >
> >> > So it always does DNAT before SNAT, similarly to what iptables would
> >> > do on PRE/POSTROUTING chains.
> >> 
> >> I can rewrite the whole function, but I wanted to start with the smaller
> >> fix that worked.  I also think it needs more testing then (since it's
> >> something of a rewrite of the function).
> >> 
> >> I guess it's not too important - do you think it gives any readability
> >> to do it this way?  If so, I can respin the patch changing it like you
> >> describe.
> >
> > I didn't mean a rewrite, but just to never handle SNAT before DNAT. So
> > the fix here would be like:
> >
> > -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> > +	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> > +	if (err == NF_ACCEPT && maniptype == NF_NAT_MANIP_DST &&
> > +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> > +		maniptype = NF_NAT_MANIP_SRC;
> > +		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> > +	}
> > +	return err;
> 
> But the maniptype of the first call could be NAT_MANIP_SRC.  In fact,
> that's what I see if the packet is reply direction && !related.

Interesting, ok.

> 
> So, we need the block to invert the manipulation type.  Otherwise, we
> miss the DNAT manipulation.
> 
> So I don't think I can use that block.

Thanks for digging on it.

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> 
> >> >> +	return err;
> >> >>  #else
> >> >>  	return NF_ACCEPT;
> >> >>  #endif
> >> >> -- 
> >> >> 2.21.0
> >> >> 
> >> 
> 
