Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012384BDF0A
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377158AbiBUN6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:58:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377152AbiBUN63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:58:29 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E06A1A39E;
        Mon, 21 Feb 2022 05:58:06 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21LCGupa011881;
        Mon, 21 Feb 2022 13:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=+/Sdd0T0flOre6aAE7sMaRWQ0Fp35SADwUsJ5fcZNfE=;
 b=Dk6XpWhx6EDl25pL078QHKV10PPC/kJvmENS+c+Lmv8981SNaDYzn3j1GB99C5vaQwqY
 j3iUDuyg1yTrMF/VaV5tNh8hheFEqcvxA8weXpjYAmbLewlkxm72jyjgPJSCPp4mj+8v
 ouFDPOrWPSQqAMVvNfdrg0pFWUcnYFiadn3/iBXuAVYfD71bdbjNCKJEm2NaRISETrg7
 iz96N84V7TMFWj0tzYN5GKg0jNNXpdeP7M0uqpb8Aec+T6ZNBLw09Ygp8qA9uwchlPf+
 ICpuP/5/ZlDKEbG6lut3pptBEzxxeaNRKK2ZzadQF6tCVpduayVZVuX7mF3GsIYn4CUU 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eby66xtce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:57:46 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21LDLQ85022605;
        Mon, 21 Feb 2022 13:57:46 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eby66xtbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:57:46 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21LDusB5029508;
        Mon, 21 Feb 2022 13:57:44 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3eaqthu024-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Feb 2022 13:57:44 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21LDvbvC45089050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Feb 2022 13:57:37 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC10DAE053;
        Mon, 21 Feb 2022 13:57:36 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EB904AE051;
        Mon, 21 Feb 2022 13:57:35 +0000 (GMT)
Received: from osiris (unknown [9.145.149.197])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Feb 2022 13:57:35 +0000 (GMT)
Date:   Mon, 21 Feb 2022 14:57:34 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        42.hyeyoo@gmail.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, vbabka@suse.cz, David.Laight@aculab.com,
        david@redhat.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 00/22] Don't use kmalloc() with GFP_DMA
Message-ID: <YhOaTsWUKO0SWsh7@osiris>
References: <20220219005221.634-1-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219005221.634-1-bhe@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -8maixwFZeKZ75OrdKXYZsYgiobSGLaQ
X-Proofpoint-GUID: qIEy-it3kkux3FMToUJumyRqQgXniOfv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-21_07,2022-02-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202210081
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 08:51:59AM +0800, Baoquan He wrote:
> Let's replace it with other ways. This is the first step towards
> removing dma-kmalloc support in kernel (Means that if everyting
> is going well, we can't use kmalloc(GFP_DMA) to allocate buffer in the
> future).
...
> 
> Next, plan to investigate how we should handle places as below. We
> firstly need figure out whether they really need buffer from ZONE_DMA.
> If yes, how to change them with other ways. This need help from
> maintainers, experts from sub-components and code contributors or anyone
> knowing them well. E.g s390 and crypyto, we need guidance and help.
> 
> 1) Kmalloc(GFP_DMA) in s390 platform, under arch/s390 and drivers/s390;

So, s390 partially requires GFP_DMA allocations for memory areas which
are required by the hardware to be below 2GB. There is not necessarily
a device associated when this is required. E.g. some legacy "diagnose"
calls require buffers to be below 2GB.

How should something like this be handled? I'd guess that the
dma_alloc API is not the right thing to use in such cases. Of course
we could say, let's waste memory and use full pages instead, however
I'm not sure this is a good idea.

s390 drivers could probably converted to dma_alloc API, even though
that would cause quite some code churn.

> For this first patch series, thanks to Hyeonggon for helping
> reviewing and great suggestions on patch improving. We will work
> together to continue the next steps of work.
> 
> Any comment, thought, or suggestoin is welcome and appreciated,
> including but not limited to:
> 1) whether we should remove dma-kmalloc support in kernel();

The question is: what would this buy us? As stated above I'd assume
this comes with quite some code churn, so there should be a good
reason to do this.

From this cover letter I only get that there was a problem with kdump
on x86, and this has been fixed. So why this extra effort?

>     3) Drop support for allocating DMA memory from slab allocator
>     (as Christoph Hellwig said) and convert them to use DMA32
>     and see what happens

Can you please clarify what "convert to DMA32" means? I would assume
this does _not_ mean that passing GFP_DMA32 to slab allocator would
work then?

btw. there are actually two kmalloc allocations which pass GFP_DMA32;
I guess this is broken(?):

drivers/hid/intel-ish-hid/ishtp-fw-loader.c:    dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
drivers/media/test-drivers/vivid/vivid-osd.c:   dev->video_vbase = kzalloc(dev->video_buffer_size, GFP_KERNEL | GFP_DMA32);
