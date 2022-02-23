Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56174C1C0D
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 20:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242642AbiBWTTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 14:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiBWTTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 14:19:13 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2028045ADC;
        Wed, 23 Feb 2022 11:18:45 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NJ9PeK008330;
        Wed, 23 Feb 2022 19:18:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=4M7keEVwA9K+g1bmFw59BD8lXOkD/TAviruIu4QgsWM=;
 b=A4jSVxJ8psUNkRPXXpGO2BUHOR470CByPj2dqKa2gE03i47W5Lkubta7w3kR4ptQZGaJ
 IL6YR8QcCmQZgAuFHL8CuVBRP2445uiyVpcW+MZS2tZ1cuRxr2Qoqfz7AV1+0funeIVc
 e0xgHF3MbH7ApK9ic0xp7UIKWogRZUj08EMyqamPM3beFX8B2VWVZ0xT6PjGoishFo1f
 9NuQO9QK39RGceWeiBQpkNYh3YcP/4wZ25ihoJXrhu9/kfzCj2lEJnpdu6LbPfI6k704
 fQ5x38+brQOPcMMQVOvIdD/jp6LSNWmOy2oSW6XdpJtOlfctVyhTTUTtxKLCQhiKIfbO 3w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6t1mvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 19:18:18 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NJHVXY015629;
        Wed, 23 Feb 2022 19:18:17 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6t1muq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 19:18:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NJBlaT029428;
        Wed, 23 Feb 2022 19:18:14 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3ear69c9cr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 19:18:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NJIB4t26018054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 19:18:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42DA3AE04D;
        Wed, 23 Feb 2022 19:18:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 47C52AE051;
        Wed, 23 Feb 2022 19:18:10 +0000 (GMT)
Received: from osiris (unknown [9.145.31.42])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 23 Feb 2022 19:18:10 +0000 (GMT)
Date:   Wed, 23 Feb 2022 20:18:08 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, cl@linux.com,
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
Message-ID: <YhaIcPmc8qi1zmnj@osiris>
References: <20220219005221.634-1-bhe@redhat.com>
 <YhOaTsWUKO0SWsh7@osiris>
 <20220222084422.GA6139@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222084422.GA6139@lst.de>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TJSaBEB9Lulpk4sdWf3aymM3sOHqNnmS
X-Proofpoint-ORIG-GUID: RQrgHuEksbIzwLY-XstVcce5JZQWh0wb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=632
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202230108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 09:44:22AM +0100, Christoph Hellwig wrote:
> On Mon, Feb 21, 2022 at 02:57:34PM +0100, Heiko Carstens wrote:
> > > 1) Kmalloc(GFP_DMA) in s390 platform, under arch/s390 and drivers/s390;
> > 
> > So, s390 partially requires GFP_DMA allocations for memory areas which
> > are required by the hardware to be below 2GB. There is not necessarily
> > a device associated when this is required. E.g. some legacy "diagnose"
> > calls require buffers to be below 2GB.
> > 
> > How should something like this be handled? I'd guess that the
> > dma_alloc API is not the right thing to use in such cases. Of course
> > we could say, let's waste memory and use full pages instead, however
> > I'm not sure this is a good idea.
> 
> Yeah, I don't think the DMA API is the right thing for that.  This
> is one of the very rare cases where a raw allocation makes sense.
> 
> That being said being able to drop kmalloc support for GFP_DMA would
> be really useful. How much memory would we waste if switching to the
> page allocator?

At a first glance this would not waste much memory, since most callers
seem to allocate such memory pieces only temporarily.

> > The question is: what would this buy us? As stated above I'd assume
> > this comes with quite some code churn, so there should be a good
> > reason to do this.
> 
> There is two steps here.  One is to remove GFP_DMA support from
> kmalloc, which would help to cleanup the slab allocator(s) very nicely,
> as at that point it can stop to be zone aware entirely.

Well, looking at slub.c it looks like there is only a very minimal
maintenance burden for GPF_DMA/GFP_DMA32 support.

> The long term goal is to remove ZONE_DMA entirely at least for
> architectures that only use the small 16MB ISA-style one.  It can
> then be replaced with for example a CMA area and fall into a movable
> zone.  I'd have to prototype this first and see how it applies to the
> s390 case.  It might not be worth it and maybe we should replace
> ZONE_DMA and ZONE_DMA32 with a ZONE_LIMITED for those use cases as
> the amount covered tends to not be totally out of line for what we
> built the zone infrastructure.

So probably I'm missing something; but for small systems where we
would only have ZONE_DMA, how would a CMA area within this zone
improve things?

If I'm not mistaken then the page allocator will not fallback to any
CMA area for GFP_KERNEL allocations. That is: we would somehow need to
find "the right size" for the CMA area, depending on memory size. This
looks like a new problem class which currently does not exist.

Besides that we would also not have all the debugging options provided
by the slab allocator anymore.

Anyway, maybe it would make more sense if you would send your patch
and then we can see where we would end up.
