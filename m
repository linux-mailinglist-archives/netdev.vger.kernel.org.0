Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88A384AF14B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiBIMU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbiBIMTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:19:53 -0500
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10068.outbound.protection.outlook.com [40.107.1.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B2EE03AE79;
        Wed,  9 Feb 2022 04:10:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNHhuj3bWyDHd8or8qE8y/4bHDNJZtuDGghwgI7z2dwrLGOM3lO8rg9/wTh1wZvLAIG94J+rcs2whyKYuY0i+Jigj6XY/glVTmi9ZaNpkj46gRNzgRdJgnaFhTUVzFJFzBa9MUmFFf84YIVEU0sHLZ697u1dtf8tObK9rqYxLeh+esxAHPpyN3t6zlT9ETio6ofvSkKTBJsW1Z1kYogzxB9VtFs2IJfDsbEKRMbYyxZ+GkAg1Y6kycLKHcAad00prrHkaSBQns3p2W+2vuRD+6VllLOhC5+qinKbuIpKd1DNkB9fi5GaDqrBsbBbpJ9+XJ4np/CtqVqQqYiu7t7SJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hKFkq4vaA09DoKzaPFr2DkisT358/E98zztfkyu8PEk=;
 b=W3W7VDZwI3mh8YwZqHGMGi5w4NnNiVMWEweoxK+kqG9laIyrs2tOBLjOWlA7+g0EwL31YxgqdpSN3XIXiTCbL7SeH9g+RktetFNKtrpCfIrLqvB2ahg1MJvdomoiWQ4Io01JcAAD/5PIYYgVuTUdSCl2YWYhGX8A+0cWZnNtkx3jXahw20kIiF2rAnY6obN4E9SkHXFU9I+QNakJxca0pn1dmS66WR16NM10uqQuFHS9lqYXITVugznocdTu7o0QG3solPnFj1PFLXWiMFhUFamSgKdegJ59BTSQZbEvmNPKhXY4WzsPHz1+wGvLSiMlLHeNxonrG81TIxiqP/WDCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKFkq4vaA09DoKzaPFr2DkisT358/E98zztfkyu8PEk=;
 b=I7EDEDANkX8q8nkkpD7OnQGuhWXwcIcgjzGu7U7J62kmWXWeAPARL5S3LY4+eIk2Dk91YqxgonHvv12l9Xx2B4ZFFMb8e9q6VNv9AhqYyYVDBdQ4Qo9kRtIolKPQx2MQzoW3RvpbfBs7xzwdCRDGtfOB80IM9XEoulFd88uTvmI=
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by AM5PR0401MB2594.eurprd04.prod.outlook.com (2603:10a6:203:2e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 12:10:41 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::a012:8f08:e448:9f4a%3]) with mapi id 15.20.4975.011; Wed, 9 Feb 2022
 12:10:41 +0000
From:   Po Liu <po.liu@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: RE: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc
 function
Thread-Topic: [v1,net-next 3/3] net:enetc: enetc qos using the CBDR dma alloc
 function
Thread-Index: AQHYHXjzHIdRyLbZEUCY5PL+XVUC1KyLIJ1Q
Date:   Wed, 9 Feb 2022 12:10:41 +0000
Message-ID: <DBBPR04MB7818A5C49F93384F606EE128922E9@DBBPR04MB7818.eurprd04.prod.outlook.com>
References: <20220209054929.10266-1-po.liu@nxp.com>
 <20220209054929.10266-3-po.liu@nxp.com>
In-Reply-To: <20220209054929.10266-3-po.liu@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ccf9978-f314-44b3-bf25-08d9ebc53127
x-ms-traffictypediagnostic: AM5PR0401MB2594:EE_
x-microsoft-antispam-prvs: <AM5PR0401MB2594769ADB7648068978247A922E9@AM5PR0401MB2594.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vaMMDLF0evf1WJvtMNDDya/1YS3NF/AlBqRqIUE1/v9+UXVsZYLk4sWdOF45O3I1idWIGEwB9R1zq4KzhOBACMsBfTIl+WkaRQk28Tqr4dAfLrLCe9bP2e8+UM6mNYsA00eDjS5wFkWs8nNcwV2RI6vAxTZryQPZy6c3tN2DjxcMk+9yyi7LcGnz3gEBlwqPxgwq2pfCjK4EDnph+8+01WTregiWEt8ShCE6VUIWjL+hs0cjq4qYVNlAXWQrYwInZqkYfgPCbj9VBKu/ukNG5rKi8gwcNqmWaG9MySajYC7iUzqaOg2GM4v+/GMljMR/HpabwIqbp0BFh+jyHoCo1TQUxLRNdp3ey2DnWe6LSY5k0+e1dEl7hM38ZH33ebNsezVLOz1MuQzve51jXONjdR3jpd/4nvuajO7aBVENYmrjg55XbqhIXHJZDi5cBSmOmGIta8Vp+8zhWT4l0+2hnyNVz761iISHgEzsONsF2waI+IK2JooBNfSIvLa+VPucuR+FZr5fjCIG33l5QsJyuaMZ/6WMTPcNCpENpq/4ifAbmfvqvGAhlMUL2EOOGjtP7YNvu6vjS9N5o05fr5AgEMUu9si9k38i+PyQnCNjbv5/lKt0ywvpR9501zaREVZLFptT2FlnguwlwW7Gffap4dLl4QpSJFAIgugU9Hb5rY+V/Hn4ZsL3nBAWRcvbKwhxHzDMMoFLN8S3BNAKB/Qzbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(66946007)(8676002)(76116006)(4326008)(33656002)(38070700005)(64756008)(66446008)(66476007)(52536014)(122000001)(38100700002)(55016003)(5660300002)(8936002)(110136005)(6636002)(316002)(44832011)(2906002)(6506007)(9686003)(53546011)(7696005)(26005)(508600001)(186003)(83380400001)(71200400001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?dmxVa2xBeUR3emRmbXl2V3NJS3c0QXdoYnhCUnVJTEZLODlWeHNaUGxPOHJB?=
 =?gb2312?B?L1ZjbkkrZnZBWUlvRUczMEtKQjVTV3AxbTNsQWVWZlJKdEtwZjd1OHQyMVlY?=
 =?gb2312?B?bnJ3ZERJSTRsVnZ1T2xiaTVRdksrYUp4V1B1eitwUzFJbXB0eS8wdnl6TDgr?=
 =?gb2312?B?L05aSHFRcld6TkIxUUpoN0NuMUZSOXBTb3RqazV1czNwZ0RVMTZrUlJwZy9U?=
 =?gb2312?B?NTJNTFRPN2NaQ3BMT3IxUmJBMFpkeUNQL2ZlRGpGME1VamNHUFR3bE5Qajhw?=
 =?gb2312?B?VzJsWGVzQjhpMnhpb3VXMHB6WElVZFdkUVBjcFBLNHd0R2llZFFDUk80OUNt?=
 =?gb2312?B?Z1pwWmJLTmtjNXBuTVdBU1BtVUpMR0plaERmeWtFZW9VUktXY3lCb1lRaXl6?=
 =?gb2312?B?a1E5bDlOZTM3ako2YkpQR09oNVV3aWg5R094K1ExRlYvdGQ3WUFkeTVwWlpU?=
 =?gb2312?B?eEFqOXp2L2RMUmNXdnArQXhHOVc0WXFHbWJEYSs1ZktZSnZQQTFDRlFBL2Jt?=
 =?gb2312?B?c3ZzYWtXbWVKYnVlc01MRk9MYmcxTHhHencySEVuMnpRYkVXNE5sTlc4VEZt?=
 =?gb2312?B?b0ttOVh4a1RaYUxBR3JGcEhVcmpkMUNFNEJaNHJ4LzVacVpGVlA1MEhMYk9D?=
 =?gb2312?B?THVlTmdzQjkvak84TlF2TklSaU15aERGMnJEL0lQaEUyQXZHb2taU2o5eEZY?=
 =?gb2312?B?TVdCWEpSTVFWeUh2NlY5QnBlM1RvY2k0V08vS3ExSmR4cHhoRC9iaWtTTlBs?=
 =?gb2312?B?WWpGNytJWmpPU0N6WXUvcCtEZVRud0NoY2hTcWtJQUpKbkVlMjk4WXBWWlVq?=
 =?gb2312?B?UXg0Zkd5THB1bXYvN3VDSVcyQWR3VysrNHFHeUo5WmtOazE0dUhLbnBvODFK?=
 =?gb2312?B?eTcwYi8ySkVuWW1nUEYxYmZzSGh3KysvbFhOcDF6cEpUK3RTMTBWMDJ2cUlk?=
 =?gb2312?B?WUZWekFsblp2UU5XSzhKWWJQUDM0NEdtSk9NOFNTM2lCUjExY1hpc3B0Q29t?=
 =?gb2312?B?ZWt4a05SanlYcDRUUUlBNC9aN1cxa3E4VXhLYzYxaC9KekFUM010RFBKWnZ1?=
 =?gb2312?B?UktlUzR3U28rZGtGcW91OEpPS3l2NzFWSHJRcnUzby9kdFFyQVFLLy9GaUhU?=
 =?gb2312?B?U2wvcmkzSm9nSEg1R2ROVzJyVkcrSHh6eXBwTjJCMTFlM0ladjF6MEpvRkgx?=
 =?gb2312?B?cllKQ2ZkK1ZCcHlPTWY5eWgxdWxwYXA0eUdFMjc1RE1lazgwWmdmVEgvZWlC?=
 =?gb2312?B?aTY0S083NzA3bmlzaVRickI4WnNEUnljc0grdTFSVktuZFNPemN3Z2VZSTVI?=
 =?gb2312?B?MWZVN1RFSlN0RjFNMDVweU9SWER1U2FzVU44QllFUllpYzRncHNCUXpVQVB5?=
 =?gb2312?B?VDVONlpPTlJYbm1Wek85MXRhUm56QmFBY2VPZlh3clR3QUdPRVptNG40a0NB?=
 =?gb2312?B?WmZtUGcrVVJXWWNrNWt1bUh6NnRWcXAwdlZ1aGRVMTQxaXd4dTF3bUdFYmx0?=
 =?gb2312?B?OEJRSVVCcXNjYUVVTFkxTnlHeWpCck1raFFSZTYrZmZsdWhTaW00czJPeEJo?=
 =?gb2312?B?S2l2eFlWRHBGWDhjUVBzS0RvZnZhS3NzYlRjMkYrcUFKeU1OYlJVRnRDeVd3?=
 =?gb2312?B?TkpMSE0yNTVDQ1hmVkJ1QjUrUUlhMEhCZ3B4T0NxT3FFZDVCS1QzNEI4bWs5?=
 =?gb2312?B?a25oWnRLeUZ1QU5NK0dlSVhyU21aUXpiWkQ3WkxJa3RpUnNzaUtWVUpwN0Nj?=
 =?gb2312?B?NnMwMnBqVk9KQ1JxekpGRnhXaDk2K1NhYUpmVmsrcU4zWmRxRW8xTjRMbzRp?=
 =?gb2312?B?ejFEemd1blc1SExYNDZWOEZGSXhSS1FEaWlaUjhZN1V6UElrc0dkV0JrRHNq?=
 =?gb2312?B?enFmYTcvcURCSEc5cHBCaXl2NnhDRnloYlpveUpTTUpUbjk0R2JiQkVTS0pr?=
 =?gb2312?B?dXlSVFVmZHFmTUhXTTkxMTJzMW9Sdk50RmhvSkYydW1zaDFMSVhPR2VPSC9Z?=
 =?gb2312?B?dk5zOGhObzMwbGpwK055ZVNxUUNxcmI5ZjM0UUVKZm9pZmIyeXFiS3YwKzZV?=
 =?gb2312?B?cVFXYmgyc2U0a0Jjc0xQTlJka1JBTURPTVVqUT09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ccf9978-f314-44b3-bf25-08d9ebc53127
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 12:10:41.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 73Yure+0VWgSVl1+ettoePN1pMW2x0LWtqmlE6rsj1QezMZW2/YFd9TzJ4Zd2dWd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2594
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFBvIExpdSA8cG8ubGl1QG54
cC5jb20+DQo+IFNlbnQ6IDIwMjLE6jLUwjnI1SAxMzo0OQ0KPiBUbzogZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldDsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsgdGltLmdhcmRuZXJAY2Fub25pY2FsLmNvbTsga3ViYUBrZXJuZWwub3JnOw0KPiBDbGF1
ZGl1IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IFZsYWRpbWlyIE9sdGVhbg0KPiA8
dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IENjOiBYaWFvbGlhbmcgWWFuZyA8eGlhb2xpYW5n
LnlhbmdfMUBueHAuY29tPjsgUG8gTGl1IDxwby5saXVAbnhwLmNvbT4NCj4gU3ViamVjdDogW3Yx
LG5ldC1uZXh0IDMvM10gbmV0OmVuZXRjOiBlbmV0YyBxb3MgdXNpbmcgdGhlIENCRFIgZG1hIGFs
bG9jDQo+IGZ1bmN0aW9uDQo+IA0KPiBOb3cgd2UgY2FuIHVzZSB0aGUgZW5ldGNfY2JkX2FsbG9j
X2RhdGFfbWVtKCkgdG8gcmVwbGFjZSBjb21wbGljYXRlZA0KPiBETUEgZGF0YSBhbGxvYyBtZXRo
b2QgYW5kIENCRFIgbWVtb3J5IGJhc2ljIHNldGluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFBv
IExpdSA8cG8ubGl1QG54cC5jb20+DQo+IC0tLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9mcmVlc2Nh
bGUvZW5ldGMvZW5ldGNfcW9zLmMgIHwgOTEgKysrKystLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDcwIGRlbGV0aW9ucygtKQ0KPiANCj4gDQo+ICAJ
bWVtc2V0KHNpX2RhdGEsIDAsIGRhdGFfc2l6ZSk7DQo+IA0KPiAtCWNiZC5sZW5ndGggPSBjcHVf
dG9fbGUxNihkYXRhX3NpemUpOw0KPiAtDQo+IC0JY2JkLmFkZHJbMF0gPSBjcHVfdG9fbGUzMihs
b3dlcl8zMl9iaXRzKGRtYV9hbGlnbikpOw0KPiAtCWNiZC5hZGRyWzFdID0gY3B1X3RvX2xlMzIo
dXBwZXJfMzJfYml0cyhkbWFfYWxpZ24pKTsNCj4gLQ0KDQpTb3JyeSwgZm91bmQgdGhlcmUgaXMg
aGFyZHdhcmUgc2V0dGluZyBidWcgaGVyZS4gV2lsbCB1cGRhdGUgc29vbiBmb3IgdjIuDQoNCj4g
IAkvKiBWSURNIGRlZmF1bHQgdG8gYmUgMS4NCj4gIAkgKiBWSUQgTWF0Y2guIElmIHNldCAoYjEp
IHRoZW4gdGhlIFZJRCBtdXN0IG1hdGNoLCBvdGhlcndpc2UNCj4gIAkgKiBhbnkgVklEIGlzIGNv
bnNpZGVyZWQgYSBtYXRjaC4gVklETSBzZXR0aW5nIGlzIG9ubHkgdXNlZCBAQCAtNTYyLDgNCj4g
KzUzNyw3IEBAIHN0YXRpYyBpbnQgZW5ldGNfc3RyZWFtaWRfaHdfc2V0KHN0cnVjdCBlbmV0Y19u
ZGV2X3ByaXYgKnByaXYsDQoNCg==
