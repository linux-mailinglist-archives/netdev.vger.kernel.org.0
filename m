Return-Path: <netdev+bounces-5517-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDA3711F77
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A14F928166C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30E63D86;
	Fri, 26 May 2023 06:00:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD26F23DB
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 06:00:18 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D12CE7;
	Thu, 25 May 2023 23:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685080817; x=1716616817;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xo6KugD535kEoKK/nlfinDXYA33glS8fwWfBlTOCr5U=;
  b=HkoGRB2J+fh9WkJDcKFssCEsb7HRAusTDgB4anArN2/YO2FlvSuB8rZM
   PwxSgo0F9K72IvmTDtLkSGW4/d8BomUtOsoFO0oufpXE1fRoAx7xpVo29
   Pv/Wvme4imsiWmF0+C14zj+wsY5NeG6fLLKdvaSZFIpnOo2c8i19859vh
   EzlCsJLWl7ytEkOutIQfJA9XAGXsFG4L+zqz3cTep5ZCoIZ6NH5TKZGWR
   q6hkWpRib+lY03On/YJXFuhXnmDz5sAnQg/kU9lFKI1uxHYwnDLbZt6qA
   79H6BNYqXWdEMay3MjQkEMKIOmAEGPqLIcaTWi3ITf+Yl+bFvboLB1sPG
   w==;
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="215573416"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 23:00:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 23:00:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 25 May 2023 23:00:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7sVN2sRTktX+VEC/W1Te58FJoFRxX9tdhdke1vw6mgY5m8GL0EXWOdol8CENp++v7/bPxnrUTe4Y4QHS0JEo3qOsXXNMmm7tz0KZYBhviFNUkFdIN/2seVbOV9m8r00jhiSYWI5AU/YvKl/s/Nf33c/FKAjFllqDX0XvmG4pBcnK8EP1yAGryEE7kaICutqgmsLu+g6v9snxj3n0VSEu8Go0OEfvQfq1J2jU7qoasTV/ep4TJ2UTnwz7BH/jqJbBBKugHvrrIwJsloTy/len9Ves+wUCNheqzRR92qjAZYr1eQTAd2Yn+PM+RPh4ofjjMwbNnAh1+Nj1IYVs537iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xo6KugD535kEoKK/nlfinDXYA33glS8fwWfBlTOCr5U=;
 b=BHTZF8ETmbSva9Ht5jzt8Gr+tb5xKmHsu0EclRtD7WwoVaJknSd1h4N3JoFzUD8aRxS41v+LLksmf8jl/cAz6xUDOfM5EG4FD/sKbqJB3cUy0N0YHV3KdXCfB9hRtCrtRXVImgmtZljjQ9/I25/6daTE2wYvRQVZJPmwdSlk/SqyEGMi/4IRNRQrJzK8GbTRVOJ2/zj0YKu1OsQyNRfqHfaMQNa8hOtgHTTDOF/c2L+uAeCxf6xpC4PQ6SiRg+hOsc+BRyc52A3eE/hAUiyJOl/u9/FNjtuDyzEvrCNNFQZsBl0blivrKkbR4jK03rfbTFfEJkLoAH2iTFS6g47RVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xo6KugD535kEoKK/nlfinDXYA33glS8fwWfBlTOCr5U=;
 b=lxzZggMoOxB5Xr3RemdiM8Ip5JxhKURMauFbCkho8LYDzMROS39PD0FsGURM9GFlZLrEG4JE4PaOOjV/68tPM+MjDPPRss5Xnn1EIRD5K6fHLt5xOB/xySDkNuLMuKalXn+yTFLW4k9IqoLhfj6Y3Iasst7POR5APTESIdy9YDc=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 IA1PR11MB6323.namprd11.prod.outlook.com (2603:10b6:208:389::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.18; Fri, 26 May
 2023 06:00:08 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 06:00:08 +0000
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
Thread-Index: AQHZjk5i1cHHgHHkGU68FcYb2PZkua9rUBqAgADCSQA=
Date: Fri, 26 May 2023 06:00:08 +0000
Message-ID: <8a46450d-7c6e-68a4-c09d-3b195a935907@microchip.com>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-5-Parthiban.Veerasooran@microchip.com>
 <ZG+oOVWuKnwE0IB2@builder>
In-Reply-To: <ZG+oOVWuKnwE0IB2@builder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|IA1PR11MB6323:EE_
x-ms-office365-filtering-correlation-id: 6a77b05b-d330-4d48-1808-08db5dae75cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VXLl05tqDN8T5yrUwbn3vyr8okcQEsSrekgHa+Vu5vd9Vi3BOEPAfey8ENhX27N2wBxgtWyTdCqcgIyNlqBIuxp0M416eEsCMd3eCm/kFrUNQvD59hjswa1XDdubhU+kHwhU3gu5bn00JRkrlkJac5oLsdrZGZHdKOMKjuKYvBwxWeJniYLAoqXtWjGfdV911H+asrd0SmGP5/B273uEqPbwUWY17Qyvohnnil/5ku7GW725GB9ZZ03XbPBiOASXw/ZsjZakB3hOmhC5foBcyvAoJOh8YSVNtvdrp3S0Rv8NKu5iBJYuhaZ9mNZGV98CT40BudU4MUeKiAhRmvEXkzNdFFcmd9eCBmUwsECPVcx/tsIs+/MIgsznU8FmY9FB1snAeWWAoPGKBQ9gilPbobWGFvYlwtYSQsco7niGprJKoTZ+idH7Gj1ljtBMMUVZ82OFlSRX6mfUwWkufZPRP3oMggAn5anX7j/ou9pP0zMCyuOO/Ik1ICfbY9pn8itqBB4F9qJYzy23OqZwSsUx4Q3roS+DN7ZsHOrlpVZeXA4CgIlKge2VWp+QFbT7RhWWWc64cfBoC4Rr3GgJM2iVWtBywNw9oPTy1tQ5gfaXvsie8r7xLazvFlK4kqZZsOzPVYPg6xWnFzklxcHMzT9XU7u9uTAoRdNAU8fdbN/VPi7nP/Ip/akxvJFOJMvUXOOs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199021)(86362001)(2616005)(38070700005)(2906002)(186003)(66946007)(4326008)(76116006)(41300700001)(66556008)(66476007)(66446008)(64756008)(6916009)(36756003)(91956017)(83380400001)(6506007)(6512007)(53546011)(26005)(31686004)(31696002)(8936002)(107886003)(7416002)(5660300002)(8676002)(38100700002)(6486002)(71200400001)(122000001)(316002)(478600001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?elRqV0xaNE8yVnQyWWlra1FNOEZ6aExSRnRyYm85U0VHOTRSRGduS0FjRkpC?=
 =?utf-8?B?ekRvdTA1M2pHSnZsdmdvWnFsOTZQSUcvc1BzZWpJZitGelZpdHN5RlVwanRO?=
 =?utf-8?B?d0FsUWhoU3BwekdCK2xKdmkvSnEzdkdqYWFIN1RIQUExbURyanJ5aU4rbGtE?=
 =?utf-8?B?M21FNDBrS2lCQmdEU3lJOW5JWDdNbVBGeHhSMGo4ckExSURIdGJaRlRtZFAv?=
 =?utf-8?B?QlhlTzk2c2VDbGZmTTFwV2crd1VVWW8ySm9tZGFVZ2JDa3hoT0doOEZvMzRv?=
 =?utf-8?B?dW50M1dVdmpGK28vaE1ub3gydWpYZ1FnRzZSWm5tWDgzeVVmY3dXbGxEUks0?=
 =?utf-8?B?dTZJM0xIdnM0cDZXRUxrd2gwbXF1NVVSN1BZT3AyaG13dC9pU2FsUEpLalFO?=
 =?utf-8?B?QldZdnQvTjgzbWdvdjFabWRNSi9hRlJwU3NOVFVabTRLZU5WZlNQN0N3b3c1?=
 =?utf-8?B?OTFyRnlkREptZ3g0WUYvTDNiOEJlL3R1ZEp2TzBDWDNPN1ZiNlUrL1BGVHdl?=
 =?utf-8?B?VHVHa0FXTlgwOTdieHp2VVliSjJ5NmU4RDFXTjhiaEFDdWhuYTQ3NjJ4U09k?=
 =?utf-8?B?N1hGQkZDVXM2NjZqbEV6ck4vbnN5L0FKYkJQeFVLb0dlQmtnVE5WVzNpZStO?=
 =?utf-8?B?c2I3RHpwOHRHRXlya0VTNVc0V29odUdJT05mMk01MDFhTE02MzNkeHUvYkc0?=
 =?utf-8?B?clVYUCt3KzZWME5tT0ZHcFhFNFYwR0lEYmVCeFVEcHpiREVFekxxazZIdUNh?=
 =?utf-8?B?Z3FoaEoxMEZTWkZvbG5rU3dRSTF0SURZNlVVTmNNZkJXOFpQYUNYSFltMjVz?=
 =?utf-8?B?V3BxY3FMK2pXTUp4SVVBT2RDWGloelFiOU5hN0I0TCtwUFhtajQ2MFJtajU0?=
 =?utf-8?B?RVJOYzI3ZVhmamVhOU54ak92cGo1YksvNllNWFJGL2VqcFpMajQ5cnF5NzdX?=
 =?utf-8?B?SElHSWx0Tlh6Vythc1gvTVdLOWk2bzRnMDRNOXZSMVFHNGtHcEFuWHRXZU5Y?=
 =?utf-8?B?TXNxS252TGtsZjVDV2dVTll2bk1ORkl1aGViYzZwclRYSUJoR1l2MHJSUXZv?=
 =?utf-8?B?SkFQSmtncnhUQldzcnFnOHJHazF3NHVSNXZjQmhrUU5ud2RMeTEwYU9iekRr?=
 =?utf-8?B?VzBqK3ZvdjU5OGtvOHFhdXJVeHhOTWNzWkR0Mit2dFFrYk1VL3lMY09YTUpo?=
 =?utf-8?B?bTlUdjYzNFkzVjF0SThweDBNTEQ4d0M3R0lBS3ZNR3dYSDc0K0drWXNBUHJJ?=
 =?utf-8?B?VU9xd0g0YnRNZitlcHNyWjFHQjQveVlUSEN2UzFleHhOS2J6ZWU4S3NkbmZj?=
 =?utf-8?B?YkNFVktuOHdwNTdhUE1RVnRTQkxCNTlqS09iakkxbHdSY0VCRGNEcVVYc3cr?=
 =?utf-8?B?VVA2OTZIMHBpMER3azNBanBrMWdjQlVGeFlISVZ1akFNYlhRTm4wVHpMVmFS?=
 =?utf-8?B?bytsZVVzWEg3OXpGTm5LOGQyM0hHU2N1ank1MVcrV005NkJONmFKWkVsVG50?=
 =?utf-8?B?UTNDdG1XQ2VqdENXbUJxRU9yZ1doaVJxem9lUHFVRWpKS0V4TkllWjQwdlgz?=
 =?utf-8?B?R0xYdytQZFRVd3F3cW8veDFGTUdNaHg1aytHSDdsQmxEbENTODZzVlBHUGxF?=
 =?utf-8?B?SG80RUFRVVV2WlhldE5JdEpPeFBmUXI0S3R1UzJsNUhkMlhwSUVld293STY4?=
 =?utf-8?B?L0hVd1MwSjRaTUF4Yld3ZmdpQ01wcXlHaTNwUjEwVUYzbU4vWk52MGl0MXhU?=
 =?utf-8?B?eXJEc2VUYTd5WGVNYnV4aDB0RjF3akFxNGYxUm5SVFcyODFKM3U2M29lSXFo?=
 =?utf-8?B?TWVUdEZiR2MwdVJiL1J1K0NXbjZjbjNnNHBvSzZ3aEpGWi9kUUdTRU5yNzJC?=
 =?utf-8?B?SHgzeFBEc0F1dHBDanF5NVVkOGtrOFJUM3BKYkNEcmxuTGR1aXBCSmVzazV1?=
 =?utf-8?B?M2hTLzh2dkxycnAxbEhCMmdOTk9WT2ZyOWhpLzRDVW9LcHhIMWxXYzlEK1U0?=
 =?utf-8?B?aU9NVFllajdVVkljZ2FDNFRkTXg4MU0va2pESzJ4K3pYMTJPdVFoSElPeWFY?=
 =?utf-8?B?VjFDT1J4OVovRDZ0enhOaDRuTWRlN3NCdWw4M0duSmNyRXpJOFExcEk1NkFR?=
 =?utf-8?B?TE9SclNjUUhBZFV1aTRHL016V1M2TXRCZTBjRklQVXpGSU12WHBHOWFhbndO?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F32AF8A9EFA57F4D9357D0347E7EB306@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a77b05b-d330-4d48-1808-08db5dae75cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2023 06:00:08.4962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oqSgvPUzI//vLrIbhxZ5UIERakg2MxbhTAHFBqHr6v9wPprpezu3RG6B9mCzkJjtrAWnJ+BetEtfFNcg4jUU+znz1YlFRBFOAztlia6wB8QT/l8BN2M16apA/jcifJpS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6323
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgUmFtb24sDQoNCk9uIDI1LzA1LzIzIDExOjU2IHBtLCBSYW3Ds24gTm9yZGluIFJvZHJpZ3Vl
eiB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4gKyAg
ICAgLyogUmVhZCBTVFMyIHJlZ2lzdGVyIGFuZCBjaGVjayBmb3IgdGhlIFJlc2V0IENvbXBsZXRl
IHN0YXR1cyB0byBkbyB0aGUNCj4+ICsgICAgICAqIGluaXQgY29uZmlndXJhdGlvbi4gSWYgdGhl
IFJlc2V0IENvbXBsZXRlIGlzIG5vdCBzZXQsIHdhaXQgZm9yIDV1cw0KPj4gKyAgICAgICogYW5k
IHRoZW4gcmVhZCBTVFMyIHJlZ2lzdGVyIGFnYWluIGFuZCBjaGVjayBmb3IgUmVzZXQgQ29tcGxl
dGUgc3RhdHVzLg0KPj4gKyAgICAgICogU3RpbGwgaWYgaXQgaXMgZmFpbGVkIHRoZW4gZGVjbGFy
ZSBQSFkgcmVzZXQgZXJyb3Igb3IgZWxzZSBwcm9jZWVkDQo+PiArICAgICAgKiBmb3IgdGhlIFBI
WSBpbml0aWFsIHJlZ2lzdGVyIGNvbmZpZ3VyYXRpb24uDQo+PiArICAgICAgKi8NCj4+ICsgICAg
IGVyciA9IHBoeV9yZWFkX21tZChwaHlkZXYsIE1ESU9fTU1EX1ZFTkQyLCBMQU44NjdYX1JFR19T
VFMyKTsNCj4+ICsgICAgIGlmIChlcnIgPCAwKQ0KPj4gKyAgICAgICAgICAgICByZXR1cm4gZXJy
Ow0KPj4gKw0KPj4gKyAgICAgaWYgKCEoZXJyICYgTEFOODY3eF9SRVNFVF9DT01QTEVURV9TVFMp
KSB7DQo+PiArICAgICAgICAgICAgIHVkZWxheSg1KTsNCj4+ICsgICAgICAgICAgICAgZXJyID0g
cGh5X3JlYWRfbW1kKHBoeWRldiwgTURJT19NTURfVkVORDIsIExBTjg2N1hfUkVHX1NUUzIpOw0K
Pj4gKyAgICAgICAgICAgICBpZiAoZXJyIDwgMCkNCj4+ICsgICAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gZXJyOw0KPj4gKyAgICAgICAgICAgICBpZiAoIShlcnIgJiBMQU44Njd4X1JFU0VUX0NP
TVBMRVRFX1NUUykpIHsNCj4+ICsgICAgICAgICAgICAgICAgICAgICBwaHlkZXZfZXJyKHBoeWRl
diwgIlBIWSByZXNldCBmYWlsZWRcbiIpOw0KPj4gKyAgICAgICAgICAgICAgICAgICAgIHJldHVy
biAtRU5PREVWOw0KPj4gKyAgICAgICAgICAgICB9DQo+PiArICAgICB9DQo+IA0KPiBUaGlzIGNv
bW1lbnQgZXhwbGFpbnMgZXhhY3RseSB3aGF0IHRoZSBjb2RlIGRvZXMsIHdoaWNoIGlzIGFsc28g
b2J2aW91cw0KPiBmcm9tIHJlYWRpbmcgdGhlIGNvZGUuIEEgbWVhbmluZ2Z1bCBjb21tZW50IHdv
dWxkIGJlIGV4cGxhaW5pbmcgd2h5IHRoZQ0KPiBzdGF0ZSBjYW4gY2hhbmdlIDV1cyBsYXRlci4N
Cj4gDQpBcyBwZXIgZGVzaWduLCBMQU44Njd4IHJlc2V0IHRvIGJlIGNvbXBsZXRlZCBieSAzdXMu
IEp1c3QgZm9yIGEgc2FmZXIgDQpzaWRlIGl0IGlzIHJlY29tbWVuZGVkIHRvIHVzZSA1dXMuIFdp
dGggdGhlIGFzc3VtcHRpb24gb2YgbW9yZSB0aGFuIDN1cyANCmNvbXBsZXRpb24sIHRoZSBmaXJz
dCByZWFkIGNoZWNrcyBmb3IgdGhlIFJlc2V0IENvbXBsZXRlLiBJZiB0aGUgDQpjb25maWdfaW5p
dCBpcyBtb3JlIGZhc3RlciwgdGhlbiBvbmNlIGFnYWluIGNoZWNrcyBmb3IgaXQgYWZ0ZXIgNXVz
Lg0KDQpBcyB5b3UgbWVudGlvbmVkLCBjYW4gd2UgcmVtb3ZlIHRoZSBleGlzdGluZyBibG9jayBj
b21tZW50IGFzIGl0IA0KZXhwbGFpbnMgdGhlIGNvZGUgYW5kIGFkZCB0aGUgYWJvdmUgY29tbWVu
dCB0byBleHBsYWluIDV1cyBkZWxheS4NCldoYXQgaXMgeW91ciBvcGluaW9uIG9uIHRoaXMgcHJv
cG9zYWw/DQoNCkJlc3QgUmVnYXJkcywNClBhcnRoaWJhbiBWDQoNCg==

