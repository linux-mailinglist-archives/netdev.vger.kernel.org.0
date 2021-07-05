Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEFD73BB490
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 02:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhGEAwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 20:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGEAwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 20:52:35 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C35C061574
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 17:49:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb6so9817777ejc.5
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 17:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=H3U7XtRi/+vbqgtRy8YmRq0Gh0mzsGLarNJC1lneRH0=;
        b=vbiYmHu6B4GvmmCgPhmM5DMbXume+1XME06lt4go1upaQptl1XlC2uY1bMEz6HIsXc
         dmpVCWrfcRXDo7mH8+SHqwX3ViDMqwngSU2GXWhOx16Re8ZgaNd+cRu3YveH4HVxVTZm
         nFKStuwtPAt7nBgQXW/DG7syCnY5532Veqg+V6AUBzT+tIbSe26/xmfKS40r2cLs+tZj
         mwa5dhyStgeeOkao0Qr6MVdrxUegyKlILvyPKdwRWcHSQgeSuGliYxdcHeDD4nwJcg0g
         a7sFqKOrE5jWRRWILtXJY/g4BPKtRy9m14M+LeV4DfXptPz3AqlFLEawl4uhzXxCMiXM
         ya+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=H3U7XtRi/+vbqgtRy8YmRq0Gh0mzsGLarNJC1lneRH0=;
        b=XvTaFf1OpG268hPnWPuB8NlhTb8mLfta+rMO2liV3LgeBrueAgDbovCt25SGWhyCEK
         35B5A6o/84J/pPcWlh61zMf4URqVscQtQttbrpZ3g/6OFaK/7ncBB+NA7wJFJnIYFcbu
         UEZUJorEI+80JCr1navur1WOR8R4/Hw5EQCSOGNgd3TiexSk9UsIwk1aAa2pF53UaJ6F
         Zhx/Kh28lGJrkqXF2DXR6LGV1Lb/X5pHWEl5A+HDZSNv7+YJTZ8gvSlCgUHxCawHGVbC
         Afz505k9gkxmm0hIDwF6naxaXeawZUhgMgjt2dPnpqIf1YAMSmJBuGJoHIbK4yFxeeW6
         IQOw==
X-Gm-Message-State: AOAM531dHhl5COYCxU6E5DY2cYQwdHrbS9GWf+SLzf9VsUBCd4pMnRK6
        5RzMSzo5W6n66Ap/m9ezz14=
X-Google-Smtp-Source: ABdhPJwb90FJiQmIYvQOWezkKKa9Q+YZlL9nrghwItzzplJxu088GCUTJuAZM70OMJPs2rBVHFbhhA==
X-Received: by 2002:a17:906:d54e:: with SMTP id cr14mr8066500ejc.38.1625446196635;
        Sun, 04 Jul 2021 17:49:56 -0700 (PDT)
Received: from skbuf ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id jx17sm3674148ejc.60.2021.07.04.17.49.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 17:49:56 -0700 (PDT)
Date:   Mon, 5 Jul 2021 03:49:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "gnault@redhat.com" <gnault@redhat.com>,
        "baowen.zheng@corigine.com" <baowen.zheng@corigine.com>,
        Amit Cohen <amcohen@nvidia.com>
Subject: Re: [PATCH net-next] selftests: net: Change the indication for iface
 is up
Message-ID: <20210705004955.il4hicxlpm3ujhsm@skbuf>
References: <20210624151515.794224-1-danieller@nvidia.com>
 <20210624215102.auewn2cod7z5kjki@skbuf>
 <MN2PR12MB45172880B30787CA283A3A22D8009@MN2PR12MB4517.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR12MB45172880B30787CA283A3A22D8009@MN2PR12MB4517.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Danielle,

On Thu, Jul 01, 2021 at 08:50:42AM +0000, Danielle Ratson wrote:
> > -----Original Message-----
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > Sent: Friday, June 25, 2021 12:51 AM
> > To: Danielle Ratson <danieller@nvidia.com>
> > Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; shuah@kernel.org; Ido Schimmel <idosch@nvidia.com>;
> > Nikolay Aleksandrov <nikolay@nvidia.com>; gnault@redhat.com; baowen.zheng@corigine.com; Amit Cohen
> > <amcohen@nvidia.com>
> > Subject: Re: [PATCH net-next] selftests: net: Change the indication for iface is up
> >
> > Hi Danielle,
> >
> > On Thu, Jun 24, 2021 at 06:15:15PM +0300, Danielle Ratson wrote:
> > > Currently, the indication that an iface is up, is the mark 'state UP'
> > > in the iface info. That situation can be achieved also when the
> > > carrier is not ready, and therefore after the state was found as 'up',
> > > it can be still changed to 'down'.
> > >
> > > For example, the below presents a part of a test output with one of
> > > the ifaces involved detailed info and timestamps:
> > >
> > > In setup_wait()
> > > 45: swp13: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel master
> > >     vswp13 state UP mode DEFAULT group default qlen 1000
> > >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > > minmtu 0 maxmtu 65535
> > >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > > 7cfe90fc7dc0
> > > 17:58:27:242634417
> > >
> > > In dst_mac_match_test()
> >
> > What is dst_mac_match_test()?
> >
> > > 45: swp13: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel
> > >     master vswp13 state DOWN mode DEFAULT group default qlen 1000
> > >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > > minmtu 0 maxmtu 65535
> > >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > > 7cfe90fc7dc0
> > > 17:58:32:254535834
> > > TEST: dst_mac match (skip_hw)					    [FAIL]
> > >         Did not match on correct filter
> > >
> > > In src_mac_match_test()
> >
> > What is src_mac_match_test()?
> >
> > > 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
> > >     master vswp13 state UP mode DEFAULT group default qlen 1000
> > >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > > minmtu 0 maxmtu 65535
> > >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > > 7cfe90fc7dc0
> > > 17:58:34:446367468
> >
> > Can you please really show the output of 'ip link show dev swp13 up'?
> > The format you are showing is not that and it is really confusing.
> >
> > > TEST: src_mac match (skip_hw)                                       [ OK ]
> > >
> > > In dst_ip_match_test()
> > > 45: swp13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
> > >     master vswp13 state UP mode DEFAULT group default qlen 1000
> > >     link/ether 7c:fe:90:fc:7d:f1 brd ff:ff:ff:ff:ff:ff promiscuity 0
> > > minmtu 0 maxmtu 65535
> > >     vrf_slave table 1 addrgenmode eui64 numtxqueues 1 numrxqueues 1
> > > gso_max_size 65536 gso_max_segs 65535 portname p13 switchid
> > > 7cfe90fc7dc0
> > > 17:58:35:633518622
> > >
> > > In the example, after the setup_prepare() phase, the iface state was
> > > indeed 'UP' so the setup_wait() phase pass successfully. But since
> > > 'LOWER_UP' flag was not set yet, the next print, which was right
> > > before the first test case has started, the status turned into 'DOWN'.
> >
> > Why?
> >
> > > While, UP is an indicator that the interface has been enabled and
> > > running, LOWER_UP is a physical layer link flag. It indicates that an
> > > Ethernet cable was plugged in and that the device is connected to the network.
> > >
> > > Therefore, the existence of the 'LOWER_UP' flag is necessary for
> > > indicating that the port is up before testing communication.
> >
> > Documentation/networking/operstates.rst says:
> >
> > IF_OPER_UP (6):
> >  Interface is operational up and can be used.
> >
> > Additionally, RFC2863 says:
> >
> > ifOperStatus OBJECT-TYPE
> >     SYNTAX  INTEGER {
> >                 up(1),        -- ready to pass packets
> >
> > You have not proven why the UP operstate is not sufficient and
> > additional checks must be made for link flags. Also you have not
> > explained how this fixes your problem.
> >
> > > Change the indication for iface is up to include the existence of
> > > 'LOWER_UP'.
> > >
>
> Hi Vladimir,
>
> After a consultation with Ido Schimmel, we came up with the commit
> message below:
>
> According to Documentation/networking/operstates.rst, the
> administrative and operational state of an interface can be determined
> via both the 'ifi_flags' field in the ancillary header of a
> RTM_NEWLINK message and the 'IFLA_OPERSTATE' attribute in the message.
>
> When a driver signals loss of carrier via netif_carrier_off(), the
> change is reflected immediately in the 'ifi_flags' field, but not in
> the 'IFLA_OPERSTATE' attribute. This is because changes in
> 'IFLA_OPERSTATE' are performed in a link watch delayed work. From the
> document:
>
> "Whenever the driver CHANGES one of these flags, a workqueue event is
> scheduled to translate the flag combination to IFLA_OPERSTATE as
> follows"
>
> This means that it is possible for user space that is constantly
> querying the kernel for interface state to see the output below when
> the following commands are run. Their purpose is to simulate tearing
> down of a selftest and start of a new one.
>
> Commands:
>
>  # ip link set dev veth1 down
>  # ip link set dev veth0 down
>  # ip link set dev veth0 up
>  # ip link set dev veth1 up
>
> Output:
>
> 11: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
> 11: veth0@veth1: <BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
> 11: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>     link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
> 11: veth0@veth1: <BROADCAST,MULTICAST,UP,M-DOWN> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
> 11: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 06:49:03:9b:96:12 brd ff:ff:ff:ff:ff:ff
>
> In the third line, the operational state is set by rtnl_fill_ifinfo()
> to 'IF_OPER_DOWN' because the interface is administratively down, but
> 'dev->operstate' is still 'IF_OPER_UP' as the delayed work has yet to
> run. That is why the interface's operational state is reported as
> 'IF_OPER_UP' in the next line after it was put administratively up
> again.
>
> The output in the fourth line would make user space believe that the
> interface is fully operational if only the 'IFLA_OPERSTATE' attribute
> is considered. This is false as the interface does not have a carrier
> ('LOWER_UP' is not set) at this stage.
>
> Solve this by determining if an interface is operational solely based
> on the presence of the 'IFF_UP' and 'IFF_LOWER_UP' bits in the
> 'ifi_flags' field.
>
> Hope it answers all your questions and we will send the new commit for net-next.

Thanks, this is a better explanation.

Do you mean that the test below is supposed to fail? Because I ran it
for a few tens of minutes and it didn't.

#!/bin/bash

do_cleanup() {
	ip link del veth0
}
trap do_cleanup EXIT

check() {
	local test_num=$1
	local output=$(ip link show dev veth0 up)

	# Fail if the line doesn't contain both 'state UP' and 'LOWER_UP'
	if ! echo "${output}" | grep 'state UP' | grep -q 'LOWER_UP'; then
		echo "test $test_num failed: ${output}"
		exit 1
	fi
}

test_num=0

ip link add veth0 type veth peer name veth1

while :; do
	ip link set dev veth1 down
	ip link set dev veth0 down
	ip link set veth0 up
	ip link set veth1 up
	check $test_num
	test_num=$((${test_num} + 1))
done

Nonetheless, it seems somewhat plausible that it might happen.

I'm sure you have considered adding something along the lines of a call
to linkwatch_run_queue() in rtnl_fill_ifinfo(), to make sure that the
operstate is actual at the time the netlink message is being processed
by the kernel. After all, it seems common sense to not hand out data to
user space that is already stale by the time you collect it. Why is the
naive [ kernel side ] fix not possible, and instead every user space
program should know that IFLA_OPERSTATE comes from a work item and might
be stale data?
