Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F378348A18
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhCYHZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:25:26 -0400
Received: from mail-db8eur05on2125.outbound.protection.outlook.com ([40.107.20.125]:45573
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229869AbhCYHZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 03:25:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XS+aQwAxIMvgYG/+KTcfFPVITK/52znT3RBqGjE+TsBOqdWYOP8wRXyN4Zwmyg0q+w2EN7h/aesqfouyosggt8HTf66bp9coVGDqXWaLlk56MSSAshCb0qxTGk9UL4DCFD31x8JCVAjgE1f2lSSIZ4z6dYVFDGrNHcNVSg3LsphgQYLxxspzNVLe5IScj5WBULV6OepubmPTeFXuya9B9wzyXv85WIrT6IEce2BAM3mtJ8QTa+DDIC1ipuVxj9KXHsEJRDioEatzh8hxIGCVa08qk89X0kWeDe5VHhpTJWVjpBAwfP3eEitr6gNFokh2bc8KsiT1Zuk/RSfFnKIgNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3PGFP4w5xym8UsNPOzW0beOZMiuEb0Hv5EBEtVpwvA=;
 b=PvzkxD3trk4BKDa+NDA81QRL2Zq9t9D7XzctA+CplrBJ7Ptj7RHXjw7Y3a7TG2Fw/b92s0T73Zeyra2sugtsEii9KVhbafO2oP/HSs5uwSz6A42jN4ETbPVBp5F+seCRSt04+zG1Z2zs21AImgbcoRlXoAe9OuS8GaLbJp4/IRYCwlEaFyCq4EBXin5RBrBUTxn5rTGJMOrSqXwb61BYIiLQb55Yu8P2zVHzWMNetCxwmAEZzEFolWpwui+bMC8wLfLz9FY+AeARbi4SpA0waQM/gR1vh64Wo+UYGTWbrj0Y97Mpi8QC5gmLPsG9xHziPEDm4wnjtOnPjsCzl5R07Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3PGFP4w5xym8UsNPOzW0beOZMiuEb0Hv5EBEtVpwvA=;
 b=mKCbT6vFeGO4SOCxvV7Fzvl2MBEiqunoQFYYdoBrFpJ9CXLjsGTebjJZexMOoW5IUBOicZeGNgpFzoIJuM8PwLfyTpW7bZu5cFAJHdkvCV18fwxjEuC9OwuY4u3rKpXUKdqYT32xcUPkNq+1k8xWXYzRNhNpjUZNbS+hdtdAUbQ=
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.4.149) by
 VI1PR05MB6256.eurprd05.prod.outlook.com (20.178.204.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.23; Thu, 25 Mar 2021 07:25:19 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%6]) with mapi id 15.20.3955.024; Thu, 25 Mar 2021
 07:25:19 +0000
From:   Hoang Huu Le <hoang.h.le@dektech.com.au>
To:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        Tuan Anh Vo <tuan.a.vo@dektech.com.au>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Subject: RE: [iproute2-next] tipc: add support for the netlink extack
Thread-Topic: [iproute2-next] tipc: add support for the netlink extack
Thread-Index: AQHXIRov6U90Cs3egEScaXpSHw/M26qUBdMAgABG9MA=
Date:   Thu, 25 Mar 2021 07:25:15 +0000
Message-ID: <VI1PR05MB4605C7C623F4C55569953206F1629@VI1PR05MB4605.eurprd05.prod.outlook.com>
References: <20210325015653.7112-1-hoang.h.le@dektech.com.au>
 <ec0824c4-1809-b934-e1ec-abe08e5b4f6e@gmail.com>
In-Reply-To: <ec0824c4-1809-b934-e1ec-abe08e5b4f6e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=dektech.com.au;
x-originating-ip: [14.161.14.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f301ecb3-4f61-4ad3-7d8f-08d8ef5f252b
x-ms-traffictypediagnostic: VI1PR05MB6256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6256E1ED638DA7E1AF64EC10F1629@VI1PR05MB6256.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:311;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ai6hf3jh0eUPgjKAVAzaZD0GCAzwYONlyLAH2atZ5zoFZTP60UP7vQYazZd0OICyLAjrcL5vXQSxCXW3nS9zfxUO+g8XWJmmLuWCfFrfLNyEF5nWDR+uJLabUdpTJ70UYDUhLNBIePlYeZUHROhLKU3KBZU4Pp3azNA5Pxbj4VQxxm38ZcAsENDkNC+2a0YcXMDEUx9iSWcZPl1//hbrqtLJN6SiQ5Ne9yk1mNl0V7UuyNAFhOtWSitQDqzGiyg55J6MXzuUkYaSlxd1VOJxU2JeA+enD2gqTWq4TRL+OqfQh/58D/IJr3F+s9Ht6GJg/x7clPjxyOCYyk9laE1HQzSQRXUYfmbh2Y8D12sbM9NIGxDExaZxHM0+OrE0Anlf+0XiueJvBbcRA+pg1vxA4805LXvGuQSbMOYXyQUDGZ1ip6/s0RcI0d+QXVmNt7TFijulwvdBw6A5pet5pi0JEWL99Wg0nhbfstgRV21VUr2+ZH6Gi7ShuGyFGqWkpj07qssyuIxic6anZSgpbv+CXtN4CjFho8kEFXVMMZB/LHPWhz/W9I1Gow+rZO5CqBXFnpk07u8vfpo7Grmh8dv4qtxhpU6zsBAIpKnLbcg252hpOnlRbBOLAYziLXX1NhXSyjT+1YkiLWgClcjH6f9zXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39840400004)(136003)(396003)(366004)(66446008)(8936002)(110136005)(66556008)(66946007)(64756008)(8676002)(478600001)(6506007)(6636002)(76116006)(38100700001)(9686003)(4744005)(53546011)(5660300002)(6666004)(7696005)(55016002)(71200400001)(316002)(33656002)(83380400001)(86362001)(2906002)(66476007)(52536014)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZlNseGRHUnErZ0VjVXBURmtrblRPVHhTVFE5cG5CYjJYY0Q4d3J3MDY5ZU83?=
 =?utf-8?B?TUpNSGJ0ejNDZEF4SGNrbklZNWdkZDhldXFrYlNpN0VJMFBEdjhyWEpmUFA5?=
 =?utf-8?B?RWtjS1R3Z3RnNUd1MUY4RlZ3dzcyK1lmcllZQ05SeWJXQSt5em1MZXJ1QzU2?=
 =?utf-8?B?YUJ0NmRiT01QbVdtVWNUTEFLVDAzaEdldlJlZEoxOGgrNlBmVFgwU2dnb3NU?=
 =?utf-8?B?Wk1Ua2JyeGJLdUhleld6SXhFYWNjdWFjSWgwQWxGTkQxZWpyajI5ODM1SHFM?=
 =?utf-8?B?QU56Nk1Gc3JWSWIzZFdDL3pzNEtJVmh2SGpJQXNCMVMxc2hVc2lvbitGRzBG?=
 =?utf-8?B?TllvSFJjZllzODVic1I1Tng4eXBPSnZQMWE5SnVZUkQ2U0dFekVUWVY0SEwr?=
 =?utf-8?B?NUd5aUppSGpRTytlb3VNL3VqMVJXY0tyQjVCSXpVelJlYnZDdmoyMC8rSlVt?=
 =?utf-8?B?Tmh0MlczUGFDVnJUQ0ZnaWlUa0hCZm9HcEdSdFE5UnJ5NVBhU0ljNFBGdG5P?=
 =?utf-8?B?cEdPNW80TnR5cWtiWEZ6dHV1MnhYNUlLUGxmRmdPOW5ielFhQVVnU1Z3WFpQ?=
 =?utf-8?B?VlFtcnJxU1ZSUm1vSGd6ZmVRbHFNQ3g3cFNaQWlyWEM3ME9DRVJnRGRZZ210?=
 =?utf-8?B?UUF2dkdqRDAyV25qaEh0NXpwd3lrTm13UHJoU3Z4UmVEYUtkTTg4eWVRMmUw?=
 =?utf-8?B?b1h3a2JlOVdSbFJMR25ZSnFaMUZsZWhnMzBYbS9sNUw5VHBjVS93UFBiMkFF?=
 =?utf-8?B?aVJiclk5alRYVWIvWlptM3ZBaXROUFJrVnhhbUQ4ekU5YVBUSlhqaXhVM2ND?=
 =?utf-8?B?VVlvblUxdlNYZU1aZVZINm82RUg5U3FOWkZGa2dXRGoyMm0zS0RtSW1jNTBE?=
 =?utf-8?B?MEFXbGxjdG4ydmRCRXlLc1R3b3cxM0NSNTI0NjRZZ0hBSFl1R1F2LzRHVVd1?=
 =?utf-8?B?ZXlQQytmeExiSTlldmpYdXhwcjJWT1ZKcVBobW1vT3hXOXZJaXF0NGNSZzlT?=
 =?utf-8?B?ak5uUzhockh0bk83OHNRKzhiNDkxc1d0WUZHSXBqOXAxaHp2TDJRMTBFeWRT?=
 =?utf-8?B?dS81Zk1Ca2F2c05yYmM5alhrS1lQR1NiSTRpY1dJWFc3WXM5eEtRb2Zqa01u?=
 =?utf-8?B?QTJ3QldBb2JYQ2lrTzNLSmlUaGQ2UGNWWG9kUXFnMWhrWitqK1BWWStGWkFh?=
 =?utf-8?B?RnJEUldiMi9ORlBqRzVRVldia2t2MlRvRHRmNkp1enUvSHB1NVBRY1B4R3ZU?=
 =?utf-8?B?ZlZaN3p0eXlLb0s0Um14b3lZQzN5Z1lRRy9jVzNjQWFGWGY5UWRRM2V3alFR?=
 =?utf-8?B?WHV6WWVHd3h6NTVNK2tXNHpQaVZvQmFweGZSUE5aSyt0MEIvcGE1eTdIRkdu?=
 =?utf-8?B?VTMwYi93UnhoVVMrOWVYY0RBbldnNVY1VE9icEJxM2sxOGVJSFZVWkp6Tzhv?=
 =?utf-8?B?djIvNkd0UU5VVURONGlmekQwMmdTbC9lZEg2eE9FbjAwQVprN2gxRnZHeHRz?=
 =?utf-8?B?Y0JIUjFJckltQmx0T3BtRmxLMmV4ZStNZmkwYnU0UlExT05oYkJHUHJwOUtZ?=
 =?utf-8?B?QW5QWTVPUTB1UE5lRFZjQUxONm9PRVRMZU12aTh0bjY2REFQNWVYN0MrZWsw?=
 =?utf-8?B?cVhiK0ZTZGRyU3hiRFU1RjZUcXlJTk9DRk43MzhSVkJQcGJwb082NmlpYUFy?=
 =?utf-8?B?UzhrL3AwOVh4RnIzQlN0UmFqQmZCWTQ2bElzYkhuMmo3d3ZRaG1OMmc0S0Yr?=
 =?utf-8?Q?s3YwLvWQ2ZG1F7kroo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f301ecb3-4f61-4ad3-7d8f-08d8ef5f252b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 07:25:19.6114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UuAXDpbIMPwYz3cTQPjow0wfO1z3bU7xBUUPfHuxhcmaZo9CmlbPEs7XghwqOrHD/Sh06NR9ObB/66z1y7YTJSuPR5vbR3zOwpbmukuVWEg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVy
bkBnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAyNSwgMjAyMSAxMDowOCBBTQ0K
PiBUbzogSG9hbmcgSHV1IExlIDxob2FuZy5oLmxlQGRla3RlY2guY29tLmF1PjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3RzLnNvdXJjZWZvcmdlLm5ldDsNCj4g
am1hbG95QHJlZGhhdC5jb207IG1hbG95QGRvbmpvbm4uY29tOyB5aW5nLnh1ZUB3aW5kcml2ZXIu
Y29tOyBUdWFuIEFuaCBWbyA8dHVhbi5hLnZvQGRla3RlY2guY29tLmF1PjsgVHVuZyBRdWFuZw0K
PiBOZ3V5ZW4gPHR1bmcucS5uZ3V5ZW5AZGVrdGVjaC5jb20uYXU+DQo+IFN1YmplY3Q6IFJlOiBb
aXByb3V0ZTItbmV4dF0gdGlwYzogYWRkIHN1cHBvcnQgZm9yIHRoZSBuZXRsaW5rIGV4dGFjaw0K
PiANCj4gT24gMy8yNC8yMSA3OjU2IFBNLCBIb2FuZyBMZSB3cm90ZToNCj4gPiBBZGQgc3VwcG9y
dCBleHRhY2sgaW4gdGlwYyB0byBkdW1wIHRoZSBuZXRsaW5rIGV4dGFjayBlcnJvciBtZXNzYWdl
cw0KPiA+IChpLmUgLUVJTlZBTCkgc2VudCBmcm9tIGtlcm5lbC4NCj4gPg0KPiA+IEFja2VkLWJ5
OiBKb24gTWFsb3kgPGptYWxveUByZWRoYXQuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhvYW5n
IExlIDxob2FuZy5oLmxlQGRla3RlY2guY29tLmF1Pg0KPiA+IC0tLQ0KPiA+ICB0aXBjL21zZy5j
IHwgMjkgKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0NCj4gPiAgMSBmaWxlIGNoYW5nZWQs
IDIyIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4NCj4gDQo+IHRpcGMgc2hvdWxk
IGJlIGNvbnZlcnRlZCB0byB1c2UgdGhlIGxpYnJhcnkgZnVuY3Rpb25zIGluIGxpYi9tbmxfdXRp
bHMuYy4NCg0KSXQncyByZWFsbHkgYSBiaWcgY2hhbmdlLiBTbywgd2Ugd2lsbCBkbyBpbiBuZXh0
IGNvbW1pdC4NCg==
