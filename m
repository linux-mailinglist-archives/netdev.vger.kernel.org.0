Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB758314A41
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhBII10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:27:26 -0500
Received: from mail-eopbgr1400072.outbound.protection.outlook.com ([40.107.140.72]:27133
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229743AbhBII1J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 03:27:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bU1g0TuUvfIvaSfF3oyfirYltb55TXYUCq7epHxM4OEPTv+OgdxeL0C4Vpo+9CXDDlaUI0lhB3tqGsmlBt85kdpeIbTgtrpn8IsNnh85Md102mVluHmX1MADNvPQryhP0MOBAdO1CuFWcBEHnS5lyZGy450oofFEKNeABu/24+M+W41POoWquexH4U8QaOCCdEMKtqz00b0zKzucGfGGYjH8x5tpqkRp73gnIMhcsPxWUI9fWPy9I7ypixqBTxEhEnMVpw/tspf0xGFTkqwPOU+PS/8JhxjJtCCfaEGf6Db33kwHp1B+FimsifE0Nl9BfoxdBynVnVvpqyecW4H/yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNUfV1UQmMsM5fsHWJfn2pSx7A0sFASAduk7Akup3p8=;
 b=MGpwPCstEtHmnp72z+IbiRx+Iimjlak3wILfJwm17WD8+UONZYvjYz266UH2WSP8b8Bu4n6RlTX/Js17K+8lLfawaYudu5UnzyO0zsX8BXYnzqjGr8TyYoWyJtX1X7TWKBYFLL36FU2Q82T+sGD/deEy4DEgwwpZJ7q3ikiWgy9fxkl6z1ecUaRTD/8ufPbwcXT2aF0/YgpGtlA3iR0x1apgp/a10nf2Prm77Twi0Mz3rbhE+tvH/aM7atTy5BKOBoD402+MWaPch81E+tRgqB4bXOKhSaFDcNjQ1UgO7MarAf7ONMfn/b80jBuuoO19HVuhFvAvaVeDQ32wkAYGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNUfV1UQmMsM5fsHWJfn2pSx7A0sFASAduk7Akup3p8=;
 b=jWcC2SxrpkVoOwPROUkhjtqLQIU18a8q0Bpj6Vd3eBqj8xnk9+7/JhgLEAaC9Vh4y1HxZmMgK3LNa3TZm1EQb8UG2XPnPncu0/33Q26VQeqnVayud0FEdftcNM9l4eIkMjfQxyzXMZqh95jqHxoMskUqupPYUAFgbKdl86OFZTY=
Received: from OSBPR01MB2229.jpnprd01.prod.outlook.com (2603:1096:603:20::11)
 by OS3PR01MB6134.jpnprd01.prod.outlook.com (2603:1096:604:d0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Tue, 9 Feb
 2021 08:24:52 +0000
Received: from OSBPR01MB2229.jpnprd01.prod.outlook.com
 ([fe80::9c64:96a9:41a5:98e4]) by OSBPR01MB2229.jpnprd01.prod.outlook.com
 ([fe80::9c64:96a9:41a5:98e4%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 08:24:52 +0000
From:   =?iso-2022-jp?B?Tk9NVVJBIEpVTklDSEkoGyRCTG5CPCEhPV8wbBsoQik=?= 
        <junichi.nomura@nec.com>
To:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "toke@redhat.com" <toke@redhat.com>,
        =?iso-2022-jp?B?Tk9NVVJBIEpVTklDSEkoGyRCTG5CPCEhPV8wbBsoQik=?= 
        <junichi.nomura@nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf] devmap: Use GFP_KERNEL for xdp bulk queue allocation
Thread-Topic: [PATCH bpf] devmap: Use GFP_KERNEL for xdp bulk queue allocation
Thread-Index: AQHW/r0Jwmd5e9huskOKvbv+Dh9u7w==
Date:   Tue, 9 Feb 2021 08:24:52 +0000
Message-ID: <20210209082451.GA44021@jeru.linux.bs1.fc.nec.co.jp>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.110.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ab03ced-6651-493e-cb8d-08d8ccd42c4b
x-ms-traffictypediagnostic: OS3PR01MB6134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB61340C0EF366B43E3C2AADE3838E9@OS3PR01MB6134.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+ABFw7bC3Qz7wZBOlUO4ylXYyNebcNpHMtGbvQgtckCd4Seg3ZaIxPvAwZvJgsPNpYSNxfxCzScS9aUyCaJXHMooiGANWdxGszZGfLCaXKOxrVusppjxhWl7Q00WXLDtt5Oxt7ba5/tVSQ0yoR5lDojowP8PVSJHIbIz6rZBGCOeRv71JOKAMEQAJlD9dDzg/5DNXIxvXUDlTspGViW1pWmiHUQjHs7sD/+CnKNZbZg8hF73p/L45gaifs0IzQyy1OFBB6/T1vuBRHfyUfp2JzbzL2ULBLwj537pOyzGrKdZrhlMvZFWxX+Q+dwejIDO5vNMvOzUqj3N/4iJsq/SufqL/2EcA4/rTwEVVVFSE1W3xvsiPOf1noaDB8AQAamFTYJf8H+kDy92bUbQFdqNfMlA4NkcK4tRvUAERM7jmrkUCuySKZCDXffQUNQ7aXu+x2aISPvCHkza7rBzmwhVJohenTAIPk9sN/MogTZB/BxxAWFFvkNOhS6kF9jHdBESfyFIz+Jpdn4kB2T/AxNSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSBPR01MB2229.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(1076003)(8936002)(83380400001)(86362001)(55236004)(6486002)(6506007)(5660300002)(66556008)(9686003)(91956017)(316002)(4326008)(8676002)(26005)(54906003)(110136005)(76116006)(66946007)(71200400001)(478600001)(33656002)(186003)(2906002)(85182001)(66476007)(6512007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?NWVTN1JXZElEVWxsWFpCT2VlU3o2OTRpUE9ZSmd4eHVjZGRsMEFDRm8y?=
 =?iso-2022-jp?B?YmQxTXRRMlNwS0xJd2JtZTRaWUQ0eXB0QkxYK3p4cGdwcnpKMXdpRFRP?=
 =?iso-2022-jp?B?cE9jbXlpQUNnN2F2R1ZsMG44WVVYbkxKck9kN0xCQzNqVmUrVHAwSHR1?=
 =?iso-2022-jp?B?YXBaVmlhUnJ4d0FyalVHalUxc0d3V3JpbUVoR2R3THhGQ1EweklUcmN3?=
 =?iso-2022-jp?B?Ylk0NTVJdGgyN0NxR1czb3ZhN1JlRzVTUDdiUTFpeUY5c2l2aWlVYWJE?=
 =?iso-2022-jp?B?RVBwdG1PeFpSVk85ek54S1U4MmhsdFlROVFpeE9jRU0vNUMrZWxDTnNQ?=
 =?iso-2022-jp?B?UWhZckVaUGFsRkZnNk1JSmIrNFBVSU4xNWh2Mld5NFpUNm9hb1pQNjNa?=
 =?iso-2022-jp?B?Yis5bkZ1U0c4SzdTU1hwek1hckl4d08vZzNlU0lqSzFjNllGT2hhWmFh?=
 =?iso-2022-jp?B?S24vNDRGZmdNdjJ6TGo3aWl0ZlJkRXR4YjVyZjFXZFNMRlVmWjhQbWZt?=
 =?iso-2022-jp?B?VHl4NWtXUzdmV1lQVThXaWJ3QlByTDQrRjRCRmRNWjJqNXhmVGVEUG5i?=
 =?iso-2022-jp?B?amlwR2NzQWJ2QnZDaDFrcHkxSmIyWnBYOGZyY0lZK3ZOSkl6VHdlVTJU?=
 =?iso-2022-jp?B?blp6NkpOYkgrK3NIclkrenQzd0JFelhYcklzcFBwMTVsQXFYSTJiQkFD?=
 =?iso-2022-jp?B?N3N3QVpsKzNubnVMQmgrQ002aUZZTlk5R2U5Ti9pL1VNSktqS2Z3YVJW?=
 =?iso-2022-jp?B?ZExDcy9HMWpObm1oTkVzbS8vMVVOa0ZIQWZ0Rms4dUZMUzFYM21kZVZL?=
 =?iso-2022-jp?B?dk1ZeloyWEJoa3JnQzNpV1ZkN28ycTE4dG1IQzA5Y2RIa3pxZUYrZjNQ?=
 =?iso-2022-jp?B?UFVmNUFjUHhCTk9BUUR1NW53Y3B5Vm1kd05HUmRCVEhjeEMxZ0FFQXky?=
 =?iso-2022-jp?B?YithRHRkQllnaGZtd252aWZDZ3RHby81Q0ExNGJhSnVLOGpKNkovb0ZZ?=
 =?iso-2022-jp?B?RVRxOWNJdkFKTWI1NWVveHdTb0RUcFJacnRDemlqZWxCL2VSMmVBNnFi?=
 =?iso-2022-jp?B?ZnE1Y3RJOTFveERvSE5XVzRqTCtvRXorRk5DK3A3U3BUeEJYdkJLQUpP?=
 =?iso-2022-jp?B?QVZsSmZyVnl6OXhpbTdpM2hYS2x5Nk5aWHhqVi92aW1GUnhVN2dQczBW?=
 =?iso-2022-jp?B?MXlndFZGczh6a2s0cG5WMDNXeFZGYVRvOWJTQnN3S0JhS3BqTFhneDhL?=
 =?iso-2022-jp?B?TUpKVHZ0UnhIdjZObUpNWjB2QnVyaWkvVlNMZVFNV3ZCOWd4QTM3b3pz?=
 =?iso-2022-jp?B?c0xQYU12V3EwU0VvK0xaTVFUUG9lVDdKTUdFc2xMTUpwWDJoeStDczZ5?=
 =?iso-2022-jp?B?NW9qRTczN1VRbzlCakxEYUdmMnF6d3E5TnBNM1ZadjhWSlVTeW1MaUpj?=
 =?iso-2022-jp?B?akJ0Y0lmMUFlcCtySkhiSS80ZzFHN2RYTFRNNnFDMVp1blcrTnhrNllT?=
 =?iso-2022-jp?B?NStIMmp1Ky9QYmdET2NJMlFxeDY5NnpQNG1sdVZ0RjJENGxhZG5PZnhG?=
 =?iso-2022-jp?B?bGdoWlRsMGIrV1RYZTBzUXk0M2Y2RUZ2RGlNM2lIdmJLdnFkS2Z6d25B?=
 =?iso-2022-jp?B?NndwN3VNc1djL2c3SlVpMXhjUUJrbWgrcEtMREZYdndWVm92SnRTbGVT?=
 =?iso-2022-jp?B?TlBWTXNsYVBwaFpkekhhR2Qrc0pHVnR4TkJpaE9odkp6MDVhMU5Vb2Zh?=
 =?iso-2022-jp?B?a01Lb3dSbmZYK3pkZHFNdFczVnp3Q1BTQWI0anlySVQwVFZRLzFnTnV1?=
 =?iso-2022-jp?B?clRISnl3UjF3eGorOVJsbXIwUTkxZXkzSkNyRVJUY21iR3pHY2lDZ2kv?=
 =?iso-2022-jp?B?SVNJOFc1WmxRTk51SERzcE9WeFZCaU05ZVZEdkUyRjg0L1hWZ20ralZt?=
 =?iso-2022-jp?B?QUxWeHFKZ2hIY1YyMC8xOEl1WXJwdz09?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <A521822A9B58B642A0FC4C645EE31822@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSBPR01MB2229.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab03ced-6651-493e-cb8d-08d8ccd42c4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 08:24:52.0603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3kUG/zCkuwotszdTMdxQt/RWnNyVc6jcbY3RhYa+F0EJBKtkJbmJXkgSzE+gCMFYPQnJ6c+CXMQX7JtTZB/3lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devmap bulk queue is allocated with GFP_ATOMIC and the allocation may
fail if there is no available space in existing percpu pool.

Since commit 75ccae62cb8d42 ("xdp: Move devmap bulk queue into struct net_d=
evice")
moved the bulk queue allocation to NETDEV_REGISTER callback, whose context
is allowed to sleep, use GFP_KERNEL instead of GFP_ATOMIC to let percpu
allocator extend the pool when needed and avoid possible failure of netdev
registration.

As the required alignment is natural, we can simply use alloc_percpu().

Signed-off-by: Jun'ichi Nomura <junichi.nomura@nec.com>

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index f6e9c68afdd4..f4d3fe8e0652 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -803,8 +803,7 @@ static int dev_map_notification(struct notifier_block *=
notifier,
=20
 		/* will be freed in free_netdev() */
 		netdev->xdp_bulkq =3D
-			__alloc_percpu_gfp(sizeof(struct xdp_dev_bulk_queue),
-					   sizeof(void *), GFP_ATOMIC);
+			alloc_percpu(struct xdp_dev_bulk_queue);
 		if (!netdev->xdp_bulkq)
 			return NOTIFY_BAD;
 =
