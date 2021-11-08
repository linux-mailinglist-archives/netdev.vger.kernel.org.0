Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E35449D1D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 21:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhKHUeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 15:34:46 -0500
Received: from mail-cusazon11021014.outbound.protection.outlook.com ([52.101.62.14]:37591
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229832AbhKHUep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 15:34:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYfMBwm/M9JlDmXrNHXRdUNLKMBtL12XdKjxtWbysi7RfaF9jpIGHLKRHNrek1lhAY5TajMGUe6ttdq9583Qoz2bqyo5jnqzXLFTBRUmcd7yRPi60bkxaAmUB6yVlKOOn7IJSe9fXdS/lmOuogbivGOBGE7iiIhJ+S3Q/QLocS2Sq+1gqGljZ9VDO8g8y+hrkR4MUu48xRlNbOPY6bs/l14IXs4ovHy8n3eahNM191y3bDSQ5tP27iBGiugsdiyGfVvKNBKMgR0gmUX7PP5BSsAFmEiq3HFu4vh73VfFouw4TT7ocvgYvCrxFlI7AQSld02GcxpwY4WqWivISNF6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8yQP8SlP4wEsyodN2IBg8jjvh7br9X/JhqAas/sbknM=;
 b=iVAn+wCE5XeRTb8ojFq1cVRVrXQOBdej95larPSkOEzFdkGVI0ECLh1KZvpkycmu79V6sbKLNjNOh9IBLJCQpanXdRpICcCADxo1TyvGCDm97Jz7gXoA+0g7P01uG9EhOLHlpqZ92mNGQqBzi0FIcW09oW3nvCHU7+RqFEnkq979yNpZb64Ahiz6w0PtRpsdWuZvUw0/Pue9QCy4C9PCyB29hEtAlmtAdI9R35gWLH9+nEC3cCQuYqz/AYM+99aMD81KeWnhiixeHIr9eu+C3yox21YBLUobn6fll04+PwQcRf0iv3HQijydbdbVgJvQBLXbCOlXOZjEOyxmZ2OsGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8yQP8SlP4wEsyodN2IBg8jjvh7br9X/JhqAas/sbknM=;
 b=Pi8+Wvwd3ztB8mEMiGB8/l/4Fs3M6S8W+RaBSOl/gz9OgA1VoJR9Coj6U3OMfuLyRTpE/xqOpM2y6m8+A+fO9ObzKK2wPXaiPYWpu03stWmz5BPIRIfiLu6xL/dqgO7oaF/AafgHgDND3UrlF87OuLkAj6u5T0u9g5Eh9cYVs+k=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1333.namprd21.prod.outlook.com (2603:10b6:a03:115::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.2; Mon, 8 Nov
 2021 20:31:57 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1%6]) with mapi id 15.20.4690.002; Mon, 8 Nov 2021
 20:31:57 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Colin Ian King <colin.i.king@googlemail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: mana: Fix spelling mistake "calledd" -> "called"
Thread-Topic: [PATCH] net: mana: Fix spelling mistake "calledd" -> "called"
Thread-Index: AQHX1N3JWXHPA/r+2EOYbwPQvYNA7Kv6FERg
Date:   Mon, 8 Nov 2021 20:31:56 +0000
Message-ID: <BYAPR21MB127056B1E0D886CDFA044B73BF919@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211108201817.43121-1-colin.i.king@gmail.com>
In-Reply-To: <20211108201817.43121-1-colin.i.king@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=77dd171c-b47a-42de-8ade-cbfcb8c1dd4e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-11-08T20:27:07Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd6fcb4c-f495-43a7-0d8d-08d9a2f6cf33
x-ms-traffictypediagnostic: BYAPR21MB1333:
x-microsoft-antispam-prvs: <BYAPR21MB13331468149C09EB80E73C21BF919@BYAPR21MB1333.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1I0p52WxVLUcnjwLYbZkHW30QMd7/n+CRayv+IKRONdcr/Wpr/XPUrMDlX7UpocHmAzYBXk94tRCIPVWLqUSICLs18UrJOo0gsFk+lL3f4tTreZD4tgbTqc1cd5OxeAKwMZOS1gPS1sD00SDhLs6X9R76r6Qn5hulfHy7k+XZep4TZnwwnF+RAsK9zOul/vdT4uV1Rq7sjcD+CeEEEFFsd5iLQ2hlp+Gpr0H5st+0LuS0vqpbOoQJrbmiMwCI30Fpd01j/hT5fzJQev7y/h9aB1QUqRrsG0oxECXAlJeMA0c1fF+JDM4MahyznAPQYXnjdQ5cjMAQ3DSnuD6sdVV74VIW/FT56k6V86YrYoe+qNXtK038sdrlr4MQhtLk/XAg4JiBCiz+0wdpuEgdA4W3WtQ2X+6H9B0ECI4LMZoMs2J0dwtlYmPPUv09VbPxCmBCPkVkbhP4Inhp60duR4AoqhIEhI56EqoZrzRgtDdwLvdOWsJ26ALZBuwTRXiZQNp0EGMSUi2lhUpXONERezwb5WEAxs1g0GSbEqnZtEBROvTlRXsDEuLGFGqXHPdhrRalTMIHv2eIU3ysjVmW/l89lFUPvRr86bJi0tK6ELKL+6ijqwsCRZfz8qiiKtHsyEJwmcOc8mURoPLBmbQnJNdQcgwKH+RTRUxU9kyEtmhDPLErYX+sh3Q9XeLFtpG6EmbXTmlx5WmcJ+U9YnTkkAzug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(558084003)(82950400001)(8936002)(5660300002)(83380400001)(66446008)(71200400001)(7696005)(38070700005)(64756008)(8990500004)(10290500003)(508600001)(4326008)(110136005)(54906003)(86362001)(9686003)(76116006)(55016002)(82960400001)(66476007)(26005)(66946007)(6506007)(38100700002)(316002)(33656002)(52536014)(66556008)(186003)(2906002)(8676002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GuIEBURXPo3zvxMGCRaiSP11rWy+9Gnwvk9UKewvNzTE+Ezai/RP2TFGWrNe?=
 =?us-ascii?Q?AyxflgZPM07w8/bVolO0IQmszuWhY2TO9xUXgUbUMcC+Jzv8pLpOU0JWhHY5?=
 =?us-ascii?Q?5CATeP7rE8fU6qMVoZsYc4KkSX/gRr6KN92w2jtwCGToec3JoTakfJtJLQUj?=
 =?us-ascii?Q?reLxaSN/Nqgn+blpl2A4FU1A0FIacbWF+y/Y1pO3ZEhEsTeLBwwhwP1Oorx+?=
 =?us-ascii?Q?sDtIjYKzDpcvUd5tgh3zERrx+6U/ZCHmlhv/fxwLyzspn/U6HWWr2nvFwByU?=
 =?us-ascii?Q?/+M8jjnGmKKSQKvldmpGf6ZzzoN9bSocXYNEcyqgKYZ+1/Ld8qb6dRl1l1Cg?=
 =?us-ascii?Q?tpSkkGbTlMCWCbV1pzBlAMEpZZYLIJ9XVl+l5dYk3Px3XLLbNzVETY/gepaN?=
 =?us-ascii?Q?NZILeFvAw0kIbQXuv0RgQesQ+H6qFp9t9X/FvqkW49twexBB0SMcmTwtrkfK?=
 =?us-ascii?Q?89gyYBiS91qU3rhRKxisMVmGRb6xGz5YISQuEU99BqAfBu1T4LFbiHnWtwb/?=
 =?us-ascii?Q?ovXBgTSoEfj536PYXHRGwXYbi9BhuaHzHHL3fly735VXYZK+ZP7aJqs7zBro?=
 =?us-ascii?Q?WFnAWcthUDK+DJk+xnhR0OosT4HXL6nNigCkm3danqONJhPK3wKAVq/Ebfy4?=
 =?us-ascii?Q?9nH/muo/rsz19t9GqWpCz5bg7Te+UHxqXQuzUE9hUpaIs9jwdqWc0GaOpTVl?=
 =?us-ascii?Q?suMvDm91+bcX978Ok7Rb5/WJifqmmGxdYLSRoEZwjnqZ9aHZd9kTfwNeBFak?=
 =?us-ascii?Q?hhCtT6Sp92vo4uC90CsYf5v5WmnWfqB6tckImSL9hKUp6eXnU+PaK/VCfE7O?=
 =?us-ascii?Q?7viunl/0vbWt9I2mm/j+ttQqllQowmhTj4BvJXWitCwYko7VCGBGBWF68dkj?=
 =?us-ascii?Q?17kuzpRoE0aLvs9TFgBJUgOX4TMZx+MVL2RXZzcqm5xCZ/IQta3hWr3w89mK?=
 =?us-ascii?Q?3nCQuVomQjUdwmuxAaYKOW5ngIhUA/woM6L1wg6Z3/em92FdBuKEr4xPA38r?=
 =?us-ascii?Q?3Mwrd5GUw3yrv3Zv5rxgzLvuvmdtwyjgrUT92BqwTc/Fhe1IAFB2vQUptkti?=
 =?us-ascii?Q?rDa2/ODXfH2o9JLB4FZlOI03gCosHh4ELO561Ag4TAeu5VghH1HyTuVp/NYk?=
 =?us-ascii?Q?1m2EViIifR/d1oSJzv6lkLI7biq7feDmZoFDYMJ811XXaiDIT+wBI8eqsbJa?=
 =?us-ascii?Q?HxZ+zmElaUslbDn8xnAHjPhJgQ3j/jTaKe3vQhAtJF7vzZU1tz6b/+UHX2+o?=
 =?us-ascii?Q?UwC/Sf9o7OcwaV8nuMr4odP5sT4TGX/LkfHutDkhQdFrtiOMnv6H7DL0yJC2?=
 =?us-ascii?Q?jAZUfD9kAIxcMkh5zLHCvrK+VapPtiMUL+vY1qaUmKPlHybKF4RMKWhl80OA?=
 =?us-ascii?Q?RHaU0nHarjM7IVosbnM01/nFJA1QY+nqXT2rN9HvjoBzioN1PxUnPgj2qQh/?=
 =?us-ascii?Q?1G230K9CQNatZGHkwV7TWYXreMg4E6LwKOg64abeXAuJusq46GEVLZBdv2zB?=
 =?us-ascii?Q?VKbhxsrGWiHLYgMcfOAuDvpBAlFPlklO91hsl1wg/KLbsyK1lthWIQnIPrrA?=
 =?us-ascii?Q?9J1g+0ZnGFFRu9I4P4S4xhio2ggRKKxsBUGfzFpGqNrt6Vp6Ekd5n35x+AX4?=
 =?us-ascii?Q?woleP3PgjwaSgK24Pe/qZtY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd6fcb4c-f495-43a7-0d8d-08d9a2f6cf33
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 20:31:57.0160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K/WKiz4s4QSXrxnQlY2pN5MByC7A3PMBxFptH0CExbi63GTze7gn7VSqGxPU0YeveS5lSqG7uEAQsoEi5dN4oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Colin Ian King <colin.i.king@googlemail.com>
>=20
> There is a spelling mistake in a dev_info message. Fix it.
>=20
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>

It would be good to add a Fixes tag:
Fixes: 635096a86edb ("net: mana: Support hibernation and kexec")

Reviewed-by: Dexuan Cui <decui@microsoft.com>

(Sorry for my typo in the original patch!)
