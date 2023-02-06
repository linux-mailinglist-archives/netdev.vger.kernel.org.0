Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F3068B8F1
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjBFJtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBFJtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:49:03 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4AC1C7F7
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:49:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN4SXkl52fw3SlWzAPlE4ZitrV8NBB80MBnnKXxObK0p1zYKMEF4caAeoRbFhf2bjW5pIfZJkM7n7DB6W5W5AKmmPlWAhR60tCgb3mFWj+i2266JmfFugQ8tvg6ApExe0xBvnewvA+h7LGSu38MnM7zxdfWYK5tKVAPLLoss9DSUfYWrxDfxk3aumXh9/fMAfQwL0lOt9SFn71GXvJlrCl2YdUGMe6lDIFiZ8dXydv9O/y6Y6/fe29qlRKg75erlemc5bUAriDjQmqaxPE6WJ0LyQUuh25Da2t3SiBgyKvfiJN1Zb6W4uXOv+5fxUSaSoZa5V1VQ36GDZKeU2Yy5Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcRHqlndwOm8UkdNpt6UdeJjbYflhRFSXYkRzrO3tR0=;
 b=eQ3UauyOoFcTasLmP6+ddHah3XGJqsXB2Z7L1EaPPBtjPiQKbMbV1i0Ag31i3N5Fa0Odv8L+3bXuCbttRUCSth65oayT3u+0XMduBrJv1KtC1C44x3K8UFkcFwKtl61Po9PiJprtF6Ph6OdpP6BAqbCWdNB8+vLpdm+A7utF4mg4vMKNr2ZQwEG3JaRzFpGPvxaBgg2kQyb6fdllwA7Q//7UMMK3luomazku1TEhb3qlIFqa/EhK1yxx/jEWV4+SBNVb9mpG2yWKN/VHxGvJ0F6L7+KpBKpwlBFSyQHVkTMWJ6zWbrBWjJxaQtce6lWxt0UcMaE4i7IPS1Va091YaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcRHqlndwOm8UkdNpt6UdeJjbYflhRFSXYkRzrO3tR0=;
 b=ndTz5Cylu2PgMt7icg/QWS3P0XPChe+AFQZLvn6Or9l/Nh9IwGycefCq72iLVxTFAa6vw0FFyLtcutp28IF0cb4v21MZK2mahGMuSKZNyF8aFng4PWc+ONo6yNAF4ksDcews+3OGGZSkJyTmlHMPR8u9TyrC4EoRDuT4nmS+IZSW1uIMxkG4+ifo2n1/N2Vqnf6n5wtn6W1CUDh+LhToS/cdyLS+NT89YK2KJSfKQ5dL7MygADcHBNO+Bk5nQh/3I5zH5Y8Ul4j7I4+YwW9vPuCxGuVweZZ2sRTOD7AIx8b7RdOiaX9HMCJpRuGeMEk0WZZpDvqnCX09hlzhl8sDxg==
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 09:48:59 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::9fd9:dadc:4d8a:2d84%4]) with mapi id 15.20.6064.027; Mon, 6 Feb 2023
 09:48:59 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        Shai Malin <smalin@nvidia.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: RE: [PATCH v11 04/25] Documentation: document netlink ULP_DDP_GET/SET
 messages
Thread-Topic: [PATCH v11 04/25] Documentation: document netlink
 ULP_DDP_GET/SET messages
Thread-Index: AQHZN9NMZe5wd4vn5025ex0Brr4M4K6+JX2AgAOKz0A=
Date:   Mon, 6 Feb 2023 09:48:59 +0000
Message-ID: <SJ1PR12MB6075F8F252B7D3587D82F96BA5DA9@SJ1PR12MB6075.namprd12.prod.outlook.com>
References: <20230203132705.627232-1-aaptel@nvidia.com>
        <20230203132705.627232-5-aaptel@nvidia.com>
 <20230203194131.52b8c904@kernel.org>
In-Reply-To: <20230203194131.52b8c904@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR12MB6075:EE_|MN2PR12MB4270:EE_
x-ms-office365-filtering-correlation-id: 7d23206c-0e07-49a3-c6f3-08db08275eed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rjd16uWufqJRhn6nbwPlWxV1R2VztekHU3NN+cepvjMfl+eOYxjsYEmM/5VSp+MRX/FRwArvQkPdgRutT3+ixsqhnGne2J9R4Rm5uWVFWZ3DqRopKjozCdqw5bXfigmcAOqMzpZyycEX4+tk8s9Jxq7Q+MDK4stN78LNHaFl6xe4l4uWFj6YpjbEjzyA1A4UjqzdTDLbS21OfZXPcWIKpjudFaRgjXfvyhiKQNesJhLpx6FZtPlUFrRhb2RLQkFy+igtzoeKaalCkPouR6nXPqLqEGREUGgoOsRmzAZoTBEelxaBPIbZ0oJ99c7vpohzgC7lWkGUpjCD6xyU2v+38vED+KSRpkrRTRsBTp1lF3Am4Jf/pDEY8DQemfvu9k4sJj936/WDQqUulEkPWqFH6vq/M7eLlj3b8Ju5w7lKJJEqqbLrk1/Cb7XRsaeFw1nQIjFyuext3BmuLGTgRsS9Oz53+j0G/CZqZdTKCGBzEZ2ZRnn5PJEDWuiZ657ke3LPBaGLhd4ax5LG7oSfx0x261ywaNuU4K8Gnr7N9KnA51fixD5dW8QZWqdvlksnsKoYoJ9w+VS4HewkDEI91lwRVvzMoZjTzH2pXTw04mTNUb8F6vwlgZXL9RdRHEGiOPjb6NUBRGv3LukH27c4QAwzJbJK0/J6vmzYvpUhDvKNLK1Z7pfzZO33XzIaNIrQAro7UnOyxSjCu5x/bph9EgeoGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(451199018)(186003)(66946007)(76116006)(122000001)(38070700005)(52536014)(38100700002)(5660300002)(6916009)(41300700001)(9686003)(6506007)(64756008)(2906002)(66476007)(66556008)(7416002)(4326008)(8936002)(8676002)(107886003)(66446008)(478600001)(26005)(86362001)(558084003)(33656002)(316002)(54906003)(7696005)(71200400001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDlVVmZ5RDk5WExON1dGUktIVHZQaEZOMjJhSGRzWld3QVAvTmRGWTNSY0pa?=
 =?utf-8?B?a25MWmNCRkZYQTFXZDdzM21lQjdXeC9Gcmh2enhNaElaVm9BeDNSL29IeFMy?=
 =?utf-8?B?ZUs3eHBSVXAyRXpiSzJmVExSSjBTeCs3TmF1Wndjb04yRVFGRjQyUjVoVTMx?=
 =?utf-8?B?eWdNcFdmNWd6dlpGbkdjcXpiN2hrS3p4MDAwcUN6bjhjN3Rud3ExaFd2ZjB6?=
 =?utf-8?B?dTlhUm5ZVVNDSUFhdi81alp6QUVPQkZoalR5OFg0ZTNlaGtFZTRyVTlncWti?=
 =?utf-8?B?dUEwdE5kekFNOFpEc3hEQ2djNGV4ZHRKN2tiZ2JCNUF6SFBDU1Nid3c4c215?=
 =?utf-8?B?Ynlob2pTTFpSLzQxQmFZUmJRSHp6YlF6RXV3VXd0QTYxTnhxemI0ajBDaW1i?=
 =?utf-8?B?ZmQ2RDVJRnhtb2YzOGNSVEljdW5kaHltU2UwU2lOeEdOY0x3cmZINjJrU1Ey?=
 =?utf-8?B?LzZ1ZVZEUUZrdXkrKzludVN4ak5mMi8xNWZIdEdUWmEvdmZJdWhpajJpQVY2?=
 =?utf-8?B?SXRVRkdQbVpYMVNpVHpQYWd5QjdaZEZuUXQvaFViSkMzSk40N2dVNFBmTUZ2?=
 =?utf-8?B?ZmZaYzBWK0VDRUpValZWSSt4SzNQdlFicFM5c0g0MUtUV0srQmdJSXo1NnNZ?=
 =?utf-8?B?bXUzc1plS2tjckE3a1ZDS0FaNWtZSWYvcHZjY2NwQUhPNWM1aUFLdEtJT3BG?=
 =?utf-8?B?dXh3TkpzN3F6Rlhsc3ZkTnlNTXhrUCtTd3ZRczViY1IvRzZxQWtZT1JBU0px?=
 =?utf-8?B?OERWeVZpMHhGZHpLTHA2OURlbXQ1U2pBeTZVY2F6ZE81VEdoM1A0QWtMbnFX?=
 =?utf-8?B?ZDFkQnoveTN5QWxFQ3orSEZyVTYzMDFzR3ovSGhGMEtoVzNRMmRKMEU0UHlK?=
 =?utf-8?B?R2xPY3U3MmtYV0RNSzU1eUNuTnoxZHJoeVZqOUVnOFo5K0NjaUR4STlkenlo?=
 =?utf-8?B?NGtQRmlUY2NmMlB6a2dVbU5PempNWjFqSkQydStheExoQWNYUWtCeEkvMC9i?=
 =?utf-8?B?aUJlazRHVnU2b2ZGZDlIWlRjVlFLMDRkRTQwZHZwM2l0U0dWb1pkR2ljNEZx?=
 =?utf-8?B?Zi84cEdqNGh2Q1dPbFJwQ3NqNklPV3oreUFQWVNGN3ZyWVVHcHlVYldGMCtB?=
 =?utf-8?B?THpXYTg3MWxRMGU2VDZPaGZ2V2JTRDJYaW02aW4rSi9jUlVwY01JYm94M0Vz?=
 =?utf-8?B?dUI0RlZvYmVkemV6OHhQV1Rqc1E1VXZGNTlGZzM4WUovL0pRVVVyM2ttSjNG?=
 =?utf-8?B?ZVlMWlRCdXNTVDB3T1hBbVJHNDA0S1FZL1kvWDd3d3hKc3FEUjlHVEtTc1BF?=
 =?utf-8?B?RDRJdFFOaWZGTzljQ0ErRXlmRkpqbVlkU1JmVnJ3U2xtcTNBNWVrT0FEaUQ5?=
 =?utf-8?B?NUpudjJFbnp4d3JFem9CdzJmZUNGVVM0Y3lyUzNlNTIra1A5bzN2cmo3SVlT?=
 =?utf-8?B?VHo0eWM3RWNkQzBzZjlpWDJ3eWNBOVdEQUhNL2N5T25qVGJubHpDaXhvUDZF?=
 =?utf-8?B?VUpsSzB4TmdKdlVPcmNoeUl4THIxNHVGa3lrSjJwU2R4TUU0TGxySURPU3Bi?=
 =?utf-8?B?N09PaldNVXlMYXVDSHQ3WmFUL1RuR01WdnBlSUtLRzcwMmRVVVRlbDJvRTht?=
 =?utf-8?B?RXhjRE5vNG42bXcyQ2dXNHNTa05kWkFhVjV1R1M5OENtR016S1U4T2RBUnhX?=
 =?utf-8?B?b2V0VnZReS9UbDhXQUE0VDJSWG1iTUc1aWtRT0Q1VzA1WW90SGFoUHhzeWx1?=
 =?utf-8?B?RytxcitGRGVNcUJuaUV5YXJ2bDNRQk1aYVFIUHdIV1lGdGVEMHBUQjlXb1o4?=
 =?utf-8?B?S0xsWFMvdEVQbEdWLzhmN2NYRDhqMEszN3BPbGttRFlWZ2tvOFFxeFVTa3M3?=
 =?utf-8?B?ZitOYkdRYzI4ZFJJTVpmeUUvTjBIcGRIVzFDVnpqSzByOEU0VnZaMWdFRCt4?=
 =?utf-8?B?b1BSbDkreTQ2OVBQbThmc2p1b2ZOdmhrd1FrYVRIRmZHOVZwYzR3NmxRdy9C?=
 =?utf-8?B?UktjWFZRNUVYUXZCSTY2Tit0UXFxRWYzTEpuYlg3emZ0Sk9xL2VRQTF2dzVj?=
 =?utf-8?B?UUcvSHBYZkprenYzdW82bHZnTUdTbjlTVVAxVGJPcVluNmF3TGFZdW1qN2RN?=
 =?utf-8?Q?XQLRInOfmGy0E5Jjifmv2S9tg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d23206c-0e07-49a3-c6f3-08db08275eed
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2023 09:48:59.2132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/BBSgfZL+D0Us9oaC4M91imBeFYAIQvKi0v3z7dtj+dkcRiCmeyn0yGFjqKVHTpcBuZtt12PsqA0QGfIHgjFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBJZiB5b3UgbmVlZCB0byByZXNwaW4gZm9yIG90aGVyIHJlYXNvbnMgLSB5b3UgY2FuIGRyb3Ag
dGhlIHZhbHVlOg0KPiBlbnRyaWVzIGhlcmUuIEkgaGFkIHRvIGFkZCBpdCBmb3IgdGhlIHByZXZp
b3VzIGNvbW1hbmQgYmVjYXVzZSBvZiB0aGUNCj4gZGlzY29udGludWl0eSBpbiBJRHMgYnV0IGlm
IHlvdSdyZSBqdXN0IGFkZGluZyBzdWJzZXF1ZW50IGVudHJpZXMNCj4gLSB0aGUgdmFsdWUgYmVp
bmcgcHJldmlvdXMgKyAxIGlzIGltcGxpZWQuDQoNCk9rDQogDQo+IEFja2VkLWJ5OiBKYWt1YiBL
aWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KDQpUaGFua3MgSmFrdWIuDQo=
