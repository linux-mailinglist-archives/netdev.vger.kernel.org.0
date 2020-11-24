Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6BB2C1D55
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 06:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgKXFWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 00:22:06 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:27053
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728144AbgKXFWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 00:22:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=nU2IWDN0buyZwIw4Ft7KEgMeN3BpdAIfGjvZaNjbw95gJWs/zRAu82xEK8a1/tfF1kbxt7sv/h7OnplnYcQW8MgsT99cgngBKJUO7dh1QozblV6rB/CZDhntbG2AUfS2QV3MNTmj5+VL2mIpdbub35ZBIx2yhklITmYjoe1h0K0=
Received: from AM6P191CA0098.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::39)
 by DB7PR08MB3836.eurprd08.prod.outlook.com (2603:10a6:10:76::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 05:21:59 +0000
Received: from AM5EUR03FT042.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::bb) by AM6P191CA0098.outlook.office365.com
 (2603:10a6:209:8a::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Tue, 24 Nov 2020 05:21:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT042.mail.protection.outlook.com (10.152.17.168) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 05:21:58 +0000
Received: ("Tessian outbound 814be617737e:v71"); Tue, 24 Nov 2020 05:21:58 +0000
X-CR-MTA-TID: 64aa7808
Received: from 33b21df39ac0.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 8411E29B-2C51-420C-94D6-5B8AC7BCDF9E.1;
        Tue, 24 Nov 2020 05:21:53 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 33b21df39ac0.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 24 Nov 2020 05:21:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HigVNubI4o/OPPw8bICHVASrhTGBDTthV2TUp5JcFkIlkQrhlH9CK95/brzXrpyl12a2Csadg0rUOZuTejoqUgRBc7pmqwYAOdUUI+WKGC3FTbFFV6zDdgfc+9LSz3yhQszDNTGgvWMSG2O4IlDUXgqmiuqlUXZrTtdaRPQP/YssdIgDj9bubRDTHpZrYdJYoEHKuvG0xjIldMqC2SydN+vkVevKR8zZLIqWWnVv8jIAQihWBMooWD2S4NOeoWrBrq58qrHJvcPGfdpsFnSRV+F34T8CHaf5NuwOs9ok92w27EndKZ1oedkQexD2LQs39FfNnklI6tMxigNUOVvCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=IwulHk6vSGIoKYKoDk+jlmoT6r9gD8vyIyrGXLahZarVIT/E98zqS7fj7xVfTHlEJ+l4ZH4m6mRdTcX2VbwgO6Pm5q36J7ACyAPrpdS+CC9+7EzE7WSawRxJFhQvAxwybkq1nSs9LKXSGDCsYA/VbWj1WdXY51Z8T7PSTczX9yrGlRIGUq3VmK/6MNuhZFqeGyFRA3TsXlpo+y8eAA0VmkVy+Ur3SznPIUVqm5j60tvQeptJ59oMg4ufC61s4n4Tlsk183f785Z0pcl4UH4kdoCvCNaDtM513MKoCMViXil1/oNGh7/AT+eUGvljNAT+sWUO/BEqpkVgFP2luImu4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rAMcHFUpHfYscir3212kekOoJuVQONeTUk7iu2FfxBo=;
 b=nU2IWDN0buyZwIw4Ft7KEgMeN3BpdAIfGjvZaNjbw95gJWs/zRAu82xEK8a1/tfF1kbxt7sv/h7OnplnYcQW8MgsT99cgngBKJUO7dh1QozblV6rB/CZDhntbG2AUfS2QV3MNTmj5+VL2mIpdbub35ZBIx2yhklITmYjoe1h0K0=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2250.eurprd08.prod.outlook.com (2603:10a6:3:c3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Tue, 24 Nov
 2020 05:21:51 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Tue, 24 Nov 2020
 05:21:51 +0000
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
Subject: RE: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
Thread-Topic: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64 support
Thread-Index: AQHWt/NFDHcZq7JlmEiPhjJ99jyBiKnVnyWAgAE0KVA=
Date:   Tue, 24 Nov 2020 05:21:51 +0000
Message-ID: <HE1PR0802MB25553458B5878B8B32372960F4FB0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
 <20201111062211.33144-9-jianyong.wu@arm.com>
 <38fad448a3a465e4c35994ce61f4d8dd@kernel.org>
In-Reply-To: <38fad448a3a465e4c35994ce61f4d8dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 6075EE547CF5F44BA7DA3D606C509743.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 768adc39-9009-434d-d3a5-08d89038dde8
x-ms-traffictypediagnostic: HE1PR0802MB2250:|DB7PR08MB3836:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB383653F44080B3AEC1337D06F4FB0@DB7PR08MB3836.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:3513;OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: b0HzNshnIBHAG5zhWC9FSqtlh3pV+gWSQ+iYA9RtB6/K9fuKqxPyPqHQCJl6xxdRAJro85vX2PaQjFsf1tEiHZUlrk71jgdhwaUOiQ8CxSzYN6YNIM8klnh/wuJQeOx4pb+NFvpCpS164Eckc0Y3+wJOzaaNThoR/PnZZFtOD0kV1Y95VJJiVTp4yIJ1jsn76pnd4XBgj6LTuFt+SidVF0K97HtBxbqc5iu2P6yOq8Q2KGo9SH0b6mhFvg5lXpFv+mwCV/6tbMg1Y7aQMSSyflLI7tIQ2XNh4S0mGzhV6u/cbVjDn/czCF+KnycBC2uT
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(39860400002)(396003)(478600001)(8676002)(71200400001)(54906003)(6506007)(53546011)(316002)(186003)(33656002)(8936002)(52536014)(55016002)(5660300002)(9686003)(83380400001)(26005)(7696005)(7416002)(66446008)(6916009)(66476007)(64756008)(4001150100001)(66946007)(66556008)(4326008)(2906002)(86362001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: zW2+MZMZ0qcnKd2rx1J6FZLRZY2ssq/OdodZJfANlzSN61V/gTFBm77R5BxA4mMUEE38D8VP+yr/puKMjSwExTZBmoZ17HlMATyc1QEskCIbMeJh/clwlnxyS1akpczGWalOt0wH5X0dV9wAVNH+GD+FhKS+P+X72KHzVVu6fXsuvbfmyd26M9TNyt/kcBnAqs4VBO5QNd6KhGMnuTS3P20K1+RQ7AHADEQxBSN30ppcUhxgyQjgc7h6O6O94eBxD7gXzNIfWeC4btO6GvsA+nqIQeDkeUcOl/NBtACf2K2EY/UoqQXvcgK+Gj2HaXQzXuxDptA462W6Lpx5DuZvL8MjkfLcHEOqjwhKOJ7r6PoRnzClsN6lspkVRM7uGTwfB4+HCObHbzdTzktm9PaLNMFb7i/iwwKSfthPamizVi37MNRF+OMyiAIrZ5G+0y7I8ddOi2tuxA5ezDnchxK6iGG/qdYuAhkmDYtZFKI4NDHR1H0dPPISIO6Y6rJIfsuFYZgSbsSatYMz9/2DkN4SLXYW0uHiVethDcUGZQ3Cvq0hF6sVhOVnOSYT8lNaS1JWfQIzsS/XM0YkR4VL8vZGh6EE6y6Kh4fAQcPdWPXBwVP4PgmHHdYw/BlV/9AFK4TY6ouk35l98IrPe1uSRZcoecB00OwyJo+w0ZEn6W/O+JkgKqdO5m1FQuO9qb0pdyhGfvai4DTDzcsnm/hE2EfRk7taaLXR17jysnaooGRxi/VIzQNCDk98PsR8b3sEqqjkips4N0mKz0WNmq20btOhrDoOawu+0k3m+0bUAplliyhn1x5lyXQZHpX4U2Ak4RNyPUZPSL2jmxjVJpB1l864UV+JIEiauccBrFj5K9mWlcpz0vokLlDRLKYI8u9pLnz6mt364OwEiz4Qi/qbs77nyQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2250
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT042.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: a3fe8848-0b08-48a0-4a3e-08d89038d99f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuItpLqjsUBVMU5MRT6/7N4rGXSG6suvRVUIQ/twarAwG9P97VhMaHGi6BmZy3NxBOETTPYw2fdEoMckDVRM7YBhI/KklFpmWlSSYzUsfKztCmnBUt56tvHKft2h+d6AB9984OaEhBnlxsGfUuvbNoH1LDHi0OrVAYiowgMRHtu6Fe4H9/EgWxMqVAvP+xnLbyWKVDV1GoGWNdJsBVsjFO20puwZZJuglZDeSreL6d6JP908LocwYekaT+CgXg2QzSR7jXuuh36Ry2/dF/VeSnkkmtpPTYcQskvsyCwXfadFJmezhZKRKo+ZQQnCSngTz29oupoPUL3KQ666TF9YTRAhBxHAUWL1ecD0kap6fnIfbdShxnmhQ+fNz7R6JnaCLG6uL8bebUMopnaOiHbBDg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(46966005)(9686003)(47076004)(82310400003)(53546011)(2906002)(336012)(450100002)(55016002)(26005)(4001150100001)(7696005)(83380400001)(8936002)(6862004)(186003)(52536014)(33656002)(82740400003)(6506007)(316002)(70206006)(4326008)(54906003)(8676002)(356005)(70586007)(86362001)(478600001)(5660300002)(81166007)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 05:21:58.7337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 768adc39-9009-434d-d3a5-08d89038dde8
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT042.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, November 23, 2020 6:58 PM
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
> Subject: Re: [PATCH v15 8/9] doc: add ptp_kvm introduction for arm64
> support
>=20
> On 2020-11-11 06:22, Jianyong Wu wrote:
> > PTP_KVM implementation depends on hypercall using SMCCC. So we
> > introduce a new SMCCC service ID. This doc explains how does the ID
> > define and how does PTP_KVM works on arm/arm64.
> >
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  Documentation/virt/kvm/api.rst         |  9 +++++++
> >  Documentation/virt/kvm/arm/index.rst   |  1 +
> >  Documentation/virt/kvm/arm/ptp_kvm.rst | 29
> +++++++++++++++++++++
> > Documentation/virt/kvm/timekeeping.rst | 35
> ++++++++++++++++++++++++++
> >  4 files changed, 74 insertions(+)
> >  create mode 100644 Documentation/virt/kvm/arm/ptp_kvm.rst
> >
> > diff --git a/Documentation/virt/kvm/api.rst
> > b/Documentation/virt/kvm/api.rst index 36d5f1f3c6dd..9843dbcbf770
> > 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -6391,3 +6391,12 @@ When enabled, KVM will disable paravirtual
> > features provided to the  guest according to the bits in the
> > KVM_CPUID_FEATURES CPUID leaf  (0x40000001). Otherwise, a guest may
> > use the paravirtual features  regardless of what has actually been
> > exposed through the CPUID leaf.
> > +
> > +8.27 KVM_CAP_PTP_KVM
> > +--------------------
> > +
> > +:Architectures: arm64
> > +
> > +This capability indicates that KVM virtual PTP service is supported
> > +in
> > host.
> > +It must company with the implementation of KVM virtual PTP service in
> > host
> > +so VMM can probe if there is the service in host by checking this
> > capability.
> > diff --git a/Documentation/virt/kvm/arm/index.rst
> > b/Documentation/virt/kvm/arm/index.rst
> > index 3e2b2aba90fc..78a9b670aafe 100644
> > --- a/Documentation/virt/kvm/arm/index.rst
> > +++ b/Documentation/virt/kvm/arm/index.rst
> > @@ -10,3 +10,4 @@ ARM
> >     hyp-abi
> >     psci
> >     pvtime
> > +   ptp_kvm
> > diff --git a/Documentation/virt/kvm/arm/ptp_kvm.rst
> > b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > new file mode 100644
> > index 000000000000..bb1e6cfefe44
> > --- /dev/null
> > +++ b/Documentation/virt/kvm/arm/ptp_kvm.rst
> > @@ -0,0 +1,29 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +PTP_KVM support for arm/arm64
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > +
> > +PTP_KVM is used for time sync between guest and host in a high
> > precision.
> > +It needs to get the wall time and counter value from the host and
> > transfer these
> > +to guest via hypercall service. So one more hypercall service has
> > +been
> > added.
> > +
> > +This new SMCCC hypercall is defined as:
> > +
> > +* ARM_SMCCC_HYP_KVM_PTP_FUNC_ID: 0x86000001
> > +
> > +As both 32 and 64-bits ptp_kvm client should be supported, we choose
> > SMC32/HVC32
> > +calling convention.
> > +
> > +ARM_SMCCC_HYP_KVM_PTP_FUNC_ID:
> > +
> > +    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +    Function ID:     (uint32)      0x86000001
> > +    Arguments:	     (uint32)      ARM_PTP_PHY_COUNTER(1) or
> > ARM_PTP_VIRT_COUNTER(0)
> > +                                   which indicate acquiring physical
> > counter or
> > +                                   virtual counter respectively.
> > +    return value:    (uint32)      NOT_SUPPORTED(-1) or val0 and val1
> > represent
> > +                                   wall clock time and val2 and val3
> > represent
> > +                                   counter cycle.
>=20
> This needs a lot more description:
>=20
> - Which word contains what part of the data (upper/lower part of the 64bi=
t
> data)
> - The endianness of the data returned

OK.

Thanks
Jianyong=20
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
