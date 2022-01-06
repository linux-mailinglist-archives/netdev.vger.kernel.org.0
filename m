Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D608486847
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241629AbiAFRS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:18:56 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:26658 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241570AbiAFRSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qccesdkim1;
  t=1641489534; x=1642094334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M9UIjdv2YqRyCDV4+0DXzKQRk9dLyN13dnK/OeDrF+w=;
  b=mE3QpWFLziGSJuXJuHCg5p7JA6nrr9NruJus4tgG4UyJ6UgiQEvPXp7P
   j6KXKSdNh4ijxcem0Arj7oyhe8+n/kBMq3OwZHHSlhk+Z/MlOgPloYR1D
   vIa30fZdapdL6hQYKGuXRDPr3bD2TkBj3GDXEQpogicqM8TbhaFLcaJ99
   A=;
Received: from mail-dm6nam11lp2173.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.173])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 17:18:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmN1Z+6dBKsIqmCPXobvVmeL4fltv6Hs9MY82fjRLgpSpIFWL1zTikFww1R+r/UtTbuzU5iIgqPk7R8laV3HFHEF2MDFM0UeyBVuf2AjaFIQ5mL8IIvmPXqilb7hByY3TvrOskrKVA516c4eiJ58eSN/Kg4YNN49nrBkg/TMmAxLPkgCSt3sI0NOjx5OYa1QfmUqWOIi+BiNp+Mt4ojZTuQ3+cngC1uYH575hmxOZQMtsJ/NgB5M519+swp0P69h+ydqp2K/4kF5PmUoC3EWrC1Frr9zEcpnqI8jozM5IMyL6y4nOePZlWNZ1rG6KSkNhRWLCXT2Lnm7S1kmRRO8og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9UIjdv2YqRyCDV4+0DXzKQRk9dLyN13dnK/OeDrF+w=;
 b=DHe74nYtMYvyxY2K3pvwVVpR9szioAfdb4DDOHj1zt62I3kthKzGTJndZc92LNp4LeDb91/30aEesON4chTLWQO0aA6wt7vKzKYT3nv02BxEB+9LvmxMlz9VWarwYmRjFxO7wOMhQEeyXCMJwWO50g/1UD+mT0AI8LnKE8V7ZrvlODYkc8yvY1FdQed24M6/NTNMCszL+Xqa42RbATJVlXa8qMdPbE9RaWJlGcYUtJg8DZY/2uMttg03f9Dg1zH2hIz1VG0Vq7hSyLxWDFAEVBQ9S1fBp3qWGq0x+ZhfMrEf8fIN0kOmTIcvBMZfNVRLVHxZz/escXp4Vs/Tlgbyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quicinc.com; dmarc=pass action=none header.from=quicinc.com;
 dkim=pass header.d=quicinc.com; arc=none
Received: from BYAPR02MB5238.namprd02.prod.outlook.com (2603:10b6:a03:71::17)
 by BYAPR02MB5464.namprd02.prod.outlook.com (2603:10b6:a03:95::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Thu, 6 Jan
 2022 17:18:51 +0000
Received: from BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07]) by BYAPR02MB5238.namprd02.prod.outlook.com
 ([fe80::8802:ab1b:7465:4b07%6]) with mapi id 15.20.4844.017; Thu, 6 Jan 2022
 17:18:51 +0000
From:   "Tyler Wear (QUIC)" <quic_twear@quicinc.com>
To:     Yonghong Song <yhs@fb.com>,
        "Tyler Wear (QUIC)" <quic_twear@quicinc.com>,
        Martin KaFai Lau <kafai@fb.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "maze@google.com" <maze@google.com>
Subject: RE: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Topic: [PATCH] Add skb_store_bytes() for BPF_PROG_TYPE_CGROUP_SKB
Thread-Index: AQHX9tuyjzikyJjagEKGz1loPsx8d6w93owAgAE+o3CAABKSgIAKpfOwgAAsSoCACaSBEIACEA6AgACeYVA=
Date:   Thu, 6 Jan 2022 17:18:51 +0000
Message-ID: <BYAPR02MB5238358FFC983C910FCA595EAA4C9@BYAPR02MB5238.namprd02.prod.outlook.com>
References: <20211222022737.7369-1-quic_twear@quicinc.com>
 <1bb2ac91-d47c-82c2-41bd-cad0cc96e505@fb.com>
 <BYAPR02MB52384D4B920EE2DB7C6D0F89AA7D9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211222235045.j2o5szilxtl3yqzx@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388E60A9E9BA148CBA9299AA449@BYAPR02MB5238.namprd02.prod.outlook.com>
 <20211229210549.ocscvmftojxcqq3x@kafai-mbp.dhcp.thefacebook.com>
 <BYAPR02MB52388A3420C7FBC0B79894CFAA4B9@BYAPR02MB5238.namprd02.prod.outlook.com>
 <2e3a072c-2734-0d54-d0c3-833a75b509bf@fb.com>
In-Reply-To: <2e3a072c-2734-0d54-d0c3-833a75b509bf@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=quicinc.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69285411-919b-4aed-af04-08d9d1389c0e
x-ms-traffictypediagnostic: BYAPR02MB5464:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB5464948ED0857F4A671F3063FB4C9@BYAPR02MB5464.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EqmiwC+I2PJSeLvo1Krgc7oTtjhnvUdZ6AZK3rl3Dk5+IANmpKQFhclCay2TYPaSym/8y2ZtIdXtN3LgPyTuSGbGMvKjgqutR1jJyJaWi4T0F4iYoCr7QmWS+GBRZ7WBMwS8SGACj+D7ZyKgfEBMBi8eqt1cnP/NJOeD9eMyC8Cw/u44RxRt2ZijJZpl34uOxLdF3vP3s9oOJKF/Ik0upO9KjvzI49FA3Ey5zzVPhF+ryO2tf54BP0dXS5xSAPdpP50C9dWa2z6jf6Po5ebbokgR1br4ixoVctwoUznRTtfMxQxMdd9Ct30DbpkLXz3ThrMg1SiqdYFYZZPGrO2oPF3gwEypcnL+EwyeHP4cWlSJBxPHbCqwIjWhYHDUVNJjj/GbezoWiXI06tKXDauIgNrW70n6x3Iu0zJ5PQQJZj9rEUxdOOlVQT+1Oj5OZcVRFIJuS511G2SNHUFOZR790SVPoERKwypmnXi3thoJnKqgyueWFlQLjF3P0p/L7Hu/IOV6NMJ3UEjObytNu1RlF8znjEvvEVYiDDcPaY0YsSuZQMofd63uFJuaxvq0+q0cflXN8YjxSE/NG/14ovhD8HZDCcFuMpAv4NS99Z61uy9ADpDwYkgO/a3UDiIuBHYWZwz8+Ykaze5L+gtXOkiZO9eDys8JVXt1N/rWEE4DDICCY2h1pE33w9wm1pa1ZmL0NQzNPpavBkQhfpUGr8NY9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5238.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(53546011)(66946007)(64756008)(2906002)(26005)(33656002)(110136005)(66476007)(71200400001)(7696005)(66446008)(52536014)(55016003)(9686003)(66556008)(8676002)(76116006)(8936002)(316002)(122000001)(38070700005)(508600001)(83380400001)(38100700002)(4326008)(6506007)(86362001)(54906003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2VOaGtsSjVuR00wSmxCT2I5aEE4ZldMKzg0cC9ZMTJWb0FzWHNRaHV3MG5B?=
 =?utf-8?B?T0pvdDdDdGRRcEYrMjUyWmRoZjR0MEhyYmEwNGhNQU1NaWVlUm9QVnc3d3E4?=
 =?utf-8?B?bmVxcGdZcWRDcEJueUwyZElid0lSbGVRNWZ6OUFDdEZZdkEyZjdiU3JjL1o5?=
 =?utf-8?B?bG5OZzhCcE9lalUwbWZDZnR5MXQrMHZrT0k5SFprT2xBSC9CelVUZmZ3ZWdC?=
 =?utf-8?B?RnI5cWJOeXRmYlA5OG55QlkxdGRCNzFBY3llU2c2MmhYQ2ZQYUdobWxwc080?=
 =?utf-8?B?VzdQOWRxSkxhMDRRUkc1VEZORmppY1BrOUhIcnJzSnlmbnFCK1V0MS84bVdk?=
 =?utf-8?B?Y05XRUx4YVozKzZtMDNTWFZETDlPbzNYRUNQMmdmeHlWQ1Y1c1Z4bkQyN3hI?=
 =?utf-8?B?WEZtdlZ1V1RycWd6T3ljRWFnVUc2cjYraWFVcWRrbkhyNHY1akFOU2lSN09s?=
 =?utf-8?B?QnowTU1OY0k2cGU0VDUwQlE5VHRxZk9XVHFVbEZQTVBGNnIwcHdlSGViRjJR?=
 =?utf-8?B?Tjh1Qml3cmFzVVJqV1dycHI1ZkFVdVdMeHpzaXRoQ1V0M2NicmJGalNzcVhN?=
 =?utf-8?B?QkhwSUpsYkVsTTkwRlU0Wno2ZlFJc2duT3JsZXNjamxFazZmVnV4aDdLV291?=
 =?utf-8?B?RGx6M3duaFZ4SGRPRW8vb1BpWVFBSVB1SnpyQmxUSzhJeTlRQU5BdzNBVHFm?=
 =?utf-8?B?K0dFRGVFRVV5dy8zeGNUQko3azZicUsxaXBYWU5NdlY3c0hRVTJXekV4eG1y?=
 =?utf-8?B?L0huUTZEOXNoNjNRZmJmc2orK3B5U2hyY2lwbWltcjh4VXlkR2QySk1UYkh4?=
 =?utf-8?B?TkVUZHhaS0lWS2JLa3dRbG51Vm1RWENZVmE1ZWlFdTFRTUV4dURWUm1tZDNi?=
 =?utf-8?B?WlR4NTRBaWk2aDBkUytuRHRoZWRXRVlROW5mVVgwK0hDbnBsVUJSZTE3TERN?=
 =?utf-8?B?Qi9NKzhDaU5nLzhjRFFuL1o4eWFwemo3S28zdVpSYm82YUlSeG1VVXc5b2dL?=
 =?utf-8?B?OVdWRysveWlDVnFYNmJDQWZlQ3dOdHJJNWZsSDRQQUc1VWpnMkRCeWZpT0F4?=
 =?utf-8?B?WWh6QUVFWk4vbVVIeXR2UlE5YTJ1WkJLR3ZOZXY0aU5lY1VwdDc1UURhWXNs?=
 =?utf-8?B?ZC9OSDMydE5lNWg4OWh1dFpiT0x4bVlPa01xUkN6QjNhdFF5Ym9aLzFqbHNZ?=
 =?utf-8?B?REhLa3Z0WTVadXc5ZkRJYVh4NmFDYndsZFVXZ0VJSUkzZ3Btdlg0c0ptaWxQ?=
 =?utf-8?B?NXRxNUtNMVVvQnZuU0t0TDVzaDh0SHdUd1MxYTBXMmdjZ3BPdnpGMUxHT2px?=
 =?utf-8?B?bW9mYnEyR1I0Q0dvWW90SWQ0QVJZVXRXY0NQbFc1WTRkSlJVTzhDVktoWHpm?=
 =?utf-8?B?NGdKN091MUFWWFFTV1AwNEU0QkZHMTNGOGNHYkhVRTM3Z0ZSTm1iV05Yb0VI?=
 =?utf-8?B?QXdsZEFnVm1BeXMxNlo5d1ZWWUVzNktTK0FlNW5MOU1mVjZzcFRpWmxoMVN6?=
 =?utf-8?B?bVdQa3pUeTdyMGNNKzhtZno0KzEwNU5nVGhyMmMrRjgwOU9BUW9xUHVUYk5B?=
 =?utf-8?B?bmxWcWRDN0RTZWlFclN0NThWWEk1NXBtTWxYSXdVT0kxcVFLT1hPZnhRT3VO?=
 =?utf-8?B?UlIrd1hLMGd4NGFMR09MZ1NGenFITnZpQVY5dHpSRDZvWk4yeG1od3ZadEV6?=
 =?utf-8?B?VUxxTW1lMVZwek96TjhFaUg5YjRhU2EzMjNRWmpBdFJZNDV5LzlCeFZuRERQ?=
 =?utf-8?B?VlcwUml6dVhOMWNGRzdCaDMrVzVCa3liOXN6cDZQTlFaUXY3d3VrYVlIZzlq?=
 =?utf-8?B?aHMvdlpXdUtkZUZnWmUxL1h4b0RnTkcvTTd1TVh0cm5HTU42L3pVZFhKK3l5?=
 =?utf-8?B?WHBLYUYrdlBteHhiaGY4UkJzWXM2QzY2b1lteE9uVDlvYlNsT2FTN1hjTVFi?=
 =?utf-8?B?dU5NQVNLcWlQYVJaYzdNdlRNcE1BYVRUbCtWd0F4ZldBeDE2UVdDay9xRHhm?=
 =?utf-8?B?N2hqZ0NIZ096bW1BTVdKWHJscEd6Q04vTmR3akVmeFllTW5mM3didU8vVWZ3?=
 =?utf-8?B?UDNUeWxvbFA5aG1rN2s0R3hQMnU3M3RydEZKaHo0d0hRWFhKMTN2ZWNVZ25q?=
 =?utf-8?B?VUVtSG9CanV6QWRSZm9UQWZETHltdGQvcGVyWm5wUjNHdTJxZ1VkdXJ1eGcy?=
 =?utf-8?B?L2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quicinc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB5238.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69285411-919b-4aed-af04-08d9d1389c0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2022 17:18:51.4655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sxzmZVqw2EDANjXAzkasBohjLgq5B6AGinAobeS4+iVba24b4TzkyZoW+0R/kHDHZgiUMJe6AALYDwfiu+MuBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogWW9uZ2hvbmcgU29uZyA8
eWhzQGZiLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBKYW51YXJ5IDUsIDIwMjIgMTE6NTEgUE0N
Cj4gVG86IFR5bGVyIFdlYXIgKFFVSUMpIDxxdWljX3R3ZWFyQHF1aWNpbmMuY29tPjsgTWFydGlu
IEthRmFpIExhdSA8a2FmYWlAZmIuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
YnBmQHZnZXIua2VybmVsLm9yZzsgbWF6ZUBnb29nbGUuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0hdIEFkZCBza2Jfc3RvcmVfYnl0ZXMoKSBmb3IgQlBGX1BST0dfVFlQRV9DR1JPVVBfU0tCDQo+
IA0KPiBXQVJOSU5HOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFF1YWxj
b21tLiBQbGVhc2UgYmUgd2FyeSBvZiBhbnkgbGlua3Mgb3IgYXR0YWNobWVudHMsIGFuZCBkbyBu
b3QgZW5hYmxlIG1hY3Jvcy4NCj4gDQo+IE9uIDEvNC8yMiA0OjI3IFBNLCBUeWxlciBXZWFyIChR
VUlDKSB3cm90ZToNCj4gPg0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4+IEZyb206IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4NCj4gPj4gU2VudDogV2Vk
bmVzZGF5LCBEZWNlbWJlciAyOSwgMjAyMSAxOjA2IFBNDQo+ID4+IFRvOiBUeWxlciBXZWFyIDx0
d2VhckBxdWljaW5jLmNvbT4NCj4gPj4gQ2M6IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+OyBU
eWxlciBXZWFyIChRVUlDKQ0KPiA+PiA8cXVpY190d2VhckBxdWljaW5jLmNvbT47IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7DQo+ID4+IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IG1hemVAZ29vZ2xlLmNv
bQ0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIXSBBZGQgc2tiX3N0b3JlX2J5dGVzKCkgZm9yDQo+
ID4+IEJQRl9QUk9HX1RZUEVfQ0dST1VQX1NLQg0KPiA+Pg0KPiA+PiBXQVJOSU5HOiBUaGlzIGVt
YWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIFF1YWxjb21tLiBQbGVhc2UgYmUgd2FyeSBv
ZiBhbnkgbGlua3Mgb3IgYXR0YWNobWVudHMsIGFuZCBkbyBub3QgZW5hYmxlDQo+IG1hY3Jvcy4N
Cj4gPj4NCj4gPj4gT24gV2VkLCBEZWMgMjksIDIwMjEgYXQgMDY6Mjk6MDVQTSArMDAwMCwgVHls
ZXIgV2VhciB3cm90ZToNCj4gPj4+IFVuYWJsZSB0byBydW4gYW55IGJwZiB0ZXN0cyBkbyB0byBl
cnJvcnMgYmVsb3cuIFRoZXNlIG9jY3VyIHdpdGggYW5kIHdpdGhvdXQgdGhlIG5ldyBwYXRjaC4g
SXMgdGhpcyBhIGtub3duIGlzc3VlPw0KPiA+Pj4gSXMgdGhlIG5ldyB0ZXN0IGNhc2UgcmVxdWly
ZWQgc2luY2UgYnBmX3NrYl9zdG9yZV9ieXRlcygpIGlzIGFscmVhZHkgYSB0ZXN0ZWQgZnVuY3Rp
b24gZm9yIG90aGVyIHByb2cgdHlwZXM/DQo+ID4+Pg0KPiA+Pj4gbGliYnBmOiBmYWlsZWQgdG8g
ZmluZCBCVEYgZm9yIGV4dGVybiAnYnBmX3Rlc3Rtb2RfaW52YWxpZF9tb2Rfa2Z1bmMnDQo+ID4+
PiBbMThdIHNlY3Rpb246IC0yDQo+ID4+PiBFcnJvcjogZmFpbGVkIHRvIG9wZW4gQlBGIG9iamVj
dCBmaWxlOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5DQo+ID4+PiBsaWJicGY6IGZhaWxlZCB0
byBmaW5kIEJURiBpbmZvIGZvciBnbG9iYWwvZXh0ZXJuIHN5bWJvbCAnbXlfdGlkJw0KPiA+Pj4g
RXJyb3I6IGZhaWxlZCB0byBsaW5rDQo+ID4+PiAnL2xvY2FsL21udC93b3Jrc3BhY2UvbGludXgt
c3RhYmxlL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9saW5rZQ0KPiA+Pj4gZF8NCj4gPj4+
IGZ1bmNzMS5vJzogVW5rbm93biBlcnJvciAtMiAoLTIpDQo+ID4+PiBsaWJicGY6IGZhaWxlZCB0
byBmaW5kIEJURiBmb3IgZXh0ZXJuICdicGZfa2Z1bmNfY2FsbF90ZXN0MScgWzI3XQ0KPiA+Pj4g
c2VjdGlvbjogLTINCj4gPj4gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL1JFQURNRS5yc3Qg
aGFzIGRldGFpbHMgb24gdGhlc2UuDQo+ID4+DQo+ID4+IEVuc3VyZSB0aGUgbGx2bSBhbmQgcGFo
b2xlIGFyZSB1cCB0byBkYXRlLg0KPiA+PiBBbHNvIHRha2UgYSBsb29rIGF0IHRoZSAiVGVzdGlu
ZyBwYXRjaGVzIiBhbmQgIkxMVk0iIHNlY3Rpb24gaW4gRG9jdW1lbnRhdGlvbi9icGYvYnBmX2Rl
dmVsX1FBLnJzdC4NCj4gPg0KPiA+IFRoaXMgd2lsbCBhbHNvIHJlcXVpcmUgYWRkaW5nIHRoZSBs
My9sNF8gY3N1bV9yZXBsYWNlKCkgYXBpJ3MgdGhlbi4gQWRkaW5nIHRoZSBjc3VtX3JlcGxhY2Uo
KSB0byBhIGNncm91cCB0ZXN0IGNhc2UgcmVzdWx0cyBpbiB0aGUNCj4gYmVsb3cgZXJyb3IgZHVy
aW5nIGJwZiBwcm9ncmFtIHZhbGlkYXRpb246DQo+ID4gIkJQRl9MRF9bQUJTfElORF0gaW5zdHJ1
Y3Rpb25zIG5vdCBhbGxvd2VkIGZvciB0aGlzIHByb2dyYW0gdHlwZSINCj4gDQo+IEkgc2F3IHlv
dSBwb3N0ZWQgYSBuZXcgcGF0Y2gsIHNvIGl0IHNlZW1zIHlvdSBoYXZlIHJlc29sdmVkIHRoaXMg
QlBGX0xEX1tBQlN8SU5EXSBpc3N1ZS4gRG8geW91IGtub3cgd2hhdCBpcyB0aGUgcmVhc29uIGZv
ciB0aGlzDQo+IHZlcmlmaWNhdGlvbiBlcnJvcj8gSGVyZSwgdGhlIHByb2dyYW0gdHlwZSBpcyBj
Z3JvdXBfc2tiIHdoaWNoIHNob3VsZCBub3QgbWVzcyB1cCB3aXRoIEJQRl9MRF9bQUJTfElORF0g
d2hpY2ggaXMgbW9zdGx5IGZvciBjbGFzc2ljDQo+IGJwZiB0byBleHRlbmRlZCBicGYgY29udmVy
c2lvbi4gRGlkIEkgbWlzcyBhbnl0aGluZyBoZXJlPw0KPiANCg0KV2FzIGFuIGlzc3VlIHdpdGgg
dXNpbmcgYnBmX2xlZ2FjeS5oIHRvIGxvYWQgYnl0ZXMuDQo=
