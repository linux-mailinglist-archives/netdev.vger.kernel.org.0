Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB6D25F671
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728324AbgIGJ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:28:29 -0400
Received: from mail-am6eur05on2079.outbound.protection.outlook.com ([40.107.22.79]:15766
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727122AbgIGJ2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 05:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=cxHIgqtUpMiTEdgzKpXt0OctKngyjNFS89BXiHGFoUja8JmnT5YysX6f5XMTBCXCWgJuT6gg2VkaX8ZDMc+7HyeWlayHCZJ891ufJCEiGLSmGnly5g3pYNNNkFBqCHfoFgXzes9piM37aANCs+gy5Svp6I3GXCz1+d5ydG6Su1o=
Received: from AM5PR1001CA0019.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:2::32)
 by AM0PR08MB3058.eurprd08.prod.outlook.com (2603:10a6:208:5a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 09:28:14 +0000
Received: from VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:2:cafe::8) by AM5PR1001CA0019.outlook.office365.com
 (2603:10a6:206:2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend
 Transport; Mon, 7 Sep 2020 09:28:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT038.mail.protection.outlook.com (10.152.19.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 09:28:13 +0000
Received: ("Tessian outbound 195a290eb161:v64"); Mon, 07 Sep 2020 09:28:13 +0000
X-CR-MTA-TID: 64aa7808
Received: from f8e596ab0ae9.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 672D886F-B51D-442A-A468-AFF621A70880.1;
        Mon, 07 Sep 2020 09:28:08 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id f8e596ab0ae9.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 07 Sep 2020 09:28:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atcFvWU097ck/38YWCo9EoUc1D8YT0WRwZzXakLyWtai12/ZyNFWli9Elm3jZA4dzo/53wsd8bbX47xwr6/BnZg3hwnqXTFlV3XvmEA1326E5/itThuQP913AbP+f0/NL45871LSRqrtiB+IjL+7gff9DllWWpzXrFGNvSDSPiVbP+HjUYtrZjIUUbyoGaFegachJRWUBBmBkoJra459UJ76HW8EFiBClMlQhdeU2fr1NWYIkQ2lF9DwH/fyoZrozW7dOwN7Vt/LoR6veAmr84t36s1vBe6eO4WOn/o37wZQrAaYosJ0KH8Fp+a8p81WdJmyCprlEhpB23OUJ9R4Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=RngVqezZm7fVvRzd587v3SxlNi9fUMJeSJIoOU3YuIX0DnsOEO0W7nL3Ocl4zcwfUCeiYNGhyWsvUzqZ3v96qK3B7juiOCavQjZP32cnnGIA+VAKkTTfE3qp3ivIUhcFC1PX3m/M9yzU/lvdL6uIvQHMeeAegJ28G2mTSaMucl87UXuZhcYDEdP6AjT5aaHWgvDWTQjtM0GP/Jv0Kyjq8PH9xuRkM0RmZ0ATYevE+5EqHpuSNL7OK61oMc8nZ7pb9wfxfMDFvdU+brH9T/n1w34sgG4v4gFxMf9+vU7YUMQQW2hxSmZoBfHMU426fRG62MBy2DHt5FtRCBSXdxM4Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+LIRbyS7mirD2uo0rjpTaYxaNJIbnZAyoeU7Egu2LM=;
 b=cxHIgqtUpMiTEdgzKpXt0OctKngyjNFS89BXiHGFoUja8JmnT5YysX6f5XMTBCXCWgJuT6gg2VkaX8ZDMc+7HyeWlayHCZJ891ufJCEiGLSmGnly5g3pYNNNkFBqCHfoFgXzes9piM37aANCs+gy5Svp6I3GXCz1+d5ydG6Su1o=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0802MB2251.eurprd08.prod.outlook.com (2603:10a6:3:cc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Mon, 7 Sep
 2020 09:28:03 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::74f7:5759:4e9e:6e00%5]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 09:28:03 +0000
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
Subject: RE: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Topic: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
Thread-Index: AQHWgp4Q48WtGxJp4kuFSJTL6o01LqlZ4qMAgAL3/tCAAAlCgIAABDCQ
Date:   Mon, 7 Sep 2020 09:28:02 +0000
Message-ID: <HE1PR0802MB25551446DC85DB3684D09211F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
 <20200904092744.167655-9-jianyong.wu@arm.com> <874kocmqqx.wl-maz@kernel.org>
 <HE1PR0802MB2555CC56351616836A95FB19F4280@HE1PR0802MB2555.eurprd08.prod.outlook.com>
 <366387fa507f9c5d5044549cea958ce1@kernel.org>
In-Reply-To: <366387fa507f9c5d5044549cea958ce1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 8B17ACBF26669E4D86F0DDB84E900C84.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0f6dfc18-bb2c-45d3-27db-08d853105832
x-ms-traffictypediagnostic: HE1PR0802MB2251:|AM0PR08MB3058:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB3058DA9A2A6DF94898A8AA5CF4280@AM0PR08MB3058.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4502;OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: x/f0PLbhq7NvDZad5h+FRhplCb1UC+tbeWJRxGZinvG1CascCWVUEpXCFu06/rkyKZyEgxlyUMZRwbypTNHPAERXOOvBrdeXesvzDpugQlP/F6ZSR7YEp8KcERHS3jx6yEPBxGVtoS1gB6lM1rV8i+zVUW1bWFjNWBa/IxIma3CVOUuiZ6hgOT2yXDQtxbsYBg38/rO5bvwXnRYSWP2JdRCyWO2vRhNI83SoucEoY93pMJrZsapArGyM9AyjC1WXjqHMRHSB8BTb6oRPc5c50Wr+B6VTE8uLuZfrNG0zyN1MMTsQWaoHH6b3M5Os3WTA
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(186003)(52536014)(6916009)(55016002)(478600001)(71200400001)(66946007)(66476007)(83380400001)(76116006)(5660300002)(2906002)(9686003)(64756008)(7416002)(316002)(66446008)(86362001)(66556008)(54906003)(33656002)(8936002)(53546011)(26005)(4326008)(7696005)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1aXwki9yBhqKzSsk7+4c9N4r4SlMaLDSypeIPZ8DK3vNsYTc+rwVoqBzk7lYAsUwMWjEfy+zdQgQ+naTcdGzNjD2HW9or6oSuSYrCrC4B16Jczk3BXw4Vumow1NOzmydOfXsNo15ZDDkugdUtVGhdfp/nF2sIYzQXmYGcu7OHRveBwXpXkZEieo13mo/HxzyOdzwvSDpsXPh18O1p5/svdTHZNfIBDe3VM03dSfhsIDXPb0g6mDB9TEcuZrJoEok96bs4JMY7ehCUxFQ595XbxbH2Grg/0FJ3yIXOpg6XkNsQ9b4lPHBmVfG4zQ+nlCqOzsyTtxSVQBRI60iKtE/rN9d9Z9oOX61ikObQjUzr8dmsrtpHr+j2W8cYE9a9fz7mGv3Ro7how/6fRaEhZLDErlHVV4MXDVo9Pc/qpb2BVUcuJhbxdHMUR9cYxLjKkKrWHJLZHXNdeoFGwGNVDGy29FRnQGVKZPe6PgybROenHFFz13qOkQTpzs30lhD3bJElO7XCAKb1XLoTcNIiao5sBB0UG3pLL9R3PDgUfOiv502G1+C2YtahZmp3PFBsPQON4gXrMYZerxh/r7oblU0PTSndEJsMZgEY3YdxGh0oHla+eQWu9vfTSuGOkml76fc483LtEh89M6a6RxYXI9jcw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2251
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: c46a92c6-d509-4a27-9e0f-08d85310521a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtnuFdu1/lVdy3ThZqFb0Lvo+fppCjkNSFu+ONv8VUy74wVX9bdfERuKrTQAdh2ENurI4A5fqsa9lEq/Q4SfrC6TcyD7c+VUzB1m77UdMnjnWBZyo/q/6E4XRELv3SB0NOnxsGKogFEHW7DtFP9zZwoslPVQ7Oz2jy4IqsCkkoEjbFTaA3LcSDvos/abd2RdR1ekQFZ2bokPjDyMgpE70ic3ojOCZyt+Ze9KxtSAXua/3jEujthR6nPwWDd58P92JUtgK9jpqhf4+MzR3+FCmMUM1gMB5seAcvkLD13QymCiFpCYLvP3khwhe1vXl9SvU4/IljTFCjYI5BESvIuD5QFUZf9spdMww9Tu19g5Kn3zaQLT1yKhlNc2C4xOGzhXJVA+vYbRZ8LkdopkvV612g==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966005)(186003)(336012)(52536014)(86362001)(2906002)(55016002)(478600001)(9686003)(70206006)(70586007)(36906005)(6862004)(54906003)(33656002)(83380400001)(316002)(5660300002)(81166007)(47076004)(8936002)(356005)(82740400003)(8676002)(82310400003)(7696005)(26005)(4326008)(450100002)(6506007)(53546011);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 09:28:13.4930
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f6dfc18-bb2c-45d3-27db-08d853105832
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT038.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Marc Zyngier <maz@kernel.org>
> Sent: Monday, September 7, 2020 4:55 PM
> To: Jianyong Wu <Jianyong.Wu@arm.com>
> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> kvm@vger.kernel.org; Steve Capper <Steve.Capper@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
>=20
> On 2020-09-07 09:40, Jianyong Wu wrote:
> > Hi Marc,
> >
> >> -----Original Message-----
> >> From: Marc Zyngier <maz@kernel.org>
> >> Sent: Saturday, September 5, 2020 7:02 PM
> >> To: Jianyong Wu <Jianyong.Wu@arm.com>
> >> Cc: netdev@vger.kernel.org; yangbo.lu@nxp.com;
> >> john.stultz@linaro.org; tglx@linutronix.de; pbonzini@redhat.com;
> >> sean.j.christopherson@intel.com; richardcochran@gmail.com; Mark
> >> Rutland <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> >> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>;
> >> linux-kernel@vger.kernel.org; linux-arm- kernel@lists.infradead.org;
> >> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> >> <Steve.Capper@arm.com>; Justin He <Justin.He@arm.com>; nd
> >> <nd@arm.com>
> >> Subject: Re: [PATCH v14 08/10] ptp: arm64: Enable ptp_kvm for arm64
> >>
> >> On Fri, 04 Sep 2020 10:27:42 +0100,
> >> Jianyong Wu <jianyong.wu@arm.com> wrote:
> >> >
> >> > Currently, there is no mechanism to keep time sync between guest
> >> > and host in arm64 virtualization environment. Time in guest will
> >> > drift compared with host after boot up as they may both use third
> >> > party time sources to correct their time respectively. The time
> >> > deviation will be in order of milliseconds. But in some
> >> > scenarios,like in cloud envirenment, we ask for higher time precisio=
n.
> >> >
> >> > kvm ptp clock, which choose the host clock source as a reference
> >> > clock to sync time between guest and host, has been adopted by x86
> >> > which makes the time sync order from milliseconds to nanoseconds.
> >> >
> >> > This patch enables kvm ptp clock for arm64 and improve clock sync
> >> > precison significantly.
> >> >
> >> > Test result comparisons between with kvm ptp clock and without it
> >> > in
> >> > arm64 are as follows. This test derived from the result of command
> >> > 'chronyc sources'. we should take more care of the last sample
> >> > column which shows the offset between the local clock and the
> >> > source at the last
> >> measurement.
> >> >
> >> > no kvm ptp in guest:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > ^* dns1.synet.edu.cn      2   6   377    13  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    21  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    29  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    37  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    45  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    53  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    61  +1040us[+1581us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377     4   -130us[ +796us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    12   -130us[ +796us] +/-   =
21ms
> >> > ^* dns1.synet.edu.cn      2   6   377    20   -130us[ +796us] +/-   =
21ms
> >> >
> >> > in host:
> >> > MS Name/IP address   Stratum Poll Reach LastRx Last sample
> >> >
> >>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > ^* 120.25.115.20          2   7   377    72   -470us[ -603us] +/-   =
18ms
> >> > ^* 120.25.115.20          2   7   377    92   -470us[ -603us] +/-   =
18ms
> >> > ^* 120.25.115.20          2   7   377   112   -470us[ -603us] +/-   =
18ms
> >> > ^* 120.25.115.20          2   7   377     2   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377    22   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377    43   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377    63   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377    83   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377   103   +872ns[-6808ns] +/-   =
17ms
> >> > ^* 120.25.115.20          2   7   377   123   +872ns[-6808ns] +/-   =
17ms
> >> >
> >> > The dns1.synet.edu.cn is the network reference clock for guest and
> >> > 120.25.115.20 is the network reference clock for host. we can't get
> >> > the clock error between guest and host directly, but a roughly
> >> > estimated value will be in order of hundreds of us to ms.
> >> >
> >> > with kvm ptp in guest:
> >> > chrony has been disabled in host to remove the disturb by network
> clock.
> >> >
> >> > MS Name/IP address         Stratum Poll Reach LastRx Last sample
> >> >
> >>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> > * PHC0                    0   3   377     8     -7ns[   +1ns] +/-   =
 3ns
> >> > * PHC0                    0   3   377     8     +1ns[  +16ns] +/-   =
 3ns
> >> > * PHC0                    0   3   377     6     -4ns[   -0ns] +/-   =
 6ns
> >> > * PHC0                    0   3   377     6     -8ns[  -12ns] +/-   =
 5ns
> >> > * PHC0                    0   3   377     5     +2ns[   +4ns] +/-   =
 4ns
> >> > * PHC0                    0   3   377    13     +2ns[   +4ns] +/-   =
 4ns
> >> > * PHC0                    0   3   377    12     -4ns[   -6ns] +/-   =
 4ns
> >> > * PHC0                    0   3   377    11     -8ns[  -11ns] +/-   =
 6ns
> >> > * PHC0                    0   3   377    10    -14ns[  -20ns] +/-   =
 4ns
> >> > * PHC0                    0   3   377     8     +4ns[   +5ns] +/-   =
 4ns
> >> >
> >> > The PHC0 is the ptp clock which choose the host clock as its source
> >> > clock. So we can see that the clock difference between host and
> >> > guest is in order of ns.
> >> >
> >> > Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> >> > ---
> >> >  drivers/clocksource/arm_arch_timer.c | 24 +++++++++++++
> >> >  drivers/ptp/Kconfig                  |  2 +-
> >> >  drivers/ptp/ptp_kvm_arm64.c          | 53
> >> ++++++++++++++++++++++++++++
> >> >  3 files changed, 78 insertions(+), 1 deletion(-)  create mode
> >> > 100644 drivers/ptp/ptp_kvm_arm64.c
> >> >
> >> > diff --git a/drivers/clocksource/arm_arch_timer.c
> >> > b/drivers/clocksource/arm_arch_timer.c
> >> > index d55acffb0b90..aaf286e90092 100644
> >> > --- a/drivers/clocksource/arm_arch_timer.c
> >> > +++ b/drivers/clocksource/arm_arch_timer.c
> >> > @@ -1650,3 +1650,27 @@ static int __init
> >> > arch_timer_acpi_init(struct acpi_table_header *table)  }
> >> > TIMER_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT,
> >> > arch_timer_acpi_init);  #endif
> >> > +
> >> > +#if IS_ENABLED(CONFIG_PTP_1588_CLOCK_KVM)
> >> > +#include <linux/arm-smccc.h>
> >> > +int kvm_arch_ptp_get_crosststamp(unsigned long *cycle, struct
> >> timespec64 *ts,
> >> > +			      struct clocksource **cs)
> >> > +{
> >> > +	struct arm_smccc_res hvc_res;
> >> > +	ktime_t ktime;
> >> > +
> >> > +	/* Currently, linux guest will always use the virtual counter */
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FU
> >> NC_ID,
> >> > +			     ARM_PTP_VIRT_COUNTER, &hvc_res);
> >> > +	if ((long long)(hvc_res.a0) < 0)
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	ktime =3D (long long)hvc_res.a0;
> >> > +	*ts =3D ktime_to_timespec64(ktime);
> >> > +	*cycle =3D (long long)hvc_res.a1;
> >> > +	*cs =3D &clocksource_counter;
> >> > +
> >> > +	return 0;
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(kvm_arch_ptp_get_crosststamp);
> >> > +#endif
> >> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> >> > 942f72d8151d..127e96f14f89 100644
> >> > --- a/drivers/ptp/Kconfig
> >> > +++ b/drivers/ptp/Kconfig
> >> > @@ -106,7 +106,7 @@ config PTP_1588_CLOCK_PCH  config
> >> > PTP_1588_CLOCK_KVM
> >> >  	tristate "KVM virtual PTP clock"
> >> >  	depends on PTP_1588_CLOCK
> >> > -	depends on KVM_GUEST && X86
> >> > +	depends on KVM_GUEST && X86 || ARM64 && ARM_ARCH_TIMER
> >> &&
> >> > +ARM_PSCI_FW
> >> >  	default y
> >> >  	help
> >> >  	  This driver adds support for using kvm infrastructure as a PTP
> >> > diff --git a/drivers/ptp/ptp_kvm_arm64.c
> >> > b/drivers/ptp/ptp_kvm_arm64.c new file mode 100644 index
> >> > 000000000000..961abed93dfd
> >> > --- /dev/null
> >> > +++ b/drivers/ptp/ptp_kvm_arm64.c
> >> > @@ -0,0 +1,53 @@
> >> > +// SPDX-License-Identifier: GPL-2.0-only
> >> > +/*
> >> > + *  Virtual PTP 1588 clock for use with KVM guests
> >> > + *  Copyright (C) 2019 ARM Ltd.
> >> > + *  All Rights Reserved
> >> > + */
> >> > +
> >> > +#include <linux/kernel.h>
> >> > +#include <linux/err.h>
> >> > +#include <asm/hypervisor.h>
> >> > +#include <linux/module.h>
> >> > +#include <linux/psci.h>
> >> > +#include <linux/arm-smccc.h>
> >> > +#include <linux/timecounter.h>
> >> > +#include <linux/sched/clock.h>
> >> > +#include <asm/arch_timer.h>
> >> > +
> >> > +int kvm_arch_ptp_init(void)
> >> > +{
> >> > +	struct arm_smccc_res hvc_res;
> >> > +
> >> > +
> >> 	arm_smccc_1_1_invoke(ARM_SMCCC_VENDOR_HYP_KVM_FEATUR
> >> ES_FUNC_ID,
> >> > +			     &hvc_res);
> >> > +	if (!(hvc_res.a0 | BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
> >> > +		return -EOPNOTSUPP;
> >> > +
> >> > +	return 0;
> >>
> >> What happens if the
> >> ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID function isn't
> implemented
> >> (on an old kernel or a non-KVM hypervisor)? The expected behaviour is
> >> that a0 will contain SMCCC_RET_NOT_SUPPORTED, which is -1.
> >> The result is that this function always returns "supported". Not an
> >> acceptable behaviour.
> >>
> > Oh!  it's really a stupid mistake, should be "&" not "|".
>=20
> But even then. (-1 & whatever) is always true.

Yeah, what about checking if a0 is non-negative first? Like:
if (hvc_res.a0 < 0 || !(hvc_res.a0 & BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP)))
	return -EOPNOTSUPP;

Thanks
Jianyong=20
>=20
>          M.
> --
> Jazz is not dead. It just smells funny...
