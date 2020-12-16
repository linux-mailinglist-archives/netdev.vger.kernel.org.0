Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1162DC7B9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgLPUWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbgLPUWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 15:22:24 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB8EC061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 12:21:43 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id u18so51638609lfd.9
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 12:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=mG/0CGEBX7p0aczwETNNOn7HPELBlCLB6VLDMWoAy7w=;
        b=eqTwwJ4ubZChjpObhSx4clviRXzlvv97aFLOc6IVp65SaYgh9+2TjOB7X6mWqlCe7e
         oprfFBFvq6/tCy97GW2bZdjrLB2Kf9zx8mkkWDE5oFhtEoU/II3sahK4Qe6ZDT4JbdjR
         5sy7kFb4rwpEbzW1vg32fpMyUaYf+fFQ2xcGN+W/CY8vNHdJPxQGvgF62hcflqSGhBFc
         dsHgVN2i61KfQArSmwAwHPQmnLfkh+LYzqHslUu/d+jqtjXKXIj2/2TXteZnCWGCONOk
         ILQZTgRdbGCc1x6d5bUvHr2EtsXeDwU+/19ea1ukKcf8XhOkdueKuvHhaMXYipZmxDd8
         hrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mG/0CGEBX7p0aczwETNNOn7HPELBlCLB6VLDMWoAy7w=;
        b=lEwPdg8mtAf2wRUX9CCjs3x39zWOdfeSpCZss6fEamMYFIwq8/Knj8KHF40Om8NcN2
         V/AXutKwi2udj00WvfHzlwLOH2bW/BzVQZc2+kZjFMBieMLrIIRg4vCDpqC0kLGHfZAk
         lbOHFX/2Jb6LY/wxv89ywgsZa+/+PaI2kgwnZnqkT1uZQQL06PY+P/gcU40AJct/6eyK
         3Ngi/WwrxoM5Jt487DeAbuONNeK1k/8pl//Zolvzvc5jWGSL5Xl9MIdKf+pzii9incIN
         PDz0sFIkWr3KV/F0dBt0zffTqctQmqsulKLvvUT8T7l//dpZmD7nFWa+MANpGdHCvlvm
         CzBA==
X-Gm-Message-State: AOAM5338Xl0T5xWVipZB28IgOL4fAPIOJCH+3VMJ1WMy8Ir+Mbn9bFqP
        umF9D7LSvxBIxeN+p3F3xWLUFXxAOmLbTS/5
X-Google-Smtp-Source: ABdhPJwzRodJn6bOhhys2Xzp7LQg3yxjQNiB/BM5Q03aPFkAHQjyu4PLJXP+Kvl1jZzmf5m+kLv0Lw==
X-Received: by 2002:a2e:8599:: with SMTP id b25mr13336839lji.334.1608150101767;
        Wed, 16 Dec 2020 12:21:41 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id w12sm336834lfp.203.2020.12.16.12.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 12:21:41 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 4/5] net: dsa: mv88e6xxx: Link aggregation support
In-Reply-To: <20201216190410.2mgrujtjfd2uvnwu@skbuf>
References: <20201216160056.27526-1-tobias@waldekranz.com> <20201216160056.27526-5-tobias@waldekranz.com> <20201216190410.2mgrujtjfd2uvnwu@skbuf>
Date:   Wed, 16 Dec 2020 21:21:40 +0100
Message-ID: <87h7olbiy3.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 21:04, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 16, 2020 at 05:00:55PM +0100, Tobias Waldekranz wrote:
>> Support offloading of LAGs to hardware. LAGs may be attached to a
>> bridge in which case VLANs, multicast groups, etc. are also offloaded
>> as usual.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c    | 298 +++++++++++++++++++++++++++-
>>  drivers/net/dsa/mv88e6xxx/global2.c |   8 +-
>>  drivers/net/dsa/mv88e6xxx/global2.h |   5 +
>>  drivers/net/dsa/mv88e6xxx/port.c    |  21 ++
>>  drivers/net/dsa/mv88e6xxx/port.h    |   5 +
>>  5 files changed, 329 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index eafe6bedc692..bd80b3939157 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1189,7 +1189,8 @@ static int mv88e6xxx_set_mac_eee(struct dsa_switch *ds, int port,
>>  }
>>  
>>  /* Mask of the local ports allowed to receive frames from a given fabric port */
>> -static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>> +static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port,
>> +			       struct net_device **lag)
>>  {
>>  	struct dsa_switch *ds = chip->ds;
>>  	struct dsa_switch_tree *dst = ds->dst;
>> @@ -1201,6 +1202,9 @@ static u16 mv88e6xxx_port_vlan(struct mv88e6xxx_chip *chip, int dev, int port)
>>  	list_for_each_entry(dp, &dst->ports, list) {
>>  		if (dp->ds->index == dev && dp->index == port) {
>>  			found = true;
>> +
>> +			if (dp->lag_dev && lag)
>> +				*lag = dp->lag_dev;
>>  			break;
>>  		}
>>  	}
>
> I'll let Andrew and Vivien have the decisive word, who are vastly more
> familiar with mv88e6xxx than I am, but to me it looks like a bit of a
> hack to put this logic here, especially since one of the two callers
> (i.e. half) doesn't even care about the LAG.
>
>> @@ -1396,14 +1402,21 @@ static int mv88e6xxx_mac_setup(struct mv88e6xxx_chip *chip)
>>  
>>  static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
>>  {
>> +	struct net_device *lag = NULL;
>>  	u16 pvlan = 0;
>>  
>>  	if (!mv88e6xxx_has_pvt(chip))
>>  		return 0;
>>  
>>  	/* Skip the local source device, which uses in-chip port VLAN */
>> -	if (dev != chip->ds->index)
>> -		pvlan = mv88e6xxx_port_vlan(chip, dev, port);
>> +	if (dev != chip->ds->index) {
>> +		pvlan = mv88e6xxx_port_vlan(chip, dev, port, &lag);
>> +
>> +		if (lag) {
>> +			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
>> +			port = dsa_lag_id(chip->ds->dst, lag);
>> +		}
>> +	}
>
> What about the following, which should remove the need of modifying mv88e6xxx_port_vlan:
>
> static int mv88e6xxx_pvt_map(struct mv88e6xxx_chip *chip, int dev, int port)
> {
> 	struct dsa_switch *ds = chip->ds;
> 	struct net_device *lag = NULL;
> 	u16 pvlan = 0;
>
> 	if (!mv88e6xxx_has_pvt(chip))
> 		return 0;
>
> 	/* Skip the local source device, which uses in-chip port VLAN */
> 	if (dev != ds->index) {
> 		pvlan = mv88e6xxx_port_vlan(chip, dev, port);
> 		struct dsa_switch *other_ds;
> 		struct dsa_port *other_dp;
>
> 		other_ds = dsa_switch_find(ds->dst->index, dev);
> 		other_dp = dsa_to_port(other_ds, port);
>
> 		/* XXX needs an explanation for the reinterpreted values of
> 		 * dev and port
> 		 */
> 		if (other_dp->lag_dev) {
> 			dev = MV88E6XXX_G2_PVT_ADRR_DEV_TRUNK;
> 			port = dsa_lag_id(ds->dst, other_dp->lag_dev);
> 		}
> 	}
>
> 	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
> }

Yeah I agree. This is really a left-over from the RFC that I meant to
clean-up. I will change it for v5.

>>  
>>  	return mv88e6xxx_g2_pvt_write(chip, dev, port, pvlan);
>>  }
>> @@ -5375,6 +5388,271 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
>>  	return err;
>>  }
>>  
