Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941B14DDF62
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239399AbiCRQw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239392AbiCRQw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:52:58 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F0370CC1;
        Fri, 18 Mar 2022 09:51:38 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22IBr8WI004639;
        Fri, 18 Mar 2022 12:51:16 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3evfvtrfcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 12:51:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GhEgvrfmp07/QXLoUeJwVTS+yoENmM8MAf8k28UOaIM5eA2rh9DHJtzWwMFWIccrjiyLL+FvyvXSlO3sZFpKCnDEbpOYA13hf1NOxCjM//2P2TIYEB6jfVnUsLB0+TWsSdxvJKLFgV3GS1KsxznpjwIryIceOB2UEMFuEL+/fXuRqj3WVbyHYh4T8GNWZQcDACyhOPvL05nonf8EGwM0Ie/uAEMr19IjNY/ArElvLgc5TIBECBTjNeKuoD80HKs9WKhUr2KyqxOlRg2ZdUCpN2gUFZUAeeAc7IzuAyXfIKhmUgp9xVmxmD4jU9dZhZlol2AvVVKV76CKXMCSZCb3Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kULSm+3t7FExpMKcLSowqxIvp93wg9+6yhYe4XQokEU=;
 b=O8roRqy11DG3l98Tkmt9r7Dqubm/eB5CO3ewvikOR4RTBjlixkeXDTE4T6UvN+o8EIIL8YHf0EEXPfj0VxNblca7i8Ov86qfaxRKaN8B3wR9uN9QRlZgiWrM1y2evyLRAK1liFSS7mD30qQGzHsnqoDEJgteLSNHQCnGstP+RxVx9T1y4dWTPzVovOX7YNtOgMaqnbYsKqTr2359kWFzQQZmVCBqXWOms5hbWPT5QJ2fI0lLoAXaDuVVFSx0Bv2gK+GCZQHMcHJjVsH+eE/XxLVhcbPu+2gslARF/1VuLQZ9I/xnyDF6iMK9jUf8E1SRmnFix+3QKqH1oFC5Mq5ygA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kULSm+3t7FExpMKcLSowqxIvp93wg9+6yhYe4XQokEU=;
 b=HyIa9jwR4rQaLkRkd8NIw+pirRP7otVhrZvx/OvXpH65vaj2z6LBijZKSAliLjGwyvMD8mEzb2+L46UZ1OHw3QZgYyTJA3rynvZrvP5r4A0GKB8WNJZcFYvANnIlCUWoxuqMckn3+Us3udy0eC+cbRd0zxhqXCJoTiRQ/W8hzSQ=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6311.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 16:51:14 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Fri, 18 Mar 2022
 16:51:14 +0000
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
Subject: Re: [PATCH v3 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Topic: [PATCH v3 1/2] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Index: AQHYOpY61BbvkFPq5kyCwVOJmTYkAKzFW5UA
Date:   Fri, 18 Mar 2022 16:51:14 +0000
Message-ID: <0e9b6f1e35b7b370d248adefc6f71cac6d5725cf.camel@calian.com>
References: <20220318070039.108948-1-andy.chiu@sifive.com>
In-Reply-To: <20220318070039.108948-1-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 644b90cd-f712-4ee6-2811-08da08ff83ec
x-ms-traffictypediagnostic: YT2PR01MB6311:EE_
x-microsoft-antispam-prvs: <YT2PR01MB631174FC1547CA98B841D384EC139@YT2PR01MB6311.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BZuFQum3A4pP4oaGGROofnndnDKhfM2mYLr/HZQrBULxh00H7BywWC6ijBpDOTecCPAnaRtnUfXbnfVtQdBZVtgXnAlpT5RNvtWfh6QBnUYsp754r3CBDRFeTt68CChIOrqfRh7ypfRvQU+izRjbQZacqJFGFN07cCJryiVu2st/oHoZdNg1JjuCQRD2IQQmPXxHt4vmFRfvdYxmJ3nKwwoeO1xRLEshESrjgNS0edSm4wHnPcz8PzqW9SwuboFVBakgcDBcK0lHXm3Mxx5depiX8Xtcn50Xg+ODuSRiKpZYz7Dd5FtDRxYIcPU8yvXK6oKR1cIzVFkXqM4pk90KXcrqNtO7XeyemH6ytuJePcioMDh39Q9XpjmbaMB1NmABG/CnAQw+MG67Wn1Eum8z8st/rZOHJNfXNn255D3TOnbBfZTDml4y1pCBrXTnhHlpudhS1QQgCE/B17ySCuiqZPGFE5OctYQ7Hj2bqME/uupewrswhaKq9mkY9AXGehj1ASUUeIMDTQHzQcOiRTWFwxR78185VBzoRmWvmmAD/x0agast4w2S/PjlcoxM1O+1PwwIQL/F8CEE2dNVexTPF0sJacjyA88dXFi9SEnzChtmQybn/gNwysTeYRey6e/X6VbYm7nqT1MMTYdKmNzpPBFF+B5sUuLDn7KBITP2SQn1HLl6vfdbF8jbtfraoU8oDWv9w7MHR+5ds6V962SZNwutwdxNfkXaaU+9HNeCSqGnwEXfAGEVU0YzdW1tuxKy6pNkVwAbOZzkmNCnCl0PZt95VV/l8n2x2dnRgHCNdbtNPNTnbLsWw7BPqgBGE5mgzPaNDxeMcqQrgnmgjXCzZq7pYBGKLEQAgagfqiBHfvg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(54906003)(26005)(6512007)(316002)(186003)(36756003)(2906002)(38070700005)(2616005)(44832011)(8676002)(7416002)(508600001)(122000001)(8936002)(83380400001)(76116006)(6486002)(71200400001)(91956017)(5660300002)(86362001)(110136005)(4326008)(15974865002)(38100700002)(66946007)(66446008)(66556008)(64756008)(66476007)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGVmbkhFN3hlVkNRTTIrYTBDTUdLM09rd2lPMnI5dEloNktyc29YdDJmd2tP?=
 =?utf-8?B?Sm5HV0o2NGFLMHFUaWI5c0gvTmt0QUxjOS9kRDNvSmlWNXBKdldvN3RLVkdS?=
 =?utf-8?B?YkRWRDNvS2RUZDlzNW9iNFhCQlVKenA1bzlYOHBmOUw5NllsOUx0c2VJc1NX?=
 =?utf-8?B?Yk1iWkVGK0NERHM4K2JnbXllYWNsNFo0RGRUNlRwYUdMTEJQUGRGYzljdmVT?=
 =?utf-8?B?UEhFMjNXK016azhXME1CNS9aQ2ZSTldZVmxNOHhPc0FmL2lvcDJSVDUzMStL?=
 =?utf-8?B?anRBaW8vNHFRN0dyekI3Mk1oVUFEMEhtZ0UxUmtlMUQ5ZzUyN2F5V1E4b0hm?=
 =?utf-8?B?WEo1eEtQamN3dFg4YS9XOHhibVpUbnVTRlVxWitzTitxRVJ0WEJia0VqZng2?=
 =?utf-8?B?MXBIQmlPL3RWclZTUnQvVEh5U1RKMkFvelFJd0xLUk51clowL1diMUh1Mzlr?=
 =?utf-8?B?dTU5WDd1L09YUHE4MXhjV21BeDhzN1ZsaFRFN0FxKzhTQVk5eGg4Y0dxeUp0?=
 =?utf-8?B?NVdia3hBbGNRZ21UZUFOWXpVNXJ5WllkM2lJMW05UldnQmNHa0s5MHc4Mm80?=
 =?utf-8?B?cFd0dkl5SlJDeDBTaUVVQXpXeG00VVNVTFRSdlBidmMxdDhQUVJBL0l2Ym5M?=
 =?utf-8?B?bVVRdFZrd2d4YnQzQnM2Y3hoTHd3K2NINTA1ekhMeTZJNWN3NXdlREg5KytH?=
 =?utf-8?B?em16Z2RTV3ViN0FhNzN0SW4ySnYvSStWR01hbjdQWXNrSjBNczI4bjBGSjV6?=
 =?utf-8?B?OWE1TkF3QzIrNjZST1N6SG1HYlR2OERyb2ZNZDZzdGRmcVMzc3B1QUk5OE1T?=
 =?utf-8?B?L1RQTUtnVVJmSjM3K25abnRMSEhuU00xb0NoTUY1MDVZUFQvWkxGSkZCVjBY?=
 =?utf-8?B?Z1cxY0JmeVBKMjhmcG5TSGdGUWltNk05cXJRaDZZWDM0ZmUxNUV0TUNIRG1m?=
 =?utf-8?B?M2NXaXN4cW9IQTUxaXlaZ0M1VDZvK0dnWVRsOWphb3lId1o2ZmtjNDZiMzUr?=
 =?utf-8?B?K0N3Q2kyV2JaUDVqT3QrdkhPRGtzeUlNSlVock9XVWxhWkpHOVdoWldHUmNW?=
 =?utf-8?B?YVFwbFdON25TRXJmYmxTN3FEcFpDbWZ1eVR6bTdSaEIwb2M3ekJCT0RvOFNj?=
 =?utf-8?B?U0pQNXhXdzg2YUVrdzduaThmZXJUN2RoNVEwaS8zSnFrM0pqeVVoRW1QZEYx?=
 =?utf-8?B?VjQwZ3VNUmRzQWV1NlY1UWdvb0xjUlg0YVBMRUw0eUNWU2RxMVR4dTlCeDRr?=
 =?utf-8?B?aE5JejJPbDRzV0IrUGZhT1BJZWErNDZvb1FnZEdPSWtYVjREQjlvTklnWjdK?=
 =?utf-8?B?NHlCam5BRGpCSjJzSHUwZGxKQjVzNlRiVDZXSlJjbWRjLzhrL0FRZW93d25l?=
 =?utf-8?B?eHkyZUdGNmxqL0FISFhKbmcvNlZzeHVTSHRCRFBhTlMrbTg4K2RTWTlGNU1G?=
 =?utf-8?B?VDJRMGFSRXZYdzZCdWtKcitUa3dtaDJ6NFdzZHZlcW55aGlRVVRKbkdGRFIy?=
 =?utf-8?B?dk96RHVpOFlKbEd5OGRsc2RrQW00cllnNm1iUnd1ODVmbzJWbjUwL3ptT0RO?=
 =?utf-8?B?MWQwSHIxVzVxK0ZBRENOM3FJZUYxMDRKdUZQRjBHRWRkNnV3RmlPOEdGOHVX?=
 =?utf-8?B?dnVPMGFieEZXZTFXMWZSSWpnakxJbXFCY0VuOXBRVTNoaXZWK2FCaG1RYTNm?=
 =?utf-8?B?QlN6Mk9kZG10N01OZ1MrbEM3aXR1Vy85OHNoU2RzTnFLYSs4TnBNcXVkZDlF?=
 =?utf-8?B?VEV4cFlFNUt4eGZ6NHFkeWFNWWd6QVllb25jQ3VYWCtMYmFNVzFPa3VNOURG?=
 =?utf-8?B?NWJQV3Z2TFF2NnFXMHIwK21ncmc0ZVBpYlBJWmUxbWZ1Q2V1U1d3N21wN3BP?=
 =?utf-8?B?TFZ3WkFQaUlLR3ZRcW8vaXpqWVhxQ1FzSElCSkFuOEFJMDlWZVdxeU0vdlNk?=
 =?utf-8?B?cEc0cnpFRE9JQ2FJRmJEMy9iT01oTzk5MDEwWVRhaldsWmpvL0JyejZkWWR5?=
 =?utf-8?Q?2+z5SfR/GYH2Oz0totB5zwh58E4wMs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <05FA3BC45F98ED458D588AF43061621B@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 644b90cd-f712-4ee6-2811-08da08ff83ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 16:51:14.9008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GEcU1rJOsMYwEbj1b7kY2K3sfAAGjcAAQb1k7iH2O8szimQf21uROEyhN1efoRZrHOhY/u5V2uqy+qKMiiNhcMLjD/n1VCvTvcteNWLypt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6311
X-Proofpoint-ORIG-GUID: gf6yTeuEFp3pUj29tEiEV58Kbw9M6Gog
X-Proofpoint-GUID: gf6yTeuEFp3pUj29tEiEV58Kbw9M6Gog
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_12,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=882 lowpriorityscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180089
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAzLTE4IGF0IDE1OjAwICswODAwLCBBbmR5IENoaXUgd3JvdGU6DQo+IERv
Y3VtZW50IHRoZSBuZXcgcGNzLWhhbmRsZSBhdHRyaWJ1dGUgdG8gc3VwcG9ydCBjb25uZWN0aW5n
IHRvIGFuDQo+IGV4dGVybmFsIFBIWSBpbiBTR01JSSBvciAxMDAwQmFzZS1YIG1vZGVzIHRocm91
Z2ggdGhlIGludGVybmFsIFBDUy9QTUENCj4gUEhZLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW5k
eSBDaGl1IDxhbmR5LmNoaXVAc2lmaXZlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IEdyZWVudGltZSBI
dSA8Z3JlZW50aW1lLmh1QHNpZml2ZS5jb20+DQo+IC0tLQ0KPiAgRG9jdW1lbnRhdGlvbi9kZXZp
Y2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQgfCA1ICsrKysrDQo+ICAxIGZp
bGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQNCj4gYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hpbGlueF9heGllbmV0LnR4dA0KPiBp
bmRleCBiOGU0ODk0YmM2MzQuLmEyZmEzYmVmMDkwMSAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQNCj4gKysrIGIv
RG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQN
Cj4gQEAgLTY4LDYgKzY4LDExIEBAIE9wdGlvbmFsIHByb3BlcnRpZXM6DQo+ICAJCSAgcmVxdWly
ZWQgdGhyb3VnaCB0aGUgY29yZSdzIE1ESU8gaW50ZXJmYWNlIChpLmUuIGFsd2F5cywNCj4gIAkJ
ICB1bmxlc3MgdGhlIFBIWSBpcyBhY2Nlc3NlZCB0aHJvdWdoIGEgZGlmZmVyZW50IGJ1cykuDQo+
ICANCj4gKyAtIHBjcy1oYW5kbGU6IAkgIFBoYW5kbGUgdG8gdGhlIGludGVybmFsIFBDUy9QTUEg
UEhZIGluIFNHTUlJIG9yDQo+IDEwMDBCYXNlLVgNCj4gKwkJICBtb2Rlcywgd2hlcmUgInBjcy1o
YW5kbGUiIHNob3VsZCBiZSBwcmVmZXJhYmx5IHVzZWQgdG8gcG9pbnQNCj4gKwkJICB0byB0aGUg
UENTL1BNQSBQSFksIGFuZCAicGh5LWhhbmRsZSIgc2hvdWxkIHBvaW50IHRvIGFuDQo+ICsJCSAg
ZXh0ZXJuYWwgUEhZIGlmIGV4aXRzLg0KDQpTcGVsbGluZzogZXhpdHMgLT4gZXhpc3RzDQoNCj4g
Kw0KPiAgRXhhbXBsZToNCj4gIAlheGlfZXRoZXJuZXRfZXRoOiBldGhlcm5ldEA0MGMwMDAwMCB7
DQo+ICAJCWNvbXBhdGlibGUgPSAieGxueCxheGktZXRoZXJuZXQtMS4wMC5hIjsNCi0tIA0KUm9i
ZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRl
Y2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
