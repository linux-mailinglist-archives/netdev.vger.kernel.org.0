Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6AA333152
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 23:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhCIWBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 17:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCIWBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 17:01:24 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897F7C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 14:01:23 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id e19so32224839ejt.3
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 14:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DbjvNZVDvIxiebT58vvCke7Ya0EpcLisY26J9Y40F0Q=;
        b=UMKoLpzDwVKlCx2qmSLFQPS8IWlB9LL3lWpqfZwnnkK8n2x6CJFogw7aFXRPbP6ixC
         w8RxpGc97PHkX6+xENyF71LQ6UrA+sJT/xuBaRP8MR7klhOSQgVWMceVxGWIsO14iO3s
         Pute6g+keNl2V4jcNwRKeEnRMDB9GcaeKNGe/linxwYqo5nr4mZj5n+mQFAEomhidjoB
         h7n7myKiiVqo6Jv/DIgjVWdT0MwfDyhGJtgs1bvpojsK193jxb93wvrZZq0tW+jmBjLV
         CkWWmLHzsPBz7PW39gDIPbdJwPXg24C2HXv2gy1vsHAm8gCuO/ICb4BqsTlDRSFtnh7s
         wYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DbjvNZVDvIxiebT58vvCke7Ya0EpcLisY26J9Y40F0Q=;
        b=EVowThdAxJhEHWJtE26QHVkdv4aP6T3thDGdpuAvKjrDfa6Ls7mThOvooYKC+/4A3n
         xEjhVTj72/dsohq0WL+L+KzUOIXabM/3c20mPnzEpi3Pcil61AUsv7j939PlzAebzh+u
         eNdeUz0oOCQvuybcPhm4ZQMo8m/JKEhk7DxGZsCf1dU/uyL2CBwCUnaR2jmOSWitg5RH
         RH5Yu2/L0FZ6oYz5Gf+LJEB/pzlPuV4GdwkTY19Lsjh6sj1M3fyNN2X1Q66cpwBGgKh4
         ig8xMJIrRVjMyeOMoPWPFgB4gDzomLEoHHBLtJwd7AMmmyfRukb/R00sw9LYKjaE2W8U
         aSmQ==
X-Gm-Message-State: AOAM533+SupGpebE1I7BeKNqslZVO3VXiiN64cLmQJIRDHlZFqbkeFK+
        iwKQrJQMjYGxeDizSWNjjq0=
X-Google-Smtp-Source: ABdhPJyOoDjBF5iBCDlB6owa983DlkjQGuTRzBtyn5+R1PbzAQXVcLul23nzhc5numTIhjAbJKIJaA==
X-Received: by 2002:a17:906:388d:: with SMTP id q13mr231513ejd.34.1615327281112;
        Tue, 09 Mar 2021 14:01:21 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id y17sm9006200ejf.116.2021.03.09.14.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 14:01:20 -0800 (PST)
Date:   Wed, 10 Mar 2021 00:01:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [RFC net] net: dsa: Centralize validation of VLAN configuration
Message-ID: <20210309220119.t24sdc7cqqfxhpfb@skbuf>
References: <20210309184244.1970173-1-tobias@waldekranz.com>
 <699042d3-e124-7584-6486-02a6fb45423e@gmail.com>
 <87h7lkow44.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7lkow44.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 10:28:11PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 09, 2021 at 12:40, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 3/9/21 10:42 AM, Tobias Waldekranz wrote:
> >> There are three kinds of events that have an inpact on VLAN
> >> configuration of DSA ports:
> >> 
> >> - Adding of stacked VLANs
> >>   (ip link add dev swp0.1 link swp0 type vlan id 1)
> >> 
> >> - Adding of bridged VLANs
> >>   (bridge vlan add dev swp0 vid 1)
> >> 
> >> - Changes to a bridge's VLAN filtering setting
> >>   (ip link set dev br0 type bridge vlan_filtering 1)
> >> 
> >> For all of these events, we want to ensure that some invariants are
> >> upheld:
> >> 
> >> - For hardware where VLAN filtering is a global setting, either all
> >>   bridges must use VLAN filtering, or no bridge can.
> >
> > I suppose that is true, given that a non-VLAN filtering bridge must not
> > perform ingress VID checking, OK.
> >
> >> 
> >> - For all filtering bridges, no stacked VLAN on any port may be
> >>   configured on multiple ports.
> >
> > You need to qualify multiple ports a bit more here, are you saying
> > multiple ports that are part of said bridge, or?
> 
> Yeah sorry, I can imagine that makes no sense whatsoever without the
> context of the recent discussions. It is basically guarding against this
> situation:
> 
> .100  br0  .100
>    \  / \  /
>    lan0 lan1
> 
> $ ip link add dev br0 type bridge vlan_filtering 1
> $ ip link add dev lan0.100 link lan0 type vlan id 100
> $ ip link add dev lan1.100 link lan1 type vlan id 100
> $ ip link set dev lan0 master br0
> $ ip link set dev lan1 master br0 # This should fail
> 
> >> - For all filtering bridges, no stacked VLAN may be configured in the
> >>   bridge.
> >
> > Being stacked in the bridge does not really compute for me, you mean, no
> > VLAN upper must be configured on the bridge master device(s)? Why would
> > that be a problem though?
> 
> Again sorry, I relize that this message needs a lot of work. It guards
> against this scenario:
> 
> .100  br0
>    \  / \
>    lan0 lan1
> 
> $ ip link add dev br0 type bridge vlan_filtering 1
> $ ip link add dev lan0.100 link lan0 type vlan id 100
> $ ip link set dev lan0 master br0
> $ ip link set dev lan1 master br0
> $ bridge vlan add dev lan1 vid 100 # This should fail
> 
> >> Move the validation of these invariants to a central function, and use
> >> it from all sites where these events are handled. This way, we ensure
> >> that all invariants are always checked, avoiding certain configs being
> >> allowed or disallowed depending on the order in which commands are
> >> given.
> >> 
> >> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> >> ---
> >> 
> >> There is still testing left to do on this, but I wanted to send early
> >> in order show what I meant by "generic" VLAN validation in this
> >> discussion:
> >> 
> >> https://lore.kernel.org/netdev/87mtvdp97q.fsf@waldekranz.com/
> >> 
> >> This is basically an alternative implementation of 1/4 and 2/4 from
> >> this series by Vladimir:
> >> 
> >> https://lore.kernel.org/netdev/20210309021657.3639745-1-olteanv@gmail.com/
> >
> > I really have not been able to keep up with your discussion, and I am
> > not sure if I will given how quickly you guys can spin patches (not a
> > criticism, this is welcome).
> 
> Yeah I know, it has been a bit of a whirlwind.
> 
> Maybe I should just have posted this inline in the other thread, since
> it was mostly to show Vladimir my idea, and it seemed easier to write it
> in C than in English :)

I like it, I think it has good potential.
I wrote up this battery of tests, there is still one condition which you
are not catching, but you should be able to add it. If you find more
corner cases please feel free to add them to this list. Then you can
clean up the patch and send it, I think.

-----------------------------[ cut here ]-----------------------------
From 9fcfccb6a38a9769962b098ba19d50e576710b5b Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Tue, 9 Mar 2021 23:51:01 +0200
Subject: [PATCH] selftests: net: dsa: add checks for all VLAN configurations
 known to mankind that should fail

Offloading VLANs from two different directions is no easy feat,
especially since we can toggle the VLAN filtering property at runtime,
and even per port!

Try to capture the combinations of commands that should be rejected by
DSA, in the attempt of creating a validation procedure that catches them
all.

Note that this patch moves the irritating "require_command" for mausezahn
outside the main net forwarding lib logic, into the functions that
actually make use of it. My testing system doesn't have mausezahn, and
this test doesn't even require it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../drivers/net/dsa/vlan_validation.sh        | 316 ++++++++++++++++++
 tools/testing/selftests/net/forwarding/lib.sh |   9 +-
 2 files changed, 324 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/drivers/net/dsa/vlan_validation.sh

diff --git a/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh b/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh
new file mode 100755
index 000000000000..445ce17cb925
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/dsa/vlan_validation.sh
@@ -0,0 +1,316 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NUM_NETIFS=2
+lib_dir=$(dirname $0)/../../../net/forwarding
+source $lib_dir/lib.sh
+
+eth0=${NETIFS[p1]}
+eth1=${NETIFS[p2]}
+
+test_bridge_vlan_when_port_has_that_vlan_as_upper()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link set ${eth0} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Add bridge VLAN when port has that VLAN as upper already"
+}
+
+test_bridge_vlan_when_port_has_that_vlan_as_upper_but_is_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link set ${eth0} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100
+	ip link del br0
+
+	log_test "Add bridge VLAN when port has that VLAN as upper already, but bridge is initially VLAN-unaware"
+}
+
+test_bridge_vlan_when_other_bridge_port_has_that_vlan_as_upper()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth1}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Add bridge VLAN when another bridge port has that VLAN as upper already"
+}
+
+test_bridge_vlan_when_other_bridge_port_has_that_vlan_as_upper_but_is_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Add bridge VLAN when another bridge port has that VLAN as upper already, but bridge is initially VLAN-unaware"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_vlan_upper()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper with same VID as another port's VLAN upper"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_vlan_upper_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper with same VID as another port's VLAN upper, and bridge is initially unaware"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_equal_to_pvid()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.1 type vlan id 1
+	ip link set ${eth0} master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.1
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper equal to the PVID"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_equal_to_pvid_but_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.1 type vlan id 1
+	ip link set ${eth0} master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.1
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper equal to the PVID, but bridge is initially VLAN-unaware"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_bridge_vlan()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link set ${eth1} master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper with same VID as another port's bridge VLAN"
+}
+
+test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_bridge_vlan_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	bridge vlan add dev ${eth0} vid 100 master
+	ip link set ${eth1} master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Bridge join when new port has VLAN upper with same VID as another port's bridge VLAN, but bridge is initially unaware"
+}
+
+test_vlan_upper_on_bridge_port_when_another_port_has_upper_with_same_vid()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Add VLAN upper to port in bridge which has another port with same upper VLAN ID"
+}
+
+test_vlan_upper_on_bridge_port_when_another_port_has_upper_with_same_vid_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth1} master br0
+	ip link add link ${eth1} name ${eth1}.100 type vlan id 100
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100
+	ip link del ${eth1}.100
+	ip link del br0
+
+	log_test "Add VLAN upper to port in bridge which has another port with same upper VLAN ID, and bridge is initially unaware"
+}
+
+test_vlan_upper_join_vlan_aware_bridge_which_contains_the_physical_port()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth0}.100 master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "VLAN upper joins VLAN-aware bridge"
+}
+
+test_vlan_upper_join_vlan_aware_bridge_which_contains_the_physical_port_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0} master br0
+	ip link set ${eth0}.100 master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "VLAN upper joins VLAN-aware bridge, but bridge is initially unaware"
+}
+
+test_bridge_join_when_vlan_upper_is_already_in_bridge()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0}.100 master br0
+	ip link set ${eth0} master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Bridge join when VLAN upper is already in VLAN-aware bridge"
+}
+
+test_bridge_join_when_vlan_upper_is_already_in_bridge_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0}.100 master br0
+	ip link set ${eth0} master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Bridge join when VLAN upper is already in VLAN-aware bridge, which was initially VLAN-unaware"
+}
+
+test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth1} master br0
+	ip link set ${eth0}.100 master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "VLAN upper joins VLAN-aware bridge which contains another physical port"
+}
+
+test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth1} master br0
+	ip link set ${eth0}.100 master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "VLAN upper joins VLAN-aware bridge which contains another physical port, but bridge is initially unaware"
+}
+
+test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge()
+{
+	ip link add br0 type bridge vlan_filtering 1
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0}.100 master br0
+	ip link set ${eth1} master br0
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Bridge join when VLAN upper of another port is already in VLAN-aware bridge"
+}
+
+test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge_initially_unaware()
+{
+	ip link add br0 type bridge vlan_filtering 0
+	ip link add link ${eth0} name ${eth0}.100 type vlan id 100
+	ip link set ${eth0}.100 master br0
+	ip link set ${eth0} master br0
+	ip link set br0 type bridge vlan_filtering 1
+	check_fail $? "Expected to fail but didn't"
+	ip link del ${eth0}.100 > /dev/null 2>&1 || :
+	ip link del br0
+
+	log_test "Bridge join when VLAN upper of another port is already in VLAN-aware bridge, which was initially VLAN-unaware"
+}
+
+ALL_TESTS="
+	test_bridge_vlan_when_port_has_that_vlan_as_upper
+	test_bridge_vlan_when_port_has_that_vlan_as_upper_but_is_initially_unaware
+	test_bridge_vlan_when_other_bridge_port_has_that_vlan_as_upper
+	test_bridge_vlan_when_other_bridge_port_has_that_vlan_as_upper_but_is_initially_unaware
+	test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_vlan_upper
+	test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_vlan_upper_initially_unaware
+	test_bridge_join_when_new_port_has_vlan_upper_equal_to_pvid
+	test_bridge_join_when_new_port_has_vlan_upper_equal_to_pvid_but_initially_unaware
+	test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_bridge_vlan
+	test_bridge_join_when_new_port_has_vlan_upper_with_same_vid_as_another_port_bridge_vlan_initially_unaware
+	test_vlan_upper_on_bridge_port_when_another_port_has_upper_with_same_vid
+	test_vlan_upper_on_bridge_port_when_another_port_has_upper_with_same_vid_initially_unaware
+	test_vlan_upper_join_vlan_aware_bridge_which_contains_the_physical_port
+	test_vlan_upper_join_vlan_aware_bridge_which_contains_the_physical_port_initially_unaware
+	test_bridge_join_when_vlan_upper_is_already_in_bridge
+	test_bridge_join_when_vlan_upper_is_already_in_bridge_initially_unaware
+	test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port
+	test_vlan_upper_join_vlan_aware_bridge_which_contains_another_physical_port_initially_unaware
+	test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge
+	test_bridge_join_when_vlan_upper_of_another_port_is_already_in_bridge_initially_unaware
+"
+
+tests_run
+
+exit $EXIT_STATUS
diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index be71012b8fc5..8d7348a1834f 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -139,7 +139,6 @@ require_command()
 }
 
 require_command jq
-require_command $MZ
 
 if [[ ! -v NUM_NETIFS ]]; then
 	echo "SKIP: importer does not define \"NUM_NETIFS\""
@@ -1113,6 +1112,8 @@ learning_test()
 	local mac=de:ad:be:ef:13:37
 	local ageing_time
 
+	require_command $MZ
+
 	RET=0
 
 	bridge -j fdb show br $bridge brport $br_port1 \
@@ -1188,6 +1189,8 @@ flood_test_do()
 	local host2_if=$5
 	local err=0
 
+	require_command $MZ
+
 	# Add an ACL on `host2_if` which will tell us whether the packet
 	# was flooded to it or not.
 	tc qdisc add dev $host2_if ingress
@@ -1276,6 +1279,8 @@ __start_traffic()
 	local dip=$1; shift
 	local dmac=$1; shift
 
+	require_command $MZ
+
 	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
 		-a own -b $dmac -t "$proto" -q "$@" &
 	sleep 1
@@ -1352,6 +1357,8 @@ mcast_packet_test()
 	local tc_proto="ip"
 	local mz_v6arg=""
 
+	require_command $MZ
+
 	# basic check to see if we were passed an IPv4 address, if not assume IPv6
 	if [[ ! $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
 		tc_proto="ipv6"
-----------------------------[ cut here ]-----------------------------
