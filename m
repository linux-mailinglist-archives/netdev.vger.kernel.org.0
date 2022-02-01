Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DEA4A66CE
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:08:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242717AbiBAVIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbiBAVIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:08:11 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763DEC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 13:08:10 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o12so36399996lfg.12
        for <netdev@vger.kernel.org>; Tue, 01 Feb 2022 13:08:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+YgTrbZ+br7SKiGTUig61/H0Hvfp8CGkXHp83zLz8Uo=;
        b=73cD52dp7X4A9MhKZgqEr3adZyeoBDgcxZJtBsSJr+28IBT+hSzPVTZVvjvD1Gvz5B
         gELHEPRVHdrg9+h7gkuFRxYPyaEhQMNDGl9zAceKZ7Xx+XuQFIMAZyBKWDHRxkZzT4Hn
         Jpi+6Sds7Uj+FKFtpy8kpmsr2SkHOV9nbcBqKIQ/khRNWjFhD++TM4F0GYhcS5cxcKGD
         jZj8BvScSX7UiMcHvXdEMLtf8jsQYSHLhI2TJs0Gu/cXIp43QnQD6H4Pb6DuKRHwysMy
         DIFXlSDxe1kkIajYIdDbp6/uDTWgW9444Y/9ATA68USJGw0fMN39LkIQtxf/+8A2WmRV
         M71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+YgTrbZ+br7SKiGTUig61/H0Hvfp8CGkXHp83zLz8Uo=;
        b=ToKjz+PObdv7xf0eV8R25gBBAm3NfJEbR6hx40mCKH5KBTTBP4u21BMSngxR/K8zVi
         PLHMHDdR3/gTLBZHWaZW9LgwyspnVaON2vRc1QHUBPfHg49BZZPRooJZJpmpNiCrLtWB
         koCK0J+vpwxe0ek7xmP8DwHxX2BGoqK9/LE9tGw3Jk1J3j1kj9BaVzNPn6tN2E0B175K
         6z9u32Qy2K9YIznBlslZT/raTNKgBKajP+Add0OgP5/P429IftEhAJ0keiUmjy0DlFpm
         D8lW5L6qqGcJA0ANDsdMR6KvUuNkxlV9eKpEkVv0/6c7kz6Q/o4CKHwggMslXc2kmObS
         QpUQ==
X-Gm-Message-State: AOAM532eF1qIvPbHvANqfMcT66BCX8fD6FXNcDkHwTWOwIQqu1dzQmDA
        quO8BlTBo/3YzzSxVFLma6XmKg==
X-Google-Smtp-Source: ABdhPJwZ75oOKYMdgZBxp1fcvCKFKlzhLeXrB2HobYkzsWfF9twcu4f/os9LkXDidiKr3wrOiqkNCQ==
X-Received: by 2002:ac2:4843:: with SMTP id 3mr19993250lfy.193.1643749688698;
        Tue, 01 Feb 2022 13:08:08 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id v29sm3307680ljv.72.2022.02.01.13.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 13:08:08 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Improve multichip
 isolation of standalone ports
In-Reply-To: <20220201175527.mvzn4vstgbgmnijs@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-5-tobias@waldekranz.com>
 <20220201175527.mvzn4vstgbgmnijs@skbuf>
Date:   Tue, 01 Feb 2022 22:08:07 +0100
Message-ID: <877daeb8i0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 19:55, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Jan 31, 2022 at 04:46:54PM +0100, Tobias Waldekranz wrote:
>> Given that standalone ports are now configured to bypass the ATU and
>> forward all frames towards the upstream port, extend the ATU bypass to
>> multichip systems.
>> 
>> Load VID 0 (standalone) into the VTU with the policy bit set. Since
>> VID 4095 (bridged) is already loaded, we now know that all VIDs in use
>> are always available in all VTUs. Therefore, we can safely enable
>> 802.1Q on DSA ports.
>> 
>> Setting the DSA ports' VTU policy to TRAP means that all incoming
>> frames on VID 0 will be classified as MGMT - as a result, the ATU is
>> bypassed on all subsequent switches.
>> 
>> With this isolation in place, we are able to support configurations
>> that are simultaneously very quirky and very useful. Quirky because it
>> involves looping cables between local switchports like in this
>> example:
>> 
>>    CPU
>>     |     .------.
>> .---0---. | .----0----.
>> |  sw0  | | |   sw1   |
>> '-1-2-3-' | '-1-2-3-4-'
>>   $ @ '---'   $ @ % %
>> 
>> We have three physically looped pairs ($, @, and %).
>> 
>> This is very useful because it allows us to run the kernel's
>> kselftests for the bridge on mv88e6xxx hardware.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>  drivers/net/dsa/mv88e6xxx/chip.c | 63 ++++++++++++++++++++++----------
>>  1 file changed, 44 insertions(+), 19 deletions(-)
>> 
>> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
>> index 8896709b9103..d0d766354669 100644
>> --- a/drivers/net/dsa/mv88e6xxx/chip.c
>> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
>> @@ -1630,21 +1630,11 @@ static int mv88e6xxx_fid_map_vlan(struct mv88e6xxx_chip *chip,
>>  
>>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
>>  {
>> -	int i, err;
>> -	u16 fid;
>> -
>>  	bitmap_zero(fid_bitmap, MV88E6XXX_N_FID);
>>  
>> -	/* Set every FID bit used by the (un)bridged ports */
>> -	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
>> -		err = mv88e6xxx_port_get_fid(chip, i, &fid);
>> -		if (err)
>> -			return err;
>> -
>> -		set_bit(fid, fid_bitmap);
>> -	}
>> -
>> -	/* Set every FID bit used by the VLAN entries */
>> +	/* Every FID has an associated VID, so walking the VTU
>> +	 * will discover the full set of FIDs in use.
>> +	 */
>
> So practically, regardless of whether the switch supports VTU policy or
> not, we still load VID 0 in the VTU, and this simplifies the driver a
> bit. Could we also simplify mv88e6xxx_port_db_dump() by deleting the
> mv88e6xxx_port_get_fid() from there (and then delete this function
> altogether)?

db_dump could be simplified, as there is no reason to go looking for
entries in MV88E6XXX_FID_STANDALONE. We still need this function to
collect all in-use FIDs in order for mv88e6xxx_atu_new to be able to
pick a free one.

> I think the mv88e6xxx_port_set_fid() call is now useless too?

I don't think so. Since standalone ports do not have 1Q enabled, they
will source their FID from there. This is important because of the
awkward way in which these chips behave when learning is "disabled". The
quotes are there because disabling learning essentially means that the
switch will just load an invalid entry for incoming SA:s. Which means
that they must still be isolated in their own FID to avoid poisoning
other databases.

>>  	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_fid_map_vlan, fid_bitmap);
>>  }
>>  
>> @@ -1657,10 +1647,7 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
>>  	if (err)
>>  		return err;
>>  
>> -	/* The reset value 0x000 is used to indicate that multiple address
>> -	 * databases are not needed. Return the next positive available.
>> -	 */
>> -	*fid = find_next_zero_bit(fid_bitmap, MV88E6XXX_N_FID, 1);
>> +	*fid = find_first_zero_bit(fid_bitmap, MV88E6XXX_N_FID);
>>  	if (unlikely(*fid >= mv88e6xxx_num_databases(chip)))
>>  		return -ENOSPC;
>>  
>> @@ -2152,6 +2139,9 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
>>  	if (!vlan.valid) {
>>  		memset(&vlan, 0, sizeof(vlan));
>>  
>> +		if (vid == MV88E6XXX_VID_STANDALONE)
>> +			vlan.policy = true;
>> +
>>  		err = mv88e6xxx_atu_new(chip, &vlan.fid);
>>  		if (err)
>>  			return err;
>> @@ -2949,8 +2939,43 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>>  	if (err)
>>  		return err;
>>  
>> +	/* On chips that support it, set all DSA ports' VLAN policy to
>> +	 * TRAP. In combination with loading MV88E6XXX_VID_STANDALONE
>> +	 * as a policy entry in the VTU, this provides a better
>> +	 * isolation barrier between standalone ports, as the ATU is
>> +	 * bypassed on any intermediate switches between the incoming
>> +	 * port and the CPU.
>> +	 */
>> +	if (!dsa_is_user_port(ds, port) && chip->info->ops->port_set_policy) {
>
> Will this not also affect FWD frames sent on behalf of VLAN-unaware
> bridges as they are received on CPU ports and upstream-facing DSA ports?

No, because FORWARDs from non-filtering bridges will use
MV88E6XXX_VID_BRIDGED, which does not have the policy bit set in its VTU
entry.

If the CPU was to send a FORWARD on MV88E6XXX_VID_STANDALONE, then it
would bounce back. By definition though, no forward offloading ever
takes place on those ports, so only FROM_CPUs will be sent.

> Somehow I think you intend to make this match only on downstream-facing
> DSA ports.

That sounds like a good idea. It shouldn't change the behavior, but it
does seem more prudent.

So !dsa_is_user_port would become dsa_is_downstream_port, which in turn
would be something like:

/* Return true if this is a DSA port leading away from the CPU */
static inline bool dsa_is_downstream_port(struct dsa_switch *ds, int port)
{
        return dsa_is_dsa_port(ds, port) && !dsa_is_upstream_port(ds, port);
}

Agreed?

>> +		err = chip->info->ops->port_set_policy(chip, port,
>> +						MV88E6XXX_POLICY_MAPPING_VTU,
>> +						MV88E6XXX_POLICY_ACTION_TRAP);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>> +	/* User ports start out in standalone mode and 802.1Q is
>> +	 * therefore disabled. On DSA ports, all valid VIDs are always
>> +	 * loaded in the VTU - therefore, enable 802.1Q in order to take
>> +	 * advantage of VLAN policy on chips that supports it.
>> +	 */
>
> Is this really needed? I thought cascade ports parse the VID from the
> DSA header regardless of 802.1Q mode.

I am pretty sure they will just forward the frame according to the PVT
config if 1Q is disabled.

>>  	err = mv88e6xxx_port_set_8021q_mode(chip, port,
>> -				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED);
>> +				dsa_is_user_port(ds, port) ?
>> +				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED :
>> +				MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE);
>> +	if (err)
>> +		return err;
>> +
>> +	/* Bind MV88E6XXX_VID_STANDALONE to MV88E6XXX_FID_STANDALONE by
>> +	 * virtue of the fact that mv88e6xxx_atu_new() will pick it as
>> +	 * the first free FID. This will be used as the private PVID for
>> +	 * unbridged ports. Shared (DSA and CPU) ports must also be
>> +	 * members of this VID, in order to trap all frames assigned to
>> +	 * it to the CPU.
>> +	 */
>> +	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_STANDALONE,
>> +				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
>> +				       false);
>>  	if (err)
>>  		return err;
>>  
>> @@ -2963,7 +2988,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>>  	 * relying on their port default FID.
>>  	 */
>>  	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
>> -				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED,
>> +				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
>
> I think the idea with UNTAGGED here was that packets sent by tag_dsa.c
> with TX forwarding offload on behalf of a VLAN-unaware bridge have VID
> 4095. By setting the port as untagged, that VID is stripped on egress.
> If you make it UNMODIFIED, the outside world will see it. Or am I wrong?

Unmodified basically means: "Send it out in the same way that is was
received, in accordance with the port's frame mode". The frame mode then
determines the actual on-wire format.

For DSA ports, the frame mode is set to "DSA", in which case the port
will relay the frame with the DSA tag untouched.

For user ports, the frame mode is set to "Normal Network", which either
strips the DSA tag in case of an untagged frame, or converts it to a 1Q
frame in the case of a tagged frame. Which is why no DSA tags will ever
be sent.

>>  				       false);
>>  	if (err)
>>  		return err;
>> -- 
>> 2.25.1
>> 
