Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D984952E1FF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344503AbiETBcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244784AbiETBcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:32:53 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2118.outbound.protection.outlook.com [40.107.117.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A99AE62;
        Thu, 19 May 2022 18:32:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+BG9GAkmayG0BavPT1cviwaOj58ZcBcKcD9lW9TkA2j2TcXlFkLIIGvBHz48pTZ9knnhojl3/8U5alCjT3gfy6NWYi+6JcbZvwDA+O1i1QBYQmVQSO1Ggi5eU2cHRWaIYE37dV7cBFpKsBeh/UQB2DGvCU9B69HAyGiI6if3I1pGH93QjY4sRWA4izHMV8Quiv+TKXhI26a5ulzsY8kboIOA/gS7te0Wrz2S1A4k/0KSREmox96e2FWQsZRth2yjx4XCYdGbo1LJQdtidIAS3rGY+mm3eYDETYHT4TgQtElKDxfo2C7i4F3QO5CjpUInYtiAKXx5oGJQqWENoZjqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MyFlSWzlvdTUJ9cMwaeyW8c7lk6mo8wQYVZ7jQ5lWQ=;
 b=W91JISL+zjHixoAEOXw2H2l4ny0fFxyi1PoDcO3fxF/EyHd1ayb7rptmSpLlsczugDGgaeaEoXEmr3Pa9/AZxvHlsbltSBS+7L1w2PxkkHdJJWSqJTfdF9qjzpPBnUYu6aTwx7920LaWsTh5dbKwHXhE2N+401pyUD3Vmwy9CI4Y1tLmbMNprcWmMP+6QoHJOLB5O9iLesuHP+V7m2Z0Cpzf+ThyEM6zcz2hulvHtjQgkDVhr1fV8nZTLxsCIJyooRPiqoMqzTSPdYYVWEFyiO76l8kYOXebJXVtdSXQwyB2YVUhmxCJWGCvXAzGqzyLSIIazhjlxtw2VPNqFm1ZTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MyFlSWzlvdTUJ9cMwaeyW8c7lk6mo8wQYVZ7jQ5lWQ=;
 b=SIn9bShqshACZNTab/8EtD3FCvGZgzsjcGaqB1ysDOPcbeAohFA4piLxUvToQd2uVxPxMx86Vj3F2qRVfafdmNc3BesKY3WEiWGgGH3+X+tUhTm+vvpiYH5vqg2Jghw1IlnCvb5rJQq0rzIrflkjBxehKSx2Hyv9T0RQ4KK+74g=
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PU1PR06MB2328.apcprd06.prod.outlook.com (2603:1096:803:3a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 01:32:47 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::4dea:1528:e16a:bad4%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 01:32:47 +0000
From:   =?gb2312?B?1dS+/L/8?= <bernard@vivo.com>
To:     Kalle Valo <kvalo@kernel.org>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhaojunkui2008@126.com" <zhaojunkui2008@126.com>
Subject: Reply: [PATCH] mediatek/mt76: cleanup the code a bit
Thread-Topic: Reply: [PATCH] mediatek/mt76: cleanup the code a bit
Thread-Index: Adhr6RjdAX8K6c5RQCGrrf8vv/jUHg==
Date:   Fri, 20 May 2022 01:32:46 +0000
Message-ID: <PSAPR06MB4021205461AA996200FC5C92DFD39@PSAPR06MB4021.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d69745c4-4404-486d-0a45-08da3a00a51b
x-ms-traffictypediagnostic: PU1PR06MB2328:EE_
x-microsoft-antispam-prvs: <PU1PR06MB23288075B4D48E88135DDD41DFD39@PU1PR06MB2328.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dulgwb/0WFYmtziDv6qE3KPeMbcdfmfkfP2OkejdLbN0eYpWIPIx3l3ZHVyxqicS7yH73O0jRHLts8zUMB2LR7543Q/O4zJPBiUaJiQ3ZJaatMq8JA4g2Tg3ljtnAd6jnFpKCUpVd2pK9YbRmAWp+CYBk9sSJZn0BFHZp85rkzhEtYsfY9GVX3Bjd/XEMXxwNbQLqx9KuUZMynXCSzZA60FEMZaJ+vRjtW8oGu28n/gvszkrz4S5xJaVLSjD/e0mqulJHyOZTjyU3Rcxfr0n7pG2hnoU4Npe0JdalmmGD2kTxZMP1yW7rTrZoHbuMF50P1mfS3jnRmDqDRuXvf63tFEc1z+4p/B0bBZyB3JbJCJwvo0dRLiADDj9IhKAnUTF+gsfG5CFsAjGAozk5k8g05WTWdZFvynzjIieAIHRZ8zwUXZPvul4moPXTonVv3leMGERTgqIMBV1F1geblgpyId8yGN5OHyaAVXMmG6tRmCxSrIcqPsVkmB8RqGa7pQWHJ1/SZ2HB30Lq3a+zeQS91UFOeaI9bBtjqefSIEbr0MWox7YuXFKktzZSJ0LaTs8Y94HyRoL1CQVkbMsNfXqEw1zPWImx2+NkyvGqRmRVI8fLVvOGPJfuMEc13JgSIyp579sftRcrC1Pb6YMV/0bfI48jFfblG3r6bc/3DATGPf3mRFm5dZG1Z60/Pxn57PeLWImAtLksXW3/YgNXa7iSXrdZeYDShqveeMPedS9tDs05f2ohojOF0BMwyQXjKjzu+eGSX6+9QrzxL1X5YO68g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(66446008)(6916009)(52536014)(5660300002)(66476007)(64756008)(9686003)(26005)(186003)(6506007)(122000001)(38070700005)(38100700002)(2906002)(33656002)(8676002)(76116006)(508600001)(4326008)(966005)(8936002)(7416002)(85182001)(55016003)(7696005)(66946007)(66556008)(71200400001)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?VmRBUzdkcEloU2VnSitWMHdUTEpZV0pzRWtlbjlFdWR5clQ5aXRxOGpRS2FD?=
 =?gb2312?B?VjNwbUh3YTk1RzluZFFiWU5SRXRSc3pqdDBDL3lXbE8vRmlHZEVGL0dEaEtu?=
 =?gb2312?B?YlRJa1pZQWpydXUxdnQ2NWtVSnlRaXhUVHB1M0ZoV0FWQmk4amtTaDZhaFdD?=
 =?gb2312?B?ZFRsMWR3VjJxZEthbk1PLzJzbnp5UWVxQWlWQjQ4MlQ3ZytaWFVuYTZ1WEpo?=
 =?gb2312?B?dGZCeUt0L0JnNUZyY0RkQ0NTK0sxUzNTNGNrZzdLV1ZZVXZlaXByektMOEZO?=
 =?gb2312?B?clNBL2FiODg3eldLZ2FYN21NSm1IbXk0MC9rWmxtWTFVcUVjdmU0SGwwa2NV?=
 =?gb2312?B?V1hyL2owTkdPT3JWeFczSjFIdnRVdU5leXU5bmhPT25rczV6c0pBcGZ4ZmFH?=
 =?gb2312?B?a3NLK0tyeHBMSmdDbEVaUTdSWUVBQ003T2NleDl6YjlydElTRCtKTHY3UjdL?=
 =?gb2312?B?L1pBa0xyOE4zTzdheWRvWnR6OFlodk9PZ3lvbHAzZmViZTJGdVVpUDQrY1V3?=
 =?gb2312?B?OWsyczdtZDhna1ZGcXAzL2lXYWRsMUF3clpwY045RUlBUHd6dVhkMU5sSXRs?=
 =?gb2312?B?KzVGTmpGWTZVV1U3bnJTZVN0bDBhamFIaEIrSzNrLzVrRmZ1YzFGWGo0UjRu?=
 =?gb2312?B?aUoyWkNKR09GTjdiY0NlQkpGQ3NRSmozYUhKOTlsUU9iZXp4QlFpMDZ4ZStq?=
 =?gb2312?B?MmpESHZqMHExZ1RkeWk0VVNWa2lucWxnNTZZd0h6cEZldVdDNVJBQjhTRGZ3?=
 =?gb2312?B?b1BXck9ma0VIaUU0SmRlcG1uUUxMMmJCcVZEK0ZKZ3NBTDF1NnNYNTl0aVh5?=
 =?gb2312?B?U1EwQnlWVytZU29VU1E1VlBoWVNBdStYTjh6dUhjVGZpQVVaRHRPMzk1RGlS?=
 =?gb2312?B?WkdTY1dsdENZZ0xhbzFHUThxYnhuTk9DZTIxOURzMWwvM2ZsaEIwMWd2SjlS?=
 =?gb2312?B?RHpNV1ZuMlRYQ054ejZRdkV6czJIWW16bWFpLytGUEhlQnlkbFR5UFh4TUpC?=
 =?gb2312?B?VUNZMWJIRmFScUt2T1VKSnQvYWwweVAzaEhqNDlqQVZTRllkUmR2ME5mVytp?=
 =?gb2312?B?U3J6aTZLbTFVM0JkMDA4Qm1VcTVRRkhyZGQ4a1pWTnNXaDlwR0pTSzNOL2l4?=
 =?gb2312?B?S1NOK0tYTUkyQTBzT0JGZUdjS3d1MCtGQyttSVlZUTVLNkQrd1RaU3FibHJy?=
 =?gb2312?B?a2tkaHEvNEN0eEpHSGJlQndRRzB3RHRUQnJ5Qi9LaXJIN3pRRHVlQmtEN3Fi?=
 =?gb2312?B?dHc0aEw5azFtUmptLzRqSGptWTZiU2YrR2M1bGNQcDRoME9LMVN0eFYzQW9j?=
 =?gb2312?B?d1ExT2dKcVB1OGhCVm50YWlnQnl2Y3pOSlFGUmxtVy9TL1pKNXFIUEdISnJi?=
 =?gb2312?B?ME8yL2tNMG9ZV0NVUHpXWHZMSTJJMFpUS044U0R1NVpudXorSTJXUXZiZlRa?=
 =?gb2312?B?d2E0M1hsK0l6UGZtdnRGSUNDSlNhdkhjNmJ0clFselhnSU5xNmdJc0R0VzN2?=
 =?gb2312?B?SWh6RHRqcnlKYmF4c3NhdHkrVnpFeExocTF5Qkw2Y0ZscW4yaDJmU0dzdU5G?=
 =?gb2312?B?blRBTnJYSE5KdTNiSGhIT0ZvdEdIc1lVSHZoNWZWYVBIcElHVkN3OHA2ZTlw?=
 =?gb2312?B?SHRKTHVvblVzSW1BS250Z2g0blRhc2RrYk9SelJzamluMDdUOUxvNFFDUkkz?=
 =?gb2312?B?NHB2L093MVZRK2MrcWpnVFlpdVArUEVKUjVWNjFLRkFhK0V4RE9qMU5aZ25Z?=
 =?gb2312?B?UUdNWm93eDFnbTFoRTFaTTd4Mm9GL1o0cTlWMHJkNDlnNk1zU3JzRU5FNkxB?=
 =?gb2312?B?TnpyK3UrbXhYbFlhbnNVeDBMc1QwdCtqZmxiaHB1YnlQOHZSdnZ6ejNIOUNL?=
 =?gb2312?B?N2doUXdkajVWeTJjbmNnUzZFSXBIS2oyLzREY28yenNjaDg2SGpDWGtJMFlT?=
 =?gb2312?B?Si9UaW5IcG1vQlVpWlM5QUQ3NGNVS0YzM3FRRTA5WVBGVjBGNlBVMzBXTlk1?=
 =?gb2312?B?SVF2L1JlTS8yL1VRNUVFcUtBdmlGK3VFallkUkFqU2JEc2dkMjg3Q3laQTJ2?=
 =?gb2312?B?SmRpZnM4eE1kdVZzdU0wQlhjTHIxV3RyQWU5cXpmdFdFUTI2cHNSWVkzOE5n?=
 =?gb2312?B?ZndZL2RIUkxaUmtCMXdpdDYzMXVPaTh4SVRGanJWZGYvUGFDRktEVHdtVlNw?=
 =?gb2312?B?eHdWb2FmY3d1S05HS2VadFFMZ0IzQlR6T0d2Q1FiZFlaMjFkdndka3hMbWx3?=
 =?gb2312?B?ZzlsMVYxQ0hJR3RlT2J2MHJWeVhoTTllRnVPWmJGY3B4Sjlzc1dEZEFVWnB2?=
 =?gb2312?Q?5q8/I66lUzGxNNJp7f?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69745c4-4404-486d-0a45-08da3a00a51b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 01:32:47.0145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bxbrSBJWnHenSrPI1LcT38aNwuzGcKXLZML+XRZbXjzbi/9l5IpUbE00V2u8E1UyoPuOWr2sw7FadrYJeKzuEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1PR06MB2328
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwu
b3JnPiANCreiy83KsbzkOiAyMDIyxOo11MIxOMjVIDEzOjExDQrK1bz+yMs6INXUvvy//CA8YmVy
bmFyZEB2aXZvLmNvbT4NCrOty806IEZlbGl4IEZpZXRrYXUgPG5iZEBuYmQubmFtZT47IExvcmVu
em8gQmlhbmNvbmkgPGxvcmVuem9Aa2VybmVsLm9yZz47IFJ5ZGVyIExlZSA8cnlkZXIubGVlQG1l
ZGlhdGVrLmNvbT47IFNoYXluZSBDaGVuIDxzaGF5bmUuY2hlbkBtZWRpYXRlay5jb20+OyBTZWFu
IFdhbmcgPHNlYW4ud2FuZ0BtZWRpYXRlay5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJl
bmkgPHBhYmVuaUByZWRoYXQuY29tPjsgTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdt
YWlsLmNvbT47IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1tZWRp
YXRla0BsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyB6
aGFvanVua3VpMjAwOEAxMjYuY29tDQrW98ziOiBSZTogW1BBVENIXSBtZWRpYXRlay9tdDc2OiBj
bGVhbnVwIHRoZSBjb2RlIGEgYml0DQoNCj4gQmVybmFyZCBaaGFvIDxiZXJuYXJkQHZpdm8uY29t
PiB3cml0ZXM6DQoNCj4gPiBGdW5jdGlvbiBtdDc2X3JlZ2lzdGVyX2RlYnVnZnMganVzdCBjYWxs
IG10NzZfcmVnaXN0ZXJfZGVidWdmc19mb3BzIA0KPiA+IHdpdGggTlVMTCBvcCBwYXJhbWV0ZXIu
DQo+ID4gVGhpcyBjaGFuZ2UgaXMgdG8gY2xlYW51cCB0aGUgY29kZSBhIGJpdCwgZWxldGUgdGhl
IG1lYW5pbmdsZXNzIA0KPiA+IG10NzZfcmVnaXN0ZXJfZGVidWdmcywgYW5kIGFsbCBjYWxsIG10
NzZfcmVnaXN0ZXJfZGVidWdmc19mb3BzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmVybmFy
ZCBaaGFvIDxiZXJuYXJkQHZpdm8uY29tPg0KDQo+IFBsZWFzZSBtYWtlIHRoZSB0aXRsZSBtb3Jl
IGluZm9ybWF0aXZlIGFuZCBkb24ndCB1c2UgbWVkaWF0ZWsgaW4gdGhlIHRpdGxlLCBmb3IgZXhh
bXBsZSBzb21ldGhpbmcgbGlrZSB0aGlzOg0KDQo+IG10NzY6IHJlbW92ZSBzaW1wbGUgbXQ3Nl9y
ZWdpc3Rlcl9kZWJ1Z2ZzKCkgZnVuY3Rpb24NCg0KPiBNb3JlIGluZm86DQoNCj4gaHR0cHM6Ly93
aXJlbGVzcy53aWtpLmtlcm5lbC5vcmcvZW4vZGV2ZWxvcGVycy9kb2N1bWVudGF0aW9uL3N1Ym1p
dHRpbmdwYXRjaGVzI2NvbW1pdF90aXRsZV9pc193cm9uZw0KSGkgS2FsbGUgVmFsbzoNCg0KR290
IHRoaXMsIEkgd291bGQgcmVzdWJtaXQgYSBwYXRjaCBvZiBWMiB2ZXJzaW9uLCB0aGFuayB5b3Ug
dmVyeSBtdWNoIQ0KDQpCUi8vQmVybmFyZA0KPiAtLQ0KPiBodHRwczovL3BhdGNod29yay5rZXJu
ZWwub3JnL3Byb2plY3QvbGludXgtd2lyZWxlc3MvbGlzdC8NCg0KPiBodHRwczovL3dpcmVsZXNz
Lndpa2kua2VybmVsLm9yZy9lbi9kZXZlbG9wZXJzL2RvY3VtZW50YXRpb24vc3VibWl0dGluZ3Bh
dGNoZXMNCg==
