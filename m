Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4751C6A0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbiEESAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 14:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382955AbiEESAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 14:00:51 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46C054BF6
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:57:08 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245BTvr3012732;
        Thu, 5 May 2022 13:56:54 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fv458gmbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 13:56:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3fTPQqt4pgxDEaZFPWAx7l8Y7auFESWjt3VscW70qYnjqDerEHfq2PCHU37V3H2JaA1i4BqtCIN8nLOU8aS6cdZ1KyU2dzSImioWKIrqoFKtYLlQWLRTyuSlF0LbDih9Nx12uCJGWF/E5J6MGP0cy2TfFCmReJsTL/Uv1KH6EnUCwLWyNC/2aVrQ6mlYWtgPIry465lvNQ9EHxJv2HutB5OxHAknMxYRlkreWs1CrIQ/1tCsuqKOihNSLrzEXYUwYa8pCngcsvnINO8aEE1BkH8/5iiDq3IiRV6VWLaYf93rGVCC5LmOX4OIjxgx19i0550hL5GHeKrhe/Tk2ogMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fklAhmaMKX8PCQ8evBcGHCzjiS5KV0ce6P3VzupTscM=;
 b=UimndWcdOEy3RxtUprxrYo9LbQHVo3QjIiFDrDl/ZCzuOH9LWBv9puM98Dd3i+LtGV4v4VKwPQw/EbnOEaeCUJ/GcAuEHRItG7HV/6ZvhP7/dcHuxuxyAP9fPCTRRFIakv8g8xqwyRpgFAUzttGodz6kURUzy1PlREdYSi8Yo7fBy9rg3D6ead8kgBfNsBCIFFZCtHb1qvHnfVuigLMCqS/Afalli9BWWo38Y3zgQIBXfhrsoLUHWYnDlWuQMw8Clz3NkZ9NtKeFFjHVSSWdc3wKy/RHPmjgLTM3osYnhXD/7H54zkudB7MHeilfdDHtPMDAAw7yWIGb/dfcZViZPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fklAhmaMKX8PCQ8evBcGHCzjiS5KV0ce6P3VzupTscM=;
 b=PRKSWWrRtZ9KdNTzUppHeOAYGYGBAY1K0T67y05Gg3ll8lLZTOiuuoIQ+5V5aD8PYaNof3PbeYkm4q+aSacYlORNETihBB59t1cnMsLtMKhHmoUoCWh757Jeykt0NnEefm+Rvsb+3nHR8R+HZwjb16phGRjfybD/9AFEuG8BU+I=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YQBPR0101MB9357.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:60::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.14; Thu, 5 May
 2022 17:56:52 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 17:56:51 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>
Subject: Re: [PATCH net-next 0/2] MACB NAPI improvements
Thread-Topic: [PATCH net-next 0/2] MACB NAPI improvements
Thread-Index: AQHYXBjpJhYmpgkJsEGVA+mZ9XZ3ya0QmsyA
Date:   Thu, 5 May 2022 17:56:51 +0000
Message-ID: <4ae0701c105276b78e2bf6b69fad48a429cf4422.camel@calian.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
In-Reply-To: <20220429223122.3642255-1-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fd95ea5-0f9a-4394-0160-08da2ec0a264
x-ms-traffictypediagnostic: YQBPR0101MB9357:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB9357FC8755CD3D9663913C67ECC29@YQBPR0101MB9357.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wjiLlolpwGqtPdh6UVWjOli1Go6yVJSXzNdnmryfWoo/Ffqn1dPraXPDCY1vxb7qtHFkzYdSp4Awx17ygeFIkrTJhmC9GKIKZ2HwHcXKolYAYSaNedParALsV9HxtX4ltMDit5ttHi+O48LuNChf7swWPWsz6lwAEu7QvBOAIPC6mANZcI/4AHFaITFr2uhjlaSNR/32tc7CRAAt/NaWGV8HYhhA0ixoqGj3q3euQ6oJwcliyTMrGTAevYE3BnuoJQLdoSGjV9nUwhJGWBloabLw89IcDWy3Vzp4gUb5jc0phFQAwvMGB+2m95ygdTi9YkGE/IOhvIy80l/W5NAt9tbgwsdiKXwB6n4Rcc7zsLbHayAKJE10NFBIligQIb4RNoBY8MTYVt4JWmKqJmvkA/jmj3a9dDbeTkS/b4wD1HNSla5sco+AKjAYxZe0KBM/5eaee5gRZF2MFUrqT2Lj8PxnaKSg7hm8mgpKsDTrhb3hPFSy/VdAKlNfN7UM/EZRH6EHCa/mYSu0OfJwgxGbFEWAYUX55wfClMZf9n0nDtQ/2mO9w8D32rEUG7fe9cl7y7lAJWHR/5JUYpnw1w1e05IvmiqkxFQCLIf8ctxo6bXcMuFd/cRJwnajvjp/gNzMtuFpePaa4SwYEww3ZR5V9qPloPrmL1BQ0gMPEr2sm+w3uBauNZEbee/lpPtdqRtlMJtAqHEy+ybt4AkCUhLMEM1BHJA9BZwvLAjDECJLHaYnwVH9Dm9wrQr6TYrx3jvjS/5ZQhR8XlvolDyHLOCKWjQ+u6/diDuu1thiuJGWEMdAU/4EFyHOgh/Oy5cGlJTKOhiMQ1we3vdgf/ROfKXW+Hlwabgbqyd1bWXCp+JEOS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(36756003)(86362001)(508600001)(186003)(8936002)(76116006)(66476007)(4326008)(5660300002)(15974865002)(44832011)(38100700002)(122000001)(38070700005)(4744005)(66946007)(66556008)(8676002)(6916009)(83380400001)(71200400001)(316002)(6486002)(26005)(6506007)(54906003)(6512007)(2616005)(66446008)(64756008)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WW1MUUl6cGJLeUVOMkQ4QXlaQ1lFRWk5cTIwcWVWTWNHSStTajJLN3pFU2pC?=
 =?utf-8?B?MXg4VVArbW9lQk45UnpVeUlZSW8xYk1lbmM0emFXUm53aGZvbm5YSC9QemJp?=
 =?utf-8?B?bWh5bFVRZzdRYW9OMmV0VGtWRTd2aU94NnpOVjduWjVvTk1ScHFPZVBzZGYy?=
 =?utf-8?B?RkwyWlNmdGtXSjE1b0RVQkdwY0NUZG1qSTFQbURhamlaczU2OWJ4bnBFOGN5?=
 =?utf-8?B?eTRsaS9id2dPMWFkQmR5RjF3YjVlRXNaSkNvYmJZQm9tSXJMdlI4blpZUW9w?=
 =?utf-8?B?Ymw1cXphY1Evc1lZTTYxbXAwQlpkdjFOZCtNZlliU1ZFZFpncFl0UUV6K0dw?=
 =?utf-8?B?TFVyQ0VDMCsveWtOejdWMU9KUEI0TWhvSzFTdytneDdVWW1wcFYrVUZvYWhu?=
 =?utf-8?B?bnM5ZEZZOXdSdTJLK01GaWRWTHIvRno3WklLL3VFSXh6dUxZYTBsQWlQQ3pX?=
 =?utf-8?B?UWZFbG1BTjJpR3RQSTFTYzg0cUZBcElzUlpzT2hRZkVIajM4S0hZdXdnUUo3?=
 =?utf-8?B?RUpkcnd5bGMycVNQVzZmaytSSzFYL2s5RytFMHdoWG9ycEJnOVdDdkNoSHQv?=
 =?utf-8?B?K251bmcvdUZQenk5cG1jVUpTYlNaYnNYcXlnalJnWmVKTFpOcm9xZC9nQnRv?=
 =?utf-8?B?bW14RnMxNEFyNmI4UXllSkhhVW82UXpac3hoTFBTSHlFNmthYitra2h5UGlk?=
 =?utf-8?B?ZFlIeDJXQW9NZERCdy9jcjhSK2hva3huNUgrOGhCSEhXUi9LTjNTMFgvWmdX?=
 =?utf-8?B?Uk85VjNaa0RSRUtDTG9RYjBva2RLeXJwTEROVDNpS2Y4MEJQaVBYUFp0ZC9u?=
 =?utf-8?B?ejhaMnRqVUNSNzNsSm1KNUZBRmxhN1hsVFpUTjlPbGhzcHlLM0VsZjA3dUVl?=
 =?utf-8?B?d2VKbXUrc1U4WENsbTFVZWEyb01idnB1Q1BDbTZMZ3dLZ1pJbTNPcmtlOGxY?=
 =?utf-8?B?ZmtFay82UGRkMEZGVVZKRU9UaHh0NDJCSlJMRUdOVkRUQkRCeEtZTjJCVTc1?=
 =?utf-8?B?WVpRK3Z2VnM4OEI1bG1UUUpidE9OTXE1VXJiRndESTBuWTdscjNrRDZka1FX?=
 =?utf-8?B?bDNRcnBjQUZKSU1EZEhhQWluOEpqZStXSUh6UE1GMmZoam1mZmY2MVVIRHB3?=
 =?utf-8?B?alpYZVRhWEhxdlRMbEljNmJOVzErbURjTUw3cW01eWVIK29ETW54TXJFTys3?=
 =?utf-8?B?dUt1Y0d5RGxGMkdsbnQvV2xuOVRaY2h4REpOTU5NeWlVU1piNFBoRlRZeGJi?=
 =?utf-8?B?M2JpR0kwMFlraTl5RVlUeEtsa3o3RkhIRW1YYXpicVZOVFVrY0l5RGgyaklz?=
 =?utf-8?B?QThyT3dVQkhHWXg3RE5Ia2VsdW1rRnRDU1N0eGNacHA2ZWxGRzJmRG03QjNk?=
 =?utf-8?B?RWtRYmQ0OFNYSnUxVTJwYnplemFzK0tKRnVqbE1YRUdNb2lra3FvcDl4ZHVS?=
 =?utf-8?B?MHZCZXV1ZDUrbkQwUmRaWERVUHdBZFAyclN3UHRXcUFQMjJvR3ZWR25nU00v?=
 =?utf-8?B?cmI3WSs0T0x4MHJoWXVIdlJheWhYTWtqem9uTzRxS0pnQzE1UHBjSTlleDM4?=
 =?utf-8?B?NVVaYitSUW45OVRjb2w3VEZiY3owMk9pT1ZUVzg2QVVNVmFmbFY5Qm1TWUZY?=
 =?utf-8?B?cEhtYVVkWXV6U2ZPM3dHS3ZNM2VYditualJRcEV4V0RNYzNCbGJnekRjUERL?=
 =?utf-8?B?V0ZlclZsbVlSLyswTUk5TVpJMlFMdXM2K0pxbFAydDEvSkdEemlVbUF5S0hK?=
 =?utf-8?B?TkVoNTZBamhOYW53L3JvSW1zeHh3U3JIeVhycW9aeXMxMVcwTFA1amdncEhE?=
 =?utf-8?B?Z09ib0FJeVRsaG5NYmowa2l4cHovV0ZkUk9KUXB2QmdTNlQ0STBQK1BtZHNE?=
 =?utf-8?B?L0Z6MUxxdjIraEhKUEVVdFhaL0daTHNMbExuUGlKZlJTWDVJc1l5VHk5SGh4?=
 =?utf-8?B?MTJIQ2lpSTJvN21SOTI2RzM5a3VTM3B6Ukp5V3dFV3AraDJyZU5hWGVHZHpM?=
 =?utf-8?B?Y01kR2s1NWJ0bUNrUlhQdk50Qi9pdU5lTTRwdHVRSGxjSVFsa3UrRTdrcWYw?=
 =?utf-8?B?NGs3Yms5MjhndkphSmExS1p0SHhoWDQrbTI3azBBLzJPblV1V3VlOFRzRnVw?=
 =?utf-8?B?SWtCR3FGZERLK1RnS25Tdkd4TktGcjBTM21vSEpObHZ2b1g5TXVIWEpzTTll?=
 =?utf-8?B?UVJHVHZZWTZwcUdqZWtTZmQwdXJpQ25DWnZMaEFIMjZ4THBVZUZOcmtodEJP?=
 =?utf-8?B?Njd0azMySjdFQlQvaHpEZHBZc1ZtTnJza1l1bTdadEk1amMxV3czWGdxZUtQ?=
 =?utf-8?B?dDFDdHhoV2NXNGs1MTVSUWZ2MWR5TnZUWFRoOGN2MU5XcTI1N29iVFFnZTh3?=
 =?utf-8?Q?kx1kEwblMvmmIDtddnqcV5OISwUN+69bxAZzl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1BA476103837449994302864CB035C6@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd95ea5-0f9a-4394-0160-08da2ec0a264
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 17:56:51.9095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /PEbTpFSvIVvvqvEYZkRO5Bx9fBfsGnqtuyF296JnbW8znpFjC8c+NsxjwOzEQ5+jyM+2P4yNi5aLlkQP7Ej2Z2C+N9abpe1LDClr98I/mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB9357
X-Proofpoint-GUID: hUTYIZPQtcxuDOD63CGupqjb4XnOi6OR
X-Proofpoint-ORIG-GUID: hUTYIZPQtcxuDOD63CGupqjb4XnOi6OR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 mlxlogscore=813 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA0LTI5IGF0IDE2OjMxIC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gU2ltcGxpZnkgdGhlIGxvZ2ljIGluIHRoZSBDYWRlbmNlIE1BQ0IvR0VNIGRyaXZlciBmb3Ig
ZGV0ZXJtaW5pbmcNCj4gd2hlbiB0byByZXNjaGVkdWxlIE5BUEkgcHJvY2Vzc2luZywgYW5kIHVw
ZGF0ZSBpdCB0byB1c2UgTkFQSSBmb3IgdGhlDQo+IFRYIHBhdGggYXMgd2VsbCBhcyB0aGUgUlgg
cGF0aC4NCj4gDQo+IFJvYmVydCBIYW5jb2NrICgyKToNCj4gICBuZXQ6IG1hY2I6IHNpbXBsaWZ5
L2NsZWFudXAgTkFQSSByZXNjaGVkdWxlIGNoZWNraW5nDQo+ICAgbmV0OiBtYWNiOiB1c2UgTkFQ
SSBmb3IgVFggY29tcGxldGlvbiBwYXRoDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiLmggICAgICB8ICAgMSArDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L21hY2JfbWFpbi5jIHwgMTkzICsrKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ICAyIGZpbGVzIGNo
YW5nZWQsIDEwNiBpbnNlcnRpb25zKCspLCA4OCBkZWxldGlvbnMoLSkNCj4gDQoNCkxvb2tzIGxp
a2UgdGhpcyBwYXRjaHNldCBpcyBtYXJrZWQgYXMgQ2hhbmdlcyBSZXF1ZXN0ZWQgaW4gUGF0Y2h3
b3JrLCB0aGVyZSB3YXMNCnNvbWUgZGlzY3Vzc2lvbiBidXQgbm90aGluZyB0aGF0IHNlZW1lZCBs
aWtlIHRoZXJlIHdhcyBhIGNvbmNsdXNpb24gdGhhdCBhbnkNCmNoYW5nZXMgd2VyZSBuZWVkZWQu
IElmIGFueW9uZSB3b3VsZCBsaWtlIHRvIHNlZSBjaGFuZ2VzIGluIGFub3RoZXIgc3BpbiwNCnBs
ZWFzZSBsZXQgbWUga25vdy4NCg0KLS0gDQpSb2JlcnQgSGFuY29jaw0KU2VuaW9yIEhhcmR3YXJl
IERlc2lnbmVyLCBDYWxpYW4gQWR2YW5jZWQgVGVjaG5vbG9naWVzDQp3d3cuY2FsaWFuLmNvbQ0K
