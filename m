Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D946480C8
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiLIKSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLIKSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:18:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FAF396C4;
        Fri,  9 Dec 2022 02:18:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AJ5lZmxqtrH5fvOk3GauwEbdgb71ZawXFrxscb1wO4UdoGnNJi1STJCig0p5//9JZYN8wIUUGXQ5zZHJqLDxA2yI0ktiNIIZjGabyT925bcbTjo0+UCW7bvSSvB1WHhgQcLu7TMkgVEXECjrdx2FQfQcD22n/IHBwnr6yWE21y72ez86hUVDgrKr9lxzxFwrMUtT8VW9rNaZzMMYq/P0S/ZPPmFP1tilNbZiCg+XNifCecFtWBdceto1wExBRG8dWtvaw9qZDc405hvLsuy4IhrTdJy2XqP1nhfiKiPGzm2l1IeHm4vWDM5UTAaSZANguIo5RLiqPcsygkPW+O6Psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4lOvDmh1oAEUgdDdYjRDVaOwcEEgWhVUwhP6vr3HMc=;
 b=FtSJOv0ssTOkxrD6NF3kyFvO+wFazBRIeMsfs/GNuzJJfog6uaoS3YgwtDK19LnBjCnkM+ba3Dm7Hzj5SH6hqPdcoRs+/RMMwpdUKH39rjR0/2prFytZIS4Us2R8RIczEEsoc44ssG0GxG9Y2eEnGoqq3NB0TspXx9m46Ns7ABxef+Kd534sqea0t+xOJAafRF45mhQ8ptf6EZwtGCZCFV5QS5CI3lwaVw7VgZDybPJ/X9a8ZLoe/xGB3EqgNWbrZDuzqQgCclKI9q3IwnszQR2aCf7ii5Pd2aKi4nM/bDVFrf7kAiMNLabTQbIplnQKYWSSG5LbSUH2MYM1HwUk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4lOvDmh1oAEUgdDdYjRDVaOwcEEgWhVUwhP6vr3HMc=;
 b=IHV2nQ7/vPo0Ub0kqz5mfQkD6G511rLN9te8GN0rfdIXxlcvGlC/0uC4YBqda7LHXHgb7rDy+uAfIWzdROqN0TfyN0hTKF1iWHGiQ7FiMS7/jvRtW0nzfjiLndLuqkFIsmwHc4yQnBSfWdGRC4w8NLjA97ZOjhf5fLnJoiV2bigOlHX0qqBvV+1wWM8RTQgRPGJ1zDIjQjSAx00ZtUM6EfaHPuwOY+37WJtQoVi6e6B+WhBAp8UVh8342O9AJDp2VsvPIabsvxXvMrI1RcDvrGz9Q4WaKS7oVmTRTpLM7tbN5f4c2YKBLiTyMCmycdoLi1JsZdcXC5BGVi3yGBXs+g==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by PH8PR12MB6699.namprd12.prod.outlook.com (2603:10b6:510:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:18:40 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 10:18:39 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZCvv/CYvpmkSg7ESdruoP4MuPZa5k1xAAgAAAMYCAAH2hEA==
Date:   Fri, 9 Dec 2022 10:18:39 +0000
Message-ID: <IA1PR12MB635381D5C6C3ACE64763C8D6AB1C9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221208115517.14951-1-ehakim@nvidia.com>
        <20221208183244.0365f63b@kernel.org> <20221208183325.3abe9104@kernel.org>
In-Reply-To: <20221208183325.3abe9104@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|PH8PR12MB6699:EE_
x-ms-office365-filtering-correlation-id: d8b73427-e1a5-48b8-bb57-08dad9cebde5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LWp/9zZjdLO8Pc3+E5Zzv6epxoWgDGxkm5CJWpczDrhmaelYUxXD3NC3VI4du27yCNuq0ca9jBSDbdOeEkcj5F8hVZyD7Sv/mkUJqkMnQPbxP/aO9UMgMJx9B5nmJ5teOpptLNPYc74iQr7qgxOfZsbIUYucZCJDB0XyXzayuh50aDNxYG1N+bd0DoP6btry0ei/N/Hi7DSQ1titrgANpR69Opc0O3e+/7kVFsdsiJiEnwxSxnVsUxR2+6VAbQdeKRKapeQDXduACf8XeDbcvL/4ELouQ0bnSuZRIUZ3YBq9OSPx4nBKfUoF1eKhKtj1DJ86jDrwFm0GnQ3ER+OZW8Lh/v33V+LjC3YjLPJA0sgB+j+rkPIn8jgLN424fOHj+TwYOHIJDXsTvubrpYaHJ69/ShzbOEx+Yv5pFdUlJ72pAWRAvk5+3NRKsBkTQxKdL74SDg9CkL1FgoN7x0p4DGjhQ7VjQJLNhVAYPl8zPNlpTCTcJanz+WNg0UXclR6i7DesB/OpA+775XYpMdghtfro3BEzC3wCGj388GMsgzeLulygly/C71bTqLHqvL8Sly22U4Mdil6ODZ5rpnUiLCved8OIpxu7k3SKoKeEjfFysV3NbF2tJNh5H8jeasQRjDVGp0ZwVjMO06A6qwktuTGd4aUarYy6Kup0pyMYtKu0YeQ7TytlZ5m00Qo3iKO2flGbQnrowhI622BNePUbfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199015)(76116006)(66476007)(52536014)(66946007)(4326008)(66556008)(64756008)(8676002)(66446008)(5660300002)(4744005)(8936002)(9686003)(41300700001)(26005)(71200400001)(33656002)(478600001)(2906002)(316002)(54906003)(6916009)(7696005)(53546011)(6506007)(186003)(38070700005)(55016003)(83380400001)(122000001)(86362001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TElZTmZGRzJQanQ1QkNmeWFTWmxkRjFvNlc0aGdZRkxiU0RFQzFkMlZPTnQ5?=
 =?utf-8?B?RmZTcVNZRkRqQkhmL1AzQ2l2dk9ZK1NOSnJUSHQyMWJkdVQ5ZmZ3K0VteDlt?=
 =?utf-8?B?eWcxNEhVa21BdzdmWDBpcDd5N2pOUVlTbVFUdzcybkdpdEdGQVFPR2trRWRP?=
 =?utf-8?B?aGZQemVZbFFRdDZteDNiY2o0aTNwZlgwaXFBd2tZYU93VHVQUlNaWHJDYzVV?=
 =?utf-8?B?LzlDUVN5T3lHSnd2WURTQWlXdlhRVTFqOGxpM0Q2N1gwRjBWWHlLYXlFUU82?=
 =?utf-8?B?NVdoS0l0OWZlTDJDNDlYWEhtTy92aTVRM1BiUVRDT0dnangxNHJiRVBZVlk2?=
 =?utf-8?B?MS9hZndPa2lTOXRrMjFYSkVzbTZaT0lkdXpteVJlYlhJcDlTTWJkSFJCbk1w?=
 =?utf-8?B?OFoxakV0VWgvaFpTdHJlY1ZNNUJybzhxcmNxTmlMNnZOb1ZSSEFEY3JibDBl?=
 =?utf-8?B?V0RESE9Tdlc1RWRKc0NqK3UvRnovclJEaDV3TVJZcXVkK2JrS1pkdU0zL2NG?=
 =?utf-8?B?TDBJYjlORjQ0Z3VBaGtBSVQ2eFI4RmhkMDRNTzhOVEkyRlJ3TUZFR0NGOTJK?=
 =?utf-8?B?R0xWMGdZMXFqcWN0YmQ4TjQyM3RWTHBjNVlQUEVwQWxLLzdhMHh1emtuVUVi?=
 =?utf-8?B?U0MwdDRRSjB1MFU5SjNKelYwUEhNNWxoYTZDbElsQ0pmTFBGZ1VXR1puMmRO?=
 =?utf-8?B?QkdVTWtWUVk5QjczV0ZyZ09WOWhBK044anpGZHh0UE1udDY5dXdvYSt3bzFa?=
 =?utf-8?B?UElsT3ZmTlNNNFZjcUpaaEVqMXh5TnNhMjdwaW56ajR3QXU4MVNBVFkxQnNC?=
 =?utf-8?B?bGg0aU9PaWtHVWM4ZFZla3VRV3J4NFBLYUFTSThTZHY2ZUV6Wk9IMzI4aEg0?=
 =?utf-8?B?dFNRYXM3RkZRd2hhZzJuRURtYytjQ2laNkxsT2p3MFUwdFFqeUNJQ0dONlFu?=
 =?utf-8?B?ZGFUMHdnak1UR3liSTBZQWpyRG9Mb3NEeDB0bUtwek1lYm9oZjBqTnhaU2Vl?=
 =?utf-8?B?YWorSVA5b0YycmNSZTZrRFNyUmFDejRiNUgxcHhFaGVjeXN0eGtFUzh0MlhW?=
 =?utf-8?B?L2Y0am9XenpXZk9IVjFGVlNRU041MVhKd1BvUmVWR3ljWG9Wc0tNRUkrRnZr?=
 =?utf-8?B?K0syaWk2T0p1alNxdGtrTUludjM2L3poNEhvTFhlMEE0TXFoZGJmSGQ5SjhT?=
 =?utf-8?B?WHNFcTl4WGJqLzhvUUJkdXZvbWdmeGkvZDJVMlhYcHJZWlgrVWRYaFFZRWth?=
 =?utf-8?B?UEMvREovUE9kZExGVU1zRHdqYUdzSnFCaTQ4VmNKUDQ4ZWJEcDFDUEdoaWZy?=
 =?utf-8?B?UHRYYUR0V2dlV0xrYmhGYU9LQ1Z3M042WmhQK2o3ZFY4MFBLV0FNZkExSUJ1?=
 =?utf-8?B?Y2FXb2orOVVJOS9nKzVQNE82OENLdkNzY3dnR2U3TEh0VXBTandZbkt3cmlh?=
 =?utf-8?B?VVQwMTlpMVhsZFFGdHowNTdiRWsvZ1FUNWNrdXMySWhtODVLSmoyZE80WC9R?=
 =?utf-8?B?WGo2cEhHLyt2TnNOSmFPTkFxOUx5MW01ZTQ3U0E1bFVqYlZ4b3FlbkJoRVpm?=
 =?utf-8?B?R2VlMUpmNVFlQUdpRDBQeWw3dU0vMGZkMnJ5UDVKQnRRd2tJa2dmQ3BpSVpC?=
 =?utf-8?B?aXB1a09FSHgwYmF2Vk9uWWpac2FqNC9ETG8wbTRVbW8zMkZINFpzSWgydUYw?=
 =?utf-8?B?UHgrdmdzbHFTbkFhME9sa0lmWEdYclhqVnd0dnVFS1dGZllhZzU3WmlGcHR1?=
 =?utf-8?B?NXBGeFNtOHZCb3F1Y3hzRjFaZ3NMYWtiVFdvN1VHWUkxVWtIeW5BSmVwa0FD?=
 =?utf-8?B?a3hWTUF3bVZvLzB4S05laE9ienlJbmJTWFBVVUJjbWtEa3dCaXV3MWQ5OU5T?=
 =?utf-8?B?WHIzVXB1SlFtczAvVTlsSkcvZHkvVnkzQmpEbGFzMnVFRnluZnN3aWNZT3ZN?=
 =?utf-8?B?ekl3RW1Yb205WXBHQkJtM0lNbW53ZDdMRTNKbGVsajNFcGN4N3FQMnYzSXZZ?=
 =?utf-8?B?Nm9TS1pzblF6TGI3aFhGV2xtZnRtUnNOVi91eWVNL1ljbGVvSzJKcWpidGFy?=
 =?utf-8?B?MmpZWkQ2S1pYamQ2NnVmWHl3ZWlMWnVxY3pHUVVGRU1YOTFMODc3cHZTOTNz?=
 =?utf-8?Q?6LgQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8b73427-e1a5-48b8-bb57-08dad9cebde5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 10:18:39.8317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LaNIa3hWH8/17h/+QC6544yG1jYwlf4C5l/aiRoxOiG5i8MBny++zgKyfJikr8806IZOiu1E/3R1IcTYnZfDsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCA5IERlY2VtYmVyIDIwMjIgNDozMw0K
PiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgUmFlZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNvbT47DQo+IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IHBhYmVuaUByZWRoYXQuY29tOw0K
PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBzZEBxdWVhc3lzbmFpbC5uZXQ7IGF0ZW5hcnRAa2Vy
bmVsLm9yZzsgamlyaUByZXNudWxsaS51cw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IHY0IDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3INCj4gSUZMQV9NQUNTRUNfT0ZGTE9BRCBp
biBtYWNzZWNfY2hhbmdlbGluaw0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9w
ZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiBUaHUsIDggRGVjIDIwMjIg
MTg6MzI6NDQgLTA4MDAgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gSSB0aGluayB5b3UncmUg
anVzdCBtb3ZpbmcgdGhpcyBjb2RlLCBidXQgc3RpbGwuDQo+IA0KPiBBbmQgYnkgImJ5IHN0aWxs
IiBJIG1lYW4gLSBpdCdzIHN0aWxsIGEgYnVnLCBzbyBpdCBuZWVkcyB0byBiZSBmaXhlZCBmaXJz
dC4NCg0KVGhlIGNvZGUgYWRkZWQgYnkgdGhvc2UgcGF0Y2hlcyBkb2VzIG5vdCB1c2UgdGhlIHJ0
bmxfbG9jaywgdGhlIGxvY2sgaXMganVzdCBnZXR0aW5nIG1vdmVkIGFzIHBhcnQgb2Ygc2hhcmlu
ZyBzaW1pbGFyIGNvZGUsDQpidXQgdGhlIG5ldyBjb2RlIGlzIHN0aWxsIG5vdCB1c2luZyBpdCwg
SSBkb27igJl0IHRoaW5rIHRob3NlICBwYXRjaGVzIG5lZWQgdG8gd2FpdCB1bnRpbCBhIGZpeCBv
ZiBhbiBleGlzdGluZyBsb2NraW5nIGlzc3VlIGFzIGxvbmcNCmFzIHRoZSBuZXcgY29kZSBpcyBu
b3QgaW5zZXJ0aW5nIGFueSBidWdzLg0K
