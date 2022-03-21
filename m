Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B7F4E2FB1
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 19:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352022AbiCUSNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 14:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350305AbiCUSNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 14:13:31 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9F611DD11;
        Mon, 21 Mar 2022 11:12:04 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LBsiVb016560;
        Mon, 21 Mar 2022 14:11:52 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewc33gv33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 14:11:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ln+YI1/rlDT/xp21JJWmzUCux4+KdXrrsce3s1KtzP3YaUFk0t1jrZ06N3Cqg5QBrRg7yrj09SHrCGPOcshRd7eykfhq4hG6yxd9PP58pQsxnLQPSDXVaukyJP0xTWYyxgij8eorv4CXYV2S72bJ2HzMntdKscgxqhS0zawfUmBUYvHbAApzqNHqwsx9Xh6RtHxuq9QW149HiZ3Mk8ZiBCADkRjaNv7px/DSJJa87bE3fDWbDMs2ZjhL6O2uT9Anb/6JdWOJIOQ6FvY5OSzV8ZfN5nfF+8DiEC62O/HWZwmoVeJ0DiHuTzKVo4R3xRdBv+8lzl9qiU1YO68fLS7IQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGogiSALxri0AjOnGu3y42VDeM9f00e0guADZ8cXqJk=;
 b=mXKcFaBOkvo9AT/L8PM8SFZbUM7VwwMRTji7Qg5SrwbtyGwoqPx4ixgm315pUf82mzLMsN1aA0n0xAdDHyjpuH1qc06hZmqkFEB9UTXWmLl3H58CpN2orlcZ4wfc0yU1hShEidXeM3gCJ2FoHX1ZeVqT0kDYLDFojahtaqF9Q1iIxojsCW9N5YpUPgqSsia5iGHzBVGRpRFp3kmqNFS/xNhylMnddBJjUy957cTmrl9OA8hqvs8ynewcvItVmut01avB3vChc70HqskPRXBl5LQPcfYSJ02aJTEadg75/4XfzjcRlIBQ4uC7OJTEfMekRJUwVLCh7bodeifFVEPkfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGogiSALxri0AjOnGu3y42VDeM9f00e0guADZ8cXqJk=;
 b=imMyXYMh7ttbP8iMkmttvIso0clxK917Aj6haIPE5mWVtu0orUEvj9VMxZBk+g5MGekhMGbkdt4Z/CfCJ1nwLYAxJlFiv3QyPYwTw4dvl85psA+1VRbetVgXeEthj0tY92sQNakWz8lFpalaVlnUVepIXXeNim1HyIpC8OWywxQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB3958.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:4e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 18:11:50 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5081.022; Mon, 21 Mar 2022
 18:11:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "harinik@xilinx.com" <harinik@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Topic: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Index: AQHYPTgrI7jLgAaz1UWtdS3v+RtT+KzJ+jUAgAApnoA=
Date:   Mon, 21 Mar 2022 18:11:50 +0000
Message-ID: <6fe3be1038463cf3155401650b42de89772ea5d5.camel@calian.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
         <20220321152515.287119-3-andy.chiu@sifive.com>
         <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
In-Reply-To: <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89a3e330-d010-4e8d-d433-08da0b664542
x-ms-traffictypediagnostic: YQXPR01MB3958:EE_
x-microsoft-antispam-prvs: <YQXPR01MB395814ED2AD402F31C1AFE22EC169@YQXPR01MB3958.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OLjkGEesLdaZySHeX22fAOwoC/TUymrlPIdbDlbM5DmT4DCkhpKfde3KkRTu7sZfmNt4OdUFCy8A0bZ3hWiNX3N9D759U31YcGJq3tHiFPKgfMI61LXD+ThkWhKZVnKXIMf4AVxw4vqm0dcIkJlGCPQrB/VdEYSwUxwj4LqpkfnvPMDuZ5E/ksRlknKNiuNPYIjAY344b6c3q2Ix4gtmlpTIe6xXSPshFa1eZPdEh5MhupBnbBBVek4H+RbeDQaKHAwtfD2UHYoSNayx2f6Hls5Ja41CeNhb9EGBk+kix5ryM6EVJocj5gr12juGD8q+TJE4uH6cXGM4GGoB674jRyRuxSrNzUAcf/vY1QzMRDLagL7/Om7/wGWb4ltohNpmRRlvTA65rsVkdJOjgYDrTAuvXea8+bPxoIq9uG37FVebBpOfcxWhfvauv4AItI8h2XOyQ47zt7F4Y4pYucaXj3Z6IX3s3N4yg1+sI+b5ZeQ5ndu012sRjsAeRWi+kS8lqEBuQpjk0Qh7xLwr5kKYj9vZsuNThxqX1OIUVjSQLlFZb3bXC4XiGDbgAFcbrua2fJ5e95mklsJSH+Yu5IxNCK/TRPyk9dZ/qQNNd1yATKqlQmIjJhm0PJkEg9dR/siGRZzPKmtSBy61PWFFWZPpxhrf5vek35ON1HtarsrTfmjssR9NxZW8pIIS5f/Bh4huuUvox9tGQHoaQ9DCPmGVbuj1ke2VWlKYWv4HyvFBBGo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(6506007)(6512007)(66946007)(66556008)(76116006)(36756003)(66476007)(6486002)(8676002)(4326008)(508600001)(83380400001)(71200400001)(26005)(186003)(91956017)(38100700002)(8936002)(64756008)(110136005)(54906003)(316002)(7416002)(86362001)(5660300002)(44832011)(38070700005)(66446008)(2616005)(122000001)(2906002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFhjcUpLK1AwdHJjRE1HRTNSR0F3S3NrSHV1TmxlUDdjTGZ5Q2hVNWxScDVL?=
 =?utf-8?B?LytZUzNqdmllenczR0ljNENkZytPSVJPN2dhLzUyWC9QRkFqNEMxNDV5RzJM?=
 =?utf-8?B?STZtaGhKOENaV3plUUZ3citCSGZpVUdPdW45cWVqa2RHV3I0QWNBOGV4NVZl?=
 =?utf-8?B?WGdQTTlweGFuK0tRbTVWdWlQYVdKOXN2SWd2L1k1N3NtSU9rcDNwSVdLalph?=
 =?utf-8?B?NkowZ1dlMkl0elBVeW9VeWNwWnJyd3p1eHJEV0dyYURPZnROSjJMTjh0cnFy?=
 =?utf-8?B?VkZpVkRSZ1JzbG1LWGozSXFyRmZLQnlZV09jTysyRUJsbU9pSDhuUWhwb1VP?=
 =?utf-8?B?b2xJTGQ1UCtUMVBCRUZOSjhJYVY1TXpzQ1dIMG5FcDBlYklWeWJMaEZtMEpL?=
 =?utf-8?B?RVlOQTdoQTB0c0djaUdOQTdtZFNHemV5YlBiQXdzNityUFpzbTM1Uk1vTHcx?=
 =?utf-8?B?N1JwRlY0Rkowc3pjaVR2bFpKR001QkFERjBSbzJSQkhtOXBsSDlIbzJBdktx?=
 =?utf-8?B?bmpsZzBaL1hnTHBYZlNib1ZCdVAwNy8vV3BWM2tIb1diZUIvNXlKSURGemVM?=
 =?utf-8?B?clFORE82ZFNMOUh5Y1A1R3YxU0lwOW02WXlaZVJFcFh6R3A4anRWV3lQMExB?=
 =?utf-8?B?ZUl5eGFDWGtPNHZyVW8rL3JFbHcwYTh5U2FQUkdrM2t6eDdlY2hibWIrN0Zq?=
 =?utf-8?B?QkNEaDNZQndFTWJMUzFnUURsRkgzdk5GU204SWtGTkhQdE83QWUxNGFDRHg5?=
 =?utf-8?B?TEszU1V0QlQreXlBWXYwT2R6bVJVNzhVT2plQmNQSGd1YmNFbUhDTG43ZEoz?=
 =?utf-8?B?ZmV6NmxoSFJ3WVJGTUNzMURtcURCdmowSkVGMzM1VVZlemljaGNjUnVjbjBT?=
 =?utf-8?B?ak8wQ2t4dGdGR2tJTkpVRWt0d09vbFJVYllFUUN5eXFMYjJKS0NPaDJWWDBs?=
 =?utf-8?B?WU52YTdnMmRvWnl3RFd0NnF2MTNaekhWVnBmZG82Q2M0SGlhVTZJcUJVT2ZZ?=
 =?utf-8?B?aDJrY3k1Rm5wQ1F2eFRmZ1dSRFlGZ3ExRTJ6ZXd2VkNhNkVZdGZLNXNyL1FL?=
 =?utf-8?B?UUo3cDdNeGt5SXdVanJ1bHpZcmdlWFJ5ZVBqaEJ1ODRMa0hzbUh0QTVKdTdv?=
 =?utf-8?B?NHFZUnpYaEk1U01wejAyam9nVzlFZkwxZDNXYlZTOHVnSHhTOEtYcTBqRGJz?=
 =?utf-8?B?UXc1QlMvV0lDNGI3cUs3N2lMOXJjNWF1cjFDVzNqeVFZL3ZYT3lBWjNxc0ls?=
 =?utf-8?B?N1BOVW94NFE0clZycmwrQ1FxTzhDc3ZRdDd3VmVkdmNkYUhpT1lnbDV3Y0FD?=
 =?utf-8?B?M1I2WWc2Ui8zQmNLVUpQU2prQVppMEJTc1pXTVlOS003aStUcmtTMmxEYVNp?=
 =?utf-8?B?c253VVZyd2hNWHIzQVFpVmJ6N3pYTEFZUnBCT0gzWUM0dFhidmxxRDdndUpV?=
 =?utf-8?B?NHMxbnlvZWZtaDF4STRSWjlpK1ZKakhiTFpSM2pkdnZSZUdyRm5VQTJpd0F0?=
 =?utf-8?B?amt4RXl6eGtxUWdxMXNWWFdvZFR2UURKOXFUK0tNTGNQS3lkNlFGL2N1K2hm?=
 =?utf-8?B?RGlWdFAxMUhuUkV5Yzk5TURTK1pIZSsrQzdDb2V6N3J2dFpqY3ptQ29QalBl?=
 =?utf-8?B?QlVmVjJrM1I4b2hBWTROT2dKTllsaC9sVkhIaW1sNDFrVGFaUUN0VnZhc25O?=
 =?utf-8?B?cGFHcDdRZHlXTjl4VFNZTC94WjAySlFXb0d1YmtmZno0Yk9HQjlwRlY1aGps?=
 =?utf-8?B?Z2IxUVJXMGx4eWFnVjlkLy84ME9CN1dqeEFwTGRWeExSZDEwZjNsZEFaMmRM?=
 =?utf-8?B?TlhrUUpPeitnVk1mOWt5dWpyTTRvSlNVQURpZW91STBPN1JGTVFIZ3Z5UXpD?=
 =?utf-8?B?dEs0L25ydXJVZ2xvbjJ6NWJkMlRLWHFPZHFTcEFya2NDamJWZXA0NG5NaWtY?=
 =?utf-8?B?elVtaHgrbXV6UUVCMFBpS0hsTEtWeVl4NitVa0wvajA3V0dPdUVXY3dCWllY?=
 =?utf-8?Q?35kS2ahQkq2OlA0emOAGqtlBo5vU64=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <81519A2B1375AC499B7F64780C2CAACF@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 89a3e330-d010-4e8d-d433-08da0b664542
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 18:11:50.2092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 446Cyi0dIKW5ESYxnHIVL70r0zLgAxs/2xw0ycwEHDNtiHHV4Du4zSpqvvxZoy9EIuKlDeHxOOCnluX6CGLrNiJcV+iaHAseQzTZdNE9nmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB3958
X-Proofpoint-ORIG-GUID: fbXxXqEXgBadgIAsQKTMAb6cA7ueJGIl
X-Proofpoint-GUID: fbXxXqEXgBadgIAsQKTMAb6cA7ueJGIl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_07,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=904 suspectscore=0
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

T24gTW9uLCAyMDIyLTAzLTIxIGF0IDE1OjQyICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogQW5keSBDaGl1
IDxhbmR5LmNoaXVAc2lmaXZlLmNvbT4NCj4gPiBTZW50OiBNb25kYXksIE1hcmNoIDIxLCAyMDIy
IDg6NTUgUE0NCj4gPiBUbzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5c0B4aWxpbnguY29t
Pjsgcm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbTsNCj4gPiBNaWNoYWwgU2ltZWsgPG1pY2hhbHNA
eGlsaW54LmNvbT4NCj4gPiBDYzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3Jn
OyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPiByb2JoK2R0QGtlcm5lbC5vcmc7IGxpbnV4QGFybWxp
bnV4Lm9yZy51azsgYW5kcmV3QGx1bm4uY2g7DQo+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IEFuZHkgQ2hpdQ0KPiA+IDxhbmR5LmNoaXVAc2lm
aXZlLmNvbT47IEdyZWVudGltZSBIdSA8Z3JlZW50aW1lLmh1QHNpZml2ZS5jb20+DQo+ID4gU3Vi
amVjdDogW1BBVENIIHY0IDMvNF0gZHQtYmluZGluZ3M6IG5ldDogeGlsaW54X2F4aWVuZXQ6IGFk
ZCBwY3MtaGFuZGxlDQo+ID4gYXR0cmlidXRlDQo+ID4gDQo+ID4gRG9jdW1lbnQgdGhlIG5ldyBw
Y3MtaGFuZGxlIGF0dHJpYnV0ZSB0byBzdXBwb3J0IGNvbm5lY3RpbmcgdG8gYW4gZXh0ZXJuYWwN
Cj4gPiBQSFkgaW4gU0dNSUkgb3IgMTAwMEJhc2UtWCBtb2RlcyB0aHJvdWdoIHRoZSBpbnRlcm5h
bCBQQ1MvUE1BIFBIWS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbmR5IENoaXUgPGFuZHku
Y2hpdUBzaWZpdmUuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBHcmVlbnRpbWUgSHUgPGdyZWVudGlt
ZS5odUBzaWZpdmUuY29tPg0KPiA+IC0tLQ0KPiA+ICBEb2N1bWVudGF0aW9uL2RldmljZXRyZWUv
YmluZGluZ3MvbmV0L3hpbGlueF9heGllbmV0LnR4dCB8IDggKysrKysrKy0NCj4gPiAgMSBmaWxl
IGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+IA0KPiA+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hpbGlueF9heGll
bmV0LnR4dA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxp
bnhfYXhpZW5ldC50eHQNCj4gPiBpbmRleCBiOGU0ODk0YmM2MzQuLmJhNzIwYTJlYTVmYyAxMDA2
NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hpbGlu
eF9heGllbmV0LnR4dA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQveGlsaW54X2F4aWVuZXQudHh0DQo+ID4gQEAgLTI2LDcgKzI2LDggQEAgUmVxdWlyZWQg
cHJvcGVydGllczoNCj4gPiAgCQkgIHNwZWNpZmllZCwgdGhlIFRYL1JYIERNQSBpbnRlcnJ1cHRz
IHNob3VsZCBiZSBvbiB0aGF0IG5vZGUNCj4gPiAgCQkgIGluc3RlYWQsIGFuZCBvbmx5IHRoZSBF
dGhlcm5ldCBjb3JlIGludGVycnVwdCBpcyBvcHRpb25hbGx5DQo+ID4gIAkJICBzcGVjaWZpZWQg
aGVyZS4NCj4gPiAtLSBwaHktaGFuZGxlCTogU2hvdWxkIHBvaW50IHRvIHRoZSBleHRlcm5hbCBw
aHkgZGV2aWNlLg0KPiA+ICstIHBoeS1oYW5kbGUJOiBTaG91bGQgcG9pbnQgdG8gdGhlIGV4dGVy
bmFsIHBoeSBkZXZpY2UgaWYgZXhpc3RzLg0KPiA+IFBvaW50aW5nDQo+ID4gKwkJICB0aGlzIHRv
IHRoZSBQQ1MvUE1BIFBIWSBpcyBkZXByZWNhdGVkIGFuZCBzaG91bGQgYmUNCj4gPiBhdm9pZGVk
Lg0KPiA+ICAJCSAgU2VlIGV0aGVybmV0LnR4dCBmaWxlIGluIHRoZSBzYW1lIGRpcmVjdG9yeS4N
Cj4gPiAgLSB4bG54LHJ4bWVtCTogU2V0IHRvIGFsbG9jYXRlZCBtZW1vcnkgYnVmZmVyIGZvciBS
eC9UeCBpbiB0aGUNCj4gPiBoYXJkd2FyZQ0KPiA+IA0KPiA+IEBAIC02OCw2ICs2OSwxMSBAQCBP
cHRpb25hbCBwcm9wZXJ0aWVzOg0KPiA+ICAJCSAgcmVxdWlyZWQgdGhyb3VnaCB0aGUgY29yZSdz
IE1ESU8gaW50ZXJmYWNlIChpLmUuIGFsd2F5cywNCj4gPiAgCQkgIHVubGVzcyB0aGUgUEhZIGlz
IGFjY2Vzc2VkIHRocm91Z2ggYSBkaWZmZXJlbnQgYnVzKS4NCj4gPiANCj4gPiArIC0gcGNzLWhh
bmRsZTogCSAgUGhhbmRsZSB0byB0aGUgaW50ZXJuYWwgUENTL1BNQSBQSFkgaW4gU0dNSUkgb3IN
Cj4gPiAxMDAwQmFzZS1YDQo+ID4gKwkJICBtb2Rlcywgd2hlcmUgInBjcy1oYW5kbGUiIHNob3Vs
ZCBiZSBwcmVmZXJhYmx5IHVzZWQgdG8NCj4gPiBwb2ludA0KPiA+ICsJCSAgdG8gdGhlIFBDUy9Q
TUEgUEhZLCBhbmQgInBoeS1oYW5kbGUiIHNob3VsZCBwb2ludCB0byBhbg0KPiA+ICsJCSAgZXh0
ZXJuYWwgUEhZIGlmIGV4aXN0cy4NCj4gDQo+IEkgd291bGQgbGlrZSB0byBoYXZlIFJvYiBmZWVk
YmFjayBvbiB0aGlzIHBjcy1oYW5kbGUgRFQgcHJvcGVydHkuDQo+IA0KPiBUaGUgdXNlIGNhc2Ug
aXMgZ2VuZXJpYyBpLmUuIHJlcXVpcmUgc2VwYXJhdGUgaGFuZGxlIHRvIGludGVybmFsIFNHTUlJ
DQo+IGFuZCBleHRlcm5hbCBQaHkgc28gd291bGQgcHJlZmVyIHRoaXMgbmV3IERUIGNvbnZlbnRp
b24gaXMgDQo+IHN0YW5kYXJkaXplZCBvciB3ZSBkaXNjdXNzIHBvc3NpYmxlIGFwcHJvYWNoZXMg
b24gaG93IHRvIGhhbmRsZQ0KPiBib3RoIHBoeXMgYW5kIG5vdCBhZGQgaXQgYXMgdmVuZG9yIHNw
ZWNpZmljIHByb3BlcnR5IGluIHRoZSBmaXJzdCANCj4gcGxhY2UuDQo+IA0KDQpUaGUgcGNzLWhh
bmRsZSBwcm9wZXJ0eSBpcyBjdXJyZW50bHkgdXNlZCBpbiB0aGUgRnJlZXNjYWxlIGRwYWEyIGRy
aXZlciwgc28NCnRoZXJlJ3Mgc29tZSBwcmVjZWRlbnQgZm9yIGl0LiBCdXQgSSBzdXBwb3NlIGlm
IGl0J3MgaW50ZW5kZWQgdG8gYmUgYSBzdGFuZGFyZA0KbWVjaGFuaXNtIGl0IHNob3VsZCBiZSBk
b2N1bWVudGVkIG1vcmUgZ2xvYmFsbHk/DQoNCj4gDQo+ID4gKw0KPiA+ICBFeGFtcGxlOg0KPiA+
ICAJYXhpX2V0aGVybmV0X2V0aDogZXRoZXJuZXRANDBjMDAwMDAgew0KPiA+ICAJCWNvbXBhdGli
bGUgPSAieGxueCxheGktZXRoZXJuZXQtMS4wMC5hIjsNCj4gPiAtLQ0KPiA+IDIuMzQuMQ0K
