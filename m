Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79D5648183
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiLILTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiLILSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:18:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCD870BAD;
        Fri,  9 Dec 2022 03:18:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJHEUfYQ0sJlXdU0GDA6oN2Qa175Gstw0O5HLNfS/kS/7pBtwNUIqTMXdooCqLi6BYtwaiFjRATc1sjdUKN1FvF5bABp8gwaF7LTCRTyMODrhdOYsR54Wv0UD72FISqEE4a9Ttqmj8ler0HcWjFNWfeHQnm0YK75VxxOFpHzwHJuN6AGcEXU52ibJGeJNlrN9lOy4ii3G0jkdwS7+vScIzLicsAEhkukf7yWTgDwpp/J02OHHx3xNY7b95yhy/zBYAbkIandf8zN3d2IJJK2iLe4/aXI+xXDhol87XfU0Zn+29+EoXxLPPoLzSB0aqtnCA24dh3rBJT2xQauCedNiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4pOQs7rM5zyhpoUXyj5TvrLbnraFOwPccWBVb6DMNA=;
 b=dCmffc1O+/bHXk1oSpFHw+DE6vgSWGFf+Bd6H7K1t4jyNfRvTJiZNgLMqeXQOM/jOZdamoszVZgBiUS2OsFqv2NR/rINpbnuUskkeHlOrCkCJim/RC+lTv6fm5RYyQkr0hL2O5MICWHuqTque/e1XLlDSrG05HJlZavHcFIYguYHLBwyAs5BqhLooGZa5PR7rWQQ3FQX0vy8VzO7VToTqqAblsZOAc6gVNgBQmWoYAW2PcrTzUEbq+4Zn3aPuprypPziHTCQEUbmLbepVPM0xvLgsUSAKFCAuiIGgcko86Fy0BGHQoGBUmfSZmyJMTVnMyNjnOaYyDZymyVEYXIDQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4pOQs7rM5zyhpoUXyj5TvrLbnraFOwPccWBVb6DMNA=;
 b=LSBpXrLM31BFm1PyTdARAun915/UngSMY5lrgH5jMcvGCGtVIPm05NHuqzhb7g8oO4lub/G5YLkC/GIxsD3OPnufGdZvyXDbxsHXwrcv7NpA4iX1ejOAoJ2d0jcG2jA4niiSZMiV+T/SlDnWibrekb6nqmd5cCdL+4OHQ412bQYz8J9TUPxb5wzh4O707cmrJZXli/C3xFatDBZTcWNFL00YMU1ZZwTz2ZocG2RBlbL5cfNNnye+eZh4r6fwHkaQoI+ROsDp81YmcK525RovSLw/bjFFtX+FczeFqvg8O03QG9CrptXwF+ygBKvmnA2ypJrs6l6+yJo9Tw6L+IREvA==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SN7PR12MB8147.namprd12.prod.outlook.com (2603:10b6:806:32e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 11:18:25 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 11:18:25 +0000
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
Thread-Index: AQHZCvv/CYvpmkSg7ESdruoP4MuPZa5k1xAAgAAAMYCAAH2hEIAAFMjg
Date:   Fri, 9 Dec 2022 11:18:25 +0000
Message-ID: <IA1PR12MB6353ED5F4DAA71B81C4B4481AB1C9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221208115517.14951-1-ehakim@nvidia.com>
        <20221208183244.0365f63b@kernel.org> <20221208183325.3abe9104@kernel.org>
 <IA1PR12MB635381D5C6C3ACE64763C8D6AB1C9@IA1PR12MB6353.namprd12.prod.outlook.com>
In-Reply-To: <IA1PR12MB635381D5C6C3ACE64763C8D6AB1C9@IA1PR12MB6353.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SN7PR12MB8147:EE_
x-ms-office365-filtering-correlation-id: 22cf7487-abd2-4a57-f4fd-08dad9d7170a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TQ1Kq70S2+LGTCnpQMvO/ms81eHyyFv8LEn6J2Xj9udqmb2J20Uhc4fNBvEM6Dvjo02yXIfoaROtuKR1s24KtcMMITIOcencRyAKLpe+gvDxb1a7GB7sjc8DkqiAxF18Vxdc6hx1Dyn+NhybFlFG1kX6FbVOB5gF6Sse03kDIyXkDsTdRu70RlB+ZDlX+sMlbXLlQKjGp7zfSckuq3zJ+XJ/AfMm1EfYuYgcl5dZ41ut9lJM2VlrvC40PS4D1nj64X7uMoaXFJXAO0fh1tlDreSzHK97cPfLMROHvd6keDEaka/0sCz6xbi3ia0ihG4CIvLsz2VMgBOA6A3LiFVPGm5NLxHF/xdnGECyL/6vn46xTAWX2Ub2G6tWlh5VcVLfzB1ONq+uvolpJsCVdlokjGWe58If7IyPHzbocNUuO5AYBLHmwdTB4cruZOqazkV5ZsY1za86I33aGlf8cUu9Q/9uW7ro8sDZaaO3xPH6X8hHYr/ASgB1kFqBv2reDHqG2Xo5rBSb6QNobv9C90iatpzpPNbhgXT5CBgSXePJKpgh9bZj9miwRn3uWiSiHQzmKmnI+yQlqYG/NhWMfhVbSm+5WDCQ8sWWGa8iY7jS737VUT9Z+9AJdqolrY6vxOJjB2gfbMzFnDFu+yebc8JRE2wu5Gx8lO2D/mb9MaXL2r6vDX9Rgq/jGMhkNUmJcE2u4z0eib8H/b4r07GZKQMtoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(2940100002)(26005)(9686003)(55016003)(86362001)(316002)(122000001)(54906003)(8676002)(41300700001)(4326008)(64756008)(38100700002)(66446008)(66476007)(66556008)(6916009)(76116006)(66946007)(83380400001)(478600001)(186003)(53546011)(33656002)(2906002)(5660300002)(7696005)(6506007)(8936002)(38070700005)(71200400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkprOWd5RFVDalA5NzBDemtadzR4d08vdTlpN2hUekxad2lNcWMwT3JMbUQ1?=
 =?utf-8?B?Q0FMaWxFYjBOeFFwQ0lBaGF4c0diTi91YUZaUFhIOGdocUl6RjZacnFGaFl2?=
 =?utf-8?B?RjNDRmJ1WE1pMThTclFaZHIvcUQxMkEyMHU3YkJING9aQTc5Mzl6aTBCYm1G?=
 =?utf-8?B?U2FzWVBwVjc5ckluZFkxa09tVHl5SEptaVJyMzlxdkRxdEFpN3V2UkxhT3Q3?=
 =?utf-8?B?TngvdkdGY0Y1Qlp6ZUdYRUI2ZU1OcExaVWdEMDlJbHJDbW1HU1I1cWthWHQ3?=
 =?utf-8?B?d1UzRkpyaGNlMDR2NTREeE9hYVplQ3l5aUNNMFp5bEtQQ1lVMkVlekdwYTVC?=
 =?utf-8?B?QWpraFpNWS92dXYwVG56SysxK0VWanBVNDRyMzFQLzh2Sm92ZjlXMFRuMGRr?=
 =?utf-8?B?QkYyWnJvUUpIclY4bEc5MTVWa3lkSU0vbVdhbW5zQmkzbnhUWjlHUnlzTFl6?=
 =?utf-8?B?a3FXV25HRi9Db1N4b0ZkRExTcjROTnA0NGFDTy9hM0VEQWQwMlo4Y1owdjlM?=
 =?utf-8?B?OE82cVE0QVV5NFRNREFDSk02bHNpQmdzTFJSNWJlZ1RtSXRBQWZqemhlOWFK?=
 =?utf-8?B?SE5pSmZHNDMyZ1ZBZ0VhWDZ3K0hScFZTTjBpeHUxTkxjLzZ4cUNwSDAwYXBz?=
 =?utf-8?B?MnlwQWFkVktOMzc1RWJrMlprVklJU1VBWDlRYjJvRnVMMjVRVGszS2NlUkVl?=
 =?utf-8?B?TGJNTHk5azkwV2FJOHpsaWlmcDZLakZLNjNLYW1LVHpXemRjV0lnUGMyRlE1?=
 =?utf-8?B?TXYyRU5XTFJoS3NraHNraEdQWU9mQU1YWng4QzhpdEpEMXZNV0lsa290L0VT?=
 =?utf-8?B?Y1pTRDR2NDh2S3BTQjNib2NaRjlrVVE1Y3JZVUVZb3BVRTROQnZybzQvbzlK?=
 =?utf-8?B?QVpGR3FoTzJLejh1bkswSHE5MzlvMEdOUVErREl2MHVySmowbkhmOWxHR0I0?=
 =?utf-8?B?S2U2QzVCOWNUNlRUdmZxMkdDdVA4RUltbE5aMnRsL1NBVVZnbTQrNjBTSGZh?=
 =?utf-8?B?RmtMOG1qZ1VtZHpJemduYkpLYlRsTURGU0lqNUtwSDJpdTdGektZYmxGbC9V?=
 =?utf-8?B?L0pNZE1PSWhNL0VEL21PbUFoKytzVmRvZnA2SDczMGtxaWIyMzkxM3RKREdF?=
 =?utf-8?B?YklsWnJxbmZ0NGZybU1sdDRhdThrSVpXaEo4dEs2Zzl5Y0lMSWcrS3piVjA0?=
 =?utf-8?B?TzRsQytLc0pJUjdpQ2xjeG5VU2l1THVCWVdzTnV2KzdvRkNVM1pXNEp2WU5C?=
 =?utf-8?B?d3d2VVYrWFdhRzU4WHRpdVg3WWxGNm5BMUJoS0NoSXlKT3Brd0hrRzNpK21z?=
 =?utf-8?B?VkNsTlpuNEFQamQyM3dkakFBM21Da2d3bzBJd2lPQ3lIREpwcDY0Nld2Z2s1?=
 =?utf-8?B?TGx2eW5RUFpRRWVqaDcwZ2d6T3F5eVdyV284SEFjc3Z4NHBUc1hDN0VSdndE?=
 =?utf-8?B?THY0c2g2b0NlelhYbjhLdWEvRXJvK1RNazViekcwVTUvaThDSWVCNXVXU1Ir?=
 =?utf-8?B?STcveERSc0l0TDRwRm9pbkNUUkJIc1lDNmRwMlNvc2pHTlBub2E3Uk9FdUxI?=
 =?utf-8?B?eWhSWGhxZEhHamRtY3JTcVJMd1hsendxcEQzdTN2WTY4ejh0L1RBY1VCUzhL?=
 =?utf-8?B?WTVuSWpTc1FGYlpYNW05c243Y2pMaHBqeURhMEpqRWhNOHF4VStTQjFDcGhT?=
 =?utf-8?B?T2ZRdE1ralJjUlpGSmhXUlBuaTh3enkzU29TUmRFOHpzL1RyS0E2UGUvajBq?=
 =?utf-8?B?RWdjRFJGRzYrdzdmaHhxOUp3V3pXV3dHd3JteitmWGFyK2ZoOTJNYWQvZ2Zn?=
 =?utf-8?B?Q00wMEVnU2doY1FQdjUrS3dTWFJXcFdWSHJwWTJMSGJ1bUorN1o2YU5OMlBT?=
 =?utf-8?B?QS9oM0dsMTlYdDJFbFFqYmZ1ODNXK1JGeVV2QzkwcUFDQUQxYXR0OGtwMXU1?=
 =?utf-8?B?TmJoUVNJQlV1Rmx0cmdPOFFjaWdHSmdtdm0vdVlhNjBHRnMrSGxpTkVqWFpp?=
 =?utf-8?B?UjdJeGcyMGdWY1JsZ1YrTlRwS3F0UEEwRU5ZVXpjL2ZzM2Z4UUEwaHR3WThC?=
 =?utf-8?B?MFp1aVQzRnRWZ3h1N1E3a09uVGhLOVlvVUM5T3hmTCtmSUw2V0RGYVlnVlpQ?=
 =?utf-8?Q?li8g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22cf7487-abd2-4a57-f4fd-08dad9d7170a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 11:18:25.3511
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9dUi1BxGIow07zbyHMe2JKN1jxzLdYW8Uu1/PlWUhH1yUQJQoSzhWF+9ZTlqYx9PdMpIIFn1T0cOpJ5Um0fuNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8147
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRW1lZWwgSGFraW0NCj4g
U2VudDogRnJpZGF5LCA5IERlY2VtYmVyIDIwMjIgMTI6MTkNCj4gVG86IEpha3ViIEtpY2luc2tp
IDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBS
YWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPjsNCj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1
bWF6ZXRAZ29vZ2xlLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207DQo+IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmc7IHNkQHF1ZWFzeXNuYWlsLm5ldDsgYXRlbmFydEBrZXJuZWwub3JnOyBqaXJpQHJlc251
bGxpLnVzDQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggbmV0LW5leHQgdjQgMS8yXSBtYWNzZWM6IGFk
ZCBzdXBwb3J0IGZvcg0KPiBJRkxBX01BQ1NFQ19PRkZMT0FEIGluIG1hY3NlY19jaGFuZ2VsaW5r
DQo+IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBK
YWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiA+IFNlbnQ6IEZyaWRheSwgOSBEZWNl
bWJlciAyMDIyIDQ6MzMNCj4gPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0K
PiA+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtIDxyYWVkc0Bu
dmlkaWEuY29tPjsNCj4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29t
OyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBzZEBxdWVh
c3lzbmFpbC5uZXQ7IGF0ZW5hcnRAa2VybmVsLm9yZzsNCj4gPiBqaXJpQHJlc251bGxpLnVzDQo+
ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2NCAxLzJdIG1hY3NlYzogYWRkIHN1cHBv
cnQgZm9yDQo+ID4gSUZMQV9NQUNTRUNfT0ZGTE9BRCBpbiBtYWNzZWNfY2hhbmdlbGluaw0KPiA+
DQo+ID4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNo
bWVudHMNCj4gPg0KPiA+DQo+ID4gT24gVGh1LCA4IERlYyAyMDIyIDE4OjMyOjQ0IC0wODAwIEph
a3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+ID4gSSB0aGluayB5b3UncmUganVzdCBtb3ZpbmcgdGhp
cyBjb2RlLCBidXQgc3RpbGwuDQo+ID4NCj4gPiBBbmQgYnkgImJ5IHN0aWxsIiBJIG1lYW4gLSBp
dCdzIHN0aWxsIGEgYnVnLCBzbyBpdCBuZWVkcyB0byBiZSBmaXhlZCBmaXJzdC4NCj4gDQo+IFRo
ZSBjb2RlIGFkZGVkIGJ5IHRob3NlIHBhdGNoZXMgZG9lcyBub3QgdXNlIHRoZSBydG5sX2xvY2ss
IHRoZSBsb2NrIGlzIGp1c3QgZ2V0dGluZw0KPiBtb3ZlZCBhcyBwYXJ0IG9mIHNoYXJpbmcgc2lt
aWxhciBjb2RlLCBidXQgdGhlIG5ldyBjb2RlIGlzIHN0aWxsIG5vdCB1c2luZyBpdCwgSSBkb27i
gJl0DQo+IHRoaW5rIHRob3NlICBwYXRjaGVzIG5lZWQgdG8gd2FpdCB1bnRpbCBhIGZpeCBvZiBh
biBleGlzdGluZyBsb2NraW5nIGlzc3VlIGFzIGxvbmcgYXMNCj4gdGhlIG5ldyBjb2RlIGlzIG5v
dCBpbnNlcnRpbmcgYW55IGJ1Z3MuDQoNCkkgd2lsbCBzZW5kIGEgZml4IHBhdGNoIHNob3J0bHkg
YXMgcmVxdWVzdGVkLg0K
