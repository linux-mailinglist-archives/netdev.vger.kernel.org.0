Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC82B367355
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 21:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243509AbhDUTUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 15:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243038AbhDUTUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 15:20:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD509613D8;
        Wed, 21 Apr 2021 19:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619032810;
        bh=Fnina1B7+AE5Wwe2BxpYRdSHYHzDFJs/VUhcXc4PWHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q28AXH+CjVzRs7VH7TKNuKDWfSKHVMy0ZG9m+b2t6iGaSSrVJNzc3OevvoZBYnCWV
         jfXazzboXUu9dWphhszdYYxLNo6MCYafkZhOsJp47HsXTCwrknsMc4JmT1Oa6aQGuk
         1EFe7VsRq1If8Lbk4UAuEluPtcom+XLheEP/t7Olv12BDJQn2HbYZsVVH3viu31iOy
         8NwirlDYG3ykBYr5iRDXmhn2Ne1Sm00yytxtvOlgxsOaFEAMjcaiKo48X3aYGN+bll
         JKv5GtdM8Vcr7dR03f4xH3Uk9hWOZAkItWg+naFOPLeXzg5U619r4dDtSvwEOD+jS0
         Bt2gq5UOcv0Vw==
Date:   Wed, 21 Apr 2021 12:20:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Message-ID: <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210421174723.159428-7-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
        <20210421174723.159428-7-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 10:47:18 -0700 Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Extended SF port attributes to have optional external flag similar to
> PCI PF and VF port attributes.
> 
> External atttibute is required to generate unique phys_port_name when PF number
> and SF number are overlapping between two controllers similar to SR-IOV
> VFs.
> 
> When a SF is for external controller an example view of external SF
> port and config sequence.
> 
> On eswitch system:
> $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> 
> $ devlink port show
> pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
> pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller 1 pfnum 0 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00
> 
> $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
> pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller 1 pfnum 0 sfnum 77 splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> 
> phys_port_name construction:
> $ cat /sys/class/net/eth1/phys_port_name
> c1pf0sf77
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

I have a feeling I nacked this in the past, but can't find the thread.
Was something similar previously posted?
