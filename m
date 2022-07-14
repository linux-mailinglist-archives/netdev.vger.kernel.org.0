Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7ECE5753D0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239562AbiGNRQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbiGNRQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:16:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2064.outbound.protection.outlook.com [40.107.223.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8FA45998
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:16:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2ipR9ABBv+mwHRhr5J8ix2ZS7m8R3hrHYPDD1PMV00tBPCHeScD+xn4HlPXx3n/e+bkIzzB56ijzNtpCdy51bl+yFYO/ZkG1Q1lxSCUje/Y2mpuI3ylLMijMS6KAH/jUTHrossADrZIe4OF7fp1tYHowgSRcQu6q6U+zKrEInubSDRdrM0eH4A77VG01BN3yexhG7SHppDKd5BsMHjux0RWM1s7F2MgLxc2ZYfl/FHDAXr7L/2EoTc9ClMnmABr3C9wZIpNLi2lo0WD2S21xnhmA6pA8BGIuJ9cdmWBTqZryEqLXDOLL9KQ+vKxzpS6yp4hflnjBLCJ5uU1/48auw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TODH8T0JAZMTKj0K5uDgOQ0GeHlAVibc5+oW36R2vkg=;
 b=VCuuSBcEfT/DH+vsty7BrTVtF+yVeLL4Aa3O4WOSJIa8XJa1hlo9irFB9NMsARxf0sFrhxFsvYLOYmWNoCIHSl1tpEqC6/PW9D2qf7YtIqUhuuMrvCR2ZmfGKWaKkxGK26ytq6EFBGAtp7hOuGvLzq9EttFkxfneW0SQLrcRMgazQrNRRu3T1Dc27Q2c7KEKKk99lLgFJr9vfhNmRGF1sHCjmIL+6vCG31L0s5Q6skHFFbbgN26V4a945mPxfbM9hb82zv1RNuCN3VciTFUvTuBroFMiSXjvVCV6AfjPQt7NpYuyqY4H0OJzWZwD1cBV56ekhehOgzA72RF8TQpYtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TODH8T0JAZMTKj0K5uDgOQ0GeHlAVibc5+oW36R2vkg=;
 b=RBjkUB94uq5GP84b3K+Zfef9WHsLiVOT73RjKoSjSvW2GMaAaLCv1JRcsn/9V/DxBQAwC/796DTNoZoZyB3XyOqV/fiUdfOTkbQYkSae2xVYhgt92PCzXM+sfuawkqxrRnlF2R2pAfkuj2qvKuhKFILxn6hp2BvNrs469Te41jM=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Thu, 14 Jul
 2022 17:16:02 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::88b4:c67c:e2e2:7dbe%9]) with mapi id 15.20.5438.012; Thu, 14 Jul 2022
 17:16:02 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: network driver takedown at reboof -f ?
Thread-Topic: network driver takedown at reboof -f ?
Thread-Index: AQHYl40Svy5jf8uV0UGBbesFglmmI6199V2AgAAmUIA=
Date:   Thu, 14 Jul 2022 17:16:02 +0000
Message-ID: <5156c006ee7c362ef26b2ad28eea2196c847a106.camel@infinera.com>
References: <997525652c8b256234741713c2117f5211b4b103.camel@infinera.com>
         <191adc26-28d3-758a-7c9a-53e71a62b0fa@gmail.com>
In-Reply-To: <191adc26-28d3-758a-7c9a-53e71a62b0fa@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8026d02-bd67-4bc8-729b-08da65bc874f
x-ms-traffictypediagnostic: CO1PR10MB4418:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /9OVZDGLaS9Oh3HAImiXJepZScAciorjY49wUH3cpIhVUHK+wMYhGCSKKB6hNgvAcS7drwqHwMmIMtget7NR9fJ+PXgroZcUI8gcmJq23Lj7IeNvvGUdJokk05D1GyV7R1T4PdfCKbU+LHu07eRhHUkuzzVLplgVCQrVDTFJ0wyHx6w0xcMCieDZ/YGuDJpCm7l2hGm84MAF2mOLI6uOqoFo3BD5kr1xFuM0qVVIdg7ygedPy32BOrgOtcRCiddTDIDDtr/6woXav84GS948qZTw216X63o36BVvYCfH6AAQauoZxmTjX2kRtfoGZw5+T6qPAFHNviOKIgRsg6DkAFPAXT6x/SOO4u3nYjwEYXhOgkBf/pQFJIX4Ba42qckBdv9O7nO9FdPGFjr6pyMJ9ehuAtfQ2aW0BorzPM6+okK84zWKMtQMRtB29qZXiNO+Im+91/Dq2yCUNKmUZYZHcR5hHbJB0OCPt760y27LHCSR2hRCoQkxoA2LagOKimnZk3uBGUNZd7CA0J/F3AD5AtzkRo9rX9eqjOmh66sCFFKEt2Yuy4OgsRnYr1ao/ofdIAVRPQQ7ouI6kRbO8RUxhuhReEOX7a52br1OQB0aYspxPinhSDnFvGkRX2GEek/ecZFnyxwVqyQW1aw17d1jIqb4rFSxeoIvWJUthjQKQKIMWa7cFeFjCq6Ww9iRyFhokWXV/Dx+ne6s8fWmhOSIQNWsUjUCOvguZLllzFN5bX4ZDsQ1OQIavs9bSVnuqW8HBMnf5ZdpHtqdLUX5X6/S8NrTsPzJDxsXmy9Fh5p8kSJpUjoZOXqhXFOzDgwNl4vdfaUvhB9OkQ93VhkJdbzRniJJH9X8YSObD2K0iYN+2lA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(186003)(83380400001)(8676002)(66476007)(71200400001)(91956017)(66946007)(66446008)(45080400002)(66556008)(76116006)(64756008)(2616005)(26005)(36756003)(2906002)(6506007)(110136005)(53546011)(6512007)(38070700005)(122000001)(6486002)(966005)(5660300002)(41300700001)(316002)(86362001)(478600001)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akU5ZGNWczJNNEVqbUxtM2N6NUl3U3EwVnV5dWt5bUJUeWw1OVZaWGhEakln?=
 =?utf-8?B?dThCd0VWc0dDZEc0NGtuZmlLajI3TlBxYjd4dTlWMm1OOHQ5WnBBdnhrZklt?=
 =?utf-8?B?NERFaFh4bzdZUTJEOWEvYXR5ejcvTFhaZjlQRlJnYkpTcEhndHNSZUZ1TUR6?=
 =?utf-8?B?SS9KYkdQWlFTWUZwRE1XTzZxZlBSbjQyekhtVUJVLzljRS9OVHg2Um9SYWQ3?=
 =?utf-8?B?djV6Rmc1cy9GYURzN2FIMXNRcTJFcThBMk0xcHVtOURMYjhmS3YzeTd0TE1J?=
 =?utf-8?B?Q1JIUWJaZ00vMTFzYjlpTm1pL2ZmOExubHpoMWhVMWYrRmxYODRJOHBhNUtY?=
 =?utf-8?B?RDViK2JUejF3ODlteElNcStEaTZNcFd5RWZ4VWlSck4weDdRNTlhY3lqS0VZ?=
 =?utf-8?B?MWxxRU5jb3l6K1MxQURKd21HVXh0a29SODZ3Z2pVYnA2SnVkV29mOGZLbmtw?=
 =?utf-8?B?S0hCQU1zRlB1N1JKVG9QOVRnK3FXQWlab3dYQmR2bE4rdEh5OFJjanFTV2Ix?=
 =?utf-8?B?My85U3gzejVxOG5lUURsWkl3V3hFOVNLSW4xVmo5SU9OamYxbjRRd0hmVGFt?=
 =?utf-8?B?R3EzSDZ2Tm4zU1VVelVBWmloSGRTbzBkZkNYY0U1MzArSkNnS2V5QiszZWFl?=
 =?utf-8?B?YzVjck9XaTM5bHptS0hlVjl4TVlWVXJmWVhvUGJtY2FsK0wzZ05oSldWUUdv?=
 =?utf-8?B?V1FLdXNnMUsva0ZGRnQwa0wrdTNXTTVIZjl1NUJ0WDZ4aDBjcXc5SjFuUlJh?=
 =?utf-8?B?M0NmcWZadnB3N0xhVnRjVE1aUVlReVJYUDFLTGg3Z2dqMU1CaDBwZ1RFUjY2?=
 =?utf-8?B?Y2RjZ1IzK3h3Tk9iTzBja1JlaDBNSzFrU2hoeVBuSFgwL2RFVkRXVXM2eW1o?=
 =?utf-8?B?b0xNdVJLRlZBamVyNlRuQXQyaHZLdldIaERkbHJpcGxDS004U2o2QlNEWWJN?=
 =?utf-8?B?TjFReC9Mai9SUVo5TDFhZVZvY1h6djhkMkNDb28rMlVHeldQQ0FkbTI2T21l?=
 =?utf-8?B?dzlubjRjRVlEVkZ2M2s1OHNWVU5sQ2R1eUw0VWpnb3RaUnd2YUkyWXJUY1hu?=
 =?utf-8?B?bHVnQ21UdkFtek5TM3Vwc2lCa0FsbjJ5cnR3TXd5NmVFVWdERXJCZlNOWWlv?=
 =?utf-8?B?cHBvQ0Y0eERMUDZHV3ZSVTlDTGo5OWxzNGd1VktralVYSnZZT2NZOVZ5MGJr?=
 =?utf-8?B?b21ZSU9BaEhnSVFySjBoaEFQdzc5UzRBVjNrRGlPeUJFK1lIMTd0SDNYOXFN?=
 =?utf-8?B?MVBwSG9MaUxwSGE0bWZ2RFUxekpvRU1YT0lsRlRtN1Uzb1NIMkNsUGowd2dj?=
 =?utf-8?B?dDJ4bjRDU29XYVFtK2ZhZkNtRHQ0L1ZaZGtnazJsaEFoOHNKTEJsZmE2OE1x?=
 =?utf-8?B?ajlWMlZ0b3dLUGtPWDhOVmpVSFNCQnhTWCs4RFFoM0FRclFlTkpXMGlwZXFF?=
 =?utf-8?B?UFUyT0EzWmdvY0s3UHRYYkdDUzR4OFVZS1I3YU1NcmxlVW9IZWgrK0t2ajhn?=
 =?utf-8?B?QzJLelFjUGFZSDdBbUlveUdpVndQVGI4Skx6bHZJMUpvak85Ym5HVmhITjJ2?=
 =?utf-8?B?MEcweWVBZ3NjbFhJSUxoZFZVdFNabDZvZXA0QWVMSjduTHRYQk0ydm1oWnhk?=
 =?utf-8?B?WElyckxqbEkzdWFSdW1aaGoyY3BjSXVwOGVnS29UY1J0NUl3VTUyVmdpZjh1?=
 =?utf-8?B?OHZ2YlhZZXlxMkhwZjFJNit5WDdrMW1Bb1FjdXU5OWlsYzJkSS92d3Q1K21a?=
 =?utf-8?B?RmJzZ3hHY3BiTFUyWmpxUUtBQnVranFZait3OEQ5bkVGS3AvZVdiN05GOTZT?=
 =?utf-8?B?WWF2TG5MN2h0MVh0cUxwdWFGbU5kWWVhR3Y2cVJIK25jdXZhT1FFVHB6SWN2?=
 =?utf-8?B?Q2VHSGJVWVE1RGNjNW1oTlZLcWV6YksvMTJhZldwTll4TGMrNXovRmd2SmUv?=
 =?utf-8?B?aldqYjhaLzZ1N0x2ckIwNDl1eTU4QkpiTDJjK2QwU0ZWajIzZ21ZV3l3QkYz?=
 =?utf-8?B?Qy9veW8zSWJzbHhDYjJJQXh3NDQrdkliaVM5Sm1rUzdBdWJBSVVOS2dVRkZE?=
 =?utf-8?B?SFlGUWIveldSR3dWeUNwSVJFTXM0OFdXOEhwWFVSeVJ4aVAyODd6OExBYll4?=
 =?utf-8?Q?xrsbG89W0Hb1wX1ejeM3ky+38?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5264C075F0A5BC4689D4FE952FB26551@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8026d02-bd67-4bc8-729b-08da65bc874f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2022 17:16:02.4421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGtzo6cyfc4OqtytCsPe3+jkeT4vLHYeF1rVSy0inzYGpGh4gm7emAv9qtXh6B2WohIdQ5XU8m3F6eZ2kTVefw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTE0IGF0IDA3OjU4IC0wNzAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3Rl
Og0KPiANCj4gT24gNy8xNC8yMDIyIDc6MjEgQU0sIEpvYWtpbSBUamVybmx1bmQgd3JvdGU6DQo+
ID4gRG9pbmcgYSBmYXN0IHJlYm9vdCAtZiBJIG5vdGljZSB0aGF0IHRoZSBldGhlcm5ldCBJL0Zz
IGFyZSBOT1Qgc2h1dGRvd24vc3RvcHBlZC4NCj4gPiBJcyB0aGlzIGV4cGVjdGVkPyBJIHNvcnQg
b2YgZXhwZWN0ZWQga2VybmVsIHRvIGRvIGlmY29uZmlnIGRvd24gYXV0b21hdGljYWxseS4NCj4g
PiANCj4gPiBJcyB0aGVyZSBzb21lIGZ1bmN0aW9uIGluIG5ldGRldiBJIGNhbiBob29rIGludG8g
dG8gbWFrZSByZWJvb3Qgc2h1dGRvd24gbXkgZXRoIEkvRnM/DQo+IA0KPiBJZiB5b3Ugd2FudCB0
aGF0IHRvIGhhcHBlbiB5b3UgdHlwaWNhbGx5IGhhdmUgdG8gaW1wbGVtZW50IGEgLT5zaHV0ZG93
biANCj4gY2FsbGJhY2sgaW4geW91ciBuZXR3b3JrIGRyaXZlciByZWdpc3RlcmVkIHZpYSBwbGF0
Zm9ybS9wY2kvYnVzLCBpZiANCj4gbm90aGluZyBlbHNlIHRvIHR1cm4gb2ZmIGFsbCBETUFzIGFu
ZCBwcmV2ZW50LCBlLmcuOiBhIGtleGVjJ2Qga2VybmVsIHRvIA0KPiBiZSBjb3JydXB0ZWQgYnkg
YSB3aWxkIERNQSBlbmdpbmUgc3RpbGwgcnVubmluZy4NCj4gDQo+IFRoZXJlIGlzIG5vIGdlbmVy
aWMgcHJvdmlzaW9uIGluIHRoZSBuZXR3b3JrIHN0YWNrIHRvIGRlYWwgd2l0aCB0aG9zZSBjYXNl
cy4NCj4gDQo+IGh0dHBzOi8vbmFtMTEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20v
P3VybD1odHRwcyUzQSUyRiUyRmdpdC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJGbGludXglMkZr
ZXJuZWwlMkZnaXQlMkZ0b3J2YWxkcyUyRmxpbnV4LmdpdCUyRmNvbW1pdCUyRiUzRmlkJTNEZDlm
NDVhYjllNjcxMTY2MDA0Yjc1NDI3ZjEwMzg5ZTFmNzBjZmMzMCZhbXA7ZGF0YT0wNSU3QzAxJTdD
Sm9ha2ltLlRqZXJubHVuZCU0MGluZmluZXJhLmNvbSU3Q2YxMDdlYTRjNTczMTQxMWE4MTNkMDhk
YTY1YTk2YTRkJTdDMjg1NjQzZGU1ZjViNGIwM2ExNTMwYWUyZGM4YWFmNzclN0MxJTdDMCU3QzYz
NzkzNDA3NTU3Nzg0MjIwMyU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3
TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MzMDAw
JTdDJTdDJTdDJmFtcDtzZGF0YT1RZXJKbzEwdXZOSlc5YUk0UGFSRXZvV3NaS0F6bjhTR3g2SEFQ
MVpyJTJCdDAlM0QmYW1wO3Jlc2VydmVkPTANCg0KRXhhY3RseSB3aGF0IEkgbmVlZCwgdGhhbmsg
eW91IDopDQoNClRyeWluZyB0byBhZGQgYSBzaHV0ZG93biBJIGhhdmUgYSBwcm9ibGVtIGdldHRp
bmcgYXQgcHJpdiBwdHI6DQpzdGF0aWMgdm9pZCBjY2lwX3NodXRkb3duKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpDQp7DQoJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsNCglz
dHJ1Y3QgbmV0X2RldmljZSAqbmRldiA9ICh2b2lkKilkZXYtPnBhcmVudDsNCglzdHJ1Y3QgY2Np
cF9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7Ow0KDQpBYm92ZSBkb2VzIG5vdCB3b3Jr
LCBteSBwcm9iZSBoYXM6DQoJbmRldiA9IGFsbG9jX25ldGRldihzaXplb2Yoc3RydWN0IGNjaXBf
cHJpdiksIGlmX25hbWUsDQoJCQkgICAgTkVUX05BTUVfVU5LTk9XTiwgY2NpcF9pbml0X2Rldik7
DQoJcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KICAgICAgICBTRVRfTkVUREVWX0RFVihuZGV2
LCAmcGRldi0+ZGV2KTsNCg0KSSBtdXN0IGJlIG1pc3Npbmcgc29tZXRoaW5nIG9idmlvdXMgLi4u
Lg0K
