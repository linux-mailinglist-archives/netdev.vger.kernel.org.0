Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908C9B5B88
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 08:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfIRGBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 02:01:54 -0400
Received: from mail-eopbgr30081.outbound.protection.outlook.com ([40.107.3.81]:53921
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbfIRGBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 02:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU27VzIsiqU7nilB7U+07yVO9o8p1lR8kj+eahsonPg=;
 b=JiyTPGZAXMv302JVGw553l0rEox4CkxBi98W/vYVbf40QRUT6zLc2jEmoXOSnyGs47MQnlOEWEr/HqK3GvJTNm3GAcbOApK3IChdFUXtKvsPmom422BhcFiDlzOSe1nmEXAO/MRwwd38ABxMskQTwm6FofKFeZW4hZnC5hGYFK4=
Received: from HE1PR08CA0067.eurprd08.prod.outlook.com (2603:10a6:7:2a::38) by
 DB8PR08MB4076.eurprd08.prod.outlook.com (2603:10a6:10:b0::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Wed, 18 Sep 2019 06:01:46 +0000
Received: from AM5EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::206) by HE1PR08CA0067.outlook.office365.com
 (2603:10a6:7:2a::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2284.18 via Frontend
 Transport; Wed, 18 Sep 2019 06:01:46 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=none action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT028.mail.protection.outlook.com (10.152.16.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.14 via Frontend Transport; Wed, 18 Sep 2019 06:01:44 +0000
Received: ("Tessian outbound d5a1f2820a4f:v31"); Wed, 18 Sep 2019 06:01:43 +0000
X-CR-MTA-TID: 64aa7808
Received: from 0b333124ff32.2 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.0.57])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 56582147-6A58-4446-8240-B293CC1E63B7.1;
        Wed, 18 Sep 2019 06:01:38 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 0b333124ff32.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 18 Sep 2019 06:01:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqHsDtIzGeTFklqlq+VrgAgH397JKMRUBK10EM5eoFUfHVw8+aHHIkBWqnnrztbSJM9GNCRpfZC0s2QA4kGIbj0d8pJH3KwoNz2DNcDHs4Ma5l85j8KCjxn7BDLZIeSL2IMueWkk4ljfxcujVveDQ/kNJ6UQa4QjzZ2SWnM/oemgjd0TpkCkkphQgeJApMbbErkL+KDLwyJmY1liSpeO1/8POR3RQDFVbE/SuCt7yj+ZNc+FKWLutikHwOALsiUB9KyfYrceFX6niPi/8LEyl13cH4AAZT6EjdlHzAxY8IA+VHDBTeOlTvf6yyB6t4W2aRfFzY/oRwYeCb5qdnGQRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU27VzIsiqU7nilB7U+07yVO9o8p1lR8kj+eahsonPg=;
 b=QwuRhHML1cvZ49LJEMUWTV0zU/CTmFp8kZDrC7wm2CCFiPy/kOwfZLkH0WapOEXmo380uuQLNBs3JD13y8fl0LJiNXYH+22n4M9oelAeY+rH/+IuqGEYQr56Bdnp3kYCdRnHKqCqBHExFE/H2I66iM3CAkq3DZmgyScMECnThIU+qBxdOW/JBgWO/q8l8DtGLE7XeKM59cvd3IntCN8DaW9x1hno31aXA+k1wZjEmcUAVD20xPWCdkVi3cI1crzZppVAVIrypuCdSp9cu06F3b/pLcL+VFghf8yhnHu4bNp4HYO032AjWB9+KWFyBQWR3qmJGoYhd4wWz3+XQd9UrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU27VzIsiqU7nilB7U+07yVO9o8p1lR8kj+eahsonPg=;
 b=JiyTPGZAXMv302JVGw553l0rEox4CkxBi98W/vYVbf40QRUT6zLc2jEmoXOSnyGs47MQnlOEWEr/HqK3GvJTNm3GAcbOApK3IChdFUXtKvsPmom422BhcFiDlzOSe1nmEXAO/MRwwd38ABxMskQTwm6FofKFeZW4hZnC5hGYFK4=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1690.eurprd08.prod.outlook.com (10.168.145.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Wed, 18 Sep 2019 06:01:34 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2263.023; Wed, 18 Sep
 2019 06:01:34 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>,
        nd <nd@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/6] Timer: expose monotonic clock and counter value
Thread-Topic: [PATCH 3/6] Timer: expose monotonic clock and counter value
Thread-Index: AQHVbUqaDFZ5iqdiL0+E9FJrHymYEKcwy6KAgAAi8UA=
Date:   Wed, 18 Sep 2019 06:01:34 +0000
Message-ID: <HE1PR0801MB1676AD8E5E50B70F1E3CD9F5F48E0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190917112430.45680-1-jianyong.wu@arm.com>
 <20190917112430.45680-4-jianyong.wu@arm.com>
 <20190918034235.GA1469@localhost>
In-Reply-To: <20190918034235.GA1469@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 608732e4-db59-46e7-920f-83398e68906f.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: c962753e-ec51-4b27-f9d5-08d73bfdaf55
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB1690;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1690:|HE1PR0801MB1690:|DB8PR08MB4076:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB407667EF5F2C4E42B60A1432F48E0@DB8PR08MB4076.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:2000;OLM:2000;
x-forefront-prvs: 01644DCF4A
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(13464003)(199004)(189003)(186003)(102836004)(6506007)(53546011)(55236004)(66066001)(26005)(33656002)(99286004)(7696005)(66446008)(64756008)(66556008)(66476007)(76116006)(8936002)(66946007)(476003)(11346002)(81166006)(81156014)(8676002)(446003)(3846002)(52536014)(2906002)(5660300002)(486006)(54906003)(76176011)(86362001)(6116002)(316002)(7736002)(6246003)(478600001)(55016002)(14454004)(9686003)(25786009)(6436002)(229853002)(4326008)(71200400001)(71190400001)(1411001)(305945005)(74316002)(256004)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1690;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: l1G1qFjo0Us2Sxndm+WD5HpZPQ32cQmgsKtS2IrPrOn27WJAgOG1p6TYK5f2TMU1l76bqTQwboLBH4xb/CLu3E4PMV62rGQu2bb3xZIT7DwkuicwRybbd5g8eShNpa1LpB3rhxlPXQSiHS2++4qAqCFIUQlUXYpCOaMqd/LawWak5L827xrK4nrjf0FVDyoDzAE+fwFXTJJnip449RuucVmADRVOny/eSLE9t7D5C/OSR9cNSDR9U4ffaCmdIp3ttSO35O0XUMwDTV+KIYKQgp5INMFdAe9H3G/9JikgQcylEWcJBHBg2zOCTAEz3iTr/Tf1dfKFEcXcka+ca48up7YJIfkyzY95nF9Z7qIxLia+ujP0qn5q5HccPlnmEJy786q6X4WmfW2gkvoSJwLQyORYuRgUysdQFluDwfPmhzw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1690
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(346002)(199004)(189003)(13464003)(5660300002)(55016002)(6116002)(8746002)(478600001)(316002)(26005)(102836004)(26826003)(70586007)(53546011)(6862004)(50466002)(2906002)(76130400001)(8936002)(63350400001)(336012)(11346002)(446003)(33656002)(7696005)(14454004)(8676002)(186003)(81156014)(76176011)(86362001)(229853002)(6506007)(81166006)(4326008)(54906003)(36906005)(22756006)(1411001)(46406003)(52536014)(9686003)(450100002)(25786009)(6246003)(70206006)(476003)(66066001)(107886003)(74316002)(97756001)(356004)(99286004)(7736002)(305945005)(126002)(486006)(23726003)(3846002)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR08MB4076;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 840208ee-0a22-4ad2-17b1-08d73bfda944
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(710020)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR08MB4076;
NoDisclaimer: True
X-Forefront-PRVS: 01644DCF4A
X-Microsoft-Antispam-Message-Info: wIntRmAPq1glL77UCo9KT0o+hbr+U/eP45y1LMq59btu/4SCCAdU9teyjF9ZKDqGP7XOSxXpC37IEkPpCLWZF0hjhjGDip388MXyFT05W2J6Oq6P1fyb/qn5uXFKL+TFJPWbkE8VZx8vOfXhX5+Wl70XxIQcuUw6W2Ik/0/k4SMc0OGZXI4U85QLqnv3mb42NwvHVapm2uvGBxan84Pyc+ALqJPo99bXHMxYKhXtrsHGo7+bGP1FC8bqdKrwHHflDqidKHjBN6ztoJ++XYgj9cU75agNfBo5N0Z0VP5A0JPOh85O7lhtGzSTX+wkIpIG9wEC7oJU3bwOS748SH0BGyQ/SRhIr6Uuq74sz2HTydKpsRgW8H15OdZcl6zXcJtqhZob1G+k1j37QfK1lDzBKTvQptlrCaqgoZsgTbRWOZM=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2019 06:01:44.9875
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c962753e-ec51-4b27-f9d5-08d73bfdaf55
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Wednesday, September 18, 2019 11:43 AM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; maz@kernel.org; Mark Rutland
> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org; Steve
> Capper <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>; nd <nd@arm.com>; linux-arm-
> kernel@lists.infradead.org
> Subject: Re: [PATCH 3/6] Timer: expose monotonic clock and counter value
>=20
> On Tue, Sep 17, 2019 at 07:24:27AM -0400, Jianyong Wu wrote:
> > A number of PTP drivers (such as ptp-kvm) are assuming what the
> > current clock source is, which could lead to interesting effects on
> > systems where the clocksource can change depending on external events.
> >
> > For this purpose, add a new API that retrives both the current
> > monotonic clock as well as its counter value.
> >
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > ---
> >  include/linux/timekeeping.h |  3 +++
> >  kernel/time/timekeeping.c   | 13 +++++++++++++
> >  2 files changed, 16 insertions(+)
>=20
> For core time keeping changes, you must CC lkml, tglx, and John Stultz.
>=20

Thanks, I will.

Thanks
Jianyong Wu

> Thanks,
> Richard
