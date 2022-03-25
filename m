Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690074E7CE8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234318AbiCYXml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 19:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbiCYXmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 19:42:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2CC16E7F0;
        Fri, 25 Mar 2022 16:39:23 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22PMkdNf018946;
        Fri, 25 Mar 2022 23:39:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=IdZP3D0QA8k9y7Imwt2i5Pq8bQyCKZNwmQtGuEEpg9w=;
 b=P/2ixLclO/faqLuPbo+UWXRH1Ltxe1b5/mvBo+13BIa/obCrSn2N9TXtMLrhYbR+9qbo
 nCAowLjCuuIQCJARSwpE9dmrFAGAljvTq4UcIIDuC3Vk4hZZ65Iv4EeD3UR0WNXLOtCg
 lfAxdaaqX4YO5LmSl2HeELX0TA0teWdWS84JoJuZsLJawv7Vx8wNTwNTMRGwGpoSD5yj
 SEkyfGdCirXdoW7h8NprqwHoi5psbTfoLDFGj/e9/plQi1Rwn8+CviCJiCNartnnWNVp
 0f0vp9tOogG0YvOSOiFoDO8XH4i296tiHfk2bBGjrgpks3+12PZUW5U05SErVuI1bxkJ bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kaxdugr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 23:39:01 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22PNOoFX007424;
        Fri, 25 Mar 2022 23:39:01 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kaxdug9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 23:39:01 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22PNcs6x019988;
        Fri, 25 Mar 2022 23:38:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3ew6t9c17u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Mar 2022 23:38:59 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22PNcuwv49545638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Mar 2022 23:38:56 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EB74AE045;
        Fri, 25 Mar 2022 23:38:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9C0EAE053;
        Fri, 25 Mar 2022 23:38:55 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.85.1])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri, 25 Mar 2022 23:38:55 +0000 (GMT)
Date:   Sat, 26 Mar 2022 00:38:53 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     mbizon@freebox.fr, Linus Torvalds <torvalds@linux-foundation.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Netdev <netdev@vger.kernel.org>, Kalle Valo <kvalo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        stable <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        iommu <iommu@lists.linux-foundation.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [REGRESSION] Recent swiotlb DMA_FROM_DEVICE fixes break
 ath9k-based AP
Message-ID: <20220326003853.44c3285c.pasic@linux.ibm.com>
In-Reply-To: <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com>
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
        <cce202fb-5185-aa3e-9e9b-11626192cb49@arm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: srrOjsZQlOzqe3feimddiODLjhlk02mH
X-Proofpoint-GUID: ZMfUbVuSEunOfRMz6u6RyoVVaz6CAvFj
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-25_08,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203250128
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 11:27:41 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> What muddies the waters a bit is that the opposite combination 
> sync_for_cpu(DMA_TO_DEVICE) really *should* always be a no-op, and I for 
> one have already made the case for eliding that in code elsewhere, but 
> it doesn't necessarily hold for the inverse here, hence why I'm not sure 
> there even is a robust common solution for peeking at a live 
> DMA_FROM_DEVICE buffer.

In https://lkml.org/lkml/2022/3/24/739 I also argued, that a robust
common solution for a peeking at a live DMA_FROM_DEVICE buffer is
probably not possible, at least not with the current programming model
as described by Documentation/core-api/dma-api.rst.

Namely AFAIU the programming model is based on exclusive ownership: the
buffer is either owned by the device, which means CPU(s) are not allowed
to *access* it, or it is owned by the CPU(s), and the device is not
allowed to *access* it. Do we agree on this?

Considering what Linus said here https://lkml.org/lkml/2022/3/24/775
I understand that: if the idea that dma_sync_*_for_{cpu,device} always
transfers ownership to the cpu and device respectively is abandoned, 
and we re-define ownership in a sense that only the owner may write,
but non-owner is allowed to read, then it may be possible to make the
scenario under discussion work. 

The scenario in pseudo code:

/* when invoked device might be doing DMA into buf */
rx_buf_complete(buf)
{
	prepare_peek(buf, DMA_FROM_DEVICE);
        if (!is_ready(buf)) {
                /*let device gain the buffer again*/
                peek_done_not_ready(buf, DMA_FROM_DEVICE);
                return false;
        }
	peek_done_ready(buf, DMA_FROM_DEVICE);
	process_buff(buf, DMA_FROM_DEVICE); is
}

IMHO it is pretty obvious, that prepare_peek() has to update the
cpu copy of the data *without* transferring ownership to the CPU. Since
the owner is still the device, it is legit for the device to keep
modifying the buffer via DMA. In case of the swiotlb, we would copy the
content of the bounce buffer to the orig buffer possibly after
invalidating
caches, and for non-swiotlb we would do invalidate caches. So
prepare_peek() could be actually something like,
dma_sync_single_for_cpu(buf, DMA_FROM_DEVICE,
                        DMA_ATTR_NO_OWNERSHIP_TRANSFER)
which would most end up being functionally the same, as without the
flag, since my guess is that the ownership is only tracked in our heads. 

For peek_done_not_ready() there is conceptually nothing to do, because
the device retained ownership. Thus would either have to mandate
peek_done_not_ready() being a nop, or non-existent, (that is
what Toke's patch does in the specific case), or we would have to
mandate that dma_sync_*_for_*() has no side effects under certain. The
former looks simpler to me, especially with swiotlb. But we are also
fine if the cache ain't dirty, because the CPU didn't write (as pointed
out by Linus) and we were to detect that, and avoid flushing a clean
cache, or if we were to track ownership and to avoid flushing caches
because no ownership transfer. But to avoid these bad flushes, at least
for swiotlb, we would either have to track cache ownership, or even
worse track dirtiness (for which we would have to extend the API, and
make the drivers tell us that the cache, i.e. the original buffer got
dirtied).

Since the device has ownership when peek_done_not_ready() is invoked,
we might need to transfer ownership to the CPU in peek_done_ready().
This could again be a dma_sync_for_cpu() with a flag, which when supplied
tells the dma API that no sync (cache invalidate) is needed because the
driver guarantees, that the whole mapping was sufficiently sync-ed by
prepare_peek(). Please notice, that the whole scheme is based on the
driver knowing that the whole DMA is done by examining the buffer, and
it decides based on whatever it sees.

Some of the ongoing discussion seem so ignore this whole ownership biz.
My feeling is: the notion of ownership useful. If both sides end up
modifying (and eventually flushing) we are in trouble IMHO, an ownership
avoids that. But if the conclusion ends up being, that ownership does
not matter, then we should make sure it is purged from the documentation,
because otherwise it will confuse the hell out of people who read
documentations and care about programming models. People like me.

Regards,
Halil
