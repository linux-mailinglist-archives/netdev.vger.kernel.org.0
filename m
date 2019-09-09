Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A8AD691
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 12:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbfIIKRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 06:17:46 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:13828
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728358AbfIIKRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 06:17:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NseBk28u5QfqyWTtvRK9JQi1xO+q6kt7V6DbbrAJIuw=;
 b=2RXVv39/uhi4vsHWaz1GWh5ZuSTtiNddAktEIKmupLyoVZ+UOVOdUioKAV5G7sWwPX2jsTei6UrrE5LcGvi+rw++loRkxAe0sDO97FD0C8OphOd3fdeizJT+UI1XL7BSxGlH/FCKlyieKt/sSCiryRX8XJFLDkP9/AJ7plBWUkM=
Received: from AM6PR08CA0020.eurprd08.prod.outlook.com (2603:10a6:20b:b2::32)
 by DB8PR08MB4972.eurprd08.prod.outlook.com (2603:10a6:10:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.18; Mon, 9 Sep
 2019 10:17:36 +0000
Received: from AM5EUR03FT017.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::203) by AM6PR08CA0020.outlook.office365.com
 (2603:10a6:20b:b2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.14 via Frontend
 Transport; Mon, 9 Sep 2019 10:17:35 +0000
Authentication-Results: spf=temperror (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=temperror action=none
 header.from=arm.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arm.com: DNS Timeout)
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT017.mail.protection.outlook.com (10.152.16.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14 via Frontend Transport; Mon, 9 Sep 2019 10:17:34 +0000
Received: ("Tessian outbound 1b0c40e33850:v28"); Mon, 09 Sep 2019 10:17:32 +0000
X-CR-MTA-TID: 64aa7808
Received: from de957b0b3119.3 (ip-172-16-0-2.eu-west-1.compute.internal [104.47.10.56])
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 35F2C035-E194-4573-936B-FE035222200C.1;
        Mon, 09 Sep 2019 10:17:27 +0000
Received: from EUR03-DB5-obe.outbound.protection.outlook.com (mail-db5eur03lp2056.outbound.protection.outlook.com [104.47.10.56])
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id de957b0b3119.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 09 Sep 2019 10:17:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kvx7xXQTezedXvYlPeWoxetb4kmPiGepgWG8e6erDFZ0Ef1rJ8sbwtJk3Vt4x9PhmNXDzDUhFYJ6MnGHZODow9apjQ3hiaJjTAwmnl2K4UMttzXfbjrIHEJ4iBPoYutv9jeE65J6yJjwSiRLOhU0WuUO3T2R8MOVq5FILSPCS7eCPFj07bLIG29UYCBhRR2B27U3uxAXrc0SZhqO+p7rbfQuISVc8eRZp/2x+Mv+2GOT/bgpaseARAP1exe1e0PpaUNUysenCjl9OP/ztbb7yleceZwf/Kbk9iwhY82QKw89z7kVEpeF4uwGOA9tO0M6uSMAcki5x2qd1HAhqbyjwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpsS2TPrHOYKrlejv+FGnOAtihhIkh/M3jCsXNsBZrk=;
 b=H/95OS9VMhYf+bloXglq6PazQrsEXxDk4gDbwMi42XBStfuB3vnAtc57sArfhUgVJ737jTSv9FsoEpuQYI1MD0hqHzi4XA776wQGDqwNqSDsLmY8TiM3nb2mJ3AaFEOX/vY4lKr0tRqMuf8+4VpuubEJ6wr6WX7BeFBrjuIwmCIZwcyeal3nwj7gKL8BcU2wI/5YpxxNuaDTHPABf+csNznim1zH4WAbiLpZm25jOjuiWeOS+DKeX1UucyJna3iNdbZ+PMrETJa/zfZoTtc3rFg/Kk88/sh+h0Q0bUfL3jRwZKa0A1OJHv0iJQKdyDJwl4XBmYNNiinCl9lAoFimWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpsS2TPrHOYKrlejv+FGnOAtihhIkh/M3jCsXNsBZrk=;
 b=iM6tAxUBdLbzyDeKgJUe+l/z68y13llYB5E0x9mQmgPoKTrW/FKdurCFwfNcLMQ6Sku2t0/j1WmhBqKVCKcAznZlCi4AhK0BIHfyYvxWVSy4VsxyAUNuGcxV0HTDFXOe66WPg8GpiZ+j1VOgxc1e5qkbNlaGy1bfObxqUtdhBkI=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB2058.eurprd08.prod.outlook.com (10.168.95.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Mon, 9 Sep 2019 10:17:24 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::40a2:f892:29a7:2942%10]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 10:17:24 +0000
From:   "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com>
To:     Marc Zyngier <maz@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        "Kaly Xin (Arm Technology China)" <Kaly.Xin@arm.com>,
        "Justin He (Arm Technology China)" <Justin.He@arm.com>
Subject: RE: [RFC PATCH 3/3] Enable ptp_kvm for arm64
Thread-Topic: [RFC PATCH 3/3] Enable ptp_kvm for arm64
Thread-Index: AQHVXjSmk4aR/CraEk2ZVbEHwQusoKcR7cKAgAyZL9CAAXZNAIADI2mA
Date:   Mon, 9 Sep 2019 10:17:24 +0000
Message-ID: <HE1PR0801MB16768BE47D3D1F0662DDC3C7F4B70@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20190829063952.18470-1-jianyong.wu@arm.com>
        <20190829063952.18470-4-jianyong.wu@arm.com>
        <4d04867c-2188-9574-fbd1-2356c6b99b7d@kernel.org>
        <HE1PR0801MB16768ED94EA50010EEF634EAF4BA0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
 <86h85osbzz.wl-maz@kernel.org>
In-Reply-To: <86h85osbzz.wl-maz@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 854e2a7c-0269-46bd-977d-5dda69c1b023.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: d90b3dcb-cf9a-4966-c8e9-08d7350eee80
X-MS-Office365-Filtering-HT: Tenant
X-Microsoft-Antispam-Untrusted: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:HE1PR0801MB2058;
X-MS-TrafficTypeDiagnostic: HE1PR0801MB2058:|HE1PR0801MB2058:|DB8PR08MB4972:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB497249E98ABD7FE95AFF7D49F4B70@DB8PR08MB4972.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:9508;
x-forefront-prvs: 01559F388D
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(13464003)(51444003)(189003)(199004)(71200400001)(446003)(53936002)(71190400001)(55016002)(6916009)(66066001)(476003)(486006)(4326008)(9686003)(6246003)(53546011)(66556008)(6436002)(25786009)(66446008)(64756008)(256004)(14444005)(5660300002)(52536014)(186003)(478600001)(66946007)(229853002)(102836004)(26005)(55236004)(6506007)(66476007)(3846002)(6116002)(2906002)(14454004)(30864003)(54906003)(11346002)(33656002)(76116006)(316002)(99286004)(74316002)(7696005)(305945005)(86362001)(8676002)(7736002)(76176011)(8936002)(81156014)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB2058;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info-Original: pniV5WGrICxA7HSL5AlEmazXTC1T6fCjnO8MmD5pGZMGEyRfZQJebut6LVitGBLU+kDz78wRY654kQ5EwMFomdloRIo6jxh+ZXCh0dyRcjLVKB4wZb7BGUiJ1aBmh1TWryAedrHQTP1HK57i16OiH62GriCfTc1OFq5D2C6L+metamHJ6mz2S0g3+ZRTcfNCOGRHa18G+oMEK2FUCNhSAQBqtpzIzjWypQtQghZ/gc9FDYYHS/lOCOIj8DT94L8nvBrZXFDgYIFzuvQPGvzqAiKufQ7iDYMezesl4wM6fSklYSnA2q/hZoJLGLUH9zVD3keqgLFdTtiKKsMHaF8tjRfrZR1x/kcmX2HfKS5Vx4SnYGZ37Xcv5MwYqIS4kqALJk72/3oKCzAdskHj8y1CduVfD2RIqNx/hNVu+5/Z+7s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB2058
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT017.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(376002)(2980300002)(13464003)(199004)(189003)(51444003)(40434004)(63350400001)(63370400001)(8676002)(11346002)(6116002)(2906002)(478600001)(9686003)(30864003)(5660300002)(76176011)(7736002)(46406003)(55016002)(47776003)(86362001)(7696005)(66066001)(26826003)(70206006)(52536014)(22756006)(70586007)(36906005)(336012)(8936002)(8746002)(6506007)(53546011)(14454004)(102836004)(76130400001)(450100002)(23726003)(81166006)(25786009)(97756001)(6246003)(356004)(4326008)(486006)(186003)(6862004)(33656002)(99286004)(50466002)(305945005)(446003)(74316002)(3846002)(54906003)(476003)(229853002)(316002)(26005)(14444005)(126002)(5024004)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR08MB4972;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:TempError;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;A:1;MX:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 721f6ee1-23c8-4677-48fd-08d7350ee88b
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(710020)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR08MB4972;
X-Forefront-PRVS: 01559F388D
X-Microsoft-Antispam-Message-Info: xFo6/0g2NEtsDw4UdigBBuPPe/UFU6fozucqYebncGQ+7JYDoNKYtMwLqQaxryHspTpkW+HyzbmQRAP1kHI1hLUFg6ikNM1k15dBYe9kmARiPLBKD0dyCIwWVaTgiPOUZmTHnUZ8Drc1qdFgKIAwEXbOgKaMNpvTjVdG87Hq0cPfT0IX+/6tEx5scHOslIE/SxFN1KSumrhp+4rhAbdaOvCt07s4U2rEiU1fjg/Rqcnd8EzLj8gzBnNmovKWBy8uBA5ifq50mTrB+gVEWlcHsIL60xg+P75nxd3PqaX30eKDTyp3lb+DJiDPg8cm2JVy0Is0HupucN6d75Tc8c2WNiS+6uYqFcNnQrTEbwS/E+T5WoI8+Ygj5D5uaTtaZuod+lrzjDWlk4ZI1IYCCvP4FqYaYfU8Nrtey9kGrnWp+Z8=
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2019 10:17:34.1314
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d90b3dcb-cf9a-4966-c8e9-08d7350eee80
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB4972
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Saturday, September 7, 2019 5:16 PM
> To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; pbonzini@redhat.com;
> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; Will Deacon <Will.Deacon@arm.com>; Suzuki
> Poulose <Suzuki.Poulose@arm.com>; linux-kernel@vger.kernel.org; Steve
> Capper <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> <Justin.He@arm.com>
> Subject: Re: [RFC PATCH 3/3] Enable ptp_kvm for arm64
>
> On Fri, 06 Sep 2019 12:58:15 +0100,
> "Jianyong Wu (Arm Technology China)" <Jianyong.Wu@arm.com> wrote:
> >
> > Hi Marc,
> >
> > Very sorry to have missed this comments.
> >
> > > -----Original Message-----
> > > From: Marc Zyngier <maz@kernel.org>
> > > Sent: Thursday, August 29, 2019 6:33 PM
> > > To: Jianyong Wu (Arm Technology China) <Jianyong.Wu@arm.com>;
> > > netdev@vger.kernel.org; pbonzini@redhat.com;
> > > sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> > > Rutland <Mark.Rutland@arm.com>; Will Deacon
> <Will.Deacon@arm.com>;
> > > Suzuki Poulose <Suzuki.Poulose@arm.com>
> > > Cc: linux-kernel@vger.kernel.org; Steve Capper
> > > <Steve.Capper@arm.com>; Kaly Xin (Arm Technology China)
> > > <Kaly.Xin@arm.com>; Justin He (Arm Technology China)
> > > <Justin.He@arm.com>
> > > Subject: Re: [RFC PATCH 3/3] Enable ptp_kvm for arm64
> > >
> > > On 29/08/2019 07:39, Jianyong Wu wrote:
> > > > Currently in arm64 virtualization environment, there is no
> > > > mechanism to keep time sync between guest and host. Time in guest
> > > > will drift compared with host after boot up as they may both use
> > > > third party time sources to correct their time respectively. The
> > > > time deviation will be in order of milliseconds but some scenarios
> > > > ask for higher time precision, like in cloud envirenment, we want
> > > > all the VMs running in the host aquire the same level accuracy from
> host clock.
> > > >
> > > > Use of kvm ptp clock, which choose the host clock source clock as
> > > > a reference clock to sync time clock between guest and host has
> > > > been adopted by x86 which makes the time sync order from
> > > > milliseconds to
> > > nanoseconds.
> > > >
> > > > This patch enable kvm ptp on arm64 and we get the similar clock
> > > > drift as found with x86 with kvm ptp.
> > > >
> > > > Test result comparison between with kvm ptp and without it in
> > > > arm64 are as follows. This test derived from the result of command
> > > > 'chronyc sources'. we should take more cure of the last sample
> > > > column which shows the offset between the local clock and the
> > > > source at the last
> > > measurement.
> > > >
> > > > no kvm ptp in guest:
> > > > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> > > >
> > >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-  =
 21ms
> > > > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-  =
 21ms
> > > >
> > > > in host:
> > > > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> > > >
> > >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-  =
 18ms
> > > > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-  =
 18ms
> > > > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-  =
 18ms
> > > > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-  =
 17ms
> > > > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-  =
 17ms
> > > >
> > > > The dns1.synet.edu.cn is the network reference clock for guest and
> > > > 120.25.115.20 is the network reference clock for host. we can't
> > > > get the clock error between guest and host directly, but a roughly
> > > > estimated value will be in order of hundreds of us to ms.
> > > >
> > > > with kvm ptp in guest:
> > > > chrony has been disabled in host to remove the disturb by network
> clock.
> > >
> > > Is that a realistic use case? Why should the host not use NTP?
> > >
> >
> > Not really, NTP will change the the host clock which will contaminate
> > the data of sync between Host and guest. But in reality, we will keep N=
TP
> online.
> >
> > > >
> > > > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> > > >
> > >
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-  =
  3ns
> > > > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-  =
  3ns
> > > > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-  =
  6ns
> > > > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-  =
  5ns
> > > > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-  =
  4ns
> > > > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-  =
  4ns
> > > > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-  =
  4ns
> > > > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-  =
  6ns
> > > > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-  =
  4ns
> > > > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-  =
  4ns
> > > >
> > > > The PHC0 is the ptp clock which choose the host clock as its
> > > > source clock. So we can be sure to say that the clock error
> > > > between host and guest is in order of ns.
> > > >
> > > > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> > > > ---
> > > >  arch/arm64/include/asm/arch_timer.h  |  3 ++
> > > >  arch/arm64/kvm/arch_ptp_kvm.c        | 76
> > > ++++++++++++++++++++++++++++
> > > >  drivers/clocksource/arm_arch_timer.c |  6 ++-
> > > >  drivers/ptp/Kconfig                  |  2 +-
> > > >  include/linux/arm-smccc.h            | 14 +++++
> > > >  virt/kvm/arm/psci.c                  | 17 +++++++
> > > >  6 files changed, 115 insertions(+), 3 deletions(-)  create mode
> > > > 100644 arch/arm64/kvm/arch_ptp_kvm.c
> > >
> > > Please split this patch into two parts: the hypervisor code in a
> > > patch and the guest code in another patch. Having both of them togeth=
er
> is confusing.
> > >
> > Ok,  really better.
> >
> > > >
> > > > diff --git a/arch/arm64/include/asm/arch_timer.h
> > > > b/arch/arm64/include/asm/arch_timer.h
> > > > index 6756178c27db..880576a814b6 100644
> > > > --- a/arch/arm64/include/asm/arch_timer.h
> > > > +++ b/arch/arm64/include/asm/arch_timer.h
> > > > @@ -229,4 +229,7 @@ static inline int arch_timer_arch_init(void)
> > > >     return 0;
> > > >  }
> > > >
> > > > +extern struct clocksource clocksource_counter; extern u64
> > > > +arch_counter_read(struct clocksource *cs);
> > >
> > > I'm definitely not keen on exposing the internals of the arch_timer
> > > driver to random subsystems. Furthermore, you seem to expect that
> > > the guest kernel will only use the arch timer as a clocksource, and
> > > nothing really guarantees that (in which case
> get_device_system_crosststamp will fail).
> > >
> > The code here is really ugly, I need a better solution to offer a
> > clock source For the guest.
> >
> > > It looks to me that we'd be better off exposing a core timekeeping
> > > API that populates a struct system_counterval_t based on the
> > > *current* timekeeper monotonic clocksource. This would simplify the
> > > split between generic and arch-specific code.
> > >
> > I think it really necessary.
> >
> > > Whether or not tglx will be happy with the idea is another problem,
> > > but I'm certainly not taking any change to the arch timer code based =
on
> this.
> > >
> > I can have a try, but the detail is not clear for me now.
>
> Something along those lines:
>
> From 5f1c061e55c691d64012bc7c1490a1a8c4432c67 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Sat, 7 Sep 2019 10:11:49 +0100
> Subject: [PATCH] timekeeping: Expose API allowing retrival of current
> clocksource and counter value
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  include/linux/timekeeping.h |  5 +++++
>  kernel/time/timekeeping.c   | 12 ++++++++++++
>  2 files changed, 17 insertions(+)
>
> diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h in=
dex
> b27e2ffa96c1..6df26a913711 100644
> --- a/include/linux/timekeeping.h
> +++ b/include/linux/timekeeping.h
> @@ -275,6 +275,11 @@ extern int get_device_system_crosststamp(
>                       struct system_time_snapshot *history,
>                       struct system_device_crosststamp *xtstamp);
>
> +/*
> + * Obtain current monotonic clock and its counter value  */ extern void
> +get_current_counterval(struct system_counterval_t *sc);
> +
>  /*
>   * Simultaneously snapshot realtime and monotonic raw clocks
>   */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c index
> d911c8470149..de689bbd3808 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1098,6 +1098,18 @@ static bool cycle_between(u64 before, u64 test,
> u64 after)
>       return false;
>  }
>
> +/**
> + * get_current_counterval - Snapshot the current clocksource and counter
> value
> + * @sc:      Pointer to a struct containing the current clocksource and =
its
> value
> + */
> +void get_current_counterval(struct system_counterval_t *sc) {
> +     struct timekeeper *tk =3D &tk_core.timekeeper;
> +
> +     sc->cs =3D READ_ONCE(tk->tkr_mono.clock);
> +     sc->cycles =3D sc->cs->read(sc->cs);
> +}
> +
>  /**
>   * get_device_system_crosststamp - Synchronously capture system/device
> timestamp
>   * @get_time_fn:     Callback to get simultaneous device time and
>
> which should do the right thing.
>
It is a good news for me. These code is indeed what I need!
So what's your plan about this patch?  Is there any problem with you if I i=
nclude these code
into my patch ?

> >
> > > > +
> > > >  #endif
> > > > diff --git a/arch/arm64/kvm/arch_ptp_kvm.c
> > > > b/arch/arm64/kvm/arch_ptp_kvm.c
> > >
> > > We don't put non-hypervisor in arch/arm64/kvm. Please move it back
> > > to drivers/ptp (as well as its x86 counterpart), and just link the tw=
o parts
> there.
> > > This should also allow this to be enabled for 32bit guests.
> > >
> > Err, sorry, what's mean of "link the two parts there"? should I add
> > another two file update driver/ptp/ Both for arm64 and x86 to contains
> > these arch-specific code or pack them all into ptp_kvm.c?
>
> What I'm suggesting is that you have 3 files:
>
>   drivers/ptp/ptp_kvm.c
>   drivers/ptp/ptp_kvm_x86.c
>   drivers/ptp/ptp_kvm_arm.c
>
> and let the Makefile combine them.
>
> [...]
>
it is what I want to do at the beginning of drafting these patches.

> > > Other questions: how does this works with VM migration? Specially
> > > when moving from a hypervisor that supports the feature to one that
> doesn't?
> > >
> > I think it won't solve the problem generated by VM migration and only
> > for VMs in a single machine.  Ptp_kvm only works for VMs in the same
> > machine.  But using ptp (not ptp_kvm) clock, all the machines in a low
> > latency network environment can keep time sync in high precision, Then
> > VMs move from one machine to another will obtain a high precision time
> > sync.
>
> That's a problem. Migration must be possible from one host to another, ev=
en
> if that means temporarily loosing some (or a lot of) precision. The servi=
ce
> must be discoverable from userspace on the host so that the MVV can decie
> whether a migration is possible or not.
>
Don't worry, things will be not that bad.
ptp_kvm will not trouble the VM migration. This ptp_kvm is one clocksource =
of the clock pool for
chrony. Chrony will choose the highest precision clock from the pool. If ho=
st does not support
ptp_kvm, the ptp_kvm will not be chosen as the clocksouce of chrony.
We have roughly the same logic of implementation of ptp_kvm with x86, and p=
tp_kvm works well in x86.
so I think that will be the case for arm64.

Maybe I miss your point, I have no idea of MVV and can't get related info f=
rom google.
Also I'm not clear of your last words of how to decide VM migration is poss=
ible?

Thanks
Jianyong Wu

> Thanks,
>
>       M.
>
> --
> Jazz is not dead, it just smells funny.
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
