Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C3F591EF0
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 09:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbiHNHmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 03:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240296AbiHNHmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 03:42:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E51F618;
        Sun, 14 Aug 2022 00:42:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTzY17ZHbHI2RK12MD+KEPLHBq8eXv5Iw97gVCoxkZZPmvKSdYCm1lgp9qKb6RW6dqeUzCqjYwvE3GV3JT0UZRVgxYuPG3mqhqdrKkocaliFIYrDiCUcxeATkH2/X90zmMLvx3zF24o1OKpSVZrKTGk2bJc+yavHG/tlc0DNpx/o5qMFpFIa8PsdBmlYraJXABpXmzQ9uvhw8t8Ac6lt9dcF/85mzi3b8xLQwxWt5FEbhrptglUVjxom/9H/DoJko96WuFJ8Teew0+RBaDk390pReuYVe6LRInPHJ9yhZaTGNLvBzLeiMEeFg9M5zqFr27yBO4+PH8p/2ulkgfUnDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6h3J8DV3nGpjL8PnDWbC6uL+F0U/hSX8t7k53GKjyg=;
 b=GBZl/cw4srjfzOm0rt3AlEDQqbP+bZ4o5x3NFKDRzokr4puz++V7XuSlTjTgm6dP4B58RSUh3JjnaqK33Yx+eC5wMqx5wwayOUvUDosVbBbgfVr8k/MsMdfCHmpo3WPa3MZnr4WNOmWmOdyR8Bau0RH2rImkKLIvMemV9GtTkFh2BV8RXkHhH09isDnVirv0PKpLQ1O/tqO/dEPEdbx9fgDx/JMZIK43njDsoZl12biZ7PzbGwpg0WcVn6HBbeD640kEAY4yyCrK0lZwMACdRl/FxqJvMxr/9ZWgJpQrGZL1KwOFvJHbFEnnZSWb44cFBeweZAJWAgeZHyubZzs84Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6h3J8DV3nGpjL8PnDWbC6uL+F0U/hSX8t7k53GKjyg=;
 b=BaApZR0fHetgOT37eIC8ByNUJtulVeNK1NRiz5HUB3XJdo52+9K/1K7CQb+6wgKFMkk+t9Sq7R2F/s2AlQF9hb0ju12pqD/jzZifAZP4pqKHL++5QL8Lr6ivbVr1pbXlC0cyZi0gIDMuevBYdsP4Lz3NX58cAP80yAacBPfDC44TrmKJ1bH+wK6X/GCPQ8yiTqMZ6cyXlHI9KdsORD0qJw5Z+LArBo8LF+WsvqVFhyelT+aYhsw8zafqH/5nq8LOnWZB4pSw9dI9rPAa0hUDww+SLqYCOCzbQk0Y12rQT2jBfkOYZ0az9Ws14zlC2DcZ3Ud3nSj2EATwHYGTg8W/1w==
Received: from BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21)
 by BYAPR12MB4711.namprd12.prod.outlook.com (2603:10b6:a03:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Sun, 14 Aug
 2022 07:42:36 +0000
Received: from BL1PR12MB5377.namprd12.prod.outlook.com
 ([fe80::55e8:4e19:26db:62ea]) by BL1PR12MB5377.namprd12.prod.outlook.com
 ([fe80::55e8:4e19:26db:62ea%5]) with mapi id 15.20.5525.011; Sun, 14 Aug 2022
 07:42:36 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        "rafael@kernel.org" <rafael@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Thread-Topic: [PATCH 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Thread-Index: AQHYpYz96Gih+04o9kejOPb3QatIDq2erIYggAHTNoCADZeNQA==
Date:   Sun, 14 Aug 2022 07:42:36 +0000
Message-ID: <BL1PR12MB5377BB6CC118BBBA0B8403E4AF699@BL1PR12MB5377.namprd12.prod.outlook.com>
References: <20220801095622.949079-1-daniel.lezcano@linaro.org>
 <20220801095622.949079-2-daniel.lezcano@linaro.org>
 <BN9PR12MB538167CB6E0EE463ED25898CAF9F9@BN9PR12MB5381.namprd12.prod.outlook.com>
 <6cf66002-f13d-a1ee-7fa6-dfa78d6be427@linaro.org>
In-Reply-To: <6cf66002-f13d-a1ee-7fa6-dfa78d6be427@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 63c882a7-50fd-4fc1-e709-08da7dc88e9b
x-ms-traffictypediagnostic: BYAPR12MB4711:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +h0zgTZaubiK0m/MfLUeXbqPwjLsfk7FTPLsPGq9ZKPXgUfhn8tYzGc1OemxETg/EFiXvNiI3lhJnENKuDadOnzvNVlZg2z8NaycjDzd9qjZdxKe78Fi0te7KwKmGbcrwmvV+L3YmmnUvVgzR254mjMaaizvVPJlmlysVqbm7Qy96oFovdhrQKzbGy2YbLkU9foj7Ji9G5ugSuEkN1KZqkBFCCISRbbkcr6FEp7aBXGNozDjzQzcDCRDq2IWziOHUFNWiSWKP+Vzzam8J82oXIuMd6rUgBWm0J/vLKHPCF7A485vUh7t6a5FDjeF2fpc3q0OL2QSjtQPuX+E8U0W9CZzTzYKJ4qi1Co07gEvbJF8U7zfBkNBbfl1mA55GpgYwQ+DlbrNroI0ebLk5ibUxBH85JLiV1RyBndI3UTv7K082VtmlfH/FburYRPflPlB3K2rDoKLULA8o5xibl8RhpQhtAdVNe7hWWjRs3jj4ttUi+RPyi9zxQR6Ef6kLYdftmA80VeLcehSN0J3nCn56/UhP2+RyNi8K4JHvO+JHqMImoAg2nEkqh3lSUA6GWF727cAxO6MGlbK1iDP4NyDSmUu9UxNAyv1rQOtgkOPn69/DTJVsI8PfJlSH3Qkf2cSJhnN/nk5mu04feJ6aw1BSRPB/yLgBJRGi/FJvv2UpP9ZTxqRVZ3alF51uZxIE+TAqQRRDO/I+M3U2KmN3JGUK1BgVXjTRfRWoCFRvfNKmyTdes8H55+Bh4F4fGvsYSIlWEKKJue2xw87JUU9LuFMrdOW4eCi38o4XofCg2rl2haHEZPJTA6m7SYo/XCryHTW63XA2JGzvkssfSa4TYCl91+T7vN37UGM9Fi5aMQAaKPlXJSTSv7+F9ZHU8mWlrGzwrqSvCpGz5EpJSzpjEL6ozFzYm5D4tUoTXlJkRxRNEo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5377.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(38070700005)(54906003)(52536014)(5660300002)(316002)(41300700001)(76116006)(66556008)(53546011)(8676002)(4326008)(86362001)(6506007)(66476007)(122000001)(8936002)(110136005)(2906002)(33656002)(66946007)(66446008)(64756008)(26005)(7696005)(9686003)(55016003)(83380400001)(186003)(478600001)(38100700002)(966005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVk3bkUrc0tQejF6Tlo1dXd1b3pSSW9TQmNlNFhSV3BZNlV6OHlSb2lIcFVF?=
 =?utf-8?B?NXF6RUhvTzVFOVBMYWlqV2tTdkd1bTdJSE1lVDhUdUR6QWtVOEZ5Y2xmTWJM?=
 =?utf-8?B?R2JvQXZYRVJpQmZ5bGNaQVc1dE5JSWZ5TjhXOVpScSsxWGNxeHRMK3YrdmI5?=
 =?utf-8?B?a3lReFFheUpIOVlZZnhxNDUrVGdaUXZranRsM3dSVUpXWktudHdUNGE2ejJL?=
 =?utf-8?B?QktZMUt0aXpXc2VKYjV5blBpaEFwd0xWRk96VGY4VzFzMTJ5L1RTVDc5RmdM?=
 =?utf-8?B?aVAzaW9ybGgzVXFPcCtVcWRiV2xlUytRSmFabzF4S0ErQlp5Z0RCZXJGQWl5?=
 =?utf-8?B?UmE4ZWdXZlRoZ2VNdFhrbzhQZU02YnExY0JKUjFELzNNZVZxWUhWeFFNVWN6?=
 =?utf-8?B?bjhFQkpDZ2J6V0xoREVVQ3d0ZnJOM3ltazdQRzl3MHdlTmczejk0RGhXOE1J?=
 =?utf-8?B?SEovcTUyYUVPTnQxRzZ4bFZMdmwrTlJTSjEwVHg1ZnhSUW93MUVSQ29wRHhF?=
 =?utf-8?B?eUdrWkhXODd5aGVKTnBwUStPalF6VVc1MVZjT0lNd2szMVBGank2SHVoM1JQ?=
 =?utf-8?B?OFZqbDVXVkYvMC9OVzF6UEcyZk54dVNKb0s5OXhaMGphd3EweXB4aUsvazB0?=
 =?utf-8?B?bStpVGtrVUtoRG0zbFpBQjJ3dStkTDFNelpweTZJWHV0ak5GSXNQa1JIaHlx?=
 =?utf-8?B?d2pvTkRyaTRLaU9wU2dnak05ZVNOMEFpZ2tXNUJ4MW1HS1A1ZEtKYVBjQ3JE?=
 =?utf-8?B?K2hhVlVibTdJSEJJV3ZnY2VCN2IxQ3o2b1ZEUzQ0SVAvZUkzblhlQVF3cWgr?=
 =?utf-8?B?Y1p0YmtVUC81a09TeEFzM1FwZitQd2Zza0M2emlqOVFXOW12a1d2bytVYXVp?=
 =?utf-8?B?Nm96Z3RTR25iRnlaTXh3cGpiMW81N29KWklnYVlMMFRka1Z0QTRIT0YzSmls?=
 =?utf-8?B?NDBHVk1yajhIYmZkWFl3ZzlvQlZnNktiMnFLSzNuKzl3N05hTmFNSnM1Yjh0?=
 =?utf-8?B?Yno5cSt3U1k1aG5HTlYwcmkvaDR3NVFieGowZzZyNTBnOFFZNnhKdmFSRnZL?=
 =?utf-8?B?T04yNjU4RlU3eG9IQk1NQUxCSFdybDF6M2tVU0ZJNEd6RHB3eU85cDU4RE1k?=
 =?utf-8?B?VUIyOG03amRrRVF0Vlk0UVU4OGR1VEVmZFBpeDdoREg3M1ltV3BNZTgwa1Y1?=
 =?utf-8?B?YXVsOXFYbEs4aUFOdGFCdzMwT2FnTzFOSXNVSmY3UkNyZGlJQ2Zwb2tlY1hn?=
 =?utf-8?B?UEdDYTZhNmJac1FBKzMvK3JjMDJLOGdDbVdtSVpZR0w3L3B2TEd0eEhLUDBJ?=
 =?utf-8?B?QWpuQUNReTNTQk56Qjd3enNQYWRUZmRJWThUalBRWno3Wi9CQlhIOFRpYzky?=
 =?utf-8?B?NU1IYjFzc0pLSjVWdlFERHBJbTFWVU5SNFBNeVN0eGFEL25wa1VteXBpR2M2?=
 =?utf-8?B?a284MzNZV2lHTEY3ZDhuRVREckVtcmE5TFZVckxNdmJDVXNFNjNIRSttS2lh?=
 =?utf-8?B?WW1NampoaEhpT0NaQ1NBZlV3cVFqYmx4aFZma3Y2WGFpR0ZHaDdCUVRYZHlL?=
 =?utf-8?B?Y3RHOERwNTlYMHdmWFFyRldLc1U4M240d1FNUldjM25UdTVFeFhUeE4rbnNV?=
 =?utf-8?B?RE1vRFJZcGlOd3RBRllyZnpubDI1MDl3d2FRZUhpMTZ4Z2JLRkZKUDlQYU9t?=
 =?utf-8?B?TE16ZFRDVmhucjNha1JZYTU1dUlVUHVGOUhXYnh0MnFIUXZ2RDMxS1pBYmRy?=
 =?utf-8?B?TW9VOXhLL0RWTVZYNGl2MGFyb2E2UXIvd1pFUTNpdERHYzVKenVXUEVBeEx6?=
 =?utf-8?B?bS9Pc3I1TVZnODZGY1ZyRXR1ZlFGZDdqaXZRZ2JwQ09pbGo1YlpGOU5wMDBy?=
 =?utf-8?B?Q3JkcnhwQzRKTG5GZHp4T00rZ3VTUUhrVThOMU95Q1Z0d1JiL2dPcUpZc0l2?=
 =?utf-8?B?Y3dRRGFlV2VKMHlVNlgyVUx0ZWpINDc4LzdSMFl3TElSdy91eDlJWnpuUUE2?=
 =?utf-8?B?enp1cXRGc2xqdCtZTDd1QmpaZGxsRFI4RGQ4U1pEY2hLK2RmOEcxYlRmaTBz?=
 =?utf-8?B?ZCtqZGMwVFRtd3pUV1ZxbFBFTDRwelRMR3ZHdFYvYkVackx3dFV4U1Q0UHhE?=
 =?utf-8?Q?a64dC9AdWWxGRYQF8AexDt3KT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5377.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63c882a7-50fd-4fc1-e709-08da7dc88e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 07:42:36.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpJ/Q7BJwIANJhl6khi4tbjP+IIuuYDtPZbd5UNEeK23nAWs2UDlqXQxZUHxESP2nKbIUK5N+VxIfZeq41hTXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4711
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIExlemNhbm8g
PGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDUsIDIw
MjIgNzowNyBQTQ0KPiBUbzogVmFkaW0gUGFzdGVybmFrIDx2YWRpbXBAbnZpZGlhLmNvbT47IHJh
ZmFlbEBrZXJuZWwub3JnDQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgSWRvIFNjaGltbWVs
IDxpZG9zY2hAbnZpZGlhLmNvbT47IFBldHIgTWFjaGF0YQ0KPiA8cGV0cm1AbnZpZGlhLmNvbT47
IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0ggMi8yXSBSZXZlcnQgIm1seHN3OiBjb3JlOiBBZGQgdGhlIGhvdHRlc3Qg
dGhlcm1hbCB6b25lDQo+IGRldGVjdGlvbiINCj4gDQo+IA0KPiBIaSBWYWRpbSwNCj4gDQo+IA0K
PiBPbiAwNC8wOC8yMDIyIDE0OjIxLCBWYWRpbSBQYXN0ZXJuYWsgd3JvdGU6DQo+ID4NCj4gPg0K
PiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBEYW5pZWwgTGV6Y2Fu
byA8ZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZz4NCj4gPj4gU2VudDogTW9uZGF5LCBBdWd1c3Qg
MSwgMjAyMiAxMjo1NiBQTQ0KPiA+PiBUbzogZGFuaWVsLmxlemNhbm9AbGluYXJvLm9yZzsgcmFm
YWVsQGtlcm5lbC5vcmcNCj4gPj4gQ2M6IFZhZGltIFBhc3Rlcm5hayA8dmFkaW1wQG52aWRpYS5j
b20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBJZG8gU2NoaW1tZWwNCj4gPj4gPGlkb3NjaEBu
dmlkaWEuY29tPjsgUGV0ciBNYWNoYXRhIDxwZXRybUBudmlkaWEuY29tPjsgRXJpYyBEdW1hemV0
DQo+ID4+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47IFBhb2xvDQo+IEFiZW5pDQo+ID4+IDxwYWJlbmlAcmVkaGF0LmNvbT4NCj4gPj4gU3Vi
amVjdDogW1BBVENIIDIvMl0gUmV2ZXJ0ICJtbHhzdzogY29yZTogQWRkIHRoZSBob3R0ZXN0IHRo
ZXJtYWwNCj4gPj4gem9uZSBkZXRlY3Rpb24iDQo+ID4+DQo+ID4+IFRoaXMgcmV2ZXJ0cyBjb21t
aXQgNmY3Mzg2MmZhYmQ5MzIxM2RlMTU3ZDljYzZlZjc2MDg0MzExYzYyOC4NCj4gPj4NCj4gPj4g
QXMgZGlzY3Vzc2VkIGluIHRoZSB0aHJlYWQ6DQo+ID4+DQo+ID4+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2FsbC9mM2M2MmViZS03ZDU5LWM1MzctYTAxMC0NCj4gPj4gYmZmMzY2YzhhZWJhQGxp
bmFyby5vcmcvDQo+ID4+DQo+ID4+IHRoZSBmZWF0dXJlIHByb3ZpZGVkIGJ5IGNvbW1pdHMgMmRj
MmY3NjAwNTJkYSBhbmQgNmY3Mzg2MmZhYmQ5MyBpcw0KPiA+PiBhY3R1YWxseSBhbHJlYWR5IGhh
bmRsZWQgYnkgdGhlIHRoZXJtYWwgZnJhbWV3b3JrIHZpYSB0aGUgY29vbGluZw0KPiA+PiBkZXZp
Y2Ugc3RhdGUgYWdncmVnYXRpb24sIHRodXMgYWxsIHRoaXMgY29kZSBpcyBwb2ludGxlc3MuDQo+
ID4+DQo+ID4+IFRoZSByZXZlcnQgY29uZmxpY3RzIHdpdGggdGhlIGZvbGxvd2luZyBjaGFuZ2Vz
Og0KPiA+PiAgIC0gN2Y0OTU3YmUwZDViODogdGhlcm1hbDogVXNlIG1vZGUgaGVscGVycyBpbiBk
cml2ZXJzDQo+ID4+ICAgLSA2YTc5NTA3Y2ZlOTRjOiBtbHhzdzogY29yZTogRXh0ZW5kIHRoZXJt
YWwgbW9kdWxlIHdpdGggcGVyIFFTRlANCj4gPj4gbW9kdWxlIHRoZXJtYWwgem9uZXMNCj4gPj4N
Cj4gPj4gVGhlc2UgY29uZmxpY3RzIHdlcmUgZml4ZWQgYW5kIHRoZSByZXN1bHRpbmcgY2hhbmdl
cyBhcmUgaW4gdGhpcyBwYXRjaC4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogRGFuaWVsIExl
emNhbm8gPGRhbmllbC5sZXpjYW5vQGxpbmFyby5vcmc+DQo+ID4gVGVzdGVkLWJ5OiBWYWRpbSBQ
YXN0ZXJuYWsgPHZhZGltcEBudmlkaWEuY29tPg0KPiANCj4gVGhhbmtzIGZvciB0ZXN0aW5nDQo+
IA0KPiA+IERhbmllbCwNCj4gPiBDb3VsZCB5b3UsIHBsZWFzZSwgcmUtYmFzZSB0aGUgcGF0Y2gg
b24gdG9wIG9mIG5ldC1uZXh0IGFzIEpha3ViDQo+IG1lbnRpb25lZD8NCj4gPiBPciBkbyB5b3Ug
d2FudCBtZSB0byBkbyBpdD8NCj4gDQo+IEl0IGlzIGZpbmUsIEkgY2FuIGRvIGl0LiBUaGUgY29u
ZmxpY3QgaXMgdHJpdmlhbC4NCj4gDQo+IEhvd2V2ZXIsIEkgd291bGQgaGF2ZSBwcmVmZXJyZWQg
dG8gaGF2ZSB0aGUgcGF0Y2ggaW4gbXkgdHJlZSBzbyBJIGNhbg0KPiBjb250aW51ZSB0aGUgY29u
c29saWRhdGlvbiB3b3JrLg0KPiANCj4gSXMgaXQgb2sgaWYgSSBwaWNrIHRoZSBwYXRjaCBhbmQg
dGhlIGNvbmZsaWN0IGJlaW5nIHNpbXBsZSwgdGhhdCBjYW4gYmUgaGFuZGxlIGF0DQo+IG1lcmdl
IHRpbWUsIG5vPw0KDQpIaSBEYW5pZWwsDQoNClNvcnJ5IGZvciB0aGUgZGVsYXkuDQoNClllcywg
aXQgaXMgT0suIFRoZXJlIGFyZSBubyBwbGFucyB0byBtYWtlIGNoYW5nZXMgaW4gJ2NvcmVfdGhl
cm1hbC5jJyBtb2R1bGUNCkluIGN1cnJlbnQgY3ljbGUsIHNvIGl0IHNob3VsZCBiZSBmaW5lLg0K
DQpUaGFua3MsDQpWYWRpbS4NCg0KPiANCj4gPiBUaGVyZSBpcyBhbHNvIHJlZHVuZGFudCBibGFu
ayBsaW5lIGluIHRoaXMgcGF0Y2g6DQo+ID4NCj4gCSZtbHhzd190aGVybWFsX21vZHVsZV9vcHMs
DQo+ID4gKw0KPiA+DQo+IAkmbWx4c3dfdGhlcm1hbF9wYXJhbXMsDQo+IA0KPiBZZWFoLCB0aGFu
a3MuDQo+IA0KPiAtLQ0KPiA8aHR0cDovL3d3dy5saW5hcm8ub3JnLz4gTGluYXJvLm9yZyDilIIg
T3BlbiBzb3VyY2Ugc29mdHdhcmUgZm9yIEFSTSBTb0NzDQo+IA0KPiBGb2xsb3cgTGluYXJvOiAg
PGh0dHA6Ly93d3cuZmFjZWJvb2suY29tL3BhZ2VzL0xpbmFybz4gRmFjZWJvb2sgfA0KPiA8aHR0
cDovL3R3aXR0ZXIuY29tLyMhL2xpbmFyb29yZz4gVHdpdHRlciB8IDxodHRwOi8vd3d3LmxpbmFy
by5vcmcvbGluYXJvLQ0KPiBibG9nLz4gQmxvZw0K
