Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A46034AF69
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 20:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCZTg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 15:36:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZTge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 15:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4A4619C9;
        Fri, 26 Mar 2021 19:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616787393;
        bh=WKtHSyYs4uA1sawyAcaD/5Bn+rSuEjSC1yMpBw9B3qY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=hMuedBKjqktedS+VVHHct+ScCr1GZOL4byGSIF4WHQdgvv6beXDQzf1sEyE43Q+L8
         3zk8JjV8qI1XxMmQ9y7tsOEqR/pjdk1A0ssb0rXnJrIQUNFNO/MNs4uHgTGRBmYlq2
         xPKmOdzdtbHGiD+CwVkBzUW+cMohV/cCCVFOU7pkybntHUUZ+eWIHKDY6vo7ANzuVl
         i3uE75hBhwswe430bQHBrHLD1qO+pdcbhN3qNpVYpvbZdtl1jB+o2hY18uhHesmN37
         Mk7JnU8UZfmVUdAmoOaZ7JUQKN1czp9xzQGaHsAt/yPgvV2unbcWMXskfE9tWnyhqC
         d7LvXW7dkyq0g==
Date:   Fri, 26 Mar 2021 14:36:31 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Keith Busch <kbusch@kernel.org>,
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
Message-ID: <20210326193631.GA902426@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UcXwNKDSP2ciEjM2AWj2xOZwBxkPCdzkUqDKAMtvTTKPg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:50:44AM -0700, Alexander Duyck wrote:

> I almost wonder if it wouldn't make sense to just partition this up to
> handle flexible resources in the future. Maybe something like having
> the directory setup such that you have "sriov_resources/msix/" and
> then you could have individual files with one for the total and the
> rest with the VF BDF naming scheme. Then if we have to, we could add
> other subdirectories in the future to handle things like queues in the
> future.

Subdirectories would be nice, but Greg KH said earlier in a different
context that there's an issue with them [1].  He went on to say tools
like udev would miss uevents for the subdirs [2].

I don't know whether that's really a problem in this case -- it
doesn't seem like we would care about uevents for files that do MSI-X
vector assignment.

[1] https://lore.kernel.org/linux-pci/20191121211017.GA854512@kroah.com/
[2] https://lore.kernel.org/linux-pci/20191124170207.GA2267252@kroah.com/
