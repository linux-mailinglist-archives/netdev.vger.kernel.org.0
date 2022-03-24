Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA554E68B6
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352663AbiCXSeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238496AbiCXSeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:34:17 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3554B7151;
        Thu, 24 Mar 2022 11:32:45 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22OGIMG7018966;
        Thu, 24 Mar 2022 18:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QPEoHxcEwKvYGqD5wCoP7vHQWU9iiR1gyHKaskx0ZaY=;
 b=YDBpcmCRe4ki6BgB0SzAPfHDpOgPtoKSUOAJ9H6C/9pX+LdL4n4BkLFoH63IckXnstJs
 NdRVabkXq6ZjY8MAGiNTH9gubWNuk5juaAZCsPKK/Fd0ld/mQxhtZziEWROez1mKQrxW
 bFZIf7hmf8bwtYZ4yZa/rpa82GBqUdi4rPE+KwqXoXYWmwipmv0u9lmQSSjiTPaYRdOI
 VcU/xsKboRIw0dBPQjCQ4PeM2FwRQU0a51BljHE/Ky1j0TqZMP6T9U148McERsplQV73
 0EUyJAxe190C98PHRB8DTNBgKRUMBNt5wTQqschIecSpuDDeUYQsArLo1ob2wAeP6s6k Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kawf7yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:32:24 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22OHq0IS007551;
        Thu, 24 Mar 2022 18:32:23 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f0kawf7y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:32:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22OIKRCQ015319;
        Thu, 24 Mar 2022 18:32:21 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 3ew6t8sta4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Mar 2022 18:32:21 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22OIWJah41681174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Mar 2022 18:32:19 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F2F6A405B;
        Thu, 24 Mar 2022 18:32:19 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35D4DA4054;
        Thu, 24 Mar 2022 18:32:18 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.63.111])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu, 24 Mar 2022 18:32:18 +0000 (GMT)
Date:   Thu, 24 Mar 2022 19:31:58 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Christoph Hellwig <hch@lst.de>, Maxime Bizon <mbizon@freebox.fr>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20220324193158.5fcae106.pasic@linux.ibm.com>
In-Reply-To: <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
References: <1812355.tdWV9SEqCh@natalenko.name>
        <f88ca616-96d1-82dc-1bc8-b17480e937dd@arm.com>
        <20220324055732.GB12078@lst.de>
        <4386660.LvFx2qVVIh@natalenko.name>
        <81ffc753-72aa-6327-b87b-3f11915f2549@arm.com>
        <878rsza0ih.fsf@toke.dk>
        <4be26f5d8725cdb016c6fdd9d05cfeb69cdd9e09.camel@freebox.fr>
        <20220324163132.GB26098@lst.de>
        <d8a1cbf4-a521-78ec-1560-28d855e0913e@arm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oKSb7ZJ3AqHPRcTREuBg4BsuIsetEW2S
X-Proofpoint-GUID: DxCDOKV1iW1_bko4dmsq5AdF-oH4bAFl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-24_06,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 phishscore=0 lowpriorityscore=0
 impostorscore=0 clxscore=1011 spamscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203240101
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 16:52:31 +0000
Robin Murphy <robin.murphy@arm.com> wrote:

> > Creating a new mapping for the same buffer before unmapping the
> > previous one does looks rather bogus.  But it does not fit the
> > pattern where revering the sync_single changes make the driver
> > work again.  
> 
> OK, you made me look :)
> 
> Now that it's obvious what to look for, I can only conclude that during 
> the stanza in ath_edma_get_buffers(), the device is still writing to the 
> buffer while ownership has been transferred to the CPU, and whatever got 
> written while ath9k_hw_process_rxdesc_edma() was running then gets wiped 
> out by the subsequent sync_for_device, which currently resets the 
> SWIOTLB slot to the state that sync_for_cpu copied out. By the letter of 
> the DMA API that's not allowed, but on the other hand I'm not sure if we 
> even have a good idiom for "I can't tell if the device has finished with 
> this buffer or not unless I look at it" :/

I agree with your analysis. Especially with the latter part (were you
state that we don't have a good idiom for that use case). 

I believe, a stronger statement is also true: it is fundamentally
impossible to accommodate use cases where the device and the cpu need
concurrent access to a dma buffer, if the dma buffer isn't in dma
coherent memory.

If the dma buffer is in dma coherent memory, and we don't need swiotlb,
then we don't need the dma_sync functionality. 

Specifically for swiotlb, if the swiotlb buffer is in dma coherent
memory, the driver could peek the swiotlb buffer, but I have no idea if
we can provide a remotely sane API for that. The point is the device
would have peek not via a pointer to the original buffer, but get
suitable pointer to the bounce buffer, which would be probably be
considered valid, as long as the mapping is valid. Honestly IMHO quite
ugly but I see no other way. 

Regards,
Halil
