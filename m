Return-Path: <netdev+bounces-5689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA911712757
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:17:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F91D1C21063
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95FFE18B13;
	Fri, 26 May 2023 13:16:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858BC15497
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:16:59 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4A712C;
	Fri, 26 May 2023 06:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685107016; x=1716643016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oNDFX4Eh0xmBc6ooZ5IciPewrL4fgYxsDa3hTCS+lkQ=;
  b=xpDK2H4mFDk39C+wC/X0CMUlqWZSs5eL9CeL0OtxZ1A1ga24/1taIL88
   y6y7lAb4GLFsFhtxYKB3cE57wxDcMGLxyhWBLU6ye2xXQMnkrVq6aLWTY
   /0M5xNCfdwh/GjX2QurKwE/MPDkM5ygvTSU7qDEdzthEGAAv1mb3KPelY
   ZEkjO6c+Ach+Erk0CVIG3uRRJt/xu8XJk5gLngOeGtf9O1KCSTeTk64or
   ByufEqhCqQtZhDmY4cWBWheM2UP2T9Ppwve+vpDMKNsTyT2zvpsfik4/m
   FrKoAcSsGj1j+AU1/bhILVQas06m9dpeUTjGoLoGJb1rep9VaYiMv36ke
   w==;
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="154101790"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 06:16:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 06:16:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Fri, 26 May 2023 06:16:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKgl7A5u3u1BIN7mIAHAod4QRpqD/cg/qIN+cu/oT+G35OYVzflrdu4RyGR5baC/LDLJ5WBgJgisGzMYSZHw8z4M2z1nv5PKw532/B4uq7Te1oRQFXVRDQ2Qyn+73AhfcaIZSkta48QdaEh9jiSnkTdQlbVnjxJoOHqppv/wZFn4+Ggt8KtIr08Js1TQkODXO+91SAYxVVZwlEaGX2T5yoc1i1FPV1sW4Qa7pvP96mVAyiT8vBSsdJY5/FyRjytRZ+TkBJPq0xsqTalUG2fWdrHRk7+FuH22sqHgiH7BB/e0R2MIREsG0OG7FMz/Bu3xWDiPvGJVRRep6ym54eHZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNDFX4Eh0xmBc6ooZ5IciPewrL4fgYxsDa3hTCS+lkQ=;
 b=nI29P5Z7iyDQ4rsuGMx4vScW4iBWNwgQlmJyZb1x75Y5wL6o0xawKGvELlVDcClQDJKGmE9qe8AsK7wFaGt66YbymZ1yI/T6IvrM4VpbqvWk5nVBCyaJeEVKyXschrpCABosTPl0xILHVJGULD1A3lAHb/UJb1TeRILkdy0jYbRErO8laF5LYfYo9LKj59zyb5T0iI4dQkYLKdfS5shkg09maDnsZg6wmhUU4GtR1XmZ/JllIchbKj8Bn1CZEerJv8EHrT+1orEBSOMvsrfBAsSPYq12b59P+cxeyf+rhLmd0+il49wwW8xGHn1XnenjiK/tFQclggnTKYV/zTDgKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNDFX4Eh0xmBc6ooZ5IciPewrL4fgYxsDa3hTCS+lkQ=;
 b=N4j1vJOKTKjYN+jof1xwpjJn8JU+SfA+254aNY1msTdVDpphNTQCW+I3c+p4LF3gaDv/O1PDqCDzAJt+g0Ydg7R0TkYGh62cmcSz7kj72geURKq6L0Bn3VvSStabHNjeRI2Ar5FbROTKMuvUW4/mmLjdE3fWycXjgsg43ozGvJA=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 CY8PR11MB6916.namprd11.prod.outlook.com (2603:10b6:930:58::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.16; Fri, 26 May 2023 13:16:51 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 13:16:50 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <ramon.nordin.rodriguez@ferroamp.se>
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v3 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Topic: [PATCH net-next v3 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Index: AQHZjk5i1cHHgHHkGU68FcYb2PZkua9rUBqAgADCSQCAABRoAIAAZZwA
Date: Fri, 26 May 2023 13:16:50 +0000
Message-ID: <37890657-bb37-0327-56d2-6193ac275a0c@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-5-Parthiban.Veerasooran@microchip.com>
 <ZG+oOVWuKnwE0IB2@builder>
 <8a46450d-7c6e-68a4-c09d-3b195a935907@microchip.com>
 <ZHBcUvSbX0taOED3@debian>
In-Reply-To: <ZHBcUvSbX0taOED3@debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|CY8PR11MB6916:EE_
x-ms-office365-filtering-correlation-id: b2087592-10ee-49df-309a-08db5deb7781
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iRiqZfQCpSWb3Ol2Lp6oHUpawLXwU9TPlnLUkFn1vvjR+sZabx/yCmsi52GlPB6D3cMyOl5MnBNpOpWbKNuzi1YHohaBGySrDqlWlgQwcnIczMP/vYMfdmn/CYMxbalsBEcJsigSeCImeGn/9H2sDYXC+uIFNZTn0zU4VoGlGLVcizW+vI5rYh+iEmLHMrZcdRd/LgU5tnWSMSSYlEwYzWtyaAqJmc9PTidbWnNhdaIMZxLCyz4tmTL/apWlQJF10C1kC4UfUN1ak7RmfXPx8y8Vi6gkWo88StBv/YgI+SNAPZKozYlfADKrfyVVvSb3WgJB3s0lOyqPATYGseKlIghEOsgBzxAg2C5W5Ufr0IUHZmEc3SZEjzyRprWa90aBxzBmHcyjpA49HDd2VPndu2momgZyeIVRRZVu1YgKg3Gb/qURZ28WLLoK8DYn1zeFBoumNqWE6Keb8ADNiMG+OjueaECPJ9Xi/K+iAWugYgtD28JL/nLocM1owRXRjRn/IlkOqPihKtqcmDqbQMWYu1WV3REO141SCyyQuPc7rVjZv3i3oj3oN/Xh+Ol/lXdHoAOe1MCTVL4kWLjtGtcYo0RfRU5ymyKNTPsCR9yB8ezMnL/HllCIEinpzAxmnKNG7ALi3bml8st2TseEZi5qVJNJLMA1gN5pwdkWqbrk/HQwZ4PPeFfY15zgLbcetnwN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199021)(91956017)(66946007)(76116006)(478600001)(54906003)(66556008)(41300700001)(64756008)(66446008)(66476007)(4326008)(6486002)(6916009)(8936002)(8676002)(83380400001)(53546011)(5660300002)(2906002)(66574015)(2616005)(71200400001)(31686004)(316002)(31696002)(86362001)(186003)(38070700005)(122000001)(38100700002)(6512007)(36756003)(6506007)(7416002)(26005)(107886003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFJTeHBPb1p2Q3NDV2k5WWlJWHV0VGpyNTZhMEJCNzZWclcvTjRrZEIxb0dp?=
 =?utf-8?B?YXYyZStPSUhlMCtXdjBuQUtwZXlpTXV5djgzM0o1RFhwTWZGWXB4MmRyTTRJ?=
 =?utf-8?B?TWRsTElRazJJOEtZOWtVc0lYVVRmb2ExUS9RczhDcExTRGo5U2dQd2IzSFBU?=
 =?utf-8?B?V0ZMMlFNVUtIU0ltMkRrSWQyMmVIWlV6ZC9nUjlYK2tMbmxGOXBzYUlXOU9B?=
 =?utf-8?B?ZGpPU2N0WGI5RmlwNVYzMVltUjNSV0Y2RjZXdk0yWnhqemlWbFI4cnAyT2E1?=
 =?utf-8?B?VU9PZ2Y3QWlYRVQ2K3c4V3ZseTdTZmxjTVovUXkwaTZYSHNXUFJBeC9jMEdG?=
 =?utf-8?B?Ly8wbmZOaUh3Mzg0VzBsY0hDYWxCUEE2SHZ5RVI5K2xVcE1wcnJvVkNEMEI2?=
 =?utf-8?B?UFZqQ0pVY3U5Um5GRnFlZExmM0dCcEZlWE40U3BBZEI0Tzdjak01RmxhMUdL?=
 =?utf-8?B?RDZ1QzFNYkNMa2FTanN6QnNkSklObEt6ZzNpZ0VSK3l0U2JZNkpoTE9CM2s3?=
 =?utf-8?B?Q0xrUTZFeGlXZU44bGZVNWxxRzhHNmdSZnJWQTVNekN0QzVwTWJ6K1F2dC9y?=
 =?utf-8?B?OTl2M0JZaStERk5HK2dpeUZyWndBd25RbmtDQlpDU2xxRHFyTEQxaHpCYW1O?=
 =?utf-8?B?MGozV2ZUSkZySGJkb2svd1l3UUlsbkNvSlhaTEJJa3Fnd2lQdmZicGRpWnky?=
 =?utf-8?B?bkZyR3lKR0FqeHI3ajAxTDJUUDZCYnM2dXE4a2V1WXduSmgyUk51UmU2eFAx?=
 =?utf-8?B?RjhSS3N3Skd0aHRPbnVDQkF4bW55RmdXQ3d3ZTAycnBVQ2Zrd0lTL1M1V0lu?=
 =?utf-8?B?QVZXTm1jMi8zWlkycUdXZ2FmQUpYMGliT2FKVlRaZGozK3RPcFZweTZlelJO?=
 =?utf-8?B?UW8yalJ6VzNFSjRpQ2RieUlyTjJMbCtmQWVXNlVsZ1hxak1lR3BoL0ZWMVh5?=
 =?utf-8?B?dCsrMjRxdVNYdmlvcFl4VEFTaVU0UEw3cTl5THVPRW84cjI3eThGSlVBM3NZ?=
 =?utf-8?B?T21WQ3NCbE91WXMyckUyeXl4NWhaR1Rxc0VabWpsRXlqcCtZVUNOVUhtak9x?=
 =?utf-8?B?RWM4ZFFQYTFRNWc0L0ErRWVBUXJWRGJSYzNaT0J5cTRrdnU3cEpMWWhhR0Jn?=
 =?utf-8?B?K1BaNjRabTgzOUFpSHVybDRRSlpBd3RKQ09LNE43eEJKNlFBbDZCb2sxL3N2?=
 =?utf-8?B?aVIwamRqbGc2RmlpUkk5U1N4NjBScjhjR3ZhbGVVSmlnVzRUcVAxb0ZrRjAr?=
 =?utf-8?B?Z1hoM3lOSStIOTdRSy8xcGhCVWJpTVVEem5rWWV1V0RoQmdzWWJrRWdpKzh2?=
 =?utf-8?B?OWNyYkkvWDc0clJzUTJ3UnpLNXM5c1VnZDFiYnI1VXYxWmIxTHpiMHFqdHFM?=
 =?utf-8?B?M1RuL1FaNmREUGpNR0U1WXhjSnZFRjRvMjAvRmFzclowR1pVaSsvZER6K0h4?=
 =?utf-8?B?eVFxbzh1QVBaYXM4cVlBRXhDclR1c2VVMnBXRjlGMURSUU0wWUx3QXhUbytw?=
 =?utf-8?B?UFBZbWJsM29kSVFxbnQwa0dtWWNodmVkclBYYVdFZko5WWdMeU1lQ2k2UWNF?=
 =?utf-8?B?VUw2VlluTThna1F2d3YvTU5mb2k0L21GZldVM3lPTk9BR1JlY2FDQkhrUXUw?=
 =?utf-8?B?TFpuMjBZY3AyanBWVVppY2tyYXpPbi9Ha0RNdnRWUDlhb1FNUTQwOUJEYVpR?=
 =?utf-8?B?SVV0d2RUREd1SlI5bjJtQ080MS9vSUhDcE12RTNVMk4zWTZaTyt5anN0Zklo?=
 =?utf-8?B?VzN4YWtOSUpOUktCRjRhMGE5VGhtVHRGZ2szQ2ZMRGJQakp2Unlkd3JNeHpD?=
 =?utf-8?B?N1pUSmF3VE9GelRSWnJMZkppZ3NteFJ2b20vQllsdUVZK1kvOGtROTNvMkJ1?=
 =?utf-8?B?Um00blBSY1lnd1Ewd3pBS2s0Wm10d29PRmErVFZYTVhiY3NFNGlxSmsyOVZq?=
 =?utf-8?B?WExCVzVya1pTdjVHRlBINjZueHl1bUxGWXU5d25aQVJzYXBwTlMwNlg2Wmtu?=
 =?utf-8?B?RzF2V3crVEp1ODRHN3hnWEpYY2dxcUpCYXh6Z2xBZ1A2RXpma0VNTitDTmcy?=
 =?utf-8?B?NDJ6ZXB3QU9RUHRpb3VJVTJzUjZQdVZlMndPUWorZ2VHbzNQZ25zZkZBYXUr?=
 =?utf-8?B?bXI3TWgrRkptRlNTUkpsUlBqYk5hR2hTdHZ4YVVuaHdZZU9SNEhLWTc5L2g4?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A04C1816879CB4082D3C14E54A58A0C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2087592-10ee-49df-309a-08db5deb7781
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 13:16:50.6546
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJq19Ah29IRApOpsPAJpYI0K3EbNWwxsnfS+Ff5NGRdDSbknq3duNvhbekrhli2bfkVR/GST2Hr/Qdgp/zKN8RRMgkeQ7e5ZbIi+eBMBQt6gjXvUx0jwNdH9ag7ZRcK8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6916
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgUmFtb24sDQoNCk9uIDI2LzA1LzIzIDEyOjQ0IHBtLCBSYW3Ds24gTm9yZGluIFJvZHJpZ3Vl
eiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBG
cmksIE1heSAyNiwgMjAyMyBhdCAwNjowMDowOEFNICswMDAwLCBQYXJ0aGliYW4uVmVlcmFzb29y
YW5AbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IEhpIFJhbW9uLA0KPj4+PiArICAgICAvKiBSZWFk
IFNUUzIgcmVnaXN0ZXIgYW5kIGNoZWNrIGZvciB0aGUgUmVzZXQgQ29tcGxldGUgc3RhdHVzIHRv
IGRvIHRoZQ0KPj4+PiArICAgICAgKiBpbml0IGNvbmZpZ3VyYXRpb24uIElmIHRoZSBSZXNldCBD
b21wbGV0ZSBpcyBub3Qgc2V0LCB3YWl0IGZvciA1dXMNCj4+Pj4gKyAgICAgICogYW5kIHRoZW4g
cmVhZCBTVFMyIHJlZ2lzdGVyIGFnYWluIGFuZCBjaGVjayBmb3IgUmVzZXQgQ29tcGxldGUgc3Rh
dHVzLg0KPj4+PiArICAgICAgKiBTdGlsbCBpZiBpdCBpcyBmYWlsZWQgdGhlbiBkZWNsYXJlIFBI
WSByZXNldCBlcnJvciBvciBlbHNlIHByb2NlZWQNCj4+Pj4gKyAgICAgICogZm9yIHRoZSBQSFkg
aW5pdGlhbCByZWdpc3RlciBjb25maWd1cmF0aW9uLg0KPj4+PiArICAgICAgKi8NCj4+Pg0KPj4+
IFRoaXMgY29tbWVudCBleHBsYWlucyBleGFjdGx5IHdoYXQgdGhlIGNvZGUgZG9lcywgd2hpY2gg
aXMgYWxzbyBvYnZpb3VzDQo+Pj4gZnJvbSByZWFkaW5nIHRoZSBjb2RlLiBBIG1lYW5pbmdmdWwg
Y29tbWVudCB3b3VsZCBiZSBleHBsYWluaW5nIHdoeSB0aGUNCj4+PiBzdGF0ZSBjYW4gY2hhbmdl
IDV1cyBsYXRlci4NCj4+Pg0KPj4gQXMgcGVyIGRlc2lnbiwgTEFOODY3eCByZXNldCB0byBiZSBj
b21wbGV0ZWQgYnkgM3VzLiBKdXN0IGZvciBhIHNhZmVyDQo+PiBzaWRlIGl0IGlzIHJlY29tbWVu
ZGVkIHRvIHVzZSA1dXMuIFdpdGggdGhlIGFzc3VtcHRpb24gb2YgbW9yZSB0aGFuIDN1cw0KPj4g
Y29tcGxldGlvbiwgdGhlIGZpcnN0IHJlYWQgY2hlY2tzIGZvciB0aGUgUmVzZXQgQ29tcGxldGUu
IElmIHRoZQ0KPj4gY29uZmlnX2luaXQgaXMgbW9yZSBmYXN0ZXIsIHRoZW4gb25jZSBhZ2FpbiBj
aGVja3MgZm9yIGl0IGFmdGVyIDV1cy4NCj4+DQo+PiBBcyB5b3UgbWVudGlvbmVkLCBjYW4gd2Ug
cmVtb3ZlIHRoZSBleGlzdGluZyBibG9jayBjb21tZW50IGFzIGl0DQo+PiBleHBsYWlucyB0aGUg
Y29kZSBhbmQgYWRkIHRoZSBhYm92ZSBjb21tZW50IHRvIGV4cGxhaW4gNXVzIGRlbGF5Lg0KPj4g
V2hhdCBpcyB5b3VyIG9waW5pb24gb24gdGhpcyBwcm9wb3NhbD8NCj4+DQo+PiBCZXN0IFJlZ2Fy
ZHMsDQo+PiBQYXJ0aGliYW4gVg0KPj4NCj4gDQo+IEknZCBzdWdnZXN0IHRoZSBmb2xsb3dpbmcN
Cj4gLypUaGUgY2hpcCBjb21wbGV0ZXMgYSByZXNldCBpbiAzdXMsIHdlIG1pZ2h0IGdldCBoZXJl
IGVhcmxpZXIgdGhhbiB0aGF0LA0KPiBhcyBhbiBhZGRlZCBtYXJnaW4gd2UnbGwgY29uZGl0aW9u
YWxseSBzbGVlcCA1dXMqLw0KT2sgSSB3aWxsIHVzZSB0aGlzIHByb3Bvc2FsIGluIHRoZSBuZXh0
IHZlcnNpb24uDQoNCkJlc3QgUmVnYXJkcywNClBhcnRoaWJhbiBWDQoNCg==

