Return-Path: <netdev+bounces-4681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80B3D70DD98
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:37:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E9E28133B
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6987B1E53A;
	Tue, 23 May 2023 13:37:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55560EEDE
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:37:38 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93797CA;
	Tue, 23 May 2023 06:37:36 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NDSIMF005983;
	Tue, 23 May 2023 13:36:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z7spHrtrmZ67UDugotEBvSpqHnqw9d1kgSzqBqUyyH8=;
 b=l5uV2H3ANZt7cmqCfqUK5iS9kT0j0cD2CAjfqHTCGgJkRbP3QBIsXTwqRZt2wQX0lI/K
 uMnNa3cTxU6YXpQlj233RxDVbXdBt6Zte8kNBs8NkH75pYYPLPK24T+jobk4K/3eu+fx
 630m5oGuTHAlOtHNoCpIsVOlatZQ1lDpZGDYSZQ21dB0kv2OGYBzIZDznKF3kSlNDvl/
 AVKMM8aBKX4IVHOwnhXMaY0Eoya6Gtmu+rqNQXi/NZOzk4gTc7Myn/AUWGR2EDDelmaJ
 y9+s0c6p3YmEAfNC7agEkSinBX8RLB52Tsd+zw/bGkU+klE60Ex065xFYNSLtemrnMkX MA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrws21ke0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 13:36:43 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34NDSYQS009096;
	Tue, 23 May 2023 13:36:41 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrws21j46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 13:36:41 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
	by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8atFS000463;
	Tue, 23 May 2023 13:36:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3qppe097k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 13:36:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NDZxfm14418472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 13:35:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE48220043;
	Tue, 23 May 2023 13:35:59 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F73E2004B;
	Tue, 23 May 2023 13:35:57 +0000 (GMT)
Received: from [9.171.22.235] (unknown [9.171.22.235])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 May 2023 13:35:57 +0000 (GMT)
Message-ID: <5935f5ffdead164cfaedd067cd948d7c551a99ac.camel@linux.ibm.com>
Subject: Re: [PATCH v9 5/6] iommu/dma: Allow a single FQ in addition to
 per-CPU FQs
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>, Will Deacon <will@kernel.org>,
        Wenjia Zhang <wenjia@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Gerd Bayer <gbayer@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Alexandra Winter
 <wintera@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Suravee Suthikulpanit
 <suravee.suthikulpanit@amd.com>,
        Hector Martin <marcan@marcan.st>, Sven
 Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        David
 Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, Andy
 Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad
 Dybcio <konrad.dybcio@linaro.org>,
        Yong Wu <yong.wu@mediatek.com>,
        Matthias
 Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
 <angelogioacchino.delregno@collabora.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin
 Wang <baolin.wang@linux.alibaba.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding
 <thierry.reding@gmail.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Jonathan
 Hunter <jonathanh@nvidia.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux.dev, asahi@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-tegra@vger.kernel.org, linux-doc@vger.kernel.org
Date: Tue, 23 May 2023 15:35:57 +0200
In-Reply-To: <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
	 <20230310-dma_iommu-v9-5-65bb8edd2beb@linux.ibm.com>
	 <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8LV3zvez_FivvhCrjxTltho7FnbQWNLm
X-Proofpoint-ORIG-GUID: kjDiC2gMyraUPuAC5gMZ4Q10X1c7HWl8
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_09,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305230106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-22 at 17:26 +0100, Robin Murphy wrote:
> On 2023-05-15 10:15, Niklas Schnelle wrote:
> > In some virtualized environments, including s390 paged memory guests,
> > IOTLB flushes are used to update IOMMU shadow tables. Due to this, they
> > are much more expensive than in typical bare metal environments or
> > non-paged s390 guests. In addition they may parallelize more poorly in
> > virtualized environments. This changes the trade off for flushing IOVAs
> > such that minimizing the number of IOTLB flushes trumps any benefit of
> > cheaper queuing operations or increased paralellism.
> >=20
> > In this scenario per-CPU flush queues pose several problems. Firstly
> > per-CPU memory is often quite limited prohibiting larger queues.
> > Secondly collecting IOVAs per-CPU but flushing via a global timeout
> > reduces the number of IOVAs flushed for each timeout especially on s390
> > where PCI interrupts may not be bound to a specific CPU.
> >=20
> > Let's introduce a single flush queue mode that reuses the same queue
> > logic but only allocates a single global queue. This mode can be
> > selected as a flag bit in a new dma_iommu_options struct which can be
> > modified from its defaults by IOMMU drivers implementing a new
> > ops.tune_dma_iommu() callback. As a first user the s390 IOMMU driver
> > selects the single queue mode if IOTLB flushes are needed on map which
> > indicates shadow table use. With the unchanged small FQ size and
> > timeouts this setting is worse than per-CPU queues but a follow up patch
> > will make the FQ size and timeout variable. Together this allows the
> > common IOVA flushing code to more closely resemble the global flush
> > behavior used on s390's previous internal DMA API implementation.
> >=20
> > Link: https://lore.kernel.org/linux-iommu/3e402947-61f9-b7e8-1414-fde00=
6257b6f@arm.com/
> > Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com> #s390
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > ---
> >   drivers/iommu/dma-iommu.c  | 163 ++++++++++++++++++++++++++++++++++--=
---------
> >   drivers/iommu/dma-iommu.h  |   4 +-
> >   drivers/iommu/iommu.c      |  18 +++--
> >   drivers/iommu/s390-iommu.c |  10 +++
> >   include/linux/iommu.h      |  21 ++++++
> >   5 files changed, 169 insertions(+), 47 deletions(-)
> >=20
---8<---
> >=20=20=20
> > +/**
> > + * struct dma_iommu_options - Options for dma-iommu
> > + *
> > + * @flags: Flag bits for enabling/disabling dma-iommu settings
> > + *
> > + * This structure is intended to provide IOMMU drivers a way to influe=
nce the
> > + * behavior of the dma-iommu DMA API implementation. This allows optim=
izing for
> > + * example for a virtualized environment with slow IOTLB flushes.
> > + */
> > +struct dma_iommu_options {
> > +#define IOMMU_DMA_OPTS_PER_CPU_QUEUE	(0L << 0)
> > +#define IOMMU_DMA_OPTS_SINGLE_QUEUE	(1L << 0)
> > +	u64	flags;
> > +};
>=20
> I think for now this can just use a bit in dev_iommu to indicate that=20
> the device will prefer a global flush queue; s390 can set that in=20
> .probe_device, then iommu_dma_init_domain() can propagate it to an=20
> equivalent flag in the cookie (possibly even a new cookie type?) that=20
> iommu_dma_init_fq() can then consume. Then just make the s390 parameters=
=20
> from patch #6 the standard parameters for a global queue.
>=20
> Thanks,
> Robin.

Working on this now. How about I move the struct dma_iommu_options
definition into dma-iommu.c keeping it as part of struct
iommu_dma_cookie. That way we can still have the flags, timeout and
queue size organized the same but internal to dma-iommu.c. We then set
them in iommu_dma_init_domain() triggered by a "shadow_on_flush" flag
in struct dev_iommu. That way we can keep most of the same code but
only add a single flag as external interface. The flag would also be an
explicit fact about a distinctly IOMMU device thing just stating that
the IOTLB flushes do extra shadowing work. This leaves the decision to
then use a longer timeout and queue size within the responsibility of
dma-iommu.c. I think that's overall a better match of responsibilities.

Thanks,
Niklas

