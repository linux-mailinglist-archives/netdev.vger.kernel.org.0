Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B4E25F4BA
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 10:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgIGIMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 04:12:15 -0400
Received: from mail-am6eur05on2085.outbound.protection.outlook.com ([40.107.22.85]:41063
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727973AbgIGIKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 04:10:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=AqsqDy/4r7XI38pqKDkfk4mBEURFY4+WhzgrCrVlCHHasG7BKn7CC1hfjPqwukDF15l9bYJ4pL0sbLkWGQfal5f+zhU7CJn1c2TrmK9lJzKNAfqfZQJaMiJipSjeWPpORyDPOE0lJfTM56VvvBSNwr7WkIk40TSPkXawOSa4oUs=
Received: from AM6PR04CA0016.eurprd04.prod.outlook.com (2603:10a6:20b:92::29)
 by AM6PR08MB3717.eurprd08.prod.outlook.com (2603:10a6:20b:8e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:10:33 +0000
Received: from VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:92:cafe::f0) by AM6PR04CA0016.outlook.office365.com
 (2603:10a6:20b:92::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend
 Transport; Mon, 7 Sep 2020 08:10:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT036.mail.protection.outlook.com (10.152.19.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 08:10:32 +0000
Received: ("Tessian outbound a0bffebca527:v64"); Mon, 07 Sep 2020 08:10:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from af51c5d0360e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D6925066-E116-4384-B3C3-B77A11220064.1;
        Mon, 07 Sep 2020 08:10:27 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id af51c5d0360e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 07 Sep 2020 08:10:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzbN8fzi44U//3u4TLCL/F2yT+lFFCgtb69Qn0ECUCruKZ3+GSvg6wJgIVNGYN8D6F+E9sktzzVFJe/m45L8f37MuFR+DGZmemMDi1ylWhxHDZ3BB6pto1XSinEdH820wa3zYREUxLNSM+8zCJMpF+ZMtXUnDJ2kpXLF8t4USxsMZWW0ORY1dakiQIUD3EAyLGFTcLbGGHLX1f0kVrTq+R6Ne6ZQl3sikxCdguWIhjHnxYwV6FGgmv2ezMFCEofnH5HnbLii3DkbAb+vmDkWJlcRgQXVIaW0apijoopM+1t2qfFR4mkvnU2g29cpPSZnO2qpYSiYhpSvBQbjO/b2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=e47jHGeM9fiefV+WsSISBwXwzGOpKHwE+bIpAbVFpm9t04RV1vRnoPN6DJwpMvNNIju9ukd63I8fwJlbcY3tUJIzsJLohn5AXrUrr684q0SZgSpAwR6dzTKLHj/ZDwOR3JfM5aWP7y0Hcs6ld0s7sm5h2aUaDDBlqT7s0XOlFnY8xZtFoBwEzOhEJKff65W5pNiaKEc7P8KwUJzuJZWArpYHj3v85xejV2Dk17T816Fj6AT4pootMHSQBAOJQnMk4HTfISztS3GejQ7at6vPxWbVom/35PeVaGWAKJoDNuTc09+sCs748if5QvjJ2lHhwCq0/ltTe5rdwWc2VMozYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbomYQuq98mdC7txqyvr2DAMeVh5dYTdY3ezixIenMI=;
 b=AqsqDy/4r7XI38pqKDkfk4mBEURFY4+WhzgrCrVlCHHasG7BKn7CC1hfjPqwukDF15l9bYJ4pL0sbLkWGQfal5f+zhU7CJn1c2TrmK9lJzKNAfqfZQJaMiJipSjeWPpORyDPOE0lJfTM56VvvBSNwr7WkIk40TSPkXawOSa4oUs=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2442.eurprd08.prod.outlook.com (2603:10a6:3:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 08:10:18 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 08:10:18 +0000
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
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Topic: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Thread-Index: AQHWgp30ocMxzsQpy0OAzPdSdzfgH6lYp9iAgAQrilA=
Date:   Mon, 7 Sep 2020 08:10:18 +0000
Message-ID: <HE1PR0802MB2555626C7B115C88306B429FF4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
        <20200904092744.167655-8-jianyong.wu@arm.com> <87eenhr01m.wl-maz@kernel.org>
In-Reply-To: <87eenhr01m.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A2BE30E98BBD6D418036B19794D502EF.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 889f11e1-7898-4e41-da34-08d853057de7
x-ms-traffictypediagnostic: HE1PR0802MB2442:|AM6PR08MB3717:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3717F6C25C843FA151174E2CF4280@AM6PR08MB3717.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: ywRKWk7uiAUkFPO2s5VhtohUKxWh5YdS2DYkYNZmD9NUcDKBluqMKcyZMe7MKpkdn9oojXbxiGnsgHQRJistTsbTj7x+xNlBcEqI9L6wbaL/agBHAVRuvnRUk+0VL/GzP52aYEYiN7PDdNE7uiwkJt9+yiYcaVW3UK9nrKsdZIbIxYa9GV3ZHolXJSILnpCur5AHZ8BkNOtx8OTTn5pQH4NKYe9ptqxDy2/zkNLL0b9BRBlFnJCJCKcUf4MMTBhB1vKRgnKhOVcKkqP5ToiFw2sI0U4tvPAR5CZSPG8x0IWMXzBTAVE+6TNVXGyc2CkWjpCyXqheBr64yp6U1y9Pkg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(7696005)(52536014)(8936002)(4326008)(66946007)(5660300002)(2906002)(71200400001)(54906003)(478600001)(26005)(76116006)(53546011)(86362001)(64756008)(66556008)(186003)(66476007)(9686003)(55016002)(66446008)(8676002)(316002)(6506007)(83380400001)(33656002)(7416002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qIZKKepTx5jqp7uMdXlJUyn9H6HWwEJWXzpTL0+RnHM+/3kZXMVeFuxK1xEdpOwCXn9JBwXvrWRRNDsJRq2ELxSPgchpwrMuRiGmpTH02qgNtpmPLTf3/iQ777hYuiyk6sETdZ6NbvdEwTsdHzMDulSVVI7fuaXXA7S0C35YfzcIj3KuvJzXRi69dq9Hag6Y48MRcuJ7pgGrd8Cx5x95CYsUVQnyzTUraNdJf3PaElAesANGNGf7ZyfxV8WBkrTer5J5MMXsXiQ9aXi74Gak+8/Do/vXTWoTwmd4Q6zHYzpShNgjAEo1PXgiDT6zTFx7AvRJF8cD5EtfM/vIdJmAioYoZJiPnLadnKmKuxU0DMJ57KuRyFZUEiY3x6VsNEe9CJJYfhIcLFIIw+absu6SXAheynGZAUQIWCcbywpqms6u6+ag1IxG6N2TNlNRbTO40PpNOLUyi7Z/IBz12OqVSoUj6DaU61/QLv2ICFCgAp/ycrbBfxB9D4VY4vC086aaUAvHaC1yuqYHg25WkOWRxa5+D7RRAE5x+Ew3IobEV0I81qjCWWN0qxcb+O1hSt6NwWS5o/bQVU9+bUto3UKSXJbvstXSO88MMIUvZMYCu4t2LnFpMZ4dDziUc/fChvRieV0avMVzy9mHmfKAZWU1Ew==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2442
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: d743de07-a622-4e19-18aa-08d8530575ca
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2iarKFF2G4m/Y3n0U34GUPcNM8IR3x7asi8I4uw0hbPjrraGoSIM0g5TmuMFl+/BAMCvd/xQNI6GMgZXAlQ6UYTnzpybt3KGJajK5fnvPmIpByHfNzhCiSlUD83Caw8eJdY63poJm8npwj+wzuZZSxkBCSD5jkwP/wl383Ac67f9tlzG8axsTFeiVb7wII3N8n9V5Kxr8yJqDQbHefl996xUON2wPeiB/CgyFcPBNWUK8/Y25NUryg1shFoRQ0Rd5J2aDpbYk21SipNXbdZCy4Ly2d1kI7j83A+MAOAPme0s12/YV5+B9lMans2VB6mHnmrhCe+WyKaNFXHC5vvcCwLyDtfSAHUTQ5mrqT2RfnLrTrcKVDpcG+gHnnjnRw5Ny0Pead1THCsh92aXn5kXNA==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966005)(9686003)(82310400003)(8936002)(2906002)(26005)(53546011)(356005)(8676002)(83380400001)(86362001)(55016002)(6506007)(186003)(336012)(33656002)(81166007)(6862004)(450100002)(36906005)(4326008)(316002)(54906003)(52536014)(70206006)(70586007)(47076004)(5660300002)(82740400003)(7696005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 08:10:32.2974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 889f11e1-7898-4e41-da34-08d853057de7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT036.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 5, 2020 12:15 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm
> ptp.
>=20
> On Fri, 04 Sep 2020 10:27:41 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > ptp_kvm will get this service through smccc call.
> > The service offers wall time and counter cycle of host for guest.
> > caller must explicitly determines which cycle of virtual counter or
> > physical counter to return if it needs counter cycle.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  arch/arm64/kvm/Kconfig       |  6 +++++
> >  arch/arm64/kvm/arch_timer.c  |  2 +-
> >  arch/arm64/kvm/hypercalls.c  | 49
> > ++++++++++++++++++++++++++++++++++++
> >  include/kvm/arm_arch_timer.h |  1 +
> >  include/linux/arm-smccc.h    | 16 ++++++++++++
> >  5 files changed, 73 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig index
> > 318c8f2df245..bbdfacec4813 100644
> > --- a/arch/arm64/kvm/Kconfig
> > +++ b/arch/arm64/kvm/Kconfig
> > @@ -60,6 +60,12 @@ config KVM_ARM_PMU
> >  config KVM_INDIRECT_VECTORS
> >  	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
> >
> > +config ARM64_KVM_PTP_HOST
> > +	bool "KVM PTP clock host service for arm64"
>=20
> The "for arm64" is not that useful.
Yeah,

>=20
> > +	default y
> > +	help
> > +	  virtual kvm ptp clock hypercall service for arm64
> > +
>=20
> I'm not keen on making this a compile option, because whatever is not
> always on ends up bit-rotting. Please drop the option.
>=20
Ok, I will remove this option next time.

> >  endif # KVM
> >
> >  endif # VIRTUALIZATION
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 32ba6fbc3814..eb85f6701845 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -81,7 +81,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
> >  	}
> >  }
> >
> > -static u64 timer_get_offset(struct arch_timer_context *ctxt)
> > +u64 timer_get_offset(struct arch_timer_context *ctxt)
> >  {
> >  	struct kvm_vcpu *vcpu =3D ctxt->vcpu;
> >
> > diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> > index 901c60f119c2..2628ddc13abd 100644
> > --- a/arch/arm64/kvm/hypercalls.c
> > +++ b/arch/arm64/kvm/hypercalls.c
> > @@ -3,6 +3,7 @@
> >
> >  #include <linux/arm-smccc.h>
> >  #include <linux/kvm_host.h>
> > +#include <linux/clocksource_ids.h>
> >
> >  #include <asm/kvm_emulate.h>
> >
> > @@ -11,6 +12,10 @@
> >
> >  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)  {
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	struct system_time_snapshot systime_snapshot;
> > +	u64 cycles =3D -1;
> > +#endif
>=20
> Please move all the PTP-related code to its own function, rather than
> keeping it in the main HVC dispatcher. Also assigning a negative value to
> something that is unsigned hurts my eyes. Consider using ~0UL instead.
> See the comment below though.

Ok, much better.

>=20
> >  	u32 func_id =3D smccc_get_function(vcpu);
> >  	u64 val[4] =3D {SMCCC_RET_NOT_SUPPORTED};
> >  	u32 feature;
> > @@ -21,6 +26,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  		val[0] =3D ARM_SMCCC_VERSION_1_1;
> >  		break;
> >  	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> > +		/*
> > +		 * Note: keep in mind that feature is u32 and smccc_get_arg1
> > +		 * will return u64, so need auto cast here.
> > +		 */
> >  		feature =3D smccc_get_arg1(vcpu);
> >  		switch (feature) {
> >  		case ARM_SMCCC_ARCH_WORKAROUND_1:
> > @@ -70,7 +79,47 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
> >  		break;
> >  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> >  		val[0] =3D BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +		val[0] |=3D BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
> >  		break;
> > +#ifdef CONFIG_ARM64_KVM_PTP_HOST
> > +	/*
> > +	 * This serves virtual kvm_ptp.
> > +	 * Four values will be passed back.
> > +	 * reg0 stores high 32-bit host ktime;
> > +	 * reg1 stores low 32-bit host ktime;
> > +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
> > +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
>=20
> This comment doesn't match what I read below.
>
Sorry, should have changed according this time. But should keep this next t=
ime as
we really need use 32-bits value to support HVC32.
=20
> > +	 */
> > +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> > +		/*
> > +		 * system time and counter value must captured in the same
> > +		 * time to keep consistency and precision.
> > +		 */
> > +		ktime_get_snapshot(&systime_snapshot);
> > +		if (systime_snapshot.cs_id !=3D CSID_ARM_ARCH_COUNTER)
> > +			break;
> > +		val[0] =3D systime_snapshot.real;
> > +		/*
> > +		 * which of virtual counter or physical counter being
> > +		 * asked for is decided by the r1 value of smccc
>=20
> nit: s/smccc/SMCCC/
Thanks

>=20
> > +		 * call. If no invalid r1 value offered, default cycle
>=20
> nit: If r1 is an invalid value...
>=20
> > +		 * value(-1) will return.
>=20
> nit: will be returned.
>=20
Yeah.

> > +		 */
> > +		feature =3D smccc_get_arg1(vcpu);
> > +		switch (feature) {
> > +		case ARM_PTP_VIRT_COUNTER:
> > +			cycles =3D systime_snapshot.cycles -
> > +				 vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
>=20
> nit: On a single line, please.
Ok.
>=20
> > +			break;
> > +		case ARM_PTP_PHY_COUNTER:
> > +			cycles =3D systime_snapshot.cycles;
> > +			break;
>=20
> It'd be a lot clearer if you had a default: case here, handling the inval=
id case.

Ok, much better.

>=20
> > +		}
> > +		val[1] =3D cycles;
>=20
> Given that cycles is a 64bit value, how does it work for a 32bit guest? O=
r have
> you removed support for 32bit guests altogether?
>=20
Yeah, I will arm32 support back.

Thanks
Jianyong=20
> > +		break;
> > +#endif
> >  	default:
> >  		return kvm_psci_call(vcpu);
> >  	}
> > diff --git a/include/kvm/arm_arch_timer.h
> > b/include/kvm/arm_arch_timer.h index 51c19381108c..5a2b6da9be7a
> 100644
> > --- a/include/kvm/arm_arch_timer.h
> > +++ b/include/kvm/arm_arch_timer.h
> > @@ -105,5 +105,6 @@ void kvm_arm_timer_write_sysreg(struct
> kvm_vcpu
> > *vcpu,
> >  /* Needed for tracing */
> >  u32 timer_get_ctl(struct arch_timer_context *ctxt);
> >  u64 timer_get_cval(struct arch_timer_context *ctxt);
> > +u64 timer_get_offset(struct arch_timer_context *ctxt);
> >
> >  #endif
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index f7b5dd7dbf9f..0724840eb5f7 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -103,6 +103,7 @@
> >
> >  /* KVM "vendor specific" services */
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES		0
> > +#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
> >  #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
> >  #define ARM_SMCCC_KVM_NUM_FUNCS			128
> >
> > @@ -112,6 +113,21 @@
> >  			   ARM_SMCCC_OWNER_VENDOR_HYP,
> 		\
> >  			   ARM_SMCCC_KVM_FUNC_FEATURES)
> >
> > +/*
> > + * ptp_kvm is a feature used for time sync between vm and host.
> > + * ptp_kvm module in guest kernel will get service from host using
> > + * this hypercall ID.
> > + */
> > +#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID                          =
 \
> > +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         \
> > +			   ARM_SMCCC_SMC_32,                            \
> > +			   ARM_SMCCC_OWNER_VENDOR_HYP,                  \
> > +			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
> > +
> > +/* ptp_kvm counter type ID */
> > +#define ARM_PTP_VIRT_COUNTER			0
> > +#define ARM_PTP_PHY_COUNTER			1
> > +
> >  /* Paravirtualised time calls (defined by ARM DEN0057A) */
> >  #define ARM_SMCCC_HV_PV_TIME_FEATURES
> 	\
> >  	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,
> 	\
> > --
> > 2.17.1
> >
> >
>=20
> Thanks,
>=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.
