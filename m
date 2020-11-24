Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060BD2C1D52
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 06:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgKXFVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 00:21:07 -0500
Received: from mail-eopbgr20082.outbound.protection.outlook.com ([40.107.2.82]:41956
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbgKXFVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 00:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6du2o7rWvA6djQN2aRcu2gznOAcUgE1pdRlgFaX7kY=;
 b=IngAmwmK5KWDURXra+wZJqRXfHRxgDO7/bipEnijOexohISt3MesALz30/2MbeUHZF8ZiA7iU5twD6XT/vanRlLV21RRZlfiZ9aYAeBq6eRfiHx3NybKz+c4YSOZtr7cKArA+ZC5jrki21RVU2O44/nuNIbTK26ayI6uBVDIii4=
Received: from MR2P264CA0171.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::10) by
 HE1PR0801MB1691.eurprd08.prod.outlook.com (2603:10a6:3:7b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Tue, 24 Nov 2020 05:20:57 +0000
Received: from VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:501:0:cafe::7c) by MR2P264CA0171.outlook.office365.com
 (2603:10a6:501::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:20:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT013.mail.protection.outlook.com (10.152.19.37) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:20:56 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71"); Tue, 24 Nov 2020 05:20:55 +0000
X-CR-MTA-TID: 64aa7808
Received: from ad22e5ee345a.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 48495EDA-1374-4109-9F36-1E4733E3B596.1;
        Tue, 24 Nov 2020 05:20:50 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ad22e5ee345a.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 24 Nov 2020 05:20:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StPA14REhadGBrJxWkUk9YXlGOObcOc9w+WKRIlMaepFJ69tAOD6f0WiJJcGNgd81lTlud2AG5HRyCLCGcrgdMZJc+29rlVp1kraxskNL3oQI7PksLr3rMfWQ2BZIpIOBcWxsha+uI6ji1fhKO/8EhJsOXFhYvnaQHhQ7eV1Vejv7jwaOGobGywoYpB2UwUyzK6W9HF8YUqxnYVT+HGZ07E1QD94aPZo4IL5YFf8ZsvGhPwWIQDYle7K3FaevqZaouDH4hJRMV+SN62oWM498Q1vXlOslCDB0PfJ87/l68R1tJqr6erPgAUgg+OKk5tVowzPkEEItvPEeTJSsIkRTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6du2o7rWvA6djQN2aRcu2gznOAcUgE1pdRlgFaX7kY=;
 b=f81LqXQNGAG5StV+yR4HBGvff6zwiZDC/Q3IxI+SoW0yRX78sNa4DozQ+fOLKCI6QzkqEJn2Ia8PTj9Rkk853lQf1mJqNqlGre+UdF94lkCzdWyO+sNNmtj9abNsZQAHKOGq3Dq8h4p/+QXHIL3IVsmMW8Gzrl9aGZpChtUupPXumJRdhrBUMLZM+kFSkNiNDX2r3zraMDW6vRkpUOyST+2SC8DQRPp38FwrpBHDlb9V0yB2gisCETuGYKjV6YSZwGcAr1nzBm41vpo2/CY4sBXZnHfYy3Xgzrd2TwMWtmVQex7qudxKm0m3a9o92xPcp4WAthdM/vWohJnoFyGzQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6du2o7rWvA6djQN2aRcu2gznOAcUgE1pdRlgFaX7kY=;
 b=IngAmwmK5KWDURXra+wZJqRXfHRxgDO7/bipEnijOexohISt3MesALz30/2MbeUHZF8ZiA7iU5twD6XT/vanRlLV21RRZlfiZ9aYAeBq6eRfiHx3NybKz+c4YSOZtr7cKArA+ZC5jrki21RVU2O44/nuNIbTK26ayI6uBVDIii4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2250.eurprd08.prod.outlook.com (2603:10a6:3:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 05:20:46 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:20:46 +0000
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
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <Steven.Price@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWt/MyY3F2SxWQTkCP3WjcSZqyYKnVm0IAgAE1lUA=
Date:   Tue, 24 Nov 2020 05:20:46 +0000
Message-ID: <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
In-Reply-To: <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 353105F801D2DE49B6134BA89F0FD244.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4e405d76-2f04-47c0-89f9-08d89038b8ab
x-ms-traffictypediagnostic: HE1PR0802MB2250:|HE1PR0801MB1691:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0801MB1691CCB5554BE6FAFFC2ED4DF4FB0@HE1PR0801MB1691.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2449;OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: UdZK98CkLLayKlva/06G8KhR4w8zr3+zA6bV6PIZCoegdbsK5YOxEmzL08ZCmZxi7gVm3D2V+AjWcMCez9qS4GlF9ve22WtF+bWKirbk7cRTrO8XiW1sxAqXTqT10ZMFha88YWkH79g8TEO3Kz7s2CzNEkXnCNk0iWv4TO57QsMSaEEZbShLqUUdl6ZH9LhRRqX6hl82BWS32U/8AscL6qmU2AEYE0grxPb6sk16i4h5KNlm7CsErLe/elYHWXWI8/A8KK3UzSOHSG3sudekB0OolwB54XTpOFMQkdrsuF9j5F7zEKfw7C7zPpgrhQ4aJVafcyQ6IkhallIVmD2qow==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(478600001)(8676002)(71200400001)(54906003)(6506007)(53546011)(316002)(186003)(33656002)(8936002)(52536014)(55016002)(5660300002)(9686003)(83380400001)(26005)(7696005)(7416002)(66446008)(6916009)(66476007)(64756008)(4001150100001)(66946007)(66556008)(4326008)(2906002)(86362001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FrF7zQfnUZYVDKkAot9fp2JLt4WHj0kskO7a6lidurT9twOTLa0Yc2WYSJqFZy+g5rKplIuCCdw/kkkD/Wc4G2yECTBCiD/gvEFBJjoIWoKsrB2hUURep0o87pN/aRRdW8WccVodsk1g1kYP77sURtxm9MLt6EoNlnBVZVSVEMiEjApbIRXh0zme3cXz8znOS7t0793WKkZFYVhZMBVdy7r7pRJ71sapBheaZ5fO+gxUE3rQOjhZqdThQBXx8xK9lASelDeV+Bu7/CAGq+ngee7H6O7K029s6kcOjMy7VbFmKXf4gYStd9NyL1/gBmRHshRMG9tJl3ZN5hFQUkQHwpRCujun8dpsCJ1Woxco0xlWeMXDgkqdCdEuir2QThBlb3cNdgMCvaRydlkbkSCr+IZiY6kGaox6W8QLWgV3viUfXKZ/MwnIVqwP+ASfjlM8JUFCh4/6PfvphJCa4sArvVZ3uFlYNr2lMInZdJVC9qdTHt5PzJlx2apbMMYo4kcOJYvZcjU7SwvrtHUc4eGplaSbwyDuFlUrPmV6av7blKZpprOvqonBDIeHpzjfDnJgF2frVoHj5jjIJdLe4nKtC78kKsT1OeByB1UZb3JRth1Q/o10dXBB1lh5sHVbUl+vtmrMcGRCD0DQiFun1+u0KW/rbkr1QTAqnyQmHQ9p1AAsPCl5FDYWAxlvGlplzRFf/ORKZCNp5kNJgUCvqrqI98PGoeQAHoq2cAFpWNiZB2iPHQaS42XpLj0vpMVQs6tbl64c1BbVPKkQNsQTtQKV03gdh6cbZCJK5wA44Mpg/I5D/1YuLXDr4v2/AvIIQHk+pX76dJYpZHAMc8gXlTw5PU2SlEGEzqMXNN8Am9J62pAi1Ux+dxYc4RD/riPeHcihnu1Pyi3Oq8D+dzNqZha1Qw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2250
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8c36b3c0-0be3-4c8b-83f6-08d89038b2d3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 89TlUtGrnFqJBo2wVKwzhEvb9WZpYroe9sk584peAgqynBN0Ib7CWnI15//Eyw9USkCD+JD3Fp/eyL6PtUg6lTYa1RQ8gxFTvU/tcrnzIDgB0sZYNfB23S1hVLU4pNT38cp9bFJ5gC0UehWi07HACgHXDYarXhP8pBTUl5XmZa30EflEldDZdrLObVHFsTNfr46Z7ZwjZ+sZhePuItKO55pauZTtropNu65eeofTLRjnOuY3MDw/zOkOyNxoCdDGTyF+GGr2MYNK7leuR1RNvxBRryihEwz8K18PiriCgcTqvAaAUTQhoXdwg91KJgQq6MnOPAbGMGVumN4ZPClKZ4nhCjkVT2sK3S2Yk2Y52EnZ6zk1ohdSmKN+SYfg7L/KMeFjkX8hnZSjD+cQZgwBqw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(46966005)(4326008)(478600001)(70206006)(70586007)(9686003)(450100002)(82740400003)(82310400003)(47076004)(2906002)(55016002)(6862004)(356005)(81166007)(7696005)(54906003)(5660300002)(336012)(316002)(86362001)(83380400001)(33656002)(6506007)(53546011)(8936002)(52536014)(8676002)(26005)(186003)(4001150100001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:20:56.1584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e405d76-2f04-47c0-89f9-08d89038b8ab
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1691
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, November 23, 2020 6:44 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Andre
> Przywara <Andre.Przywara@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v15 6/9] arm64/kvm: Add hypercall service for kvm ptp=
.
>=20
> On 2020-11-11 06:22, Jianyong Wu wrote:
> > ptp_kvm will get this service through SMCC call.
> > The service offers wall time and cycle count of host to guest.
> > The caller must specify whether they want the host cycle count or the
> > difference between host cycle count and cntvoff.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/hypercalls.c | 61
> +++++++++++++++++++++++++++++++++++++
> >  include/linux/arm-smccc.h   | 17 +++++++++++
> >  2 files changed, 78 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index b9d8607083eb..f7d189563f3d 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -9,6 +9,51 @@
> >  #include <kvm/arm_hypercalls.h>
> >  #include <kvm/arm_psci.h>
> >
> > +static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val) {
> > +	struct system_time_snapshot systime_snapshot;
> > +	u64 cycles =3D ~0UL;
> > +	u32 feature;
> > +
> > +	/*
> > +	 * system time and counter value must captured in the same
> > +	 * time to keep consistency and precision.
> > +	 */
> > +	ktime_get_snapshot(&systime_snapshot);
> > +
> > +	// binding ptp_kvm clocksource to arm_arch_counter
> > +	if (systime_snapshot.cs_id !=3D CSID_ARM_ARCH_COUNTER)
> > +		return;
> > +
> > +	val[0] =3D upper_32_bits(systime_snapshot.real);
> > +	val[1] =3D lower_32_bits(systime_snapshot.real);
>=20
> What is the endianness of these values? I can't see it defined anywhere, =
and
> this is likely not to work if guest and hypervisor don't align.
>=20
> > +
> > +	/*
> > +	 * which of virtual counter or physical counter being
> > +	 * asked for is decided by the r1 value of SMCCC
> > +	 * call. If no invalid r1 value offered, default cycle
> > +	 * value(-1) will be returned.
> > +	 * Note: keep in mind that feature is u32 and smccc_get_arg1
> > +	 * will return u64, so need auto cast here.
> > +	 */
> > +	feature =3D smccc_get_arg1(vcpu);
> > +	switch (feature) {
> > +	case ARM_PTP_VIRT_COUNTER:
> > +		cycles =3D systime_snapshot.cycles - vcpu_read_sys_reg(vcpu,
> > CNTVOFF_EL2);
> > +		break;
> > +	case ARM_PTP_PHY_COUNTER:
> > +		cycles =3D systime_snapshot.cycles;
> > +		break;
> > +	case ARM_PTP_NONE_COUNTER:
>=20
> What is this "NONE" counter?

Yeah, there is no counter named "NONE". this is not a counter, and only mea=
ns no counter data needed for guest and just do nothing.
If no this arm here, it will go to the default one and return "NOT_SUPPORTE=
D"

>=20
> > +		break;
> > +	default:
> > +		val[0] =3D SMCCC_RET_NOT_SUPPORTED;
> > +		break;
> > +	}
> > +	val[2] =3D upper_32_bits(cycles);
> > +	val[3] =3D lower_32_bits(cycles);
>=20
> Same problem as above.
>=20
> > +}
> > +
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> >  	u32 func_id =3D smccc_get_function(vcpu); @@ -79,6 +124,22 @@ int
> > kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  		break;
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >  		val[0] =3D BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > +		val[0] |=3D BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
> > +		break;
> > +	/*
> > +	 * This serves virtual kvm_ptp.
> > +	 * Four values will be passed back.
> > +	 * reg0 stores high 32-bits of host ktime;
> > +	 * reg1 stores low 32-bits of host ktime;
> > +	 * For ARM_PTP_VIRT_COUNTER:
> > +	 * reg2 stores high 32-bits of difference of host cycles and cntvoff;
> > +	 * reg3 stores low 32-bits of difference of host cycles and cntvoff.
> > +	 * For ARM_PTP_PHY_COUNTER:
> > +	 * reg2 stores the high 32-bits of host cycles;
> > +	 * reg3 stores the low 32-bits of host cycles.
> > +	 */
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +		kvm_ptp_get_time(vcpu, val);
> >  		break;
> >  	default:
> >  		return kvm_psci_call(vcpu);
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index d75408141137..a03c5dd409d3 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -103,6 +103,7 @@
> >
> >  /* KVM "vendor specific" services */
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
>=20
> I think having KVM once in the name is enough.
>=20
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -114,6 +115,22 @@
> >
> >  #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
> >
> > +/*
> > + * ptp_kvm is a feature used for time sync between vm and host.
> > + * ptp_kvm module in guest kernel will get service from host using
> > + * this hypercall ID.
> > + */
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID
> 		\
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 		\
> > +			   ARM_SMCCC_SMC_32,
> 	\
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> > +
> > +/* ptp_kvm counter type ID */
> > +#define ARM_PTP_VIRT_COUNTER			0
> > +#define ARM_PTP_PHY_COUNTER			1
> > +#define ARM_PTP_NONE_COUNTER			2
>=20
> The architecture definitely doesn't have this last counter.

Yeah, this is just represent no counter data needed from guest.
Some annotation should be added here.

Thanks
Jianyong

>=20
> > +
> >  /* Paravirtualised time calls (defined by ARM DEN0057A) */
> >  #define ARM_SMCCC_HV_PV_TIME_FEATURES
> 	\
> >  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 	\
>=20
> Thanks,
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
