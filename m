Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2396825F798
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgIGKQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:16:43 -0400
Received: from mail-eopbgr770081.outbound.protection.outlook.com ([40.107.77.81]:21675
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728741AbgIGKQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:16:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLafFf/gXXrqzGzuGcG3simyjFjf1k+A+4ZPVZShH5s181be7aqeENHHekj8DXBSnN38pGATzVnUM6l3o7h2kquNf8jznLWv+oGzkdGKx62SlW39TdxH8+OtMi2FAAXBXU3eTIWUEe+eiMwkKy96ivF1s6Sd/0jVuLTugwktSyQXHkf3mTMe/akNwF2/PRqkjMjOaZTCpTy87pwD73aiZ7VFQGNGDdM3RafwEytan3AO7pqUYDadiJcWAsPZmuryPKL/IL88tMhjg3ajpHiWVmTRvILAxb55iLz8uuaCddQP/Ujd9wCSQu3vF0dAtCXWLP2PrzXJ3YnyF6cvO56l/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYDK+4n3lVRV+3X4FSxbCFv4F3eKWdbh6ZIPIgKPxZM=;
 b=IkghpV38k7q4SsANJ7MED0ocZSS6yqAk2IbZ21Uk8Ul7H24ZfjyPJqB/t8yXHkaARbfuki65/zbiky5peUCXojZbpT+dT5lorKTBgPCuWtNcHNzkYqgIzh/lY1/AHk8D2+L1pxkRIlYZGsApvZ2oqEuLDRalPQFlYdG7A/tVBdw3mHkpANhOeJHYKynLQ+bjohGttFNwFwx2hFgzh4Vtgbe8FmxPI+1ixARrsYMox8UL41hsg95G+s0pcIZDgCirDIPE0CCK4y3oeAtmEe6IuEFiFaHbrLagXMwXgTZv/iIRSZec1Db/CrusuaVj69pmIK6IjJ8Q21j7QndeOszQsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kYDK+4n3lVRV+3X4FSxbCFv4F3eKWdbh6ZIPIgKPxZM=;
 b=fNgmVdmX7Pi4tbpK5zy5zJV7Y7xr6ZTpSMVNtDzzuSKTE3vnHaHWkVY1R1Zp8iDl9Y1reH+2xOtWlEOq09Byh8nUL92itwFJMFuzf0sqJt6C1mnYEIymt2IFjmnpvFmM0WAmpd4x60A2pxmLqXxHQT+FNKtAxun/+oVMr4nBoQY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2606.namprd11.prod.outlook.com (2603:10b6:805:55::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17; Mon, 7 Sep
 2020 10:16:07 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:07 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 14/31] staging: wfx: drop useless struct hif_map_link_flags
Date:   Mon,  7 Sep 2020 12:15:04 +0200
Message-Id: <20200907101521.66082-15-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
References: <20200907101521.66082-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::25) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:06 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3cc4816-f727-47f3-eef3-08d85317090c
X-MS-TrafficTypeDiagnostic: SN6PR11MB2606:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2606872E2CB3E1FDE1422D7693280@SN6PR11MB2606.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qz19+Cs7gHpmcZFvbWo4VwaojBm4JpEZtLjlnw5BCjdwSjxx6yN4iztjTxOY4gQvoFzzC7bQEJtDy236bQcxDbW9CasYsGII1u99ZULZvUL2oKKBqiimeejOLgFO7oKysmJ9uk1OKPzY61HVFt2lKIZeuPXzeJkTOshTOBUCYcaKOBXAZDo/sN8K/0BxGhQ3wgX06zMxC9aNGziBRf169cxBJrmMYzN8K79PAXLRMILZ4rwH8ajI71yz8mGA3JGscQb/QroSJEj7JIPaY4Py9A0+qR9HkykOS9HNx8ML+J/0NnLrMBTa1DX8KOnGL4APZjMwrzuT/5ywwX64IaySwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(366004)(136003)(39850400004)(66946007)(4326008)(5660300002)(2616005)(66476007)(316002)(956004)(478600001)(54906003)(52116002)(2906002)(66556008)(1076003)(36756003)(8676002)(86362001)(6486002)(8936002)(7696005)(66574015)(83380400001)(26005)(107886003)(16526019)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UNaVLDRXJlT96RPr3bslParBZv8RUyZtEt7sSPlQAW/O5ujEgvyUuJbarrpsews4xCziXgBj7VN6tSAgP8/CmpSjgJzkHiJFwQEnRrJ+af7eFhy+5EFZ2jaFgmblBd8Ze1Bl2CwqmPHQcljuzAS47teD0HEh5SKziklREV0NQLwqFXpxP9YDe+1zQ+qbKDlEkJjC6tDw1ijpyGeqL5ng2cm8UcLwO0hn73/8lr8aZj6x6Cuwub73wJfvmEbzmpWmj17SM9Vxht7c1RWRQqCdBQzOtEcMY4pWl+2KNRDrTll4iZS00O/zzGvnODegxDsA9bvKYYaQyk75Su0tGrGVo7ffyIcalreRUfCgSwrHBruBFQzwBNfqsSPxaQGro70RMi5HY0fmMLy5GKPNWQ8yIQStymjuaAsLgxtQqWQaVXw53BXfRBJb0TSfxAq/fZs8eBzeTdko4hjanDW/Ifbkw5JQcAR7Xy176TcS1Bizl9wTzrMDPj3kYEPs1lhTWSyp1fohbNnp1CaaLd5qTBrSfStmmRWGgtuGBc+Vl3ogPpjr/uwtXBy2GHj6F+Vxkh9S+Xq7gwvbefjdR6D20hbPZZb53zTAwl/dofh4Mgnvywj769Nm5MipDIME83Hz+YjEYUeqtrGvoQAiZnWMXLRa7Q==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3cc4816-f727-47f3-eef3-08d85317090c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:07.5749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +toXlm85eX9lv+JzoXVsrSyJbC2LfOknRaajI7O79r2IK2hPmhp1bi3tGWMRVWIioAhOFm9bJIxVV0JMYY5rlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2606
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU3Ry
dWN0IGhpZl9tYXBfbGlua19mbGFncyBoYXMgbm8gcmVhc29uIHRvIGV4aXN0LiBEcm9wIGl0IGFu
ZCBzaW1wbGlmeQphY2Nlc3MgdG8gc3RydWN0IGhpZl9yZXFfbWFwX2xpbmsuCgpBbHNvIHJlbmFt
ZSB0aGUgZmllbGQgJ21hcF9kaXJlY3Rpb24nIGluICd1bm1hcCcuIEl0IGlzIG1vcmUKbWVhbmlu
Z2Z1bCBhbmQgYWxsb3dzIHRvIGRyb3AgZW51bSBoaWZfc3RhX21hcF9kaXJlY3Rpb24uCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIHwgMTUgKysrLS0tLS0tLS0t
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICAgfCAgNCArKy0tCiAyIGZpbGVz
IGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9o
aWZfYXBpX2NtZC5oCmluZGV4IDg5NWYyNmQ5ZjFhMi4uZjg2ZjZkNDkxZmIyIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX2NtZC5oCkBAIC00MzQsMjAgKzQzNCwxMSBAQCBzdHJ1Y3QgaGlmX2NuZl9i
ZWFjb25fdHJhbnNtaXQgewogI2RlZmluZSBISUZfTElOS19JRF9NQVggICAgICAgICAgICAxNAog
I2RlZmluZSBISUZfTElOS19JRF9OT1RfQVNTT0NJQVRFRCAoSElGX0xJTktfSURfTUFYICsgMSkK
IAotZW51bSBoaWZfc3RhX21hcF9kaXJlY3Rpb24gewotCUhJRl9TVEFfTUFQICAgICAgICAgICAg
ICAgICAgICAgICA9IDB4MCwKLQlISUZfU1RBX1VOTUFQICAgICAgICAgICAgICAgICAgICAgPSAw
eDEKLX07Ci0KLXN0cnVjdCBoaWZfbWFwX2xpbmtfZmxhZ3MgewotCXU4ICAgICBtYXBfZGlyZWN0
aW9uOjE7Ci0JdTggICAgIG1mcGM6MTsKLQl1OCAgICAgcmVzZXJ2ZWQ6NjsKLX0gX19wYWNrZWQ7
Ci0KIHN0cnVjdCBoaWZfcmVxX21hcF9saW5rIHsKIAl1OCAgICAgbWFjX2FkZHJbRVRIX0FMRU5d
OwotCXN0cnVjdCBoaWZfbWFwX2xpbmtfZmxhZ3MgbWFwX2xpbmtfZmxhZ3M7CisJdTggICAgIHVu
bWFwOjE7CisJdTggICAgIG1mcGM6MTsKKwl1OCAgICAgcmVzZXJ2ZWQ6NjsKIAl1OCAgICAgcGVl
cl9zdGFfaWQ7CiB9IF9fcGFja2VkOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCA0OTUyM2U3MGFm
NmMuLmVkZGI2MGRlYzA2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHgu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC01MDIsOCArNTAyLDggQEAg
aW50IGhpZl9tYXBfbGluayhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCB1bm1hcCwgdTggKm1h
Y19hZGRyLCBpbnQgc3RhX2lkLCBib28KIAkJcmV0dXJuIC1FTk9NRU07CiAJaWYgKG1hY19hZGRy
KQogCQlldGhlcl9hZGRyX2NvcHkoYm9keS0+bWFjX2FkZHIsIG1hY19hZGRyKTsKLQlib2R5LT5t
YXBfbGlua19mbGFncy5tZnBjID0gbWZwID8gMSA6IDA7Ci0JYm9keS0+bWFwX2xpbmtfZmxhZ3Mu
bWFwX2RpcmVjdGlvbiA9IHVubWFwID8gMSA6IDA7CisJYm9keS0+bWZwYyA9IG1mcCA/IDEgOiAw
OworCWJvZHktPnVubWFwID0gdW5tYXAgPyAxIDogMDsKIAlib2R5LT5wZWVyX3N0YV9pZCA9IHN0
YV9pZDsKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9NQVBfTElO
Sywgc2l6ZW9mKCpib2R5KSk7CiAJcmV0ID0gd2Z4X2NtZF9zZW5kKHd2aWYtPndkZXYsIGhpZiwg
TlVMTCwgMCwgZmFsc2UpOwotLSAKMi4yOC4wCgo=
