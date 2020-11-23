Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF5F2C1274
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390426AbgKWR44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:56:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35254 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731340AbgKWR44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:56:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHtsnM032585;
        Mon, 23 Nov 2020 09:56:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=ayKeG63TgdBGMWt1elUzDKUGrj2crvvsQ9p3cwwH5ak=;
 b=UtsY8Dp+ZO5f3OPsimL93Lnbcl/uYS3ZHxxB+QElzOfKFS3ZIuUZ/L2d2LTe4fDAtg5J
 vhezygtr+i9EtfGmgeRNCyNmM6ZlfoBsFpKGCNYiqdZOPEb5ByOmYAhjpZM4kKsLbD92
 4MduIC9+HFcShFrE2Cugc6juHkvlNJfjdIlbkfXiwVXISjAKz5Il82OY/q5R8+i9G3M9
 23uRfc0Rmz2mWkUGVKTlXBZxczl13TQnytwP7uucLfVTM/zuZ67rs3F7ZaNxdbMPgr5a
 Inx5V8jW/e53TABa7FaImsnagxwwUipFoIpGPEa8XnHHkUsfN6JqpsxUoYtqVmqZhLBm ag== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u6ttk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:56:04 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:56:03 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:56:03 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:56:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7tm1+76zAtj/vIyFCxE6yQMb4CsarawXzIRT+03KQrO1+nLAuJsQXgCi/xi4tdbcO4aVYrQDCQ1CDwekiXDgVPu/9WhOA5bjlC+TfGjEkDEdtX6QQ084fDspzd3UKMPZotbufJV6pKZeY9lCGEfmyu3aE6lDcdfC1j7KrIQEiF6CKYRf6SHyt/X5oNeIWF3I7fbhBbITxiTkvHFWWJhexpjm79BlQ++mUmShaPI0DnxMncm8jS5egMdI7jTrw3wKlp3OfJs7pHfPmohCyEomXyssa8T2HyiPkCwO9k5oJkoXPLAE2VLX1+JKr/3InShC0jTMT3jVZwFtylbwSshGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayKeG63TgdBGMWt1elUzDKUGrj2crvvsQ9p3cwwH5ak=;
 b=hpxf1M3GjHDdDuLj9bHAXoL2xob1XEKAPPSF/4zEmKSIVPQDbJ6aKVJAxZmiRPf2aZQRgueqvUWae7ttvuz2Ou/UW2skYSnKkHbGhuMac3ihhIphnK3gfkw0L6rHnsrRFkwUQLywqasqajphJiXeiXpGXDQKX0knpWr3JsQT3LAmEXhh2DyuB3d5YkZaCQAPsrXqCBbS39/TyTnvzEqswv8o3rrvF67+fTelBEXkWl9VQNxsw3uDM1swI2lydxLy3rc7QmsjQLwUOOZsbismS0/+/OQUoocKCzf5xlzPsbVIeVLptytUrjrvlVl4yx4q2gTWulBQmWDWAU5SfjZuYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayKeG63TgdBGMWt1elUzDKUGrj2crvvsQ9p3cwwH5ak=;
 b=JfB6qWKfMc6J0mdkxZTBVtjb+x2w17wkRHQ447xS0o35X2TgD+OVWylAGNVL3UhTUL7rrrJD7y1RhRSN03Vkr79+BHfLPa3uinWiYAvWGekLVYYZgdkX7iLFzzSchJa+DzfCoarA3285JCMSG0a4PGWhMc6IgwE2inj9CjJeT1s=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by CO6PR18MB3954.namprd18.prod.outlook.com (2603:10b6:5:34d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 17:56:01 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:56:01 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v5 1/9] task_isolation: vmstat: add quiet_vmstat_sync function
Thread-Topic: [PATCH v5 1/9] task_isolation: vmstat: add quiet_vmstat_sync
 function
Thread-Index: AQHWwcHncFFYB7yySUCSwy4M4/wQUg==
Date:   Mon, 23 Nov 2020 17:56:01 +0000
Message-ID: <0e07e5bf6f65dc89d263683c81b4a19bcc6d4b60.camel@marvell.com>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
In-Reply-To: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a177c911-2bea-4778-33e1-08d88fd90a1e
x-ms-traffictypediagnostic: CO6PR18MB3954:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3954AF25092C9DEDE193A98ABCFC0@CO6PR18MB3954.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WeR3fWHdBhlNYuHhjuoI2gi6gCZ1erUXqY612gVYWmlJAUbLJcP5Syi3n76eWrPiKkOJ4T0jsyzT5k9cd5Lbs14RE85Qe/HICzSxs2JSNylUZfp0/NVXm8YnF0Ab7pqgbQbgfgMKxAc+YgTWwrVH6vDUizKHJToEeuLi39dYONBnmhTstAYHeHPu99p2N1R2hGf/XH6gAH4q/kYGeAMJ4Chx57TzHAnZNFo1YVKbGydhGtvHBFduiqEkY8pCqcsu4zyY/WUqxB26HCE3SzFbMyO6AWRz36cnCpSHWxouxTktgDo6pHUn88X13oyK1HbTPTr1MtPGt7ddJQkKcc7Xew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(2906002)(6506007)(6512007)(64756008)(8676002)(66476007)(66446008)(66556008)(7416002)(6486002)(4326008)(8936002)(71200400001)(26005)(36756003)(2616005)(478600001)(54906003)(66946007)(86362001)(5660300002)(316002)(76116006)(91956017)(186003)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: T01+YFQyVT/f4ttncxpIuAGD2LawA0m61uid3Ji7jj8UhXXgHMhTxTJaDlOE+H06q/w/MsZwILZdj63WbPQ5B5uqKEhN+9wkl2RtUmI5R6uTi3TuTpvyFdKVgrU9SJ4O5XRJdagSilhVg28lF8lZbHCMqYlwz0FrOoDqiITE2JL3dPcDu/Riu6thizwNb0WAsRwR9TKhiiz9KEUAfPemKM86iP+AogeDFWkm1LXf6uOoNKA4GMEFsu+CJn/zI0Tcn60WgHCpXUZFFdF641F2YazWpwB+FRVCFKeTDkPO5O04fNh4icIvyimczk1R9CQWbujmx2wobg3N9kLXJnh04IVNW8NOOgBYsW7aKWQQ622hAEacgLMYtKrh0D5EEYvvYslM2VwYWaT89WSiX6ARnORFpXlJv+ciL8EwX9RviZLJmyr2n/4sUD9DiG58mMItgcHpTy/5/Q64rb676jamlsns6KQ0Fd7AzUUKrWWsdkDRlA0VOyRvCrWt6ZchaWWHUTts/b26MrIMLziD/+prPfdfu/g7nuN48RyEfHZH0BRPntaee4RoqNYOr5GcOluXZ6xVkOdYzlof756NTPhDUFUekMp0qRoRHC6f34YDphN4w2Bs6TjTS1noJaJv/dX/G/Od5HYA+bt2BLfxLtaSrlMorD6DbhvzT2V1ZiPgv9+UgoMD3AVEU0wIoI9QLNwmiughGy8frXjL0wNUOZEInbfOoR9Um5bSDZ++9x/555LjxD45gQOjYGzWBJMNXr4JcAlozDNqBIfzKSNQ088rtL7BvUU7rVBzMQEjPj6SBkS8bWjE4E8inZvSM6IJ4iEh0TVusSkzz6b1xWjkz9weFMo1UUHfiN+8bsztac7ICWs+MJ9e58Ayp8Mahzjatsz0aVk7VWQYhY4YRGl+frrA9A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EE67D1612B99E849BF24A997E8AAB72F@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a177c911-2bea-4778-33e1-08d88fd90a1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:56:01.1572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4DTxq/F1OHacfwsrXoBCqTINPgRqURp+6GALpX5cvtQz/qE6fu3iqt+sZjtaUSSKeGQIy+YsqJROt7RkU/ELiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3954
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpJbiBjb21taXQg
ZjAxZjE3ZDM3MDViICgibW0sIHZtc3RhdDogbWFrZSBxdWlldF92bXN0YXQgbGlnaHRlciIpDQp0
aGUgcXVpZXRfdm1zdGF0KCkgZnVuY3Rpb24gYmVjYW1lIGFzeW5jaHJvbm91cywgaW4gdGhlIHNl
bnNlIHRoYXQNCnRoZSB2bXN0YXQgd29yayB3YXMgc3RpbGwgc2NoZWR1bGVkIHRvIHJ1biBvbiB0
aGUgY29yZSB3aGVuIHRoZQ0KZnVuY3Rpb24gcmV0dXJuZWQuICBGb3IgdGFzayBpc29sYXRpb24s
IHdlIG5lZWQgYSBzeW5jaHJvbm91cw0KdmVyc2lvbiBvZiB0aGUgZnVuY3Rpb24gdGhhdCBndWFy
YW50ZWVzIHRoYXQgdGhlIHZtc3RhdCB3b3JrZXINCndpbGwgbm90IHJ1biBvbiB0aGUgY29yZSBv
biByZXR1cm4gZnJvbSB0aGUgZnVuY3Rpb24uICBBZGQgYQ0KcXVpZXRfdm1zdGF0X3N5bmMoKSBm
dW5jdGlvbiB3aXRoIHRoYXQgc2VtYW50aWMuDQoNClNpZ25lZC1vZmYtYnk6IENocmlzIE1ldGNh
bGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IEFsZXggQmVsaXRzIDxh
YmVsaXRzQG1hcnZlbGwuY29tPg0KLS0tDQogaW5jbHVkZS9saW51eC92bXN0YXQuaCB8IDIgKysN
CiBtbS92bXN0YXQuYyAgICAgICAgICAgIHwgOSArKysrKysrKysNCiAyIGZpbGVzIGNoYW5nZWQs
IDExIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvdm1zdGF0Lmgg
Yi9pbmNsdWRlL2xpbnV4L3Ztc3RhdC5oDQppbmRleCAzMjJkY2JmY2M5MzMuLjMwMGNlNjY0ODky
MyAxMDA2NDQNCi0tLSBhL2luY2x1ZGUvbGludXgvdm1zdGF0LmgNCisrKyBiL2luY2x1ZGUvbGlu
dXgvdm1zdGF0LmgNCkBAIC0yODQsNiArMjg0LDcgQEAgZXh0ZXJuIHZvaWQgX19kZWNfem9uZV9z
dGF0ZShzdHJ1Y3Qgem9uZSAqLCBlbnVtIHpvbmVfc3RhdF9pdGVtKTsNCiBleHRlcm4gdm9pZCBf
X2RlY19ub2RlX3N0YXRlKHN0cnVjdCBwZ2xpc3RfZGF0YSAqLCBlbnVtIG5vZGVfc3RhdF9pdGVt
KTsNCiANCiB2b2lkIHF1aWV0X3Ztc3RhdCh2b2lkKTsNCit2b2lkIHF1aWV0X3Ztc3RhdF9zeW5j
KHZvaWQpOw0KIHZvaWQgY3B1X3ZtX3N0YXRzX2ZvbGQoaW50IGNwdSk7DQogdm9pZCByZWZyZXNo
X3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpOw0KIA0KQEAgLTM5MSw2ICszOTIsNyBAQCBzdGF0
aWMgaW5saW5lIHZvaWQgX19kZWNfbm9kZV9wYWdlX3N0YXRlKHN0cnVjdCBwYWdlICpwYWdlLA0K
IHN0YXRpYyBpbmxpbmUgdm9pZCByZWZyZXNoX3pvbmVfc3RhdF90aHJlc2hvbGRzKHZvaWQpIHsg
fQ0KIHN0YXRpYyBpbmxpbmUgdm9pZCBjcHVfdm1fc3RhdHNfZm9sZChpbnQgY3B1KSB7IH0NCiBz
dGF0aWMgaW5saW5lIHZvaWQgcXVpZXRfdm1zdGF0KHZvaWQpIHsgfQ0KK3N0YXRpYyBpbmxpbmUg
dm9pZCBxdWlldF92bXN0YXRfc3luYyh2b2lkKSB7IH0NCiANCiBzdGF0aWMgaW5saW5lIHZvaWQg
ZHJhaW5fem9uZXN0YXQoc3RydWN0IHpvbmUgKnpvbmUsDQogCQkJc3RydWN0IHBlcl9jcHVfcGFn
ZXNldCAqcHNldCkgeyB9DQpkaWZmIC0tZ2l0IGEvbW0vdm1zdGF0LmMgYi9tbS92bXN0YXQuYw0K
aW5kZXggNjk4YmMwYmMxOGQxLi40Mzk5OWNhZjQ3YTQgMTAwNjQ0DQotLS0gYS9tbS92bXN0YXQu
Yw0KKysrIGIvbW0vdm1zdGF0LmMNCkBAIC0xOTM2LDYgKzE5MzYsMTUgQEAgdm9pZCBxdWlldF92
bXN0YXQodm9pZCkNCiAJcmVmcmVzaF9jcHVfdm1fc3RhdHMoZmFsc2UpOw0KIH0NCiANCisvKg0K
KyAqIFN5bmNocm9ub3VzbHkgcXVpZXQgdm1zdGF0IHNvIHRoZSB3b3JrIGlzIGd1YXJhbnRlZWQg
bm90IHRvIHJ1biBvbiByZXR1cm4uDQorICovDQordm9pZCBxdWlldF92bXN0YXRfc3luYyh2b2lk
KQ0KK3sNCisJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKHRoaXNfY3B1X3B0cigmdm1zdGF0X3dv
cmspKTsNCisJcmVmcmVzaF9jcHVfdm1fc3RhdHMoZmFsc2UpOw0KK30NCisNCiAvKg0KICAqIFNo
ZXBoZXJkIHdvcmtlciB0aHJlYWQgdGhhdCBjaGVja3MgdGhlDQogICogZGlmZmVyZW50aWFscyBv
ZiBwcm9jZXNzb3JzIHRoYXQgaGF2ZSB0aGVpciB3b3JrZXINCi0tIA0KMi4yMC4xDQoNCg==
