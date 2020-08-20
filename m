Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D7424C2D7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgHTQCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:02:44 -0400
Received: from mail-dm6nam12on2046.outbound.protection.outlook.com ([40.107.243.46]:36576
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729553AbgHTQAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 12:00:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HJEqEOcHOIqDqsmTY7E+ERklFLIgc+Tg7h0ObsyVFwOYPv8CPy2Xd8U20vbM05/SomHep+bUqWk4MWXQ23YfZ8NpicIGl0n+9Fe73iE6jYeX0P3B3p8yk1sSblEMovY7BFGFJkmtfmK4lufqObhlnfRLLjcI69Ht45k3/zwTdAP5jNex0wm9SRqYw/PPJXQUZJAwhFzWvWX4NgOOxr/KCltFvJ5hyvGuGLDJxvuAJaM2CcgYROF+7spn8gw4WA3CThg21VoL9JY0nIjQlewigpGSCBiEzJL0k6JEmxfxtnB9cCnSkFZjJKPOjf9tXgOI5PCHv17b8va3Ofm7YGidZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpyoGU4FzcSEiHvu1sHhSwYfCgw6bHk1zKFXGBQ+uEE=;
 b=CRZ3i9ibV5SqTMB3SOb2WSsfnB0elm4Vpi+8/E5WyctVTwoEutNYOSvOnrT0P8Hx3gOwNoHu8djg8F+kbDtj/GJbiJiTx2YRI6H+zJmVRLbjWPa3dC5+lMf+vrHtoQpGpB4TPf7OG4SuKVy06NQxWCuAnjLzndLZdIDoyjXPLWv+JmDB4U27G+N5wSVzD7POwIypMJTYHA30MosWA6vFDQY2o1ZvyRo/aPCyfPv4LboB4yALKdgP0YIGIevmtgkJ7jqCdVuH0R7Bnah/Wg/5X8tKMsWBAyzlW9tJ0Cq6hffVyUE+AmVFGMvx/Mz8687tGPmArK/1HWoUd/ykRm3PLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpyoGU4FzcSEiHvu1sHhSwYfCgw6bHk1zKFXGBQ+uEE=;
 b=FExzpL0nxZVFIekvyd9j0UumrM5jJizJiNYdGSt7dA+1ZeFehqM91dXenWnTHn9DEEjh3+VoXFhgRCtEMo8UAMD/fVv4r1dJsbPqVrkWO+mEfrxMrrmKvfgbb0h4UoB+rKukXPrXqs+0DYK8W2yg126yaop3AW+GZCTQxCpB5FI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4541.namprd11.prod.outlook.com (2603:10b6:806:94::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 15:59:36 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3305.026; Thu, 20 Aug 2020
 15:59:36 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/12] staging: wfx: scan while AP is supported
Date:   Thu, 20 Aug 2020 17:58:55 +0200
Message-Id: <20200820155858.351292-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::14) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by PR0P264CA0122.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 15:59:35 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe2c4bb8-49ea-4d45-d954-08d84522099f
X-MS-TrafficTypeDiagnostic: SA0PR11MB4541:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4541F0C024EC14113E0E67EA935A0@SA0PR11MB4541.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpPhfUaySdeMUwWO/1z5SLf7UvffPqmAeRibJgpoVUYZCX2+QxTC0LJJW2UACfT3Xkv/igGGhCfr26tUWbHnFU9/DvHEfxYIhEJp1zkYHrWZVnglEZ3X5WEzxbRSpyolSnEc8tp9tnilNsTs1E/gx0DX1NMnu61q1OPPK7+bvU8fV6Z5ErDeWiU68cjIQF3nDcrUlIor0X7658Ba7m+1TN/Ok+Ndu0lWzPWr/NtD3LU09Iuyi9/IEsDibyPY/6baPJwsbwdxZDQPZpUn7AqbYakEIU/iU8YSPZegpJsnQe8QWS2IJqPUnfNUBB9fKDBR9uCvW/7RgBffL+ECGvbAulErFy+slQwT8egzfOC9FK8HotdSjmLurrgmhIzj3eIV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39850400004)(366004)(346002)(136003)(186003)(6666004)(2906002)(8676002)(316002)(16576012)(54906003)(956004)(26005)(66574015)(8936002)(2616005)(110011004)(52116002)(83380400001)(107886003)(1076003)(5660300002)(478600001)(36756003)(4326008)(66476007)(66556008)(66946007)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zq6AaBHPIMcS6+nvywatWBeOD7RVbiL3M8TYITeFcxzNDvYCeGkt5FAfb5wgDkNL++WEx7Bz4Yol5tTbqRCbTA2jzIiXofminMVSqfrXjcHt7h/HRsnMr6lrgoz9kUtnHSQ91ZEcq83Kd8BiTeFEuiiFYmjEE7OcfecdhosaTu8N4wMdL32zBfKKrAi/EtHu/ksTgqIhypDzVnduybvgNQuliSQHqgWiTb8TuSanUkmxVqOMGbiav4eRu0lwuojKkbGN+Nf1G/ItxOp6vyk8+poApxY+b/buzlIlVTxbPBYw0uCCK9W9hPHATanTGx/roM2m/hqlWCBdZEP2S/KLVyznWUITpZvRXfaZ81geKrjPhnNHxHnrEiHy19EuWhESo5HZYTFOc2ESCL/rgwU+sQPRx0Wde33/IF3e0gdhiJ14ncQbhr58pmOBn4U2HJpElRpbPx3kTJ0FHs6HaUDzp+14+8yyi/K3hmVHyA0pNXMwi5kvfcnDpRp2scax0lRiEwv6T/FDUV8E+W46Y/yzZMRD/Y8ucIivo7FBfCl1xb/OFNJbOefR6BU0jxXhfdrzU7QNYq3GeBRRXBHNBa4SOGt5cKMAGlPG7oLCSzsrMLCEBNMuvOKRoKhhRu2GAOrd0UuX1CpMmEadokKc97nUSg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe2c4bb8-49ea-4d45-d954-08d84522099f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 15:59:36.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1b0sIAjJoHK5/9k7ajTYc6sb8YMAVWGwSoKg42nzUYZyE08mzhpR6DF8i008y4vv64XLALOzgHcxrdLakG2GNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRldmljZSBpcyBhYmxlIHRvIHNjYW4gd2hpbGUgcnVubmluZyBhbiBBY2Nlc3MgUG9pbnQuIEp1
c3QgZGVjbGFyZQppdC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8IDEg
KwogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA0IC0tLS0KIDIgZmlsZXMgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9tYWluLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCA0MjYzZjkx
Mjc2MGIuLjVhMzAxOGUxNDQ0NSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWlu
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKQEAgLTI4Miw2ICsyODIsNyBAQCBz
dHJ1Y3Qgd2Z4X2RldiAqd2Z4X2luaXRfY29tbW9uKHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJCQkJ
Tkw4MDIxMV9QUk9CRV9SRVNQX09GRkxPQURfU1VQUE9SVF9XUFMyIHwKIAkJCQkJTkw4MDIxMV9Q
Uk9CRV9SRVNQX09GRkxPQURfU1VQUE9SVF9QMlAgfAogCQkJCQlOTDgwMjExX1BST0JFX1JFU1Bf
T0ZGTE9BRF9TVVBQT1JUXzgwMjExVTsKKwlody0+d2lwaHktPmZlYXR1cmVzIHw9IE5MODAyMTFf
RkVBVFVSRV9BUF9TQ0FOOwogCWh3LT53aXBoeS0+ZmxhZ3MgfD0gV0lQSFlfRkxBR19BUF9QUk9C
RV9SRVNQX09GRkxPQUQ7CiAJaHctPndpcGh5LT5mbGFncyB8PSBXSVBIWV9GTEFHX0FQX1VBUFNE
OwogCWh3LT53aXBoeS0+ZmxhZ3MgJj0gfldJUEhZX0ZMQUdfUFNfT05fQllfREVGQVVMVDsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zY2FuLmMKaW5kZXggZTlkZTE5Nzg0ODY1Li4wMmQ0ZTY1M2Q1OTQgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5j
CkBAIC0xMTMsMTAgKzExMyw2IEBAIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9
IChzdHJ1Y3Qgd2Z4X3ZpZiAqKXZpZi0+ZHJ2X3ByaXY7CiAKIAlXQVJOX09OKGh3X3JlcS0+cmVx
Lm5fY2hhbm5lbHMgPiBISUZfQVBJX01BWF9OQl9DSEFOTkVMUyk7Ci0KLQlpZiAodmlmLT50eXBl
ID09IE5MODAyMTFfSUZUWVBFX0FQKQotCQlyZXR1cm4gLUVPUE5PVFNVUFA7Ci0KIAl3dmlmLT5z
Y2FuX3JlcSA9IGh3X3JlcTsKIAlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zY2FuX3dvcmspOwogCXJl
dHVybiAwOwotLSAKMi4yOC4wCgo=
