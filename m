Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A1C66BCDD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjAPL1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjAPL1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:27:33 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14EC1F48E;
        Mon, 16 Jan 2023 03:27:12 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kt14so8450787ejc.3;
        Mon, 16 Jan 2023 03:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7RU/jAVTYRq13tnDju69u81AWbh/npY+C//ebXqISzw=;
        b=NZPFA9HR4A2H2ZqAi0Lk8N6b+8aBy0x6M6qIKs/nhV1K3eLml8JCJOp3Q8TRy+LcVh
         b+o8AwbbSAuvg4XhsZSMzFWHqJXd6o2ON1ms64rwP/hk0Vu8PvHg7Vft0l9H3rHHlmAt
         ZI30C6dTeIi/lsR+P3khWM6YGr9+yFtvEpp4+uY5NbwEZSuqfgKM5ytqi88XJW/va2ek
         ru4Cat7prlz1nByng0euGqkzZO5mhx7oRedHcrV2fV4BNbteyqoA0RWsr/M4x6KvNQ+Z
         0kaHHO8/CyUGKNI+uVtfq9qicSksQk6HMXseml1uvR76iW49lTn1gwaL+FAF1lzZMb1J
         Mz/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7RU/jAVTYRq13tnDju69u81AWbh/npY+C//ebXqISzw=;
        b=uMQftHud/qBfy/HiWu4pC91Zc+bKkat7SzO3EmFmU6WqFEdS5mnvIQj4tqpFgGeH60
         IkTRrC4m4P5HRg4JSi3f57/nECx8LG6JQy7oLPN+rbgPoynK2pXm3DV81O9rVpheYKJO
         xu60v0nqs2vuMty7kKqlW0dC8KH+IuNBSm04vYJLLV/8Jt701pfGovu8c7KgaDYSiBN+
         RtKezozCTEyE4d4K8ngIhPZOyldT6+rpk9ct27lznlpiSs6sG1XENf7FbrV+fi0QS6k1
         1rL6fPmdOBYMPkPn8TB0S5iVGsbxaJ+ALm8AxgP7zGAvWeWmIuTyZNdjMA0InC/yn6lI
         Gj8g==
X-Gm-Message-State: AFqh2krpv9CWaRPZDYLybmmUc5t5VOGgAjs+njacxhSbO074HaBXPVdF
        qBtDbO1iFWZdeXs65KQPgQU=
X-Google-Smtp-Source: AMrXdXvZL3FU2cub0TYfkO1fFfisgfXYeDSU1L7B9wAKXcRmobnNnekIHqC9qaoEKrNTBVsgnkX78g==
X-Received: by 2002:a17:906:99ca:b0:871:9359:3763 with SMTP id s10-20020a17090699ca00b0087193593763mr1154929ejn.40.1673868430977;
        Mon, 16 Jan 2023 03:27:10 -0800 (PST)
Received: from localhost (tor-exit-1.zbau.f3netze.de. [185.220.100.252])
        by smtp.gmail.com with ESMTPSA id k8-20020a1709062a4800b0083ffb81f01esm11684468eje.136.2023.01.16.03.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 03:27:10 -0800 (PST)
Date:   Mon, 16 Jan 2023 13:27:03 +0200
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
Message-ID: <Y8U0h/TVw5dCpPEq@mail.gmail.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
 <20230112173120.23312-2-hkelam@marvell.com>
 <Y8FMWs3XKuI+t0zW@mail.gmail.com>
 <87k01q400j.fsf@nvidia.com>
 <Y8IKTP1hf21oLYvL@mail.gmail.com>
 <87fscd505e.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fscd505e.fsf@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 06:18:37PM -0800, Rahul Rameshbabu wrote:
> On Sat, 14 Jan, 2023 03:50:04 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> > On Fri, Jan 13, 2023 at 01:06:52PM -0800, Rahul Rameshbabu wrote:
> >> On Fri, 13 Jan, 2023 14:19:38 +0200 Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
> >> > On Thu, Jan 12, 2023 at 11:01:16PM +0530, Hariprasad Kelam wrote:
> >> >> From: Naveen Mamindlapalli <naveenm@marvell.com>
> >> >> 
> >> >> The current implementation of HTB offload returns the EINVAL error
> >> >> for unsupported parameters like prio and quantum. This patch removes
> >> >> the error returning checks for 'prio' parameter and populates its
> >> >> value to tc_htb_qopt_offload structure such that driver can use the
> >> >> same.
> >> >> 
> >> >> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> >> >> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> >> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> >> >> ---
> >> >>  include/net/pkt_cls.h | 1 +
> >> >>  net/sched/sch_htb.c   | 7 +++----
> >> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >> >> 
> >> >> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> >> >> index 4cabb32a2ad9..02afb1baf39d 100644
> >> >> --- a/include/net/pkt_cls.h
> >> >> +++ b/include/net/pkt_cls.h
> >> >> @@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
> >> >>  	u16 qid;
> >> >>  	u64 rate;
> >> >>  	u64 ceil;
> >> >> +	u8 prio;
> >> >>  };
> >> >>  
> >> >>  #define TC_HTB_CLASSID_ROOT U32_MAX
> >> >> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> >> >> index 2238edece1a4..f2d034cdd7bd 100644
> >> >> --- a/net/sched/sch_htb.c
> >> >> +++ b/net/sched/sch_htb.c
> >> >> @@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >> >>  			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
> >> >>  			goto failure;
> >> >>  		}
> >> >> -		if (hopt->prio) {
> >> >> -			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
> >> >> -			goto failure;
> >> >> -		}
> >> >
> >> > The check should go to mlx5e then.
> >> >
> >> 
> >> Agreed. Also, I am wondering in general if its a good idea for the HTB
> >> offload implementation to be dictating what parameters are and are not
> >> supported.
> >> 
> >> 	if (q->offload) {
> >> 		/* Options not supported by the offload. */
> >> 		if (hopt->rate.overhead || hopt->ceil.overhead) {
> >> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
> >> 			goto failure;
> >> 		}
> >> 		if (hopt->rate.mpu || hopt->ceil.mpu) {
> >> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
> >> 			goto failure;
> >> 		}
> >> 		if (hopt->quantum) {
> >> 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
> >> 			goto failure;
> >> 		}
> >> 	}
> >
> > Jakub asked for that [1], I implemented it [2].
> >
> > [1]: https://lore.kernel.org/all/20220113110801.7c1a6347@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net/
> > [2]: https://lore.kernel.org/all/20220125100654.424570-1-maximmi@nvidia.com/
> >
> > I think it's a good idea, unless you want to change the API to pass all
> > HTB parameters to drivers, see the next paragraph.
> >
> >> Every time a vendor introduces support for a new offload parameter,
> >> netdevs that cannot support said parameter are affected. I think it
> >> would be better to remove this block and expect each driver to check
> >> what parameters are and are not supported for their offload flow.
> >
> > How can netdevs check unsupported parameters if they don't even receive
> > them from HTB? The checks in HTB block parameters that aren't even part
> > of the API. If you extend the API (for example, with a new parameter),
> > you have to make sure existing drivers are not broken.
> 
> They can if tc_htb_qopt_offload contains placeholders for every
> unsupported parameter. Then, the responsibility of indicating whether
> those parameters are supported in an offload or not moves to the drivers
> that should look at those parameters and see if they are set with
> non-default values.

Yes, but why add fields and pass them to the drivers if they are not
used, and some of them probably will never be used? This approach is
also not a role model of robustness, because:

1. The need to add these checks to each driver is not obvious, and a new
driver may easily miss them. As a reviewer, I will not even notice it,
because I don't know hardware specifics of each and every NIC.

2. Let's say, a new parameter gets added to HTB. In this case, a check
will have to be added to every driver, or HTB will end up having
"supported for offload" and "unsupported for offload" fields anyway,
just as it has now.

> My concern is that, if another driver implementer decides to introduce
> support for one of the other parameters, this becomes a growing chain of
> maintainers that need to review since every driver that chooses to adopt
> htb offload is subject to being impacted by future parameters supported.
> I agree this is unavoidable, if a new parameter is added for htb
> altogether, but if netdev drivers adopt a practice of checking these
> parameters, it becomes very easy for a feature author to just add
> another check in those drivers that already make use of htb offload.

Yes, your suggestion simplifies life for authors of existing drivers who
want to add a new feature, but it's more risky for new drivers, and it
doesn't work when HTB itself wants to add a new parameter.

Status quo is something that I would expect to be more natural for
kernel developers:

1. If you are an author of a new driver, implement the API in whole, or
it's your responsibility to check for unsupported parts.

2. If you are extending the API, make sure to fix the existing users.

> In the patch you authored and linked, you mention the following.
> 
>   If future drivers support more offload parameters, the checks can be moved
>   to the driver side.
> 
> I think this is good opportunity to make that move.

I didn't mean "if a future driver supports one more parameter, let's
make all drivers check all parameters". The meaning is: the list of
unsupported parameters is not carved in stone; if a new driver supports
more parameters, the checks for those parameters can be moved to the
drivers. In our case, it's one new parameter.

> 
> Btw, as you previously pointed, this is the change in behavior seen but
> the mlx5 netdevs do not support the prio parameter, so we will need to
> add a driver side check.

I would expect the patch authors to do it :)

BTW, discussing where to do the checks is all fun until you realize not
all parameters can even be checked on HTB level, for example, we can't
detect whether the user has set buffer and cbuffer, because tc assigns
some defaults if they are omitted from the command line. If you have
good ideas how it can be fixed, please share.

> 
>   /opt/mellanox/iproute2/sbin/tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 89900kbit cburst 89900kbit prio 8
>   Error: HTB offload doesn't support the prio parameter.
> 
>   /opt/mellanox/iproute2/sbin/tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst 89900kbit cburst 89900kbit prio 8
>   # No error since support is being added in the htb offload API
> 
> >
> >> 
> >> >>  	}
> >> >>  
> >> >>  	/* Keeping backward compatible with rate_table based iproute2 tc */
> >> >> @@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >> >>  					TC_HTB_CLASSID_ROOT,
> >> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> >> +				.prio = hopt->prio,
> >> >>  				.extack = extack,
> >> >>  			};
> >> >>  			err = htb_offload(dev, &offload_opt);
> >> >> @@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >> >>  					TC_H_MIN(parent->common.classid),
> >> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> >> +				.prio = hopt->prio,
> >> >>  				.extack = extack,
> >> >>  			};
> >> >>  			err = htb_offload(dev, &offload_opt);
> >> >> @@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
> >> >>  				.classid = cl->common.classid,
> >> >>  				.rate = max_t(u64, hopt->rate.rate, rate64),
> >> >>  				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
> >> >> +				.prio = hopt->prio,
> >> >>  				.extack = extack,
> >> >>  			};
> >> >>  			err = htb_offload(dev, &offload_opt);
> >> >> -- 
> >> >> 2.17.1
> >> >> 
