Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B7752057A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240633AbiEITut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiEITus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:50:48 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AD9248DF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:46:49 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249JW1fo002761;
        Mon, 9 May 2022 15:46:34 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2176.outbound.protection.outlook.com [104.47.75.176])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fwnp40wpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 15:46:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4xUe5vfYG6J7wNChWU55Q5hugNgXykwxriR2EouHkCSguOsfd3hrT3V2R3hqWvMxc1FUDcPxFr4liWDceJYoS8Ixl0G5JJqCD2BGojZY0Drryn2GBaPXc4tn5SsqJdLSOeqL1tqyANVRgZhH4NnOTPKOZ9yggYOluyoGiO525GjXEX3jRQNP9GFVqRHpQmAklky+3j19e0oVSPEbGHoGT5KmUztwJHIU/BNOK89MSp/2uOxYY9uDymBAV7QUB7jbNdmIedtxco37hANaxmSHkmx+uFJ8ZVl0HTDp6sv5QOfEcWrBX7NLSMOT26wJxNQt29EJYtGubKtvIIYS3RCtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eaw9KKN2TRTwSLshKRi6NqtAVZYb3zFLUZ7nQlyhlMM=;
 b=cOioQZV6Wa861xJvdUsexjLr5tsxP2pQ9w4qjwiZJZRtQ1e4GMACVakfJ+pBoKq/v8f+IqBIIB6fUUAmB3ECkyJkluHi0fMJAE6JWCAYuKtVIXLGtv9aSvj+3Fs7Pr25UuGo7+WwgSjlKx3JUjm+O7kNHvn3ALK+PuLYHnJNk6KhqJJxWaihYnD1BdO2RK30gkI22i0sIgfz7gcztFR/SQlMvS5LxwNkNPjPxq1WHAfSmIHBS41Fk15p1/ZC6RH3LTIBIx64xYs/WYrAWVbdgkQ+m/UvOdC9DBL/byzUNuhp1ph7jofRXSD79td/Sw/iodkDyL5reKXqpbczoOtcOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eaw9KKN2TRTwSLshKRi6NqtAVZYb3zFLUZ7nQlyhlMM=;
 b=5Z+HiS4RMG6Z4otLG/NY3UZubrm0Wn6Z+jn9wMIToGDXJeY0TJVOPxqifPETUaCMqwoRNgGuAAGVAPMuRMGNmRlrtqVubVvY122SnJMpSC/xqnOGmTNVxVDGoOn450PsvbR/7BOlEmB8yPdJPFrYFib0Vhj+wH3fTedRSAp9W5o=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 19:46:32 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:46:32 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "harinik@xilinx.com" <harinik@xilinx.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Thread-Topic: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Thread-Index: AQHYXBjqW86HPeAHQEWJTK5E4QbDLq0HhAYAgAVlt4CAAHz9AIAI62sAgACwn4A=
Date:   Mon, 9 May 2022 19:46:32 +0000
Message-ID: <b3e8ec11408c5ebd144e7569d83373a44781e8ed.camel@calian.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
         <20220429223122.3642255-3-robert.hancock@calian.com>
         <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
         <7b84cace-778b-2a73-a718-94af1147698a@vaisala.com>
         <96fbf2e7f08912b1f80426aca981f52a4a7e7b97.camel@calian.com>
         <CAFcVECJL0PSTUxCh3LERxT1465vzdL7vAb+GxGHqL+FtmyQJgA@mail.gmail.com>
In-Reply-To: <CAFcVECJL0PSTUxCh3LERxT1465vzdL7vAb+GxGHqL+FtmyQJgA@mail.gmail.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efb8f36d-daaf-4dc4-d847-08da31f49e55
x-ms-traffictypediagnostic: YT2PR01MB5904:EE_
x-microsoft-antispam-prvs: <YT2PR01MB59045C3152230BEE6F8099D1ECC69@YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jvBCu+mk5yOZIWVwV6ATDKUebXhiiF9IOv5rHnOm4ARgmkWe9nwdR1TkmMmMnBIFkfPSVpvAkuuhtYx/ztyHCPh91CDJMsCb3qxH/d8conPBq9vc5BkR8Alnpsz79QIBLUvz2ral4csD+4UYbMHMiFWRqOMdr4LzicTiws94StV2Ne8H59X9upx720aNtr+hj+sGqxDXn0y0sjpYjmxjTmeZA+JwLQ/uiu4O9msxgO0o1aaedIf79MUeZ7yCPNLSuUJajnZIlrO6H06QpFha54ihFB5oxr4aEJzY3kKfmB8ewAta4wPB25wCRxQKjKmaJIx+8o1jAzcD0VIS0//iA/noVCZXd7D1zyutds3wQJAwStMMEA0rshGnB65kNWSeXcuWhO81+me/7DC0Zk+ExdrpGdqZbcOY665OEu8UkTGLRuR3w9As9pZfF9Am0SMl6o/NafwMEIQvqof42SnhUSH54CHv+DGSDF83bp5548537W1BRlYSs6zaIx7Jl3XeEQeNXVVNMHcnJSoPeGX33Owg1sGDkh3457Ig7EG30HEXkMrckLHb17laDBsULe2hUVgz+4vG+EBdssIbHlYx4yYyXt1Zk+s5BweDws37ou6qD+Haxg1+NXThIeCs9WLuA7Yv3aiukLvYLOKrJ5g7/UP3r66P7k5pre/5Ixjzm3nuRDo9P+fB/Nv0UuU649z9ASi2gJKksZxzK4XNHm69vM1W2lkiLv67KP12p1yn4p0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(6506007)(6916009)(86362001)(122000001)(316002)(6486002)(38070700005)(2906002)(71200400001)(38100700002)(186003)(66946007)(76116006)(36756003)(26005)(83380400001)(2616005)(5660300002)(6512007)(8676002)(4326008)(44832011)(66556008)(66446008)(8936002)(64756008)(66476007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVhlS2pkRnlnemlsZWRDMjA3anhkTEFtQmtoTU45eWM5YWdWai9YNTkrYU9w?=
 =?utf-8?B?VDRWeHpsRElFQ2NndjRoK243cUVla2VNM3RPZkN1YmRYTWpSVXcyMWlIUmE5?=
 =?utf-8?B?Z1B6Ynd2RnBSamY4TjVjdzJqSUI0T1N4MDZPK3dKekFzR01DSlJTWGR5UzB2?=
 =?utf-8?B?T3hldU80QUZYNmdSTEFLdGxXZDAwUllMMUpBbjFrV3A2ZFdiVmZjOEtvT2J0?=
 =?utf-8?B?U2djY1lEc0FUenhTRUtuSlh1c1o3K2RaYWdlTW1QS0ZScHdCK0ZBcUU5V2hw?=
 =?utf-8?B?TU0yVzFoaW1CYUNxMHlrYm1nN3pWb1dEeVh3NWFBV21oaHJ5T3BwbDlwRzZ0?=
 =?utf-8?B?M1FoK204dDRGRENDTEdBWjZLK0ljOXVXOWNxL2pkdHdlTlZ0QTZGbWs3TUZ2?=
 =?utf-8?B?MTdNOVZuM0xlNkFkVFl6R3VZanJzaVF1SStuc3FxUkpwa2wxaWtBYmFKS3Fq?=
 =?utf-8?B?WFFlc0hRRU4zRC9KOEFGMldsTXR3TTdnZTFSd1BaL003SE8xZHEvREtiallo?=
 =?utf-8?B?azEweUllM2J4dm1tWWVrdnlKR1E3VmRiRnVUZk01RVhXTHRkK091RVROSldE?=
 =?utf-8?B?dVdpVVdEdTBHNE8wMFVsZHVUQ2ZxSGp5eHh2TllKY0E4bkNYSndyeU94c3pN?=
 =?utf-8?B?VVdXTjNFYWhKa2pBMnJVaFhieGN6NFMxNENscTRONzJJYnV3S3VtNnNoRDRo?=
 =?utf-8?B?eW41RW9jZmVzVzY5eEJuRUxXWkFmaGdDVkpRN1c4Q2ZDQjNxNFVqOHNNVWxO?=
 =?utf-8?B?bkc3aDc4cW1idVVNN2w5THZsSDRKcE1BV1AvRzFlNUVQeEN5Z0dWUWU3UGhC?=
 =?utf-8?B?bHJYaUt0Nm5LQlQ2VDVKVGYxaU5kRUtkblh3aXJTWjBRZElLUjBqbXJ1Myt1?=
 =?utf-8?B?ckpzQ3J0QzEzam1pck1vZXJvQXZYZ3lwdDh1SFp0VnBUaG5kckVIejZVOVNx?=
 =?utf-8?B?TUhxaTJFYUNMNDM4TFF0Mmlwdk5rQWl4cytiSkJKWnUxUUFkaERqK1lQWml0?=
 =?utf-8?B?amhFS3Q2THB4OHpsODFSTEVDdWl1a3VvMGhXRzhMOEgvaHFkcndROWRWdDN1?=
 =?utf-8?B?a1NYd3FkbDdhSlduNGJtdFBmV2g1aU9PQ2w3KzByOHBMNzZZMDV1L2k5bHND?=
 =?utf-8?B?ZldoQUdjT2IzcnZnbTZBUldvZThCcU1OV2NtcnY2YmYvU1FsaUVMclg3MEEy?=
 =?utf-8?B?Y1A2emFOckdQQmY3MHdwNE1STk9lSWdHNEMzcGFKNk9vbmM1ekI0Vm13bUdh?=
 =?utf-8?B?UFc5RmFId1BZejg5TXZtNmJXQ0lSenJndU1sL2VmbkYxN1ZmbjBWSW9LYkRI?=
 =?utf-8?B?dW5pOGlZald6MTMyZXA1ay9hRDVuS0xtNndhTExJWFlkV21WZUwxRFlIbmJU?=
 =?utf-8?B?NXd1QzQ2OGhaQU1ZSXhudDkxS2t0YXlMWElaZTdMa0ZNclJVejZTT0ZQZmJW?=
 =?utf-8?B?c1huSFB4Q3FsTHhJMzF0Vm5oRmk5a00yUUZmWm5UaEYyV0JxNFEyY2RRQllM?=
 =?utf-8?B?bDdsMmM5dnRVVm0xRG5qUG5FN2tNTll1QjUya3NuMEx5cGFMdXRuMkJRUWRI?=
 =?utf-8?B?RktoajZ1c1VTYkxyd0xXL1hLTVpIRjkwMWFqY3lSbnUrOU9XbTJKSzFBUC9F?=
 =?utf-8?B?STRqUHI5bU9Ja1BKU00xRTU1YzJ6aGVJYjNNWXN5eEs4Nm1IMllkTSs2d3dr?=
 =?utf-8?B?OTNDcW80UmFxODg4VHpFWHI0c2lmN1VLUnpCaUV2Q21YR3I4T2NVYkFWVkh2?=
 =?utf-8?B?eWxhRVFISUUzajUwR2dGL1l0TS9OV28ydkRtRnBHZ2xtd3NOL0M2ZXJtTE0y?=
 =?utf-8?B?OEhjTTg2Ui9keC9yUll3TFJYeE1BTVJoQXFhNVpxZVFiR00rT3FoeWwzT3M5?=
 =?utf-8?B?VEkxSGxrY3VBTGo1aXRQNkViRkEvOTZVMitNK2Jra05YSzY5VlRsZ2EybVZx?=
 =?utf-8?B?UkMyNllEYWJONmFyNnZFbUFISENSOG55ZkhxSkNQc09yRDlDdUhZK1hYS3dv?=
 =?utf-8?B?Mk0yc1Nkb3FOeHZWZndjZkZEVHB0SEgwK04xRnNzVmpRcE4yWlhhanMvV1lH?=
 =?utf-8?B?OXE0TnZUWFVjb3RZU21iajcwZS9qRk5LanNqR1hBN2dpcXd6cEkwcWtpeDJl?=
 =?utf-8?B?MFJJdEZETEIxMkdIaTM1ZWFxelNjazBoUHo4aWw5Y1BFcmk1bGxla20wSmJs?=
 =?utf-8?B?UGhBamZ0VXpjNHhnQXFuSGpDb3I5V1hCSWs5ZWtobVEwQVVaR0J4QlRzazh0?=
 =?utf-8?B?aklvSENoYVk2dHB1UUp4Nkp3WFVQWHJ2a01VRC96NnZXNTZNc05FZU9MTDZr?=
 =?utf-8?B?d0FsSGROb1hoenpQU0g0emtNc1hHWEpVTHpEajkweDNSVU5JckRvcUdJWFNl?=
 =?utf-8?Q?RrL9FeSa8dYvZ4VN5j55h8iEwQ8xf+fiMTpEO?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA4647D21C54F6418EBCEDEE81D1AC35@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: efb8f36d-daaf-4dc4-d847-08da31f49e55
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 19:46:32.3928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K+qDqOnESYdpsn4nowEpTYtTYmVAuLU4EGUnC88ORKjjTlTGATU3Rd+PIOQoCpLjrczoPpRVVaUK50+Gjcusix+PaYNliqXsrNnFeQZrrNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5904
X-Proofpoint-ORIG-GUID: VfCS2-CMUqr80uFn84DpcWeC6ibHcK1l
X-Proofpoint-GUID: VfCS2-CMUqr80uFn84DpcWeC6ibHcK1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=12 spamscore=12 clxscore=1015
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=12 mlxlogscore=88
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090102
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA1LTA5IGF0IDE0OjQ0ICswNTMwLCBIYXJpbmkgS2F0YWthbSB3cm90ZToN
Cj4gSGkgUm9iZXJ0LA0KPiANCj4gVGhhbmtzIGZvciB0aGUgcGF0Y2guDQo+IA0KPiA8c25pcD4N
Cj4gPiBPcmlnaW5hbGx5IEkgdGhvdWdodCB0aGVyZSBtaWdodCBiZSBhIGNvcnJlY3RuZXNzIGlz
c3VlIHdpdGggY2FsbGluZyBpdA0KPiA+IHVuY29uZGl0aW9uYWxseSwgYnV0IGxvb2tpbmcgYXQg
aXQgZnVydGhlciBJIGRvbid0IHRoaW5rIHRoZXJlIHJlYWxseSBpcy4NCj4gPiBUaGUNCj4gPiBG
cmVlQlNEIGRyaXZlciBmb3IgdGhpcyBoYXJkd2FyZSBhbHNvIHNlZW1zIHRvIGFsd2F5cyBkbyB0
aGUgVFggcmVzdGFydCBpbg0KPiA+IHRoZQ0KPiA+IGludGVycnVwdCBoYW5kbGVyIGlmIHRoZXJl
IGFyZSBwYWNrZXRzIGluIHRoZSBUWCBxdWV1ZS4NCj4gPiANCj4gPiBJIHRoaW5rIHRoZSBvbmx5
IHJlYWwgaXNzdWUgaXMgd2hldGhlciBpdCdzIGJldHRlciBwZXJmb3JtYW5jZSB3aXNlIHRvIGRv
DQo+ID4gaXQNCj4gPiBhbGwgdGhlIHRpbWUgcmF0aGVyIHRoYW4gb25seSBhZnRlciB0aGUgaGFy
ZHdhcmUgYXNzZXJ0cyBhIFRYVUJSIGludGVycnVwdC4NCj4gPiBJDQo+ID4gZXhwZWN0IGl0IHdv
dWxkIGJlIHdvcnNlIHRvIGRvIGl0IGFsbCB0aGUgdGltZSwgYXMgdGhhdCB3b3VsZCBtZWFuIGFu
IGV4dHJhDQo+ID4gTU1JTyByZWFkLCBzcGlubG9jaywgTU1JTyByZWFkIGFuZCBNTUlPIHdyaXRl
LCB2ZXJzdXMganVzdCBhIHJlYWQgYmFycmllcg0KPiA+IGFuZA0KPiA+IGNoZWNraW5nIGEgZmxh
ZyBpbiBtZW1vcnkuDQo+ID4gDQo+IA0KPiBJIGFncmVlIHRoYXQgZG9pbmcgVFggcmVzdGFydCBv
bmx5IG9uIFVCUiBpcyBiZXR0ZXIuDQo+IA0KPiA+ID4gQnV0IHNob3VsZCB0aGVyZSBhbnl3YXlz
IGJlIHNvbWUgY29uZGl0aW9uIGZvciB0aGUgdHggc2lkZSBoYW5kbGluZywgYXMNCj4gPiA+IEkg
c3VwcG9zZSBtYWNiX3BvbGwoKSBydW5zIHdoZW4gdGhlcmUgaXMgcnggaW50ZXJydXB0IGV2ZW4g
aWYgdHggc2lkZQ0KPiA+ID4gaGFzIG5vdGhpbmcgdG8gcHJvY2Vzcz8NCj4gPiANCj4gPiBJIG9w
dGVkIG5vdCB0byBkbyB0aGF0IGZvciB0aGlzIGNhc2UsIGFzIGl0IHNob3VsZCBiZSBwcmV0dHkg
aGFybWxlc3MgYW5kDQo+ID4gY2hlYXANCj4gPiB0byBqdXN0IGNoZWNrIHRoZSBUWCByaW5nIHRv
IHNlZSBpZiBhbnkgcGFja2V0cyBoYXZlIGJlZW4gY29tcGxldGVkIHlldCwNCj4gPiByYXRoZXIN
Cj4gPiB0aGFuIGFjdHVhbGx5IHRyYWNraW5nIGlmIGEgVFggY29tcGxldGlvbiB3YXMgcGVuZGlu
Zy4gVGhhdCBzZWVtcyB0byBiZSB0aGUNCj4gPiBzdGFuZGFyZCBwcmFjdGljZSBpbiBzb21lIG90
aGVyIGRyaXZlcnMgKHI4MTY5LCBldGMuKQ0KPiANCj4gSW4gdGhpcyBpbXBsZW1lbnRhdGlvbiB0
aGUgVFggaW50ZXJydXB0IGJpdCBpcyBiZWluZyBjbGVhcmVkIGFuZCBUWA0KPiBwcm9jZXNzaW5n
IGlzDQo+IHNjaGVkdWxlZCB3aGVuIHRoZXJlIGlzIGFuIFJYIGludGVycnVwdCBhcyB3ZWxsIGFz
IHZpY2UgdmVyc2EuIENvdWxkIHlvdQ0KPiBwbGVhc2UNCj4gY29uc2lkZXIgdXNpbmcgdGhlIGNo
ZWNrICJzdGF0dXMgJiBNQUNCX0JJVChUQ09NUCkiIGZvciBUWCBpbnRlcnJ1cHQgYW5kDQo+IE5B
UEk/DQo+IElmIEkgdW5kZXJzdGFuZCB5b3VyIHJlcGx5IGFib3ZlIHJpZ2h0LCB5b3UgbWVudGlv
biB0aGF0IHRoZSBhYm92ZSBjaGVjayBpcw0KPiBtb3JlDQo+IGV4cGVuc2l2ZSB0aGFuIHBhcnNp
bmcgdGhlIFRYIHJpbmcgZm9yIG5ldyBkYXRhLiBJbiB1bmJhbGFuY2VkIHRyYWZmaWMNCj4gc2Nl
bmFyaW9zIGkuZS4NCj4gc2VydmVyIG9ubHkgb3IgY2xpZW50IG9ubHksIHdpbGwgdGhpcyBiZSBl
ZmZpY2llbnQ/DQoNCkluIHRoZSB2MiBvZiB0aGlzIHBhdGNoIHNldCBJJ20gYWJvdXQgdG8gc3Vi
bWl0LCBJJ20gc3BsaXR0aW5nIHRoZSBOQVBJDQpzdHJ1Y3R1cmVzIHNvIHRoYXQgVFggYW5kIFJY
IGhhdmUgdGhlaXIgb3duIHBvbGwgZnVuY3Rpb25zLCB3aGljaCBhdm9pZHMgdGhlDQpuZWVkIGZv
ciBhbnkgcmVkdW5kYW50IGNoZWNrcyBvZiB0aGUgc3RhdGUgb2YgdGhlIG90aGVyIHJpbmcgKFRY
IG9yIFJYKSB3aGVuDQpub3QgdHJpZ2dlcmVkIGJ5IGFuIGludGVycnVwdC4NCg0KPiANCj4gUmVn
YXJkcywNCj4gSGFyaW5pDQo=
