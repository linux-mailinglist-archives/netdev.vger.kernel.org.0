Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4330948C9C2
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343749AbiALRfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:35:46 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:41969 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355865AbiALRfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:35:19 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6j7q020242;
        Wed, 12 Jan 2022 12:35:10 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg51m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:35:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0k4ZY6+w5b173045LNR20PSHYm0rgAz0afZl/Q+ceqXcsv1SSUjplpyrSunrpFrBM4fVSM0TH+pwjPSZNP545rNiaGphZ7W+p5fmYaECbBNafOyZSl9HUuN7hu8GwljcOoUpoXHE6szvflJf7Q1O6VH4sW6sDXv4cgkrmE3dxGgvkCLASdDkKCOI+QMJpgVOQcYwWUPor94/fM4SISnvUShNzFObmuRsoRXGdjxwJyuHPze0UF4pjYqhqAJrfkT+d+P68w2r3FPXgACvHqtBWTmig09/OkzMCj0HErUof62o5ltCJSKhyVnwYFLw5udqQL6oZPKc2m/DdCFx6UPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5Sy+4LpHQ2I+XbFSqV+cOFyq1TNlI/h24pfsWimzds=;
 b=b+iiCsg5UKcYlMi/BkAf7eNRRWQ7kZnF+Jfvj4I4koKgRY6YXuh3uG+nKeYm4xaaDwYFp8NFUq5N0G1eJuR3YbCh9GuNCS9lHWuwu5YKVHFuO2p5MVhi2p7Q/MDfTid2ExX4+pj+FZbnT9DsDeJ3BfbMMXArCxZMsak0ELIaJuIkqA129Ehllnl+IdxiLRin8yWneJzArEelT6E9iBtc8cWD0nLBo/QsRtaAPVeKe5ATwQpuhczbHd+cIVBNUjoHqG2oen2NtERrXVoJF3toIabTH9XllFmTEPHGAiCPxb2OE4gR4TCxBzxd54EtvlNQL3RmIkKsM6JsnYPaTVCedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5Sy+4LpHQ2I+XbFSqV+cOFyq1TNlI/h24pfsWimzds=;
 b=e5mdjKCTJgeEkOfhFSQG9jvjMqMetoGRBY4sC+8GkgG/ZDCC/0Rxemww6tTziTNDkOLrLabZC0LtVA+oLhn7RF6h/7lB4+sTKgbcOTx4UbILVMeusQFMWk+kTLclW0cfY7PVrosXws9/zSTrPAlzZde+SZYwdO+RlvbeH3zgKro=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTOPR0101MB1977.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:17::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Wed, 12 Jan
 2022 17:35:09 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:35:08 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 6/7] net: axienet: fix for TX busy handling
Thread-Topic: [PATCH net 6/7] net: axienet: fix for TX busy handling
Thread-Index: AQHYBzA5L1u5H0SMT06JpF46UOhrCaxewIMAgADYrACAAASEAIAACWgA
Date:   Wed, 12 Jan 2022 17:35:08 +0000
Message-ID: <65861fcbb40607b630cd1e49a04e5cde6a7fbf00.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
         <20220111211358.2699350-7-robert.hancock@calian.com>
         <20220111194948.056c7211@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <e3b5c842272de17865477110ee55625464113cda.camel@calian.com>
         <20220112090128.082f7477@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220112090128.082f7477@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcd1a742-a7f1-40df-eda1-08d9d5f1e10c
x-ms-traffictypediagnostic: YTOPR0101MB1977:EE_
x-microsoft-antispam-prvs: <YTOPR0101MB1977FAFE4CC4058860689C8EEC529@YTOPR0101MB1977.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SBCex9zR6EYXAcs1GQKHwsUdD8oLWViMoiOjLsYoE4gCfCTRMbjXyy8HNkUjHJ5BMXiXufOa3RY1WishXtoJCTksDBeBSuREBgTaTsgiTF+wq3Y6F8nXeMCUhhN5oKFkPJeYOzVedmm+Twn62MnM9k4RFIhEditlcUgjtc3oR6zcMcZ0/InZoCE77idxd9sxYQoEedI1fGrzkmeM+fdhKPxdJw5n6hP/L3pWegfyr624K2EEZG4JGWn78ebM1/ieQFizzsIQ6DL+lzuPaCK0V5oBNiU4y4NoIc5xcRSxYHftGBRXG7/MorZea/qqCWCc2odzKttp84qh8CbivMx69x03a4EGO3RBeFsab7BP0ho0eyb1dsBVT87fmMA3rI5+z5I408EiM1rPCGJ4qqxw1cHpdaMZuOyIV0gSm+mVsGjcEStQTb2TiyJxJn9hGePzhzgcPsFwfvFNhsZfPIlyHoePG1z5x6iv2Nvyp46zzODeeCs6Rpm8ZGSer0+XgiODSp8CvX78p4Jysv10OssOi6gvKlXSBC7n8tB4bYRZcYanvX4zvk38R/JzVFxh4cGs0ENTA2DgB7pTdGsPeef5Ew6wgOdN/iTikbBifTmKWAD3HR0ZcYUmdqI3nWb7gOlkTjA38RxGdGK+r7KIMzj9E+ZUR9+andplv65zorHCbiAzuHWLRiY/ikdaDEIJd5/BIILgBaeJe/05sDBYo+8x5bbXrzdq7JpwXNfS6nFOHsobcHx+L3vRTj80KNmLKI/1ie8h1RlZIE+6Uz4jNDgAvDi17F2t+IYgkBqGLqszqZoRHPtXrp5jxIP3Ty4+BKbOtDCEHC+RUTemD/GFqeCdCVQzCC/fW1Pp/geryxhFFXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(71200400001)(66476007)(86362001)(66946007)(38100700002)(54906003)(91956017)(66556008)(4326008)(26005)(508600001)(186003)(2616005)(76116006)(6486002)(36756003)(6512007)(83380400001)(6506007)(5660300002)(8936002)(66446008)(64756008)(15974865002)(316002)(44832011)(122000001)(8676002)(38070700005)(6916009)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZERoaTlzK2Q1V2JONlhZbHF5NUpVdElqcWVoWVpTMzlOdVZ1eEsxWmdCelkr?=
 =?utf-8?B?dTZGZ2pRelRjanRnalRvTlpiQ3YzVmFreWhJWnVmNkNiRElyNUliZzQ1TTQ5?=
 =?utf-8?B?NHlFMHVCSTRIWWlsK2RMV1l1ZzhDOXdVSVdpWFpIdzZZbkRWTXFCOVVob1BE?=
 =?utf-8?B?S2lFTnoyYVRWUnZFbjEzZDhvenBSS2hGK0tuQW1PYjFYa2Y0bGM0aS94SUwv?=
 =?utf-8?B?T2NUTTczU2x3M3hLbzVoUkZrakFpdG10ZS82Y0RWb3ppL1VEcWp3a0pwZGZw?=
 =?utf-8?B?eCtQTFZ3dXI4Yk14U0Y5VlVCaS85em8xYzZwOVN1RTlUOWhrSzEwbUNIbW9X?=
 =?utf-8?B?VUR4QzdZaWxtaGhoY0t2OU8zbHFpNWNaZnJQTmRtV0lwbEZ2ckZLUEhIYlNs?=
 =?utf-8?B?WGRGcVBKUFg3d1FHTGoyOWtuZkVocU1WYmdpL3FyT3ZHUndpVktIRXpocEI5?=
 =?utf-8?B?ZlVXbEd3ZjVNS1k5UFBZU095SEtLcmF2cEx2UUFBVFFNd0ZtLzFZSEgyNzJk?=
 =?utf-8?B?ZldNYlRZVHJ4c2Zza3JHQW5ubDRveldNekhzK256M1N3dTE4cUVMSGVPSFBz?=
 =?utf-8?B?bjFJL051Z0tzWUtxQ3NKTWk4clNQYjJSL1VWRXdnWjN2dlV3d0Y1TXFDbEpV?=
 =?utf-8?B?RTkvNFJWTWdCVnFoaTlvd0x1cWROM0xoUmJJTldlM01KM1FWQUd2TUVuOFZQ?=
 =?utf-8?B?L3luSXdsQ0lNVUEzMFdlbkREWHVPc2FNU1VkU3ZVTzVtemlzdlI0ekxKajVj?=
 =?utf-8?B?VjIrSEx4OHdxaWx6Q25rbVJERVVmVTJMZTZjWUtHVGV3UlhuUXVUeUgxUTFn?=
 =?utf-8?B?VVVDd1hadzEvSEhRZzZDWVMxcmhWdUYrZEhiODV3dHl6WE9DMzFOemVGUVJV?=
 =?utf-8?B?ajh5OUhKOVJHNTdxNGlwMk10b2thZkxFRkxIK2F2b1FHOGtiVEtxaXFDN0Zm?=
 =?utf-8?B?WGVURHpQTTJYYVYwanNvbXNEeHQxOWlRVWQ2UUVSZkhWOXBGQUxER0xyVGpv?=
 =?utf-8?B?Q0pzTkl2aGtaMzZIQUdrMENyaHFmQ2xZZVFPaHJycUJFWTZnVnNTOTB2SHI3?=
 =?utf-8?B?bHlUd0VQZHNDS1dwTTRDdkhLVS9UcDhrbGZDdCt1a1ErKy9XUU1oSWhjN090?=
 =?utf-8?B?eTFEMHFPUjVId3hQbmdXeGU3ODFYQ0VucFl1aHVEbXdiYjRGeXVuSWFvZ1hr?=
 =?utf-8?B?REZ4amdGbm9iZmFJWGJka3pZaE1EV2M5TDdLdE1yZElXSnpUV2dlS3RlbEFz?=
 =?utf-8?B?OVExeWlQMFJjck5RMXdRMisyZVJ0ckdzL045T2NpME1WNWo0R2NNeVFkRVIv?=
 =?utf-8?B?MndYQXJQL3ZpYVN4Z0s0a3RDak9qNklsQ2tkK01Ud21EQnBCLzhNU3VwWFJt?=
 =?utf-8?B?dktDNVk4US9FUDJZT0E4clM2Y1pEQzBSR01GcGR6VVZsTjNKdkJKbk9rSFVu?=
 =?utf-8?B?RHY4RlRDZ1dUUENPSkN4a1VvK3dzYm0wT2xFbjlsL2Y2cjkraTVyb2xscDMz?=
 =?utf-8?B?MnJnZHpvalREenlIckdrbG8xSmdKQXJXNW1sZFBJRDBHd2N5dnZCTDB1VVZ0?=
 =?utf-8?B?VUdGRzRTd1hDNlQzbmJKbkEydjlDZnVYNnByOXBmNlNDdGhUVGgvSXIvNXk5?=
 =?utf-8?B?eGo4eDZBUzBGWHByQlBsQVBFbDZRUjFXWGdBUkVRR0JBNTluOGdESU4vanNq?=
 =?utf-8?B?UnFFSWQydnlKOHR5M2RHS0tPOWJvNXJHbm9hVENlY1Q3L09IWWtJaGx2bnVk?=
 =?utf-8?B?WlZEUk5Tc081MW5NT0lhelBiWHVMODVDUVVYVmRYeUVMMW5uRlZKR0pZZUF6?=
 =?utf-8?B?OEphOEx4aENPdXhlSEgxVjI0TmZ0Zm9MRVUrOE1rMnhZRUVxTkE1eU9YZ1d3?=
 =?utf-8?B?dFdYbndteXFPVHRnR2FieDM2Q2xTUzhFRVZYZndDVkl1cG9LQkRQREhuNmZz?=
 =?utf-8?B?SlhnWlFLNGVla3RVTkRucmFvVkNvZkdQdTRXRys2MEliTnYyV01nQysyY2xp?=
 =?utf-8?B?ZzRBVndPY1FBSks5VzNEQzRpd0RNY2ZVcGJjOUdwODV0SzNjUW1BQ2tRKy9v?=
 =?utf-8?B?VDRlenlQQWh4UWIvL09aVUNqZU5xdFRueFpzOWkremJJUzZlb1Ztb3MxVkRy?=
 =?utf-8?B?UzlPMmY4bUgxV0Z1NFJ1NEdrS1dNUUV3SUFIeVJJcnduVTRVT0gzRitHcW10?=
 =?utf-8?B?VTZkQndJN08xbVlNcmQ0YnNUV0FaUld2V29JVVcvRkRUb1Btdm5qUTB2U1JQ?=
 =?utf-8?Q?k+IOTuqdEict1Qt5bD91r/Acm3zLWB/yyoLu2gK03I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <32A66846524ADF458EDC4D78EA04C502@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd1a742-a7f1-40df-eda1-08d9d5f1e10c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 17:35:08.8566
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T8AytbMCuKs1A9oPUi1B0PW16vqB1F/aUEQFp8TOV1lmXnCYGiQAQhqlX2hPM+sr/C6T8KAqze6MdrKuVB/2iPmZ7oc4sz0yEZEug172jeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTOPR0101MB1977
X-Proofpoint-GUID: cg2rvp0QUjZreqzvgAmukK_dYV1JoIg6
X-Proofpoint-ORIG-GUID: cg2rvp0QUjZreqzvgAmukK_dYV1JoIg6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTEyIGF0IDA5OjAxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxMiBKYW4gMjAyMiAxNjo0NToxOCArMDAwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBPbiBUdWUsIDIwMjItMDEtMTEgYXQgMTk6NDkgLTA4MDAsIEpha3ViIEtpY2luc2tp
IHdyb3RlOg0KPiA+ID4gT24gVHVlLCAxMSBKYW4gMjAyMiAxNToxMzo1NyAtMDYwMCBSb2JlcnQg
SGFuY29jayB3cm90ZTogIA0KPiA+ID4gPiBXZSBzaG91bGQgYmUgYXZvaWRpbmcgcmV0dXJuaW5n
IE5FVERFVl9UWF9CVVNZIGZyb20gbmRvX3N0YXJ0X3htaXQgaW4NCj4gPiA+ID4gbm9ybWFsIGNh
c2VzLiBNb3ZlIHRoZSBtYWluIGNoZWNrIGZvciBhIGZ1bGwgVFggcmluZyB0byB0aGUgZW5kIG9m
IHRoZQ0KPiA+ID4gPiBmdW5jdGlvbiBzbyB0aGF0IHdlIHN0b3AgdGhlIHF1ZXVlIGFmdGVyIHRo
ZSBsYXN0IGF2YWlsYWJsZSBzcGFjZSBpcw0KPiA+ID4gPiB1c2VkDQo+ID4gPiA+IHVwLCBhbmQg
b25seSB3YWtlIHVwIHRoZSBxdWV1ZSBpZiBlbm91Z2ggc3BhY2UgaXMgYXZhaWxhYmxlIGZvciBh
IGZ1bGwNCj4gPiA+ID4gbWF4aW1hbGx5IGZyYWdtZW50ZWQgcGFja2V0LiBQcmludCBhIHdhcm5p
bmcgaWYgdGhlcmUgaXMgaW5zdWZmaWNpZW50DQo+ID4gPiA+IHNwYWNlIGF0IHRoZSBzdGFydCBv
ZiBzdGFydF94bWl0LCBzaW5jZSB0aGlzIHNob3VsZCBubyBsb25nZXIgaGFwcGVuLg0KPiA+ID4g
PiANCj4gPiA+ID4gRml4ZXM6IDhhM2I3YTI1MmRjYTkgKCJkcml2ZXJzL25ldC9ldGhlcm5ldC94
aWxpbng6IGFkZGVkIFhpbGlueCBBWEkNCj4gPiA+ID4gRXRoZXJuZXQgZHJpdmVyIikNCj4gPiA+
ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5j
b20+ICANCj4gPiA+IA0KPiA+ID4gRmVlbHMgYSBsaXR0bGUgbW9yZSBsaWtlIGFuIG9wdGltaXph
dGlvbiB0aGFuIHN0cmljdGx5IGEgZml4Lg0KPiA+ID4gQ2FuIHdlIGFwcGx5IHRoaXMgYW5kIHRo
ZSBmb2xsb3dpbmcgcGF0Y2ggdG8gbmV0LW5leHQgaW4gdHdvDQo+ID4gPiB3ZWVrJ3MgdGltZT8g
SXQncyBub3QgdG9vIG11Y2ggb2YgYSBzdHJldGNoIHRvIHRha2UgaXQgaW4gbm93DQo+ID4gPiBp
ZiBpdCdzIGEgYml0IGNvbnZlbmllbmNlIGJ1dCBJIGRvbid0IHRoaW5rIHRoZSBGaXhlcyB0YWdz
IHNob3VsZCANCj4gPiA+IHN0YXkuICANCj4gPiANCj4gPiBXZWxsIGl0J3MgYSBmaXggaW4gdGhl
IHNlbnNlIHRoYXQgaXQgY29tcGxpZXMgd2l0aCB3aGF0DQo+ID4gRG9jdW1lbnRhdGlvbi9uZXR3
b3JraW5nL2RyaXZlci5yc3Qgc2F5cyBkcml2ZXJzIHNob3VsZCBkbyAtIEknbSBub3QgdG9vDQo+
ID4gZmFtaWxpYXIgd2l0aCB0aGUgY29uc2VxdWVuY2VzIG9mIG5vdCBkb2luZyB0aGF0IGFyZSwg
SSBndWVzcyBtb3N0bHkNCj4gPiBwZXJmb3JtYW5jZSBmcm9tIGhhdmluZyB0byByZXF1ZXVlIHRo
ZSBwYWNrZXQ/DQo+IA0KPiBZZXMsIGl0J3MganVzdCB0aGUgcmUtcXVldWluZyBvdmVyaGVhZCBB
RkFJVS4NCj4gDQo+ID4gRnJvbSB0aGF0IHN0YW5kcG9pbnQsIEkgZ3Vlc3MgdGhlIGNvbmNlcm4g
d2l0aCBicmVha2luZyB0aG9zZSB0d28gcGF0Y2hlcw0KPiA+IG91dA0KPiA+IGlzIHRoYXQgdGhl
IHByZXZpb3VzIHBhdGNoZXMgY2FuIGludHJvZHVjZSBhIGJpdCBvZiBhIHBlcmZvcm1hbmNlIGhp
dCAoYnkNCj4gPiBhY3R1YWxseSBjYXJpbmcgYWJvdXQgdGhlIHN0YXRlIG9mIHRoZSBUWCByaW5n
IGluc3RlYWQgb2YgdHJhbXBsaW5nIG92ZXIgaXQNCj4gPiBpbg0KPiA+IHNvbWUgY2FzZXMpIGFu
ZCBzbyB3aXRob3V0IHRoZSBsYXN0IHR3byB5b3UgbWlnaHQgZW5kIHVwIHdpdGggc29tZQ0KPiA+
IHBlcmZvcm1hbmNlIA0KPiA+IHJlZ3Jlc3Npb24uIFNvIEknZCBwcm9iYWJseSBwcmVmZXIgdG8g
a2VlcCB0aGVtIHRvZ2V0aGVyIHdpdGggdGhlIHJlc3Qgb2YNCj4gPiB0aGUNCj4gPiBwYXRjaCBz
ZXQuDQo+IA0KPiBBbHJpZ2h0LCBpZiB5b3UgaGF2ZSBhbnkgbnVtYmVycyBvbiB0aGlzIGl0J2Qg
YmUgZ3JlYXQgdG8gaW5jbHVkZSB0aGVtDQo+IGluIHRoZSBjb21taXQgbWVzc2FnZS4NCg0KSSBk
b24ndCBoYXZlIGFueSBudW1iZXJzIGZyb20gdGhhdCBpbmRpdmlkdWFsIGNoYW5nZSB1bmZvcnR1
bmF0ZWx5LCBqdXN0IGZyb20NCmJvdGggb2YgdGhlIHR3byB0b2dldGhlciAodGhlIHNlY29uZCBj
aGFuZ2UncyBjb21taXQgbWVzc2FnZSBtZW50aW9ucyB0aGUgVFgNCnJhdGUgd2VudCBmcm9tIDYw
MCBNYnBzIHVwIHRvIG5lYXIgMSBHYnBzIG9uIGEgMSBHYnBzIGxpbmspLiBCdXQgSSdsbCBhZGQg
c29tZQ0Kc29tZSBtb3JlIHJhdGlvbmFsZSB0byB0aGUgY29tbWl0IG1lc3NhZ2Ugb24gdGhpcyBv
bmUuDQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2Fs
aWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
