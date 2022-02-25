Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E10F4C4369
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbiBYLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236092AbiBYLZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:25:11 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2054.outbound.protection.outlook.com [40.107.100.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484FC225013;
        Fri, 25 Feb 2022 03:24:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QPTMG3EqFxjewv2TdYlx1XU9+olbN2OTij9Tw5Fa7rPsskDnGPJfeORGcXmPRB+TvqxFhtcPZtxT6o8MYfr8Po6RBi50CUfWAncOzr6y9UId/xlzvL8IaAyV/1j50cK3oX0+h+B4u/Jj0oQwm1paisXI37G/wwmiiNxA4MpgKimNqAbk8pw2Kf6sY82LDOFQRIUksM4OBNLAjIhAcl6dhFCTDMGAjw2li6/GXLAFJx7qaH4fqAvASaVAUqfb8xkFYpuzZERKZSTBffJdGyRb1JoXiSrPp2kZRlDWLYA4gOGUjC+nwtgMIQMBUwg3/QbDnh0a+maBdJzoqXEThdkHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I179u1habwdSm5yQ2mS5LMrlzWQSEc1YWKeJfZu+ro0=;
 b=joEVwuxbtfzD4JcDkrDRiaopzl2G3n3SEUv1HoGzwEENjzG6M1NwhAAHTq6Xgn/GTqEJgtkpqdIGhVak3SFxGp/dVL3ga+QserbpnpNJ7CXaEF83iwB6vwsrYa6s7Z+p6ZGfs0KoZoQphIRiW5pMxwirlrj04DyprPKx4dscH5Wncw4fFTOBLqLPO7fZ6XE4xXEoyQNGoHs1RJ64c/At9GpvhXXYEmKc1DL+kiLpIPoVczIxcyeFZzxqAJD+4KooMmSj7zLhQjfk5Qh9SXjRED24wYPTpGFjDsCuhhraRc+IOkYRbDA4fKFM3+hVZikvaVeel0+4WOfwctkuJIDxbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I179u1habwdSm5yQ2mS5LMrlzWQSEc1YWKeJfZu+ro0=;
 b=JJCoCHYxWXFTIofP5JMS/Ik7TEgXNKpvLkttWYSsh9Mo27NE4bkR1zEdhikXz5P7cHoqLla30wJs5JblJJh5hzWu/nW5O7eMAzc6xUPwsV/WGOIAI6CYTNxiRLW8jtx88AjoqawBd6BHEGvuc0gW6yhV9qtVhyPnBw4XKtnNUPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by DM6PR11MB4362.namprd11.prod.outlook.com (2603:10b6:5:1dd::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 11:24:35 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::dd2e:8a4e:fc77:1e66%5]) with mapi id 15.20.5017.023; Fri, 25 Feb 2022
 11:24:34 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Cc:     devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/10] staging: wfx: usual maintenance
Date:   Fri, 25 Feb 2022 12:23:55 +0100
Message-Id: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0052.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::27) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a90d822-6064-4c69-aeac-08d9f851666e
X-MS-TrafficTypeDiagnostic: DM6PR11MB4362:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4362CAB8151D96C4188B0A5D933E9@DM6PR11MB4362.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S1gkSGuQqVwn+kWhfo9KfrL5bT6iIo+lw8bGI8guqaXx5YQ1pvWjYRUz6wpOJDjvIgmfz1uIk/0CzwOucb3OlbgiMFYm5TVeuX3dG+GsXEC5vCpoHPK8GNWsdlVcRw4L4rlfZat1iGJPjIWARiFEl60ibNKgDC5UQ+QSrmKT8MWl/Yvrv5avzxbtq3UAqStRuwhv+GYaDwwqPQGDV/KjhrtTt9JDwgJ+iZ4f/31hnt16gm4QCHzRIrAAbEH8NOCYIs4uWCrYTHnDqovci+0fgEITtFrv+aXhPyIaGXo6K9e7H9ZvjqAn9HhfKTzIp0CoCkKPLhiNMB5yg/ov1mPg/28zalSTpM/saWdedurh1lztYmpEMXVgsqecWrVzq4nueKmekZds+/ufoNxAabOw629fUxUentyo2/DkKxxmnptR5fchChIORw4xjYKxGZbB3XqwlzSBrLkgF1yoDL+CT9s9TwVUGDS58+unSiDL5L/WDsVfZ3u5p9p37PsXh2SaopPrUI60piuE14hiCfSlDLCbPzfyRA/xxzc6JzOUTO0YsIX+xCFzerDtIxqzeA0Xr3wgxJ7U0iWrk2bYwYo00z4/iJNfeOngMes7aGySQ7EUitQo29Tq3Tcb0UIPxGkCtycM+MJF+eloL1dllrWNKLTs48qXNUiRt8fkN3R9sw0euXO8ebbBPBWKWyxUehMy1lrS9McP1u/xJ+beHnRfJNY7bsO1AGyxKA09yncPReKTgJKXy/fu6luNY53drlPl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6506007)(1076003)(66946007)(52116002)(8676002)(2616005)(66574015)(26005)(66476007)(5660300002)(66556008)(508600001)(2906002)(83380400001)(54906003)(38100700002)(4326008)(86362001)(6486002)(8936002)(186003)(6666004)(107886003)(36756003)(316002)(38350700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHR0akRoR0krZG9McWVvcUlCM3FZMXdaWkVhSkpnbHhmbFhXQzlJWHNhT0sr?=
 =?utf-8?B?cjlZTEZUcGhQcVh3R0tLRlAvdk5ZVFY5UmpSdCt6RVVSSGNzdURBNmVKc1dK?=
 =?utf-8?B?UXZnYUZUb1BaU0ZNaGRwNXg3a3oxSVpRbHlkVDJ2VXlOQzFMVDFqZk9oRFJ5?=
 =?utf-8?B?RlQvM29WNVlJdWlsOVc0L0t4TFNBN2dVNXFBWmljM0F5Y0lsWi81ZVllNFR5?=
 =?utf-8?B?RUNBY0VUdFd4YkFIZXNqQ2lQZ2Mvd1Z4OFg0czdZMzdwOVJkeDlmTXZvNEE1?=
 =?utf-8?B?WjFHbFNGM2ZsYzFVVjFHZUpVTVdBVm0wZ0p0OUNESlk1ai9uaGgyZ3RMYkEz?=
 =?utf-8?B?NllSbVhWVFJldlRwNWMrb2c0dFBONWU0ZzJMZ3dKSitoYmpmd1pxV2FZemFr?=
 =?utf-8?B?T0xnWmk0QzZKbWZ6M2t6WDc0aHUwczJScC9iWHBOMStjc3lBWmdtd1hZclQ5?=
 =?utf-8?B?ZFdJZE9LaTBmeHAwbTUzM28weEZxOWdxYVJGMjRaazU5VG83UW1RMnB2MWJ5?=
 =?utf-8?B?SXNJcXFLNnpSRm9rWklERzR1dG9xejc5c25IM0hGaktNM3hrUkdIS0d4cURM?=
 =?utf-8?B?VFB2aVo0NmRyZDg1ZkxVTUNxWWllWk9xQnJCTFlXVjBFbDRsaDNjc2RxVDJy?=
 =?utf-8?B?V2kwZEgxT2xFTWl5QXFqcWh1UVVNY3M4czJYZk5GYjk0aldSZ1J6SkppdmVM?=
 =?utf-8?B?RU1nTVdCWjNsYXR0WmV2alhjMlIrV0owU0dhTG9ieDFMRjRzc0hvQlU2QmF5?=
 =?utf-8?B?dm4wd054K0p6WE9SY3podk13MlJvQXZuMVBDcy9hSVJKQUU2SnBJOFhteGhJ?=
 =?utf-8?B?L0lZVERoQTZ3WkhqWUI2ekZDOWFoMm1jVGJPV2Y2eHoxRkFYaCt5Mm5xRkFu?=
 =?utf-8?B?aHl3SEFTNEZwY1RPL0hFbTB1c1ZzVkRFblJLMTZZekwrS29kM0dxK3dlV2M2?=
 =?utf-8?B?ejkzZGY0RVkxM21RYkw5aWQ3UFpoTnQ5YW9XcGNtT2o4bFBRY0VhZnZIWmZm?=
 =?utf-8?B?Q1JxUkxMeG1OaE41SjhjVkkxclpPbjlyeW1tQi9NM3hJZ1dwSnpaY2RjVXlR?=
 =?utf-8?B?dmp4cFk4VjZHM1F3OVJyZlZpMjRPcnFIUUlIeStoUEx4Si9aKy9heUtEc1Uv?=
 =?utf-8?B?NmJiRHArcEVOSUFNV3NQQjNkSG5yeW90YUNtM3g1SFFNKzdSdWhYeXhMNms1?=
 =?utf-8?B?YlVLcHVOTkNQTWE0bzRzZko2YmkyMzVuTUc3TWJ2c0c1dDZtb01XVzZjSndZ?=
 =?utf-8?B?Z00vQSsrNzExVStKMVE2TkdRVzI3L0xhK1hOd1NNSUo0d1ZMZUNEWGowZGt1?=
 =?utf-8?B?QWFwWE1aYWhyTko2S3BsZmh1NlgwN3JXSDZNSkUyN2tlMldzZjZscjEwMndH?=
 =?utf-8?B?eUpLNnBuaEFna1g3VS9wZzhXL3YxMnFxR0pYaERFUWpGY2kxRm55SmRGRkl2?=
 =?utf-8?B?YjJSMkpnKzZ5ZW5aSGU2ZHErYUJFWlZjVXg1bmoxcm9BWWNXSzhiRG5PQ0tV?=
 =?utf-8?B?VTNxSmIzZ3I1emQvWDBkQnN2a2NwZ0FoRGw0VS93T2M1d3FPalhaTEIyakF3?=
 =?utf-8?B?Zmo3L2tzOWtQcm5XUWVnaER4Z2RXdjJiUEE2S1NLQ1ZCK0JaZHNhZnVyOElj?=
 =?utf-8?B?dEUvL254QXMzMkE4ZjFqSDZ0TW9nV0g1WENYRUFhVFlOWlZKS2RWcHhVelZU?=
 =?utf-8?B?NHZiNjk5QVZ4NzNYY2h3NnBSTHBUNmk2K2x6bU0wR0FaaUJtVGxzVStXSGRG?=
 =?utf-8?B?Y0Y5ZFZIQnhzbmNzQWVYQmZpb0Y4TmxGU0lOV2ZHdlZwd29QWVYxa0NlOElX?=
 =?utf-8?B?Sy80MEtUNnl0RkZBT2RPTlQzTDFZa2F0YTRzbng5bWlxNk1SdGtRTlZ5akVS?=
 =?utf-8?B?VXFuY2E1LzFqU3NYbVN6ZlhvdUVaQzlTTTQ2NWpUb0RBaWJ4VlNyWHJKOEYw?=
 =?utf-8?B?STVVemVaQkR5MDZldVV0ZGZPc1NHVnJ0dEV0SEVLcXpFbkFsVUJJVGZkZ2tH?=
 =?utf-8?B?OHFlZFVDSG5QNkdSVTlIT2dIZlIzeHRGK3E3T1A0b3hZM3pLYmVnU2tDaG5Z?=
 =?utf-8?B?Zm4vOGpucGxKUWttNkJWK29SSlhBQmxUbDN4V3NIMWtWZVdJZ3ZtZjl6Umw5?=
 =?utf-8?B?eHNYdmpEaGtRdnFJMDFJSVgzQW5yMFdKUnE1WnY4djVGam5RbjdvSG1pZUw2?=
 =?utf-8?Q?QZB3HGOGqKp8cc+dIHq77es=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a90d822-6064-4c69-aeac-08d9f851666e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 11:24:34.7016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zj2emOFKFVy2ZyPBDrAMIJ5YQX3WVqkzRo/MMsslfHOZLCl3EnX+XcTFI0XDSncO0C+cEknd/4ALwkkpI03Ing==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4362
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBQUiBjb250YWlucyBmaXhlcyBmb3IgdmFyaW91cyBzbWFsbCBkZWZlY3RzIEkgaGF2ZSBzZWVu
IHRoZXNlIGxhc3QKd2Vla3MuCgpKw6lyw7RtZSBQb3VpbGxlciAoMTApOgogIHN0YWdpbmc6IHdm
eDogc3RhLm8gd2FzIGxpbmtlZCB0d2ljZQogIHN0YWdpbmc6IHdmeDogZml4IHN0cnVjdCBhbGln
bm1lbnQKICBzdGFnaW5nOiB3Zng6IGZvcm1hdCBjb21tZW50cyBvbiAxMDAgY29sdW1ucwogIHN0
YWdpbmc6IHdmeDogZm9ybWF0IGNvZGUgb24gMTAwIGNvbHVtbnMKICBzdGFnaW5nOiB3Zng6IHJl
bW92ZSB1c2VsZXNzIHZhcmlhYmxlCiAgc3RhZ2luZzogd2Z4OiBkcm9wIHVzZWxlc3MgaW5jbHVk
ZQogIHN0YWdpbmc6IHdmeDogcmVtb3ZlIGR1cGxpY2F0ZWQgY29kZSBpbiB3ZnhfY21kX3NlbmQo
KQogIHN0YWdpbmc6IHdmeDogcHJlZmVyIHRvIHdhaXQgZm9yIGFuIGV2ZW50IGluc3RlYWQgdG8g
c2xlZXAKICBzdGFnaW5nOiB3Zng6IGVuc3VyZSBISUYgcmVxdWVzdCBoYXMgYmVlbiBzZW50IGJl
Zm9yZSBwb2xsaW5nCiAgc3RhZ2luZzogd2Z4OiBmbGFncyBmb3IgU1BJIElSUSB3ZXJlIGlnbm9y
ZWQKCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L01ha2VmaWxlICAgICAgfCAgMSAtCiBkcml2ZXJzL3N0
YWdpbmcvd2Z4L2JoLmMgICAgICAgICAgfCAgMSArCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19z
cGkuYyAgICAgfCAzMCArKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jICAgICB8ICA4ICsrLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2Z3aW8uYyAgICAgICAgfCAgMyArLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQu
aCB8ICAyIC0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jICAgICAgfCAgMyArLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgICAgICB8IDEzICsrKysrKy0tLS0tLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jICB8ICAzICstLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9od2lvLmMgICAgICAgIHwgIDkgKysrLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVl
LmMgICAgICAgfCAgOSArKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAg
ICB8IDExICsrKysrLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oICAgICAgICAgfCAg
MyArLS0KIDEzIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDU2IGRlbGV0aW9ucygt
KQoKLS0gCjIuMzQuMQoK
