Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5846E4E853E
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 05:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233693AbiC0DTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 23:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbiC0DTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 23:19:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BB3BE20;
        Sat, 26 Mar 2022 20:17:28 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22QN8uub010694;
        Sun, 27 Mar 2022 03:15:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9DvjLHqiD/x//WFKS/P9jaalSbZ7FCAerDENqv2AuQ0=;
 b=NiQin1hvwsSIDpU4aWiuJkBQoM9mBoLsu06hXu8g/XUzGZ1ufiX/D+SPbZ3pDwb289E1
 Xtcw9aftByVc2M5KvjTeSGI8asAtGmRDV/fmTZ7O/wEmLE13CgdNxzpqbQxWdkWG9syH
 +1dJ789BXbYTzisPI3kwPbVB4WOPrbzdi1rOTLRj+GPE6okvPz2mnyLbvXNwM+3pFBep
 1e7F/bFtHKqL7MXK9OzSvl7Po0e4HGc1F+akev0vF/cLmUlJ9P7JX7RjBLkM4jjd1uyv
 FpmUf4SOt9xUJkGmgopfQXeNE+Uaip9tX6SUwsIdrrJwLHcPy6NyUgIekRsrpTsH/EZx Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8hj6q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:15:20 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22R3FJ3r032085;
        Sun, 27 Mar 2022 03:15:19 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f2c8hj6pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:15:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22R3DEah011173;
        Sun, 27 Mar 2022 03:15:17 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf99eex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:15:17 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22R3FEO535062162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Mar 2022 03:15:14 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AC91911C04C;
        Sun, 27 Mar 2022 03:15:14 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C7AE711C04A;
        Sun, 27 Mar 2022 03:15:13 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.54])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 27 Mar 2022 03:15:13 +0000 (GMT)
Date:   Sun, 27 Mar 2022 05:15:02 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        iommu <iommu@lists.linux-foundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220327051502.63fde20a.pasic@linux.ibm.com>
In-Reply-To: <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
        <20220324055732.GB12078@lst.de>
        <4386660.LvFx2qVVIh@natalenko.name>
        <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
        <878rsza0ih.fsf@toke.dk>
        <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
        <20220324163132.GB26098@lst.de>
        <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
        <871qyr9t4e.fsf@toke.dk>
        <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
        <31434708dcad126a8334c99ee056dcce93e507f1.camel@freebox.fr>
        <CAHk-=wippum+MksdY7ixMfa3i1sZ+nxYPWLLpVMNyXCgmiHbBQ@mail.gmail.com>
        <298f4f9ccad7c3308d3a1fd8b4b4740571305204.camel@sipsolutions.net>
        <CAHk-=whXAan2ExANMryPSFaBWeyzikPi+fPUseMoVhQAxR7cEA@mail.gmail.com>
        <e42e4c8bf35b62c671ec20ec6c21a43216e7daa6.camel@sipsolutions.net>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 5AO0CU8XzxzmSZ7csSQlI7JE3Lm55pAU
X-Proofpoint-GUID: S5VeM4OLVvWlIXwACDa2AF4Dq87pnNg0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-27_01,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 clxscore=1011
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203270018
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 22:13:08 +0100
Johannes Berg <johannes@sipsolutions.net> wrote:

> > > Then, however, we need to define what happens if you pass
> > > DMA_BIDIRECTIONAL to the sync_for_cpu() and sync_for_device() functions,
> > > which adds two more cases? Or maybe we eventually just think that's not
> > > valid at all, since you have to specify how you're (currently?) using
> > > the buffer, which can't be DMA_BIDIRECTIONAL?  
> > 
> > Ugh. Do we actually have cases that do it?  
> 
> Yes, a few.
> 
> > That sounds really odd for
> > a "sync" operation. It sounds very reasonable for _allocating_ DMA,
> > but for syncing I'm left scratching my head what the semantics would
> > be.  
> 
> I agree.
> 
> > But yes, if we do and people come up with semantics for it, those
> > semantics should be clearly documented.  
> 
> I'm not sure? I'm wondering if this isn't just because - like me
> initially - people misunderstood the direction argument, or didn't
> understand it well enough, and then just passed the same value as for
> the map()/unmap()?

I don't think you misunderstood the direction argument and its usage. I
didn't finish thinking about the proposal of Linus, I'm pretty confident
about my understanding of the current semantics of the direction.
According to the documentation, you do have to pass in the very same
direction, that was specified when the mapping was created. A qoute
from the documentation.

"""
        void
        dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
                                size_t size,
                                enum dma_data_direction direction)

        void
        dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
                                   size_t size,
                                   enum dma_data_direction direction)

        void
        dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg,
                            int nents,
                            enum dma_data_direction direction)

        void
        dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
                               int nents,
                               enum dma_data_direction direction)

Synchronise a single contiguous or scatter/gather mapping for the CPU
and device. With the sync_sg API, all the parameters must be the same
as those passed into the single mapping API. With the sync_single API,
you can use dma_handle and size parameters that aren't identical to
those passed into the single mapping API to do a partial sync.
"""
(Documentation/core-api/dma-api.rst)

The key here is "sync_sg API, all the parameters must be the same
as those passed into the single mapping API", but I have to admit,
I don't understand the *single* in here. The intended meaning of the
last sentence is that one can do partial sync by choose 
dma_hande_sync, size_sync such that dma_handle_mapping <= dma_handle_sync
< dma_handle_mapping + size_mapping and dma_handle_sync + size_sync <=
dma_handle_mapping + size_mapping. But the direction has to remain the
same.


BTW, the current documented definition of the direction is about the
data transfer direction between memory and the device, and how the CPU
is interacting with the memory is not in scope. A quote form the
documentation.

"""
======================= =============================================
DMA_NONE                no direction (used for debugging)
DMA_TO_DEVICE           data is going from the memory to the device
DMA_FROM_DEVICE         data is coming from the device to the memory
DMA_BIDIRECTIONAL       direction isn't known
======================= =============================================
"""
(Documentation/core-api/dma-api.rst)

My feeling is, that re-defining the dma direction is not a good idea. But
I don't think my opinion has much weight here.

@Christoph, Robin: What do you think?

Regards,
Halil
