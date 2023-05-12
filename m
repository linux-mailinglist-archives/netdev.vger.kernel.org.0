Return-Path: <netdev+bounces-1991-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7CF86FFE36
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B30F2819AF
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 693947EF;
	Fri, 12 May 2023 01:01:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568A039D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:01:06 +0000 (UTC)
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2067.outbound.protection.outlook.com [40.107.215.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE60E46A2;
	Thu, 11 May 2023 18:01:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJI+BWyOvS79VofF2W55aaj+7qg/dNlwdF36WlRilJxGEvGRKas7gKc3H4UZyfArdPhJgcfwNQfqim+OoZVe/UkrGR8U97qKe6AZLMk+FCAyVdEBaLD9444AJDpgUYWG2tMubOdK/l4UvQz1EYpkvtgmnS8YECOWuX3YPi6DG7v5LSWOde9TJPtqH1E0FNkP1CDMp56xKZv7qQD7qFDtGPUbHuPO6n4ln1lF88ToAgVa6SbYPgep3pL4ya/5BzyxzmOcp+f2Zcx9+ag4K+zQIPkmpkGTEfWU8PQOal46opBOf9cP9owMrIf2dfd1+OqjhvW6Ch2ngtiiwZMawJQKzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0PVMQQ5Z5FK+w39Xhy/E/ri44BFWUSScQN2Pk2Yaog=;
 b=cffvKz8ik1mceho/26cz66MA8SwlLRRjG5nQw6J22MnPAKUezOrS8tfzhDqdgVOQgNTpuVWWPV2fzDqMBb8G0ymj8jzHsznUT/IjVxtL5/jQEGUG0KFebQ5wE3pAaY4bFzfiLeQSWcaZvGq1k0r360jI78QJ3kugdh+gE1fCjHLmnFlAchrTuKa7npYBHHEQ3m2dP/AmxnwmtkTem42NITrn6v8cPK7Paoaf4RB6KAgrLEDmSglQRv3bU+bGxGcm3LSiIxGqiT3U4H6YPPibBZakKYG7Vn6MnoOd2gP7yhXW9LuiBnA5G0zShc4zcjmtYB9lrK9e9KX6QDyE587wEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T0PVMQQ5Z5FK+w39Xhy/E/ri44BFWUSScQN2Pk2Yaog=;
 b=flNXhLznhTkxphZSsQxS0y+PDeDIIufIH16SnpWUYnl5zQDSwiF221vbIO5rX+HpwUXayiK+6EWKDIOX+sMHWFLGAoaDT8vEuZjN0fQxMz6Mr2UJTHS+BGBYpteDmnvWVasQjimoCeKMJDSDKZ56y7OKOvyJ0CkACnEh329gRR7dj6UmiiCVQ6DFFlfEJ9ec6VFl68JdPZZMJLKoydJbwWOl7C7YJ4HR0tELxjPaCNSTfIaPRn1tcSqFT+tnOQi27Q/zZNY2E14mzmrBQBMjV3p0couBI9jVjqbV6smu+mDGNeJSGv1qqmlk8SL8c1z78iqlMaxg8cOlSb6Lutmcjw==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by TYUPR06MB5978.apcprd06.prod.outlook.com (2603:1096:400:358::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 01:00:59 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6012:86c1:192:4d46]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6012:86c1:192:4d46%6]) with mapi id 15.20.6363.033; Fri, 12 May 2023
 01:00:59 +0000
From: Angus Chen <angus.chen@jaguarmicro.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: Remove low_thresh in ip defrag
Thread-Topic: [PATCH] net: Remove low_thresh in ip defrag
Thread-Index: AQHZgkW/BfZIdsQ1906gjuw+jXxLvq9UTMOAgAGH7HA=
Date: Fri, 12 May 2023 01:00:59 +0000
Message-ID:
 <TY2PR06MB342405B4B32AF6B5A60645BC85759@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20230509071243.1572-1-angus.chen@jaguarmicro.com>
 <20230510183357.1b8501fd@kernel.org>
In-Reply-To: <20230510183357.1b8501fd@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|TYUPR06MB5978:EE_
x-ms-office365-filtering-correlation-id: 22b65e75-d9f6-44d5-004d-08db528459a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 aIzn/vsL9puxx5rIlnEXsJ27SrxPuZd5m7iqyHgQztkTTkdwOXFATkKzcJh6wwURltg3RgzKEagS/C3l9lfIgCZ+3dp2Z2qSr0HCe0/3WP2k4pQzqTTojK93/nfJgpqGoR8HUvVkESedhvE/pxzLAuABIzORBA0UMTVeb5bChBD59wqtJPZ7NzTIrDUbJmv2xKcP9/Poesewbb+AcdJZGo2iGska6RYXWLYvaoYnPmwJP9fqEiZKRI9k0EHTrx+yk9c6p7m1680fgYS58i0RWxeoPO15kpuHqF+72g6MyQZzfQrwGXdRjvkv0+olEBKVMULMzZqshHRjmOyV949y+WvNf022Sev1bhL0IU8F0t3bgIz7o/oXhaHzE7+aFlZs7DaNnAAv6Vfb4BsW6R66sbmSnbU2JMEH9q5bj+4tTYE0oZucdLwAvcV8thPG2QKARR/XWrV85JL8UCUa9wAr34iHxmGOa7A9UHWfYc4n17clrtQ7D12nKVNpSJxNABp9RT6KnRPb5hkvixBERYpbqkx3Px2E2SWr5iDhTCcPS+T4hAAmHDI2SeFynfGM47CrAc5lYxtixDpHytYFP+kZGFTYPr7MYJOeEpsumPY8FOh5WOgVKbwRrs54zpZL/Kfj
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39840400004)(366004)(396003)(136003)(451199021)(83380400001)(186003)(4744005)(2906002)(38100700002)(33656002)(38070700005)(86362001)(122000001)(8936002)(71200400001)(8676002)(316002)(7696005)(41300700001)(44832011)(52536014)(5660300002)(478600001)(54906003)(76116006)(66556008)(4326008)(64756008)(66946007)(66476007)(6916009)(66446008)(55016003)(53546011)(26005)(6506007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TzRmVTUwVHdkL0wvVThWRVkwTS9obzFvaVkybFBtc1hIWjNWTkRIbUZlejhO?=
 =?utf-8?B?ZVhRNGV5RUkwRDR0K0JPMHhYVFd2UGkyUFlIWW9pMUFuUFVZS2ZJVDZzbHY0?=
 =?utf-8?B?b1NyeTNQbVpjNGw2ejlwMHRWd21PVzR5VmJuWGNwR1NXQ1BnQ2psbjU3dnJz?=
 =?utf-8?B?Q05taFVGU3paeE9XS2RSeFlYK2lXZHZiSEhNUnJZQzZPMUJjT05XZk5PSlcr?=
 =?utf-8?B?TEdickFVeGVpWFBuNUwzRmFwbnVhdDZjMStEVVIyeENKRUkvbVdwbk1ISjNu?=
 =?utf-8?B?azBidG16N1VhVktRR0FQOUFKZjN0NlFqbkk5VHpjVkUzOUJSSjdEbWxZZ3NW?=
 =?utf-8?B?RnNNUnJEOGszWHBPSm9vN0ZKUEJlNktvTTQyZXVtVGJsdFZ1ZzVxN3Q4L09P?=
 =?utf-8?B?aVYzR3l3djF1TVB4QmczNDZHdEpuZ2dpUU12Z2tjbUV3b3o5UC9WY1FWV0lR?=
 =?utf-8?B?QjcvNWJGRlV0d3NCMkxmdGsvdGJ2ckoxemw4ekVWSjJyWkI5TE42UDRTN3Rv?=
 =?utf-8?B?S0s0c3o0OEpjUmJhdi9FTlpGczlYT1pyaXJTc2lOZkFkU1RXcURaaWJxOWpm?=
 =?utf-8?B?OWN2VnBZdXJkMTV1dW14Y01Sc3lOVE9TbHVvWDFaN1lPellyZVRYTDk1b3VT?=
 =?utf-8?B?WUtmNUg2YTlwakFmdzlCKzZ4clYra2ZZYStOZ24rVEp1Ti84VHg1dE9zaHVN?=
 =?utf-8?B?UzJwSFNYbnZLVGY4ZHUvaE9sR0hJdWFncHZyT29zZ1Znc1JEZnNkd2pkYis2?=
 =?utf-8?B?N3VTU1YrUDlZc25iQkpuUWNDWUVXcTVLOU1KTjJsL2dodDBVK050NnFvL3ZS?=
 =?utf-8?B?bUlZcHdTTXcxRGVHQkdSUEJoMVhIVFVZdDRCMUgxYlFXWEluOGNPU0VFUVFC?=
 =?utf-8?B?RHAvM2tGaXB3RFROdmlwOWRMWnNpNUQwVkR6QTM5cjBJUTJuMERSR1IvSFgr?=
 =?utf-8?B?MU9NdGZEMDc1Z1RXOTExanFMT3ljNWM0NXdvbXIzcTBXN3FRSTdGUlF3a0kr?=
 =?utf-8?B?ZEEvTlVlMUgxTVAxTlhiT1ZuTzRXRkJDZlJKbVlQUVRFcVkzYi9zeUM3Rmlq?=
 =?utf-8?B?MjFvSjB0ekx2c3FlZVNKbzdJY3lTNDViSjMzK21sY3Fpcy9ka0d6U09CR0t4?=
 =?utf-8?B?Y1NNYVJ6dkhNSFl4MzNYdCs0LzVHZ2lvckxFWUFnZUNMcTdzcXNYcllJMUk3?=
 =?utf-8?B?Wkpsa3hJcGYxUC9uVkJacjU0YmpiODN5bGE5aWtwcmtBK0wzem8yN3JIM3B1?=
 =?utf-8?B?ZFhvRG92ZncyaXh5eFIxQW8zQ0hiUkwwNFMzNVBQakp1N0d3dHBranAyWnRy?=
 =?utf-8?B?NWxqUUJSUFNDNXl2SXByeklnSTQrV3lFelg1Z2t3cWFBSWRUakwzS1ZueUhY?=
 =?utf-8?B?RTVZNkpZaitqVjZSRXhVTEgzeXhiOUlFeFhzbXdwNzkrOTViRFBvT0pnZ2ll?=
 =?utf-8?B?MGYzcU5GSlRoclpGZUg0dnFTb2IrTHJmZmtyMC9NNzJweTZ5QUNYMkVnM0pB?=
 =?utf-8?B?SHNuZjVUaGJHMUtpM1dsNlFOcnhsR2o4NUpUaFVwNXYrWTZMeUl1N1ZvdkNC?=
 =?utf-8?B?dmUyWXFvSWpqbkJBSWh3b0xOSWNSRjRQeENFSEUvR3Z6M3VaN25uR3hZUlVD?=
 =?utf-8?B?anhabWVLM1FKRzRoaytJSldUSDlIOWpXODBuMkR5VjQyS3dwVDBIUHFSNnpT?=
 =?utf-8?B?amFjR2VyN1prNEVWTmxLWC9NUU5sSUFxNFJJTWpIQUNHK1JKNTdLc1JqczVw?=
 =?utf-8?B?c2RrY3VWYmNqc0c2WU51NnVvTFNodHY3R0U5S3RhdkQ3bVlrRUFoTW0vK3kx?=
 =?utf-8?B?TDVpK0w5a0tGc1RJVkVyTmZQdVVlL2IvRHFPOUJiR1lPbEJUUlBrdk5SRktt?=
 =?utf-8?B?NDNQQ21RaDY1cldhVGhUZGpVdFMzQ0hacEQrSSs3SWtUWXNtN2JHWlF3ZmVl?=
 =?utf-8?B?NTdSdW5mNG96VWUxbHE0UzRTREtiQ3RHTHJ3MHJSc0FSSmwvQ0hXektsS05I?=
 =?utf-8?B?TmhxcUF4UGlXa3M3bjk4Z1lDcFdXc0lqT3V2ajBiNEtzYjN1ZGlVU1NKSnRu?=
 =?utf-8?B?RWdrcWYvWkd4cEgxc1BYa0puU3luMTUvaE56Tkc4OHFxa3BjNXpxOXp6NjVJ?=
 =?utf-8?Q?x1G+rlkIXwDsgyxGBxXAI4A4O?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22b65e75-d9f6-44d5-004d-08db528459a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2023 01:00:59.5609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z6w9x0JBmVdk7n95149AQZPtOxch0OsAqPOMwEfuO/F+Iaifl0oHp6kl2DfRZAFE+UVoRmUsFCHveFXeczegT6JLacq84qn8eUsYcDVIxC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR06MB5978
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5z
a2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE1heSAxMSwgMjAyMyA5OjM0
IEFNDQo+IFRvOiBBbmd1cyBDaGVuIDxhbmd1cy5jaGVuQGphZ3Vhcm1pY3JvLmNvbT4NCj4gQ2M6
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGRzYWhlcm5Aa2VybmVsLm9yZzsgZWR1bWF6ZXRAZ29vZ2xl
LmNvbTsNCj4gcGFiZW5pQHJlZGhhdC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBSZW1v
dmUgbG93X3RocmVzaCBpbiBpcCBkZWZyYWcNCj4gDQo+IE9uIFR1ZSwgIDkgTWF5IDIwMjMgMTU6
MTI6NDMgKzA4MDAgQW5ndXMgQ2hlbiB3cm90ZToNCj4gPiBBcyBsb3dfdGhyZXNoIGhhcyBubyB3
b3JrIGluIGZyYWdtZW50IHJlYXNzZW1ibGVzLGRlbCBpdC4NCj4gDQo+IFlvdSdyZSBub3QgcmVh
bGx5IGRlbGV0aW5nIGl0Lg0KVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5LEkgd2lsbCBtZXJnZSB0
aGUgZGVsIGFjdGlvbiBpbiBvbmx5IG9uZSBwYXRjaCBpbiB2Mg0KPiBQbGVhc2UgdXNlIHNwZWxs
Y2hlY2suDQo+IFlvdSBhbHNvIG1pc3NwZWxsZWQgInVudXNlZCIgaW4gdGhlIGNvZGUuDQpZZXMs
SSB3aWxsIGZpeCBpdCx0aGFua3lvdS4NCj4gLS0NCj4gcHctYm90OiBjcg0K

