Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F52665E654
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 09:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbjAEIAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 03:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjAEIAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 03:00:13 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D871EC43
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 00:00:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwXcURPh/pfm5zkZCPeL39sDU5cAMe3qE2s19mot9325bNrmH5vpX0VDTbGyJWcZ91RlDyHQuwU8Nnp57t6Fa0Rx2+F2a5tUmIIdsmoXpeBscy1hHIIzAOEDjVje9slyKXcgTx4bHaSkNS/2ZPjCDKBSdigRY+0OMMGD5Q7qpksyTF7Zba9t4qjQl0FJoFK0oUfkmBEjmqoclAAoTLpdBtOE5AZBo08e1uuY970fBTWe5h6NXKzFKON6/VEYgsXr9iJn5Bm1F/+BcpGNYQOuWDKq5Hx75TcbmRoKP/Grz1pJvJ9ZmGR0iLRRpdwOOPx3JAdES1b5T0RfA7LjrupBtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vz0VCST07UZ6MS7h4x/q6ZYysGr5ZRMVE1W1539exms=;
 b=WfhL0Dk7kVRIB1+2RmX/URNgAKusv0WKAIoYM3jLKThcZrw5/wmZmamlhKNAp+BIRTZy2viVCq0UFcTu8o1GE4mZt3x3+0i3VR9dhE6AcjgFnz0H4EHC6vujpvAR5OVMLr1ViXjYtIK9/uIAKrKaVrPPkRupD2TPu9gYJaxSTDKspveLXgxeWs4pi7JwdytAxKqMfDZLMlr4skGWqV0me/MriyIrC4uacRiU9KUVf7YUmwjHT50IIMWfXCsbdl/jg4juggEyYTYQ/BZGp5Zxrw6uIAN7bxqlDbNj+BkIPe7ONuv6MZeoT+JcdmDnLlgwee9gVui9qQyM1rKkqhA2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vz0VCST07UZ6MS7h4x/q6ZYysGr5ZRMVE1W1539exms=;
 b=NGgO6rFUuW79L6sp5/9GFFurXfjLTqLuEad5ijsq6QL/vyXgeqkzQd9T9k1bxgGGYHHjc/AZ5TTSHp3CGdW003tD3M6oiX4HEPGQ0MUwbJMJUe1IWvW1wcEKuxseCgI9EgMHPoy/9Vm5uwNFDfWQxa5kccr3NebDHi/zjDvwfhgjxJSnQoqi/gaD5RkoFzgxx8uFqmkeXVRRw0GsuAuwLd52rP7jyOOOpq8IGn6DVwdbwNhr+fSeGm/9ICHRlaFvAFPdrqd5R4l9NTEGS/OF1tLZmPu85R0LviwV4W/wG8ZXRKYgqIZddm9fXJTMtA/0X9+ZXcZNV+o5K/5cdocyzA==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS7PR12MB8250.namprd12.prod.outlook.com (2603:10b6:8:db::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 08:00:09 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%7]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 08:00:08 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [PATCH net-next v6 0/2] Add support to offload macsec using
 netlink update
Thread-Topic: [PATCH net-next v6 0/2] Add support to offload macsec using
 netlink update
Thread-Index: AQHZINtol12TdesMo0WGpy69ci9jaK6PdW4g
Date:   Thu, 5 Jan 2023 08:00:08 +0000
Message-ID: <IA1PR12MB6353FFE107811CFD990A84ABABFA9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230105075721.17603-1-ehakim@nvidia.com>
In-Reply-To: <20230105075721.17603-1-ehakim@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS7PR12MB8250:EE_
x-ms-office365-filtering-correlation-id: 0913bc4d-d011-47be-e546-08daeef2dd47
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m77bp91deah4kxmkf/jSodmc5+HVCWTJ4MbSqOFQq0pBv+fsIgpCYInst//de8c4143lTOGIkfpdqOKYyz0PhCcWxBcHWSaxyGnXQa/Tvp/O3kBWlUyFIOFbuePYzfpLy11hx76B9fNxLuMHx2xknwNb0JQY7hot1fjn9ua6MGvrJuu1G9koiBJ58Alg6kNug8XVOzlMucSX1cxAbcrIuVznc0SXTQxUbJugv4rTZKlPx9Q4tVhmJ2yUE1U6kmUcOtbofTbg18rAQ8CWZ50DXRd5AG9Rh/g9Iv+5fwJv9NcBZ6l8WL9lsrk2+qxF2qIdmLFycTA9qbLXu9qiOTjifh3rdmn/8OYmMkN9X+7Ukr2kC/W1yqUiagq2vyioEQJ+w3C2poK9M1hYor+W/L4u5lq7KHjYzDjwHB+NCadBAY9zA5L0pdTuDGqaPHBQ+3sc27P9cA9pxvi3n4zqBN6zFOimlmS3t7RA+Hx2XSUHEquX1dGT187t2sLIAu8eeQKiD32xb6q80szQXvgDq3wfsLIOcrh8hWt4iXOcJRk9qujJcsPbN7gJAleBwg+0NzHI9rwjvJrpS6e4yaJ7KF2lkGvfOSw2iydBJZtjjkg2pDwJjB1wIW//FLzIdHZ2wPPxL5oGLGJeHTCX2R9kHp7O8psyFZLjJslRnR+piSnc2pQXIiH87pbo6Y4buN59z/DaCd+KKC4GArQZlwG7bvWPIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(33656002)(55016003)(2906002)(66446008)(66946007)(76116006)(4326008)(186003)(5660300002)(41300700001)(66476007)(64756008)(52536014)(8676002)(478600001)(71200400001)(26005)(8936002)(7696005)(83380400001)(6506007)(53546011)(316002)(9686003)(6916009)(38070700005)(86362001)(54906003)(66556008)(122000001)(38100700002)(15650500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTZuaTAvVEFzTXE5WlFPVElVdjh3MlJQUlduMVVwQ0F2Z0NyYS9Mcm9IcjQ1?=
 =?utf-8?B?SDhBYkp1dGNXUmlEaWZzTnhNbXo4MEtrMUE4d3JhQWtwd0Vwd1dmc3JEZ0tz?=
 =?utf-8?B?QVc3UTk2N0Q5MkRLbG0yQ2hVOWp2L2tNZHMrMS9HdFhRRVJXZ0s1KzM2RENM?=
 =?utf-8?B?dlUvZThjY0xEME9ERyt6aXVyM3lRNWwzL2ViZEErcnhBejduZHQyRFM0Slpk?=
 =?utf-8?B?ODZHM2JUaVEva1UwaU1BNTFGYXhMWU1jTzhYcW1kRmZKek1ZS0RmK1ZBQ0M0?=
 =?utf-8?B?UkY4cncwdk05dWh3SFZ3NVBWaGNqRER3ZklSWEdXZFB2SXc5WS9pRzRhdCta?=
 =?utf-8?B?Y2d0RE5yMElEajU3UXQ4YXNBTjJrZzlPT3cybm1oNHYwTzdvOERTQUR0YVpS?=
 =?utf-8?B?Zmt5VWU2TkxMd2gyamQzUGE4R3VZODYvN094cDEwRm9aaTlFUmtVZ0xkeEZp?=
 =?utf-8?B?VFlGT3pmNjRGODNkdFM1cGMvbFl5T0IvZmI4RWwwdTU0dmpIU3lnRis1Wms0?=
 =?utf-8?B?bWRscVVBSHpxM3lnWmhKM2tJR2hXSlptS2c1ZFFsM0x4cWZaYVhBOFJ0UXdX?=
 =?utf-8?B?OXg2eWpRU21na2VEemh1bDZHMjJhMGJmSUwyZVM5dC9XZjUyZ0NscGFpSUF1?=
 =?utf-8?B?cHRVUVFoRWt1MVlyRGdidFB4RkpoYm5LU3JKWDJ1SnBXSDRic1RNSFZsNTFh?=
 =?utf-8?B?UFhZV0Qwbm5RaVFIV3pLV2lTN2VOamVJZGd3MmtPb29sbEo2eUNuNTV5Q2pZ?=
 =?utf-8?B?OW5FVkFqenRaOVhwVEdHd2JDQVdZZ2J2YzRhWW52aTdzNytOcHZGVXZYSGR2?=
 =?utf-8?B?RTFhWEVRaVZnbXVvZnhoOVlNdWUrRWpFRkd6WVNCeUFqSzhyck9zNVhlMlRl?=
 =?utf-8?B?Rm8vVjR4aGZzb245ZFVNUGRqYWI1M0ltTUdPMmpnMVE4bzVuVnlSUW02RlNG?=
 =?utf-8?B?M29idkRXTDhBOUZkdStNbUIwYVJTMzA3OWdKOUFqYVpEaS9NcjMwT0hEemp4?=
 =?utf-8?B?UEx6V3BEK3BadFoyZXNhSTFqVFJVekhiRjBHazA5OUErYmIvK2ZRMXdSNkhq?=
 =?utf-8?B?ZkoyV2N1VXExaWtKM053dFNwTGw3a1JIOHJ6VlhsU3VKdFFweU5mVFZzSTZ4?=
 =?utf-8?B?NnJsR2dKVCtCT1JrSFJ0TGdZK1RuWE96OTJhcjhJWVJMODgwcXN2dVViVVBk?=
 =?utf-8?B?RUMwTitjUlJmT2hraUZwMC81akVYL0hsS1FCN0dtUFdiTE1mV3dKelFRZlZx?=
 =?utf-8?B?d0Z4SFQ5N0RyaS92bHhuWGNWZHZYNXN2VnMxSDNJQS9lTkI0S0I5WlVhREFP?=
 =?utf-8?B?VWptMTBxS2F3V3R5Nmc4amJFbHVNNk1kK0VGVlluYXVqcW5oQ3NWMStFdFFz?=
 =?utf-8?B?cXVlMUFBcVo1citSVHNEYmtkYU5NMEticFZYeldkYVgxYjk3YXFMZDhldVJz?=
 =?utf-8?B?VStYS3VFUkpxdVE1ZjczVm1hZldpWnBva3lSbDhCaDlpTmZJbEZSNG82anF5?=
 =?utf-8?B?RFZ6RGtBQ0E2Y014b3V3QUJQcXVhT3oyNW1VRG5ab1NtV1FpTklFWmo2R3pR?=
 =?utf-8?B?WkZpN2Q1SkswVmE2a1k0akRWbDVBMUhyQ24rYUJiSVk3c2VYZzFkZG83d2V4?=
 =?utf-8?B?OWpFbjhuejZ6aG52NitJVG1xVEhJQkozSkJzK01NNnZKSUhtdHpTNFliS0Uy?=
 =?utf-8?B?WU1lbW9mdlFERXVCMm05M3pPYWtVRHh0WmlVQSsyWHRaMkR4UUNDbjZmSWNa?=
 =?utf-8?B?dnJ0THN3YW9RVmIvZFQ3SDhvNnd2SUNwTm5uYmx2a2pIODg5cEFTV2ZlYWVP?=
 =?utf-8?B?bzlra2ZaWWNJaDJuZnRGU2ZaMVkyMkkwYlZmQ256OUhJNTJ4ajhRZWlvSVBR?=
 =?utf-8?B?L2MyY0dkcTBZOVhzT3FxbGsrN2NXRmlxclZuZW9zYURXOXB2ZXFWbzJmNnRP?=
 =?utf-8?B?eHNoeFh6T1dEVUR6ZXM2Wk1wNzRLYWlBc2hiT2t6M3B0cWI0Nll1YUszMkVR?=
 =?utf-8?B?Q2wwVWNuYitUV0hheTdaMDFzOWs2TXp6RUF3SWIvbENtL010K29vZUROTkJx?=
 =?utf-8?B?N2tSeWFrZWV6OGRIR0ZLVVh6ZUVHdDgwMjJ5czdxc2orbXltV0o2ckk2VW94?=
 =?utf-8?Q?DybxX35SG7geQxuuKAJZdfbnr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0913bc4d-d011-47be-e546-08daeef2dd47
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 08:00:08.7850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M6JQ3EarEmTO3XMeOXXJu2WCo2KEFE12d2NFrCgc8/VmPI83swyZFaJEffq4S7Tfj4RqGim73R2n0GkV5mtEdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8250
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBnb3QgdGhlIHZlcnNpb25pbmcgdGFnIGFzIHBhcnQgb2YgYW4gYXV0b21hdGVkIHZlcnNp
b25pbmcgc2NyaXB0LA0Kc29ycnkgYWJvdXQgdGhhdCB3aWxsIGZpeCBhbmQgcmVzZW5kLg0KDQo+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEVtZWVsIEhha2ltIDxlaGFraW1A
bnZpZGlhLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIDUgSmFudWFyeSAyMDIzIDk6NTcNCj4gVG86
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IFJhZWQgU2FsZW0gPHJhZWRzQG52aWRpYS5j
b20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtl
cm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBzZEBxdWVhc3lzbmFpbC5uZXQ7IGF0ZW5h
cnRAa2VybmVsLm9yZzsgRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBTdWJqZWN0
OiBbUEFUQ0ggbmV0LW5leHQgdjYgMC8yXSBBZGQgc3VwcG9ydCB0byBvZmZsb2FkIG1hY3NlYyB1
c2luZyBuZXRsaW5rDQo+IHVwZGF0ZQ0KPiANCj4gRnJvbTogRW1lZWwgSGFraW0gPGVoYWtpbUBu
dmlkaWEuY29tPg0KPiANCj4gVGhpcyBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBvZmZsb2FkaW5n
IG1hY3NlYyBhcyBwYXJ0IG9mIHRoZSBuZXRsaW5rIHVwZGF0ZSByb3V0aW5lDQo+ICwgY29tbWFu
ZCBleGFtcGxlOg0KPiBpcCBsaW5rIHNldCBsaW5rIGV0aDIgbWFjc2VjMCB0eXBlIG1hY3NlYyBv
ZmZsb2FkIG1hYw0KPiANCj4gVGhlIGFib3ZlIGlzIGRvbmUgdXNpbmcgdGhlIElGTEFfTUFDU0VD
X09GRkxPQUQgYXR0cmlidXRlIGhlbmNlIHRoZSBzZWNvbmQNCj4gcGF0Y2ggb2YgZHVtcGluZyB0
aGlzIGF0dHJpYnV0ZSBhcyBwYXJ0IG9mIHRoZSBtYWNzZWMgZHVtcC4NCj4gDQo+IEVtZWVsIEhh
a2ltICgyKToNCj4gICBtYWNzZWM6IGFkZCBzdXBwb3J0IGZvciBJRkxBX01BQ1NFQ19PRkZMT0FE
IGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+ICAgbWFjc2VjOiBkdW1wIElGTEFfTUFDU0VDX09GRkxP
QUQgYXR0cmlidXRlIGFzIHBhcnQgb2YgbWFjc2VjIGR1bXANCj4gDQo+ICBkcml2ZXJzL25ldC9t
YWNzZWMuYyB8IDEyNyArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0t
DQo+ICAxIGZpbGUgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKSwgNjEgZGVsZXRpb25zKC0pDQo+
IA0KPiAtLQ0KPiAyLjIxLjMNCg0K
