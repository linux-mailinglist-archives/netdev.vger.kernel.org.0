Return-Path: <netdev+bounces-4664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A79770DC03
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 14:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B2C61C20D0A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A25744A875;
	Tue, 23 May 2023 12:09:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B7E4A85F
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 12:09:46 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0964818E;
	Tue, 23 May 2023 05:09:36 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NBu59s011498;
	Tue, 23 May 2023 12:03:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=GKYjosqXXClUpptGSo+WqClf2Qp4Kx9XS8p1Izd85Ck=;
 b=euoa/AzC8tQz0kG2m/kUYwiBGNBVXfQVZvP4AxrxL9ylnsBel++r9O3mJd0UMZWgh+on
 fagwfdO7lRBgDIf39dH6nKbIfQvD6StBUAaJfsVPji4fDsb4DGJ49CKEHgKOEHXFy6AE
 1NqN29WnK63ZEJUB9mfC8nwX8x5rGqd6CNFgBt1+zb8Hb23nOUoaFN9VlBOCP6h5XF/S
 hyqIjr2vUWnv4tHQ5nbYWlajAA/XkXCFoghD1k2Z5/lJ6p3XyEt12MD7wpcmOoe+IRL0
 z7zE6jQYGeLtnzn7ZajbepPZ82DogIu8knyeNWytT5tyV/pasyThcZDm+C1Go1R2Gt4s nw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrw2488jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:03:21 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34NBuYuI013546;
	Tue, 23 May 2023 12:03:07 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qrw2487u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:03:06 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
	by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34N309RA030369;
	Tue, 23 May 2023 12:02:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qppcf170c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 May 2023 12:02:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34NC2ojO13500984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 12:02:50 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91C2320043;
	Tue, 23 May 2023 12:02:50 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8AC420040;
	Tue, 23 May 2023 12:02:47 +0000 (GMT)
Received: from [9.171.22.235] (unknown [9.171.22.235])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 May 2023 12:02:47 +0000 (GMT)
Message-ID: <0d9e3f86cf9a1a3d69e650fb631809498c2cd01e.camel@linux.ibm.com>
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
Date: Tue, 23 May 2023 14:02:47 +0200
In-Reply-To: <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
References: <20230310-dma_iommu-v9-0-65bb8edd2beb@linux.ibm.com>
	 <20230310-dma_iommu-v9-5-65bb8edd2beb@linux.ibm.com>
	 <b1e53f39-5e0b-a09d-2954-cdc9e8592b67@arm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.48.1 (3.48.1-1.fc38) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CX4CMTbjS9rN7JA4wHUdJpnk4TEt6Js2
X-Proofpoint-ORIG-GUID: vQuNIviFptwQDoD71zzcOEgdj_w8Gdy7
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
 definitions=2023-05-23_08,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230095
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
> > diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> > index 7a9f0b0bddbd..be4cab6b4fe4 100644
> > --- a/drivers/iommu/dma-iommu.c
> > +++ b/drivers/iommu/dma-iommu.c
> > @@ -49,8 +49,11 @@ struct iommu_dma_cookie {
> >   		/* Full allocator for IOMMU_DMA_IOVA_COOKIE */
> >   		struct {
> >   			struct iova_domain	iovad;
> > -
> > -			struct iova_fq __percpu *fq;	/* Flush queue */
> > +			/* Flush queue */
> > +			union {
> > +				struct iova_fq	*single_fq;
> > +				struct iova_fq	__percpu *percpu_fq;
> > +			};
> >   			/* Number of TLB flushes that have been started */
> >   			atomic64_t		fq_flush_start_cnt;
> >   			/* Number of TLB flushes that have been finished */
> > @@ -67,6 +70,8 @@ struct iommu_dma_cookie {
> >=20=20=20
> >   	/* Domain for flush queue callback; NULL if flush queue not in use */
> >   	struct iommu_domain		*fq_domain;
> > +	/* Options for dma-iommu use */
> > +	struct dma_iommu_options	options;
> >   	struct mutex			mutex;
> >   };
> >=20=20=20
> > @@ -152,25 +157,44 @@ static void fq_flush_iotlb(struct iommu_dma_cooki=
e *cookie)
> >   	atomic64_inc(&cookie->fq_flush_finish_cnt);
> >   }
> >=20=20=20
> > -static void fq_flush_timeout(struct timer_list *t)
> > +static void fq_flush_percpu(struct iommu_dma_cookie *cookie)
> >   {
> > -	struct iommu_dma_cookie *cookie =3D from_timer(cookie, t, fq_timer);
> >   	int cpu;
> >=20=20=20
> > -	atomic_set(&cookie->fq_timer_on, 0);
> > -	fq_flush_iotlb(cookie);
> > -
> >   	for_each_possible_cpu(cpu) {
> >   		unsigned long flags;
> >   		struct iova_fq *fq;
> >=20=20=20
> > -		fq =3D per_cpu_ptr(cookie->fq, cpu);
> > +		fq =3D per_cpu_ptr(cookie->percpu_fq, cpu);
> >   		spin_lock_irqsave(&fq->lock, flags);
> >   		fq_ring_free(cookie, fq);
> >   		spin_unlock_irqrestore(&fq->lock, flags);
> >   	}
> >   }
> >=20=20=20
> > +static void fq_flush_single(struct iommu_dma_cookie *cookie)
> > +{
> > +	struct iova_fq *fq =3D cookie->single_fq;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&fq->lock, flags);
> > +	fq_ring_free(cookie, fq);
> > +	spin_unlock_irqrestore(&fq->lock, flags)
>=20
> Nit: this should clearly just be a self-locked version of fq_ring_free()=
=20
> that takes fq as an argument, then both the new case and the existing=20
> loop body become trivial one-line calls.

Sure will do. Just one question about names. As an example
pci_reset_function_locked() means that the relevant lock is already
taken with pci_reset_function() adding the lock/unlock. In your wording
the implied function names sound the other way around. I can't find
anything similar in drivers/iommu so would you mind going the PCI way
and having:

fq_ring_free_locked(): Called in queue_iova() with the lock held
fr_ring_free(): Called in fq_flush_timeout() takes the lock itself

Or maybe I'm just biased because I've used the PCI ..locked() functions
before and there is a better convention.

>=20
> > +}
> > +
> > +static void fq_flush_timeout(struct timer_list *t)
> > +{
> > +	struct iommu_dma_cookie *cookie =3D from_timer(cookie, t, fq_timer);
> > +
> > +	atomic_set(&cookie->fq_timer_on, 0);
> > +	fq_flush_iotlb(cookie);
> > +
> > +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> > +		fq_flush_single(cookie);
> > +	else
> > +		fq_flush_percpu(cookie);
> > +}
> > +
> >   static void queue_iova(struct iommu_dma_cookie *cookie,
> >   		unsigned long pfn, unsigned long pages,
> >   		struct list_head *freelist)
> > @@ -188,7 +212,11 @@ static void queue_iova(struct iommu_dma_cookie *co=
okie,
> >   	 */
> >   	smp_mb();
> >=20=20=20
> > -	fq =3D raw_cpu_ptr(cookie->fq);
> > +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> > +		fq =3D cookie->single_fq;
> > +	else
> > +		fq =3D raw_cpu_ptr(cookie->percpu_fq);
> > +
> >   	spin_lock_irqsave(&fq->lock, flags);
> >=20=20=20
> >   	/*
> > @@ -219,58 +247,114 @@ static void queue_iova(struct iommu_dma_cookie *=
cookie,
> >   			  jiffies + msecs_to_jiffies(IOVA_FQ_TIMEOUT));
> >   }
> >=20=20=20
> > -static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
> > +static void iommu_dma_free_fq_single(struct iova_fq *fq)
> > +{
> > +	int idx;
> > +
> > +	if (!fq)
> > +		return;
> > +	fq_ring_for_each(idx, fq)
> > +		put_pages_list(&fq->entries[idx].freelist);
> > +	vfree(fq);
> > +}
> > +
> > +static void iommu_dma_free_fq_percpu(struct iova_fq __percpu *percpu_f=
q)
> >   {
> >   	int cpu, idx;
> >=20=20=20
> > -	if (!cookie->fq)
> > -		return;
> > -
> > -	del_timer_sync(&cookie->fq_timer);
> >   	/* The IOVAs will be torn down separately, so just free our queued p=
ages */
> >   	for_each_possible_cpu(cpu) {
> > -		struct iova_fq *fq =3D per_cpu_ptr(cookie->fq, cpu);
> > +		struct iova_fq *fq =3D per_cpu_ptr(percpu_fq, cpu);
> >=20=20=20
> >   		fq_ring_for_each(idx, fq)
> >   			put_pages_list(&fq->entries[idx].freelist);
> >   	}
> >=20=20=20
> > -	free_percpu(cookie->fq);
> > +	free_percpu(percpu_fq);
> > +}
> > +
> > +static void iommu_dma_free_fq(struct iommu_dma_cookie *cookie)
> > +{
> > +	if (!cookie->fq_domain)
> > +		return;
> > +
> > +	del_timer_sync(&cookie->fq_timer);
> > +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> > +		iommu_dma_free_fq_single(cookie->single_fq);
> > +	else
> > +		iommu_dma_free_fq_percpu(cookie->percpu_fq);
> > +}
> > +
> > +
> > +static void iommu_dma_init_one_fq(struct iova_fq *fq)
> > +{
> > +	int i;
> > +
> > +	fq->head =3D 0;
> > +	fq->tail =3D 0;
> > +
> > +	spin_lock_init(&fq->lock);
> > +
> > +	for (i =3D 0; i < IOVA_FQ_SIZE; i++)
> > +		INIT_LIST_HEAD(&fq->entries[i].freelist);
> > +}
> > +
> > +static int iommu_dma_init_fq_single(struct iommu_dma_cookie *cookie)
> > +{
> > +	struct iova_fq *queue;
> > +
> > +	queue =3D vzalloc(sizeof(*queue));
> > +	if (!queue)
> > +		return -ENOMEM;
> > +	iommu_dma_init_one_fq(queue);
> > +	cookie->single_fq =3D queue;
> > +
> > +	return 0;
> > +}
> > +
> > +static int iommu_dma_init_fq_percpu(struct iommu_dma_cookie *cookie)
> > +{
> > +	struct iova_fq __percpu *queue;
> > +	int cpu;
> > +
> > +	queue =3D alloc_percpu(struct iova_fq);
> > +	if (!queue)
> > +		return -ENOMEM;
> > +
> > +	for_each_possible_cpu(cpu)
> > +		iommu_dma_init_one_fq(per_cpu_ptr(queue, cpu));
> > +	cookie->percpu_fq =3D queue;
> > +	return 0;
> >   }
> >=20=20=20
> >   /* sysfs updates are serialised by the mutex of the group owning @dom=
ain */
> > -int iommu_dma_init_fq(struct iommu_domain *domain)
> > +int iommu_dma_init_fq(struct device *dev, struct iommu_domain *domain)
> >   {
> >   	struct iommu_dma_cookie *cookie =3D domain->iova_cookie;
> > -	struct iova_fq __percpu *queue;
> > -	int i, cpu;
> > +	const struct iommu_ops *ops =3D dev_iommu_ops(dev);
> > +	int rc;
> >=20=20=20
> >   	if (cookie->fq_domain)
> >   		return 0;
> >=20=20=20
> > +	if (ops->tune_dma_iommu)
> > +		ops->tune_dma_iommu(dev, &cookie->options);
> > +
> >   	atomic64_set(&cookie->fq_flush_start_cnt,  0);
> >   	atomic64_set(&cookie->fq_flush_finish_cnt, 0);
> >=20=20=20
> > -	queue =3D alloc_percpu(struct iova_fq);
> > -	if (!queue) {
> > +	if (cookie->options.flags & IOMMU_DMA_OPTS_SINGLE_QUEUE)
> > +		rc =3D iommu_dma_init_fq_single(cookie);
> > +	else
> > +		rc =3D iommu_dma_init_fq_percpu(cookie);
> > +
> > +	if (rc) {
> >   		pr_warn("iova flush queue initialization failed\n");
> > -		return -ENOMEM;
> > +		/* fall back to strict mode */
> > +		domain->type =3D IOMMU_DOMAIN_DMA;
>=20
> Why move this? It doesn't logically belong to FQ initialisation itself.

Ah yes this is not needed anymore. Previously when I had a new domain
type I think I needed to set domain->type in here and moved the
fallback for consistency. Will remove that change.

>=20
> > +		return rc;
> >   	}
> >=20=20=20
> > -	for_each_possible_cpu(cpu) {
> > -		struct iova_fq *fq =3D per_cpu_ptr(queue, cpu);
> > -
> > -		fq->head =3D 0;
> > -		fq->tail =3D 0;
> > -
> > -		spin_lock_init(&fq->lock);
> > -
> > -		for (i =3D 0; i < IOVA_FQ_SIZE; i++)
> > -			INIT_LIST_HEAD(&fq->entries[i].freelist);
> > -	}
> > -
> > -	cookie->fq =3D queue;
> > -
> >   	timer_setup(&cookie->fq_timer, fq_flush_timeout, 0);
> >   	atomic_set(&cookie->fq_timer_on, 0);
> >   	/*
> >=20
---8<---
> >   static struct iommu_device *s390_iommu_probe_device(struct device *de=
v)
> >   {
> >   	struct zpci_dev *zdev;
> > @@ -793,6 +802,7 @@ static const struct iommu_ops s390_iommu_ops =3D {
> >   	.device_group =3D generic_device_group,
> >   	.pgsize_bitmap =3D SZ_4K,
> >   	.get_resv_regions =3D s390_iommu_get_resv_regions,
> > +	.tune_dma_iommu =3D s390_iommu_tune_dma_iommu,
> >   	.default_domain_ops =3D &(const struct iommu_domain_ops) {
> >   		.attach_dev	=3D s390_iommu_attach_device,
> >   		.map_pages	=3D s390_iommu_map_pages,
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 58891eddc2c4..3649a17256a5 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -219,6 +219,21 @@ struct iommu_iotlb_gather {
> >   	bool			queued;
> >   };
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

Sounds good.

>=20
> > +
> >   /**
> >    * struct iommu_ops - iommu ops and capabilities
> >    * @capable: check capability
> > @@ -242,6 +257,9 @@ struct iommu_iotlb_gather {
> >    *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
> >    *		- IOMMU_DOMAIN_DMA: must use a dma domain
> >    *		- 0: use the default setting
> > + * @tune_dma_iommu: Allows the IOMMU driver to modify the default
> > + *		    options of the dma-iommu layer for a specific
> > + *		    device.
> >    * @default_domain_ops: the default ops for domains
> >    * @remove_dev_pasid: Remove any translation configurations of a spec=
ific
> >    *                    pasid, so that any DMA transactions with this p=
asid
> > @@ -278,6 +296,9 @@ struct iommu_ops {
> >   	int (*def_domain_type)(struct device *dev);
> >   	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
> >=20=20=20
> > +	void (*tune_dma_iommu)(struct device *dev,
> > +			       struct dma_iommu_options *options);
> > +
> >   	const struct iommu_domain_ops *default_domain_ops;
> >   	unsigned long pgsize_bitmap;
> >   	struct module *owner;
> >=20
>=20


