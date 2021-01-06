Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 247112EBB15
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 09:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbhAFIaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 03:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFIai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 03:30:38 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on0609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E25C06134C;
        Wed,  6 Jan 2021 00:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psXdjHB/DZDTqtEI6AFEhmzvZUMftX7ar2OCCxKHNMw=;
 b=79SnQhnMcEquypku/ZvoX18NKk5VTBF4ukJiM2YUf8GJPejqnULuY/9rkCDj7WrJZ0mlG//5rphMA/9ScAkHVMykNyupU6he+e3GWykDXeqnPeKnmro+YWINuAGDqGWXUyUHwnvW0b1IKhhLTlsuvHSrEOOFhov3on9ZHskvPiw=
Received: from AM6PR0202CA0047.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::24) by VE1PR08MB5021.eurprd08.prod.outlook.com
 (2603:10a6:803:108::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 08:29:34 +0000
Received: from VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:20b:3a:cafe::1d) by AM6PR0202CA0047.outlook.office365.com
 (2603:10a6:20b:3a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend
 Transport; Wed, 6 Jan 2021 08:29:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT039.mail.protection.outlook.com (10.152.19.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 08:29:33 +0000
Received: ("Tessian outbound eeda57fffe7b:v71"); Wed, 06 Jan 2021 08:29:33 +0000
X-CR-MTA-TID: 64aa7808
Received: from dfb496bc38f0.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 33E96408-893A-47C5-B127-F33A9762CAF7.1;
        Wed, 06 Jan 2021 08:29:28 +0000
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id dfb496bc38f0.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 06 Jan 2021 08:29:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHUMqnelxZm4sTCWLMiYnOV+3RpE2ZF1LZIVSAamGFdEOiQygcoD/qu1+X7qFQnjHMfRbqVcFbOIQDWinAO6mzrP8xYWhIanC1VPKVi/WufxvgNG+9FYhqhSD/5fO1gDjxdocFN+CayZuiL9L0LB1wDPKCcdv/8WA3xROslAC8dOdkCyUW4KjTwIyC5B07UoDN2lVQs8FS3fx95rgIW8popmPJSDFCijtbPsIBWf3P7QTvvABKKRanKW726vN07HN+ZaszxqqXQ9kKC5VTIGTp6viOMcbBed9okmftIx4BhwM3peb8/Lhxgtttd1eAAs3DyL7lveCyJn2uC2YMkcsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psXdjHB/DZDTqtEI6AFEhmzvZUMftX7ar2OCCxKHNMw=;
 b=ZUkCYtt5rDMZWzFHgzCMTJ+97HlX6uHn4qHyT8yE0LhoBgQTrqrFzAfUpzwti2sMMPh2Y4uEihDxGM1kaE3sEV/Cwgs7rG0NmxYoqXkl2fXt8Z/VjqgWBUebV/HB7LW5gmJzCIF9xIJx2ocGTHEzxEHDAQuzAR5gtNoqbEojX908ZrCPmoMviyPAmhaGtGIx0ningJYKv6iiIcHuGXfLGydTwPNR1dWIDQLesm9fJ646FhkaU02p2pZ+lrRK7GuvV09BTCU5OGy30kvJpOmmIg95HtoX/zqpw4CIXoSv9OUZvreawmwbZmmU7vfWm+nIqnyG7HsZzQRPMWV+K0JvSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psXdjHB/DZDTqtEI6AFEhmzvZUMftX7ar2OCCxKHNMw=;
 b=79SnQhnMcEquypku/ZvoX18NKk5VTBF4ukJiM2YUf8GJPejqnULuY/9rkCDj7WrJZ0mlG//5rphMA/9ScAkHVMykNyupU6he+e3GWykDXeqnPeKnmro+YWINuAGDqGWXUyUHwnvW0b1IKhhLTlsuvHSrEOOFhov3on9ZHskvPiw=
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com (2603:10a6:802:a9::18)
 by VI1PR08MB3645.eurprd08.prod.outlook.com (2603:10a6:803:84::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.19; Wed, 6 Jan
 2021 08:29:25 +0000
Received: from VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8]) by VE1PR08MB4766.eurprd08.prod.outlook.com
 ([fe80::9cb0:dfc6:9464:a3d8%2]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 08:29:25 +0000
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
        Andre Przywara <Andre.Przywara@arm.com>,
        Steven Price <Steven.Price@arm.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Steve Capper <Steve.Capper@arm.com>,
        Justin He <Justin.He@arm.com>, nd <nd@arm.com>
Subject: RE: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
Thread-Index: AQHWzfH314IeOXkaQU2t29Ihl+nLg6oab/hQ
Date:   Wed, 6 Jan 2021 08:29:25 +0000
Message-ID: <VE1PR08MB4766B2024A5ADA9D6AE9F4E9F4D00@VE1PR08MB4766.eurprd08.prod.outlook.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
In-Reply-To: <20201209060932.212364-1-jianyong.wu@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 9C14E3ADFB61D14F869E89FCF4950781.0
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8399b127-4413-4bcb-cca6-08d8b21d3236
x-ms-traffictypediagnostic: VI1PR08MB3645:|VE1PR08MB5021:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <VE1PR08MB5021B16F3D6292A163D7B01BF4D00@VE1PR08MB5021.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:6108;OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: T8telqQDbZ0RvphIgWiCN8Wp/tjYFRptVxBEGOGWZQ+TyXWtJ4AaD+Adk6DXO9eAfJ/A/aH3lVw4/KvasP7nKreC04Q5EL/+ehOzuw14TGhO9RKImoGJqqAXEEXJLKemacDjj3mx3gXFhurv+ssYvq9u2HcvU4lrflU3S9hXSBscBExitjPSkIeZhQoa6G17Hn5/73Zm6ieE3b3qG6dP/Xi4VAhHUScErpXdT2D5Q7T+MmolHRp+uRfJtX8R/tMPb9xCdx9JXsdsEHUhYplSQy+WHtVZAeFaNH0jC7Te6sbwPlyoeIPhMbXfl0Tso9IDGWhr/g4H7rh2CiFrM/XE2K0FCz1nVvPFwOJc01FEoJ1ZhDvHnjX0XvTrVxDl6kIV6nXTtQv8G7p5hEyW0zi1sGv+YUEuWRzceXyYxwCeriRAPfdu0PK+vHpKY3CnToPKJkVRd+F+RQRd2Laona1KVwNxXv7crqEP8HAcMGaxTRbNJGfbRexuG9KxEFt/ZmlI
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4766.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(26005)(5660300002)(186003)(2906002)(66946007)(66556008)(71200400001)(64756008)(921005)(83380400001)(4326008)(966005)(52536014)(478600001)(66476007)(6636002)(7416002)(33656002)(9686003)(8676002)(76116006)(66446008)(316002)(7696005)(86362001)(6506007)(8936002)(53546011)(55016002)(110136005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wD2KmWNFiQlpqgdr6+iA00MDO/OsPS0rIJJUtWcCrrlRB+PLZsT40GMBsKWx?=
 =?us-ascii?Q?jmm46GnplZquZRngAm6eXf5pzlOefJEiSfxM5iM9VOVEy9uNCahDHjVR2xqn?=
 =?us-ascii?Q?3mmuWwPtRK0HPs3KOGeRAjuROipIhlG0ygtXHFz7lZYrq9wuhcVE0xYpb9Li?=
 =?us-ascii?Q?qBILyPNRAxxcbm0VKYlEf93gdtiUfiOAdX+stkhMKv7aTMTpeweKNRRMyH0x?=
 =?us-ascii?Q?JZ1UjKjjVvSmaY7/yk2jy0F1W16RHO13xlDR6lYKQw3LKT/eph0uqciiehK0?=
 =?us-ascii?Q?KUtVHrq+zFh3q/PvgRZwkwjlYWL9YMKRLrewLYjuJMg0en7FHKGqsH9GVVmv?=
 =?us-ascii?Q?OHuPsnKOjh8n8D2M7Yw32xv3yjCMRqNUQtZHqCWfWJuEDLh2Ja8LT18eO+hR?=
 =?us-ascii?Q?dQuZXuJsHUev6bDYKH6NYmyi1CPUtEvgmEAJq77AklXvhqCqD5arzP0CV3O6?=
 =?us-ascii?Q?3jSw7RbdBJSi41/oqv+RRgRCm4Uupod95Mo1c+gchKODdZDuWz6RIDxXIpz+?=
 =?us-ascii?Q?U81XvDgGB+oVH/NWuixGMoh9RB0BM56+4naU67zY9rqx8WTNuUHKM0PlkiaI?=
 =?us-ascii?Q?2Eo0CpPO/oRpd/WmVpKn0xBHWGVzyey7OIRPm8pRmQFau4uecPPSRV8/lBz1?=
 =?us-ascii?Q?1ioqMF89OwmqGsA8HOURKORolzix6h2QQXR0whqen4BVj5BSRndCZ4HenDNu?=
 =?us-ascii?Q?xU3t+4878PuVPmr53qbNkfCBz4EwvPfpN6ZmGjhs4zwn3qupbd1nPbUHaBaa?=
 =?us-ascii?Q?JftrtUWiYuJRmnAZdBO8D6F6gZ7ZAZ5JMR5jdZf2La2veHV2r+5zsfTdKcib?=
 =?us-ascii?Q?Sb3qjRD6ahUAv00k0J9l1Na4ChcwhBGAd9hJ7jAf22ItDW91eUDPUdA35a1t?=
 =?us-ascii?Q?ph/vrvjU2qEdO+8SGBsuH1mQBPtC/6mpUngl4Pkm8qf1jRanhRpTYbnyzn45?=
 =?us-ascii?Q?JRz3p7lqC0tSmIr8Vd8q4FwtV+waBtk3xZ4P5dk3058=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3645
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 6c9036fc-5621-44f0-5873-08d8b21d2d45
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: STz6cCxehLz81uzhuJklYaTyHS0cL2brSjMbsy+OpC15xdIAGNe7tfhtnLzNZGUdVsdXiDLnPkxijt3V1cXeP+jJWQI4MLYsBypRQzyVUJDX/5/w0KOEXTrFkPIwllctZWUreXySoh/MMPA/Ztbe+H1prWQ6hoG5rZQbRrx2kzBtnBcd1HaovO2OEk+bvWOOTDwzRLooevHVF1a5Ss3Ac3m+t8leSao+H9tDxiynHrHhINrSNT1fQS7W43caoSMLeMhhCrCuUSZui+CHb7teUB2HwBEG12i0Fwq2fyj/Hb5nSvifKMR/FVxE1gE9cCs6QbrdGXzV8Tw5HvvLaUnUdkYkQYIweVcfxzXgSSte7Lzwh/epFW1cNYNTu43re/hZTfBbpag7CxIq1OTAzS6bx9kIF1OtBg0FjdfB3zlD1vINOIKkRLS9g2xBiZDRS8oIQIon3XBGB0Tz5F517bpX9Re2mkftZgzSMLnx3mt5sxhRuN7Luahb2h5nrrW+Vl7jPSQCJg1PKV5Lc6QmpTRU1H7ey5R3mpHv2QBbQT3jKTno019nRAA7eRp3QM6MkESSieMBvHcWE2Ws5DjRfjutVQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(33656002)(450100002)(316002)(34070700002)(70586007)(8676002)(2906002)(7696005)(921005)(478600001)(8936002)(6636002)(54906003)(966005)(83380400001)(110136005)(86362001)(47076005)(55016002)(356005)(82310400003)(52536014)(186003)(4326008)(26005)(82740400003)(336012)(6506007)(70206006)(81166007)(53546011)(9686003)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 08:29:33.6634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8399b127-4413-4bcb-cca6-08d8b21d3236
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT039.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5021
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ping...
Any comments? Thanks!

> -----Original Message-----
> From: Jianyong Wu <jianyong.wu@arm.com>
> Sent: Wednesday, December 9, 2020 2:09 PM
> To: netdev@vger.kernel.org; yangbo.lu@nxp.com; john.stultz@linaro.org;
> tglx@linutronix.de; pbonzini@redhat.com; sean.j.christopherson@intel.com;
> maz@kernel.org; richardcochran@gmail.com; Mark Rutland
> <Mark.Rutland@arm.com>; will@kernel.org; Suzuki Poulose
> <Suzuki.Poulose@arm.com>; Andre Przywara <Andre.Przywara@arm.com>;
> Steven Price <Steven.Price@arm.com>
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org; Steve Capper
> <Steve.Capper@arm.com>; Justin He <Justin.He@arm.com>; Jianyong Wu
> <Jianyong.Wu@arm.com>; nd <nd@arm.com>
> Subject: [PATCH v16 0/9] Enable ptp_kvm for arm/arm64
>=20
> Currently, we offen use ntp (sync time with remote network clock) to sync
> time in VM. But the precision of ntp is subject to network delay so it's =
difficult
> to sync time in a high precision.
>=20
> kvm virtual ptp clock (ptp_kvm) offers another way to sync time in VM, as
> the remote clock locates in the host instead of remote network clock.
> It targets to sync time between guest and host in virtualization environm=
ent
> and in this way, we can keep the time of all the VMs running in the same =
host
> in sync. In general, the delay of communication between host and guest is
> quiet small, so ptp_kvm can offer time sync precision up to in order of
> nanosecond. Please keep in mind that ptp_kvm just limits itself to be a
> channel which transmit the remote clock from host to guest and leaves the
> time sync jobs to an application, eg. chrony, in usersapce in VM.
>=20
> How ptp_kvm works:
> After ptp_kvm initialized, there will be a new device node under /dev cal=
led
> ptp%d. A guest userspace service, like chrony, can use this device to get=
 host
> walltime, sometimes also counter cycle, which depends on the service it c=
alls.
> Then this guest userspace service can use those data to do the time sync =
for
> guest.
> here is a rough sketch to show how kvm ptp clock works.
>=20
> |----------------------------|              |--------------------------|
> |       guest userspace      |              |          host            |
> |ioctl -> /dev/ptp%d         |              |                          |
> |       ^   |                |              |                          |
> |----------------------------|              |                          |
> |       |   | guest kernel   |              |                          |
> |       |   V      (get host walltime/counter cycle)                   |
> |      ptp_kvm -> hypercall - - - - - - - - - - ->hypercall service    |
> |                         <- - - - - - - - - - - -                     |
> |----------------------------|              |--------------------------|
>=20
> 1. time sync service in guest userspace call ptp device through /dev/ptp%=
d.
> 2. ptp_kvm module in guest receives this request then invoke hypercall to
> route into host kernel to request host walltime/counter cycle.
> 3. ptp_kvm hypercall service in host response to the request and send dat=
a
> back.
> 4. ptp (not ptp_kvm) in guest copy the data to userspace.
>=20
> This ptp_kvm implementation focuses itself to step 2 and 3 and step 2 wor=
ks
> in guest comparing step 3 works in host kernel.
>=20
> change log:
>=20
> from v15 to v16:
>         (1) remove ARM_PTP_NONE_COUNTER suggested by Marc.
>         (2) add more detail for ptp_kvm doc.
>         (3) fix ci issues reported by test robot.
>=20
> from v14 to v15:
>         (1) enable ptp_kvm on arm32 guest, also ptp_kvm has been tested o=
n
> both arm64 and arm32 guest running on arm64 kvm host.
>         (2) move arch-agnostic part of ptp_kvm.rst into timekeeping.rst.
>         (3) rename KVM_CAP_ARM_PTP_KVM to KVM_CAP_PTP_KVM as it
> should be arch agnostic.
>         (4) add description for KVM_CAP_PTP_KVM in
> Documentation/virt/kvm/api.rst.
>         (5) adjust dependency in Kconfig for ptp_kvm.
>         (6) refine multi-arch process in driver/ptp/Makefile.
>         (7) fix make pdfdocs htmldocs issue for ptp_kvm doc.
>         (8) address other issues from comments in v14.
>         (9) fold hypercall service of ptp_kvm as a function.
>         (10) rebase to 5.10-rc3.
>=20
> from v13 to v14
>         (1) rebase code on 5.9-rc3.
>         (2) add a document to introduce implementation of PTP_KVM on arm6=
4.
>         (3) fix comments issue in hypercall.c.
>         (4) export arm_smccc_1_1_get_conduit using EXPORT_SYMBOL_GPL.
>         (5) fix make issue on x86 reported by kernel test robot.
>=20
> from v12 to v13:
>         (1) rebase code on 5.8-rc1.
>         (2) this patch set base on 2 patches of 1/8 and 2/8 from Will Dec=
on.
>         (3) remove the change to ptp device code of extend getcrosststamp=
.
>         (4) remove the mechanism of letting user choose the counter type =
in
> ptp_kvm for arm64.
>         (5) add virtual counter option in ptp_kvm service to let user cho=
ose the
> specific counter explicitly.
>=20
> from v11 to v12:
>         (1) rebase code on 5.7-rc6 and rebase 2 patches from Will Decon
> including 1/11 and 2/11. as these patches introduce discover mechanism of
> vendor smccc service.
>         (2) rebase ptp_kvm hypercall service from standard smccc to vendo=
r
> smccc and add ptp_kvm to vendor smccc service discover mechanism.
>         (3) add detail of why we need ptp_kvm and how ptp_kvm works in co=
ver
> letter.
>=20
> from v10 to v11:
>         (1) rebase code on 5.7-rc2.
>         (2) remove support for arm32, as kvm support for arm32 will be re=
moved
> [1]
>         (3) add error report in ptp_kvm initialization.
>=20
> from v9 to v10:
>         (1) change code base to v5.5.
>         (2) enable ptp_kvm both for arm32 and arm64.
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
le patch.
>         (2) update commit message for patch 4/8.
>         (3) refine patch 7/8 and patch 8/8 to make them more independent.
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
> [1] https://patchwork.kernel.org/cover/11373351/
>=20
>=20
> Jianyong Wu (6):
>   ptp: Reorganize ptp_kvm module to make it arch-independent.
>   clocksource: Add clocksource id for arm arch counter
>   arm64/kvm: Add hypercall service for kvm ptp.
>   ptp: arm/arm64: Enable ptp_kvm for arm/arm64
>   doc: add ptp_kvm introduction for arm64 support
>   arm64: Add kvm capability check extension for ptp_kvm
>=20
> Thomas Gleixner (1):
>   time: Add mechanism to recognize clocksource in time_get_snapshot
>=20
> Will Deacon (2):
>   arm64: Probe for the presence of KVM hypervisor
>   arm/arm64: KVM: Advertise KVM UID to guests via SMCCC
>=20
>  Documentation/virt/kvm/api.rst              |  9 ++
>  Documentation/virt/kvm/arm/index.rst        |  1 +
>  Documentation/virt/kvm/arm/ptp_kvm.rst      | 31 +++++++
>  Documentation/virt/kvm/timekeeping.rst      | 35 ++++++++
>  arch/arm/kernel/setup.c                     |  5 ++
>  arch/arm64/kernel/setup.c                   |  1 +
>  arch/arm64/kvm/arm.c                        |  1 +
>  arch/arm64/kvm/hypercalls.c                 | 86 ++++++++++++++++--
>  drivers/clocksource/arm_arch_timer.c        | 31 +++++++
>  drivers/firmware/smccc/smccc.c              | 37 ++++++++
>  drivers/ptp/Kconfig                         |  2 +-
>  drivers/ptp/Makefile                        |  2 +
>  drivers/ptp/ptp_kvm_arm.c                   | 45 ++++++++++
>  drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} | 84 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 96 +++++++++++++++++++++
>  include/linux/arm-smccc.h                   | 59 +++++++++++++
>  include/linux/clocksource.h                 |  6 ++
>  include/linux/clocksource_ids.h             | 12 +++
>  include/linux/ptp_kvm.h                     | 16 ++++
>  include/linux/timekeeping.h                 | 12 +--
>  include/uapi/linux/kvm.h                    |  1 +
>  kernel/time/clocksource.c                   |  2 +
>  kernel/time/timekeeping.c                   |  1 +
>  23 files changed, 498 insertions(+), 77 deletions(-)  create mode 100644
> Documentation/virt/kvm/arm/ptp_kvm.rst
>  create mode 100644 drivers/ptp/ptp_kvm_arm.c  rename
> drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} (60%)  create mode 100644
> drivers/ptp/ptp_kvm_x86.c  create mode 100644
> include/linux/clocksource_ids.h  create mode 100644
> include/linux/ptp_kvm.h
>=20
> --
> 2.17.1

