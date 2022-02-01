Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834724A6307
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbiBARzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiBARza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:55:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB24C061714;
        Tue,  1 Feb 2022 09:55:30 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id c24so36372598edy.4;
        Tue, 01 Feb 2022 09:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d9Ywm1WV6rhU4YsMzezgHUEbjp6LC+6CT//UTjfISTk=;
        b=lPCAH2s8wAT995v4IuAwlV+fFADIRkcT+XqXfBU455Ttng9p9n42TIEp1qKERcgY5h
         TcWdbOQEdXtYaqKMTVgRulVlzIf5HJvvH3nIrE3HG8K1alEZ/FRLeGXsUti+ZvZ1fl8C
         iEoeysMPQ+6A9euE3psuagaC5lM0mspU1F6ukGMyZLmWS7JZ/YunvLlXhdYDH+RBJI+C
         qhAkjMeCum+sdGWyUEaLwqHJv6/sK7xraK5SojYcDmeLUndl327oISKAAspXQF75aPHP
         0XIP8LVtOxIdWGj1n5C5okdSpWvXVUnK4sJt2G3eSPxQg7FBiam0DZ7wYFjXZdy2hOoR
         GaNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d9Ywm1WV6rhU4YsMzezgHUEbjp6LC+6CT//UTjfISTk=;
        b=6IyYju235xH4sCDQSGm1o7lUTuOglDcaSD+5OaqoxxCXx+Lp7Xy2HgHrd0XDZrzvEh
         80yqHePPRqGTf46pvzHu1DFL4BwFODhMWG2EjO5zUYUY9KsOO+xcRnRpq/Nxmhx/kCUZ
         73mrTxwstVZZ0aqM4pwUNwuJa+oitWAVJangveTYkD+94o2dDYmi46acS0K9zj2FXqvQ
         5shsVUXRasVtGHo2bvybGfng5sJYZgnlnK+elHWG8+1vSWwgIQcnPOxl6W+a7GhoCHkk
         AonUPgbEtYfeCX0Vuq7itfrwL2yL5E+rqarNYZKHlHbpcibcXZojYQIjIzNJXtqigTG4
         LgRw==
X-Gm-Message-State: AOAM532X9WCj1Zo9jG3wRiIl/MLn2jijA0KtIBFZN8K7TunvQZ7V87ux
        YHcSbbC7SXi/v1x4LNSs6aIFdDpGadA=
X-Google-Smtp-Source: ABdhPJyuFGAwcEFe69a+SsxBEhPgdMPIhwN3hIlgJ9cc5K660P6J8Vo6y9xuM1fieKLE6v9u3ke5ww==
X-Received: by 2002:a05:6402:c9b:: with SMTP id cm27mr26423233edb.100.1643738128915;
        Tue, 01 Feb 2022 09:55:28 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id d17sm19804905ede.88.2022.02.01.09.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 09:55:28 -0800 (PST)
Date:   Tue, 1 Feb 2022 19:55:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Improve multichip
 isolation of standalone ports
Message-ID: <20220201175527.mvzn4vstgbgmnijs@skbuf>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
 <20220131154655.1614770-5-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131154655.1614770-5-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 04:46:54PM +0100, Tobias Waldekranz wrote:
> Given that standalone ports are now configured to bypass the ATU and
> forward all frames towards the upstream port, extend the ATU bypass to
> multichip systems.
> 
> Load VID 0 (standalone) into the VTU with the policy bit set. Since
> VID 4095 (bridged) is already loaded, we now know that all VIDs in use
> are always available in all VTUs. Therefore, we can safely enable
> 802.1Q on DSA ports.
> 
> Setting the DSA ports' VTU policy to TRAP means that all incoming
> frames on VID 0 will be classified as MGMT - as a result, the ATU is
> bypassed on all subsequent switches.
> 
> With this isolation in place, we are able to support configurations
> that are simultaneously very quirky and very useful. Quirky because it
> involves looping cables between local switchports like in this
> example:
> 
>    CPU
>     |     .------.
> .---0---. | .----0----.
> |  sw0  | | |   sw1   |
> '-1-2-3-' | '-1-2-3-4-'
>   $ @ '---'   $ @ % %
> 
> We have three physically looped pairs ($, @, and %).
> 
> This is very useful because it allows us to run the kernel's
> kselftests for the bridge on mv88e6xxx hardware.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 63 ++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 8896709b9103..d0d766354669 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1630,21 +1630,11 @@ static int mv88e6xxx_fid_map_vlan(struct mv88e6xxx_chip *chip,
>  
>  int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
>  {
> -	int i, err;
> -	u16 fid;
> -
>  	bitmap_zero(fid_bitmap, MV88E6XXX_N_FID);
>  
> -	/* Set every FID bit used by the (un)bridged ports */
> -	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
> -		err = mv88e6xxx_port_get_fid(chip, i, &fid);
> -		if (err)
> -			return err;
> -
> -		set_bit(fid, fid_bitmap);
> -	}
> -
> -	/* Set every FID bit used by the VLAN entries */
> +	/* Every FID has an associated VID, so walking the VTU
> +	 * will discover the full set of FIDs in use.
> +	 */

So practically, regardless of whether the switch supports VTU policy or
not, we still load VID 0 in the VTU, and this simplifies the driver a
bit. Could we also simplify mv88e6xxx_port_db_dump() by deleting the
mv88e6xxx_port_get_fid() from there (and then delete this function
altogether)?

I think the mv88e6xxx_port_set_fid() call is now useless too?

>  	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_fid_map_vlan, fid_bitmap);
>  }
>  
> @@ -1657,10 +1647,7 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
>  	if (err)
>  		return err;
>  
> -	/* The reset value 0x000 is used to indicate that multiple address
> -	 * databases are not needed. Return the next positive available.
> -	 */
> -	*fid = find_next_zero_bit(fid_bitmap, MV88E6XXX_N_FID, 1);
> +	*fid = find_first_zero_bit(fid_bitmap, MV88E6XXX_N_FID);
>  	if (unlikely(*fid >= mv88e6xxx_num_databases(chip)))
>  		return -ENOSPC;
>  
> @@ -2152,6 +2139,9 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
>  	if (!vlan.valid) {
>  		memset(&vlan, 0, sizeof(vlan));
>  
> +		if (vid == MV88E6XXX_VID_STANDALONE)
> +			vlan.policy = true;
> +
>  		err = mv88e6xxx_atu_new(chip, &vlan.fid);
>  		if (err)
>  			return err;
> @@ -2949,8 +2939,43 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	if (err)
>  		return err;
>  
> +	/* On chips that support it, set all DSA ports' VLAN policy to
> +	 * TRAP. In combination with loading MV88E6XXX_VID_STANDALONE
> +	 * as a policy entry in the VTU, this provides a better
> +	 * isolation barrier between standalone ports, as the ATU is
> +	 * bypassed on any intermediate switches between the incoming
> +	 * port and the CPU.
> +	 */
> +	if (!dsa_is_user_port(ds, port) && chip->info->ops->port_set_policy) {

Will this not also affect FWD frames sent on behalf of VLAN-unaware
bridges as they are received on CPU ports and upstream-facing DSA ports?
Somehow I think you intend to make this match only on downstream-facing
DSA ports.

> +		err = chip->info->ops->port_set_policy(chip, port,
> +						MV88E6XXX_POLICY_MAPPING_VTU,
> +						MV88E6XXX_POLICY_ACTION_TRAP);
> +		if (err)
> +			return err;
> +	}
> +
> +	/* User ports start out in standalone mode and 802.1Q is
> +	 * therefore disabled. On DSA ports, all valid VIDs are always
> +	 * loaded in the VTU - therefore, enable 802.1Q in order to take
> +	 * advantage of VLAN policy on chips that supports it.
> +	 */

Is this really needed? I thought cascade ports parse the VID from the
DSA header regardless of 802.1Q mode.

>  	err = mv88e6xxx_port_set_8021q_mode(chip, port,
> -				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED);
> +				dsa_is_user_port(ds, port) ?
> +				MV88E6XXX_PORT_CTL2_8021Q_MODE_DISABLED :
> +				MV88E6XXX_PORT_CTL2_8021Q_MODE_SECURE);
> +	if (err)
> +		return err;
> +
> +	/* Bind MV88E6XXX_VID_STANDALONE to MV88E6XXX_FID_STANDALONE by
> +	 * virtue of the fact that mv88e6xxx_atu_new() will pick it as
> +	 * the first free FID. This will be used as the private PVID for
> +	 * unbridged ports. Shared (DSA and CPU) ports must also be
> +	 * members of this VID, in order to trap all frames assigned to
> +	 * it to the CPU.
> +	 */
> +	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_STANDALONE,
> +				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,
> +				       false);
>  	if (err)
>  		return err;
>  
> @@ -2963,7 +2988,7 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
>  	 * relying on their port default FID.
>  	 */
>  	err = mv88e6xxx_port_vlan_join(chip, port, MV88E6XXX_VID_BRIDGED,
> -				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNTAGGED,
> +				       MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_UNMODIFIED,

I think the idea with UNTAGGED here was that packets sent by tag_dsa.c
with TX forwarding offload on behalf of a VLAN-unaware bridge have VID
4095. By setting the port as untagged, that VID is stripped on egress.
If you make it UNMODIFIED, the outside world will see it. Or am I wrong?

>  				       false);
>  	if (err)
>  		return err;
> -- 
> 2.25.1
> 

