Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC279284AFA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgJFLcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgJFLcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:32:43 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CA4C061755;
        Tue,  6 Oct 2020 04:32:43 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id e22so10266239ejr.4;
        Tue, 06 Oct 2020 04:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kX8ZXjmlvAzE5YWp8jGwONULNKTcl3d76oJGTyswjl0=;
        b=XVA/JTCnw1UI/7yKMrn0kJToyF01tKp8vrXLrb6oMcdoRsoApzo5UA9MsWzdE7bRXF
         TII/iSYeVf3qn92CpkF2fA7kN4IDGFdR6Cb+0Fhi6AMJrYraZiArn4mOSkb2G0MmBOsw
         2KjgN77tnWY+Ub7FVDmLFIWIcyMmpdWv22UX0EeKmVfUiuaCdrtd6nk3pq7Vp6UDdSNY
         6fI84kHZIg4X1Jahv2XXpmeAsirjcmNRWj+odzRhLziHefJfuVg3YHjbNS6cw0CTQvnK
         8F47Uz5TQCkK9ToYJSMc8/Mk6VAj0pDM8f4R0FJFwX3pPG89wZH0rO6Jm8lYbY6OgVHS
         gplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kX8ZXjmlvAzE5YWp8jGwONULNKTcl3d76oJGTyswjl0=;
        b=eIVqoD9Yuq84ePk03Hc5wrGgjjhP/MEcnPQtRqBA6kO6uKUoSLCArI8cDK6ovS5znh
         5NlooorHEyR+qAPO4txlTd7GywTVzhkCyJpetAgekxrLoaamsvgsK2HWeJjGNXA2AMR9
         3Ip1XJcaZI5LaEOte1WYDaeX6dx6OYRcMjTcmVBorHDiYnZwP3eSBo3va0CSDZdZOGIW
         2uvLN+TlzzbyJxigMD5cS45b/CmluMo9Jr+FJH3kheSMn2nfNf+1G80E8xKTCCvSpfWh
         JZFuWYEmb3/xnIfn55zxINYWv8UwLfZDjtxSdlNzKJX2/aYhWhidoqmsBizO5fs822Re
         LsgA==
X-Gm-Message-State: AOAM531uun2cYeySZXqR3KKiXc8ba2tVhXWhGXaPrnL8Ocm4+0F7JRso
        mRyIzmVq0w9ZERZ7EtPAWPE=
X-Google-Smtp-Source: ABdhPJzls4J9eIk9vYvrHbqOaN+vzTu8tf/Kes3g9W3RFywHoAmAdrRJEo8EFn4Ga0td8CHuXmhZTQ==
X-Received: by 2002:a17:906:8519:: with SMTP id i25mr4725605ejx.76.1601983959577;
        Tue, 06 Oct 2020 04:32:39 -0700 (PDT)
Received: from skbuf ([188.26.229.171])
        by smtp.gmail.com with ESMTPSA id j10sm2070165edy.97.2020.10.06.04.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 04:32:39 -0700 (PDT)
Date:   Tue, 6 Oct 2020 14:32:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v6 2/7] net: dsa: Add DSA driver for Hirschmann
 Hellcreek switches
Message-ID: <20201006113237.73rzvw34anilqh4d@skbuf>
References: <20201004112911.25085-1-kurt@linutronix.de>
 <20201004112911.25085-3-kurt@linutronix.de>
 <20201004125601.aceiu4hdhrawea5z@skbuf>
 <87lfgj997g.fsf@kurt>
 <20201006092017.znfuwvye25vsu4z7@skbuf>
 <878scj8xxr.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878scj8xxr.fsf@kurt>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 06, 2020 at 12:13:04PM +0200, Kurt Kanzenbach wrote:
> On Tue Oct 06 2020, Vladimir Oltean wrote:
> > On Tue, Oct 06, 2020 at 08:09:39AM +0200, Kurt Kanzenbach wrote:
> >> On Sun Oct 04 2020, Vladimir Oltean wrote:
> >> > I don't think this works.
> >> >
> >> > ip link add br0 type bridge vlan_filtering 1
> >> > ip link set swp0 master br0
> >> > bridge vlan add dev swp0 vid 100
> >> > ip link set br0 type bridge vlan_filtering 0
> >> > bridge vlan del dev swp0 vid 100
> >> > ip link set br0 type bridge vlan_filtering 1
> >> >
> >> > The expectation would be that swp0 blocks vid 100 now, but with your
> >> > scheme it doesn't (it is not unapplied, and not unqueued either, because
> >> > it was never queued in the first place).
> >> 
> >> Yes, that's correct. So, I think we have to queue not only the addition
> >> of VLANs, but rather the "action" itself such as add or del. And then
> >> apply all pending actions whenever vlan_filtering is set.
> >
> > Please remind me why you have to queue a VLAN addition/removal and can't
> > do it straight away? Is it because of private VID 2 and 3, which need to
> > be deleted first then re-added from the bridge VLAN group?
> 
> It's because of the private VLANs 2 and 3 which shouldn't be tampered
> with. Isn't it? You said:
> 
> > If you need caching of VLANs installed by the bridge and/or by the 8021q
> > module, then you can add those to a list, and restore them in the
> > .port_vlan_filtering callback by yourself. You can look at how sja1105
> > does that.
> [...]
> > If your driver makes private use of VLAN tags beyond what the upper
> > layers ask for, then it should keep track of them.
> 
> That's what I did.

Yes, that's what I said, and it's not wrong because there's a big IF there.
But first of all, whatever you do has to work, no matter how you do it.

DSA can at any moment call your .port_vlan_add method either from the
bridge or from the 8021q module. And you need to make sure that you:

- offer the correct services to these layers. Meaning:
  (a) a bridge with vlan_filtering=0 does not expect its offloading
      ports to filter (drop) by VLAN ID. The only thing that changed
      after the configure_vlan_while_not_filtering patch was that now,
      DSA drivers are supposed to make sure that the VLAN database can
      accept .port_vlan_add calls that were made during the time that
      vlan_filtering was 0. These VLANs are supposed to make no
      difference to the data path until vlan_filtering is switched to 1.
  (b) a bridge with vlan_filtering=1 with offloading expects that VLANs
      from its VLAN group are tagged according to their flags, and
      forwarded to the other ports that are members of that VLAN group,
      and VLANs from outside its VLAN group are dropped in hardware.
  (c) 8021q uppers receive traffic tagged with their VLAN ID

- still keep port separation where that's needed (i.e. in standalone
  mode). Ports that are not under a bridge do not perform autonomous L2
  forwarding on their own.

Because port separation is only a concern in standalone mode, I expect
that you only call hellcreek_setup_vlan_membership when entering
standalone mode.

So:
- neither the bridge nor the 8021q module cannot offload a VLAN on a
  port that is the private pvid of any other standalone port. Maybe this
  would not even be visible if you would configure those private pvids
  as 4095, 4094, etc, but you should definitely enfore the restriction.
- IF you let the bridge or 8021q module use a private pvid of a
  standalone port during the time that said port did not need it, then
  you should restore that private pvid when the bridge or 8021q upper is
  removed. This is the part that seems to be causing problems.
- in standalone mode, you can't let 8021q uppers request the same VLAN
  from different ports, as that would break separation.

I am thinking:
If you _don't_ ever let the private pvids of the standalone ports
overlap with the valid range for the bridge and 8021q module, then you
don't need to care whether the bridge or 8021q module could delete a
private pvid of yours (because you wouldn't let them install it in the
first place). So you solve half the problem.

Otherwise said:
If you reject VLANs 4095 and 4094 in the .port_vlan_prepare callback,
you'll be left with 4094 usable VLANs for the bridge on each port, or
4094 VLANs usable for the 8021q module in total (but mutually exclusive
either on one port or the other). So you lose exactly 2 VLANs, and you
simplify the driver implementation.

- The .port_vlan_prepare will check whether the VLAN is 4095 or 4094,
  and if it is, refuse it.

- The .port_vlan_add will always install the VLAN to the hardware
  database, no queuing if there's no reason for it (and I can't see any.
  Your hardware seems to be sane enough to not drop a VLAN-tagged frame,
  and forward it correctly on egress, as long as you call
  hellcreek_setup_ingressflt with enable=false, am I right? or does the
  VLAN still need to be installed into the egress port?).

- The .port_vlan_del will always delete the VLAN from the hardware.

- The .port_bridge_join will:
  (a) disable the VLAN ingress filtering that you need for standalone
      mode. Let the bridge re-enable it if it needs.
  (b) delete VLAN 4094 or 4095 from the port's database. It bothers you
      in bridged mode.

- The .port_bridge_leave will:
  (a) re-enable the VLAN ingress filtering for standalone mode.
  (b) reinstall VLAN 4094 or 4095 into the port's database. You need it
      for isolation in standalone mode.

Am I missing something? The rules are relatively simple and intuitive
(until they aren't!), I'm not trying to impose a certain implementation,
sorry if that's what you understood, I'm just trying to make sure that
the rules are observed in the simplest way possible.

You'll also need something along the lines of this patch, that's what I
was hoping to see from you:

----------------------[ cut here ]----------------------
From 151271ebeebe520ff997bdc08a3e776fbefce17c Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 6 Oct 2020 14:06:54 +0300
Subject: [PATCH] net: dsa: give drivers the chance to veto certain upper
 devices

Some switches rely on unique pvids to ensure port separation in
standalone mode, because they don't have a port forwarding matrix
configurable in hardware. So, setups like a group of 2 uppers with the
same VLAN, swp0.100 and swp1.100, will cause traffic tagged with VLAN
100 to be autonomously forwarded between these switch ports, in spite
of there being no bridge between swp0 and swp1.

These drivers need to prevent this from happening. They need to have
VLAN filtering enabled in standalone mode (so they'll drop frames tagged
with unknown VLANs) and they can only accept an 8021q upper on a port as
long as it isn't installed on any other port too. So give them the
chance to veto bad user requests.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/slave.c   | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index c0185660881c..17e4bb9170e7 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -534,6 +534,12 @@ struct dsa_switch_ops {
 	void	(*get_regs)(struct dsa_switch *ds, int port,
 			    struct ethtool_regs *regs, void *p);
 
+	/*
+	 * Upper device tracking.
+	 */
+	int	(*port_prechangeupper)(struct dsa_switch *ds, int port,
+				       struct netdev_notifier_changeupper_info *info);
+
 	/*
 	 * Bridge integration
 	 */
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e7c1d62fde99..919dbc1bcf6c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2006,10 +2006,22 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER: {
 		struct netdev_notifier_changeupper_info *info = ptr;
+		struct dsa_switch *ds;
+		struct dsa_port *dp;
+		int err;
 
 		if (!dsa_slave_dev_check(dev))
 			return dsa_prevent_bridging_8021q_upper(dev, ptr);
 
+		dp = dsa_slave_to_port(dev);
+		ds = dp->ds;
+
+		if (ds->ops->port_prechangeupper) {
+			err = ds->ops->port_prechangeupper(ds, dp->index, ptr);
+			if (err)
+				return err;
+		}
+
 		if (is_vlan_dev(info->upper_dev))
 			return dsa_slave_check_8021q_upper(dev, ptr);
 		break;
-- 
2.25.1

----------------------[ cut here ]----------------------

And then you'll implement this callback and reject 8021q uppers (see the
dsa_slave_check_8021q_upper function for how) with equal VLANs on
another port. Maybe that's one place where you can keep a VLAN list. But
that's an implementation detail which should be best left to you to
figure out.

> At the end of the day the driver needs to port separation
> somehow. Otherwise it doesn't match the DSA model, right? Again there is
> no port forwarding matrix which would make things easy. It has to be
> solved in software.
> 
> If the private VLAN stuff isn't working, because all of the different
> corner cases, then what's the alternative?

Did I say it can't work? I am just commenting on the code.

> > In bridged mode, they don't need a unique pvid, it only complicates
> > the implementation. They can have the pvid from the bridge VLAN group.
> 
> Meaning rely on the fact that VLAN 1 is programmed automatically? Maybe
> just unapply the private VLAN in bridge_join()?

Yes.

> I've checked that property with ethtool and it's set to the value you
> suggested.

Ok, so you don't need to change anything on the ethtool features side in
that case.

Thanks,
-Vladimir
