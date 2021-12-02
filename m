Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D7A466925
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376352AbhLBRem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:34:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56676 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376359AbhLBRee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 12:34:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83B26274F
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 17:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E1CC00446;
        Thu,  2 Dec 2021 17:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638466271;
        bh=B5EE7GsH55N6jRcNwrXVrmcVh+7BHLxCCs7YEijuuzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YCCR61Q2CAYOiYX+sq0M/BC1R4d6KpGF0AJWZ3Tpt6SG2g7rWq50rQbHVb/ERVT9C
         GzHtViLBzYdwFVCmFKX33oI8rmIM+hM+UzteIZUNM5EG0NalYLdu1Jm9Qs4meMKAPi
         3xpFz3F0QPK05N/nPKMno58k/BS/qAmcn2ZgtoSFVkYBzzqmlNn76MMOyWPO+1fqWd
         es2tOzggpkcBRlPt+e4zY2gjFqumYnOOZDkHSh9Y8tMVUjJQgpxr4yaojDflCHyryO
         2grAK4BtyrsZcaNqOuv3KoVTYuBhF/wgVnmWjjpDbig+v+2Wp9bA8/zCMU2BSgeWg3
         HLh5ZtE7bqlaQ==
Date:   Thu, 2 Dec 2021 09:31:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: Re: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Message-ID: <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
 <20211122144307.218021-2-sunrani@nvidia.com>
 <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
 <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 07:07:05 +0000 Saeed Mahameed wrote:
> On Tue, 2021-11-30 at 19:12 -0800, Jakub Kicinski wrote:
> > On Tue, 30 Nov 2021 22:17:29 +0000 Sunil Sudhakar Rani wrote:  
> > > Sorry for the late response. We agree that the current definition
> > > is vague.
> > > 
> > > What we meant is that the enforcement is done by device/FW.
> > > We simply want to allow VF/SF to access privileged or restricted
> > > resource such as physical port counters.
> > > So how about defining the api such that:
> > > This knob allows the VF/SF to access restricted resource such as
> > > physical port counters.  
> > 
> > You need to say more about the use case, I don't understand 
> > what you're doing.  
> 
> Some device features/registers/units are not available by default to
> VFs/SFs (e.g restricted), examples are: physical port
> registers/counters and similar global attributes.
> 
> Some customers want to use SF/VF in specialized VM/container for
> management and monitoring, thus they want SF/VF to have similar
> privileges to PF in terms of access to restricted resources.
> 
> Note: this doesn't break the sriov/sf model, trusted SF/VF will not be
> allowed to alter device attributes, they will simply enjoy access to
> more resources/features.

None of this explains the use case. It's pretty much what Sunil already
stated. 

> We would've pushed for a more fine-grained per "capability" API, but
> where do we start/end? I think "trust" concept is the right approach.

