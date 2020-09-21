Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32627351A
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 23:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgIUVoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 17:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbgIUVoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 17:44:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D83823A60;
        Mon, 21 Sep 2020 21:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600724650;
        bh=8Y5gNaHO2J88gCnCHiipo6ubQfGa0ledJYXfR9TF0DY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PNTRckTRIQ3S3sYjTzTjjKKdJxV02CLAaKvqHk9av6uU0pkb4ME6LSW40dm+NyapR
         QTSYSdApGsfVbLUHhDAf9UbdCFAJ6ob6nLFUyo0u55WYippB0Non/M03/X4RjCQbI6
         wG/uCa7Zlriwz2RQE2yvDaY9y5N30vyfuyXADuI8=
Date:   Mon, 21 Sep 2020 14:44:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Brown, Aaron F" <aaron.f.brown@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Message-ID: <20200921144408.19624164@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
        <20200722012716.2814777-5-kuba@kernel.org>
        <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Sep 2020 07:23:58 +0000 Brown, Aaron F wrote:
> > From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Jakub
> > Kicinski
> > Sent: Tuesday, July 21, 2020 6:27 PM
> > To: davem@davemloft.net
> > Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Jakub Kicinski
> > <kuba@kernel.org>
> > Subject: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a test for
> > shared UDP tunnel info tables
> > 
> > Add a test run of checks validating the shared UDP tunnel port
> > tables function as we expect.
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  .../drivers/net/netdevsim/udp_tunnel_nic.sh   | 109 ++++++++++++++++++
> >  1 file changed, 109 insertions(+)
> >   
> I ran into two things while running this script.
> 1. The script as it exists in the git tree (Jeff Kirshers next-queue) is not executable.  I don't know if that's a patch issue or translation into the tree.  Easy enough to get around, but should probably be executable to start.

Ah, good catch, thanks! Please adjust in your tree or I can send a
follow up with other patches I still have queued.

> 2. The script runs into a handful of errors,7 to be precise.  I'm not sure if they are real failures, incorrect expectations or maybe something in my kernel .config (I have been using a minimal .config and enabling modules as needed.)

Can you share the .config? Do you have tunnels enabled? 
I just retested and it passes :(

> The output I get from it is:
> ----------------------------------------------------------------------------------------------------
> u1518:[0]/usr/src/kernels/next-queue> cat ~/udp_tunnel-sh-outut.txt                                                                     
> ERROR: table 0 on port 1: basic - VxLAN v4 devices
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 0 on port 1: basic - VxLAN v4 devices
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 0 on port 1: basic - VxLAN v6 devices
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 0 on port 1: basic - VxLAN v6 devices
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 0 on port 1: basic - another VxLAN v6 devices
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 0 on port 1: basic - Geneve device
>        check_table: wrong entry 0
>        expected: port: 4789     type: 1
>        have:     port: 0        type: 0
> ERROR: table 1 on port 1: basic - Geneve device
>        check_table: wrong entry 0
>        expected: port: 6081     type: 2
>        have:     port: 0        type: 0
> FAILED 7/435 checks
> u1518:[0]/usr/src/kernels/next-queue>
> ----------------------------------------------------------------------------------------------------
> The script sends messages to dmesg, most look to be informative "set" and "unset" messages, but I do get a handful of failed messages.  The dmesg queue was cleared before the run so only contains the udp_tunnel-sh messages:
> ----------------------------------------------------------------------------------------------------
> u1518:[0]/usr/src/kernels/next-queue> dmesg|grep -i fail
> [ 8909.179462] netdevsim netdevsim386 eth4: UDP tunnel port sync failed port 10000 type vxlan: -110
> [ 8909.328763] netdevsim netdevsim386 eth4: UDP tunnel port sync failed port 20000 type geneve: -2
> [ 8909.444028] netdevsim netdevsim386 eth4: UDP tunnel port sync failed port 10000 type vxlan: -110
> [ 8909.592049] netdevsim netdevsim386 eth4: UDP tunnel port sync failed port 20000 type geneve: -2
> u1518:[0]/usr/src/kernels/next-queue>

These are error injection, the test does. They are expected.
