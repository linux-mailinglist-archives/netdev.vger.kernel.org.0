Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8091E2C2298
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgKXKOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:14:48 -0500
Received: from mail-db8eur05on2054.outbound.protection.outlook.com ([40.107.20.54]:18784
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726771AbgKXKOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 05:14:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=9Z8CkJfuasxzLlu2vYG65hTy2Ko4cztoc+cIyYr5RjfnSzUHKXaL9yBiZ2In81fb/XDDZIUp3kQATY92iDYdp82v5Pjfydp/RWmgrOMXr2b5p7OmvU0ToaERqleeSkz+FSxBV+mkaYCiuaHOF5BTX2mMVy85/dAcGWzbSX+MPVU=
Received: from DB6PR1001CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:4:b7::19)
 by AM6PR08MB3800.eurprd08.prod.outlook.com (2603:10a6:20b:87::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 24 Nov
 2020 10:14:34 +0000
Received: from DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:b7:cafe::29) by DB6PR1001CA0009.outlook.office365.com
 (2603:10a6:4:b7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 10:14:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT017.mail.protection.outlook.com (10.152.20.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 10:14:33 +0000
Received: ("Tessian outbound e0cdfd2b0406:v71"); Tue, 24 Nov 2020 10:14:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from 10cc60184369.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 2356AA53-166A-43C4-B4D2-5549FA9A8132.1;
        Tue, 24 Nov 2020 10:14:27 +0000
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 10cc60184369.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 24 Nov 2020 10:14:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l/XMK/FiSbn1qJDuQP37B0sEKrT3lymuvMDwJBGsrFXrGxzW+nJadWk+o/4UGMwtfm81Qsnw3VIzqGRDi6Ct4GTGPbvsDxKMvqEfcjg6myew4t3P+jIrYjFyCmSTQddbWJgqGDkGIPk9xmX0NaUdW86JdRZbIu6C67FwTrdezMhR7jvnA+r/g8k/UeQmQWsMqUkOxRPWZ14UYII4JvI7g2GIsTfwgY5MkMcuCDExpqTTTBkUHPk/TOX6rrxRFlrwRHWPKwEWb5LkDmuE32D6PJiL9IUqRP5MoQVid0qAze6TFmAD23nEriJ02jeHy4wPpKhEj91u9bgQGTL1m9QF0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=ksnp2LpRw4r90zOC6ubaPtgZs6tEh3JD52RGi0jcIphktGF4Gt3Bev8iTNQ9vjIbFIP98XVtPLsYxnIxzGsYnjacboV8qX2fJmB2vE3k4ELcfX4NN/yOkMXJhiWu5E7LKrVj9XKUr+SJ5P4nHlHhxG8X3cu6In4xXKGLMizsZLbMaDa4irTIJPCBHcgkqHs6TRmSn4Q49paD2aLW+8g5ZPwrJ20g8+DlBZe3UEHFui9K/T0hAz/49L5aZBX5QjJqG5miU41AdOGgdcHcnugWDbMdVltdJ4HhBsabXSe9SxHmllOX9apVPe7b5xhpV0up+DAUgCnrK/t/gn7EdFQTUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/Te3bGJdq/nS5Kyt4BmoAvBIKDLvV878/EeuaU4Dqs=;
 b=9Z8CkJfuasxzLlu2vYG65hTy2Ko4cztoc+cIyYr5RjfnSzUHKXaL9yBiZ2In81fb/XDDZIUp3kQATY92iDYdp82v5Pjfydp/RWmgrOMXr2b5p7OmvU0ToaERqleeSkz+FSxBV+mkaYCiuaHOF5BTX2mMVy85/dAcGWzbSX+MPVU=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1722.eurprd08.prod.outlook.com (2603:10a6:3:87::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Tue, 24 Nov
 2020 10:14:23 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 10:14:23 +0000
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
Thread-Index: AQHWt/MyY3F2SxWQTkCP3WjcSZqyYKnVm0IAgAE1lUCAAEGfAIAAEqEQ
Date:   Tue, 24 Nov 2020 10:14:23 +0000
Message-ID: <HE1PR0802MB2555FE5AE7D96B7CB25CBE1EF4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-7-jianyong.wu@arm.com>
 <d409aa1cb7cfcbf4351e6c5fc34d9c7e@kernel.org>
 <HE1PR0802MB255534CF7A04FB5A6CE99A67F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
In-Reply-To: <9133f26699c5fc08d0ea72acfa9aca3b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A60D24C566063C40A89C0ABD70FE477F.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: af7e51e7-a08a-4ea7-cac9-08d89061bd3c
x-ms-traffictypediagnostic: HE1PR0801MB1722:|AM6PR08MB3800:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM6PR08MB3800714BDC05B7EB3F7E778EF4FB0@AM6PR08MB3800.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:139;OLM:139;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: EDtfTunj0vN6JCN2O4bjggD8LZLhIg3bG/zFB+W6Kc8B5dTn9jVCY0XizfOfPAsR4/sQ1uNBXkJlCVI8sv7h3ECZbmFIUTgRSh71PLn4qk0AjMtyz+x0L+J+gYWxoAAL55tnjmiGLnk2AY/L94P1+purolDf5RZI/teDgInd3m++IvnA7DHk+u02Roidd00y8SUiMPC1Kk09dPmT9AGCetGN64u3IQpkyco4iH9UaysFrtY8FhU59REylZwJE0OKMO0rVOfRzTAXqhe64mYb2w/q6PuoEQrUSgo1OUxDJU8Wlr0xJZgLa5wmDFymWiBF2GdUXuGoJzybt2YeT3BAyQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(71200400001)(7416002)(5660300002)(55016002)(9686003)(66556008)(66946007)(76116006)(33656002)(4326008)(4001150100001)(64756008)(8676002)(66446008)(478600001)(66476007)(8936002)(6916009)(86362001)(2906002)(52536014)(6506007)(316002)(54906003)(186003)(7696005)(26005)(53546011)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: u5cja79b+paQXscUANShvwlSIPgo62WPGMpsm5JMyynWPeN5d9+evKk6uqTGMI8iMQnpn5PDlqtaQiNb5DT8bougveRbMHvvgN4NgUlsBdfHg+Z3V/e5oeUkP2NuuLDqoHuOq3ZljLLgAnr8wbXl+2XHLWNiRpm7oRxWGDX+aIKx34Qcri/4ooIgwC0C3u/T3U7MYTRZ7GjwmKXl5iWJ8IU6bQiFQXX6HnCIXjfVRnpHVKhn4nmKBxdFe3Jb/b91qHxeVAKvO4jSqVnSxI21yhCoWdhpyiHMQ0hTvMwze3AxbmCUPu77NAlKuvBige9Q4+1koKknbYfTA2oc+30MEa/MgK6iddwjWggUhF+5i39YT1EpAWky9e9dEwD3OdjIpRh+Lq9AUHw36y6F/4N9DrlB5WZyuC6rPzTj4SQUNQOc6436bkWuySMMvdUE4HSUyBTNczGLG3QYwNImCaUgv6aRhLKP6RqlQByXtAWMaPlODkoDFuXGrTgQCvAR7l0CEzHI09RQ7SkzLXGskeCMxIqrLbTPg5Y18dwKCWcKJEKWbQBwO/Q5X+L/A9xB1ty304K7qgU6/y/DiICHBbm6H82YqxexCSkXm1mQwzGybHjbhYXF4ePgmdCAeLe+EnzUHxFsn5nVo+WwTZ7epRXCVq+k1ay8cDILaFDs1rYAr+uIVGSYO0PInbVNaf1XeaLUoi5qraD5uyJshggGhnOvra59OIK1zgwcCtlSJZrbtLNi2RKjHmezb4I7vL8n3fZU1H67NVRFhmT2s390T4q9Au3hKe6IadlW9R2D+m9II74ihMk2gO60ehyTp6O7P7xwhakFCmWWlfyAqiTrXSNYyZ8eBb/4JtMAruyg3/xfPPlqxQhoD52CpsxSpM1FaE+3TRnTylFG0VgNsi+Cr2ekaQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1722
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f78ccf59-cdc5-43b5-6e73-08d89061b77b
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h+y/W7qejp2arGLdu5aVPSMb33xuFRq7zLVXsOa/7MajrkGWuQtRXZhwMw9Angznkw/8A3VkoUp0vLZmLc4nYF3C6GqEoRQIimBW9xBFP0x5nLHvES1VMPKQ/xSHCko8qzbNUxKsYsymslABlpEpGB5A0H7b9ExMQ0V+RAclZ8d134Zw+x4lMi6cR9ABI7P2NS65DEu06P5KmgaMc3+2jP3Tar0321E5wmZl/bFo47/daXy7lg0Pwd3fR31T40LQvTWqjeZv0nM0iZSaPIYsPIfWQMjXRYqx6SEBeinVHD9gtDvb430BoEfFmjuumDvdz2OrM9VxRvNma0w+kkP+y/CgHRQR9awdJx2YJPd2aTaJxh1sTPBtFz7RVffgrpe/Z91zJP+CMBedqxtBlUijsw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(136003)(376002)(46966005)(86362001)(6862004)(4326008)(54906003)(2906002)(52536014)(7696005)(81166007)(55016002)(9686003)(316002)(356005)(82740400003)(4001150100001)(8676002)(47076004)(82310400003)(336012)(33656002)(450100002)(478600001)(70206006)(83380400001)(70586007)(186003)(26005)(53546011)(6506007)(5660300002)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 10:14:33.3900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af7e51e7-a08a-4ea7-cac9-08d89061bd3c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Tuesday, November 24, 2020 5:07 PM
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
> On 2020-11-24 05:20, Jianyong Wu wrote:
> > Hi Marc,
>=20
> [...]
>=20
> >> > +/* ptp_kvm counter type ID */
> >> > +#define ARM_PTP_VIRT_COUNTER			0
> >> > +#define ARM_PTP_PHY_COUNTER			1
> >> > +#define ARM_PTP_NONE_COUNTER			2
> >>
> >> The architecture definitely doesn't have this last counter.
> >
> > Yeah, this is just represent no counter data needed from guest.
> > Some annotation should be added here.
>=20
> I'd rather you remove it entirely, or explain why you really cannot do wi=
thout
> a fake counter.

OK, I will remove it.

Thanks
Jianyong
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
