Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302F92FA785
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393651AbhARR2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393014AbhARR2F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:28:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E86B322C9E;
        Mon, 18 Jan 2021 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610990844;
        bh=1QqZsNBiEYHce/TxqoAworGTHh0sCp2ofekQfF6WJCs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IMEdnGaABtp9XUUhkU1AUfXvRWDkxTuPKHZTZ9ZxW3y1nYE7AfHXwdZPfksslDNKX
         mlKj8l5pluv0bhky8F1h8gDd4QTPxNOfReAj/tCiGpaOqvrLVHHkFWP9AyVRcFkXP0
         7dZu/CIm0JZSiV+ZmmS2wHTpBamPUEVtS4RQcDtLloal+S1ifG3mg/njbyRZ8R/P9G
         fqYhuOuLxvTd3IV5cVbGKgnk8h+EdC75uplxR7I+dqalYYppaioq5SBFbqygMGDZx8
         NpcZzL0FJm7eNsgeRI9NjnAjmmjMNX5lMqZOtc3XRKQwKUyxrervNv2S3omeHO4QI/
         hdkSUlkXxHdaA==
Date:   Mon, 18 Jan 2021 09:27:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin B Shelar <pbshelar@fb.com>, netdev@vger.kernel.org,
        pablo@netfilter.org, laforge@gnumonks.org
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling
 API
Message-ID: <20210118092722.52c9d890@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
References: <20210110070021.26822-1-pbshelar@fb.com>
        <20210116164642.4af4de8e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8adc4450-c32d-625e-3c8c-70dbd7cbf052@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 14:23:52 +0100 Jonas Bonn wrote:
> On 17/01/2021 01:46, Jakub Kicinski wrote:
> > On Sat,  9 Jan 2021 23:00:21 -0800 Pravin B Shelar wrote:  
> >> Following patch add support for flow based tunneling API
> >> to send and recv GTP tunnel packet over tunnel metadata API.
> >> This would allow this device integration with OVS or eBPF using
> >> flow based tunneling APIs.
> >>
> >> Signed-off-by: Pravin B Shelar <pbshelar@fb.com>  
> > 
> > Applied, thanks!
> 
> This patch hasn't received any ACK's from either the maintainers or 
> anyone else providing review.  

I made Pravin wait _over_ _a_ _month_ to merge this. He did not receive
any feedback since v3, which was posted Dec 13th. That's very long.

v5 itself was laying around on patchwork for almost a week, marked as 
"Needs Review/Ack".

Normally we try to merge patches within two days. If anything my
lesson from this whole ordeal is in fact waiting longer makes
absolutely no sense. The review didn't come in anyway, and we're 
just delaying whatever project Pravin needs this for :/

Do I disagree with you that the patch is "far from pretty"? Not at all, 
but I couldn't find any actual bug, and the experience of contributors 
matters to us, so we can't wait forever.

> The following issues remain unaddressed after review:
> 
> i)  the patch contains several logically separate changes that would be 
> better served as smaller patches
> ii) functionality like the handling of end markers has been introduced 
> without further explanation
> iii) symmetry between the handling of GTPv0 and GTPv1 has been 
> unnecessarily broken
> iv) there are no available userspace tools to allow for testing this 
> functionality

I don't understand these points couldn't be stated on any of the last 
3 versions / in the last month.

> I have requested that this patch be reworked into a series of smaller 
> changes.  That would allow:
> 
> i) reasonable review
> ii) the possibility to explain _why_ things are being done in the patch 
> comment where this isn't obvious (like the handling of end markers)
> iii) the chance to do a reasonable rebase of other ongoing work onto 
> this patch (series):  this one patch is invasive and difficult to rebase 
> onto
> 
> I'm not sure what the hurry is to get this patch into mainline.  Large 
> and complicated patches like this take time to review; please revert 
> this and allow that process to happen.

You'd need to post a revert with the justification to the ML, so it can
be reviewed on its merits. That said I think incremental changes may be
a better direction.
