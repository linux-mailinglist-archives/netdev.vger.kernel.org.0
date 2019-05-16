Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686FF20F66
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfEPTzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:55:23 -0400
Received: from alln-iport-2.cisco.com ([173.37.142.89]:11753 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEPTzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:55:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1942; q=dns/txt; s=iport;
  t=1558036521; x=1559246121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xwo9DXIib5kAvinw58nr377mdpB0gR/+fbltU9RiSIA=;
  b=Rs8yFEb9lkSTYHLxr4cWXa7nnfnRaJvaXtMA+gtVJQ17QksTx2AzZbCY
   zNMK1ywNEMR62c+TeD5DiDNjoPzc9/QseyHs+ZTrbrJFbUoZdyoVFBol/
   c4Z1r2+tvLB2FzKkkgc/XlZuURhfkOwkqRBC/Jt04S1AfFOGDK1kaqd/g
   o=;
IronPort-PHdr: =?us-ascii?q?9a23=3AeuaO5BIMJ6xZ6VcQItmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeCtad2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXEv4IfrjRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0A1AAAYv91c/5pdJa1kGwEBAQEDAQE?=
 =?us-ascii?q?BBwMBAQGBUgUBAQELAYE9UAOBPiAECyiEEYNHA451gleXJoEugSQDVAkBAQE?=
 =?us-ascii?q?MAQEtAgEBgUuCdQIXghcjNQgOAQMBAQQBAQIBBG0cAQuFSwEBAQMSEREMAQE?=
 =?us-ascii?q?3AQ8CAQgYAgImAgICMBUQAgQOBRsHgwCBawMdAQKhCwKBNYhfcYEvgnkBAQW?=
 =?us-ascii?q?FCRiCDwkUdygBi08XgUA/gTgfgkw+h04ygiaNQSyaGwkCggmSbRuWCYxFlSs?=
 =?us-ascii?q?CBAIEBQIOAQEFgVEDM4FXcBVlAYJBgg+Db4pTcgGBKIxXK4IlAQE?=
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="274498504"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by alln-iport-2.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 May 2019 19:55:21 +0000
Received: from XCH-RCD-012.cisco.com (xch-rcd-012.cisco.com [173.37.102.22])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id x4GJtKsf024193
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 16 May 2019 19:55:21 GMT
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by XCH-RCD-012.cisco.com
 (173.37.102.22) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 14:55:20 -0500
Received: from xhs-rtp-003.cisco.com (64.101.210.230) by xhs-rtp-003.cisco.com
 (64.101.210.230) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 May
 2019 15:55:18 -0400
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-003.cisco.com (64.101.210.230) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 16 May 2019 15:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwo9DXIib5kAvinw58nr377mdpB0gR/+fbltU9RiSIA=;
 b=YsELEVWv96Twer6zHi9MbfPkASXQsIS6wcg6RYOdHffhBIyglRluYDdCWWldt2zl+trAsB1bNAD1IpiTEPnBnW0Vgu1NQeU/X02jsV9WzmTUmcnlZfuJ1iqbmWl++F6Q/JzDf13NEU45UuH/bH2Td0YUCiXF1T+eB1m/ymYIs14=
Received: from BYAPR11MB2744.namprd11.prod.outlook.com (52.135.228.10) by
 BYAPR11MB2597.namprd11.prod.outlook.com (52.135.227.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 19:55:16 +0000
Received: from BYAPR11MB2744.namprd11.prod.outlook.com
 ([fe80::e43c:3a2a:b70b:beaf]) by BYAPR11MB2744.namprd11.prod.outlook.com
 ([fe80::e43c:3a2a:b70b:beaf%5]) with mapi id 15.20.1878.024; Thu, 16 May 2019
 19:55:16 +0000
From:   "Nikunj Kela (nkela)" <nkela@cisco.com>
To:     "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
CC:     "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
Thread-Topic: [PATCH] igb: add parameter to ignore nvm checksum validation
Thread-Index: AQHVBfPQmilbvj7AIk6HX7/hQr0aSqZuMR+AgAAFiIA=
Date:   Thu, 16 May 2019 19:55:16 +0000
Message-ID: <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
In-Reply-To: <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=nkela@cisco.com; 
x-originating-ip: [2001:420:30a:4d04:34de:1b8a:9315:481d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db673654-81ca-4dc4-8313-08d6da386b10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR11MB2597;
x-ms-traffictypediagnostic: BYAPR11MB2597:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB259710B29006285B182A7DC4AD0A0@BYAPR11MB2597.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(366004)(39860400002)(346002)(136003)(189003)(199004)(99286004)(305945005)(5640700003)(71200400001)(66476007)(66946007)(82746002)(33656002)(71190400001)(2501003)(66556008)(6246003)(64756008)(66446008)(229853002)(6436002)(54906003)(256004)(68736007)(73956011)(76116006)(53936002)(5660300002)(6486002)(83716004)(486006)(86362001)(6116002)(25786009)(14454004)(11346002)(102836004)(6506007)(186003)(53546011)(8676002)(8936002)(36756003)(446003)(81166006)(2616005)(81156014)(2906002)(478600001)(7736002)(4326008)(476003)(46003)(2351001)(316002)(76176011)(6512007)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB2597;H:BYAPR11MB2744.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NLSGwMJ0wjVm+KWStrw/IE1Wr0QT9kwy8sLFF4NP+0/doNf/7j4itFwBrPoz9/t/DMjpSmip45J4ZcjjMPHEIP4J37d18PRKcOkeEojn/R7WXjRCZyx7Nmrf+uGthzOv/ivWgNZ1r1iZe52QDhYGfPTN4df73LKdMWhvIqm7HR6BOlB5XovW3ZRMuwcE+nnYT5+v79VSWmZ17MlYezIqmu9v47zONDBFr+K2nHnRLE9a0oZGICcyTIN6ts0gf6visO0RWwwnzNHM7gpAD8Cf12FXYDEP0oc63HQLd2jklWJ5tqFmMe+eWhl8DsTcRMnvabrcwhJzfgsvLUyf/jqx8neLl4CnuNBYwioOU+hthVkXDRXqE24cIS5nd9GFuCGuGH2vPT1bdMAielvH3eRTNzfS2CRv04c9Q9iufupqxfg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <40643AC9A3943F4BA5A819F2B15AEFAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db673654-81ca-4dc4-8313-08d6da386b10
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 19:55:16.6253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2597
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.22, xch-rcd-012.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMTYvMTksIDEyOjM1IFBNLCAiSmVmZiBLaXJzaGVyIiA8amVmZnJleS50LmtpcnNo
ZXJAaW50ZWwuY29tPiB3cm90ZToNCg0KICAgIE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAyMzoxNCAr
MDAwMCwgTmlrdW5qIEtlbGEgd3JvdGU6DQogICA+PiBTb21lIG9mIHRoZSBicm9rZW4gTklDcyBk
b24ndCBoYXZlIEVFUFJPTSBwcm9ncmFtbWVkIGNvcnJlY3RseS4gSXQNCiAgID4+IHJlc3VsdHMN
CiAgID4+IGluIHByb2JlIHRvIGZhaWwuIFRoaXMgY2hhbmdlIGFkZHMgYSBtb2R1bGUgcGFyYW1l
dGVyIHRoYXQgY2FuIGJlDQogICA+PiB1c2VkIHRvDQogICA+PiBpZ25vcmUgbnZtIGNoZWNrc3Vt
IHZhbGlkYXRpb24uDQogICA+PiANCiAgID4+IENjOiB4ZS1saW51eC1leHRlcm5hbEBjaXNjby5j
b20NCiAgID4+IFNpZ25lZC1vZmYtYnk6IE5pa3VuaiBLZWxhIDxua2VsYUBjaXNjby5jb20+DQog
ICA+PiAtLS0NCiAgID4+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX21haW4u
YyB8IDI4DQogICA+PiArKysrKysrKysrKysrKysrKysrKysrLS0tLS0tDQogICA+PiAgMSBmaWxl
IGNoYW5nZWQsIDIyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQogICAgDQogICAgPk5B
SyBmb3IgdHdvIHJlYXNvbnMuICBGaXJzdCwgbW9kdWxlIHBhcmFtZXRlcnMgYXJlIG5vdCBkZXNp
cmFibGUNCiAgICA+YmVjYXVzZSB0aGVpciBpbmRpdmlkdWFsIHRvIG9uZSBkcml2ZXIgYW5kIGEg
Z2xvYmFsIHNvbHV0aW9uIHNob3VsZCBiZQ0KICAgID5mb3VuZCBzbyB0aGF0IGFsbCBuZXR3b3Jr
aW5nIGRldmljZSBkcml2ZXJzIGNhbiB1c2UgdGhlIHNvbHV0aW9uLiAgVGhpcw0KICAgID53aWxs
IGtlZXAgdGhlIGludGVyZmFjZSB0byBjaGFuZ2Uvc2V0dXAvbW9kaWZ5IG5ldHdvcmtpbmcgZHJp
dmVycw0KICAgID5jb25zaXN0ZW50IGZvciBhbGwgZHJpdmVycy4NCg0KICAgIA0KICAgID5TZWNv
bmQgYW5kIG1vcmUgaW1wb3J0YW50bHksIGlmIHlvdXIgTklDIGlzIGJyb2tlbiwgZml4IGl0LiAg
RG8gbm90IHRyeQ0KICAgID5hbmQgY3JlYXRlIGEgc29mdHdhcmUgd29ya2Fyb3VuZCBzbyB0aGF0
IHlvdSBjYW4gY29udGludWUgdG8gdXNlIGENCiAgICA+YnJva2VuIE5JQy4gIFRoZXJlIGFyZSBt
ZXRob2RzL3Rvb2xzIGF2YWlsYWJsZSB0byBwcm9wZXJseSByZXByb2dyYW0NCiAgICA+dGhlIEVF
UFJPTSBvbiBhIE5JQywgd2hpY2ggaXMgdGhlIHJpZ2h0IHNvbHV0aW9uIGZvciB5b3VyIGlzc3Vl
Lg0KDQpJIGFtIHByb3Bvc2luZyB0aGlzIGFzIGEgZGVidWcgcGFyYW1ldGVyLiBPYnZpb3VzbHks
IHdlIG5lZWQgdG8gZml4IEVFUFJPTSBidXQgdGhpcyBoZWxwcyB1cyBjb250aW51aW5nIHRoZSBk
ZXZlbG9wbWVudCB3aGlsZSBtYW51ZmFjdHVyaW5nIGZpeGVzIE5JQy4NCiAgICANCg0K
