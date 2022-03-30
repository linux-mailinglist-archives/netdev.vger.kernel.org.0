Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136AA4EC405
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345447AbiC3Mag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349036AbiC3M1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:27:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917E2B5199;
        Wed, 30 Mar 2022 05:12:28 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBQkFs026930;
        Wed, 30 Mar 2022 12:12:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MUFVyysUdoPdz+GQhkqKxHsF7V7+5wuBxTvpNCjkBHQ=;
 b=PDYKOx3wxUFSnsD7R97b2PQoJ5lgQO2Md4e0CiPdZD5viSXuSelavKL/RHn/pev1mZMH
 X+45fRDnJWiU4Qwo/fKAPjsdCoZ/VKMrp/JR1/KOFB2Pb5dEnpCoVy64Jvp1P2uOcbij
 SG9lrdCnuQptxKFW27X/W35PEO1VeyKsE+XlP9Jyzg/jauief+Y4ho64RNXzfY2O6zgY
 2AEFumF8FepOXwntvvmfbjvntAzpC0MRBoMQuSQ/tFcZ5N9L8SzBoHzHd5X22uq+6/JM
 dze6ewWnew8a1HgX6CceO7eXHRpAK+bGgDEAtxNNIOPO97XPzanjTM4fs8hZ1IA/y/gT yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4pbcgxdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:12:02 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UBdOnf017794;
        Wed, 30 Mar 2022 12:12:02 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f4pbcgxcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:12:01 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBwVWc018090;
        Wed, 30 Mar 2022 12:11:59 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hy9rv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:11:59 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCBub229622756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:11:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6F3E4C050;
        Wed, 30 Mar 2022 12:11:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 071474C040;
        Wed, 30 Mar 2022 12:11:56 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.15.152])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Wed, 30 Mar 2022 12:11:55 +0000 (GMT)
Date:   Wed, 30 Mar 2022 14:11:54 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
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
Message-ID: <20220330141154.2ed284f1.pasic@linux.ibm.com>
In-Reply-To: <20220328063723.GA29405@lst.de>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <CAHk-=wiwz+Z2MaP44h086jeniG-OpK3c=FywLsCwXV7Crvadrg@mail.gmail.com>
        <27b5a287-7a33-9a8b-ad6d-04746735fb0c@arm.com>
        <CAHk-=wip7TCD_+2STTepuEZvGMg6wcz+o=kyFUvHjuKziTMixw@mail.gmail.com>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
        <20220324190216.0efa067f.pasic@linux.ibm.com>
        <20220325163204.GB16426@lst.de>
        <87y20x7vaz.fsf@toke.dk>
        <e077b229-c92b-c9a6-3581-61329c4b4a4b@arm.com>
        <CAHk-=wgKF5GfLXyVGDQDifh0MpMccDdmBvJBG3dt2+idCa5DzQ@mail.gmail.com>
        <20220328063723.GA29405@lst.de>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ul5-ww-qQk8Gw2JXhdzZFG5qKYbo_d91
X-Proofpoint-ORIG-GUID: CV3YK3L41YQ9qvUgMuQRgvjVjUTto1XH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 bulkscore=0
 phishscore=0 adultscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Mar 2022 08:37:23 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Fri, Mar 25, 2022 at 11:46:09AM -0700, Linus Torvalds wrote:
> > I think my list of three different sync cases (not just two! It's not
> > just about whether to sync for the CPU or the device, it's also about
> > what direction the data itself is taking) is correct.
> > 
> > But maybe I'm wrong.  
> 
> At the high level you are correct.  It is all about which direction
> the data is taking.  That is the direction argument that all the
> map/unmap/sync call take.  The sync calls then just toggle the ownership.
> You seem to hate that ownership concept, but I don't see how things
> could work without that ownership concept as we're going to be in
> trouble without having that.  And yes, a peek operation could work in
> some cases, but it would have to be at the cache line granularity.
> 
> arch/arc/mm/dma.c has a really good comment how these transfers relate
> to actual cache operations btw>
> 
>  *
>  *          |   map          ==  for_device     |   unmap     ==  for_cpu
>  *          |----------------------------------------------------------------
>  * TO_DEV   |   writeback        writeback      |   none          none
>  * FROM_DEV |   invalidate       invalidate     |   invalidate*	  invalidate*

Very interesting! Does that mean that

memset(buf, 0, size);
dma_map(buf, size, FROM_DEVICE)
device does a partial write
dma_unmap(buf, size, FROM_DEVICE)

may boil down to being the same as without the memset(), because the
effect of the memset() may get thrown away by the cache invalidate?

That is in this scenario we could actually leak the original content of
the buffer if we have a non-dma-coherent cache?

Regards,
Halil 

>  * BIDIR    |   writeback+inv    writeback+inv  |   invalidate    invalidate
>  *
>  *     [*] needed for CPU speculative prefetches

