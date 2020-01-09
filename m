Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF9221352D1
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 06:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgAIFqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 00:46:01 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:7391
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgAIFqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 00:46:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7iLiJpHBCJE0HnGmYjGoIrJigbzqr/53g/pQ5w3TkQ=;
 b=sIQi0TBj89V4T4WRsrlowg0kNYEFqG+dPVLzygtl+uiOgRM83nZq7pLP5cy0Rspf48ZYaK5Mvsw6sXidbF9WvtVb6sNeoXSPQ0y7Lw/g4Jyvb4Z6gPFKDaPT0DcAoBi0lVheTg8vZn4Xy1RfQInu4o4AvVyWfwj2Tr58XnK2E2A=
Received: from VI1PR08CA0225.eurprd08.prod.outlook.com (2603:10a6:802:15::34)
 by VI1PR0801MB1744.eurprd08.prod.outlook.com (2603:10a6:800:5c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11; Thu, 9 Jan
 2020 05:45:51 +0000
Received: from DB5EUR03FT019.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::209) by VI1PR08CA0225.outlook.office365.com
 (2603:10a6:802:15::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.8 via Frontend
 Transport; Thu, 9 Jan 2020 05:45:51 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT019.mail.protection.outlook.com (10.152.20.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Thu, 9 Jan 2020 05:45:51 +0000
Received: ("Tessian outbound e09e55c05044:v40"); Thu, 09 Jan 2020 05:45:50 +0000
X-CR-MTA-TID: 64aa7808
Received: from baa23648147e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A70A0D8F-4803-4290-9B30-C2D80ADC7164.1;
        Thu, 09 Jan 2020 05:45:45 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id baa23648147e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 09 Jan 2020 05:45:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WN3RVYnR+1EYTFM//6Bj+D3On9ivyUp7Ibfq8QNqTRJCH0rz5S/RAJGeQM1nReXbC9u2pMnLRT6lDBRpIKxW8C7bCfMEvYREaTRCYNc1fh6CmR2diiCB0X9LJsMk7mBuFVD2ruaalYCiW/BSNFALDwvbiNAetUZ/DXdQ7emVJ3pFrhQMF9Rqnwjs1tbKlGQS+K0IHdcKHiHxqGhPr6UvlexY2yuLh0uvt7lKK9N7DgN9N92bieBq4MC/m62GKZTe9QrR4X0dZuxJyIm54lHymDC/Y6In9mEhtVnuXccGbsvf0fdYM5i1IBfebk/D1Mh44YRNF6cI6MEOYeHRdcGpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7iLiJpHBCJE0HnGmYjGoIrJigbzqr/53g/pQ5w3TkQ=;
 b=d49qWT9/j5MmBRAyKbZCuF9pbJRGs30EHuMnAmWlivlEgrdTncJq49ZPRW+B/5c9XjLqKLKjT3QhcINbz8Up6XW3SZ0/OI39r5nmel4g/Q1qN8YFX/eV2f8PwTrPO1BThbT0jA8tiPj25yD3mgc0m3F/eRXujQUP1Pcm9ozohumqaLmwGYHj9Vz/U3nzP9Qr568x/kZBBbsJkO+xUpb0CbouDLRq/rGhIsVKP9i1TAuL4IPLYQxGmXkwg8lcyYCj61TXt/Vvka39pjAFe9D7ZjnVaVB6cZQ+8nIgJY2Z3Ca/WXgrNapEayp2Si1vJ3lBiqrIizE21uYe62HymvMEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7iLiJpHBCJE0HnGmYjGoIrJigbzqr/53g/pQ5w3TkQ=;
 b=sIQi0TBj89V4T4WRsrlowg0kNYEFqG+dPVLzygtl+uiOgRM83nZq7pLP5cy0Rspf48ZYaK5Mvsw6sXidbF9WvtVb6sNeoXSPQ0y7Lw/g4Jyvb4Z6gPFKDaPT0DcAoBi0lVheTg8vZn4Xy1RfQInu4o4AvVyWfwj2Tr58XnK2E2A=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1692.eurprd08.prod.outlook.com (10.168.148.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Thu, 9 Jan 2020 05:45:41 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2602.018; Thu, 9 Jan 2020
 05:45:41 +0000
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
Thread-Index: AQHVrwuxR+1ZEaCriEa+CGCL3lP4K6ffGBkAgALhg9A=
Date:   Thu, 9 Jan 2020 05:45:40 +0000
Message-ID: <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
In-Reply-To: <7383dc06897bba253f174cd21a19b5c0@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 86cbdfd4-7a49-4f0e-b04b-a1437558a46e.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8cefe0b0-c554-4e57-43fb-08d794c72f6a
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1692:|HE1PR0801MB1692:|VI1PR0801MB1744:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0801MB17440E5FF848C586C491E704F4390@VI1PR0801MB1744.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:4502;OLM:4502;
x-forefront-prvs: 02778BF158
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(13464003)(189003)(199004)(55016002)(7696005)(6916009)(9686003)(4326008)(55236004)(7416002)(186003)(6506007)(53546011)(4001150100001)(5660300002)(8676002)(26005)(2906002)(52536014)(478600001)(76116006)(66446008)(66476007)(86362001)(66556008)(33656002)(54906003)(64756008)(66946007)(81156014)(8936002)(71200400001)(316002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1692;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: BJUhHduHHsUPntu98UORhvl3/qR3i01uO5qLBPC93MlgelZElZ/YSpJMUg63NmBgPwGft1smK5FvRO8/zQhHX1EDsgcDF1Sr3FaXTEUD9gYvAFpmY8NbRlOUMSy1hE2PYvJkJij0X5PROxKrspVKaTuOTLtWC3A/fWbA3Dmv9boTv7a19WIawTQgHTpxnCwQ8k5UqDikDQzc/c7GW9YQy2Yy/NvzH5nrZkq+VYc/1MZxMYS6sjUsSmA+Fc82MldCy+iOyyRFeezuyScp06b5jlvgeST7K14sKbZKUHsCAMYKYufMVu1ClhCbQpd2TSOstG/VHlg1ZkRTuf8jXz/KFwJF6RPHQQ5RqWe/pkIDwHNdOZrkcz6zvBSkcY1Qt/tsmmTZH+nvQNFISjmst4AlMfetHtvnJ3kGtM/JIf86OZwSlzN2M0/P90I2rAD1C9DtL2Qx5H6eRnofg6frknCGR05Jw8OqAaHdXKkr9NMyq/40M2wSZ305PmJBca7g0Br3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1692
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT019.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(199004)(189003)(13464003)(316002)(70206006)(70586007)(54906003)(81166006)(53546011)(6506007)(7696005)(81156014)(8936002)(8676002)(33656002)(186003)(2906002)(356004)(5660300002)(450100002)(9686003)(55016002)(86362001)(4326008)(26005)(4001150100001)(478600001)(6862004)(52536014)(336012)(26826003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0801MB1744;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: ab5211e5-2aef-43e4-535b-08d794c729a7
X-Forefront-PRVS: 02778BF158
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GoSLi2An1G65O7FB0SSEp860hq3IYXO3HdaluASp+X9fytwConh7wMZyg6m4/syMUdxaHh8e8RpzoOXCPpURv3g4KDq2e7fYdnLpzYq3xTBSub9Jvd+tJRiqmP+Ra8qUR8monFeWZF5rPEAw4x1sMbpQvdH2Tlw/WGTl8O/jJbgzUVCkIM35FN3Hgprp4Hr5O01KRF9D1Otm6TYQnkr2aIGcQh2ATawl7l4ItmPVLfUX5FFDEX7phRlokusYa9J3MyBQ451m9hnBP1LjZAMZgCFh8c1ANlGKgA6LaBuE3SkirHOLhSXqykL96XV7pnYTdQxwXP9Xl8HkAk32FTDdu79FEpmJnTdUr1aYiPYieiq3vgFKGUvtmpdAba/5Xnb1vBCo7kzDU5v6C9tAiKOeRiFduDB0hmXXZPanFjI65JELSeeTUkmsVcnlWakUgtl5A0jjnWnRl7JlmWdD7T3aAbtyc6/kiQmlQ5CwlMpH14PhTLyxEphhdrmOdUMhQWv4
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2020 05:45:51.0179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cefe0b0-c554-4e57-43fb-08d794c72f6a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Tuesday, January 7, 2020 5:16 PM
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
> On 2019-12-10 03:40, Jianyong Wu wrote:
> > ptp_kvm modules will call hvc to get this service.
> > The service offers real time and counter cycle of host for guest.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  include/linux/arm-smccc.h | 12 ++++++++++++
> >  virt/kvm/arm/psci.c       | 22 ++++++++++++++++++++++
> >  2 files changed, 34 insertions(+)
> >
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 6f82c87308ed..aafb6bac167d 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -94,6 +94,7 @@
> >
> >  /* KVM "vendor specific" services */
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_PTP			1
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -103,6 +104,17 @@
> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >
> > +/*
> > + * This ID used for virtual ptp kvm clock and it will pass second
> > value
> > + * and nanosecond value of host real time and system counter by vcpu
> > + * register to guest.
> > + */
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> 		\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_PTP)
> > +
>=20
> All of this depends on patches that have never need posted to any ML, and
> just linger in Will's tree. You need to pick them up and post them as par=
t of
> this series so that they can at least be reviewed.
>=20
Ok, I will add them next version.

> >  #ifndef __ASSEMBLY__
> >
> >  #include <linux/linkage.h>
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c index
> > 0debf49bf259..682d892d6717 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/kvm_host.h>
> >  #include <linux/uaccess.h>
> >  #include <linux/wait.h>
> > +#include <linux/clocksource_ids.h>
> >
> >  #include <asm/cputype.h>
> >  #include <asm/kvm_emulate.h>
> > @@ -389,6 +390,8 @@ static int kvm_psci_call(struct kvm_vcpu *vcpu)
> >
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > +	struct system_time_snapshot systime_snapshot;
> > +	u64 cycles;
> >  	u32 func_id =3D smccc_get_function(vcpu);
> >  	u32 val[4] =3D {};
> >  	u32 option;
> > @@ -431,6 +434,25 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >  		val[0] =3D BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> >  		break;
> > +	/*
> > +	 * This will used for virtual ptp kvm clock. three
> > +	 * values will be passed back.
> > +	 * reg0 stores high 32-bit host ktime;
> > +	 * reg1 stores low 32-bit host ktime;
> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
>=20
> That's either two or four values, and not three as you claim above.
>=20
Sorry, I'm not sure what do you mean "three", the registers here is 4 from =
reg0 to reg3.

> Also, I fail to understand the meaning of the host cycle vs cntvoff compa=
rison.
> This is something that guest can perform on its own (it has access to bot=
h
> physical and virtual timers, and can compute cntvoff without intervention=
 of
> the hypervisor).
>=20
To keep consistency and precision, clock time and counter cycle must captur=
ed at the same time.=20
It will perform at ktime_get_snapshot.

> Finally, how does it work with nested virt, where cntvoff is for the the =
vEL2
> guest?
>=20
For now, I have not considered ptp_kvm in nested virtualization. Also I'm n=
ot sure about if nested virtualization is
ready on arm64 , as I need test ptp_kvm on it. If so, I can consider it.

> > +	 */
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +		ktime_get_snapshot(&systime_snapshot);
> > +		if (systime_snapshot.cs_id !=3D CSID_ARM_ARCH_COUNTER)
> > +			return kvm_psci_call(vcpu);
>=20
> What does this mean? Calling PSCI because you've failed to identify the c=
lock
> source? What result do you expect from this? Hint: this isn't a PSCI call=
.
>=20
Sorry, what I want to do here is that return to guest with the error info.
Maybe I should set val[0] to -1 and break to let the guest know that error =
comes, as
the guest will check if val[0] is positive to determine the next step.

> Cosmetic comments below:
>=20
> > +		val[0] =3D systime_snapshot.real >> 32;
>=20
> val[0] =3D upper_32_bits(systime_snapshot.real);
Ok
>=20
> > +		val[1] =3D systime_snapshot.real << 32 >> 32;
>=20
> val[1] =3D lower_32_bits(systime_snapshot.real);
>=20
Yeah

> > +		cycles =3D systime_snapshot.cycles -
> > +			 vcpu_vtimer(vcpu)->cntvoff;
>=20
> On a single line please.
>
ok
=20
> > +		val[2] =3D cycles >> 32;
> > +		val[3] =3D cycles << 32 >> 32;
>=20
> Same as above.
>=20
yeah
> > +		break;
> >  	default:
> >  		return kvm_psci_call(vcpu);
> >  	}
>=20

Thanks
Jianyong

> Thanks,
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
