Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB977138F4B
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 11:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgAMKiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 05:38:05 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:37382
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbgAMKiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jan 2020 05:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2IsnjHPw96qnN4tKtlGg9Dneuyk7M2uLULt5ulWWvg=;
 b=Hzw8veuBLudHI5/cPbn6T4lfzelgBlG8xsgBNpSOBbnxHSuOGQ9wlxVK+LT+NqVNOawoGko6YnICovZW7cXnMRCr5GNBAIdoWWqdj3LPpXVdhcTdwn5y7g7zunhlsAQQwpPjTorI4Dz3AmPhACVQ/JnshOyM4nyTgynnVsCR4Ss=
Received: from VI1PR08CA0095.eurprd08.prod.outlook.com (2603:10a6:800:d3::21)
 by AM0PR08MB4483.eurprd08.prod.outlook.com (2603:10a6:208:145::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9; Mon, 13 Jan
 2020 10:37:57 +0000
Received: from DB5EUR03FT022.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e0a::200) by VI1PR08CA0095.outlook.office365.com
 (2603:10a6:800:d3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Mon, 13 Jan 2020 10:37:57 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT022.mail.protection.outlook.com (10.152.20.171) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.11 via Frontend Transport; Mon, 13 Jan 2020 10:37:57 +0000
Received: ("Tessian outbound ca1df68f3668:v40"); Mon, 13 Jan 2020 10:37:57 +0000
X-CR-MTA-TID: 64aa7808
Received: from b4b015b4fabf.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id FC6CFA66-DC93-421E-A3D0-E669EC97D769.1;
        Mon, 13 Jan 2020 10:37:51 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id b4b015b4fabf.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 13 Jan 2020 10:37:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxwOJYLMmKI5fdXPC3bLONt+MZl4j+Bhqgf0vjK21xOOmo5BMacbIuW96sfzxIOOcKEbm5OrNdlXuMrPVz4a5KdJfBu2sLmOgHYyOVfOL/ab0X9/j0RwBdsmqqvRD3uOKhjNC+yN8WyYTcSqqhlZAsaZksdlDoMHxJ0k6kVNpU2R7WGtV/rFZQIsQCDQWOWbZk4UAQQ7aVgBFVZD3U8ghuTi0bTOplFhMZe3YBBxicT9h428onL/4WR+SzUOLeLEsn7pwFfVT8jdzRyawWcqecjKi8jIfo2D6Z9H+pskHxW0dln+Q/NjrU6qsI2yOVRNMk0VcaiVAhf+NqH/S8BWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2IsnjHPw96qnN4tKtlGg9Dneuyk7M2uLULt5ulWWvg=;
 b=kWphFGLffkSjAXLt21pvZpF+6a4h4DvZPGUSenINXvpm/5wbUXsWUeHtoGdjSvSUFmPLVoVrzpCrGIBKc+EXW/macLYQWYTj+wOlZgYs/z4xPgtsbu9YG4eGPHERx2uBoQuSV9dkA2rAPZ0+MRM/lfd9WeqMIHGNw+tTSGQK8bzz3fpUzwCCBOLDGmB19bLgb2Rm2veNRm7zog2pZXea6d+o5AVnEACRNZrEpFy9O8zNggbjSxLQcguQURoEkZR9Exw9x9Txts6bA0Dt1lCAGpLKGIU4LhyOYav6X2UaMnYY/KUv+8GGHkslcGsChJIloV60F8IJSllQUqMi03AEKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2IsnjHPw96qnN4tKtlGg9Dneuyk7M2uLULt5ulWWvg=;
 b=Hzw8veuBLudHI5/cPbn6T4lfzelgBlG8xsgBNpSOBbnxHSuOGQ9wlxVK+LT+NqVNOawoGko6YnICovZW7cXnMRCr5GNBAIdoWWqdj3LPpXVdhcTdwn5y7g7zunhlsAQQwpPjTorI4Dz3AmPhACVQ/JnshOyM4nyTgynnVsCR4Ss=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2025.eurprd08.prod.outlook.com (10.168.95.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Mon, 13 Jan 2020 10:37:48 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 10:37:48 +0000
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
Subject: RE: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHVrwu1ZTEnzkrQbEOo/hXDFqaU6affG9SAgALmpVCAADyUAIABmc4AgAAMSACABLWzgA==
Date:   Mon, 13 Jan 2020 10:37:48 +0000
Message-ID: <HE1PR0801MB16765F2905CD0F381E33AD9EF4350@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20191210034026.45229-1-jianyong.wu@arm.com>
 <20191210034026.45229-8-jianyong.wu@arm.com>
 <ca162efb3a0de530e119f5237c006515@kernel.org>
 <HE1PR0801MB1676EE12CF0DB7C5BB8CC62DF4390@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <ee801dacbf4143e8d41807d5bfad1409@kernel.org>
 <HE1PR0801MB16765B52E5DCD8EA480EDABFF4380@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <a85deebc23c1fa77e6f70b6eaef22a34@kernel.org>
In-Reply-To: <a85deebc23c1fa77e6f70b6eaef22a34@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: dc938f51-5418-4b65-a328-0b2ce92da0b7.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12468cb4-c96c-4ef8-a10a-08d79814a76f
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2025:|HE1PR0801MB2025:|AM0PR08MB4483:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4483F7198180DA7BB3BCD396F4350@AM0PR08MB4483.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: True
x-ms-oob-tlc-oobclassifiers: OLM:3173;OLM:3173;
x-forefront-prvs: 028166BF91
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(189003)(199004)(8676002)(7416002)(55016002)(81156014)(71200400001)(9686003)(86362001)(4326008)(2906002)(81166006)(55236004)(53546011)(76116006)(66446008)(54906003)(6506007)(7696005)(6916009)(33656002)(66946007)(66476007)(66556008)(478600001)(5660300002)(64756008)(26005)(52536014)(316002)(8936002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2025;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: rSkPb1/C+8sPgsge7r6JI+ZAKnU78qHmaIlm8zIbY43ZZlnFAcBFE39u8u4fpCnPvddQMc/0IXT4uKgw24lMjZ8jjEYa2q8fbLpVhpHx8dZFg63pUc8c/T4DX+OyN5CP9IQnYmO+igVgF8L9ex/FP3xtZlbyaKiP8Of690uZwALQ3uoHiCUcX8Oeb/q61wjUX7VrvxGGAyyGPvTiYEYNRJVq97qs3Z/H03ygWA3E2BUYM+DQ0HYrAq2vcODTngmRZBVvdf8ISp5tZKDmvivAf1OJCzAK7Gv+IrPHAI5wAzZK/+kIvOXGB//VcJ8/62w7ieTmB2aCpfB7R978ft4BxHuwEwdTsjuEPkkCr8VShb8mYgt+aFJUqkQJ3DazFAENVcx3dxaJoeyIns8Znub+AcupC8ma8dVcCwtfnysFCjWOXqSV7m3yh6480O2yCg54
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2025
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT022.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(396003)(136003)(199004)(189003)(8676002)(81166006)(356004)(316002)(9686003)(70206006)(81156014)(86362001)(2906002)(26826003)(478600001)(54906003)(8936002)(55016002)(70586007)(33656002)(26005)(186003)(5660300002)(7696005)(6862004)(450100002)(6506007)(336012)(53546011)(52536014)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR08MB4483;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 8a655d6e-1410-4fec-8c1b-08d79814a27c
X-Forefront-PRVS: 028166BF91
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZeNNckZEoOm5IgK8s2XBu2p1W6rtdlW870enQ+8CyZ7FMLhxjVyYP8v58EIkA+gLvn7UWAXjZh0fVgEk43KGdDSY+UTHQwXkOmYxPmUFA/atOvleOLdAyhSfNNyZV6qHrjzL/5G2Q3SYA19eQCVi8+cnhIpD2EVKvrgVPuHvYLDFohaC3PEbhmKAORhtllQLdkgarqeZZY6sLZyc2ceEQDnYSq+hUeFk+yZBGuUrUWrHlE2T/ECcZGaBGBClbxhm53I9URhyePeg2AMGmG2rq/0LCClueAE3fkYuz1UYqRGb/OheizpnTviX3Wz7xQsC4ZsAQto5TufsFDQ2LtxZ2FnHF3aUYeFX7Cc+q0LGWbwcWlqd4/sBEUjcCM9xuRkSxim9iHYrquQkOrbX0RAWuTez7uIBIR5jBztahDPJ8IlhcvIFM4DKLZTd0FBYGoEk
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2020 10:37:57.0832
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12468cb4-c96c-4ef8-a10a-08d79814a76f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4483
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Friday, January 10, 2020 6:35 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v9 7/8] ptp: arm64: Enable ptp_kvm for arm64
>=20
> Hi Jianyong,
>=20
> On 2020-01-10 10:15, Jianyong Wu wrote:
> > Hi Marc,
>=20
> [...]
>=20
> >> >> > +	ktime_overall =3D hvc_res.a0 << 32 | hvc_res.a1;
> >> >> > +	*ts =3D ktime_to_timespec64(ktime_overall);
> >> >> > +	*cycle =3D hvc_res.a2 << 32 | hvc_res.a3;
> >> >>
> >> >> So why isn't that just a read of the virtual counter, given that
> >> >> what you do in the hypervisor seems to be "cntpct - cntvoff"?
> >> >>
> >> >> What am I missing here?
> >> >>
> >> > We need get clock time and counter cycle at the same time, so we
> >> > can't just read virtual counter at guest and must get it from host.
> >>
> >> See my comment in my reply to patch #6: *Must* seems like a very
> >> strong word, and you don't explain *why* that's better than just
> >> computing the total hypercall cost. Hint: given the frequency of the
> >> counter (in the few MHz
> >> range) vs the frequency of a CPU (in the multiple GHz range, and with
> >> an IPC close enough to 1), I doubt that you'll see the counter making
> >> much progress across a hypercall.
> >>
> > Sorry, I will avoid to use those strong words.
> >
> > It's really the case that the hypercall won't across cycle in general.
> > But sometimes, kernel preempt
> > may happen in the middle of the hypercall which we can't assume how
> > long before schedule back. so it's better capture them together at the
> > same time.
>=20
> Fair enough. Please document the rational, as I guess others will ask the
> same questions.
>=20
Ok

> Then the problem to solve is that of the reference counter, as you so far
> assume the virtual counter. I guess you need to be able to let the guest
> select the reference counter when calling the PTP service.
>=20
I could not come up with an idea about the point where the guest give this =
info of counter value.
Where we give that interface to ptp service, as it's not a user space appli=
cation.

> [...]
>=20
> > By the way, does nested virtualization diff between arm64 and arm32?
>=20
> There is no nested virt for 32bit (it is explicitly forbidden by the arch=
itecture).
> =20
Ok, thanks

Thanks
Jianyong=20

>          M.
> --
> Jazz is not dead. It just smells funny...
