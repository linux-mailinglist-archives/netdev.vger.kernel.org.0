Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC17677DCF
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjAWOTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjAWOTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:19:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028AB16AE0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:19:16 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30N9lKkR017081
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:19:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=hrmlM7fhTG05Duwmf/rX7U2K4FO+xQtxRZXAkrbpDow=;
 b=H90jhM6mV+vtgszNHWvNjCkLFkC2caG7pjl66FOnHWWVHfs6khF95RbrTp0rkwtG000N
 1mhy17is1Q9ZC0gO7xp656FHPl6g5jMVRgO/B4GNtfNZP30Iry9UMi6PE7aOu0NliTlE
 0yLhIsr/YdJzSQ/LO3uShmYEIUO//Ljn6h2BKCwwv+PdP+5FYtRZXdRYxc03GLeW4k88
 efQjH5hgCJ910Jp6XBuMwBs3hSGLqxgZE3SjDfxIwM7O0G5fSC4kKHfhn87S4prg6NOh
 ZJDSECbFGmxMVVW5vmm1hTWZNgbsjq/eOjjAuZATDLXIzGh8VFXdiQTXKzDzqqQI9Xpz Bg== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8c8tq4y8-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 06:19:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNdVOjRdUA9TrYaxhxeQj0giyZpytkMYyUgaECwSQmvvwHEvIgYo9vPYfXFWBr5Tr9o8PXN+Ba31fcI6r6JVmPnUe9QdabNtyrGxdgAIj53dsdTHpOvCNb87QoIGPNKBHboT9eWtnRCIJ3oEKzo2L90Vkdf4UuZNvh7bTt8DgsmyswvnXn1HL2kBBm94Incg3YV+QBTZS0lEr97dhBabgVv14h0D5iDQJM38soG9T2TD8pWc0es/M+0OaPJVJ/TDAZr0JtgdYjm3CstkpUAtFt+mA66K2nTsGqBfIaqgsDX4ArVRVYGlrlFLFSWYFGKE6GLd5eX/mFmIDwZoGmxazw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrmlM7fhTG05Duwmf/rX7U2K4FO+xQtxRZXAkrbpDow=;
 b=ncjKqV4EVXFDAmLGOmmWWT+qM4ob9hNmIEn9RfY/7VKj5McIe09Uwr20CEIGjYPWNO9BZtyy3iYyEON6rQVlYhgGRu7ALJjH2Z9KG7kqH99kkqB0fY16rgTnOekash+Rs0eHM5k2kkDUcKqsendiEXKZOrN86FKNrvWXnQCSnK/Pws4Cs6qXyDgvYVEL7Pu036owvjF3CJ4ynXNZ/OiLh3XoZc263gg5uBM+EzI3tLRt75Ga4m0wEGjD8MXTahS3NQ4hSWPeB04ldlqnQbS6Mfp0c/BnnpMcelluQ9gXUjxT+XWuHZ0trGYO2n2sWayUTob8F9VqHBxcwK3cC7TR/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by SJ0PR15MB4680.namprd15.prod.outlook.com (2603:10b6:a03:37d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 14:19:12 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::207b:48b8:3fbf:1fa%8]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 14:19:12 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Topic: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Index: AQHZLnza/MOTtBC6Vkmawt4udI7hba6rmVwAgAB0/YA=
Date:   Mon, 23 Jan 2023 14:19:12 +0000
Message-ID: <87992fa4-22c5-1af1-6d0d-f55fc3c0edb8@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com> <Y841PJnZiF0WfoBn@unreal>
In-Reply-To: <Y841PJnZiF0WfoBn@unreal>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|SJ0PR15MB4680:EE_
x-ms-office365-filtering-correlation-id: 2bacba5e-2a95-4b53-a0eb-08dafd4cccf2
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TM2wBsDTPOZVD6s/uyKZuoAAO27okwS+2rHguSv1+rZFImw+67UJYvtTAhyd3EbCDWVHzPVNmDb/xn3B+sy1H50Kx/bwvYkGmKCXrwbnNRtokRNQ5jfKWlMnyvMlzSYUOeAkAN+z84ZGofH8KFd7P/10OSoKhS1sdlAtkxs6QbpalRR1b5tHPXQYP9a/2kMXD+BkBHCPFOesg3k+Yewgg253EncyypDC6QBBt/9gvn3rJCAm+O4gIznK631zEZSQCtnLFonFBDgCE/Y2OqpCg2xBC5QCmwYLJ3xDY96JHNjOS9O44Gv91qSpwXHEu0shSz4M9ZgGSUnZ6boAtQZgjj75D4P7NaahZqJv181rS9W6RhyenG8PK+OEgIXi80YY34N40GEKxAebfmbPsnB/S+COLYJlk5ebukMKsmZtmeAImplWi9XbzMwV0sYxKJtFXtqzkiMfUa1D5DXh5UrDayfkYl/8dvg8veQl43VAZNHHiIWbTcsypIDDSNwFv62m4LyK9J/oXiTOOToyV2wiCOgY36CTLZlifWRr7k3nBWvGmThygN94E6hPKNC73oe1QL9oI331O4vdYCjyesPyvzheMj85ai01Cov1x0YYWaMCvaXJEtO+jF8IVdwUiubmavgnzlpDCC3zbliwYvYZGfdUWicjZrzAKsObI1hUkdSwGYizGhGOizTm7dFgeiPvJ4CVtGUzQyfOlEsFW/bDl4+OiUvq5poP8IPLq7oXjSc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(38100700002)(122000001)(83380400001)(38070700005)(31696002)(41300700001)(86362001)(2906002)(8936002)(5660300002)(4326008)(6916009)(8676002)(53546011)(186003)(6512007)(6506007)(66476007)(316002)(54906003)(66946007)(76116006)(64756008)(2616005)(66446008)(66556008)(91956017)(478600001)(6486002)(71200400001)(31686004)(36756003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eGRRQ0JFQ0dlS2laUlRPK3V6RTN0R1VQMWlaRVFyT2RpZ1ZiVXB6TUk0ZFpv?=
 =?utf-8?B?UENLbGZVbFpnWlNDcnJJamVnMkFwbkU1WDJReGJENEd6TzVEL3NmNU5yazdm?=
 =?utf-8?B?S0diQUluakRxd3ZTTXJZVitmTy94bjRlWmkraEJaZ1FQb2Z1biszbk41eXpz?=
 =?utf-8?B?aCtobHg1Uk9yaEF1UzkxOEdGYVJXSk5VMU85MU1hYy9IbWtFTE9PWGRObG95?=
 =?utf-8?B?ODdPQjgzM0xWOXVTeEN1NTVUaWVyNy9rYzQwbEgrd1JPektlQ2NOdEdrUDl2?=
 =?utf-8?B?Q2oxaG9rRndLK29TSXdQdmRVc1Iva1orTDJOd3NSR2o4dmZXY2dHS1hJaDlv?=
 =?utf-8?B?eG5vZlJCallqT2x1R0ZBQVplcDdobzhKd011V3RQU1pERkxNajBHVTR3Vng2?=
 =?utf-8?B?emcwWWhvNFFKTTBQTElENGp6WitST0lNRDVrdXN1eFN1b2x2NUE1Mm84Vm10?=
 =?utf-8?B?emRnSVM0QjNtVnRyNndMQ1VidGY3UFRPQzI0UkVlU3g3N2Y0OEFxanhsVTRN?=
 =?utf-8?B?OTBkQVl1VXZRVjVHWS9ZREp5RWNEcm1JRDlpQlNJaStXZmZZLzc4bVczRm5B?=
 =?utf-8?B?Q3htVVVmcnlLNXhhMWI3bEM0T1NaaVExa3doZ2sxdDB6TW03VGVoSUE0RGgy?=
 =?utf-8?B?azdYUHNaZ2hHblBzVER6OGIyYmZreG5rQjBvdVViM2tGbjg3Q0luLzZhczNO?=
 =?utf-8?B?YXh0OThsSlVVV1FJaXgwN1dEV3dybmQ5N2x5YUdESk5QQUpleHJkV2w0aGdR?=
 =?utf-8?B?cEUxcjArNDFXdTFmSUEwYlY5UGx4QkZ4SGhnSGV4QTJBUzhwT3VlemRKTG9E?=
 =?utf-8?B?ckJTU2QvYXNESEgxSFVVSmlkV3plRU9Jb2l3a2Y4MDlkM0VHS00yUU5JNnNT?=
 =?utf-8?B?cm4zSXNQM21hU25tc3hoUHd1RndKVWRwbXJ1VjJkMU1UM2llWGdXbHdxLzlG?=
 =?utf-8?B?VUZEOUNXd1JEckl2am5NYll6VTZvaTYvRzRNYUFTem9idzhyUkNtWStLYXY4?=
 =?utf-8?B?WkVaL0RQckh2SVJhZ1lPTGFFaGdDOUZMT2JIR09saThWRkp5d0kxVS9vUDRv?=
 =?utf-8?B?YmNtclUrSTNCL0MyQUdCd211S1lyd3ljNWZkOWlNS1ZXM2hYZkthS3dlRCtT?=
 =?utf-8?B?bDM2UGg0TTVyeDZ5SStFdWhSeExOK08yQ0F5bnFjNm9oSXdwZFZoSVp4WDVE?=
 =?utf-8?B?cjNmbzllTHp0QXNyVFFrY1AzT25KSkxRNEdMY0RmUENPUGxuekE3aEJycnVM?=
 =?utf-8?B?MzdXS2NEdU9ycHdXdjc3c2FheXBZUjA2R2VYRnVsYkJ6NWtQaVJhMHFXM29a?=
 =?utf-8?B?cDVyVWZKMUs2VTY3N2pvSXMzbjllaktwWTVjL0ZtSnNLenAzcmJGRmdFT0pR?=
 =?utf-8?B?N05aRDhYZVJHcTJTdmVXK3U5aUV5RVlseFRMUGdmWGZ6V0xQS1Z5VTRJSDdO?=
 =?utf-8?B?ZUplaE1jN0NTbEpQZ0VIZGllSSthdFJhOFZZL2FWaHNzMU1YcHpFSm12STg3?=
 =?utf-8?B?M01tQ3FsaS8zOVNyRk43bnd6WnZkQk5UY0lnZklDNXNkbm8rZnZDRkk3bzVz?=
 =?utf-8?B?OENTYTMzSDJKQ0x0bkJoR1oxRXpNektxdzdIZndUQzRsZXo2SnZtbnNrVUYx?=
 =?utf-8?B?a1JHbWV0TDQ4YmQrZUJHWTBEQjkrV2lBN3ZJZlVieVVDekg3aDA1UmxFbjRP?=
 =?utf-8?B?ZEZTejB2SXlaVFZaeE1YeEkzSGhxVU5ROXRYdGh2NlY4NkVoV09NeEQ1K1V0?=
 =?utf-8?B?TGFqWFREYzdkbkcxVGJleUZndnZBdDg3MGF1N2NiT1BhSDF4bEFtMjJuTjZV?=
 =?utf-8?B?STE0R1VQa2FDMkY4NE1BbGhudUtBSmlZaHA2R29OU3JJbytSQzI1R1k3em5W?=
 =?utf-8?B?NzdQTm9mWlNCRFBBMVc0RjdTTU1EQmdZbzVDMUNSVHRvbWYxS3ZFcGQraEdp?=
 =?utf-8?B?elNEUktzNThQTHIvb2g5cWh0SlJySzdFcm1UdThnNkRjVS9DdDVuY2Y1NytR?=
 =?utf-8?B?V3lBSkFMS0lyV0ZLUXlOd0ozR2Z6Y0tmS3NTaVpyZTVWT0g3WUhqSnNKaEtK?=
 =?utf-8?B?L2lzaDZwNnNJdzJuQnlaREpFelk2L1FRQW5NYlNlTHpNS1RnMHRwR3NteU1t?=
 =?utf-8?B?b1I2N2lQeFdqN2wvb0I3eFVuMUJNaDkwbjQ5UzZMd1NBaUt1bWd2dzVtMWlm?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCAE3C416FCB2B4B88B77AF265E1659A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bacba5e-2a95-4b53-a0eb-08dafd4cccf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 14:19:12.3672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8dXF27ytTQJg2RkSdZuRC8WNR8kTarsB5+LG2Gtms/DxAyFdpd6cD4OP/GZjYCCx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4680
X-Proofpoint-GUID: R3mShorUH1yV883BaZ6-Q8q4Le44RzF-
X-Proofpoint-ORIG-GUID: R3mShorUH1yV883BaZ6-Q8q4Le44RzF-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_10,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMvMDEvMjAyMyAwNzoyMCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPiANCj4gT24gU3Vu
LCBKYW4gMjIsIDIwMjMgYXQgMDg6MTY6MDFBTSAtMDgwMCwgVmFkaW0gRmVkb3JlbmtvIHdyb3Rl
Og0KPj4gRmlmbyBwb2ludGVycyBhcmUgbm90IGNoZWNrZWQgZm9yIG92ZXJmbG93IGFuZCB0aGlz
IGNvdWxkIHBvdGVudGlhbGx5DQo+PiBsZWFkIHRvIG92ZXJmbG93IGFuZCBkb3VibGUgZnJlZSB1
bmRlciBoZWF2eSBQVFAgdHJhZmZpYy4NCj4+DQo+PiBBbHNvIHRoZXJlIHdlcmUgYWNjaWRlbnRh
bCBPT08gY3FlIHdoaWNoIGxlYWQgdG8gYWJzb2x1dGVseSBicm9rZW4gZmlmby4NCj4+IEFkZCBj
aGVja3MgdG8gd29ya2Fyb3VuZCBPT08gY3FlIGFuZCBhZGQgY291bnRlcnMgdG8gc2hvdyB0aGUg
YW1vdW50IG9mDQo+PiBzdWNoIGV2ZW50cy4NCj4+DQo+PiBGaXhlczogMTliNDNhNDMyZTNlICgi
bmV0L21seDVlOiBFeHRlbmQgU0tCIHJvb20gY2hlY2sgdG8gaW5jbHVkZSBQVFAtU1EiKQ0KPj4g
U2lnbmVkLW9mZi1ieTogVmFkaW0gRmVkb3JlbmtvIDx2YWRmZWRAbWV0YS5jb20+DQo+PiAtLS0N
Cj4+ICAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vcHRwLmMgIHwgMjgg
KysrKysrKysrKysrKystLS0tLQ0KPj4gICAuLi4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9lbi90eHJ4LmggfCAgNiArKystDQo+PiAgIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fc3RhdHMuYyAgICB8ICAyICsrDQo+PiAgIC4uLi9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fc3RhdHMuaCAgICB8ICAyICsrDQo+PiAgIDQgZmlsZXMgY2hhbmdlZCwgMzAg
aW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+IDwuLi4+DQo+IA0KPj4gQEAgLTI5
MSwxMiArMjkxLDE2IEBAIHZvaWQgbWx4NWVfc2tiX2ZpZm9fcHVzaChzdHJ1Y3QgbWx4NWVfc2ti
X2ZpZm8gKmZpZm8sIHN0cnVjdCBza19idWZmICpza2IpDQo+PiAgIHsNCj4+ICAgCXN0cnVjdCBz
a19idWZmICoqc2tiX2l0ZW0gPSBtbHg1ZV9za2JfZmlmb19nZXQoZmlmbywgKCpmaWZvLT5wYykr
Kyk7DQo+PiAgIA0KPj4gKwlXQVJOX09OQ0UoKHUxNikoKmZpZm8tPnBjIC0gKmZpZm8tPmNjKSA+
IGZpZm8tPm1hc2ssICIlcyBvdmVyZmxvdyIsIF9fZnVuY19fKTsNCj4gDQo+IG5pdCwgIiIlcyBv
dmVyZmxvdyIsIF9fZnVuY19fIiBpcyBub3QgbmVlZGVkIGFzIGNhbGwgdHJhY2UgYWxyZWFkeSBp
bmNsdWRlcyBmdW5jdGlvbiBuYW1lLg0KDQp5ZXAsIHN1cmUuIEJ1dCBJIHN0aWxsIHRoaW5rIHdl
IHdvdWxkIGxpa2UgdG8gaGF2ZSBzbWFsbCB0aXAgYWJvdXQgDQpyZWFzb25zLiBBbmQgYWxzbyBz
b21lIG90aGVyIGZ1bmN0aW9ucyBpbiBtbHg1IGhhdmUgdGhlIHNhbWUgZGVidWcgaW5mbyANCndp
dGggV0FSTl9PTkNFLg0KDQo=
