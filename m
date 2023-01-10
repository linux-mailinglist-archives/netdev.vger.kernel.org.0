Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB25664213
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbjAJNjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjAJNiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:38:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20627.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::627])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01808DD0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 05:38:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xpyp2KoD2GEGLwERqFXo8E772tXoQwJ9ExWCLybFLF9lRM8KCLp82lzkLkdhDSTV1cdFBTEXQgVfCmE23ZXiWZzJUVjncGp8FCUDdzfztye99C50JVdIyNiLJh6mVKyvhINhR5RzmOCbe5TgIstNCyxb+4V+KnHte34QCOnTZi9pLGFc1/qKDaYR63q+PPO8iWyRw1apn9d3+PMjcKr40HXkROhwuNuDEoAkg/UBwSYPecSuKcV3DY9xFXVy7qmhUaguipMSLy+occtmy0k6IavO4pWUVVNpTMudcBM1qEJNu7hibrlLICnx2kPEkl7rb27W4Q/ClISphDOG65EmKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BUmJp1dUdchuhS4gue8iVMNvAX/V6sKMyUop4KiJrw=;
 b=VZl7LI8pa+8bPE096uNKLXjz5GyfDt3dEcWuWqoSgVZKxxM2MKlj9770w+s1dbMQBM/iPxx/VxQliAr66AUU5XGmdlz8s7J3J2ck65emoLdD541PjM1M8BHA/5CQCrD7DP6k6mEpqUuPIdIeR+oEQI5M3UBeZ7nhwyzvUOSaC5kRvrtFHE1wfmRZxp3tOTaToLwtcvIywiuxM/xdAi9QJcfHz+SgXpZtEH345TWA0nSMpjWLkGgEAf7mtvB972Zz1qBJSuYZo5iNpzsalOguRO5flG5f1hAM+zdb0rV6xFT6ZxOQy0TUoXa6he+LGyifJkjLu/yPMQjeePN45jtEJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BUmJp1dUdchuhS4gue8iVMNvAX/V6sKMyUop4KiJrw=;
 b=jBwAKvQVhwf/94ZZaTlVMdG8cUohbRAuokWbPh7WyKt0Ps2SXEnYfavUaQJB67Ya2e0dsiiBCabNtbENcHCYBzcx0pOfTfuYwWHPoJhsElGDQ2+kZiNrUlZO4VCHBo+oC8w/4WSnz+eZk+4QWnutTztH6JfOluUFihbxMek/RuFXEgPOnWREX8nDzZH+DfhIOPmklXEiNrgGJsfsKvXuGN4KoNgFy8uEiPUpcRRDvwOpnq46rS/xi3VuERPGEtFeZHCLVbb7n9xH1h0+PuEhKzcyldEeRaREcwp9Q9lXBd3DsIO5Rr3SRyxWyF/aqMn7/w6hDCI5I0ZqlQCijYIyBQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by CY5PR12MB6372.namprd12.prod.outlook.com (2603:10b6:930:e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:38:48 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 13:38:48 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: RE: [PATCH main 1/1] macsec: Fix Macsec replay protection
Thread-Topic: [PATCH main 1/1] macsec: Fix Macsec replay protection
Thread-Index: AQHZJMo4IObyE0HZYEC1M2UkECCch66Xa5iAgAAVavCAAAx5AIAAFrhQ
Date:   Tue, 10 Jan 2023 13:38:48 +0000
Message-ID: <IA1PR12MB63532F95E8921422D982220CABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230110080218.18799-1-ehakim@nvidia.com> <Y703mx5EEjQyH8Fu@hog>
 <IA1PR12MB635369F750521C87790D328AABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y71UCProYz73JVCW@hog>
In-Reply-To: <Y71UCProYz73JVCW@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|CY5PR12MB6372:EE_
x-ms-office365-filtering-correlation-id: 84d6196b-752d-430c-21be-08daf31000b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GzfL4nos56Gvzocd1bTF+7UJJutHpMRxj3e/OT/TwcUndJAeUvICp6JWqUwY73Y0dNZtEkcUpWEbdIwHL0sJ06Z64E8iHkz8+quWpyEve4KU0h3IXPnlAITmBRH5FJfNB0dsUBIoXooYEhtgiWDcncGlz5sNWbOpPuyHHb3xYy9Km8mvAKDVLPvGUby1Kz31h3403fzF/y8XOMCSpbb9M7PbhfhiiZ9e7ALYLsfnE4WCqI8kJYNd83fPHQKutIPPt1GfARwIeBoaapgLesKjMNDEwzJtU/JtgUNWB6X7HrF/LLur9e/NQwxoD/5BuEgcXGAsgu+kvH22Mm8jxidPn8WMCW9NI2/evCbksGPqaV8T68ykZKplf1jnuPtF9mLapBC2+lXCdn4yrA1Wi03tKE2euxJL9vzvH1xc8wxY8gPHXmEJoGl35JeuOxGAdFeJv3nZcKiOm9JmqGiwbtTnS40uh0tfR0Pi1QSgoVqy6+xK/dpa1Zx1bukAtvZB59OJInEss2EEKWCtdJtp6aWl31ZsT74vubqzdVQeYRcltvydXg/Frk/G7aomEYIad3c23GZBHhh5gBYvZkw9xdqFrRu9zgjcmcAG0DLslbCzgmCUHneLuCSf4yVw6JqxIJyoN4DmcT4hjeIqT2xQLDd+aCN2/ZIMZYP/3oSpN6Fv0dlhPz4o0isDlYIY6p3yZ1dMdk4BgdJRspqaZ6kEFXbTrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199015)(66946007)(52536014)(41300700001)(2906002)(8936002)(5660300002)(8676002)(6916009)(66476007)(66446008)(76116006)(66556008)(64756008)(316002)(7696005)(107886003)(71200400001)(54906003)(478600001)(53546011)(6506007)(33656002)(186003)(4326008)(55016003)(26005)(9686003)(83380400001)(86362001)(38100700002)(122000001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UEZkWEYwMTRFVDZNQXIzTzc3THhZcEM3MExEZE5rUXpMRjgrL1BlUVpsenVI?=
 =?utf-8?B?ektsZEdnc2l0SmFkREhVTUdVZllLN1RFTjEySVJWaXVsaDVXbmxtVEd5YUZW?=
 =?utf-8?B?cDl6eTY0TTFRNW1US3ExWHB5WnB5NklWMU5wM3FsMTkwaW85WGpXcDFwSXM0?=
 =?utf-8?B?WU5wRzFneWhFMHZNZy9senNBUnRYczFwSUtpa0o0ZkpnRWhxZXk3ZExmb2Nu?=
 =?utf-8?B?eU1vM0trSU43ejQwNVBPaTN2aHUxS1dWVTVDQy9TMlI3OGhPalo4SzlSMjZj?=
 =?utf-8?B?bFRRWFdJQzA0NW1TTzlSUzRaODJlR29IYW96eHdqaUFyUWtEUWZLcVJQYWxC?=
 =?utf-8?B?K1NhVVlNV3J1ZEE4TzU5UWpJcUNlL095RncrWUY3dUR0ZlJKYUR2aUdJbVly?=
 =?utf-8?B?NEFKN2tLRFNLRytRQ2FJelR2R1lHYVpPcHJWSnoxemFKUmVhU2ZCVm1LRnor?=
 =?utf-8?B?dHoyT0hESTlJdnBDSlkxNkhuaSt1S2hWZFVnOTU3VVdaSWpqc3NFMVN3S04y?=
 =?utf-8?B?bXpXZENQMnZ6ek9MZTArVmJRWkJQRnhYaGhaSlJ1UVJ3VDNibG9LU0dXQzRh?=
 =?utf-8?B?QmhSZG1lY3RNYWR3bDA1M2pxaGErUkhzL2hNZC9rWkVUU09jRmFNTHM2YkxF?=
 =?utf-8?B?dy9wYjJaLzg2em9VMHp3Wmh0bmI1MkxWL1FBVzloN2pwc1d5aUYwajlzb1Qr?=
 =?utf-8?B?T0R3Z3crZkJFSFZQRGI4Y1NoblJEWmxUUzhxSFhDQjN1WldIWFd5RzQvT1RO?=
 =?utf-8?B?eU5Pek02NDNXOXV0MTVnMnJYc29tdXFlcDJzTFNNUUNsVWUwVGNQUFlGL0VJ?=
 =?utf-8?B?SjB2alg4bmhaMzcvTnZnZUVKN0Q2d3NTM0FHWmI4MUZ5bEpDVTZ4WldrQ3Bz?=
 =?utf-8?B?TlpwN05Vdkl1YVkwUForS3JHNUIyTUZvSGdSMWpURStURlp0NTc0dHNYTzZM?=
 =?utf-8?B?RjU5RmVmdzNwQTBwZGJ3U05ibVl3SVpOQnRrUVNuVnpmWFdwMHJ6akN4WmFB?=
 =?utf-8?B?dktNVy9aU0lhendKajFWMmVDV0J6WGhIRzNpakVzQ0VSbXMxaWpPQ2FRSExT?=
 =?utf-8?B?eWxQamNicUdiYzk5a1FadEtHWmFVKzF2YWNlWlZrRGxwVVlpSEhpU3dlWTlT?=
 =?utf-8?B?QzAwVWZ2djBZQWtWVUZuQldQWXJEdDNHWXdrNmdQdllIemVyMUhFVDNrekw3?=
 =?utf-8?B?VGRqS2c4TGw2ZWtsK3hKSmRWMHROVE1oRFkxeXBTak5LVS8rRzdFSjRYdG9K?=
 =?utf-8?B?VWNKb09WalBKczBzTkNsKzk4UWJsUUNPdEhlaDlLanNrZFFFMHRhWXl0Zmx5?=
 =?utf-8?B?VERoKzZRdGkzUVdxbHEyWUQ3MVBKVHBxSi9ENVBaMjBjMWphQUMvWmF2OWpk?=
 =?utf-8?B?cVZ1NHowUHE1bmFmS0I1NEk1YXQxOTM5STVDRmgzZmR4TjVGbUVKM3RPNi9z?=
 =?utf-8?B?MFM0THVpZVZmc2tKemJNUldJUEpCbGtmSkZNSzhXaGtsdUFmSkNONDRuTU11?=
 =?utf-8?B?NWZ6R3ZUSGlocVF4Q2xLdmJQMklXZFNOOUxxbXo3TkRRM3UrellFeTYzeHVE?=
 =?utf-8?B?UkFXbWFRVG5IVllLenpRVVJCbk9ONUFGcEZqMGVDWXIwa0IzL29WRU80cjRS?=
 =?utf-8?B?RWJ5dzlQTzl6eXZwV3d5QnUvbnQ0bW9GWmVidzBqNlFxZmlDdDJtNVQwcE9D?=
 =?utf-8?B?NG4yNkxHM3J5R0VtRVJ5amZabWdoUnMvSHozakZVZGVaQytoOXFPeGk5Nmw2?=
 =?utf-8?B?ZHZadnIxUDU5SStSbDZTYjBDVjFFL3lDNzRWSW8ydFpNWXA3UmJ3STBIdXhD?=
 =?utf-8?B?U0hjYmJ5dFBIaXBCcm5XbDduR29MbkkvYU9UdzcrMDVUcXNXaDRYVGhaNWR6?=
 =?utf-8?B?b0FBUFJwbEhpRytVRC9jMmNkbGtrc2QyUm9pUWQ3WWticnltOTE0LzhWcWM5?=
 =?utf-8?B?dmZSb3A5RFo4UmJKMm9UaHowNW9HYlk1U3RqaGNBVEJkVzZnckYyV2VBZmdV?=
 =?utf-8?B?cWhuZjRvV3dOaGkrTGJneUVTSnM2NisxUWwzYng0M3pNNUJJMGgvUFJ5dVBz?=
 =?utf-8?B?dE41d1N2dE9oZ0ptaW5VK21lSDJLbXhHcVJpUEt4UnRuMzN5bFpHcjk5RDZr?=
 =?utf-8?Q?TgUgRTAvJ5RnU1GgM1FRvjpVe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d6196b-752d-430c-21be-08daf31000b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 13:38:48.2643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 17+8F+2ICTIBPhDtgVkRoHpyDcOkLsnv0Wd0JqvpikZMoaGsZBeLs/IZ4KX6UAE+koBGi9HoFG0muKvm1/Hjfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6372
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFR1ZXNkYXksIDEwIEphbnVhcnkgMjAyMyAx
NDowMw0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogZHNhaGVy
bkBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtDQo+IDxyYWVk
c0BudmlkaWEuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG1haW4gMS8xXSBtYWNzZWM6IEZp
eCBNYWNzZWMgcmVwbGF5IHByb3RlY3Rpb24NCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1
dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gMjAyMy0wMS0xMCwg
MTE6MjM6MjYgKzAwMDAsIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+DQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBTYWJyaW5hIER1YnJvY2EgPHNkQHF1
ZWFzeXNuYWlsLm5ldD4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIDEwIEphbnVhcnkgMjAyMyAxMjow
Mg0KPiA+ID4gVG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gPiA+IENjOiBk
c2FoZXJuQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFJhZWQgU2FsZW0NCj4g
PiA+IDxyYWVkc0BudmlkaWEuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBtYWluIDEv
MV0gbWFjc2VjOiBGaXggTWFjc2VjIHJlcGxheSBwcm90ZWN0aW9uDQo+ID4gPg0KPiA+ID4gRXh0
ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4g
PiA+DQo+ID4gPg0KPiA+ID4gMjAyMy0wMS0xMCwgMTA6MDI6MTkgKzAyMDAsIGVoYWtpbUBudmlk
aWEuY29tIHdyb3RlOg0KPiA+ID4gPiBAQCAtMTUxNiw3ICsxNTE1LDcgQEAgc3RhdGljIGludCBt
YWNzZWNfcGFyc2Vfb3B0KHN0cnVjdCBsaW5rX3V0aWwNCj4gPiA+ID4gKmx1LCBpbnQNCj4gPiA+
IGFyZ2MsIGNoYXIgKiphcmd2LA0KPiA+ID4gPiAgICAgICAgICAgICAgIGFkZGF0dHJfbChuLCBN
QUNTRUNfQlVGTEVOLCBJRkxBX01BQ1NFQ19JQ1ZfTEVOLA0KPiA+ID4gPiAgICAgICAgICAgICAg
ICAgICAgICAgICAmY2lwaGVyLmljdl9sZW4sIHNpemVvZihjaXBoZXIuaWN2X2xlbikpOw0KPiA+
ID4gPg0KPiA+ID4gPiAtICAgICBpZiAocmVwbGF5X3Byb3RlY3QgIT0gLTEpIHsNCj4gPiA+ID4g
KyAgICAgaWYgKHJlcGxheV9wcm90ZWN0KSB7DQo+ID4gPg0KPiA+ID4gVGhpcyB3aWxsIHNpbGVu
dGx5IGJyZWFrIGRpc2FibGluZyByZXBsYXkgcHJvdGVjdGlvbiBvbiBhbiBleGlzdGluZyBkZXZp
Y2UuIFRoaXM6DQo+ID4gPg0KPiA+DQo+ID4gVGhhbmtzIGZvciBjYXRjaGluZyB0aGF0Lg0KPiA+
DQo+ID4gPiAgICAgaXAgbGluayBzZXQgbWFjc2VjMCB0eXBlIG1hY3NlYyByZXBsYXkgb2ZmDQo+
ID4gPg0KPiA+ID4gd291bGQgbm93IGFwcGVhciB0byBzdWNjZWVkIGJ1dCB3aWxsIG5vdCBkbyBh
bnl0aGluZy4gVGhhdCdzIHdoeSBJDQo+ID4gPiB1c2VkIGFuIGludCB3aXRoDQo+ID4gPiAtMSBp
biBpcHJvdXRlLCBhbmQgYSBVOCBuZXRsaW5rIGF0dHJpYnV0ZSByYXRoZXIgYSBmbGFnLg0KPiA+
ID4NCj4gPiA+IEkgdGhpbmsgdGhpcyB3b3VsZCBiZSBhIGJldHRlciBmaXg6DQo+ID4gPg0KPiA+
ID4gICAgICAgICBpZiAocmVwbGF5X3Byb3RlY3QgIT0gLTEpIHsNCj4gPiA+IC0gICAgICAgICAg
ICAgICBhZGRhdHRyMzIobiwgTUFDU0VDX0JVRkxFTiwgSUZMQV9NQUNTRUNfV0lORE9XLCB3aW5k
b3cpOw0KPiA+ID4gKyAgICAgICAgICAgICAgIGlmIChyZXBsYXlfcHJvdGVjdCkNCj4gPiA+ICsg
ICAgICAgICAgICAgICAgICAgICAgIGFkZGF0dHIzMihuLCBNQUNTRUNfQlVGTEVOLA0KPiA+ID4g
KyBJRkxBX01BQ1NFQ19XSU5ET1csIHdpbmRvdyk7DQo+ID4gPiAgICAgICAgICAgICAgICAgYWRk
YXR0cjgobiwgTUFDU0VDX0JVRkxFTiwgSUZMQV9NQUNTRUNfUkVQTEFZX1BST1RFQ1QsDQo+ID4g
PiAgICAgICAgICAgICAgICAgICAgICAgICAgcmVwbGF5X3Byb3RlY3QpOw0KPiA+ID4gICAgICAg
ICB9DQo+ID4gPg0KPiA+ID4gRG9lcyB0aGF0IHdvcmsgZm9yIGFsbCB5b3VyIHRlc3QgY2FzZXM/
DQo+ID4NCj4gPiBUaGUgbWFpbiB0ZXN0IGNhc2Ugd29ya3MgaG93ZXZlciBJIHdvbmRlciBpZiBp
dCBzaG91bGQgYmUgYWxsb3dlZCB0bw0KPiA+IHBhc3MgYSB3aW5kb3cgd2l0aCByZXBsYXkgb2Zm
IGZvciBleGFtcGxlOg0KPiA+IGlwIGxpbmsgc2V0IG1hY3NlYzAgdHlwZSBtYWNzZWMgcmVwbGF5
IG9mZiB3aW5kb3cgMzINCj4gPg0KPiA+IGJlY2F1c2Ugbm93IHRoaXMgd2lsbCBzaWxlbnRseSBp
Z25vcmUgdGhlIHdpbmRvdyBhdHRyaWJ1dGUNCj4gPg0KPiA+IGEgcG9zc2libGUgc2NlbmFyaW86
DQo+ID4gd2Ugc3RhcnQgd2l0aCBhIG1hY3NlYyBkZXZpY2Ugd2l0aCByZXBsYXkgZW5hYmxlZCBh
bmQgd2luZG93IHNldCB0byA2NA0KPiA+IG5vdyB3ZSBwZXJmb3JtOg0KPiA+IGlwIGxpbmsgc2V0
IG1hY3NlYzAgdHlwZSBtYWNzZWMgcmVwbGF5IG9mZiB3aW5kb3cgMzIgaXAgbGluayBzZXQNCj4g
PiBtYWNzZWMwIHR5cGUgbWFjc2VjIHJlcGxheSBvbg0KPiA+DQo+ID4gd2UgZXhwZWN0IHRvIG1v
dmUgdG8gYSAzMi1iaXQgd2luZG93IGJ1dCB3ZSBzaWxlbnRseSBmYWlsZWQgdG8gZG8gc28uDQo+
ID4NCj4gPiB3aGF0IGRvIHlvdSB0aGluaz8NCj4gDQo+IFRoZSBrZXJuZWwgY3VycmVudGx5IGRv
ZXNuJ3QgYWxsb3cgdGhhdC4gRnJvbSBtYWNzZWNfdmFsaWRhdGVfYXR0cjoNCj4gDQo+ICAgICAg
ICAgaWYgKChkYXRhW0lGTEFfTUFDU0VDX1JFUExBWV9QUk9URUNUXSAmJg0KPiAgICAgICAgICAg
ICAgbmxhX2dldF91OChkYXRhW0lGTEFfTUFDU0VDX1JFUExBWV9QUk9URUNUXSkpICYmDQo+ICAg
ICAgICAgICAgICFkYXRhW0lGTEFfTUFDU0VDX1dJTkRPV10pDQo+ICAgICAgICAgICAgICAgICBy
ZXR1cm4gLUVJTlZBTDsNCj4gDQo+IFNvIHdlIGNhbiBzZXQgdGhlIHNpemUgb2YgdGhlIHJlcGxh
eSB3aW5kb3csIGJ1dCBpdCdzIGlnbm9yZWQgYW5kIHdpbGwgYmUgb3ZlcndyaXR0ZW4NCj4gd2hl
biB3ZSBlbmFibGUgcmVwbGF5IHByb3RlY3Rpb24uDQo+IA0KPiBXZSBjb3VsZCBjaGVjayBmb3Ig
d2luZG93ICE9IC0xIGluc3RlYWQgb2YgcmVwbGF5X3Byb3RlY3QgYmVmb3JlIGFkZGluZw0KPiBJ
RkxBX01BQ1NFQ19XSU5ET1csIGFuZCBJIHRoaW5rIHRoYXQgc2hvdWxkIHRha2UgY2FyZSBvZiBi
b3RoIGNhc2VzLg0KDQpBY2ssIHRoZSBpbml0aWFsIHByb3Bvc2VkIGZpeCBpcyBnb29kIGVub3Vn
aCBzaW5jZSB3ZSBjYW4ndCByZS1zZXQgcmVwbGF5IHRvIG9uIHdpdGhvdXQNCnByb3ZpZGluZyBh
IHdpbmRvdywgd2Ugd2lsbCBmYWxsIG9uIHRoZSB0ZXN0Og0KDQplbHNlIGlmICh3aW5kb3cgPT0g
LTEgJiYgcmVwbGF5X3Byb3RlY3QgPT0gMSkgeyANCiAgICAgICAgICAgICAgICBmcHJpbnRmKHN0
ZGVyciwNCiAgICAgICAgICAgICAgICAgICAgICAgICJyZXBsYXkgcHJvdGVjdGlvbiBlbmFibGVk
LCBidXQgbm8gd2luZG93IHNldC4gZGlkIHlvdSBtZWFuICdyZXBsYXkgb24gd2luZG93IFZBTFVF
Jz9cbiIpOw0KICAgICAgICAgICAgICAgIHJldHVybiAtMTsNCn0NCg0KSSB3aWxsIHNlbmQgYSBW
MiB3aXRoIHRoZSBwcm9wb3NlZCBmaXguDQoNCj4gPg0KPiA+ID4NCj4gPiA+ID4gICAgICAgICAg
ICAgICBhZGRhdHRyMzIobiwgTUFDU0VDX0JVRkxFTiwgSUZMQV9NQUNTRUNfV0lORE9XLCB3aW5k
b3cpOw0KPiA+ID4gPiAgICAgICAgICAgICAgIGFkZGF0dHI4KG4sIE1BQ1NFQ19CVUZMRU4sIElG
TEFfTUFDU0VDX1JFUExBWV9QUk9URUNULA0KPiA+ID4gPiAgICAgICAgICAgICAgICAgICAgICAg
IHJlcGxheV9wcm90ZWN0KTsNCj4gPiA+DQo+ID4gPiAtLQ0KPiA+ID4gU2FicmluYQ0KPiA+DQo+
IA0KPiAtLQ0KPiBTYWJyaW5hDQoNCg==
