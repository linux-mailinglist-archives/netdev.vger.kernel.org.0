Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651D427A3FE
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgI0UWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:22:21 -0400
Received: from smtprelay0082.hostedemail.com ([216.40.44.82]:39946 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726314AbgI0UWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 16:22:20 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 12720100E7B40;
        Sun, 27 Sep 2020 20:22:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:967:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2693:2828:2859:2892:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6742:6743:7903:9025:10004:10400:10848:11232:11658:11914:12043:12297:12555:12740:12760:12895:12986:13069:13311:13357:13439:14096:14097:14181:14659:14721:21080:21433:21627:21987:30012:30054:30055:30075:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: guide09_05122ab2717b
X-Filterd-Recvd-Size: 3897
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf10.hostedemail.com (Postfix) with ESMTPA;
        Sun, 27 Sep 2020 20:22:11 +0000 (UTC)
Message-ID: <c7a5fd123e3c634ce0bbac9abb4ae32c8c67e0c6.camel@perches.com>
Subject: Re: [patch 00/35] net: in_interrupt() cleanup and fixes
From:   Joe Perches <joe@perches.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Paul McKenney <paulmck@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Dave Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-doc@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        Jon Mason <jdmason@kudzu.us>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Jouni Malinen <j@w1.fi>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        libertas-dev@lists.infradead.org,
        Pascal Terjan <pterjan@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Date:   Sun, 27 Sep 2020 13:22:10 -0700
In-Reply-To: <20200927194846.045411263@linutronix.de>
References: <20200927194846.045411263@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2020-09-27 at 21:48 +0200, Thomas Gleixner wrote:
> Folks,
> 
> in the discussion about preempt count consistency accross kernel configurations:
> 
>   https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> Linus clearly requested that code in drivers and libraries which changes
> behaviour based on execution context should either be split up so that
> e.g. task context invocations and BH invocations have different interfaces
> or if that's not possible the context information has to be provided by the
> caller which knows in which context it is executing.
> 
> This includes conditional locking, allocation mode (GFP_*) decisions and
> avoidance of code paths which might sleep.

Are these patches intended to be applied to Linus'
tree before v5.9 is released?

This patchset will cause conflicts against -next.

For instance, in patch 34, RT_TRACE has already
been removed in -next.


