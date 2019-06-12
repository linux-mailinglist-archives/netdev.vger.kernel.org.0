Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 909BF42E45
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 20:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFLSCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 14:02:48 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41987 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbfFLSCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 14:02:46 -0400
Received: by mail-qk1-f195.google.com with SMTP id b18so10954378qkc.9
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 11:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=D2UadACeHT7xXajSYmWbapHdLTzvJgQEjtcrt4Rw5eE=;
        b=atAc+7HeNoAX3IOBFqTYORG39DHyh+Eh1NOGQvy5AuYR749t+ypkoOoD3A8IymXlat
         otQiXWZENtbUGaAiDfCRQfUg4I6Xqh7VefeGENqMvqXHzCRWRZaNqUAZDmDTQa317CKR
         PSN7fThad1X8ldFb79TGgiyng7/1dZMmi26opdB5pVDnjw9bjFfojGrOYuU2M6yDBxOH
         hC7dYhzwcgV+GwAsLFbzNvF4RB7gYcuucU7cLmQR0azKNgL8pxVEoEs+QzzrcYKL5aEr
         ah4SmFqBHfB8kXnB0DjOv3UMF2ulSsMJmc5YviDGa4y6ZfGz3OgxtwgeOg7pa5k0lNuY
         jeMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=D2UadACeHT7xXajSYmWbapHdLTzvJgQEjtcrt4Rw5eE=;
        b=O332glXlylhzKfHr1CESE1r3/QsPq9sMxYRPWSkk1FKOg6p08txf+9rTepMV3Mbtdg
         dvuiGXZjZ8jnY0IW0qmP4tre95hasyzhhl7WHXJnsRoXFlCMStQtpPW4XQcuKXrlgmvZ
         TgSKGbvEmSuZ13rM5MovReoyG/aOfQX18f3WmIx2b+CMb84SYkvWKuOFiJf3xb/WtJIB
         V/Q2adXF0ERQ3smmmmc1U3+4N8pALbA2hDZVQ34DuBNTBco/ADHn4z/yYOSPLKWUpbLB
         4p9JORmguftAigkfc6XBIrS+fwq59Wh6DCuGhcNnxTV/mXINDYbZcxGISBf5evqpad8z
         Y/lw==
X-Gm-Message-State: APjAAAU5BmtwHDjDVxG5+SkDAR51b7PGYzkD8TgZj/L3tuknYBDXMSwy
        r8OmcLw3X4x5/WGJ9THPoXA=
X-Google-Smtp-Source: APXvYqxJ/De//GDFT4J4GwzP90rCgMDpTo9HlFswfnJxuSHyV8w42y5S07WspOZWSdrxnWrQkpj4zw==
X-Received: by 2002:a37:4a8a:: with SMTP id x132mr42779526qka.42.1560362565715;
        Wed, 12 Jun 2019 11:02:45 -0700 (PDT)
Received: from localhost.localdomain ([168.181.49.36])
        by smtp.gmail.com with ESMTPSA id j22sm214504qtp.0.2019.06.12.11.02.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 11:02:44 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id CA896C1BD5; Wed, 12 Jun 2019 15:02:39 -0300 (-03)
Date:   Wed, 12 Jun 2019 15:02:39 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        John Hurley <john.hurley@netronome.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>, dcaratti@redhat.com
Subject: Re: [PATCH net-next v6] net: sched: Introduce act_ctinfo action
Message-ID: <20190612180239.GA3499@localhost.localdomain>
References: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528170236.29340-1-ldir@darbyshire-bryant.me.uk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 05:03:50PM +0000, Kevin 'ldir' Darbyshire-Bryant wrote:
...
> +static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
> +			   struct nlattr *est, struct tc_action **a,
> +			   int ovr, int bind, bool rtnl_held,
> +			   struct tcf_proto *tp,
> +			   struct netlink_ext_ack *extack)
> +{
> +	struct tc_action_net *tn = net_generic(net, ctinfo_net_id);
> +	struct nlattr *tb[TCA_CTINFO_MAX + 1];
> +	struct tcf_ctinfo_params *cp_new;
> +	struct tcf_chain *goto_ch = NULL;
> +	u32 dscpmask = 0, dscpstatemask;
> +	struct tc_ctinfo *actparm;
> +	struct tcf_ctinfo *ci;
> +	u8 dscpmaskshift;
> +	int ret = 0, err;
> +
> +	if (!nla)
> +		return -EINVAL;
> +
> +	err = nla_parse_nested(tb, TCA_CTINFO_MAX, nla, ctinfo_policy, NULL);
                                                                       ^^^^
Hi, two things here:
Why not use the extack parameter here? Took me a while to notice
that the EINVAL was actually hiding the issue below.
And also on the other two EINVALs this function returns.


Seems there was a race when this code went in and the stricter check
added by
b424e432e770 ("netlink: add validation of NLA_F_NESTED flag") and
8cb081746c03 ("netlink: make validation more configurable for future
strictness").

I can't add these actions with current net-next and iproute-next:
# ~/iproute2/tc/tc action add action ctinfo dscp 0xfc000000 0x01000000
Error: NLA_F_NESTED is missing.
We have an error talking to the kernel

This also happens with the current post of act_ct and should also
happen with the act_mpls post (thus why Cc'ing John as well).

I'm not sure how we should fix this. In theory the kernel can't get
stricter with userspace here, as that breaks user applications as
above, so older actions can't use the more stricter parser. Should we
have some actions behaving one way, and newer ones in a different way?
That seems bad.

Or maybe all actions should just use nla_parse_nested_deprecated()?
I'm thinking this last. Yet, then the _deprecated suffix may not make
much sense here. WDYT?

Thanks,
Marcelo
