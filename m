Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97CDB6A0B8F
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbjBWOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 09:10:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbjBWOKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 09:10:11 -0500
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01olkn2027.outbound.protection.outlook.com [40.92.98.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B4D4FCAB;
        Thu, 23 Feb 2023 06:10:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eTXpzI/knA05PVNVW9Fb2RNk1g+e4IUUn9EIeSvovzbLI5g5rKZmLcuEjpZjDV2T3grUv5YzIxzybaML8DVPFmQ2i1guDxpHQ3UGe9J8C1vyRgNRzIJ4pG5hdRiPOvun/KxifU5WvnRoqB8mywwi+unwMaO0ULfrq0HeialYyjYv+9h1G2kYgg1xZ8CzcB13fWDE1tvOaNMLwR4PqVS8S7HYH2GoKr54nFELUQrkp7daaeS9RDVN34IQNoGjuj3mbjx22Xq+juHOQ3LlbDaitFQWcJAW7MGMjsHvY2sU4zsX/yMlPzBljbFBB5Yjm1APGe8EwgLXC/1moXHX9oFVmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuXYWTxmjIoTnXPh3IlSiTjIlMd/7PS/o7AytNFzF98=;
 b=kWKq299HlzsqeVOi7KAyDfVK8WvSCBGrwlSu9SlgGBWZeRy2mj4q/dpOu4/PpI/Bw9Gre8zYERTE/EHGTFS3n40M0LyNFXZlKMB2KMhlaX/gSCNm9uf1RbtIls0xlmBIoIiQIucugAWi7kdxD42OuBW5ARhM/+/P/+hYfcV0aCWtZeruzvXKrKY9uoIFEUWtGdzEaVhHDQv9m0hQysQbZ5U9KIhBar7f5cTueamb3KKcbkEL7OQZvHH6wmkzSjLMkEuZGayZ/LC8aD5o/cLNhtwUAl10KducvBbw2y23KqkgOPR496+ZfqDqU1E2Sbe1wXO1iIVCo2CXpihwrVmdzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuXYWTxmjIoTnXPh3IlSiTjIlMd/7PS/o7AytNFzF98=;
 b=mBxaDgE72OFqAckDQnZOaRXQ6aJPD+uu9t1zERNPe6hL+gq1+yl42sJT4QJUc4EJhjtnr+WKOp9DAJOZvhtXQpw2WAuuiES6Dv3YoZWRJGY8pfoASEpQ5mUHUMlHMsdmccaRhIof5GzUbzyTiWYqSfQZxiFX9WJO00piE01Yjvyv76oo+e6stU0eye1++04LJqu2F7pv6e53o060PgXpIqTJen7widbATjFoBAkgEQWMd6uD1K0bYM3aH3V3/kxzs6b0Vy61swnQLLXcwzFn9zYehYPFWl6cRVwV4GYCX0eKv0g1qIHIxyy/5UZgJh5CcXQvH8+qzpM/GrSJQFATyQ==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYWP286MB3560.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:390::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 14:10:06 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Thu, 23 Feb 2023
 14:10:06 +0000
From:   =?gb2312?B?1LUgzNU=?= <taoyuan_eddy@hotmail.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/1] net: openvswitch: Use on stack
 sw_flow_key in ovs_packet_cmd_execute
Thread-Topic: [PATCH net-next v2 1/1] net: openvswitch: Use on stack
 sw_flow_key in ovs_packet_cmd_execute
Thread-Index: AQHZR4FotInn34zS50WzoBK8YtCA8a7cdKMAgAAEvoCAABhgBA==
Date:   Thu, 23 Feb 2023 14:10:05 +0000
Message-ID: <OS3P286MB22955BF6A1B4B782C3E12A61F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
References: <OS3P286MB229572718C0B4E7229710062F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
         <OS3P286MB22957CD400DAAAB7786FEF96F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
 <633f202d784a8c67fb846336941ef3e22877d1c7.camel@redhat.com>
In-Reply-To: <633f202d784a8c67fb846336941ef3e22877d1c7.camel@redhat.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [udW8z+fGTttnp4JjzCAFv6ih6mWNqeJ5]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OS3P286MB2295:EE_|TYWP286MB3560:EE_
x-ms-office365-filtering-correlation-id: 85b4767c-3810-4c82-754d-08db15a7aa12
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AK5JHDivNNMrQpvOYhv9UPuMzEq17mhcrsl4Q1zkHHF1vFe47DvppWw/+9V2QSWMHWFHPN5xHG9m4Ve7LqnjVg42DNp7NOMkeId7JaVbsJofFyb+9dXFR3QGwE/V2sSYqxVExzVk5nVuzCaGjInDoB4aDq3CV2PiUPMWjDBCoCtEABme4Td/Jsfgb6zBM0bkW4P1SOM9CanoX/8Lkzu4CCefddc7Vm/t//8KGFtqTUgoCwY04gEpPMizIedLrB5Et2SQ8DBcAW1tnSfEe1xn+AezzogZw5Bfj/Xs/3l7enOxw1SoH3mX1+HNiG+6YQjvhQi8vy9dpJ+Y337WRYIzieWHFl8AQejlqJiLUaWSu5dGfy5awFAFOgbFjqsiq2YvttAk4/G8R9Zi0aty1GEWIxh6A7oszMn0sgElT9tMa1stXeB6ff4ehfkUqhkyPymMkKDOdKE+hKi7lJJE4XJuoL6CYOeidCQ2bFyieWo7SnScD6Aqc06nXyMHTwS/+OwUnhOV6cJtJBq06Z/NjXAfkqy3ns50f+/5rtbRvMjqtDDNphso1j+UnruFVC6SeoKdTZNFmeZeY77jptKEsneKwHgb1PegepyA1Ydof71KrcFgD03Ap3MjTqo1HE4XVTTS2jGjlXYxJU1BMfdM4iUROA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cFlrUzRHeGpxV09LOXkzcnNCblVQVTNNWnN1T2dVRjZJVU42Yjdld3FXeXVk?=
 =?gb2312?B?a2s2VHl1Sis0Rm1FNDNPaS9GNSsvaWlSTnlnYzBXNkd4UnF1KzZjeURwVWNC?=
 =?gb2312?B?TDZhRTE0bGwzOVozc1JVS1dLYmEveTV5bWhacFV2TVk1ZU1mWWx2R0tNNDJw?=
 =?gb2312?B?TnVJQWVDSXAvTE5qcmIzZEVWN3kzay8zZlFXS1ljMVlJa3p1dTZ5ZmRHdHgv?=
 =?gb2312?B?aUxLaGdBSVFZK1hsdlQzSjI5eWl6eGF1Q1duL1plaVZxUE53Uy8vUEhCYk1j?=
 =?gb2312?B?UDJwL2UvL1NrSHNVSC82N1J0aGNscnI2TjNEbExUZGozSEdiaksyUzhhVEFF?=
 =?gb2312?B?NE5PdXh3TVVlT21hSFlZQXJSWEJXM0R3K1NmRXdmWXJVTXFLdHZnU0R4QlQz?=
 =?gb2312?B?a2ExL2s2cENTRFFEM0Y1NHhaMmZPK0w3eXpKbytTQVBKRGxHb29rNjVzeTZJ?=
 =?gb2312?B?NWkva09kbHRuTjk5SEZNdVBDWWx3ODVVUzl0Q0daUEcvOG54elRVejA4SE9n?=
 =?gb2312?B?aUlmaEN6cHRNZDJ0ODJxM2NOdzc4WnlXbzRUOE1SYm1VMkdjV0ZvUTA5ek5G?=
 =?gb2312?B?cmxLVWloOU5NVWcvZ00zbUR3aEVrRk5GZ0E4TXlnbURLS1AxMnl1ZS8yUW5t?=
 =?gb2312?B?SExESVFBYWZlZk9IbW9jWGZDb3QvOW04R0FlLzVRRWF5WGhjRzd1MUx2TlpG?=
 =?gb2312?B?aDR1K0wvVDFkZjVKcEhCSjFXVFRRNmpiREVROUdJQkcxa1k2T1hsN1hWYWtN?=
 =?gb2312?B?djA4V0ZyS0pGL2ZWSzM5Z3V0Q0Z3bnBnYkZMTXZWOFk2WVJLVDNGTEpsWXM0?=
 =?gb2312?B?N3hqdk5ra2R4dHhqSmVaOC8yaTdJQldzNnByRnB6T1hWaDNXUmZmbjlyV3o3?=
 =?gb2312?B?V2FLdzVDU2gvOHNkQXpRcEUwUWl0TVIyS21EWHliQlhqaGNYRThWYnVteUhx?=
 =?gb2312?B?UkMwK1dQeGp4MEZQeEZCZGd2ZU42N282L1ZINVcrRlhEL2NDNkJHVXdSUHJs?=
 =?gb2312?B?NEJGWE5GdmQySkdSVVI2cm1COURBOWk3cS9jQWR1Z0R3MXMvbG9VcEY4a1Vj?=
 =?gb2312?B?dUh0L202THo4WEo5elNXbVIyQmhMa0JReVRqb0IzVnF1RHNJU3hNcTdoazVj?=
 =?gb2312?B?dGcyR2I3TVZSazRmQVBJN1RwQkxpNjRTeXB3WE5Bb2h2NVpuVlZKZFcrbjNo?=
 =?gb2312?B?Vk5RNE5mV3R6Uy83MTgvN2E5UVVsSG5TY1g3QWhvaFNSM3pJL1NHL1VRclJJ?=
 =?gb2312?B?UThzdUhUNnVHVE1wamIwUG5WLzZBNnZqZGkwb1gvS3dzQU9wTUxCUS9YK0Fr?=
 =?gb2312?B?Q2lzVzk4ZUlEUmQ5NTViQ2FLaTNrdXdGTWN4VkRpblFNNUN4cUtXOXErSk9C?=
 =?gb2312?B?bm1ENkYrZHZKdjBLMHVDWUo2S0tpQTBSaTh3QVhpRlJuNXJHY2xKVzJlVlc3?=
 =?gb2312?B?b2FkK2gwbHMvaFY1bVV4RmVMdlVrRllxalk4cmtVYmpwZk0vdGhSTW1BcEt2?=
 =?gb2312?B?Zno2SXdNY3FETUp0aHVtVVRJT1NlL1NsTnA0eG1XZGtBWWhIeFFTbkFuRndK?=
 =?gb2312?B?RTBOQkFMS3MzU1BxbjJTbCszTGRSL296RGdIZWhxNFRKMnh6VHVPSW5UaytF?=
 =?gb2312?B?bWlXTnBmMm9ndkprY0laa0xhb01aU3ZzNnJveGxpNTh1RlNvRWJjdkpxVFR6?=
 =?gb2312?B?VmZiU2JWMzVFblFuYVdjSzZaVDJuekVpaFdtdC95L0VvTXFWa3B1YlV3PT0=?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b4767c-3810-4c82-754d-08db15a7aa12
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2023 14:10:05.9959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB3560
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U3VyZSwgd2lsbCByZWRvIHRoZSBwb3N0IHdoZW4gd2luZG93IG9wZW4KSGF2ZSBhIGdyZWF0IGRh
eQplZGR5CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCkZyb206IFBh
b2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT4KU2VudDogVGh1cnNkYXksIEZlYnJ1YXJ5IDIz
LCAyMDIzIDEyOjQxClRvOiBFZGR5IFRhbzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZwpDYzogUHJh
dmluIEIgU2hlbGFyOyBEYXZpZCBTLiBNaWxsZXI7IEVyaWMgRHVtYXpldDsgSmFrdWIgS2ljaW5z
a2k7IGRldkBvcGVudnN3aXRjaC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcKU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MiAxLzFdIG5ldDogb3BlbnZzd2l0Y2g6IFVzZSBv
biBzdGFjayBzd19mbG93X2tleSBpbiBvdnNfcGFja2V0X2NtZF9leGVjdXRlCgpPbiBUaHUsIDIw
MjMtMDItMjMgYXQgMjA6MjQgKzA4MDAsIEVkZHkgVGFvIHdyb3RlOgo+IFNvcnJ5LCB0aGVyZSBp
cyBhIHR5cG8gaW4gdGhlIG1haWwsIGkgd2lsbCByZXNlbmQgc2hvcnRseSwKCnBsZWFzZSwgZG9u
J3QgZG8gdGhhdC4KCiMgRm9ybSBsZXR0ZXIgLSBuZXQtbmV4dCBpcyBjbG9zZWQKClRoZSBtZXJn
ZSB3aW5kb3cgZm9yIHY2LjMgaGFzIGJlZ3VuIGFuZCB0aGVyZWZvcmUgbmV0LW5leHQgaXMgY2xv
c2VkCmZvciBuZXcgZHJpdmVycywgZmVhdHVyZXMsIGNvZGUgcmVmYWN0b3JpbmcgYW5kIG9wdGlt
aXphdGlvbnMuCldlIGFyZSBjdXJyZW50bHkgYWNjZXB0aW5nIGJ1ZyBmaXhlcyBvbmx5LgoKUGxl
YXNlIHJlcG9zdCB3aGVuIG5ldC1uZXh0IHJlb3BlbnMgYWZ0ZXIgTWFyIDZ0aC4KClJGQyBwYXRj
aGVzIHNlbnQgZm9yIHJldmlldyBvbmx5IGFyZSBvYnZpb3VzbHkgd2VsY29tZSBhdCBhbnkgdGlt
ZS4KCg==
