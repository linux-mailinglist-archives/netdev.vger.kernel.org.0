Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47EF56B6B16
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 21:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbjCLU3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 16:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjCLU3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 16:29:23 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on20706.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::706])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56A0360BF;
        Sun, 12 Mar 2023 13:29:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QZwxqKxNQsWZb5APVqOoC136MSo6U3wglKqoAQ/tywNvjY84K9IRs1MVGtPSmfmgCArEFXBufs1R2VMYvUuwuJpeuwNwH50lRCC3eNPpvqaUsbIqe75GESg9k6lb+JrbkyDsUGlrWSiPnW5t9rXJum7sjsHxtWRzguf/7F+YtH0jCTNFMIZ+BzdxjPc8ZHUNAcALsJOc3V5hx+1oGHDUA//uEMYPq+b/H3cN0VAjkRotKo24JnqWCxLCNSItVvXKcpu/Rbz/SL97Va4iyM3F+Uuyz9YmPffjFAglwd/Y3fYfq1LprQox3xSOjEWa/YndidvYTYCb/fJhdlNnKBKF7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LisvGa9e8IwQ+yW6USXElxPovCTIBslRZbcMxS/2dc=;
 b=ImQgcgf5pFZ08ZNknJzhONtLf0xrD+zVq897DKvWq2RzSFLMDrpSqN0H9sQadhIBigkHInjLD535s8Yv/0RfqoM0M7ZspybTGI/U80bao4mesrt8Bc2fQx425E4ED/WKatAb//lPVCJfgKLpMPot7sA2HYyUTvHklvhXKC9/UUjXbJj1viDB4osc7Y+DlPp4mXymrlPDlgkWOuA89qcQD2SFkgP2zj8m0K08TlRayF42S6+x3lie6BeEzK9qwcvR8kfYFy+9fwaiVZlBORv8D+HQem4frxa26KxZjs4Cgi/Y4uDxYnaxeOrF4+yamTLFJzXkQFbMkuVeouTy6IHa/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LisvGa9e8IwQ+yW6USXElxPovCTIBslRZbcMxS/2dc=;
 b=Ufaa9BY3LNIPi6DgtWceel9dcE9CmtJxbEBJZnDf5nv5jsNmDo2bqRIK9rkCuQ/oXOQOgWwRecUqNs1tWLRwyiZcMk94yJCkLb6ua94/ltYMsasYXqwmLuiPMmTOnfXVYNReykh0ROlnsrJ7hMn7/QWBYpshmCg6h4WPNxwvSXA=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by AS2PR03MB8906.eurprd03.prod.outlook.com (2603:10a6:20b:5f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sun, 12 Mar
 2023 20:29:17 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::c9cc:aef7:363b:9c91]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::c9cc:aef7:363b:9c91%4]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 20:29:16 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next] net: lan966x: Change lan966x_police_del return
 type
Thread-Topic: [PATCH net-next] net: lan966x: Change lan966x_police_del return
 type
Thread-Index: AQHZVSFQDt83Tmd9vkqaj+iIv88iYw==
Date:   Sun, 12 Mar 2023 20:29:16 +0000
Message-ID: <20230312202915.47jc6ko4fs3hngyd@bang-olufsen.dk>
References: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230312195155.1492881-1-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR03MB3950:EE_|AS2PR03MB8906:EE_
x-ms-office365-filtering-correlation-id: 558efcb1-dbc2-47f4-855a-08db23387350
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDKJ6qTdXzeuGiEuqZDrLoV5nRGTHAh+23Z5laq2+kQAKt6BS11+dr2abJ/mZzoZOLgb+VRLvSzKtg2cVx53wuU4G1jZ/9ObG9JuP4+86l90AtCk3XcHHl50a9RQv2Xn3+lRnkwbOnJBh94fZ8bqe3P3E4ClNETK5XO6gyGgFS8Do1yKW+aMNRMQ63x0LNBkcKCuuqQu7jqxv9qiupQ3sAh/UaK90dMmf8wBOiPRHcFi7zeyXpJdRGOzHKZeaX5i5mOvfzoQGQ8dUG60uk7Wv71AehhInNZZcytNG5RUgayEzPom0O0iDO4WWLkx/QArEGlbf8DrP0VAQTNhR2s/uVDZj5QY0+wRMCf0NIjzX9aoUFsZRetibmlzQBzEEYxQ+qZMuh/BJGmRuNS1QeWPLITKgf7EoaweMK04PCF+OpSVUbEz69R2+byWJUZ5wt+dpUkJ4EsmzOhaff16OxDU4ef6iOKTLVjrReeFH1+na/AXN7z8gLKhV+lVagPUuHh+n/Rd0g076KfdTxySEpdVLqzQgYl++dP2bgW0SJLNxa3buzH4Kl0RRS5e3H+K/1k6NknDVvW9fZuO/ymqqC6Ca1ZdBxqCigdGo5+8okccBcfif/BX9+ubk0WvMUqr/mVewAchjWWDw3yaaQXlMwq4FFy2zR5m+JGSsh/1cKxqoIu5SyIiklGNm3o92h+FCiiWqpYEKtSFw+Or3OYspxoyfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(376002)(346002)(39850400004)(136003)(451199018)(5660300002)(85202003)(4744005)(85182001)(36756003)(83380400001)(478600001)(71200400001)(6512007)(1076003)(6506007)(26005)(6486002)(2616005)(186003)(76116006)(6916009)(91956017)(38070700005)(4326008)(64756008)(66446008)(66556008)(66946007)(8676002)(66476007)(8976002)(8936002)(41300700001)(86362001)(54906003)(38100700002)(316002)(122000001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDlYWWtRZDFqSTl4dFppYitUNUF4WnpNSDF0WS80NTlKNG1iU1pwSEZhRW9L?=
 =?utf-8?B?eHlMNmp3ZTVkV3FSVkpyNm0xRzVmTUV6d1V6cE5QMlg2N1ZDbmZrMTJuSGh0?=
 =?utf-8?B?WWFIdXZJN09LcjlQOWg0ajl5YTVkK21zVDVFYy9JQzdCV0krS3JTSmlFaVUv?=
 =?utf-8?B?NkF5ck1MZ0xKa0lQZFVZWGd0NmFWTS9JRHRjSlFneklYb3hGbnlBQndWeFpI?=
 =?utf-8?B?bmFiREFxMWdhK25qYmQ4eUVzLzZhN1hUdTkvTy82Tk9maGlxR0U1bkJiQ2N1?=
 =?utf-8?B?alNQdTdRREZUTDdtNVJvNkxoU3YwTlVpdkVtUER3dUVXRHBYQzhWQktLOVN0?=
 =?utf-8?B?UThDalJWQldBSEwxWldsRFlZVG5pQWQ5VG5zMEQ2R0x4NzZiRDByWUNuU0RS?=
 =?utf-8?B?TmpOa2RLWU5oQURzZ2VKeVJvNW9jbXRHY3NGTWNiYVA4UVh1VjViVWZPd2tv?=
 =?utf-8?B?SFRGSjNQYm9vRW1Fd05ha1pIOUp1eUZoS2dGaHlNbFhWanpZS2xjMVhQUU1H?=
 =?utf-8?B?c0NabmFFYnk4R2xqV2RMQ0J6bmx5RDRrUytuNy96VXFGQWYwS0FlU0dmYWlL?=
 =?utf-8?B?ZXRlS2xBYWZPbmJSUzBuUnQrdmsweWxLTVhiUGhPbzJVazdsVXdwem9mSm5B?=
 =?utf-8?B?RnE5a3RjdW1oUEIxS0o2Ti9jWW85QXJhMjRUckwzMDB0dzRZekhTUzBlb0E5?=
 =?utf-8?B?U0VJb1c4b29jREVYN1dvUXlkQzJyd2hmUGNMY0M5UXlTaDFPdmU4eU9uZ000?=
 =?utf-8?B?UXlTcll0V1l3Q0JydC9LSGxNOU55cU5ZVmdtbFZ0TkFUTEh6WmNZMC9xbzNY?=
 =?utf-8?B?UVZ0cTBhS2xqWDJXbGxlWVAwWGNuUDRtVGNLZ0VtZEcxOGFSSjZLeGFsZUw5?=
 =?utf-8?B?VGpZODFGOVpJYmsxY21oVVdaOEVCaTVsODQ1cWgrc2NTbkR6b2hCMmxKd1V2?=
 =?utf-8?B?ZW5wMzBieHlpem13RW4xUHdGWGZIWUtGZG9mSkVwSVduSXk2ekVlVHM4UU1H?=
 =?utf-8?B?STVZVzRUKy9Gb2hPZVFlenhMUVdINFNTOW1aQjNCc3RtcGpvY1hURFd1cWdM?=
 =?utf-8?B?aEI5RG5XbTFwSWZBWUo0Zml5TlZwcG9Ybzg5SVNOZko3cm1vVGVVM0xnQU9t?=
 =?utf-8?B?ZjFzSGVGeFREVEhaNHZsRENGdVNYQXBMVndSaDE0QW5oRGdyejZ4QVRzQXpv?=
 =?utf-8?B?SGZuSkhpUEVRTzJCbklWbGVVRXlYN0dmMnB6RVV6enlkQlU5ZW5QRmtwcVFK?=
 =?utf-8?B?UHZzT3RjYmNIZTVhdmloaEc3ZGVxa05XQ2xhRTF0WitFU0IwMXkydmExc1pm?=
 =?utf-8?B?M1o2bmtKMER5OXZEeHdwTXVCMjhBY3gvTkZsd1B1VUFZZC9LTDJYOVBHTC83?=
 =?utf-8?B?ZDlkSG0rTHFKY3hoODE3ZXVaM05nSlpEWkRZZnlBeFJlR25SVzBheUZrTDUr?=
 =?utf-8?B?SFUySWNMc2paVTFQY0UxaFdqMVRYbTVqMUNpd3dCNTRLSkFxdER5ZFd2VC9y?=
 =?utf-8?B?cjBKTWI5SzR1aHdTN1d3UUNIL0ZJOGxaVmtna3Vjd2QzcHJ6aGc0dk5XWlk4?=
 =?utf-8?B?UDV0cW1sOG9NZW9FclhDbjBXZUYyeHRmMUVHZENzK3BtOHdNcHBOSi81akF6?=
 =?utf-8?B?S0VJNG9rNC9iUUxyV1dTU2JHalFwd1JUbjhvakdlNE45NDBQYW1maTJzWTdq?=
 =?utf-8?B?bk1ob3A1NWVweXlSeGVIS0NidzIxRDUzWWIwWGU3aEo2Qnd3a3dwMGNCTFVh?=
 =?utf-8?B?cTJFV0NwbEcwaEZ6Z3Y0MnJlUzZMNlZ4cVdOT1dqOStNT0ZMcWkrSEpyY0pt?=
 =?utf-8?B?SGFwd3kxMHpuR1dmcmV3NGlQd0h4VzNjbUkyUERmREtUQ1hNb3ZraUI4cktU?=
 =?utf-8?B?elg2UFFqZXEzNzgvMWh5M2U3citKMS9iS3V5VERlcnUvMjhaSUlFZm4ySU9B?=
 =?utf-8?B?dE5TR3ZDUmJWczA3U245OXR1ZlFwTnhiVXRka0c1RitOYVpKWmVFb3dlNWFF?=
 =?utf-8?B?N09YOGdwdWN3bHNpTmh3aEszRDVqNkhNbzhPclNwSExSUG9ZZ1YxUlJDUWt3?=
 =?utf-8?B?Vml5T2VQVzFSMmtqYXFoUnVxRVlsMDZJSjQyOTJzM3ZtTHE3ZEdIVkUraTNr?=
 =?utf-8?B?NEp2WHFhbW9rVU5JTVppUGZmTWVDcnZPMjlDOUpDRXJmRnNzcHZLUmNjdXdD?=
 =?utf-8?B?SGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62AFE947E3B8AE4EBCBAC18AD9142617@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558efcb1-dbc2-47f4-855a-08db23387350
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2023 20:29:16.2229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Gy8BrakC1iSufM6jJrmqz3zS2ip8L6aSS6BANfxnArs6xQTAqFdWjDT5iZA8um3ye+M3Ggn3rFphshG+DcpXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB8906
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCBNYXIgMTIsIDIwMjMgYXQgMDg6NTE6NTVQTSArMDEwMCwgSG9yYXRpdSBWdWx0dXIg
d3JvdGU6DQo+IEFzIHRoZSBmdW5jdGlvbiBhbHdheXMgcmV0dXJucyAwIGNoYW5nZSB0aGUgcmV0
dXJuIHR5cGUgdG8gYmUNCj4gdm9pZCBpbnN0ZWFkIG9mIGludC4gSW4gdGhpcyB3YXkgYWxzbyBy
ZW1vdmUgYSB3cm9uZyBtZXNzYWdlDQo+IGluIGNhc2Ugb2YgZXJyb3Igd2hpY2ggd291bGQgbmV2
ZXIgaGFwcGVuLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSG9yYXRpdSBWdWx0dXIgPGhvcmF0aXUu
dnVsdHVyQG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJh
Z2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg==
