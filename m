Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F2C1CCFE9
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 04:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgEKC4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 22:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgEKC4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 22:56:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01192207FF;
        Mon, 11 May 2020 02:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589165806;
        bh=vxznxnXyV9jJgjbtDTP982UE/WBJquPKTv27zUplE1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BJVMm8PHc1/fJcdww881DsO16kShx84Jgv2VY8i6CeStvB6MiXTk4yA5y6RVibirE
         Mx/L0TO4LREbi1o/lAzprpUoJUstHhYK0mCh/bSg96h2cHiV23LlaGvYYHV483bceq
         tO6fR32mpFnNGU+Bfti/zuOd4FKacyeTTN9vYLv4=
Date:   Sun, 10 May 2020 19:56:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH v4 resend net-next 0/4] Cross-chip bridging for disjoint
 DSA trees
Message-ID: <20200510195644.0058101c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200510163743.18032-1-olteanv@gmail.com>
References: <20200510163743.18032-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 May 2020 19:37:39 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support for boards where DSA switches of multiple types
> are cascaded together. Actually this type of setup was brought up before
> on netdev, and it looks like utilizing disjoint trees is the way to go:
> 
> https://lkml.org/lkml/2019/7/7/225
> 
> The trouble with disjoint trees (prior to this patch series) is that only
> bridging of ports within the same hardware switch can be offloaded.
> After scratching my head for a while, it looks like the easiest way to
> support hardware bridging between different DSA trees is to bridge their
> DSA masters and extend the crosschip bridging operations.
> 
> I have given some thought to bridging the DSA masters with the slaves
> themselves, but given the hardware topology described in the commit
> message of patch 4/4, virtually any number (and combination) of bridges
> (forwarding domains) can be created on top of those 3x4-port front-panel
> switches. So it becomes a lot less obvious, when the front-panel ports
> are enslaved to more than 1 bridge, which bridge should the DSA masters
> be enslaved to.
> 
> So the least awkward approach was to just create a completely separate
> bridge for the DSA masters, whose entire purpose is to permit hardware
> forwarding between the discrete switches beneath it.
> 
> This is a direct resend of v3, which was deferred due to lack of review.
> In the meantime Florian has reviewed and tested some of them.
> 
> v1 was submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200429161952.17769-1-olteanv@gmail.com/
> 
> v2 was submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200430202542.11797-1-olteanv@gmail.com/
> 
> v3 was submitted here:
> https://patchwork.ozlabs.org/project/netdev/cover/20200503221228.10928-1-olteanv@gmail.com/

Applied, thanks everyone!
