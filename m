Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF98434AD59
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 18:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhCZR31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 13:29:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230131AbhCZR3J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 13:29:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C400619AB;
        Fri, 26 Mar 2021 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616779748;
        bh=M6OUrfDMrzLAMPDOWMnIeoUbhgVLY1VEIZq6xDgF1yk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AXwYFBM/wqb3s905KFf88a1XGQker0PBsjfRkO93sFOJiSmPvsbXd3GH71T/zyKcw
         pZrjn1hz92wqdWwZCd9vDId9vew2ZgWjoH5xODVDyTFdDR+zoTgE3KGpUMLj+krM9Y
         4ERqeyDTOhgyQudmOu8xxb4s5xAttyje/LlfIMxvAmV/YrOfL2+6isMMz+GtuufVtU
         p3kVUY4UsY3MO+XkCJZzTuKHBJWsaCRcsaYC8hDQa/ROPp5HOX2EcqilnW+qgO/ocA
         NkQB1Bb7kbwNKYE2tVtqrfJqrVH3dH9y8A4lEQrf9mmkutPL/SMF/0mTiP3Bu2sQ28
         cRngWzTnU1Ovw==
Date:   Sat, 27 Mar 2021 02:29:00 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210326172900.GA4611@redsun51.ssa.fujisawa.hgst.com>
References: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
 <20210326170831.GA890834@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326170831.GA890834@bjorn-Precision-5520>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 12:08:31PM -0500, Bjorn Helgaas wrote:
> I also want to resurrect your idea of associating
> "sriov_vf_msix_count" with the PF instead of the VF.  I really like
> that idea, and it better reflects the way both mlx5 and NVMe work.

That is a better match for nvme: we can assign resources to VFs with
the PF's "VF Enable" set to '0', so configuring VFs without requiring
them be enumerated in sysfs is a plus. The VFs would also implicitly be
in the "offline" state for that condition and able to accept these
requests.
