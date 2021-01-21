Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2AE2FDF94
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbhAUCVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbhAUAwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 19:52:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 947F023602;
        Thu, 21 Jan 2021 00:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611190241;
        bh=87wGMhsXUrsr3OJlQSSHfERoYkWmFHAB+rp1mZXf4eM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N62MTHKejFTJ91VreEJyH/SsWFmuvTIajfyM6UtXgWNSASz2i1qHKqUAIge+AmNtA
         4XS31j31rIPwZwWV0NEzOgcaqGaKZA2oKA9EKYMlt54nSVYofDdq1NravCKE+xMemr
         79DuRPQ5ep2XAJlh5Y7neJng1hG9YSnQhvfeyXMNoafSCvcaDc360WUN7VoQTy3g0k
         Bi2Fs5FhfhPzow6lQznDaDFGYb8B5sdJtsi4V7DTIUg02goEM9L38b6kILP0yLBBHv
         H1MHp5vSnV9JiuelqwuC0vUAp4BCNMmRR41LLOrMUbMWH3sQvK0jFbSKrEWqoSYRek
         ozmEI1KnVcf5A==
Date:   Wed, 20 Jan 2021 16:50:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/1] net: dsa: hellcreek: Add TAPRIO
 offloading support
Message-ID: <20210120165039.2867de26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87turc2i14.fsf@kurt>
References: <20210116124922.32356-1-kurt@linutronix.de>
        <20210116124922.32356-2-kurt@linutronix.de>
        <20210119155703.7064800d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87turc2i14.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 08:18:15 +0100 Kurt Kanzenbach wrote:
> >> +	/* Schedule periodic schedule check */
> >> +	schedule_delayed_work(&hellcreek_port->schedule_work,
> >> +			      HELLCREEK_SCHEDULE_PERIOD);  
> >
> > Why schedule this work every 2 seconds rather than scheduling it
> > $start_time - 8 sec + epsilon?  
> 
> The two seconds are taken from the programming guide. That's why I used
> it.
> 
> The PTP frequency starts to matter for large deltas. In theory the
> rescheduling period can be increased [1]. Should I adjust it? 

I see, makes sense. You can leave it as is, please just add a comment
next to the definition saying that the exact value is not important we
just want it to be low enough to no suffer from clock freq error.
