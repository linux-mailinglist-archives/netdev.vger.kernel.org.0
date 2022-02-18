Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEBC04BB422
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbiBRI0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:26:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiBRI0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:26:49 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2113.outbound.protection.outlook.com [40.107.236.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2CB1FA41
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 00:26:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NqG580L4Sxm0gGXWLHJywiR3EeHRY13oYukXzFJGNJ5J8F6LlBjtcAEVuEBzOtT1mvTOAsIlcR+RJEOh3rDm9ptCNHRDoXwn0YNLps1hhs+bwPjTx5vpHYHOOJpyCN3LYSNwZz+ULjnJkZnAV9GjJllwybDd9htX2hLF2zJi9ToTNztLCNFwARG6qVzCdta6OEen/HR1+/aJOnftoJFg7HlpG6IRBvPRAXFnMTuTaAb0hIhBmR4VAvFJPCwfYNFimFww8IlNeWazjnn6+SNiK6vr5UcbB7iXeAPa2kLssvmgeqEFAxn5B00yXeDZwUovtE6lRAsO9MAcAZRg5r5jKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5RMxWWIc3gRGO4INhWz1/4UysoTlSToSo425RvFbjY=;
 b=c0mjNK4SP7PXLSGqhlGQO1bJyKrLr1rO975a8VoUNTc6hvoMLzKFzGSTCpW54lJVHm836H3PXsF882ZDEOrH9hlmB2EcAjBZBQuhuJIdpCL5vtgKR3BKhlFm6ld6Q7UmDfeUAIU7uRx9WK36RN5PczX+7FZ1xNeQvSNIavTPjloojovHmLpg5mJdUtu7trwSWRec2g4+qhiOb/gqstdtOxVKdYMwLN5b7C1kHef6MM74kbxtnMwxdwK4Z/r92gQbSlPcr/tso4A6XcQlvDd58UdPS2KoinMDaPaMgf6InEgvI15WcnYrpoqXfR91fdoXm4G+kc/O5m/34M5COaoA4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g5RMxWWIc3gRGO4INhWz1/4UysoTlSToSo425RvFbjY=;
 b=OofQhswEAHgxn+TzFCseH3MlnAOqTSsPAQ4jX4I3bF4DIWJybJpS50X0UdtFiPWgGYadNsavChtRdgK05/OshEkXVp1sKjbfLECcx5aizj0zpUi5Zxdzk4PXsmrvax34+L/kYWarvnYv6g9DitRucRUTpFDUKIWIv+THUruPp+I=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by MN2PR13MB3168.namprd13.prod.outlook.com (2603:10b6:208:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 18 Feb
 2022 08:26:24 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::1d6a:3497:58f3:d6bb%6]) with mapi id 15.20.5017.007; Fri, 18 Feb 2022
 08:26:24 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH net-next 3/6] nfp: add hash table to store meter table
Thread-Topic: [PATCH net-next 3/6] nfp: add hash table to store meter table
Thread-Index: AQHYI+0h+aU4BPqu70a15rcbnGZP8qyYvVcAgAA3HBA=
Date:   Fri, 18 Feb 2022 08:26:24 +0000
Message-ID: <DM5PR1301MB2172C8E090C289F2E7971D86E7379@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220217105652.14451-1-simon.horman@corigine.com>
        <20220217105652.14451-4-simon.horman@corigine.com>
 <20220217204714.33132c8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217204714.33132c8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df729c11-4cb0-4cb3-0203-08d9f2b859d8
x-ms-traffictypediagnostic: MN2PR13MB3168:EE_
x-microsoft-antispam-prvs: <MN2PR13MB3168F29DB10A8F88AA512327E7379@MN2PR13MB3168.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i3lx2N7upSFQSn5dvnl6A6mviYzB6CBiL7rx4Io3Ws2hov2xfx15NoIoy6Z+lKgaMeMRj2JczTW0dKJP6cG9sjqDBzQCHIPKboohI0Erqp+l/+mPNwhhbLoDN+8LLBnYI0kxVlCBBFUmEs6awP5Xh9yRi2/i/y/cncacJDOlDrBbjDK9DiHG29vW3cXkXCfcsd+AadZpdHLyACkdpyYkPgwnka0ESOVIsdNJbzV85xs7pLzyjnX9ns7M4HkqidLLoq5i4ukE6VEFRRbhqBEVgQ4dyI+p5GDdQiagCZtOUJ1onutGKkgQwcOGA/Pd2+4NTL7bhPAqnKOM7Wn8hqNJJwlcMDbWwaEzzRDvuZ4ALItW0+7J4moZ/OQHjkPL5H4irR/W+P/BDBAb7uzXcHkipkwtUZkV1bKplYPq9IFtiP7om+f+2WBWCfoNlDrN8gcYyCSNTNcArsvd7k3CzKDwn13s78qK/kwxGno+VRh7r+mFL2T8QD5Tx3yULjwoX1L0rcAxsNRg9V9Ug1icTBUQz9HbyJ4IVyAevlFip7u9NIgs6F5wj6Ft2RiJnS1/2xE1Ke7lLzKPB+kLiTbpkg5Q1pdfHx/DyjBt27CpaRzJLVDX2+sLp++ya2rspkONPxiLm+x+PrvfdX1DaBLv/7cGZSGzxcnJUuYxI68MNDX5rslEsX0bZdewy+4TJVz0vNSsEk+ZzOFpAhHd0ksYTf3DyckIUGJiHrIguRlIwIHMBCo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(376002)(346002)(39830400003)(136003)(366004)(396003)(83380400001)(54906003)(6636002)(316002)(107886003)(186003)(110136005)(26005)(33656002)(71200400001)(508600001)(66446008)(38070700005)(8676002)(122000001)(66476007)(4326008)(64756008)(44832011)(66946007)(66556008)(76116006)(8936002)(52536014)(5660300002)(55016003)(38100700002)(2906002)(7696005)(6506007)(86362001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjNlbEllam50aVBNeEVtcjhaM0l0QkNuYXVteUZKcEZ1bkhPNFI1TXlWL3Bv?=
 =?utf-8?B?UmVqeDV0K1NkdjFQTEtxbUUyby9XdFl3ZXB4K3BDWUMxaGhoUS9uWVZBVkdV?=
 =?utf-8?B?cW0wbHNsYmpkSjNmSks5bU5WcEFzMmZSRHE3ZXY5anp4bWZTN0FkYVJsZ2xY?=
 =?utf-8?B?ejlia2VqZUE5bmNUUkE4QVE5Q2l4UDNKdkhqSEhaYWNja2VRSndpUjAwMU9J?=
 =?utf-8?B?bmdaRm5QWjJnTXg2OGEwZDJWNDJNMEtsUU80aVpnV3NLTDN0Q0VYQWU0WU9j?=
 =?utf-8?B?YW1MdXB2Uzd2MTJ1SU5vRmJ3UjlPbU16dU9Hc3NLN1dPOS90dTNIMTJaREtJ?=
 =?utf-8?B?RnRUTUtHVUl4a0lXZW5hY1RkSm1LcUpCa0Qwc2kyT3ROa1hXZzZXK2F1NjNF?=
 =?utf-8?B?S0V0Wm82U2UyTjRPajhaZXBUb3drWHBoOGtPVVJyMlp3bXExd043ODZFaTVv?=
 =?utf-8?B?cGVOYzZ5YlgwTE1DTGJnZURaM2ZId28vRXRlVXZ3RVdTL3ZrL21iV1pvOU41?=
 =?utf-8?B?dGJxYS9tdm1Qa2lYbXdwY3U5VVBFUkR1d1YvT0tHdUZZc3VpdEVYQWJicHdB?=
 =?utf-8?B?YWF2a0twN0FvRnpoNHg0dDM0VnBwTkd4UVExd2NISjlWM2ZFcE5ZWEU1ZDNi?=
 =?utf-8?B?aG9PZHFMeUx0U0daQzI0dytOeThwUUdJR0JQRWdZU0Q2ZzdzNS9sZmFFL1ZH?=
 =?utf-8?B?TVdqUmZQV1gzVjgwOXZGYlZKc01Ec1M1akUzWGd2TUkwbXkzRnJRUGpxRlF2?=
 =?utf-8?B?YWlJakxyeGFMVGE4KzlkaVBnc2owWHg2UnVITEdrZUNOZnV5WlM5S0xOVWNZ?=
 =?utf-8?B?N0hCWU5OU04yZHd1eGZGUWJrM1cvYldsQXZJYk1nUXladU9XUGI1UndBeE9D?=
 =?utf-8?B?eng5ajRCYWFTY1I3ejJmMjF6bUlicEFnMjRDbHE3RmxGYWRBNzc4Tndod2JP?=
 =?utf-8?B?eWpqZUErYWc2VU92SWw0ek5QR2RZRG5yWGVFTC96bjcwRHZrMlkwcEczMFB6?=
 =?utf-8?B?WkVyV0hSQlZyaSs3UFpkd2phdlptQUIzN2dOQnZBOXdnYmpIbXdXUVpncFhC?=
 =?utf-8?B?WFEwcEs3UTJ4S0NmTk9Zd1BrZUd4aFdIcWxxa0dXM1dSTkE0anlleDVqdTRo?=
 =?utf-8?B?Q3dIc2QySmhMdFByMEhxTDF3ZEtpbEdlbURZenVsUVZJL0IwV1ozM2NodWVp?=
 =?utf-8?B?azI5d2s5YkZzMlA0T1BRN3RJRllQSEpkY2xzVXdRZFF2UW94YjllUEd4LzFE?=
 =?utf-8?B?L0VrR2ZjckY5ak5FK2szWEJFVmtxMkRzUGwwdi92VDZ4SXppTnAzc3BmUE5R?=
 =?utf-8?B?cWVPN2xhSVoycDVBN2JheGlRbXlIakRJY3U1WENhMUVYZ1N1TGlWeDMxUEt5?=
 =?utf-8?B?bXAyYnlSbExJRFdKZXcyL1pHRkZ2OXM4YVV6Y3F2V2FuZnZhNjRFTUFsNE0x?=
 =?utf-8?B?MnRWOGFYdWx5TlB1RGN1V1VIWWhGVFJhdWsrbytnMGZrSFU0a0NFbzBjUCto?=
 =?utf-8?B?SlhMY3U1UC9zWHY4cm9mc1JRYms4VGM1amdVSjFrVndnQjlVaXQvT3JSakZ2?=
 =?utf-8?B?WmpqS21zbm1Ka0ZVaWpKSUlyK0U3Y0ZaNm55bC9BMisyWEt3U0xjQVRYc3Y1?=
 =?utf-8?B?ZkVpK0R5TkxqelI4RHpGbkxTd3pOM2FmQ2htWWZtL1V6ejA4bDRWUFh1bVVq?=
 =?utf-8?B?OHBrM25MTTE3VTl2K0pOWDZYMDBvN0JRWjNyT0pPajN1Q0lmcGw1cm9GcE5I?=
 =?utf-8?B?NWs2MFg2eEpWTlFmL05lQ0JDRVFmODVESkRMc0VCUTdmOCtmT20xSGY0M3R1?=
 =?utf-8?B?QXArZ082L3ZrY1orUGJVMVQzZXhYN0U0TEJzdDA2S091NGRMRytLTmFsWEZv?=
 =?utf-8?B?WGNyUWxRRzc4TWU2K2d2Ly9LMlZBQzI1MzRUcE0yelI5d1h6aTYzVFZwelZV?=
 =?utf-8?B?ZDZtYjIyd3dERS9jb3ZLVVM5V05yR0xVMXVRcTk3blhNSEVwcVpLVDFrQ2Rs?=
 =?utf-8?B?UENJR2tBM3VOejgyYTdRZ2ovdlc5WlFkUitXNTJ0SklUOHgzU3NQbVlFVVZW?=
 =?utf-8?B?TGovcHRYNEx5TndiS20ySnZkS3dJWm9CK0VkU1BxOXY3dmkwRm5WWGJGS25r?=
 =?utf-8?B?WWgrTEg5akttSXVITFpJZmkxZ3d5YVdWRFlEcGltWWNoV29HNFQ3eUFJdzJO?=
 =?utf-8?B?czZMOWVjdHZ0Z2tzMHNyQjFLd0Q5U0xuTnk4b2FGRE54SXc1WXpsQkJjZmNC?=
 =?utf-8?B?aU5MRTRNeW9Xb2lsVDRVNEp4dmpBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df729c11-4cb0-4cb3-0203-08d9f2b859d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 08:26:24.4243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: riTIJCeIrwpSg3PPRq0HDx3NehFgsAiwgk78i9Fn9LvujQ1NKtHfrPCLnZBrtkjDN4mKsN1ODGLx6+HjMHoRDyUTa6+4oeNltGZ1rNXsPrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3168
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRmVicnVhcnkgMTgsIDIwMjIgMTI6NDcgUE0sIEpha3ViIHdyb3RlOg0KPk9uIFRodSwgMTcg
RmViIDIwMjIgMTE6NTY6NDkgKzAxMDAgU2ltb24gSG9ybWFuIHdyb3RlOg0KPj4gRnJvbTogQmFv
d2VuIFpoZW5nIDxiYW93ZW4uemhlbmdAY29yaWdpbmUuY29tPg0KPj4NCj4+IEFkZCBhIGhhc2gg
dGFibGUgdG8gc3RvcmUgbWV0ZXIgdGFibGUuDQo+Pg0KPj4gVGhpcyBtZXRlciB0YWJsZSB3aWxs
IGFsc28gYmUgdXNlZCBieSBmbG93ZXIgYWN0aW9uLg0KPg0KPj4gK3N0YXRpYyBzdHJ1Y3QgbmZw
X21ldGVyX2VudHJ5ICoNCj4+ICtuZnBfZmxvd2VyX2FkZF9tZXRlcl9lbnRyeShzdHJ1Y3QgbmZw
X2FwcCAqYXBwLCB1MzIgbWV0ZXJfaWQpIHsNCj4+ICsJc3RydWN0IG5mcF9tZXRlcl9lbnRyeSAq
bWV0ZXJfZW50cnkgPSBOVUxMOw0KPj4gKwlzdHJ1Y3QgbmZwX2Zsb3dlcl9wcml2ICpwcml2ID0g
YXBwLT5wcml2Ow0KPj4gKw0KPj4gKwltZXRlcl9lbnRyeSA9IHJoYXNodGFibGVfbG9va3VwX2Zh
c3QoJnByaXYtPm1ldGVyX3RhYmxlLA0KPj4gKwkJCQkJICAgICAmbWV0ZXJfaWQsDQo+PiArCQkJ
CQkgICAgIHN0YXRzX21ldGVyX3RhYmxlX3BhcmFtcyk7DQo+PiArDQo+DQo+dW5uZWNlc3Nhcnkg
bmV3IGxpbmUNClRoYW5rcywgd2lsbCBtYWtlIHRoZSBjaGFuZ2UgaW4gVjIgcGF0Y2guDQo+DQo+
PiArCWlmIChtZXRlcl9lbnRyeSkNCj4+ICsJCXJldHVybiBtZXRlcl9lbnRyeTsNCj4+ICsNCj4+
ICsJbWV0ZXJfZW50cnkgPSBremFsbG9jKHNpemVvZigqbWV0ZXJfZW50cnkpLCBHRlBfQVRPTUlD
KTsNCj4NCj53aHkgaXMgdGhpcyBBVE9NSUM/DQpQcmV2aW91c2x5LCB3ZSB1c2Ugc3Bpbl9sb2Nr
IHRvIHByb3RlY3QgdGhlIG1ldGVyIGVudHJ5LCBzbyB3ZSB1c2UgdGhlIA0KQnV0IG5vdyB3ZSBj
aGFuZ2UgdGhlIG11dGV4IHNvIGl0IHdpbGwgbWFrZSBzZW5zZSB0byB1c2UgR0ZQX0tFUk5FTCBt
ZW1vcnkgYWxsb2MuIA0KV2Ugd2lsbCBtYWtlIHRoZSBjaGFuZ2UgaW4gVjIgcGF0Y2guDQpUaGFu
a3MNCj4NCj4+ICsJaWYgKCFtZXRlcl9lbnRyeSkNCj4+ICsJCWdvdG8gZXJyOw0KPj4gKw0KPj4g
KwltZXRlcl9lbnRyeS0+bWV0ZXJfaWQgPSBtZXRlcl9pZDsNCj4+ICsJbWV0ZXJfZW50cnktPnVz
ZWQgPSBqaWZmaWVzOw0KPj4gKwlpZiAocmhhc2h0YWJsZV9pbnNlcnRfZmFzdCgmcHJpdi0+bWV0
ZXJfdGFibGUsICZtZXRlcl9lbnRyeS0NCj4+aHRfbm9kZSwNCj4+ICsJCQkJICAgc3RhdHNfbWV0
ZXJfdGFibGVfcGFyYW1zKSkgew0KPj4gKwkJZ290byBlcnJfZnJlZV9tZXRlcl9lbnRyeTsNCj4+
ICsJfQ0KPg0KPnVubmVjZXNzYXJ5IGJyYWNrZXRzDQpUaGFua3MsIHdpbGwgbWFrZSB0aGUgY2hh
bmdlIGluIFYyIHBhdGNoLg0KPg0KPj4gKwlwcml2LT5xb3NfcmF0ZV9saW1pdGVycysrOw0KPj4g
KwlpZiAocHJpdi0+cW9zX3JhdGVfbGltaXRlcnMgPT0gMSkNCj4+ICsJCXNjaGVkdWxlX2RlbGF5
ZWRfd29yaygmcHJpdi0+cW9zX3N0YXRzX3dvcmssDQo+PiArCQkJCSAgICAgIE5GUF9GTF9RT1Nf
VVBEQVRFKTsNCj4+ICsJcmV0dXJuIG1ldGVyX2VudHJ5Ow0KPj4gKw0KPj4gK2Vycl9mcmVlX21l
dGVyX2VudHJ5Og0KPj4gKwlrZnJlZShtZXRlcl9lbnRyeSk7DQo+PiArZXJyOg0KPg0KPmRvbid0
IGp1bXAgdG8gcmV0dXJuLCBqdXN0IHJldHVybiBkaXJlY3RseSBpbnN0ZWFkIG9mIGEgZ290bw0K
Pg0KPj4gKwlyZXR1cm4gTlVMTDsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIHZvaWQgbmZwX2Zs
b3dlcl9kZWxfbWV0ZXJfZW50cnkoc3RydWN0IG5mcF9hcHAgKmFwcCwgdTMyDQo+PiArbWV0ZXJf
aWQpIHsNCj4+ICsJc3RydWN0IG5mcF9tZXRlcl9lbnRyeSAqbWV0ZXJfZW50cnkgPSBOVUxMOw0K
Pj4gKwlzdHJ1Y3QgbmZwX2Zsb3dlcl9wcml2ICpwcml2ID0gYXBwLT5wcml2Ow0KPj4gKw0KPj4g
KwltZXRlcl9lbnRyeSA9IHJoYXNodGFibGVfbG9va3VwX2Zhc3QoJnByaXYtPm1ldGVyX3RhYmxl
LA0KPiZtZXRlcl9pZCwNCj4+ICsJCQkJCSAgICAgc3RhdHNfbWV0ZXJfdGFibGVfcGFyYW1zKTsN
Cj4+ICsNCj4NCj51bm5lY2Vzc2FyeSBubA0KVGhhbmtzLCB3aWxsIG1ha2UgdGhlIGNoYW5nZSBp
biBWMiBwYXRjaC4NCj4NCj4+ICsJaWYgKG1ldGVyX2VudHJ5KSB7DQo+DQo+ZmxpcCBjb25kaXRp
b24gYW5kIHJldHVybiBlYXJseQ0KVGhhbmtzLCB3aWxsIG1ha2UgdGhlIGNoYW5nZSBpbiBWMiBw
YXRjaC4NCj4NCj4+ICsJCXJoYXNodGFibGVfcmVtb3ZlX2Zhc3QoJnByaXYtPm1ldGVyX3RhYmxl
LA0KPj4gKwkJCQkgICAgICAgJm1ldGVyX2VudHJ5LT5odF9ub2RlLA0KPj4gKwkJCQkgICAgICAg
c3RhdHNfbWV0ZXJfdGFibGVfcGFyYW1zKTsNCj4+ICsJCWtmcmVlKG1ldGVyX2VudHJ5KTsNCj4+
ICsJCXByaXYtPnFvc19yYXRlX2xpbWl0ZXJzLS07DQo+PiArCQlpZiAoIXByaXYtPnFvc19yYXRl
X2xpbWl0ZXJzKQ0KPj4gKwkJCWNhbmNlbF9kZWxheWVkX3dvcmtfc3luYygmcHJpdi0+cW9zX3N0
YXRzX3dvcmspOw0KPj4gKwl9DQo+PiArfQ0KPj4gKw0KPj4gK2ludCBuZnBfZmxvd2VyX3NldHVw
X21ldGVyX2VudHJ5KHN0cnVjdCBuZnBfYXBwICphcHAsDQo+PiArCQkJCSBjb25zdCBzdHJ1Y3Qg
Zmxvd19hY3Rpb25fZW50cnkgKmFjdGlvbiwNCj4+ICsJCQkJIGVudW0gbmZwX21ldGVyX29wIG9w
LA0KPj4gKwkJCQkgdTMyIG1ldGVyX2lkKQ0KPj4gK3sNCj4+ICsJc3RydWN0IG5mcF9mbG93ZXJf
cHJpdiAqZmxfcHJpdiA9IGFwcC0+cHJpdjsNCj4+ICsJc3RydWN0IG5mcF9tZXRlcl9lbnRyeSAq
bWV0ZXJfZW50cnkgPSBOVUxMOw0KPj4gKwlpbnQgZXJyID0gMDsNCj4+ICsNCj4+ICsJbXV0ZXhf
bG9jaygmZmxfcHJpdi0+bWV0ZXJfc3RhdHNfbG9jayk7DQo+PiArDQo+PiArCXN3aXRjaCAob3Ap
IHsNCj4+ICsJY2FzZSBORlBfTUVURVJfREVMOg0KPj4gKwkJbmZwX2Zsb3dlcl9kZWxfbWV0ZXJf
ZW50cnkoYXBwLCBtZXRlcl9pZCk7DQo+PiArCQlnb3RvIHJldDsNCj4NCj50cnkgdG8gYXZvaWQg
bmFtaW5nIGxhYmVscyB3aXRoIGNvbW1vbiB2YXJpYWJsZSBuYW1lcywgZXhpdF91bmxvY2sgd291
bGQgYmUNCj5tb3N0IGluIGxpbmUgd2l0aCB0aGUgc3R5bGUgb2YgdGhlIGRyaXZlciBoZXJlLg0K
VGhhbmtzLCB3aWxsIG1ha2UgdGhlIGNoYW5nZSBpbiBWMiBwYXRjaC4NCj4NCj4+ICsJY2FzZSBO
RlBfTUVURVJfQUREOg0KPj4gKwkJbWV0ZXJfZW50cnkgPSBuZnBfZmxvd2VyX2FkZF9tZXRlcl9l
bnRyeShhcHAsIG1ldGVyX2lkKTsNCj4+ICsJCWJyZWFrOw0KPj4gKwlkZWZhdWx0Og0KPg0KPndo
eSBkZWZhdWx0IGFuZCBub3QgdXNlIF9TRVQ/DQpBY3R1YWxseSwgd2Ugd2lsbCBjaGVjayBpZiB0
aGUgbWV0ZXIgZW50cnkgZXhpc3RzIGFuZCBhZGQgaW4gTkZQX01FVEVSX0FERCwgIHNvIHdlIGRv
IG5vdCB1c2UgdGhlIE5GUF9NRVRFUl9TRVQuIA0KTWF5YmUgd2Ugd2lsbCBuZWVkIHRvIGRlbGV0
ZSB0aGUgTkZQX01FVEVSX1NFVCBkZWZpbml0aW9uIHRvIG9taXQgdGhlIGNvbmZ1c2lvbi4NClRo
YW5rcw0KPg0KPj4gKwkJbWV0ZXJfZW50cnkgPSBuZnBfZmxvd2VyX3NlYXJjaF9tZXRlcl9lbnRy
eShhcHAsDQo+bWV0ZXJfaWQpOw0KPj4gKwkJYnJlYWs7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYg
KCFtZXRlcl9lbnRyeSkgew0KPj4gKwkJZXJyID0gLUVOT01FTTsNCj4+ICsJCWdvdG8gcmV0Ow0K
Pj4gKwl9DQo+PiArDQo+PiArCWlmICghYWN0aW9uKSB7DQo+PiArCQllcnIgPSAtRUlOVkFMOw0K
Pj4gKwkJZ290byByZXQ7DQo+PiArCX0NCj4NCj5kZWZlbnNpdmUgcHJvZ3JhbW1pbmcgaXMgZGlz
Y291cmFnZWQgaW4gdGhlIGtlcm5lbCwgcGxlYXNlIGRyb3AgdGhlIGFjdGlvbg0KPmNoZWNrIGlm
IGl0IGNhbid0IGhhcHBlbiBpbiBwcmFjdGljZQ0KVGhhbmtzLCB3aWxsIG1ha2UgdGhlIGNoYW5n
ZSBpbiBWMiBwYXRjaC4NCj4NCj4+ICsJaWYgKGFjdGlvbi0+cG9saWNlLnJhdGVfYnl0ZXNfcHMg
PiAwKSB7DQo+PiArCQltZXRlcl9lbnRyeS0+YnBzID0gdHJ1ZTsNCj4+ICsJCW1ldGVyX2VudHJ5
LT5yYXRlID0gYWN0aW9uLT5wb2xpY2UucmF0ZV9ieXRlc19wczsNCj4+ICsJCW1ldGVyX2VudHJ5
LT5idXJzdCA9IGFjdGlvbi0+cG9saWNlLmJ1cnN0Ow0KPj4gKwl9IGVsc2Ugew0KPj4gKwkJbWV0
ZXJfZW50cnktPmJwcyA9IGZhbHNlOw0KPj4gKwkJbWV0ZXJfZW50cnktPnJhdGUgPSBhY3Rpb24t
PnBvbGljZS5yYXRlX3BrdF9wczsNCj4+ICsJCW1ldGVyX2VudHJ5LT5idXJzdCA9IGFjdGlvbi0+
cG9saWNlLmJ1cnN0X3BrdDsNCj4+ICsJfQ0KPj4gK3JldDoNCj4+ICsJbXV0ZXhfdW5sb2NrKCZm
bF9wcml2LT5tZXRlcl9zdGF0c19sb2NrKTsNCj4+ICsJcmV0dXJuIGVycjsNCj4+ICt9DQo+PiAr
DQo+PiAraW50IG5mcF9pbml0X21ldGVyX3RhYmxlKHN0cnVjdCBuZnBfYXBwICphcHApIHsNCj4+
ICsJc3RydWN0IG5mcF9mbG93ZXJfcHJpdiAqcHJpdiA9IGFwcC0+cHJpdjsNCj4+ICsNCj4+ICsJ
cmV0dXJuIHJoYXNodGFibGVfaW5pdCgmcHJpdi0+bWV0ZXJfdGFibGUsDQo+PiArJnN0YXRzX21l
dGVyX3RhYmxlX3BhcmFtcyk7IH0NCj4NCj5taXNzaW5nIG5sDQpUaGFua3MsIHdpbGwgbWFrZSB0
aGUgY2hhbmdlIGluIFYyIHBhdGNoLg0KPg0KPj4gIHN0YXRpYyBpbnQNCj4+ICBuZnBfYWN0X2lu
c3RhbGxfYWN0aW9ucyhzdHJ1Y3QgbmZwX2FwcCAqYXBwLCBzdHJ1Y3QgZmxvd19vZmZsb2FkX2Fj
dGlvbg0KPipmbF9hY3QsDQo+PiAgCQkJc3RydWN0IG5ldGxpbmtfZXh0X2FjayAqZXh0YWNrKQ0K
