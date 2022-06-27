Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4564855CAA1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbiF0HMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiF0HMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:12:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25ADE267E;
        Mon, 27 Jun 2022 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656313970; x=1687849970;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fbr0NVnODg/oEC7CRB6NhNvXUBnCp66nRzcSKS4dLzM=;
  b=MknSwQqAYhlDiv+LETf607oHA/XQ46VoJH/C7zngMQz+vo5HpnU2KM4M
   /cN9Uixo4lTlN9bRdIaqOiMREfTx+ZNdCu4sq4PItcFg95bKkUuaMS65+
   JusbDe9SmxVnaZITxhiqgG6zK99Oagrid4gqV7ZS+sGBf3thQPlu98AHs
   i5xAIeYKYEfk79c4/7F0yNaITs0ouCy8ATgLuUlO6+Ptm9dgU2MJRX4oK
   sOCtj0WFvl2AGoe6X7ulnp+M2n0QCg9SRZRF2E8lEQGVEMOQYpAl2NQ0Z
   YS2oMm0mOTgn+n9bvjIfNjDDyP1TIdVQ9yk9mV1L0WGxIN9iJVvDFnIkv
   g==;
X-IronPort-AV: E=Sophos;i="5.92,225,1650956400"; 
   d="scan'208";a="169992544"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jun 2022 00:12:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 27 Jun 2022 00:12:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Mon, 27 Jun 2022 00:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS/9T9EuxtyWicdpi0MpPw1HPjUoI6hxc5eemLfIRDvRPdFcv0/R58GnWqcv6iK8TTHu1Y8AyXBD4pgDLfS6uec7SNhp83kB1OKtC0dApEUdKVE1JwQkOJ/X2rJ6V3NjDDM+n8fH3AcnTUjN1VkjKvfhkBlqIdTQzXjxeRuMeQPgeheqvbMKEq8J4CF2at5ZhV6b2VJahaZlza5vUcI30Auov3uXzaNvl+tk8rB6Eiy5M+BJl580aSbZ/r+Kkr/5NeCGWHgvIgqNEh1tO0/gJypnwFsbsoHLDxqrd4+gf5b9g6p4K+VrWbJUf3Yd+o7x7v6eNFI77H9Gv85dhNk++A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fbr0NVnODg/oEC7CRB6NhNvXUBnCp66nRzcSKS4dLzM=;
 b=Psws+QV11qRwSVFBSk1Agim1qziAiRUy84dcbSiaNedWuBGG34evGT5/kuwF2ngBn5DZtuLMxcgKpxMEIRJqUdO9jLz2UH4dx1EpYM4EuWDEHWfpRSKGSsxtgp+rsG6LiSOukwJKjCq9uFUkRGPquLixctWEnx0WrIPLo2mLKWxbdUBVSCJiJlK9jPpWU0XofLkREsAq82AgCb1GPaJtmO4Rl3i+JeAh4nVP9hK/eHkzNrKDejJ4/qU6a2wxC6Q3gSBWcyeuE1osFQW1sweHSVLZTIJDvZPF1JTVQCwpVKBfZ3vVDWf5VjUZw+MVPlE2khQz1z3m/5QXb0SynzPhqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fbr0NVnODg/oEC7CRB6NhNvXUBnCp66nRzcSKS4dLzM=;
 b=L7UF3+diY3zxHhB8SGYn2FjVmV4hOGOMU385MFgeme97tB+Ip2FVYJr3e9NTEl4P/g+7zplSlnJuIHadjj7mz5iZwTXmZx9ZMNxbUJGAnFoWC4T3fbIvgu0m4XMXP8GTffW/HJtHQtLoUi2R9qaqGSShQ0Z7pfh/GF0sbj8S3cc=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by DS7PR11MB6294.namprd11.prod.outlook.com (2603:10b6:8:96::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Mon, 27 Jun
 2022 07:12:47 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:12:47 +0000
From:   <Conor.Dooley@microchip.com>
To:     <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Thread-Topic: [PATCH net-next 16/22] riscv: dts: microchip: add mpfs's CAN
 controllers
Thread-Index: AQHYiIwO2RhNbJRj0UuhSQdJJDIbva1i2XoA
Date:   Mon, 27 Jun 2022 07:12:47 +0000
Message-ID: <ff40e50f-728d-dba3-6aa2-59db573d6f76@microchip.com>
References: <20220625120335.324697-1-mkl@pengutronix.de>
 <20220625120335.324697-17-mkl@pengutronix.de>
In-Reply-To: <20220625120335.324697-17-mkl@pengutronix.de>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 940cd7fc-cae5-4079-2e2c-08da580c708b
x-ms-traffictypediagnostic: DS7PR11MB6294:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y1wmbNpKHFLzwGAdr0aAH2wyiYeebIdEAQ8qOPhMeBLhcQ/x+QopQKiHwi6DfWVHLSBgx166YKcTnwE6zO9gpOoZZ8BoGOU//KUp7u+wcH8K/mk6hwSfyIb8q5cqJfXg+7THQhLI4u8X0AQdI7GvRoIR3VrV60TBut6IryqJMAo0yuEhR032eLAVjH2j1h3SlTRynyzICTQoMPWEkxvVS0QDs74s5laj/d/BZOR6+mFviD97C1k6r5MGVMUI7bwfHzi1O+r7lTub5jgVKyq7Gh9yb0ZbaOBa5RR/WsiQSrvWYzti6fuYBwDAxC9BsIgObywZj9iByR+kb2spo2ezDPGH7/VJI+Dw0uGNd16Rl1fyMkB7P+5sq9ZRuFyBJ6DQsM5nanLyPz9UNoPwcCBczu5x/n8TJZ1K4eAhQ1s9vv+N62w/gFkjIdf017SwCdLo7k9+DjHkHrOKfD1rMTkx+AAll+PLFIDjmEZEbWATvdwhBk64cwTLXxoVN06epa9h23vXAp8CbDIPrnIZjIzXaUv5kHb5ml+oqEGa/YpRKa8FatQkDPjgFf0Sk9KIEAS0wtQp7XlPJPomGVVmJI+s/f5GJp4RLfbznVJ4Y7gANZ6eo7jJM8z0AGPVLqI0h4m0sEltMj8Ao3pSGoTBOeVk9lAoDwXz3MxVKZWSqecdXqk+vftlINvZ5wxslnu9gC4b0M7FF6faiBnI4SfpRSStf2DtNLfMtltrky4QZK2Tn7hNE+lB55YvIPAYswGDJCiwZ9v2e/T8QOXGL375jEKbxdWg4cuSEJ/FEAqp7RXusyiw+DOrCS2RmZdr0j/Z4UZq1bYKIR39HkwVjl9P4B/OpcxbPKQzcDUQ7BEAFEerDZLN5RsO6GQ9Km0vvFk2staJmUrt8vQ5vUUx65tt3ew1nA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(39860400002)(396003)(366004)(346002)(83380400001)(5660300002)(76116006)(71200400001)(31686004)(66446008)(2616005)(6512007)(4326008)(86362001)(478600001)(66556008)(38070700005)(91956017)(6486002)(66946007)(122000001)(64756008)(110136005)(316002)(31696002)(66476007)(966005)(41300700001)(54906003)(6506007)(8676002)(26005)(53546011)(8936002)(2906002)(36756003)(186003)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MVBNNlVURWphc2hUZlpCVHhNS2dyR0F4TlA3RDBlcHRVZXBaS1ZmUGZMbUQ2?=
 =?utf-8?B?eDI3WkFadS9zMm1aODVSOHRlTUFuV1FucEZ3b1NpbGIwcXdFUitJdTVhc3Rs?=
 =?utf-8?B?U0IwWDJyVlF1djlZekd4M0xyNHo2Q2tPQ21TSWFYb3ZqRFJwSEI3NlpjaWtK?=
 =?utf-8?B?dzFkcDNJeERwMGd1alVMSjVJUkJ3WWJwSC8rbmFrTlpsRzBSK29WQS9iQjk2?=
 =?utf-8?B?SkxTdG5lNWhodHhKWENxdjRlTHlKYnMxYTQ0Sm9MY2tqR21MditqZ3VYb1JX?=
 =?utf-8?B?OFBwamt3bFRIcWlOOWZFdXdKRTYwWEEzOHE3WUl5Ny93MmpJMXk4ZjNaWW1y?=
 =?utf-8?B?RDhUSlF2ckFpZTVWV0FoQ2twUy8zN1pKRms0UmF3MVgrMENxZzNDZ0d2RGpt?=
 =?utf-8?B?MUpKZWpQWWcyZmd3MStmcE1hV2x6NWQwQy9ucFI5Y1Y4MURNemk5YVJYZERR?=
 =?utf-8?B?aEJDYXFiN3o4cGRxVTNWVDBLeXhZclNLVmNMY29qSDhrSldMenhBQkVobmxY?=
 =?utf-8?B?YXFvYUU3MDJNSW9nSms3Z0JySmJmRS9pTjhaOW9YNmxNcGFuejhGTWlpRzdH?=
 =?utf-8?B?MnVRLzg0NEpzMm54eUhmblBhZ1I2aDd1T3BndUtjQng5eUUyeVhzZHdpWWJL?=
 =?utf-8?B?SlFXb1BsdkpiMHpGZW00RjJ4SWhLemM3dDdUQlVlSUR1bjZGSU0wckpIWlNO?=
 =?utf-8?B?NEhHVTRONG9pQW0zRmNaZEI0ZDFwWjJzTXFjRjBpZDJ4azkzQjNERU4vbWp6?=
 =?utf-8?B?QVlINWtWaDQxODRVNHRoS2IyaG9vVDVZMVd6ZDZxdGRMbFhuR2YvWVo1aERH?=
 =?utf-8?B?RkNKMXk2cmdNZzRVRXBrQTVMR1ZvaEVvb25jcUdJRVdTc2FzNFJQZkdTNVZo?=
 =?utf-8?B?cW9xL1J6ODIrQjNUMzFISi9FZE53WC9md1ZrdzNqSldLT21sclZsVUlFZnEr?=
 =?utf-8?B?bW5pTTQ1elE3M2hKajF0TThlOUpWeGd6UHJWV240dTZjZVlFWGtSVXpxOGJ6?=
 =?utf-8?B?SElBMk1HY1ptSFk0dGtLNW5hRUwrTWVzSm1kR0lnWWYvdWltTnY3YmhqbEQ5?=
 =?utf-8?B?UmdLMzdaQ25yajFNYVl5MW9mdytVUWQ2QWV3Tk9SM0YwY2lrNm1CcUZMQi96?=
 =?utf-8?B?WGRTS2hoTXRieFh6QlJNMmtsV2hEdkNHZ2x3OW01QitYU1pHcVFodVVJM2po?=
 =?utf-8?B?NG1oMmNnL2pCemp5WjFiUmx1N0F0TTMrS3pZZzFoR1Z1Ri8xVnY1WXgwdXgv?=
 =?utf-8?B?dGIvUWl2MUF5WmY4NEJjZkpIaGltb2RKWkIyTWFINEJZajJJalZ5cVlDSWZo?=
 =?utf-8?B?L3lCVTdweEs0MGN2bkJxdzZDeUJpdHZ4NFdjSHNaaXdlTnBYbU9Nb0N3eXFI?=
 =?utf-8?B?YjdnaGxkSjJndUJlTXBUUm5PUGhHaWhSdUtac09QUlRURml5MHBoMVpJUHdY?=
 =?utf-8?B?NzZJRWo4bmkzTGJOTVFDN0NvRm5CTUtGcGpxdEJGUnZhMTlxVlU1NEdvbkVV?=
 =?utf-8?B?dC9hREpJREFKbDNlYTlIemFiQWt3ZXRvN1pLK3pEaytpeG1aNmZKK1RHWDVG?=
 =?utf-8?B?eDJDRzdPQjlEVWFsczFqTzQrSWpGZkYyQ2o0cHNnMDIxdWtZbjA0OVdPN1FM?=
 =?utf-8?B?RUtuRFM5ZEYyV1FIUm9iTkIyWWFnV2FYZnlLM3RRNGhCQTJTOUFXM2FOb2tR?=
 =?utf-8?B?eVFVTWV4em9WN0Qwd3ZaVWRzU1RlaXY5QWlSTGltUnhObUk2bU9SWlB4YjhI?=
 =?utf-8?B?Y08zSjEwODlhVDJxSW1CSndEYnUyazllQkJ4TWRqMXZxb1poQ0c1MGlCRDFz?=
 =?utf-8?B?K1JZWkRWNXJZWk1BaEZrbDZQdVBWUkZPczVoWU9xV2R6MmJkVE1xRnRGbzhW?=
 =?utf-8?B?TlN6b25jM2g4aVU4TWVIakFxckYwM0ZKcllZcVNHc2I2eVAxc3lKTTRlVTRs?=
 =?utf-8?B?UVdXQzNkc1BycHYyYnNkQlE3bElpb1RoM093VTFSVGJ1YjJ5TWZicXRtdU9Z?=
 =?utf-8?B?T0NoMUJMeUYyaEkxWmR6V25sOVd4YktDL09NVmE5d0NoUTZEdXBwOXROZ2lZ?=
 =?utf-8?B?OXVoQitIVzJ1cVlva0Y5UldRV3hxZEw0SzhRclNBdzF1RmtvUWU2R1d6RXlB?=
 =?utf-8?Q?w5PmbeqVkqpfy8HBhkHuKePgp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CCA87A1D6C2E674B98CF785FD9BDFA1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 940cd7fc-cae5-4079-2e2c-08da580c708b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 07:12:47.7054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iDCrbGJL+b4Seij2IIVNtKcjASMksk9c6K4afUhNDmCkeVxmz+NbcRIYF+4kJCF2OGetOc4VXpROuJdq4if1Vh9dsAgd+NW/kJ/FPj0c5Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6294
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDYvMjAyMiAxMzowMywgTWFyYyBLbGVpbmUtQnVkZGUgd3JvdGU6DQo+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogQ29ub3IgRG9vbGV5IDxjb25v
ci5kb29sZXlAbWljcm9jaGlwLmNvbT4NCj4gDQo+IFBvbGFyRmlyZSBTb0MgaGFzIGEgcGFpciBv
ZiBDQU4gY29udHJvbGxlcnMsIGJ1dCBhcyB0aGV5IHdlcmUNCj4gdW5kb2N1bWVudGVkIHRoZXJl
IHdlcmUgb21pdHRlZCBmcm9tIHRoZSBkZXZpY2UgdHJlZS4gQWRkIHRoZW0uDQo+IA0KPiBMaW5r
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMjA2MDcwNjU0NTkuMjAzNTc0Ni0zLWNv
bm9yLmRvb2xleUBtaWNyb2NoaXAuY29tDQo+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERvb2xleSA8
Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IE1hcmMgS2xlaW5l
LUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQoNCkhleSBNYXJjLA0KTm90IGVudGlyZWx5IGZh
bWlsaWFyIHdpdGggdGhlIHByb2Nlc3MgaGVyZS4NCkRvIEkgYXBwbHkgdGhpcyBwYXRjaCB3aGVu
IHRoZSByZXN0IG9mIHRoZSBzZXJpZXMgZ2V0cyB0YWtlbiwNCm9yIHdpbGwgdGhpcyBwYXRjaCBn
byB0aHJvdWdoIHRoZSBuZXQgdHJlZT8NClRoYW5rcywNCkNvbm9yLg0KDQo+IC0tLQ0KPiAgIGFy
Y2gvcmlzY3YvYm9vdC9kdHMvbWljcm9jaGlwL21wZnMuZHRzaSB8IDE4ICsrKysrKysrKysrKysr
KysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbXBmcy5kdHNpIGIvYXJjaC9yaXNj
di9ib290L2R0cy9taWNyb2NoaXAvbXBmcy5kdHNpDQo+IGluZGV4IDhjMzI1OTEzNDE5NC4uNzM3
ZTBlNzBjNDMyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Jpc2N2L2Jvb3QvZHRzL21pY3JvY2hpcC9t
cGZzLmR0c2kNCj4gKysrIGIvYXJjaC9yaXNjdi9ib290L2R0cy9taWNyb2NoaXAvbXBmcy5kdHNp
DQo+IEBAIC0zMzAsNiArMzMwLDI0IEBAIGkyYzE6IGkyY0AyMDEwYjAwMCB7DQo+ICAgICAgICAg
ICAgICAgICAgICAgICAgICBzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiAgICAgICAgICAgICAgICAg
IH07DQo+IA0KPiArICAgICAgICAgICAgICAgY2FuMDogY2FuQDIwMTBjMDAwIHsNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsbXBmcy1jYW4iOw0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICByZWcgPSA8MHgwIDB4MjAxMGMwMDAgMHgwIDB4MTAwMD47
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGNsb2NrcyA9IDwmY2xrY2ZnIENMS19DQU4wPjsN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0LXBhcmVudCA9IDwmcGxpYz47DQo+
ICsgICAgICAgICAgICAgICAgICAgICAgIGludGVycnVwdHMgPSA8NTY+Ow0KPiArICAgICAgICAg
ICAgICAgICAgICAgICBzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiArICAgICAgICAgICAgICAgfTsN
Cj4gKw0KPiArICAgICAgICAgICAgICAgY2FuMTogY2FuQDIwMTBkMDAwIHsNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsbXBmcy1jYW4iOw0KPiArICAg
ICAgICAgICAgICAgICAgICAgICByZWcgPSA8MHgwIDB4MjAxMGQwMDAgMHgwIDB4MTAwMD47DQo+
ICsgICAgICAgICAgICAgICAgICAgICAgIGNsb2NrcyA9IDwmY2xrY2ZnIENMS19DQU4xPjsNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgaW50ZXJydXB0LXBhcmVudCA9IDwmcGxpYz47DQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGludGVycnVwdHMgPSA8NTc+Ow0KPiArICAgICAgICAgICAg
ICAgICAgICAgICBzdGF0dXMgPSAiZGlzYWJsZWQiOw0KPiArICAgICAgICAgICAgICAgfTsNCj4g
Kw0KPiAgICAgICAgICAgICAgICAgIG1hYzA6IGV0aGVybmV0QDIwMTEwMDAwIHsNCj4gICAgICAg
ICAgICAgICAgICAgICAgICAgIGNvbXBhdGlibGUgPSAiY2RucyxtYWNiIjsNCj4gICAgICAgICAg
ICAgICAgICAgICAgICAgIHJlZyA9IDwweDAgMHgyMDExMDAwMCAweDAgMHgyMDAwPjsNCj4gLS0N
Cj4gMi4zNS4xDQo+IA0KPiANCg0K
