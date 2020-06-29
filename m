Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A75620DC70
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbgF2UPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:15:20 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16162 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732274AbgF2UPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593461718; x=1624997718;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
  b=UmDnL3Eb+6IHhD1gJmRsqdgvecfme1YP1hW649UzFR10P7O4OASNJbxs
   CXuw5zZjyte9de5xoJ6ibeG75rvNEvJ8PIXTpPXz/8+yI1C1+eV4eW8FZ
   QuU8ZaPwV7+BV42OFgHQ9kyjOkyUzPqOFstC085j9YM6/e++tHHTVOh+h
   UERqZ15MkOkIir8wnj8B9/6Qn7gBQbceLxtHYE4lEzJSl5egwilOnEon2
   OKsFmBxSP0mBw0Om+uWLkEekR3j3lzKcYJC9uGuzjOMAM3gKV6LzZiUef
   QTxplJ6gkNTG51dpkgqCbEWQdXmdDVpbH7uxOoy/hYQUjdIXXT0olAmND
   A==;
IronPort-SDR: wFP15aOtORMQ0l80yWolJYUwIaeYe2y5BGsZwFc91mlfCzgzreOKG3RABWBMq2tBttakMPHljN
 0R2/HH3ikaAC5j+7usY9fc+cITbnkLOyi8hSNlGhn26wlimGnNZe1Wnvdol3lW82h5Nu2m+tUW
 kCXgSEoXleXB3K1RTSgOAnFDrvUBssMXFzCprb5wsGbWS0Hs1fatHTdlXjrN+koo8sekIAIxbF
 myIEzhDzKOHKTg35v1XuIjjFt37h6hTUb78LkBkvp+0gKUk2SiJzVTDShHamZCiRl/qC0abeqK
 qlg=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="81972626"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 13:15:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 13:15:00 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Mon, 29 Jun 2020 13:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2CZx1cVFGWxpo3E1xiQwkQxeDCptB2d9/JhwvfF2/QEcFw9kpAaWunsdiBTzLcNZ4y+Pw3VkCnEYeuzcpdXzDi6kECgacIvbaWlpNXGPhwkiMSDRNhYKpkm+TxR7CTpuPjNhfJt8dM24h7XU1tu2IlU8Wb4bexJELuUz0goGSD/EQcsGNU2SNrsr14XoFY8kNR/yHwoBSq84UsfxzRWP51D7vlrEGpFxe7vZOyoo5PXXxEcmP9mUT2qh1TFMruytZqyDyoqEafXrz0+2kN2H6KuTcFRUIk5+0rlnvvZZb0iXu3LCflFhKzvdpUjSS8mwTc1uFBqiYwMCCq0tt2cig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
 b=FYzNxvIdnXDjqQ/QNkiY+Bf/kudEe7BZ/nzSGjXPQ9gkxXnA2AcP9zyqZaxmfbCHeBlcd+iAgcLUnDUOawCbhbUv6hedKIQtBzTG330BOVwqq8JEE0e2SBsZdhVKM52Rc33KFlNnERlI6DXxU1ihrMF3E4dWRrG8KvldWrK5IpVJr03vMcnPYF84kSap7u7NKsGOEgtTkiApOLpnK5OibuAMBYsONRb0R4UNG8PJS3Ruoho63FulYtiiNUhnM7NNqOw314djjP/ltHxBR7j/NFD2yMmK43RmdDU9K06yvUWsOKt4ZF68TvSd54c8+/+9XWyCKcT8aWdI+av7P6A6TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGQVZwE+pnzncmQh0KEc1c95kDfMl6zV343reXKcIds=;
 b=vdM0yqWtM0xOgwZzqB0rwGINxku2Fp9kBJimIBmUq9rRLbNVhl1E9Y7VSwlcuLVxGCe32ecvET9VAgCK6umLRrRO1lWQzJ1ui/vGYLVc71cI5RR2UkUwp3dOW/1CKFm0eT/C8wrX3NpqcO2J6GUPir+GKDBuIdF9ikm1IXwygEM=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BYAPR11MB2997.namprd11.prod.outlook.com (2603:10b6:a03:8b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Mon, 29 Jun
 2020 20:15:13 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 20:15:13 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 1/8] smsc95xx: check return value of smsc95xx_reset
Thread-Topic: [PATCH net-next 1/8] smsc95xx: check return value of
 smsc95xx_reset
Thread-Index: AQHWTlH/RuJjG1oI9UKZ57LQazji6A==
Date:   Mon, 29 Jun 2020 20:15:13 +0000
Message-ID: <568a690d2d4d1527be465a05dec40732ec271c20.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 803ec8dd-ee4f-4de1-47cc-08d81c6921a8
x-ms-traffictypediagnostic: BYAPR11MB2997:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2997FA6B5E87DE8EF0873762EC6E0@BYAPR11MB2997.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B4teutoiz00lN5MwrR6QEvbMnKMDwjK/w3uDo6WuHKDc9ul7Qysdys2JIXAY+pOLfn1VE6vmcXcdO/UgrcL/Q3iCf20vUjL/JtDfBFW29mgeNV9EVE2/ISUcg57AvcP2n5RcQwprgyAh2ESuTP0Foy51E4GfNewvAQeyz/2Jw5ShhJKueBULpxu92E1Fy6GCRfQMeZ+XHS2B8JPgyfDmkdqJavBBSQuR09ahBvoyj37JHu63avaIqo7NTMoucjerdadqTnj4HI+qVZDjlag3ucG/hsZQiRqTsuzRrl2Pi5evNH5F/63+paih/xQ9Le0K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(86362001)(71200400001)(186003)(110136005)(26005)(36756003)(83380400001)(5660300002)(2616005)(107886003)(478600001)(6506007)(4326008)(66946007)(76116006)(8936002)(6486002)(66446008)(64756008)(316002)(6512007)(91956017)(66556008)(8676002)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bd1UEm/FTdOYOqW+VhXuHCT4vnBI84JYIPLQOFXHHRSSv54WChkKvrzAjlsRqSO5hgEkv0gg3/O4/L1V9NDgrf9Zq9tRUbbDuE8pU6mdLfR0PuUObQ9hNOohMBF9YWoB1asCwGuowPBKOYGxsWVi9fhqJcJC9kikFfGVO9JYpBwN0D/5m5fBRA9nuTKNYGA75nK+i99Miy/F54PD7wss4uHEg8Y+nLWF0xo5DXLJNkviBKe1CjCR7mxHAj5pgaVJEsV7BaF3EHbPnH6KGgXRIu3b/2JBUZ1OzKsMdiWBUp/eAnZTVE+0Bh/1UQdbfo67QkUhGlbCIteWbKLm0x5BdbRPhY+xlqz2Y3+MstI90ANONg9fvuWkvyJ4s634zVPF+qQOzn1baa3Cc93CdoN6+n3qHGF1Pu5Os1VQOJ+B3NJBVwpR6Af3WzTs4i3L6u9XSHyDLuW0R0lqDvvrU1wp2x3FKcqQytkH8KFP+6+vMu6TM8hgY1Gk4hR/JxqPaNKF
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FF3A3B814F3294FB6B2B6ED44E4A044@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803ec8dd-ee4f-4de1-47cc-08d81c6921a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 20:15:13.2696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cjfNNX5jdwKFyWfCQz1P6w63shX0ZmV2z15ZK7wdaf2Ty2oSvJ7PQYWKp1GNDEkUWq+VEPGbfUeTZ9dUcDgGflaJkblFnLyImTK4EaKfLZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIHJldHVybiB2YWx1ZSBvZiB0aGUgZnVuY3Rpb24gc21zYzk1eHhfcmVzZXQoKSBtdXN0IGJl
IGNoZWNrZWQNCnRvIGF2b2lkIHJldHVybmluZyBmYWxzZSBzdWNjZXNzIGZyb20gdGhlIGZ1bmN0
aW9uIHNtc2M5NXh4X2JpbmQoKS4NCg0KU2lnbmVkLW9mZi1ieTogQW5kcmUgRWRpY2ggPGFuZHJl
LmVkaWNoQG1pY3JvY2hpcC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBQYXJ0aGliYW4gVmVlcmFzb29y
YW4gPA0KUGFydGhpYmFuLlZlZXJhc29vcmFuQG1pY3JvY2hpcC5jb20+DQotLS0NCiBkcml2ZXJz
L25ldC91c2Ivc21zYzk1eHguYyB8IDYgKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0
aW9ucygrKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgYi9kcml2
ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KaW5kZXggM2NmNGRjMzQzM2Y5Li5lYjQwNGJiNzRlMTgg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KKysrIGIvZHJpdmVycy9u
ZXQvdXNiL3Ntc2M5NXh4LmMNCkBAIC0xMjg3LDYgKzEyODcsOCBAQCBzdGF0aWMgaW50IHNtc2M5
NXh4X2JpbmQoc3RydWN0IHVzYm5ldCAqZGV2LA0Kc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYp
DQogDQogCS8qIEluaXQgYWxsIHJlZ2lzdGVycyAqLw0KIAlyZXQgPSBzbXNjOTV4eF9yZXNldChk
ZXYpOw0KKwlpZiAocmV0KQ0KKwkJZ290byBmcmVlX3BkYXRhOw0KIA0KIAkvKiBkZXRlY3QgZGV2
aWNlIHJldmlzaW9uIGFzIGRpZmZlcmVudCBmZWF0dXJlcyBtYXkgYmUNCmF2YWlsYWJsZSAqLw0K
IAlyZXQgPSBzbXNjOTV4eF9yZWFkX3JlZyhkZXYsIElEX1JFViwgJnZhbCk7DQpAQCAtMTMxNyw2
ICsxMzE5LDEwIEBAIHN0YXRpYyBpbnQgc21zYzk1eHhfYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYs
DQpzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCiAJc2NoZWR1bGVfZGVsYXllZF93b3JrKCZw
ZGF0YS0+Y2Fycmllcl9jaGVjaywNCkNBUlJJRVJfQ0hFQ0tfREVMQVkpOw0KIA0KIAlyZXR1cm4g
MDsNCisNCitmcmVlX3BkYXRhOg0KKwlrZnJlZShwZGF0YSk7DQorCXJldHVybiByZXQ7DQogfQ0K
IA0KIHN0YXRpYyB2b2lkIHNtc2M5NXh4X3VuYmluZChzdHJ1Y3QgdXNibmV0ICpkZXYsIHN0cnVj
dCB1c2JfaW50ZXJmYWNlDQoqaW50ZikNCg==
