Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5775A2A9B8C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 19:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgKFSFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 13:05:33 -0500
Received: from alln-iport-4.cisco.com ([173.37.142.91]:24937 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgKFSFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 13:05:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2666; q=dns/txt; s=iport;
  t=1604685930; x=1605895530;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=w+8RR1NLBjXb3gtaFOr4Owkp6c8iyDTmPXJCalq6/qE=;
  b=bXZQbETiZWr4CNC/0LQ1NAgQHFqvp7fr/+KWP5KyVumt6Q1i/J08WAl9
   /X3vudLysFFwtwhi4zpSc9TRHAL14UWpzUrTw2UbgfSSciQbN2nmZmpGh
   WzBPc7rFbufJABuO8j1VCwlmrZBWl8jXWFvWvZGOyHet+VOeO5LHaXA8+
   o=;
X-IPAS-Result: =?us-ascii?q?A0BoCwA7j6VffYENJK1iHQEBAQEJARIBBQUBQIFPgVJRg?=
 =?us-ascii?q?VMvLoQ9g0kDjSUumQGCUwNUCwEBAQ0BAS0CBAEBhEoCF4F4AiU4EwIDAQEBA?=
 =?us-ascii?q?wIDAQEBAQUBAQECAQYEFAEBhjwMhXMBAQEDEhEEDQwBATcBDwIBCA4KAgImA?=
 =?us-ascii?q?gICMBUQAgQNAQcBAR6DBIJWAy4BpHECgTuIaHZ/M4MEAQEFhQ8YghAJgQ4qg?=
 =?us-ascii?q?nKDc4ZXG4FBP4E4gms+hD4XgwCCX5MoPaRFCoJtmwEFBwMfoXC0FAIEAgQFA?=
 =?us-ascii?q?g4BAQWBayGBWXAVgyRQFwINjh83gzqKWHQ4AgYBCQEBAwl8jUwBAQ?=
IronPort-PHdr: =?us-ascii?q?9a23=3A2Omm1ROx8ldBmIjRKGIl6mtXPHoupqn0MwgJ65?=
 =?us-ascii?q?Eul7NJdOG58o//OFDEvKwz3lzER4PW77RDkeWF+6zjWGlV55GHvThCdZFXTB?=
 =?us-ascii?q?YKhI0QmBBoG8+KD0D3bZuIJyw3FchPThlpqne8N0UGG8vkYVDW5Hqo4m1aFh?=
 =?us-ascii?q?D2LwEgIOPzF8bbhNi20Obn/ZrVbk1IiTOxbKk0Ig+xqFDat9Idhs1pLaNixw?=
 =?us-ascii?q?=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.77,457,1596499200"; 
   d="scan'208";a="582939195"
Received: from alln-core-9.cisco.com ([173.36.13.129])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 06 Nov 2020 18:05:30 +0000
Received: from XCH-RCD-004.cisco.com (xch-rcd-004.cisco.com [173.37.102.14])
        by alln-core-9.cisco.com (8.15.2/8.15.2) with ESMTPS id 0A6I5TXX031531
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Fri, 6 Nov 2020 18:05:30 GMT
Received: from xhs-aln-002.cisco.com (173.37.135.119) by XCH-RCD-004.cisco.com
 (173.37.102.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Nov
 2020 12:05:29 -0600
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-002.cisco.com
 (173.37.135.119) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 6 Nov
 2020 12:05:28 -0600
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 6 Nov 2020 12:05:28 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJOQ5dVmIqnUfGmrCjDy6zmIqVbsXKesiJUz/SbrEdIy/w9uRI4WosxQChrhFo3VLHAuIUDayr6AKMDHpE6Sz2WAL+wCm5iCQ8hn9JX8iaZKrlHy4AcncPLNjir8J0ALz7d7MfG7cwj4SHONCbCRIzZmbmrUv83g6Cbtx7HzFiqp2oXQZqzlmFviqdo/hIwrS4/xPoRcIq5pO2+xurPICKoOVU0TQBAFgX8tP9RpN49CAepqyrp0NvyirzH0ey80zn1okD7Q85NBgSM0jkBbGviKUvT8uSZc/vtKolc7NeZn+8RrfKl5V+qi/h9KqlY4c7amf2+ZHCG94lIOpMUCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+8RR1NLBjXb3gtaFOr4Owkp6c8iyDTmPXJCalq6/qE=;
 b=NaKM/6pSGu+OSxyMavCat4n6ykAd/nZ/VVpbtHC73zX0+/LzPh8zCcCE+uLJ+Sp/8AIidSat5UXcoo/9IBwHDSKwVzM0etW7AuXXLYaFtc1O6cXg9s0CDNNv3UnxyfhEkz2AyDltAAXAmT94hvoXYCXvLfa5aw9KBo+2fZrJm6r/Lz1//owrOqDR4hvvN2tDQSQj6JsnxCUtWKISTsirp/QEqIpd9xaXw0h7XZHKDCrDsjxGjDDIb9CISCM1ywsoPb7x3/YrFUXbhc5zLDaMVdbpAFyulBbGluIeQhVFZHO2mhjzja6ELQRXUkUfc4DXU2nTJW8ssG0j3E8qwnoRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w+8RR1NLBjXb3gtaFOr4Owkp6c8iyDTmPXJCalq6/qE=;
 b=ztKejeE2W3PJOKGrlQ5qNu20LBBl2N7DqSGuudrKpNUXDCc5WxmgLqcSuCweY3oSTeFJiZK4KyYAAwGhimBHtLK6EJEuRyU3+TuxHekwcI9FGCbG1r4YhKEQxiTHIK87tSx1RBP4why5J5Q9i+VRdrancCGsb3T/+ReqYRds5xY=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by BL0PR11MB3204.namprd11.prod.outlook.com (2603:10b6:208:60::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 18:05:27 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::35e6:aaac:9100:c8d2%5]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 18:05:27 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>
Subject: Re: [PATCH net v2] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Topic: [PATCH net v2] ipv6/netfilter: Discard first fragment not
 including all headers
Thread-Index: AQHWtD3xtGc4Rv40RUiV27+UIhZqJam7U42AgAASvYA=
Date:   Fri, 6 Nov 2020 18:05:27 +0000
Message-ID: <e5b033cd-8de1-8fe6-5da9-e997a0570db1@cisco.com>
References: <20201106130803.12354-1-geokohma@cisco.com>
 <20201106085815.603de8d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201106085815.603de8d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1002::30e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b589b6a0-7880-4cbf-4a15-08d8827e8a8d
x-ms-traffictypediagnostic: BL0PR11MB3204:
x-microsoft-antispam-prvs: <BL0PR11MB32045F73D3172E716447CE64CDED0@BL0PR11MB3204.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cMPoKDq5pl8fsR44OWsaB6vLFSIKCDSbxAjxALkNxojjWGjhoIMi60djWr9gZ0b59OHiX8Xfkv1uk6yk6Pt/KPIwl7kmMUpNR4qUB59LZsqgHaz1UuDv1PkvcXaAX4zgkEbax/slyKYeSrQ19zi3MSDP2DkBLnE+zE3KCA8b8SoIGaqRzn48CyHTKtiXen5BFa42g9SPNnaBzPCP7/q1lpIrcDNXjlgUaLUrdVCMWkoFf6VnUFWuYPPEFlOaiUeTfMBrbrxRDzfUeJMKVWK2P313nw6FmuWm2LSpYvMJYe81i9/RkqxMowXo28Tn0bYD79SfTRZs0Ql2QKDKA5GPwB9GXzoB9Mb6YIrRkjcsr8SfI8cMUnpLB51+zFRboayi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(31686004)(71200400001)(186003)(7416002)(36756003)(4326008)(316002)(2616005)(31696002)(66476007)(66446008)(91956017)(64756008)(6506007)(6486002)(76116006)(8676002)(53546011)(8936002)(66946007)(478600001)(6916009)(6512007)(86362001)(66556008)(5660300002)(83380400001)(54906003)(2906002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dRjzyiduuWPk2kPAwLjD1GHbI9orGA+T74w6g4vqqnZI+WR9JVUONGHLC82pCzRgGl5a5AJhwVpPigb/SNoQNBVkfWwxcI5WP9M77pNo41hMZynFIuHzBEP30GRPnBC6abFNj4hXi0rbVAJrwd1iYdh6LFFXPThU3Q4046QsgB5D2h3vibH8bRMPB6yRsp9S1l6Bl2u6uUFZ8XKKq3mwQAvgxYwIv5/JeIG5YwPw9WM58oLMTN7UBEa9icQoY1txs7sc48Ge3DyrVPumYdMtY4hofGHELbdXDFIU27/NnPEXO5wie3gCoQ6hSQ86LKShpI4tZSLE5bfPu6wxcMmu5A1tWRZ3oMbu9kVuCVsWSRhdrTu7zoStkVuILreut2D2w+0mHn+mottYQovS6PEKqTvcoKlRfm5j0JGJjYOJlddKbqUXoljNGmDBDh8+YD/L29XZzNSmRtsm6YoPL666cw1N6zha8k7cYTFk6wRtPcSJYYBLH4pqxoBv+9Mopf8BwgDTg2t+dlBvCXtXTCtRgnc1vicdx3VvmAye8opV1nfjjgP4aKMshG9xJsmhRXoRQKjekKRNe3/dja0/j6Dbq2/EDbkLIWog8lYGiq2XhlA99AiMIuAJlYsVxxSTwxmD6wy90/L0iU/m0ulDDqArRn1QIq82d39RHl3UFHc3804=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <101030A735C9854BA62611CF925B183E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b589b6a0-7880-4cbf-4a15-08d8827e8a8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 18:05:27.3491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: moAuFJ5rh4qwNE6aWZ5LX9WIAPwa8Kui9JwVM4tWzdL8s7lK2UzNOOYcUyR1IlYc+UcuL8gPRBDBxMtJjrvD4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3204
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.14, xch-rcd-004.cisco.com
X-Outbound-Node: alln-core-9.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDYuMTEuMjAyMCAxNzo1OCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwgIDYg
Tm92IDIwMjAgMTQ6MDg6MDMgKzAxMDAgR2VvcmcgS29obWFubiB3cm90ZToNCj4+IGRpZmYgLS1n
aXQgYS9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMgYi9uZXQvaXB2Ni9yZWFzc2VtYmx5LmMNCj4+IGlu
ZGV4IGM4Y2YxYmIuLmU2MTczZjUgMTAwNjQ0DQo+PiAtLS0gYS9uZXQvaXB2Ni9yZWFzc2VtYmx5
LmMNCj4+ICsrKyBiL25ldC9pcHY2L3JlYXNzZW1ibHkuYw0KPj4gQEAgLTMyNSw3ICszMjUsNyBA
QCBzdGF0aWMgaW50IGlwdjZfZnJhZ19yY3Yoc3RydWN0IHNrX2J1ZmYgKnNrYikNCj4+ICAJY29u
c3Qgc3RydWN0IGlwdjZoZHIgKmhkciA9IGlwdjZfaGRyKHNrYik7DQo+PiAgCXN0cnVjdCBuZXQg
Km5ldCA9IGRldl9uZXQoc2tiX2RzdChza2IpLT5kZXYpOw0KPj4gIAlfX2JlMTYgZnJhZ19vZmY7
DQo+PiAtCWludCBpaWYsIG9mZnNldDsNCj4+ICsJaW50IGlpZjsNCj4+ICAJdTggbmV4dGhkcjsN
Cj4+ICANCj4+ICAJaWYgKElQNkNCKHNrYiktPmZsYWdzICYgSVA2U0tCX0ZSQUdNRU5URUQpDQo+
PiBAQCAtMzYyLDI0ICszNjIsMTEgQEAgc3RhdGljIGludCBpcHY2X2ZyYWdfcmN2KHN0cnVjdCBz
a19idWZmICpza2IpDQo+PiAgCSAqIHRoZSBzb3VyY2Ugb2YgdGhlIGZyYWdtZW50LCB3aXRoIHRo
ZSBQb2ludGVyIGZpZWxkIHNldCB0byB6ZXJvLg0KPj4gIAkgKi8NCj4+ICAJbmV4dGhkciA9IGhk
ci0+bmV4dGhkcjsNCj4+IC0Jb2Zmc2V0ID0gaXB2Nl9za2lwX2V4dGhkcihza2IsIHNrYl90cmFu
c3BvcnRfb2Zmc2V0KHNrYiksICZuZXh0aGRyLCAmZnJhZ19vZmYpOw0KPj4gLQlpZiAob2Zmc2V0
ID49IDApIHsNCj4+IC0JCS8qIENoZWNrIHNvbWUgY29tbW9uIHByb3RvY29scycgaGVhZGVyICov
DQo+PiAtCQlpZiAobmV4dGhkciA9PSBJUFBST1RPX1RDUCkNCj4+IC0JCQlvZmZzZXQgKz0gc2l6
ZW9mKHN0cnVjdCB0Y3BoZHIpOw0KPj4gLQkJZWxzZSBpZiAobmV4dGhkciA9PSBJUFBST1RPX1VE
UCkNCj4+IC0JCQlvZmZzZXQgKz0gc2l6ZW9mKHN0cnVjdCB1ZHBoZHIpOw0KPj4gLQkJZWxzZSBp
ZiAobmV4dGhkciA9PSBJUFBST1RPX0lDTVBWNikNCj4+IC0JCQlvZmZzZXQgKz0gc2l6ZW9mKHN0
cnVjdCBpY21wNmhkcik7DQo+PiAtCQllbHNlDQo+PiAtCQkJb2Zmc2V0ICs9IDE7DQo+PiAtDQo+
PiAtCQlpZiAoIShmcmFnX29mZiAmIGh0b25zKElQNl9PRkZTRVQpKSAmJiBvZmZzZXQgPiBza2It
Pmxlbikgew0KPj4gLQkJCV9fSVA2X0lOQ19TVEFUUyhuZXQsIF9faW42X2Rldl9nZXRfc2FmZWx5
KHNrYi0+ZGV2KSwNCj4+IC0JCQkJCUlQU1RBVFNfTUlCX0lOSERSRVJST1JTKTsNCj4+IC0JCQlp
Y21wdjZfcGFyYW1fcHJvYihza2IsIElDTVBWNl9IRFJfSU5DT01QLCAwKTsNCj4+IC0JCQlyZXR1
cm4gLTE7DQo+PiAtCQl9DQo+PiArCWlmICghaXB2Nl9mcmFnX3ZhbGlkYXRlKHNrYiwgc2tiX3Ry
YW5zcG9ydF9vZmZzZXQoc2tiKSwgJm5leHRoZHIpKSB7DQo+PiArCQlfX0lQNl9JTkNfU1RBVFMo
bmV0LCBfX2luNl9kZXZfZ2V0X3NhZmVseShza2ItPmRldiksDQo+PiArCQkJCUlQU1RBVFNfTUlC
X0lOSERSRVJST1JTKTsNCj4+ICsJCWljbXB2Nl9wYXJhbV9wcm9iKHNrYiwgSUNNUFY2X0hEUl9J
TkNPTVAsIDApOw0KPj4gKwkJcmV0dXJuIC0xOw0KPj4gIAl9DQo+IG5ldC9pcHY2L3JlYXNzZW1i
bHkuYzogSW4gZnVuY3Rpb24g4oCYaXB2Nl9mcmFnX3JjduKAmToNCj4gbmV0L2lwdjYvcmVhc3Nl
bWJseS5jOjMyNzo5OiB3YXJuaW5nOiB1bnVzZWQgdmFyaWFibGUg4oCYZnJhZ19vZmbigJkgWy1X
dW51c2VkLXZhcmlhYmxlXQ0KPiAgIDMyNyB8ICBfX2JlMTYgZnJhZ19vZmY7DQo+ICAgICAgIHwg
ICAgICAgICBefn5+fn5+fg0KVGhhbmtzIGZvciB0ZWxsaW5nIG1lLiBJIHdpbGwgZml4IGl0Lg0K
R2VvcmcNCg==
