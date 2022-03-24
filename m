Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135504E6845
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:03:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352454AbiCXSE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236126AbiCXSE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:04:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBC9B6D1C;
        Thu, 24 Mar 2022 11:02:54 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22OHdpdx028652;
        Thu, 24 Mar 2022 18:02:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7N/Uygt+143zP1GtcKOONYQzUeuYDGnbzS8lAEa/ht4=;
 b=orZn5/JJHPLU3aXi7QTpaZ5Czx9MkFWvCy6VS9j1sQFwvDaNk44fFCgOg135hXfxmdZc
 7THzrDaOfxXn3zjwLe/faPAApLdB9K/JfUCKPi3DtfufF4GOob4cliM045llpIvvJUyY
 Rzfrq0x8LbmVXpJ5CAsp3+EVRza2WHBDyzSmRE2u/6OfPXgGd219KcTs/50mvKryuhJt
 GeFdl1tYurjSfaYri8ylmr62AvKiZJIUWlmjKNWp0ouRtR1/QKb6rkyBpmmHlWM1P+Q9
 DEH/ZSOUmCvhhzGqJfOXpiJ21L1W8cSw8v18NJVGcFY3A7fBsLn+WfG/pEF5dwQDkR1y BQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0pxd1pyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:02:24 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22OHhWqv004212;
        Thu, 24 Mar 2022 18:02:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f0pxd1pxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:02:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22OHxcHC020458;
        Thu, 24 Mar 2022 18:02:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t93dsj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:02:21 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22OHoXog52691430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 17:50:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 456E54C04A;
        Thu, 24 Mar 2022 18:02:19 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC5E4C040;
        Thu, 24 Mar 2022 18:02:18 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.111])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 24 Mar 2022 18:02:18 +0000 (GMT)
Date:   Thu, 24 Mar 2022 19:02:16 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4?= =?UTF-8?B?cmdlbnNlbg==?= 
        <toke@toke.dk>, Kalle Valo <kvalo@kernel.org>,
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
Message-ID: <20220324190216.0efa067f.pasic@linux.ibm.com>
In-Reply-To: <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
        <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
        <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2MudIYovaPOAUEbTqagMNrUaYICtVj4D
X-Proofpoint-ORIG-GUID: 7Gru2c9X8jDDAUwXo23TBQWTusNqnneh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_06,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 clxscore=1011 impostorscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Mar 2022 20:54:08 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> On 2022-03-23 19:16, Linus Torvalds wrote:
> > On Wed, Mar 23, 2022 at 12:06 PM Robin Murphy <robin.murphy@arm.com> wrote:  
> >>
> >> On 2022-03-23 17:27, Linus Torvalds wrote:  
> >>>
> >>> I'm assuming that the ath9k issue is that it gives DMA mapping a big
> >>> enough area to handle any possible packet size, and just expects -
> >>> quite reasonably - smaller packets to only fill the part they need.
> >>>
> >>> Which that "info leak" patch obviously breaks entirely.  
> >>
> >> Except that's the exact case which the new patch is addressing  
> > 
> > Not "addressing". Breaking.
> > 
> > Which is why it will almost certainly get reverted.
> > 
> > Not doing DMA to the whole area seems to be quite the sane thing to do
> > for things like network packets, and overwriting the part that didn't
> > get DMA'd with zeroes seems to be exactly the wrong thing here.
> > 
> > So the SG_IO - and other random untrusted block command sources - data
> > leak will almost certainly have to be addressed differently. Possibly
> > by simply allocating the area with GFP_ZERO to begin with.  
> 
> Er, the point of the block layer case is that whole area *is* zeroed to 
> begin with, and a latent memory corruption problem in SWIOTLB itself 
> replaces those zeros with random other kernel data unexpectedly. Let me 
> try illustrating some sequences for clarity...
> 
> Expected behaviour/without SWIOTLB:
>                               Memory
> ---------------------------------------------------
> start                        12345678
> dma_map(DMA_FROM_DEVICE)      no-op
> device writes partial data   12ABC678 <- ABC
> dma_unmap(DMA_FROM_DEVICE)   12ABC678
> 
> 
> SWIOTLB previously:
>                               Memory      Bounce buffer
> ---------------------------------------------------
> start                        12345678    xxxxxxxx
> dma_map(DMA_FROM_DEVICE)             no-op
> device writes partial data   12345678    xxABCxxx <- ABC
> dma_unmap(DMA_FROM_DEVICE)   xxABCxxx <- xxABCxxx
> 
> 
> SWIOTLB Now:
>                               Memory      Bounce buffer
> ---------------------------------------------------
> start                        12345678    xxxxxxxx
> dma_map(DMA_FROM_DEVICE)     12345678 -> 12345678
> device writes partial data   12345678    12ABC678 <- ABC
> dma_unmap(DMA_FROM_DEVICE)   12ABC678 <- 12ABC678
> 
> 
> Now, sure we can prevent any actual information leakage by initialising 
> the bounce buffer slot with zeros, but then we're just corrupting the 
> not-written-to parts of the mapping with zeros instead of anyone else's 
> old data. That's still fundamentally not OK. The only thing SWIOTLB can 
> do to be correct is treat DMA_FROM_DEVICE as a read-modify-write of the 
> entire mapping, because it has no way to know how much of it is actually 
> going to be modified.
> 

Very nice explanation! Thanks!

> I'll admit I still never quite grasped the reason for also adding the 
> override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I 
> think by that point we were increasingly tired and confused and starting 
> to second-guess ourselves (well, I was, at least).

I raised the question, do we need to do the same for
swiotlb_sync_single_for_device(). Did that based on my understanding of the
DMA API documentation. I had the following scenario in mind

SWIOTLB without the snyc_single:
                                  Memory      Bounce buffer      Owner
--------------------------------------------------------------------------
start                             12345678    xxxxxxxx             C
dma_map(DMA_FROM_DEVICE)          12345678 -> 12345678             C->D
device writes partial data        12345678    12ABC678 <- ABC      D
sync_for_cpu(DMA_FROM_DEVICE)     12ABC678 <- 12ABC678             D->C
cpu modifies buffer               66666666    12ABC678             C
sync_for_device(DMA_FROM_DEVICE)  66666666    12ABC678             C->D
device writes partial data        66666666    1EFGC678 <-EFG       D
dma_unmap(DMA_FROM_DEVICE)        1EFGC678 <- 1EFGC678             D->C

Legend: in Owner column C stands for cpu and D for device.

Without swiotlb, I believe we should have arrived at 6EFG6666. To get the
same result, IMHO, we need to do a sync in sync_for_device().
And aa6f8dcbab47 is an imperfect solution to that (because of size).


> I don't think it's 
> wrong per se, but as I said I do think it can bite anyone who's been 
> doing dma_sync_*() wrong but getting away with it until now. 

I fully agree.

> If 
> ddbd89deb7d3 alone turns out to work OK then I'd be inclined to try a 
> partial revert of just that one hunk.
>

I'm not against being pragmatic and doing the partial revert. But as
explained above, I do believe for correctness of swiotlb we ultimately
do need that change. So if the revert is the short term solution,
what should be our mid-term road-map?

Regards,
Halil
 
> Thanks,
> Robin.

