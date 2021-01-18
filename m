Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36ACF2FA9CE
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393788AbhARTM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437033AbhARTLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 14:11:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D664422573;
        Mon, 18 Jan 2021 19:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610997023;
        bh=ZDVED+BDpPUl1j75vfxYgGUeEhvgDLhLNqHYC/MeNmM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PKAMhwya+NydDuH/nrhb7U0Cz9WvygMu6Ph60HDxlgW+Oz21di/xNRSqaUP6NDGZE
         aoSzD/NukCDDhjZJ286vBXzLZwQgZpmBMYaAnPMzeKlK9yOH3+GwsoAKF9Ha3d+Ltj
         x/4Hug21xDBo+fEIEMwYXFD1G8ZO6EdnzBUUcBJbUIR5SddY+DP+AwwaoDSJ1fdiXR
         QyhcSDKvBx5nsWbQBl5vUgQ1iFJOJhgUDiwx+d14Iu8vz32y4sH9RdUk9DpUMKCHZ3
         +7x9p9s8eLR6+ty/RUcWlgnhJAiojUyQG3lnlCUdqWPsY5AfTDHAbU0cp1hDov3jpm
         Fe3OKBxtEDrTg==
Date:   Mon, 18 Jan 2021 11:10:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Bhaskar Upadhaya <bupadhaya@marvell.com>, <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 1/3] qede: add netpoll support for
 qede driver
Message-ID: <20210118111021.6e423363@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5f6c49fc-8dfc-9d54-7d90-89a78cae9b2a@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
        <1610701570-29496-2-git-send-email-bupadhaya@marvell.com>
        <20210116182607.01f26f15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5f6c49fc-8dfc-9d54-7d90-89a78cae9b2a@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Jan 2021 17:35:30 +0100 Igor Russkikh wrote:
> > On Fri, 15 Jan 2021 01:06:08 -0800 Bhaskar Upadhaya wrote:  
> >> Add net poll controller support to transmit kernel printks
> >> over UDP  
> > 
> > Why do you need this patch? Couple years back netpoll was taught 
> > how to pull NAPIs by itself, and all you do is schedule NAPIs.
> > 
> > All the driver should do is to make sure that when napi is called 
> > with budget of 0 it only processes Tx completions, not Rx traffic.  
> 
> Hi Jakub,
> 
> Thanks for the hint, we were not aware of that.
> 
> I see our driver may not handle zero budget accordingly. Will check.
> 
> But then, all this means .ndo_poll_controller is basically deprecated?

It's still needed for special devices, off the top of my head for
example bonding uses it to poll its members. But for normal NIC
drivers, yes, it's pretty much deprecated.
