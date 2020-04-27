Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268431BA52C
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgD0NlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:08 -0400
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:9980
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbgD0NlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=duMt3DXje3M2rE+HihBK8AP9s+XUHe8pIxOdlqxx0HziSfqYleG64RmU52iv7hQ4g8veSipWJ40nm/1vKJnLKX6fuXrgVZeGXqP4b6ta/h6oFx7MoJSF8GiksUiMQ06Kea5FUsvu+yjSRNMU3UJeIJq8KGjMVLqZ8DS9sSlHS+v40xXHMsEObpkDOq2+f6XDidqWq9qu3o/ivGHrEgiBlR+tV+xGGt9qk3Xz4Re6i7GUZiYqZDrbuaJaN9ysaElT3q9YiaZFo2ZvBWk0ZAyO+3EwJMzG3I2RI2Ax295CoX1vOLxWrtAS5ox7uhGL7gBuF6dcUpDVkfh3VPbfKvDeWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPGhlRhQV8LoVCtdI7RwpboNHZqL6bcToiGsJGCk/yk=;
 b=SCXq5+mIbLdIMknmOkj8i3Q6L1qo3MYxhaUmSaXvhQ2PjWr8O8jXhrKxVi1ZjhF8kELuKCHALkBbGugH5dbzBg6RolFJ0ZVOB3pLviJYv5Fkmfp12LLqVUA54wtVMYQaqxqhcGLIL8Xm4uAtheWiApJBLDun/mfIyruN/T2BMX5hqMXnGrRbu2Qhs/CTDESOv4gIyzn6ThdNVxsML/d86k+p2vaOq2bVHnmP3bd27Zlzm+gT6Fja7tsKl7WNbUgI20p+tz2WRQ9LdklZYKBhb1uv8r5iZZFG2MQlhIFFQFpYJNa7u4+8GnRljGSsd9276NrI87CrMR1/mYsgelfqMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPGhlRhQV8LoVCtdI7RwpboNHZqL6bcToiGsJGCk/yk=;
 b=lg3SeNf/vysYQArUz9jmUmsK0oa4V33rgnJBCrp3QkvEO2Yk7XkcJSlTzPFU3oqZZCRH6sHH+btbUVlzv/CQn0YcOGqAZzWGsp+lxTkFOXmTcj7JZQuWIhu0U/g39GpUtXQilXm354nnjlW9NTCJWHpkrmTJJyvB9FmbggXtWqM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:03 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:02 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/17] staging: wfx: change the field chip_frozen into a boolean
Date:   Mon, 27 Apr 2020 15:40:16 +0200
Message-Id: <20200427134031.323403-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
References: <20200427134031.323403-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::28) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:00 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08be903d-4b18-450c-a142-08d7eab0a090
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1424555ED2C247440F04194093AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L53ToBQjJvlKhpNQRoKP+1NhERmTbDHOSxbBT39ZoXgzo8u27hJMdXVPJoaYWXsVRNxiXmIEC/OOqfHB+q7a/zyvUP6Xa2rwID6m6PEwQ6EPzIGpH6wtX+Km0iLJvA0WBqj4SQw65jCobKM/S0L4bwGRQJq53STkBjSEDUf4Ln/zU8D9LtZPs72fdekqZQ78oeTB9zj/4xi7aC4eaP2N7XtdEHtyRGItct69xXATRljo+nW5ZOzFvhNT+HwSDE6PI76u+AbL43SJHiL5ior+gtzwzLBKvxATVczBeGpnsD6Fo6cVdp4mNQVN9beAMU6OvqfgeZM3dFKVCpGYk81urbr9p9Ll8o3zYgtpVqSM9UkarZX/YtPI/EoEpsD9xIgsrmRGoU2oJqKq73PxmzTIxB82YRCywelRuRILPk3hbDt9YHLH4vmuZIpiR5gSlRH/
X-MS-Exchange-AntiSpam-MessageData: prQW5TJgEOafXAx1bEG3Jv/j3LvpuWPZaC/u6jDwVFJOqxI6buRbIqmfHUGasZQBBOa5n3KlBfZTJ/d5t+tR+gOX+Z+CGxoc8kJ+VBA1i167IXHQXFdA4U+mCEgeDkKMw7P5I0YMzAa4A5JAHdDb05vSBcFcIfckwsxNsc2SMA+C2xrF1emx+9Av9NvOai3B6EUy+sW7rgU0ns9jT3KvqoX+TQUiGoMI2tAel41VISZac7Ju+SiIJqrWLGX1M17iCJ5IxTBGZa7ZaNFSpuyY3eZ0YaAXEEPGb30k5IcLCxVbgtZL0f6758Y17gDzJ1j6JqPTR4wbSTJnFfOM8r/vza6cWusfGAG+PqpjbLC+nUqV9FpuSiEzVqXEq86jL70gH/acpVDbiwELIbXyOOT+rqaT8xF+6KkNjlU4XtRtBu2Ni306uEZMOpihYJEjilYcuU0mVACfBU//5fvtnjEkWJq6fR0YZVTKOKXKJAD5cEDNNGi5iiG5BsATuqnO83Uk2gRIjv9I7TX7x1tDvTm3KOBEfy3QP6MCze0w2xyZoNVQ9H5HlGS4sARklalvNgGa9d2h2FM+kag5kKT1UsBC6PQGZhitFKQ3kDq3b8t1ckshq67e8Dv+B1couubOAXWnpRyFBFz2YB4/KhrRd7QmW/LqJaY/aJ3EXSoPZ7Vs9F2t482Wy1ZqW5I3VSjvssJlLyHnE4rncXEFB4IXwMch4AJOc2oKI4gWJ0sDkZ3RwNl5a/2ST8rX8qOk+Ehidl1np3oPyqNukZqiaARfwyXiDNHqe8K+KwmmhqVt2x+HRe1yIGw6OVODeRCdPlDrJcrKd6ilTkQDaORahq0QswlGiLoDUXeRpCVTOcPX+dnLgf4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08be903d-4b18-450c-a142-08d7eab0a090
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:02.7210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YVQn3ZzTd9FhLgwE+w9KESby9ls8/l2ynWnASRqOnZsvdc8yrKK8quY+F6B5JH4pfYtg+FZ68jkaRjpapM2RPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGZpZWxkIGNoaXBfZnJvemVuIGlzIGRlY2xhcmVkIGFzIGFuIGludGVnZXIsIGJ1dCBpdCBpcyBv
bmx5IHVzZWQgYXMKYSBib29sZWFuLiBTbywgY29udmVydCBpdCBpbnRvIGEgYm9vbGVhbi4KClNp
Z25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNv
bT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jIHwgMiArLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfdHguYyB8IDIgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAgfCAy
ICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oICAgIHwgMiArLQogNCBmaWxlcyBjaGFuZ2Vk
LCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfcnguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMKaW5kZXgg
YjhkNTcwMjU2NDk4Li5iNTYxMzhmZWYwYmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3J4LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfcnguYwpAQCAtMzE2LDcg
KzMxNiw3IEBAIHN0YXRpYyBpbnQgaGlmX2V4Y2VwdGlvbl9pbmRpY2F0aW9uKHN0cnVjdCB3Znhf
ZGV2ICp3ZGV2LAogCiAJZGV2X2Vycih3ZGV2LT5kZXYsICJmaXJtd2FyZSBleGNlcHRpb25cbiIp
OwogCXByaW50X2hleF9kdW1wX2J5dGVzKCJEdW1wOiAiLCBEVU1QX1BSRUZJWF9OT05FLCBidWYs
IGxlbik7Ci0Jd2Rldi0+Y2hpcF9mcm96ZW4gPSAxOworCXdkZXYtPmNoaXBfZnJvemVuID0gdHJ1
ZTsKIAogCXJldHVybiAtMTsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCmluZGV4IDE3NzIxY2Y5ZTJhMy4u
ZThmM2M1ZjljZTdiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAgLTkxLDcgKzkxLDcgQEAgaW50IHdm
eF9jbWRfc2VuZChzdHJ1Y3Qgd2Z4X2RldiAqd2Rldiwgc3RydWN0IGhpZl9tc2cgKnJlcXVlc3Qs
IHZvaWQgKnJlcGx5LAogCWlmICghcmV0KSB7CiAJCWRldl9lcnIod2Rldi0+ZGV2LCAiY2hpcCBk
aWQgbm90IGFuc3dlclxuIik7CiAJCXdmeF9wZW5kaW5nX2R1bXBfb2xkX2ZyYW1lcyh3ZGV2LCAz
MDAwKTsKLQkJd2Rldi0+Y2hpcF9mcm96ZW4gPSAxOworCQl3ZGV2LT5jaGlwX2Zyb3plbiA9IHRy
dWU7CiAJCXJlaW5pdF9jb21wbGV0aW9uKCZ3ZGV2LT5oaWZfY21kLmRvbmUpOwogCQlyZXQgPSAt
RVRJTUVET1VUOwogCX0gZWxzZSB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggMmY2ZjlmYWYxNWJlLi4w
Yzc5OWNlZGQxMDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTUyLDcgKzUyLDcgQEAgdm9pZCB3Znhf
dHhfZmx1c2goc3RydWN0IHdmeF9kZXYgKndkZXYpCiAJCQkgd2Rldi0+aGlmLnR4X2J1ZmZlcnNf
dXNlZCk7CiAJCXdmeF9wZW5kaW5nX2R1bXBfb2xkX2ZyYW1lcyh3ZGV2LCAzMDAwKTsKIAkJLy8g
RklYTUU6IGRyb3AgcGVuZGluZyBmcmFtZXMgaGVyZQotCQl3ZGV2LT5jaGlwX2Zyb3plbiA9IDE7
CisJCXdkZXYtPmNoaXBfZnJvemVuID0gdHJ1ZTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5o
aWZfY21kLmxvY2spOwogCXdmeF90eF91bmxvY2sod2Rldik7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCA3MDZl
OTVjZDEwOTIuLjc3YmI2YzYxNzU0NiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93
ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC00NSw3ICs0NSw3IEBAIHN0
cnVjdCB3ZnhfZGV2IHsKIAlzdHJ1Y3QgaGlmX2luZF9zdGFydHVwCWh3X2NhcHM7CiAJc3RydWN0
IHdmeF9oaWYJCWhpZjsKIAlzdHJ1Y3Qgc2xfY29udGV4dAlzbDsKLQlpbnQJCQljaGlwX2Zyb3pl
bjsKKwlib29sCQkJY2hpcF9mcm96ZW47CiAJc3RydWN0IG11dGV4CQljb25mX211dGV4OwogCiAJ
c3RydWN0IHdmeF9oaWZfY21kCWhpZl9jbWQ7Ci0tIAoyLjI2LjEKCg==
