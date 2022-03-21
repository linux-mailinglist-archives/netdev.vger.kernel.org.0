Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D0B4E2FAB
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348609AbiCUSKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiCUSKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:10:51 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1318E387B5;
        Mon, 21 Mar 2022 11:09:24 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LBsiVO016560;
        Mon, 21 Mar 2022 14:08:59 -0400
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewc33gv1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:08:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4MTNMryVQpBC5fUHs4EF4J8SPlP1xXHrs7AntkVboPC/erIXLuLgTOwet6TJ0HAHAzrII5pSZ+n4fhSTOZasEPMaG3SyI5sdc7FIDFAP7vjQn+NYvKP5atELwoJn1DlJWhCpgCDpdcp6KltJEkbaRpZGn/0uTKY23cu0d2+d9e5Z5JUs5jhaFq7XS/YChZmGiNoIrQVQlERRh5gIgEkXqF8swI8WAemo3jeUCi2jshX3nEbTpFtRPryLQ2ItfGf6gBkuZ9hWPUnMTb8Wv787hXZbOL+voqpD4csKLVjsBeCe7FtFxb+WH3vkfG+K9BWJkCK8mMsuoIACGc18jBhOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UVmlW85AYU3BIUfSyqQxClf5DpNjNohifSz3K0IN/hM=;
 b=HdAD6BywoHVDYAj2Mv8/KDKLTryykFL8qkgVbPDhemCWZKDK1TzopQIhor/idPNBVoxlH+smcohZM6TEWZC0Y308/W82KTUvFSkElWRLQVbpgNQFO2psd9uT8otePSh8B+nFfHuUtjqAvLwZkgQytEOTNWaHJUUaHGAU6X07fRhsE+AGZCIElacq5Slgz54hTYrDH8GtTH9BtvTbvZfO0tdJLZLRMCy7hXYx8DHZ+ypsxM3+KQ07E6NLn6bmpQS2huHcwm3LF6ZYNOKSOnWMGY3KdpGf8IOxev8NPKXqOtjVv75wjQ8T82cT8Cj6PJjnngSCoxTAJ3QMWRDVh/H1kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UVmlW85AYU3BIUfSyqQxClf5DpNjNohifSz3K0IN/hM=;
 b=C3hziEF++kwFabNnsrYyJ2OcBdHYfzSO7tXVIFu7jH0XXUwTXbxrc6t/irBSdLUIjVC/2iBu5FVyaTR4hbqlI1l7NR14QCiRIk5NpZ2C2eDvx2rYNdomuRkc4UA/1OCey0Xvcwxz62ZhBe1oK8hAq1hpZbPeZdRQmLYZWXTK0B4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB3354.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Mon, 21 Mar
 2022 18:08:57 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 18:08:57 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/4] net: axienet: setup mdio unconditionally
Thread-Topic: [PATCH v4 1/4] net: axienet: setup mdio unconditionally
Thread-Index: AQHYPTgmjMCHk+wFaUa9PUM46co+x6zKIwUA
Date:   Mon, 21 Mar 2022 18:08:57 +0000
Message-ID: <52e8c8ba9b9558aa6a5666230a834decfbaee0d8.camel@calian.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
In-Reply-To: <20220321152515.287119-1-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9608e2b-bff4-41d8-1bec-08da0b65de47
x-ms-traffictypediagnostic: YT1PR01MB3354:EE_
x-microsoft-antispam-prvs: <YT1PR01MB33541655E2DC95CEE5A9B8F5EC169@YT1PR01MB3354.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lDNhoxCs89GoYG2YYeYX9Gz+FAx8BeThQjlvlYQBuNMBk9DxdihS2+2k0TzyZOF9BlJy/v4HIXWrhVAjUgp8zZS3EBm0bBE+Ly2e5vVX+CjyQh0nw2y8VRQKR8VyRKc8bVump5grTvTAxgeinmnCGp6Xy4TyYlEcsC95A/j81+DRe0tbENPE9WX3olMqJ9fvqFhBj0gT3SwEOCVwoKZh25vmZd0n5MudcoRNoqF8bXdjitCXm/qd5xB6hTcGjx0RaOw1LH09Pi0e9WnxXmkLlqtzj/DUb9gv3xsTtXzn1y24l4iGYPUvKZ5MbBnImbRrh7kvkYtlwvcuex+sampaHw8cOHZQ0cdGqB5zSXNxkBrFfkV27rptwyJqwKKSX3bBSef0cbdYvVS63G7cX8w0kpa8/E5W8noC33de1OPzkU9IdYsxJRPDhLyM+67jETRgp8e6hkE/3b4OdbClqeqbB07IsQ2EOsytYJMhE5nBivMtOVvekVOQRFdPbLySlS3P5mPNNFBpwPuItRtqv2ivCeAfBYcCvrdNxcw3O54zQHFR3zqj39F07SXA8DjI1RB0PGh2/6Yz8yJwMO3nxT1mvt0q8cQ5A4ueQfEGauxdUFlvzNt7KEy/H846Y2sdB7NX8Eg8Kvdat144gA/yU7E3SmvVsvABi958/PiDND8rOZcG/1NZxNSLkBTff4ytMz56V2+sXVijUuprWx6n4GTy1HDX2rMK+FEezpPVf543WFuBH0BjZBdfVJ0YZlCMyztezMRP9X3BsZQfM4gTZ9qmT27nbMcZMqMHpuIYRrIJhe7hKRcJbN68H0No1eJtgNZTlFbhkLjP+OuWYFJxGSALcWEu1cntYmtW40cUCXObaQ4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(15974865002)(2906002)(76116006)(6506007)(91956017)(66946007)(71200400001)(8676002)(66556008)(66476007)(4326008)(66446008)(64756008)(122000001)(6486002)(38070700005)(508600001)(44832011)(7416002)(26005)(8936002)(5660300002)(86362001)(38100700002)(316002)(186003)(6512007)(2616005)(36756003)(110136005)(54906003)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnBMV1NTbWtBZVNweVlWajFvNlAvM3JyYU9SWWowUjVvU3BadUtyRkgyWVBK?=
 =?utf-8?B?Qm5YeUdBQ0xuaUdZWHJHNkZiYm9UdEZWZG1XOHJzS1BBME1hWERQL0VjNXB1?=
 =?utf-8?B?VzFWUmVEMVVIa2JqZWVpQkE0WWxJcmpQQjV5U0ZzMzlYejQxREpWM09tVURs?=
 =?utf-8?B?UnZta0xtZ2ZsWHNMYnZYWFQ1cWVVcENmSnY5Sml1OG1rc25pMjVoNWdENk1H?=
 =?utf-8?B?RytxQ0wxdkxvWk9FemxjcU44YTE0S0l1MnRrckh2SUxuSXk1cTUwSHcyTmRU?=
 =?utf-8?B?RE9OWkoydUtGLys4c1VISXRWN3ZjUmcxRTNaNVY3alREbitEbGJyMlZxaE9V?=
 =?utf-8?B?NlkwV2JkY1Fpemo1d1VmYW1nemV3U0ZKSjNJQkdXSzdjU0NtalRNYU5iOW1F?=
 =?utf-8?B?UWdXOG5hREcxT2pvaXdYSEttMVB0QzNPR3VVS2dhYWc3STJycmNuYkd1WkZ1?=
 =?utf-8?B?bTlDNWhpQkcvcFBKNDhDU0FMbm9pYjFZTWlsSS9sVXJ2djdUSVYvOHVSeTVD?=
 =?utf-8?B?dTZ5SUVIWm5XdU5BMlYxdEVKL3U2S0ZzamtMRzdYaTRrZHlsVHB1QUc2Qmo5?=
 =?utf-8?B?bXk2VWVQcjZHRjhBcUdvUUpWcU93UWhHUmtMZEk2QTZpYnVzTGV2V29RZDYr?=
 =?utf-8?B?RmU5b2hzcnV0UjF4akxMR09VejZDaktUSmcrKy9DU2gvQzVPclRIbDB6ZVRh?=
 =?utf-8?B?VzZtRW1TV2VmdzFMdmNoYlJ3U3diMHpXdnV1RlloNEIvSFA5c2U3dDlkWWFH?=
 =?utf-8?B?dktUcnJFVjhqblk0cDZsSy8vREIxTVJVbjF4dkNGeitWakJrSXl2WXJ3Z2Vz?=
 =?utf-8?B?cFYzaHRndm9lRUVoVmh5ZXk3M0JwaG1zQ2I3Ujg2QTcxblRQNXVvRDRKbkli?=
 =?utf-8?B?OVRPaG1kcTlEU1JZMVUzNEM2dWF6a1NRa29nbk5oWEkyU2lJMllTdU9WdjNY?=
 =?utf-8?B?VEhLNEtCTXQ2RjBWeGtGREJ6R2JOaStmdlZoQUpobzRmWTNSSXg4Uks2OGNs?=
 =?utf-8?B?ZkUvRXA4cDJRMnRHdmtFaEZmVjJZdGdIbzdjYVJMU3dwbjZXNmNkeVh6NGk3?=
 =?utf-8?B?YlpwcDNxUmpDRm5mSTFiN3FZWnplNDh2d3VtcE1xQ1ErejNVOXZQVVhRZ0wv?=
 =?utf-8?B?c0pTb2IyYldEVktGODlxaEI5MXpDSy9HZlQrT0M4Q0U1ZEpLZ2x3anpDNEFk?=
 =?utf-8?B?c2FXVngrQWU1NFgvTFJiNG9BQ081bytraFJyOGpSSjhWOUhwaE9IaVB1MDNq?=
 =?utf-8?B?YkdxaTFhakR0MENEL1BCT3MySGFHL3l6RUhJUTYvcVhwQkZYY1pNOFpzaFlR?=
 =?utf-8?B?eWpSTGdjNDZsY1A5VlpubVpjKzJ5SXM4c3hweEdWYUFUTmlobFRRY1BnNG1P?=
 =?utf-8?B?ZnQrdjR3ME5GZ3BsRzF4VHdzamRJaVQ4SGREV25RQjBMMnkzdTA0TjJFb01D?=
 =?utf-8?B?NHV4aXJ3c21acnNJOEs3ejE0WldXQVBPa3ZhaThZZWFjZjdlaEtQbnBjV3ZX?=
 =?utf-8?B?L1IzQTM4UUVJQnB0RktaZ1Q3aENJbHNWYldaVG9rRGxTem5JTktsTHdGYU9o?=
 =?utf-8?B?MkZsVk10ejc5eG1WWkJvdFRWbHEwVE4xL3drVllFaXNNN0ROamtQbzZyNEY3?=
 =?utf-8?B?cXlnODNROUxGZVNLT1czeVBvVCtFUGt3VFVFYkxsTmZDTkttTStrQ3M1emlU?=
 =?utf-8?B?dXBabEdJeWtYbWdhbmltNDFjYkNNanFwQXUvUC9aeFdZZ2NUSm9YdDJxSjVW?=
 =?utf-8?B?eWQxK2FWRFlLL1lpeEd5RDZlSC90ZmJoM1hQYndZbUwwZWFnZHhMV1lOa3lm?=
 =?utf-8?B?NFdSZjBISG5EdUNzRnBTc1NkUlNwR1ZvVVJiWm5oeGlWeTZNR2JGTlN3Uisr?=
 =?utf-8?B?RTFPeGRsVWwra1lBdjVQRXdIR1ZYenJvN3lDNVF2eGI5SHRTelZERU9UdU5I?=
 =?utf-8?B?ck4rNUtuNldQQllFTDVIYUpScEVYVDh5TjArcHZUYldTdjFab1ZLMk05Nkh1?=
 =?utf-8?Q?X9k4UDgf98JrcRR/YRbBuGT1addLyQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <433ADA6796D7B8498E0D7C97625789C4@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e9608e2b-bff4-41d8-1bec-08da0b65de47
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 18:08:57.4057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SOJZCi8JTqxfH2lIKppdZ3AyVlS1tqM8xrGOZfUU1akzPIlb79bnTrYuHp8qG4rnD/2ztPdxvw5aDuCUMzp0mHyHYrWU3ftU7hk+p88XlqQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3354
X-Proofpoint-ORIG-GUID: rlhQ7JpIr2wr5_taxW4buapyvl3AnlSt
X-Proofpoint-GUID: rlhQ7JpIr2wr5_taxW4buapyvl3AnlSt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=724 suspectscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210116
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTIxIGF0IDIzOjI1ICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IFRo
ZSBjYWxsIHRvIGF4aWVuZXRfbWRpb19zZXR1cCBzaG91bGQgbm90IGRlcGVuZCBvbiB3aGV0aGVy
ICJwaHktbm9kZSINCj4gcHJlc3NlbnRzIG9uIHRoZSBEVC4gQmVzaWRlcywgc2luY2UgYGxwLT5w
aHlfbm9kZWAgaXMgdXNlZCBpZiBQSFkgaXMgaW4NCj4gU0dNSUkgb3IgMTAwQmFzZS1YIG1vZGVz
LCBtb3ZlIGl0IGludG8gdGhlIGlmIHN0YXRlbWVudC4gQW5kIHRoZSBuZXh0IHBhdGNoDQo+IHdp
bGwgcmVtb3ZlIGBscC0+cGh5X25vZGVgIGZyb20gZHJpdmVyJ3MgcHJpdmF0ZSBzdHJ1Y3R1cmUg
YW5kIGRvIGFuDQo+IG9mX25vZGVfcHV0IG9uIGl0IHJpZ2h0IGF3YXkgYWZ0ZXIgdXNlIHNpbmNl
IGl0IGlzIG5vdCB1c2VkIGVsc2V3aGVyZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHkgQ2hp
dSA8YW5keS5jaGl1QHNpZml2ZS5jb20+DQo+IFJldmlld2VkLWJ5OiBHcmVlbnRpbWUgSHUgPGdy
ZWVudGltZS5odUBzaWZpdmUuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3hp
bGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMgfCAxMyArKysrKystLS0tLS0tDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4g
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IGlu
ZGV4IDZmZDUxNTdmMGE2ZC4uNWQ0MWI4ZGU4NDBhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gQEAgLTIwNjQsMTUg
KzIwNjQsMTQgQEAgc3RhdGljIGludCBheGllbmV0X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZp
Y2UNCj4gKnBkZXYpDQo+ICAJaWYgKHJldCkNCj4gIAkJZ290byBjbGVhbnVwX2NsazsNCj4gIA0K
PiAtCWxwLT5waHlfbm9kZSA9IG9mX3BhcnNlX3BoYW5kbGUocGRldi0+ZGV2Lm9mX25vZGUsICJw
aHktaGFuZGxlIiwgMCk7DQo+IC0JaWYgKGxwLT5waHlfbm9kZSkgew0KPiAtCQlyZXQgPSBheGll
bmV0X21kaW9fc2V0dXAobHApOw0KPiAtCQlpZiAocmV0KQ0KPiAtCQkJZGV2X3dhcm4oJnBkZXYt
PmRldiwNCj4gLQkJCQkgImVycm9yIHJlZ2lzdGVyaW5nIE1ESU8gYnVzOiAlZFxuIiwgcmV0KTsN
Cj4gLQl9DQo+ICsJcmV0ID0gYXhpZW5ldF9tZGlvX3NldHVwKGxwKTsNCj4gKwlpZiAocmV0KQ0K
PiArCQlkZXZfd2FybigmcGRldi0+ZGV2LA0KPiArCQkJICJlcnJvciByZWdpc3RlcmluZyBNRElP
IGJ1czogJWRcbiIsIHJldCk7DQo+ICsNCj4gIAlpZiAobHAtPnBoeV9tb2RlID09IFBIWV9JTlRF
UkZBQ0VfTU9ERV9TR01JSSB8fA0KPiAgCSAgICBscC0+cGh5X21vZGUgPT0gUEhZX0lOVEVSRkFD
RV9NT0RFXzEwMDBCQVNFWCkgew0KPiArCQlscC0+cGh5X25vZGUgPSBvZl9wYXJzZV9waGFuZGxl
KHBkZXYtPmRldi5vZl9ub2RlLCAicGh5LQ0KPiBoYW5kbGUiLCAwKTsNCj4gIAkJaWYgKCFscC0+
cGh5X25vZGUpIHsNCj4gIAkJCWRldl9lcnIoJnBkZXYtPmRldiwgInBoeS1oYW5kbGUgcmVxdWly
ZWQgZm9yDQo+IDEwMDBCYXNlWC9TR01JSVxuIik7DQo+ICAJCQlyZXQgPSAtRUlOVkFMOw0KDQpS
ZXZpZXdlZC1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQoN
Ci0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFk
dmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
