Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB3FCAC0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 17:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKNQ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 11:29:54 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39472 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfKNQ3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 11:29:54 -0500
Received: by mail-qk1-f193.google.com with SMTP id 15so5498664qkh.6;
        Thu, 14 Nov 2019 08:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Etq+ZZLehuQdqs1e3s2Ev3L0ve5IMuF3F+oENs00DHk=;
        b=efZeLNh8qrmA+sLeSOthCoIYWYgM+hh3MW3YpbgA+Ee0nkWXg9PznusvGodqjefIr+
         Vq4aVJ96nuCe4wIpJZ9EkZYUoh4XQs/t3UQAzDmSFZVrQaoC+Tib1fauHQU6rXn6/EU4
         mGc8+cEjHU5TaTGLW21fxoOSkWfwCcHepXw8oWmAp/6szm5FSHmRAjJqWavrHyCiQ+Nm
         NhU6s+ertjFoxYdjSg+MMprtlREBfj9O9NUDMb6RJns4lsurr1/VEPpg5Pb/ldZ3dx02
         pLe6KKqzKVkzr+1afmCdMP+qshc0K6sge7jJb6RwSl7uDXwafZyggfLbsrK0owUJhCDb
         JVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Etq+ZZLehuQdqs1e3s2Ev3L0ve5IMuF3F+oENs00DHk=;
        b=XvuP7KvEnBDVRIOXJfDAPQrK6vQ75eiOtGXPiSx2u398FXXjBrjyfMXz2ZeCW0NO/d
         73XRNyheORVto7JZMC8YvmQK1bAqJ3aHdoKYcgntZT0o32iwXaqHftUepgSiOLozlWP3
         6gTG4SYxbCbvc/gzIZaeAQcV87gfSFpm7uNFE8IrSBJ1eoj0V4rCLTqXS8rO3n0Uvk7d
         a8j6qMxciKMyOmTQu0BzwbdTL+5QREnbd6gMYUWx0MthpNKITtA47IgM45hjkRknn/0t
         oiG15Rc5hupfTSqbGZJd//O3OSb/t3cGCOfxnnA1FsspiNmK2XKACoPD17fgIb/u0gaK
         KTvA==
X-Gm-Message-State: APjAAAUMtKaJ7e0Qv8UV2RM2+eaRAEh66Y660nE4WAK9ud2IyomFsqMk
        UcSVHZo7f6l+ytfZapHgN+U=
X-Google-Smtp-Source: APXvYqzViwFybatYL+Yoq+i7GWng93cFYBn8+ugVzmW2kzmWbEhzLjXQb1HoPxY4pvW8WQcThtLr0Q==
X-Received: by 2002:a05:620a:12a3:: with SMTP id x3mr8157689qki.336.1573748992934;
        Thu, 14 Nov 2019 08:29:52 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:e3d4::1])
        by smtp.gmail.com with ESMTPSA id k29sm3029590qtu.70.2019.11.14.08.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 08:29:52 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id A35AEC4B42; Thu, 14 Nov 2019 13:29:49 -0300 (-03)
Date:   Thu, 14 Nov 2019 13:29:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, paulb@mellanox.com
Subject: Re: [PATCH net 2/2] act_ct: support asymmetric conntrack
Message-ID: <20191114162949.GB3419@localhost.localdomain>
References: <20191108210714.12426-1-aconole@redhat.com>
 <20191108210714.12426-2-aconole@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108210714.12426-2-aconole@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 04:07:14PM -0500, Aaron Conole wrote:
> The act_ct TC module shares a common conntrack and NAT infrastructure
> exposed via netfilter.  It's possible that a packet needs both SNAT and
> DNAT manipulation, due to e.g. tuple collision.  Netfilter can support
> this because it runs through the NAT table twice - once on ingress and
> again after egress.  The act_ct action doesn't have such capability.
> 
> Like netfilter hook infrastructure, we should run through NAT twice to
> keep the symmetry.
> 
> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
> 
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
>  net/sched/act_ct.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index fcc46025e790..f3232a00970f 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -329,6 +329,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  			  bool commit)
>  {
>  #if IS_ENABLED(CONFIG_NF_NAT)
> +	int err;
>  	enum nf_nat_manip_type maniptype;
>  
>  	if (!(ct_action & TCA_CT_ACT_NAT))
> @@ -359,7 +360,17 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  		return NF_ACCEPT;
>  	}
>  
> -	return ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	if (err == NF_ACCEPT &&
> +	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
> +		if (maniptype == NF_NAT_MANIP_SRC)
> +			maniptype = NF_NAT_MANIP_DST;
> +		else
> +			maniptype = NF_NAT_MANIP_SRC;
> +
> +		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
> +	}

I keep thinking about this and I'm not entirely convinced that this
shouldn't be simpler. More like:

if (DNAT)
	DNAT
if (SNAT)
	SNAT

So it always does DNAT before SNAT, similarly to what iptables would
do on PRE/POSTROUTING chains.

> +	return err;
>  #else
>  	return NF_ACCEPT;
>  #endif
> -- 
> 2.21.0
> 
