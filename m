Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09FA84D3A93
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbiCITrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiCITry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:47:54 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4458E;
        Wed,  9 Mar 2022 11:46:55 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 229FFrSH012493;
        Wed, 9 Mar 2022 11:46:30 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3ep38ph6qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 11:46:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcGaIpydXNoz3VOwhKIbwL39ZXDIU2iVuhi0gN5oG60pkkwqvCCGBRrP4FpC6RDlHJRvcfGk5CYJ6d3d8ffZevxPCawNNHDY6SUDszMrJ0vkXY/8pv2hm/7xA4HzcMy841LRPVXbYinUAcD2QcAwBfDXjnI+PsMCYh4w5loECoxAXiVyEDOErWiBLtOePHpU/iEheHZasShj03vyorvD4ZGvUCUnUrmIghbxh763BPTRW+6jSAJPB4S8Rnw9zBpyfGwdUiXZUa4niQbZDsji5axkxi1nOmMBkbypq35yNo7xl2GXYL8aDK9OQbot4H/2JTcNsHrWPjbwZ0O4syTY0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yCaNXq494/ckss1q+7kSUlWkzebCLOUUR03brBBrSw=;
 b=dq+fdSDU5FR4Kk7XtsSjsJ5d/ZGr17+L0XqbCOR4PWwwIRTiTyfeiesCb2HvZygdm2LS7YjOf9V9XsvGwhKd1iUOkw2NTkwRpyHVQyGTzSg20GDFCj688pXmhLdghaKfBwku/McLw4xFidTEaAZp/r/zlpg5daftVEcKkJrlbJ34Q58bN09KwP5Q1N9X6nOsPvChL1LN4uqa45C8dnVW1udvaBtEAX03gtQ3a0anp7+qZyznAAD+83hAfL6JlheWPVKTaRzTo6X27AIUi1U/goibRwxVI2lDxVvcpMQZCCevhqexCcyy/yNWPII4MrwouHXmhdmE/KDfqp07mAT2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yCaNXq494/ckss1q+7kSUlWkzebCLOUUR03brBBrSw=;
 b=lid7jm0lrM2ulY9UdpoI/uXd6qmXp4fMcjQeCoivTUULtm5Z2dnVzfhEErjS0gLFs3Bvvoh9d9Dp/Db+NGicg1BfpYlIh9LvkETKWwXKuE1ojMD6z25TT2wUPtmEqhBNdK6G2DhzRc9bUDvVtV1129EqKislmDN97xSgD5stslk=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BY3PR18MB4817.namprd18.prod.outlook.com (2603:10b6:a03:3cc::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 19:46:24 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:46:24 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Topic: [EXT] Re: [PATCH v2 net-next 1/2] bnx2x: Utilize firmware
 7.13.21.0
Thread-Index: AQHX82cKaSG7IQ3NYE6x2TZQurl1/6y3uviAgAACYwCAABsBAIAACH9AgAAPEQCAAAE60A==
Date:   Wed, 9 Mar 2022 19:46:24 +0000
Message-ID: <BY3PR18MB4612C2FFE05879E30BAD91D7AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211217165552.746-1-manishc@marvell.com>
 <ea05bcab-fe72-4bc2-3337-460888b2c44e@molgen.mpg.de>
 <BY3PR18MB46129282EBA1F699583134A4AB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <e884cf16-3f98-e9a7-ce96-9028592246cc@molgen.mpg.de>
 <BY3PR18MB4612BC158A048053BAC7A30EAB0A9@BY3PR18MB4612.namprd18.prod.outlook.com>
 <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
In-Reply-To: <CAHk-=wjN22EeVLviARu=amf1+422U2iswCC6cz7cN8h+S9=-Jg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 91a932d0-bd54-4b99-d34d-08da02057e6c
x-ms-traffictypediagnostic: BY3PR18MB4817:EE_
x-microsoft-antispam-prvs: <BY3PR18MB4817A6D6D131AFC147385BB8AB0A9@BY3PR18MB4817.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BRqJXKA9PjNyUM4IE+zMvkv6wzOK5q3UpBAMiMDmsMNXb2bxz2CG6O2X0tki8qykcHhBc7mEqWK00aw0UBaICWm/nx91EVyD5H8S1/iEzerwC16yS4ACQYW55cmeDPMrGulAKSGB/U/veJiBXBMmrRyzvyNP0rMuYN69LWg0mIEmuAdTKBa0uNv18KVCSkDIQr3Y4QRTlbzCmjfHCLzMvstiW4VDPSGTXTqIXF0YtSwUijnENY5SyWEM2X3aH/p90AsUn27I7RlyhvrFZGmeiANRYwcQBdZcGepNQrKvTff/TTHKXGdOVxHDUbPMLj8qytozlFOrqJtChwB5e2h1NRaizM/MEgss1dZ8gCytPaEn0N16eJYKLnJdm/27T8Gtak/TD5juX3TU5OUjF/b2OUYU4OtmX6IkBkjE1PD5Sf+Hoc/ypWwcV0PMW+eB8wnKSvbejbbJOLoyRdqwnC2CWKb+8+nrjztkItJ+c5UI1JO09FJ3snUzPrIL5Prg1FOGBeiO7nbkjqQf5iPEblyZwiWjUNeyxQGtA1IUd5aS/BDu11Mz5mn/NdtnSfVWca1CCN8+AbxsdPphDEuAQ710nVdrNvYaboTU7rn9iHRIA2Cq0YDjP1+TpkQRMCgBpR+69fDuRie0F+nT3aqwJ9M+m6tyd+KX9YvNGQ6BFbxTdTyIoLGb1UVyVEQzWgJ0GYGcYA7HOKsnR/sXyaCmrB6b/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(55016003)(186003)(508600001)(66946007)(4326008)(38070700005)(8676002)(76116006)(2906002)(52536014)(66476007)(86362001)(66446008)(5660300002)(66556008)(64756008)(316002)(122000001)(6916009)(8936002)(9686003)(53546011)(7696005)(6506007)(83380400001)(38100700002)(33656002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmJXTTFNQklFVHU0cjJYamQwOXBHdnFXMmlMellnVnFVRFJSY3NxbXhxUllp?=
 =?utf-8?B?ZFU3aFVqS0IyUmp3TVJiSzVTRkNoMXp2d29JNldCZUdKNVhhcUlyZVJhS0pU?=
 =?utf-8?B?L1Ftd3ZJK3N1MU5COG9RZ2dxcm9zL1hOdkZxTjlaMGxJVmR4ZVdhd0FMalFR?=
 =?utf-8?B?RVgwbkJoeHFTZTFqMWJvTWVKRWxJVkFyRzFhNndZcEpERkRKVmlyeVRUV0xX?=
 =?utf-8?B?clZMM0w5eXlrSmFjMFdRZmpNSTVKSHdSQWMvdnEvVG5TWDkrcEY5SEdCZEsv?=
 =?utf-8?B?d0lRaVRCejFrRkJUMFgyVkQyaFhmOUtRbnZCNkpLdFZnbGdxMUFOU29Ma014?=
 =?utf-8?B?d0xKQ0ptOWlFWDAydE54REFISldXc1Yvb0NrZ2NLYUtXb2syQ2pjKzhWekNj?=
 =?utf-8?B?QmhFNzdPMzdFU3ZUOTdBQXhuM0dDR2xtR3Q0ZzhFTTVBRHBFMTU5M1NURGVU?=
 =?utf-8?B?UFNublo5bU9mWkVnNStGVUFHaXhxVTJUWVVIdlErVzk4TFpwVXVuaVRUek9s?=
 =?utf-8?B?NWFvQmQ4R0lrQ3dyeG84VkI0YnRnZy9LWWg1NmRmQ09EU2pFOWN0YVBGNG1k?=
 =?utf-8?B?MDBiYUJLV29SaFV4VnNIMWwrdEFnWFRkZ0hMWHJsN2V5MkpTczRIdmczL2g0?=
 =?utf-8?B?WXd0cWZIWng3K3RleVI4VFhqeGpBNFBjS2lnZ3VsNTJGaUJtRFIvVEZxUDJz?=
 =?utf-8?B?bGRVZnBtM1ZZQmtkenJKYkd4VkF2U2dqOUtlaTZVN0Jwckh4N25ieHZ4aTZY?=
 =?utf-8?B?cXpwNFl6UzA0OXpldzQ0N25KbWk2cEV0MU5jaFpoMWR5d0lYREFZWGZYTVBl?=
 =?utf-8?B?SklScUVkdE1aRDRBUWdqczErZ1dHcE1PTExPdllLU0RxT3pCWFZZVDlsQ0tq?=
 =?utf-8?B?OUFYUW5YWUc1cCtuU0ZxanpmNkdPZUY2Q3BsS1VCZmtJZzR0cGE2UEZLTDRm?=
 =?utf-8?B?UDZWeDNtZEd6R0MybklwUG9nQnpGZkFtdDg0ekUxZVV3b1loUGZEekkxRGFU?=
 =?utf-8?B?dm9FVEwyaXFZTnJheVF3eStibm9CZ3hSVmhTSGljYkZWMjB5dVNzcHFnUVkw?=
 =?utf-8?B?UkxqZ0VVeUJocXVVaElFWnoybHlSL0YyTWxHcEh4YTBWV2pienl1dk9hTU5a?=
 =?utf-8?B?cXR5MW1pNTlDZW9yc1ZjZ2lUaW50YTQrMDFWemRaTWFTTGIvekJJaVU0b01V?=
 =?utf-8?B?aXU5eU1oZkVPdXJRRHc4a25razQyUGJxV1A4VmE4ZEw5T1IwYlJwUEV3NEor?=
 =?utf-8?B?Z2oxajArWVpHam1zS0FnVllxSGVoWWpmMjE2cWpuMGZ5alBjcGl6Rk9IZ2h1?=
 =?utf-8?B?cEdud2Q2RGdac3R4Z2NLbW5UQUhkamFuRFVISjh6WklrbldHckhGaG5QeXd0?=
 =?utf-8?B?K09aQjNoSzN0dUg1L1FrMGxzWjgzSktWNTRQOUVDMDc4RTNnUE1NRUpWUTgw?=
 =?utf-8?B?WHUwU1hTZUV1Vk9aNUFaZFZvSXpwbmROUFZWU2N0QmFFRmNvR3ZZNjVlb0ZY?=
 =?utf-8?B?a3BBazIxMFJtVXhZTGE3YjNkWjNyb3gwN2xwOTRVYnMyYXNubmxNNGdQemNS?=
 =?utf-8?B?YzRaUXNkUStVcDZVT0U5czB1U1VQYlVmb3ZCcU5zL3pqZ0Vkc2hVcXdOckVk?=
 =?utf-8?B?WldIdTZtSUdzbkpURVhYUWtMWlpNdEp3b2hCU2lBRWIxSEJhNjFWc20vTkhK?=
 =?utf-8?B?ZlVnSUViSk9hK1p0Nk9neWxOSGIyeXVnUU9kbmpDeHp1SWdzaXhCaFAzKzNV?=
 =?utf-8?B?ZFRGR2liYnhIWWhOcnJsd2dQVnZaYWV4Q1Z2bk1oUDY1Vm1pb0pXb3M5L3Bq?=
 =?utf-8?B?TEwzWVNtajZhNER6d01nSG05TmdvNVRxN2dQNkVwZWlXSEd5eEJTNzZQSXZZ?=
 =?utf-8?B?S3gwZmw4NzNjd3FYZjM4ZG5XUzNKL0l2VU1GcTY1SUxCeExOc05NS0dqREdM?=
 =?utf-8?B?QjMveDFLUzF1RFdBVkMvMTVqeW95VFIzbi9aRkdYeGIxWGRDOTBKUWt5Ujc3?=
 =?utf-8?B?TXpZQlJFQ3UwektETWdxdko2R3Jvbi95V0J3STBxbHJhUHVTZy9QZnVlemRu?=
 =?utf-8?B?YTNYd2sxUlYrU00xVms4MW5WU1IwYzhNakNiQjdOMVVXRWVFQWFpRk93Z3JH?=
 =?utf-8?B?RkYvMlhwbDQyL08vMTlXeWlrQlVDKzBncXp6ck1aaEVCUGRWTzY2RkxYalR4?=
 =?utf-8?B?QjJ1NHhIb0lpaXE1bzVDSStWeWQ1QmFQQUZvekhiZGxUQVpldmF1ZHF4NlRo?=
 =?utf-8?Q?qzwwgoCKUfOZcdvU/V1GfSSqbR9/zooerN+l9paHj8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91a932d0-bd54-4b99-d34d-08da02057e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 19:46:24.4406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5U/RbruWsxALqYNXPd0QME7n0bE9KJB0LNHEc0kjB9TLGPgnZFnhCmyNOk3S4S9SAoXucnWj2x9sbioNiNzsBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR18MB4817
X-Proofpoint-GUID: gNE33gEUoWMM26rdankAr4IV8ej9CZcX
X-Proofpoint-ORIG-GUID: gNE33gEUoWMM26rdankAr4IV8ej9CZcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_07,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9y
dmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAxMCwg
MjAyMiAxMjo1NSBBTQ0KPiBUbzogTWFuaXNoIENob3ByYSA8bWFuaXNoY0BtYXJ2ZWxsLmNvbT4N
Cj4gQ2M6IFBhdWwgTWVuemVsIDxwbWVuemVsQG1vbGdlbi5tcGcuZGU+OyBrdWJhQGtlcm5lbC5v
cmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEFyaWVsIEVsaW9yIDxhZWxpb3JAbWFydmVs
bC5jb20+OyBBbG9rIFByYXNhZA0KPiA8cGFsb2tAbWFydmVsbC5jb20+OyBQcmFiaGFrYXIgS3Vz
aHdhaGEgPHBrdXNod2FoYUBtYXJ2ZWxsLmNvbT47DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1A
ZGF2ZW1sb2Z0Lm5ldD47IEdyZWcgS0gNCj4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsg
c3RhYmxlQHZnZXIua2VybmVsLm9yZzsNCj4gaXQrbmV0ZGV2QG1vbGdlbi5tcGcuZGU7IHJlZ3Jl
c3Npb25zQGxpc3RzLmxpbnV4LmRldg0KPiBTdWJqZWN0OiBSZTogW0VYVF0gUmU6IFtQQVRDSCB2
MiBuZXQtbmV4dCAxLzJdIGJueDJ4OiBVdGlsaXplIGZpcm13YXJlDQo+IDcuMTMuMjEuMA0KPiAN
Cj4gT24gV2VkLCBNYXIgOSwgMjAyMiBhdCAxMToyMiBBTSBNYW5pc2ggQ2hvcHJhIDxtYW5pc2hj
QG1hcnZlbGwuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IFRoaXMgbW92ZSB3YXMgaW50ZW50aW9u
YWwsIGFzIGZvbGxvdyB1cCBkcml2ZXIgZmxvdw0KPiA+IFtibngyeF9jb21wYXJlX2Z3X3Zlcigp
XSBuZWVkcyB0byBrbm93IHdoaWNoIGV4YWN0IEZXIHZlcnNpb24gKG5ld2VyDQo+ID4gb3Igb2xk
ZXIgZncgdmVyc2lvbiB3aGljaCB3aWxsIGJlIGRlY2lkZWQgYXQgcnVuIHRpbWUgbm93KSB0aGUg
ZnVuY3Rpb24gaXMNCj4gc3VwcG9zZWQgdG8gYmUgcnVuIHdpdGggaW4gb3JkZXIgdG8gY29tcGFy
ZSBhZ2FpbnN0IGFscmVhZHkgbG9hZGVkIEZXIG9uDQo+IHRoZSBhZGFwdGVyIHRvIGRlY2lkZSBv
biBmdW5jdGlvbiBwcm9iZS9pbml0IGZhaWx1cmUgKGFzIG9wcG9zZWQgdG8gZWFybGllcg0KPiB3
aGVyZSBkcml2ZXIgd2FzIGFsd2F5cyBzdGljayB0byB0aGUgb25lIHNwZWNpZmljL2ZpeGVkIGZp
cm13YXJlIHZlcnNpb24pLiBTbw0KPiBmb3IgdGhhdCByZWFzb24gSSBjaG9zZSB0aGUgcmlnaHQg
cGxhY2UgdG8gaW52b2tlIHRoZSBibngyeF9pbml0X2Zpcm13YXJlKCkNCj4gZHVyaW5nIHRoZSBw
cm9iZSBlYXJseSBpbnN0ZWFkIG9mIGxhdGVyIHN0YWdlLg0KPiANCj4gLi4gYnV0IHNpbmNlIHRo
YXQgZnVuZGFtZW50YWxseSBET0VTIE5PVCBXT1JLLCB3ZSdsbCBjbGVhcmx5IGhhdmUgdG8gcmV2
ZXJ0DQo+IHRoYXQgY2hhbmdlLg0KPiANCj4gRmlybXdhcmUgbG9hZGluZyBjYW5ub3QgaGFwcGVu
IGVhcmx5IGluIGJvb3QuIEVuZCBvZiBzdG9yeS4gWW91IG5lZWQgdG8gZGVsYXkNCj4gZmlybXdh
cmUgbG9hZGluZyB1bnRpbCB0aGUgZGV2aWNlIGlzIGFjdHVhbGx5IG9wZW5lZC4NCj4gDQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIExpbnVzDQoNCkhlbGxvIExpbnVzLA0KDQpU
aGlzIGhhcyBub3QgY2hhbmdlZCBhbnl0aGluZyBmdW5jdGlvbmFsbHkgZnJvbSBkcml2ZXIvZGV2
aWNlIHBlcnNwZWN0aXZlLCBGVyBpcyBzdGlsbCBiZWluZyBsb2FkZWQgb25seSB3aGVuIGRldmlj
ZSBpcyBvcGVuZWQuDQpibngyeF9pbml0X2Zpcm13YXJlKCkgW0kgZ3Vlc3MsIHBlcmhhcHMgdGhl
IG5hbWUgaXMgbWlzbGVhZGluZ10ganVzdCByZXF1ZXN0X2Zpcm13YXJlKCkgdG8gcHJlcGFyZSB0
aGUgbWV0YWRhdGEgdG8gYmUgdXNlZCB3aGVuIGRldmljZSB3aWxsIGJlIG9wZW5lZC4NCg0KVGhh
bmtzLA0KTWFuaXNoDQoNCg0KDQoNCg0KDQoNCg0KDQoNCg==
