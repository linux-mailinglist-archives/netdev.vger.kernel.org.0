Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E9913A76F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 11:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbgANKfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 05:35:04 -0500
Received: from mail-vi1eur05on2055.outbound.protection.outlook.com ([40.107.21.55]:62178
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727285AbgANKfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 05:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=TtzYkCofO4VWT/73TqESbF5XVqA0cmdObMMDm1zloZN5CGruOZw3gcJSNRHcrvwRuOaB/JuSoC2qpogMlvo8zTQrjCc88Se0c+CYUhN9qJC+oreFTfwghSxx7/220/2cvhoY5OPrHf2AzQV2M9shHGrBRCt0R1t0ML/8aMp7hsQ=
Received: from VI1PR08CA0106.eurprd08.prod.outlook.com (2603:10a6:800:d3::32)
 by VI1PR0802MB2493.eurprd08.prod.outlook.com (2603:10a6:800:b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10; Tue, 14 Jan
 2020 10:34:58 +0000
Received: from DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::207) by VI1PR08CA0106.outlook.office365.com
 (2603:10a6:800:d3::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend
 Transport; Tue, 14 Jan 2020 10:34:58 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT046.mail.protection.outlook.com (10.152.21.230) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Tue, 14 Jan 2020 10:34:58 +0000
Received: ("Tessian outbound 121a58c8f9bf:v40"); Tue, 14 Jan 2020 10:34:58 +0000
X-CR-MTA-TID: 64aa7808
Received: from b6e565f55bc2.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 59396DE5-C495-44D7-AF14-D39CA66F96DF.1;
        Tue, 14 Jan 2020 10:34:53 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b6e565f55bc2.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 14 Jan 2020 10:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GO9NFD1Wgc9hOaWhJZQg7pfIdVdflKJHZdodQPiryEm/jLbb5UEeeNkkaWnUkTjBv7Ex0vb6HigTxqwdfkoV8H5mgpl/kQ+133LT+/J7NRgg2iaTmDD1pD/aIoIQyjcJ8r2fLZw7i0JVMKwm2gQpx5G0ZG5xP4mbSRtt3suWf13AVxf0BJcEN8n3KCPlvaNGFZa/z/2xqJwhFHBEZpUFF/jnrZvBGLSiyqhyvo4PNEgUXEgsiZZFBJ8ZoogF3q/UeQr2eD/5lI7n9urGkH1SNqmaHzBU7zh2uXiHM4CpDtLvsKa7UI53gi5MiVkeyxmezHk+zPrYpEe/pDmT/YXtWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=bbC2TeA32a8IqyhgVRlO86yhEtc86oH87FhV11Vvx94+VYsGUfwkAnjCQiv7D9Fcg0UgHpkwM/KXwI2bfzUqkFYohe1uj3aCSp0esnurVWejf6+2neD8dIOKOXl9IvUBTKrQsRo82yJVB09n2t0c6Lg57ZgduVEW1QFi6Oj9chjUvkn5/N4a15cH3ZzrwETNpNxen0qr80F0Ci+ggfDg3Sjsb0RDr58dZ3hJfXnndo5yA8wfHAfJlsaWzPmG8nwiHZN4DwDFcZhgidXhQHJRxhhQcN3/pO/+puMN7+Uj3oy982w8sE2+uiI0Ok92Ta1GagnejjhQRu5wizOmLNszxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uMcY0I41udNF+2uESqSRzcDBBUmCzMhHhGmFdsv3MdU=;
 b=TtzYkCofO4VWT/73TqESbF5XVqA0cmdObMMDm1zloZN5CGruOZw3gcJSNRHcrvwRuOaB/JuSoC2qpogMlvo8zTQrjCc88Se0c+CYUhN9qJC+oreFTfwghSxx7/220/2cvhoY5OPrHf2AzQV2M9shHGrBRCt0R1t0ML/8aMp7hsQ=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Tue, 14 Jan 2020 10:34:51 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.017; Tue, 14 Jan 2020
 10:34:51 +0000
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
Thread-Index: AQHVrwuxR+1ZEaCriEa+CGCL3lP4K6ffGBkAgALhg9CAAEMegIABkMMAgAAdn4CABKu08IAAEOIAgAGFg8A=
Date:   Tue, 14 Jan 2020 10:34:51 +0000
Message-ID: <HE1PR0801MB1676C93AF0AA7980F4A79B3FF4340@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-7-jianyong.wu@arm.com>
 <7383dc06897bba253f174cd21a19b5c0@kernel.org>
 <HE1PR0801MB1676AB738138AB24E2158AD4F4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <099a26ffef5d554b88a5e33d7f2a6e3a@kernel.org>
 <HE1PR0801MB16765B507D9B5A1A7827078BF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ca80d88f5e00937fca7ee80be8f5c962@kernel.org>
 <HE1PR0801MB167693BFB769ACEEA8A6B007F4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <22ba1283a7b82f018c1fdf85414e5bfe@kernel.org>
In-Reply-To: <22ba1283a7b82f018c1fdf85414e5bfe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 30ff59ce-40fd-40e8-bd50-0c283624fabb.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb87c7b3-cceb-4dd4-f98b-08d798dd674c
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1676:|HE1PR0801MB1676:|VI1PR0802MB2493:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0802MB249324583E6E1C73BFF5B5E2F4340@VI1PR0802MB2493.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;OLM:6430;
x-forefront-prvs: 028256169F
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(199004)(189003)(2906002)(54906003)(316002)(5660300002)(52536014)(478600001)(33656002)(86362001)(4326008)(6916009)(55016002)(7416002)(7696005)(71200400001)(8936002)(81156014)(186003)(81166006)(9686003)(8676002)(66556008)(6506007)(53546011)(26005)(64756008)(66476007)(66946007)(76116006)(55236004)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1676;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Nk98rnE1mlVgCWC4ypXsAgy0trOdNDzrcZiAu/NaxJ3DsQlyHH6L65mWmQwU39jlk1XSScG0tLjPQwEy6KGvt2bgBRYSrabd1K5v49CH/fa68rmxwjJpBOmaTwLIp0BWyeibB5CD99qx6ZMTiG4S7vL4oQvR59ZsVwJvGB4Ik098VYKF8pdVlAEWSYmb6dDo0/FxIqcwGoh1W3HhCffQqGddMgHBy3/qFtfUfTVTpFY0NQLuDE9yEvvqTh42L+kqyehggiiwo4xtXk8HaKtd5CHRatpkH2ykpykbHbCFbn2SEVsyPwuVLorK+KoCgsjVLMwiWnF9ANMc4vgsetZFbwMlKLrOUUHS5mJiHwCmsRJjurgQic02erBcnhAe0R4NAe6AGx3076vWtQPxmwIMgLIdHIo0oNVoHbRy+LnMP4v3/TaeBGxDpNnnwOfAfi45
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1676
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(136003)(189003)(199004)(478600001)(7696005)(33656002)(6862004)(52536014)(5660300002)(54906003)(26826003)(316002)(86362001)(356004)(6506007)(81166006)(81156014)(53546011)(2906002)(450100002)(186003)(8676002)(26005)(336012)(4326008)(8936002)(55016002)(9686003)(70206006)(70586007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0802MB2493;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: bfcdd766-b44b-487a-a34b-08d798dd6320
X-Forefront-PRVS: 028256169F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtLkz09q3jslbRe1u7buNXak9glF+EM6IHOnVGHVxGOCweY9hgn+HS6xzUlNoz99ifI6TkQid0VmOyxQe+mrxR9Zzbvri+01ZTFEOPz2VkXQENdWiED3MLHGKKv39KBPC3qX0VMhh8eyUnImrsR1CHxzO0EcAw3cOB9uF/ZiVCliSThhuH31f7t8SeQbSrp5zdNMJ+dilvwkspMXmIonlwOAwihALERQrgiYSjpsgdbsYBinmrbD1SyyheOiVPjDfwa+555jV3ggSbPDz/Eb0wT5ZVeUix/1iPg61SeQjeq6YWjHBIkC2oogw78343AQCOoJq5OVSWzbV4rCd9Qn2IXBIWpzYg1/5LnXEjk/q9rmRSxO2/G6K1K7lsOyPmPLRHX6y2VLuLmsucy504EWIH5sWgq9AN8PY5krZSQHM9zSHX9EnpHFS5g+SiHcj8/2
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2020 10:34:58.3435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb87c7b3-cceb-4dd4-f98b-08d798dd674c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0802MB2493
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, January 13, 2020 7:16 PM
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
> Hi Jianyong,
>=20
> On 2020-01-13 10:30, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Friday, January 10, 2020 6:56 PM NV breaks that assumtion,
> >> because the guest hypervisor is using the physical counter. Also,
> >> let's not forget that the hypercall isn't Linux specific.
> >> I can write my own non-Linux guest and still use this hypercall.
> >> Nothing in
> >> there says that I can't use the physical counter if I want to.
> >>
> >> So somehow, you need to convey the the hypervisor the notion of
> >> *which*
> >> counter the guest uses.
> >>
> >> Does it make sense? Or am I missing something?
> >>
> > I know what you say. Let me try to solve this problem.
> > 	Step 0, summary out all the conditions we should process, which will
> > sever as branch condition.(now only normal virt and nested virt, I
> > think)
>=20
> No. You shouldn't think of the various use cases, but of which time
> references a guest can use. You don't need nested virt to use the physica=
l
> counter, for example.
Ok,

>=20
> > 	Step 1, figure out the set of reference counter value used by guest
> > in all condition.
>=20
> That should be for the guest to tell you when it calls into the PV servic=
e.
>=20
Yeah

> > 	Step 2, determine which reference counter value will be used by
> guest
> > in a certain condition in hypercall.
> > In step 1, can we give the set only 2 elements that one is physical
> > counter the other is virtual counter?
>=20
> I don't think returning the two values is useful. Just return what the gu=
est
> asks for.
>=20
> > For step 2, I have no idea for that now. can you give me some hint
> > about it?
>=20
> Just expand your SMC call to take a parameter indicating the reference
> counter, and return the sampled (or computed) value corresponding to that
> counter.
Get it, I'll try it.

Thanks
Jianyong=20

>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
