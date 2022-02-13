Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D34B3B4E
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbiBMMZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:25:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiBMMZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:25:28 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70125.outbound.protection.outlook.com [40.107.7.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D495D673
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 04:25:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbcKfB9aySzYhugtI+JiU1v+EB3UA77mQz+mWyGhghlSo3/UIq2Q3Onrv4x6qfE+HrdNalYv0d5mI8b9ltBdgEcLnBEeGL+aA71bUBYqb1JFjGPP5rGnWoFz7uKR5RTr/47lA8J/GY0uDswQX+hg34UrdG1KrjhwpbUfknrRqTW+VGZ+4t8R+kMOsvKJHxjjMuTlZOWYvctLUOS0tpOFKxRTTcuMpDpf6rMfNnMCY9klWf8mSWnv6F0GLy8OLamjn4FvamEgFr/2O1DGzg/j+b1kZAX//5P8nd4v1PRdqqhBJ02xDD3s4vDUS5aRXDnZ5oAd/CPH2pcw2j2sfvHmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oWZ5VZn6WQO1hewk0e83n2z80NW1DWMJsz8Zkjy5iZM=;
 b=DWixjPZY1rlZbUY54VlaUmXub0ei7rsB1+AP6ghk2aMxt2141YsVCLzZRl028gm84442VRvpsH+h6xkC7QyxbzraqPACCC7jas2H7PNFbRom6AYLKRhArQm0jvSCt4HJruGyhoy+coG8pEAbUhkxdfPasIfs3tw1aZSmXs92DVlJsUFJgwfeW2Peh7MX30t2kzUv9e7V49Wz3h1DdR1RiCx1QmaMrEbxnALgxIYSSkKswYSo5zcFvOmp/TGOVDXLEXvqnkbesJhUq9YHlJ1l9t2ibADOfpO944mGXZY2KuDY3Uy4+TvCa8GVgE1keuRh9fiqnO2lb36nyQocj8w14A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oWZ5VZn6WQO1hewk0e83n2z80NW1DWMJsz8Zkjy5iZM=;
 b=hFYzmNz55G/ds9KeIJHtMst/1gxEl7IjhD2lATbfPFThqiQxsmQsIyRsLfhW6cudXOjO/kUrZUB/+jwBHom7ivbU1glx1eQWYkOOfsKiGi21DbBdqk5+9mmbHfyOmChvGNhkF9WgbKeNKI6Z7udlcghOFbVt0ak1rxNDxphiod0=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB8PR03MB6332.eurprd03.prod.outlook.com (2603:10a6:10:13d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Sun, 13 Feb
 2022 12:25:19 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4975.015; Sun, 13 Feb 2022
 12:25:19 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match
 filename
Thread-Topic: [PATCH net-next] net: dsa: realtek: rename macro to match
 filename
Thread-Index: AQHYH7f5fXk6p5e5+kWF5YSYOFSNLw==
Date:   Sun, 13 Feb 2022 12:25:19 +0000
Message-ID: <87mtivuf68.fsf@bang-olufsen.dk>
References: <20220212022533.2416-1-luizluca@gmail.com>
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Fri, 11 Feb 2022 23:25:34 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d227933-2f9f-4aea-4734-08d9eeebe637
x-ms-traffictypediagnostic: DB8PR03MB6332:EE_
x-microsoft-antispam-prvs: <DB8PR03MB6332933E36AC504DB5D542B083329@DB8PR03MB6332.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2D2xf7Y98umYomz5TcRdWDj+XkiEP1ZT/8/R0mlSzsXUG4L9klgO6TwCpj0/UR4KJDfjR3tCp9xuqwo5sZKu/GhOPTE2MDpB4K+IqQBYcDd1WfzdTOM2OGB0UBMF4pInUqVbkKGq1KxfXM/Rl6V7GthTZypoFJ8x+hyeeeFRtuj5cCdKPpPAlF0MmuXs9YaebAXH7aqFFeZvrMIVQtHY/ssnd4v6HtUBrpsImxJz22pgoopl4cXCjYMJD3gdHm0X+XpLpo6MXtgYWPpqwkTZCGv3xqxFeBQ5/qsV9K83XHiu8P87LoS4LuK9Pje43eELyYWsOXFXoqUIAIe6sIkvXQ9OWjqyv5sIZTOpZyxQJ7Q5SA+leZ92RwnvrLHMAIvIkni2NyToNXCIaaA5ng6zzymZoENKa3ZbS1LKtsqB88GS9zBoQLESBz8sZ4X/RmqdAfiV4TKGCrwFTBX6HES0u27jtFPpdagr1nGaCwF71va6zW5YhTW/+k8uY0J8oRNz9XKJQGZYTyiJ7Y6QELQojA7RSYtSObqmDstVzE6tBp0e9Oki2yOZy6z36F3eh5942L5xefHWd8gHmL7SWFjjq8rY7NQ9kFQnZpPeIAX5rmX74cP/tAlSpIJQBgUq2MsXD6NUns0c3gVI8xZ7vrf0WtwSco9yv38dD0JcicOQPTMEWhU2eWFQjb+c+Xh6eObvw1N4He2JYpQmOp6NnxqQOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(91956017)(66446008)(6486002)(66556008)(64756008)(85202003)(4326008)(85182001)(8676002)(508600001)(122000001)(76116006)(316002)(66946007)(36756003)(66476007)(86362001)(38070700005)(6916009)(38100700002)(2616005)(6512007)(186003)(6506007)(71200400001)(26005)(5660300002)(8936002)(7416002)(8976002)(83380400001)(4744005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2RWSzEwd285YmJ4V2hZVkQ2WUJKNHJKWFMzajU1QjNnN3Y1QXNXcHg3Szlk?=
 =?utf-8?B?bmxkcHlReDhxbFpGUUxkMWh2WHdLTmVnQmk5eEVCb3pkQnJZcGVkWG5uZTRW?=
 =?utf-8?B?RFhFRXpIL3BqQ0Fxc3hMODRncFplZW93QUdoTUlSVld5R3ROY01tdE81c1lO?=
 =?utf-8?B?em50Skt3ZDQvWkhTbGNlaUpLSWVXTTJ4NW83dm13SjRtaHZPeXZNRGxJUnpz?=
 =?utf-8?B?Z1NRR05yN0p2ZWhnTFZ5YWxCK3AreS93cXlrWVJxb2RjZmlsbEh5blVpMWhp?=
 =?utf-8?B?VjcwNG1ja3IxeXpTRFNSRjNCOG1lMWxaY1BKOVVWdEFndUNqRFhOOEpRT1hu?=
 =?utf-8?B?cHk3SXRldHdZRE1vY3lsUDVzSGFRMjc2cGdKYTkrR3IwYWk4VGNrL3ZTQWFq?=
 =?utf-8?B?TTJmeWJiZXExbmZxSmhkaisyYitNcFlsZWRiNEFrZ0d3bXdkc0YyNzRwNGZ6?=
 =?utf-8?B?WVNYSWVZR09KYU50VW5wQk9jVldlZC9CcDA5ZU5TY0JnTGVKbW5nYmdqbjlh?=
 =?utf-8?B?MWtheUNFSzUzem82Y3lmY21LN2EraDlHREw0bVo1VThqTGpmZEVYL29xeFZn?=
 =?utf-8?B?S3hjeVNoNzFNUlErc0p1SnJsOWk4VnlGRUNZZ0FjRDdCdU5LMzBMTHBvVWZN?=
 =?utf-8?B?NU80VHJUdE92aEtkTEs3bUxPdFkrdWRWWmVkc09xYUswNTN1OXFwSzJKMkVu?=
 =?utf-8?B?UlJ3T2hRZGdqdXBTRmxadm1GeCtJTzFWNEoxbnJ1THB5d0tlRzNxQ3R5WFBU?=
 =?utf-8?B?d1k2OGM1ME9XT1loV3laTlJVUlcvb29LeXNHRldxOEdXSkt3ek5NTTRoNm5u?=
 =?utf-8?B?TTBGVnBjRDkvbHZBY0IxcVdCbjJGMUFRLzVMUGhsR3BqSXNTL1ROOTZKbDc5?=
 =?utf-8?B?WmFyQ09UN0QrUCtnRU5JS3ZUOUFyZ2lOUlNZb3FEUGpWRlFIWE9Hb2JGdXZk?=
 =?utf-8?B?aktEd1hVWGlOQjUyS3QwNFRwNGhnVGpoaCtRQVV5TW5yc3Y0dnlxdWR3ZUpi?=
 =?utf-8?B?Sm15emx5MU9wR3FzamlJcmZzcDRXVEdoUjdXTlZEVVgrU1RrSUxrT3A4Q2pX?=
 =?utf-8?B?bGhlRVFNOE02VGs4d3lINWFBaHVpVU9MbittM3A0b2Z5MWx0cm50OHp2cHI3?=
 =?utf-8?B?Z205emd4dkdmc0F5S1paYmZYYmlTS21KMGdtUEJITVFLOURLSTgyL1YwUmRI?=
 =?utf-8?B?Zk1yZjNtbVlRSWV2YlU5RVEwUDRjTTVpeUJWemdoRWkyc0JrU0pPRGM4Lysy?=
 =?utf-8?B?M3g2VjdwMWo5NzhWQlk4L0d5bTBxNGZSSlBMM0d1alM3eEtTMXB6cTFKcmdh?=
 =?utf-8?B?Y0dtT0ZROVNyL1NvTlYrRVU0eDZrODBzakhrOW5hR3ZLaW9CUDd3VkgwK2hk?=
 =?utf-8?B?SlhpZzYyTTlsa3ZQUzRnaStxQ0VRcUlGaEgvMzJ3Sm1QMW1LaUh0T0UzSWRO?=
 =?utf-8?B?U0Z5bFduaGVCendyYUFMMUNBZnN5ZlA0MjZOUHB0Q3d3cWlRUTRuckxuZ0Vr?=
 =?utf-8?B?R3pqVE11VElQRkJlUnBNODZKVytRemtOWWFSenlLempwbEdOY2VPczdnRVRm?=
 =?utf-8?B?K3hudWdhWWNtN1ZVNXVZeUpadmNsd1BCRHh4Vm1mUjVqMEhFWWF0OTV2LzJS?=
 =?utf-8?B?aFEvd0swbXY3UlN2dXg1d1U4cFl3Q040ZnRSTlhGOG96aUgra09aYi9qQWFB?=
 =?utf-8?B?YWlKNmpOandxYlpaVms4YklpdTExZFM4bUlzb0Y3UXVxcEZqdHNDWTVVNUxs?=
 =?utf-8?B?N3g4RTJTWkdaSlZYNWVJMEFhclROa25nODVJNjVoaVV4WWZrYXowTmQ3L2FQ?=
 =?utf-8?B?NzQxTHc1UmhSaW9DaVBOKzRVbitzTUJCWDN4VlNCc3FJWlpueHhlcytaR2p1?=
 =?utf-8?B?cEVtTDl1a2RySXNEN1pwMHlMbmNPaFE3cVlmVEVGZkh2TDhvd0VqQ2VMMjdM?=
 =?utf-8?B?L3psbFNRLzM4UmFuLzRFeE1wK0tHaUloek9kTURDb1MxVjFFcW9pNkxKQm8z?=
 =?utf-8?B?b0swZTFjbUJwYUM3VW5sNXJTNS9KcHd3RG5HWEZZOE5idko3WllSWWFBdldj?=
 =?utf-8?B?cUdZRkpZeUs3SzB1WTI0RllYc3cvM3loSGtPenBabkdON3ptbXZYTTlMTXNV?=
 =?utf-8?B?enB6eGpsRUJrVGZyOVdGV1pkejU4NkpPa1BCZU9RRThGaXdpNnJYeWFPVnFI?=
 =?utf-8?Q?nNmb/g/OoOgZ70HswIiqr+E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A96F50D4C1871C45B4FAAA65C1A51C41@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d227933-2f9f-4aea-4734-08d9eeebe637
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 12:25:19.5337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3HM2bm8Ho6SEZrFaDIiVjaG36nQQds28+F6knsTtPuYt1JNWybGvLrqtNVw3pr+jI5YoJ/michdMiEooYRQjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB6332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gVGhlIG1hY3JvIHdhcyBtaXNzZWQgd2hpbGUgcmVuYW1pbmcgcmVhbHRlay1zbWkuaCB0byBy
ZWFsdGVrLmguDQo+DQo+IEZpeGVzOiBmNWYxMTkwNzdiMWMgKG5ldDogZHNhOiByZWFsdGVrOiBy
ZW5hbWUgcmVhbHRla19zbWkgdG8pDQo+IFNpZ25lZC1vZmYtYnk6IEx1aXogQW5nZWxvIERhcm9z
IGRlIEx1Y2EgPGx1aXpsdWNhQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2Ev
cmVhbHRlay9yZWFsdGVrLmggfCA2ICsrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxh
bHNpQGJhbmctb2x1ZnNlbi5kaz4=
