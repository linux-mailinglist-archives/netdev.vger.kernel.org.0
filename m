Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00613BF92
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgAOMOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:39 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:28929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730768AbgAOMOe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:14:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W8kqNxPIcq8FIgQMhXfRZTbmbl+b57UYRLkQ3nhHNr5jP19eekiuogZt1EoEMFwxvvc3G6oI8dk2LVEkWgv9YZJ8KCR9M/2SPoEei6k06SCvvbonxSIyXEHWJTUosfV0dhqXb/oVCIzaTtacjzr36pslZIFR5q4HJ88g+SvsTb2BTg1at6FAfaDU1rmZ0ldgdLusuUYyzJA/nvt02riplEGL0iRv1Y79xQqxhb4I71ltGOY/iVm3rv1+mGiyKyoUfKngWjdJx0a/TZruXv5JBOrDZQYPVcyFk5SIMLGjJkxAGMKssDNXzgDAtLbqRLv8rhpiYtQFlYBPXaMhrD+QwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3u2E2RuWsPeDBspbS1BYQcNKcjt+UuC5v4vUdV+0qA=;
 b=R5xWqPPiiuq5J4xSRQqyg1281YzaewpXdOlimKhZVD8zXwuZ7bNOj3x5r2RWnWS/s8WC2vGoZtymnhi/KXNZUzxuY7bmvHCuG25AXwP0O7yrWS796gxfVlO+hvt8DhmXOojhyoEl1Z7JYo+A+1kfZEXY3N6MgRy3AGXasAfLG6SeYwMfHCCpe33stCarA9ICW73j6A4g/IzETM4cdXkUY11LSwC0A0WQyzaLclhXZUyRvmkW5/vZpVNSYAXvGV8kJ8VRWad3GU5bY75WFDbVPRRJdbMU4vQMFb1HEMjR8vYit/SeIDfHfYwbflXZ62771JXJ9vpqgwPEi3UIrDXzWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3u2E2RuWsPeDBspbS1BYQcNKcjt+UuC5v4vUdV+0qA=;
 b=ekIaZ0jn/Wx920JY77/vQ24RBFqswYeoQGs5xPVMf6mxuQjpZKFakV7QNKzfHN4wc219qyW4ei8ctoisAaYM1TMd+ezbfMj1bNPzEdE07qj0ofF0YhTfcOihMwGUrKP8OKoUX04GOVRBEmqsaw8xD9o8GjY7yMYRR+iRijQIhNM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:14:11 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:14:11 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:33 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 64/65] staging: wfx: simplify hif_multi_tx_confirm()
Thread-Topic: [PATCH 64/65] staging: wfx: simplify hif_multi_tx_confirm()
Thread-Index: AQHVy501HoKuGDgN9ECTgXQynTSwOA==
Date:   Wed, 15 Jan 2020 12:13:34 +0000
Message-ID: <20200115121041.10863-65-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea5a3e45-74cf-46cb-9f22-08d799b45817
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB393471101C97D9F7DCF4C6C293370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K0W22SMnn9wpOAfLMOBkFjS/42B6Yao1R3MDOzqbU9dOrgMKAkJR3JxPbarY7HBviKj53qhTWIGXnQQaF99xBUD676O48eD69YMy36cl2pEOqD9dURab4SuHX84e2vzLFi/h4jMt8rZKlzTY/HYdUxkqoT7LZJcicz5VhWNdIbQbHu/zHihrnV30Y2I47IosZ9Hd3pOa+nrv9Wi02X5FZBAJOwg95wpBxRwMd2jSobaJa1vc9Mrs8bpnRd/so+4d4k43Fk4OzBw9BepviYOeoCU5Bd0O6VwR21BrYnrPjmH7MoQdF7zxzuJx/va7+5ojhvoySy0JhSLg/APIQgwZvcj9v8cbHu21AYSELOAqTtkGuRRVoLAjCc8CM4E5EAghpvLMDCSbqS5A7WGJ1WLgICMj/bZkKfmwTTjNNW0ZsgqqJBbvyHfXfysu3WN0G0WI
Content-Type: text/plain; charset="utf-8"
Content-ID: <D686B52B0DBA9A44BAF22142AD70D327@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea5a3e45-74cf-46cb-9f22-08d799b45817
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:34.9299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ePdqJJWqWZL1kW1cz+v/TH+xYMPJmmBBTTVpm7X66kSDmaSaWpXn2CgmUX4lTV4F0dliNnFo1XRF3hVKWQJ35w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVXNh
Z2Ugb2YgdGhlICJidWZfbG9jIiB2YXJpYWJsZSBkb2VzIG5vdCBzaW1wbGlmeSB0aGUgZnVuY3Rp
b24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNp
bGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYyB8IDExICsrKy0tLS0t
LS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2hpZl9yeC5jCmluZGV4IGY3OThjZDY5NzNiNi4uMzNjMjJjNWQ2MjlkIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3J4LmMKQEAgLTc3LDIxICs3NywxNiBAQCBzdGF0aWMgaW50IGhpZl9tdWx0aV90eF9jb25m
aXJtKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCWNvbnN0IHN0cnVjdCBoaWZfbXNnICpoaWYs
IGNvbnN0IHZvaWQgKmJ1ZikKIHsKIAljb25zdCBzdHJ1Y3QgaGlmX2NuZl9tdWx0aV90cmFuc21p
dCAqYm9keSA9IGJ1ZjsKLQljb25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqYnVmX2xvYyA9Ci0JCShj
b25zdCBzdHJ1Y3QgaGlmX2NuZl90eCAqKSZib2R5LT50eF9jb25mX3BheWxvYWQ7CiAJc3RydWN0
IHdmeF92aWYgKnd2aWYgPSB3ZGV2X3RvX3d2aWYod2RldiwgaGlmLT5pbnRlcmZhY2UpOwotCWlu
dCBjb3VudCA9IGJvZHktPm51bV90eF9jb25mczsKIAlpbnQgaTsKIAotCVdBUk4oY291bnQgPD0g
MCwgImNvcnJ1cHRlZCBtZXNzYWdlIik7CisJV0FSTihib2R5LT5udW1fdHhfY29uZnMgPD0gMCwg
ImNvcnJ1cHRlZCBtZXNzYWdlIik7CiAJV0FSTl9PTighd3ZpZik7CiAJaWYgKCF3dmlmKQogCQly
ZXR1cm4gLUVGQVVMVDsKIAotCWZvciAoaSA9IDA7IGkgPCBjb3VudDsgKytpKSB7Ci0JCXdmeF90
eF9jb25maXJtX2NiKHd2aWYsIGJ1Zl9sb2MpOwotCQlidWZfbG9jKys7Ci0JfQorCWZvciAoaSA9
IDA7IGkgPCBib2R5LT5udW1fdHhfY29uZnM7IGkrKykKKwkJd2Z4X3R4X2NvbmZpcm1fY2Iod3Zp
ZiwgJmJvZHktPnR4X2NvbmZfcGF5bG9hZFtpXSk7CiAJcmV0dXJuIDA7CiB9CiAKLS0gCjIuMjUu
MAoK
