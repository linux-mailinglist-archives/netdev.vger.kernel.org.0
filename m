Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F25466309
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbhLBMHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:07:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43998 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhLBMHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:07:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C50CDB822FC
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 12:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD702C00446;
        Thu,  2 Dec 2021 12:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638446620;
        bh=q1lR1oodyFNNUDKbWRo27+lIRwZFmJnyQ7K0oQ4tV/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5eFTRqXS7vzrTJI08uHcfQ2HDN0Kt7+WyfawEou12R4devlOWKHzre3X1zmdgACo
         mGE/ljN4c8860c+DpsCgZij1OZDx5nAzS+gR38JbIyXjhE7ofSSVldOfAKnIbNhKYJ
         e77Q2I6h4IuRTMIet3t7U2tDSO8G3Q7Iwc/+LT9tq79vg2wrZCt/spqXCFUnT9At0z
         vNHRT9cvUByVBACRpbveklIx556XxJr2MMDeN+afvonuNsORh5+ZTDCVRMSUowBDXf
         Kda8A+lyxUuHxXyL9P3RucaJf4k3FEA+GHrJCwBfUwXsGuz6h248b1QGOPbiE2md8B
         ix5qDATsmZQcg==
Date:   Thu, 2 Dec 2021 14:03:35 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs
 optional
Message-ID: <Yai2FxeS3zOHcitl@unreal>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
 <20211128125522.23357-6-ryazanov.s.a@gmail.com>
 <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
 <CAHNKnsSgc0bEwJbS01f26JRLpnzky9mcSJ6sWy2vFDuNOHz-Xw@mail.gmail.com>
 <YaR17NOQqvFxXEVs@unreal>
 <CAHNKnsTYzkz+n6rxrFsDSBuYtaqX0vePPv3s3ghB4KfXbP5m+A@mail.gmail.com>
 <YaX3V12BTl6pXsYr@unreal>
 <CAHNKnsT10PPUXEVJajHkYXyrya2_O7b80D8dcXOpcH5n0LVzLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHNKnsT10PPUXEVJajHkYXyrya2_O7b80D8dcXOpcH5n0LVzLw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 01:03:33AM +0300, Sergey Ryazanov wrote:
> On Tue, Nov 30, 2021 at 1:05 PM Leon Romanovsky <leon@kernel.org> wrote:
> > On Tue, Nov 30, 2021 at 02:44:35AM +0300, Sergey Ryazanov wrote:
> >> On Mon, Nov 29, 2021 at 9:40 AM Leon Romanovsky <leon@kernel.org> wrote:
> >>> On Mon, Nov 29, 2021 at 02:45:16AM +0300, Sergey Ryazanov wrote:
> >>>> Add Leon to CC to merge both conversations.
> >>>>
> >>>> On Sun, Nov 28, 2021 at 8:01 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> >>>>> On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
> >>>>>> +config WWAN_DEBUGFS
> >>>>>> +     bool "WWAN subsystem common debugfs interface"
> >>>>>> +     depends on DEBUG_FS
> >>>>>> +     help
> >>>>>> +       Enables common debugfs infrastructure for WWAN devices.
> >>>>>> +
> >>>>>> +       If unsure, say N.
> >>>>>
> >>>>> I wonder if that really should even say "If unsure, say N." because
> >>>>> really, once you have DEBUG_FS enabled, you can expect things to show up
> >>>>> there?
> >>>>>
> >>>>> And I'd probably even argue that it should be
> >>>>>
> >>>>>         bool "..." if EXPERT
> >>>>>         default y
> >>>>>         depends on DEBUG_FS
> >>>>>
> >>>>> so most people aren't even bothered by the question?
> >>>>>
> >>>>>>  config WWAN_HWSIM
> >>>>>>       tristate "Simulated WWAN device"
> >>>>>>       help
> >>>>>> @@ -83,6 +91,7 @@ config IOSM
> >>>>>>  config IOSM_DEBUGFS
> >>>>>>       bool "IOSM Debugfs support"
> >>>>>>       depends on IOSM && DEBUG_FS
> >>>>>> +     select WWAN_DEBUGFS
> >>>>>>
> >>>>> I guess it's kind of a philosophical question, but perhaps it would make
> >>>>> more sense for that to be "depends on" (and then you can remove &&
> >>>>> DEBUG_FS"), since that way it becomes trivial to disable all of WWAN
> >>>>> debugfs and not have to worry about individual driver settings?
> >>>>>
> >>>>>
> >>>>> And after that change, I'd probably just make this one "def_bool y"
> >>>>> instead of asking the user.
> >>>>
> >>>> When I was preparing this series, my primary considered use case was
> >>>> embedded firmwares. For example, in OpenWrt, you can not completely
> >>>> disable debugfs, as a lot of wireless stuff can only be configured and
> >>>> monitored with the debugfs knobs. At the same time, reducing the size
> >>>> of a kernel and modules is an essential task in the world of embedded
> >>>> software. Disabling the WWAN and IOSM debugfs interfaces allows us to
> >>>> save 50K (x86-64 build) of space for module storage. Not much, but
> >>>> already considerable when you only have 16MB of storage.
> >>>>
> >>>> I personally like Johannes' suggestion to enable these symbols by
> >>>> default to avoid bothering PC users with such negligible things for
> >>>> them. One thing that makes me doubtful is whether we should hide the
> >>>> debugfs disabling option under the EXPERT. Or it would be an EXPERT
> >>>> option misuse, since the debugfs knobs existence themself does not
> >>>> affect regular WWAN device use.
> >>>>
> >>>> Leon, would it be Ok with you to add these options to the kernel
> >>>> configuration and enable them by default?
> >>>
> >>> I didn't block your previous proposal either. Just pointed that your
> >>> description doesn't correlate with the actual rationale for the patches.
> >>>
> >>> Instead of security claims, just use your OpenWrt case as a base for
> >>> the commit message, which is very reasonable and valuable case.
> >>
> >> Sure. Previous messages were too shallow and unclear. Thanks for
> >> pointing me to this issue. I will improve them based on the feedback
> >> received.
> >>
> >> I still think we need separate options for the subsystem and for the
> >> driver (see the rationale below). And I doubt, should I place the
> >> detailed description of the OpenWrt case in each commit message, or it
> >> would be sufficient to place it in a cover letter and add a shorter
> >> version to each commit message. On the one hand, the cover letter
> >> would not show up in the git log. On the other hand, it is not
> >> genteelly to blow up each commit message with the duplicated story.
> >
> > I didn't check who is going to apply your patches, but many maintainers
> > use cover letter as a description for merge commit. I would write about
> > OpenWrt in the cover letter only.
> >
> >>> However you should ask yourself if both IOSM_DEBUGFS and WWAN_DEBUGFS
> >>> are needed. You wrote that wwan debugfs is empty without ioasm. Isn't
> >>> better to allow user to select WWAN_DEBUGFS and change iosm code to
> >>> rely on it instead of IOSM_DEBUGFS?
> >>
> >> Yep, WWAN debugfs interface is useless without driver-specific knobs.
> >> At the moment, only the IOSM driver implements the specific debugfs
> >> interface. But a WWAN modem is a complex device with a lot of
> >> features. For example, see a set of debug and test interfaces
> >> implemented in the proposed driver for the Mediatek T7xx chipset [1].
> >> Without general support from the kernel, all of these debug and test
> >> features will most probably be implemented using the debugfs
> >> interface.
> >>
> >> Initially, I also had a plan to implement a single subsystem-wide
> >> option to disable debugfs entirely. But then I considered how many
> >> driver developers would want to create a driver-specific debugfs
> >> interface, and changed my mind in favor of individual options. Just to
> >> avoid an all-or-nothing case.
> >
> > Usually, the answer here is "don't over-engineer". Once such
> > functionality will be needed, it will be implemented pretty easily.
> 
> Ironically, I took your "don't over-engineer" argument and started
> removing the IOSM specific configuration option when I realized that
> the IOSM debugfs interface depends on relayfs and so it should select
> the RELAY option. Without the IOSM debugfs option, we should either
> place RELAY selection to an option that enables the driver itself, or
> to the WWAN subsystem debugfs enabling option. The former will cause
> the kernel inflation even with the WWAN debugfs interface disabled.
> The latter will simply be misleading. In the end, I decided to keep
> both config options in the V2.

Something like this will do the trick.

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index bdb2b0e46c12..ebb7292421a1 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -85,6 +85,7 @@ config IOSM
        tristate "IOSM Driver for Intel M.2 WWAN Device"
        depends on INTEL_IOMMU
        select NET_DEVLINK
+        select RELAY if WWAN_DEBUGFS
        help
          This driver enables Intel M.2 WWAN Device communication.

> 
> --
> Sergey
