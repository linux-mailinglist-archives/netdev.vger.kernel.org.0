Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA132C0240
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgKWJ0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:26:49 -0500
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:1441
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726282AbgKWJ0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 04:26:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTz+1a6s/e90J343AonkG4KJE0FDlfAPZfLQtV5LW04=;
 b=Vg2wIyoOy0b3zM70N6J2o0lI8Pnv2B3WEmQ0qmnbj5oR7dbAba+5MB8mCdSyLtSk59RGwlS/iiVU6wu07TyzAKr3nd7uSG6hp3oRKrdTWZcMoyc6+g11qx0iyP4INJ8YTXQNNkEUXyJ0+XR+ZZc2PRTowCUNlzwBSs5UP4YoJoI=
Received: from MR2P264CA0161.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1::24) by
 HE1PR08MB2908.eurprd08.prod.outlook.com (2603:10a6:7:30::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.30; Mon, 23 Nov 2020 09:26:44 +0000
Received: from VE1EUR03FT033.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:501:1:cafe::ae) by MR2P264CA0161.outlook.office365.com
 (2603:10a6:501:1::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend
 Transport; Mon, 23 Nov 2020 09:26:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT033.mail.protection.outlook.com (10.152.18.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 09:26:43 +0000
Received: ("Tessian outbound 797fb8e1da56:v71"); Mon, 23 Nov 2020 09:26:43 +0000
X-CR-MTA-TID: 64aa7808
Received: from c4ee8c32cc97.3
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 49BF53C8-B853-476E-ABEB-1683AD6F1ACA.1;
        Mon, 23 Nov 2020 09:26:38 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id c4ee8c32cc97.3
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 23 Nov 2020 09:26:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJ701NGMGLjh4mhYY8mOm9A9+0hdbExkiafWj9DBZFeWLc7cZoROo8x8OmMFdrjQ2uoF/Wpsv8nZfOBGZDMQvGEilYbHK1K88+Dh9CbayKCcs/yHAmZFKLTv5k7vTNQG4r0PZ8ya3WYmSFQsMHQlBA6t9qMWSwv/b8rbJ8xqJwv71pwsjab9iFH5TrHgUUL2pPuF4xJ9CJ0KjJUiTHIj74FvFW4mW6mhJq+bwAfdklW4irQTXhs+kM9A1zbU8wB0I1Fttw3rvDA6zWXNz6TnSjn35toLR/97zA0tiqMW7XiIlMQLE1Cc/Tp86zIkFblcdpDBM16ox4ago9hsX9aqsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTz+1a6s/e90J343AonkG4KJE0FDlfAPZfLQtV5LW04=;
 b=m8Y3YDPX6PYuvNSxrqYi3p5DF8i35Ais3GSUvmV9W6MfOX+ULuWPo7fX1DJnF5POquiX6sXsUVwtEDVta96wKvLPWkQl5h0XpVZ7ake2Ld1VIc5CuXX8lX2ZgApPdj8hxuimPZqSarGX9VIUgeh/EC/lnY46Y/AjQ5Vp10TaRkxrkYA76DKvb22nYX/35OlGWEiq0+33n+a0v1f8fZcZh3n0Lpt1gVYitOLIuGZljQU5f9mvLcYeFm8UA2aU0F71L6oZYcnZgXc0SlFa+7gadMRiW7OPd1yG1cv5Pq2m946cGxLUvbyfvndbJZExs8O6vhQ/UlLSSCb3mdFkresPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTz+1a6s/e90J343AonkG4KJE0FDlfAPZfLQtV5LW04=;
 b=Vg2wIyoOy0b3zM70N6J2o0lI8Pnv2B3WEmQ0qmnbj5oR7dbAba+5MB8mCdSyLtSk59RGwlS/iiVU6wu07TyzAKr3nd7uSG6hp3oRKrdTWZcMoyc6+g11qx0iyP4INJ8YTXQNNkEUXyJ0+XR+ZZc2PRTowCUNlzwBSs5UP4YoJoI=
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com (2603:10a6:3:e0::7)
 by HE1PR0801MB1836.eurprd08.prod.outlook.com (2603:10a6:3:89::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Mon, 23 Nov
 2020 09:26:33 +0000
Received: from HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200]) by HE1PR0802MB2555.eurprd08.prod.outlook.com
 ([fe80::9930:b22f:9e8c:8200%5]) with mapi id 15.20.3589.021; Mon, 23 Nov 2020
 09:26:33 +0000
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
Subject: RE: [PATCH v15 0/9] Enable ptp_kvm for arm/arm64
Thread-Topic: [PATCH v15 0/9] Enable ptp_kvm for arm/arm64
Thread-Index: AQHWt/MggsqIPXcVPk2Ug53+hY3m/anVhVng
Date:   Mon, 23 Nov 2020 09:26:32 +0000
Message-ID: <HE1PR0802MB25556FD524E2803934E666ABF4FC0@HE1PR0802MB2555.eurprd08.prod.outlook.com>
References: <20201111062211.33144-1-jianyong.wu@arm.com>
In-Reply-To: <20201111062211.33144-1-jianyong.wu@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 2B38CC08EC572549A54A8729E82D682A.0
x-checkrecipientchecked: true
Authentication-Results-Original: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.113]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93086216-87cc-4fa0-14fb-08d88f91e472
x-ms-traffictypediagnostic: HE1PR0801MB1836:|HE1PR08MB2908:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <HE1PR08MB29088E0712A0ED1C971DE737F4FC0@HE1PR08MB2908.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4714;OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: aL5bbEIQDNM4PrYc/uPK2BZ2Y1yOx9lJkuwnuA+r05IeHUT0GqCNQd9VusHEUr2KwE8yKr77tk/XQY0FsqmAMZ8uoKO8ByEMZgX9ZFb2gkPPdumJGwOMi/ZEQzVCmTXIsVNppGlJ1zlJyWiDMSIIm3VRyHyzg4HPd1AYaLJcssT3r+fomqM9pL38EjYggR1gmnl4Z7iSN9NXdboJ2NU5UOYm1RcF1kqQUuoROPKS0ToGzdPTLoYL1EJX/ld2v61Jd5BBAE9yvdxctL8kMvzeJ4e96rk1sDLbxQp8cvxkGhoryxrJmQ25zGQ0tha2nUgFXjxnxBPYmD6acunKi4tIKrk1PXDZ8AMz4sfkutAss6YlpE5WFl7WP/ZPtRz18y7o0d0st0KqXgqqycjwPuNHBJ+q9U1u+Owxy+RzeKdgdHweALXKOQt1H68cqaUqY+AI
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0802MB2555.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39850400004)(346002)(376002)(5660300002)(66946007)(66446008)(71200400001)(66556008)(316002)(2906002)(64756008)(478600001)(9686003)(7696005)(83380400001)(52536014)(966005)(76116006)(6636002)(8676002)(33656002)(8936002)(7416002)(54906003)(110136005)(86362001)(66476007)(4326008)(6506007)(55016002)(186003)(921005)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dME6QSvgS/DE2o+MRnubxSI1jFlt20we3JmcY43+xXZSaUeekvJ4yMR8oP8x0KZWdxKlhUJeLMte3vwQuBemQx4Yd3ffyBvAtyoIcES+sSs6kL8dtxyeMfJdyoHAAXCf/Eoj9np/EFiegzHWK0Mrf4JOrrC6WHSt26/8twSq6PRnW4gOoZME/bZkaS3+N3xeOUb9A/Fqy6Nt6aZrLxV6bCmxEmnO8EKocZJYk9O9I5oQnLVkiVophEj45zJG6j+//vX21BrIB2fj8+UKuzRZhnq/0YNpMzBoMQr+Sm4bmEtTSXfMY694hxwrqy1PAan81qGHTIopXqYPIYj/pzQ6EpqAUiFBwiXjY6ccG92VsZ8u7hQ7IZ3AmMLB9OyAje2/UX+nJUBIiYWz6RZKReW9wpu85mWCHPcWusogJZFK7O+ZuCNcHQmHmysGQX7m1a8Zg7sOJ81WYcW3O4F73i9sJYe1f0CPtyHOaNKgz3Uv68ZdQyJJTmKyPgVCp5zObJbnICHJmWSrSp0NA9b2USbgMzjtO389M1mRMBS6kUhfkhFyEGo88ihVXuBodiRWd61MiU7zVpM3wH4vXi6kU3N5lgqYJc83jy+LYzIUfDhFkwmd5awquXjy3pWMcNmLo8A/1agf9aT9gF2aRKkEKVyBzVK3161MOwoXwEVTVzCFcfEhly037Fa0QVu8QOeppCYQVTfAETt3W67Yjqwrs8MnGd6O1KqxRl5EKSWpii5hTovTdwOVkD0u6einjpZr2NGgMrVsB2hehYqI8KNtL8uez2NbBqQuUJLIsEHv37Ct6cerLUG+iDyBrdbRmBn7YDOG/NZqulGBJk0HU+RpcvBEzeQpkjik/lnPHOwd7dMuAyE3fNcaAanfDoJ7xIIcP+biGEPp+0EOhpvsKhre22tNow==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1836
Original-Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT033.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 499cea40-9413-4642-ff13-08d88f91de32
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClkocCChYr0oKUxrdukqUQLJscbOJT0Hb/eRRLd1Bcbc52LCuNOmQn1Iz2db2EQrntVQSNcPK/7b+rAtL993e0HGWaNAV1L4GXdoT1ZQZzB7YqlBsPA83OxUp0tascOSk7NIV9r1sVejjDUGDun5hBhF3/fHyK5uIM4Vfn+rSyL+7Kpym1dz7+OBOWYanevwp5AadGLTNhmSJ8g3oj92mJtIFeE/ORw/sx0hV9X8Yx4blZx2y4PIaRZhvgH4s+NRGc5j/bTsolwTH/hNoGTEd2d6CS1qryYxeEScFFb5yH2CIqbcaGIsvClh5ZVAPTY3tB9TWAxEEE9pdcT4xPn/hVFSaNQHGElddvtN66dlPpAfeiJXav3+kZVC01FU1IcpIw8A7f0hOsSj9jcayPHwPc0lmNj0yfjpgPJfsYGClZuH9cG6NpPqq6o3WMz6aVx1ZyOc6jOdz7tLpT2l9OeLFPjXoSnNK8mYfevCN7hKGXga+SNlL9NBlc72Etg58g5O
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39850400004)(46966005)(6636002)(86362001)(82740400003)(8676002)(52536014)(55016002)(5660300002)(2906002)(33656002)(186003)(921005)(82310400003)(8936002)(26005)(83380400001)(9686003)(478600001)(966005)(336012)(450100002)(53546011)(70206006)(4326008)(6506007)(70586007)(356005)(7696005)(81166007)(47076004)(316002)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 09:26:43.5927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93086216-87cc-4fa0-14fb-08d88f91e472
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT033.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR08MB2908
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Ping ...
Any comments?

> -----Original Message-----
> From: Jianyong Wu <jianyong.wu@arm.com>
> Sent: Wednesday, November 11, 2020 2:22 PM
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
> Subject: [PATCH v15 0/9] Enable ptp_kvm for arm/arm64
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
> 2. ptp_kvm module in guest recive this request then invoke hypercall to
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
> from v14 to v15
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
>  Documentation/virt/kvm/arm/ptp_kvm.rst      | 29 +++++++
>  Documentation/virt/kvm/timekeeping.rst      | 35 ++++++++
>  arch/arm/kernel/setup.c                     |  1 +
>  arch/arm64/kernel/setup.c                   |  1 +
>  arch/arm64/kvm/arm.c                        |  1 +
>  arch/arm64/kvm/hypercalls.c                 | 88 +++++++++++++++++--
>  drivers/clocksource/arm_arch_timer.c        | 30 +++++++
>  drivers/firmware/smccc/smccc.c              | 37 ++++++++
>  drivers/ptp/Kconfig                         |  2 +-
>  drivers/ptp/Makefile                        |  2 +
>  drivers/ptp/ptp_kvm.h                       | 11 +++
>  drivers/ptp/ptp_kvm_arm.c                   | 44 ++++++++++
>  drivers/ptp/{ptp_kvm.c =3D> ptp_kvm_common.c} | 85 +++++-------------
>  drivers/ptp/ptp_kvm_x86.c                   | 95 +++++++++++++++++++++
>  include/linux/arm-smccc.h                   | 60 +++++++++++++
>  include/linux/clocksource.h                 |  6 ++
>  include/linux/clocksource_ids.h             | 12 +++
>  include/linux/timekeeping.h                 | 12 +--
>  include/uapi/linux/kvm.h                    |  1 +
>  kernel/time/clocksource.c                   |  2 +
>  kernel/time/timekeeping.c                   |  1 +
>  23 files changed, 488 insertions(+), 77 deletions(-)  create mode 100644
> Documentation/virt/kvm/arm/ptp_kvm.rst
>  create mode 100644 drivers/ptp/ptp_kvm.h  create mode 100644
> drivers/ptp/ptp_kvm_arm.c  rename drivers/ptp/{ptp_kvm.c =3D>
> ptp_kvm_common.c} (60%)  create mode 100644
> drivers/ptp/ptp_kvm_x86.c  create mode 100644
> include/linux/clocksource_ids.h
>=20
> --
> 2.17.1

