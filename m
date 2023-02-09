Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0477C690140
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBIH2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjBIH2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:28:06 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EAD8274B9;
        Wed,  8 Feb 2023 23:28:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aY21znbWdra8Rd53AxaqhSnJp2TEwA+WQI21CuDA4JsK6m2GbRA7AUHTuJDM6yfzo2tziCi3n7ZCP+22jmKfx+ZHvV/jEvT456S8v08qQjPGc1y9L2URmSl35f2kg68dv4lJkMIkoa2eBG2L78HwKyBgZ0u8VwJfnzyA9lYWLs+gYeObr8Vailq6h8a6I1Ky7XSYUnT6fPOnAk9BItyYa4iVY8x5/HsDfGDdnLypfZrH07lyabwdn0v2CNWGWuEs0w9vPsnOb/2VOmtzlbfL5D5NZLiKqFgEEiMJDupMQ1Kl/0Zg4r/UbOx2t0U1BEGr9FlBvtSDmz62PzxqLPjGjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSi6SRfd8LA2k6mCOy1c7umCwbFZZGqAZpru0FeWdqU=;
 b=hOWwpX+Gzbg21+9foVgZIOW3ViuYIzXjq5nETEZx2PFzljYCEOxF4QUZM8NrJJthz/HTiFyBEioTQf5XVY6KRg7qmjv4e/vVALhNvhoxbosvJvRm1ZRUgJk+/W9mJjLH03HQRaaQnG03LIni+koXvFNK+m/DRscep+NMXXVZmJXoq+pq7uMQ/DainpyL86ZgHXqaq0G3Y72O7x+1C8/MK6JhUv54eVzd7w2uefgiGiYz5ZddEo598aohE8zXGUK3JgDBrF4ZtZ/DKM8MDOAf2oHuGQwhUSZiCr/9JfDyrtsNXYE/Y7bJPW8Pjkc0OyFYl3wCRDbWT5HoupU/rilMTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSi6SRfd8LA2k6mCOy1c7umCwbFZZGqAZpru0FeWdqU=;
 b=uZUsQNGCGyePIy9QRH5vOXZjFbLSJyGeMYrQokD0k+QREGR4qPLongjsC/dH1YidO57djATzcTBnGMxFfkXIRhzbr9/Xmb0T7SXv3O+wY9U4OixPAgenMKrOAKQUYwNmvQqbySFwfVNw/KICzUVdBPCTK/XJywW0Buk1bFWWOz1xatlKbSi1OvfB0g42qY+JwqujS934izjyc/w+e5vzqHdRZW6jgJbo+h0jVeNPiDyhmzsGoMAxXoSJDiWnU9XE+rp2hme80d+q4Zm9qsEIuegDAyRHmR7dzrb0PhjK3fDjpBOhlseWTW/gfN6Tu8PwqAt+zyeRFQsCDE+gdYbyig==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by DB9PR10MB6668.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3d0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 07:27:59 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::41bf:a704:622e:df0d%4]) with mapi id 15.20.6064.034; Thu, 9 Feb 2023
 07:27:59 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "wei.fang@nxp.com" <wei.fang@nxp.com>,
        "xiaoning.wang@nxp.com" <xiaoning.wang@nxp.com>,
        "shenwei.wang@nxp.com" <shenwei.wang@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Topic: [PATCH] net: fec: Defer probe if other FEC has deferred MDIO
Thread-Index: AQHZO6axGn/PBMQQZUCM4xDb48lCTa7FyycAgABtnAA=
Date:   Thu, 9 Feb 2023 07:27:59 +0000
Message-ID: <9a520aac82f90b222c72c3a7e08fdbdb68d2d2f6.camel@siemens.com>
References: <20230208101821.871269-1-alexander.sverdlin@siemens.com>
         <Y+REjDdjHkv4g45o@lunn.ch>
In-Reply-To: <Y+REjDdjHkv4g45o@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|DB9PR10MB6668:EE_
x-ms-office365-filtering-correlation-id: 4d8e76a8-e2e2-4d07-2ecb-08db0a6f2bc8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lcg1Nb+Yx0j1jJHikZ3ygmSRYYgWrYT1EsYJXXoc/tfKzgvaRO6NawSteMhw3kWOhuFCF9AfezZPzClquo9oKRI8WQOUdCvtxEDf9VFvUBd724UWjiPQApO2W/tbWjDHVpWrwQvPtukbOKWITV8iV5UNXKZdTdpOzaWcSz2WKiah4KNlCXHbh8agp3w90hgH5rTaejE8FFdfX4iXBFWrfuL99AgoGnST8Bg7ZaF3DCn7YJpKqkyNg8cxY8BrkJw0qYanur2oUbVCAUS5fTqCfBo3eiP9xmgrVx4/Rcn6aCgywcn2ZYNGfEc5g/K8P/J6Xh5frsgKIfdcspeZtbP2jgMOvCtECye+/1QXu9QNpFZ+d+voAMmVF1xjb0sRiIw5XFfmkTzn5yC4Mzk3Lc5pePRcPPrLouboz2KNtgO0C8sLurzpCDlHFgJRYsVYkKiSaGJ6b2Jj5iNo+6OIBoJYIAzYT6kCEJp66MEKg487xT4oZk5XYKw8F3ypfwYU+5qzbFj8EGlBZlcLlzzb3OIrlbYJC0xguKz3kEaxhVMv1ylkBMpJYk7WOl+MoWyguo3SW9K5nAJOz+qCklNsRX4YyRf3OZhti2S7gvHQr2Uu286IHHlB9Mdilvth0d76si2hGzWuEYfqxCh8/d4cZwbMQ4gTw6M1Xhjn4m03GYPrrdgohGh50aNEacmqwLWKulOv8aSyUdQFm810/6dL6JQml09T+cH65TjQClOnpYBP2SXES1jWypJg0SlUvMcz/It+kLcnA8lml2jfMKWoMFwMZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(366004)(39860400002)(376002)(136003)(451199018)(6486002)(38100700002)(4326008)(4744005)(6916009)(2616005)(478600001)(71200400001)(54906003)(316002)(41300700001)(91956017)(86362001)(66556008)(64756008)(8676002)(15974865002)(38070700005)(66446008)(66946007)(66476007)(76116006)(8936002)(5660300002)(82960400001)(36756003)(2906002)(6506007)(55236004)(6512007)(26005)(186003)(122000001)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzI2LzNpbWRHRjFsdFlFaHNXR2RaWkJWS004QUFOZVNBYWF0Szh3WVNLVlRJ?=
 =?utf-8?B?VmlIRHVVR0xUTFB0dUJ0Vy93ZXhGbzAzMCt1U0c4VDJZVXRXNWhBYXd5TGdW?=
 =?utf-8?B?clRrcmtyVnorYjVVOGxaaTY1YTAxaENpRUVKUkNaSVZBMVNBdFVObjQ2Y2xD?=
 =?utf-8?B?SlpmQTNjQnpTYVo4YWhRRmtkSGRUVHgzOXZTUmZxVjIxVGNSTWp4Z3ZaaGQ0?=
 =?utf-8?B?WkV5SlIvU2dvN1d5cVlGTTVHeFlUYzRLeVU1QVN1RVhRWkQzUXZqWDN0SnM3?=
 =?utf-8?B?VkJuM09aeTc0WGV0eXpkaWhkL3owUXlxbS9ZUjlkK3V5Vmtkb3NmYnArQzFK?=
 =?utf-8?B?SHNmTUd5Rzh0UVl6ZVYxVVR6elZqek1BQWxESTJ1WEdaaHA0VzVRWFVWMENa?=
 =?utf-8?B?bFlVWXlKbTlUTVdRRTMwTFZWQng2TFhTSWFiSUlLZ2kybjRkTm9SL1NqaThl?=
 =?utf-8?B?aUdXeDEzYmo0YktMc1NKS2t3T081VkQybVZRVHR1RFhZdEx2UXo4eGhBVENG?=
 =?utf-8?B?R3R2MEptbkpVSHhpY2Q0OXVjaDBqV2wzNU9YblZScUVVcUlwRTk5Q1FuVGc2?=
 =?utf-8?B?bjllOGVHTzQ5RmQ1TnpoSUFwa0xMeVJUZTFIc3JDbWdHK1AzQ2ZXWnNWZmo3?=
 =?utf-8?B?cWJKdTMwdmEza1gxb1JvaFdrQkE3Y1FySkRLQThBWkdoaUN3YmkvOXBoUjN2?=
 =?utf-8?B?bm4xeHpHT3VZRjZvWkgzSTl4a1dkZWpmZGx4MnNqUnR2T3NRT00rTmVWRXo0?=
 =?utf-8?B?Mk53dlJLS0Rad0t4bVY2WHFWd1F2cXQxdFNuenlRdzBuaWZkeitWY3F2NWdp?=
 =?utf-8?B?WFlvc3pRUEh0aWZLbEZzdXdoSlBxT2tmYzA1TElLZGo1TkF6WmdEM3djSXpj?=
 =?utf-8?B?TjFDWHdwZEpOWjl6bmZ0WXNsNldnTVlUd09VUVJoT0JtQmc3UVBlNVUvUSti?=
 =?utf-8?B?NktPbUxvd0lkZkNYTVZTVWFGemw4NG1xVnc2Z28rRmJoNU41a2l2YWNQekJF?=
 =?utf-8?B?ZVNDTEk4RnRIK0huSE5BR2dpTmVWZzF6QVlrU2ZWc3BwNjJNZUwxUk94VXdn?=
 =?utf-8?B?L2ZLZ0JqUUZFbHVKY0VqblgySzJQVEdvQWxrcVdUWlF3TUVCMkRrb0RZRk1q?=
 =?utf-8?B?cGxNNTF0RjY3ZUMxR2o5eGdJdlU2cDRNQ1RoRDhzZ01QQmduV2Q2NGpVMkdO?=
 =?utf-8?B?M1VtM0NzcFp6ZThLbWJmdmhsMy85a2FLNlViWkhEYUF0dDFOUTZTRktvbTND?=
 =?utf-8?B?NTdsa3BCWWRYa255KzhMNVRXbjNqMG9wMC9qUHBuV2JTam5yUmRTVGFVRWFH?=
 =?utf-8?B?SkhSaW5vQitRYWlkdDhjNzVld0MvUDc0QUs5WnhMOXVuOTlkN3hTTExlaktx?=
 =?utf-8?B?QkVWUVd2M1V5ekg5cHJrWTBibTdDQ3hHMHJodC8reDBBSlFlaGpDeDVPQi8x?=
 =?utf-8?B?OXI0K0dWMkVPMGIrMzFHUURienhPR3JubFpKTjhiNVEya05qUXFQVkx3ZTFQ?=
 =?utf-8?B?NysrNVpOTUNNeHBueDcwUXh0V1hmaHo4Mm91d1k3RmhjM2J6ZHN1MXpOSUdu?=
 =?utf-8?B?ejhxRTNNOEdYd2pkTHJPTGNtZGJOK08wLzF4dDdScEpVekY3VzN3cXNRZGtn?=
 =?utf-8?B?R21EMko5YVR0M1plQlM4WUZOdGNCMVVrbXNZMHc0SW1HQUI3OERKTWsyUkdT?=
 =?utf-8?B?dERtU0FTV1lCeDRPaE5wQy9Gay9xbEtheUEvVU0zN1dTdjV5R2xIR2tBaWk2?=
 =?utf-8?B?TkovMzBBbFl5bVB5bHlOL2JaeldQTFk0QzVZdVpYd1dpdGNLTnFRYUw2bXN2?=
 =?utf-8?B?Mlc5MDlFV1d1VXVwSDZBbllvcW9rQTg5QjBOZmdGbk5tSVErb1BQcTVsblhB?=
 =?utf-8?B?RWpzTFUvZnN3ajRrblo4WS9XUitvM3lyV05lZlFWcFEwZjNiNjRuL0xFVm9I?=
 =?utf-8?B?MGxBWUVCak9XdVRWWlQ5ZFZMditsY204N016V2RiVDBvMFlFTTdYalJrUExY?=
 =?utf-8?B?WnVlUm1aNUNhaVhBdDRVZ0lpb1FsYmdTSkEwdzF4ZzE2S1l0Wm1nYU41K3BI?=
 =?utf-8?B?UnowT1dyWEpIMWtnTHhhbHIrWUx0bDdQTUZVWHRXNDBWdllHdU5aN2pvUW9k?=
 =?utf-8?B?b2R1UUlsbUQrOTFRQ0RjMURJMmQ5Qnl1Y2dtRFh4TW5pcVN0SjBJaE9zUExH?=
 =?utf-8?Q?1aPiRKzC8fFzaQU+uqJlsfQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9794573A1916EB44B707E0641C54BB95@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d8e76a8-e2e2-4d07-2ecb-08db0a6f2bc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 07:27:59.4619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53NuYwPbckuhl55ET9+lxnf3LefRQq6l1kYxFIn0t7tiawH7lf+kP2iQDRE7bPFdbG5i5aDZUmO5AHK4DkwUfmt9WAmHBOSLl1jc+jyZCao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR10MB6668
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gQW5kcmV3LAoKT24gVGh1LCAyMDIzLTAyLTA5IGF0IDAxOjU1ICswMTAwLCBBbmRyZXcg
THVubiB3cm90ZToKPiA+IC3CoMKgwqDCoMKgwqDCoGlmICgoZmVwLT5xdWlya3MgJiBGRUNfUVVJ
UktfU0lOR0xFX01ESU8pICYmIGZlcC0+ZGV2X2lkID4KPiA+IDApIHsKPiA+ICvCoMKgwqDCoMKg
wqDCoGlmIChmZXAtPnF1aXJrcyAmIEZFQ19RVUlSS19TSU5HTEVfTURJTykgewo+ID4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBmZWMxIHVzZXMgZmVjMCBtaWlfYnVzICovCj4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChtaWlfY250ICYmIGZlYzBfbWlp
X2J1cykgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZmVwLT5taWlfYnVzID0gZmVjMF9taWlfYnVzOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbWlpX2NudCsrOwo+ID4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDA7Cj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gLUVOT0VOVDsKPiAKPiBDb3VsZCB5b3Ugbm90IGFkZCBhbiBlbHNlIGNsYXVzZSBo
ZXJlPyByZXR1cm4gLUVQUk9CRV9ERUZGRVI/Cj4gCj4gQmFzaWNhbGx5LCBpZiBmZWMwIGhhcyBu
b3QgcHJvYmVkLCBkZWZmZXIgdGhlIHByb2Jpbmcgb2YgZmVjMT8KCndlIGRvIGhhdmUgYSBjb25m
aWd1cmF0aW9uIHdpdGggaS5NWDggd2hlcmUgd2UgaGF2ZSBvbmx5IGZlYzIgZW5hYmxlZAooYW5k
IGhhcyBtZGlvIG5vZGUpLgpJJ20gbm90IHN1cmUgaWYgaXQgd2FzIHRob3VnaHQgb2YgYnkgZmVj
IGRyaXZlciBkZXZlbG9wZXJzIChpdCBtYWtlcwphIGxvdCBvZiBub24tb2J2aW91cyBhc3N1bXRp
b25zKSwgYnV0IHRoYXQncyBob3cgaXQgd29ya3Mgbm93LiAKCi0tIApBbGV4YW5kZXIgU3ZlcmRs
aW4KU2llbWVucyBBRwp3d3cuc2llbWVucy5jb20K
