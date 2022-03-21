Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2933F4E2FAD
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352013AbiCUSLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351995AbiCUSLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:11:07 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEE85F4FB;
        Mon, 21 Mar 2022 11:09:40 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LAh2Pd007012;
        Mon, 21 Mar 2022 14:09:30 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewc33gv21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:09:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lmm2fueG5aHe36qTGq6WgNT1xNDa1YpqDlTUuJJ3e2Uhf1JtibEpHYRZ1HQnfJ43dSdUJ7+eMXL1usnPRax2WzO+2qDWJD8KmMjTg3pnTfiD4fwiA+B8E78OrQInfcFjX9s+QGuSPR5ftVWrmCjANT5GGdl+jyWfbUdb8SZHz6uUmzrW9/vZWhstEOk9fvDJP6SzBgQ4hrovkc32qVVLumlCGqTYKTWWdqqLteFyBWIDCDT8UpxXuRbGKOAK4VjQ11PTO90H6bYlevCZY2knIiOR5dFc+2e9YwM9UUWo5q5CWcKLi8d3kbrf3aHGUCfIow9qYNR9a1qUL5nD4kKZKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WvBbKrkdRonV7XWZWwR+LrefO6BbpYKq9AkyrhI9Y4Y=;
 b=gp31nqItqrzkST3Hq2wcmB1d2CFE1dRuMbuPxmcKQ7U22Qd0eviPmfuXr3/56EqdP6vegFy1SX3WsS8wIpZF6pvsVpXs6Jlq0/Ryr9V10Zxn/QVtjY89DuAd5M9Qn5qLYgwu04OxZ1HkVhWVUdEPiJZZKY7TYQ/JM7PvfTBhh3px2aEulIXBQflMqXLj+7qmdJjZJqI6ju16VHbqYD82EXk0BYiBCsuQ7N+OykQwzhC+S+0vATc7xCD7tgV4Jg2DU0zaaLaDFoTWSTkW5aaGLMXg7dtG8tYVZby8jvGffdEi0693zqA4jU2UMM/YyL0kvADV47ntt7pKn1kAOQ0SRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvBbKrkdRonV7XWZWwR+LrefO6BbpYKq9AkyrhI9Y4Y=;
 b=c+7Ti25cv6tTVnSPM26e1lHlYtmHqSKO8sJJ2EIVIdcG7DtXd3m4ePRz52Blm9DHc+YmGT/CMoeWM4FmO8hfbW9Oe3QiCXrPdV+r5K76b0kkWrtAcx/jee7I2tVWEmTl2olck8z1EE2XWreY+dI4whyO86j323d7hsOYL41CihY=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB8834.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:7b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 18:09:28 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 18:09:28 +0000
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
Subject: Re: [PATCH v4 2/4] net: axienet: factor out phy_node in struct
 axienet_local
Thread-Topic: [PATCH v4 2/4] net: axienet: factor out phy_node in struct
 axienet_local
Thread-Index: AQHYPThwN1oPyw07TE6QM0SwfcFic6zKIysA
Date:   Mon, 21 Mar 2022 18:09:28 +0000
Message-ID: <2870f7b910783ebd8bdb6478cd8dd20747c1f21b.camel@calian.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
         <20220321152515.287119-2-andy.chiu@sifive.com>
In-Reply-To: <20220321152515.287119-2-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ca99d56-3620-46e7-9d2d-08da0b65f0ed
x-ms-traffictypediagnostic: YT3PR01MB8834:EE_
x-microsoft-antispam-prvs: <YT3PR01MB883449D642A2B05ADCECEA7FEC169@YT3PR01MB8834.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DEyn06aXoSW8LjdgkYfuiFuVy0BBKGdGhpRV25aS5ae2f5dYZ0DJvO1CF5yMb2yDzEB19JqAc26aPlB8VNMuEVz1NWv0ylVhGVt/rVAtgTs0QtCRxf5wW9+vEZ1mMy2OknftrE7L4msit2md4v0Af8CeH9YhoLct6BgvI4I2+MhfuUQc58m/qXl+D9ZRGaCsvWcXU9F4pBn13KlHVD8Rb8Pq1jYdMvl37X+r0OLecdqsfk321gZ2DtqgjNr+qYc4fgAJpGkx95AmCO+D6YFuieVYn/GLM4lHnWErW2K7yA+vSWZk+4Y35fgCMbmJ3Yl4/8DXcZaKg52U0Vz2m8I+MATbWUSo0un8gpzll2RgKSAVwW2lGmL3m/Ab/tYSsAwE2DdtVeh8w9DMlAuSsUz+sftr3jqCMe2GWUi1VHIis9Y7U9zMNG1t9530XKRWlzsYf7zvj19OuEE5apg8Ot0HRafx+WFCy6UwLGRUJXqaQ28scAN9UqgMVKMPQ7iqmYjxbtNym03Bq/ZufRBN6vDW0eg16i82M+p/gpPkboFFeR8gwrQ9TaL18GGCqeBcLNRh2x406J829xRI8c0D/LmT3FGC0U41j8beuQqZ/PHcRgsryUTgMCvpujC6HvH5oGwitCy1BQ/dK0Xi2JzRkvJoVsjcCHgOXyEZM5N1tFrx7Ac0R0DbCm/H2KWrrgUfAHhhTZ2Q2Ng9IaO7tWaj9Op25N/lf4knpgiqUVCC9IBhMSBBMO8KKCvV96kE6J24jfmjWJmfDmg++ALBl/v+dorhvTLBCMQVIoxWLVemH6piaYwO2S7yhmH8HnGEKUAJOpynMY4fq96hrf1Q2LO+dpt9dA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(8936002)(36756003)(7416002)(508600001)(54906003)(44832011)(6486002)(83380400001)(71200400001)(5660300002)(8676002)(110136005)(316002)(66556008)(186003)(26005)(4326008)(91956017)(66476007)(2616005)(2906002)(66446008)(38100700002)(66946007)(6506007)(6512007)(76116006)(64756008)(86362001)(15974865002)(38070700005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T280RVJzV3dEdTQwQnE2K1lmV3pkaWdLaTJ1bllGaWhTYjlRNHE2dEFDSExY?=
 =?utf-8?B?NWt1L2pDd3p5NkVzajhKc0lKUHVNS05nK3QrNUlSVmF4dythaEduTUI1Y2pq?=
 =?utf-8?B?dUhwajkza005Tngwb2kxRmhEQklBTllna3lSNGlrYlFHcEhjVFp2YTNndlhh?=
 =?utf-8?B?R3dOVlV6MHhnb0xndnpabVFYZ0RHT05kUFpvN3hVeWVjbEdxUDZsU2FJNEg1?=
 =?utf-8?B?WUUwSDkrYm9TVTkzY0FwZ1hRVkdNWWlmQ0U3Zk1iTHhvd1UzOFRUYnQrVVJ0?=
 =?utf-8?B?OCtxRklFSHJicExKOTl3ZFIzU1ZoOFdpKzIzM3QrZmVoMlRRSWJNVVBrRzFZ?=
 =?utf-8?B?NHduM2xFN1lPQ3pFOTJzZ21XSkhicjRaMHlmdHFjZXBsa09PMWRGb1RUdHNp?=
 =?utf-8?B?VTgxSEEza3NFOGp1UTA1STFLOElaNlZhMlFOTHY4RzZrUWRkbzgzRERPYi9N?=
 =?utf-8?B?YW41WkZoQ2pvd3B6dEdOS3VmclRsMzFTZGM0ZEx5aTJIOGtkUmZ5NFZSNXR4?=
 =?utf-8?B?b0MyZmxzcnNrcHdhaWZoMkFBeHdWUkxiZFp5SUdzaWRKYnBxYnV5SXREVU5i?=
 =?utf-8?B?LzBsUmE1aW8rd3o2dGFSTzBKdXI5SkozWUo5akhBaCs3NWtpZ1h6LzkxdDlp?=
 =?utf-8?B?Q2t3a2FqdmxjMXBsT05xUEUzbnFTT1VhbC9FLzVZUTIyTHR0OXhFT0hJUXpa?=
 =?utf-8?B?d1Z4T1ppajB3cVJjS002UzExaTNRZTJnZFBKeE50cXozTHFHdEg4VVpnc1VE?=
 =?utf-8?B?MTFBWEppVC9IVnpZbUFiK0hteXdWemFLN3FxaXd6Tzlsall6SEVWdkJsWkRQ?=
 =?utf-8?B?QXcvZ0o2T3gvOUFTT0JZU1lZU0ZQeGVmRXQwSDVCSVo4emVpWGJLbzVyR0Jz?=
 =?utf-8?B?UkFUZmRZWThYc1JWc1lWZU9PQkhYdXJrT2t3Wmd6bi9yWEhrOFh1MWhxYzh0?=
 =?utf-8?B?MDlhRDRBSUJobHE2Sll2Mk5Yc1pQYUxneG9VRHNvT0Z0NDFJV1BJamVWR1hE?=
 =?utf-8?B?SVZKVU11dDEwRTdiN1lnUHV1ZWdrTlNIaGx3Tk5RTzk5K3hOUTBXNEhzQUFp?=
 =?utf-8?B?YWdib0R6UkRDKzVoN3FzOVA3dUh3cUNCanJIRCsvK0Z4UkIwU2JyOGY2OGhy?=
 =?utf-8?B?a2x0RDlUNGNxRnE0V3RZUVpMVkJqa01vZzFCeXpPYkZRRXRVeU5nU0dSM3lL?=
 =?utf-8?B?R1ByZlhVSVlGdUo1akgxb2xWNFVLQVhyKzBqVjZReVY0dGc5WnZTcXpnaThI?=
 =?utf-8?B?MjN4YkNPQ1o4Q1NlYlZiREZVOWVrcmhNN1A5cFZMWUc1eFg2aXZHaG9ZeG9W?=
 =?utf-8?B?a25obFQ1VnRmRUM0SVFDS0dCbFh4WUQ2UmViTTFFRldXeFBlUHVwSjhmV0Jw?=
 =?utf-8?B?RXF6WlRmWkhxS2J4cXpaQThiN28wZXhCOFNCNzB1eURhUFhuQlhPcENJL3dl?=
 =?utf-8?B?UmtPZlR6SE41eU1oYnR1Wk91dnpxczlIVHR1cXRUekVjeUJTc3ZVWFlJN2hy?=
 =?utf-8?B?OS9VZEUvT1FlNXU4S0hhMDhPOVlXNGJqV1FjbVRzOWtkNUx5cVNWaE9GcC8y?=
 =?utf-8?B?VUVZTUFSaTFTOERtdHVta0s5TVB3SXZlUTVUbVRTRDVIbHRFT2ZmTzZHUXZK?=
 =?utf-8?B?U2VzaDFDeDZ2ZGw0c3E4WlNHS0s2YjRoZmlmcXJ5OGlDdW04UWN4Z1ViVUpv?=
 =?utf-8?B?MWVDT2dOZE82QllTeHRmNk5TekI5LzBTQU5BeUM4VzRQdHEzcHg3VVFpUm5Y?=
 =?utf-8?B?UDBqNklsZFZNa2N5cDBpR3lqaWoxQldWZFcxL0l0eUJCRGwxWG1jRlIzUnhO?=
 =?utf-8?B?SVBCWStTRW1xY1hpbXYxN3ZTZVNYM3RFMzZDMmUyTy90enhTWEVxOHlmNDhI?=
 =?utf-8?B?Nm5ObUxlekxPL2pIbmc1bHBtV1ZsUytPNmUrNGlhQ1h1STRjTDNKdWxKMWZI?=
 =?utf-8?B?elpYZDZWcW5vVlJnaDVYdXZ0NVdML1VSNFBBRGY5dHNQN2EzMzQxVHVyTUxT?=
 =?utf-8?Q?3xyFmntXLSc3sdjcDp3dWxfF1R9Bfg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4E11237130836499FFC2EBE39F93E75@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ca99d56-3620-46e7-9d2d-08da0b65f0ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 18:09:28.7115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KLX9toHMFzdTPqqzQYBckGm0GLfGMjvpXBaYmE/PRFe+FgnFsEDeaI0DTZ+Oke+jp8HoVc4rIOv5sWhUoc5AHqDLsGxqL4NIk9tDj4YVInA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB8834
X-Proofpoint-ORIG-GUID: ZKnDuF-L4VcoStZiiOXTOpSU16z95FKc
X-Proofpoint-GUID: ZKnDuF-L4VcoStZiiOXTOpSU16z95FKc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=493 suspectscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 spamscore=0 bulkscore=0
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

T24gTW9uLCAyMDIyLTAzLTIxIGF0IDIzOjI1ICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IHRo
ZSBzdHJ1Y3QgbWVtYmVyIGBwaHlfbm9kZWAgb2Ygc3RydWN0IGF4aWVuZXRfbG9jYWwgaXMgbm90
IHVzZWQgYnkgdGhlDQo+IGRyaXZlciBhbnltb3JlIGFmdGVyIGluaXRpYWxpemF0aW9uLiBJdCBt
aWdodCBiZSBhIHJlbW5lbnQgb2Ygb2xkIGNvZGUNCj4gYW5kIGNvdWxkIGJlIHJlbW92ZWQuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBBbmR5IENoaXUgPGFuZHkuY2hpdUBzaWZpdmUuY29tPg0KPiBS
ZXZpZXdlZC1ieTogR3JlZW50aW1lIEh1IDxncmVlbnRpbWUuaHVAc2lmaXZlLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXQuaCAgICAgIHwg
IDIgLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWlu
LmMgfCAxMyArKysrKy0tLS0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgMTAgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQveGlsaW54L3hpbGlueF9heGllbmV0LmgNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxp
bngveGlsaW54X2F4aWVuZXQuaA0KPiBpbmRleCAwZjljODhkZDFhNGEuLmQ1YzFlNWM0YTUwOCAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0
LmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0LmgN
Cj4gQEAgLTQzMyw4ICs0MzMsNiBAQCBzdHJ1Y3QgYXhpZW5ldF9sb2NhbCB7DQo+ICAJc3RydWN0
IG5ldF9kZXZpY2UgKm5kZXY7DQo+ICAJc3RydWN0IGRldmljZSAqZGV2Ow0KPiAgDQo+IC0Jc3Ry
dWN0IGRldmljZV9ub2RlICpwaHlfbm9kZTsNCj4gLQ0KPiAgCXN0cnVjdCBwaHlsaW5rICpwaHls
aW5rOw0KPiAgCXN0cnVjdCBwaHlsaW5rX2NvbmZpZyBwaHlsaW5rX2NvbmZpZzsNCj4gIA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21h
aW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWlu
LmMNCj4gaW5kZXggNWQ0MWI4ZGU4NDBhLi40OTZhOTIyN2U3NjAgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiBAQCAt
MjA3MSwxOSArMjA3MSwyMSBAQCBzdGF0aWMgaW50IGF4aWVuZXRfcHJvYmUoc3RydWN0IHBsYXRm
b3JtX2RldmljZQ0KPiAqcGRldikNCj4gIA0KPiAgCWlmIChscC0+cGh5X21vZGUgPT0gUEhZX0lO
VEVSRkFDRV9NT0RFX1NHTUlJIHx8DQo+ICAJICAgIGxwLT5waHlfbW9kZSA9PSBQSFlfSU5URVJG
QUNFX01PREVfMTAwMEJBU0VYKSB7DQo+IC0JCWxwLT5waHlfbm9kZSA9IG9mX3BhcnNlX3BoYW5k
bGUocGRldi0+ZGV2Lm9mX25vZGUsICJwaHktDQo+IGhhbmRsZSIsIDApOw0KPiAtCQlpZiAoIWxw
LT5waHlfbm9kZSkgew0KPiArCQlucCA9IG9mX3BhcnNlX3BoYW5kbGUocGRldi0+ZGV2Lm9mX25v
ZGUsICJwaHktaGFuZGxlIiwgMCk7DQo+ICsJCWlmICghbnApIHsNCj4gIAkJCWRldl9lcnIoJnBk
ZXYtPmRldiwgInBoeS1oYW5kbGUgcmVxdWlyZWQgZm9yDQo+IDEwMDBCYXNlWC9TR01JSVxuIik7
DQo+ICAJCQlyZXQgPSAtRUlOVkFMOw0KPiAgCQkJZ290byBjbGVhbnVwX21kaW87DQo+ICAJCX0N
Cj4gLQkJbHAtPnBjc19waHkgPSBvZl9tZGlvX2ZpbmRfZGV2aWNlKGxwLT5waHlfbm9kZSk7DQo+
ICsJCWxwLT5wY3NfcGh5ID0gb2ZfbWRpb19maW5kX2RldmljZShucCk7DQo+ICAJCWlmICghbHAt
PnBjc19waHkpIHsNCj4gIAkJCXJldCA9IC1FUFJPQkVfREVGRVI7DQo+ICsJCQlvZl9ub2RlX3B1
dChucCk7DQo+ICAJCQlnb3RvIGNsZWFudXBfbWRpbzsNCj4gIAkJfQ0KPiAgCQlscC0+cGNzLm9w
cyA9ICZheGllbmV0X3Bjc19vcHM7DQo+ICAJCWxwLT5wY3MucG9sbCA9IHRydWU7DQo+ICsJCW9m
X25vZGVfcHV0KG5wKTsNCj4gIAl9DQo+ICANCj4gIAlscC0+cGh5bGlua19jb25maWcuZGV2ID0g
Jm5kZXYtPmRldjsNCj4gQEAgLTIxMjQsOCArMjEyNiw2IEBAIHN0YXRpYyBpbnQgYXhpZW5ldF9w
cm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiAgCQlwdXRfZGV2aWNlKCZscC0+
cGNzX3BoeS0+ZGV2KTsNCj4gIAlpZiAobHAtPm1paV9idXMpDQo+ICAJCWF4aWVuZXRfbWRpb190
ZWFyZG93bihscCk7DQo+IC0Jb2Zfbm9kZV9wdXQobHAtPnBoeV9ub2RlKTsNCj4gLQ0KPiAgY2xl
YW51cF9jbGs6DQo+ICAJY2xrX2J1bGtfZGlzYWJsZV91bnByZXBhcmUoWEFFX05VTV9NSVNDX0NM
T0NLUywgbHAtPm1pc2NfY2xrcyk7DQo+ICAJY2xrX2Rpc2FibGVfdW5wcmVwYXJlKGxwLT5heGlf
Y2xrKTsNCj4gQEAgLTIxNTQsOSArMjE1NCw2IEBAIHN0YXRpYyBpbnQgYXhpZW5ldF9yZW1vdmUo
c3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAljbGtfYnVsa19kaXNhYmxlX3VucHJl
cGFyZShYQUVfTlVNX01JU0NfQ0xPQ0tTLCBscC0+bWlzY19jbGtzKTsNCj4gIAljbGtfZGlzYWJs
ZV91bnByZXBhcmUobHAtPmF4aV9jbGspOw0KPiAgDQo+IC0Jb2Zfbm9kZV9wdXQobHAtPnBoeV9u
b2RlKTsNCj4gLQlscC0+cGh5X25vZGUgPSBOVUxMOw0KPiAtDQo+ICAJZnJlZV9uZXRkZXYobmRl
dik7DQo+ICANCj4gIAlyZXR1cm4gMDsNCg0KUmV2aWV3ZWQtYnk6IFJvYmVydCBIYW5jb2NrIDxy
b2JlcnQuaGFuY29ja0BjYWxpYW4uY29tPg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3Ig
SGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxp
YW4uY29tDQo=
