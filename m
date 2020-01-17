Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8856314016C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 02:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388092AbgAQB0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 20:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbgAQB0f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 20:26:35 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC3B220728;
        Fri, 17 Jan 2020 01:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579224394;
        bh=1UISYqwUWwwvH3mbOBovGUNJcB5XciuC3YEepxg/Bf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D6cN098tabZVxo7SMVeGKvnnu3yV9fwo+82Qva+iU8PPpY92q3k9BrZfAbVhWvzn7
         Op/SgR2RlYW5aye0SA/jvykHAbEPtEQ6Z+f+Jvs/iVukJv0B/xa6fi/I3WAFMaYeJc
         uzQr4zci/ZlQcyIQejISiirGCGwRhav/Fpwng7x0=
Date:   Thu, 16 Jan 2020 17:26:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC 3/3] net/mlx5: Add FW upgrade reset support
Message-ID: <20200116172633.5d873c17@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <2f7a4d81-6ed9-7c93-1562-1df4dc7f9578@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
        <1579017328-19643-4-git-send-email-moshe@mellanox.com>
        <20200115070145.3db10fe4@cakuba.hsd1.ca.comcast.net>
        <2f7a4d81-6ed9-7c93-1562-1df4dc7f9578@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 14:52:35 +0000, Moshe Shemesh wrote:
> > If multiple devices under one bridge are a real concern (or otherwise
> > interdependencies) would it make sense to mark the devices as "reload
> > pending" and perform the reloads once all devices in the group has this
> > mark set?  
> 
> All mlx5 current devices support PCI - Express only.
> 
> PCI-Express device should have its own PCI-Express bridge, it is 1x1 
> connection.
> 
> So the check here is just to verify, all functions found under the 
> bridge are expected to be the same device functions (PFs and VFs).

Ah, good, I couldn't confirm that PCIe fact with google fast enough :)
The check sounds good then, with perhaps a small suggestion to add 
a helper in PCIe core if it's already done by two drivers? Can be as 
a follow up..
