Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453B119541B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgC0JfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:35:23 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:30135
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726096AbgC0JfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 05:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8M492VrCoGMeefeuMgWVUgCtktC2Jao0n/MDXLnMh8=;
 b=66CJzEQ+1MHFgBVFhdFr7ASUOhLENxOgdKn1Jl0i5UvFIsRwBmcdJO9QA3XgI87acliX5Fcq9F2qENBJqJcKAt+3Wsv5z2X2qKUsKVt+zr21lIwuwFentDevBFJlq4Nf8PCVtJL0W8XcVZFEHNkadnGHz8rZ7jD5CZFh9R6DJqM=
Received: from AM4PR0701CA0005.eurprd07.prod.outlook.com
 (2603:10a6:200:42::15) by AM0PR08MB3266.eurprd08.prod.outlook.com
 (2603:10a6:208:66::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.19; Fri, 27 Mar
 2020 09:35:16 +0000
Received: from AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:200:42:cafe::1f) by AM4PR0701CA0005.outlook.office365.com
 (2603:10a6:200:42::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend
 Transport; Fri, 27 Mar 2020 09:35:16 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT031.mail.protection.outlook.com (10.152.16.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.17 via Frontend Transport; Fri, 27 Mar 2020 09:35:16 +0000
Received: ("Tessian outbound 19f8d550f75c:v48"); Fri, 27 Mar 2020 09:35:16 +0000
X-CR-MTA-TID: 64aa7808
Received: from dddd9e598800.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 21698F75-D28B-43D5-9DBD-6D1902EAB60A.1;
        Fri, 27 Mar 2020 09:35:11 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id dddd9e598800.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 27 Mar 2020 09:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WR7bZxVg91YMyO0NjLVaVHumi5kD1MOXWBCr0UjjmfUP0mumrzKEoPNFNazrsITOKMYqE78TKMtbp324D0GSRaT+ATTw8xCEbByAVda8jQjoN2wzMgaMTA1v+1Q565OUqp+Anoq475Fpxikp9+WZZS1+TfhHpSnugb27sf9E0HP/uxBn2i9irCRcrlt4HhDh1W9gtOw8N9mypR3eQcjLVLnQjH1THcO7g8K560+0jsBqeGUXU1g8BjGfLDf+r3TPd/foGJZdS+NYKQQGU05a6LAp5UojL6PF3jBdUbjTtDbmkW98qr9/m8VdisjZmRnjJfYRP185uC1Imo5mS2R7oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8M492VrCoGMeefeuMgWVUgCtktC2Jao0n/MDXLnMh8=;
 b=MoiNDjnvcwANG3tzcCJWBeURlQBvp0YPq6vgIYaI41rd1XErfyETPMik1msOX0hhBir5AKOQPyz+YSyhdGs/ZNZy8TbH55Iec+73z1ER5R8V7i/WSanjepyxEbuMi7voPX8q6+5C+AnOvtAxkHmr0sCINCGGRUDx2kuEFc5BOnYlQSeSZVAG23dpIo40Bty+tTOTkYQILxBPfxcg2c9HLPbjBi93g4adzu3QqOyeKKPyJHbE9rseuVOz/6ChxKgLOrLbIUQBF81/Tke9DLo/YzFRYnlGlzv6qlu1BUSTZQ38HpunvM6TunNZuQ6cJasqB0hxOeLRx40+KHQTqLc8KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8M492VrCoGMeefeuMgWVUgCtktC2Jao0n/MDXLnMh8=;
 b=66CJzEQ+1MHFgBVFhdFr7ASUOhLENxOgdKn1Jl0i5UvFIsRwBmcdJO9QA3XgI87acliX5Fcq9F2qENBJqJcKAt+3Wsv5z2X2qKUsKVt+zr21lIwuwFentDevBFJlq4Nf8PCVtJL0W8XcVZFEHNkadnGHz8rZ7jD5CZFh9R6DJqM=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1945.eurprd08.prod.outlook.com (10.168.94.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Fri, 27 Mar 2020 09:35:07 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::d8e4:e9e7:56cf:378d]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::d8e4:e9e7:56cf:378d%5]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 09:35:07 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        Suzuki Poulose <Suzuki.Poulose@arm.com>,
        Steven Price <Steven.Price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Kaly Xin <Kaly.Xin@arm.com>, Justin He <Justin.He@arm.com>,
        nd <nd@arm.com>
Subject: RE: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
Thread-Topic: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
Thread-Index: AQHV3+8FAZbnQUsGIUmOWBKSwbVS66gess5QgD27D8A=
Date:   Fri, 27 Mar 2020 09:35:07 +0000
Message-ID: <HE1PR0801MB167659B867202B6D4B1695BFF4CC0@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
 <HE1PR0801MB1676DA6F1AE78462CB524D6AF4160@HE1PR0801MB1676.eurprd08.prod.outlook.com>
In-Reply-To: <HE1PR0801MB1676DA6F1AE78462CB524D6AF4160@HE1PR0801MB1676.eurprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: a73d9b45-bda9-495d-abbc-c063834e7d3a.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [113.29.88.7]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd50611b-a17a-4e33-7ae3-08d7d2322859
x-ms-traffictypediagnostic: HE1PR0801MB1945:|HE1PR0801MB1945:|AM0PR08MB3266:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB32668331FF92DE4A203CF47AF4CC0@AM0PR08MB3266.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:1107;OLM:1107;
x-forefront-prvs: 0355F3A3AE
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(81156014)(81166006)(2906002)(316002)(478600001)(186003)(66946007)(9686003)(66476007)(8676002)(33656002)(66556008)(6636002)(66446008)(55016002)(64756008)(4326008)(86362001)(5660300002)(7416002)(8936002)(6506007)(54906003)(71200400001)(55236004)(53546011)(52536014)(76116006)(7696005)(26005)(110136005)(921003)(1121003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: tPsiMxyYWB7S2+ogXRUSwBZqYMDvnx8mPJXY4crMK73uUH8DZzWleWHaUyUU5gblnVNKSrSISpImPFrgsB+Wwu37PR52BygGfkjhO7wmNOLBCMveQjwhkQqy0ZJQuqr1MHQOD9Qj+DhxZDv5FKGy+8+0aej36p6fO7z39WIfB3GKVzyg9e5uwYxkY8lO8cTY7FvmjUkZsaHOtzULQU+iTqUfZbZXJu7hXtK+55kotm5rqV3J/ecIoKJjEm72/CgQYqp5AO5DdNat/8gm+JRyLfsUvHcEH+b+wBxFazXd7MYTI7xBZzVnRklXzbjrcESRqpG3Vdt68sz9iT1igq4rzz65KIW8N9RS3h0QPKWC8f2/3IM73fC5xVClkeOib71Me9I0oGj+Vp2mFYTCFkHw7GNJMWi+woVoPf952skzz1s+DlwPfXo0M+kMifqEPAH2andBEAJNZ0Z3oyi+5kBYJLOUbwMy7lNbzF/ky/s7ZrPld2bM9TBRoayUgMjwNwhO
x-ms-exchange-antispam-messagedata: zLKZiHQnG8hqvBBp+Gg5anUs9FfSDEXz9FpaIxFIWOsWLfZAYkrGyDPlEX0F4vF4aYBRaV4pNHA1QA5Guey3wvJGK6ZzjHnsK5uNAGM4YGU0EVcPzZ/60BtoH4a6cEZtSfG1Bh/rauZTCI34Q+PCFg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1945
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT031.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966005)(186003)(70586007)(6636002)(7696005)(33656002)(356004)(316002)(9686003)(450100002)(70206006)(82740400003)(52536014)(86362001)(4326008)(336012)(2906002)(110136005)(26005)(36906005)(8936002)(55016002)(26826003)(5660300002)(478600001)(8676002)(47076004)(6506007)(54906003)(81166006)(81156014)(53546011)(921003)(1121003);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: 929f2637-3955-465c-24ae-08d7d232233d
X-Forefront-PRVS: 0355F3A3AE
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UNrUZfiuCFLALkufVmTvhcO9e1ZIkVGFjUAGvhJYdQ2pq97OvdR4aKhwXh5PPbWVGr1R8KUy8CCDeCVgcJbVdHDkYnwl5Oi79g0i+7uHAEegLqf4ae4Eg//KvRtkG+7pWIo8ewPTbRUFr2mTYl/XVNUZ7UInaY8lDapNkv7SR6tUWCkSb3LoLkDZFIgou3Kjshfzw8N+Slgk/a0OpV5o7emoa3rnDmb0wvUsdTtZlwLybcv0Q4WE4qxCuqrAJ4OTz5hRwtfmDrVV661zRxo9QuOJFZG5cyI6IKYc2xSpiMT3yzxveqm7RTTDbIZ3HyFpaidh44DvKw6s/5BwGVxpt6ltbUL6Uo4QlE4/hIYp4LNk41GeCjc5H3aaATfWkR7dWii4ILLH6j9RnlChRZwuzfXZXnwFTVFN1NSaMRsOmyL2j0fxbAl9U+dcuGUQ0VXgWMJLQtWjurNH/tuaDiov8Nns79c2ox8mrImQfcmjeU60lsxgKUZd1Jq6u8xqdZJXP3FLFWyYdYfKrDVCezIFQaf+0C32sD+WaWj3Z3SCsTRwQqinXSQeaTHU4qiNKZ9f
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 09:35:16.2234
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd50611b-a17a-4e33-7ae3-08d7d2322859
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3266
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi ,

Ping ...
Is there any comments.=20
Need some comments to move forward.

Thanks
Jianyong=20

> -----Original Message-----
> From: Jianyong Wu <Jianyong.Wu@arm.com>
> Sent: Monday, February 17, 2020 10:29 AM
> To: Jianyong Wu <Jianyong.Wu@arm.com>; netdev@vger.kernel.org;
> yangbo.lu@nxp.com; john.stultz@linaro.org; tglx@linutronix.de;
> pbonzini@redhat.com; sean.j.christopherson@intel.com; maz@kernel.org;
> richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; nd <nd@arm.com>
> Subject: RE: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
>=20
> Hi,
> As this version change a lot, expect more comments. thanks.
>=20
> Thanks
> Jianyong
> > -----Original Message-----
> > From: Jianyong Wu <jianyong.wu@arm.com>
> > Sent: Monday, February 10, 2020 4:49 PM
> > To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> > tglx@linutronix.de; pbonzini@redhat.com;
> > sean.j.christopherson@intel.com; maz@kernel.org;
> > richardcochran@gmail.com; Mark Rutland <Mark.Rutland@arm.com>;
> > will@kernel.org; Suzuki Poulose <Suzuki.Poulose@arm.com>; Steven Price
> > <Steven.Price@arm.com>
> > Cc: linux-kernel@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org;
> > kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> > <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> > <Justin.He@arm.com>; Jianyong Wu <Jianyong.Wu@arm.com>; nd
> > <nd@arm.com>
> > Subject: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
> >
> > kvm ptp targets to provide high precision time sync between guest and
> > host in virtualization environment. Here, we enable kvm ptp for arm64.
> >
> > change log:
> > from v10 to v9
> >         (1) change code base to v5.5.
> > 	(2) enable ptp_kvm both for arm32 and arm64.
> >         (3) let user choose which of virtual counter or physical
> > counter should return when using crosstimestamp mode of ptp_kvm for
> arm/arm64.
> >         (4) extend input argument for getcrosstimestamp API.
> >
> > from v8 to v9:
> >         (1) move ptp_kvm.h to driver/ptp/
> >         (2) replace license declaration of ptp_kvm.h the same with
> > other header files in the same directory.
> >
> > from v7 to v8:
> >         (1) separate adding clocksource id for arm_arch_counter as a
> > single patch.
> >         (2) update commit message for patch 4/8.
> >         (3) refine patch 7/8 and patch 8/8 to make them more independen=
t.
> >
> > from v6 to v7:
> >         (1) include the omitted clocksource_id.h in last version.
> >         (2) reorder the header file in patch.
> >         (3) refine some words in commit message to make it more imperso=
nal.
> >
> > from v5 to v6:
> >         (1) apply Mark's patch[4] to get SMCCC conduit.
> >         (2) add mechanism to recognize current clocksource by add
> > clocksouce_id value into struct clocksource instead of method in patch-=
v5.
> >         (3) rename kvm_arch_ptp_get_clock_fn into
> > kvm_arch_ptp_get_crosststamp.
> >
> > from v4 to v5:
> >         (1) remove hvc delay compensasion as it should leave to userspa=
ce.
> >         (2) check current clocksource in hvc call service.
> >         (3) expose current clocksource by adding it to system_time_snap=
shot.
> >         (4) add helper to check if clocksource is arm_arch_counter.
> >         (5) rename kvm_ptp.c to ptp_kvm_common.c
> >
> > from v3 to v4:
> >         (1) fix clocksource of ptp_kvm to arch_sys_counter.
> >         (2) move kvm_arch_ptp_get_clock_fn into arm_arch_timer.c
> >         (3) subtract cntvoff before return cycles from host.
> >         (4) use ktime_get_snapshot instead of getnstimeofday and
> > get_current_counterval to return time and counter value.
> >         (5) split ktime and counter into two 32-bit block respectively
> > to avoid Y2038-safe issue.
> >         (6) set time compensation to device time as half of the delay o=
f hvc call.
> >         (7) add ARM_ARCH_TIMER as dependency of ptp_kvm for arm64.
> >
> > from v2 to v3:
> >         (1) fix some issues in commit log.
> >         (2) add some receivers in send list.
> >
> > from v1 to v2:
> >         (1) move arch-specific code from arch/ to driver/ptp/
> >         (2) offer mechanism to inform userspace if ptp_kvm service is a=
vailable.
> >         (3) separate ptp_kvm code for arm64 into hypervisor part and gu=
est
> part.
> >         (4) add API to expose monotonic clock and counter value.
> >         (5) refine code: remove no necessary part and reconsitution.
> >
> >
> > Jianyong Wu (8):
> >   psci: export psci conduit get helper.
> >   ptp: Reorganize ptp_kvm modules to make it arch-independent.
> >   clocksource: Add clocksource id for arm arch counter
> >   psci: Add hypercall service for ptp_kvm.
> >   ptp: arm/arm64: Enable ptp_kvm for arm/arm64
> >   ptp: extend input argument for getcrosstimestamp API
> >   arm/arm64: add mechanism to let user choose which counter to return
> >   arm/arm64: Add kvm capability check extension for ptp_kvm
> >
> > Thomas Gleixner (1):
> >   time: Add mechanism to recognize clocksource in time_get_snapshot
> >
> >  drivers/clocksource/arm_arch_timer.c        | 33 ++++++++
> >  drivers/firmware/psci/psci.c                |  1 +
> >  drivers/net/ethernet/intel/e1000e/ptp.c     |  3 +-
> >  drivers/ptp/Kconfig                         |  2 +-
> >  drivers/ptp/Makefile                        |  5 ++
> >  drivers/ptp/ptp_chardev.c                   |  8 +-
> >  drivers/ptp/ptp_kvm.h                       | 11 +++
> >  drivers/ptp/ptp_kvm_arm.c                   | 53 +++++++++++++
> >  drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} | 83 ++++++-------------=
-
> >  drivers/ptp/ptp_kvm_x86.c                   | 87 +++++++++++++++++++++
> >  include/linux/arm-smccc.h                   | 21 +++++
> >  include/linux/clocksource.h                 |  6 ++
> >  include/linux/clocksource_ids.h             | 13 +++
> >  include/linux/ptp_clock_kernel.h            |  3 +-
> >  include/linux/timekeeping.h                 | 12 +--
> >  include/uapi/linux/kvm.h                    |  1 +
> >  include/uapi/linux/ptp_clock.h              |  4 +-
> >  kernel/time/clocksource.c                   |  3 +
> >  kernel/time/timekeeping.c                   |  1 +
> >  virt/kvm/arm/arm.c                          |  1 +
> >  virt/kvm/arm/hypercalls.c                   | 44 ++++++++++-
> >  21 files changed, 323 insertions(+), 72 deletions(-)  create mode
> > 100644 drivers/ptp/ptp_kvm.h  create mode 100644
> > drivers/ptp/ptp_kvm_arm.c rename drivers/ptp/{ptp_kvm.c =3D>
> > ptp_kvm_common.c} (60%)  create mode
> > 100644 drivers/ptp/ptp_kvm_x86.c  create mode 100644
> > include/linux/clocksource_ids.h
> >
> > --
> > 2.17.1

