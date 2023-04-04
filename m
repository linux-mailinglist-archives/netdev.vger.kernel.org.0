Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC206D5AA8
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 10:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbjDDIWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 04:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjDDIWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 04:22:20 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2121.outbound.protection.outlook.com [40.107.105.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272C01A4;
        Tue,  4 Apr 2023 01:22:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1KNgGBcOxgPA3iwcrM/37GVLH2YUb4Cc5KKz58FPBfU9qLxstSl4SmDNoBYmm9pkexWE79byKFW+HhomlNq4w9etINzRSKJpTSJOz2GwDOQlkvbdU3jE6Cl3unaSDSFpnTjYDeJ8yF4TBMsYjxqdKlRseLMy7Ba4Lp0bzbpoeOJvlPVby6ZL0SC7APFqDA9P7zybda7sO+PKWka69VUayRzzn+mxBBzcsM+VCAzHuBz4JOybLS+WaCOqcOgZKcYEqZ6lkwAEgSoZwqbOsCPkW/D+SFke/bk2+Z8xZK845bpUBmrr9TrInXfBMzti5MZt8wXQymIjCKoGw/ek1gB+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k80BAJ1nvq+OiC6BIwuKsjAJvC7UdoN2NPPzvkS1t1E=;
 b=mKJa5I+l1a+iFpD4K/LDwvD8y2SN6pnQwCHZKW5zrP8/q4bZ73QG0+UwHzzAtUw3GZHq+joQL5fdvBC0aBZOjI9FYoryv9WOUezMhP87G8xCQ2Eodmo1hNGIkGYmy7xfJigsjvQ2Sz4bahMZbz9LncnA8Ht/duuLVx/g784lC3x4hL9KboiiES3wSB7118ysoMi6ez0YlGFUxjMU1Ez2q2k7YXtFGIMMJAjhSOFv9sKGD4OjfLNu8JDsWXBT5ZlTdlYXuOf6eVH7VbVoNW/1LaZaTFu4g7Vp/OMMHQucTODdCo92MQD8WxAS7eiyvxtl7mgbpg1PrmcfoJel7b+XRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.schwarz; dmarc=pass action=none header.from=mail.schwarz;
 dkim=pass header.d=mail.schwarz; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mail.schwarz;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k80BAJ1nvq+OiC6BIwuKsjAJvC7UdoN2NPPzvkS1t1E=;
 b=sFLsZ3rtSMu058pqTziSORuDumMZlgwi9jUR1GJ7OCNONE2AHXFU2xgiolRYp1c+awfCQH//iyLYyItt/16SmUrs54n+YpnBXsRyW9sG83vOR3SRL6yqWMXcg1BA23Mq9leooR+JAcqQomm1qY0ywgc+mY/n3gZqrhZbx8k+iyC0/whNJe5BZFhwym0G+J68mlhrVAGhX14xUEW3W7twwDxmoPsbcXb5UUpMd+dT0oTTfG67aT+cvGrC3bJJit3Q3UzTA6It8wR6cF8PGKhOae3hj76eL4EFdmnCXzYWj/yWUvkaftJP48cJQy3Zzq6WK+S/d094b2iGJGXojHCjXQ==
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:34c::22)
 by DB8PR10MB3339.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:119::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.28; Tue, 4 Apr
 2023 08:22:15 +0000
Received: from DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c]) by DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::ceef:d164:880a:be9c%4]) with mapi id 15.20.6277.026; Tue, 4 Apr 2023
 08:22:15 +0000
From:   =?utf-8?B?RmVsaXggSMO8dHRuZXI=?= <felix.huettner@mail.schwarz>
To:     Eric Dumazet <edumazet@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pshelar@ovn.org" <pshelar@ovn.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Luca Czesla <Luca.Czesla@mail.schwarz>
Subject: RE: [PATCH net v2] net: openvswitch: fix race on port output
Thread-Topic: [PATCH net v2] net: openvswitch: fix race on port output
Thread-Index: AQHZZsv1ixrGkSo3/Uu75CoN48dyyK8azxiQ
Date:   Tue, 4 Apr 2023 08:22:15 +0000
Message-ID: <DU0PR10MB52442D16C6AF7A9CA0A795F6EA939@DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM>
References: <ZCvSskSPwFv6kYrD@kernel-bug-kernel-bug>
 <CANn89iLpqh3vZ2qEYhhL12qDgVH1rgSJWqHf42cfX0qQfCvQ_w@mail.gmail.com>
In-Reply-To: <CANn89iLpqh3vZ2qEYhhL12qDgVH1rgSJWqHf42cfX0qQfCvQ_w@mail.gmail.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.schwarz;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR10MB5244:EE_|DB8PR10MB3339:EE_
x-ms-office365-filtering-correlation-id: c6b643bf-1d0d-45ea-f8dc-08db34e5b2a5
x-mp-schwarz-dsgvo2: 1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YR2lhAeQxFWkNvCEVd/MIPz1uRYkM/xWeOaJoB0ErvVnSjcEAKfTR8yNsIcALiDFEb9JL5q1ipEMr68WPgKhB6vqZUerasF3g8lu0yiuzLjaUc9YOwlMOO/cgUSD+RfQDrEk8RLAwOEg0ZCVP4rbhKxi81AvQDpy5sSyzMDp7aUUDdpv8y5ZjPlNFsdSPS8iM5lfLjrnwuQ/2qk0nGc/TKOEgnpPaNqvdzpWw5S5slafEIk+AauL8QhDHoTnt54ilO9T3av8E7+P7MvYV7aLS1e2noAOKzTo4RowywC70oEpUbvrwYLipa7opAKu44ShQbclwRWobEr08cIb5gilvAZPA1Wrm84uz9oQU0hpf7TaLEmr1/0wTsiZNvCXWewqrN9VCgg8viB0JL6+ubWQsCuvupXiFuuLFV2P5CREseSYXnHMwdG+tc+9mX6+n11dlZfSIfiu9DF8HkYu8pxOC9CJ0IM9IIkVTIYZ5yN+lTZvQK6/h1gPl4hqBOyIHSd/5R77D3lXuOE6o98YS2bnA/C8qhI5+M3MjFsf1wwYUHCd27ANT2ZmB/4TXWb0OwIXB6b0aqTJB2SsjEcvlHEw6jGkj+MJRgOELuODmlGYCVYO8aKMAXvxfLAzCB91RnOR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199021)(76116006)(478600001)(9686003)(6506007)(26005)(55016003)(66556008)(41300700001)(7696005)(66946007)(71200400001)(64756008)(66476007)(66446008)(6916009)(4326008)(966005)(53546011)(54906003)(316002)(186003)(83380400001)(5660300002)(8676002)(8936002)(52536014)(66574015)(2906002)(82960400001)(122000001)(85202003)(38100700002)(33656002)(86362001)(38070700005)(85182001)(46492015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk1NcmJtNlJ0ZlNXKzl3M09MVHdjcGJYcXk4OGtKcTAxaWdWQUs2SkpaUjgv?=
 =?utf-8?B?REN4aUtYdDk2ait5L3Y0VE9XRlN6NWJNWGlMS21QcmtkVHlvQU4zdGVIb2JT?=
 =?utf-8?B?RWN2U0FhR0Zic2NFYUpOOVJuQzJQT083NmsrMFFzaWxOYkZKTHdoTkNuNW5F?=
 =?utf-8?B?MXNjemNYblh2WWMvUW9BWEVGVGNTZ2tDeVZvNjdkU3BKQXVBNVErMVdpV2Uy?=
 =?utf-8?B?eUpjU01KUDRFK0wxaStCclJoeDhDMkhvL3BNS3RXdHlPK3BLUlEzMFJXWjZ6?=
 =?utf-8?B?ZStXUTVRL1NGMkFIZ0pZV2J3aHMyYy9PdlFGcWpqU0Y1MTljL0xRRGJMWnBu?=
 =?utf-8?B?WS9ZUzk5NUVoc01oZ09MQzZkc1F4djM2eldMbU81N0JOMitJcktldGE0eHoy?=
 =?utf-8?B?bk5FcmRIUWNBYXRHallFZ3JvakU0VHBPNEFRNFRjOEdaV2UrSzg0OFBjTDA0?=
 =?utf-8?B?QXN3Vy9ZYnh5NFd5dmhtS1dndnBCcG05QzlDUU1weUJtZmdmSk56eGlJNWpr?=
 =?utf-8?B?Z25HQTRYTitmVWdPcGgvaHVDWTJXZ3FtdXlvV0h1R2taQnY4SE1rRERpbzNi?=
 =?utf-8?B?Nlhvc2I5WDNjeFpRVTU4YXl2VUZRdFBkWEJqczJGODNUekxRdWxjY28vQ0xK?=
 =?utf-8?B?Qm9keXNiZlhJWDJvblc1bUFiVloraDE2M3dEMjJkZjM3bllwam9nQ1FnTXJQ?=
 =?utf-8?B?YW8rT0dJbm1YZ3kzQWkyMjVTVTJRcFpoc1ExNTRZR1hwbWJpMlNObUJvQm1h?=
 =?utf-8?B?SFhXc0djNnl6SlA0dmZYcGhjeE82NHRIS3RsMExUVGJBZGttNWs5MmIxSDF1?=
 =?utf-8?B?cm9XTlN0WG5UaGNGand5eGYxVmFGSXJMaFk5VUNXOVU2M2IrbHY4UWRiRno3?=
 =?utf-8?B?ZWpHVGhmVEhqZXJlNms3Y1BzSlRkQWROaDFLZmxRd2V5c29wQnVabzlJN3Np?=
 =?utf-8?B?VFUreG1SY3oxcXQ5M2J1Nk1jTzh5ZjlhaVJSQ2V4ZHZUeGE0R0Q2VllGUEpL?=
 =?utf-8?B?dmtTT0NsVkNJb0RxaGZOS1J3a0tHd0FmR1ZEWFpXT3hibzBqYjlRRWxFeU1w?=
 =?utf-8?B?a2FkTWdvZHdMSG55azVVeUxVZ3d6TE5hbnZEeDh5dVFualFmNzA5YWt2TVpC?=
 =?utf-8?B?d3JyemRBeFhpS0gwM3p1OHBQbjlVcHNyekVVM2xrbzVnMjVLWlBIS1JDcGlZ?=
 =?utf-8?B?UGNESU1NWjlieEhXbm9YTnVOdTVNRytQeEw3Z0FwL0pRSnYyQ3VPaGtOOTh2?=
 =?utf-8?B?Mmhha2plZWovS25XNmNvR0NJeForUTN1RU8rQ1lxc1o4aUZ5T0ZFQ2diaFVh?=
 =?utf-8?B?WU1EbnhSb3NKeUF2Q0FvL0xQQURzNVZmR3R0bng2RmtrQnJEUjhHbmFIWkJ3?=
 =?utf-8?B?ZWxHTmFUWm0rTnFxcUQxdFNWVTZhMGlNQkVranNnZmRJZFQyZlFabXZOVUc0?=
 =?utf-8?B?akZ3anhYZkhocVRZVW16WmNncStqZG56QWJXc2p5bnFKL252YUdkUThNVHZ2?=
 =?utf-8?B?TldiV2Z0SzYvZXN6NkJTR1BDWUJZRjdjQm0za0xpQ0ZGMXdIc2pMVktGbFlv?=
 =?utf-8?B?WFdINEpYSlZhcHZKQWc3TGlOZTRPd0EvRTF2ZkNGMC9uandHUnV6QTIyRE4z?=
 =?utf-8?B?L21JNmlRY1RnRWRrT2ZYOC9LVEdGM0cwM09xaUs0L0FMdSt2NFo0NEpQZXh2?=
 =?utf-8?B?QmlYWko3aHhBYTgvZWVKOXZhcGVnR1Z0azVwUE9MR1FaMzlUQ252WUZGbFlY?=
 =?utf-8?B?Q2JqTVBUbkV3Q0lGeU5EdnBuc2U1Y1RiZjlOcG5EL25EUWpUUVNoNTVqR3ZN?=
 =?utf-8?B?MkRYWlB6R1NYa2ZtWURzdlFuaDhlYzZWaVVQRVBnRnhmYkMveUo1YTV6VExX?=
 =?utf-8?B?QUpsa0REY3NQMHU5a1RFRmpqWTFMc204VU9MZ0pYZlpUL2VFc3gxVXJmeW9Y?=
 =?utf-8?B?U1NDc1F4OG43UnQwcHNVY0VDa2NVcWxpRCtKRGlRWlZXZmR5U0xXRm9mZE9y?=
 =?utf-8?B?Mks1K3NvSTBvSk1ZQ3k3TURSbitwNHh3cUZUN3lFV2RsSkNjN21xSzVXUFRl?=
 =?utf-8?B?c3BzUmZWY1premQ1cjNRM3hOOWxjU3dsdDRpWEJhelE1alMySHNFMWQ4bFBC?=
 =?utf-8?B?MWNpbDRnUVhuSWpiNHdGVzVrODBacTRPSjY1TXlrUEJyUFZQVzQ4NnlEOGM2?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: mail.schwarz
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR10MB5244.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b643bf-1d0d-45ea-f8dc-08db34e5b2a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 08:22:15.1921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d04f4717-5a6e-4b98-b3f9-6918e0385f4c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jPY5nBGhMPWwVKKbzaI+SrMOEOaiCyXWiwMRuFNZneXC/RfQDxmDyzF+OqGL5pd3l/soFlrlbe9vwugRBlYTupoziAjmeoOWZx73LxNtfgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR10MB3339
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBBcHIgNCwgMjAyMyBhdCAxMDowM+KAr0FNIEVyaWMgRHVtYXpldCB3cm90ZToNCj4g
T24gVHVlLCBBcHIgNCwgMjAyMyBhdCA5OjMz4oCvQU0gRmVsaXggSHVldHRuZXINCj4gPGZlbGl4
Lmh1ZXR0bmVyQG1haWwuc2Nod2Fyej4gd3JvdGU6DQo+ID4NCj4gPiBhc3N1bWUgdGhlIGZvbGxv
d2luZyBzZXR1cCBvbiBhIHNpbmdsZSBtYWNoaW5lOg0KPiA+IDEuIEFuIG9wZW52c3dpdGNoIGlu
c3RhbmNlIHdpdGggb25lIGJyaWRnZSBhbmQgZGVmYXVsdCBmbG93cw0KPiA+IDIuIHR3byBuZXR3
b3JrIG5hbWVzcGFjZXMgInNlcnZlciIgYW5kICJjbGllbnQiDQo+ID4gMy4gdHdvIG92cyBpbnRl
cmZhY2VzICJzZXJ2ZXIiIGFuZCAiY2xpZW50IiBvbiB0aGUgYnJpZGdlDQo+ID4gNC4gZm9yIGVh
Y2ggb3ZzIGludGVyZmFjZSBhIHZldGggcGFpciB3aXRoIGEgbWF0Y2hpbmcgbmFtZSBhbmQgMzIg
cnggYW5kDQo+ID4gICAgdHggcXVldWVzDQo+ID4gNS4gbW92ZSB0aGUgZW5kcyBvZiB0aGUgdmV0
aCBwYWlycyB0byB0aGUgcmVzcGVjdGl2ZSBuZXR3b3JrIG5hbWVzcGFjZXMNCj4gPiA2LiBhc3Np
Z24gaXAgYWRkcmVzc2VzIHRvIGVhY2ggb2YgdGhlIHZldGggZW5kcyBpbiB0aGUgbmFtZXNwYWNl
cyAobmVlZHMNCj4gPiAgICB0byBiZSB0aGUgc2FtZSBzdWJuZXQpDQo+ID4gNy4gc3RhcnQgc29t
ZSBodHRwIHNlcnZlciBvbiB0aGUgc2VydmVyIG5ldHdvcmsgbmFtZXNwYWNlDQo+ID4gOC4gdGVz
dCBpZiBhIGNsaWVudCBpbiB0aGUgY2xpZW50IG5hbWVzcGFjZSBjYW4gcmVhY2ggdGhlIGh0dHAg
c2VydmVyDQo+ID4NCj4gPiB3aGVuIGZvbGxvd2luZyB0aGUgYWN0aW9ucyBiZWxvdyB0aGUgaG9z
dCBoYXMgYSBjaGFuY2Ugb2YgZ2V0dGluZyBhIGNwdQ0KPiA+IHN0dWNrIGluIGEgaW5maW5pdGUg
bG9vcDoNCj4gPiAxLiBzZW5kIGEgbGFyZ2UgYW1vdW50IG9mIHBhcmFsbGVsIHJlcXVlc3RzIHRv
IHRoZSBodHRwIHNlcnZlciAoYXJvdW5kDQo+ID4gICAgMzAwMCBjdXJscyBzaG91bGQgd29yaykN
Cj4gPiAyLiBpbiBwYXJhbGxlbCBkZWxldGUgdGhlIG5ldHdvcmsgbmFtZXNwYWNlIChkbyBub3Qg
ZGVsZXRlIGludGVyZmFjZXMgb3INCj4gPiAgICBzdG9wIHRoZSBzZXJ2ZXIsIGp1c3Qga2lsbCB0
aGUgbmFtZXNwYWNlKQ0KPiA+DQo+DQo+ID4gRml4ZXM6IDdmOGE0MzZlYWEyYyAoIm9wZW52c3dp
dGNoOiBBZGQgY29ubnRyYWNrIGFjdGlvbiIpDQo+ID4gQ28tZGV2ZWxvcGVkLWJ5OiBMdWNhIEN6
ZXNsYSA8bHVjYS5jemVzbGFAbWFpbC5zY2h3YXJ6Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IEx1Y2Eg
Q3plc2xhIDxsdWNhLmN6ZXNsYUBtYWlsLnNjaHdhcno+DQo+ID4gU2lnbmVkLW9mZi1ieTogRmVs
aXggSHVldHRuZXIgPGZlbGl4Lmh1ZXR0bmVyQG1haWwuc2Nod2Fyej4NCj4gPiAtLS0NCj4gPiB2
MjoNCj4gPiAgIC0gcmVwbGFjZSBCVUdfT04gd2l0aCBERUJVR19ORVRfV0FSTl9PTl9PTkNFDQo+
ID4gICAtIHVzZSBuZXRpZl9jYXJyaWVyX29rKCkgaW5zdGVhZCBvZiBjaGVja2luZyBmb3IgTkVU
UkVHX1JFR0lTVEVSRUQNCj4gPiB2MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L1pD
YVhmWlR3UzlNVms4eVpAa2VybmVsLWJ1Zy1rZXJuZWwtYnVnLw0KPiA+DQo+ID4gIG5ldC9jb3Jl
L2Rldi5jICAgICAgICAgICAgfCAxICsNCj4gPiAgbmV0L29wZW52c3dpdGNoL2FjdGlvbnMuYyB8
IDIgKy0NCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9kZXYuYyBiL25ldC9jb3JlL2Rldi5j
DQo+ID4gaW5kZXggMjUzNTg0Nzc3MTAxLi4zN2IyNjAxN2Y0NTggMTAwNjQ0DQo+ID4gLS0tIGEv
bmV0L2NvcmUvZGV2LmMNCj4gPiArKysgYi9uZXQvY29yZS9kZXYuYw0KPiA+IEBAIC0zMTk5LDYg
KzMxOTksNyBAQCBzdGF0aWMgdTE2IHNrYl90eF9oYXNoKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNl
ICpkZXYsDQo+ID4gICAgICAgICB9DQo+ID4NCj4gPiAgICAgICAgIGlmIChza2JfcnhfcXVldWVf
cmVjb3JkZWQoc2tiKSkgew0KPiA+ICsgICAgICAgICAgICAgICBERUJVR19ORVRfV0FSTl9PTl9P
TkNFKHVubGlrZWx5KHFjb3VudCA9PSAwKSk7DQo+DQo+IE5vIG5lZWQgZm9yIHVubGlrZWx5KCks
IGl0IGlzIGFscmVhZHkgZG9uZSBpbiBERUJVR19ORVRfV0FSTl9PTl9PTkNFKCkNCj4NCj4gVGhh
bmtzLg0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4gV2lsbCBpbmNsdWRlIHRoYXQgaW4gdjMu
DQpEaWVzZSBFIE1haWwgZW50aMOkbHQgbcO2Z2xpY2hlcndlaXNlIHZlcnRyYXVsaWNoZSBJbmhh
bHRlIHVuZCBpc3QgbnVyIGbDvHIgZGllIFZlcndlcnR1bmcgZHVyY2ggZGVuIHZvcmdlc2VoZW5l
biBFbXBmw6RuZ2VyIGJlc3RpbW10LiBTb2xsdGVuIFNpZSBuaWNodCBkZXIgdm9yZ2VzZWhlbmUg
RW1wZsOkbmdlciBzZWluLCBzZXR6ZW4gU2llIGRlbiBBYnNlbmRlciBiaXR0ZSB1bnZlcnrDvGds
aWNoIGluIEtlbm50bmlzIHVuZCBsw7ZzY2hlbiBkaWVzZSBFIE1haWwuIEhpbndlaXNlIHp1bSBE
YXRlbnNjaHV0eiBmaW5kZW4gU2llIGhpZXI8aHR0cHM6Ly93d3cuZGF0ZW5zY2h1dHouc2Nod2Fy
ej4uDQo=
