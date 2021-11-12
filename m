Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D2744E980
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhKLPHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:07:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:29951 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233894AbhKLPHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 10:07:15 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="231866028"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="231866028"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:04:15 -0800
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="493042133"
Received: from pitchaix-mobl1.gar.corp.intel.com ([10.215.132.170])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:04:09 -0800
Message-ID: <9999b559abecea2eeb72b0b6973a31fcd39087c1.camel@linux.intel.com>
Subject: Re: 32bit x86 build broken (was: Re: [GIT PULL] Networking for
 5.16-rc1)
From:   Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        linux-can@vger.kernel.org
Date:   Fri, 12 Nov 2021 07:04:04 -0800
In-Reply-To: <20211112063355.16cb9d3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211111163301.1930617-1-kuba@kernel.org>
         <163667214755.13198.7575893429746378949.pr-tracker-bot@kernel.org>
         <20211111174654.3d1f83e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAHk-=wiNEdrLirAbHwJvmp_s2Kjjd5eV680hTZnbBT2gXK4QbQ@mail.gmail.com>
         <20211112063355.16cb9d3b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-11-12 at 06:33 -0800, Jakub Kicinski wrote:
> On Thu, 11 Nov 2021 18:48:43 -0800 Linus Torvalds wrote:
> > On Thu, Nov 11, 2021 at 5:46 PM Jakub Kicinski <kuba@kernel.org>
> > wrote:
> > > Rafael, Srinivas, we're getting 32 bit build failures after pulling
> > > back
> > > from Linus today.
> > > 
> > > make[1]: *** [/home/nipa/net/Makefile:1850: drivers] Error 2
> > > make: *** [Makefile:219: __sub-make] Error 2
> > > ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:
> > > In function ‘send_mbox_cmd’:
> > > ../drivers/thermal/intel/int340x_thermal/processor_thermal_mbox.c:7
> > > 9:37: error: implicit declaration of function ‘readq’; did you mean
> > > ‘readl’? [-Werror=implicit-function-declaration]
> > >    79 |                         *cmd_resp = readq((void __iomem *)
> > > (proc_priv->mmio_base + MBOX_OFFSET_DATA));
> > >       |                                     ^~~~~
> > >       |                                     readl  
> > 
> > Gaah.
> > 
> > The trivial fix is *probably* just a simple
> 
> To be sure - are you planning to wait for the fix to come via 
> the usual path?  We can hold applying new patches to net on the 
> off chance that you'd apply the fix directly and we can fast 
> forward again :) 
> 
> Not that 32bit x86 matters all that much in practice, it's just 
> for preventing new errors (64b divs, mostly) from sneaking in.
> 
> I'm guessing Rafeal may be AFK for the independence day weekend.
He was off, but not sure if he is back. I requested Daniel to send PULL
request for
https://lore.kernel.org/lkml/a22a1eeb-c7a0-74c1-46e2-0a7bada73520@infradead.org/T/




