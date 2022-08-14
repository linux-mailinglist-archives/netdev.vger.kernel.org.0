Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A78591EE2
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 09:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbiHNHcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 03:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHNHcI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 03:32:08 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D8C1EAF5;
        Sun, 14 Aug 2022 00:32:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JD8OSHD1oZD5bqktIvzsOeHm23SNPrIqG2yPOS3V3mK6oADXgi8s+JTZ+bqTFlKUq1jSLiYpoWuhM00WYC6B8ZZMUC30P5Dhxf3QKgoPbW0LOAyPf1whc9nQL0AV6+h8heV0PqVVojJiMLJw/AI2RtrkAcFICx3jfqymBNTFF2JXZIZlDO9PUATN4yRz1ZtdMEtNRQeyBPgEyH1FtHvCrJr6E8Y8/g7I0ZjJpjPHPWejy+BIZVR8GYpovq9duo/VME6AuuZKId4WVnvhMgo6KeaBPnrObLH06SvjGkUf7MIBQknlultdznh6NdGzpnRLLSjzLx+YIYnwg2kYZNxX5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVxf1VGS+uoGq2fbxAKAS8li91QhUnfjNiTBS8FxwP0=;
 b=UKWlHhN3IpnsHIiBymz8pmGiw2Y+aj2+4tzgUGThp7JHtEbChnpeBlPEJ5hsKQP7vMGU17bV+6lff5j/KAHyMQxzmswfy9Gur6PvBALB2V4XF54n9lPXoozw1kZ1ov+Uj4GUvgyrA1n9ZDr37MniGeWUcjrlQPzIizm6MGsX3hg9rQabEGHubkSxMJaRV32CaAgCcDa3wM5N1fskteSRRpsCFD2W/+kCOgIakhDp5Wf6daXXzQ0BYN07PVGej2tbmYuyP6sBqNBrzAcMOGdDWBJz3HiXtAHRTCkJHXM5tSVOHxTOVFIZboK3qkmZA8oYVM3U9WxqeYiDKph+hZq9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVxf1VGS+uoGq2fbxAKAS8li91QhUnfjNiTBS8FxwP0=;
 b=M+h+w6Gzkh+cYm5vHkoAK38dj5mF1pYBZW0jB5YVJMsvTahw+aQrlkGo4AobUo/lErFUV69ntdkpJwBiply/yCtBos0gNP3WN3QcYDemSbG6rk1ntYLixGBW2pn62YUZODqluEQWYiPrtCcK+iAxYyjvC9c+cDwrYH6KelHhLJIyFJwPiwCfhPlEcRm6FX3BpEtqqXvRpO/+FmGJp9Pm9cK02Jcep6haZN2XHL13aLF3vGOpXSb27Vge+3Y9XTWi72+n4wGIDuEQJHRixAReg1UP+Wr50DKNkzb+DnppJ+2383Sdoi7AVk/OY+NUtJyWzAkVTWwsNV+Mfst8xp527A==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by MN2PR12MB3503.namprd12.prod.outlook.com (2603:10b6:208:cf::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Sun, 14 Aug
 2022 07:32:06 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::e041:11a1:df43:9051]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::e041:11a1:df43:9051%7]) with mapi id 15.20.5525.010; Sun, 14 Aug 2022
 07:32:05 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "mayflowerera@gmail.com" <mayflowerera@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: RE: [PATCH net 1/1] net: macsec: Fix XPN properties passing to macsec
 offload
Thread-Topic: [PATCH net 1/1] net: macsec: Fix XPN properties passing to
 macsec offload
Thread-Index: AQHYq9ruGCDIPYrNQ0GGZiS3Gkvceq2p5kuAgAQg3cA=
Date:   Sun, 14 Aug 2022 07:32:05 +0000
Message-ID: <IA1PR12MB6353673BC6106F004B128267AB699@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20220809102905.31826-1-ehakim@nvidia.com>
 <20220811092543.696a5ef2@kernel.org>
In-Reply-To: <20220811092543.696a5ef2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 055f8eb3-1ca6-4a11-2c18-08da7dc716ab
x-ms-traffictypediagnostic: MN2PR12MB3503:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o39Ezdi/PY1B69z7NXsblQEnzpkqKQFaiVxz735e7cdkB5vSwrd1+m0dBGsJbR+CyeFDILbDJ2bCAm/EK4+aOkfvPe6XCvSmETysc7nuRJaLRbfjWhE5xVH/lXp1ZjGaHH+KzbffvhEFGbPmfJZQDYQDJMiwcVNk6qBk3K938Ap/0rZnRbSwGk6Kc2VqAPVPifKhF82jkYH64/OjLSNboQG6eOwypPn7dmCrd7HbNJvlVvDPXQw8KULKPtmTmXUwK5nBJPCPnIlhHiW7MpIYdkZ8nQPQltuvCiydehIqbH8A72YPonvnRAS76ylf2dX3ESmtFh0QQBo7aFNCUYYzKC/BlC1v+Ntg2mGkf4DKHIO6dkEQF1Pw4daWEaCImv9XIucnu5BJrwBWhagQ/Wla/n73IcHnn15HkHn7W58Sk4ra/pHrrjneKiYuInkI0lx/7Auz3MYAfpQ7U0u0fCUBA8LK1DJ5B2cQMLnOF6Pk0QExx8IJShDpw7fT2A1bykF1A9Fft8ui+y8OxpN0EFiQ8eDBGU56JFyAxjQYRBnp5+gzzFB1ZGT66P1bqyMP/l+VMu5JI7FKN5Y/iftmd30NLsOE9TaWafZ4rUOxWYhTnv/XnO9LsTJ3nKxi/JRR3fwZfhhnxQK+3G/zUtlEi8NHXRrYMHP901WoicseLNFXxSDBrE842CjV+Uyn1l4MPAMJ4gyZTm/kHdBr1xgFtY2KM7ZX7/IVeXBU+ME6bjYELg+TOHDtZyoDLsWruRyq3iU39VVccMABujrEuspDLWX8kLoizn6Zyabj5O/8kXMcNo7VqdTmoUNl7ASbcZhOfmVL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(478600001)(66446008)(5660300002)(2906002)(64756008)(66946007)(66476007)(33656002)(66556008)(122000001)(38100700002)(38070700005)(8676002)(52536014)(8936002)(9686003)(7696005)(6506007)(55016003)(86362001)(26005)(41300700001)(107886003)(83380400001)(71200400001)(53546011)(54906003)(76116006)(4326008)(316002)(186003)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUFPdUJIQjlqcW5TTXBIbVY0QzE0akROKzluMlI3RG1Rd241cWFhNVNHWFh0?=
 =?utf-8?B?VnJTRWN4NDRyUUNuaitQc08vcTh2Q3RqeWcrbWhBK3JCRm5mQmpEcXAyelZP?=
 =?utf-8?B?U0c4U05LY3FBSEpTTzR2T1FqbmpoRTZ1L0MwVmlZN25CWkFoUTgyUzNsSUdX?=
 =?utf-8?B?NmJyV09wL1VNUnNEUS9zN08xODZUK3FON3F0ajBhOTltcVJZU2E0VGtoeHlX?=
 =?utf-8?B?OTRsb2NzU001TzhDLzdWNWFxdUNvK2ZGbzJzZE1yRk9WbWdyNmtJbGkvR3ZT?=
 =?utf-8?B?L1RhWWN4WS8vMW40L045NTh4bjVNcmV0a3dzNDg2YmNhNGZDZE4yUlZ3bzBl?=
 =?utf-8?B?dGwwNEZTdlFMRS93RUJ6anQ1L2JHQU9OYjE1UFZ4K3k5N3pIOHZQMzRWU2dy?=
 =?utf-8?B?eEl6ZUR3U280VjArUFdUK0lWRFpSRTJIbWlYZ1ZsSUpVK252VDZmK0RPdTVw?=
 =?utf-8?B?OUxTbEZqa1ZxZUlsNElSRyt4TVNEWjdZVnA0dDR4S1BwaXVScCtQYUVvL2tE?=
 =?utf-8?B?UURhYW4zb2lSa1dnZjNOQUs4dGluWE5sd3VJa1J3akcrb1BOSHh3dVJObDMx?=
 =?utf-8?B?Qkt5K1BhYnpvZDRMN1B5ZGRObUI5YnBMUWZISm9sT2Ixc0JERTBxQ3BjMEhp?=
 =?utf-8?B?UCs5V3F3dGlHMzJsZ1grWjRwRnJIbzVOMDNZa1dBb0ZZNlNUNWZRdXllZEJH?=
 =?utf-8?B?R21laDlaYXJzRVVHSTRIZFhYMWRicHBtTTE0UzFQbS9ZVFpnc0dQVHZSQzZV?=
 =?utf-8?B?OWV0U28zWkU2bjNDTlpsZk9hNEZHYmcxWktBR3FNeHhJVlJQUVY4amlSRkg1?=
 =?utf-8?B?bCtBQXNZRUdIcWVKRHZ1RzdxaTFrSEZvTGpWTUhNOEhnelEyVGdLUHQ2SDhD?=
 =?utf-8?B?RDF4bXU2dWZTRVprbEk1MnF5SElUdlEzZXlCdzFZTVg2aGFnWWpHYmVNQTBY?=
 =?utf-8?B?Q0F0NS9PN1d4S0JQUDlQYVRYajcxMnJ4bVhWM3k3VnQvd1UyK0NIUktzQmFL?=
 =?utf-8?B?LzhMNE5XeTM2RUhVL0Zuc0hQVnVpTVF0RFhHVFZPbkQ0dCtiR3FBSytnN0Jt?=
 =?utf-8?B?KzRSR0dLSmMrdXVHNEwvem5ZWGhpN09HZkVTUm9kZWorM3IwRE5NRlJGTXY4?=
 =?utf-8?B?T2JLS0IwQXZiNnlhWWlpU0ZRcWZQdWdabjdyRE9NcTltRytReW45TWxrNkkw?=
 =?utf-8?B?d1BzNmdPSWRhZlF4bTRaemlOdjZSV1JzSVFlSU5QbGt1V2VaRVBwVHJpNHZJ?=
 =?utf-8?B?emk4eHR2Yy9rVGRpUExUNm5rTzJTczgzbFlMZTNiK3c1NkdSMTNHK0hOVXVh?=
 =?utf-8?B?THFKV2E5alZYY0pScWcwVW80ZzlGVlN6TGVoWW5qaWI2ZkNNNmVrK2FNSFF1?=
 =?utf-8?B?Y29uSU12VW9yWGZmeURzSmZmQkM0c1RZUHVqcE91THgxRGtXbTgvUGcrdEwz?=
 =?utf-8?B?OU9nbkM1M3d4WGxWejRXU2tPN3B5OGFRNWU5TzJOSFJUWDNHV0FlNm1FdWMy?=
 =?utf-8?B?SEhudThhT2NZLy93UGk5L09UaWNSYjBaUGR4NHVKbG1JR0J0M3pId1JUbWRx?=
 =?utf-8?B?UTk4b3JxRXZZTG5yTXg4ZlV4L2dETGRZVkt2dmxXQXFVOEVBR2RrS2ZzQWw1?=
 =?utf-8?B?bmhsZGViSEh0WHBNNGpWRzlHd3JTRFNvMzBwM3FLcEFsZCtUMnIvQ3Fjajhi?=
 =?utf-8?B?Z25ScFVKUllmaFEvbVA5Z3N3VjJzSFY0ckJUUHBKeXkwSXNRd0NiTHJmZmxl?=
 =?utf-8?B?eDY1SWNmK3BodlZRQTVaYWZVQTFNSEtuM1MxWVhpdlBEZVdQelZXdGR5T0dO?=
 =?utf-8?B?SlVsdE9FZUIvblVHSGcrKytybEhDV1hXQXZScTNiak0yajJRTmx1d1ZOa3pW?=
 =?utf-8?B?RUYzdEdGVkhJVkdTS3VGQzArZFRPcDhMdzQwNjZqN1YyUG1oS0ExN0R6d3Fu?=
 =?utf-8?B?bHhFRVVaT3RtQjRMWWZUYzJsWUdRSFdoVDExMkdpOU9FOUVWdVhZQVRnWkoy?=
 =?utf-8?B?bmMza2dVVjUwM2NyeXBmWS9rNVplaUlYb3d1dkZrSk96K2F0L242M204MlpB?=
 =?utf-8?B?VVdpdHQ4eEpLUkFWcEpoSUVJVzdsbnBaa2xQTy9TWnZtNExJck1jaEpZQTVs?=
 =?utf-8?Q?9Kl4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055f8eb3-1ca6-4a11-2c18-08da7dc716ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 07:32:05.8002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCKftWWear2P9g7l9DNKWAJEtk2hYKYAkOicmChpU/q+Gz64d2dqfdJk1scZejkyIN3ksVxirQXyp2wS9Zp5Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3503
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIDExIEF1Z3VzdCAyMDIyIDE5OjI2
DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBlZHVtYXpldEBn
b29nbGUuY29tOyBtYXlmbG93ZXJlcmFAZ21haWwuY29tOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4g
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgUmFl
ZCBTYWxlbQ0KPiA8cmFlZHNAbnZpZGlhLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQg
MS8xXSBuZXQ6IG1hY3NlYzogRml4IFhQTiBwcm9wZXJ0aWVzIHBhc3NpbmcgdG8gbWFjc2VjDQo+
IG9mZmxvYWQNCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1dGlvbiBvcGVuaW5nIGxpbmtz
IG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gT24gVHVlLCA5IEF1ZyAyMDIyIDEzOjI5OjA1ICsw
MzAwIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+IEN1cnJlbnRseSBtYWNzZWMgaW52b2tlcyBIVyBv
ZmZsb2FkIHBhdGggYmVmb3JlIHJlYWRpbmcgZXh0ZW5kZWQNCj4gPiBwYWNrZXQgbnVtYmVyIChY
UE4pIHJlbGF0ZWQgdXNlciBwcm9wZXJ0aWVzIGkuZS4gc2FsdCBhbmQgc2hvcnQgc2VjdXJlDQo+
ID4gY2hhbm5lbCBpZGVudGlmaWVyIChzc2NpKSwgaGVuY2UgcHJldmVudGluZyBtYWNzZWMgWFBO
IEhXIG9mZmxvYWQuDQo+ID4NCj4gPiBGaXggYnkgbW92aW5nIG1hY3NlYyBYUE4gcHJvcGVydGll
cyByZWFkaW5nIHByaW9yIHRvIEhXIG9mZmxvYWQgcGF0aC4NCj4gPg0KPiA+IEZpeGVzOiA0OGVm
NTBmYTg2NmEgKCJtYWNzZWM6IE5ldGxpbmsgc3VwcG9ydCBvZiBYUE4gY2lwaGVyIHN1aXRlcyIp
DQo+ID4gUmV2aWV3ZWQtYnk6IFJhZWQgU2FsZW0gPHJhZWRzQG52aWRpYS5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiANCj4gSXMgdGhl
cmUgYSBkcml2ZXIgaW4gdGhlIHRyZWUgd2hpY2ggdXNlcyB0aG9zZSB2YWx1ZXMgdG9kYXk/DQo+
IEkgY2FuJ3QgZ3JlcCBvdXQgYW55IHJ4X3NhLT5rZXkgYWNjZXNzZXMgaW4gdGhlIGRyaXZlcnMg
YXQgYWxsIDpTDQo+IA0KPiBJZiB0aGVyZSBpcyBub25lIGl0J3Mgbm90IHJlYWxseSBhIGZpeC4N
Cg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3LCBhZ3JlZWQNCndpbGwgcmVwb3N0IGl0IHdpdGggY29t
bWl0IGFkanVzdG1lbnQgdG8gbmV0LW5leHQgYXMgcGFydA0Kb2YgYSBtYWNzZWMgb2ZmbG9hZCBz
ZXJpZXMuDQo=
