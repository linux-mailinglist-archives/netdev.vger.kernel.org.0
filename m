Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C811D4877
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgEOIen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:43 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:6138
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728305AbgEOIek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dN0uEAiJ+AFyi7SNEb6yH/0LGVsHyi8/A65N9Mz6jKJ3XiWqHdoj0fCkMCTlNRKHg/30W7NwizRd/SITPbUOT5Uaoj8QyYlmVsCwkyoddatuvrqFH99YigiNlszILLnCE5OfFHVImDIQocLYX9t7fkVRVcNoWiWEuYxMB2ggCIs3k5lOnedw3fVtzv03CyTkRQE9DADH+Vo+9QVedXRLlan5xser40gzvLsVsK34RzuKeGSn5Ru7ILzzsxiQLsr5LcK8rjrZCf4kgXPANgOgx9iFHMQvujoR0oXSmqg3y1m5mnKN8KGdVts9CMHCNpmFgWylsZWhqTE8c8hDdB38xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiN9WqBvuXb/S5iY+mscQrScVRKkiyxt6itUyF7ulLk=;
 b=lAgjcxPs3ls95LJO4rDxADmTMGC/phEpccOlsx8cxMWUIV84rNdKySmQ7x+WR9N42dCQ7J94sZz59n5Xg6aDbIBU8k83B3grPT1OSVFFPw7PCx5gyPKsBXX73gAPvlvU57M0dbM5+NGk8legaZIrfv2Kknw3VwuqlYAng86uNqI8Fv1eeuSB8gPPA2kCjIWTu3Ndhje8jFCUmXb4WXffTh3zFv7Fntecq9vxgyohSPqzeCMj6Mor/sonUWt/w8Gjcwkn4wTHCutlZzKK3gwtq6sGh7uacQyqFv/J+jNa2PeqtFIMCh3PDF+B24yYcWjXAefH1rOnlfYWhY3XX3JokQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiN9WqBvuXb/S5iY+mscQrScVRKkiyxt6itUyF7ulLk=;
 b=KyPr5+EbEwMTxL/c0JdjnQal3c9T3umvMnCP35XkAARbepAq1dh6DtmwVnQCJ8uGdWkTw5dJhtsmdRuVo4or3qMQ4How/x9nCEC/Kodn9gRKm/Ki2s0VcbDp6F5KiLf0lEQU5zcdU5LmwjUthLA904ODM1wk18jnWm4nF2DI4KM=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:24 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:34:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 19/19] staging: wfx: remove false positive warning
Date:   Fri, 15 May 2020 10:33:25 +0200
Message-Id: <20200515083325.378539-20-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:34:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d091337-e80d-4f96-bd4c-08d7f8aac5e2
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1310A944230BE29A3DD14D3893BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:49;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QGf/ub8g2yeGcCyJAZTcAemvIsLz3nSSRPKRRAQrevK09oUrmeC9xBqlok0r09wE/RXL1KhhdJs6f4glJpQSvzdpOcSEwF5DkWvGxgG+6s/tOr6grnjB75j6mmmZlTNs7oXqePtdCPnvzPOxrf3kn2qw2vGacAy5EBHV5i4ud3VQGytWvBU4l8joideGDVfaswgf5Nxpg9QwgN22kHssnejlCEC3QYsAiwJhBadsJkPaYXhRGJtJU4VWAGHBIxnL5O+UsKTHQS6iSDkL498IOeLG6iXwHgeVALo9y2XRnTN7vBFBFUtEIBdppTqxTXF1rCJUgrSmtcUUyOjTl9ZL8RHJT/5ojDZzM3D1eF5q9boeubj+BylgqsjaOShzLHARBmjyDk9B1lxznLG06Lc39uWm/+fNyVR8GQOAC4B6lya/s2DQYpTZPHusoquAwciZqvsWdQQlimYeFOcS4TteLzBI9/15AlcWuUbfc/NptFQ1xZppxopq7OFLXzgkMEH7TU0lb+2XM8hRCbpPiEoO1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(66946007)(966005)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(54906003)(2906002)(2616005)(478600001)(66574014)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: inATRghY4H5F+9Uql+MFY9jp0zrfEjwg5vqDQX2REFya+vuBcJaRBdTb3STcsxs3DpQI9GqDeTm54b472G0xVcp6F2riKUW5kvv7sZ5ViBBXTqDcUMURTvvS58B80Qd8fNN6ajaLykmYwPV2/bUPwtI4C/LFOgnGGvEdDIAzZxfWp99x/f6kXTTvlox4b6TCeQQwYD6lwWuNaBa2LNc3rwzprTTb/JYkiSOQ5qnw6iostwy820SMk43VbfJgelyuoJ5hTuaxh/lu4Oa1ycSYgSO4FkoEFZyF+0b/WPtgS0gXygZ0zavLrgN9qYJpLDdViFGcp7J3dRddnvSGfbXB6+5yUEGGJ/3GVfOlItc87yneRuuCCGJk4UkT8w//TSr7D450EEYr++3oggr78pXSuaLrbe0mjwIm7W01qRs1/gdOhsgAfX85nsc452eyCokpjSgI6cHAOBn/4Vv6JFqZKgiOUIKRNrVCUOiDwAeWgpw=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d091337-e80d-4f96-bd4c-08d7f8aac5e2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:34:24.5324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iu7dcBhK39srP+ZAcb6AqKAL9M7vfKlQ2yyZ29kLU4QRMkcJ3KwVZ83ZdZBx+VT/qUt5HEVQ4MTwwpyfScsoaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBhIHN0YXRpb24gaXMgcmVtb3ZlZCwgdGhlIGRyaXZlciBjaGVjayB0aGF0IGFsbCB0aGUgVHgg
ZnJhbWVzIHdlcmUKY29ycmVjdGx5IHNlbnQuIEhvd2V2ZXIsIHRoZSBzdGF0aW9uIGNhbiBiZSBy
ZW1vdmVkIGJlZm9yZSBhbGwgdGhlIFR4CmZyYW1lcyB3ZXJlIGFja25vd2xlZGdlZCBhbmQgYSBm
YWxzZSBwb3NpdGl2ZSB3YXJuaW5nIGNhbiBiZSBlbWl0dGVkLgoKVGhlIHByZXZpb3VzIGNvbW1p
dCBoYXMgYWRkZWQgYSB0cmFjZSB3aGVuIGRyaXZlciByZWNlaXZlZCBhbgphY2tub3dsZWRnZSBm
b3IgYSBub24tZXhpc3RlbnQgc3RhdGlvbi4gSXQgYXBwZWFyIHRoYXQgdGhlc2UgZXZlbnRzCmFy
ZSBwZXJmZWN0bHkgY29ycmVsYXRlZCBhbmQgdGhlcmUgaXMgbm8gbGVhay4KCk5vdywgdGhlIHN1
YmplY3QgaXMgcGVyZmVjdGx5IHVuZGVyc3Rvb2QuIFJlbW92ZSB0aGUgd2FybmluZy4gSnVzdCBr
ZWVwCmEgZGVidWcgdHJhY2UgaW4gY2FzZSB3ZSBoYXZlIGFueSBkb3VidCBpbiB0aGUgZnV0dXJl
LgoKSW4gdGhlIHBhc3QsIHRoZSBzdWJqZWN0IGhhcyBhbHJlYWR5IGJlZW4gZGlzY3Vzc2VkIGhl
cmU6CiAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2RyaXZlcmRldi1kZXZlbC82Mjg3OTI0Lmdo
R0ZVTWszT0RAcGMtNDIvCgpGaXhlczogNGJiYzZhM2U3YWQwICgic3RhZ2luZzogd2Z4OiBtYWtl
IHdhcm5pbmcgYWJvdXQgcGVuZGluZyBmcmFtZSBsZXNzIHNjYXJ5IikKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgfCA2ICsrKystLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBmNDQ4OTU3YzFhOTIuLjYw
MTVjZDJjNGQ4YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00NDEsOCArNDQxLDEwIEBAIGludCB3Znhfc3Rh
X3JlbW92ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZp
ZiwKIAogCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHN0YV9wcml2LT5idWZmZXJlZCk7IGkr
KykKIAkJaWYgKHN0YV9wcml2LT5idWZmZXJlZFtpXSkKLQkJCWRldl93YXJuKHd2aWYtPndkZXYt
PmRldiwgInJlbGVhc2Ugc3RhdGlvbiB3aGlsZSAlZCBwZW5kaW5nIGZyYW1lIG9uIHF1ZXVlICVk
IiwKLQkJCQkgc3RhX3ByaXYtPmJ1ZmZlcmVkW2ldLCBpKTsKKwkJCS8vIE5vdCBhbiBlcnJvciBp
ZiBwYWlyZWQgd2l0aCB0cmFjZSBpbgorCQkJLy8gd2Z4X3R4X3VwZGF0ZV9zdGEoKQorCQkJZGV2
X2RiZyh3dmlmLT53ZGV2LT5kZXYsICJyZWxlYXNlIHN0YXRpb24gd2hpbGUgJWQgcGVuZGluZyBm
cmFtZSBvbiBxdWV1ZSAlZCIsCisJCQkJc3RhX3ByaXYtPmJ1ZmZlcmVkW2ldLCBpKTsKIAkvLyBT
ZWUgbm90ZSBpbiB3Znhfc3RhX2FkZCgpCiAJaWYgKCFzdGFfcHJpdi0+bGlua19pZCkKIAkJcmV0
dXJuIDA7Ci0tIAoyLjI2LjIKCg==
