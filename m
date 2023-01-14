Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A159066A86E
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 02:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjANBu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 20:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbjANBuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 20:50:25 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092A42675;
        Fri, 13 Jan 2023 17:50:24 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z11so33561224ede.1;
        Fri, 13 Jan 2023 17:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYP4ZfEP0gORAR9U9oC13zcVN959Hbpaca5T0mpAJ5k=;
        b=p8daRuwqCOXWWND7Uef3Y7rosGQKh3EfhYHuTWpei/CJHJGLAUFO/12zn0/zO761Ah
         KiSyirU71RS0To7tm/AEK+a+uYEVDXa5V5NJWYbp+yd/lu2tGhFbsIeMNEAkcFbOuPNA
         Ev/V9P/JAMmPZdLfyYBuO+VdsQK4tpH1R4eahJoIbQHCUbeNkwX8j9eDZ0m3S/DL9FzR
         RFnqFAV7tyaCu2so7h4YEQqd7rxRJCD840SR1khkz5i4qjhPK38AJe+tvzJq55UudvxV
         8lMzcmhh9eDTwwSJhQXHWzXZ1gsQGXZ0KTIx/ZH0YUbOU9pjo+g8IkoyJZ/b+OjD23wq
         ZOdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYP4ZfEP0gORAR9U9oC13zcVN959Hbpaca5T0mpAJ5k=;
        b=Q/NUJR8zmTWLYM18NT3YKo73SenVJ/nWViEsswXG8D+x3VSPfEQRNk7tDpKx6d5YtV
         J7WXqRhTw2zfh4iwAd20tAQsJ+M7rAULQykw27YQVcRthVhrZzzyIXl3S/xxHV7A2rdg
         TkD5Ng8PJDnQo8TpoTNkZETbAFoPdZ+eAXmZQXOQlBqnFygSCIlACldDqpY/QcW+PUaQ
         RhkpzmNey7AUBP84az/4ObijFIQXihrL9c7dj18grRnmKV7NGBoedjHgQXeEKpv0SD0W
         lE/V/0+B/kIhPHZJiIu5G9H0G3e9aBqM2uRUKdV3DnW4dUF++sjq1Y9HXDe2jw+3W4FL
         jRzQ==
X-Gm-Message-State: AFqh2koHJBqkjUqrG0aTy32+iPxPY9mCZr0o3Yei4iB21bYm9TaTLodv
        fo56PNy5eZFbW/yDgVXFptHK8KV6KuapWYKW1CbOKQ==
X-Google-Smtp-Source: AMrXdXsTRVmsYHcLdorBZdC5HgTMf2fWxXN7YQ3UIdHsOFlFVfd66JgE2Xx4f9yYji9bUbTjGICcNw==
X-Received: by 2002:a05:6402:1cca:b0:49c:d620:4bf8 with SMTP id ds10-20020a0564021cca00b0049cd6204bf8mr3413099edb.24.1673661022403;
        Fri, 13 Jan 2023 17:50:22 -0800 (PST)
Received: from localhost ([77.48.28.204])
        by smtp.gmail.com with ESMTPSA id bm15-20020a0564020b0f00b00499e797f613sm3341583edb.59.2023.01.13.17.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 17:50:21 -0800 (PST)
Date:   Sat, 14 Jan 2023 03:50:04 +0200
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, Naveen Mamindlapalli <naveenm@marvell.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: Re: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in
 offload mode
Message-ID: <Y8IKTP1hf21oLYvL@mail.gmail.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-2-hkelam@marvell.com>
 <Y8FMWs3XKuI+t0zW@mail.gmail.com>
 <87k01q400j.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k01q400j.fsf@nvidia.com>
X-Spam-Status: No, score=2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 01:06:52PM -0800, Rahul Rameshbabu wrote:
> On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> > On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
> >> From: Naveen Mamindlapalli <naveenm@marvell.com>
> >> 
> >> The current implementation of HTB offload returns the EINVAL error
> >> for unsupported parameters like prio and quantum. This patch removes
> >> the error returning checks for 'prio' parameter and populates its
> >> value to tc_htb_qopt_offload structure such that driver can use the
> >> same.
> >> 
> >> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> >> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> >> ---
> >>  include/net/pkt_cls.h | 1 +
> >>  net/sched/sch_htb.c   | 7 +++----
> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >> 
> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> >> index 4cabb32a2ad9..02afb1baf39d 100644
> >> --- a/include/net/pkt_cls.h
> >> +++ b/include/net/pkt_cls.h
> >> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
> >>  	u16 qid;
> >>  	u64 rate;
> >>  	u64 ceil;
> >> +	u8 prio;
> >>  };
> >>  
> >>  #define TC_HTB_CLASSID_ROOT U32_MAX
> >> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> >> index 2238edece1a4..f2d034cdd7bd 100644
> >> --- a/net/sched/sch_htb.c
> >> +++ b/net/sched/sch_htb.c
> >> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
> >>  			goto failure;
> >>  		}
> >> -		if (hopt->prio) {
> >> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
> >> -			goto failure;
> >> -		}
> >
> > The check should go to mlx5e then.
> >
> 
> Agreed. Also, I am wondering in general if its a good idea for the HTB
> offload implementation to be dictating what parameters are and are not
> supported.
> 
> 	if (q->offload) {
> 		/* Options not supported by the offload. */
> 		if (hopt->rate.overhead || hopt->ceil.overhead) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
> 			goto failure;
> 		}
> 		if (hopt->rate.mpu || hopt->ceil.mpu) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
> 			goto failure;
> 		}
> 		if (hopt->quantum) {
> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
> 			goto failure;
> 		}
> 	}

Jakub asked for that [1], I implemented it [2].

[1]: https://lore.kernel.org/all/20220113110801.7c1a6347@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/
[2]: https://lore.kernel.org/all/20220125100654.424570-1-maximmi@nvidia.com/

I think it's a good idea, unless you want to change the API to pass all
HTB parameters to drivers, see the next paragraph.

> Every time a vendor introduces support for a new offload parameter,
> netdevs that cannot support said parameter are affected. I think it
> would be better to remove this block and expect each driver to check
> what parameters are and are not supported for their offload flow.

How can netdevs check unsupported parameters if they don't even receive
them from HTB? The checks in HTB block parameters that aren't even part
of the API. If you extend the API (for example, with a new parameter),
you have to make sure existing drivers are not broken.

> 
> >>  	}
> >>  
> >>  	/* Keeping backward compatible with rate_table based iproute2 tc */
> >> @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  					TC_HTB_CLASSID_ROOT,
> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio = hopt->prio,
> >>  				.extack = extack,
> >>  			};
> >>  			err = htb_offload(dev, &offload_opt);
> >> @@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  					TC_H_MIN(parent->common.classid),
> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio = hopt->prio,
> >>  				.extack = extack,
> >>  			};
> >>  			err = htb_offload(dev, &offload_opt);
> >> @@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >>  				.classid = cl->common.classid,
> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> +				.prio = hopt->prio,
> >>  				.extack = extack,
> >>  			};
> >>  			err = htb_offload(dev, &offload_opt);
> >> -- 
> >> 2.17.1
> >> 
