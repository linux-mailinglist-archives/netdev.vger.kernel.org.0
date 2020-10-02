Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE8A2818C2
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 19:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388553AbgJBRGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 13:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388288AbgJBRGy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 13:06:54 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 148D9205ED;
        Fri,  2 Oct 2020 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601658414;
        bh=jw9upzBUh5IXpQN9i009xlU1DiPnjKk6XeCgluxORIA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tFQ9qPtZrPq/AT71/kcKgkI2iwzo7wYPeLCDC7MoeX0dp2ZaWbNceysEcCiW4rSII
         8RQwgcsG003b1umOjS0UgfDw0E8EXPLARcf0yFYiX9dmhh09Kapnl9z0tDtCvNUdAZ
         LYyiBVZ9wr571qVBSXcckcUw7/cxOwLY8QYJRwzY=
Message-ID: <5b8819b9bf56064bdc6e1a653ca40914f8d7657a.camel@kernel.org>
Subject: Re: [net V2 09/15] net/mlx5e: Add resiliency in Striding RQ mode
 for packets larger than MTU
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>, Tariq Toukan <tariqt@nvidia.com>
Date:   Fri, 02 Oct 2020 10:06:52 -0700
In-Reply-To: <20201001162709.40e7ce85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001195247.66636-1-saeed@kernel.org>
                <20201001195247.66636-10-saeed@kernel.org>
         <20201001162709.40e7ce85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 16:27 -0700, Jakub Kicinski wrote:
> On Thu,  1 Oct 2020 12:52:41 -0700 saeed@kernel.org wrote:
> > Usually, this filtering is performed by the HW, except for a few
> > cases:
> > - Between 2 VFs over the same PF with different MTUs
> > - On bluefield, when the host physical function sets a larger MTU
> > than
> >   the ARM has configured on its representor and uplink representor.
> 
> Just to confirm - is not multi-host affected?

Yes, but not Connecxt4-LX multi-host as it doesn't default to striding-
RQ mode.

