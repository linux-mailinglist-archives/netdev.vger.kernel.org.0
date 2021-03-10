Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8644D3348AB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhCJUK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:10:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230525AbhCJUKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 15:10:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F17B564F93;
        Wed, 10 Mar 2021 20:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615407045;
        bh=HD9VOBnSGTScWxDQSoGkCML5OLKSaqNVSIokZCpoYlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tDnak1ZVJo+WYG8QcQjzTWALZl8cHkT2vyBdWTTxelJi49bpb4jnBsnLBBy3UBSk3
         dhQ77xG8vFZXBTE79T/c2LTE8QT+U652as09oaK5m7xaVE5/berbfUUGmfs6eo6djN
         D+XaprlqGWzcerDntgG9qGLkwf7tC6yvzqnQPE30eCUyQD8LI4Q5aJmtjjY2X1Ukk5
         ZyGRaZr1bTbQsvwEYmJAP0Nmau/gPYDy0oBlUFll4NffVQbrEAypaCmGAYaEhpxN6k
         DqgrOPdGaD+p+FNmRziOrCzOX+3Pe4fxerGmMnxnRuxoV8veJIPUl3ocu6mo5kWWeH
         ueR1Zb+dnl0eQ==
Date:   Wed, 10 Mar 2021 22:10:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <YEknweta9TXcw1l5@unreal>
References: <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
 <20210310190906.GA2020121@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310190906.GA2020121@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 01:09:06PM -0600, Bjorn Helgaas wrote:
> On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > to the series, because you liked v6 more.
> > >
> > > Thanks
> > >
> > > ---------------------------------------------------------------------------------
> > > Changelog
> > > v7:
> > >  * Rebase on top v5.12-rc1
> > >  * More english fixes
> > >  * Returned to static sysfs creation model as was implemented in v0/v1.

<...>

>   2) Should a VF sysfs file use the PF to implement this?
>
>      Can you elaborate on your idea here?  I guess
>      pci_iov_sysfs_link() makes a "virtfnX" link from the PF to the
>      VF, and you're thinking we could also make a "virtfnX_msix_count"
>      in the PF directory?  That's a really interesting idea.

I want to remind that we are talking about mlx5 devices that support
upto 255 VFs and they indeed are used to their limits. So seeing 255
links of virtfnX_msix_count in the same directory looks too much unpleasant
to me.

Thanks
