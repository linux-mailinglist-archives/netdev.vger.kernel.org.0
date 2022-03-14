Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E93E4D802D
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiCNKsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiCNKsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:48:07 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F531EC54;
        Mon, 14 Mar 2022 03:46:56 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id b28so14618311lfc.4;
        Mon, 14 Mar 2022 03:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=w30p49+yCYV2VWe0azdUYl6RO0t9X1w4tgHCoSZ0fq8=;
        b=Byp3ot9wFp0LCHtVMj6ZPUPg2As8+0N6UrQlzlzIKiI13MQC5GH+DhxbwtTWMaM2PT
         EYDu/p/PdRSIFaGElhFvOuNgKour0/jAov/FiTGBjT+sn1hpBhV322FHgrlYRKpfiv44
         /HR9VzUyWhpcScQxJsMJousQqiqnuYt1WtaSFnePKx4MeOEFCq8urz81QZUWMCdsIIpQ
         kfbmXl50l6vov3Wxr9CZvnNjbGviQxBs5k4emUOo0dmc1kl18wFhzOwCfNrEDZ7oFLwU
         UuYpafOwzXx0S/hGzqHIKH3URWF8iYACCqCE4Pa1a2Yr8nQHKo39P1AjxTRgvnWh9Klq
         8ZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=w30p49+yCYV2VWe0azdUYl6RO0t9X1w4tgHCoSZ0fq8=;
        b=pvAddFDscUGR2iPlu4uP7pYW1uZg1188jcS1MUh6X2uhXBPmncOxDLi3Og5rQz0Hqe
         NvQQkOdLxB5RkWaH7j762koN0xVWEnOwc+UzlDo7aDs42kUIUbJY44G6Ip3/yOFmEYax
         wZzdWCdaX/uaklzdqYOj7AaFIyiVe40OoSypnghoTFdJLIhvcQgr4U8OBjIWXMLzFeiL
         p9peSZYcXuYh1A49Wwnnqo7H6VEq5GlFxhT/zPC8ULWCU8noHmNMfy6ihBFEAU5aqxPU
         PZJ2yFCyVHNxzBAR/ebw/MWCbYjmj9NSzeiq2tzgQ2MjMdKDQI3ATrMFoKTdjlbIq8r5
         LYkg==
X-Gm-Message-State: AOAM532AVkkCXiNb93lAc2Wm0tSyoja+2GAhx4Zmx1a9p1cE6QxF09xW
        RE27jqBTAxwzegOVtRz0Fgo=
X-Google-Smtp-Source: ABdhPJxBFCXPRlCzx0NkyvAjcvWnEEKBVpSzThggEzSSz6z54WCuxki54D+uKPnfVO3aABiu32E+Sg==
X-Received: by 2002:a05:6512:234a:b0:448:5f92:7b0e with SMTP id p10-20020a056512234a00b004485f927b0emr12526316lfu.211.1647254814577;
        Mon, 14 Mar 2022 03:46:54 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id y4-20020a05651c020400b00247eb571eb1sm3766293ljn.65.2022.03.14.03.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 03:46:54 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220310142836.m5onuelv4jej5gvs@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf>
Date:   Mon, 14 Mar 2022 11:46:51 +0100
Message-ID: <86r17495gk.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,THIS_AD,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 10, 2022 at 16:28, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 10, 2022 at 03:23:20PM +0100, Hans Schultz wrote:
>> This implementation for the Marvell mv88e6xxx chip series, is
>> based on handling ATU miss violations occurring when packets
>> ingress on a port that is locked. The mac address triggering
>> the ATU miss violation is communicated through switchdev to
>> the bridge module, which adds a fdb entry with the fdb locked
>> flag set.
>> Note: The locked port must have learning enabled for the ATU
>> miss violation to occur.
>> 
>> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
>>  drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
>>  drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
>>  drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
>>  drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 +++++++-
>>  .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 67 +++++++++++++++++++
>>  .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 ++++++
>>  drivers/net/dsa/mv88e6xxx/port.c              | 11 +++
>>  drivers/net/dsa/mv88e6xxx/port.h              |  1 +
>>  9 files changed, 138 insertions(+), 7 deletions(-)
>>  create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>>  create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/Makefile b/drivers/net/dsa/mv88e6xxx/Makefile
>> index c8eca2b6f959..3ca57709730d 100644
>> --- a/drivers/net/dsa/mv88e6xxx/Makefile
>> +++ b/drivers/net/dsa/mv88e6xxx/Makefile
>> @@ -15,3 +15,4 @@ mv88e6xxx-objs += port_hidden.o
>>  mv88e6xxx-$(CONFIG_NET_DSA_MV88E6XXX_PTP) += ptp.o
>>  mv88e6xxx-objs += serdes.o
>>  mv88e6xxx-objs += smi.o
>> +mv88e6xxx-objs += mv88e6xxx_switchdev.o
>> \ No newline at end of file
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 84b90fc36c58..e1b6bd738085 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1714,11 +1714,11 @@ static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
>>  	return err;
>>  }
>>  
>> -static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
>> -			      int (*cb)(struct mv88e6xxx_chip *chip,
>> -					const struct mv88e6xxx_vtu_entry *entry,
>> -					void *priv),
>> -			      void *priv)
>> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
>> +		       int (*cb)(struct mv88e6xxx_chip *chip,
>> +				 const struct mv88e6xxx_vtu_entry *entry,
>> +				 void *priv),
>> +		       void *priv)
>>  {
>>  	struct mv88e6xxx_vtu_entry entry = {
>>  		.vid = mv88e6xxx_max_vid(chip),
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
>> index 30b92a265613..64e8fc470fdf 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.h
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
>> @@ -763,6 +763,11 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
>>  	mutex_unlock(&chip->reg_lock);
>>  }
>>  
>> +int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
>> +		       int (*cb)(struct mv88e6xxx_chip *chip,
>> +				 const struct mv88e6xxx_vtu_entry *entry,
>> +				 void *priv),
>> +		       void *priv);
>>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
>>  
>>  #endif /* _MV88E6XXX_CHIP_H */
>> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
>> index 2c1607c858a1..729cc0610d9a 100644
>> --- a/drivers/net/dsa/mv88e6xxx/global1.h
>> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
>> @@ -136,6 +136,7 @@
>>  #define MV88E6XXX_G1_ATU_DATA_TRUNK				0x8000
>>  #define MV88E6XXX_G1_ATU_DATA_TRUNK_ID_MASK			0x00f0
>>  #define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_MASK			0x3ff0
>> +#define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS		0x0000
>>  #define MV88E6XXX_G1_ATU_DATA_STATE_MASK			0x000f
>>  #define MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED			0x0000
>>  #define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_1_OLDEST		0x0001
>> diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> index 40bd67a5c8e9..afa54fe8667e 100644
>> --- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> +++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
>> @@ -12,6 +12,8 @@
>>  
>>  #include "chip.h"
>>  #include "global1.h"
>> +#include "port.h"
>> +#include "mv88e6xxx_switchdev.h"
>>  
>>  /* Offset 0x01: ATU FID Register */
>>  
>> @@ -114,6 +116,18 @@ static int mv88e6xxx_g1_atu_op_wait(struct mv88e6xxx_chip *chip)
>>  	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_ATU_OP, bit, 0);
>>  }
>>  
>> +static int mv88e6xxx_g1_read_atu_violation(struct mv88e6xxx_chip *chip)
>> +{
>> +	int err;
>> +
>> +	err = mv88e6xxx_g1_write(chip, MV88E6XXX_G1_ATU_OP,
>> +				 MV88E6XXX_G1_ATU_OP_BUSY | MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
>> +	if (err)
>> +		return err;
>> +
>> +	return mv88e6xxx_g1_atu_op_wait(chip);
>> +}
>> +
>>  static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
>>  {
>>  	u16 val;
>> @@ -356,11 +370,11 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>>  	int spid;
>>  	int err;
>>  	u16 val;
>> +	u16 fid;
>>  
>>  	mv88e6xxx_reg_lock(chip);
>>  
>> -	err = mv88e6xxx_g1_atu_op(chip, 0,
>> -				  MV88E6XXX_G1_ATU_OP_GET_CLR_VIOLATION);
>> +	err = mv88e6xxx_g1_read_atu_violation(chip);
>>  	if (err)
>>  		goto out;
>>  
>> @@ -368,6 +382,10 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>>  	if (err)
>>  		goto out;
>>  
>> +	err = mv88e6xxx_g1_read(chip, MV88E6352_G1_ATU_FID, &fid);
>> +	if (err)
>> +		goto out;
>> +
>>  	err = mv88e6xxx_g1_atu_data_read(chip, &entry);
>>  	if (err)
>>  		goto out;
>> @@ -396,6 +414,13 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
>>  				    "ATU miss violation for %pM portvec %x spid %d\n",
>>  				    entry.mac, entry.portvec, spid);
>>  		chip->ports[spid].atu_miss_violation++;
>> +		if (mv88e6xxx_port_is_locked(chip, chip->ports[spid].port))
>> +			err = mv88e6xxx_switchdev_handle_atu_miss_violation(chip,
>> +									    chip->ports[spid].port,
>> +									    &entry,
>> +									    fid);
>
> Do we want to suppress the ATU miss violation warnings if we're going to
> notify the bridge, or is it better to keep them for some reason?
> My logic is that they're part of normal operation, so suppressing makes
> sense.
>

I have been seeing many ATU member violations after the miss violation is
handled (using ping), and I think it could be considered to suppress the ATU member
violations interrupts by setting the IgnoreWrongData bit for the
port (sect 4.4.7). This would be something to do whenever a port is set in locked mode?

>> +		if (err)
>> +			goto out;
>>  	}
>>  
>>  	if (val & MV88E6XXX_G1_ATU_OP_FULL_VIOLATION) {
>> diff --git a/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>> new file mode 100644
>> index 000000000000..e0ca452b6f86
>> --- /dev/null
>> +++ b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>> @@ -0,0 +1,67 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * mv88e6xxx_switchdev.c
>> + *
>> + *	Authors:
>> + *	Hans J. Schultz		<hans.schultz@westermo.com>
>> + *
>> + */
>> +
>> +#include <net/switchdev.h>
>> +#include "chip.h"
>> +#include "global1.h"
>> +
>> +struct mv88e6xxx_fid_search_ctx {
>> +	u16 fid_search;
>> +	u16 vid_found;
>> +};
>> +
>> +static int mv88e6xxx_find_vid_on_matching_fid(struct mv88e6xxx_chip *chip,
>> +					      const struct mv88e6xxx_vtu_entry *entry,
>> +					      void *priv)
>> +{
>> +	struct mv88e6xxx_fid_search_ctx *ctx = priv;
>> +
>> +	if (ctx->fid_search == entry->fid) {
>> +		ctx->vid_found = entry->vid;
>> +		return 1;
>> +	}
>> +	return 0;
>> +}
>> +
>> +int mv88e6xxx_switchdev_handle_atu_miss_violation(struct mv88e6xxx_chip *chip,
>> +						  int port,
>> +						  struct mv88e6xxx_atu_entry *entry,
>> +						  u16 fid)
>> +{
>> +	struct switchdev_notifier_fdb_info info = {
>> +		.addr = entry->mac,
>> +		.vid = 0,
>> +		.added_by_user = false,
>> +		.is_local = false,
>> +		.offloaded = true,
>> +		.locked = true,
>> +	};
>> +	struct mv88e6xxx_fid_search_ctx ctx;
>> +	struct netlink_ext_ack *extack;
>> +	struct net_device *brport;
>> +	struct dsa_port *dp;
>> +	int err;
>> +
>> +	ctx.fid_search = fid;
>> +	err = mv88e6xxx_vtu_walk(chip, mv88e6xxx_find_vid_on_matching_fid, &ctx);
>> +	if (err < 0)
>> +		return err;
>> +	if (err == 1)
>> +		info.vid = ctx.vid_found;
>> +	else
>> +		return -ENODATA;
>> +
>> +	dp = dsa_to_port(chip->ds, port);
>> +	brport = dsa_port_to_bridge_port(dp);
>
> Since this is threaded interrupt context, I suppose it could race with
> dsa_port_bridge_leave(). So it is best to check whether "brport" is NULL
> or not.
>
> Speaking of races with dsa_port_bridge_leave().. does SWITCHDEV_FDB_ADD_TO_BRIDGE
> not require rtnl_lock?
>
>> +	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, brport, &info.info, extack);
>
> It is buggy to pass an uninitialized on-stack extack, just pass NULL if
> there's no one to consume it.
>
> Alternatively, if the bridge produces a valid extack message for errors
> in this case (I haven't checked), it may be more useful to manually
> print the extack._msg to the kernel log - see dsa_switch_sync_vlan_filtering()
> for an example.
>
> I am a bit uncomfortable having every driver implement this ad-hoc and
> potentially have a gazillion subtle bugs like these, could we have a
> common function exported by DSA that deals with SWITCHDEV_FDB_ADD_TO_BRIDGE?
>
>> +	if (err)
>> +		return err;
>> +	entry->portvec = MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_NO_EGRESS;
>> +	return mv88e6xxx_g1_atu_loadpurge(chip, fid, entry);
>> +}
>> diff --git a/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
>> new file mode 100644
>> index 000000000000..127f3098f745
>> --- /dev/null
>> +++ b/drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0-or-later
>> + *
>> + * mv88e6xxx_switchdev.h
>> + *
>> + *	Authors:
>> + *	Hans J. Schultz		<hans.schultz@westermo.com>
>> + *
>> + */
>> +
>> +#ifndef DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_
>> +#define DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_
>> +
>> +#include <net/switchdev.h>
>> +
>> +int mv88e6xxx_switchdev_handle_atu_miss_violation(struct mv88e6xxx_chip *chip,
>> +						  int port,
>> +						  struct mv88e6xxx_atu_entry *entry,
>> +						  u16 fid);
>> +
>> +#endif /* DRIVERS_NET_DSA_MV88E6XXX_MV88E6XXX_SWITCHDEV_H_ */
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
>> index 795b3128768f..6b375b0caa2c 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.c
>> +++ b/drivers/net/dsa/mv88e6xxx/port.c
>> @@ -1239,6 +1239,17 @@ int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
>>  	return err;
>>  }
>>  
>> +bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port)
>> +{
>> +	u16 reg;
>> +
>> +	if (mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL0, &reg))
>> +		return false;
>> +	if (!(reg & MV88E6XXX_PORT_CTL0_SA_FILT_DROP_ON_LOCK))
>> +		return false;
>> +	return true;
>> +}
>> +
>>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>>  			    bool locked)
>>  {
>> diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
>> index e0a705d82019..09ea8f1615bb 100644
>> --- a/drivers/net/dsa/mv88e6xxx/port.h
>> +++ b/drivers/net/dsa/mv88e6xxx/port.h
>> @@ -374,6 +374,7 @@ int mv88e6xxx_port_set_fid(struct mv88e6xxx_chip *chip, int port, u16 fid);
>>  int mv88e6xxx_port_get_pvid(struct mv88e6xxx_chip *chip, int port, u16 *pvid);
>>  int mv88e6xxx_port_set_pvid(struct mv88e6xxx_chip *chip, int port, u16 pvid);
>>  
>> +bool mv88e6xxx_port_is_locked(struct mv88e6xxx_chip *chip, int port);
>>  int mv88e6xxx_port_set_lock(struct mv88e6xxx_chip *chip, int port,
>>  			    bool locked);
>>  
>> -- 
>> 2.30.2
>> 
