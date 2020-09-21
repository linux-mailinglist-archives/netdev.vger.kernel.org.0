Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B8E27356A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 00:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgIUWCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 18:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728308AbgIUWCG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 18:02:06 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0103B23A60;
        Mon, 21 Sep 2020 22:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600725726;
        bh=VQo3ssf5RJkttWH+xxwwzcrxGz/tD05/HCsD/0dyH0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XZW5p7hqkY/rJ/fEoiGz2JjKWzZfsZxjOhT3CyvsU7/5Gc6HolU6kNTrpHmJiM8gO
         lkOwas3So2vh6TmC1cn4gBaZMS4QljhDK6qK2ghwm8vsG1nCYfUrs+gskNK6O5flF+
         Ym1EbUI/4lh07y3KqLtjrMtXlc40pZHxSmgRPs3k=
Date:   Mon, 21 Sep 2020 15:02:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Message-ID: <20200921150204.11484b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB4322C97E73753786B179ACE3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918112817.410ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322C97E73753786B179ACE3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 20:09:24 +0000 Parav Pandit wrote:
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Friday, September 18, 2020 11:58 PM
> > 
> > On Fri, 18 Sep 2020 17:47:24 +0000 Parav Pandit wrote:  
> > > > > What do you suggest?  
> > > >
> > > > Start with real patches, not netdevsim.  
> > >
> > > Hmm. Shall I split the series below, would that be ok?
> > >
> > > First patchset,
> > > (a) devlink piece to add/delete port
> > > (b) mlx5 counter part
> > >
> > > Second patchset,
> > > (a) devlink piece to set the state
> > > (b) mlx5 counter part
> > >
> > > Follow on patchset to create/delete sf's netdev on virtbus in mlx5 + devlink  
> > plumbing.  
> > > Netdevsim after that.  
> > 
> > I'd start from the virtbus part so we can see what's being created.  
> 
> How do you reach there without a user interface?

Well.. why do you have a user interface which doesn't cause anything to
happen (devices won't get created)? You're splitting the submission,
it's obvious the implementation won't be complete after the first one.

My expectation is that your implementation of the devlink commands will
just hand them off to FW, so there won't be anything interesting there
to review. 

Start with the hard / risky parts - I consider the virtbus to be that,
since the conversation there includes multiple vendors, use cases and
subsystems.
