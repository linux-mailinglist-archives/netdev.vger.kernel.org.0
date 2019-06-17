Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099C84893F
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfFQQtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 12:49:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49584 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725995AbfFQQtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 12:49:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HGlG1v013670;
        Mon, 17 Jun 2019 09:49:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rriNvKnCPX0SsNDjCZZAHLJvEpi1A9BjWrANSj5rv3s=;
 b=oWKxdJbQvwHc6Qo34ypyff5OxJxXDmy529+YcxwH64qTGUyg2yuMzzK43F44IIi4Yl5E
 uZCg39LrI4Yxs7ESGOq9UiNYgfvy2+sAm40Vid1DAPgIy5RUrIuzgGgvb1yhSs25vL2J
 k18BBDOc27cArlc1QiAsFt4neWUD2Kp1SIYQvCU7d+qwSsyHI+YhBXgZjdL2ys4lM88f
 z/Kl4smkG2lHSEnScHeWvySedw6D7+k0304YDy80LECHN6eXpkLfMPzxQHNXKwdCLF9V
 ycZSgye4wA4TWK0kVKMjPquiewQG7WFP86Cah7iffF6D0Ph2GVa6w0mZc5GjnrudCZCq ww== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t506hyj5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 17 Jun 2019 09:49:07 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 17 Jun
 2019 09:49:06 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 17 Jun 2019 09:49:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rriNvKnCPX0SsNDjCZZAHLJvEpi1A9BjWrANSj5rv3s=;
 b=M9Gg+z0NST5pvmEDhRVOzu2oOWxr5VXnHIWaM3LP0wBWicdSmNfZCz42B72J2Ca992kwT2exfU5spO7ufSr24RVCbxi3QhB25gcilROnJY7TeuYTmPZtmmuEFIYXJPTJRFTFqlrNC2BOiDuqyOZ6FQqB5rmtMvQHPKCfOsi5fOQ=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2810.namprd18.prod.outlook.com (20.179.50.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Mon, 17 Jun 2019 16:49:04 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.1987.014; Mon, 17 Jun 2019
 16:49:04 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Topic: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Index: AQHVJOFCi7hq2bA2CEicYO6gagSpYqagDjKA
Date:   Mon, 17 Jun 2019 16:49:04 +0000
Message-ID: <DM6PR18MB26970EA12A379FBBA42EB0F4ABEB0@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2409:4042:2285:e2f3:b188:df5e:3b1c:91e4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 74accb1d-1969-4096-1bc8-08d6f343b50f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2810;
x-ms-traffictypediagnostic: DM6PR18MB2810:
x-microsoft-antispam-prvs: <DM6PR18MB2810712518EFEABDBD8A9C85ABEB0@DM6PR18MB2810.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0071BFA85B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(136003)(39860400002)(366004)(376002)(13464003)(199004)(189003)(7736002)(229853002)(102836004)(305945005)(52536014)(71190400001)(2906002)(76116006)(68736007)(66946007)(73956011)(316002)(66476007)(66556008)(66446008)(64756008)(6246003)(71200400001)(6436002)(8936002)(25786009)(86362001)(2501003)(476003)(11346002)(446003)(486006)(186003)(76176011)(256004)(14444005)(110136005)(8676002)(5660300002)(7696005)(74316002)(478600001)(53546011)(6506007)(9686003)(81156014)(81166006)(14454004)(99286004)(53936002)(55016002)(6116002)(46003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2810;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kjMKEQqG3ry6TRfy5kj4wp7Cw3Zb143zsKjeZoe8koQhHNtRsnAbnLX/S0gw9BV3k01baJ4BniYYu4oJl1tZY+PuWjUd1rhIJ0iq3o4YxAy3NAYx8Lnal0/2VmqjXPWsP57ccbWSV9HuyxJMRGljSN3bzQwf/uWdNb9m/TvszNC0bv538Fnlbc9vtX7KhdVvhgkDj1rZO0sVgAZJZM/vpK61s0B9h55HUPGAKF+ji3ylOHK8NcWZkW7X5kI/w/wP90tlE/oVu+r+CLF2Llq92DGYxvxTri+1p1jIIQS2cOl5uFhHl7G/pN3hmSP4PQqzoz2tbgN8gHLUEsKuANojIzG29LkOddyTwSM/UBhCUdRVJvwpawJJJdkHV+iqlYVYZiIUXTN1qx1PbxanSDmON7Kg80L1DfktxNsTrwDwuUg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 74accb1d-1969-4096-1bc8-08d6f343b50f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2019 16:49:04.2330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2810
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Benjamin Poirier <bpoirier@suse.com>
> Sent: Monday, June 17, 2019 1:19 PM
> To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: [PATCH net-next 01/16] qlge: Remove irq_cnt
>=20
> qlge uses an irq enable/disable refcounting scheme that is:
> * poorly implemented
> 	Uses a spin_lock to protect accesses to the irq_cnt atomic variable
> * buggy
> 	Breaks when there is not a 1:1 sequence of irq - napi_poll, such as
> 	when using SO_BUSY_POLL.
> * unnecessary
> 	The purpose or irq_cnt is to reduce irq control writes when
> 	multiple work items result from one irq: the irq is re-enabled
> 	after all work is done.
> 	Analysis of the irq handler shows that there is only one case where
> 	there might be two workers scheduled at once, and those have
> 	separate irq masking bits.
>=20
> Therefore, remove irq_cnt.
>=20
> Additionally, we get a performance improvement:
> perf stat -e cycles -a -r5 super_netperf 100 -H 192.168.33.1 -t TCP_RR
>=20
> Before:
> 628560
> 628056
> 622103
> 622744
> 627202
> [...]
>    268,803,947,669      cycles                 ( +-  0.09% )
>=20
> After:
> 636300
> 634106
> 634984
> 638555
> 634188
> [...]
>    259,237,291,449      cycles                 ( +-  0.19% )
>=20
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
> ---
>  drivers/net/ethernet/qlogic/qlge/qlge.h      |  7 --
>  drivers/net/ethernet/qlogic/qlge/qlge_main.c | 98 ++++++--------------
> drivers/net/ethernet/qlogic/qlge/qlge_mpi.c  |  1 -
>  3 files changed, 27 insertions(+), 79 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge.h
> b/drivers/net/ethernet/qlogic/qlge/qlge.h
> index ad7c5eb8a3b6..5d9a36deda08 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge.h
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge.h
> @@ -1982,11 +1982,6 @@ struct intr_context {
>  	u32 intr_dis_mask;	/* value/mask used to disable this intr */
>  	u32 intr_read_mask;	/* value/mask used to read this intr */
>  	char name[IFNAMSIZ * 2];
> -	atomic_t irq_cnt;	/* irq_cnt is used in single vector
> -				 * environment.  It's incremented for each
> -				 * irq handler that is scheduled.  When each
> -				 * handler finishes it decrements irq_cnt and
> -				 * enables interrupts if it's zero. */
>  	irq_handler_t handler;
>  };
>=20
> @@ -2074,7 +2069,6 @@ struct ql_adapter {
>  	u32 port;		/* Port number this adapter */
>=20
>  	spinlock_t adapter_lock;
> -	spinlock_t hw_lock;
>  	spinlock_t stats_lock;
>=20
>  	/* PCI Bus Relative Register Addresses */ @@ -2235,7 +2229,6 @@
> void ql_mpi_reset_work(struct work_struct *work);  void
> ql_mpi_core_to_log(struct work_struct *work);  int ql_wait_reg_rdy(struct
> ql_adapter *qdev, u32 reg, u32 bit, u32 ebit);  void
> ql_queue_asic_error(struct ql_adapter *qdev);
> -u32 ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr);
> void ql_set_ethtool_ops(struct net_device *ndev);  int
> ql_read_xgmac_reg64(struct ql_adapter *qdev, u32 reg, u64 *data);  void
> ql_mpi_idc_work(struct work_struct *work); diff --git
> a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> index 6cae33072496..0bfbe11db795 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_main.c
> @@ -625,75 +625,26 @@ static void ql_disable_interrupts(struct ql_adapter
> *qdev)
>  	ql_write32(qdev, INTR_EN, (INTR_EN_EI << 16));  }
>=20
> -/* If we're running with multiple MSI-X vectors then we enable on the fl=
y.
> - * Otherwise, we may have multiple outstanding workers and don't want to
> - * enable until the last one finishes. In this case, the irq_cnt gets
> - * incremented every time we queue a worker and decremented every time
> - * a worker finishes.  Once it hits zero we enable the interrupt.
> - */
> -u32 ql_enable_completion_interrupt(struct ql_adapter *qdev, u32 intr)
> +static void ql_enable_completion_interrupt(struct ql_adapter *qdev, u32
> +intr)
>  {
> -	u32 var =3D 0;
> -	unsigned long hw_flags =3D 0;
> -	struct intr_context *ctx =3D qdev->intr_context + intr;
> -
> -	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr)) {
> -		/* Always enable if we're MSIX multi interrupts and
> -		 * it's not the default (zeroeth) interrupt.
> -		 */
> -		ql_write32(qdev, INTR_EN,
> -			   ctx->intr_en_mask);
> -		var =3D ql_read32(qdev, STS);
> -		return var;
> -	}
> +	struct intr_context *ctx =3D &qdev->intr_context[intr];
>=20
> -	spin_lock_irqsave(&qdev->hw_lock, hw_flags);
> -	if (atomic_dec_and_test(&ctx->irq_cnt)) {
> -		ql_write32(qdev, INTR_EN,
> -			   ctx->intr_en_mask);
> -		var =3D ql_read32(qdev, STS);
> -	}
> -	spin_unlock_irqrestore(&qdev->hw_lock, hw_flags);
> -	return var;
> +	ql_write32(qdev, INTR_EN, ctx->intr_en_mask);
>  }
>=20
> -static u32 ql_disable_completion_interrupt(struct ql_adapter *qdev, u32
> intr)
> +static void ql_disable_completion_interrupt(struct ql_adapter *qdev,
> +u32 intr)
>  {
> -	u32 var =3D 0;
> -	struct intr_context *ctx;
> +	struct intr_context *ctx =3D &qdev->intr_context[intr];
>=20
> -	/* HW disables for us if we're MSIX multi interrupts and
> -	 * it's not the default (zeroeth) interrupt.
> -	 */
> -	if (likely(test_bit(QL_MSIX_ENABLED, &qdev->flags) && intr))
> -		return 0;
> -
> -	ctx =3D qdev->intr_context + intr;
> -	spin_lock(&qdev->hw_lock);
> -	if (!atomic_read(&ctx->irq_cnt)) {
> -		ql_write32(qdev, INTR_EN,
> -		ctx->intr_dis_mask);
> -		var =3D ql_read32(qdev, STS);
> -	}
> -	atomic_inc(&ctx->irq_cnt);
> -	spin_unlock(&qdev->hw_lock);
> -	return var;
> +	ql_write32(qdev, INTR_EN, ctx->intr_dis_mask);
>  }
>=20
>  static void ql_enable_all_completion_interrupts(struct ql_adapter *qdev)=
  {
>  	int i;
> -	for (i =3D 0; i < qdev->intr_count; i++) {
> -		/* The enable call does a atomic_dec_and_test
> -		 * and enables only if the result is zero.
> -		 * So we precharge it here.
> -		 */
> -		if (unlikely(!test_bit(QL_MSIX_ENABLED, &qdev->flags) ||
> -			i =3D=3D 0))
> -			atomic_set(&qdev->intr_context[i].irq_cnt, 1);
> -		ql_enable_completion_interrupt(qdev, i);
> -	}
>=20
> +	for (i =3D 0; i < qdev->intr_count; i++)
> +		ql_enable_completion_interrupt(qdev, i);
>  }
>=20
>  static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const ch=
ar
> *str) @@ -2500,21 +2451,22 @@ static irqreturn_t qlge_isr(int irq, void
> *dev_id)
>  	u32 var;
>  	int work_done =3D 0;
>=20
> -	spin_lock(&qdev->hw_lock);
> -	if (atomic_read(&qdev->intr_context[0].irq_cnt)) {
> -		netif_printk(qdev, intr, KERN_DEBUG, qdev->ndev,
> -			     "Shared Interrupt, Not ours!\n");
> -		spin_unlock(&qdev->hw_lock);
> -		return IRQ_NONE;
> -	}
> -	spin_unlock(&qdev->hw_lock);
> +	/* Experience shows that when using INTx interrupts, the device
> does
> +	 * not always auto-mask the interrupt.
> +	 * When using MSI mode, the interrupt must be explicitly disabled
> +	 * (even though it is auto-masked), otherwise a later command to
> +	 * enable it is not effective.
> +	 */
> +	if (!test_bit(QL_MSIX_ENABLED, &qdev->flags))
> +		ql_disable_completion_interrupt(qdev, 0);
>=20
> -	var =3D ql_disable_completion_interrupt(qdev, intr_context->intr);
> +	var =3D ql_read32(qdev, STS);
>=20
>  	/*
>  	 * Check for fatal error.
>  	 */
>  	if (var & STS_FE) {
> +		ql_disable_completion_interrupt(qdev, 0);
>  		ql_queue_asic_error(qdev);
>  		netdev_err(qdev->ndev, "Got fatal error, STS =3D %x.\n", var);
>  		var =3D ql_read32(qdev, ERR_STS);
> @@ -2534,7 +2486,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
>  		 */
>  		netif_err(qdev, intr, qdev->ndev,
>  			  "Got MPI processor interrupt.\n");
> -		ql_disable_completion_interrupt(qdev, intr_context->intr);
>  		ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16));
>  		queue_delayed_work_on(smp_processor_id(),
>  				qdev->workqueue, &qdev->mpi_work, 0);
> @@ -2550,11 +2501,18 @@ static irqreturn_t qlge_isr(int irq, void *dev_id=
)
>  	if (var & intr_context->irq_mask) {
>  		netif_info(qdev, intr, qdev->ndev,
>  			   "Waking handler for rx_ring[0].\n");
> -		ql_disable_completion_interrupt(qdev, intr_context->intr);
>  		napi_schedule(&rx_ring->napi);
>  		work_done++;
> +	} else {
> +		/* Experience shows that the device sometimes signals an
> +		 * interrupt but no work is scheduled from this function.
> +		 * Nevertheless, the interrupt is auto-masked. Therefore, we
> +		 * systematically re-enable the interrupt if we didn't
> +		 * schedule napi.
> +		 */
> +		ql_enable_completion_interrupt(qdev, 0);
>  	}
> -	ql_enable_completion_interrupt(qdev, intr_context->intr);
> +
>  	return work_done ? IRQ_HANDLED : IRQ_NONE;  }
>=20
> @@ -3557,7 +3515,6 @@ static int ql_request_irq(struct ql_adapter *qdev)
>  	ql_resolve_queues_to_irqs(qdev);
>=20
>  	for (i =3D 0; i < qdev->intr_count; i++, intr_context++) {
> -		atomic_set(&intr_context->irq_cnt, 0);
>  		if (test_bit(QL_MSIX_ENABLED, &qdev->flags)) {
>  			status =3D request_irq(qdev->msi_x_entry[i].vector,
>  					     intr_context->handler,
> @@ -4642,7 +4599,6 @@ static int ql_init_device(struct pci_dev *pdev,
> struct net_device *ndev,
>  		goto err_out2;
>  	}
>  	qdev->msg_enable =3D netif_msg_init(debug, default_msg);
> -	spin_lock_init(&qdev->hw_lock);
>  	spin_lock_init(&qdev->stats_lock);
>=20
>  	if (qlge_mpi_coredump) {
> diff --git a/drivers/net/ethernet/qlogic/qlge/qlge_mpi.c
> b/drivers/net/ethernet/qlogic/qlge/qlge_mpi.c
> index 957c72985a06..9e422bbbb6ab 100644
> --- a/drivers/net/ethernet/qlogic/qlge/qlge_mpi.c
> +++ b/drivers/net/ethernet/qlogic/qlge/qlge_mpi.c
> @@ -1257,7 +1257,6 @@ void ql_mpi_work(struct work_struct *work)
>  	/* End polled mode for MPI */
>  	ql_write32(qdev, INTR_MASK, (INTR_MASK_PI << 16) |
> INTR_MASK_PI);
>  	mutex_unlock(&qdev->mpi_mutex);
> -	ql_enable_completion_interrupt(qdev, 0);
>  }
>=20
>  void ql_mpi_reset_work(struct work_struct *work)
> --
> 2.21.0

Hello Benjamin,=20

Just FYI. I am OOO for a week, so reviewing and testing these patches will =
take time.

Thanks,
Manish
