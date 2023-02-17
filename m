Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542AA69B323
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjBQTa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 14:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjBQTaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 14:30:17 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6DF604DE;
        Fri, 17 Feb 2023 11:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctjP5gYnG+dc6sDitIeUbogD9GU+gTq3e5sjglECEIQgE6iYHw+RmT++74Iw5G/RrB5NeRJM3l5OOnrYRj36xmgfjbnz8TX408xYr6EOTMQxaQ7ASDUYy11vEuQ6/61YTi903OVmwaQVOKmYNoQPayTt8KMUehFRDqaMFA3KFjeGNQyQFaroqCmzcz+AfqCeIPnRPk7far6rhbFdo60gvNazHD7PoVfUqtIFdQS9edqv6S9Ik3vmMTwsYzU7SCKQOtp05tTfrnoZ4kx/KWQjU3417ADOpTXsyGvw36raKjWi8qznM4cLv2UBZK3ukR3viMRMEA4pv0NeY1+GtweLdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilGGvN07rpkto2CassDdpfHiyhfYIppMDLRwJOGuvJY=;
 b=PDX/a4aaRu2ZLnVQQoAZ/Er9/0vYKU2AmkddGg+j/f3BggZdiQsZi2/ZUeQ3NzpeOwklLW4QaslMCgUBWGZTwMBxBKIFyYNiiyvWaUmFWIK2wNwdUwsMwMfPhvaSjSeZVwxqmRib642xtmDon2UJIoN6DdRgZC/R+aHjRSwSZBnUMbZBzVtX0QlCADyX9i2+hUy6s2dQsDY5K4P2jUrDbbk0zq5uPt0+HWwzDSNvYQL5sb4d12VVNaHPJTiCoOPVICP3UZKCK7xbr3iS+q0iWkc2fuyifns2cscRAVaF9/DjZD4VunwuI3cYN3b4mu9qKga1VfhcP9HpRgWYnUxNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilGGvN07rpkto2CassDdpfHiyhfYIppMDLRwJOGuvJY=;
 b=TGsodMJksi8wQ5x9MOhVdk1aw1+3TMllTVJ7qCsKhhU3AlZK3So5xpzMK6cvDCbSpTBNKb03t9/kw0jzAoODfOP/9MuNuY6xA8MCFA1GZGBWd3VfYpt/tQT2Whn8vQ5TyTLTc6VE/ERiMLZp3c/pAI0YKxweX0QKKPobbJ0ZKkY=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM4PR12MB7504.namprd12.prod.outlook.com (2603:10b6:8:110::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 19:29:58 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%7]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 19:29:58 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Topic: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
Thread-Index: AQHZQvHb1c7AWuw7gkquvoq3/jufb67TaZYAgAAZSoA=
Date:   Fri, 17 Feb 2023 19:29:57 +0000
Message-ID: <DM6PR12MB420294C790115B98DD58FCF0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
 <60366cf007060025725a18a77f58c41ee7e3158b.camel@redhat.com>
In-Reply-To: <60366cf007060025725a18a77f58c41ee7e3158b.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4843.namprd12.prod.outlook.com
 (15.20.6086.011)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM4PR12MB7504:EE_
x-ms-office365-filtering-correlation-id: 465d9cd3-c0d1-4cff-aaf0-08db111d5ae5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PvM3zcfeHekaNfpy5XS/i3+P7ic8wL7I5oCG6axH82BBuTUyufJss3WJsYnr/LV+HAD84lifGikqe1ZbsfRGAkfdGJiA+mBUOBSpqwqd2tEKVVvQ4lfZpGtG/K0R/5YdWkNsNv160cNBoUBYs6vT+8v0hVuHhduLG9LODfMg0qZazgexejcvRMCd/AqP8cwROGl/j6lSiXM38egGDEBHdqhiYqKJCVP2vMDDIJ409K5rHtSh1HnC7D6EPtmvxqIaYob/PiKJXNOqKUTOII0KezMd1rbfL0FWuE34MP2l6WBN3CCPvntLcsOVKFGYMazKZ6vg4EGi9OdAtaLh3IFLICSkQvYUnU/sNBnO+dlqAdOutZZFsnky7zWZLAM5SaHhOn0wW5Pd4kPJvDBoT1eWNefh5DN/NhCaU3iku+m6wIiCR0+vM8rwM0auI2TV5nuVvoE3XY4pDQ6DmPcPPRcAYz3IaCiWJPDPL1pIZWVBJuPWS3LIsI8FYLq/6f/wxYyyGUN/qaYkIsBrSvh7k3CpB23NjnTKS8zQw+cXWGzCfOzofsMf2R49lmatv2/W45DEWJ5W7CrZf4VAdSGvh7JiecVH7IBHghUGw2vHd7v+7x/vSD50fRLSsWcVUXG0PofD/elkxk/cRuSjyImtcQ0I6lMb7mQrhG8ja+bh/3DTnxg9+qqG80X0xlp14y77RuIScGHopdU2IHtwjTjzOOM9YawvAyYhrzEySdI3NiqxUjkqTamXS7fk3MazKJaWDE6l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(451199018)(26005)(6506007)(186003)(9686003)(71200400001)(53546011)(83380400001)(33656002)(66946007)(76116006)(8936002)(4326008)(66476007)(7416002)(8676002)(52536014)(66556008)(66446008)(64756008)(41300700001)(5660300002)(2906002)(7696005)(966005)(478600001)(55016003)(54906003)(6636002)(316002)(38070700005)(38100700002)(122000001)(110136005)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDIyYlFjR3B4aVVWaVQvYlN5OTNoTVNXYnU1MUNVMTMweklNdTM0cXAySjBY?=
 =?utf-8?B?M3dLZ2I5V2FpZEZNd3BiMURIZDlRMktvNHhTclZnU0JId0svcGF2K2psanMx?=
 =?utf-8?B?cXRMSm1OamRrVFB1Q2VITkg1dXdPVXdLY0VFT09aTHlpZTJVcFpCeWxrRmJ3?=
 =?utf-8?B?dXYya1NoNUJXeWJocUptZmFCenBBSzFsWTBCSDFJbzc4N3NzTFJYbzlPMGNi?=
 =?utf-8?B?dkdBdHBNRXdyN2pvSXZsajFZSjl6NHBOZDk5NkZzQ0R6c2FtZ0tRbFRSQTE2?=
 =?utf-8?B?ZHMzY051V1lyUHlZMUZKS2lBYjB0VXF2TGNiakJzNW1lSFc5aU9rS3dRaXQw?=
 =?utf-8?B?ck0xRmxNd1JBRTluNk53V09pbDF5MFNXck9ZQ0tQdENGUlFFQnBuTSttM3VU?=
 =?utf-8?B?ekoxQkM1WUV4Y2grSEMrQTFFNnM5ZTROdG5pOXFTb0RJK1dzc1RYRjNXQkpL?=
 =?utf-8?B?dkFTam5qRFJWMjRDQzNFRkMva1F2dEYyVElMZG1xdjZjWVRqc0pVL0drTmFL?=
 =?utf-8?B?VFBTemlZZGRZeFczdkROMFFBeGhodVh1R3JlczMwTW5LN0hVVFdyb05HaVpl?=
 =?utf-8?B?SjNabGN3bmwrQnRSUC9sTU9CRXR6SkNTRURXTXhxM3hGSEdjdDZXS0lVZU42?=
 =?utf-8?B?a1dhbFphRlpvbDAxd3RPQm9YWFVwY0RDSzVxazhFV3g4TnV6c0hWSlBGcVd0?=
 =?utf-8?B?cFJNVjNsc1VlMFV1SGRwdzFlczcvUTZKMXdvcDJIR2pRWjVyVmFJd0JCMEpq?=
 =?utf-8?B?VWdNME1lZVJjcHh4SWpEdEswc3hmaHQwcmw4NVp3dXNFZW1JQllJS1hMdGNs?=
 =?utf-8?B?QmZzZ2x2blVqZ04rZ2dUZUErNHhnM0s4N0ZnZFlnb1pwNHl2VGV4Y1Z6UjlT?=
 =?utf-8?B?UFRJRmo1MFU0eVAwTDJQNFN2RXFXS2hTSEkzdFM1L3pDMTVMWUoxTjhiejEr?=
 =?utf-8?B?aWtyaTRoNm1wV1J5NmFNNEZZZ2ZLVjVENmE4SHNOTlBVeVV2YjJ3S3BHa3k4?=
 =?utf-8?B?NWQ4VCtDcW9GcUJLU0Z5N3RhRHJWK3d0NGtxZ0JUaW5JTXlPRWZOeE9qTlM3?=
 =?utf-8?B?eVBVMlU1UmZLUHByMDV3aGZBQXFlMFVDTm9sT25ieitxd0tna21COEdBUktt?=
 =?utf-8?B?a01pelFhbVR6dGx6aFI5ek1ZcWZTN1hEUEh1NkRVT0Y0aHBoY0xPL1FKazNp?=
 =?utf-8?B?M3EzTzV3K3RUQ2V4Tk1RSTM5VVpVbFZMWkp1YU94TGZtdUdmQU82VnVBUytH?=
 =?utf-8?B?Z1BpTko1VTFvSTNiVklva0RNVTNFLzlPekxQUzZFRDhROEpPVjJOWEhNVkxO?=
 =?utf-8?B?N20yaGZ6M2RyTW5HbDlZOVEyV1hlcmErekFnRDhua3lPRXAzREhUUU91UWVz?=
 =?utf-8?B?QUhHcWlCVTJ6YS9LV3o1Qll1MEFBUEhuRXJ5Ry9VQisvbDdBSnhyVzJhbHRN?=
 =?utf-8?B?TEd6WEU2QU5lUWJURkpqTjl3RlJUd0E1R0M1bzdyVnJKRGZHTWR0RVlvUHdq?=
 =?utf-8?B?R1NGcmlRdy9PTjgxeG52STRUS1dkc21xNXVkTkp5SVFQRUNPUU80N0dnQkdU?=
 =?utf-8?B?cXF2WTlxbjFPM3lOSlViYVlWU3h4MW1UNkVUQTdWVkpRVVBvM3NUdjMwM21h?=
 =?utf-8?B?UlRBSXZyS2Z3dVl1ZW1ZWnhkQ2hmTjJhRUVPYlBveUJwRklJVXJnL2tHb3dL?=
 =?utf-8?B?QW5zbHk1N2pNbVg5dURkc3VOejF2aWVNWHpieC9IclhibmZQdVNwN1pPQ2Y1?=
 =?utf-8?B?eWhqdVRXek1XV3ZsQ05oY21DY0JzbUJTbktIQityYkVnWmJ3SmJtWEwwZlhj?=
 =?utf-8?B?Z3ZxNnhTQlF4YXNZdWlCaXUxRDBuMGhNQzFhcU5kZjhCZE9adHE3Qjd0Sml1?=
 =?utf-8?B?ZVFVZy9mMjYzeUlFQUFYVHhSTG9yVnBYL09HYWszRGJGQXRHWHUwTUJ2N1Zn?=
 =?utf-8?B?c3M5MUtTUVNWYjJ1ZXBMTG1ERWNCSHBiMWZsV3drT3BMYWw2dW0yRjMvSjNO?=
 =?utf-8?B?M2xiMTZyYUJ3VGdaK2xaU3BueDMzVEc4MWwzZVZUWnVjR01XbDVOeEc5R3Zu?=
 =?utf-8?B?WnJEUHlRM3NoVjRCZEdncFhJRlFXaWZQa0pqdVJpdFMzd0NNYjhiUTZSU3hW?=
 =?utf-8?Q?GbC4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7763BA4A31C7340B24A3124502FBA17@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 465d9cd3-c0d1-4cff-aaf0-08db111d5ae5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 19:29:57.9469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WyZ0n26CP9dkuBznve0GLl9EdAJGHvoKR+OC1Q5Uv+xMssdeY8JPMNGrEnzbkWgr8df+A9zzaAvDraoYrjNrxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7504
X-Spam-Status: No, score=1.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzE3LzIzIDE3OjQ2LCBQYW9sbyBBYmVuaSB3cm90ZToNCj4gT24gRnJpLCAyMDIzLTAy
LTE3IGF0IDE3OjAzICswMDAwLCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20NCj4gd3Jv
dGU6DQo+PiBGcm9tOiBBbGVqYW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFt
ZC5jb20+DQo+Pg0KPj4gQWRkIGFuIGVtYmFycmFzaW5nbHkgbWlzc2VkIHNlbWljb2xvbiBicmVh
a2luZyBrZXJuZWwgYnVpbGRpbmcNCj4+IGluIGlhNjQgY29uZmlncy4NCj4+DQo+PiBSZXBvcnRl
ZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+PiBMaW5rOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjMwMjE3MDA0Ny5FakNQaXp1My1sa3BA
aW50ZWwuY29tLw0KPj4gRml4ZXM6IDE0NzQzZGRkMjQ5NSAoInNmYzogYWRkIGRldmxpbmsgaW5m
byBzdXBwb3J0IGZvciBlZjEwMCIpDQo+PiBTaWduZWQtb2ZmLWJ5OiBBbGVqYW5kcm8gTHVjZXJv
IDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+PiAtLS0NCj4+ICAgZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMgfCAyICstDQo+PiAgIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3NmYy9lZnhfZGV2bGluay5jDQo+PiBpbmRleCBkMmViNjcxMmJhMzUuLjNlYjM1NWZkNDI4MiAx
MDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3NmYy9lZnhfZGV2bGluay5jDQo+
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gQEAgLTMy
Myw3ICszMjMsNyBAQCBzdGF0aWMgdm9pZCBlZnhfZGV2bGlua19pbmZvX3J1bm5pbmdfdjIoc3Ry
dWN0IGVmeF9uaWMgKmVmeCwNCj4+ICAgCQkJCSAgICBHRVRfVkVSU0lPTl9WMl9PVVRfU1VDRldf
QlVJTERfREFURSk7DQo+PiAgIAkJcnRjX3RpbWU2NF90b190bSh0c3RhbXAsICZidWlsZF9kYXRl
KTsNCj4+ICAgI2Vsc2UNCj4+IC0JCW1lbXNldCgmYnVpbGRfZGF0ZSwgMCwgc2l6ZW9mKGJ1aWxk
X2RhdGUpDQo+PiArCQltZW1zZXQoJmJ1aWxkX2RhdGUsIDAsIHNpemVvZihidWlsZF9kYXRlKTsN
Cj4gWW91IG1pc3NlZCB0aGUgZmVlZGJhY2sgb24gcHJldmlvdXMgdmVyc2lvbiBmcm9tIE1hbmFu
ayByZXBvcnRpbmcgeW91DQo+IHNob3VsZCBhbHNvIGFkZCBhIGZpbmFsICcpJyBhYm92ZS4gU2hv
dWxkIGJlOg0KPg0KPiArCQltZW1zZXQoJmJ1aWxkX2RhdGUsIDAsIHNpemVvZihidWlsZF9kYXRl
KSk7DQo+DQo+IFBsZWFzZSB0cnkgdG8gYnVpbGQgdGVzdCB0aGUgbmV4dCB2ZXJzaW9uIGJlZm9y
ZSBzdWJtaXR0aW5nIGl0LCB0aGFua3MhDQoNCkkgdGhvdWdodCBJIGRpZCBzbywgYnV0IG9idmlv
dXNseSB3cm9uZ2x5LiBUaGUgc2hvcnRjdXQgZm9yIGNvbmZpZ3VyaW5nIA0KdGhlIGtlcm5lbCB3
aXRob3V0IENPTkZJR19SVENfTElDIGRpZCBub3Qgd29yayBidXQgSSBkaWQgbm90IG5vdGljZS4N
Cg0KSXQgd2lsbCBub3QgaGFwcGVuIGFnYWluLg0KDQpUaGFua3MNCg0KPiBQYW9sbw0KPg0K
