Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C044473AA6
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbhLNCOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:14:17 -0500
Received: from mail-psaapc01on2131.outbound.protection.outlook.com ([40.107.255.131]:24602
        "EHLO APC01-PSA-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231543AbhLNCOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 21:14:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDqQLhDWg/atc0YHQaDwrLC8//Q15ivLYbiyyAlOZW+Sc/5KPFhmtQnlazNMJ/ZDBHRfB6+WVMLxfIkITWwx4nhdDMFVPMLciw/hGMsxGyJpWwreHueczDKqDk6UqhkK+Ao8K3SjYUaRk1y0DLNdiqlAwmqPHOKMxRwpLyQfNQ5k0xYTJCog0hdlYeL72zs3QOlKrINhmxFLsjdVaDL44oVmR0ZfjpLO8cxJyJ5Em4G8waPuIysgDBbUZnCms73FTeW9MPJAZ+Xezb9Fu0ZjjJrdxz5vj0/lsldMj2woFj22EfA5C1Z5ZZw5xxraas2gWrykeMxOT+J8danqBzdosg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lLBAzweCgND1G7h+3v219E235QXz7w6ASU7aBLqFP8I=;
 b=IVDH4fLFixYSpBCbpFc8OXTbHeqW0Yr5fo/CV/IefsqPNt7TuTz2JmjaGaS/wnbYDf4/cY9rCQUXVnw9VcrflzdsWsIZaoRNXp73um227N+lJvZJxrBZhSY88/3oef+OE1g9j0Xaxty87qfKMcdNNF9K1tCio5F93vC9pVF3dqC0QzURaXiEJGXxYWUtGyyFn2NFxlqKy51Jud8y7a/MxAApX0PT3aPdn79e4K3XlR5vu0KBjKWljzfgihM6CBvwCopi3lz/OOqqmMLTdLH8QG4gWnet7rFH/KTXrZNZ2LDe7DWV6Rx/qIVGxdOOJmcSL8mTWEOM90KrTFByKyNP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLBAzweCgND1G7h+3v219E235QXz7w6ASU7aBLqFP8I=;
 b=jt2PZddicVJg5a3YOyIPuYhiFrPJzaW/HAlPIKU/srQwtUeJtu6Z1+RnE1+wt1dS+IT6o4cuPJRUVQ50RirrNwua1l0UAWJIWQ5/8onuCyi/8SNa7ZK2BNHph996RC669s3GZnMFBFELXQ9mmNLZOpzBkFK4YSJOR+ngr3HQ3os=
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3243.apcprd06.prod.outlook.com (2603:1096:100:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Tue, 14 Dec
 2021 02:14:14 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396%4]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 02:14:13 +0000
From:   =?gb2312?B?zfXH5g==?= <wangqing@vivo.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: phy: add missing of_node_put before return
Thread-Topic: [PATCH] net: phy: add missing of_node_put before return
Thread-Index: AQHX8AYYpJEfF6j9uU24/kC+73Lm/6wwQf0AgAD9E+Y=
Date:   Tue, 14 Dec 2021 02:14:13 +0000
Message-ID: <SL2PR06MB308280CD1F51C87B171D1F64BD759@SL2PR06MB3082.apcprd06.prod.outlook.com>
References: <1639388689-64038-1-git-send-email-wangqing@vivo.com>
 <ALAA5ABiE1JEtj4aLwAwtqpi.9.1639393400698.Hmail.wangqing@vivo.com.@PFliY29jQlpCQUphWjBSZjZAc2hlbGwuYXJtbGludXgub3JnLnVrPg==>
In-Reply-To: <ALAA5ABiE1JEtj4aLwAwtqpi.9.1639393400698.Hmail.wangqing@vivo.com.@PFliY29jQlpCQUphWjBSZjZAc2hlbGwuYXJtbGludXgub3JnLnVrPg==>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: bd46784c-af8f-2199-03a6-3ae118c25fa0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 117179f3-1231-478b-936d-08d9bea76c47
x-ms-traffictypediagnostic: SL2PR06MB3243:EE_
x-microsoft-antispam-prvs: <SL2PR06MB3243BB31E0344B4F0FFD11D7BD759@SL2PR06MB3243.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /CxxhoQrC7kL9IEjctRV3fhKyBifNsJRXS2cCA4rbFbP/NrJ50mgM7VHgsEe4kB6eejZup4e+qCV2cgC8HvXQsdpNOY/xsMrHjPAsxCHpss0JR7BVIrPuahI0VwlNYr8e2ZCVcWqqcDjl64tqOY6XIHu/opHy9sNswAKKCz3LzrT4o7O6UcMkmNrLCsSNK8/RoNCvHWzrqH+9OwstLz5YJDUq5ds0Azsw30ABzFQ9T/y0cdztoTwNw3e0McXydkBol9Sz9JramdO550qyGTfv5Vf+bl2otuaKyzqPWXNiIBXREcOQuhqhouuBIA5SjHnHPMLI+2hqQS2fFOXGTk0NFhxSsupwNzsAZDke7cugqp7inrPbViY2r3cj6vBdvXKn28HIbONoN60/u5UiDc7zgmlx0QjYGN1WanjIfXYD1rHmPJy6NAVGQchlyDZ/Sp4K4FNODfNkcSAtR4zWzbsuFxwIgUk50hvFsseRbqcu59XJIBJ3SKTOt6Cvoi4bnjf5+oTPGX1WKzuiHmnHNjI47xADU7i7p19R1NgiVQmrCbI3+ZeqMMEbNSAaaukCS/Jb5MPEfe1hFGAkUHDVotq4ct9kg6IDuPeiUXZAinY7v2DVat11ysWVGJ4ydOiqNEJX1n1d1juda7CG05KHoFqMIHv84/IqXGbcz0vqTcrXG7EZCieVYUvEhMZNUIy9NpJNWqQRiGpj0GzvwcnDf0LnWVQznFBegn5z/OCkcF3r8KLQph1X+eAQxFNujQ2QQqArzJH6XzgWnpLqTU9N6yzQqENlwiFSqAlJ8mz+++Yw3s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(52536014)(8676002)(966005)(2906002)(38100700002)(9686003)(33656002)(122000001)(76116006)(7696005)(6506007)(91956017)(71200400001)(26005)(85182001)(86362001)(316002)(66446008)(6916009)(8936002)(4326008)(83380400001)(508600001)(66556008)(64756008)(66946007)(54906003)(66476007)(55016003)(186003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?QWtmNm45ckxBeFhSaW9sZzlBRFI5a3ZWY3NENVJacU14Vmg4cHpCZkxYeEJj?=
 =?gb2312?B?cks5MGQ4WStUbDRYclpiQ1RkMzFHNUhLa1hzVWsxV21ldFZyeEY0M3Nkcmo2?=
 =?gb2312?B?ZitmS0t0OVc1Q1JOVzdDamhkRUtOSGJGUTY5MHZ1NG9jbUJOU1hDZUJIY3RT?=
 =?gb2312?B?UzJFZnRQRzB2Y3VjSWlBa3V0ZUwvUG5EUHk2NmdvWGxQVmE3YmRWN3NxRHFC?=
 =?gb2312?B?dlFFOVJyd1lSaFlzSnB0aGU0b3ZTWHRSbUtzdVVwNldwL1RiWTFTSWdETVpo?=
 =?gb2312?B?N0pqeVkwMXA3alpkai9WLzE3KytOeTg2dGQzS3BKSk14aXVYY01JQ0xmM0hU?=
 =?gb2312?B?cS9MRmpYUEtpVVE4OHRwa3dLcnRBc0w2Rk9jSmVQNVVrUGpEUm51ZjVkdGl4?=
 =?gb2312?B?Y3dDQitXZ0psQ1dlbjFLLzNhSHlBQXowekp6Tkhib1U2K0xEbWNNVGQ0dzZx?=
 =?gb2312?B?ZmZzdStMWTJTNVR0dEh6QlVlSlVwSDIvZUFMVndsTWsxK2lZZXFrS2hkN0Vo?=
 =?gb2312?B?UVhjK2UrR0hKYVFWQTIvcW5GQnhldmt5cVQzTXRVdklFeUdBMnJYZi9ob1VI?=
 =?gb2312?B?YVNnb3pXZWJzd2c5by8waUw0elVzdGEzYXlOM2NqMlNTbThjenQxTXNFK1dp?=
 =?gb2312?B?MG1YMS84WVl0aDVFWmhPS0RRY3ZpeDI1YVFrdFZUa0xuMkdWVlgzUmJIa2Nx?=
 =?gb2312?B?WmdoQ2NoTERUMGd2NDhHaThsck85WWxrWEZjVkpJUE0yWU9mbXh3UnoyRS8x?=
 =?gb2312?B?U0FJR0cvTStzclo4WHlzMGJuMlBuOHNTeVEzR0RHTFdyTTVsV1FJV2RrNHBN?=
 =?gb2312?B?bHhPcGxpTktRbUR6eDNERllUMlpMSTVVWEw3eFNaS05LME9uT1hlTXVGRTln?=
 =?gb2312?B?MTA3ZUdXeVZ2SFdXZ2Z1Zlc5ekI1dEkzak42NlBlNW0wbDhLcnZNb3U4dmpY?=
 =?gb2312?B?cWJva21SWjU3Y3lxUzFndVBQQU9SNHBSRmhSY2NnbU5MZmg0V2pJZ2ptRUpX?=
 =?gb2312?B?S016NUJzSGNTUEFmdSs3bWcvUkNRSCtQdGVFMG53WVgrSURMbzhMb3ZLVDM2?=
 =?gb2312?B?YUhrYjJhOG5qbEZrUmpoeWVpeUNMMjMwYkEybjg3OHdhN0dsZkNjaURGMFR5?=
 =?gb2312?B?NEgvZWo3d2pPbWdEditxSGRySGUxci9jbTFiSnRVbGRGU3VPSnFIMWFSUVVl?=
 =?gb2312?B?Q0tJS3JsOUs1NitGRGt6NTVJVVkyaWRHdHBmSjJVUGJBQVN4c2dDcGM2Snht?=
 =?gb2312?B?R1hFWGJTNm1oNFd4OEZOR2RKVGh1NWQxd0dZY2s5cWZtOUpFUTE4YzdiQzd2?=
 =?gb2312?B?dUhtdGxDWFliTkw5VUJQakVscW1RZ3ZLSGU1SW5PbncvcjErQmxQK1cxalJr?=
 =?gb2312?B?MGk0dkdvc2RmcFFkZURGS3RUZ2x4ZUN5MDA3U2dZSzgwRzZHSU9NUjM0Yktr?=
 =?gb2312?B?eHVCNDg2ODRLcVNScVN0Ny9zYXRmT290YksrT21lSXJCeUVkbllZaVZ1Qk50?=
 =?gb2312?B?djhsVytpaG4ybWdWcG1MVnJ5aVFPVWxobjVuUnFaZHpMenVSUU9oSUhtbEE5?=
 =?gb2312?B?cnduNVRpSGZNcCs2UXp0eXF6QmFSRWkyMUZpcUlZWG1yQVZYYW1LVmZkZEVi?=
 =?gb2312?B?UzRPbHFFQnNxRDVhdk9NSHVubnVqOVVSdElXdlFpY1pFVGYyZWV3VFc1cE5F?=
 =?gb2312?B?TGpFMEJVRmVhTllDZWMrbVJDRlBFRWNOdEpxbi9YeHhwdSsxT1M2cjhxN0NS?=
 =?gb2312?B?MGJtTG9SbkdORXVXRkgvSXdmaTVQVHEreU8yUEh0bTI3M1o2eFEvVXZjc2k0?=
 =?gb2312?B?U1U1TEpiemUwUG9YZ2dMYTNtTitjdmpDSldOMXF5YnRFaVRabEc2RVRsT2RY?=
 =?gb2312?B?VkF4em5URWVJSFh6RDJSQjZFMzd5T3UwRGxlbGlJeWlKbG1Bcmo2T3NIZ1ZF?=
 =?gb2312?B?ejhwS2V6TXdKOVB1emVaNUY5NG9zZFpmbWcyWkVrOWNTSklTNlZxZktaQmdL?=
 =?gb2312?B?RWZ2OHJTekQvaXp6R3hrb3NCTUpHbVU5ZG1IdXAxUElIdlpDN2FqcHYwWGRP?=
 =?gb2312?B?ZmNkRmUyNCtVanFIWW1MTEJwZEFsekJFM0VMNlV4aWtLTkhsdnRSK0o4WjFS?=
 =?gb2312?B?dXBYSGVZc1FlZWNLM2lXQ05zYWlUSSsyeDhvemxxSXd6Y3ZZcldqRldWMGZG?=
 =?gb2312?B?N2c9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 117179f3-1231-478b-936d-08d9bea76c47
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 02:14:13.1533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eqLl9/x62zbWT0yUWGrYagH9skrzyF8E1RtzDusHLOSH6y0pPxSjCzROmonsR2BFRQfq5ddOmy3BfxVgLu7nDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3243
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cj4+IEZyb206IFdhbmcgUWluZyA8d2FuZ3FpbmdAdml2by5jb20+Cj4+IAo+PiBGaXggZm9sbG93
aW5nIGNvY2NpY2hlY2sgd2FybmluZzoKPj4gV0FSTklORzogRnVuY3Rpb24gImZvcl9lYWNoX2F2
YWlsYWJsZV9jaGlsZF9vZl9ub2RlIiAKPj4gc2hvdWxkIGhhdmUgb2Zfbm9kZV9wdXQoKSBiZWZv
cmUgcmV0dXJuLgo+PiAKPj4gRWFybHkgZXhpdHMgZnJvbSBmb3JfZWFjaF9hdmFpbGFibGVfY2hp
bGRfb2Zfbm9kZSBzaG91bGQgZGVjcmVtZW50IHRoZQo+PiBub2RlIHJlZmVyZW5jZSBjb3VudGVy
Lgo+Cj5Nb3N0ICpkZWZpbml0ZWx5KiBOQUsuIENvY2NpY2hlY2sgaXMgbW9zdCBkZWZpbml0ZWx5
IHdyb25nIG9uIHRoaXMgb25lLAo+YW5kIHdlIHdpbGwgcHJvYmFibHkgbmVlZCBzb21lIHdheSB0
byB0ZWxsIHBlb3BsZSBub3QgdG8gYmVsaWV2ZQo+Y29jY2ljaGVjayBvbiB0aGlzLgo+Cj5JbiB0
aGlzIHBhdGgsIHRoZSBEVCBub2RlIGlzIGFzc2lnbmVkIHRvIGEgc3RydWN0IGRldmljZS4gVGhp
cyBfbXVzdF8KPmJlIHJlZmVyZW5jZSBjb3VudGVkLiBkZXZpY2Vfc2V0X25vZGUoKSBkb2VzIG5v
dCBpbmNyZW1lbnQgdGhlCj5yZWZlcmVuY2UgY291bnQsIG5vciBkb2VzIG9mX2Z3bm9kZV9oYW5k
bGUoKS4gVGhlIHJlZmVyZW5jZSBjb3VudAo+aGVyZSBpcyBwYXNzZWQgZnJvbSB0aGlzIGNvZGUg
b3ZlciB0byB0aGUgc3RydWN0IGRldmljZS4KPgo+QWRkaW5nIGFuIG9mX25vZGVfcHV0KCkgd2ls
bCBicmVhayB0aGlzLgo+Cj5UaGlzIG11c3QgX25ldmVyXyBiZSAiZml4ZWQiIG5vIG1hdHRlciBo
b3cgbXVjaCBjb2NjaWNoZWNrIGNvbXBsYWlucywKPmFzIGZpeGluZyB0aGUgd2FybmluZyBfd2ls
bF8gaW50cm9kdWNlIGEgcmVmY291bnRpbmcgYnVnLgo+Cj5JJ2xsIHNlbmQgYSBwYXRjaCBhZGRp
bmcgYSBjb21tZW50IHRvIHRoaXMgZWZmZWN0Lgo+Cj5UaGFua3MuCgpZZXMsIHlvdSBhcmUgcmln
aHQuIE1heWJlIHdlIGNhbiBhZGQgYSBqdWRnbWVudCBpbiB0aGlzIGNvY2NpIG9uIHdoaWNoIGV4
aXQgYXMgZXhwZWN0ZWQgCm9yIGFibm9ybWFsbHksIG9ubHkgdGhlIGxhdHRlciBuZWVkcyB0byBi
ZSByZXBvcnRlZC4KClRoYW5rcywKUWluZwo+Cj4tLSAKPlJNSydzIFBhdGNoIHN5c3RlbTogaHR0
cHM6Ly93d3cuYXJtbGludXgub3JnLnVrL2RldmVsb3Blci9wYXRjaGVzLwo+RlRUUCBpcyBoZXJl
ISA0ME1icHMgZG93biAxME1icHMgdXAuIERlY2VudCBjb25uZWN0aXZpdHkgYXQgbGFzdCE=
