Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B8D267BEF
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgILT3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:29:48 -0400
Received: from mail-mw2nam10on2107.outbound.protection.outlook.com ([40.107.94.107]:11329
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILT3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:29:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1cSmukTtviB/T93zUYLY68BkTGvHXWTs3bcFi7W5G4x9mM7Ypt9qlUCDupOda8HXiX3I8FMFUdW0U8hLz8TkAzzNuW3/OxPMDTQO3b5geQtdIeeVQlo912ZrgHXNacJW8Qqyez5FPciNdH+EhpAtmf9XbEHiRLxLWYhUQI/uWy6zQLu35p/UihgIoaILng2C6Lm/um7lip86HI2KODjl9begU9hT/fQW9CrJSzvzPkPGfj0pFzgTLDgKkrHpAaOef6BiITT1P9DOiL8HmoeQ/7dWEBgrgATwbiMlU3at8GqXvz2lT8gqs4IQ4pg1NBeKi4d7iqMoIxmRAK00zSRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKutL2onx8TcGHn3TUHi/F3V/8Ptnk8QQ6t4vBViDWk=;
 b=ECQ7LX3mYpJKiAkajalL7T7U861Jk5017UHEqEWZ0sfNAsl59U5bcEk+kc2RfsrEudgDbi7zz6hQg0JhsA536uHMcCv9H2PAlloWYwcVOu8nuVdeAdqP3STOuSree3cgNpVVBzDEqzLahBbxjIGvzsHXhz7cDixMqo3m6sWltFey0eC3IXjozURGIOIGG+PlYa7k36+dKjsJNe81lz1SmH4vX9Ueity5Sm5IjWWJ7FWz0bFeqfIrlMNGLu9gTf/vbqxr1I6kt0FSKgBnj/NTbxiZ0e0Ab8XnOaEv+iuHa7FU3s42EgBN2PaFyBqro8GMmuapuCAaY26o5WugJSp2Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKutL2onx8TcGHn3TUHi/F3V/8Ptnk8QQ6t4vBViDWk=;
 b=V7c3kD9alBfsrd7PS5IKr9jj1Ry9LJPi4wpAX/xVo4JXlCuiTvOh+LFxCOkD3oxC5bk9tjqqVTWm6gfGp6lACHJ+5TwGF3wgkA7MDDyql31E3G9c5IaL05ZbpjhR6t6RRzzsxRPNZ7o/t3mFvAj4WbvDoyspZaqEnfcvNuBWXdA=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4; Sat, 12 Sep
 2020 19:29:38 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:29:38 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Topic: [PATCH v3 03/11] Drivers: hv: vmbus: Introduce types of GPADL
Thread-Index: AQHWh3+bVYFQjSf480qysGt45XsU96llZatQ
Date:   Sat, 12 Sep 2020 19:29:38 +0000
Message-ID: <MW2PR2101MB105260FBC823B8B9012D5500D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-4-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-4-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:29:36Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ddd11ce9-c164-49eb-8973-33f74d668f6b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d715cb9e-710f-443a-695f-08d85752307f
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB07309E34579D38A6EC5F366DD7250@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WKZ/JmuvLkPO2mrH5hltA+sC2I7v1Jv2rw13Uy7XRsVyE2eFF5SaSByw7HzAkrZxnfziwXzotgH5EYE33Eh5YLcm9qgW8QWanonFUbozBAtaox1l0eTUUQ8KWFlcFjp3wAjY8gg+qC5CMoAvyh7Xn/YVc4zDYn6o30RUCJsa8tlYzWesUdZeoTj1jJfg0bS7Ck+ugr+LurNEgsR9E19BZfBMMR1rYJb5ESRc3WMAVRD/Qw0ghVogTySPRa8Pll+fdAtIv+NR8VEAdtlq1GJsw206w71vgHnm6Qv3ISpgoBqOQH6bip+CgNWHuJnEx3w1uH3S9erAvPD6yWCXiXfwyU/miCDuXn46rHNmsgtAZ1jD+C43ZA0p7rdkp8dDtxLb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(54906003)(316002)(110136005)(478600001)(10290500003)(26005)(7696005)(7416002)(6506007)(186003)(86362001)(4326008)(55016002)(9686003)(82960400001)(2906002)(82950400001)(52536014)(5660300002)(8936002)(64756008)(66476007)(83380400001)(8990500004)(76116006)(71200400001)(66946007)(33656002)(66446008)(8676002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Gjsl18eeETxme4FAsjrLjYaeNGxOmVU2w8/h9dCVHlqTrc2lDYYUgQSD2Kpf1n+cjbmYddEWqHl3UQT3CXk8KUhvyVgQGjjDh7MDHkJ/8VzltqG+rD649bq7bTKUdAWc1svTvCXrxWTy1+mvRWlcN9JwtCvnaYw7oruIGJttaYz7aHWI4B3C3+gtSHmnySUcDGktuppEymv80O6XKXGnc4BEQaL3o/guWX0Hd9H3qAtrXtv21sK8OU5yTZ4fJrNSA3A5qtkwPdVTjDqte3pR1xvxVrFwX3ciPrUwM5i+DdX6xpiMqQBfGMsGxz0rdvJBNCgdc7VM5TLKZGLF93VD/Frnpw/hMiXp3VU4ABsQGVPlF1nECU5SHGC2BaqHscWpekXZbjrY+N97QsHEL/1CGDn0PP5h+vBAbRbKn04KeyrWuTuS+/GFK3jmoLAPjTToSgyY40nM1v/0/BgmKO03QgH8YA1tadyb0/eP0W+AbEm90ve5YtmlZX2JjtnyD1nSwDzSANN7vkepstZ3zO+01zAocJzOiCtv7VhzAgEITVhjUgw8BzzA9EiTEadF8bzsVW73uNfoLGmmVPV+AHe2ZmynXHmCaB3sMfn+6/xlMTMo0vpktPOPpOxjj2z+WoiLs1RAOlQE9FFlUCAuZCWluw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d715cb9e-710f-443a-695f-08d85752307f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:29:38.2568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: br1phonELReR/QIT076WToeeXFUaEZN7p5HkPBmlGQrHW/idJhS/qnBnbpO1B7zQ4Q6Yw0mjGlAouPamQzTS4Pgd7neCLhBFz6KnJFaOU8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM

>=20
> This patch introduces two types of GPADL: HV_GPADL_{BUFFER, RING}. The
> types of GPADL are purely the concept in the guest, IOW the hypervisor
> treat them as the same.
>=20
> The reason of introducing the types for GPADL is to support guests whose
> page size is not 4k (the page size of Hyper-V hypervisor). In these
> guests, both the headers and the data parts of the ringbuffers need to
> be aligned to the PAGE_SIZE, because 1) some of the ringbuffers will be
> mapped into userspace and 2) we use "double mapping" mechanism to
> support fast wrap-around, and "double mapping" relies on ringbuffers
> being page-aligned. However, the Hyper-V hypervisor only uses 4k
> (HV_HYP_PAGE_SIZE) headers. Our solution to this is that we always make
> the headers of ringbuffers take one guest page and when GPADL is
> established between the guest and hypervisor, the only first 4k of
> header is used. To handle this special case, we need the types of GPADL
> to differ different guest memory usage for GPADL.
>=20
> Type enum is introduced along with several general interfaces to
> describe the differences between normal buffer GPADL and ringbuffer
> GPADL.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/hv/channel.c   | 160 +++++++++++++++++++++++++++++++++++------
>  include/linux/hyperv.h |  44 +++++++++++-
>  2 files changed, 183 insertions(+), 21 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
