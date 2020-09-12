Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B73267BEA
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgILTYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:24:31 -0400
Received: from mail-mw2nam10on2093.outbound.protection.outlook.com ([40.107.94.93]:6113
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725838AbgILTY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRj/KaupAl63RxcNqPIF9uP8eVs6ZghJJoh9eZzZk9x1Wa2F/jbCSE2xPUg+YDPcZXoa5cL8Dtp50IrDNfKLEXYvDWXnK/hlfMrNUg2WP1+iGorNUGmTnPe4LPSpbpCK1yR7ZWxz574HjRYJG8eEA0fqEk6XsU+cHv7c2+PRJXXHzjobiPEnEEVvV+aV7cY0U005St8Jow3h82WUj1qNq8E3iy96pK0oWxrXRleyEgxY31zNjsulWmB1aJcCDSA6ceZaoMoIMejdHidiISE21cfYjYcACJvUo6ywo6fxqYW0xm3WMz15e6sleTTOzt4E8LIxsPaisyLEOEAczZnwdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zI5jGMBJUPCyIFuuLi2bXcxFWj1PiGxLTrzNb+GCMTo=;
 b=insuBdrRatM6k7Y9WnzG8BA7buX8jPHlF6K3OqdM6/ViMwk/Ayk/2PyfWbzC0FKWuA8ZCioDkAPFinrJBTZiCp6o+1VrgwNrHbL6S/KFCO9O3ZirXJnLi9tbQEWXvLDEHHxd1g2JFcHqfUd/+4L42J4E3sMyaa9XcAGilVGZkcjH3Ne5AaG5hD40ldGzaAmCVm1jBsVeaZhZlll5JKKPOUoeCTjB730E2g4ffibNjwCfqo/3OnLV4WLdJH2VepO4CNtkQK4zLG7HiDHSBI8njxPO4Plelt9Ma3oEF9BZgrlZ4zlXd4GZEuFt2G8IkCppqYPJs3fxSsW4De08dtTv6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zI5jGMBJUPCyIFuuLi2bXcxFWj1PiGxLTrzNb+GCMTo=;
 b=PY29uvqYA6oFu2pLCQoVe1Nqj1eQ6yIRMioWWikSrnfRe27k5e+2aX44Pqnl7Nu7MjN8j9eXksvgV2YSJQjOLEiXCvmPpg3ql/pb4bhohv5vLfOdeLQ5Yo+0Zx6ymrgv96P0Z8RPqUeAC6uI10yCeiqnijNhcDkWOZT2lkq6ykk=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.4; Sat, 12 Sep
 2020 19:24:25 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:24:25 +0000
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
Subject: RE: [PATCH v3 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Thread-Topic: [PATCH v3 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Thread-Index: AQHWh3+Yd5lz0q58XUeUYnd7USgU86llZV5Q
Date:   Sat, 12 Sep 2020 19:24:24 +0000
Message-ID: <MW2PR2101MB10522FFF7FF1CEDF427317DBD7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-3-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-3-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:24:23Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f257b9b6-7104-4727-a293-c96d4adfcae9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f25f2d44-fe04-4a06-c510-08d8575175ae
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MWHPR2101MB073000A1D2757297E955157DD7250@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1htgIy9BH+cKSO+4/Nh7Qavh4Og4WkevaYGbSsNwr+2XqX5orK6hf5yFKcSItf1/gR8t0fV+D9oq8AQ79rzYriHoo/4jjXBa0lG+CIpaKPa7naRRox/0qYAXlpdKRmxWgjogzTEt/wN24FIB57giqMMHeTZqmlZhTFmu+EgWYWVVN077Vco5wZicA+VV/X1bm10V44VRXRNlp+6G4hX+hU14OPqhYzCHn4TpKKAfLEu1bCYulKYA/kOZuBz4SafwnPi+arzJq2ScbzW6XJ5PrrfOImTnyZ5U1vM96clhQUHdvW3tfPuTVbIFPtiw9vLOdAM21KjibSydnmFTxOypAG7bpX4Wj8Sm8IUkyvp+1r6i88KbLm2+k+DZxtZjBe8m
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(4744005)(52536014)(5660300002)(8936002)(2906002)(82950400001)(8676002)(33656002)(66556008)(66446008)(64756008)(66476007)(83380400001)(8990500004)(76116006)(71200400001)(66946007)(82960400001)(7696005)(26005)(7416002)(6506007)(316002)(110136005)(54906003)(478600001)(10290500003)(9686003)(55016002)(186003)(86362001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: H68iESA7MkLNigxVbIi67RKo95tNQcSvfve0VkxKzK5R69fWLes1gujae9OaBBtfdY5W//sZZ6H1IPe8L7E4URm0GGhzVagMjcz/mKJ79PwyYHh83SAFA7PzJrMatSFmQNZbKZocBX+D/uW9Iq1/ga8jWwQv4aS16txgoKTIoD7DBJDlwyZWMLvl7F+QgqA3WitYcJnOnEOxeJ4ibu6Px0fUqL2BbeNe+zYL+OrqszljRg3l/cbONX8lXWVJaSdBHXwal8ghRJxXpVwAczKkAXMFieNPmlrR7I4aUc0oqWRe6a4dIEcZSBWCH2z7MeO+u6BSUq2TMOfpj02ISQMosbHPuSwy80XBbTJamHN7CaHcSkBXjwnYSe8C6qnS8RThZuc5JOqGGwd7/JeRxGUONE+jG7SF5XyUdB0WHxzMt5CZbscQtkxQErix+aw15M+MgpIDDMGszaCRpWRKNCS7vPtAB7qVZgoqhJGUKI/fq1iSF42cGVvbNt340lpGTfLSAnv+qkzGInqhVa027ueq3oAvXXYrEcFSCwlJMl3PxoxWEnvQSN222BtevscmDuEPGJMN21cqVSDa0l7W6ZAc2U4/wnp9uMC0+ONvtHjdvh5ob993HK8rs1jnGZXd/0Sq12XQRudHIKnmT12ZgvhNTw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f25f2d44-fe04-4a06-c510-08d8575175ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:24:24.8382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VGBMOIo41bWDzNAJ22Rttqq/PKIN3r1cvD9KJ1IEjE9Jlp1DDvU61VDfqDiBA1mc68y7CrI7UO2SVBcjaWQDVGCpf2aOHXWpSbADTotOPYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> Pure function movement, no functional changes. The move is made, because
> in a later change, __vmbus_open() will rely on some static functions
> afterwards, so we separate the move and the modification of
> __vmbus_open() in two patches to make it easy to review.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> ---
>  drivers/hv/channel.c | 309 ++++++++++++++++++++++---------------------
>  1 file changed, 155 insertions(+), 154 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
