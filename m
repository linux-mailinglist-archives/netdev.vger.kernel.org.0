Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6ED74F911A
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 10:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbiDHIt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 04:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiDHItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 04:49:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D56432B325
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 01:47:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ1lMgFkKXyqHpWZ9Vo682NGxijq7MMF5Lu4pH6242FHgwPitre6y9XcnnJhAANricG+Z773xJRUDb2Xxb3TzdZ8xusrh1unS8tR7as8YO2CbIW+Q5emBQ8ZkaXZ24BzKLm717wMFZlp1IyV0FNT/8fPo80t1BgGABHhwzShUZ/FjzTIDd3WL+7e0xm74R7kYb9vK7UmR63ClYYUKNtyYPJ5rxNM4NcBqe35buI9U/bURgrwwF4fObYorE8lNf84rGEgYaNUll4Yyaud2EtlPBE5EIMHQ0sPEfJRdq3ME6pyStvPqYvXtTL/a6Vn85oiJhYaeSw9ASOV/MZ3J1lbLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vCcikQR/SSzlJ2CRQ35scaZ7DcC7fmmUv/j+BErhdpk=;
 b=CHkej4TVzzisfjlikFfRREiU2eqvZFljDv19Qo/jn0DM7hYmnLjuytVJOVCTTOx8k8SUQmtJzuvT821Pr9rAxndPf6Fu+qwFF9Zh5DoYBtMJGB/7aBlnb3w/q9+Fr8ji5cqGpwtxKSbeGEdZM/iA9Zv4S16t4og2qSSkR1nEMj+EuUfo5cmaccIhLjB06V2Y446pSZg3CszpY+grtXj5MSIgPhKWRSKDwA8+Nr5flaHVMejAzTxPh4LAMBEiYm+Ixu+7hF2JjbSXChmEZ8KrxE83Yt76Zd48jP1VWkW/Bd9X7EwYJDuICvgFApZLispyKHBmuixLyLF5aifZriniwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCcikQR/SSzlJ2CRQ35scaZ7DcC7fmmUv/j+BErhdpk=;
 b=sCoEezdVu6nx2FdpWBB8gYMXdSJL4F3RJdrGsMRb2T3UylRUD70Ulox2iimsnNF0d9dSAksbm0tfSRiHU6uuVTmGmeuwrKykGIJgSLrOWgj95jUgDgPmKKcyMJgoGaIcGH/wpTKH7L/3khiBQz7lxtv99IZVDKnKRM3tIcNF+jc=
Received: from BL3PR02MB8187.namprd02.prod.outlook.com (2603:10b6:208:33a::24)
 by BYAPR02MB4695.namprd02.prod.outlook.com (2603:10b6:a03:52::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 08:47:12 +0000
Received: from BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::2995:51b8:59a9:52fc]) by BL3PR02MB8187.namprd02.prod.outlook.com
 ([fe80::2995:51b8:59a9:52fc%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 08:47:12 +0000
From:   Harini Katakam <harinik@xilinx.com>
To:     "Claudiu.Beznea@microchip.com" <Claudiu.Beznea@microchip.com>,
        "tomas.melin@vaisala.com" <tomas.melin@vaisala.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Nicolas.Ferre@microchip.com" <Nicolas.Ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Shubhrajyoti Datta <shubhraj@xilinx.com>,
        Michal Simek <michals@xilinx.com>,
        "pthombar@cadence.com" <pthombar@cadence.com>,
        "mparab@cadence.com" <mparab@cadence.com>,
        "rafalo@cadence.com" <rafalo@cadence.com>
Subject: RE: [PATCH v2] net: macb: Restart tx only if queue pointer is lagging
Thread-Topic: [PATCH v2] net: macb: Restart tx only if queue pointer is
 lagging
Thread-Index: AQHYSxw1ebe96eaU50Otacnv9gLy/qzlrhug
Date:   Fri, 8 Apr 2022 08:47:12 +0000
Message-ID: <BL3PR02MB818774AF335BBB8542F22072C9E99@BL3PR02MB8187.namprd02.prod.outlook.com>
References: <20220407161659.14532-1-tomas.melin@vaisala.com>
 <8c7ef616-5401-c7c1-1e43-dc7f256eae91@microchip.com>
In-Reply-To: <8c7ef616-5401-c7c1-1e43-dc7f256eae91@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd9bd33d-de3b-4998-05a6-08da193c5ff8
x-ms-traffictypediagnostic: BYAPR02MB4695:EE_
x-microsoft-antispam-prvs: <BYAPR02MB4695E9125EE6758BA41E60AFC9E99@BYAPR02MB4695.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mu9m7xkUrwHGKl71nuVs3ZsDz4a4Wj13O4VZHKCy6K01Wr7EC86BLsgMSOdtuE95gWXRYbQLec8HJFDqqkksSr+7sucb/+KkU/cSGOdjnvqY0QHGMz5ANcMzA9dgwYSQ2E54/d8iqYeLDLzhWLf8C14SPZKBJY6M6Y0yXanist0ev7JUjet0VCtkbL2SIPZLOquwtHgLnjnmo5o0ap3Afp9c2NVnb10cRMeUiUJs0gx9XnOd8AK23XL2ABCOvOQi1vRaG8zSbo/AJx1qxzljNKoUSTDCLPFAnls6Y5NWdQdN1aUk39yEg0bl+4wn4xM87OHwFMKM6WwPYQURJ+1LHBmpOMM+q5KhvrQ2Dkp5fEVUby09w1X9HN8ZwtdW5BDUpoBpYOF6Nq4kavEBCRMGumGMhIkEN5mzeTTPTDsTxFGZtklhObb8v7fMr01S5hhdPDikj1emLnj7LgYNUw22/VBs/QAoM732dCOzoOlYrTEDCMHYP5VFFmn7jnA2uUkYxZ6j5XRPzmbdWT1w95UBgsxdQyQ1nsVYg0uWCC9V7nyfsBYpCaESdvOHm16iYAn6hhkN7BmW/iaEvyXF2SMm2bwCCtT50M3YqG652kCB4TLa/38NPXOuDGGNI6rCgvm99GU6/tUocx14B4oBEgpFxhNKdmBUPSFfjQ3gRzqbKu958L62wtW33CiZx05NYG7TllPT4pp8rlSQE7qHlMsUdM+zmJRF7RBTNMpUe1RlLq8kvx1xsPvHGj4EUNAPEWUjqnLiGDO0+0lxIp+3Y/BKwraCJbRl5E7GNOl2cvgApZg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR02MB8187.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(66946007)(52536014)(316002)(110136005)(8936002)(7696005)(33656002)(86362001)(508600001)(71200400001)(54906003)(4326008)(8676002)(76116006)(66446008)(64756008)(66476007)(55016003)(66556008)(966005)(186003)(26005)(53546011)(9686003)(83380400001)(6506007)(5660300002)(38100700002)(122000001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHdjWUsvVCs4QlhraGNIRUlCdTcwWjQ1Sk9zcXVzM25Zd2p4K0lUem01VGI5?=
 =?utf-8?B?TS81NGJhc2hjbHpJOC9XdC9rSGZUb1R6OS9KdzFSa1Y0NEQ0bDM2NmJ1QkVT?=
 =?utf-8?B?TzhoUko5RzJXTW1vZDBNeUM4d0xXV1RYQnloSm1VRThVdFFSSFQxWjNrNmpL?=
 =?utf-8?B?VjliclpVMVptR0V1a2tLTHRFRXpzT2ZkNU1wWTFDajd1R2U3bklUTTdZNXBi?=
 =?utf-8?B?dkdpNk5sUVpXaS9RM3FCeWhUNnF5SHdSR2FaR0Y0SE40Y0NMdzdxeGRiM09Q?=
 =?utf-8?B?OHBuR2FkaFozUVJtb21FY3JJanBzMGtxeFpRN29mZDZRQUlUanFNdFBKQmRT?=
 =?utf-8?B?elVLdEdmZ1M5RGM4OUQydDBFNGhVTEtFbmprbU5xWU43MlRxbVJVOFFoVnhH?=
 =?utf-8?B?UVNBaXZvREE4NzlnVkpKbHVKV1NFZ1Y2UFcwSGZWK0xtSkR5OVlVa0hJMzBT?=
 =?utf-8?B?ZkljVXdVMEtKNERXQnRNMUJqN2djS3RPcVQ3amlGVC9RbXhqTlloU2NNNFhs?=
 =?utf-8?B?QS9pVGNZSWF3RGxhaE56c3ZNN1JBNXNid3UydlF3cFN4Q2tCUXpTNDV0TEw2?=
 =?utf-8?B?eXNrSE5OWldaVndZRktQTDlNRzFhUVNOQXN2azRoM2xNWTlJcGhCbEpPSGZt?=
 =?utf-8?B?V0VYek04WUhJYVdKc1F3ai9GeVdmSW56TlBrWXZ3REZjNHozbHFKc2x4MXhG?=
 =?utf-8?B?ZUltcE9YMFFBb2VJL0NDcHBuUjB6c0hZcjc2OFNoNCtGV3k3ZlBlZnBlRTdT?=
 =?utf-8?B?d05XQ3l1Y0JXWUtFSlR3c0lQcHR1d1FjTE92dUlMY0RuSzdqRXRDL1hPK0E3?=
 =?utf-8?B?clRoVmZuK3VGaW9odWhqVmNlY1RDWWZQKzNuY2U5L0kwNWpvbzFxN1NYc205?=
 =?utf-8?B?YVpyZ3N5akFPS21waEdkbzdNUWo0Sk44clRjeXZvQmZ5MnE2SG5uTGJMMnd5?=
 =?utf-8?B?R1pmTysyckxSdHlYZ2JkT3VrOWxFUmZSK2RvbExBT2xGQTQ3dVBGMTlQdkk0?=
 =?utf-8?B?cTQyVmxMdzYwcnU4REk1QkJlQkdrZFNvN3Z4TlRGUWRRSXhodGhrUFBUWVo2?=
 =?utf-8?B?R1gwRXM0Z2ZRbVQ5UHkzZTlmekk1K3Juang3Skw5ZlhvNkVYMTVvVUlGa0Ey?=
 =?utf-8?B?Y1RNR1JMUFZuN0JEL0w4VjhMcGxlcjRIcTM1ZFVMNzRkcndyQklkWkxlK0lK?=
 =?utf-8?B?dCtqeXZ4czZDeXJiY3NXNVpVZnVuRFpZeUtlOFFxc09QR3JvSmttWWV5Ujht?=
 =?utf-8?B?WWRFaUZ2ZDRhWG1JMDc0cFNGR1g4T1ZWZ2o0ZzkyMkV4VE5ydkt4bzVtdUd6?=
 =?utf-8?B?S1Z5S0tiR0hJQjZnNEhtTUtvMDdLUy9kRzloVWhYZ3EyMlN0ejB4cmdYV0VU?=
 =?utf-8?B?Si9panlOdWVRNnU2TU5qNTBMSXFTT3ZXOVRUc0lFTlNQY29Vc0owYTh4Yy9E?=
 =?utf-8?B?SXhlNGtzSGRQQnhqU1pQSVlDbTRyajhrc1NWdGdVWE9HUHg0bXpSVXBZMTcz?=
 =?utf-8?B?MFdGS0QyQnJ1WTdqWS9NKzBiR2M0RHdoVVRxTDdzSXFJakIySnhWWFBiYVV6?=
 =?utf-8?B?QmMybjR6NjlnaDRVUXlwQVlsclJ3MkdFRzNBNWwwZ2pGOXB4cTMrcUUvSGVO?=
 =?utf-8?B?V2RyOVZJUzkxb1llbnhTb3E0Nm5QYVR1cHRJQmlmZjhabVhqYVpYOEdESmZa?=
 =?utf-8?B?eEh5ZkZnQUtzY3ZoUXdjMHdNcldxWnFNbjhBTGYyK1g5bWxieHdTNkFOZndG?=
 =?utf-8?B?THc3ZVJMUEhkYitxVGJFbHdrY290SnYzWU84eXp4N01GMTNiejFxOUtydzBz?=
 =?utf-8?B?LzJLWkRGdDZqZ0U0WjVQZFBrK1JkSEE1NkdBQUE2SnVkZ0VkU1YwVkdlVFBH?=
 =?utf-8?B?QUZPYS9pWnpNS205bndvUmhXM0UzTER3eG12MnpUSkd3aGw3Q2hPeGJ0YVRV?=
 =?utf-8?B?SERuY3B1SVR4ajJ5Z2JqdHdxSmRzbUNIMmYyZWx3bmt3U05PVmtNNEFnNlRU?=
 =?utf-8?B?SUt2R0hlWXphMkxtVE9BTEhyTHNrNDZsYkZVZ3ZETnNNYk1hWC9ZOEJKaVkx?=
 =?utf-8?B?dENhQnhvb2ZvN0RTcWdKdjNKQ2h4bUFXSUVIS3d5V1Z4T2dkd0ZuNTJWMFl0?=
 =?utf-8?B?SWFHY01RT3NFMFEzRHpoNU9ZejdBRWFqRzlJTVZtaGtOUC91VVpBZnA0cW96?=
 =?utf-8?B?OXJUTDFNNzZLWVR4QU9ZZUxUNlEycGpFMktVRXdlVFJ0dDB5dEMydGlkaWZ3?=
 =?utf-8?B?SE5YZnVkc1c3dm5lQTRFUzZZdTNmdjk1NFh2d3JzMTExNGRwR0kxaWFKNExn?=
 =?utf-8?B?b1NmU0tQZTYvUzR4WU8yYmM0WXhmVlFWSFBPbG1jVnRiM3JhMG5Sdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR02MB8187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd9bd33d-de3b-4998-05a6-08da193c5ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 08:47:12.1887
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U2i60t/qzFdt2RSCrfPa78Ozz1oL5jUFoEvyZFSxhYsGVNvOUlLHanPKScfw2FXa9uabYC37UkN8auDP3ILISw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB4695
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2xhdWRpdSwgVG9tYXMsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJv
bTogQ2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbSA8Q2xhdWRpdS5CZXpuZWFAbWljcm9jaGlw
LmNvbT4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCA4LCAyMDIyIDE6MTMgUE0NCj4gVG86IHRvbWFz
Lm1lbGluQHZhaXNhbGEuY29tOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBOaWNvbGFz
LkZlcnJlQG1pY3JvY2hpcC5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9y
ZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IEhhcmluaSBLYXRha2FtIDxoYXJpbmlrQHhpbGlueC5j
b20+OyBTaHViaHJhanlvdGkNCj4gRGF0dGEgPHNodWJocmFqQHhpbGlueC5jb20+OyBNaWNoYWwg
U2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47DQo+IHB0aG9tYmFyQGNhZGVuY2UuY29tOyBtcGFy
YWJAY2FkZW5jZS5jb207IHJhZmFsb0BjYWRlbmNlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IHYyXSBuZXQ6IG1hY2I6IFJlc3RhcnQgdHggb25seSBpZiBxdWV1ZSBwb2ludGVyIGlzIGxhZ2dp
bmcNCj4gDQo+IEhpLCBUb21hcywNCj4gDQo+IEknbSByZXR1cm5pbmcgdG8gdGhpcyBuZXcgdGhy
ZWFkLg0KPiANCj4gU29ycnkgZm9yIHRoZSBsb25nIGRlbGF5LiBJIGxvb2tlZCB0aG91Z2ggbXkg
ZW1haWxzIGZvciB0aGUgc3RlcHMgdG8NCj4gcmVwcm9kdWNlIHRoZSBidWcgdGhhdCBpbnRyb2R1
Y2VzIG1hY2JfdHhfcmVzdGFydCgpIGJ1dCBoYXZlbid0IGZvdW5kDQo+IHRoZW0uDQo+IFRob3Vn
aCB0aGUgY29kZSBpbiB0aGlzIHBhdGNoIHNob3VsZCBub3QgYWZmZWN0IGF0IGFsbCBTQU1BNUQ0
Lg0KPiANCj4gSSBoYXZlIHRlc3RlZCBhbnl3YXkgU0FNQTVENCB3aXRoIGFuZCB3aXRob3V0IHlv
dXIgY29kZSBhbmQgc2F3IG5vDQo+IGlzc3Vlcy4NCj4gSW4gY2FzZSBEYXZlLCBKYWt1YiB3YW50
IHRvIG1lcmdlIGl0IHlvdSBjYW4gYWRkIG15DQo+IFRlc3RlZC1ieTogQ2xhdWRpdSBCZXpuZWEg
PGNsYXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQo+IFJldmlld2VkLWJ5OiBDbGF1ZGl1IEJl
em5lYSA8Y2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbT4NCj4gDQo+IFRoZSBvbmx5IHRoaW5n
IHdpdGggdGhpcyBwYXRjaCwgYXMgbWVudGlvbiBlYXJsaWVyLCBpcyB0aGF0IGZyZWVpbmcgb2Yg
cGFja2V0IE4NCj4gbWF5IGRlcGVuZCBvbiBzZW5kaW5nIHBhY2tldCBOKzEgYW5kIGlmIHBhY2tl
dCBOKzEgYmxvY2tzIGFnYWluIHRoZSBIVw0KPiB0aGVuIHRoZSBmcmVlaW5nIG9mIHBhY2tldHMg
TiwgTisxIG1heSBkZXBlbmQgb24gcGFja2V0IE4rMiBldGMuIEJ1dCBmcm9tDQo+IHlvdXIgaW52
ZXN0aWdhdGlvbiBpdCBzZWVtcyBoYXJkd2FyZSBoYXMgc29tZSBidWdzLg0KPiANCj4gRllJLCBJ
IGxvb2tlZCB0aG91Z2ggWGlsaW54IGdpdGh1YiByZXBvc2l0b3J5IGFuZCBzYXcgbm8gcGF0Y2hl
cyBvbiBtYWNiIHRoYXQNCj4gbWF5IGJlIHJlbGF0ZWQgdG8gdGhpcyBpc3N1ZS4NCj4gDQo+IEFu
eXdheSwgaXQgd291bGQgYmUgZ29vZCBpZiB0aGVyZSB3b3VsZCBiZSBzb21lIHJlcGxpZXMgZnJv
bSBYaWxpbnggb3IgYXQNCj4gbGVhc3QgQ2FkZW5jZSBwZW9wbGUgb24gdGhpcyAocHJldmlvdXMg
dGhyZWFkIGF0IFsxXSkuDQoNClNvcnJ5IGZvciB0aGUgZGVsYXllZCByZXNwb25zZS4NCkkgc2F3
IHRoZSBjb25kaXRpb24geW91IGRlc2NyaWJlZCBhbmQgSSdtIG5vdCBhYmxlIHRvIHJlcHJvZHVj
ZSBpdC4NCkJ1dCBJIGFncmVlIHdpdGggeW91ciBhc3Nlc3NtZW50IHRoYXQgcmVzdGFydGluZyBU
WCB3aWxsIG5vdCBoZWxwIGluIHRoaXMgY2FzZS4NCkFsc28sIHRoZSBvcmlnaW5hbCBwYXRjaCBy
ZXN0YXJ0aW5nIFRYIHdhcyBhbHNvIG5vdCByZXByb2R1Y2VkIG9uIFp5bnEgYm9hcmQNCmVhc2ls
eS4gV2UndmUgaGFkIHNvbWUgdXNlcnMgcmVwb3J0IHRoZSBpc3N1ZSBhZnRlciA+IDFociBvZiB0
cmFmZmljIGJ1dCB0aGF0IHdhcw0Kb24gYSA0Lnh4IGtlcm5lbCBhbmQgSSdtIGFmcmFpZCBJIGRv
buKAmXQgaGF2ZSBhIGNhc2Ugd2hlcmUgSSBjYW4gcmVwcm9kdWNlIHRoZQ0Kb3JpZ2luYWwgaXNz
dWUgQ2xhdWRpdSBkZXNjcmliZWQgb24gYW55IDUueHgga2VybmVsLg0KDQpCYXNlZCBvbiB0aGUg
dGhyZWFkLCB0aGVyZSBpcyBvbmUgcG9zc2liaWxpdHkgZm9yIGEgSFcgYnVnIHRoYXQgY29udHJv
bGxlciBmYWlscyB0bw0KZ2VuZXJhdGUgVENPTVAgd2hlbiBhIFRYVUJSIGFuZCByZXN0YXJ0IGNv
bmRpdGlvbnMgb2NjdXIgYmVjYXVzZSB0aGVzZSBpbnRlcnJ1cHRzDQphcmUgZWRnZSB0cmlnZ2Vy
ZWQgb24gWnlucS4NCg0KSSdtIGdvaW5nIHRvIGNoZWNrIHRoZSBlcnJhdGEgYW5kIGxldCB5b3Ug
a25vdyBpZiBJIGZpbmQgYW55dGhpbmcgcmVsZXZhbnQgYW5kIGFsc28NCnJlcXVlc3QgQ2FkZW5j
ZSBmb2xrcyB0byBjb21tZW50Lg0KSSdtIHNvcnJ5IGFzayBidXQgaXMgdGhpcyBjb25kaXRpb24g
cmVwcm9kdWNpYmxlIG9uIGFueSBsYXRlciB2YXJpYW50cyBvZiB0aGUgSVAgaW4gWGlsaW54IG9y
DQpub24tWGlsaW54IGRldmljZXM/DQpaeW5xIFVTKyBNUFNvQyBoYXMgdGhlIHIxcDA3IHdoaWxl
IFp5bnEgaGFzIHRoZSBvbGRlciB2ZXJzaW9uIElQIHIxcDIzIChvbGQgdmVyc2lvbmluZykNCg0K
UmVnYXJkcywNCkhhcmluaQ0KDQo+IA0KPiBUaGFuayB5b3UsDQo+IENsYXVkaXUgQmV6bmVhDQo+
IA0KPiBbMV0NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2LzgyMjc2YmY3LTcyYTUt
NmEyZS1mZjMzLQ0KPiBmOGZlMGM1ZTRhOTBAbWljcm9jaGlwLmNvbS9ULyNtNjQ0Yzg0YTg3MDlh
NjVjNDBiOGZjMTVhNTg5ZTgzYjI0ZTQNCj4gOGNjZmQNCj4gDQo+IE9uIDA3LjA0LjIwMjIgMTk6
MTYsIFRvbWFzIE1lbGluIHdyb3RlOg0KPiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sg
bGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cNCj4gPiB0aGUgY29udGVu
dCBpcyBzYWZlDQo+ID4NCj4gPiBjb21taXQgNDI5ODM4ODU3NGRhICgibmV0OiBtYWNiOiByZXN0
YXJ0IHR4IGFmdGVyIHR4IHVzZWQgYml0IHJlYWQiKQ0KPiA+IGFkZGVkIHN1cHBvcnQgZm9yIHJl
c3RhcnRpbmcgdHJhbnNtaXNzaW9uLiBSZXN0YXJ0aW5nIHR4IGRvZXMgbm90IHdvcmsNCj4gPiBp
biBjYXNlIGNvbnRyb2xsZXIgYXNzZXJ0cyBUWFVCUiBpbnRlcnJ1cHQgYW5kIFRRQlAgaXMgYWxy
ZWFkeSBhdCB0aGUNCj4gPiBlbmQgb2YgdGhlIHR4IHF1ZXVlLiBJbiB0aGF0IHNpdHVhdGlvbiwg
cmVzdGFydGluZyB0eCB3aWxsIGltbWVkaWF0ZWx5DQo+ID4gY2F1c2UgYXNzZXJ0aW9uIG9mIGFu
b3RoZXIgVFhVQlIgaW50ZXJydXB0LiBUaGUgZHJpdmVyIHdpbGwgZW5kIHVwIGluDQo+ID4gYW4g
aW5maW5pdGUgaW50ZXJydXB0IGxvb3Agd2hpY2ggaXQgY2Fubm90IGJyZWFrIG91dCBvZi4NCj4g
Pg0KPiA+IEZvciBjYXNlcyB3aGVyZSBUUUJQIGlzIGF0IHRoZSBlbmQgb2YgdGhlIHR4IHF1ZXVl
LCBpbnN0ZWFkIG9ubHkgY2xlYXINCj4gPiBUWF9VU0VEIGludGVycnVwdC4gQXMgbW9yZSBkYXRh
IGdldHMgcHVzaGVkIHRvIHRoZSBxdWV1ZSwgdHJhbnNtaXNzaW9uDQo+ID4gd2lsbCByZXN1bWUu
DQo+ID4NCj4gPiBUaGlzIGlzc3VlIHdhcyBvYnNlcnZlZCBvbiBhIFhpbGlueCBaeW5xLTcwMDAg
YmFzZWQgYm9hcmQuDQo+ID4gRHVyaW5nIHN0cmVzcyB0ZXN0IG9mIHRoZSBuZXR3b3JrIGludGVy
ZmFjZSwgZHJpdmVyIHdvdWxkIGdldCBzdHVjayBvbg0KPiA+IGludGVycnVwdCBsb29wIHdpdGhp
biBzZWNvbmRzIG9yIG1pbnV0ZXMgY2F1c2luZyBDUFUgdG8gc3RhbGwuDQo+ID4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBUb21hcyBNZWxpbiA8dG9tYXMubWVsaW5AdmFpc2FsYS5jb20+DQo+ID4gLS0t
DQo+ID4gQ2hhbmdlcyB2MjoNCj4gPiAtIGNoYW5nZSByZWZlcmVuY2VkIGNvbW1pdCB0byB1c2Ug
b3JpZ2luYWwgY29tbWl0IElEIGluc3RlYWQgb2Ygc3RhYmxlDQo+ID4gYnJhbmNoIElEDQo+ID4N
Cj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDggKysrKysr
KysNCj4gPiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gPiBpbmRleCA4MDBkNWNl
ZDU4MDAuLmU0NzViZTI5ODQ1YyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiX21haW4uYw0KPiA+IEBAIC0xNjU4LDYgKzE2NTgsNyBAQCBzdGF0aWMgdm9pZCBt
YWNiX3R4X3Jlc3RhcnQoc3RydWN0IG1hY2JfcXVldWUNCj4gKnF1ZXVlKQ0KPiA+ICAgICAgICAg
dW5zaWduZWQgaW50IGhlYWQgPSBxdWV1ZS0+dHhfaGVhZDsNCj4gPiAgICAgICAgIHVuc2lnbmVk
IGludCB0YWlsID0gcXVldWUtPnR4X3RhaWw7DQo+ID4gICAgICAgICBzdHJ1Y3QgbWFjYiAqYnAg
PSBxdWV1ZS0+YnA7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBpbnQgaGVhZF9pZHgsIHRicXA7DQo+
ID4NCj4gPiAgICAgICAgIGlmIChicC0+Y2FwcyAmIE1BQ0JfQ0FQU19JU1JfQ0xFQVJfT05fV1JJ
VEUpDQo+ID4gICAgICAgICAgICAgICAgIHF1ZXVlX3dyaXRlbChxdWV1ZSwgSVNSLCBNQUNCX0JJ
VChUWFVCUikpOyBAQCAtMTY2NSw2DQo+ID4gKzE2NjYsMTMgQEAgc3RhdGljIHZvaWQgbWFjYl90
eF9yZXN0YXJ0KHN0cnVjdCBtYWNiX3F1ZXVlICpxdWV1ZSkNCj4gPiAgICAgICAgIGlmIChoZWFk
ID09IHRhaWwpDQo+ID4gICAgICAgICAgICAgICAgIHJldHVybjsNCj4gPg0KPiA+ICsgICAgICAg
dGJxcCA9IHF1ZXVlX3JlYWRsKHF1ZXVlLCBUQlFQKSAvIG1hY2JfZG1hX2Rlc2NfZ2V0X3NpemUo
YnApOw0KPiA+ICsgICAgICAgdGJxcCA9IG1hY2JfYWRqX2RtYV9kZXNjX2lkeChicCwgbWFjYl90
eF9yaW5nX3dyYXAoYnAsIHRicXApKTsNCj4gPiArICAgICAgIGhlYWRfaWR4ID0gbWFjYl9hZGpf
ZG1hX2Rlc2NfaWR4KGJwLCBtYWNiX3R4X3Jpbmdfd3JhcChicCwNCj4gPiArIGhlYWQpKTsNCj4g
PiArDQo+ID4gKyAgICAgICBpZiAodGJxcCA9PSBoZWFkX2lkeCkNCj4gPiArICAgICAgICAgICAg
ICAgcmV0dXJuOw0KPiA+ICsNCj4gPiAgICAgICAgIG1hY2Jfd3JpdGVsKGJwLCBOQ1IsIG1hY2Jf
cmVhZGwoYnAsIE5DUikgfCBNQUNCX0JJVChUU1RBUlQpKTsNCj4gPiB9DQo+ID4NCj4gPiAtLQ0K
PiA+IDIuMzUuMQ0KPiA+DQoNCg==
