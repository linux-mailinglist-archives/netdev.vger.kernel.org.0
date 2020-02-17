Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A60160828
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 03:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgBQC3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 21:29:14 -0500
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:12839
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgBQC3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 21:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8OewObzDkXXbOxORF7lr1T6I9p1+yMmZUxuYrqDDsM=;
 b=XkfxCCSim5N5quvKm8ZWfIvowyOfpuxpXnrTlBkcNkBvg/VHavH1kX2JAXfgTyw9MvHdFMS8hLcMtECMpo9qfbLqOhEGFfmYe6DqVexinj1+hWcsQ999VfhWQxtZ6yaucE2S/JY+8eBFHWTrzezX55K9ibr8/vD9ITVO+4EiFtA=
Received: from DB6PR0802CA0041.eurprd08.prod.outlook.com (2603:10a6:4:a3::27)
 by DB6PR0801MB2056.eurprd08.prod.outlook.com (2603:10a6:4:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.25; Mon, 17 Feb
 2020 02:29:09 +0000
Received: from AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2a01:111:f400:7e08::207) by DB6PR0802CA0041.outlook.office365.com
 (2603:10a6:4:a3::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend
 Transport; Mon, 17 Feb 2020 02:29:09 +0000
Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT048.mail.protection.outlook.com (10.152.17.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.18 via Frontend Transport; Mon, 17 Feb 2020 02:29:08 +0000
Received: ("Tessian outbound d1ceabc7047e:v42"); Mon, 17 Feb 2020 02:29:08 +0000
X-CR-MTA-TID: 64aa7808
Received: from 8e582aa9a450.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 38F0185B-F5E3-49F4-BACA-A5D6FAA844CA.1;
        Mon, 17 Feb 2020 02:29:03 +0000
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 8e582aa9a450.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 17 Feb 2020 02:29:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDgHXxoI5DjiKs7ngYSlVfg5F9BwvwTTovqW000ty4cEyomGtzDzS3gxpWqnoA3dCB4t5oJ7q1ybj+HhKI8YUCa63FxXI0phJ6k/7j50/3WvkpfVvhYOh4yY+72QogiLB178lFvswSknCMIV+VeObEAATBXQfLHO1kP3bANFOU0P6JDuxq7XYM2MsL92pgsL7R/dGs4SWq+34FYacp0lpegcTz6H05VTYV6jLe5BFn6tv7UoBdmVSzd/6w/MQGpBwvVjxoZBMiCBx+AX4xX7N59fRhijP8n46HS0Q4HaMsPI8Q7cOV1tsQRlEuq73PjDEzM+0ElmGK+dxvHiUIgiiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8OewObzDkXXbOxORF7lr1T6I9p1+yMmZUxuYrqDDsM=;
 b=XpO2Bt53638eCXteR+hiNH5VQHdWUj+IEjmg4mPK23CUECxceUu3HdTEoHYd+CUzzY6bONg3BW9LCwrUEIohSugsXWB8N1hmlx0RmzOxkDro58n1+LTIRhQXq0nUXY+bjX0pzJneboAoN4+gZqTA0fPmBzamF+LUit1FOgq0qKfJsB8th64r0/iJ7B2mhzJ73nwuMf3ygNKhg+KaQM0JoLRnyAcTGWbcs/MA/nqhCnY3h+PpAm0XwoWa+9IC9s/l7GMGO3Hr9QC3WdNmrghlJqX+s9lC8LwLY1x2bk6wTP7LYiSGXdJe0ErooxUuo4nrvgxpBfP1GUZD3V2vfyOeVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8OewObzDkXXbOxORF7lr1T6I9p1+yMmZUxuYrqDDsM=;
 b=XkfxCCSim5N5quvKm8ZWfIvowyOfpuxpXnrTlBkcNkBvg/VHavH1kX2JAXfgTyw9MvHdFMS8hLcMtECMpo9qfbLqOhEGFfmYe6DqVexinj1+hWcsQ999VfhWQxtZ6yaucE2S/JY+8eBFHWTrzezX55K9ibr8/vD9ITVO+4EiFtA=
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com (10.168.146.150) by
 HE1PR0801MB1835.eurprd08.prod.outlook.com (10.168.144.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Mon, 17 Feb 2020 02:28:58 +0000
Received: from HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f]) by HE1PR0801MB1676.eurprd08.prod.outlook.com
 ([fe80::49c0:e8df:b9be:724f%8]) with mapi id 15.20.2729.031; Mon, 17 Feb 2020
 02:28:57 +0000
From:   Jianyong Wu <Jianyong.Wu@arm.com>
To:     Jianyong Wu <Jianyong.Wu@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHV3+8FAZbnQUsGIUmOWBKSwbVS66gess5Q
Date:   Mon, 17 Feb 2020 02:28:57 +0000
Message-ID: <HE1PR0801MB1676DA6F1AE78462CB524D6AF4160@HE1PR0801MB1676.eurprd08.prod.outlook.com>
References: <20200210084906.24870-1-jianyong.wu@arm.com>
In-Reply-To: <20200210084906.24870-1-jianyong.wu@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: ec7bac31-c6fe-4637-aa17-d6df6aed5047.1
x-checkrecipientchecked: true
Authentication-Results-Original: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
x-originating-ip: [2409:8a1e:685f:5fd0:b143:6b9a:d085:ace4]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5291875c-bff1-42ca-6056-08d7b3512adb
X-MS-TrafficTypeDiagnostic: HE1PR0801MB1835:|HE1PR0801MB1835:|DB6PR0801MB2056:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0801MB20568EF877FF99B7FFE0A8BDF4160@DB6PR0801MB2056.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:2449;OLM:2449;
x-forefront-prvs: 0316567485
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39850400004)(376002)(346002)(136003)(199004)(189003)(8676002)(33656002)(8936002)(54906003)(7416002)(110136005)(52536014)(4326008)(81156014)(316002)(53546011)(64756008)(66446008)(5660300002)(6506007)(66946007)(76116006)(66476007)(81166006)(66556008)(186003)(71200400001)(6636002)(9686003)(7696005)(55016002)(478600001)(2906002)(86362001)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0801MB1835;H:HE1PR0801MB1676.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: arm.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: JDg974XpJE9yNlTDmOhsIulNP5mW0DAusITkCP9OydVJul8h36/3boaw5y02MXJ0n3IDdhHLMrE+6791lsqPj1/Tx+YiJOyUCtovS9OvfAQzMQabLam+RlKQ9JvX7B8HifWEh4KsM0XOlzj1dMJAAkFB1JrR3krP8n7fOawxPuBSv4JEDk4+MESbWDcS7kroxsYah9xNCQ9MJh5nBBV+3zG9go4y1ubUhr/jx5tHNcNv7dvVfgNxsMrF7u7Y3hQwrTDgG2HwStA36vl0keYTN/4nqSPMPvUtb2PaAK6IXnhy5y8pZOfCuS9G21ul9P1JEVDP2BweCMGit7FNN7TX4dSxC2nnD9jr6Oookk6aDfqZ5MBJstpIwHcoCFqwxzOzdGwPua9zvwWKO2vmdpjUu1wszEvRMW2eCS2vn+ma9n26nLR7mNZcI7TA+bdXItMs/FajgGdQQEvf443Xy/UZRtMzBNLYIbqwFcatW/nMI8J3qKnnOXAQimp0u1MmEizw
x-ms-exchange-antispam-messagedata: nsB9hY4e85L4SN1Gjqbm/R3q6z3G0G2+Vdl18Fe1lS3ICV4q3kyZJh/FM13krTW00J7nHmmf8GxITnaRHXMjxXY4mEM6InlaGFlvfwGrBLb0G39dimwDybMhpVp8DGfxzdsX79zCPAh7vnkaqcdm2UWWhLM/dQ5Rs0boPsAaCLEeYibYd8BpazqIzcWkidNqD8Otl179MYkWI2fL6NcWpg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1835
Original-Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jianyong.Wu@arm.com; 
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;IPV:CAL;SCL:-1;CTRY:IE;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(136003)(376002)(189003)(199004)(70206006)(81166006)(81156014)(8676002)(110136005)(52536014)(54906003)(8936002)(36906005)(4326008)(86362001)(316002)(450100002)(6506007)(53546011)(336012)(186003)(26005)(33656002)(6636002)(356004)(9686003)(55016002)(5660300002)(478600001)(7696005)(70586007)(26826003)(2906002)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0801MB2056;H:64aa7808-outbound-1.mta.getcheckrecipient.com;FPR:;SPF:Pass;LANG:en;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;MX:1;A:1;
X-MS-Office365-Filtering-Correlation-Id-Prvs: be544065-7261-4a83-b978-08d7b3512457
X-Forefront-PRVS: 0316567485
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7IMRmRlXD1eG8VyW6/B6WNh16Gdq84Tsij+u/h7VSm045GZ+RKaK+qwHtbdhUrqetkEmBoT9uHu/XOifWS9MdPI8bcTvG9lvbkj0y1afWhGC8Eu23zo8i1/ij0jZhmzE5O+NArE9oyTvaIwRLuNBH3qN+4NHBMeHRRJKbh8rZiLWlOIfwovThhOkimayOol3m8cr62e0B2A4vK29/gteaXm9LslpUFKmrGhHugn/EVh17UcGZp4sDf6nnI4R2ZelPEExA7AM1bCrqMg31BAGtIcD6WVimR28p3dvcuaQdGo9XKB9oYmgbbu15iSkwHVfAWt2BLzBsVjrZu4EFUexgPZsZWvdUXucDu4erX2gKJX+cgtO75rq594qGOGHOEXLdpXGMblPe7TUpJJpc398PGHVqrvidzMBjdHo4mSC9YTr9NZko8cgYaPBkYTx4Biw9/GT4P/gJmx4k+CGSAX3c30xgvTH6KcU7/TQa9kb9vVVthvb03pFts/G9vKjJSK/
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2020 02:29:08.7306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5291875c-bff1-42ca-6056-08d7b3512adb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB2056
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
As this version change a lot, expect more comments. thanks.

Thanks
Jianyong=20
> -----Original Message-----
> From: Jianyong Wu <jianyong.wu@arm.com>
> Sent: Monday, February 10, 2020 4:49 PM
> To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Steven Price <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Kaly Xin <Kaly.Xin@arm.com>; Justin He
> <Justin.He@arm.com>; Jianyong Wu <Jianyong.Wu@arm.com>; nd
> <nd@arm.com>
> Subject: [RFC PATCH v10 0/9] Enable ptp_kvm for arm/arm64
>=20
> kvm ptp targets to provide high precision time sync between guest and hos=
t
> in virtualization environment. Here, we enable kvm ptp for arm64.
>=20
> change log:
> from v10 to v9
>         (1) change code base to v5.5.
> 	(2) enable ptp_kvm both for arm32 and arm64.
>         (3) let user choose which of virtual counter or physical counter =
should
> return when using crosstimestamp mode of ptp_kvm for arm/arm64.
>         (4) extend input argument for getcrosstimestamp API.
>=20
> from v8 to v9:
>         (1) move ptp_kvm.h to driver/ptp/
>         (2) replace license declaration of ptp_kvm.h the same with other =
header
> files in the same directory.
>=20
> from v7 to v8:
>         (1) separate adding clocksource id for arm_arch_counter as a sing=
le
> patch.
>         (2) update commit message for patch 4/8.
>         (3) refine patch 7/8 and patch 8/8 to make them more independent.
>=20
> from v6 to v7:
>         (1) include the omitted clocksource_id.h in last version.
>         (2) reorder the header file in patch.
>         (3) refine some words in commit message to make it more impersona=
l.
>=20
> from v5 to v6:
>         (1) apply Mark's patch[4] to get SMCCC conduit.
>         (2) add mechanism to recognize current clocksource by add
> clocksouce_id value into struct clocksource instead of method in patch-v5=
.
>         (3) rename kvm_arch_ptp_get_clock_fn into
> kvm_arch_ptp_get_crosststamp.
>=20
> from v4 to v5:
>         (1) remove hvc delay compensasion as it should leave to userspace=
.
>         (2) check current clocksource in hvc call service.
>         (3) expose current clocksource by adding it to system_time_snapsh=
ot.
>         (4) add helper to check if clocksource is arm_arch_counter.
>         (5) rename kvm_ptp.c to ptp_kvm_common.c
>=20
> from v3 to v4:
>         (1) fix clocksource of ptp_kvm to arch_sys_counter.
>         (2) move kvm_arch_ptp_get_clock_fn into arm_arch_timer.c
>         (3) subtract cntvoff before return cycles from host.
>         (4) use ktime_get_snapshot instead of getnstimeofday and
> get_current_counterval to return time and counter value.
>         (5) split ktime and counter into two 32-bit block respectively to=
 avoid
> Y2038-safe issue.
>         (6) set time compensation to device time as half of the delay of =
hvc call.
>         (7) add ARM_ARCH_TIMER as dependency of ptp_kvm for arm64.
>=20
> from v2 to v3:
>         (1) fix some issues in commit log.
>         (2) add some receivers in send list.
>=20
> from v1 to v2:
>         (1) move arch-specific code from arch/ to driver/ptp/
>         (2) offer mechanism to inform userspace if ptp_kvm service is ava=
ilable.
>         (3) separate ptp_kvm code for arm64 into hypervisor part and gues=
t part.
>         (4) add API to expose monotonic clock and counter value.
>         (5) refine code: remove no necessary part and reconsitution.
>=20
>=20
> Jianyong Wu (8):
>   psci: export psci conduit get helper.
>   ptp: Reorganize ptp_kvm modules to make it arch-independent.
>   clocksource: Add clocksource id for arm arch counter
>   psci: Add hypercall service for ptp_kvm.
>   ptp: arm/arm64: Enable ptp_kvm for arm/arm64
>   ptp: extend input argument for getcrosstimestamp API
>   arm/arm64: add mechanism to let user choose which counter to return
>   arm/arm64: Add kvm capability check extension for ptp_kvm
>=20
> Thomas Gleixner (1):
>   time: Add mechanism to recognize clocksource in time_get_snapshot
>=20
>  drivers/clocksource/arm_arch_timer.c        | 33 ++++++++
>  drivers/firmware/psci/psci.c                |  1 +
>  drivers/net/ethernet/intel/e1000e/ptp.c     |  3 +-
>  drivers/ptp/Kconfig                         |  2 +-
>  drivers/ptp/Makefile                        |  5 ++
>  drivers/ptp/ptp_chardev.c                   |  8 +-
>  drivers/ptp/ptp_kvm.h                       | 11 +++
>  drivers/ptp/ptp_kvm_arm.c                   | 53 +++++++++++++
>  drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} | 83 ++++++--------------
>  drivers/ptp/ptp_kvm_x86.c                   | 87 +++++++++++++++++++++
>  include/linux/arm-smccc.h                   | 21 +++++
>  include/linux/clocksource.h                 |  6 ++
>  include/linux/clocksource_ids.h             | 13 +++
>  include/linux/ptp_clock_kernel.h            |  3 +-
>  include/linux/timekeeping.h                 | 12 +--
>  include/uapi/linux/kvm.h                    |  1 +
>  include/uapi/linux/ptp_clock.h              |  4 +-
>  kernel/time/clocksource.c                   |  3 +
>  kernel/time/timekeeping.c                   |  1 +
>  virt/kvm/arm/arm.c                          |  1 +
>  virt/kvm/arm/hypercalls.c                   | 44 ++++++++++-
>  21 files changed, 323 insertions(+), 72 deletions(-)  create mode 100644
> drivers/ptp/ptp_kvm.h  create mode 100644 drivers/ptp/ptp_kvm_arm.c
> rename drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} (60%)  create mode
> 100644 drivers/ptp/ptp_kvm_x86.c  create mode 100644
> include/linux/clocksource_ids.h
>=20
> --
> 2.17.1

