Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6205274A47
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 22:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIVUoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 16:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbgIVUoE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 16:44:04 -0400
Received: from localhost (lfbn-ncy-1-588-162.w81-51.abo.wanadoo.fr [81.51.203.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 713742220D;
        Tue, 22 Sep 2020 20:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600807443;
        bh=o/A+74sXpvNL4tx92j94WhBZbCGLWsBUOQCxdXNtXtI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RsG9FO4Tn1qmEAYSZiAQdWycz+XJr7+Km3JimdrKx+1eeq4nRkdMnFOQS0YmIQEzZ
         klOSRI+FbarzK3AG2suYbSyDtQrmq/PUbxwitW6QK5Gt0hZF+KWCOJChoU1N4JEfQz
         KxFRtROaCRNiFlBKr8VPTr2uOqIdKqB9Kaz0n/sk=
Date:   Tue, 22 Sep 2020 22:44:01 +0200
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     bhelgaas@google.com, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, mtosatti@redhat.com,
        sassmann@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
Subject: Re: [RFC][Patch v1 2/3] i40e: limit msix vectors based on
 housekeeping CPUs
Message-ID: <20200922204400.GC5217@lenoir>
References: <20200909150818.313699-1-nitesh@redhat.com>
 <20200909150818.313699-3-nitesh@redhat.com>
 <20200917112359.00006e10@intel.com>
 <20200921225834.GA30521@lenoir>
 <65513ee8-4678-1f96-1850-0e13dbf1810c@redhat.com>
 <20200922095440.GA5217@lenoir>
 <1b7fba6f-85c3-50d6-a951-78db1ccfd04a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b7fba6f-85c3-50d6-a951-78db1ccfd04a@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 09:34:02AM -0400, Nitesh Narayan Lal wrote:
> On 9/22/20 5:54 AM, Frederic Weisbecker wrote:
> > But I don't also want to push toward a complicated solution to handle CPU hotplug
> > if there is no actual problem to solve there.
> 
> Sure, even I am not particularly sure about the hotplug scenarios.

Surely when isolation is something that will be configurable through
cpuset, it will become interesting. For now it's probably not worth
adding hundreds lines of code if nobody steps into such issue yet.

What is probably more worthy for now is some piece of code to consolidate
the allocation of those MSI vectors on top of the number of housekeeping
CPUs.

Thanks.
