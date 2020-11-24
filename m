Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8B82C22AA
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731761AbgKXKTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:19:02 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:58631
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbgKXKTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 05:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=Z6lfIbJcDcjHQ/970fS+IPyjiisSIK/umspDaz/2Jw33EHnlYZKASih9bHAQzD3WhCRUaAI/DuYa5DUAZ4bLZKoNx2cqZwe/D97LI71XhuGi+rsBcJRCdFk8JyB7qxIznql/2fRcz7k578VOvvNAey6cmk6dpkG5yAVOu3c2MHE=
Received: from DB8PR09CA0032.eurprd09.prod.outlook.com (2603:10a6:10:a0::45)
 by DB8PR08MB5100.eurprd08.prod.outlook.com (2603:10a6:10:e8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 10:18:52 +0000
Received: from DB5EUR03FT020.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:a0:cafe::f0) by DB8PR09CA0032.outlook.office365.com
 (2603:10a6:10:a0::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 10:18:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT020.mail.protection.outlook.com (10.152.20.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 10:18:52 +0000
Received: ("Tessian outbound 39167997cde8:v71"); Tue, 24 Nov 2020 10:18:51 +0000
X-CR-MTA-TID: 64aa7808
Received: from 207553ae8e72.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 0B403D2B-F03D-4364-9D68-1F039F6F03DC.1;
        Tue, 24 Nov 2020 10:18:45 +0000
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 207553ae8e72.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 24 Nov 2020 10:18:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1SnG39kvykEk7Z7s8fTboS3EYmCx0caiF0IJsQy1WF1Kz7q5xGfWbSP2NkyOrAK1ucai0rN84GnUx29K1IPGzHKarJACinHQl7lSvv6uL7yXi/qML112LJ+C7NJELCtQ6Aoj8dNTC0Cu8R5nhJFjfYiweUJ8+1WckTsK0Hdpfzjyf7hqdgK8gpSofyYUhsdiSmwFOM/D8OlxXWNdunGS1dRXAqUAeUplB16+qGhNb2v02D5jC79264Qfhx0bD6G1mR1O3WxiirmbIQrAiaKlpKaTQZQleepy55SWHIHKverorzhBIyXZYzb1DIhyBt/3yemXapUKyRLL57ntomsSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=VP8SF6zGA9dzjTYVcGoohsI8UaFL6LAPiROieJjgO8vK95u1iRa7Kg+qsmzEU7hzkTK/TVAirHcNfa+pcJZ65MHQ07aQQCiwVe/tvPaZaqct7HrPPM7RhWqHB+2OooQAhIfmFsNn94a2qlqqZnk0kbohyNqDEBo6dKoWB8AcereNR7Xmli1od4MjGhZRfTitxo/J0dA/XOtYelbYQRAdNthj4062oel+ICodjQfb8UDs+rJuVwDzUnbik1jWQL8pIJLtlFPa5XsfKwPYUrpbWyJHzk4GBF3aUrQ0wls6LzPsg2/MjqhCKt+lTVzn65yqQNeftimSnY/DnwZHRjJy9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5ZM0YbzVNLfTgEOggSw2Ayc/XGetNdHpoJdwlwHejA=;
 b=Z6lfIbJcDcjHQ/970fS+IPyjiisSIK/umspDaz/2Jw33EHnlYZKASih9bHAQzD3WhCRUaAI/DuYa5DUAZ4bLZKoNx2cqZwe/D97LI71XhuGi+rsBcJRCdFk8JyB7qxIznql/2fRcz7k578VOvvNAey6cmk6dpkG5yAVOu3c2MHE=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2345.eurprd08.prod.outlook.com (2603:10a6:3:ca::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Tue, 24 Nov
 2020 10:18:41 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 10:18:41 +0000
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
Subject: RE: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for arm/arm64
Thread-Index: AQHWt/M8TW7h8ytFwE22PYJVJt7LOKnVnLWAgAE22MCAAD5PgIAAE2zg
Date:   Tue, 24 Nov 2020 10:18:41 +0000
Message-ID: <HE1PR0802MB25557885DA7391D52353B7C5F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
 <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
In-Reply-To: <5dc5480d125ace6566ae616206c3ce3f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6C9A8ECA3BBD124CA8B1E58DDB01C145.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a92ab8cd-6d6e-4676-d21c-08d8906257c2
x-ms-traffictypediagnostic: HE1PR0802MB2345:|DB8PR08MB5100:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB5100071B4EE927CBB49BDB55F4FB0@DB8PR08MB5100.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1303;OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: w9l1jtjjkYnDW+DErIKgqqauzHfZ7rAzPreYqNR0rVyGXKAwYDmZXSNje4XGJ4fgqsaRZiiD8HS8ztrS9/JhlyB6qyD8vW7S41+RfR86S7bTuZxRHSKrAI3mr9GJAMeE96cD5722I4tqtleC6qzfegl9bQx9tbbRL/AFMdFQDqnCIUbGgJQGeSJJdVDrW+SuKJK7PA5FZSvJ/ON3unv1jBB2DkD6p+hmyz6zahyL1UPrpjNuWLXTzCtaCrAc0bUBVsv7NUS9wI1vMcLhjyd4SfmDRcPGNPTehLGB1Pami2yBWQeY4tNUw5Sz2DrGQmyYRxCxVAf4ohj4r6JQOjLIXQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(4001150100001)(66556008)(64756008)(66476007)(66446008)(5660300002)(76116006)(66946007)(86362001)(2906002)(26005)(4326008)(52536014)(316002)(8936002)(71200400001)(186003)(83380400001)(478600001)(7696005)(54906003)(6916009)(7416002)(9686003)(8676002)(33656002)(53546011)(55016002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: cgtQvvJpM3NGMhe7EV0TnLAkHegiCRq9mXLcv8MdYZnmRhsd/a3yL3jHUxzSc6/TPNPgYTGTwte7EjTjzY7Q4tiFAAoIiisHa+/f5sEZ7v4gtQgAypnlcXYLwDTtpHrz6I7mduAMWWbD7YFBzMs0qzTFHexMRtKLypxiY8k0Hi1iC5MSvE29yCbTqJBuZV7WSbyTp9fl0GoNp7p1wFA5BpQoRKYgLij5ZMlnNqWSUyewvAW4iHtSC6CXuBIBYTRo0JVeuN2kWmDtfBcBIvLIR9hDi1VsfTeIvIdj+wQqMZj0AbUbtxMXugD8vSj0KaT76cQpYaMU02oEWWGzy2Fi95w1A3xMzuNMX0Pf3MSVxXOiScawFrSAOKkd0KduCN92oOYrLUDINPV1sc/dwqzH4C/GXZ76bGPDaQNB/AsERrw752nguyHKNTgRd4dXzPZJennyVk//G/zCSh3iGlUR/fkgXsj+Va53JrALTI5cYypIuV9bUAIdg4sSdnvL6wtG9GcUQEChFr5OSx/D6i3HVQI8GFf3c4kJYgaIy/vn08JID0S4+ienyzO6qLYIcCG2mY/p5CYDPbBro+0dqbRMb6Qh37vE1JdRTK6X9gkHQI9M3BaJsnB9sxNGbgCmuAG5xsL124cgU3t63cQsLHb/wdTI7nky+aF044PuUkCmEgNkJx9r3YZW5U+PQivO8buZv8c4vP0SIbrhC9FroVClgJl8ZRYSLHbwurs1fS2k0umoD9Drh5Xw/k7NYfcSGM8WqyXI4Z0i9zO+LJ12AbxgNYNjZWPwtoDt+2iLRP7wHEpS99cZurcD8EM6Ct9JnB6MHrq0gp8Ya8OKw2S/ZtZjCNm9/4Of0ZIbjxWHoV0BiZwsOcHa3/iRgrLaPO+zfEsM+Vhvqds63USUP3lCew6efA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2345
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c9794146-e0e3-4b76-830a-08d890625137
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azLIXGBURTuK+j7d9l3mAI3ExZ21UNwA8wS2IX9WqK+7i59CECJK09IEoXmiJBNxJLz/C7DVrRqg7SYB/HQ8wzIDtsCsBBf3hBskKgwlfXkNigCk13AfCdCrfY9UeTMvPR9h84b6K0FZlgvR5TgrDDRcqAiCJAcaVjsTSyh9x6bsp97MpB/cDfhJF3NnBYzlUgLS/07RwuJ1nEq/AVJWk33JzGd/uMjksWoZZzNPVKywPpmnmCgJdICx43jUFgQDCf0/VO/cwkBbrWRnh0bmcGlDELP+gZsliJCqOhAc2zEl8c9E7lCDhYI84q1lDkW5yLJhPAe3144fFWwvaeCq6gdpgPbS/0RWnHR4rxCdAlHaSZWXJOOL1sqKDca5eWbeoXokAd9PeW1mXmLQfkS6Pg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(376002)(346002)(46966005)(86362001)(70206006)(6862004)(478600001)(4326008)(53546011)(82310400003)(52536014)(450100002)(6506007)(33656002)(8936002)(336012)(4001150100001)(55016002)(316002)(356005)(26005)(81166007)(70586007)(186003)(82740400003)(47076004)(9686003)(8676002)(83380400001)(7696005)(5660300002)(54906003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 10:18:52.6380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a92ab8cd-6d6e-4676-d21c-08d8906257c2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT020.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Tuesday, November 24, 2020 5:05 PM
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
> Subject: Re: [PATCH v15 7/9] ptp: arm/arm64: Enable ptp_kvm for
> arm/arm64
>=20
> Jianyong,
>=20
> On 2020-11-24 05:37, Jianyong Wu wrote:
> > Hi Marc,
>=20
> [...]
>=20
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
> >>
> >> I really don't see the need to use a non-architectural counter ID.
> >> Using the virtual counter ID should just be fine, and shouldn't lead
> >> to any issue.
> >>
> >
> >> Am I missing something?
> >
> > In this function, no counter data is needed. If virtual counter ID is
> > used here, user may be confused with why we get virtual counter
> > data and do nothing with it. So I explicitly add a new "NONE" counter
> > ID to make it clear.
> >
> > WDYT?
>=20
> ITIABI (I Think It's A Bad Idea). There are two counters, and the API
> allows to retrieve the data for any of these two. If the "user" doesn't
> want to do anything with the data, that's their problem.
>=20
> Here, you can just sue the virtual counter, and that will give you the
> exact same semantic, without inventing non-architectural state.
>=20
OK, that's it.

Thanks
Jianyong Wu

> Thanks,
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
