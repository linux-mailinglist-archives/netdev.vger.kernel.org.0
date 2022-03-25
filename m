Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87CC4E778E
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 16:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbiCYP2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 11:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376708AbiCYP14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 11:27:56 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72F86CA57;
        Fri, 25 Mar 2022 08:25:40 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PEcQHe018886;
        Fri, 25 Mar 2022 15:25:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=wtZ7yK/0CRnLGQyyfEq04PkrYcuVIqNGBRYNpsmm4LU=;
 b=EK9KlqWRtK9jemIaBWXPSfVTRv7USZwJCT2m7UkMY4Fbqu1mZPPCfOO3KX6LaME2tqtY
 SCJSJ99+VNvyQNplV6DpxQ8ZR6IWEGAAds16W1nmTaf8MqUbsID0FMXHhdGLi5Jses/0
 t9MFw6avPEyLFxSeXEGpjX7V3EtJ2RhHM/n9AgH49GMInB2hLRNZb0kSRe9EDnDYihtq
 16LcTVMK9lmYQLG6vKMqdFQ1h8vYzlN4bZgDET3/Pl1fXf+8A1cr8jP4/aesY+Yy1NnB
 RRmf1dUNIW2zY+kdFDM5Zd7T6okZbG7oohnxKAfHoS0VUC/Czwnuyv+DJKHhKmPuRZhc Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kax5t98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:25:16 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PF4OYI008470;
        Fri, 25 Mar 2022 15:25:16 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kax5t8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:25:16 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PFN9xa018376;
        Fri, 25 Mar 2022 15:25:14 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3ew6ej3kf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 15:25:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PFDNU850856374
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 15:13:23 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB1014C040;
        Fri, 25 Mar 2022 15:25:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B44944C044;
        Fri, 25 Mar 2022 15:25:10 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.85.1])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 25 Mar 2022 15:25:10 +0000 (GMT)
Date:   Fri, 25 Mar 2022 16:25:08 +0100
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
Message-ID: <20220325162508.3273e0db.pasic@linux.ibm.com>
In-Reply-To: <20220324190216.0efa067f.pasic@linux.ibm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
        <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
        <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
        <20220324190216.0efa067f.pasic@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xAmGyw1lgESr16IrNUtiGC-eJnDwcDex
X-Proofpoint-GUID: 71FqG_G0CuPRDUQFTyfziAzEYfbIJLzg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_04,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=899 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 19:02:16 +0100
Halil Pasic <pasic@linux.ibm.com> wrote:

> > I'll admit I still never quite grasped the reason for also adding the 
> > override to swiotlb_sync_single_for_device() in aa6f8dcbab47, but I 
> > think by that point we were increasingly tired and confused and starting 
> > to second-guess ourselves (well, I was, at least).  
> 
> I raised the question, do we need to do the same for
> swiotlb_sync_single_for_device(). Did that based on my understanding of the
> DMA API documentation. I had the following scenario in mind
> 
> SWIOTLB without the snyc_single:
>                                   Memory      Bounce buffer      Owner
> --------------------------------------------------------------------------
> start                             12345678    xxxxxxxx             C
> dma_map(DMA_FROM_DEVICE)          12345678 -> 12345678             C->D
> device writes partial data        12345678    12ABC678 <- ABC      D
> sync_for_cpu(DMA_FROM_DEVICE)     12ABC678 <- 12ABC678             D->C
> cpu modifies buffer               66666666    12ABC678             C
> sync_for_device(DMA_FROM_DEVICE)  66666666    12ABC678             C->D
> device writes partial data        66666666    1EFGC678 <-EFG       D
> dma_unmap(DMA_FROM_DEVICE)        1EFGC678 <- 1EFGC678             D->C
> 
> Legend: in Owner column C stands for cpu and D for device.
> 
> Without swiotlb, I believe we should have arrived at 6EFG6666. To get the
> same result, IMHO, we need to do a sync in sync_for_device().
> And aa6f8dcbab47 is an imperfect solution to that (because of size).
> 

@Robin, Christoph: Do we consider this a valid scenario?

Regards,
Halil
