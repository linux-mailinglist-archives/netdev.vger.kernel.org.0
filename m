Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5559725E47C
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 02:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgIEAEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 20:04:11 -0400
Received: from mail-dm6nam12on2100.outbound.protection.outlook.com ([40.107.243.100]:38241
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgIEAEI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 20:04:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRJhuqviCu2R+f3fxqx4TxdSEtqUqOsMTRa3ll0pHs4U10tE1+yCIZHv/4TyFMxfCbJbViqWY9DbjSesH9/pFxrLdBlsz+mHZirVuz9i9Zrz9d6RlFniMbgaDjGmVO/EXR4aoeksXPYWm69zrcfEL6YftRh/2CHqDpXJ7VUu+ybQX/fzMM3PwcOfFYRiGkdMUa+pwnb4iUeIpL63BsD26w/jei/xI6dL0CL+FlptMQOq3FppHJkf5OC3ZVF2ZdGqhZyNj09N1Ok0/AOWI0RZqYIlbusNbgFwykizeqgzv039O7XmDbhw0GmLGSTS4pNQ9/nsukTn5ldjCS9nmipLcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/GTUNhF+3l7jIns/O6WJeB6YCP3DvPeDifTuLalKIo=;
 b=YxWnBd0JzLITGYsy9yItMIxAsFDOGPSs7fbeBWZaoWIOlpLljf6EumJosTpkKIto7ooiqfm9++8lWgbVsHKPDlQBXpoHRtGnl96hK/BWmqVqAfYHDk/O4EvZJ8KC14cevNCUfdhGcwiSn8HdPrShDtqFsTS5Y+Csx2kQLJafB239JuakGHXUQhYyPRgYzyJC8GGsSZcPJz+xFeozyWgQpVm21oxlkC5z+Hm4THnW9Q3X/ZtJw1ezRc79NWDZlYlywdF9O254aj91QV4825ypfXJVtW4+v+WDdSFtoqv5SiP/x5S/ne6kbSwSJ9MUlV0vn0rKf59KAqXu64MwO3Ntdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/GTUNhF+3l7jIns/O6WJeB6YCP3DvPeDifTuLalKIo=;
 b=gsRhDIrLWzxUMOJCy3QWHnVOcdN+O8uLzxyWNhjeGQ3CA0RWXostqi7kFw331Omd8zXWISdE1SbPuF/9SPsm21fPvAbCWiOTjQk7NXSaZ4xCdwSAYWAdf41G8pjJbhFeQcOQADeWGESbyfMWLYO9N6Y8UwJNfYRAUCGBCelesEM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB1833.namprd21.prod.outlook.com (2603:10b6:302:8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.9; Sat, 5 Sep
 2020 00:04:05 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.008; Sat, 5 Sep 2020
 00:04:05 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC v2 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Thread-Topic: [RFC v2 02/11] Drivers: hv: vmbus: Move __vmbus_open()
Thread-Index: AQHWgNVZDXo9hepsQkKExJs/TAQfsalZLXSg
Date:   Sat, 5 Sep 2020 00:04:05 +0000
Message-ID: <MW2PR2101MB1052EBD269206836141C9377D72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-3-boqun.feng@gmail.com>
In-Reply-To: <20200902030107.33380-3-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-05T00:04:04Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f076ea63-6053-43d1-af76-e2d7a80a4ff0;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f9b8269a-9711-4995-0b28-08d8512f346a
x-ms-traffictypediagnostic: MW2PR2101MB1833:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB1833B73ACD7BFF4631FDDA12D72A0@MW2PR2101MB1833.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QaptI0zyZzZIZB9o7O8jA1NYc9p8ZzuIaWXl9rf+wfQR+cfyDXa6SzVZtSvxzAKdWyDgxodZjTQ0G0J7xHDK0OuLiZMrSTyA65ddNyiGyoYa86HzgjNKd2MFSO4p/dkkxW7FJBZq3Yk7/GIlku3FVBwBl3PyGOGZKjhNtHOhCEi04froLSeF90WAsoFX6t9zM0Xz2mYMzbGOmzi084MT0qEozbeUJtQ43U+Qdy3DN07N5fO+B1HzyBoG5dqiWvJYuU3JSRyB5qBS77pSzbV4bRwOOyaVYcFL6iR0f811YT6ca+OqLA/u0onEiGfVAiLI5d+IqktiEGBAtzXcjW7mEuYLgrAGfa+iGiBLQD/6u9k71GW5YaVvPZP9HxBR6ZbL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(7696005)(478600001)(7416002)(55016002)(66556008)(8936002)(26005)(33656002)(66446008)(316002)(9686003)(8676002)(64756008)(66476007)(5660300002)(6506007)(86362001)(8990500004)(186003)(52536014)(76116006)(54906003)(66946007)(10290500003)(82950400001)(4326008)(82960400001)(2906002)(4744005)(110136005)(71200400001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MBAYL3jrYp72fV4m7AqiHR5qRhJvfLU01ytUtmiyCn5I4ZFPwSJ5ygqZhdlV8Eu+bh+QN/EFucMGUH9uZirdiXjYZkuhpwEirRCVoGpWGS6+ndvL1IQ55nFGgo4xKbxktzfcXX0ai2r30gteN7fCm9kzFH/3VbwdCZnVgS5p+f/XL+kBBVCjjCoPSK7ndPaavuDxmlDh01gg4nxB0zQvXQSBCgq+1XGju38Gi3Oj1YTVWtoifZbkyLcIZmB5LvHV1f02n4n/lHPOVHaPNsgD+yEzu6pUF3Aw0zx3YvYJNhSP9V4sGJVPyF78fwl7D5BwWKrxDut0LBS9JKInBtEXVxsV9VWf6MzaChNGygColTlcSt423XFaTHdkiRtUh8oY29/M9ZMZC9tKEpe5HQRc9OR1PeU1IeyCjrNYCKX515orCgMF1ElZUTizfTnBgzNnBBw969Ga9wXrQwEez6Dok6vJGU9iY5grqMRHauVD1Mk5AWN/zGxAxu08J7GpflXkxptwI6+NM1RYz51pGicF77y0aR1wCNy/ouCdLS1KSTJU/4baJRu5SZN61+gH4pX2aVexQb5XHExaNh5BPcajqynYBtLo1/k6a7tijhezOzGMnCIaNsNWMzV6u7/5+jPFGLnyFYrmHAO2DNIwVHTmCw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b8269a-9711-4995-0b28-08d8512f346a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 00:04:05.6493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xkb2IXo+wEzccPXi7XLHNOyo/AMAh8/FSQhdLIQ9y1Ls+e7vnDmNNWSlg/C3c/OGpXvfQ/rE/AzslvCSjAPT5G6/EHmWQ7uu/tlhjavL85o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1833
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:=
01 PM
>=20
> Pure function movement, no functional changes. The move is made, because
> in a later change, __vmbus_open() will rely on some static functions
> afterwards, so we sperate the move and the modification of

s/sperate/separate/

> __vmbus_open() in two patches to make it easy to review.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Wei Liu <wei.liu@kernel.org>
> ---
>  drivers/hv/channel.c | 309 ++++++++++++++++++++++---------------------
>  1 file changed, 155 insertions(+), 154 deletions(-)
>=20
