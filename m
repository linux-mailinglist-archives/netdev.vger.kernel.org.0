Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2A1652B0E
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 02:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiLUBkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 20:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiLUBkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 20:40:00 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060.outbound.protection.outlook.com [40.107.21.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A39C19C14;
        Tue, 20 Dec 2022 17:39:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sq4uO0qmOFfVjErbznjtSG3H0jjJu/Dx6OhF4LpDhIWu9ZXvMXhAZVNDboQGQv+y7xoizWPqVupPFodNCoEk29s3VVgyPbq27QuuTqse//dIas/q4sK+4hobGuDN++S3pnFYshbXAfIJPj1nd+rI4ordhDhkwU70JOeMhzjYaulyEDrtvbqpNeAxRRHj6Nym5gI08jFaZoQblSvXutmdquPqYov7KG3kmN3zSOyPAk3tRox+rU/NTz50k3ExM0Zd9d4MCzuxBUA1E38K5ungUgcjfYvGtfeqK0x7s8aUZF05TO0ai/ptYp6aV4O11r4EGwtazrV5j9MrdsXlDhk5Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjkT2Lbnw8s0zE04XMUHfIHfXaTNkaD1l23KtVR7bv8=;
 b=n8Egu6m7DeZrlFo+9AFd3G9Oxvq3P3s8IclvGHGqW5rWUh49fby4DmKOUz+eGCx83nQbweBJUmhcWhFD/cv5vfDvKzZhy2DVuza/QAv5mM1WbsiBAVI+IIlmFAgU6AsMmGbZfkZ9Iie7/0tjVeSgNCzDDdz9hkHbIOncW8CvrTLVDKp4Gkz6Eoip+lQQgck96tDbgPDVifSPL6fiP1uy1DhMUWOZKulnGM8Idtc1/AncEOleWuzRh2sIp0xyrgMGBXiTSGIw7BoiBmBzwq/jIM+tIPnlwmK289xSkKj/U5vPTo7vSb46Ahr7YGiVS1m5VI5Tn99Ud/Dguh44lvpyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjkT2Lbnw8s0zE04XMUHfIHfXaTNkaD1l23KtVR7bv8=;
 b=rafmqWbCfqkhpaNVyQX7wsHpeHG1K5gyBe2r3yo/sHUR291jmcUpMBNBmw2aK8uy48O0vgqrD9xCgFnlu3i+E8cuzJNgqQsBGFGA5lB7f8gSc6Jd9/Ltp3vlSNU01C2LqjY+XZFeDGnVUVFDY+GujYaXexfEVNI/fqnD3hixHhU=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by DBBPR04MB7691.eurprd04.prod.outlook.com (2603:10a6:10:201::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 01:39:55 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::e9c1:3e78:4fc8:9b24%8]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 01:39:55 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net] net: fec: Coverity issue: Dereference null return
 value
Thread-Topic: [PATCH V2 net] net: fec: Coverity issue: Dereference null return
 value
Thread-Index: AQHZE1H7bfz+bT/FtEivuVfzL8ETM653LfsAgABg2UA=
Date:   Wed, 21 Dec 2022 01:39:55 +0000
Message-ID: <DB9PR04MB81065D13CA5FA737EDA4E55B88EB9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20221219022755.1047573-1-wei.fang@nxp.com>
 <20221220113610.77a11f25@kernel.org>
In-Reply-To: <20221220113610.77a11f25@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|DBBPR04MB7691:EE_
x-ms-office365-filtering-correlation-id: 32911ad9-6bd6-45fa-4841-08dae2f4434b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gAhApP1nmuSNQNNB/o+jOS9iVU6GuPyk+WnAStmFTR47sL8I1SjlVjUl0Yo72UT88SWhfg7aDJfHjwpISHbCpEQDHkFYrygZrg5knnmt7MrPXJZLjNRfJSNdE81S5F2XBmo0WFprRSEk2spVMjAcbO3pBiYE/2EFEzhUCCztWOy0/IREdhUVQAGSnbT3gbzHs+PLrPKei68Ro3ovePwmL36RcyPOCPkRcw9urzz6zP8jlT0vv0cg3CUClVmwKBIrwKGkuzr1DPhLJhYUUUZC91hZcrhQLj9oz0sQiqeulX6cBZmmG6GzYW6kYjy+7UUoYVhTXSK/VKHR6DENI+OLmZdxxp5IhmyM7xQTUP58v0aHpMjOTPIQyOeTyGSIuphCp0nojN9VK093B8OoIYfXgX7hlEenqkEysnfkKm3giRy6PMHiMuRql1UIdFreHPvTIJk5BjSWJY796rhtNES9R1204a/pygnTUgAB5IheBVPS+dSYXBzwdCHWjMRz7VhbwlvMgYJvCZhjZGzjeiKTfE3q6Ul++vH54xIZP5dy/ye+d1xJh9KzChc8EYJ7aQZ04CRPmkHzmMBFrQP3PCBITWBGAflOP0txKztPF26f5Ujt2Bdk2l4D1HAFSIemP36sPZlTH2TFe9zD7xLmyZjr+RhHUDcN8Xq0MFprwboHONn6KQM93tX7FltBDp6mUQ56FCMejSHXzno1IGnYS2NGSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199015)(66476007)(8676002)(66556008)(316002)(76116006)(55016003)(66446008)(4326008)(66946007)(64756008)(8936002)(83380400001)(52536014)(41300700001)(38070700005)(5660300002)(7696005)(33656002)(6506007)(478600001)(71200400001)(6916009)(9686003)(53546011)(26005)(54906003)(86362001)(186003)(2906002)(38100700002)(122000001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?amh3RkJManpxVThoQmJ5QWl5dVplSHZzbWs5UitQZkNWWFF1bTRiL0FPSWk2?=
 =?gb2312?B?ekdEU0NxK3Z2ZUlWTVd5NVg3WGkrSUVHcDZJVm55THM0OXBMaDgyRitZRm11?=
 =?gb2312?B?NE5QV21abFErNFR3blRIYWppMThMTElCYU5YVjBFMGNxOXl2RGhhR3BUZHVa?=
 =?gb2312?B?blovRURwNEFpcEUwcWJHUU5qNy9JWFUyWCt1ZFE1dGlkSFQyanRjM244SmpE?=
 =?gb2312?B?U0tqQnJ5Ykp4UHZIYW1ac1RnY1c4cU5NaTBueWRHODlZeHRFeENOOVFrdWdv?=
 =?gb2312?B?YkFmMllFZlIvdTdZWVBYdm5CTjg2Znd2dHBYS2MwRWVXMUMwalg5c2ErYnZL?=
 =?gb2312?B?UTlPQmo3MGhYZWRwbVpXa09nK2N2eldOZGFaTzVuSnl6d29uTmt2MVJhTVA2?=
 =?gb2312?B?V1Z2UFdnNFRZQnJkeGdnTkpmK2VSVlFXd0sxUk9NR29XTmhpd3NVcDhOaTVE?=
 =?gb2312?B?YmQ5dGtZa1VqYko1MnhKZ1A3Vkx1RjRaSnNxdFZjRWJRTTljSUZ2ZlJhKyt2?=
 =?gb2312?B?d2tCVTR2S2cwTWNhTlJXWHR6OGVxLzRUQk8xdGdoL0hKKzBvS25keC9YVjMw?=
 =?gb2312?B?Q0R3Zk00S0ZTSHVtTUQ1SXRQR0VTZG16amlNNXJZY3FzUUZHRXprWjFjd0dl?=
 =?gb2312?B?T0Zyc1JjaU5hSVpUK1ZDd2JjTEkyc3FKMWgwZWdaaEttSGRNTkdwWlNaZ0FQ?=
 =?gb2312?B?SWk0bFBJa3h1OTNieFZBOGNGbzdvM1dvVWVxajI5QStLdDZtUmNBeGpNQUNP?=
 =?gb2312?B?eUdYRXhrNytHWVZ3Sk80bWg4emlaYzRueTMyTWFBWkNtQWFiVy9BQ2tOMEQx?=
 =?gb2312?B?eVFLc0JyL0hnYjBGQXNHamw1YWxCeG1Zc0ZFZXZ0a1RzVTY3T0VNOTJJdWdl?=
 =?gb2312?B?T1gwWWFzTDVvSDlyTEdwM3ZrMndyOWpYMFBTd3hKTTFUeVNsMGN4VkpBUmdI?=
 =?gb2312?B?d1BGL3hMOWdNQnEzRE5wWEw1bjlZVHFPdGwxN1lpbDNKOXlGSHk5UDZFKzBj?=
 =?gb2312?B?NDVhK3RjN1VXeDNSZUFXVjRBd3FSZ21nUTg4VWgwYjhvNjFsL2RRNmdKKzVC?=
 =?gb2312?B?T3huNmhJcWVQVjhvNkJDRzNITXZ4bFZNbzFhQ3VWZnZ2alllS1dMekNXc2pV?=
 =?gb2312?B?cWN1MldYSWNSNVNXcWNKTTlWd2trRmFoZkg3SGdqRmV4ckhMa3lrUXRXR2s0?=
 =?gb2312?B?TkViZjkwbUQ1UzZaRFI2dmo0a3lVdTFBaW1wZHhUQjFVbnVZQUJvdHp3VFZY?=
 =?gb2312?B?VmVLUU5QNjlmZ0Z3RzZueWFDU2kwcnp1aFdpclRNaklzeC9BbEh5dXVwT2pD?=
 =?gb2312?B?a3Y1Sk00bzlCblFCSTh3MU8xTHhwZ1NiRjRwZDZxbGJqYkxlUTZUSHNoWVQ1?=
 =?gb2312?B?MzJmVzNlbDc5RGdiZkp1NlM1V1I2QnhwYnBaZFg3Ui9tTElzeVRiNGFrYWc1?=
 =?gb2312?B?MlBRMThDa0tkSmJFcDhFamVhUnVXQWxwRzI1SklUaFA5RU5mdEFmLy85ckxj?=
 =?gb2312?B?c3BxTmM4SzVzS2hibUZVZUpPVm5OS1FjOW0rTG93YzkrQVpnS2o5WVppL3Fo?=
 =?gb2312?B?Vy9xbnI3ODk3NWN6cDV2Qi9ldDdLZGxVWE9pR2hTbnNnbnBJbGFOUCtkdGgy?=
 =?gb2312?B?UXM5d2tOVkI2ME5vYXk2b0g5QitFVksvRXNzNGMrb1NyWDdDTjg2dVJ6SnRr?=
 =?gb2312?B?VlU2empNMGUwMkJGUkI3eW9QOHZpeFFjdFhNQ0hMcXhNdm1Ud1FIeks0T0Jj?=
 =?gb2312?B?eEtFVDRYQTFrL0FIQzYyLzZHWHNnSENkdEdqalFESGZCejJFekp1cENmN3Jt?=
 =?gb2312?B?ZDlHMVozV0tOYWJxbnN4aWswTy9KS1RmTzFaWGgvWHJINmJVK0ZjeFViTXVG?=
 =?gb2312?B?YVRwd29WMGsydzdHNFhsY2p3VjFMTWg0ZHJvQjM4QWYvdFRFalpKdEZrSTIy?=
 =?gb2312?B?RThydHJ1d0VwTXhMZDh2UE1Yczh0aGp5L0gzaVltMlVTL2YxcXdtSlNjQVZB?=
 =?gb2312?B?eUk2Vm1CZWwxd1d5cVNSNm1JT2d1dU9odkU1N0xlZ2lodnZhQmxzbXZReTdO?=
 =?gb2312?B?WGhaOEZrQ1piNGMyQ0UxL0NyeUdsNnV6aGVhaklHLzV4NjgvOU12S1VYSzNF?=
 =?gb2312?Q?R8K8=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32911ad9-6bd6-45fa-4841-08dae2f4434b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2022 01:39:55.4939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8vOsNfYqheMChE++QxmmJAiUgG0nYm6ZZE3HH3cyOkFK5d6d9Gim7e6anopttqRXwC4KHFYlrTXGsJnC7A6oYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7691
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjLE6jEy1MIyMcjVIDM6MzYNCj4gVG86IFdlaSBG
YW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6
ZXRAZ29vZ2xlLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207DQo+IENsYXJrIFdhbmcgPHhpYW9uaW5n
LndhbmdAbnhwLmNvbT47IFNoZW53ZWkgV2FuZw0KPiA8c2hlbndlaS53YW5nQG54cC5jb20+OyBh
bGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tOyBkbC1saW51eC1pbXgNCj4gPGxpbnV4LWlteEBueHAu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIG5ldF0gbmV0OiBmZWM6IENvdmVyaXR5IGlzc3Vl
OiBEZXJlZmVyZW5jZSBudWxsIHJldHVybg0KPiB2YWx1ZQ0KPiANCj4gT24gTW9uLCAxOSBEZWMg
MjAyMiAxMDoyNzo1NSArMDgwMCB3ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0KPiA+IEZyb206IFdl
aSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+DQo+ID4gVGhlIGJ1aWxkX3NrYiBtaWdodCBy
ZXR1cm4gYSBudWxsIHBvaW50ZXIgYnV0IHRoZXJlIGlzIG5vIGNoZWNrIG9uIHRoZQ0KPiA+IHJl
dHVybiB2YWx1ZSBpbiB0aGUgZmVjX2VuZXRfcnhfcXVldWUoKS4gU28gYSBudWxsIHBvaW50ZXIg
ZGVyZWZlcmVuY2UNCj4gPiBtaWdodCBvY2N1ci4gVG8gYXZvaWQgdGhpcywgd2UgY2hlY2sgdGhl
IHJldHVybiB2YWx1ZSBvZiBidWlsZF9za2IuIElmDQo+ID4gdGhlIHJldHVybiB2YWx1ZSBpcyBh
IG51bGwgcG9pbnRlciwgdGhlIGRyaXZlciB3aWxsIHJlY3ljbGUgdGhlIHBhZ2UNCj4gPiBhbmQg
dXBkYXRlIHRoZSBzdGF0aXN0aWMgb2YgbmRldi4gVGhlbiBqdW1wIHRvIHJ4X3Byb2Nlc3Npbmdf
ZG9uZSB0bw0KPiA+IGNsZWFyIHRoZSBzdGF0dXMgZmxhZ3Mgb2YgdGhlIEJEIHNvIHRoYXQgdGhl
IGhhcmR3YXJlIGNhbiByZWN5Y2xlIHRoZSBCRC4NCj4gDQo+IEFwcGxpZWQgYnV0IEkgaGFkIHRv
IGNoYW5nZSB0aGUgc3ViamVjdCBiZWNhdXNlIHRoZSBzdWJqZWN0IHNob3VsZCBkZXNjcmliZQ0K
PiB0aGUgY2hhbmdlLiBNZW50aW9uaW5nIHRoZSB0b29sIHdoaWNoIGZvdW5kIHRoZSBwcm9ibGVt
IGJlbG9uZ3MgaW4gdGhlIGJvZHkNCj4gb2YgdGhlIG1lc3NhZ2UuDQoNClRoYW5rcyBmb3IgdGFr
aW5nIHRoZSB0aW1lIHRvIG1ha2UgdGhlc2UgY2hhbmdlcywgSSdsbCBrZWVwIHRoZXNlIHRoaW5n
cyBpbiBtaW5kDQpuZXh0IHRpbWUuDQo=
