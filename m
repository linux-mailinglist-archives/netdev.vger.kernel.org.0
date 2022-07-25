Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4895800D5
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 16:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbiGYOfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 10:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbiGYOfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 10:35:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8109339E
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 07:35:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsfaVjO+/ougY78hOilJXV+iG3NWXY1+DFO154ka6pG0/1k7sSmbnl6xytxklL7y4EsDWazsUu/4nxILD728MdC9qZYPoFS0qy+uKDwXano0IkiKwwdCGODrV222qaBnA+lbnWdybBlnU4h3tcEWXxo8Hj2ewuoGTymGQyx/ttZ8TcAs6LWUv8MXpVqVHzjgAk+xOQ4nfTuyUbEYiRTkR9uOF0EMjBA+6ZA4QxuA8iPwFekprF04QwAzVZU6ZCnW64+PwmUsahO/pPeJvJ/HrYRu6CQCOPOoeGOxOatPAUTuabjdLnvKVPc8Z8L6t3WrJM64nLF9Oh/Ny/WADzZuWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4c57VdWX9IdT2FPHIYVthrlXSukczZ+O/lVxo2+LvXk=;
 b=EDhiwe61JKiCBatUm9Cvc3wU3BO/ttftYtU3Clvz3ro610Kp/+73lNw0+47dACqgjGwL0ijrHxHQE7OSJx7Zij5WW9UQJLfHNLdyzl77PFWBKIWbqFwn/EX/eW6tCG7beKEZS/MI3Wna3D+//ffc1KhF/fmCZRQdLfv6CfvmvUsKJi9mP1jdGP5phTrcfYPX64chQdVsTGywMbvS73UmHxrVp2rhjBGjN3r0SuKAXZRHos8YbWYMIIur3Sr7Dy8lmRcQbjbxnJF51kJ9NFV8vp08LpkFqZ7nowtDEl0t+89RSTEaoocySrv344V0HBzHGGXQxQsGX7KMU5nsvQWH7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c57VdWX9IdT2FPHIYVthrlXSukczZ+O/lVxo2+LvXk=;
 b=pU9aqN9SYjx5VmG42b2pYZkEGhYswh4qbLLu0jYJWAdgADUIz6kAW/cAGBJD/wkFDGfNAxFxE18xdgVzmBjpDPU7xzxADwR8QQUaYkDWleOlv+Z0/cp41A/0DIYQ36G1qP3Q7xwyexbw9jUuAXIxUN+eXbFF/Ny9jrKNj9iUas7qO8kFvAT6Wxd4bggOvYGH4/O7eybrjpbGlES4k8z/uZ/bCh7KPL27/BvcuVLOMq4etmyMzGHXNjX5+5U2LH8Zb/3Pt/ateuQ59WsgWS5/tH8aKh+CHXEzpEHexAP/a7Hmg2ZctXZ+vVGWF6ygrqMOm4pj221g7lr9XPpbSx7aHQ==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BY5PR12MB5509.namprd12.prod.outlook.com (2603:10b6:a03:1d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 14:35:08 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 14:35:08 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net] net/tls: Remove the context from the list in
 tls_device_down
Thread-Topic: [PATCH net] net/tls: Remove the context from the list in
 tls_device_down
Thread-Index: AQHYnOHn+OZoq3dic0WK/NVxjJ40da2K9EqAgAQ5aoA=
Date:   Mon, 25 Jul 2022 14:35:08 +0000
Message-ID: <f085d0f65adc41f255a1a9b1bae7b0767ff3c15a.camel@nvidia.com>
References: <20220721091127.3209661-1-maximmi@nvidia.com>
         <20220722150435.371a4fd9@kernel.org>
In-Reply-To: <20220722150435.371a4fd9@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 986f72fa-d4fb-4c20-3242-08da6e4adf8a
x-ms-traffictypediagnostic: BY5PR12MB5509:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6j4vFZNNXCia5EXF2Q5PfM9SS3khO8PYyH6xNbsPgWOJ/qGK6aPOT18e0JlFNTTYt45k7UZfiW44ingno2//iXe6PPpYzCMzsOvabQ/C5LCgNbn52swo1lhIZIPAsasJry3Bx62dEE8TEuxrxF7t3OTvmcsRfkDSNSL/wWcrTK6bzz6zlsLIABGuAnqK+1+xxTAow/M5AnP8opk6RRZKf9IY6zrHi/WVgMy71GfPnXLUc4Q8+ovaJ1cuJ/F1gg30lKqpIKMib5G0zKTs3Lv5SqRjyVCuE8JASGN/DGJF4GrzY4F94sd/g0QbtVXvUq93prU+pPGWVje7SAbdtvhUnV+ZryR7Xx+ww4XhvOS/nVa6lZ/swwHhn9umPBWyvNBaaRaAncMUwCloUzW1kFhN4Jo7OzOweFFKc85XYxgU7XYWhZTODz2R/HgWFQYEt9EYqL3sj6XnPowvlOMYIyaUlc8/OCFf4ygZZXARu/wgdmkltAK1/IMrNeVkvh7Npm+dF7vIqFXPXsEoZ/okDqZTnIiHUnRIPREPSIU529H2UvZPxBoOgTim4QZpRiWS3haj5feiZ7hSF0SJSaz9+IhAQ2qCUWNSQ+a9Bk+QKYVuMGUKaIg7xVbDpDR6cmoiBVsBs1tiOv1yVDfSHJ/V1nV96tJ6Il0jgRJ28J2vrT9EVptL5ZrX+8+Gpc0GkdjtEIAoapAHHlL9EHB1/Nb73z94PmCpxak/mzWtHocPeJIgyt6lCUIIy1jwaSCwJNoGWn16NHX6Z0N3QSrG3KiH+ci4lub/VQh+K5/pMNApEq+GUK0sYPwTSq6NpdGGx7OeXO5/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(64756008)(86362001)(41300700001)(2906002)(6512007)(71200400001)(6506007)(6486002)(5660300002)(83380400001)(478600001)(8936002)(2616005)(38070700005)(38100700002)(186003)(122000001)(6916009)(4326008)(8676002)(66446008)(54906003)(66476007)(316002)(36756003)(66556008)(66946007)(76116006)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eVpEaUxLVE9TQVQvMCtlb01xSWZYbzF3Umtzayt3QzcwOE5ybHV2OGNPT2Zj?=
 =?utf-8?B?bHYveDNXSVo2MFV6OFRGUkFtek5vS1pqVktTSWFPUlZTTGZRRkhQM2JHUkwy?=
 =?utf-8?B?MnlaTTNWVmRuWkdZVUxDeU5laTFubmRucXpzNTlJL2VVdy92aExYZGYwUkdN?=
 =?utf-8?B?bkRRaUxTSEtLc2Uvb3IvR1BXWjM5K0xucGF0dGxYRStscXNnM0YvU2RMejU0?=
 =?utf-8?B?Zmoza3ordGY3ZEFTS2lXdzVwc0hjZXR2U0VnVGtwZ055UklILy85SHRhL2Jo?=
 =?utf-8?B?U2ZESlpqYjl2MEJhWjFkbmhra1ZkU2hQUXlXaFhlTEZmU291ZjJ3eGsrMUlo?=
 =?utf-8?B?UnpLRUUyb3VyTzRlWmlYWFZvR2ViYUhsWWtyUysxTDBlV1FYT0thQ0dIeHpn?=
 =?utf-8?B?YkhJSzRsaWNOeWFLaVNrUk9zOCtGOXh0OGFDREZJazl6ZVZKckZybkJIRmxq?=
 =?utf-8?B?M1BPMjBVREtlVktGcCthOGlsaWNOSmIrQ1N3NHE3bm83SXZKYjRXVzR6SWY2?=
 =?utf-8?B?ME5UMEtuenhkMHNubm84a1NOVnNONjFHNUFCYjdEVnplMUVLMEQ2amR6aHBP?=
 =?utf-8?B?NjROZGRuQVpMK0d1Z1oyTFJVdjJCcld1dE5kZVdDakppbWY5Q2tMWS9GQ0Ny?=
 =?utf-8?B?ZzFPWjdxT1U0ZXVaK1oyKzRkWXl2Wm54ZFM0VGhsSWl3aTJZOURuRHBpSEZu?=
 =?utf-8?B?WkxHb01vWmQxcXNMQUxxeitreXNUcUlPNW1lb0JkazJUMVphUCtkUkt6WU9J?=
 =?utf-8?B?YXc5dzhXSXZPdWlQS1BIV1FuejVlZXBNQTVTV21TdmZIVFpFSkovOGp1emVv?=
 =?utf-8?B?MDFhb1VhV09DcUJrVHFBU0RnUVhXZkdZZDJIY1ZWU09ja1NpRGpjRlhzSDFq?=
 =?utf-8?B?c0ZRaXdSRGptYlhNUG1VaFNSd1pNbHg4R3ZVTkJIUm9walljUWRqRXJRQzZJ?=
 =?utf-8?B?eXFadlM3cExlS3RlYWozYlVKS0s2VDRTVnpBTUdkNkxyQi9TdWdOMzBTcW43?=
 =?utf-8?B?cllzNmdHWUMvTDExU2Y2cC9TMXd5OWMxaTR0aVBiZWdwNzhObndCWjQ5Q0VZ?=
 =?utf-8?B?VjBHYlpOTUJLUFUzaTF0eDE3UGRlMXFBNjNTWDNDVGQ2ZlVBQmxyVy9DVFJN?=
 =?utf-8?B?ekh2M205cWNIKzdsVUVOTDY3MWhUWmpyckdIaVlRejd0UzR1bTBMaTg5UVBE?=
 =?utf-8?B?aGFmM3poWnk4ano4cVJwb3F5M3liRUxQb0hvRHpBLzFMZW80NUdFK29kTWtO?=
 =?utf-8?B?Vis5N04reXd1OGFydjM3WTd2MmtWNEF2UTg1TC8wQWRCUjdxSys1ZExBSHhk?=
 =?utf-8?B?bEdPVGcxQ21Salh2R1BRRkVsQnRaYkU2NFIvdWNBVFJzekJwYUM3ckZiWHVj?=
 =?utf-8?B?WnIvOEZyYmxGTDUrRG9oZXhobkQ5cVN3bU9PRFF3K21MRW9vQVM5eU9CbkRY?=
 =?utf-8?B?WGJPdGY3Q0tUbGdhaUI3em1NVzMvaG53NkV4cVQxMmlXQjAySnNxSUduQVBu?=
 =?utf-8?B?T3JqU0RFVXVYV2srRUJueXdLY2MySWdSWS92dE5rT29QRnhTemVZeElSZ0Nh?=
 =?utf-8?B?WktEL0hUSGRKMzM1RUNyWVltT0p5S1h4TlpnSTBxQVdrVDBVaTlSK25wV3FB?=
 =?utf-8?B?Wjk5ZnhNdnFSZndoanZrVThRNGQxRkNVd3MxMVFkcWRLd1ZBdmVxaWl6TGh1?=
 =?utf-8?B?T1FySHV2UytsVGdBTWNaUXRFT3BDNWg3Ym4vaSt6V1ZJQUh3U3ZQbm1lTkEy?=
 =?utf-8?B?S0o5Q2dVaE1nV0kxVCtKSUluWmliTGlPYmxSRHcxYjZVZ3R3bU1SMUlpY01y?=
 =?utf-8?B?ckVySENZTXUvQTRXVTdWSkpmRHZ0bUc4dndRb0k0OXJOWC9GRkVuTnlBVC84?=
 =?utf-8?B?SDYrUC9oYjRHaXZMSkRXSWVJV1A4VzhURXh2MUtjWk1aMUo5bDNscmROZzAz?=
 =?utf-8?B?YzE3U2diRDEwZ1ZwZUpZODgrRnBnU3Zlanh3VnJUdk15MXZCWU55akpMY25N?=
 =?utf-8?B?bGxkaEJWU1FaZ0NWbmNLRkg2VlVhYVF1cHpMdGRIRW8vcXUrM3NKWHpVUWtu?=
 =?utf-8?B?ZXUyclRhNTNUNDRZYXIyL0swdDFxZ2MrRUNid1FaMGliU3d3STBNckJmNHNh?=
 =?utf-8?B?R0hlTFVnSVljNzVLVzVPUHpkSVB6VGVocGg1K1BheHZhcWhnWXlHd3hmM1JW?=
 =?utf-8?B?Y1lEU2tHOEZTWnE4dEpVNHdjVHoxa0NiTFBmN3dQTXZBMHk5MUdXVVFrQnFZ?=
 =?utf-8?B?dU9Ga1QzOFVjUTNOV0JDOHdVbUh3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <551250B0A1B6D348A7BBE0A8834EB4CF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 986f72fa-d4fb-4c20-3242-08da6e4adf8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 14:35:08.3201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LSsSfqQauB2VL+SSmd2mPk3ou9APsCZcxdn966kEo7yQriCB9llM0fDiRNUbflnXnykyfFgjOvPzyvuLyxRLTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5509
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA3LTIyIGF0IDE1OjA0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyMSBKdWwgMjAyMiAxMjoxMToyNyArMDMwMCBNYXhpbSBNaWtpdHlhbnNraXkg
d3JvdGU6DQo+ID4gdGxzX2RldmljZV9kb3duIHRha2VzIGEgcmVmZXJlbmNlIG9uIGFsbCBjb250
ZXh0cyBpdCdzIGdvaW5nIHRvIG1vdmUgdG8NCj4gPiB0aGUgZGVncmFkZWQgc3RhdGUgKHNvZnR3
YXJlIGZhbGxiYWNrKS4gSWYgc2tfZGVzdHJ1Y3QgcnVucyBhZnRlcndhcmRzLA0KPiA+IGl0IGNh
biByZWR1Y2UgdGhlIHJlZmVyZW5jZSBjb3VudGVyIGJhY2sgdG8gMSBhbmQgcmV0dXJuIGVhcmx5
IHdpdGhvdXQNCj4gPiBkZXN0cm95aW5nIHRoZSBjb250ZXh0LiBUaGVuIHRsc19kZXZpY2VfZG93
biB3aWxsIHJlbGVhc2UgdGhlIHJlZmVyZW5jZQ0KPiA+IGl0IHRvb2sgYW5kIGNhbGwgdGxzX2Rl
dmljZV9mcmVlX2N0eC4gSG93ZXZlciwgdGhlIGNvbnRleHQgd2lsbCBzdGlsbA0KPiA+IHN0YXkg
aW4gdGxzX2RldmljZV9kb3duX2xpc3QgZm9yZXZlci4gVGhlIGxpc3Qgd2lsbCBjb250YWluIGFu
IGl0ZW0sDQo+ID4gbWVtb3J5IGZvciB3aGljaCBpcyByZWxlYXNlZCwgbWFraW5nIGEgbWVtb3J5
IGNvcnJ1cHRpb24gcG9zc2libGUuDQo+ID4gDQo+ID4gRml4IHRoZSBhYm92ZSBidWcgYnkgcHJv
cGVybHkgcmVtb3ZpbmcgdGhlIGNvbnRleHQgZnJvbSBhbGwgbGlzdHMgYmVmb3JlDQo+ID4gYW55
IGNhbGwgdG8gdGxzX2RldmljZV9mcmVlX2N0eC4NCj4gDQo+IFNHVE0uIFRoZSB0bHNfZGV2aWNl
X2Rvd25fbGlzdCBoYXMgbm8gdXNlLCB0aG8sIGlzIHRoZSBwbGFuIHRvIHJlbW92ZQ0KPiBpdCBs
YXRlciBhcyBhIGNsZWFudXAgb3IgeW91ciB1cGNvbWluZyBwYXRjaGVzIG1ha2UgdXNlIG9mIGl0
Pw0KDQpJIGRvbid0IHBsYW4gdG8gcmVtb3ZlIGl0LiBSaWdodCwgd2UgbmV2ZXIgaXRlcmF0ZSBv
dmVyIGl0LCBzbyBpbnN0ZWFkDQpvZiBtb3ZpbmcgdGhlIGNvbnRleHQgdG8gdGxzX2RldmljZV9k
b3duX2xpc3QsIHdlIGNhbiByZW1vdmUgaXQgZnJvbQ0KbGlzdCwgYXMgbG9uZyBhcyB3ZSBjaGVj
ayB0byBub3QgcmVtb3ZlIGl0IHNlY29uZCB0aW1lIG9uIGRlc3RydWN0aW9uLg0KDQpIb3dldmVy
LCB0aGlzIHdheSB3ZSBkb24ndCBnYWluIGFueXRoaW5nLCBidXQgbG9zZSBhIGRlYnVnZ2luZw0K
b3Bwb3J0dW5pdHk6IGZvciBleGFtcGxlLCB3aGVuIGxpc3QgZGVidWdnaW5nIGlzIGVuYWJsZWQs
IGRvdWJsZQ0KbGlzdF9kZWwgd2lsbCBiZSBkZXRlY3RlZC4NCg0KU28sIGl0IGRvZXNuJ3QgbWFr
ZSBzZW5zZSB0byBtZSB0byByZW1vdmUgdGhpcyBsaXN0LCBidXQgaWYgeW91IHN0aWxsDQp3YW50
IHRvIGRvIGl0LCBUYXJpcSBoYXMgYSBwYXRjaCBmb3IgdGhpcy4NCg0KPiANCj4gV2UgY2FuIGRl
bGV0ZSBpdCBub3cgaWYgeW91IGRvbid0IGhhdmUgYSBwcmVmZXJlbmNlLCBlaXRoZXIgd2F5IHRo
ZSBmaXgNCj4gaXMgc21hbGwuDQoNCg==
