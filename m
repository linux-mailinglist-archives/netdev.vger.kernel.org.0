Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048A75A62D5
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiH3MGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiH3MF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:05:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E8276741
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 05:05:21 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27UBtkKl029784;
        Tue, 30 Aug 2022 05:03:50 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3j8s2ewrks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Aug 2022 05:03:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgMQoNaSUEOD+Jff3zto8h9PcJhP8fjpT79O5JeQwyPZJYjyApwmCCFfqofDHXaZR5cY8ScmPHemrHlmVf4k1SyyNaDdeUJhF+T7DMoj6/700VzKpWCfMthg4FmR8plQe0gjH6+QTTjoE07L9fJLIb1FylGS6k9TWEy38UEVEpM3nkbfuY8Cn6GzYDue4xm1aRifhMF2Ed3qGPUWVa+UspONWcEaRsOp8G5iPSW9ShiBgGWvgUHCa7ksi1grLWJDEYh9Osl3ZhpilHxB6kQcx7EkSrcgik1Sr73lqxaP96XM/m/7JNq6tFjWf1cKyo4tYRzbrvs9PEkXAcf9YkeNkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4NILq8DSZTLT9UO3uq+XQmZcJ0tlmPmZ5TMuzp4c2A=;
 b=GlH1U5HTGdS+SeV5xcH11OrRM8qEVoJXNXwYZvUTEZQma+WhoWmZr3sygkan5ESSEUuXQ94+3mAf45DgeOUYUhS7OxJoIHbMagpJyu53yxiwfiTf2A674BIUOui0ZIqZ8bukdOML3YzUcAvVcoZuAhzk7GZ+Ni1/bbisTIF8h+XmlKElmuP/5QSSWL+OxVZ2eVN1yr6mkfAQGJm7ANQK1NPBRddg6nTl1tmARMDuzYFQva95itQWUNAeYJuGj2V9qPetOvkn4Mj5WIxchPsayRjonDgf9KE1i4pX5JKJmJlcRpHM8nFcJw1g0YakDvAj7oFbX3GHvrDV22I/8Ggp0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4NILq8DSZTLT9UO3uq+XQmZcJ0tlmPmZ5TMuzp4c2A=;
 b=NfUfxjuPlS9IP/YuetXm1PbSJkc0npz562s9tgPDVuN5nZ3asyPMXPV9h7VCspXt29UXRH6TilOkwqqiqEGrmwJlfQEWrZZYcokzWnBPTc5FkYHO5ZVS03V84wspIgsXKfRzDIWpW4t5Zqz3JZmanbk/9CQR4L4XZyf9+XgyUoA=
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com (2603:10b6:a03:430::6)
 by BN6PR18MB1522.namprd18.prod.outlook.com (2603:10b6:404:12a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Tue, 30 Aug
 2022 12:03:48 +0000
Received: from SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24]) by SJ0PR18MB5216.namprd18.prod.outlook.com
 ([fe80::a0cb:528f:3593:e24%5]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 12:03:48 +0000
From:   Suman Ghosh <sumang@marvell.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [net-next PATCH V5] octeontx2-pf: Add egress PFC
 support
Thread-Topic: [EXT] Re: [net-next PATCH V5] octeontx2-pf: Add egress PFC
 support
Thread-Index: AQHYvGI6E3BrzQ2evU2hcVEf+qlckq3HWC9w
Date:   Tue, 30 Aug 2022 12:03:48 +0000
Message-ID: <SJ0PR18MB52161CD6B76022B762944F4BDB799@SJ0PR18MB5216.namprd18.prod.outlook.com>
References: <20220826075751.2005604-1-sumang@marvell.com>
 <686875c4c9b6d8c2ad17b506f7784a8fb8bf351b.camel@redhat.com>
In-Reply-To: <686875c4c9b6d8c2ad17b506f7784a8fb8bf351b.camel@redhat.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36c0d9a3-0f4c-457a-530f-08da8a7fb230
x-ms-traffictypediagnostic: BN6PR18MB1522:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u70EA6Rvd65zRb15fkW+jXhSO0zvA4TwHxd4PXWM3cYZMwBgYIhFyQPy5TzEmTYklehbqrD6WIAZDR8UeHFIC5xanG1+mKEsTfGD63QjC9vAvAjNYVKImXoIynjLMd3WJtOcV2rxDf87gWg3uNROY+sGr8Di+mgQD7R0a7WLWv7O3b/sLtNd+NHc/lk591ZPhU2y1v8wPT/0ZbLtHgUbA6N/PGIxGuWKwFVD3GBzlztSt0YeuMf4PBmW9VY8n1pTjrxL9HtU7y5uW9CGTBtttjM28QWdrmUjU0Mssw1hum1okgWHGbDvSDPdFYlHwigLLAcxnNLz9b0KO+alGFKUIz1yURik4Ezmrpj4npzAb4/di37jHmdorVqwNfiQ/hs4cokAJ7SjtnIFpp4vkpBdMVBZ838N+OdEzUKGG75SkDxnFMxa4kLDz7ZM6wFv8d35ItuhRiT93ca6UvCN+AGtWvZVViswstcschQxMiLgauUNj7BdcIvvGDIkAh8EW3d+DGSIFJN647aKNCr6uYDUdOasmxPNXD180jvT1ttIyh7ixDMzdFZGQ7XyhkqE0bn9pz6oRJCiPXkEYWUC9pppCDSL98aXcSoVSbf39hnDWaXIxwyGxFNIXyb091gwdR/15rsojxzzup5RNKE8iGCqg+u953kvhtBxIcgVFQwWXqaiDYvGu8HD676xLoDcVaFD7eFyE2nY7EE297RB/MYhymw82o5PNsRmSPaDT/+ZP+A5an4ftdi31WnUqFEIDvsig44YTefzauKDvjfR3da3oWl33NMJKt8g/PIO77cRrZQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB5216.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(38100700002)(122000001)(186003)(2906002)(26005)(7696005)(6506007)(9686003)(86362001)(83380400001)(55016003)(921005)(33656002)(38070700005)(66446008)(66476007)(66556008)(66946007)(64756008)(316002)(478600001)(8676002)(76116006)(71200400001)(110136005)(8936002)(52536014)(5660300002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QVUzVXVqUnRSMkdGWG5JWFlVUGJvNnFvZjdwendCZ1NOdFgvQW04WWFNL3gx?=
 =?utf-8?B?Z3JxNUdkTFJ4K2VVT2lzcWxuLzJzYjUzTFpGYy9IeFhOZVNvU09KR1VsTm00?=
 =?utf-8?B?UTJJZ1F2Ty9acHhScjl1ZWlPcjNMd0o3QlBIS0FtM0pVMGY4VGxwS3d3bWFK?=
 =?utf-8?B?WTgvL1JHcVR6cldBRlZiMVM3Ky96aG0xQS8vclg2TUZ2SndVdGEvUzlQK3JI?=
 =?utf-8?B?VVo0NGxoVU1hcDRKOFV0M2pwaG5ONWZkUCthRlhXOWlOOThPTjBBR2NIdTFz?=
 =?utf-8?B?aXhMWnZ6Y3R6c2pmYlg5Mm1VMUZrMVYvRXB6V05Kc0cyM0EyOTYrSHY1eGVT?=
 =?utf-8?B?QU51MEZzQThxcG5BamdGa2ZpM2hPbmJ4a0NHMlhqU1dvaDh5QUdHeW9pZ3Nn?=
 =?utf-8?B?bEd4cThnWTEyTlRzMENDSU02TXVkTzFSdHdFU0g0bXlVUmVTb0Q1WGF5ZHZh?=
 =?utf-8?B?dThXZ1dvZmNMNGhGYXR6eDlvWi9HcXNUeVI2dU92N1lMUm9EVVhLMU1ZZThY?=
 =?utf-8?B?WG1YSVQ4NGJBZWxteWlDc0VvS3BaVktrZjVaTjMvc0xKVjFhSWdqS1NRbE45?=
 =?utf-8?B?S1R3VFlVS1BlTGJYSGNNQllWeERkbmswTm9tbk9iK1UzOFRrY0xmOG9tbVlt?=
 =?utf-8?B?ZDIrNzF0NUw1VGNHVW1uQ1dLc3duclZuY2dpYWR2OVZnMjg3QUNFcnVvV1dx?=
 =?utf-8?B?Q1pjWnBIQU9RenViWU5DR0g4akdsY1RTMFFBRzRxOHpTanlSQTcrSUc3M0Er?=
 =?utf-8?B?VmJ5NFduQTBBNDRKaUJjM2FrTGh6VmVWT0JJQWROejhDNzBrYVlYd2kwb1c1?=
 =?utf-8?B?Y3RtN2NxcktwMXpwL2JydjMySnpSOWt0cG04amFrK1kxUlRVYjNWMnZiV1Zh?=
 =?utf-8?B?U2RuTDRuSnpLTy9PeXQwWHFhWUNnS2JrZkpoelFxNzB1aEpCU3hFdi9obFl3?=
 =?utf-8?B?N21INEgyRU93NHVkVXdSMFd2dTdtYTNha3hUU2pwLzFxNFhlc0FZdElueVlN?=
 =?utf-8?B?RVhtV04wSXI1c3VrL29BZy9mTEhPeUlud2Q2ZWJLaXhHelR0T01OTWdiclE0?=
 =?utf-8?B?cVVoVlNEb0lMWTJWUm00MTRzb3hNc2VhdVJvYk5vL2RJTEdiK3RqaUZpSmxi?=
 =?utf-8?B?aUZZRk1qTDJtNlo1bVFmUllRcnVoc2dxa3NrRkEvYndiMG5kTytRUGRTaHZs?=
 =?utf-8?B?cnNhTDh1SC84SDdVUGVuN3dWWDJqb1JrREp5bSt6SExIaWNTQWMyeU9OSGRL?=
 =?utf-8?B?SmtKSjJHeXF2dzNBTFNXeVRnTGVVYjBpa3FiSHVJT0JkNStDTWp2V1ZJd0VB?=
 =?utf-8?B?bGpHM2pMUDd1YzBLanNjTGkzODVHSVREcXhBQ3l0SDV6MllnR2tnaXhpTjIz?=
 =?utf-8?B?SXQxU1lYblRWSk5rQVRzdFJ3WW40Qk1NTUtheHVSTVErSXRpWE93ZFovN1hk?=
 =?utf-8?B?d29ueTdFY1Eva3M1VktpUjZjb1YzWFZQQVVnK202a2ExYXExYVRnbHhnZGJP?=
 =?utf-8?B?bDVxQlZPb21nSHpUejJvcDVMdXlYRUpTbGJvbEp1T1AyQTRYUFo5MUhvWmJ3?=
 =?utf-8?B?QWIwd08xbEZKbzF0TWlqKzdJQnhkZGd6L1hqUU9rTzdIZ1Axb3ZmaytrYWNH?=
 =?utf-8?B?U2tHdmJtSUdVK3owclpsd2RnOFh0YnlhSytyMzc1NU1xaUJYZjhRRzRIRGtO?=
 =?utf-8?B?bDF1eFRGVmMvd0habmVyd1ZYSjM0MjBKVFBWSzBUT1VRekRxbWtYQ2ZodW5q?=
 =?utf-8?B?a3k2RHhZd2tVZXVqV2JaVmJLM1IwT2NBN2N5dnQrTm50cHVsaEs5UXVUdG1v?=
 =?utf-8?B?RnBxVUJKZVlMMmlDS3RIS0pOdE8zWlVmb3hMZ25PZytCbmoyVnQxTjN3WWY1?=
 =?utf-8?B?RGVweWZ2YU9iL2pPa2wzNmJid1A1SnVnTHQrWnRmZU1QRXErdnBQQ0ZqQ243?=
 =?utf-8?B?Ym4zSkFMRm1GTnZLcFhDVXVUSVFTaUhQSFFOS3VmRWg5d3pmMVo1Z0dic2dw?=
 =?utf-8?B?aW9heU8rck1tVjZVd2VsczRXRzZHSmF1ZWxhTVkwSXR0UjZ5OFdoaUVRaHFV?=
 =?utf-8?B?UEdKOStpUmMzLzh5LzE3blFtSUE2UEpoVWFWaS9FWlpMT3ZuYnIrWVBjTWQ5?=
 =?utf-8?Q?UjMP0lmICHGaczoflkvnZffyN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB5216.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c0d9a3-0f4c-457a-530f-08da8a7fb230
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2022 12:03:48.0868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kcr3WFyrqZhLCW4dDP4g1VKY+cFhD5piR3B0h+BhLPzaEnCh9JU39E3tBV6oiipnwlqt0a0q3aQg1xuogRHIkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1522
X-Proofpoint-GUID: 7thWyNw-H8n9bUgpp-KoFL0bE_eWZS7A
X-Proofpoint-ORIG-GUID: 7thWyNw-H8n9bUgpp-KoFL0bE_eWZS7A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-30_06,2022-08-30_01,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj4gK2ludCBvdHgyX3BmY190eHNjaHFfdXBkYXRlKHN0cnVjdCBvdHgyX25pYyAqcGZ2Zikgew0K
Pj4gKwl1OCBwZmNfZW4gPSBwZnZmLT5wZmNfZW4sIHBmY19iaXRfc2V0Ow0KPj4gKwlzdHJ1Y3Qg
bWJveCAqbWJveCA9ICZwZnZmLT5tYm94Ow0KPj4gKwlib29sIGlmX3VwID0gbmV0aWZfcnVubmlu
ZyhwZnZmLT5uZXRkZXYpOw0KPg0KPnBsZWFzZSwgcmVzcGVjdCB0aGUgcmV2ZXJzZSB4LW1hcyB0
cmVlIGluIHZhcmlhYmxlcyBkZWNsYXJhdGlvbi4NCltTdW1hbl0gRG9uZQ0KPg0KPlsuLi5dDQo+
PiBAQCAtMTg1Myw2ICsxODgwLDMyIEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBvdHgyX3htaXQoc3Ry
dWN0IHNrX2J1ZmYNCj4qc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2KQ0KPj4gIAlyZXR1
cm4gTkVUREVWX1RYX09LOw0KPj4gIH0NCj4+DQo+PiArc3RhdGljIHUxNiBvdHgyX3NlbGVjdF9x
dWV1ZShzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LCBzdHJ1Y3QNCj5za19idWZmICpza2IsDQo+
PiArCQkJICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqc2JfZGV2KQ0KPj4gK3sNCj4+ICsJc3RydWN0
IG90eDJfbmljICpwZiA9IG5ldGRldl9wcml2KG5ldGRldik7ICNpZmRlZiBDT05GSUdfRENCDQo+
PiArCXU4IHZsYW5fcHJpbzsNCj4+ICsjZW5kaWYNCj4+ICsJaW50IHR4cTsNCj4+ICsNCj4+ICsj
aWZkZWYgQ09ORklHX0RDQg0KPj4gKwlpZiAoIXNrYi0+dmxhbl9wcmVzZW50KQ0KPj4gKwkJZ290
byBwaWNrX3R4Ow0KPj4gKw0KPj4gKwl2bGFuX3ByaW8gPSBza2ItPnZsYW5fdGNpID4+IDEzOw0K
Pj4gKwlpZiAoKHZsYW5fcHJpbyA+IHBmLT5ody50eF9xdWV1ZXMgLSAxKSB8fA0KPj4gKwkgICAg
IXBmLT5wZmNfYWxsb2Nfc3RhdHVzW3ZsYW5fcHJpb10pDQo+PiArCQlnb3RvIHBpY2tfdHg7DQo+
PiArDQo+PiArCXJldHVybiB2bGFuX3ByaW87DQo+PiArDQo+PiArcGlja190eDoNCj4+ICsjZW5k
aWYNCj4+ICsJdHhxID0gbmV0ZGV2X3BpY2tfdHgobmV0ZGV2LCBza2IsIE5VTEwpOw0KPj4gKwly
ZXR1cm4gdHhxOw0KPg0KPllvdSBjYW4ganVzdA0KPglyZXR1cm4gbmV0ZGV2X3BpY2tfdHgobmV0
ZGV2LCBza2IsIE5VTEwpOw0KPg0KPmFuZCBhdm9pZCBkZWNsYXJpbmcgdHhxLg0KW1N1bWFuXSBE
b25lDQo+DQo+Q2hlZXJzLA0KPg0KPlBhb2xvDQoNCg==
