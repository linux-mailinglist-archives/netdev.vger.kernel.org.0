Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A977831409
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfEaRpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:45:05 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:55710 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfEaRpF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:45:05 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4D53A78;
        Fri, 31 May 2019 10:45:04 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DEB233F59C;
        Fri, 31 May 2019 10:45:01 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
To:     Christoph Hellwig <hch@infradead.org>
Cc:     David Miller <davem@davemloft.net>, madalin.bucur@nxp.com,
        netdev@vger.kernel.org, roy.pledge@nxp.com,
        linux-kernel@vger.kernel.org, leoyang.li@nxp.com,
        Joakim.Tjernlund@infinera.com, iommu@lists.linux-foundation.org,
        camelia.groza@nxp.com, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <20190530.150844.1826796344374758568.davem@davemloft.net>
 <20190531163350.GB8708@infradead.org>
 <37406608-df48-c7a0-6975-4b4ad408ba36@arm.com>
 <20190531170804.GA12211@infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <1b81c168-f5e0-f86a-f90e-22e8c3f2a602@arm.com>
Date:   Fri, 31 May 2019 18:45:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531170804.GA12211@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2019 18:08, Christoph Hellwig wrote:
> On Fri, May 31, 2019 at 06:03:30PM +0100, Robin Murphy wrote:
>>> The thing needs to be completely redone as it abuses parts of the
>>> iommu API in a completely unacceptable way.
>>
>> `git grep iommu_iova_to_phys drivers/{crypto,gpu,net}`
>>
>> :(
>>
>> I guess one alternative is for the offending drivers to maintain their own
>> lookup tables of mapped DMA addresses - I think at least some of these
>> things allow storing some kind of token in a descriptor, which even if it's
>> not big enough for a virtual address might be sufficient for an index.
> 
> Well, we'll at least need DMA API wrappers that work on the dma addr
> only and hide this madness underneath.  And then tell if an given device
> supports this and fail the probe otherwise.

Bleh, I'm certainly not keen on formalising any kind of 
dma_to_phys()/dma_to_virt() interface for this. Or are you just 
proposing something like dma_unmap_sorry_sir_the_dog_ate_my_homework() 
for drivers which have 'lost' the original VA they mapped?

Robin.
