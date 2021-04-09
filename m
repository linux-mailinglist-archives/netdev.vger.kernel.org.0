Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DD935A5E6
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234498AbhDIShY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhDIShX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 14:37:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A09B861104;
        Fri,  9 Apr 2021 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617993429;
        bh=Iy3Qb7NwLtOCYIRd5re3QWLFgzfiolRSmn+5l2eQUiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCQ+iCfwvt/MKTGJ77VEaRMsFssdYRLng0FXgJI/uXkMCBcztBQdf1x0meBu8/qp9
         ksKdRg1pdr5lq8RJlDaiz8H+ea1ONgvH8lwrbD7f8hqNGbZB2o1NKWj+KHN9a0IBKE
         SkryDl7+ZNH/jV+sf3cnEMJfh1X8uAewzaMghwykjNGbPNt6QdtvZ8xxQ7KxYraxrk
         owQ+E+kfmWHM4lvtOVWjNl0+BYV9mV+Zy7kAjgjTE1ls2J7XudJjpJYDOkU2tR1lEq
         oVV62blZ5SmQjIPdDUI2RU64ZaG40n8Ba7zePu73ArRSSCsPVuXo1b3j0fNpvGE6jB
         x+2vU7tOip4MA==
Date:   Fri, 9 Apr 2021 11:37:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, idosch@idosch.org,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [RFC] net: core: devlink: add port_params_ops for devlink port
 parameters altering
Message-ID: <20210409113707.4fad51dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409170114.GB8110@plvision.eu>
References: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
        <ce46643a-99ad-54e8-b5ed-b85ca35ecbcb@intel.com>
        <20210409170114.GB8110@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Apr 2021 20:01:14 +0300 Vadym Kochan wrote:
> On Fri, Apr 09, 2021 at 09:51:13AM -0700, Samudrala, Sridhar wrote:
> > On 4/9/2021 9:22 AM, Oleksandr Mazur wrote:  
> > > I'd like to discuss a possibility of handling devlink port parameters
> > > with devlink port pointer supplied.
> > > 
> > > Current design makes it impossible to distinguish which port's parameter
> > > should get altered (set) or retrieved (get) whenever there's a single
> > > parameter registered within a few ports.  
> > 
> > I also noticed this issue recently when trying to add port parameters and
> > I have a patch that handles this in a different way. The ops in devlink_param
> > struct can be updated to include port_index as an argument
> 
> We were thinking on this direction but rather decided to have more strict
> cb signature which reflects that we are working with devlink_port only.

+1 for passing the actual pointer
