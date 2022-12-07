Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F4F645E02
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiLGPwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLGPwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:52:18 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A723AC14;
        Wed,  7 Dec 2022 07:52:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZKFH+FkkawndUUsZGWdl2ZiosgjBYXkUbrz2OtWvBNW00dSyZN5+No8qPFQQb4ivZqXFAqp/HkzToZce/UFKkoxyKW3wpyHoIxFPGCZMNUBlpbWfC6eTz3nj9CuYvGznkEZvqRKe/W9UpPIkbor09INokkem6Tkdf1Vql/4zeEBvML9A+sUCFCPW3U1vIThCnaBolDYQnAlTAazM1hEMlqXVRgUnTIRmHMc6sGC3F3pzN7VzIcRuQsvCPl0tgYEkjgToEMQUWC0heUQgXD4nI9p50xG6Szf4jnLxi/07I7AisNjAMDTxfWQ2TRuc+62Z7lXE2qEUNEiIftrORVSEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VaYSrhp+tLqORvLDXURqyvvsNZHf8dYkPxLjHCnBrQ=;
 b=FYysq/QaBoMQhnWOfiZLhYWHQJPFW4gIvGUeXVQfgQnYkeRJJCHWhDGXu9EEahKv5Zlm4qHDpeu0GJIPyU7WhDzGpqc69RHDFveZImEzgEXKHlpobZc88fbOnzYVWOfkoJd5ALAGzks3MttRwQgUo4UNkeKiurn79Yy0n2zKE6upZCZKkw592flT6STRIMKDVeyBYlEtSj6UWJOaHRG6j1BdD8g6Lelgnx95AGaaNT1T63yoAexKKREVxAxVzdFXaunZ5UUb8bxRzjSJusmKkBBBbBpSeKLAHTpRmi4an/6OlfmojEhOGScfgv0eTFG3YwBbwUp3IpiX1efy2gjgWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VaYSrhp+tLqORvLDXURqyvvsNZHf8dYkPxLjHCnBrQ=;
 b=EObiS3EXTfaY1DFnQlQH4ZSmwRYAPLJ+6ODZOby5Grlhlqxu7erkdTSK4/Ah+Xl2zPTQ3Ow7oGqy227ksxkIwod5eOedKe8BY24bGT+Ciw7Vdkl0EnvmsdeUhITo8b+WI8rFvem7UdcJU8UNzONTiw7BhRCbDLe0/HuowXFGh0OlpxJIhWIq9dCylKbKBbbf2E6DboJwHF/7wpVH9rOWEg6iCCqHB/PVOZoPt/M7i76PmUc9aiuqOd80GdtOYUYbmq05Mt6NnxwYsCQetut8Umifesp2L3W9mdWfj05awiYa0yq2N6Sf87F4tiHq3Wb4lIq4oEdNPXv2FlydHGThIw==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DM4PR12MB5071.namprd12.prod.outlook.com (2603:10b6:5:38a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 15:52:15 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 15:52:15 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZCiQusL+UzHu/8U2fyvKlL6owS65ikZoAgAAA31A=
Date:   Wed, 7 Dec 2022 15:52:15 +0000
Message-ID: <IA1PR12MB635345D00CDE8F81721EEC89AB1A9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221207101017.533-1-ehakim@nvidia.com> <Y5C1Hifsg3/lJJ8N@hog>
In-Reply-To: <Y5C1Hifsg3/lJJ8N@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DM4PR12MB5071:EE_
x-ms-office365-filtering-correlation-id: a47dfcea-4d38-40dd-59a4-08dad86b0366
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xBkhNJD75GXfF7oixL8FdpAYzoJLILSl5Y8IjNQUlHPxDIlxvzwESEvjbsOBodYeLZO7kaGnPfpY5gZPJSdRKOO9sY4knKnbaWeWg9fMFpx5ESTyT/qepjlhJ4XCwDL3ZSDK9BsiLtZzr6hodi7LxuZAqJNwH/hocv6DedcdaRA9/F629DKIPVLdrdfPbFmH8CF/+Y4U+X2/R+0Pqe+f7aizj6/VoU31yhz/lo0DFwXGhAKeL4M8/KOKXZnVi6NfPpB0u7sN/l9k/0lTCGygzDafIozITPUsw1STVx5WCLLiCVvixqZFc5+aMP5qYRYBYVaUlnlro5kvkucSXuD4A0wX620zLoonB9mmow4vBdRY6s3yJ3zTtRvB4rMJ2EdMYshUzwNV2gJagnFA4DFmxH+uoj5Dnv/a20yali/GCJhJ1cy7QwFvz1saokA+hy1H35umgkl1t+SLDV0ybDvrlOejKySnX7It/6fb2DTLWCnannLRQ4r/tw4MScLUSeB0o/VJ7hTJTRvs8LWpYdaJD3YkfVapYYNKeb89md8QnCyK4RnGXsLpXVCaOg7xlVXpj0lYPAJhHH0zDC9+TzEiGESg+N82QBp8Snld/PXF8WzPZ62c6EYUnyXUTujg/EM7ZcrbsXm42gJ5RTqDiKWId8rc0ZoAEyD1U2X2+CqyjfFmC8SMNNqghRHv3fwN2W1exmrwQot3/OVrVStqyhAWRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199015)(83380400001)(122000001)(8936002)(86362001)(2906002)(38070700005)(5660300002)(4326008)(41300700001)(33656002)(52536014)(478600001)(186003)(55016003)(26005)(53546011)(7696005)(64756008)(9686003)(6506007)(66946007)(8676002)(66556008)(6916009)(76116006)(66446008)(66476007)(54906003)(316002)(38100700002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STcyczhxWVNwUE5qUzFnNkR2QVRQT1pFMGt0NC93Qy9PRUl4MlJRYU8wWlhE?=
 =?utf-8?B?WTM2MXk2NFYxZGx0Z210OFhJT1MyMlFJZW9Zc09NejZ5M21XNmtTZEg4bHNr?=
 =?utf-8?B?MG12NUpwTHVCWHNxT2diL2ZtaGgvZnZxSm9qK0VlU2RuRU9aaWxlRjBNVllv?=
 =?utf-8?B?MXExd1NVbHUyb2xWa1B2N3BkKzMwNi9pZ2J5VFpoMmJRczkxTDRlR0FGazNz?=
 =?utf-8?B?aFZ5TzZIM3hWUmFKdFFFem4ydi9uVHVzUTV1UUw3WDdobUFrTHdDcFdUSUFL?=
 =?utf-8?B?cEVNWUNnb0YrQjdxZTl3MTFzUVdqZlEzOGlsK2l0S3FoeWZxYktRUGpYdjQz?=
 =?utf-8?B?L3MxeklkNFhqMG5uTnpjeTczU2luemdmenk1d2Q5aEdqOENMb2FXbjNTTUth?=
 =?utf-8?B?TmNUdkJXMWRoSTk0ZWZUZVJVaHhrTkNpcnJPc2k0WEZIVkE3T042S1V1RlA1?=
 =?utf-8?B?STZrdEtoUFBXLzg5c3Zwa0QxREJ2L016dHZURTFOaUdKM1RXRnR4UUFVSG42?=
 =?utf-8?B?UlRsOXY4VGxLbXNYMTdyMHQweTd6ZW1xQmd4ZnBGRmxjMUk0SXo5cEduN0xp?=
 =?utf-8?B?dGV3U2NLaklJaXdWN0FXcmpTd29GeHYxbFpmWi96Qkg1RmZJSHJ0aFFTVW1t?=
 =?utf-8?B?R1QrSklCWHArZlpFMllwWnNtUzErOGxoN0d0bTlqL05zRE5ZRkl1OTNHNFQ0?=
 =?utf-8?B?dmtSd0MyY2RhMXE3eHd0NlU1Rk5BYmpQakN4Mlo3VlplTk5mQ3ByMHh1R3ZR?=
 =?utf-8?B?TjNPdlExOHdTeTRQc0JDUUsya3JUMHpaMFd6ZjRsczRlcXZhTkp0ZDNUK2Rx?=
 =?utf-8?B?K3RuRmNTaUZ3a1VYeWVMUGxzcEd1UU5Peldpc2Y4aUVhd29aaERaSm9UNC9s?=
 =?utf-8?B?RDJDWWNoaVAvU1JkdWQybWxaOGFBQWtmTzRyUFptMnJ1Q29NVG5BR1BSOVZX?=
 =?utf-8?B?ekdtcGlCMnlXUjZkRFRCZjh3aUluQTNhbXd1NkRZalhWQkp6czhONTdaS1hi?=
 =?utf-8?B?bCtDVFFWLzVwNlJZbHYxdFBwSllYeXBxeE12c3o5Y2pJYkhMR3ZseXJYK0Zw?=
 =?utf-8?B?b1JkREFuT3FCZHJNQnNxWWp3cVF3VkEzWW8vNm12YzBpcjR2ODFQVWhKbjc0?=
 =?utf-8?B?YjRvNXJ3TzI1Sk9TMkJWa2V5dlpOclpFUzhVakY5YzByTjA3T0l0VDl4aDhj?=
 =?utf-8?B?NmdtSm9KV3A0ZnJUWktOMnhZZ05nNStROW1GUFc1d0ZUSGJyNE1IbEZiNUlt?=
 =?utf-8?B?V2o4RFlVS013bzBOZ3FydFdJTU9CSXY3Y1NYSGxNRGgyN3ZpRWFTWStBWVJT?=
 =?utf-8?B?bmk0dk5lOW8wWDAvcWVMWHFmaHd0bUlBeHNPTXJoOTNzTEp6MThTWEtUYW9P?=
 =?utf-8?B?TXNqRkxHMnpWcE1zRnFNWnZSWURzSVlhQmpvQTU5NkhwQUsrODNKWG0yWmtJ?=
 =?utf-8?B?N1dqYk5jTDBxbzRqWWNWTFlDME8zc0NYaHB1R25JSksvVUZmb0JjMTQ0M3h5?=
 =?utf-8?B?cmFHNkl2YVcrWWo4TWtWYkFPNjU4NU1zZjJPK2Y1eExmTmsyM1JUcWFsc0Fl?=
 =?utf-8?B?RGVTb01zbTBXY1p4d3VwWEpUYVF3TUNUSTB5TGRSU2FDbVVnTGQ0cnpQYVlm?=
 =?utf-8?B?Rll2amZDREpHV2tQaTgwLzhCem1LRUdmYThQOXFFTk1xY2ZOdTFMcTRNVkNn?=
 =?utf-8?B?aGFqU1BzSHNiUlBldWUzNFRhdFFYbmZ0aUxIcmsvbWpQU1d0TDJJU1ZxYU5O?=
 =?utf-8?B?Zko2VFVndlZEdDNsRVJwWlpUUTA1Q3ZXU0wzQTg0WXNoRmtYbFV5Qm5jcW5n?=
 =?utf-8?B?RHZ1bFNQaDZZZjVQUGtucjE3bmNjNVBOdGlpZEoweXRNSDVQR1lKZnBDRlp4?=
 =?utf-8?B?cCtaTkRPOGN1NFlMSkFkbkpoVEN5OTkrYk5GUW84YkNBb1FFSHlhaFl5eGky?=
 =?utf-8?B?N2ZPWG9VeFZvaVpWRlJpMFpsR1pLMXRkcUFNZ1pwMExsVityMDIydDVNSXFh?=
 =?utf-8?B?ejhvR1hwR3F1OWdEcFdzbzRzcTRYYVJPcFpCNFV3TzY4Vkllclh6ZGMra2tY?=
 =?utf-8?B?Q1NwcUJOajBlVXZXTXFDemhrUGlkRXZsSTZlSTIxODI2cUVZRkZWc2hpL0th?=
 =?utf-8?Q?oWV4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47dfcea-4d38-40dd-59a4-08dad86b0366
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 15:52:15.6017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KX0qWMUV8kPtmVVtQy4mpH+JFI2lnBu692aVNJvYS5WYXWFc8kFzcvh9qxA8UPsGJZyYXIi8etHuXJjOy97RmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5071
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFdlZG5lc2RheSwgNyBEZWNlbWJlciAyMDIy
IDE3OjQ2DQo+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+IENjOiBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPjsN
Cj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwu
b3JnOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYXRlbmFy
dEBrZXJuZWwub3JnOyBqaXJpQHJlc251bGxpLnVzDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0
LW5leHQgdjMgMS8yXSBtYWNzZWM6IGFkZCBzdXBwb3J0IGZvcg0KPiBJRkxBX01BQ1NFQ19PRkZM
T0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+IA0KPiBFeHRlcm5hbCBlbWFpbDogVXNlIGNhdXRp
b24gb3BlbmluZyBsaW5rcyBvciBhdHRhY2htZW50cw0KPiANCj4gDQo+IDIwMjItMTItMDcsIDEy
OjEwOjE2ICswMjAwLCBlaGFraW1AbnZpZGlhLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBFbWVlbCBI
YWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+ID4NCj4gPiBBZGQgc3VwcG9ydCBmb3IgY2hhbmdp
bmcgTWFjc2VjIG9mZmxvYWQgc2VsZWN0aW9uIHRocm91Z2ggdGhlIG5ldGxpbmsNCj4gPiBsYXll
ciBieSBpbXBsZW1lbnRpbmcgdGhlIHJlbGV2YW50IGNoYW5nZXMgaW4gbWFjc2VjX2NoYW5nZSBs
aW5rLg0KPiANCj4gbml0OiBtYWNzZWNfY2hhbmdlbGluaw0KDQpBY2sNCg0KPiBbLi4uXQ0KPiA+
ICtzdGF0aWMgaW50IG1hY3NlY191cGRhdGVfb2ZmbG9hZChzdHJ1Y3QgbWFjc2VjX2RldiAqbWFj
c2VjLCBlbnVtDQo+ID4gK21hY3NlY19vZmZsb2FkIG9mZmxvYWQpIHsNCj4gPiArICAgICBlbnVt
IG1hY3NlY19vZmZsb2FkIHByZXZfb2ZmbG9hZDsNCj4gPiArICAgICBjb25zdCBzdHJ1Y3QgbWFj
c2VjX29wcyAqb3BzOw0KPiA+ICsgICAgIHN0cnVjdCBtYWNzZWNfY29udGV4dCBjdHg7DQo+ID4g
KyAgICAgaW50IHJldCA9IDA7DQo+ID4gKw0KPiA+ICsgICAgIHByZXZfb2ZmbG9hZCA9IG1hY3Nl
Yy0+b2ZmbG9hZDsNCj4gPiArDQo+ID4gKyAgICAgLyogQ2hlY2sgaWYgdGhlIGRldmljZSBhbHJl
YWR5IGhhcyBydWxlcyBjb25maWd1cmVkOiB3ZSBkbyBub3Qgc3VwcG9ydA0KPiA+ICsgICAgICAq
IHJ1bGVzIG1pZ3JhdGlvbi4NCj4gPiArICAgICAgKi8NCj4gPiArICAgICBpZiAobWFjc2VjX2lz
X2NvbmZpZ3VyZWQobWFjc2VjKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+
ID4gKw0KPiA+ICsgICAgIG9wcyA9IF9fbWFjc2VjX2dldF9vcHMob2ZmbG9hZCA9PSBNQUNTRUNf
T0ZGTE9BRF9PRkYgPyBwcmV2X29mZmxvYWQgOg0KPiBvZmZsb2FkLA0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgbWFjc2VjLCAmY3R4KTsNCj4gPiArICAgICBpZiAoIW9wcykNCj4g
PiArICAgICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKyAgICAgbWFj
c2VjLT5vZmZsb2FkID0gb2ZmbG9hZDsNCj4gPiArDQo+ID4gKyAgICAgY3R4LnNlY3kgPSAmbWFj
c2VjLT5zZWN5Ow0KPiA+ICsgICAgIHJldCA9IChvZmZsb2FkID09IE1BQ1NFQ19PRkZMT0FEX09G
RikgPyBtYWNzZWNfb2ZmbG9hZChvcHMtDQo+ID5tZG9fZGVsX3NlY3ksICZjdHgpIDoNCj4gPiAr
ICAgICAgICAgICAgICAgICAgIG1hY3NlY19vZmZsb2FkKG9wcy0+bWRvX2FkZF9zZWN5LCAmY3R4
KTsNCj4gDQo+IEkgdGhpbmsgYWxpZ25pbmcgdGhlIHR3byBtYWNzZWNfb2ZmbG9hZCguLi4pIGNh
bGxzIHdvdWxkIG1ha2UgdGhpcyBhIGJpdCBlYXNpZXIgdG8NCj4gcmVhZDoNCj4gDQo+ICAgICAg
ICAgcmV0ID0gb2ZmbG9hZCA9PSBNQUNTRUNfT0ZGTE9BRF9PRkYgPyBtYWNzZWNfb2ZmbG9hZChv
cHMtDQo+ID5tZG9fZGVsX3NlY3ksICZjdHgpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgOiBtYWNzZWNfb2ZmbG9hZChvcHMtPm1kb19hZGRfc2VjeSwgJmN0
eCk7DQo+IA0KPiAoYW5kIHJlbW92ZSB0aGUgdW5uZWNlc3NhcnkgKCkpDQoNCkFjaw0KDQo+ID4g
Kw0KPiA+ICsgICAgIGlmIChyZXQpDQo+ID4gKyAgICAgICAgICAgICBtYWNzZWMtPm9mZmxvYWQg
PSBwcmV2X29mZmxvYWQ7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiByZXQ7DQo+ID4gK30NCj4g
PiArDQo+IA0KPiBbLi4uXQ0KPiA+ICtzdGF0aWMgaW50IG1hY3NlY19jaGFuZ2VsaW5rX3VwZF9v
ZmZsb2FkKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+ID4gK3N0cnVjdCBubGF0dHIgKmRhdGFb
XSkgew0KPiA+ICsgICAgIGVudW0gbWFjc2VjX29mZmxvYWQgb2ZmbG9hZDsNCj4gPiArICAgICBz
dHJ1Y3QgbWFjc2VjX2RldiAqbWFjc2VjOw0KPiA+ICsNCj4gPiArICAgICBtYWNzZWMgPSBtYWNz
ZWNfcHJpdihkZXYpOw0KPiA+ICsgICAgIG9mZmxvYWQgPSBubGFfZ2V0X3U4KGRhdGFbSUZMQV9N
QUNTRUNfT0ZGTE9BRF0pOw0KPiANCj4gQWxsIHRob3NlIGNoZWNrcyBhcmUgYWxzbyBwcmVzZW50
IGluIG1hY3NlY191cGRfb2ZmbG9hZCwgd2h5IG5vdCBtb3ZlIHRoZW0gaW50bw0KPiBtYWNzZWNf
dXBkYXRlX29mZmxvYWQgYXMgd2VsbD8gKGFuZCB0aGVuIHlvdSBkb24ndCByZWFsbHkgbmVlZA0K
PiBtYWNzZWNfY2hhbmdlbGlua191cGRfb2ZmbG9hZCBhbnltb3JlKQ0KPiANCg0KUmlnaHQsIEkg
dGhvdWdodCBhYm91dCBpdCAsIGJ1dCBJIHJlYWxpemVkIHRoYXQgdGhvc2UgY2hlY2tzIGFyZSBk
b25lIGJlZm9yZSBob2xkaW5nIHRoZSBsb2NrIGluIG1hY3NlY191cGRfb2ZmbG9hZA0KYW5kIGlm
IEkgbW92ZSB0aGVtIHRvIG1hY3NlY191cGRhdGVfb2ZmbG9hZCBJIHdpbGwgaG9sZCB0aGUgbG9j
ayBmb3IgYSBsb25nZXIgdGltZSAsIEkgd2FudCB0byBtaW5pbWl6ZSB0aGUgdGltZQ0Kb2YgaG9s
ZGluZyB0aGUgbG9jay4NCg0KPiA+ICsgICAgIGlmIChtYWNzZWMtPm9mZmxvYWQgPT0gb2ZmbG9h
ZCkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ICsNCj4gPiArICAgICAvKiBDaGVj
ayBpZiB0aGUgb2ZmbG9hZGluZyBtb2RlIGlzIHN1cHBvcnRlZCBieSB0aGUgdW5kZXJseWluZyBs
YXllcnMgKi8NCj4gPiArICAgICBpZiAob2ZmbG9hZCAhPSBNQUNTRUNfT0ZGTE9BRF9PRkYgJiYN
Cj4gPiArICAgICAgICAgIW1hY3NlY19jaGVja19vZmZsb2FkKG9mZmxvYWQsIG1hY3NlYykpDQo+
ID4gKyAgICAgICAgICAgICByZXR1cm4gLUVPUE5PVFNVUFA7DQo+ID4gKw0KPiA+ICsgICAgIC8q
IENoZWNrIGlmIHRoZSBuZXQgZGV2aWNlIGlzIGJ1c3kuICovDQo+ID4gKyAgICAgaWYgKG5ldGlm
X3J1bm5pbmcoZGV2KSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+ID4gKw0K
PiA+ICsgICAgIHJldHVybiBtYWNzZWNfdXBkYXRlX29mZmxvYWQobWFjc2VjLCBvZmZsb2FkKTsg
fQ0KPiA+ICsNCj4gDQo+IC0tDQo+IFNhYnJpbmENCg0K
