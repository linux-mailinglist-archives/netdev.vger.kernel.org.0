Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3E526BAF
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 22:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384440AbiEMUio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 16:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355333AbiEMUim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 16:38:42 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10107.outbound.protection.outlook.com [40.107.1.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC20179C2F;
        Fri, 13 May 2022 13:38:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C0muRwBuMJTkMAKKCHnCEGZ1DhsBvia2oyjANHDtvxQiUBKbI1NGIVF2zxuRNU9UTqjfbJCPM4U27eJhNBHSJ0i3saRIjFjh/EJ5Rg0DKmCoJ+KD80q8sd67JgsrxBr40RQSdMYMJjCTDyJjIeceaqy+9yPy/xVmu3n/yDVy6Ybpob+14RZI1Jbao3AG5fK6PINljZ1ja/LQB+cPgVvwPjNCo0S2PvDxxQx8TkG7kbIz8xxc0OXwgeKT0PI0+BcC+dh9LoaCJFo3u+khbD35DOgBnnAIMi26DZjihIBW7/AiIK2rCdHZeZFOjWqg/yEvytqEFXg6iLQxqyClQC2hnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=47N8EM0spfJhiGaKx3jVraaalULx9+kIAtxJmMXmxxg=;
 b=B0G15EIeZXT/1Tauh5Sa22kNkciCy4NHPmuuq/vZ2NvD7E82MpoCuq3L32hY/A3tOzcdfcuGRlB/RR/ayqFASb9uvNLgHynF2WB+bZnX3Vtii7xSUDgcMCvzTUAeREGRKLEGKgKJdjFs5Ga/5YHYYBtONZKggJFn6fJdaKL18A50f7GHguUTUaJhM+4slLbyd9huiwZej7VUfNY36Ev5zkj7kSkrNn16YwAFeRQvrRRZl2OKwbYcH879KKZh4twNYnIdhXzTLJTQF6TPzKuYvo6ou59EBy69tpV1s48rHcoAIv7xNMXaj7mRO2qI/0aFUDHmsNR+m56pGbOxsvvRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=47N8EM0spfJhiGaKx3jVraaalULx9+kIAtxJmMXmxxg=;
 b=dLfmsy6iDW/jEMsdt+9ldVd9TYncL9hCjyvPlqPs+91/B92xj21OP30WANymUKwBwhmA9Z/iAc4Jd3x+059Gsd1X/X9RSjXOYiKJWXWs5V7HKwLI21Nez/rA50HY7G+4SFoS6il6Z4rQ8YJLFj9UwaUWGxOjaAgfgALim1NM1ME=
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by VI1PR04MB4318.eurprd04.prod.outlook.com (2603:10a6:803:47::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 20:38:37 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::d92d:6b1:cc94:fe26]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::d92d:6b1:cc94:fe26%7]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 20:38:37 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "Skajewski, PiotrX" <piotrx.skajewski@intel.com>
CC:     Stephen Douthit <stephend@silicom-usa.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Thread-Topic: [PATCH v2 1/1] ixgbe: correct SDP0 check of SFP cage for X550
Thread-Index: AQHYWKbugTda+MigG0adrRulWMX2cq0blMSAgAG/bYA=
Date:   Fri, 13 May 2022 20:38:37 +0000
Message-ID: <VI1PR0402MB3517DE4A2EFD5E3B0A377E0DEACA9@VI1PR0402MB3517.eurprd04.prod.outlook.com>
References: <20220420205130.23616-1-jeffd@silicom-usa.com>
 <20220425131758.4749-1-jeffd@silicom-usa.com>
 <fd59c0e8-7f84-a09a-f673-339919b4a056@intel.com>
In-Reply-To: <fd59c0e8-7f84-a09a-f673-339919b4a056@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ea62971-e925-4dd1-7663-08da35208eb9
x-ms-traffictypediagnostic: VI1PR04MB4318:EE_
x-microsoft-antispam-prvs: <VI1PR04MB43188493CA4130DF2CD3499CEACA9@VI1PR04MB4318.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /CQb6KlA0tOwUQTeACEedwAANmXTuhYZPgWjIjH+yBMSet7k4lU37tb81FzifhUtU2ry87D12+V9gYYoA1qzf2JM529/v06Cz+bYSoiHs36l0CK4MdeiE112H4FbWc2K1HBraFe4bGJBQyZUloTnc+n/xs8BEcVmqq3Yc7CxC11HIk2kdeCdr1TZgM8MKiZUAvTJ9bhndZaqftMYBYHFKK3D/hXxLDTH/frD2KUNmeMq6GHLJYTYKEi3C/Ez1Y31kGLLGK3I6nWegaE7rgpSrOT0Ha8BGtl6nY6ioVM00Xc9mzwl/JFxydJaOryxEZMz9RZW3We6lHfDy669i5odNsGh4G/5LwJf1Xy3Oz6coHpghyzyUcGXuF5oORjmb6fYS5KZIQVxVYx9S7cBVz78E5eNZ6FSTNo5biBsHu2c0i0PKAyWcc1PxQC2+DsS2FvYK0DAUKCaoIEqLPm8oArfkaAIsHqJfBS61uOhVpdIhtqJX2YK3mJE3nMrAuf/3kGMdVwObDIWkEkb3zCifuWH8q1xB8zVZnTHEW+taPXpB9asoFvPoycirRIeJezadIgXeptPdKpkZFBTj49+rP70LI101KKmagNvbiymcDXFAFjoxvIK1nr6bIIrLkCr5RUVF2Jk+0uejEdx/+9phbb5Ez2QWX8Niby1Q5IGlUUCf1l4/BZc54GSntYFiy1qloK/0Q6ppkZy432DjL7ckxNiYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(122000001)(38070700005)(9686003)(38100700002)(53546011)(33656002)(54906003)(110136005)(6506007)(7696005)(8676002)(66446008)(66476007)(4326008)(76116006)(64756008)(66556008)(66946007)(508600001)(2906002)(7416002)(71200400001)(5660300002)(83380400001)(186003)(86362001)(52536014)(55016003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzRsdDcvY2FqVzhyRVVER09BY3JFUTdUQnl1M1B1MWNLUVZpNkVNcFJMeGZk?=
 =?utf-8?B?b3pValhGTVNXSVZNeDNUTVpEZHhaN1NvUVNjaDVrVDZtOGlTOFBwNW9tME5i?=
 =?utf-8?B?VjFQNkJIRUtwTkJVRVBXeHlrWWFpMm54ek5qK294WmMydytVUUl1Y2FIaWRj?=
 =?utf-8?B?NC9PeWpRRFN5M2RSWmFoTjlYbnhaaWZCcS9lTjhVWm5DU1RQaUZoQ3hVSXBH?=
 =?utf-8?B?NEVzT2c3RkcxNk5JK2dOQzh5MnZHWDNJblladU5pSHNzVnVJYy9MQ3N4RWsz?=
 =?utf-8?B?L2JyNmdBMHJjZ2ZiVVl1YzZUQU5mRzMxWmhrSlE5bnljTEFaWTFhS0dFbGV1?=
 =?utf-8?B?T2NISW1WWS81QXFqNkdLQjVDdlI4SnZxZnlXdUU4RFdrUi9lNE9wQUN5QktG?=
 =?utf-8?B?Y0ErN0l4b3c5SS8yZUxjR1FkNWxGMko2RE9ka2tGY28zZTNMNjFZcWhnQkc0?=
 =?utf-8?B?VHZwd0lEN0FwUldVdVVRL2FzYm9QMHlZVWJwdkJ6b2w4UDJTNEsvVlhxQlBS?=
 =?utf-8?B?R2RlOC9pb3dFazdyK1JmT2xjV3lNZ0xNWjdkYVdxNWpPRUNJaFFabHNzcHJw?=
 =?utf-8?B?OVNIbk5oTWFMQW9HZ2hBMDFNZCsxNUliRk1LUXN1bDNZNExjYWNTUHF0TGRB?=
 =?utf-8?B?T2Q2V2VPSHFUNE5aSzZ1OWNpY1RrdmpPOWFZbGxoeVo5QnZYSkllYm51eFpB?=
 =?utf-8?B?UWtlMHdsamU0WlhNNklDZDg5cFp3VU1POWxYay95SkprUnhBK2JkaUdDblFu?=
 =?utf-8?B?bG1oa2ovMTJacmZLRWdPeWUvc1IvdGJMQnFwQnRiMUg4N3A3NzQzYXJJZXdB?=
 =?utf-8?B?QzNJMENPd2M2QXQ4cWY1SWFjeGprYWlPYUZSMWNHVnhMTVg3dVRoVUlyQmpz?=
 =?utf-8?B?Zm0xMXo0bGg5d1k5ZEp1bHJRNnJvbzFKRnBEV0EvbFNoU2xBUUd6YzhaZVhC?=
 =?utf-8?B?b0RVdE5nT2d5Y2x5QjdJb0JuQWlyekpyYThQSlFUWDlBb1Y5SzhPYVA3VHdi?=
 =?utf-8?B?cmNnU3MzSFNQS0dsd1F6OU1pYW1sQzV3YW95NWJDNUNhQzlmc2svT3lNM1Y1?=
 =?utf-8?B?cm9hWTZoQzVzbVBpNmxObTIwd2dLSU8rcGZ3L2ZINEJ3Q2doWnRITmkzc3d5?=
 =?utf-8?B?aXNXWGliNzZzOHBoSGtMYmFvNmQ3NWtIdkZSbVNvWDZCRXZ4R1FLT0JCVFds?=
 =?utf-8?B?cEk2NmplMEJWMFlBdXRxV2JLWXFhQVRDVWJxdFJjMUZ0bllHVWtHR3l0T0Vp?=
 =?utf-8?B?cWY3VnArdFIzeUVnUkdaOVgxdFFXeDZPUzRvbkRuUER1TVk1c2UxaFN4V1h1?=
 =?utf-8?B?Y09ka1JTQzVNZVAwSnZidzJPczkrUEVXenAzUHloVS9LWm9SQVAvamtQeCtr?=
 =?utf-8?B?MDlzYlIrTUVPaExoeExFS01nKzJaQXgvcW5zc0VMdlo1NmFGVzRrSmZiNDF6?=
 =?utf-8?B?TGcvbHRuWEtKbjVGUXllNUZVS3U3QWRUL2R4S21yejJNM2pKNVNUekdRSDZH?=
 =?utf-8?B?UmxXWldHYUQ4cFp5SFowWEROeU1nYVd4UEJrbW5zUXZRZmNyeUgzNzB5SFJz?=
 =?utf-8?B?d200aVV0MDlmY1k1bmwxYjJROWJmYVIxSTRDUkcxYW9NSFA5bDhjeDVEUmRX?=
 =?utf-8?B?NHp2d042aGpWV0R2Z2xXY21GK1lNam1qL0EyZmFYZUh5QVVDNGlOaGt3bFBj?=
 =?utf-8?B?MzA3em5XQ0d6b1JsVHFlL2ovV0JkYnJXbEtmN3ljWXV0akl2cjFYN1dlK1g4?=
 =?utf-8?B?NTFub3lNMXhOb29wZHpmU0hkRlZsZWJhVkRWL1lJU0pOYmVtbG9mUDh1L1lv?=
 =?utf-8?B?MFJoZy96SXI5RkpDMUx2aDNaRm5lYTVYMHgwWG50VHVTT2xzRFRZbURHVGZu?=
 =?utf-8?B?WGFCNnlWQThxYVIydFRrejZrNURWN1hXSTYydFR4ZGF2UU1rMnFCSWhleHBn?=
 =?utf-8?B?L2ZreEpxOG02dFVKcnVQcGFwWmdyOEZMUUFBYXFuWS9DUjRiT1pyQ3VKbUg3?=
 =?utf-8?B?ay9DV3JhaGVLdjQ5UGh5NGVxVGRBcjMySVNka1d1UVpFWmE1ekR4cmlFNmdS?=
 =?utf-8?B?OFdkblJGVFNwOEhTQm5DZFAwSkQ5SXNqRDNUWlRLbW9hcFFBQng4djZlcGdQ?=
 =?utf-8?B?ZVFXTHhRNzRzb2k1YUlqWjEwcXhrUnBkYzJxTmV1Qk1ZRmdDNnNnR0FoaVE5?=
 =?utf-8?B?bVJWTXZ5V3RLOHNVeDB2K0x0NkZGMVp1YysvSnJpbWdpZDZnQjcyQ2doeFlK?=
 =?utf-8?B?cEd3ZXJOZlUwTVF4dnZwQlhieFZHcVVoL2dQMnhFRFMzbnRVempMKzlZT0li?=
 =?utf-8?B?MVNpNVFmMElEVm80Z3hXM1NDaUx2RjVzN2sxWDZGWUNQOEVMbXl2YmxyeGc1?=
 =?utf-8?Q?w8PXoCPGObqB9YXy6iMR/TgOQqlQtnk2mDN/+SwzKY/gZ?=
x-ms-exchange-antispam-messagedata-1: hSoDHTPSTJXhqA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea62971-e925-4dd1-7663-08da35208eb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 20:38:37.5622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQ1VvZzOPSirkYecR2gzSoEoGzqoORGBbUMpPCyz3L6PJqlG65iu71jS0a2aiMyYVeDQhs8bGUj/T6ko3z0i/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4318
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9ueSBOZ3V5ZW4gPGFu
dGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPg0KPiBTZW50OiBUaHVyc2RheSwgTWF5IDEyLCAyMDIy
IDE6MDkgUE0NCj4gVG86IEplZmYgRGFseSA8amVmZmRAc2lsaWNvbS11c2EuY29tPjsgaW50ZWwt
d2lyZWQtbGFuQG9zdW9zbC5vcmc7IFNrYWpld3NraSwNCj4gUGlvdHJYIDxwaW90cnguc2thamV3
c2tpQGludGVsLmNvbT4NCj4gQ2M6IFN0ZXBoZW4gRG91dGhpdCA8c3RlcGhlbmRAc2lsaWNvbS11
c2EuY29tPjsgSmVzc2UgQnJhbmRlYnVyZw0KPiA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+
OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgSmVm
Zg0KPiBLaXJzaGVyIDxqZWZmcmV5LnQua2lyc2hlckBpbnRlbC5jb20+OyBEb24gU2tpZG1vcmUN
Cj4gPGRvbmFsZC5jLnNraWRtb3JlQGludGVsLmNvbT47IG1vZGVyYXRlZCBsaXN0OklOVEVMIEVU
SEVSTkVUIERSSVZFUlMNCj4gPGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnPjsgb3Bl
biBsaXN0Ok5FVFdPUktJTkcgRFJJVkVSUw0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IG9w
ZW4gbGlzdCA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCB2MiAxLzFdIGl4Z2JlOiBjb3JyZWN0IFNEUDAgY2hlY2sgb2YgU0ZQIGNhZ2UgZm9yIFg1
NTANCj4gDQo+IENhdXRpb246IFRoaXMgaXMgYW4gZXh0ZXJuYWwgZW1haWwuIFBsZWFzZSB0YWtl
IGNhcmUgd2hlbiBjbGlja2luZyBsaW5rcyBvcg0KPiBvcGVuaW5nIGF0dGFjaG1lbnRzLg0KPiAN
Cj4gDQo+IE9uIDQvMjUvMjAyMiA2OjE3IEFNLCBKZWZmIERhbHkgd3JvdGU6DQo+ID4gU0RQMCBm
b3IgWDU1MCBOSUNzIGlzIGFjdGl2ZSBsb3cgdG8gaW5kaWNhdGUgdGhlIHByZXNlbmNlIG9mIGFu
IFNGUCBpbg0KPiA+IHRoZSBjYWdlIChNT0RfQUJTIykuICBJbnZlcnQgdGhlIHJlc3VsdHMgb2Yg
dGhlIGxvZ2ljYWwgQU5EIHRvIHNldA0KPiA+IHNmcF9jYWdlX2Z1bGwgdmFyaWFibGUgY29ycmVj
dGx5Lg0KPiANCj4gSGkgSmVmZiwNCj4gDQo+IEFkZGluZyBvdXIgZGV2ZWxvcGVyIGFuZCBhZGRp
bmcgaGlzIHJlc3BvbnNlIGhlcmU6DQo+IA0KPiAiDQo+IE91ciBhbmFseXNpcyAodXNpbmcgMHgx
NWM0KSBzaG93ZWQgdGhhdCBldmVyeSB0aW1lIHRoZSBjYWdlIGlzIGVtcHR5IFNEUA0KPiBpbmRp
Y2F0ZXMgMCBhbmQgd2hlbiBjYWdlIGlzIGZ1bGwgaXQgaW5kaWNhdGVzIDEuIE5vIG1hdHRlciB3
aGF0IHRyYW5zY2VpdmVyIHdlDQo+IHVzZWQsIGZyb20gdGhvc2Ugd2UgaGF2ZS4gVGhlIHNhbWUg
aGFwcGVucyBldmVuIHdlIGRvbid0IHVzZSB0aGUgZGV2aWNlDQo+IHdoaWNoIGZhbGwgaW50byBj
cm9zc3RhbGsgZml4IGUuZyAweDE1YzIuDQo+IA0KPiBXaGVuIHByb3Bvc2VkIHBhdGNoIHdhcyBh
cHBsaWVkLCB0aGUgZGV2aWNlcyBhcmUgbm8gbG9uZ2VyIGFibGUgdG8gbmVnb3RpYXRlDQo+IHNw
ZWVkLiBTbyBiYXNpY2FsbHkgdGhpcyBwYXRjaCBzaG91bGQgbm90IGJlIGFjY2VwdGVkLg0KPiAN
Cj4gTkFDSw0KPiANCj4gQlIsDQo+IFBpb3RyDQo+ICINCg0KSGVyZSdzIHRoZSBpc3N1ZTogIHRo
ZSBwaW4gZGVmaW5pdGlvbiBvZiBTRFAgTU9EX0FCUyBpcyB0aGF0IHRoZSBzaWduYWwgd2lsbCBi
ZSBhICcxJw0KZnJvbSB0aGUgY2FnZSB3aGVuIHRoZSBtb2R1bGUgaXMgYWJzZW50LiAgaXQncyB1
cCB0byB0aGUgcGxhdGZvcm0gdG8gaW52ZXJ0IHRoZSBzaWduYWwNCmlmIGl0J3MgaW50ZW5kZWQg
dG8gYmUgdXNlZCBhcyBhbiBpbnRlcnJ1cHQgaW5wdXQgc2luY2UgdGhlIFNEUHggaW50ZXJydXB0
IGRldGVjdGlvbg0KaXMgb25seSByaXNpbmcgZWRnZS4gIHlvdSBjYW4gc2VlIHRoaXMgaW1wbGVt
ZW50YXRpb24gb24gcGcgMTA3IG9mIEludGVsIGRvY3VtZW50DQozMzE1MjAtMDUgKHJldiAzLjQp
IGFzIGZpZ3VyZSAzLTExLiAgd2hpbGUgdGhlIGRvY3VtZW50IGlzIGZvciB0aGUgODI1OTksIGl0
IGNsZWFybHkgDQpzaG93cyB0aGF0IFNEUDIgKGFzIGluIHRoZSBjb2RlIGJlbG93KSBpcyB1c2Vk
IGZvciBNT0RfQUJTIGluZGljYXRpb24sIHZzIGluIHRoZQ0KWDU1MCBwbGF0Zm9ybSBpbXBsZW1l
bnRhdGlvbiB3aGVyZSBpdCBhcHBlYXJzIHRvIChhbHdheXM/KSBiZSBTRFAwLiAgQnV0LCBzaW5j
ZQ0KaXQncyBhIHBsYXRmb3JtLXN1cHBsaWVkIGludmVydGVyIHRoYXQgdHVybnMgdGhlIE1PRF9B
QlMgc2lnbmFsIGZyb20gYW4gYWN0aXZlIGhpZ2gNCnRvIGFjdGl2ZSBsb3cgKGFuZCB0aGVyZWZv
cmUgaXMgcmVhZCBieSB0aGUgY29kZSBhcyBhIGFuZCBhY3RpdmUgaGlnaCAnTU9EVUxFIFBSRVNF
TlQnDQpzaWduYWwpLCB0aGVyZSBzaG91bGQgYmUgYW4gb3B0aW9uIHRvIGNoYW5nZSB0aGUgcG9s
YXJpdHkgb2YgdGhlIHNpZ25hbCB0byBpbmRpY2F0ZQ0KcHJlc2VuY2Ugb3IgYWJzZW5jZS4gIEkg
c3VibWl0dGVkIGEgZGlmZmVyZW50IHBhdGNoIGZvciB0aGUgVFhfRElTQUJMRSBjb25maWd1cmF0
aW9uDQpmb3IgcGxhdGZvcm1zIHRoYXQgZG9uJ3QgdXNlIFNEUDMgZm9yIFRYX0RJU0FCTEUgYW5k
IGl0IHdhcyBuYWNrJ2QgYmVjYXVzZSB0aGVyZQ0Kd2VyZSBubyBtb3JlIG1vZHVsZSBwYXJhbXMg
YWxsb3dlZCAod2hpY2ggaXMgaWRlYWxseSB3aGF0IHRoaXMgcGF0Y2ggd291bGQgYWxzbyBiZSku
DQoNClNvLCBpdCBkb2Vzbid0IGFwcGVhciB0byBiZSBzcGVjaWZpY2FsbHkgcmVxdWlyZWQgZm9y
IHRoZSBwbGF0Zm9ybSB0byBpbXBsZW1lbnQgdGhlIA0Kc2lnbmFsIHdpdGggYW4gaW52ZXJ0ZXIs
IHNob3VsZG4ndCB0aGVyZSBiZSBhIGNvbmZpZ3VyYXRpb24gb3B0aW9uIHRoYXQgbWFrZXMgdGhp
cw0Kb3Bwb3NpdGUgcG9sYXJpdHkgZGVwZW5kaW5nIG9uIHRoZSBwbGF0Zm9ybT8NCg0KPiANCj4g
PiBGaXhlczogYWFjOWUwNTNmMTA0ICgiaXhnYmU6IGNsZWFudXAgY3Jvc3N0YWxrIGZpeCIpDQo+
ID4gU3VnZ2VzdGVkLWJ5OiBTdGVwaGVuIERvdXRoaXQgPHN0ZXBoZW5kQHNpbGljb20tdXNhLmNv
bT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKZWZmIERhbHkgPGplZmZkQHNpbGljb20tdXNhLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX2Nv
bW1vbi5jIHwgMTAgKysrKystLS0tLQ0KPiA+ICAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9u
cygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9jb21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfY29tbW9uLmMNCj4gPiBpbmRleCA0YzI2YzRiOTJmMDcu
LjEzNDgyZDRlMjRlMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRl
bC9peGdiZS9peGdiZV9jb21tb24uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2l4Z2JlL2l4Z2JlX2NvbW1vbi5jDQo+ID4gQEAgLTMyOTksMTcgKzMyOTksMTcgQEAgczMy
IGl4Z2JlX2NoZWNrX21hY19saW5rX2dlbmVyaWMoc3RydWN0DQo+IGl4Z2JlX2h3ICpodywgaXhn
YmVfbGlua19zcGVlZCAqc3BlZWQsDQo+ID4gICAgICAgICogdGhlIFNGUCsgY2FnZSBpcyBmdWxs
Lg0KPiA+ICAgICAgICAqLw0KPiA+ICAgICAgIGlmIChpeGdiZV9uZWVkX2Nyb3NzdGFsa19maXgo
aHcpKSB7DQo+ID4gLSAgICAgICAgICAgICB1MzIgc2ZwX2NhZ2VfZnVsbDsNCj4gPiArICAgICAg
ICAgICAgIGJvb2wgc2ZwX2NhZ2VfZnVsbDsNCj4gPg0KPiA+ICAgICAgICAgICAgICAgc3dpdGNo
IChody0+bWFjLnR5cGUpIHsNCj4gPiAgICAgICAgICAgICAgIGNhc2UgaXhnYmVfbWFjXzgyNTk5
RUI6DQo+ID4gLSAgICAgICAgICAgICAgICAgICAgIHNmcF9jYWdlX2Z1bGwgPSBJWEdCRV9SRUFE
X1JFRyhodywgSVhHQkVfRVNEUCkgJg0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgSVhHQkVfRVNEUF9TRFAyOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBzZnBf
Y2FnZV9mdWxsID0gISEoSVhHQkVfUkVBRF9SRUcoaHcsIElYR0JFX0VTRFApICYNCj4gPiArICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIElYR0JFX0VTRFBfU0RQMik7DQo+
ID4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgY2FzZSBp
eGdiZV9tYWNfWDU1MEVNX3g6DQo+ID4gICAgICAgICAgICAgICBjYXNlIGl4Z2JlX21hY194NTUw
ZW1fYToNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgc2ZwX2NhZ2VfZnVsbCA9IElYR0JFX1JF
QURfUkVHKGh3LCBJWEdCRV9FU0RQKSAmDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBJWEdCRV9FU0RQX1NEUDA7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHNm
cF9jYWdlX2Z1bGwgPSAhKElYR0JFX1JFQURfUkVHKGh3LCBJWEdCRV9FU0RQKSAmDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIElYR0JFX0VTRFBfU0RQMCk7DQo+
ID4gICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICAgICAgICAgICAgICAgZGVmYXVs
dDoNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgLyogc2FuaXR5IGNoZWNrIC0gTm8gU0ZQKyBk
ZXZpY2VzIGhlcmUgKi8NCg==
