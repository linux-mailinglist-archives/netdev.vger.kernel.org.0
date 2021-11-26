Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEA745F5AA
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 21:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhKZUN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 15:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbhKZUL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 15:11:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89960C061759
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 11:55:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E8262337
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 19:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DA0C9305B;
        Fri, 26 Nov 2021 19:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637956514;
        bh=4hQOiPQsKnk0GljqkORngIRPClWLGiDi+JEccvEa7NU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9LLVb52dOS4zn0Mb66Y8wrMkttKAaOcLT+IxWPW0fsah5Ecmp+5ROabDO5B2sVnn
         uEAYFIri0mQifRYV8MFZ4Fn7Lh5wX7qPqSemNVFmXV8fk+Qw+0Nd+uuKShqys76k5I
         taVUJa14Y2132zLxbkSdgfCIugaBabO/IsrOK7GzNbNl2FeSTVTYjR6T8UDZysCv9U
         ceSPZrMiVfDObyQlFihjaVcZNXj9ToHX4CKu+h3zpue6bFk2vSagHMJlkgf7bseWqb
         KudGCr/Xtp6UUv7YKtKCNGs2ckWcZpAROMbHiJOFmoKXMVn932xHcfb4md5B4UxnI2
         Kh7kLrpSNANjw==
Date:   Fri, 26 Nov 2021 11:55:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Message-ID: <20211126115513.4f9de392@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211126193806.fewy42a2hnpiudsj@skbuf>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
        <20211125234520.2h6vtwar4hkb2knd@skbuf>
        <20211125190101.63f1f0a2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211126095500.tkcctzfh5zp2nluc@skbuf>
        <20211126103507.3bfe7a7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211126193806.fewy42a2hnpiudsj@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Nov 2021 19:38:07 +0000 Vladimir Oltean wrote:
> On Fri, Nov 26, 2021 at 10:35:07AM -0800, Jakub Kicinski wrote:
> > Alright, but please expect more push back going forward. Linus was
> > pretty clear on what constitutes -rc material in the past, and we're
> > sending quite a lot of code in each week..  
> 
> Thanks, and please don't hesitate to push back.
> 
> If for any reason you're not comfortable including these in the "net"
> pull request, I'm okay with that, but at least allow me to keep the
> "Fixes:" tags on the patches (because they do address incomplete
> functionality), and consider applying them to net-next. Then maybe the
> AUTOSEL people will notice and pick them up :)

Yeah, but then we'll get the opposite complaint of "why is this in -next
if it's a fix".

> Anyway I've noticed that the linux-stable maintainers are much more
> generous these days when it comes to backporting. For example, I shouted
> a few months ago that a relatively large quantity of DSA refactoring
> patches was brought into "stable" because of some other patch that
> wouldn't apply 100% cleanly:
> https://lore.kernel.org/lkml/20210316162236.vmvulf3wlmtowdvf@skbuf/
> But in the meantime I got used to it and I'm a bit more relaxed about it now.

Indeed, I'll admit, it feels like the practice of stable is at odds with
the expectations of -rc releases.

If you're confident the changes are good, that's fine by me. It's still
relatively early -rc days.
