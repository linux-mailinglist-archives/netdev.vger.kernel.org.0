Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6B21088
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 00:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfEPWdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 18:33:21 -0400
Received: from alln-iport-3.cisco.com ([173.37.142.90]:49967 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfEPWdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 18:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2706; q=dns/txt; s=iport;
  t=1558045999; x=1559255599;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z7LebGJsPnYpWy/gR9XMGSu5NumicmBU891SEomATj4=;
  b=AD5L8D+7Gx49XwsXNW3fZINOu+zsH3GOjkln//TFpvqywIWT4rNrFrcr
   F6H8TU+F8Hf3dMc5IfmvE+Uuaje3NQYmrOxcyVUkckmlGCqUdot1IZeQc
   H/RtSMvZyE8P6VmsJMSAROijvolEEgzABYYPrG7+eQ8NhMbQbocQDsIoB
   4=;
IronPort-PHdr: =?us-ascii?q?9a23=3AwvhLNRHDyS5vFtofXYWIf51GYnJ96bzpIg4Y7I?=
 =?us-ascii?q?YmgLtSc6Oluo7vJ1Hb+e4w3A3SRYuO7fVChqKWqK3mVWEaqbe5+HEZON0pNV?=
 =?us-ascii?q?cejNkO2QkpAcqLE0r+efjpYigzNM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0ANAAC55N1c/4MNJK1kGgEBAQEBAgE?=
 =?us-ascii?q?BAQEHAgEBAQGBUgQBAQEBCwGBPVADgT4gBAsohBGDRwOOdIJXiUCNZ4EugSQ?=
 =?us-ascii?q?DVAkBAQEMAQEtAgEBgUuCdQIXghcjNQgOAQMBAQQBAQIBBG0cDIVLAQEEEhE?=
 =?us-ascii?q?RDAEBNwEPAgEIDgoCAiYCAgIfERUQAgQBDQUbB4MAgWsDHQECoGICgTWIX3G?=
 =?us-ascii?q?BL4J5AQEFhQUNC4IPCRR3KAGLTxeBQD+BOB+CTD6CGoIqgwoygiaNQSyZYjk?=
 =?us-ascii?q?JAoIJjxaDVxuWCYxFiDiMcwIEAgQFAg4BAQWBUQMzgVdwFWUBgkGCD4NvilN?=
 =?us-ascii?q?yAYEoi2krgiUBAQ?=
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="277907918"
Received: from alln-core-1.cisco.com ([173.36.13.131])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 May 2019 22:33:19 +0000
Received: from XCH-RCD-006.cisco.com (xch-rcd-006.cisco.com [173.37.102.16])
        by alln-core-1.cisco.com (8.15.2/8.15.2) with ESMTPS id x4GMXIdm030427
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 22:33:19 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-RCD-006.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 17:33:18 -0500
Received: from xhs-rcd-002.cisco.com (173.37.227.247) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 17:33:17 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-002.cisco.com (173.37.227.247) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 16 May 2019 17:33:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector1-cisco-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7LebGJsPnYpWy/gR9XMGSu5NumicmBU891SEomATj4=;
 b=cae1X6dmAJk5qLR/MaoIEDaeVbi150XEZMmR4thEFo4mrV+b7qDhPfeClKLTK9gzaZmIiLxXHqPE1De5Oy07aKN++5MZjYW0RWnKw4gg5oAIj17kBYG2apxa27svS6t5V44biPe2HQFLUlNEmg7+wxI583txr7KxLPnLOfpIraQ=
Received: from BYAPR11MB2744.namprd11.prod.outlook.com (52.135.228.10) by
 BYAPR11MB3448.namprd11.prod.outlook.com (20.177.186.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.26; Thu, 16 May 2019 22:33:15 +0000
Received: from BYAPR11MB2744.namprd11.prod.outlook.com
 ([fe80::e43c:3a2a:b70b:beaf]) by BYAPR11MB2744.namprd11.prod.outlook.com
 ([fe80::e43c:3a2a:b70b:beaf%5]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 22:33:15 +0000
From:   "Nikunj Kela (nkela)" <nkela@cisco.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
CC:     "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
Thread-Topic: [PATCH] igb: add parameter to ignore nvm checksum validation
Thread-Index: AQHVBfPQmilbvj7AIk6HX7/hQr0aSqZuMR+AgAAFiICAACN/AIAACKaA
Date:   Thu, 16 May 2019 22:33:15 +0000
Message-ID: <F028ADDC-EA02-46C3-AC7A-A1A6606BC3F5@cisco.com>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
 <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
In-Reply-To: <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nkela@cisco.com; 
x-originating-ip: [2001:420:30a:4d04:34de:1b8a:9315:481d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdea4004-a1f7-4662-fb07-08d6da4e7cea
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR11MB3448;
x-ms-traffictypediagnostic: BYAPR11MB3448:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB344831EB028C07682F7790B1AD0A0@BYAPR11MB3448.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(376002)(39860400002)(366004)(199004)(189003)(86362001)(186003)(446003)(6506007)(8936002)(6246003)(11346002)(102836004)(7736002)(14454004)(2501003)(2906002)(4326008)(46003)(68736007)(478600001)(316002)(76176011)(305945005)(5660300002)(229853002)(66556008)(66946007)(76116006)(73956011)(66446008)(64756008)(66476007)(71200400001)(83716004)(71190400001)(6512007)(6436002)(6486002)(6116002)(25786009)(36756003)(33656002)(54906003)(256004)(81156014)(82746002)(2616005)(110136005)(81166006)(53546011)(99286004)(476003)(486006)(53936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3448;H:BYAPR11MB2744.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 88vJQG/TBJlVTDkrwecfPbbQjK/PjKHkkLw1B4GXXsxbMY5IYOSBk1haVRk80U6h0y+j82KbGNMdFMuyKYFDbQo3nis0pW8ZVRFN/Jts0kwPjWGxARzbrcMM8Fq3eerrYhJk8lXKKzP0KjB+P59Ub7edkOIGqfq5cjlFEOW+7Tf7qtaPx/j998OQGLeFCdL+8wzHxW7cvAW/Pftv03u7NDRfaEVRjROJK+AK4R39x2uilBgYjMBx4r8iDVNZrc3AMpbIDoh/mnA9qrfg81Z3tTmYW01B5Q1RceJKBgkDsl2tYugJh8Sar3ifIzoL4+rPxbQUYdfrEQZ/F8s7cYrvO+gblD9yI6mMSZ5ESzAp2fZECcWXkhKSACgWfWu8eotMSeibQbCnVD3hnGyRVwQtrePNfYoRDzvVw1EOkDRMgkY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1FB4C5C63BF63408351084027178CDA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fdea4004-a1f7-4662-fb07-08d6da4e7cea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 22:33:15.5993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3448
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xch-rcd-006.cisco.com
X-Outbound-Node: alln-core-1.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMTYvMTksIDM6MDIgUE0sICJGbG9yaWFuIEZhaW5lbGxpIiA8Zi5mYWluZWxsaUBn
bWFpbC5jb20+IHdyb3RlOg0KDQogICAgT24gNS8xNi8xOSAxMjo1NSBQTSwgTmlrdW5qIEtlbGEg
KG5rZWxhKSB3cm90ZToNCiAgICA+PiANCiAgICA+PiANCiAgICA+PiBPbiA1LzE2LzE5LCAxMjoz
NSBQTSwgIkplZmYgS2lyc2hlciIgPGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT4gd3JvdGU6
DQogICAgPj4gDQogICAgPj4gICAgIE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAyMzoxNCArMDAwMCwg
TmlrdW5qIEtlbGEgd3JvdGU6DQogICAgPj4gICAgPj4gU29tZSBvZiB0aGUgYnJva2VuIE5JQ3Mg
ZG9uJ3QgaGF2ZSBFRVBST00gcHJvZ3JhbW1lZCBjb3JyZWN0bHkuIEl0DQogICAgPj4gICAgPj4g
cmVzdWx0cw0KICAgID4+ICAgID4+IGluIHByb2JlIHRvIGZhaWwuIFRoaXMgY2hhbmdlIGFkZHMg
YSBtb2R1bGUgcGFyYW1ldGVyIHRoYXQgY2FuIGJlDQogICAgPj4gICAgPj4gdXNlZCB0bw0KICAg
ID4+ICAgID4+IGlnbm9yZSBudm0gY2hlY2tzdW0gdmFsaWRhdGlvbi4NCiAgICA+PiAgICA+PiAN
CiAgICA+PiAgICA+PiBDYzogeGUtbGludXgtZXh0ZXJuYWxAY2lzY28uY29tDQogICAgPj4gICAg
Pj4gU2lnbmVkLW9mZi1ieTogTmlrdW5qIEtlbGEgPG5rZWxhQGNpc2NvLmNvbT4NCiAgICA+PiAg
ICA+PiAtLS0NCiAgICA+PiAgICA+PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2ln
Yl9tYWluLmMgfCAyOA0KICAgID4+ICAgID4+ICsrKysrKysrKysrKysrKysrKysrKystLS0tLS0N
CiAgICA+PiAgICA+PiAgMSBmaWxlIGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDYgZGVsZXRp
b25zKC0pDQogICAgPj4gICAgIA0KICAgID4+ICAgICA+TkFLIGZvciB0d28gcmVhc29ucy4gIEZp
cnN0LCBtb2R1bGUgcGFyYW1ldGVycyBhcmUgbm90IGRlc2lyYWJsZQ0KICAgID4+ICAgICA+YmVj
YXVzZSB0aGVpciBpbmRpdmlkdWFsIHRvIG9uZSBkcml2ZXIgYW5kIGEgZ2xvYmFsIHNvbHV0aW9u
IHNob3VsZCBiZQ0KICAgID4+ICAgICA+Zm91bmQgc28gdGhhdCBhbGwgbmV0d29ya2luZyBkZXZp
Y2UgZHJpdmVycyBjYW4gdXNlIHRoZSBzb2x1dGlvbi4gIFRoaXMNCiAgICA+PiAgICAgPndpbGwg
a2VlcCB0aGUgaW50ZXJmYWNlIHRvIGNoYW5nZS9zZXR1cC9tb2RpZnkgbmV0d29ya2luZyBkcml2
ZXJzDQogICAgPj4gICAgID5jb25zaXN0ZW50IGZvciBhbGwgZHJpdmVycy4NCiAgICA+PiANCiAg
ICA+PiAgICAgDQogICAgPj4gICAgID5TZWNvbmQgYW5kIG1vcmUgaW1wb3J0YW50bHksIGlmIHlv
dXIgTklDIGlzIGJyb2tlbiwgZml4IGl0LiAgRG8gbm90IHRyeQ0KICAgID4+ICAgICA+YW5kIGNy
ZWF0ZSBhIHNvZnR3YXJlIHdvcmthcm91bmQgc28gdGhhdCB5b3UgY2FuIGNvbnRpbnVlIHRvIHVz
ZSBhDQogICAgPj4gICAgID5icm9rZW4gTklDLiAgVGhlcmUgYXJlIG1ldGhvZHMvdG9vbHMgYXZh
aWxhYmxlIHRvIHByb3Blcmx5IHJlcHJvZ3JhbQ0KICAgID4+ICAgICA+dGhlIEVFUFJPTSBvbiBh
IE5JQywgd2hpY2ggaXMgdGhlIHJpZ2h0IHNvbHV0aW9uIGZvciB5b3VyIGlzc3VlLg0KICAgID4+
IA0KICAgID4+IEkgYW0gcHJvcG9zaW5nIHRoaXMgYXMgYSBkZWJ1ZyBwYXJhbWV0ZXIuIE9idmlv
dXNseSwgd2UgbmVlZCB0byBmaXggRUVQUk9NIGJ1dCB0aGlzIGhlbHBzIHVzIGNvbnRpbnVpbmcg
dGhlIGRldmVsb3BtZW50IHdoaWxlIG1hbnVmYWN0dXJpbmcgZml4ZXMgTklDLg0KICAgIA0KICAg
ID5UaGVuIHdoeSBldmVuIGJvdGhlciB3aXRoIHNlbmRpbmcgdGhpcyB1cHN0cmVhbT8NCiAgICA+
LS0gDQogICAgPkZsb3JpYW4NCg0KTXkgY29sbGVhZ3VlcyB3YW50ZWQgbWUgdG8gdXBzdHJlYW0g
c28gaWYgdGhlcmUgaXMgYW55b25lIGVsc2UgaW4gdGhlIHNhbWUgc2l0dWF0aW9ucywgbWF5YmUg
dGhlcmUgaXMgYSBiZXR0ZXIgc29sdXRpb24uIA0KICAgIA0KDQo=
