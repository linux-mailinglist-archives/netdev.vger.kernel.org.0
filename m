Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42C1E71E5
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 03:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438243AbgE2BFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 21:05:46 -0400
Received: from mail-eopbgr60080.outbound.protection.outlook.com ([40.107.6.80]:1153
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2438195AbgE2BFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 21:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqfAn/hkYxLJ73chCIBA+jSwpnTJdU9kUcXapgmiNjQ=;
 b=wSY/XdxkANV8BCU06ky30C0tkv66kjT6tl5xrDcseVW9h09gNs/PbOGoLPRfzIpJSKM77x5rj1MUcCVwDC+l6xGf2RAdveCu8LL3NWysA59paAjJI0lCn3iTSHz1j+iuAPz5yrtY6nOi/lMo75Ndz9vzwCOyp80x+Uo+spm0Xow=
Received: from DB6P192CA0001.EURP192.PROD.OUTLOOK.COM (2603:10a6:4:b8::11) by
 VI1PR08MB3965.eurprd08.prod.outlook.com (2603:10a6:803:dd::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3045.17; Fri, 29 May 2020 01:05:38 +0000
Received: from DB5EUR03FT009.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:b8:cafe::e9) by DB6P192CA0001.outlook.office365.com
 (2603:10a6:4:b8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend
 Transport; Fri, 29 May 2020 01:05:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT009.mail.protection.outlook.com (10.152.20.117) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Fri, 29 May 2020 01:05:38 +0000
Received: ("Tessian outbound facc38080784:v57"); Fri, 29 May 2020 01:05:38 +0000
X-CR-MTA-TID: 64aa7808
Received: from 590180419ac9.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id B785AFE7-ECD6-45F8-8CFD-3112B0A46193.1;
        Fri, 29 May 2020 01:05:33 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 590180419ac9.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 29 May 2020 01:05:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hOU51j0uNdUr3rQqTUennZjvydsWCvjnVoiz+zmpMvY9B/KlxA/isWsF/k6uZmTI3QK98ZkC8VyER5IRiHPMXkTrQxfg/iZQWvFGfvXYJxUH4WtIg8WIySZnCksI5qhA29KjMhI+lGPoga2JNajR7GSgTra4j62U2G+auMtEMnT0Bhb28RMXCaSyvKiVz1vzHBNXzfwR7nk4lbsVkY+2HNnZKljm9nd5U3YLoeTc1tJ9D6ArSSCRd4/pYmXzDG/7ERPTvuZneuavRAOGjxZjALaKKK0JBeq4Ooxv9p6nQyjO4C6jrZlAAy4Z2rlBVuP6HAkqv0b62eMwBLCnnAXU5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqfAn/hkYxLJ73chCIBA+jSwpnTJdU9kUcXapgmiNjQ=;
 b=msPe4XJL+wTws6dJhh9wMHwtFQA/BoSsJfjADCzrQoRSGe8PQnMmQ8ixF316WlBC891tpJhHAjaNhrYXxpUWyIlNGcLG3xKtOp6N4OS3ThIBEJpZ0zJGfnU6Tx2iF/JK/ekpSECzl/pKCDWx3td2IDw0FYY1CH6fWtqesSM/ur+yHhU9M75UhtYU43qab/oitn0EBaw+bTvO5PrIbIfL4aq4NkETTMPTGeu6BhCWpTe4pJ14rLoTlQs7A17WMzX1aQZrfXK9DFNt3cNftnGMmDj6VfrBpqISc39M6dda7vHdyPbAf8bhNITgXQ7fkA1KMLd8cNKdLSzQuPYeTslDqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pqfAn/hkYxLJ73chCIBA+jSwpnTJdU9kUcXapgmiNjQ=;
 b=wSY/XdxkANV8BCU06ky30C0tkv66kjT6tl5xrDcseVW9h09gNs/PbOGoLPRfzIpJSKM77x5rj1MUcCVwDC+l6xGf2RAdveCu8LL3NWysA59paAjJI0lCn3iTSHz1j+iuAPz5yrtY6nOi/lMo75Ndz9vzwCOyp80x+Uo+spm0Xow=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2491.eurprd08.prod.outlook.com (2603:10a6:3:de::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.21; Fri, 29 May
 2020 01:05:26 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.030; Fri, 29 May 2020
 01:05:25 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: RE: [RFC PATCH v12 05/11] time: Add mechanism to recognize
 clocksource in time_get_snapshot
Thread-Topic: [RFC PATCH v12 05/11] time: Add mechanism to recognize
 clocksource in time_get_snapshot
Thread-Index: AQHWMBRarnlKRx72O0Ohyt/gOs353ai9vAGAgACN4SA=
Date:   Fri, 29 May 2020 01:05:25 +0000
Message-ID: <HE1PR0802MB2555D67ACAF18A52DE8D9278F48F0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-6-jianyong.wu@arm.com>
 <87tv00nhje.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87tv00nhje.fsf@nanos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 92c3abe8-9efe-4ce7-b3d6-85b06a5a27ff.1
x-checkrecipientchecked: true
Authentication-Results-Original: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fdbf23ba-fcc5-4ccd-8594-08d8036c6686
x-ms-traffictypediagnostic: HE1PR0802MB2491:|VI1PR08MB3965:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB3965BBA9EA663B14C3518167F48F0@VI1PR08MB3965.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2958;OLM:2958;
x-forefront-prvs: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 4TBFoddbFrAB1xW5jZi42UejDCCNh1LFQqupSblRlYWG3ANav5BlGwQy8WxKs73Aok251e8LTHGlq03fZjTLrW/Hp++6lZxNuvrP4trgg65PBxTBjknNOQO6qa6ujnXDHKm7DjVBWCvo/ZMERnsv1GswLMhdcx+syZErn8humW6wzlrG+I1WSvBv5T/WmYCX2n0BpGtt7V2DLZvW8ZyNfNQ3YFsapVilcSSge1zQVtIZtFww4p1tw4QajBbIXJHoTfBUPy4k6Kx4w2DlrdspTa4BZ2Yj5Y7GJlx44IiYRqY9CYOkwv+BO+IpjWW/q2dcYH4ohGQAEORlHihcVqSBvxA4GB8du2GTu3eWfSC1sB8cCyye8UrEaonaEXILdlWZ
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(7696005)(54906003)(316002)(110136005)(7416002)(2906002)(478600001)(86362001)(4326008)(76116006)(52536014)(66476007)(66556008)(64756008)(66446008)(66946007)(55016002)(53546011)(6506007)(71200400001)(186003)(26005)(33656002)(8936002)(9686003)(8676002)(6636002)(5660300002)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3HipzhGdsSvBFlegJeI2GC8ZhhOdssEvYAMJikJhEmWGUnhrMKGn9sOPPmPbXxjvcwhO0mA/amkwpVIZU4pJji9fUVmSMJDpBrP7NDck6YuncSjXYj2MBViF9BBBbVpy6ukCWRFvOUwzLhHkaRTEoJj5PwRbTz2RgiJfjkKVHjTGNQ7zbWbLJ+h62Qhp0cLPppTuED0HsSgx5SYtDds6E6PhgDrXgbI62AeyUJhd7fHM+7GSg//V6czKOzfva9AhrbRLvfr/sjD/Zob6wqqOP/CvJxseh2YUmpXfxjPNsLRmjH2ZQErss5zlLh8DyfMgpSr0MKXLhBhsLnepPQ9OfCRaCi214qlumZd/qjkmoYuOMKg41bELcLLOSQYrJyXVSzCIa1FANR5on9mBwkxLyBWJJpVmdyN7wBYE/ADiYzm1KPPhC1MVVZBYGyWEkmcQVjeABh4o1lcvhl/3tqVmDFGbTMucBHl59fA9pHZqklg=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2491
Original-Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT009.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(396003)(346002)(39860400002)(46966005)(450100002)(81166007)(86362001)(33656002)(83380400001)(82310400002)(6636002)(82740400003)(47076004)(356005)(316002)(2906002)(478600001)(4326008)(70206006)(8936002)(53546011)(6506007)(55016002)(54906003)(70586007)(52536014)(110136005)(8676002)(5660300002)(9686003)(186003)(7696005)(26005)(336012)(921003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: cb2116b4-ebc1-45c8-649a-08d8036c5f0b
X-Forefront-PRVS: 04180B6720
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lK89LDROjfk6F8ia/ZrhVgN7RAqQcbawHdL9dsR0STrf9RkKrQ3KLVZ9kQIh6xS3r3M65U6QHOAGBP6D+v1EGE4Qr3uogW5epg44tE5D+g5velwiH5cDCfQ0o95H2vPxPuC1wiAgzizoctNU1p0KWSEe6v6w9JeKvvfNuUEfWb9y8qxZL/LFyNheyoLe++/WlX2b+ORUGuLq+VQw799Fqs7n79yJwRsdWhgumfOvfepdR6k9rrkRUCzR+RMKB1S3sKqxTn+OY/Qq4UQSdkam8pSosdp58OMKX0Qld5eOusHeZOL84v9qSxrPNJOMJ5wXsc0s8xCGxx1/CsiSc0G7OAYHcGGBZS+dz2aXTyHqTr+KiVMuWH8qRRc2PvbTSRcDIuZJUSv1fsk+kezzj4iJm9Mm/B1ibQJALDZgiVkp20I=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 01:05:38.4258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbf23ba-fcc5-4ccd-8594-08d8036c6686
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3965
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
> Sent: Friday, May 29, 2020 12:36 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>; netdev@vger.kernel.org;
> yangbo.lu@nxp.com; john.stultz@linaro.org; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Wei Chen <Wei.Chen@arm.com>; Jianyong Wu
> <Jianyong.Wu@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v12 05/11] time: Add mechanism to recognize
> clocksource in time_get_snapshot
>=20
> Jianyong Wu <jianyong.wu@arm.com> writes:
> > From: Thomas Gleixner <tglx@linutronix.de> diff --git
> > a/kernel/time/clocksource.c b/kernel/time/clocksource.c index
> > 7cb09c4cf21c..a8f65b3e4ec8 100644
> > --- a/kernel/time/clocksource.c
> > +++ b/kernel/time/clocksource.c
> > @@ -928,6 +928,9 @@ int __clocksource_register_scale(struct
> > clocksource *cs, u32 scale, u32 freq)
> >
> >  	clocksource_arch_init(cs);
> >
> > +if (WARN_ON_ONCE((unsigned int)cs->id >=3D CSID_MAX))
> > +		cs->id =3D CSID_GENERIC;
> > +
>=20
> This is white space damaged and certainly not from me.

Sorry, I will fix it.

Thanks
Jianyong=20

