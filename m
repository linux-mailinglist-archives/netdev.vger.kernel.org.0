Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A981E0633
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 06:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgEYEup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 00:50:45 -0400
Received: from mail-eopbgr20087.outbound.protection.outlook.com ([40.107.2.87]:42998
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgEYEup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 00:50:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBe6a9FB0XVi+xwEwBkCm8WfTrjMg5lxhRAHJUOmWa0=;
 b=Xu2fyOrWA9wlnrMnbWYHDEWSz/1G8DDC4wSR361vo3lKsztL/RfWTHPE4iMCVUXtU3j2jcFsH/XC47jE/YqKIcWGTz8Bm7O+RZvWKR35SYNwOBsv3d4cNo/+uia2r5Ba9B2+GRSQAeGbMbrHi04ja9xNrhBLwfDrpyFwEkRhOUM=
Received: from AM5PR0601CA0053.eurprd06.prod.outlook.com (2603:10a6:206::18)
 by DB8PR08MB3948.eurprd08.prod.outlook.com (2603:10a6:10:a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 04:50:38 +0000
Received: from AM5EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::5) by AM5PR0601CA0053.outlook.office365.com
 (2603:10a6:206::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend
 Transport; Mon, 25 May 2020 04:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT015.mail.protection.outlook.com (10.152.16.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 04:50:38 +0000
Received: ("Tessian outbound b157666c5529:v57"); Mon, 25 May 2020 04:50:38 +0000
X-CR-MTA-TID: 64aa7808
Received: from 642c2e7ce00e.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 6791C755-D578-4386-9B2F-955DAA4E244B.1;
        Mon, 25 May 2020 04:50:33 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 642c2e7ce00e.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 25 May 2020 04:50:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mi7DZ4JAO2BhNtyXjFiUf14NAHhfsK1uyCOvVTJaU4BA4lNERytXJYaZkH4R/Mq6utjQGOp1TjZqqX+jF00r1NjXVOOrrKtIBsB3saMnQVNylCO4rVLv50Jq5yO5BeJj13vbI0Nrjl/fUdxa6kIRCTV3tyuitDluVr/NH2Z6Ktn3yKeuyJGZ8gTnMNoyNYnBl8rMJBk97R4koO+s5N5F+Yy1zoVUj5pWDRXTxUYFqHnWjN4sEyM5JXWkGGzgDz+q9cn5pEL/cLh17tEHhAY/JKvagge2mpt0JA2YpryGaQzZFl5ipsMw3bHGBlW12LOIWZ9oiuWq3TSIEps2PkGSoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBe6a9FB0XVi+xwEwBkCm8WfTrjMg5lxhRAHJUOmWa0=;
 b=jsJJvYuKhB1gm8Hz3BXkw1rGJf6TOysiQXfB80sXjk32VVr3uJb+jaUCw3WDcVSMa/FFz4May+2NeIjnK34mWRrt4RSGdG+0dozPDwLAoeTrEL8iLtZzl9n09Xfo7vn0zD3bzytoINidkzrm75+8tc26jn0vwNmfGS9UTmeufMUD+wFC5bEyyG6cmCQC+rXRjfmGHrCx/8BeIzr/vSI159Kut1LgRDodb3c+hACEbKstdDVSLE+7xFZCSlom4kpce6jpEXwCuw7EOzZe5sgu+3VcOfRXQCtav7muLmIyjKFgZNvrbjq8KC9bjWC7lLMmlDR6UF30s7lQ7Y2AE0FRUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBe6a9FB0XVi+xwEwBkCm8WfTrjMg5lxhRAHJUOmWa0=;
 b=Xu2fyOrWA9wlnrMnbWYHDEWSz/1G8DDC4wSR361vo3lKsztL/RfWTHPE4iMCVUXtU3j2jcFsH/XC47jE/YqKIcWGTz8Bm7O+RZvWKR35SYNwOBsv3d4cNo/+uia2r5Ba9B2+GRSQAeGbMbrHi04ja9xNrhBLwfDrpyFwEkRhOUM=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2556.eurprd08.prod.outlook.com (2603:10a6:3:e1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 04:50:29 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::b1eb:9515:4851:8be%6]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 04:50:29 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "maz@kernel.org" <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
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
        Wei Chen <Wei.Chen@arm.com>, nd <nd@arm.com>
Subject: RE: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Topic: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Thread-Index: AQHWMBRtHtaBVLC+ukSXkuIjkrpVgai2gQEAgAGkltA=
Date:   Mon, 25 May 2020 04:50:28 +0000
Message-ID: <HE1PR0802MB25552E7C792D3BB9CBE2D2C7F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
 <20200524021106.GC335@localhost>
In-Reply-To: <20200524021106.GC335@localhost>
Accept-Language: en-US
Content-Language: en-US
X-Mentions: maz@kernel.org
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2acbd9d0-45d3-4119-b71f-c53f85f849e9.1
x-checkrecipientchecked: true
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: efafed36-5746-4a18-c955-08d800672bbb
x-ms-traffictypediagnostic: HE1PR0802MB2556:|DB8PR08MB3948:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB3948C503991300A3880543A8F4B30@DB8PR08MB3948.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:8882;
x-forefront-prvs: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: WRTlXvpllqTfyKztAXZhhmURtG6366EhN81xl7VMyZpjqTG+4cQKKZ9j35FbWhoDAIvsnCQ22mKn5XQipk/IYGzpEVX+mcu9zceQWG6blGFPbS/FkfRq+3z9bBtyI5X431xjteCMS85vX0b35OiTh5TtIkFm0M03kHgtkFmjI/g6OIUl9SpgNR9kpuLkKbrdc9NRRDfiVcDdg49B5KiKZyqhHY/kDvneYWT7Xp1eol/LUTudMt8vEEAGLfotVLmC7eza1IOpPsTYieOEjrUqskHoquV6mroDV4fqCoszkyWtm99/GakxT+zCPV/vYtW2klOoM9ZrCdu8tOpI+ae22pZkhfFNBA8DAecrATQd/k6FQ1FHp1WAfHrP7Ssv8dKm
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39850400004)(366004)(376002)(396003)(346002)(5660300002)(7416002)(7696005)(55016002)(66946007)(316002)(76116006)(54906003)(66556008)(66446008)(66476007)(64756008)(110136005)(9686003)(478600001)(8676002)(86362001)(52536014)(26005)(186003)(33656002)(53546011)(71200400001)(6506007)(4326008)(2906002)(8936002)(76704002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bDvCD3/Wy5dBCtBkmIQPqXeGvdBa6c+Nf+cxIFiQJtgfF9AxkmYYbiPyuX3JX713rpqNzkE/H+/cS3mrYtRnh+GNJXAi3b3mgylygW+/2JvLX7f+YbS+NaEMu2F78/7OL6D5vn2kcMgwb21KGhfDlef8vFtw8iWYu/gKW4i7+V1xjNSBuZ89kRAJ7r9xhRZ9g1qT08joRBTkej+Xf5eHMz/ggKHlLsTSuE3f4w3hlXLDOI+z/oe65W0hFuNs87HbtDjtPSCISyKvwseWcCPcevv8QSQWH39Dl66wkVbinPkrcl/ZjnVucib1/3ayfpb/QsorFO5hSxkNNva3tALCpGGd7V3EMdRreDnf0gqVVbJsFXDu+P3W6+VWUCntr59rh6LwpKQbmYuJzNbjZ4GoOIClt2ycmXqBEV/Z5a8r1OCGnQaXetAhAKnnYZUE8Z2zXaW+RJDJNs+kg6ZY6t3sEG4sBOXz2guNDlHp3XqyH4E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2556
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39850400004)(46966005)(356005)(9686003)(316002)(36906005)(55016002)(33656002)(5660300002)(110136005)(86362001)(8676002)(450100002)(52536014)(4326008)(82310400002)(54906003)(8936002)(47076004)(53546011)(6506007)(336012)(26005)(186003)(82740400003)(7696005)(478600001)(81166007)(70586007)(70206006)(2906002)(76704002);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 23135167-5e5c-4cb9-06e1-08d800672609
X-Forefront-PRVS: 0414DF926F
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /9E9WT6OFWzSQxE4fwmF6wKr+tI3ETURCguFHZclsns+wVr8j0vYdE0s3gR5/qmY94BYRZZqCNclXjhiZgWClHzzt25At5dAEsr4S/ImffKu0b+EXJk8ha2GiMFk4wfYLP7GIGQIfxmKSm4pnon5bICwhJkAgeBKFsPtMka+26F1GE4/1d/4gI/CirBai8NvXLBUIKSGZRSG5cBbpLQcPFDxjfCzyq9BNU05mMG0j+5rZLOO+2jQS3hjr3dCsGmm918UTGztzsWaOdsdPwc0o2OsmKE868hENPygM7uU9D+Kvlb/Wz6Vj6Amug8N9vOJNZ7xt+gBS95GUUPtmB++s7f2cE6bEqaCWysVh1h6zeVqkB06QqwhyeFoBC+CNbPKwfHkhtNgRzZA6RUTlWMDVtkA5vNfsnqYKSvJQO6tSEc=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 04:50:38.7114
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: efafed36-5746-4a18-c955-08d800672bbb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB3948
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Sunday, May 24, 2020 10:11 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; Mark Rutland <Mark.Rutland@arm.com>; will@kernel.org;
> Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Kaly Xin
> <Kaly.Xin@arm.com>; Justin He <Justin.He@arm.com>; Wei Chen
> <Wei.Chen@arm.com>; nd <nd@arm.com>
> Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choos=
e
> which counter to return
>=20
> On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
> > In general, vm inside will use virtual counter compered with host use
> > phyical counter. But in some special scenarios, like nested
> > virtualization, phyical counter maybe used by vm. A interface added in
> > ptp_kvm driver to offer a mechanism to let user choose which counter
> > should be return from host.
>=20
> Sounds like you have two time sources, one for normal guest, and one for
> nested.  Why not simply offer the correct one to user space automatically=
?  If
> that cannot be done, then just offer two PHC devices with descriptive nam=
es.
>=20

It's a good idea, but in most case physical counter will not be used, so it=
's  better not keep 2 ptp devices all the time.
How about adding an extra argument in struct ptp_clock_info to serve as a f=
lag, then we can control this flag using IOCTL to determine the counter typ=
e.
In this way, no extra arguments needed in .getcrosststamp. But we also need=
 specific code in ptp_ioctl to implement it like in this patch.

The second way, maybe we can use the flag as a module parameter, this is ea=
sier to implement.
  @maz@kernel.org WDYT?
=20
> > diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> > index fef72f29f3c8..8b0a7b328bcd 100644
> > --- a/drivers/ptp/ptp_chardev.c
> > +++ b/drivers/ptp/ptp_chardev.c
> > @@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int
> cmd, unsigned long arg)
> >  	struct timespec64 ts;
> >  	int enable, err =3D 0;
> >
> > +#ifdef CONFIG_ARM64
> > +	static long flag;
>=20
> static?  This is not going to fly.

Need remove here.

>=20
> > +		 * In most cases, we just need virtual counter from host and
> > +		 * there is limited scenario using this to get physical counter
> > +		 * in guest.
> > +		 * Be careful to use this as there is no way to set it back
> > +		 * unless you reinstall the module.
>=20
> How on earth is the user supposed to know this?
>=20
Yeah, It's odd , should be removed.

> From your description, this "flag" really should be a module parameter.
Maybe use flag as a module parameter is a better way.

Thanks
Jianyong=20
>=20
> Thanks,
> Richard
