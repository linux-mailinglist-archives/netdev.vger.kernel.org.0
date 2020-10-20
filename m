Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C877B29323C
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389249AbgJTANz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:13:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389221AbgJTANz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 20:13:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E256620637;
        Tue, 20 Oct 2020 00:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603152835;
        bh=UL606fIo3DvsNwqvpY6R1cEuc8k22snjyK3hHJ53iQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VKc3l9jO2bXxzu7AFaaExy/RUrCmZYSL68S6nswyK5kol1DmJ+mEFkm0fJqeoRjh1
         rIl8myyUy1kMJrJ3TN+wJdV0HMjw3ZS+G4LKiogTcMV9Yt/q5Q5AoPW6+1XmpWR9sG
         RB/7hj8FkH8eDrSvi13AzUHFbxXPzb3qc3HS4DkM=
Date:   Mon, 19 Oct 2020 17:13:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: reference count the host mdb addresses
Message-ID: <20201019171352.529f1133@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020000746.GR456889@lunn.ch>
References: <20201015212711.724678-1-vladimir.oltean@nxp.com>
        <20201019165514.1fe7d8f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201020000746.GR456889@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 02:07:46 +0200 Andrew Lunn wrote:
> On Mon, Oct 19, 2020 at 04:55:14PM -0700, Jakub Kicinski wrote:
> > On Fri, 16 Oct 2020 00:27:11 +0300 Vladimir Oltean wrote:  
> > > Currently any DSA switch that implements the multicast ops (properly,
> > > that is) gets these errors after just sitting for a while, with at least
> > > 2 ports bridged:
> > > 
> > > [  286.013814] mscc_felix 0000:00:00.5 swp3: failed (err=-2) to del object (id=3)
> > > 
> > > The reason has to do with this piece of code:
> > > 
> > > 	netdev_for_each_lower_dev(dev, lower_dev, iter)
> > > 		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);  
> > 
> > We need a review on this one, anyone?  
> 
> Hi Jakub
> 
> Thanks for the reminder. It has been on my TODO list since i got back
> from vacation.

Good to have you back! :)
