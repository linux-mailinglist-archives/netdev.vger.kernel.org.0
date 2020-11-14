Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A612B29DC
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgKNA1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:27:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgKNA1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:27:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77AC72225B;
        Sat, 14 Nov 2020 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605313630;
        bh=kbjpbHZqBe/j/J0/85NRbKAMl5cM+yVFagK3JWoxB7c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vTUe687URi5omkSztN//C15R7hF6PDuz4If/y20ZY7rIeTaY7Ga3gFtf6Ni8sJ0uA
         jy/VLBRLMMM3MPBnKzihMzEg/Sq1N0ibEOEFTnBcBX2guOODn8ckPxWqTIRp7LIQtQ
         eb7KBQJM8SyfQ+Av7ytVQhy/K3MbbPjmdYBUaDDY=
Date:   Fri, 13 Nov 2020 16:27:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201113162709.608406b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111131153.3816-2-tobias@waldekranz.com>
References: <20201111131153.3816-1-tobias@waldekranz.com>
        <20201111131153.3816-2-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 14:11:52 +0100 Tobias Waldekranz wrote:
> Ethertype DSA encodes exactly the same information in the DSA tag as
> the non-ethertype variety. So refactor out the common parts and reuse
> them for both protocols.
> 
> This is ensures tag parsing and generation is always consistent across
> all mv88e6xxx chips.
> 
> While we are at it, explicitly deal with all possible CPU codes on
> receive, making sure to set offload_fwd_mark as appropriate.

Uncharacteristically unreviewed for a DSA patch :)

> + *
> + * Regular DSA
> + * -----------
> + * For untagged (in 802.1Q terms) packes, the swich will splice in the

packes -> packets
swich  -> switch

> + * tag between the SA and the ethertype of the original packet. Tagged
> + * frames will instead have their outermost .1Q tag converted to a DSA
> + * tag. It expects the same layout when receiving packets from the
> + * CPU.

