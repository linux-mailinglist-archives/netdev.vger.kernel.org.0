Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC99DFD7D9
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 09:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKOIYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 03:24:54 -0500
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:28483
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbfKOIYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 03:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqONU9aIxyPtotpVZqCYAhzJULEraZFes6JCG8txzZs=;
 b=hlJSNoMLnNJpyym+QB8FBKB2pBYZwsqecWw0YNqGF9hjLLl1yq8jgKd89OLOqS9o6ObFNxjmc9j44CGg8pPDLdAuhsA3KEsqXxyR32T4DLoDzOiKxUh1Ld7orOcVxid8sCK9AochL2BSqccYvtI+UVz5eIyfcj7HIkdOdh9tWpg=
Received: from HE1PR0802CA0009.eurprd08.prod.outlook.com (2603:10a6:3:bd::19)
 by VI1PR0802MB2558.eurprd08.prod.outlook.com (2603:10a6:800:ae::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.27; Fri, 15 Nov
 2019 08:24:43 +0000
Received: from DB5EUR03FT037.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::202) by HE1PR0802CA0009.outlook.office365.com
 (2603:10a6:3:bd::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.22 via Frontend
 Transport; Fri, 15 Nov 2019 08:24:42 +0000
Authentication-Results: spf=fail (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: Fail (protection.outlook.com: domain of arm.com does not
 designate 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT037.mail.protection.outlook.com (10.152.20.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23 via Frontend Transport; Fri, 15 Nov 2019 08:24:42 +0000
Received: ("Tessian outbound 3fba803f6da3:v33"); Fri, 15 Nov 2019 08:24:39 +0000
X-CR-MTA-TID: 64aa7808
Received: from de50c3b770ee.2 (cr-mta-lb-1.cr-mta-net [104.47.6.54])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id D7401C03-0FEA-4BBB-B8B7-D77B23F631F7.1;
        Fri, 15 Nov 2019 08:24:34 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-ve1eur02lp2054.outbound.protection.outlook.com [104.47.6.54])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id de50c3b770ee.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 15 Nov 2019 08:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFG+r2n8zfADuoUg9Ph7IkzLi7et3xzqZfemxf8fUweGofHXrYt7NsTklTDDPXM6s/71MSZ1Dhxzb2NkqNLq+Qj79h+6hR7Rwcjr+TDAJmJmjypeq/z4Tj+8hTSlTWCC5ClOrL+9Wno03LxOSJFmXDyc2SedGN1L1dakfXdI49EGaELHlk0WnRa0ctwr+dEswb4R5JyAeSkN3JvTSZJKRprGJFKc9BL+c87vF8XNNytZf3V6y2n1XoU2oMTLVpl5U86TlzYqYpb7jloaWYaGPQnHxZdLZcJUJ0dQs9e6GHtcxXXTKasKZ71Z45uOutA5R0A7ATWKhP6NKeEkLN98Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqONU9aIxyPtotpVZqCYAhzJULEraZFes6JCG8txzZs=;
 b=Pv+J2L7iUg+1jK4bs+NbdOTbj6EyVeA3axuVzEjA89dXh3+GLd2L+DAcXTsHsnyeoMI0oKbgAYcFvDTfC6p1QqOsKgXi2Jj9rt7sYKD/cHhX90+MFIs/FVw8enlMbgvMEtTU9C5yMKDp78fwnU85VRcuMvcKQc+WVpS7cOZgICNQvmGFF/OIuEbiFOkKlo6tGwJdz056H9QeyHxkfL6+rnLDactPSl2shaqKVOnpsb0IwtiSShj4MzpwDIhADago9bWkVeCuEQYjVwPlR492ggzH9mLHOPQ2ez6H0QqbSx40XAvARAOvErY138nGpCi/kuOultQQPbNrYgo299Abuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqONU9aIxyPtotpVZqCYAhzJULEraZFes6JCG8txzZs=;
 b=hlJSNoMLnNJpyym+QB8FBKB2pBYZwsqecWw0YNqGF9hjLLl1yq8jgKd89OLOqS9o6ObFNxjmc9j44CGg8pPDLdAuhsA3KEsqXxyR32T4DLoDzOiKxUh1Ld7orOcVxid8sCK9AochL2BSqccYvtI+UVz5eIyfcj7HIkdOdh9tWpg=
Received: from VI1PR0801MB1677.eurprd08.prod.outlook.com (10.168.64.21) by
 VI1PR0801MB1807.eurprd08.prod.outlook.com (10.168.61.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 15 Nov 2019 08:24:32 +0000
Received: from VI1PR0801MB1677.eurprd08.prod.outlook.com
 ([fe80::dc15:dc7b:57ad:d978]) by VI1PR0801MB1677.eurprd08.prod.outlook.com
 ([fe80::dc15:dc7b:57ad:d978%8]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 08:24:32 +0000
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
Subject: RE: [RFC PATCH v7 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
Thread-Topic: [RFC PATCH v7 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
Thread-Index: AQHVmuUeY8KwMfywA063cJuUDSewUaeKtyGAgAEslGA=
Date:   Fri, 15 Nov 2019 08:24:32 +0000
Message-ID: <VI1PR0801MB16770B5FEF32B82E7B81251EF4700@VI1PR0801MB1677.eurprd08.prod.outlook.com>
References: <20191114121358.6684-1-jianyong.wu@arm.com>
 <20191114121358.6684-5-jianyong.wu@arm.com>
 <alpine.DEB.2.21.1911141507010.2507@nanos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.21.1911141507010.2507@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 62d86767-0af9-4fac-8287-f19c350689aa.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d4d9eb6-4c35-427d-dd15-08d769a543e6
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1807:|VI1PR0801MB1807:|VI1PR0802MB2558:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0802MB255854095E8C242650AB5D30F4700@VI1PR0802MB2558.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
x-forefront-prvs: 02229A4115
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(13464003)(256004)(71190400001)(11346002)(6916009)(446003)(14454004)(66066001)(5660300002)(74316002)(305945005)(2906002)(7736002)(476003)(76176011)(53546011)(52536014)(6506007)(55236004)(186003)(7696005)(7416002)(486006)(102836004)(26005)(54906003)(25786009)(66946007)(316002)(478600001)(66556008)(99286004)(86362001)(64756008)(76116006)(66476007)(4326008)(66446008)(6436002)(8936002)(3846002)(6116002)(33656002)(229853002)(8676002)(9686003)(55016002)(81156014)(6246003)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0801MB1807;H:VI1PR0801MB1677.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 7YZGu0/rggLm+5fBgbCPoUnGwI4YbjkzrrbbjrNg9Ms5rkjolWuev1X1jNt85OaUhLdBANQLAYs018Qzxp7WhHEFkGIRUnwIPSKw52QxuyL4iCXmr3INnXKPqbfwhEbjn3bh23lvjnjIMD1h1DCZZ75Yec0tF2IITrSb1Pgm1FkuQsU3279MOobfNaJIYhqF/yY2reFBKvrgByFWugbp14iFBrnymuCHiQHnDdvCjXztZhpHzAjA9/G3joYkPw+E97OLpHwAED0/k/Qwusc5p2QnsiRzaH4HkmD4gQAePYE0/WxPFkWRUE5Er8R/57DwLF2c/vvT03FGQqcRtYao3zAJDYq1wC2creDvvcPpTkNNeTa8bFveHq8ExYLIrmK1sJ12lVfkQlZ2C7qeFEc+CHN+QdFBqANo3NZsWmueTqrroW7NICH7nKJTOJvG3XNK
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1807
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT037.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(136003)(376002)(1110001)(339900001)(189003)(199004)(13464003)(356004)(2906002)(486006)(23726003)(25786009)(97756001)(450100002)(70586007)(46406003)(70206006)(305945005)(6862004)(47776003)(5660300002)(76130400001)(54906003)(22756006)(7696005)(4326008)(476003)(102836004)(7736002)(126002)(6506007)(186003)(53546011)(52536014)(316002)(74316002)(66066001)(26005)(76176011)(55016002)(8676002)(9686003)(86362001)(8746002)(8936002)(336012)(99286004)(50466002)(478600001)(33656002)(26826003)(11346002)(6116002)(6246003)(3846002)(229853002)(446003)(81166006)(105606002)(14454004)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2558;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Fail;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9dabf6fb-8949-47c2-550f-08d769a53dd2
NoDisclaimer: True
X-Forefront-PRVS: 02229A4115
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wGLsP5SyX5vDBzfsLfJWSAzcegFKtHSRSmBd4CTLlobCMhKF8squWA1foOFPOf1kQs5RxGRs0xkwNx5HLCF3Yr+k+jGpnUi9ZP4nOE3VHu2aHLCCj47SSk66Q+eyCRvy87bmLu1v9pkWoP977MSBB2ELmPgpMUQu4pBYVfa9FvPorN/KSMgb9u+9WZpiZzQ/Le1Xlbu6Pi1xE7wNjcvVnjpyT0hNgshxkFQTJgMjTu/ZpLCw876eYhRTGdc+LqCrEpFkhtRWXJhwHcSLXoSvt1L16txLypAZhBJmkbJAicHeg//m8suJy6OAPWrqGdttsd75T6/52/PczGHvbDNQlprrJz2cbeAVvsSAsMdUudMpvZMfqKpl/23IXOnapOPzxMG0/pnSp0K+Ouq2T8Ae84l+jD6UotsaVOVNQzzHsU/seKVk7BuPA2zR5mexnIGT
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2019 08:24:42.4977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4d9eb6-4c35-427d-dd15-08d769a543e6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2558
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi tglx,

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Thursday, November 14, 2019 10:19 PM
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
> Subject: Re: [RFC PATCH v7 4/7] time: Add mechanism to recognize
> clocksource in time_get_snapshot
>=20
> On Thu, 14 Nov 2019, Jianyong Wu wrote:
> > From: Thomas Gleixner <tglx@linutronix.de> In some scenario like
> > return device time to ptp_kvm guest, we need identify the current
> > clocksource outside core time code.
> > A mechanism added to recognize the current clocksource by export
> > clocksource id in time_get_snapshot.
>=20
> Can you please replace that with the following:
>=20
>  System time snapshots are not conveying information about the current
> clocksource which was used, but callers like the PTP KVM guest
> implementation have the requirement to evaluate the clocksource type to
> select the appropriate mechanism.
>=20
>  Introduce a clocksource id field in struct clocksource which is by defau=
lt  set
> to CSID_GENERIC (0). Clocksource implementations can set that field to  a
> value which allows to identify the clocksource.
>=20
>  Store the clocksource id of the current clocksource in the
> system_time_snapshot so callers can evaluate which clocksource was used
> to  take the snapshot and act accordingly.
>=20

Ok, really better.

> > diff --git a/include/linux/clocksource_ids.h
> > b/include/linux/clocksource_ids.h new file mode 100644 index
> > 000000000000..93bec8426c44
> > --- /dev/null
> > +++ b/include/linux/clocksource_ids.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */ #ifndef
> > +_LINUX_CLOCKSOURCE_IDS_H #define _LINUX_CLOCKSOURCE_IDS_H
> > +
> > +/* Enum to give clocksources a unique identifier */ enum
> > +clocksource_ids {
> > +	CSID_GENERIC		=3D 0,
> > +	CSID_ARM_ARCH_COUNTER,
>=20
> This should only add the infrastructure with just CSID_GENERIC in place.
>=20
> The ARM_ARCH variant needs to come in a seperate patch which adds the
> enum and uses it in the corresponding driver. Seperate means a patch doin=
g
> only that and nothing else, i.e. not hidden in some other patch which act=
ually
> makes use of it.
>=20

Yeah, this patch should be arch independent and "CSID_ARM_ARCH_COUNTER" sho=
uld be in an
Separate patch.

Thanks
Jianyong

Thanks
> Thanks,
>=20
> 	tglx
