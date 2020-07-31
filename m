Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A5F234A97
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387513AbgGaSAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729657AbgGaSAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:00:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1172087C;
        Fri, 31 Jul 2020 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596218410;
        bh=v3m93NOu2RHKqtGk+BbI7KLEBi/a9BbgDGvJwhfhejw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VZd+Ibd6vIk36uQdfvn/UoO2oSaB46FonfvQfn4rcrXBIpF+CfB2aTrSjfXPCDIsM
         ji0+Auh0CQwM7aseUcBPZzPHB45+59g4fbRuGVMI1ZEF5X/jD/tQdFGmDkDj5Jyt1D
         xuuJzvEbLyzP7vz9lRc9npBil7e+jefxq56tzZlw=
Date:   Fri, 31 Jul 2020 11:00:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ganji Aravind <ganji.aravind@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200731110904.GA1571@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
        <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200731110904.GA1571@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jul 2020 16:39:04 +0530 Ganji Aravind wrote:
> On Thursday, July 07/30/20, 2020 at 16:23:35 -0700, Jakub Kicinski wrote:
> > On Thu, 30 Jul 2020 20:41:38 +0530 Ganji Aravind wrote:  
> > > Update set_flash to flash firmware configuration image
> > > to flash region.  
> > 
> > And the reason why you need to flash some .ini files separately is?  
> 
> Hi Jakub,
> 
> The firmware config file contains information on how the firmware
> should distribute the hardware resources among NIC and
> Upper Layer Drivers(ULD), like iWARP, crypto, filtering, etc.
> 
> The firmware image comes with an in-built default config file that
> distributes resources among the NIC and all the ULDs. However, in
> some cases, where we don't want to run a particular ULD, or if we
> want to redistribute the resources, then we'd modify the firmware
> config file and then firmware will redistribute those resources
> according to the new configuration. So, if firmware finds this
> custom config file in flash, it reads this first. Otherwise, it'll
> continue initializing the adapter with its own in-built default
> config file.

Sounds like something devlink could be extended to do.

Firmware update interface is not for configuration.
