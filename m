Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7229978E96
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfG2PCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:02:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44986 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727168AbfG2PCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 11:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JSWsR08a0l9t8e7uYY7dWaL6U4fKWmgrhjCsvX1Z6cM=; b=YQbbjbDgFTYzXno+RUXkz4lJz9
        Z3mXB/hc0MjZVyOnmuGeNMjXh3xaiuC8NmRAtn8NaCjWhdSdcPCCJ2kY9FIX4xl+ruPnUu7FNkEWA
        xa3MbSsKKrmbIQFynBmaCZkiyxLMIL/gKIp+VQqV0eahIeW1gLKm8A90/TuxRgSsO2kg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hs79y-0002Ez-FQ; Mon, 29 Jul 2019 17:01:58 +0200
Date:   Mon, 29 Jul 2019 17:01:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Benjamin Beckmeyer <beb@eks-engel.de>
Cc:     netdev@vger.kernel.org
Subject: Re: DSA Rate Limiting in 88E6390
Message-ID: <20190729150158.GE4110@lunn.ch>
References: <5a632696-946d-504b-1077-f7eb6d31ec19@eks-engel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a632696-946d-504b-1077-f7eb6d31ec19@eks-engel.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 12:30:20PM +0200, Benjamin Beckmeyer wrote:
> Hi all,
> is there a possibility to set the rate limiting for the 6390 with linux tools?
> I've seen that the driver will init all to zero, so rate limiting is disabled, 
> but there is no solution for it in the ip tool?
> 
> The only thing I found for rate limiting is the tc tool, but I guess this is 
> only a software solution?

Hi Benjamin

In Linux, we accelerate the software solution by offloading it to the
hardware. So TC is what you need here.
 
> Furthermore, does exist a table or a tutorial which functions DSA supports?
> The background is that we are using the DSDT driver (in future maybe the UMSD
> driver) but we would like to switch to the in kernel DSA entirely. And our
> software is using some of the DSDT functions, so I have to find an 
> alternative to these functions.

The DSA framework supports offloading TC. There was some patches a
while back adding ingress rate limiting to one of the DSA drivers, via
TC. I forget which, and i don't think they have been merged yet. If
you can find the patchset, it should give you a good idea how you can
implement support in the mv88e6xxx driver.

	  Andrew
