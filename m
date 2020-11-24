Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FA72C1DA1
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 06:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgKXFhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 00:37:45 -0500
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:25473
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725616AbgKXFho (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 00:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=M7f8z1xVJuvm5gdEDTijmTvnb2B7WoT/dwQykeAdNuqtVtrNle21Iwfai2nx+J/f1OsENm1pqtrq8vGz9xBMjy0nJa2CPxmnBGVo/YWSAVdSwIyrOOWrBRQsS7dDwW+9JXSw9L5Jkf4WbdkDONbIyLGBU6LoNXmhvWro85TG/m4=
Received: from AM6P191CA0077.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::18)
 by DB6PR08MB2919.eurprd08.prod.outlook.com (2603:10a6:6:1e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 24 Nov
 2020 05:37:32 +0000
Received: from VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::e7) by AM6P191CA0077.outlook.office365.com
 (2603:10a6:209:8a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:37:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT018.mail.protection.outlook.com (10.152.18.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:37:31 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71"); Tue, 24 Nov 2020 05:37:30 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8bbd5a06462b.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6DCDF244-920A-45C3-8A2D-E32A8D7B0847.1;
        Tue, 24 Nov 2020 05:37:25 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8bbd5a06462b.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 24 Nov 2020 05:37:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gA/ZovE8sdCPmqbNMWtHS+5WQsiC/fqSIokjGD23dWzBMHmLutnpoKnNOYa8or1N1XXUuUQkHEMVvxldtK/NQsdxXA1pXMjDMhhgbAlBeV7vgl26RFupyom/91UyuH1Rs5S1DJ0aMl9QSdQRHgZwklbx2F7GcK6gt907HQ4OHkRDRLIFFu5MadVVtGewsfWCp70x76E9/qDTwknk7NsdCtplBLWN7Gr1++fmQlM4bwKqdez6eFATr8Lnyyy7H8TE+/u/TfUcGNRTXyCnSIhoeDxSvvE9Lj1l0/VgJ5lqzlDEIuGDP5NEiuMddXIQP50iYc5LtU5zJ7758NMICWP+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=ZOXhRHbgcvVDTucDniBDqjlSxcOpRxkOUmmxw7fwi6NjGOlugoZLfzQrVoG91dij3gS/3VhCs8MoCFbL+w+ZLyXvnALuMA9Q0XCRF3WzlC32Zt6yemd5GKQ8+2VTX+4RxpGdb0lMrJxHbHnvE8U3geThB9RaPfW/xuNer7AQK4o0pkEp4fVtS1Tt1LlfsKSchpJHVwbbBJBqpmRNA+k1sXEtiVEHVf9jK5MvRVMTJYIea7NX+pUzxnMwA/xhznqVI/lilguYj5GdgXctSn5dcc0YW5PyP06V6DwB8aY2yy+UK1sRfBSTCGQSeycA8PtPpHZdR3m83mA93XQhkjCahQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPcSd9et9D9kYd1nzxxQUUu7Rndy/ovi5rtgozcAL2A=;
 b=M7f8z1xVJuvm5gdEDTijmTvnb2B7WoT/dwQykeAdNuqtVtrNle21Iwfai2nx+J/f1OsENm1pqtrq8vGz9xBMjy0nJa2CPxmnBGVo/YWSAVdSwIyrOOWrBRQsS7dDwW+9JXSw9L5Jkf4WbdkDONbIyLGBU6LoNXmhvWro85TG/m4=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1881.eurprd08.prod.outlook.com (2603:10a6:3:55::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 05:37:22 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:37:22 +0000
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
Thread-Index: AQHWt/M8TW7h8ytFwE22PYJVJt7LOKnVnLWAgAE22MA=
Date:   Tue, 24 Nov 2020 05:37:21 +0000
Message-ID: <HE1PR0802MB2555C5D09EA2BF0BA369BE37F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-8-jianyong.wu@arm.com>
 <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
In-Reply-To: <7bd3a66253ca4b7adbe2294eb598a23f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6326F7F8614FA349943B6F4E755C265E.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 10adb08e-4144-4761-a2cd-08d8903b09e9
x-ms-traffictypediagnostic: HE1PR0801MB1881:|DB6PR08MB2919:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR08MB2919EE6CFF6E1888EC6E9B17F4FB0@DB6PR08MB2919.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: QmrcusFpBuuZXZXc6oSVZp0dWrP3PB7Uvh+uxCvHIMdVTfW9JJmL3Lr3xRiu+RFG+7iyavk/9+KfiRB1o+Orm+WkKsITMQsWNushcTzC+6Oo1nzDPL0lBBF2ahaUlqpxiJi8gSupTSpSYzzp/PQNmulS2wwuxOiDIPfR8kqNqvOH9G9GkRuDCGjRnP/heJlQCvkh0foWZUUPy3ptcNJ+ihSoOe7qVrP4BBNRS2IpSoPWr0ejCPs6aw+MLzKoaq+gOvbSZUaAlU3fxeZWqfC3mgEWXqmrHDTJOQDXXeEURo6zXSqbZI8ssXjy7XGeiaen
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(76116006)(66476007)(52536014)(186003)(5660300002)(26005)(66946007)(55016002)(86362001)(4326008)(4001150100001)(9686003)(316002)(7416002)(33656002)(6916009)(54906003)(2906002)(66446008)(66556008)(478600001)(6506007)(7696005)(8936002)(83380400001)(53546011)(8676002)(71200400001)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 44nlNso5msO92xsJVDqXUoGnKJVWV7XVa1gbDKAioHMEBQZ+nNYAmPrTIacwf1j5d1NdHaHWMZyIguKlrckUygulnwRo4aIJWQ5dEuJGnm5eHssShiPbveL47Xlm9YhutdG6qNLxMO5fBgGnXfHmi0LYLltDKQeBKSwSWB8+I0K77RZj0RIGvOcSbSe8kOqRugyfuLcxnFmoVMlV4+185QGXzqIA4+Jfup5nwqQKhHRg130o8cUUVMW6eQAHpWEdm1TQozO3VDFpDr4Yw/dE83en2Lrt/Pp3DDnVucZbEPBRjoWJqSI6Bj6T73g1oB96effW2LZMT5iL4oQx4dqFPPAvaamCFVkY/5hxcMzZ4bEbBS1Oky8v3zD5yhECkrbRmlGbOUnbwwN+QnpzixvWAJvccI1v4TLNFUvxpeC3c2Sq+zJduXz64uTeRhG06CDqGbcCoiAJHNEv+Tvv97GotwKqygxZkcwGAP1D72pqSPXgMHtGIbfGII7Pa5pPnn9++GVeMkkAs9e2ahKPwts44k4leTvdG8qPAJP3e9u9PYLmbDiEESbGAQrryEJaUMq7Y6ZoYI0zORhLRS1V45gk0Worn6JqLtYFFw2BomJ76zlV53zctKqi2A0zxcFiPeZPuE3EFlCN7UaQSy+FBMnBSLo3Op1P2iAcBKI3OX7Pnx48YUscju87liaveUZqCn0qoqM5n0ZKsNnfHykZBL9kMXwwB3fjGr1GJWWlR2q/BBVZGqMoZtiippOJGKTFGKtsfmZDVsOEshsV0L+Y5TAXkF1/9DVvPK/NtJa7pqyoX4Oh+qCgv9VwcwKcoJf+7NPk0ztzc1jPCjejHAA0843s3YTKxofmZT+kD0J5DkFlwIdW6UnmeHx5yxvv2gzllBdnykurRYF+q1ngQNTV4AWaPQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1881
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: b554fa0d-892c-41f1-80dd-08d8903b0438
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CGQZj7vQ691eS1kztlM9yMKjvjMqQMOfH6KLVOALYe9WqQ7h4+LrhAV3bR8gPVNRTQHye0BI1HqWXYf3OHHMfy5XamG0dE7Nw4tBRyuh8OUJuEHUjouLugqe4e7P/FFkeAfbVLR+0PDa6CAvLjpV4800Cyh4v2649op8miCiM+vENPuiNdb0j1oFor7PXaQlf2l3JN7toFPUstPFRxT/ZcHyWzhXURw57wD8PNXMqbCWXRuTJ/p4ok5U6oiXu/7LEjo8pV9S2iId5xZUB2aLUAI7miA9MSi1ZPTQ4C5O92TZhtgAS9c8szHGs607InR3AjAN4/oxZOQbVYz1DnlKwl6/qdpR8GjyMgxdqanFRZOeCUgJFFtdpS6ccl88i6AcoTiokfKcxtlN2r1k7AM39A==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(376002)(136003)(46966005)(356005)(2906002)(47076004)(53546011)(70206006)(478600001)(26005)(4001150100001)(82310400003)(6506007)(186003)(5660300002)(52536014)(70586007)(8936002)(8676002)(82740400003)(83380400001)(7696005)(336012)(9686003)(33656002)(450100002)(86362001)(81166007)(6862004)(316002)(54906003)(55016002)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:37:31.4153
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10adb08e-4144-4761-a2cd-08d8903b09e9
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT018.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2919
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, November 23, 2020 6:49 PM
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
> On 2020-11-11 06:22, Jianyong Wu wrote:
> > Currently, there is no mechanism to keep time sync between guest and
> > host in arm/arm64 virtualization environment. Time in guest will drift
> > compared with host after boot up as they may both use third party time
> > sources to correct their time respectively. The time deviation will be
> > in order of milliseconds. But in some scenarios,like in cloud
> > envirenment, we ask
>=20
> environment
>=20
OK

> > for higher time precision.
> >
> > kvm ptp clock, which chooses the host clock source as a reference
> > clock to sync time between guest and host, has been adopted by x86
> > which takes the time sync order from milliseconds to nanoseconds.
> >
> > This patch enables kvm ptp clock for arm/arm64 and improves clock sync
> > precison
>=20
> precision
>
OK
=20
> > significantly.
> >
> > Test result comparisons between with kvm ptp clock and without it in
> > arm/arm64
> > are as follows. This test derived from the result of command 'chronyc
> > sources'. we should take more care of the last sample column which
> > shows the offset between the local clock and the source at the last
> > measurement.
> >
> > no kvm ptp in guest:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-
> > 21ms
> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-
> > 21ms
> >
> > in host:
> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-
> > 18ms
> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-
> > 17ms
> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-
> > 17ms
> >
> > The dns1.synet.edu.cn is the network reference clock for guest and
> > 120.25.115.20 is the network reference clock for host. we can't get
> > the clock error between guest and host directly, but a roughly
> > estimated value will be in order of hundreds of us to ms.
> >
> > with kvm ptp in guest:
> > chrony has been disabled in host to remove the disturb by network
> > clock.
> >
> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-
> > 3ns
> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-
> > 3ns
> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-
> > 6ns
> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-
> > 5ns
> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-
> > 4ns
> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-
> > 4ns
> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-
> > 4ns
> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-
> > 6ns
> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-
> > 4ns
> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-
> > 4ns
> >
> > The PHC0 is the ptp clock which choose the host clock as its source
> > clock. So we can see that the clock difference between host and guest
> > is in order of ns.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  drivers/clocksource/arm_arch_timer.c | 28 ++++++++++++++++++
> >  drivers/ptp/Kconfig                  |  2 +-
> >  drivers/ptp/Makefile                 |  1 +
> >  drivers/ptp/ptp_kvm_arm.c            | 44
> ++++++++++++++++++++++++++++
> >  4 files changed, 74 insertions(+), 1 deletion(-)  create mode 100644
> > drivers/ptp/ptp_kvm_arm.c
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c
> > b/drivers/clocksource/arm_arch_timer.c
> > index d55acffb0b90..b33c5a663d30 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -25,6 +25,7 @@
> >  #include <linux/sched/clock.h>
> >  #include <linux/sched_clock.h>
> >  #include <linux/acpi.h>
> > +#include <linux/arm-smccc.h>
> >
> >  #include <asm/arch_timer.h>
> >  #include <asm/virt.h>
> > @@ -1650,3 +1651,30 @@ static int __init arch_timer_acpi_init(struct
> > acpi_table_header *table)  }  TIMER_ACPI_DECLARE(arch_timer,
> > ACPI_SIG_GTDT, arch_timer_acpi_init);  #endif
> > +
> > +int kvm_arch_ptp_get_crosststamp(u64 *cycle, struct timespec64 *ts,
> > +			      struct clocksource **cs)
> > +{
> > +	struct arm_smccc_res hvc_res;
> > +	ktime_t ktime;
> > +	u32 ptp_counter;
> > +
> > +	if (arch_timer_uses_ppi =3D=3D ARCH_TIMER_VIRT_PPI)
> > +		ptp_counter =3D ARM_PTP_VIRT_COUNTER;
> > +	else
> > +		ptp_counter =3D ARM_PTP_PHY_COUNTER;
> > +
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +			     ptp_counter, &hvc_res);
> > +
> > +	if ((int)(hvc_res.a0) < 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	ktime =3D (u64)hvc_res.a0 << 32 | hvc_res.a1;
> > +	*ts =3D ktime_to_timespec64(ktime);
> > +	*cycle =3D (u64)hvc_res.a2 << 32 | hvc_res.a3;
>=20
> Endianness.
>=20
> > +	*cs =3D &clocksource_counter;
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> > 942f72d8151d..677c7f696b70 100644
> > --- a/drivers/ptp/Kconfig
> > +++ b/drivers/ptp/Kconfig
> > @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH  config
> > PTP_1588_CLOCK_KVM
> >  	tristate "KVM virtual PTP clock"
> >  	depends on PTP_1588_CLOCK
> > -	depends on KVM_GUEST && X86
> > +	depends on KVM_GUEST && X86 ||
> (HAVE_ARM_SMCCC_DISCOVERY &&
> > ARM_ARCH_TIMER)
> >  	default y
> >  	help
> >  	  This driver adds support for using kvm infrastructure as a PTP
> > diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile index
> > 699a4e4d19c2..9fa5ede44b2b 100644
> > --- a/drivers/ptp/Makefile
> > +++ b/drivers/ptp/Makefile
> > @@ -5,6 +5,7 @@
> >
> >  ptp-y					:=3D ptp_clock.o ptp_chardev.o
> ptp_sysfs.o
> >  ptp_kvm-$(CONFIG_X86)			:=3D ptp_kvm_x86.o
> ptp_kvm_common.o
> > +ptp_kvm-$(CONFIG_HAVE_ARM_SMCCC)	:=3D ptp_kvm_arm.o
> ptp_kvm_common.o
> >  obj-$(CONFIG_PTP_1588_CLOCK)		+=3D ptp.o
> >  obj-$(CONFIG_PTP_1588_CLOCK_DTE)	+=3D ptp_dte.o
> >  obj-$(CONFIG_PTP_1588_CLOCK_INES)	+=3D ptp_ines.o
> > diff --git a/drivers/ptp/ptp_kvm_arm.c b/drivers/ptp/ptp_kvm_arm.c new
> > file mode 100644 index 000000000000..2212827c0384
> > --- /dev/null
> > +++ b/drivers/ptp/ptp_kvm_arm.c
> > @@ -0,0 +1,44 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + *  Virtual PTP 1588 clock for use with KVM guests
> > + *  Copyright (C) 2019 ARM Ltd.
> > + *  All Rights Reserved
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/err.h>
> > +#include <asm/hypervisor.h>
> > +#include <linux/module.h>
> > +#include <linux/psci.h>
> > +#include <linux/arm-smccc.h>
> > +#include <linux/timecounter.h>
> > +#include <linux/sched/clock.h>
> > +#include <asm/arch_timer.h>
> > +#include <asm/hypervisor.h>
> > +
> > +int kvm_arch_ptp_init(void)
> > +{
> > +	int ret;
> > +
> > +	ret =3D
> kvm_arm_hyp_service_available(ARM_SMCCC_KVM_FUNC_KVM_PTP);
> > +	if (ret <=3D 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_arch_ptp_get_clock(struct timespec64 *ts) {
> > +	ktime_t ktime;
> > +	struct arm_smccc_res hvc_res;
> > +
> > +
> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> NC_ID,
> > +			     ARM_PTP_NONE_COUNTER, &hvc_res);
>=20
> I really don't see the need to use a non-architectural counter ID.
> Using the virtual counter ID should just be fine, and shouldn't lead to a=
ny
> issue.
>=20

> Am I missing something?

In this function, no counter data is needed. If virtual counter ID is used =
here, user may be confused with why we get virtual counter
data and do nothing with it. So I explicitly add a new "NONE" counter ID to=
 make it clear.

WDYT?

Thanks
Jianyong
>=20
> > +	if ((int)(hvc_res.a0) < 0)
> > +		return -EOPNOTSUPP;
> > +
> > +	ktime =3D (u64)hvc_res.a0 << 32 | hvc_res.a1;
>=20
> Endianness.
>=20
> > +	*ts =3D ktime_to_timespec64(ktime);
> > +
> > +	return 0;
> > +}
>=20
> Thanks,
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
