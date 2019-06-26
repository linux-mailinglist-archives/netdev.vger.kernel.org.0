Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8BE564FD
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfFZI7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:59:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36476 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725379AbfFZI7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 04:59:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q8xYXK016161;
        Wed, 26 Jun 2019 01:59:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fNpCHMvrHiu/isERpYDvhWUbNSNH9zcm83OA4G7IO24=;
 b=wMOFRF4GBN+qleQlPa1NU6O0sTbGqIfsIsMJWmNfr2C36Pt9Uutl2YbDucu07XPUgmzz
 aCrQ9jbUff95rhUpzi3RtBn8OslI6jDdROxsKVm3/x57XidhvpYqk3Plh6t0dr18Qz4i
 fTtAnK+T6k6+UjpgPjlWSaiXhbp+4USyvkJBVRmFnwas0fOSmoVxi0F/sjNxpuP033Ai
 KNRfhPsBv+Xd6Ih9QeCbMHy7hFKT9neurFtDaRzsxSVriBta6Dnvt8F9w4/GbQCTaiSI
 WG/Oc8HWhP6GymEUV669NNWiRqARUNxB8AuN07A9Cm5OzDrnSCaDQAvE612gQuvPUZPB zw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tc5ht00vw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 01:59:39 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 01:59:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 01:59:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=qsrn4sqTo4QZysNIh3jlXpP9UDmzeyxf9pghbyNBYoO4z7Z+4GV2CBFkke5183JogMnoO2u3EoTpeJstLqHTaMGGKr4XQBHQ67R4TTzk7Lvo1+GWXHYd3VxBkauIKGeOxWfBtwdDhfwJbctAedfy5emF3PSyJwdwSFuckQAXeGM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNpCHMvrHiu/isERpYDvhWUbNSNH9zcm83OA4G7IO24=;
 b=QtIYh5U6ZteScZRWwv6Ut/VYpt5l5oWgrjQQzwKEPl2uU52tmtN7WQzUBw3NPO2MT0cEc/BrZEwppu6LSCy2XTVZNJ4zpFivs+glQVYcF1Lv4W6AlUf3X/DR9NXDVt0L+3PWJ1ktjVuSNvGe+ODpxQu/Gbp450CYtLDXeDa3bhg=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNpCHMvrHiu/isERpYDvhWUbNSNH9zcm83OA4G7IO24=;
 b=cAeaGdvB/9JaEXyaJfsJ/QUSBxzLQvwPtvKdnZPLar6hPObqDE6guc3XXxlKrotTsTttwZYMh0sTnQ7UoGszSNYI//vtmF2Cn8X0LtR/Zi+gYlQuFpi3iqKxYhbVmsj7o+eGqKyvZKGyNqhWo+tWXU1CJ6PPuj1K9/m90nqTRcw=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB2938.namprd18.prod.outlook.com (20.179.52.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 08:59:37 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 08:59:36 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Topic: [PATCH net-next 01/16] qlge: Remove irq_cnt
Thread-Index: AQHVJOFCi7hq2bA2CEicYO6gagSpYqatq44w
Date:   Wed, 26 Jun 2019 08:59:36 +0000
Message-ID: <DM6PR18MB2697814343012B4363482290ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-1-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d32465f-7fc9-4b03-591c-08d6fa149d95
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2938;
x-ms-traffictypediagnostic: DM6PR18MB2938:
x-microsoft-antispam-prvs: <DM6PR18MB2938E5F252DEB5985AF65BC6ABE20@DM6PR18MB2938.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(376002)(346002)(13464003)(199004)(189003)(256004)(25786009)(14444005)(53936002)(71200400001)(478600001)(6436002)(73956011)(55016002)(8676002)(66946007)(76116006)(14454004)(8936002)(86362001)(9686003)(68736007)(2906002)(229853002)(71190400001)(446003)(53546011)(74316002)(76176011)(476003)(7736002)(110136005)(99286004)(316002)(486006)(2501003)(3846002)(6116002)(7696005)(305945005)(5660300002)(52536014)(33656002)(26005)(102836004)(81156014)(66556008)(186003)(81166006)(6246003)(66476007)(66446008)(64756008)(6506007)(66066001)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2938;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /Yk/VL1/WhwZDFTT9co+kftMyDRQfbsu6Dg81KkVhH/6ox8NJ3U2v1L8WOxHZ1dfiN1KRsaFF1zRotxrq0hMNrmEXje1fIQ0FoNsjaEzjMCV70A1xjYxHHrUma9mG7YGTkuLS0YdpvyGjZ8zF65XNf/9GcTEikef8vi3i4whkRrvu8BKctAlDi6cI8K6bBm6TWBcm13KkEP3KQ7dADfsFKnzrO3DuYlmJ8kQoclM0eMDvVKbWzrKsA7HUvyc4GjtbLgaKKBJOgypNIiD56CcU1QvZxs52vo1X1VU6EjkXp0NM76ZHkofSadkBkV6YywdFvH3Q4lRR5wWtrHuA5oggnBGsO2F6JXGTFy2eHO3KIRrjTilmexG9tmWYxOrAac0A6jlnEmay6haKv+p4XN8BLuuXgakRj9oaeE5LERKmLw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d32465f-7fc9-4b03-591c-08d6fa149d95
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 08:59:36.7905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2938
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_05:,,
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

I believe you are talking about here for asic error recovery worker and MPI=
 worker.
Which separate IRQ masking bits are you referring here ?

>  static int ql_validate_flash(struct ql_adapter *qdev, u32 size, const ch=
ar *str)
> @@ -2500,21 +2451,22 @@ static irqreturn_t qlge_isr(int irq, void *dev_id=
)
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
> +	/* Experience shows that when using INTx interrupts, the device does
> +	 * not always auto-mask the interrupt.
> +	 * When using MSI mode, the interrupt must be explicitly disabled
> +	 * (even though it is auto-masked), otherwise a later command to
> +	 * enable it is not effective.
> +	 */
> +	if (!test_bit(QL_MSIX_ENABLED, &qdev->flags))
> +		ql_disable_completion_interrupt(qdev, 0);

Current code is disabling completion interrupt in case of MSI-X zeroth vect=
or.
This change will break that behavior. Shouldn't zeroth vector in case of MS=
I-X also disable completion interrupt ?
If not, please explain why ?

>=20
> -	var =3D ql_disable_completion_interrupt(qdev, intr_context->intr);
> +	var =3D ql_read32(qdev, STS);
>=20
>  	/*
>  	 * Check for fatal error.
>  	 */
>  	if (var & STS_FE) {
> +		ql_disable_completion_interrupt(qdev, 0);

Why need to do it again here ? if before this it can disable completion int=
errupt for INT-X case and MSI-X zeroth vector case ?

>  		ql_queue_asic_error(qdev);
>  		netdev_err(qdev->ndev, "Got fatal error, STS =3D %x.\n", var);
>  		var =3D ql_read32(qdev, ERR_STS);
> @@ -2534,7 +2486,6 @@ static irqreturn_t qlge_isr(int irq, void *dev_id)
>  		 */
>  		netif_err(qdev, intr, qdev->ndev,
>  			  "Got MPI processor interrupt.\n");
> -		ql_disable_completion_interrupt(qdev, intr_context->intr);

Why disable interrupt is not required here ?  While in case of Fatal error =
case above ql_disable_completion_interrupt() is being called ?
Also, in case of MSI-X zeroth vector it will not disable completion interru=
pt but at the end, it will end of qlge_isr() enabling completion interrupt.
Seems like disabling and enabling might not be in sync in case of MSI-X zer=
oth vector.


