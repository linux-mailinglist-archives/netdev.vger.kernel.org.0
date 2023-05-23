Return-Path: <netdev+bounces-4666-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A731D70DC69
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:21:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DCE4281284
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396764A87B;
	Tue, 23 May 2023 12:21:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283AE4A85F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:21:39 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD436119;
	Tue, 23 May 2023 05:21:37 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NC85Cd010591;
	Tue, 23 May 2023 12:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=b/N97QNJLbmr+RhSzhUpL7rxH3poMQwYGelaxe/kHjw=;
 b=ikq5fqhiSpAAT0nJmLp0aCj978Av/rRSS20Vc4ULriCHaM0B7e6jTtTZJvoiEszfEp9B
 l7miWEJ49bMuuMf1IpkL0lHjV9aYJAP4k4tugihoSJ+ulamMiXffid3ZMqXCYrOhemca
 b697LrcX3VA2GTXABwyFzt0QEAzH0LWC47K1qa9a190SlVw00sYxpmR3QWCWyn+lMG0w
 O7Vdf1FG9BiZhYoT+2OE9qZxkgvgdDI6gDcQOXIhpLK6HvUP32YP2uq12Ef/ajaAlWoJ
 s1A8hVsg7S/r9zE0ldTpDCJaPMjUrWa79b/rzIwRHbSCz33LjwGjs4zykqMBYji7DN/U 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrw2n8kac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:20:34 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34NC85YP010666;
	Tue, 23 May 2023 12:20:33 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrw2n8k8b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:20:33 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34N2FIwg013811;
	Tue, 23 May 2023 12:20:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3qppcu9f06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:20:30 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NCKRRA11338474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 12:20:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E82A02004D;
	Tue, 23 May 2023 12:20:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EA4820040;
	Tue, 23 May 2023 12:20:24 +0000 (GMT)
Received: from [9.171.22.235] (unknown [9.171.22.235])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 May 2023 12:20:24 +0000 (GMT)
Message-ID: <b06a47fecf5eab9440c1c35d9c7b83fe87f918a0.camel@linux.ibm.com>
Subject: Re: [PATCH v9 6/6] iommu/dma: Make flush queue sizes and timeout
 driver configurable
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>, Will Deacon <will@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Julian
 Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Suravee
 Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Hector Martin
 <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig
 <alyssa@rosenzweig.io>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu
 <baolu.lu@linux.intel.com>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu
 <yong.wu@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Orson Zhai
 <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chunyan
 Zhang <zhang.lyra@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec
 <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry
 Reding <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org
Date: Tue, 23 May 2023 14:20:24 +0200
In-Reply-To: <ZGuT2R42SWFHmklu@8bytes.org>
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
	 <20230310-dma_iommu-v9-6-65bb8edd2beb@linux.ibm.com>
	 <ZGuT2R42SWFHmklu@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SCHk9GNBzwPXZyeAocq9ZCr1U8UNYoFE
X-Proofpoint-ORIG-GUID: YIMPkAl4-Wv-r6WPNnYiGonT3FNgmVP_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_08,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 bulkscore=0 mlxscore=0 priorityscore=1501 adultscore=0 spamscore=0
 mlxlogscore=686 impostorscore=0 clxscore=1015 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230095
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-22 at 18:10 +0200, Joerg Roedel wrote:
> On Mon, May 15, 2023 at 11:15:56AM +0200, Niklas Schnelle wrote:
> > In the s390 IOMMU driver a large fixed queue size and timeout is then
> > set together with single queue mode bringing its performance on s390
> > paged memory guests on par with the previous s390 specific DMA API
> > implementation.
>=20
> Hmm, the right flush-queue size and timeout settings are more a function
> of the endpoint device and device driver than of the iommu driver, no? I
> think something like this could also help solving the recently reported
> scalability problems in the fq-code, if done right.
>=20
> Regards,
>=20
> 	Joerg
>=20

In our case the large flush queue and timeout is needed because the
IOTLB flushes of the virtualized s390 IOMMU are used by KVM and z/VM to
synchronize their IOMMU shadow tables thus making them more expensive.
This then applies to all pass-through PCI devices without their drivers
knowing about the IOMMU being virtualized like that. But yes of course
there could be cases where the device driver knows better.

Thanks,
Niklas

