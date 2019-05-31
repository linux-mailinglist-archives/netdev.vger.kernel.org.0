Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227CA31355
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfEaRDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:03:37 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:54924 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfEaRDh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:03:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00600A78;
        Fri, 31 May 2019 10:03:37 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B94C3F59C;
        Fri, 31 May 2019 10:03:32 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] Prerequisites for NXP LS104xA SMMU enablement
To:     Christoph Hellwig <hch@infradead.org>,
        David Miller <davem@davemloft.net>
Cc:     madalin.bucur@nxp.com, netdev@vger.kernel.org, roy.pledge@nxp.com,
        linux-kernel@vger.kernel.org, leoyang.li@nxp.com,
        Joakim.Tjernlund@infinera.com, iommu@lists.linux-foundation.org,
        camelia.groza@nxp.com, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
References: <20190530141951.6704-1-laurentiu.tudor@nxp.com>
 <20190530.150844.1826796344374758568.davem@davemloft.net>
 <20190531163350.GB8708@infradead.org>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <37406608-df48-c7a0-6975-4b4ad408ba36@arm.com>
Date:   Fri, 31 May 2019 18:03:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531163350.GB8708@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/05/2019 17:33, Christoph Hellwig wrote:
> On Thu, May 30, 2019 at 03:08:44PM -0700, David Miller wrote:
>> From: laurentiu.tudor@nxp.com
>> Date: Thu, 30 May 2019 17:19:45 +0300
>>
>>> Depends on this pull request:
>>>
>>>   http://lists.infradead.org/pipermail/linux-arm-kernel/2019-May/653554.html
>>
>> I'm not sure how you want me to handle this.
> 
> The thing needs to be completely redone as it abuses parts of the
> iommu API in a completely unacceptable way.

`git grep iommu_iova_to_phys drivers/{crypto,gpu,net}`

:(

I guess one alternative is for the offending drivers to maintain their 
own lookup tables of mapped DMA addresses - I think at least some of 
these things allow storing some kind of token in a descriptor, which 
even if it's not big enough for a virtual address might be sufficient 
for an index.

Robin.
