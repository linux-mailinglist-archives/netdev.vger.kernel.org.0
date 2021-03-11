Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF5C337D7E
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 20:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCKTQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 14:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229520AbhCKTQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 14:16:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9FC164EF2;
        Thu, 11 Mar 2021 19:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615490165;
        bh=nKWwGiGO6+FXiSkDFk2w1sq4arv1V6JlzszSg8Y7QMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QCTE5HITElA7vkXUnbkkVn25zFyNucD5HJhhQSQBkXcg70gMTjEECxGHBXChGk79g
         Lm3gzOD8AsvbZ5OMcOgcOED9ANxr2HB18+o11euDlZ9yHps5RflUgDPbD7ZC+3djP1
         jJxh/ojDT0tXtzdUK0j5tXQ2K4g24gkCN1+ftlMctQg8R/bFRTPCOdK5P+c+/yjcBf
         UxjoKlGGsp32pXrnTS8W4Je9VbF/S5mFvfDf9pUjuW0W6gRnZrpscoGD8bpcA256MK
         HFqluwZME3NoLOHpQ/+2aM/qE3CDUZMNuMQFbpAVYJ40ikBbQiagHQa5NW2zB+FqgN
         +jzD2jkB1MvBQ==
Date:   Thu, 11 Mar 2021 12:16:02 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210311191602.GA36893@C02WT3WMHTD6>
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311181729.GA2148230@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 12:17:29PM -0600, Bjorn Helgaas wrote:
> On Wed, Mar 10, 2021 at 03:34:01PM -0800, Alexander Duyck wrote:
> > 
> > I'm not so much worried about management software as the fact that
> > this is a vendor specific implementation detail that is shaping how
> > the kernel interfaces are meant to work. Other than the mlx5 I don't
> > know if there are any other vendors really onboard with this sort of
> > solution.
> 
> I know this is currently vendor-specific, but I thought the value
> proposition of dynamic configuration of VFs for different clients
> sounded compelling enough that other vendors would do something
> similar.  But I'm not an SR-IOV guy and have no vendor insight, so
> maybe that's not the case?

NVMe has a similar feature defined by the standard where a PF controller can
dynamically assign MSIx vectors to VFs. The whole thing is managed in user
space with an ioctl, though. I guess we could wire up the driver to handle it
through this sysfs interface too, but I think the protocol specific tooling is
more appropriate for nvme.
