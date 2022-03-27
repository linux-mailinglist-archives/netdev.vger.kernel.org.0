Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02BC4E8549
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 05:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbiC0DvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 23:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiC0DvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 23:51:06 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E678562FD;
        Sat, 26 Mar 2022 20:49:27 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22QNHv8G010618;
        Sun, 27 Mar 2022 03:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=+mfoRcCmFT0JS6zf2eRI3+Pi12WB0EBK81p1P9sU4gs=;
 b=Zbdrt0LI2EXiVBh5IRuPJS9IKj/qkBF+X7vXMaAYHvsx+9s536+scpooWYSil3E+pNf+
 vI98T8t6SBBkOsSdOnO1nqG8abatud3Z8aVbRynfYBK93q3ne50KDOopgDvRr83x1TVj
 3+g4vls3PiElzKU+HENeNpjU2X3wieLEnmxHg6+U9eynM1t6NWnGD5aGvj/kg6OhrXur
 91Wdcs7ceWvkdAbQoSVzjKIpil8d+3/nIJK94k0TkR+FeP5REEcv5CmmD82g0DV5hyRS
 FHp3/IwrQQKvaCs2R6JGTu/GnGkW5EqFy+admvvd9RHAzdW5Qs294jHf2VS7I3ahs6nc NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2ccrjf5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:48:57 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22R3muqC030615;
        Sun, 27 Mar 2022 03:48:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2ccrjf5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:48:56 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22R3mjgQ008417;
        Sun, 27 Mar 2022 03:48:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf99fpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 27 Mar 2022 03:48:53 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22R3mujE45089254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 27 Mar 2022 03:48:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A40D8A404D;
        Sun, 27 Mar 2022 03:48:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B88A0A4040;
        Sun, 27 Mar 2022 03:48:50 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.73.54])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Sun, 27 Mar 2022 03:48:50 +0000 (GMT)
Date:   Sun, 27 Mar 2022 05:48:48 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Maxime Bizon <mbizon@freebox.fr>,
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
Message-ID: <20220327054848.1a545b12.pasic@linux.ibm.com>
In-Reply-To: <CAHk-=whUQCCaQXJt3KUeQ8mtnLeVXEScNXCp+_DYh2SNY7EcEA@mail.gmail.com>
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
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aU2QkfNNjgUjQGcm0JFsF5Yd0bFRyEZx
X-Proofpoint-GUID: ewoGDMbOZ3Cbe29feLOTEoCrihOk2PUz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-27_01,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=739
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203270020
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 12:26:53 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I don't think the dma_sync_single_for_device() is *wrong* per se,
> because the CPU didn't actually do any modifications.
> 
> But yes, I think it's unnecessary - because any later CPU accesses
> would need that dma_sync_single_for_cpu() anyway, which should
> invalidate any stale caches.
> 
> And it clearly doesn't work in a bounce-buffer situation, but honestly
> I don't think a "CPU modified buffers concurrently with DMA" can
> *ever* work in that situation, so I think it's wrong for a bounce
> buffer model to ever do anything in the dma_sync_single_for_device()
> situation.

I agree it CPU modified buffers *concurrently* with DMA can never work,
and I believe the ownership model was conceived to prevent this
situation. But a CPU can modify the buffer *after* DMA has written to
it, while the mapping is still alive. For example one could do one
partial read from the device, *after* the DMA is done,
sync_for_cpu(DMA_FROM_DEVICE), examine, then zero out the entire buffer,
sync_for_device(DMA_FROM_DEVICE), make the device do partial DMA, do
dma_unmap and expect no residue from the fist DMA. That is expect that
the zeroing out was effective.

The point I'm trying to make is: if concurrent is even permitted (it
isn't because of ownership) swiotlb woudn't know if we are dealing with
the *concurrent* case, which is completely bogous, or with the
*sequential* case, which at least in theory could work. And if we don't
do anyting on the sync_for_device(DMA_FROM_DEVICE) we render
that zeroing out the entire buffer form my example ineffective, because
it would not reach the bounce buffer, and on dma_unmap we would overwrite
the original buffer with the content of the bounce buffer.

Regards,
Halil
