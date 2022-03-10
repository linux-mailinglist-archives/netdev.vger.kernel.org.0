Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2974D4D3E
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243857AbiCJPP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:15:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiCJPPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:15:42 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF64B2D72
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 07:14:36 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id 25so8159656ljv.10
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 07:14:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Eze/8M2gI0/1aPxBC8oNjaaWCvFby/x8ND3xWZra1Gk=;
        b=JDhd3TyE53QQTFNn518ewb1ExwOApdXXEJW1aDE5Be9Sn0zuMirJ8Zcd1A7MCvaWUq
         3XY1fjzMggkv1ldxzwzocSmv1scaP04XFE6RTGdib7C9HaN+7mtWgNMZRQPsZ240A67O
         r0KuwT9DXQgPlm+L8Hnn+lBh3z/Kuea3tYpzU94npVEKbM1IWMUdqk6ZKyM3jPHfxomn
         TuB1c4r/lDva+znWi2Pkte+YKJ4y1EYwGSE9HaFN2O1ViJIM1DNG0hpplTzWPYsjwhSb
         +zCLVnrLindrZjLE51fDCHSCnywUvQ2fbUi7INLA4x1UZ8t9+gngZ1w1In3Cwl1xYCFj
         WJmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Eze/8M2gI0/1aPxBC8oNjaaWCvFby/x8ND3xWZra1Gk=;
        b=k9TIDlKRJ6MA2cW203lO6r5wTYI9PvS2tAsWjdZzqXzL8BkoFAWUXAI5pFAi1uFQ7E
         9UYsj6AbVPwI60Nytipar7HxvfGjqBqWMdqNfpOlw0Rc8QakXFZIqSDY2ko66JhJG7B7
         vBbEVLggSxSBGT2AJel2L+lpkGBdmipJBi2yA3iFfir37Epfcr+f5h8TzmGloSYnkZ4z
         mb1cP419Q77mjp8SBQM+UK0Q6qUhfse3lq48EHO4+5u9j3RPGjbq8B8+HZ7gfNpYFt4J
         2Mt5L4KgXXsI8Pt8plVbXKgHehzBbczrsRn8FlodvksgD/JzSZx4NFdTR1PkjrVEbywC
         PY1A==
X-Gm-Message-State: AOAM530CeCpauWKiNthwSq/JqkPsXHifqZWiPkLAgR3/TBU7o70Bdcdc
        5XjT0iFms7Gz5CSB7avNSIkSlQ==
X-Google-Smtp-Source: ABdhPJwnRxRsFwfExg2LFKi8X51nSOcL450NxvZfSsH2xnJVTTBvAShauyIOr0ArHxmnUAhRDccEyA==
X-Received: by 2002:a05:651c:2115:b0:246:2a10:acb8 with SMTP id a21-20020a05651c211500b002462a10acb8mr3386215ljq.345.1646925274899;
        Thu, 10 Mar 2022 07:14:34 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id c16-20020a056512105000b0044315cbf157sm1026257lfb.64.2022.03.10.07.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 07:14:34 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH v2 net-next 10/10] net: dsa: mv88e6xxx: MST Offloading
In-Reply-To: <20220303222658.7ykn6grkkp6htm7a@skbuf>
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-11-tobias@waldekranz.com>
 <20220303222658.7ykn6grkkp6htm7a@skbuf>
Date:   Thu, 10 Mar 2022 16:14:31 +0100
Message-ID: <87k0d1n8ko.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 00:26, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 01, 2022 at 11:03:21AM +0100, Tobias Waldekranz wrote:
>> Allocate a SID in the STU for each MSTID in use by a bridge and handle
>> the mapping of MSTIDs to VLANs using the SID field of each VTU entry.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 178 +++++++++++++++++++++++++++++++
>>  drivers/net/dsa/mv88e6xxx/chip.h |  13 +++
>>  2 files changed, 191 insertions(+)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index c14a62aa6a6c..4fb4ec1dff79 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1818,6 +1818,137 @@ static int mv88e6xxx_stu_setup(struct mv88e6xxx_chip *chip)
>>  	return mv88e6xxx_stu_loadpurge(chip, &stu);
>>  }
>>  
>> +static int mv88e6xxx_sid_new(struct mv88e6xxx_chip *chip, u8 *sid)
>> +{
>> +	DECLARE_BITMAP(busy, MV88E6XXX_N_SID) = { 0 };
>> +	struct mv88e6xxx_mst *mst;
>> +
>> +	set_bit(0, busy);
>> +
>> +	list_for_each_entry(mst, &chip->msts, node) {
>> +		set_bit(mst->stu.sid, busy);
>> +	}
>> +
>> +	*sid = find_first_zero_bit(busy, MV88E6XXX_N_SID);
>> +
>> +	return (*sid >= mv88e6xxx_max_sid(chip)) ? -ENOSPC : 0;
>> +}
>> +
>> +static int mv88e6xxx_sid_put(struct mv88e6xxx_chip *chip, u8 sid)
>> +{
>> +	struct mv88e6xxx_mst *mst, *tmp;
>> +	int err = 0;
>> +
>> +	list_for_each_entry_safe(mst, tmp, &chip->msts, node) {
>> +		if (mst->stu.sid == sid) {
>> +			if (refcount_dec_and_test(&mst->refcnt)) {
>> +				mst->stu.valid = false;
>> +				err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
>
> It is interesting what to do if this fails. Possibly not this, because
> the entry remains in hardware but not in software.

True, I will let the error bubble up and keep the SW state in sync with
the hardware.

>> +				list_del(&mst->node);
>> +				kfree(mst);
>> +			}
>> +
>> +			return err;
>> +		}
>> +	}
>> +
>> +	return -ENOENT;
>> +}
>> +
>> +static int mv88e6xxx_sid_get(struct mv88e6xxx_chip *chip, struct net_device *br,
>> +			     u16 msti, u8 *sid)
>> +{
>> +	struct mv88e6xxx_mst *mst;
>> +	int err, i;
>> +
>> +	if (!br)
>> +		return 0;
>
> Is this condition possible?

Removing.

>> +
>> +	if (!mv88e6xxx_has_stu(chip))
>> +		return -EOPNOTSUPP;
>> +
>> +	list_for_each_entry(mst, &chip->msts, node) {
>> +		if (mst->br == br && mst->msti == msti) {
>> +			refcount_inc(&mst->refcnt);
>> +			*sid = mst->stu.sid;
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	err = mv88e6xxx_sid_new(chip, sid);
>> +	if (err)
>> +		return err;
>> +
>> +	mst = kzalloc(sizeof(*mst), GFP_KERNEL);
>> +	if (!mst)
>> +		return -ENOMEM;
>
> This leaks the new SID.

I don't think so, the SID is just calculated based on what is in
chip->msts. However:

- The naming is bad. Will change.

>> +
>> +	INIT_LIST_HEAD(&mst->node);
>> +	refcount_set(&mst->refcnt, 1);
>> +	mst->br = br;
>> +	mst->msti = msti;
>> +	mst->stu.valid = true;
>> +	mst->stu.sid = *sid;
>> +
>> +	/* The bridge starts out all ports in the disabled state. But
>> +	 * a STU state of disabled means to go by the port-global
>> +	 * state. So we set all user port's initial state to blocking,
>> +	 * to match the bridge's behavior.
>> +	 */
>> +	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
>> +		mst->stu.state[i] = dsa_is_user_port(chip->ds, i) ?
>> +			MV88E6XXX_PORT_CTL0_STATE_BLOCKING :
>> +			MV88E6XXX_PORT_CTL0_STATE_DISABLED;
>> +
>> +	list_add_tail(&mst->node, &chip->msts);
>> +	return mv88e6xxx_stu_loadpurge(chip, &mst->stu);
>
> And this doesn't behave too well on failure (the MSTID exists in
> software but not in hardware).

Yes, fixing in v3.

>> +}
>> +
>> +static int mv88e6xxx_port_mst_state_set(struct dsa_switch *ds, int port,
>> +					const struct switchdev_mst_state *st)
>> +{
>> +	struct dsa_port *dp = dsa_to_port(ds, port);
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	struct mv88e6xxx_mst *mst;
>> +	u8 state;
>> +	int err;
>> +
>> +	if (!mv88e6xxx_has_stu(chip))
>> +		return -EOPNOTSUPP;
>> +
>> +	switch (st->state) {
>> +	case BR_STATE_DISABLED:
>> +	case BR_STATE_BLOCKING:
>> +	case BR_STATE_LISTENING:
>> +		state = MV88E6XXX_PORT_CTL0_STATE_BLOCKING;
>> +		break;
>> +	case BR_STATE_LEARNING:
>> +		state = MV88E6XXX_PORT_CTL0_STATE_LEARNING;
>> +		break;
>> +	case BR_STATE_FORWARDING:
>> +		state = MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	list_for_each_entry(mst, &chip->msts, node) {
>> +		if (mst->br == dsa_port_bridge_dev_get(dp) &&
>> +		    mst->msti == st->msti) {
>> +			if (mst->stu.state[port] == state)
>> +				return 0;
>> +
>> +			mst->stu.state[port] = state;
>> +			mv88e6xxx_reg_lock(chip);
>> +			err = mv88e6xxx_stu_loadpurge(chip, &mst->stu);
>> +			mv88e6xxx_reg_unlock(chip);
>> +			return err;
>> +		}
>> +	}
>> +
>> +	return -ENOENT;
>> +}
>> +
>>  static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
>>  					u16 vid)
>>  {
>> @@ -2437,6 +2568,12 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
>>  	if (err)
>>  		return err;
>>  
>> +	if (!vlan.valid && vlan.sid) {
>> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>  	return mv88e6xxx_g1_atu_remove(chip, vlan.fid, port, false);
>>  }
>>  
>> @@ -2482,6 +2619,44 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
>>  	return err;
>>  }
>>  
>> +static int mv88e6xxx_vlan_msti_set(struct dsa_switch *ds,
>> +				   const struct switchdev_attr *attr)
>> +{
>> +	const struct switchdev_vlan_attr *vattr = &attr->u.vlan_attr;
>> +	struct mv88e6xxx_chip *chip = ds->priv;
>> +	struct mv88e6xxx_vtu_entry vlan;
>> +	u8 new_sid;
>> +	int err;
>> +
>> +	mv88e6xxx_reg_lock(chip);
>> +
>> +	err = mv88e6xxx_vtu_get(chip, vattr->vid, &vlan);
>> +	if (err)
>> +		goto unlock;
>> +
>> +	if (!vlan.valid) {
>> +		err = -EINVAL;
>> +		goto unlock;
>> +	}
>> +
>> +	err = mv88e6xxx_sid_get(chip, attr->orig_dev, vattr->msti, &new_sid);
>> +	if (err)
>> +		goto unlock;
>> +
>> +	if (vlan.sid) {
>> +		err = mv88e6xxx_sid_put(chip, vlan.sid);
>> +		if (err)
>> +			goto unlock;
>> +	}
>> +
>> +	vlan.sid = new_sid;
>> +	err = mv88e6xxx_vtu_loadpurge(chip, &vlan);
>
> Maybe you could move mv88e6xxx_sid_put() after this succeeds?

Yep. Also made sure to avoid needless updates of the VTU entry if it
already belonged to the correct SID.

Thanks for the great review!
