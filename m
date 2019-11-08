Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0211CF3E38
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 03:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfKHCwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 21:52:06 -0500
Received: from mail-eopbgr80072.outbound.protection.outlook.com ([40.107.8.72]:14560
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726219AbfKHCwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 21:52:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdTY0JbhkY6/6eskSvqk2yfJ3IFG65hthmmAev67c2w=;
 b=raumMO49Ya+iI7QERym2Udjz/EuNaJD74/vYPiyhuIbUctYbK+GJyciCRjRCuNFKZj74JQWB1hKZoxCbHmXfSbELYH8BB8/zVaDMq8peYYiSDL9irxgLFM9DKUr18uljosJu4LWtgPq/xUaOmAY5FNXJxrmASkViB4EkyUB47u0=
Received: from AM6PR08CA0045.eurprd08.prod.outlook.com (2603:10a6:20b:c0::33)
 by DB7PR08MB3531.eurprd08.prod.outlook.com (2603:10a6:10:49::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20; Fri, 8 Nov
 2019 02:51:54 +0000
Received: from VE1EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e09::201) by AM6PR08CA0045.outlook.office365.com
 (2603:10a6:20b:c0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2430.20 via Frontend
 Transport; Fri, 8 Nov 2019 02:51:54 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT048.mail.protection.outlook.com (10.152.19.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.21 via Frontend Transport; Fri, 8 Nov 2019 02:51:54 +0000
Received: ("Tessian outbound 851a1162fca7:v33"); Fri, 08 Nov 2019 02:51:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from ebff76385b05.2 (cr-mta-lb-1.cr-mta-net [104.47.4.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 9EA17CD6-723F-47F5-95A8-1B85579A6C74.1;
        Fri, 08 Nov 2019 02:51:46 +0000
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2056.outbound.protection.outlook.com [104.47.4.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ebff76385b05.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 08 Nov 2019 02:51:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6DVogRnMm2XlW2YryYoDspufVFhEGFBiTI5hTCaeyb+ddVtlkQDD0tfvEf9KRHsaFGJNSGAGFJWQ6raRWBhI/7DqdkrS0z6QvFor32IZpLDU4yp43v30sQCR2cxWtnrWFqxFjwQvyWy/T+mVkykkVY0R4Gk4Oiqdhvew1sRTqmUY7rlefoFOpwieu2gB2P7xUkQmUu2BMaQ9UZhWHOgnzQ/MwXf7aiHq7rb/GyVydeYlbFhUTGGyFQT5o7sY0h38zN/lf/TfZnwOF1aYNoXwKY1mNKQ/IFNMUvvU7SHtZqx/oxAEboH6cNlfwQz5cBXuzDHdbdRkeIXkayUbPdBcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdTY0JbhkY6/6eskSvqk2yfJ3IFG65hthmmAev67c2w=;
 b=iMB8mpRykImGGNF5hXhC7SoDWc7yTkLJlOCAaOsmpn+ck6Qb6yxkBZWsLW/OXXDUyOrJKV4m6iOn7nZumt/pcY7QjnJDQCh+5rMAjRrNZC+0v1y6rOfxldqdb4Q/jTTjF5F3tBhnBJqTqHJZBKTFgL77/iW+Qxwfoxe50XCGpRhhEdk9ZTmd5imvA5BeEd10/ekbixeJItUfwrAjgodgkzyhTJpHCUqNNfBS2guu1odxwOuBQLP9UfnMGo5XowudAVYekqmATjr2CLQ4t3vByJZRFQXfPsKrcwcrjWWCLZMHvNuar7LzwSPorI0aKDdyX4qREDsRnR+LRefIZbU41A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdTY0JbhkY6/6eskSvqk2yfJ3IFG65hthmmAev67c2w=;
 b=raumMO49Ya+iI7QERym2Udjz/EuNaJD74/vYPiyhuIbUctYbK+GJyciCRjRCuNFKZj74JQWB1hKZoxCbHmXfSbELYH8BB8/zVaDMq8peYYiSDL9irxgLFM9DKUr18uljosJu4LWtgPq/xUaOmAY5FNXJxrmASkViB4EkyUB47u0=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1690.eurprd08.prod.outlook.com (10.168.145.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 02:51:44 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::453c:d9b6:5398:2294%8]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 02:51:44 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [RFC PATCH v6 5/7] psci: Add hvc call service for ptp_kvm.
Thread-Topic: [RFC PATCH v6 5/7] psci: Add hvc call service for ptp_kvm.
Thread-Index: AQHVilqZVMoUcaXKbE+vr/6AIRo8jKd/bmYAgAE3LOA=
Date:   Fri, 8 Nov 2019 02:51:44 +0000
Message-ID: <HE1PR0801MB16766C7E11CF88D32BC0A4BAF47B0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191024110209.21328-1-jianyong.wu@arm.com>
 <20191024110209.21328-6-jianyong.wu@arm.com>
 <alpine.DEB.2.21.1911070856100.1869@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1911070856100.1869@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 90748d83-4bdb-4ee3-aed4-fb4cce270c7c.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b83d0808-671c-49c2-ddf4-08d763f69d1b
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1690:|HE1PR0801MB1690:|DB7PR08MB3531:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB353153CCDA33BA83B0E0DB0BF47B0@DB7PR08MB3531.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0215D7173F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(13464003)(189003)(199004)(5660300002)(81156014)(6436002)(6916009)(99286004)(55016002)(74316002)(186003)(2906002)(66556008)(6246003)(4326008)(446003)(14444005)(102836004)(476003)(26005)(25786009)(66476007)(86362001)(229853002)(478600001)(14454004)(3846002)(55236004)(256004)(6116002)(52536014)(76176011)(7736002)(7696005)(33656002)(7416002)(316002)(11346002)(54906003)(486006)(53546011)(6506007)(9686003)(66066001)(64756008)(76116006)(66946007)(305945005)(8936002)(66446008)(81166006)(8676002)(71190400001)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1690;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Mz3B7tgT2kLk+3X18+7ilYUfs/eJ7lPDIUpwZloBt4yrhDBr8+ZwtNlYp/RfG4m44QyEIdoYob2PjeiVRyG+GDMEbWFlYXRJvmycV94T0ULTIvsdl4Qp6q55XdUlt1s08YRJ0dzhkw/TtL0P/n+mL7JNIhsrgtCXkdvs/BhScjNyHT42HfO9y5ApjNBf8PM8IuVn2sTbf8fd4JWXzF0bzwjbq05cx49glvS6pdvdscpnEKe1r8mccPOo7xQ0kwu04XWGwep/4gkzwRj2hBrlJ98IKEl3XN/qox79Kn6fqb+yF7VidN1aMW1NPa+AN2voq0kx/KM+/sTcLVAtyTjhkh2d/B1M27eijD1I7gd4b3U708bwS6+yZbYqpwGXS8b5YvrDxOSeAH1vHpTRuYYQb1xkJbTJZ871zAKtc6MFMV5qUqwP1G+XWs5wyUe4v0We
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1690
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(1110001)(339900001)(13464003)(189003)(199004)(316002)(26826003)(54906003)(478600001)(14454004)(6862004)(8746002)(9686003)(6246003)(99286004)(446003)(126002)(486006)(86362001)(4326008)(66066001)(25786009)(97756001)(55016002)(229853002)(14444005)(11346002)(52536014)(450100002)(5660300002)(2906002)(46406003)(102836004)(3846002)(23726003)(305945005)(33656002)(74316002)(8676002)(7736002)(47776003)(76130400001)(476003)(36906005)(70206006)(7696005)(105606002)(8936002)(26005)(186003)(53546011)(356004)(336012)(70586007)(6116002)(22756006)(81166006)(76176011)(6506007)(81156014)(50466002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR08MB3531;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 87832ef8-58bd-44d4-5366-08d763f696f8
NoDisclaimer: True
X-Forefront-PRVS: 0215D7173F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyRBcjRgMAWMMUBFz3xOXvX8QEra1Y8rzlGRZRu8XSTskB+6iCMWLdNBGP0BksxUtiN6E0p3WnD5UXgxidha5V2tcjiOkMu0FXFPHLsBubHxqaB87NqeQm3WqrIdWu4yqcuadspfjUBMXo8DxQs2ZNXlrt3MUqrpkpCGyt1E452kZ1UzvN6zHeQYgytfIVUlcPlvYkXM+B0z1EVdPDcCY3DcXg0qLAzrnXypV2kaGF2LGG0khDfCGVQ5zUh9jH7rN2OJw7VYfQniMjzBDx5T9yL3Fh983pHhzXo1Xf+PatoGPNTWVlthnCMvjINzhFQgRjiNbb2H8Mb0z0DEECll2iHUpTF4aIvR6wo0oyfeFxz4A2euZ9dJVV5A/tOpHQt4cBKpdo0sTjznGQLla436Rq0bvs0FNuxgFzuLxgq4Y6E6DJ19C/Y2nLYHJ7gHoTRp
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2019 02:51:54.3276
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b83d0808-671c-49c2-ddf4-08d763f69d1b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3531
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi tglx,

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Thursday, November 7, 2019 4:01 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> pbonzini@redhat.com; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; linux-
> kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v6 5/7] psci: Add hvc call service for ptp_kvm.
>=20
> On Thu, 24 Oct 2019, Jianyong Wu wrote:
>=20
> > This patch is the base of ptp_kvm for arm64.
>=20
> This patch ...
>=20

Yeah, avoid subjective expression.

> > ptp_kvm modules will call hvc to get this service.
> > The service offers real time and counter cycle of host for guest.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/clocksource/arm_arch_timer.c |  2 ++
> > include/clocksource/arm_arch_timer.h |  4 ++++
> >  include/linux/arm-smccc.h            | 12 ++++++++++++
> >  virt/kvm/arm/psci.c                  | 22 ++++++++++++++++++++++
> >  4 files changed, 40 insertions(+)
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> > b/drivers/clocksource/arm_arch_timer.c
> > index 07e57a49d1e8..e4ad38042ef6 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -29,6 +29,7 @@
> >  #include <asm/virt.h>
> >
> >  #include <clocksource/arm_arch_timer.h>
> > +#include <linux/clocksource_ids.h>
>=20
> Same ordering issue and lack of file.
>=20
OK,

> > diff --git a/include/clocksource/arm_arch_timer.h
> > b/include/clocksource/arm_arch_timer.h
> > index 1d68d5613dae..426d749e8cf8 100644
> > --- a/include/clocksource/arm_arch_timer.h
> > +++ b/include/clocksource/arm_arch_timer.h
> > @@ -104,6 +104,10 @@ static inline bool
> arch_timer_evtstrm_available(void)
> >  	return false;
> >  }
> >
> > +bool is_arm_arch_counter(void *unuse)
>=20
> A global function in a header file? You might want to make this static in=
line.
> And while at it please s/unuse/unused/
>=20

Should remove this residue line from v5 in v6.

> > +{
> > +	return false;
> > +}
> >  #endif
> >  #include <linux/linkage.h>
> > diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c index
> > 0debf49bf259..339bcbafac7b 100644
> > --- a/virt/kvm/arm/psci.c
> > +++ b/virt/kvm/arm/psci.c
> > @@ -15,6 +15,7 @@
> >  #include <asm/kvm_host.h>
> >
> >  #include <kvm/arm_psci.h>
> > +#include <linux/clocksource_ids.h>
>=20
> Sigh.
>=20
Yeah,

> >  /*
> >   * This is an implementation of the Power State Coordination
> > Interface @@ -392,6 +393,8 @@ int kvm_hvc_call_handler(struct
> kvm_vcpu *vcpu)
> >  	u32 func_id =3D smccc_get_function(vcpu);
> >  	u32 val[4] =3D {};
> >  	u32 option;
> > +	u64 cycles;
> > +	struct system_time_snapshot systime_snapshot;
>=20
> Also here you might notice that the variables are not randomly ordered.
>
Do you mean considering the alignment then put "struct system_time_snapshot=
  systime_snapshot" as the top one and u64 cycles as the second?

Thanks=20
Jianyong
=20
> Thanks,
>=20
> 	tglx
