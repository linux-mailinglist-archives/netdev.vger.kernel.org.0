Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD8BF9682
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfKLRCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:02:55 -0500
Received: from rcdn-iport-9.cisco.com ([173.37.86.80]:23327 "EHLO
        rcdn-iport-9.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLRCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 12:02:55 -0500
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Nov 2019 12:02:54 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1294; q=dns/txt; s=iport;
  t=1573578173; x=1574787773;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3XzoIwjqzuLJljfaa2ROeyCix6flvJ+ctmiO5RnvvoY=;
  b=I9k8bmLPn0pDS6uTpYlNYH58E00vU6Y0llbPS3SObQX7igAKfjDQxGDz
   c8zormuDPwVisNCkGnHcYoDt1eclE8qYvGeECUDj1XblUdRm3yXOKUoaF
   h6SJGMQR8v7taMl3JNLFKdh2Z0xdRy74sG6g+mvhb9Dxj/5ObQKZyKjRn
   I=;
IronPort-PHdr: =?us-ascii?q?9a23=3ALEF/Ch1H1Tz5WJI0smDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxKGt+51ggrPWoPWo7JfhuzavrqoeFRI4I3J8RVgOIdJSw?=
 =?us-ascii?q?dDjMwXmwI6B8vQCVfyKfLjdC0SF8VZX1gj9Ha+YgBY?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0BKAADm4spd/51dJa1lHAEBAQEBBwE?=
 =?us-ascii?q?BEQEEBAEBgWoHAQELAYFKUAWBRCAECyqEKYNGA4RahhWCXpgAgS4UgRADVAk?=
 =?us-ascii?q?BAQEMAQEtAgEBhEACF4IGJDQJDgIDCwEBBAEBAQIBBQRthTcMhVIBAQECARI?=
 =?us-ascii?q?RBA0MAQE3AQ8CAQgaAiYCAgIwFRACBAENBSKDAIJHAw4gAaQ5AoE4iGB1fzO?=
 =?us-ascii?q?CfgEBBYUNGIIXCYEOKAGMExiBQD+BOB+CTD6ELhcXgnkygiyQDJ4ICh2CCJV?=
 =?us-ascii?q?EFAeZeYpvg1iZdgIEAgQFAg4BAQWBUjmBWHAVZQGCQVARFJA2DBeDUIpTdIE?=
 =?us-ascii?q?okDYBAQ?=
X-IronPort-AV: E=Sophos;i="5.68,297,1569283200"; 
   d="scan'208";a="575673166"
Received: from rcdn-core-6.cisco.com ([173.37.93.157])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 12 Nov 2019 16:55:47 +0000
Received: from XCH-ALN-014.cisco.com (xch-aln-014.cisco.com [173.36.7.24])
        by rcdn-core-6.cisco.com (8.15.2/8.15.2) with ESMTPS id xACGtlmA013875
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 12 Nov 2019 16:55:47 GMT
Received: from xhs-rtp-001.cisco.com (64.101.210.228) by XCH-ALN-014.cisco.com
 (173.36.7.24) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 10:55:46 -0600
Received: from xhs-aln-001.cisco.com (173.37.135.118) by xhs-rtp-001.cisco.com
 (64.101.210.228) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 11:55:45 -0500
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-001.cisco.com (173.37.135.118) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 12 Nov 2019 10:55:45 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+ii9NmLm9ZZ62l5gdy1+FKO2K7jGbmOuK2Rgme+wxqXONfHeVdzhE53/rqYlVBvTKSqq4H1v3I2bzpf4Xn/z3RVQCEnTfPW/5Q5N1+qNdBVy4txbeGx+w0NCFvWeK8nvrfGpTYtUh7NJvL5sGj/LDVj26iI93U2p6GREljHadZuqnK52iWADYIsaLotUMBpdI8hAknS4lbz3YdwouL2n4kWg32uI8ItAiViCTRxBFGeUkqOjjdemiCjwtQ9cmOuC/aFBr5aIslZ/TFA4bvP+H59qlPTFAuekLmyQ012rcH59ACBhR1p/zrQ+LmbZUM59pCyvWLo3exBRlaXJ9jeXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XzoIwjqzuLJljfaa2ROeyCix6flvJ+ctmiO5RnvvoY=;
 b=nLCADza4GtTIgEoJgZFiV8JShI99AfNJwZC2la1VG/NZD4eMa0m9SYASzComyVa423BD6PMC+SxcR1+ub2dhi3PaRXvq/fmZNAKTPVaupBg29zD9vlh8Scy2MUBsYL+TVLm2aNy+9kPCajb7gzj0HuK91754HxM3ziSzZlCe11wq9fDWJ05C3qNkCJ/kKMtBvshGQqWccCoqc7HXaqUeD5uy40N5NPJZvsdZcXx5GND4T0n/aQBTfX3/XaU7v7CmD8bdWouD95P1+UMWjrv8lA7NDooEKsrmdTq60OS33hyXyo1vZO8mafmcqW1PrgVfPWnf3P6qr0UVE4ImyVewAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3XzoIwjqzuLJljfaa2ROeyCix6flvJ+ctmiO5RnvvoY=;
 b=qJymWR7UyjqqgWNElbiRJkiVlOnfaWm511M1UdwUS8f+M4/w6dI6lwiNrrbRqJPUZHX7WN3YpAhCoymyE2oM07IaLAadZsQ8EGceyW9Dpw2fWs6q7WzPJfwU2u6adiF/3HrgRIry68LjeeYQ9NsJiU1CBqh8HrxgI/EgR6tTxP4=
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com (10.174.53.140) by
 CY4PR1101MB2088.namprd11.prod.outlook.com (10.172.75.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Tue, 12 Nov 2019 16:55:44 +0000
Received: from CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc]) by CY4PR1101MB2311.namprd11.prod.outlook.com
 ([fe80::703d:f3d9:40d4:55fc%5]) with mapi id 15.20.2451.023; Tue, 12 Nov 2019
 16:55:44 +0000
From:   "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: Re: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmXjf3wbj+LJfjk+2lQ/PEvIoiqeIHUyA
Date:   Tue, 12 Nov 2019 16:55:44 +0000
Message-ID: <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
In-Reply-To: <20191112164707.GQ18744@zorba>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hramdasi@cisco.com; 
x-originating-ip: [2001:420:c0e0:1004::125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 863b676a-bd54-4b32-c498-08d767912883
x-ms-traffictypediagnostic: CY4PR1101MB2088:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR1101MB2088B78F42D8981D39158357C9770@CY4PR1101MB2088.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(189003)(199004)(6116002)(66476007)(6246003)(107886003)(316002)(6506007)(54906003)(186003)(36756003)(66446008)(86362001)(66556008)(64756008)(110136005)(4326008)(6512007)(76176011)(71200400001)(2906002)(102836004)(256004)(76116006)(99286004)(91956017)(478600001)(33656002)(66946007)(25786009)(46003)(6436002)(305945005)(446003)(71190400001)(8936002)(2616005)(6486002)(4744005)(7736002)(476003)(81156014)(486006)(81166006)(8676002)(14454004)(5660300002)(229853002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1101MB2088;H:CY4PR1101MB2311.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wZ/B8+yaCUca5EgZCUDm9sMiSFN65P4R7poG23MjrYnZt6WiTAj88C64zPKVl7HpvmzsAEtxJOogc0jQ65gLV1hOYuHlLleur22NJc2GD9i3UX5FRKdRq8wUW/6gwQpXDgvX9IKuKasn27XHa0OhLbB/AfFvQIUMqytYKC0i3jC8IUXYR06dWX7hmtNQO2RgTkjVDWYRb3IkE7VMgsK/gVV2/WxSPAx2LL1emCADi2Q5QrOC4aHdcb3NmVx0aPU6jlGmfQgkplYRfxKb/q9E9HS+UDDW1hl30M6SmcPia2j5WVhKYtBuatB2zRU0gN/6gI9CwRKoi6MW5xIMLrpc4vyJ4UaniFHB0WQUHX78nVIZ22Y9R0O9lbdORQ+WbwjGSq41R0tE+BcjtKAbGlq0Oz5XGXyJQ2Uxy8TMMfUpYnHwKCMGlyBeQjMjTSTXGeW/
Content-Type: text/plain; charset="utf-8"
Content-ID: <B2850CD3BB382440A2116771CA471F02@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 863b676a-bd54-4b32-c498-08d767912883
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 16:55:44.2268
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pavv07eLM7mnIrzKTa8jvanMlngDYhGBkita8tM2LArgEWj2+tNTJuqEhl+Q4MJFG5m1bY5knsMoJies9U8tgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2088
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.24, xch-aln-014.cisco.com
X-Outbound-Node: rcdn-core-6.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ICAgID4gUmVwb3J0ZWQtYnk6IERhbmllbCBXYWxrZXIgPGRhbmllbHdhQGNpc2NvLmNvbT4NCiAg
ICA+IFNpZ25lZC1vZmYtYnk6IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29t
Pg0KICAgID4gLS0tDQogICAgPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5m
YXIuYyB8IDMgKystDQogICAgPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5m
YXIuaCB8IDIgKy0NCiAgICA+ICAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCiAgICA+IA0KICAgID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ZyZWVzY2FsZS9naWFuZmFyLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
Z2lhbmZhci5jDQogICAgPiBpbmRleCA1MWFkODY0Li4wZjRkMTNkIDEwMDY0NA0KICAgID4gLS0t
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KICAgID4gKysrIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KICAgID4gQEAgLTMxNzMs
NyArMzE3Myw4IEBAIHZvaWQgZ2Zhcl9tYWNfcmVzZXQoc3RydWN0IGdmYXJfcHJpdmF0ZSAqcHJp
dikNCiAgICA+ICAJZ2Zhcl93cml0ZSgmcmVncy0+bWluZmxyLCBNSU5GTFJfSU5JVF9TRVRUSU5H
Uyk7DQogICAgPiAgDQogICAgPiAgCS8qIEluaXRpYWxpemUgTUFDQ0ZHMi4gKi8NCiAgICA+IC0J
dGVtcHZhbCA9IE1BQ0NGRzJfSU5JVF9TRVRUSU5HUzsNCiAgICA+ICsJdGVtcHZhbCA9IGdmYXJf
cmVhZCgmcmVncy0+bWFjY2ZnMik7DQogICAgPiArCXRlbXB2YWwgfD0gTUFDQ0ZHMl9QQURfQ1JD
Ow0KDQpUaGlzIGlzIG5vdCBpbiBzeW5jIHdpdGggUEFEL0NSQyBkZWZpbml0aW9uIG9mIG1hY2Nm
ZzIgbWVudGlvbmVkIGluIHAyMDIgcm0uDQogDQoNCg==
