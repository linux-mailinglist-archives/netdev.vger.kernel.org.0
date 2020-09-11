Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D50E26687C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgIKTAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:00:15 -0400
Received: from mga05.intel.com ([192.55.52.43]:6558 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgIKTAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 15:00:14 -0400
IronPort-SDR: /Lu3C32kluHHYzSOGHXY1D8Q9G5/J394zPZu6abADvBPlHBHnevAgu/uqpag4pe9f01KZgLOlw
 AiEUnJVjHqfg==
X-IronPort-AV: E=McAfee;i="6000,8403,9741"; a="243660572"
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="243660572"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 12:00:08 -0700
IronPort-SDR: kbJRtATcXqMIZYEWhTVSp4nx1R87fX0Ubo85bNfgkBXkokJ0MQwU3jL6QnJnsGJNGB/j0DKpvp
 RSclCt8pb/iQ==
X-IronPort-AV: E=Sophos;i="5.76,416,1592895600"; 
   d="scan'208";a="329876700"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.209.99.126])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 12:00:07 -0700
Date:   Fri, 11 Sep 2020 12:00:05 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1
 clean
Message-ID: <20200911120005.00000178@intel.com>
In-Reply-To: <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:

> On Thu, 10 Sep 2020 18:23:26 -0700 Jesse Brandeburg wrote:
> > Some of these patches are already sent to Intel Wired Lan, but the rest
> > of the series titled drivers/net/ethernet affects other drivers, not
> > just Intel, but they depend on the first five.
> 
> Great stuff. Much easier to apply one large series than a thousand
> small patches. I haven't read all the comment changes but FWIW:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!

> I feel slightly bad for saying this but I think your config did not
> include all the drivers, 'cause I'm still getting some warnings after
> patch 11. Regardless this is impressive effort, thanks!

No worries! I want to get it right, can you share your methodology?

I saw from some other message that you're doing
make CC="ccache gcc" allmodconfig
make CC="ccache gcc" -j 64 W=1 C=1

Is that the right sequence? did you start with a make mrproper as well?
I may have missed some drivers when I did this:
make allyesconfig
make menuconfig
<turn on all "Ethernet Drivers" = m manually>

but I'd like to target the actual job you're running and use that as
the short-term goal.

Also, if you have any comments about the removal of the lvalue from
some of the register read operations, I figure that is the riskiest
part of all this.
