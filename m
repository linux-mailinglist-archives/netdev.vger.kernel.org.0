Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79576136A41
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 10:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgAJJvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 04:51:18 -0500
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:10662
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727206AbgAJJvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 04:51:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=8FQ7PeEm7yBB4SBI4hGg24Yd+x5kvAHSrcrlWSQU6JpLUb4n3wAtxPMJ1j5aYS/n9wXjq3cNeJ0irPy88A9ju19x5821y6eWkhwsNwGMLlWK365a5/Ghs8xoMkLynugC2V4LJYqdfilrN7jcYT8HniPhIJ7ox/OqUZO3AJwevTY=
Received: from AM4PR08CA0067.eurprd08.prod.outlook.com (2603:10a6:205:2::38)
 by DBBPR08MB4824.eurprd08.prod.outlook.com (2603:10a6:10:d9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.12; Fri, 10 Jan
 2020 09:51:10 +0000
Received: from AM5EUR03FT008.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::202) by AM4PR08CA0067.outlook.office365.com
 (2603:10a6:205:2::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend
 Transport; Fri, 10 Jan 2020 09:51:10 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT008.mail.protection.outlook.com (10.152.16.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Fri, 10 Jan 2020 09:51:10 +0000
Received: ("Tessian outbound 28955e0c1ca8:v40"); Fri, 10 Jan 2020 09:51:10 +0000
X-CR-MTA-TID: 64aa7808
Received: from ef822ac32c86.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7423F90E-C564-4349-B2A7-0CD8414F21D6.1;
        Fri, 10 Jan 2020 09:51:05 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ef822ac32c86.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 10 Jan 2020 09:51:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqaNw3gGyUGsLAV6nwkgaY6w+Hs7SxgkC2FKckmAh/+K7fgOuVhfZo9rcXxH9Aj33kUEQByuFbKOIAzlHP2t4Xutyxqg5tiRj7gSBQrzUtwoHVB57cUmoNGZlpRFgq2XaeNrIXuh34LNe5JBEPVz49N6hkteivifsR0c7Z1Q/mGeqc5VpBNjNv0RqJhjn1hXZcozQN5eb2q3Otpc404B2yZfu6aZaZlmjGYxKFQLrdyo3jwq0HNzyckrAr43QnkIxZn4tSJMmIrm1mpO/n1KnpqD0c5UYVYji9sM6Kgx5ztOw6dlNQ9gqkiGQ61/TbL5iD/k6mnYwgvgPkq8c8IUNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=mx0BWR002S7DA9ed95LDbyEvWtxVXY8PCAyiGE3rNNHPXwMvUC9MmRF34pQyzjsTOUVlH0EUtQrxA4YsedUOdejrfTXbOXnHWmuDcpcjACFztXFryZT0UmlLUrOPEmvHb23fZiknldSQ36+bbO+tUFmt/S3/cqm6dAM0s4fVDhoNELxs7WxfYCQ7s9nffGWA/4BzRPfF6Pq8weaefAZFjBpv1hmQ9Syc7+qX9hSW5MYxa+HTrb4ShZnR0S3Q4DTJMPUuz/xywdKp2aDmPqT3nZP7xPdUfEAu2osyovTEiK1memsBRUIA2jsagNEaV91JZw36rp9WZjzJ/x0Omqy4Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpOxh8Ck9WWCfMNgHMOLPoOZgn4b+fCTsO88KvX3vfQ=;
 b=8FQ7PeEm7yBB4SBI4hGg24Yd+x5kvAHSrcrlWSQU6JpLUb4n3wAtxPMJ1j5aYS/n9wXjq3cNeJ0irPy88A9ju19x5821y6eWkhwsNwGMLlWK365a5/Ghs8xoMkLynugC2V4LJYqdfilrN7jcYT8HniPhIJ7ox/OqUZO3AJwevTY=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1978.eurprd08.prod.outlook.com (10.168.96.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Fri, 10 Jan 2020 09:51:01 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 09:51:01 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVrwuxR+1ZEaCriEa+CGCL3lP4K6ffGBkAgALhg9CAAEMegIABkMMA
Date:   Fri, 10 Jan 2020 09:51:01 +0000
Message-ID: <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
In-Reply-To: <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7d87b698-0ad5-49aa-adcb-f8ae0f578508.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a4db4bc2-a6ee-4716-26ba-08d795b29f50
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1978:|HE1PR0801MB1978:|DBBPR08MB4824:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB4824134B078D773CB15C4121F4380@DBBPR08MB4824.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:1850;OLM:1850;
x-forefront-prvs: 02788FF38E
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(376002)(136003)(346002)(13464003)(199004)(189003)(7696005)(53546011)(55016002)(86362001)(6506007)(7416002)(6916009)(52536014)(9686003)(316002)(71200400001)(55236004)(8936002)(66446008)(966005)(4001150100001)(33656002)(81156014)(76116006)(54906003)(66556008)(186003)(2906002)(4326008)(26005)(81166006)(66946007)(64756008)(8676002)(5660300002)(478600001)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1978;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: oRkGsVNMjxE5Gdp7ZfbaWvlBB14kjc0n/fYhBVzWLvJ0Mfm1F9QVPgMmS026Hzu6tpeyo+v7lOFdl9QhTU3pc46wLRgYv2SahhF2+1nhyQDG/pS/s8Pv+uuIls2gd5LPVm7u7RDpncWbNkmhSQcd5WgUykRiGS8WAILuQdbfugnVQrIM9TX0k2rRpOHB1Zuclx3sn76b5WB7mNPmRXNGz4Kj6JmK51g6kqbZdXxDNlWVaXimUHx6eTVqT/AgaSGSSYP5PP7FbQQ4xMKn422f6+b6uXiOY9p2ZSH8OVti4R6EQtkFqxXT4f0HThpc2lttLf5TqP1NYsEZFilenMSLhSCEm4oLkIYzokoAB1X1yQNOWbgk7n8A9L7xHb9xACa346iaIscRPykkQFCb8NPl0OAqrSFNrOwj7FGfCnFHkS2d66K66XNklosr8ZIopXJHdaG76/EJutpZgppODt+qStriVpOGEEeFkdsSv5wlQssYOqeSB2MoCKhy+0cLOHzvs4M8czfV8jdZsptk83spcPPqBfbuBkthViDF7x4Mx3s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1978
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT008.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(376002)(39860400002)(199004)(189003)(13464003)(8936002)(450100002)(4326008)(6506007)(54906003)(26826003)(186003)(81166006)(2906002)(81156014)(6862004)(5660300002)(26005)(7696005)(478600001)(336012)(53546011)(52536014)(70206006)(70586007)(356004)(36906005)(55016002)(33656002)(9686003)(316002)(966005)(8676002)(86362001)(4001150100001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR08MB4824;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: c104dbeb-b2ac-474d-5662-08d795b299d0
X-Forefront-PRVS: 02788FF38E
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMQCIYuaTd9n4/gySpch17YtvSFmAqyvm/Ylc5YqsVgVOE8c3A4opQYJeQkHjeAf1YA6hck3GGdJQhd+DaUE3Da8yZNoZZM3PsnNRRrFoKjF59PVbmjqKTWb6WJ9tNXzBCSU+1wn7tcG1sfEV77F7ulYklpXq1LUDvSMJK9oqmtItZ7nIAlZSf6uLGycMKgndxvr7P0qqnedT3t+zTj86AxeB4S9QeGTEqG+cDMtvsLUVIGa0PnNo8obmdtXCffcpdN4FZzmYRGdDJsngNig2cMZtOukrRYCt6c1+jTSq3LQPYhy0/ocZz2lI8GlPvJApNkfp30G8bYzbBOG5uu5o+kBSkKMDo5f5SzvDaIWCNq9r49c1ItZP4FMKrt/ykjSKqlEmm+gjDX3anN6FQTgF0DKx+3iaJWlaJfyWOhgc1+xOuO7d2oIDBUyIk+MVBI0y3vtPOMASyRnIihRNtorSnBil0Z7VGI1vK3mg+FVnnlxLCisgZx9sU5BeGyakKOz6vN7AQz9fzbI0p4m5Vy7e1C+Qwnc2eYq7+Dv6Ajm3CQ=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2020 09:51:10.4160
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4db4bc2-a6ee-4716-26ba-08d795b29f50
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4824
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Thursday, January 9, 2020 5:16 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for ptp_kvm.
>=20
> On 2020-01-09 05:45, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Tuesday, January 7, 2020 5:16 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> >> <Justin.He@arm.com>; nd <nd@arm.com>
> >> Subject: Re: [RFC PATCH v9 6/8] psci: Add hvc call service for
> >> ptp_kvm.
> >>
> >> On 2019-12-10 03:40, Jianyong Wu wrote:
> >> > ptp_kvm modules will call hvc to get this service.
> >> > The service offers real time and counter cycle of host for guest.
> >> >
> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > ---
> >> >  include/linux/arm-smccc.h | 12 ++++++++++++
> >> >  virt/kvm/arm/psci.c       | 22 ++++++++++++++++++++++
> >> >  2 files changed, 34 insertions(+)
> >> >
> >> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> >> > index 6f82c87308ed..aafb6bac167d 100644
> >> > --- a/include/linux/arm-smccc.h
> >> > +++ b/include/linux/arm-smccc.h
> >> > @@ -94,6 +94,7 @@
> >> >
> >> >  /* KVM "vendor specific" services */
> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> >> > +#define ARM_SMCCC_KVM_PTP			1
> >> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >> >
> >> > @@ -103,6 +104,17 @@
> >> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >> >
> >> > +/*
> >> > + * This ID used for virtual ptp kvm clock and it will pass second
> >> > value
> >> > + * and nanosecond value of host real time and system counter by
> >> > +vcpu
> >> > + * register to guest.
> >> > + */
> >> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> >> 		\
> >> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> >> 		\
> >> > +			   ARM_SMCCC_SMC_32,
> >> 	\
> >> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> >> 		\
> >> > +			   ARM_SMCCC_KVM_PTP)
> >> > +
> >>
> >> All of this depends on patches that have never need posted to any ML,
> >> and just linger in Will's tree. You need to pick them up and post
> >> them as part of this series so that they can at least be reviewed.
> >>
> > Ok, I will add them next version.
> >
> >> >  #ifndef __ASSEMBLY__
> >> >
> >> >  #include <linux/linkage.h>
> >> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c index
> >> > 0debf49bf259..682d892d6717 100644
> >> > --- a/virt/kvm/arm/psci.c
> >> > +++ b/virt/kvm/arm/psci.c
> >> > @@ -9,6 +9,7 @@
> >> >  #include <linux/kvm_host.h>
> >> >  #include <linux/uaccess.h>
> >> >  #include <linux/wait.h>
> >> > +#include <linux/clocksource_ids.h>
> >> >
> >> >  #include <asm/cputype.h>
> >> >  #include <asm/kvm_emulate.h>
> >> > @@ -389,6 +390,8 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
> >> >
> >> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> >> > +	struct system_time_snapshot systime_snapshot;
> >> > +	u64 cycles;
> >> >  	u32 func_id =3D smccc_get_function(vcpu);
> >> >  	u32 val[4] =3D {};
> >> >  	u32 option;
> >> > @@ -431,6 +434,25 @@ int kvm_hvc_call_handler(struct kvm_vcpu
> *vcpu)
> >> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >> >  		val[0] =3D BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >> >  		break;
> >> > +	/*
> >> > +	 * This will used for virtual ptp kvm clock. three
> >> > +	 * values will be passed back.
> >> > +	 * reg0 stores high 32-bit host ktime;
> >> > +	 * reg1 stores low 32-bit host ktime;
> >> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> >> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
> >>
> >> That's either two or four values, and not three as you claim above.
> >>
> > Sorry, I'm not sure what do you mean "three", the registers here is 4
> > from reg0 to reg3.
>=20
> Please read the comment you have written above...

oh, I see it.

>=20
> >> Also, I fail to understand the meaning of the host cycle vs cntvoff
> >> comparison.
> >> This is something that guest can perform on its own (it has access to
> >> both physical and virtual timers, and can compute cntvoff without
> >> intervention of the hypervisor).
> >>
> > To keep consistency and precision, clock time and counter cycle must
> > captured at the same time. It will perform at ktime_get_snapshot.
>=20
> Fair enough. It would vertainly help if you documented it. It would also =
help if
> you explained why it is so much worse to read the counter in the guest
> before *and* after the call, and assume that the clock time read happened
> right in the middle?
>=20
ok, I will give explain in comments.

> That aside, what you are returning is something that *looks* like the vir=
tual
> counter. What if the guest is using the physical counter, which is likely=
 to be
> the case with nested virt? Do you expect the guest to always use the virt=
ual
> counter? This isn't going to fly.

To be honest, I have little knowledge of nested virtualization for arm and =
I'm confused with that
guest'guest will use physical counter.

IMO, ptp_kvm will call hvc to trap to its hypervisor adjacent to it. So gue=
st'guest will trap to hypervisor in guest and will
get guest's counter cycle then calculate guest'guest's counter cycle by som=
ething like offset to sync time with it. So only if the
guest's hypervisor can calculate the guest'guest's counter value, can ptp_k=
vm works.

the implementation of calculating the return value of counter cycle vary wi=
th the way deriving counter cycle from hypervisor to guest.

If considering nested virt here, we need the basic knowledge of how guest'g=
uest's counter cycle is calculated from its hypervisor and how to determine=
=20
we are in guest's hypervisor or guest'guest's hypervisor.
If it is the case, can you give me some knowledge, something like a documen=
t, about that?

>=20
> >> Finally, how does it work with nested virt, where cntvoff is for the
> >> the vEL2 guest?
> >>
> > For now, I have not considered ptp_kvm in nested virtualization. Also
> > I'm not sure about if nested virtualization is ready on arm64 , as I
> > need test ptp_kvm on it. If so, I can consider it.
>=20
> It is not about testing. It is about taking the architecture into account=
.
> And ready or not doesn't come into play here. What you're defining here i=
s
> an ABI, and it better be totally future proof.
>=20
Yeah, should included it in design.

> But if you want to test, help yourself to [1] and have fun!
> >
Thanks

> >> > +	 */
> >> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> >> > +		ktime_get_snapshot(&systime_snapshot);
> >> > +		if (systime_snapshot.cs_id !=3D CSID_ARM_ARCH_COUNTER)
> >> > +			return kvm_psci_call(vcpu);
> >>
> >> What does this mean? Calling PSCI because you've failed to identify
> >> the clock source? What result do you expect from this? Hint: this
> >> isn't a PSCI call.
> >>
> > Sorry, what I want to do here is that return to guest with the error
> > info.
> > Maybe I should set val[0] to -1 and break to let the guest know that
> > error comes, as the guest will check if val[0] is positive to
> > determine the next step.
>=20
> What you should do is handle it like a normal SMCCC failure.
>=20
Yeah, I will fix it.

Thanks
Jianyong=20

>          M.
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-
> platforms.git/log/?h=3Dkvm-arm64/nv-5.5-rc4-WIP
> --
> Jazz is not dead. It just smells funny...
