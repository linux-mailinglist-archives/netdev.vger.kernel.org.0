Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF24154D8B0
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348912AbiFPC6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347736AbiFPC6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:58:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966FD45067
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 19:58:12 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so550057pjl.5
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 19:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qUuIolFoUpQQdptoOJK/Qo9Q+8TTX/i2v/BnRCYeYi0=;
        b=pYcoB1iV44NRXAhWpH0+gXrAmmONlVX6FX3mlq6L22OJ4TAwvPht9L7wrKCBG9Yd4i
         cPFviG4JVPQXgvfkSEmGzBS3HHj/GoApvZkzXBd/k/Aj0X34VeNOcpCwnQpCYJgydvWT
         PsjTtZUmm37dVofaUizGf6L+2UM2tKS01nFfAE2DzUnwFofqi/km9Mmr2ZzymhHgwF/u
         ZGFC68wfghGH3ZTtX56mdTrCQjU9uYQiLFg+Pm2JcEGGKsJNG2Aq2cQZP5Nt/36rILTG
         OVAF7McavlOPilLHvbqIi6LTp/r7ltRWJHDFJfSrLv1FDQXepmJkKw6YJ6kNVKw4Lr+Q
         ImqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qUuIolFoUpQQdptoOJK/Qo9Q+8TTX/i2v/BnRCYeYi0=;
        b=U4ErfbQhP7A041Jp1lnyuj9pOelgBvLNxNHLzmiV3GD32+pNmkpZa/doSgsf1mrAUq
         bhfbWDrpCfnFL51AmarCcOdIE+WAQSXcCMFpBH+uCg4dQEm6e+RXh4tzNdYvmEy0kd4d
         ePjhrKo49KWFimMrcnlloE+RjThSHprxs/byqqygaa+lavLmaBN/NWliZyvZDGeG25ir
         wxVgJDb1bjIzDoUqB9fBzqN/5JJeQ5HB8iCXEj7sGZXkAGFSiOc6Dkpvs1a33+uHTfw7
         WpCFiqoZcAdggT9C8YEJ/jn/TB6+QS1tmQAvU2+cM7TkgWp39yKm9unE2j512M+d5ygs
         wMcw==
X-Gm-Message-State: AJIora9JuIZbyX+iARUNKFu7XKIay7KUMqYHHVPmmxoZQGt3HC7Hj28d
        7G+Z8/PeEQK6Z3QeRS93EJ48LmHL/Ok=
X-Google-Smtp-Source: AGRyM1sQ5lMzOLlJ11Zy3/hvYQ2SgL8CrdBRql/cqZ6bX0Kf98UadbhVBFMXQeydKZr8YtQyXE0fgw==
X-Received: by 2002:a17:90a:e818:b0:1e3:3c67:7781 with SMTP id i24-20020a17090ae81800b001e33c677781mr13683440pjy.72.1655348291987;
        Wed, 15 Jun 2022 19:58:11 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y8-20020a056a00190800b0050dc76281b4sm371711pfi.142.2022.06.15.19.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 19:58:11 -0700 (PDT)
Date:   Thu, 16 Jun 2022 10:58:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Message-ID: <YqqcPcXO8rlM52jJ@Laptop-X1>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
 <c5d45c3f-065d-c8e7-fcc6-4cdb54bfdd70@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5d45c3f-065d-c8e7-fcc6-4cdb54bfdd70@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 01:44:57PM -0400, Jonathan Toppins wrote:
> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> > index 43be3782e5df..53a18ff7cf23 100644
> > --- a/Documentation/networking/bonding.rst
> > +++ b/Documentation/networking/bonding.rst
> > @@ -780,6 +780,17 @@ peer_notif_delay
> >   	value is 0 which means to match the value of the link monitor
> >   	interval.
> > +prio
> > +	Slave priority. A higher number means higher priority.
> > +	The primary slave has the highest priority. This option also
> > +	follows the primary_reselect rules.
> > +
> > +	This option could only be configured via netlink, and is only valid
> > +	for active-backup(1), balance-tlb (5) and balance-alb (6) mode.
> > +	The valid value range is a signed 32 bit integer.
> > +
> > +	The default value is 0.
> 
> Why is this a signed 32 bit number? Why not a u8, it would seem 256 [255,0]
> options is more than enough to select from. Is there a specific reason it
> needs to be an s32?

The main reason is to compatible with team prio option, which also use a s32
value.

If you think s32 is too wide, how about s16? As u8 looks a little tight.
And follow are the reasons I prefer using singed value.

> 
> If the reason for selecting a signed value is so that the default priority
> could be in the middle of the range, why not just set the default to be 128,
> assuming u8 is wide enough?

First, 128 looks like a weird default value to me as a user.
0/1 as a default looks more reasonable.

Second. If I'm a user, other than using like 111, 125, 128, 130,
I'd prefer to use a multiple of 10 as priority number. e.g. -10, 20, 100, -200.

I know someone prefer a positive value as priority number. But given the
convenience of using negative value for a less wanted slave. I personally
prefer a singed value for priority setting.

Hi, Jay, what do you think?

> > @@ -157,6 +162,20 @@ static int bond_slave_changelink(struct net_device *bond_dev,
> >   			return err;
> >   	}
> > +	if (data[IFLA_BOND_SLAVE_PRIO]) { > +		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
> > +		char prio_str[IFNAMSIZ + 7];
> > +
> > +		/* prio option setting expects slave_name:prio */
> > +		snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
> > +			 slave_dev->name, prio);
> > +
> > +		bond_opt_initstr(&newval, prio_str);
> 
> It might be less code and a little cleaner to extend struct bond_opt_value
> with a slave pointer.
> 
> 	struct bond_opt_value {
> 		char *string;
> 		u64 value;
> 		u32 flags;
> 		union {
> 			char cextra[BOND_OPT_EXTRA_MAXLEN];
> 			struct net_device *slave_dev;
> 		} extra;
> 	};
> 
> Then modify __bond_opt_init to set the slave pointer, basically a set of
> bond_opt_slave_init{} macros. This would remove the need to parse the slave
> interface name in the set function. Setting .flags = BOND_OPTFLAG_RAWVAL
> (already done I see) in the option definition to avoid bond_opt_parse() from
> loosing our extra information by pointing to a .values table entry. Now in
> the option specific set function we can just find the slave entry and set
> the value, no more string parsing code needed.

This looks reasonable to me. It would make all slave options setting easier
for future usage.

> 
> > +		err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval);
> 
> I think this patch series needs to be rebased onto latest net-next/master as
> a patch series I sent added two extra parameter list arguments to
> __bond_opt_set().

OK, I will.

> 
>   2bff369b2354 bonding: netlink error message support for options
> 
> Considering my comments above about extending bond_opt_value, I might look
> as sending a fixup patch to remove all the parameter list additions and hide
> the netlink extack pointer in bond_opt_value.
> 
> > +		if (err)
> > +			return err;
> > +	}
> > +
> >   	return 0;
> >   }
> > @@ -1306,6 +1318,61 @@ static int bond_option_missed_max_set(struct bonding *bond,
> >   	return 0;
> >   }
> > +static int bond_option_prio_set(struct bonding *bond,
> > +				const struct bond_opt_value *newval)
> > +{
> > +	struct slave *slave, *update_slave;
> > +	struct net_device *sdev;
> > +	struct list_head *iter;
> > +	char *delim;
> > +	int ret = 0;
> > +	int prio;
> 
> Priorities are only considered if there is no primary set, correct? Would
> you not want to issue a netdev_warn here noting the fact that this will be
> ignored if the bond device has a primary set? Much like how other options
> issue warnings, or in miimon's case turn off arp monitor, when other
> configuration influence the effectiveness of the setting?

OK, I will.

Thanks
Hangbin
