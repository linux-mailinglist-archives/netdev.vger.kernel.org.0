Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A943528BAD9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbgJLO3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:29:14 -0400
Received: from alln-iport-4.cisco.com ([173.37.142.91]:45829 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgJLO3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:29:13 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2020 10:29:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2042; q=dns/txt; s=iport;
  t=1602512951; x=1603722551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=erg6RD7kH3UVInhkXiBJQ6P62KCG3m4qmbrHoMzGetg=;
  b=IaASo3s6bleO8xjHm60aMDP/6PLrHL0GOBtXQITFkGEkOEdG7oPU0Uki
   43FhqZLEH2xr/QXtRamMiSxPsbt+52egqeHDM2OYR76SfABcub2M1QuaK
   ZDY20ASMOdpsOnr+d/BGnjpjXFHmH9ua2hOT8VCG86Ry/w2KouGYqQDvp
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3AykNwwBYMfdKJ4ld8kx0Q8r3/LSx94ef9IxIV55?=
 =?us-ascii?q?w7irlHbqWk+dH4MVfC4el21QWTD4PW9/xFj/bbqebnQ2NTqZqCsXVXdptKWl?=
 =?us-ascii?q?dFjMgNhAUvDYaDDlGzN//laSE2XaEgHF9o9n22Kw5ZTcD5YVCBpHCu4z8WBh?=
 =?us-ascii?q?jlcw1vKbe9Fovblc/i0ee09tXaaBlJgzzoZ7R0IV22oAzdu9NQj5FlL/M6yw?=
 =?us-ascii?q?DCpT1DfOEFyA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CvDAB9ZYRf/49dJa1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHgUkvLIQ9g0YDjSMIJph7glMDVQsBAQENAQEtAgQ?=
 =?us-ascii?q?BAYRKAheBfwIlOBMCAwEBCwEBBQEBAQIBBgRthVwMhXMBAQEDEhEEDQwBATc?=
 =?us-ascii?q?BDwIBCBgCAiYCAgIwFRACBA0BBQIBAR6DBIJMAy4BnDcCgTmIYXZ/M4MBAQE?=
 =?us-ascii?q?FhQUYghAJgQ4qgnKDboZWG4FBP4ERJwyCLy4+hD0XgwCCYJMOPKQaCoJoml0?=
 =?us-ascii?q?FBwMfgxWKCJQds0cCBAIEBQIOAQEFgWsjgVdwFYMkUBcCDY4fg3GKVnQ3AgY?=
 =?us-ascii?q?KAQEDCXyNTAEB?=
X-IronPort-AV: E=Sophos;i="5.77,366,1596499200"; 
   d="scan'208";a="560417924"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Oct 2020 14:22:06 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 09CEM5Ir029706
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 12 Oct 2020 14:22:06 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 09:22:05 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Oct
 2020 10:22:04 -0400
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 12 Oct 2020 10:22:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ub82k+0wuZJoEf3u/59YMVlpliDnhZB17CK2W8vwxJMQm8qcr65DTZ4GGC/cEfZOccWgiSNM0blaRj/hB6yvl7JHPvthOhfM8sd58vGMukpzMpwZuooBopAgLhpqJSlvQ1T5+9G9oQPJ/jgN2z31HOFaZ82Sl8qS6pAQXw/QGPnZTw5ZE81K4f17vNwfIQFNWOI6/CDd1PNXRsSa2NdJiuUZtOIQY+J9vttA1cvuBApB/z1wWWpKUZ0hRdw6lm05soNvp9ppWGzljQ5V7PtOL46Age7G2ZRjWAW0L5Mt7CoSImXNcwb9AHyPu5PVjt/7X/uiKbBm067QniWeEyovOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erg6RD7kH3UVInhkXiBJQ6P62KCG3m4qmbrHoMzGetg=;
 b=Iro3ICTUjCF2E9CVU+BdyGXSao+alX+jD8VNkRUWE3uJMx3gtlIBXZVvVfMIFZ1KirM7tRHi+xKtm9+ICI7NHu63psQ2AO68SWFUU4fjmb3hS9jybK0tqqOGiQo1GAyk1x4zrPHiZod0QmLGT/ghhYBK9RfsqcNCKAdTx7yAQGr41ISe1o5NBXJTHw3xyJVhCph6z1SjRTf2DpQajdxiQYGnT3yoQOmuUZhcjeUeChJ9/htLvTxImcbj+siccfRSbvMtHlkDm+AhL/fbx3pANjNBYKqZI4mcAgE/AqF/26m8Hp1qKg+8etumvPxOCTCWKnoEV+UCrQo7TqpvLLcpgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erg6RD7kH3UVInhkXiBJQ6P62KCG3m4qmbrHoMzGetg=;
 b=v5zlfv6wttZVjM5jcLt1OvDf9cquARS7jaTq0bHi4EODI5OlQ41v5pHSKywneIfKHyRWYmB2v75NSG2b4SRUQhFDq4+CKQ5BKInL2s33chdBXEX0wU21NmpI9UjYXAlFSFaCxwCF1Ai8JapktFRiVZ7ZOQvD8hBxFdlDBQSzO04=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by BL0PR11MB3492.namprd11.prod.outlook.com (2603:10b6:208:7c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.29; Mon, 12 Oct
 2020 14:22:04 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba%4]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 14:22:04 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net] netfilter: Drop fragmented ndisc packets assembled in
 netfilter
Thread-Topic: [PATCH net] netfilter: Drop fragmented ndisc packets assembled
 in netfilter
Thread-Index: AQHWoJbBEebqCsIskUSF95qGreIjMKmT7PQAgAAX+QA=
Date:   Mon, 12 Oct 2020 14:22:03 +0000
Message-ID: <a7ab5aff-7a3d-f8f8-5250-c8e2fdfbcbc2@cisco.com>
References: <20201012125347.13011-1-geokohma@cisco.com>
 <20201012125614.GA27601@salvia>
In-Reply-To: <20201012125614.GA27601@salvia>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1008::457]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fa7886df-e349-4da4-cb8b-08d86eba312d
x-ms-traffictypediagnostic: BL0PR11MB3492:
x-microsoft-antispam-prvs: <BL0PR11MB34929B33A1056900AE9C8A8DCD070@BL0PR11MB3492.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKEI5sLhTT17DdI/ofACINQzl3alV+Whq+Ue71cx0do4cNxLmRZSXEWRHsX0mhf5GLfL0zD72SCegfVpGyWYhxfkPcquvY9P9MN3MIJ8WzHgCXLeQgLbXXZjjxi1rpT5oxSQKZA9dvpVoSD49fbWOEpsQqLeUl6Elz3XwDyjBW3ADo2MQPXeImzP/IYP4fxjb76AAJ+jgg4cCoA9vv8DDyt5AV72T8NzKiMh/DAAnQT8+SXhSZysYiRhkn0w8t5AtVgGRvZJK8C7cR9gFsry1Qwm4jVU2tZtBBk6LDERahIltYqkQLLtE2M1OxRy9AEEonL3srYLzX2OXqI83quWxFFHXggJ/l07TkcHZHdeHAQY46C6el43nGF5u5b4oGjB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(6916009)(316002)(31696002)(2906002)(8936002)(6512007)(5660300002)(54906003)(36756003)(8676002)(478600001)(53546011)(66446008)(31686004)(64756008)(66476007)(6506007)(4326008)(66946007)(66556008)(186003)(91956017)(76116006)(6486002)(2616005)(71200400001)(86362001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6YlSJxHNzEF1XpPZD0c4ZPqR3Ili4rFxb3qc6erbihbzjIYMj+O22YBQGyaYV3gYiJPS07HYQ4O0A3Plm2aaRKqU9i+re/GuTQY+R9wNdAYjcduurybh+rRHGuw3pkwhVIiLPOOCPVpU8AeZ2pBtpuaaNslQVJz2nZ640VpV2pnp7mDKtCn8J3OpmrvhgkZqr+HBlWSkQystXIJgc4YFZxNs4k7mdtSYzMT5++D2ahIW1lK8/39PLziLpCpP1NDiJn/vT2TRlj7lnvB2LcwHBoRpasBSlzYCRNY0/tSsGqBIQiaK6r4CW2qdcGFefJC0Sjn0tovxAMdrfwvCgHn4QWSSSW+yllicP144eOP3qu3Q7le/5vIqL7bIhNmUNjsmFMCRfRexNngHykfIkouHUnbdUqf1X/MhRClJ7zqnMkwSS/1vAt+MHD8FYuiYeufyGlvxzXUyxalFWzNUh6BWoJN4yURwiTeA7EA89B98f0KrmPwnC+woKFwQ4DyOak7utqXVZ/TL8RbeduCwgnRQV6WaV5CQVdWn2vGsRbZwEEK55BHm+lQGX0IbFyo7xwvhXoA33LPoVlWBKdOiP97mpm0OdqTSCFZwBRvwSIbzogiIYA81BnX8GVIOLVhI5G/2F4SvoMjpCFTZpxWPqlGfJxCh26rHeGppTv3r8G0swAE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF18CAC328110146881FCD989DCD1392@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7886df-e349-4da4-cb8b-08d86eba312d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 14:22:03.9753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mD2UOYNUz6k+0krznr+0wPSz2X4r94bvhgvsjwPiqWwZL2qRb5HcCL5F1/fVF7suZAIkh41+8QWM0Qw+kXlujw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3492
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIuMTAuMjAyMCAxNDo1NiwgUGFibG8gTmVpcmEgQXl1c28gd3JvdGU6DQo+IFBsZWFzZSwg
Q2M6IG5ldGZpbHRlci1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcgZm9yIHlvdXIgbmV0ZmlsdGVyDQo+
IHBhdGNoZXMsIHNvIHBhdGNod29yayBjYW4gY2F0Y2ggaXQgdGhlcmUgdG9vIG5leHQgdGltZS4N
ClRoYW5rIHlvdSwgSSB3aWxsIG5leHQgdGltZS4NCj4NCj4gT24gTW9uLCBPY3QgMTIsIDIwMjAg
YXQgMDI6NTM6NDdQTSArMDIwMCwgR2VvcmcgS29obWFubiB3cm90ZToNCj4+IEZyYWdtZW50ZWQg
bmRpc2MgcGFja2V0cyBhc3NlbWJsZWQgaW4gbmV0ZmlsdGVyIG5vdCBkcm9wcGVkIGFzIHNwZWNp
ZmllZA0KPj4gaW4gUkZDIDY5ODAsIHNlY3Rpb24gNS4gVGhpcyBiZWhhdmlvdXIgYnJlYWtzIFRB
SEkgSVB2NiBDb3JlIENvbmZvcm1hbmNlDQo+PiBUZXN0cyB2NkxDLjIuMS4yMi8yMywgVjZMQy4y
LjIuMjYvMjcgYW5kIFY2TEMuMi4zLjE4Lg0KPj4NCj4+IFNldHRpbmcgSVBTS0JfRlJBR01FTlRF
RCBmbGFnIGR1cmluZyByZWFzc2VtYmx5Lg0KPj4NCj4+IFJlZmVyZW5jZXM6IGNvbW1pdCBiODAw
YzNiOTY2YmMgKCJpcHY2OiBkcm9wIGZyYWdtZW50ZWQgbmRpc2MgcGFja2V0cyBieQ0KPj4gZGVm
YXVsdCAoUkZDIDY5ODApIikNCj4+IFNpZ25lZC1vZmYtYnk6IEdlb3JnIEtvaG1hbm4gPGdlb2tv
aG1hQGNpc2NvLmNvbT4NCj4+IC0tLQ0KPj4gIG5ldC9pcHY2L25ldGZpbHRlci9uZl9jb25udHJh
Y2tfcmVhc20uYyB8IDEgKw0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMg
Yi9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRyYWNrX3JlYXNtLmMNCj4+IGluZGV4IGZlZDk2
NjYuLjA1NGQyODcgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvaXB2Ni9uZXRmaWx0ZXIvbmZfY29ubnRy
YWNrX3JlYXNtLmMNCj4+ICsrKyBiL25ldC9pcHY2L25ldGZpbHRlci9uZl9jb25udHJhY2tfcmVh
c20uYw0KPj4gQEAgLTM1NSw2ICszNTUsNyBAQCBzdGF0aWMgaW50IG5mX2N0X2ZyYWc2X3JlYXNt
KHN0cnVjdCBmcmFnX3F1ZXVlICpmcSwgc3RydWN0IHNrX2J1ZmYgKnNrYiwNCj4+ICAJaXB2Nl9o
ZHIoc2tiKS0+cGF5bG9hZF9sZW4gPSBodG9ucyhwYXlsb2FkX2xlbik7DQo+PiAgCWlwdjZfY2hh
bmdlX2RzZmllbGQoaXB2Nl9oZHIoc2tiKSwgMHhmZiwgZWNuKTsNCj4+ICAJSVA2Q0Ioc2tiKS0+
ZnJhZ19tYXhfc2l6ZSA9IHNpemVvZihzdHJ1Y3QgaXB2NmhkcikgKyBmcS0+cS5tYXhfc2l6ZTsN
Cj4+ICsJSVA2Q0Ioc2tiKS0+ZmxhZ3MgfD0gSVA2U0tCX0ZSQUdNRU5URUQ7DQo+PiAgDQo+PiAg
CS8qIFllcywgYW5kIGZvbGQgcmVkdW5kYW50IGNoZWNrc3VtIGJhY2suIDgpICovDQo+PiAgCWlm
IChza2ItPmlwX3N1bW1lZCA9PSBDSEVDS1NVTV9DT01QTEVURSkNCj4+IC0tIA0KPj4gMi4xMC4y
DQo+Pg0KDQo=
