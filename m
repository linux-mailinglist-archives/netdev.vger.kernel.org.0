Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8061323203
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 21:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhBWUW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 15:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:43450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233355AbhBWUWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 15:22:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6189764E4B;
        Tue, 23 Feb 2021 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614111731;
        bh=8laCGD7U3MYSyfadsQn88ZtEeX4T0liVLcz0GRwyYPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ptB8CxddL8YW1QWoe5c+F2+mjCCPOjZ5mvl4BJ1Lg1ajOaPrSNldFAHh+oS+pNkZC
         2+6bIMBBxI7b2lC7leRQ81c78RiYHbw9ZS6uzxNZ1a6f427EtC4bc6qit+8HP5v0iC
         woponyIisbOLVjymtcU7CoIidFKbLhM/f9xFmrwZhlp6r5sN2s7mEDKaXUBhl6Jkv2
         Z4QTDhkf3deSqAf1n7UZ7WiQOY6BPmWNwCgiKHTbsauKJUyE0/R95tSyzHzXJFcZRA
         Jsk6NF8eDzk+w4qMN13Yrft7FUxdmZ5JXv0gI2CWaH4LJTaF2ShvzS3Ijg7TTPw+Ni
         zDiTyfjCnBWIw==
Date:   Tue, 23 Feb 2021 12:22:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Coiby Xu <coxu@redhat.com>
Cc:     netdev@vger.kernel.org, kexec@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [RFC PATCH 4/4] i40e: don't open i40iw client for kdump
Message-ID: <20210223122207.08835e0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222070701.16416-5-coxu@redhat.com>
References: <20210222070701.16416-1-coxu@redhat.com>
        <20210222070701.16416-5-coxu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 15:07:01 +0800 Coiby Xu wrote:
> i40iw consumes huge amounts of memory. For example, on a x86_64 machine,
> i40iw consumed 1.5GB for Intel Corporation Ethernet Connection X722 for
> for 1GbE while "craskernel=auto" only reserved 160M. With the module
> parameter "resource_profile=2", we can reduce the memory usage of i40iw
> to ~300M which is still too much for kdump.
> 
> Disabling the client registration would spare us the client interface
> operation open , i.e., i40iw_open for iwarp/uda device. Thus memory is
> saved for kdump.
> 
> Signed-off-by: Coiby Xu <coxu@redhat.com>

Is i40iw or whatever the client is not itself under a CONFIG which
kdump() kernels could be reasonably expected to disable?
