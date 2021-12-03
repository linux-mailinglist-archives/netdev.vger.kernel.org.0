Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F3C466F0F
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350050AbhLCBWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349900AbhLCBWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 20:22:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B43C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 17:19:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7417562905
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 01:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAD6C53FCC;
        Fri,  3 Dec 2021 01:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638494359;
        bh=V0QxvZE2/2I3prvBTqC3RtsC+PAwM5qNGV/P43tlFHM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FgAVTrZp7nu/dBrNqGtbJcXHHnAePxaOFK5TpYHifWMuEvsab7yseIRYWBAoGuqdb
         8wNI8kM/KaA+BlxXlc+naoJegph9gMYbunTtqWj1rQEbwUU+49HglWwDD2aLowNbkw
         v3iGY/KHAjI+9TxFCGiDkrRqjoMXMsq7JR7S0jtsuDXjgYHPa+SozaS+6Oud/NsG7x
         2jKYf/dz9U8yGhF1iZMhvlVP65Fh5DgZ83A31AyOk74Jfr5FYQYtTWJ9nnRJT91ZEX
         a+HuM380NpTaPOGIDyz02GmyFDd3ph2rEWfPQfaQmzChKFLya8is6UYJChMWObqPnT
         HSt4v986mG+WQ==
Date:   Thu, 2 Dec 2021 17:19:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Manish Chopra <manishc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: Re: [EXT] Re: [PATCH net] qede: validate non LSO skb length
Message-ID: <20211202171918.7147ce0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY3PR18MB4612B62FDA2167BB348D4051AB699@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211124092405.28834-1-manishc@marvell.com>
        <20211124153816.124156fc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY3PR18MB4612B62FDA2167BB348D4051AB699@BY3PR18MB4612.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Dec 2021 21:19:26 +0000 Manish Chopra wrote:
> > On Wed, 24 Nov 2021 01:24:05 -0800 Manish Chopra wrote:  
> > > Although it is unlikely that stack could transmit a non LSO skb with
> > > length > MTU, however in some cases or environment such occurrences
> > > actually resulted into firmware asserts due to packet length being
> > > greater than the max supported by the device (~9700B).
> > >
> > > This patch adds the safeguard for such odd cases to avoid firmware
> > > asserts.
> > >
> > > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > > Signed-off-by: Alok Prasad <palok@marvell.com>
> > > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > Signed-off-by: Ariel Elior <aelior@marvell.com>  
> > 
> > Please add an appropriate Fixes tag and repost.  
> 
> Hello Jakub,
> 
> I don't really know which commit has introduced this exactly. It was
> probably day1 (when this driver was submitted) behavior, just that
> this issue was discovered recently by some customer environment. Let
> me know if you want me to put one of those initial driver commit tag
> here and repost ? 

Yes, that'd be best. This way any sort of automation for tracking which
fixes need to be backported will have clear signal that this fix
applies to all the kernels.
