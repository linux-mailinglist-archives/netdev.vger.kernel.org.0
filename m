Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88307298FD6
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781972AbgJZOtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:49:32 -0400
Received: from alln-iport-8.cisco.com ([173.37.142.95]:43133 "EHLO
        alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781957AbgJZOtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 10:49:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2808; q=dns/txt; s=iport;
  t=1603723770; x=1604933370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kJHdfAJvjSGalnXRigLh6gUfoFnGVSJrwQY9Qw8n/es=;
  b=gTJzKXVZAnMb1dpdhOexnQ54VeCfXZiVbYe3Y6pJoG3SVUcF/K6VfV11
   KHhoMp3nHvZVKF1QdttIi7l7Xqt3/kDXKuAtawoIbsRra1SX/x5STdold
   4bc08FoCeNJ/ly9T6aQ2rTizkhXiu6+X0KAvGuw0mYu4MIdr7mWpZEmsJ
   k=;
IronPort-PHdr: =?us-ascii?q?9a23=3A3/L4lxAwNfxZVDiMyninUyQJPHJ1sqjoPgMT9p?=
 =?us-ascii?q?ssgq5PdaLm5Zn5IUjD/qw00A3GWIza77RPjO+F+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGF8P3ZlmUqXq3vnYeHx?=
 =?us-ascii?q?zlPl9zIeL4UofZk8Ww0bW0/JveKwVFjTawe/V8NhKz+A7QrcIRx4BlL/U8?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BACABQ4JZf/4kNJK1gHAEBAQEBAQc?=
 =?us-ascii?q?BARIBAQQEAQFAgU+BUlEHgUkvLIQ8g0kDjRkIJph6glMDVQsBAQENAQEtAgQ?=
 =?us-ascii?q?BAYRKAheBdAIlOBMCAwEBCwEBBQEBAQIBBgRthWEMhXMBAQQSEQQNDAEBNwE?=
 =?us-ascii?q?PAgEIGAICJgICAjAVEAIEDQEHAQEegwSCTAMuAZwQAoE7iGh2fzODBAEBBYU?=
 =?us-ascii?q?OGIIQCYEOKoJyg3CGVxuBQT+BOAyCXT6EPReDAIJfkxgBPaI4gXwKgmqabQU?=
 =?us-ascii?q?HAx+hXrN1AgQCBAUCDgEBBYFrI4FXcBWDJFAXAg2OHzeDOopWdDgCBgoBAQM?=
 =?us-ascii?q?JfI1MAQE?=
X-IronPort-AV: E=Sophos;i="5.77,419,1596499200"; 
   d="scan'208";a="590441677"
Received: from alln-core-4.cisco.com ([173.36.13.137])
  by alln-iport-8.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 26 Oct 2020 14:49:29 +0000
Received: from XCH-ALN-001.cisco.com (xch-aln-001.cisco.com [173.36.7.11])
        by alln-core-4.cisco.com (8.15.2/8.15.2) with ESMTPS id 09QEnTvp012320
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 26 Oct 2020 14:49:29 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-001.cisco.com
 (173.36.7.11) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Oct
 2020 09:49:28 -0500
Received: from xhs-rcd-001.cisco.com (173.37.227.246) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 26 Oct
 2020 10:49:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-001.cisco.com (173.37.227.246) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 26 Oct 2020 09:49:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqSSnvF4ZX5P3SdDQ5GyN2vflSMf7tAKLxZt5+IX534zEm+PH5XNKXX0nKycR7AtCf4aDCmz/N1Xp00aX7pFijqT8ZnpMUUZXR8F+M+MMY88bwUOpSq3RyawdTxnD4eRvmsbCF6G3wciRkYp/UFJ1AfCCWb1S2CF6v/XMJbyDWD1BeWWp3sKLk+DmWELaZ1sLVaNMj/XC1u7NMmmftICw1EOv1zz+yjRIvutf3P5UgM/+pBcK/TiVAJacim826C07Ca31zR85rZo5xxwCkqrcY431tXBu9Btb2DW1zQvoREJW2nPYjh/B63ZsagF2UKVcBWCa+D8gSMOkJJLzb/c2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJHdfAJvjSGalnXRigLh6gUfoFnGVSJrwQY9Qw8n/es=;
 b=Pw24ALsKFesrWhkrk+6npFomu5+AinPgeZhI/WP8peD00tq6/yh2ekQ45nWoDy/fSAB2zzvZT/U7codIqAOhqjPMFEti+PtV/t34ESnts+f3qvLq516CjhehO9f+DGQ3of9I5eXvyGlNUPLZSAiYgwi9PqfmK8bX50kivj8XnqdzlUwTw+e/EgBVo3k5ifcKEVtPmAvwpvjhnGZWilo9r43ztjgdZqLLM5NGDTWxSRmQZ5pRCdJp0UOe4HtklPRLwHw/Qti5efBPjdeuOhJAWECs49nZc+7rLZq1UFJ6pkRqAWDN5/RUDF4tv13C43abtKmeWKrmDH9F4/92j/NnVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJHdfAJvjSGalnXRigLh6gUfoFnGVSJrwQY9Qw8n/es=;
 b=QRMhJmkk3/UUkbDxkrMxpmBbd0vk4F/JbRIger+JvR2D5MU/XauWyikWvGtrwUajDQTHmlVBvojOKfJ7Ben1+T6hC1+cfkWgMv4LJwRQbnAv6nkWvamc6p5H3mibzez4zZ5prImnLNtrDtzsga7vUP0/0RLAZAGhYLZQ2JF6+P4=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by MN2PR11MB4663.namprd11.prod.outlook.com (2603:10b6:208:26f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 14:49:25 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::f160:9a4f:bef6:c5ba%4]) with mapi id 15.20.3477.029; Mon, 26 Oct 2020
 14:49:25 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Topic: [PATCHv4 net 2/2] IPv6: reply ICMP error if the first fragment
 don't include all headers
Thread-Index: AQHWq2nfQzoTEclCX0OPTEyd7AzIoamph8kAgABP54CAAB/gAA==
Date:   Mon, 26 Oct 2020 14:49:25 +0000
Message-ID: <ec2d260d-2d83-772f-9430-fee0d9d21c59@cisco.com>
References: <20201023064347.206431-1-liuhangbin@gmail.com>
 <20201026072926.3663480-1-liuhangbin@gmail.com>
 <20201026072926.3663480-3-liuhangbin@gmail.com>
 <57fe774b-63bb-a270-4271-f1cb632a6423@cisco.com>
 <20201026125519.GO2531@dhcp-12-153.nay.redhat.com>
In-Reply-To: <20201026125519.GO2531@dhcp-12-153.nay.redhat.com>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1006::1a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 694b686c-90e0-408a-1b75-08d879be558c
x-ms-traffictypediagnostic: MN2PR11MB4663:
x-microsoft-antispam-prvs: <MN2PR11MB4663459607706438E1980DBECD190@MN2PR11MB4663.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gqXUpo8OuR/tDmGV6YrRlGRjYHLEntyq700xWwl5UGRDwbNWtB+UC4NTrVkY6g1kMbq4iMP0Bb97v7T3y0Ot+DhY/Kmkxw4rCyxOSUsZ/Kzg2EgCOgqqCnCxXRSXZ811JHWfgtiHo0wsqDClVeczwpb9ojTqEz9nGy24u9xCXTsvXYqaPojxjeIre/eEW6O/sNGtx6ZgucM7/1DAiZbwyBupr0cXSMzUNBJPCXq+um8mt6Iu93CmkOVrrPhahfCSazvAgxgTwMCIqqqzMI6Hsp7Gfg4gKRXvA4zkz0P+8bZlGHJdQ5PNyn5QcjXmy9YwRcx6dO0HoatfDRiI6GLrCAMcPPbT5ABoBY0yEsiU8wUznm6gGUaOUHH4ci8zgi/U
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(6512007)(8936002)(6486002)(2616005)(8676002)(6916009)(76116006)(36756003)(66476007)(71200400001)(66556008)(83380400001)(66446008)(91956017)(66946007)(5660300002)(64756008)(2906002)(86362001)(186003)(31686004)(478600001)(54906003)(6506007)(53546011)(31696002)(316002)(4326008)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0IK+pYK0jg46ZE6JuHOVuw+OxJnY+iAMovhoXCj4fh833rS7r5F6g/QkgYRqjz6JXHkzdk+qHca1IRYYPteor0BdUAp1fi0Zi1ueDmOM/dKQAUmqhLZ4H8RovtIaeB9hgHC0/iWWuKzVkRl40PxSZEWFwZLfzJxV4ZvezS5ZYNBSnXWrspUJhya8ZDw5A0sYdQIfCEfVo73ygkUPVjOHuRToC4g1w1Nh0Oowhn7tFPoBCA6heWd6jznvdK2wQDv3sIFYtJyPeT+GPW/2eZa5PIPjIMoCWLqgh3t0gRQ3w7bZ2dTaiAvaibkpuEd3bDYYedUK880s5owAN4E8ZrEP5RaYntdmeIQ1PX2ySx9VMOWdEDgFtlsKa2ibZ3qytTKbgl4pVSCLtAt2XsRdr8A58pk9nJWa9JbTu7KdXE1h+eD5d9pzN3GIDVH5o1ohEgqab5qr+XhjW+Ipfe8RMrscNL9wFe5XQoRxBd1TZU8wqwN6YnrbCp/tmfGS2BqSSgf1i0tiGKx0faUNhWOSgsR026/NlGwBr+aO/eSVoJfs+qwLA5jOcdFNnf3u1sziesZEUAWkQXy0r+ywYZJ2J46q3ZZkbhrVDjyRmzL00Q+C2SuVlm9rALexyCVtu3ZmR7j9hm2r+vW0Bwlrffq7Xvb2u1LC4kEczhXZf14mUNjdEV4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FF06EE2F850C443A0CD1DF21B87E696@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 694b686c-90e0-408a-1b75-08d879be558c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 14:49:25.7058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwZ+0AaRh83E3ckgsbN+Pw3b+X0cc6OzgNut5dxE7Xa8rukkZJcfTDZ6L+sUu6NRABrcpyVbTFZzN8HVdDdmgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4663
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.11, xch-aln-001.cisco.com
X-Outbound-Node: alln-core-4.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjYuMTAuMjAyMCAxMzo1NSwgSGFuZ2JpbiBMaXUgd3JvdGU6DQo+IE9uIE1vbiwgT2N0IDI2
LCAyMDIwIGF0IDA4OjA5OjIxQU0gKzAwMDAsIEdlb3JnIEtvaG1hbm4gKGdlb2tvaG1hKSB3cm90
ZToNCj4+PiArCW5leHRoZHIgPSBoZHItPm5leHRoZHI7DQo+Pj4gKwlvZmZzZXQgPSBpcHY2X3Nr
aXBfZXh0aGRyKHNrYiwgc2tiX3RyYW5zcG9ydF9vZmZzZXQoc2tiKSwgJm5leHRoZHIsICZmcmFn
X29mZik7DQo+Pj4gKwlpZiAob2Zmc2V0IDwgMCkNCj4+PiArCQlnb3RvIGZhaWxfaGRyOw0KPj4+
ICsNCj4+PiArCS8qIENoZWNrIHNvbWUgY29tbW9uIHByb3RvY29scycgaGVhZGVyICovDQo+Pj4g
KwlpZiAobmV4dGhkciA9PSBJUFBST1RPX1RDUCkNCj4+PiArCQlvZmZzZXQgKz0gc2l6ZW9mKHN0
cnVjdCB0Y3BoZHIpOw0KPj4+ICsJZWxzZSBpZiAobmV4dGhkciA9PSBJUFBST1RPX1VEUCkNCj4+
PiArCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB1ZHBoZHIpOw0KPj4+ICsJZWxzZSBpZiAobmV4
dGhkciA9PSBJUFBST1RPX0lDTVBWNikNCj4+PiArCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCBp
Y21wNmhkcik7DQo+Pj4gKwllbHNlDQo+Pj4gKwkJb2Zmc2V0ICs9IDE7DQo+PiBNYXliZSBhbHNv
IGNoZWNrIHRoZSBzcGVjaWFsIGNhc2UgSVBQUk9UT19OT05FPw0KPiBJUFBST1RPX05PTkUgZGVm
aW5lcyB0aGUgc2FtZSB3aXRoIE5FWFRIRFJfTk9ORS4gU28gaXB2Nl9za2lwX2V4dGhkcigpIHdp
bGwNCj4gcmV0dXJuIC0xLCBhbmQgd2Ugd2lsbCBnb3RvIGZhaWxfaGRyIGFuZCBzZW5kIElDTVAg
cGFyYW1ldGVyIGVycm9yIG1lc3NhZ2UuDQo+DQo+IFRoZSBxdWVzdGlvbiBpcyBpZiBpdCdzIE9L
IHRvIHJlcGx5IGEgSUNNUCBlcnJvciBmb3IgZnJhZ21lbnQgKyBJUFBST1RPX05PTkUNCj4gcGFj
a2V0PyBGb3IgcHVyZSBJUFBST1RPX05PTkUgbWVzc2FnZSwgd2Ugc2hvdWxkIGRyb3Agc2lsZW50
bHksIGJ1dCB3aGF0IGFib3V0DQo+IGZyYWdtZW50IG1lc3NhZ2U/DQpBY2NvcmRpbmcgdG8gUkZD
ODIwMCBzZWN0aW9uIDQuNzogIklmIHRoZSBQYXlsb2FkIExlbmd0aCBmaWVsZCBvZiB0aGUgSVB2
Ng0KDQpoZWFkZXIgaW5kaWNhdGVzIHRoZSBwcmVzZW5jZSBvZiBvY3RldHMgcGFzdCB0aGUgZW5k
IG9mIGEgaGVhZGVyIHdob3NlDQoNCk5leHQgSGVhZGVyIGZpZWxkIGNvbnRhaW5zIDU5LCB0aG9z
ZSBvY3RldHMgbXVzdCBiZSBpZ25vcmVkIGFuZCBwYXNzZWQNCg0Kb24gdW5jaGFuZ2VkIGlmIHRo
ZSBwYWNrZXQgaXMgZm9yd2FyZGVkLiIgSSBoYXZlIG5vdCBmb3VuZCBhbnkgUkZDDQoNCmRlc2Ny
aWJpbmcgZGlmZmVyZW50IGJlaGF2aW91ciBmb3IgZnJhZ21lbnRlZCBwYWNrZXRzLg0KDQo+DQo+
Pj4gKw0KPj4+ICsJaWYgKGZyYWdfb2ZmID09IGh0b25zKElQNl9NRikgJiYgb2Zmc2V0ID4gc2ti
LT5sZW4pIHsNCj4+PiArCQlfX0lQNl9JTkNfU1RBVFMobmV0LCBfX2luNl9kZXZfZ2V0X3NhZmVs
eShza2ItPmRldiksIElQU1RBVFNfTUlCX0lOSERSRVJST1JTKTsNCj4+PiArCQlpY21wdjZfcGFy
YW1fcHJvYihza2IsIElDTVBWNl9IRFJfSU5DT01QLCAwKTsNCj4+PiArCQlyZXR1cm4gLTE7DQo+
Pj4gKwl9DQo+Pj4gKw0KPj4+ICAJaWlmID0gc2tiLT5kZXYgPyBza2ItPmRldi0+aWZpbmRleCA6
IDA7DQo+Pj4gIAlmcSA9IGZxX2ZpbmQobmV0LCBmaGRyLT5pZGVudGlmaWNhdGlvbiwgaGRyLCBp
aWYpOw0KPj4+ICAJaWYgKGZxKSB7DQo+PiBBcmUgeW91IHBsYW5uaW5nIHRvIGFsc28gYWRkIHRo
aXMgZml4IGZvciB0aGUgZnJhZ21lbnRhdGlvbiBoYW5kbGluZyBpbiB0aGUgbmV0ZmlsdGVyPw0K
Pj4NCj4gSSBoYXZlIG5vIHBsYW4gdG8gZml4IHRoaXMgb24gbmV0ZmlsdGVyIGFzIG5ldGZpbHRl
ciBpcyBhIG1vZHVsZS4NCj4gSXQgbWF5IGhhdmUgZGlmZmVyZW50IGJlaGF2aW9yIGR1cmluZyBk
ZWZyYWdtZW50Lg0KPg0KPiBUaGFua3MNCj4gSGFuZ2Jpbg0KDQpJIG1pZ2h0IGhhdmUgYSBsb29r
IGF0IHRoZSBuZXRmaWx0ZXIgbXlzZWxmIHRoZW4uDQoNCg0KVGhhbmtzDQoNCkdlb3JnDQoNCg==
