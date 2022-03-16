Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E246C4DBA7C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 23:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358212AbiCPWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358272AbiCPWEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 18:04:47 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A672324581
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 15:03:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22GIohKc027671;
        Wed, 16 Mar 2022 15:03:21 -0700
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2049.outbound.protection.outlook.com [104.47.74.49])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3eue23k72a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 15:03:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YKUBP8Aapcw5SfAQkism8A3sBaKOUWXVkqQz2kmB3huoJyUH05YIWX+YrHlIcu+UHAOPZkAk2HxfRbr3tVoODEtzXV3B9RNN8da/kfH/J/yLlPuTmG2MVnrEqKE7Jys+t4NtK07vD+JQ5mfKoYqALCQhQWCvk9MgWqmZCu6yCnDoL8k1FVf5FabPuLKcegO2luSVyg1JqyHYR4NDUmyqkbiCwO7Nrg5V2J1lC4BmvH/6JkVNIlRXxxhCWYSwv/AXBrVDJ0J+Hq7tFwIrOy5MC/PV3XsnxsOcUxzelMWbbpqeUBBBZ1ZGqROySvI2EIh5tSqpyjTRIsQkrTL54NRaoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yw8hIrLXvekXi+rc4SI10/ugY+zapQ/QRkx1Mc38s18=;
 b=Dj8c9KGu0M4NTw1qVBMN15gWGlCxr/ol/LdZPQV3Zir4R1PqAmyPmNVB3g67CZYmOZqjW3JpAFSsPCClVudaYIqzyp85yZBMj/FGGk9FJn+WNjcyI6GpCNk4V5NtJq2PH23BUWnThxHpEhzjakwphZjqw1FINTz+SZzraH08p4GWIMwMMn0+upGrFgY/Dt9vl10vTn/6wzvq4AwDAOr9gFx5GHf131ptDaoM9oJRX8sZ4rMRpGrtZVromwf8XlHf4PIHS+g767rFQTVYG7KyEy5k3H0JL3fLbfl3jUDZWHCxUlCFxPagx13sDJEOUyb5FpdCE39RjdbGRY2bxoI8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yw8hIrLXvekXi+rc4SI10/ugY+zapQ/QRkx1Mc38s18=;
 b=Eq0hHXaSva48sYacbnmox21OdJ9Np5gDBCS3BDzkPKhscUYZcSC3vFNDF43U2tr3MK5oghEJnsZmMEoh4LoctKI0+ci/IMeP83UdpKkjxfOSdTgvtH33ZEuuX+WZXSzXIsIw60vKSzKUkhtsHPSn5ITk3MgRqHcJVp9DkSiv678=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by BN8PR18MB3076.namprd18.prod.outlook.com (2603:10b6:408:73::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.29; Wed, 16 Mar
 2022 22:03:18 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::4ca0:dcd4:3a6:fde9%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 22:03:18 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     Donald Buczek <buczek@molgen.mpg.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "it+netdev@molgen.mpg.de" <it+netdev@molgen.mpg.de>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: RE: [EXT] bnx2x: How to log the firmware version? (was: [RFC net]
 bnx2x: fix built-in kernel driver load failure)
Thread-Topic: [EXT] bnx2x: How to log the firmware version? (was: [RFC net]
 bnx2x: fix built-in kernel driver load failure)
Thread-Index: AQHYOXWDGtwJdUwtm0SzKIZYpl1Q06zCjRyg
Date:   Wed, 16 Mar 2022 22:03:18 +0000
Message-ID: <BY3PR18MB46126FF9D9C3F244D6EFB898AB119@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20220316111842.28628-1-manishc@marvell.com>
 <5f136c0c-2e16-d176-3d4a-caed6c3420a7@molgen.mpg.de>
 <BY3PR18MB4612DEDE441A89EEE0470850AB119@BY3PR18MB4612.namprd18.prod.outlook.com>
 <cb7d704a-60bd-a06f-6511-95889bc0bc5f@molgen.mpg.de>
In-Reply-To: <cb7d704a-60bd-a06f-6511-95889bc0bc5f@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfad3ada-d37f-4f2d-813b-08da0798c734
x-ms-traffictypediagnostic: BN8PR18MB3076:EE_
x-microsoft-antispam-prvs: <BN8PR18MB307665960B0C31BB67A9EFEDAB119@BN8PR18MB3076.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /QKsVF+8uZZsx97ZVoIOa/XMIxNCS+jZcy7fJl7mNfta2R0FiyQ3F8ul6lqCIWO/JS+w4qcPHReDVbdk4KYDIEtzsuypNT4OgWzePsgeBK2h3pk6ReY3ua/vVUSmlm5UIuQVQrzpPqPTOcMKOtCCUjwkLJViUbt6th7XQ7tmqb//FVAMK9sZZbwiaaF9cb8vgX6oUXm7leDVgBVxS2ns/lZqXiLkLJjlfy1miLOnDSsDS5mGI3hB72hTvNN0FzApI0Of1VjNjm3+o9+ZWhhK+qylYX2a4Vw4lVBKrHQZcTw2kzao+Se4Mb4RF/J401eJ3SPfTyfiBMLKlMsnQ1j309193Dy2Tnc9btKx8GA9MGHxYSI/Ib+WB2x5u2GGkmJYULYRe3KUlba8bXZEr6jPVCjTXWp4uw6tLT9ck6E498HswfaQw8wrYwVcyHuiBOEyr/xUUMaVu5pn5eiTtPei02vVbs54dD6/j7d4r6eTfm0jWgRuRud2mHavu9r8sJtV/F6WqBc0B6TW7nTA5VbpYdLodA+o6WSTxtBBKF5Xmqi1+8Cv748TxyBe6KWNhgSPtwIoTLY8JAThJZslbtvcDbBYQI7o0bRBgJ9DE8Xri0F/33uovG8S4qQaIv8jKxiqMapIWkmOIO+3dMgd0D2HruDRcMCEmVn0PAnL1Qzc1Sx8Zot6uN5WctH3Gj8Uymjg3Iq8F9/EpueUaoAabgKWoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(83380400001)(38070700005)(2906002)(55016003)(5660300002)(52536014)(33656002)(8936002)(54906003)(76116006)(316002)(4326008)(64756008)(8676002)(66946007)(66556008)(66476007)(66446008)(86362001)(7696005)(53546011)(6506007)(9686003)(38100700002)(122000001)(71200400001)(508600001)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NCsyYjhpMHVrV0Z5QUVLMmNaNHBQREwwaWk0OHJuSDN4TmlTMnlucGtlYjR6?=
 =?utf-8?B?VFJNckYzWTNKV1hTN2NvUjZXWE1GRDZRTmYxb1krYlpMY2J6d3U2dlZJZnd4?=
 =?utf-8?B?NHV6L3V5ejlvZURFWFFISzdIRURYVGdqbXpNdlR2N2hPZjV2cTNYZk9wU2hy?=
 =?utf-8?B?dHVUaEtEK25mV3lJNXlqazdIYW1QMHBHRVErMzFvcnhZS3JZRXF3dm1EbVEz?=
 =?utf-8?B?cWtOd1B2cDg2aHh1bWNmVUVOQjRoMytWQjVqQzhxaUZrWGl1eDQ3WWV1cVVp?=
 =?utf-8?B?VElCUXNwS3RHL2VvOE1qVGw1MTBnUSs4VlphMFR3TUFWSXR1S1d1ZzYxYUF0?=
 =?utf-8?B?MTMwNm5hYUtjVHFDUUltbXFyU1N3c2owQVNubmpNcGdLeFFKT1Nma2xRU29R?=
 =?utf-8?B?b3Nkd1VKV0dkY0FJOFVkcUd4TDBOYWhubnZzRWRnK1RvK2k5MFRiSGIxdXVl?=
 =?utf-8?B?Q0U5NGlwQlZTR0R5Vk1zZGpmTzZyVmI1L3FBb2RydXpTVTY5VGNxdk9VbkZi?=
 =?utf-8?B?VEZyZ2xQUDZwSzgxSWUxOHIrM1JMKzJITkM0TmhoTHRQd3Q1Y1o2Y2NQS0tQ?=
 =?utf-8?B?cHhTZ2V1eUQ4dEVWSkNKVzFVOHZLbEdqdGNram03VmoyKzQxL0JPcndDR04r?=
 =?utf-8?B?YWN5ZWtKSGRWRU1YWDFXeUZTbEs4ZFU4dHZ5ZWs2RGdYSWc5dExrQXBqYVlX?=
 =?utf-8?B?TEhMUU5pOWV4ZFplTWhsSEw4MU9FaVQyK2VRaTVQdmZsVGw2dWl0OTNTMEZS?=
 =?utf-8?B?ejAxUGlzYWhGYmE5RGtENzVZQ0JFRWp3TmR2aThzakd1U2J0WWVGOVY0UTJ3?=
 =?utf-8?B?QmZxNFczRGVZdkxCVXVsaEE2ZEovTkszMkJmYXJDMDBBZzJ4QzVkSEZLbEZW?=
 =?utf-8?B?a1ZmU0Zja0ZRR3diRFR5L3FidnRCaytxKzd4ZWE3MHEvR0c5bCtyNkZJc2xI?=
 =?utf-8?B?ZHN0SXF1UUlFNU03WSt5M1JreDR2TW0yQnF2VlNNRE9OeVZqU29XMFJ4cDkr?=
 =?utf-8?B?NzJWc1d3Z25zVXpWbnBsL3h0anAwV2NraG5FYndhQ3JJSHdqS2JyZnFpQUlR?=
 =?utf-8?B?QzcyWmdiZWpza29NSHNweDFlcktSMWs0SjF6bGptcVFKb25zM3RPQUQ0NVh2?=
 =?utf-8?B?UDQ1UldJZlJXT3NHQ3lNcXc1UkIrYWdOV3d4KzdWcEpDaFVHdSs4TkZiVm1s?=
 =?utf-8?B?R3J1U292VDcyQ05iL005aUhkOU1JQ1FrZTdVeFFGclU0VjEzbTM3NXpBZkhL?=
 =?utf-8?B?akZnbUxwakFURWZwd0VWTktabno0NURPNG9hRXlSNHN6MG1qM1dkenlPUGxR?=
 =?utf-8?B?QW9id2lBVDNjbVJjQlF1TnBmTmhGQVFBN3Q0YXBaVGZLbU1WL21TblQvQmhH?=
 =?utf-8?B?ZXROd3pvZlkwaHNxMmErMVpDMlgyMGM1ejQzZ0hZK3FSS3lKU0g2WWI3ajZY?=
 =?utf-8?B?ck1odXM3M0ZoYUFPa1hxcFBwczlha01yZWtQK0tvdFh6aVczMkdGbEZVdTJa?=
 =?utf-8?B?b2N0NUVOUGo5U09YZlhvZjdnTkVjMTlhYitMVmxYM2tKbkEyMThZWFk0cTNq?=
 =?utf-8?B?ZG1FLytjRUs1ZGgwNnFxMHFWOTJGKzdFb1lkQ1ZUN1IzT3hVYURJNmZpUERa?=
 =?utf-8?B?ZHlqc21UU0VWWTVmYXA3UjYzdStqd2Y3dElIWjBYb0ttdjNlUTZ1QzNuNW1Z?=
 =?utf-8?B?OHFtRGM1NzAyNSs3SWJETVczVlNpZThRRERlRzYycHBjL3d3ejh3d2FudEh2?=
 =?utf-8?B?YWJyb3lPbk9UaDhrV2pwOEVFTUlVMDUxSzZDcnZ0TVMyR09ETFdsaW5Ra3c4?=
 =?utf-8?B?K25veUh6Z2pCdlZzeC9ZUm1MaFB0VjdKL2RRUm9aY2JTaVZhSXFXMW8wLzZv?=
 =?utf-8?B?S1VMYzk3SHF2MS93MHBlTWh0SVRRUEZYNWJ6QnV2S0NpcHF3R2xKRXlBQTlL?=
 =?utf-8?B?VDdRbmlQRWdFa21OcDRXcGdPQ3FiWktMVklMeWFjdGhUZk1Bby9VMTJQZHgw?=
 =?utf-8?B?RWprSSt4aFViUTdFOGZqWWVUZU9aaVpZS1FsOXRDRWNpMEljc1VrcnJ0czkx?=
 =?utf-8?Q?vroylQ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfad3ada-d37f-4f2d-813b-08da0798c734
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 22:03:18.3783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PfDLuXC1SrL6tyTJqoIZAYi3q9PeftyvED3DGUbZdy2YBGaaBVxuWOOQf1Lj8Pj529HIkIj1vqWDyWe0hCZl6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB3076
X-Proofpoint-GUID: OG7favD-sSbroljNYzADtzyv-2Ttc63O
X-Proofpoint-ORIG-GUID: OG7favD-sSbroljNYzADtzyv-2Ttc63O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_09,2022-03-15_01,2022-02-23_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYXVsIE1lbnplbCA8cG1lbnpl
bEBtb2xnZW4ubXBnLmRlPg0KPiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMTcsIDIwMjIgMjowNiBB
TQ0KPiBUbzogTWFuaXNoIENob3ByYSA8bWFuaXNoY0BtYXJ2ZWxsLmNvbT4NCj4gQ2M6IERvbmFs
ZCBCdWN6ZWsgPGJ1Y3pla0Btb2xnZW4ubXBnLmRlPjsgSmFrdWIgS2ljaW5za2kNCj4gPGt1YmFA
a2VybmVsLm9yZz47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IEFyaWVsIEVsaW9yDQo+IDxhZWxp
b3JAbWFydmVsbC5jb20+OyBpdCtuZXRkZXZAbW9sZ2VuLm1wZy5kZTsNCj4gcmVncmVzc2lvbnNA
bGlzdHMubGludXguZGV2DQo+IFN1YmplY3Q6IFtFWFRdIGJueDJ4OiBIb3cgdG8gbG9nIHRoZSBm
aXJtd2FyZSB2ZXJzaW9uPyAod2FzOiBbUkZDIG5ldF0gYm54Mng6DQo+IGZpeCBidWlsdC1pbiBr
ZXJuZWwgZHJpdmVyIGxvYWQgZmFpbHVyZSkNCj4gDQo+IEV4dGVybmFsIEVtYWlsDQo+IA0KPiAt
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+IERlYXIgTWFuaXNoLA0KPiANCj4gDQo+IFRoYW5rIHlvdSBmb3IgeW91
ciBhbnN3ZXIuDQo+IA0KPiBBbSAxNi4wMy4yMiB1bSAxOToyNSBzY2hyaWViIE1hbmlzaCBDaG9w
cmE6DQo+IA0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBQYXVs
IE1lbnplbCA8cG1lbnplbEBtb2xnZW4ubXBnLmRlPg0KPiANCj4gW+KApl0NCj4gDQo+ID4+IEht
bSwgd2l0aCBgQ09ORklHX0JOWDJYPXlgIGFuZCBgYm54MnguZGVidWc9MHgwMTAwMDAwYCwgYnJp
bmdpbmcgdXANCj4gPj4gbmV0MDUgKC4xKSBhbmQgdGhlbiBuZXQwNCAoLjApLCBJIG9ubHkgc2Vl
Og0KPiA+Pg0KPiA+PiAgICAgICBbIDMzMzMuODgzNjk3XSBibngyeDogW2JueDJ4X2NvbXBhcmVf
ZndfdmVyOjIzNzgobmV0MDQpXWxvYWRlZA0KPiA+PiBmdyBmMGQwNyBtYWpvciA3IG1pbm9yIGQg
cmV2IGYgZW5nIDANCj4gPg0KPiA+IEkgdGhpbmsgdGhpcyBwcmludCBpcyBub3QgZ29vZCBwcm9i
YWJseSAgKHRoYXQncyB3aHkgaXQgaXMgZGVmYXVsdA0KPiA+IGRpc2FibGVkKSwgaXTigJlzIG5v
dCByZWFsbHkgdGhlIGZpcm13YXJlIGRyaXZlciBpcyBzdXBwb3NlZCB0byB3b3JrDQo+ID4gd2l0
aCAoaXQgaXMgc29tZXRoaW5nIHdoaWNoIHdhcyBhbHJlYWR5IGxvYWRlZCBieSBhbnkgb3RoZXIg
UEYNCj4gPiBzb21ld2hlcmUgb3Igc29tZSByZXNpZHVlIGZyb20gZWFybGllciBsb2FkcyksDQo+
IFN0aWxsIGludGVyZXN0aW5nLCB3aGVuIGhhbmRsaW5nIGZpcm13YXJlIGZpbGVzLCBhbmQgdHJ5
aW5nIHRvIHdyYXAgb25lcyBoZWFkDQo+IGFyb3VuZCB0aGUgZGlmZmVyZW50IHZlcnNpb25zIGZs
eWluZyBhcm91bmQuDQo+IA0KPiA+IGRyaXZlciBpcyBhbHdheXMgZ29pbmcgdG8gd29yayB3aXRo
IHRoZSBmaXJtd2FyZSBpdCBnZXRzIGZyb20NCj4gPiByZXF1ZXN0X2Zpcm13YXJlKCkuIEkgc3Vn
Z2VzdCB5b3UgdG8gZW5hYmxlIGJlbG93IHByaW50cyB0byBrbm93IGFib3V0DQo+ID4gd2hpY2gg
RlcgZHJpdmVyIGlzIGdvaW5nIHRvIHdvcmsgd2l0aC4gUGVyaGFwcywgSSB3aWxsIGVuYWJsZSBi
ZWxvdw0KPiA+IGRlZmF1bHQuDQo+ID4NCj4gPiAgICAgICAgICBCTlgyWF9ERVZfSU5GTygiTG9h
ZGluZyAlc1xuIiwgZndfZmlsZV9uYW1lKTsNCj4gPg0KPiA+ICAgICAgICAgIHJjID0gcmVxdWVz
dF9maXJtd2FyZSgmYnAtPmZpcm13YXJlLCBmd19maWxlX25hbWUsICZicC0+cGRldi0NCj4gPmRl
dik7DQo+ID4gICAgICAgICAgaWYgKHJjKSB7DQo+ID4gICAgICAgICAgICAgICAgICBCTlgyWF9E
RVZfSU5GTygiVHJ5aW5nIHRvIGxvYWQgb2xkZXIgZncgJXNcbiIsDQo+ID4gZndfZmlsZV9uYW1l
X3YxNSk7DQo+IA0KPiBJbmRlZWQsIGFmdGVyIGZpZ3VyaW5nIG91dCB0byBlbmFibGUgYEJOWDJY
X0RFVl9JTkZPKClgIGJ5IHRoZSBwcm9iZSBmbGFnIDB4Mg0KPiDigJMgc28gZWl0aGVyIGBibngy
eC5kZWJ1Zz0weDJgIG9yIGBldGh0b29sIC1zIG5ldDA0IG1zZ2x2bCAweDJgLCBMaW51eCBsb2dz
Og0KPiANCj4gICAgICAkIGRtZXNnIC0tbGV2ZWw9aW5mbyB8IGdyZXAgYm54MnggfCB0YWlsIC04
DQo+ICAgICAgWyAgMjQyLjk4NzA5MV0gYm54MnggMDAwMDo0NTowMC4xOiBmd19zZXEgMHgwMDAw
MDAzYg0KPiAgICAgIFsgIDI0Mi45OTQxNDRdIGJueDJ4IDAwMDA6NDU6MDAuMTogZHJ2X3B1bHNl
IDB4NjQwNA0KPiAgICAgIFsgIDI0My4wMzgyMzldIGJueDJ4IDAwMDA6NDU6MDAuMTogTG9hZGlu
ZyBibngyeC9ibngyeC1lMWgtNy4xMy4yMS4wLmZ3DQo+ICAgICAgWyAgMjQzLjM1NjI4NF0gYm54
MnggMDAwMDo0NTowMC4xIG5ldDA1OiB1c2luZyBNU0ktWCAgSVJRczogc3AgNTcgZnBbMF0gNTkN
Cj4gLi4uIGZwWzddIDY2DQo+ICAgICAgWyAgNTcxLjc3NDA2MV0gYm54MnggMDAwMDo0NTowMC4w
OiBmd19zZXEgMHgwMDAwMDAzYg0KPiAgICAgIFsgIDU3MS43ODEwNjldIGJueDJ4IDAwMDA6NDU6
MDAuMDogZHJ2X3B1bHNlIDB4MjE0OQ0KPiAgICAgIFsgIDU3MS43OTk5NjNdIGJueDJ4IDAwMDA6
NDU6MDAuMDogTG9hZGluZyBibngyeC9ibngyeC1lMWgtNy4xMy4yMS4wLmZ3DQo+ICAgICAgWyAg
NTcxLjgxMTY1N10gYm54MnggMDAwMDo0NTowMC4wIG5ldDA0OiB1c2luZyBNU0ktWCAgSVJRczog
c3AgNDYgZnBbMF0gNDgNCj4gLi4uIGZwWzddIDU1DQo+ICAgICAgJCBkbWVzZyAtLWxldmVsPWVy
ciB8IGdyZXAgYm54MngNCj4gICAgICBbICA1NzEuOTc5NjIxXSBibngyeCAwMDAwOjQ1OjAwLjAg
bmV0MDQ6IFdhcm5pbmc6IFVucXVhbGlmaWVkIFNGUCsNCj4gbW9kdWxlIGRldGVjdGVkLCBQb3J0
IDAgZnJvbSBJbnRlbCBDb3JwICAgICAgIHBhcnQgbnVtYmVyIEFGQlItNzAzU0RaLUlOMg0KPiAN
Cj4gTWF5YmUgdGhlIGZpcm13YXJlIHZlcnNpb24gY291bGQgYmUgYWRkZWQgdG8gdGhlIGxpbmUg
d2l0aCB0aGUgTVNJLVggYW5kDQo+IElSUSBpbmZvLiBNYXliZSBhbHNvIHRoZSBvbGQgdmVyc2lv
biBvbiB0aGUgZGV2aWNlLCB3aGljaCBgZXRodG9vbCAtaSBuZXQwNGANCj4gc2hvd3MuDQo+IA0K
PiAgICAgICQgZXRodG9vbCAtaSBuZXQwNCB8IGdyZXAgZmlybXdhcmUNCj4gICAgICBmaXJtd2Fy
ZS12ZXJzaW9uOiA3LjguMTYgYmMgNi4yLjI2IHBoeSBhYTAuNDA2DQo+IA0KPiBObyBpZGVhLCB3
aHkgZXRodG9vbCBkb2VzIG5vdCBzaG93IHRoZSBsb2FkZWQgZmlybXdhcmUuDQoNCnRoYW5rcyBQ
YXVsIGZvciB5b3VyIHF1ZXN0aW9ucy9zdWdnZXN0aW9ucyBhbmQgc3BlY2lhbGx5IHZlcmlmaWNh
dGlvbiBvZiB0aGUgZml4Lg0KSSB3b3VsZCBwcmVmZXIgdG8gZW5hYmxlL2FkanVzdCBvciBhZGQg
YW55IG5ldyBsb2dzIGluIGEgc2VwYXJhdGUgY29tbWl0IChqdXN0IG5vdCB0byBhZGQgbWFueSB0
aGluZ3MgaW4gc2FtZSBjb21taXQpDQpUaGUgdmVyc2lvbiB5b3Ugc2VlIGluIGV0aHRvb2wgaXMg
YWN0dWFsbHkgYSBkaWZmZXJlbnQgZmlybXdhcmUgY2FsbGVkIGFzIG1hbmFnZW1lbnQgZmlybXdh
cmUgKE1GVykgcnVubmluZyBvbiB0aGUgZGV2aWNlLg0KTWF5IGJlIHdlIGNhbiBjaGVjayB0aGUg
ZmVhc2liaWxpdHkgb2YgcmVwb3J0aW5nIGJvdGggdGhlIEZXIHZlcnNpb25zIChNRlcgYW5kIEZX
IGZpbGUgdmVyc2lvbiBvbiB0aGUgaG9zdCkgaW4gZXRodG9vbC4NCk9yIHBlcmhhcHMgTUZXIGlu
IHN5c3RlbSBsb2cgYW5kIEZXIGZpbGUgdmVyc2lvbiBpbiBldGh0b29sLg0KDQpUaGFua3MuDQoN
Cg==
