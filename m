Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE814C6BE2
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 13:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbiB1MOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 07:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiB1MOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 07:14:12 -0500
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00137.outbound.protection.outlook.com [40.107.0.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182A726102
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 04:13:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftRzXryeeg7+i+djm5b7rlEYe0B68SNHY5WtZl8F4Jbh/ODQzbPDK672oRWW2DROj+wQRbsEQUX3BTSKYZsI1FLjOAXvWMqHwwD9euFYeFlafh+gLrGvmkS/f/KdlEHpitKH4GF5coPRzYwZzm4prN8hAtLnANg0M5fdfCPW5VT7VowafJyR8KW7r1oWyjWq/lp4nfpyBeT2j8/T5TK//6lfzMV5Sq449h37cb322Md0wssOXoNNMZ49qnUNsDIsUgkUXQJvf59uqQWYq771WleWQRvrIosA3Ipoc4gjDyCgO+TI6B315yJ4Bq1HgChvvdRXCvg2aInC1vkNSCVLrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZbHK/XsPgyji7H0RT3Qz9dTcWEzISEKX7CXnKY+SYTI=;
 b=J+hKpwNPuijfnF3aN2d9BaYT7Y3Ftf+Djh1dZ/UQYRxg/EsRGJy0OFPorCoojsjYwd34diSK5o7Owb4b2Eu6+KJXpsJFtEPsEf/xV3Sgjy3BMH4dAcij3jxeOszyh2FIe9mvq1waAlnhQG8Ev+w6c3IIv8DtAR+l7iuEzhzyIEJ/dJhes+99TtmkpdW8j3shR1VKn/ySW9Zas0qxGH2fJ9sUtcoVmAFmQVlzDWhLQ6Vqq+t24aydB+IM5yywtDWNa9DuZzh+YbmXuhw1jJ1C28RLsyTAUYUqNXR6lxucn10LrtWvOVPLSWskTWK1Lh4khLfof3xGY/UgFXgbooVwBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbHK/XsPgyji7H0RT3Qz9dTcWEzISEKX7CXnKY+SYTI=;
 b=SoWHjfyJP7Rbld1CoHc7/V33XgyVN/C4CSENI/geSURtwzlcgMSfYDvyxMsgjVU6E7YmTZZcw/OVJNdYiAaw6P+J2J8pQR56sw3NVQrZ5nt5+M0B+6F3jWsBnNSrG3i8uJfFu2wJhuwDNbZ3qp57KwGg4nfaZcg7GzwuSKxu2Es=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB6622.eurprd03.prod.outlook.com (2603:10a6:800:17f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Mon, 28 Feb
 2022 12:13:29 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 12:13:29 +0000
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
Subject: Re: [PATCH net-next v4 2/3] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Topic: [PATCH net-next v4 2/3] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Index: AQHYK46A9poiEEl+bEaqlIkGQWxWlw==
Date:   Mon, 28 Feb 2022 12:13:28 +0000
Message-ID: <87zgmbb34o.fsf@bang-olufsen.dk>
References: <20220227035920.19101-1-luizluca@gmail.com>
        <20220227035920.19101-3-luizluca@gmail.com>
In-Reply-To: <20220227035920.19101-3-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Sun, 27 Feb 2022 00:59:19 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f83d6e6-e38f-42c8-abbe-08d9fab3baee
x-ms-traffictypediagnostic: VI1PR03MB6622:EE_
x-microsoft-antispam-prvs: <VI1PR03MB6622FA901513E84EA8969ECB83019@VI1PR03MB6622.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iz+/2tg3STgDu+NCOLDvGbemiVbvG0P59Yr7GTalMz+jEr2UU7SpaHRfkPwONwnqsHhHU6ojs7tcW6gmQ24Qa/LGiiEIqJffdg8rBoBXpCUVGinmdy6YfB5tRhuXMp5aNcwpKXGJ5lfGlrYgqck2rN7scykADFyo4KuuI2GWoyWrLfCtOXPEO79luhi14WDiTpCF7prT8c4n8fVeHoJ5RcOdJq5luPx8kzKE7pxaSGNMDsJ+LMUKQ1UsYq7q5GklEbNTo0SPr98onA8FVIbodeAzEkQaSN5wpEn883CHOEjiOa6UG/cA1phh5hVnU7lSbFyspedNczu31aO5EY8S+ouAb+zvjylQKJhp54VJ3TxMrGg0Vkcl/jPw0EKgvn6Ax69LkFeNXP4U7piY+r4pNzItWfEwndjAbveX7+bUKzEohkypQFf3Zo+9XWDZIOiuKeEBYewhWWdEvk3CdlId6vMvw2XbeWrX9pfIaiqQ8CTSXJv4FWrMlNVaReSub2jFvh0dp+OpA0V87eIY3qAYaDmzy5kOk1Z/TFM0102GokmhmWdf/F8NEWPjIkn6IvfNeKxmCq2cks8OTQqcKNKCE+XnlHPn07K7z5KLM6/KB5dABQ8Ia8qIK2MHE0MsvcNLFPE4O9mxFYCobWD94nVffv3kv3s5sNPQb/TFTZv3h5JSt0+zQWWX2EBfio6wQS3PUFgpz9grUgBiKqo7v3J53w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(91956017)(38100700002)(76116006)(6486002)(85182001)(66946007)(36756003)(66476007)(66556008)(66446008)(64756008)(508600001)(2616005)(8676002)(4326008)(26005)(186003)(85202003)(86362001)(6506007)(2906002)(122000001)(5660300002)(7416002)(8976002)(8936002)(71200400001)(4744005)(316002)(54906003)(38070700005)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UDJvalNDV3RKRHBIeXBtbHMrR1J6UktveUJLTkR3eEh2OFkza1dtQitkbEcy?=
 =?utf-8?B?ZmdCOTVQSHFPczlhUklxckUrKzQwSGtIQmNsRTZaWlFsbE1FTDJNclpWajRj?=
 =?utf-8?B?QVgxT0IvNytNVHJnS0VBWXBQSWVtU2Z0dUp5d2FMVDlLTVpNL2tDZkM1dlRQ?=
 =?utf-8?B?cGkrckJ3U3JtYldWazk5dU5odkRWUXVKTDNsYU8yVkNQRGtuVERVVEVpQnll?=
 =?utf-8?B?bGtoNDZBTEdVdVF1djVPQU1ORlcxTWxGK3huMk5seUVUdVRROFE1VjlFWmMw?=
 =?utf-8?B?RGplTmJlZkhrSlhoaGpBajFjZGxEWVlGd0JhRXN0VTlqOE1RejFvNnBTZVFW?=
 =?utf-8?B?R2hCT2R2cC9hYzhnWEdYR09TTFcySTRVMmVFZ1lrVXJ3N09kdEllUzk3dnRU?=
 =?utf-8?B?aFhuL1hWZGZ0d3NZSW1vV09WbC9yQjFmRmlZL0RwZ0EvSURKWkFINW1wU2pB?=
 =?utf-8?B?VnRpUm1MN3hxSkpMSG11VmhQeERkcjc3UjZuRlJmRjN4cDJhN3hGcG5ranly?=
 =?utf-8?B?ZjNGSThRY0ZqVzNTekJNdElLUWI1MjY2RzVRYjVDck1VMld1RjQrN2RlNDRT?=
 =?utf-8?B?OVVDaFpQZjF6UkZTT2ZKQm5LQUx3WDQxaWxmcFRzdFh0ZjA5SEp5ZTRKcWtS?=
 =?utf-8?B?WlVrSUV0aUMza1BiczRlVGFYK2RHeUZNUWJRZkZhNG9UVVkzWjBJTjdIVDhN?=
 =?utf-8?B?ZjNoblNLaFJ6Y3BZeEgra21qWm9nd0hvNzFzZEFKZStwYzRWS0Z0TFEvWkpR?=
 =?utf-8?B?aUpKeVpQVFJHODZ3K050WEZWMHlieldKUVhyek40OERIVitJOHhzSEpwTTNM?=
 =?utf-8?B?N2hmY3JzQ1BrTGFhUWo1cVRwaDdEVnVETWpYVnVGeUxIaTFSclBEb3hwMi9B?=
 =?utf-8?B?VUJpaGJzczJhRjFWVXQweWJpVnlkN215YjFMaTQva1JvOVEybzk2ZUlVaTJ4?=
 =?utf-8?B?NEJpWDNCd2x1MHQ2UE4xM1Z6M0NHRHloZnhtVm12VlJ0R1piQ1BucVFyQ0d5?=
 =?utf-8?B?V01tTzVjamtIREdJUjM1amg3M003c1NidXNYZThvQlQ2MzgwWHo4dGQrazk0?=
 =?utf-8?B?RnZOMFFRWnZoMHo2REtyUWhHRnVCZ2Zrazhac1FGU3FIQnB4eVdDQnJ0ekFY?=
 =?utf-8?B?cDVwRUYxV01XRUpCQWE2NFhsa3BhdTRWbHJEVFJtRDBnNS9SeXltK2EzeEhW?=
 =?utf-8?B?cit6VG9uT2UwVXlWV0w1ZkxqUmNXWndIQUhHSzdXMUdSUHliOTNrYzB2Wndn?=
 =?utf-8?B?SEdwYzZUaW14RWRwK0kwQXAxM1IyY2FLenhodURBd0x5QWNSMEFJR3N1Sis3?=
 =?utf-8?B?SDZJNTlISWxhb1IralEvU1FScUJvM0JaMXdCNXlYZ091ZUI5Y3MwbWhrSzFW?=
 =?utf-8?B?T1NLbHI5ZFZ3aTJwT05xUjV5QWpaSjVDRUd1WTNHdVFXZEI1bFd6Q2FEL1Ir?=
 =?utf-8?B?UHFsRk91cnlYdFcxMS9FanNicC9uMXhTdGE5c3ROS1BHTE51TVZuaVRZYVFF?=
 =?utf-8?B?ekpLVW42L1lFUzlZTjJXcTZKc1plRURkNVFZeG9Vdm4rcktUQ1NQRUJLQk5P?=
 =?utf-8?B?ZThjZGwxQ3BkMkNMQi9RQWJPTzNpc1ZvSEJCRThVMGlycmJSczZOb2NHckFL?=
 =?utf-8?B?SGMxbTFzcmdrOFNvSy9tMWlPd1dNVWltMjdZeUxNRno0WjQ1Rk5IdjJ6MHNX?=
 =?utf-8?B?aWJHblpJckFudDRYVGwyOE54c0F3Rzk4eFZQRzlXVWtIUWpGeStKNm5XN3Iz?=
 =?utf-8?B?amtMV25FMjlDT09BWGpyN1YydXJHK0xtcUpueE1PYUNVblYySFZtbFJ2VEZj?=
 =?utf-8?B?TmhFZ01kcmtxdDJuWHE3QWtxV3czeEF6azY1OVFQQm1FN29kVGNPVmNsVW9r?=
 =?utf-8?B?VGFTRTV2RnBxeUxZMysrRlM3Z2tZalFscnRqVDM0bFI1WE1KaitDSElLOVRL?=
 =?utf-8?B?SWVzZnUrdm1SSUlrWGpQZnMwYjZwanZyYmI4dHBPbUw0K0M4bnN3eWQvOGRU?=
 =?utf-8?B?UFZwYkNZM0xJK0RvWWdTVUpXM25KUkQxcE9HUmgxd2FDTllDZks2c2ZRSGs0?=
 =?utf-8?B?dXB1QjJlajZDYlQ1WFJjSlA5QktRaWl1QUg5UXlXanE0OTU0RGFlVHNSMFBs?=
 =?utf-8?B?YWdIblAxV1ZaU3FoRkdGZkRkTFpqbC9sR0wyVGZqTnl1cGhCS1BzMWdSejhX?=
 =?utf-8?Q?WQlBVUXu1tvMA8W1Nhi7s9Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9D793FC903AF884B95F6838BA7CE207C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f83d6e6-e38f-42c8-abbe-08d9fab3baee
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2022 12:13:29.1617
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Ott8Ph1RjfIYbZ49rA7mWAULzsPaqnr/fAKmTNPSVKrQnqIjSxczRqx7aagigcAxS1nx2sFU3apzSsbTzhZ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6622
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
Cj4gUmVhbHRlayBzd2l0Y2hlcyBzdXBwb3J0cyB0aGUgc2FtZSB0YWcgYm90aCBiZWZvcmUgZXRo
ZXJ0eXBlIG9yIGJldHdlZW4NCj4gcGF5bG9hZCBhbmQgdGhlIENSQy4NCj4NCj4gUmV2aWV3ZWQt
Ynk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4gU2lnbmVkLW9mZi1i
eTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KDQpIaSBM
dWl6LA0KDQpQbGVhc2Ugbm90ZSB0aGF0IHlvdSBzaG91bGQgbm9ybWFsbHkgcHV0IG15IFJldmll
d2VkLWJ5IGFmdGVyIHlvdXINClMtby1iLiBBZnRlciB5b3VyIHYxIChhbmQgYXNzdW1pbmcgeW91
IHJlbWVtYmVyZWQgeW91ciBTLW8tYikgaXQgc2hvdWxkDQpiZSB0cmVhdGVkIGFzIGFwcGVuZC1v
bmx5LiBHaXZlcyBzb21lIGNocm9ub2xvZ3kgdG8gdGhlIHJldmlldyBwcm9jZXNzLg0KDQpLaW5k
IHJlZ2FyZHMsDQpBbHZpbg==
