Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030D5417803
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 17:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347171AbhIXPuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 11:50:24 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:54954 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233379AbhIXPuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 11:50:23 -0400
X-Greylist: delayed 24180 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2021 11:50:23 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1632498529;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mhE3ASJe6DxZAFE9NPoUPzpJP6n79kJO7pdRNTZKhcc=;
        b=cct/WSqw3A3uCt0iTLU+RW5kT9vJYC59SZH2jMEcpCk+CI0xVETdB/vIj8tC7qSvDYejFl
        yAJL0rYsAVCLJ/J5moGikU564/dNrAWIidbfE8DK+Az8D6DYyJG54ybw6jkiU9qeIojxv5
        qlaOGvw+0FNUgElvD5rZLOncDGalmmo=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-eZpqVhyBMXy-qcXW2OF9cw-2; Fri, 24 Sep 2021 11:48:48 -0400
X-MC-Unique: eZpqVhyBMXy-qcXW2OF9cw-2
Received: from PH0PR19MB5113.namprd19.prod.outlook.com (2603:10b6:510:90::23)
 by PH0PR19MB5066.namprd19.prod.outlook.com (2603:10b6:510:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Fri, 24 Sep
 2021 15:48:43 +0000
Received: from PH0PR19MB5113.namprd19.prod.outlook.com
 ([fe80::48e9:1dc2:d989:b9f2]) by PH0PR19MB5113.namprd19.prod.outlook.com
 ([fe80::48e9:1dc2:d989:b9f2%8]) with mapi id 15.20.4544.018; Fri, 24 Sep 2021
 15:48:42 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>,
        "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Subject: Re: [PATCH] net: phy: enhance GPY115 loopback disable function
Thread-Topic: [PATCH] net: phy: enhance GPY115 loopback disable function
Thread-Index: AQHXsSNdw4MBIM5DFkCqF7LjgZ0AI6uzFRgAgAA/7IA=
Date:   Fri, 24 Sep 2021 15:48:42 +0000
Message-ID: <e722c4a0-2215-7ea4-db07-fb3445a737f8@maxlinear.com>
References: <20210924090537.48972-1-lxu@maxlinear.com>
 <YU29ulYZSlzKVtaE@lunn.ch>
In-Reply-To: <YU29ulYZSlzKVtaE@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25634c77-a557-4fba-7324-08d97f72c901
x-ms-traffictypediagnostic: PH0PR19MB5066:
x-ld-processed: dac28005-13e0-41b8-8280-7663835f2b1d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR19MB5066172C4EC822349FED9A8EBDA49@PH0PR19MB5066.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uIphV5aouf5gj1ONVFui0j7anZF9sK+TJcAVNZUdrsa0OzN/8RM3OcVdnmantxJl396inb2nEDkVkBX4gwqqoe5U5ALZ5AEUWBjwGIUDhKC7g1pAZIi+JHy9pMYDZcFpsd7Fm5pIobCtJBJEo8svuXNX9tHpKeLcpp75pb52OuSxYmcDIF+hSNG77FVggCi5cijJGgNUltjz6vDnmE0p8fS85tjvfu9X7UclWWFXJNqv0Y2gpGQ5nNWEXQbNSVwOjFiKcIRAzN7EviTgh4mkH8O2ay9B8y0t0BzeQhSrGIUn728v4kiz+UW8wuzDBeZlCbVa9qc8sO0naG+TWJNR9mvd1OjqF6O+rB+Y6r4JLv1+zuVd38uT8MqDT9GGBgjeMKPXDXCKwQHp/cqq6nT6b5k9EiD9F2pJvKEA6UcxBcHxQ0fobRaaL4jEs+KItt1OD3sliJjP8W19r/IEsUwR34Z4AAdvrIOxaLDdQtwpI1GV4QuUo3KEd1wAxijfuBuxXWlFLw/VXiPP/GQ0QbLqJmg/lmKkFPLf8lEu0uk9xHvoinXvkuAmEMIF6z4jzxftu5oKs+IvGPHzAJewTr45KbX/2KrR3qLzNT36Hwv6gZNzC3eHiuN/guCbaqGf9oaSZklmBkL3bupTEhwIizdpggs0EedX3flQ0Zx4ePbwibIvOrZ2GD7rW3dJzg2ENY569CPQPA6ZX0b7z8u2ExSOr6b3dEq2ts2s72WyZIIHdYvhFveQc06puUZ5Spfx10tnj1vxs/0tG7x7LbOqrNgkkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR19MB5113.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(86362001)(83380400001)(508600001)(91956017)(66476007)(64756008)(2616005)(38100700002)(36756003)(8676002)(26005)(122000001)(66556008)(31696002)(2906002)(38070700005)(66446008)(76116006)(6506007)(66946007)(5660300002)(8936002)(71200400001)(54906003)(186003)(4326008)(316002)(6486002)(31686004)(6512007)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHhIZGlvUkJOdDJMS04vcUI4MnUzQ08rZXN0VHpMaHVuVndiTkRrdDFUNlhL?=
 =?utf-8?B?U25pem1QK0dqQTE2N2RsT09LUlI0cWFMZTM4Y2JpbXdLTW9wV1NNZGhVSUZp?=
 =?utf-8?B?YS9BYmR0Z0toSzBqYTM3UFpCVHdnZktBK1QyWkNiRjRNQkJ4cG5udFhrN1I5?=
 =?utf-8?B?TnpoaUxOODBHRVRSRmdOeWN2My9yOGZjR3JCNDNNSVJpOThuWm1TK2NyUVVJ?=
 =?utf-8?B?V2c3cG44ak9lWW5jdWR5LzRnYk9wT0wrcGF0V2pXTVd5b3I3Z2hEdnhHMHQy?=
 =?utf-8?B?cGQ2eGNhVFlnOW5VRVpCSTd2YVR2bjJrN2w3TUM1UFNOUWo2Rjc2eVIyNDdX?=
 =?utf-8?B?Q1dGREoxWWpaLzQxZXRDRGRMTUx5V0EvTjc4bktCcTg1RnNPekNpdDMyRUtp?=
 =?utf-8?B?amYyRDZqbVdJcEMzRmFWVlhTaWdIbFBpaUtkZUU4M3g5VWxnM0ZpZVp1TGNP?=
 =?utf-8?B?am5OWnB1RDVpQUozVFd2bWxrTTdmdHpDZ0tnbXpKZDNvQy9uUTAvWjRTV2tW?=
 =?utf-8?B?RzJCVUtPSFlHUFN2ZmZodUxrdUV1am91Vm9ESWdPTHdqdDJwUTNBSVBjUkd2?=
 =?utf-8?B?RlYzZWNBcTQ3bkE1ZzByT3JJWkxONWhHWTdiREYrWExpZnJER0ZDSktGYTlp?=
 =?utf-8?B?ODVmZ0JJWE1yQWlsR2hnY1NwV1pSbEI2VlNIY2VBRkViaTlKb056MERxVnRE?=
 =?utf-8?B?TTJqcUg2VFNHVnhIK1ZRRHo2Ky9QV29ZZ2x6czJodk5Bd1ZiK3ZkWXI1SUxj?=
 =?utf-8?B?R0lFUTFORysrdlU2L3FUZDlaZUYxaFpuQ1huTUkvNmtKU3VCSzhBRTNjaUti?=
 =?utf-8?B?R0szZWlndXdZdVJ0eTdPblA4cTBKdzhqVENzdE51U0xkUUpWR1VtYlVHaEtw?=
 =?utf-8?B?NXU4K3U2cjIwQ0RJVUl2Z2ZDTThUcnl2UUpLVU1HaWxqdG44QWJaMkNNSGky?=
 =?utf-8?B?b0FLNWtmNG1JakNKTzZ3NGt5a0xxeXJGN3JKOHlyblhITFBkQzgwT1N0WG5L?=
 =?utf-8?B?RWJwRjlucnVTS1MxdUNPNmkwWHRJd0h4d1pKWGRvWnllSDUxbHZiNXFNb1Zz?=
 =?utf-8?B?OFZyUzlhTXdreGsvYXRlTTVkNk9sM1lJUEpBTGtKbUkxSHZlclJwWXBLRFc2?=
 =?utf-8?B?OG1tRmFoWk50QmdFWG4vdVV5ZG1FbFFLWUsvWmM0WjcrNkN6M05OekgvQ0Nm?=
 =?utf-8?B?dGlRdndNTElkS2V3TDBBYTJVRVBMOFFpeGpxY094RkJWb3hET0RNM3FKaENC?=
 =?utf-8?B?NEE2Z1ppeUthZXdRa3Q3L0JPY0xCc2hXTEo4SllrUkgwbEp6Q0huVGlYU3Rw?=
 =?utf-8?B?Z3VWYlpDcXZvL3NBLzRMZzN4clZYVHFlRUZ6Z1YvaDlhRGZOd3RBOFFEZ0Uz?=
 =?utf-8?B?cFhvQUIvd3FnTkVZOEMzWHhxZUIrMVFzYzBqc012cUo1QW9jbW9SSEpxNWoy?=
 =?utf-8?B?TzRucW5uL1E1eEVlUzZMUFhnbkIyNUxBT0l2dk9YakQ1dUtWL05rNmZGRnZn?=
 =?utf-8?B?cWxzUWQ3Y2ZqL0VpMm8vZkZpamduSm05L28wSmJKQXFWQnEzckkwQS9PaG96?=
 =?utf-8?B?bzNSSXNaeHdDNlYvQ0gwQWRiMWdBZ1ZUdUcvNlBTUVZ0dHNyQklCSW9XWGRS?=
 =?utf-8?B?SUtla0hxdmdYWXpDd1VMNFAxK0lzR0tDQ0FxdGpCUFcydndvMjIwZmtaZHZO?=
 =?utf-8?B?SmlnckVJWG9CYm5pejNjVUl2V29SQTZBdktOM0pob3V2RVpYeXp1blNndnpF?=
 =?utf-8?Q?TqSq+66ENfz7FbdbmM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR19MB5113.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25634c77-a557-4fba-7324-08d97f72c901
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2021 15:48:42.3148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QEKb4apy+L2w696pDRRtJzusfYDTLakW5vECwKknAF5UVgk8M+wG8GWeKf5kpXMyDKllEZajDWXRsHK9/PQnYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR19MB5066
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <8EF3981A3EACAA45AF4370DFBC6D385D@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvOS8yMDIxIDc6NTkgcG0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBUaGlzIGVtYWlsIHdh
cyBzZW50IGZyb20gb3V0c2lkZSBvZiBNYXhMaW5lYXIuDQo+DQo+DQo+IE9uIEZyaSwgU2VwIDI0
LCAyMDIxIGF0IDA1OjA1OjM3UE0gKzA4MDAsIFh1IExpYW5nIHdyb3RlOg0KPj4gR1BZMTE1IG5l
ZWQgcmVzZXQgUEhZIHdoZW4gaXQgY29tZXMgb3V0IGZyb20gbG9vcGJhY2sgbW9kZSBpZiB0aGUg
ZmlybXdhcmUNCj4+IHZlcnNpb24gbnVtYmVyIChsb3dlciA4IGJpdHMpIGlzIGVxdWFsIHRvIG9y
IGJlbG93IDB4NzYuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWHUgTGlhbmcgPGx4dUBtYXhsaW5l
YXIuY29tPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvbmV0L3BoeS9teGwtZ3B5LmMgfCAzMCArKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0NCj4+ICAgMSBmaWxlIGNoYW5nZWQsIDI4IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3BoeS9teGwtZ3B5LmMgYi9kcml2ZXJzL25ldC9waHkvbXhsLWdweS5jDQo+PiBpbmRleCAyZDVk
NTA4MWMzYjYuLjNlZjYyZDVjNDc3NiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9t
eGwtZ3B5LmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L3BoeS9teGwtZ3B5LmMNCj4+IEBAIC00OTMs
NiArNDkzLDMyIEBAIHN0YXRpYyBpbnQgZ3B5X2xvb3BiYWNrKHN0cnVjdCBwaHlfZGV2aWNlICpw
aHlkZXYsIGJvb2wgZW5hYmxlKQ0KPj4gICAgICAgIHJldHVybiByZXQ7DQo+PiAgIH0NCj4+DQo+
PiArc3RhdGljIGludCBncHkxMTVfbG9vcGJhY2soc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwg
Ym9vbCBlbmFibGUpDQo+PiArew0KPj4gKyAgICAgaW50IHJldDsNCj4+ICsgICAgIGludCBmd19t
aW5vcjsNCj4+ICsNCj4+ICsgICAgIGlmIChlbmFibGUpDQo+PiArICAgICAgICAgICAgIHJldHVy
biBncHlfbG9vcGJhY2socGh5ZGV2LCBlbmFibGUpOw0KPj4gKw0KPj4gKyAgICAgLyogU2hvdyBH
UFkgUEhZIEZXIHZlcnNpb24gaW4gZG1lc2cgKi8NCj4gWW91IGRvbid0IHNob3cgYW55dGhpbmcu
DQpZb3UgYXJlIHJpZ2h0LiBTb3JyeSBpdCB3YXMgYSBtaXN0YWtlLiBJIHdpbGwgZml4IGl0Lg0K
Pg0KPj4gKyAgICAgcmV0ID0gcGh5X3JlYWQocGh5ZGV2LCBQSFlfRldWKTsNCj4+ICsgICAgIGlm
IChyZXQgPCAwKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4gKw0KPj4gKyAgICAg
ZndfbWlub3IgPSBGSUVMRF9HRVQoUEhZX0ZXVl9NSU5PUl9NQVNLLCByZXQpOw0KPj4gKyAgICAg
aWYgKGZ3X21pbm9yID4gMHgwMDc2KQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gZ3B5X2xvb3Bi
YWNrKHBoeWRldiwgMCk7DQo+PiArDQo+PiArICAgICByZXQgPSBwaHlfbW9kaWZ5KHBoeWRldiwg
TUlJX0JNQ1IsIEJNQ1JfTE9PUEJBQ0ssIEJNQ1JfUkVTRVQpOw0KPj4gKyAgICAgaWYgKCFyZXQp
IHsNCj4+ICsgICAgICAgICAgICAgLyogU29tZSBkZWxheSBmb3IgdGhlIHJlc2V0IGNvbXBsZXRl
LiAqLw0KPj4gKyAgICAgICAgICAgICBtc2xlZXAoMTAwKTsNCj4+ICsgICAgIH0NCj4gZ2VucGh5
X3NvZnRfcmVzZXQoKSB3b3VsZCBiZSBiZXR0ZXIuIERvZXMgYSBzb2Z0IHJlc2V0IGNsZWFyIHRo
ZQ0KPiBCTUNSX0xPT1BCQUNLIGJpdD8gSXQgc2hvdWxkIGRvLCBhY2NvcmRpbmcgdG8gQzIyLg0K
Pg0KPiAgICAgICAgICAgICAgICBBbmRyZXcNCj4NClllcywgSSB3aWxsIHVzZSBnZW5waHlfc29m
dF9yZXNldCBpbnN0ZWFkLg0KDQoNClRoYW5rcyAmIFJlZ2FyZHMsDQoNClh1IExpYW5nDQoNCg==

