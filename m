Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1373A3206C3
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 20:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBTTGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 14:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:47228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBTTGm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Feb 2021 14:06:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DC06023B;
        Sat, 20 Feb 2021 19:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613847962;
        bh=aksYvv/pbvkBrCrX+SCT6HQfuRBM+wqAG8UH2b1d1bE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=dxnnMLpH67twloA+/vmCSkcKexWZPI8hyNLC3n3FSAcEcTPsjFWLdYkyW17JDhuhg
         U/qmm8NswdgNacbtUpK/ceW+DlECvmGUjb+serwKwAdcyB3k1dnapq03faEJCUxu9u
         boA8+aj79+4t0Gye3lKskgWbXWHh4AH3w0as0av+Zfx1eNmDdq9FQxd2HYhPkcXuyF
         EQV6mLTRSbQSP2gC1dNTUhR85MZy3pApQv1MKI7hKUHnjbxt8Q3shs9xHEuDmQNb9c
         3hJvFpoazUBznWx3vzMGsmSJrUZAcxtGB/3OJnPTlSXxrPIDXVw82TklvOQwQDIE4J
         9pj7D003swsAg==
Date:   Sat, 20 Feb 2021 13:06:00 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
Subject: Re: [PATCH mlx5-next v6 1/4] PCI: Add sysfs callback to allow MSI-X
 table size change of SR-IOV VFs
Message-ID: <20210220190600.GA1260870@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC90wkwk/CdgcYY6@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 19, 2021 at 09:20:18AM +0100, Greg Kroah-Hartman wrote:

> Ok, can you step back and try to explain what problem you are trying to
> solve first, before getting bogged down in odd details?  I find it
> highly unlikely that this is something "unique", but I could be wrong as
> I do not understand what you are wanting to do here at all.

We want to add two new sysfs files:

  sriov_vf_total_msix, for PF devices
  sriov_vf_msix_count, for VF devices associated with the PF

AFAICT it is *acceptable* if they are both present always.  But it
would be *ideal* if they were only present when a driver that
implements the ->sriov_get_vf_total_msix() callback is bound to the
PF.
