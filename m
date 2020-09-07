Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501DD25F460
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 09:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgIGHz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 03:55:57 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:58112
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726833AbgIGHzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 03:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUCzExZOuDqEhfwVv9mY9si80E7JvV5ev8EqUlNFfjY=;
 b=NR497deyRY2dykWbJtwGH2zU3VeSvY+QQkC2yjS7QYQIdTskBl3vsjvOwHl9yvzlU1ka1LapbkYXe9p2PrIyBItxf3mH3KNPS8IXHXjViPLLToDNWUtRcWRkzEeFtCHI9oU1GIx6scLcZ/CIdJSKx+ekVgxIe3MOUB6TKGle2dM=
Received: from MR2P264CA0086.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:32::26)
 by DB6PR0802MB2150.eurprd08.prod.outlook.com (2603:10a6:4:85::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 07:55:50 +0000
Received: from VE1EUR03FT047.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:500:32:cafe::51) by MR2P264CA0086.outlook.office365.com
 (2603:10a6:500:32::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend
 Transport; Mon, 7 Sep 2020 07:55:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT047.mail.protection.outlook.com (10.152.19.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 07:55:49 +0000
Received: ("Tessian outbound e8cdb8c6f386:v64"); Mon, 07 Sep 2020 07:55:49 +0000
X-CR-MTA-TID: 64aa7808
Received: from 2583122da173.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 04AA52B7-C53F-485E-81E3-13540371B59B.1;
        Mon, 07 Sep 2020 07:55:43 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 2583122da173.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 07 Sep 2020 07:55:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grFZ3E145prYxByKA28F0NcW9pNE1ezVlwCtqLie8jZt9xaSYbHW0R1KIdLHqCMdvzFTq8U+zsvyo2ujUhoP0JKMs7ImdIuxS9V04+QjgwnkBilDwNp/dXOZ7lEsOcDgCDgYw/4X6lofABwyfsSzno4V9aAvWSdycUkFboBzO8yK39yaV0cO2vnR3zIHzyGovQ888CrO+ihl9pbtmWiqHYj2ueA/FFSDJj52QgkJj5ZSbOM0k6enLZfjfC/vAgWK/j/3PmChwGMacNtXqARHW6rP0z1Me3j46DXaGJK+6t80zkm3B3RMnbfVQ/xU8qZpdg6upP/ZwC4mHoqunbDV3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUCzExZOuDqEhfwVv9mY9si80E7JvV5ev8EqUlNFfjY=;
 b=I2LROZdsMBvlJ8H2+jv67o+bmv1pU7/rxitqpm2AGLBEChp3/GblB2Sb6JiQcsVM/RuiyHWQKpvvDIL/ee2+Pa8RQ25x4PFoi2NTJETQGebCG+bOwQpJSu1ZOtPHZK5Z+NtHVt+8S47rga7iXXWPn+kI5GDNoPq9iNz0kTxQ1iY07BBkHjcyT5YqbfNf0SaFxcyhiU5Hti1qxmsr1iRWlFxdFyRkne3Jh0sJs5lW4LTorWAcnIt1NkREWy04GBKhEbN/SbZC482QTkQw0kMzKJo+4xUAOac4x6dQcshVwkh6nhdo6xHWw2HcmuT2zWfZL3FyptuCI+/nMMuMtQZ6Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUCzExZOuDqEhfwVv9mY9si80E7JvV5ev8EqUlNFfjY=;
 b=NR497deyRY2dykWbJtwGH2zU3VeSvY+QQkC2yjS7QYQIdTskBl3vsjvOwHl9yvzlU1ka1LapbkYXe9p2PrIyBItxf3mH3KNPS8IXHXjViPLLToDNWUtRcWRkzEeFtCHI9oU1GIx6scLcZ/CIdJSKx+ekVgxIe3MOUB6TKGle2dM=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2249.eurprd08.prod.outlook.com (2603:10a6:3:c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 07:55:39 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 07:55:39 +0000
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
Subject: RE: [PATCH v14 09/10] doc: add ptp_kvm introduction for arm64 support
Thread-Topic: [PATCH v14 09/10] doc: add ptp_kvm introduction for arm64
 support
Thread-Index: AQHWgp36kP2WPVfAh0y+53P6AOHZGalYqNOAgAQpW/A=
Date:   Mon, 7 Sep 2020 07:55:38 +0000
Message-ID: <HE1PR0802MB2555849BDD0F9185ED3CF5F7F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
        <20200904092744.167655-10-jianyong.wu@arm.com> <87d031qzvs.wl-maz@kernel.org>
In-Reply-To: <87d031qzvs.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 1C61F0A72C975544853C80C6917AE5D5.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd990820-90c4-4883-0f52-08d853036fc5
x-ms-traffictypediagnostic: HE1PR0802MB2249:|DB6PR0802MB2150:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0802MB2150296B3314C7CE69E187C8F4280@DB6PR0802MB2150.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7219;OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9OSiapGiGdMJnEyCd+EOHTsj0k4vLOh4NEzbZOp7dCzXkjaVtGm5FqLIOjke7D8hTfOyxieyTNOfP4mGHo0xjtgz+xHpTwrP0jxP4+B9qNjQxy/SUxhVWV93r5S9NDN7wMzjlmh4KhFydNp0qy4ZbaxgdN/36NclFK23YNk3fEaeMOmLvraPWA5SmP7XnrlImLXmOjUYFbdK44MZuCNtI6a5WGshcVkgrBuw9pHy6HCoZ/gVtvB9hZbuWkfc9qFAr/3SuB5kxbqVlP29PkERnMVc2NunOnZYFNmuQQCqa/RsWK2KG+BDwYmFVq/9fXd5nANrv/AO3GmVF90ErAv6MQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(478600001)(6916009)(54906003)(71200400001)(8676002)(26005)(83380400001)(8936002)(186003)(53546011)(6506007)(33656002)(55016002)(2906002)(7416002)(7696005)(5660300002)(52536014)(86362001)(4326008)(9686003)(66446008)(66556008)(66476007)(66946007)(76116006)(316002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: GIY+7SUU+IRkRKY8lmvsdBIP0W7pA/phTk4OcMFaaXFVEidjtVhxebfB8qsPWmbu3bF6nnp8tcBXG6BY2Z+f1R/NYeCFiRxoKTNtfVckFUfNCkS+tHC4YsdhQCLXkAyloh0ADJUFJ3Kn63bANSSzRGOQBVlCusL0GjfN0tgLhsFEV+S+HT8NkOTJyYYCZQFnCnCNh3o3Lyg0iUSYNjo90pXcIHVgf57cDSZvxwTe8piQ8dlJgnjPzLAFjdYyKFAfByLkqJonRCTfDVpvBb4fsaaypMAIKppg704VBp0ZvpOd2cn/0FL/YOOlA5u8GURF9UvQacuXFMrJHnhsZ6jkqh3vMRkzSfC7lpPCS7F0VSgBfmOLnh1DM5CGqb0wX8tFjh7RjtbVbWRTkX8bb58kY8YgaWDqtnkm/UaO+32mou7b2koytOiFrSl4k51lAxopdpcfHr7d4FTAKOIWvDDUJ90S9RhP7y3duNRc5q6z8HUjOicY0PCIo77nJE0FnbO7isqwhaY6DP4cVVMiLwn4F7ugXywXeafx6bXgFo+20uWEM8y8L2zQZRJX3MXnafanhbDVTgZJTS0ouPcrGWOLNoh/o41DoxuV6/JyPNa30NfDHwWgH85DGs82xiMUrt5od6Vs73hjhZDuxnz36pqMqQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2249
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 171f5ed5-4f6d-485e-956a-08d853036967
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xk5goaMF681OO+x4uLKe8y7dVMM2J3F63oyWTiR3ng+Q4e5PLcaBogCisYw9Ho8ez7Q7sq8wBaZD5ZAb1KGMuLtn+K5vZHkc2GY+IJy+jfOw5fEEzZglNRjtJctbVb2s+PdHDmbhdMHypETbLVZcFGJrmhfq/3z7I9bLcrAb+SxaIeDvDHU6CZhmlyJN2JpL+bA5bgQFooVUEE56g4JogRj1hB8JcOOXaLxJEbDvAgMDDdN+xG5W0ixmgE32CfgFSZvIcxOmHwX4hmWzC06Ahxli6k5Durk/swBP9LdaXBFQdgYDjG0jOp7sUn4XmSzRrGFY9pandflNInN/szyqrhyrXMdhCTlvv1Mkgb6mnxxnYvEkCYY6EMTKZUld7quTmuubWVep2+fOrxjt5kOVUw==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(346002)(376002)(46966005)(82310400003)(53546011)(70206006)(186003)(6506007)(336012)(6862004)(81166007)(33656002)(356005)(70586007)(86362001)(52536014)(5660300002)(82740400003)(478600001)(450100002)(4326008)(54906003)(2906002)(316002)(8936002)(7696005)(9686003)(8676002)(83380400001)(55016002)(36906005)(26005)(47076004);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 07:55:49.6206
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd990820-90c4-4883-0f52-08d853036fc5
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT047.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 5, 2020 12:19 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 09/10] doc: add ptp_kvm introduction for arm64
> support
>=20
> On Fri, 04 Sep 2020 10:27:43 +0100,
> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >
> > ptp_kvm implementation depends on hypercall using SMCCC. So we
> > introduce a new SMCCC service ID. This doc explain how we define and
> > use this new ID.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  Documentation/virt/kvm/arm/ptp_kvm.rst | 72
> > ++++++++++++++++++++++++++
> >  1 file changed, 72 insertions(+)
> >  create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
> >
> > diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst
> > b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > new file mode 100644
> > index 000000000000..455591e2587a
> > --- /dev/null
> > +++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > @@ -0,0 +1,72 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +PTP_KVM support for arm64
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > +
> > +PTP_KVM is used for time sync between guest and host in a high preciso=
n.
> > +It needs get wall time and counter value from host and transfer these
> > +data to guest via hypercall service. So one more hypercall service
> > +should be added.
> > +
> > +This new SMCCC hypercall will be defined as:
> > +
> > +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0xC6000001
> > +
> > +As we only support 64-bits ptp_kvm client, so we choose SMC64/HVC64
> > +calling convention.
>=20
> This isn't what the code does, as it is explicitly set as an SMC32 servic=
e...
> Furthermore, we still run 32bit guests, and will do for the foreseeable f=
uture.
> Having removed KVM support for 32bit doesn't mean 32bits are gone.

Sorry to have removed arm32 support. It's worthy to add arm32 support in.
I will add it next time.

Thanks
Jianyong=20

>=20
> 	M.
>=20
> --
> Without deviation from the norm, progress is not possible.
