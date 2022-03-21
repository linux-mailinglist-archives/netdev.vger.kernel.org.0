Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F38F74E3508
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 01:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbiCVABO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 20:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233922AbiCVABN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 20:01:13 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B85611162;
        Mon, 21 Mar 2022 16:58:39 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22LNBKkD019221;
        Mon, 21 Mar 2022 19:56:21 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2177.outbound.protection.outlook.com [104.47.75.177])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ewa9vhnac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 19:56:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D588Oq1UHGPClpWlvj7opbF6Ht6lSpgtV+V7jXSSgs/6KNxdruy1Xpu3rN46G4uTozGCVSoQS0+bTF+AAAA15mDVOFKHxW0ZTBWhqVKiMzKK60WKAlq3oqMpV7y5gdwiuQFTfs3jUEQWmCi3IxPkUrs8uiFDmGEeqMGDf61W4uHgOrUqqknJjBy4j5kOTWG/4XrguXyrLrP2I1ybcoo/qbO7hqgD8sWB9rMqukWbZ10Vkt8ddVc4mqiLFPNBOuuy+zLUe2pSrsvv8tVcSgQYfb/72C/LsCDhUW/OvgKCAI5k2vR7aZLqYEru/f8ixH7riq/IGsOZgh6c3gruIa7H3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Omo7X3x4s33vPVBhPAaEKYl2HaZIyQw9LQgnnFgZcA0=;
 b=Ec1EEWAo3N9XC94ArMoO3ZEwHiVAJs2686ncHnIsMePYb49wPA8oaWhXH5Cb7xk3/T5ZdPDOhCa8eTsySULqYfv+g4Ms7NP4H1Rrlh2/q+DAnU4u8uWnW+tvLpStrsDk8zUzm9ikvZnQGUxRbpNy1EMfhVkpoROnPJZO95LxAqMIFOyTmH3am6Fh+ad2whq8uHmah1F2CTfHXYKa93Sxg9xUBxaKVWtUL2vdOyOMPq5ID4zkopu4JQUiMAKdyNpmyoHeApIK1EuUb9p1MMGlsEgUR7pfebpn4uoyAcTxDbo7FxIf4bzGMXl52xfNjTc6CRArkmTVpBMsHt8qKopBzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Omo7X3x4s33vPVBhPAaEKYl2HaZIyQw9LQgnnFgZcA0=;
 b=zS7HaTl/aEiqb1GuVjSgzdgoxrpr1wNYD555aHK2WgpjhKUPVO5PHCr5Gc7iSaZBtMotU2YgQiiN3DHQG9J7BFsrQ6YSNq9NYsmi1qfvp7w/mvn9n32I2ov8LAgIbQNPHQufjSTRVB5pghtZGtkw+qkmr+QhZRjUgG+11VIb2AM=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by QB1PR01MB3475.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:39::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Mon, 21 Mar
 2022 23:56:19 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 23:56:19 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "robh@kernel.org" <robh@kernel.org>,
        "radheys@xilinx.com" <radheys@xilinx.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "harinik@xilinx.com" <harinik@xilinx.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andy.chiu@sifive.com" <andy.chiu@sifive.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Topic: [PATCH v4 3/4] dt-bindings: net: xilinx_axienet: add pcs-handle
 attribute
Thread-Index: AQHYPTgrI7jLgAaz1UWtdS3v+RtT+KzJ+jUAgACGoACAAAM+AA==
Date:   Mon, 21 Mar 2022 23:56:19 +0000
Message-ID: <d649514d914366156128505091ecaab61da525b8.camel@calian.com>
References: <20220321152515.287119-1-andy.chiu@sifive.com>
         <20220321152515.287119-3-andy.chiu@sifive.com>
         <SA1PR02MB856080742C4C5B1AA50FA254C7169@SA1PR02MB8560.namprd02.prod.outlook.com>
         <YjkN6uo/3hXMU36c@robh.at.kernel.org>
In-Reply-To: <YjkN6uo/3hXMU36c@robh.at.kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38e2b01d-f2d7-473b-037c-08da0b9664eb
x-ms-traffictypediagnostic: QB1PR01MB3475:EE_
x-microsoft-antispam-prvs: <QB1PR01MB3475C90CFBF293B4DA553736EC169@QB1PR01MB3475.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 04SOuPLAZVZ/dSBORKfseUxIqHbfjog8IrRi2gAC11VDV2Q8hvwCowTIDjrHw9KhGbg83dxtOG3vEY7Oyc4XHEmA9SmJ8VT+FtU3jZWjc8SdNmHbWuxwoweFvb4TYKmr4ccEoEZ3v5Q40rFTRvJxo8fSvXoCxvFdLcUceUlxgONOA2Dakb+vmaUkOI7jk4+d86Bcngsot8K2mASo/lTzaRIeqEA/VE65FnCc4atbJGaRQ7m9/2zE66mU9ipbATn7ciMhq7luMyQUexBtbTf2PsWgfIvEForBg9m+PndJj1Ogh3Cs32xmI8fgR1Ry/D2OBWMSQ3RRKIuAH/6fy5AsLchdtJAXHsY55j94Zw69mGNJOYLmfjpuc/pV19Mftnqzuum17J8UTHCTNiIWPrv395TKHdwEfKT/IrTC9cBRcYJYw+fGlrk+xKGyEw34XYS7cQPiLGpmDdSBQL6fEiJ6xqKH08Ug+y6DfPC6pI/F2HwixDuW9KJ3ReEsLmhaQU0S6AuzOBqOQQoCxXaBiba8/JB14dKQwf6lpb5L7zkKJk6Aya2C2qPg8mUDY72kPRCq1K9921ql90W/vCv6Zey/M/DmylxmKnNGs1dqh6fBVsLgSMkpkrgkEsoGWFaND3oZ7/oE723BDQqe9moWsYO0boGYZbQTImp4gtC+5uBH93VlvHNjFe+t47Mvjf2SeWUQImlPSi/F2VOe7OTJhDq2+azICURnS7K7yvkiFiHiuF0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(91956017)(76116006)(38100700002)(4326008)(66946007)(66556008)(36756003)(122000001)(6486002)(71200400001)(508600001)(38070700005)(64756008)(66446008)(66476007)(2616005)(316002)(83380400001)(110136005)(6512007)(186003)(8936002)(53546011)(7416002)(5660300002)(2906002)(6506007)(8676002)(86362001)(54906003)(26005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDVTQitXT3hNdks0S2F2MTZVRmtINTROVnlheVhVRDZ2RVlTN1VSZXZ4cWhQ?=
 =?utf-8?B?MEZ3V0tFaFZIUkhhTUwxK0ZnZ1IzaUZUb2dDTTVDRUN2ajZTTXNvb1E3OXRX?=
 =?utf-8?B?N0JCMGlseEhrcE5kVUVvMWJZNzlockZxN1krMjlNTjZ3eWlSaXNKYWpzcm05?=
 =?utf-8?B?d2lUeVFIaUNqVDZtUWM3MUpENG9uaG9NMlFaTHMzdVBMdDB4TlE1T0doSjF5?=
 =?utf-8?B?d0VzSDZlajVEV2liNmZBdTVVWTY3SlUza1dDVXAyUUlsTVUwN2hsNHgwSVVY?=
 =?utf-8?B?eHlQeEtjU3JZYkZSa0V4enlPL0xSZnJHSFpqMmVrS0FPVVQ1MU9tY3Q1eThJ?=
 =?utf-8?B?K0lUL2kzNWJoZnhiZXcyRTVXN0J2TWdiNnFOdHF0a2tIN29sUmNHMGl6QnZH?=
 =?utf-8?B?UTN6TjJGMXB5bHVaZDM5dW9jRFRzUnRCZWVVMFk5L0V5VmhzSXB4bkkyNWF0?=
 =?utf-8?B?R3BYRXF1SnplcG9oN290MTBjTVlqMitSMEM1dk50K0JUVkc5SFJSbzJMdmN0?=
 =?utf-8?B?Z3pCRG0rTjZkUW5FT250VnA5NHF4c2dZOFFzRTFrcGNLdDB0YUFwU05hVVZY?=
 =?utf-8?B?eEFiZVd3NFE1MjVrZ29NUFJoZDlJdm5zZ1dRYlBNWjd6ZXVuamxwbExQTXhF?=
 =?utf-8?B?RGVUT0JpRlRpcWQ1VjN2RlNUMWpUa2xmZ1VjaWNLS2ViaU5GeEFCNklyN1JH?=
 =?utf-8?B?SG9GUSt6UXducEF4TG9tRGFWbnJUODg5QkRUeDVFMXVNUHhxSUxCWGJSdkUx?=
 =?utf-8?B?ZFVVZnlHMm9IQkdySTNIMWlwdFU1UnRJVHZOMVF1QjdybWl0Z0c5NHhybytl?=
 =?utf-8?B?U25Id1BYL0p2NTAxSmUvWDBQMTJQdG1KUmVsdVM2Z0Vyd1hmeHFHVjZxMVF4?=
 =?utf-8?B?bEhPZGg3V2lLUmNxdDk1OHdLOUZuUlhBc1AxZ01ZMHpCSFdBTzd3a09teVdZ?=
 =?utf-8?B?aUZJVkR6Uk1pRXB2RkdoMGM4aEhYblNYajdBekIyeVVWaURyY20yQ3FkZ1M0?=
 =?utf-8?B?MXhETHVpN0dOODMzSC9BR1NxTUs2aHk1RFdkRExhMTl5UmJJN1hZL1ExaXpr?=
 =?utf-8?B?SWtkWG92RXR6OUlhNndnWUdaWEpJRU0wNUVjb25CdUwybHNZcUwvcWhDNVdh?=
 =?utf-8?B?VWpaaGZIUGw4MEk5NEhPWnEvSXlETUJacCt6SzBDV1lnOEI4dDJGVEhFL3Rs?=
 =?utf-8?B?WnlVbXorZ0dqWUZxd3lnUXdZUHpJSVpGeU1NbDcwUC9BQ1A3T3VuSVlwSzFk?=
 =?utf-8?B?Z2RWWUhuVUVCcE1TampzVnBDUk1HVGNKL0tGSFlvR2xWWXBVdFRQeUtzUWRB?=
 =?utf-8?B?Y3pLZkJsUm1UN20wdHFNQWVzL2VWWitzTlBjSHg2aWhTRk1CK1FZSHhnaHhs?=
 =?utf-8?B?Mko4OThySWlMSGhWRXNUSWVuMG9zT2JPU1I4eHdjODdoZmp6a0NtSDZjcHdE?=
 =?utf-8?B?aFE3czBnaDFubzBBV3djblZ2dmd2NUNWbllNcFRyY0lGWk1hSFQ3dVdDYkxI?=
 =?utf-8?B?MUNKV25nOEcxbjhNaEVVL3V2c0hKd0s3aUdYUStScmxjNm9qZU5vWUNpQkhq?=
 =?utf-8?B?dkhhdlNvWVZJL3NuTWhIQWNocElycDhKd0FCQXl1bU9RVGlybVEvVHNnOE1I?=
 =?utf-8?B?TmRNRXRYSVdFVm5rRDc2OHRmNW1DeW9yNVZQTEx1UHpadHhCb3hFbWcrTTRN?=
 =?utf-8?B?MFZadGtrbCsxYlVTaFgwckptK1RLWVU0aUxQaXpSSXRNK2pNWjdLSzUxclMv?=
 =?utf-8?B?ZTQxVEVqbU5BT2t0ZXFobFJuZTdqejFwUTBLUGt0OG42dnNzc3k4NldkQmNj?=
 =?utf-8?B?bnVjVnk4YWZXeGdTalVMY1M1RGVCZWd6UXkxOUw1UTZMSjlTVjBITXNMcTdo?=
 =?utf-8?B?b1BKOEJ5bnU2Y2FqL09yNmdJNGxrejZtMGFDb1pZTEZQTnVjSkxxZU9PaUYx?=
 =?utf-8?B?THUwK2VpeEJlbFlXNFdkeGxlejFJVkIvcDRJSmV3OWhEVnVnNmNmMHZWVGVo?=
 =?utf-8?B?ZzJGd3kzTnZBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B117BABCCFA3C48A086722E0332BCD3@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e2b01d-f2d7-473b-037c-08da0b9664eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2022 23:56:19.2001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p48NRldgCdYqSv/mBtMtTbgypJQRFZyt9+kiU8Yq5D/Dc8du7H5fIhPbd+SPUIJetJEshpI5QdYNFSVYYcq/ZRa/vq6EN/R/KL3xwLyMspQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: QB1PR01MB3475
X-Proofpoint-ORIG-GUID: SsKxwF5Djw7MUmw-8vyJhe8tp447FqVL
X-Proofpoint-GUID: SsKxwF5Djw7MUmw-8vyJhe8tp447FqVL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_10,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210147
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAzLTIxIGF0IDE4OjQ0IC0wNTAwLCBSb2IgSGVycmluZyB3cm90ZToNCj4g
T24gTW9uLCBNYXIgMjEsIDIwMjIgYXQgMDM6NDI6NTJQTSArMDAwMCwgUmFkaGV5IFNoeWFtIFBh
bmRleSB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9t
OiBBbmR5IENoaXUgPGFuZHkuY2hpdUBzaWZpdmUuY29tPg0KPiA+ID4gU2VudDogTW9uZGF5LCBN
YXJjaCAyMSwgMjAyMiA4OjU1IFBNDQo+ID4gPiBUbzogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFk
aGV5c0B4aWxpbnguY29tPjsgcm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbTsNCj4gPiA+IE1pY2hh
bCBTaW1layA8bWljaGFsc0B4aWxpbnguY29tPg0KPiA+ID4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+ID4gPiByb2JoK2R0QGtl
cm5lbC5vcmc7IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgYW5kcmV3QGx1bm4uY2g7DQo+ID4gPiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgQW5keSBD
aGl1DQo+ID4gPiA8YW5keS5jaGl1QHNpZml2ZS5jb20+OyBHcmVlbnRpbWUgSHUgPGdyZWVudGlt
ZS5odUBzaWZpdmUuY29tPg0KPiA+ID4gU3ViamVjdDogW1BBVENIIHY0IDMvNF0gZHQtYmluZGlu
Z3M6IG5ldDogeGlsaW54X2F4aWVuZXQ6IGFkZCBwY3MtaGFuZGxlDQo+ID4gPiBhdHRyaWJ1dGUN
Cj4gPiA+IA0KPiA+ID4gRG9jdW1lbnQgdGhlIG5ldyBwY3MtaGFuZGxlIGF0dHJpYnV0ZSB0byBz
dXBwb3J0IGNvbm5lY3RpbmcgdG8gYW4NCj4gPiA+IGV4dGVybmFsDQo+ID4gPiBQSFkgaW4gU0dN
SUkgb3IgMTAwMEJhc2UtWCBtb2RlcyB0aHJvdWdoIHRoZSBpbnRlcm5hbCBQQ1MvUE1BIFBIWS4N
Cj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5keSBDaGl1IDxhbmR5LmNoaXVAc2lmaXZl
LmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBHcmVlbnRpbWUgSHUgPGdyZWVudGltZS5odUBzaWZp
dmUuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC94aWxpbnhfYXhpZW5ldC50eHQgfCA4ICsrKysrKystDQo+ID4gPiAgMSBmaWxlIGNo
YW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZm
IC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94aWxpbnhfYXhp
ZW5ldC50eHQNCj4gPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC94
aWxpbnhfYXhpZW5ldC50eHQNCj4gPiA+IGluZGV4IGI4ZTQ4OTRiYzYzNC4uYmE3MjBhMmVhNWZj
IDEwMDY0NA0KPiA+ID4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC94aWxpbnhfYXhpZW5ldC50eHQNCj4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJl
ZS9iaW5kaW5ncy9uZXQveGlsaW54X2F4aWVuZXQudHh0DQo+ID4gPiBAQCAtMjYsNyArMjYsOCBA
QCBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KPiA+ID4gIAkJICBzcGVjaWZpZWQsIHRoZSBUWC9SWCBE
TUEgaW50ZXJydXB0cyBzaG91bGQgYmUgb24gdGhhdCBub2RlDQo+ID4gPiAgCQkgIGluc3RlYWQs
IGFuZCBvbmx5IHRoZSBFdGhlcm5ldCBjb3JlIGludGVycnVwdCBpcyBvcHRpb25hbGx5DQo+ID4g
PiAgCQkgIHNwZWNpZmllZCBoZXJlLg0KPiA+ID4gLS0gcGh5LWhhbmRsZQk6IFNob3VsZCBwb2lu
dCB0byB0aGUgZXh0ZXJuYWwgcGh5IGRldmljZS4NCj4gPiA+ICstIHBoeS1oYW5kbGUJOiBTaG91
bGQgcG9pbnQgdG8gdGhlIGV4dGVybmFsIHBoeSBkZXZpY2UgaWYgZXhpc3RzLg0KPiA+ID4gUG9p
bnRpbmcNCj4gPiA+ICsJCSAgdGhpcyB0byB0aGUgUENTL1BNQSBQSFkgaXMgZGVwcmVjYXRlZCBh
bmQgc2hvdWxkIGJlDQo+ID4gPiBhdm9pZGVkLg0KPiA+ID4gIAkJICBTZWUgZXRoZXJuZXQudHh0
IGZpbGUgaW4gdGhlIHNhbWUgZGlyZWN0b3J5Lg0KPiA+ID4gIC0geGxueCxyeG1lbQk6IFNldCB0
byBhbGxvY2F0ZWQgbWVtb3J5IGJ1ZmZlciBmb3IgUngvVHggaW4gdGhlDQo+ID4gPiBoYXJkd2Fy
ZQ0KPiA+ID4gDQo+ID4gPiBAQCAtNjgsNiArNjksMTEgQEAgT3B0aW9uYWwgcHJvcGVydGllczoN
Cj4gPiA+ICAJCSAgcmVxdWlyZWQgdGhyb3VnaCB0aGUgY29yZSdzIE1ESU8gaW50ZXJmYWNlIChp
LmUuIGFsd2F5cywNCj4gPiA+ICAJCSAgdW5sZXNzIHRoZSBQSFkgaXMgYWNjZXNzZWQgdGhyb3Vn
aCBhIGRpZmZlcmVudCBidXMpLg0KPiA+ID4gDQo+ID4gPiArIC0gcGNzLWhhbmRsZTogCSAgUGhh
bmRsZSB0byB0aGUgaW50ZXJuYWwgUENTL1BNQSBQSFkgaW4gU0dNSUkgb3INCj4gPiA+IDEwMDBC
YXNlLVgNCj4gPiA+ICsJCSAgbW9kZXMsIHdoZXJlICJwY3MtaGFuZGxlIiBzaG91bGQgYmUgcHJl
ZmVyYWJseSB1c2VkIHRvDQo+ID4gPiBwb2ludA0KPiA+ID4gKwkJICB0byB0aGUgUENTL1BNQSBQ
SFksIGFuZCAicGh5LWhhbmRsZSIgc2hvdWxkIHBvaW50IHRvIGFuDQo+ID4gPiArCQkgIGV4dGVy
bmFsIFBIWSBpZiBleGlzdHMuDQo+ID4gDQo+ID4gSSB3b3VsZCBsaWtlIHRvIGhhdmUgUm9iIGZl
ZWRiYWNrIG9uIHRoaXMgcGNzLWhhbmRsZSBEVCBwcm9wZXJ0eS4NCj4gPiANCj4gPiBUaGUgdXNl
IGNhc2UgaXMgZ2VuZXJpYyBpLmUuIHJlcXVpcmUgc2VwYXJhdGUgaGFuZGxlIHRvIGludGVybmFs
IFNHTUlJDQo+ID4gYW5kIGV4dGVybmFsIFBoeSBzbyB3b3VsZCBwcmVmZXIgdGhpcyBuZXcgRFQg
Y29udmVudGlvbiBpcyANCj4gPiBzdGFuZGFyZGl6ZWQgb3Igd2UgZGlzY3VzcyBwb3NzaWJsZSBh
cHByb2FjaGVzIG9uIGhvdyB0byBoYW5kbGUNCj4gPiBib3RoIHBoeXMgYW5kIG5vdCBhZGQgaXQg
YXMgdmVuZG9yIHNwZWNpZmljIHByb3BlcnR5IGluIHRoZSBmaXJzdCANCj4gPiBwbGFjZS4NCj4g
DQo+IElNTywgeW91IHNob3VsZCB1c2UgJ3BoeXMnIGZvciB0aGUgaW50ZXJuYWwgUENTIHBoeS4g
VGhhdCdzIGFsaWduZWQgd2l0aCANCj4gb3RoZXIgdXNlcyBsaWtlIFBDSWUsIFNBVEEsIGV0Yy4g
KHRoZXJlIGlzIHBoeSBoL3cgdGhhdCB3aWxsIGRvIFBDUywgDQo+IFBDSWUsIFNBVEEpLiAncGh5
LWhhbmRsZScgaXMgZm9yIHRoZSBldGhlcm5ldCBQSFkuDQoNClRoYXQgbWlnaHQgYmUgY29uZnVz
aW5nIGluIHNvbWUgY2FzZXMgLSBJJ20gdGhpbmtpbmcgb2YgdGhlIENhZGVuY2UgR0VNDQpjb250
cm9sbGVycyBvbiB0aGUgWGlsaW54IE1QU29DIGRldmljZXMsIHdoZXJlIHRoZXJlIGlzIGEgUENT
IGludGVybmFsIHRvIHRoZQ0KY29udHJvbGxlciwgYXMgd2VsbCBhcyBhIGdlbmVyaWMgUEhZIGRl
dmljZSB3aGljaCBpcyB1c2VkIHRvIGNvbnRyb2wgdGhlIGFjdHVhbA0KbG93LWxldmVsIEkvTyB0
cmFuc2NlaXZlciBvbiB0aGUgY2hpcCAod2hpY2ggY2FuIHdvcmsgaW4gU0dNSUkgbW9kZSBidXQg
YWxzbyBpbg0KVVNCLCBQQ0llLCBTQVRBIG1vZGVzKS4gQ2FsbGluZyB0aGVtIGJvdGgganVzdCBh
ICJQSFkiIG1ha2VzIHRoYXQgZGlzdGluY3Rpb24NCnJhdGhlciB1bmNsZWFyLiBJbiB0aGUgY2Fz
ZSBvZiB0aGF0IGRyaXZlciBJIGJlbGlldmUgaXRzIFBDUyBpcyBqdXN0ICJrbm93bg0KYWJvdXQi
IGJ5IHRoZSBNQUMgd2hlbiBpdCBpcyBwcmVzZW50IGFuZCBub3QgY29uZmlndXJlZCBpbiB0aGUg
ZGV2aWNlIHRyZWUgbGlrZQ0KdGhpcyBkcml2ZXIgZG9lcywgYnV0IHBvc3NpYmx5IGl0IGNvdWxk
IGJlIERUIGNvbmZpZ3VyYWJsZSBzb21lZGF5IChzaW5jZSBJDQp0aGluayBpdCdzIHBvdGVudGlh
bGx5IHBvc3NpYmxlIHRvIHVzZSBhIGRpZmZlcmVudCBQQ1MgaW1wbGVtZW50ZWQgaW4gdGhlDQpw
cm9ncmFtbWFibGUgbG9naWMgaWYgb25lIHdhbnRlZCkuDQoNClRoZSB3YXkgdGhpcyBQQ1MgaXMg
YWNjZXNzZWQsIGJvdGggaXQgYW5kIHRoZSBwb3RlbnRpYWwgZXh0ZXJuYWwgUEhZIGFyZSBib3Ro
DQoiRXRoZXJuZXQgUEhZcyIgaW4gdGhhdCB0aGV5IHN1cHBvcnQgc3RhbmRhcmQgRXRoZXJuZXQg
UEhZIHJlZ2lzdGVycyBldGMuLCBpdCdzDQpqdXN0IHRoYXQgZ2VuZXJhbGx5IHRoZSBleHRlcm5h
bCBvbmUgaXMgdGhlIG9uZSB0aGUgb3V0c2lkZSBMaW51eCBuZXR3b3JraW5nDQppbmZyYXN0cnVj
dHVyZSBjYXJlcyBhYm91dCwgdGhlIFBDUyBQSFkgaXMgbW9yZSBvZiBhbiBpbXBsZW1lbnRhdGlv
biBkZXRhaWwNCmludGVybmFsIHRvIHRoZSBkcml2ZXIuDQoNCj4gDQo+IFJvYg0K
