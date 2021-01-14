Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5682F6851
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbhANRwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:52:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:39166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbhANRwJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 12:52:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBF3823A34;
        Thu, 14 Jan 2021 17:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610646689;
        bh=uhySbMp0N2pR99EJXI5G1RY9Zc1k9reOUa4yrVzT+ag=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h3E/jRCT3m1iJiN1Kz6d7DF1QdZgJqc+QgsEcfughzAy9X+gGMg0PHRJ1K9Dzg1Mt
         dp5XD8+ouRzp9oNivTeC/LF1DXZkLv5ziQrLT95GfOStvQ77AvBDIvQj5bUJRVQ7Zv
         5lElTwXdO+/zBR5Lmx1Akmqw229AemWGFL7Ymhb+cbgP5N2B5F59mfE0iVIb/gV6gu
         8xXbk6aJcLmYlXffHdKLcZHAvZKcoNlDHOiR7MfAC7Gk4NompKrb4/s0aLVXTiPGKP
         VP4+e2uMZJZV+5sRXa8Zms8Ed+UCtrQ0oNYo5r7arfsCk7/80LPN+EZF2XVuciQ//X
         dY0GOXVQHvFrQ==
Date:   Thu, 14 Jan 2021 09:51:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH mlx5-next v2 0/5] Dynamically assign MSI-X vectors count
Message-ID: <20210114095128.0f388f08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114103140.866141-1-leon@kernel.org>
References: <20210114103140.866141-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 12:31:35 +0200 Leon Romanovsky wrote:
> The number of MSI-X vectors is PCI property visible through lspci, that
> field is read-only and configured by the device.
> 
> The static assignment of an amount of MSI-X vectors doesn't allow utilize
> the newly created VF because it is not known to the device the future load
> and configuration where that VF will be used.
> 
> The VFs are created on the hypervisor and forwarded to the VMs that have
> different properties (for example number of CPUs).
> 
> To overcome the inefficiency in the spread of such MSI-X vectors, we
> allow the kernel to instruct the device with the needed number of such
> vectors, before VF is initialized and bounded to the driver.


Hi Leon!

Looks like you got some missing kdoc here, check out the test in
patchwork so we don't need to worry about this later:

https://patchwork.kernel.org/project/netdevbpf/list/?series=414497
