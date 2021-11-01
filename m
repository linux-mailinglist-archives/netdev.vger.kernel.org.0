Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF74422FE
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhKAWFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhKAWFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 18:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEE960F56;
        Mon,  1 Nov 2021 22:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635804161;
        bh=ciS+ilIF7yMFwyhEs1ZpmE/q/9l0uKJKO6+kp85h2kE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=lbvF6YjOJTaYXhvJ/dEalUHJ7MdGGjg31PoZqhBc4pA4WBP2hqLRduDXVKtbXQzR/
         GlY/7TVsVjfx8L9VHaqm5rXYQUcj7c3mT9G0hT0azedT1EdIi4tjwIiD8dw09rXT+3
         t/JjwOd8cNHDxpn2dVxd21JIPIF7/gujvNId0bexc1+2lX65XQ7zOuXvzHxDqLy6GP
         Ex4B0nmLK1l/+9dK4HcEJwBSNlIEFyLDrnxB0/IJh8Wre4TJgY1WW4WqiILk4saGQw
         qMEzroPMwkAjZFYeHkl50TqbNWL+O6+zdm+r9N+fXCWL/ZvdPnniriTfJLMMK/5sKk
         MMh0KA8dO/Ilw==
Date:   Mon, 1 Nov 2021 17:02:39 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
Message-ID: <20211101220239.GA554641@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030135348.61364-8-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 09:53:47PM +0800, Dongdong Liu wrote:
> 10-Bit Tag capability, introduced in PCIe-4.0 increases the total Tag
> field size from 8 bits to 10 bits.
> 
> PCIe spec 5.0 r1.0 section 2.2.6.2 "Considerations for Implementing
> 10-Bit Tag Capabilities" Implementation Note:
> 
>   For platforms where the RC supports 10-Bit Tag Completer capability,
>   it is highly recommended for platform firmware or operating software
>   that configures PCIe hierarchies to Set the 10-Bit Tag Requester Enable
>   bit automatically in Endpoints with 10-Bit Tag Requester capability.
>   This enables the important class of 10-Bit Tag capable adapters that
>   send Memory Read Requests only to host memory.
> 
> It's safe to enable 10-bit tags for all devices below a Root Port that
> supports them. Switches that lack 10-Bit Tag Completer capability are
> still able to forward NPRs and Completions carrying 10-Bit Tags correctly,
> since the two new Tag bits are in TLP Header bits that were formerly
> Reserved.

Side note: the reason we want to do this to increase performance by
allowing more outstanding requests.  Do you have any benchmarking that
we can mention here to show that this is actually a benefit?  I don't
doubt that it is, but I assume you've measured it and it would be nice
to advertise it.

Bjorn
