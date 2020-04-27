Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5389A1BA4F7
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgD0Nl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:41:28 -0400
Received: from mail-mw2nam12on2070.outbound.protection.outlook.com ([40.107.244.70]:26405
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728057AbgD0NlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 09:41:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h6f/IKkPNzsyGecOBcTPPdkIrzojNwDUHIs8GeT8e16DaNZPf/+io4dxKnm2V18pWL0Ig4Wi6v6rAWZAYYLcQEFrME6DR7PdjhQK1g91KnJ4PO9wFqD/ValZYuA2cwhXLapo6rnEC/S3ms5vUyFsZsV1bZdrkt8alb/SvIB8T7B8n3UXNkYrhNsneQsMcIpdKO5RJYk0vAqD5HeESFoEa6fRVUo0ZcJCNB9Sbxr/yRCzhUyDu1vd6mRZiEcuNk0I9rpjycZcKhYNeKfwZnZ58GUTt6KMNKjO+2enO+XPipAeyHPSnUuO5CXSxKJVu1Q8iHCTtv5+9PdkLpnWWtSlkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls12IveF/ET4mH1NJA5R84/E6bI4tj6ugofbKWmst6g=;
 b=FjXz46DJeLygf39RSuVhJBJPJ7i9XLnRZVGZjGYWGuIEO/kB7rpac5GguX0TGmB3l7SIj4CFunsKdtOLIDrKeTvaS5SNME+TDPniUXfciXeZSwB+3VxVwjQsINu596hJMKgbH1FVYJ0Xie0j0UASzMi+BeVXuEG3JzP/BSEDphDuiOC3OPsspQMbxUIZkaB+9aPs2pFBbW3wnlc2jQ8SxAUFblis/FD6qr3/lZ8RFVDloAHxiuA31yH3qbLZ1sew2wyxPPVj2C2onp/PszInYhgXUGNn/Way2NOgWeo6Q2jv6/mipRgQ/ch250g3m+Uht/5F3fjFV5/hTuG3PUr3bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ls12IveF/ET4mH1NJA5R84/E6bI4tj6ugofbKWmst6g=;
 b=OE+laAYx1zVoeLwpuTaFG+TJjgyHLDKHHyFaATSrnnAc6SJSGIFTF4sem2CS5NAaPa0azR8ubvEItTzaElCqWXMw2O4kPIJesx+EmeVBA3zjKnDZjbilhTfBjBQh2MSGxMypS50mECU+g5MOUU4jn9Gp1ugysN/t0E0jXVW00cw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1424.namprd11.prod.outlook.com (2603:10b6:300:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Mon, 27 Apr
 2020 13:41:17 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2937.023; Mon, 27 Apr
 2020 13:41:17 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 07/17] staging: wfx: add an explicit warning when chip detect too high temperature
Date:   Mon, 27 Apr 2020 15:40:21 +0200
Message-Id: <20200427134031.323403-8-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR0P264CA0232.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Mon, 27 Apr 2020 13:41:14 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d7b5a36-3022-45e8-2c9b-08d7eab0a934
X-MS-TrafficTypeDiagnostic: MWHPR11MB1424:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14240DF26FC45D49E26CD52293AF0@MWHPR11MB1424.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 0386B406AA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39850400004)(376002)(346002)(396003)(366004)(8886007)(66476007)(66556008)(4326008)(81156014)(86362001)(8936002)(6486002)(52116002)(6666004)(6506007)(5660300002)(16526019)(6512007)(1076003)(478600001)(8676002)(36756003)(186003)(2616005)(54906003)(107886003)(66574012)(2906002)(316002)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pcNnUOaV36BM1jTS8xlEBIv5aeslHoLXy00PHYUsLYAULeUcbqThiHhJZnBJMOgsHyJ4YgWnk/Pc7sXg1InofviuMXPkJC4Tb+5PU8EtOo+e//ymM91Z09THzOmpf3c+37284SV9aoG9OlgGIi4wj9r/eIt3E9828zh4cqS5Q8x479olOVLfgj+tEFAPwqTdAbt8Kl6a0m2a9XZJAxDNDrjFSo/J2+qMa1imHyIo7o6JI9IRhQ/FVfp30li1aq9uOBWroTwnq23QLdC/UJ0sm2pIYWlV29SgG6b3rMXHQvYY89k1kJhAKYWecv7XR+uUdd0WmCUmvuaC3UkhHgZPRmRQkM3odk6Yv8rWa/jMbuiAM86gxGJZ1XBuCoh2m5wALex3fHRibPkB4oVajRT0R2b0rVMWa93bHxZaSou3ES5LyzOJHhVNQtMvfnVbr2MR
X-MS-Exchange-AntiSpam-MessageData: kfiLR5kjbtrYUfkMQUdsiZ/GyYYlmboWYwR7mk+HJ3KnoX1REOiJmqVCLOZGgLdtgv+hxtRwIjyRjaWWKXRVHbnjjw41Rca/DVfRrqe0Z50mW8qrCB5pcvlI7ppDcAWwdESH7r91PWaE8Vcbv5+EV5Ob+ue0pXZKPRwtX3u5RUK3BCs7qY6se9yIpr+Uanz3WIxCbAsX6DPqrr9BJlOaOeMO8gmQcMLpBdn414neuSBJ5UxoHip87dKYCj3yTyT0F58WTdc30lwGGKxilzCBit82EFkBMaq6WuBWbmjgcFktwI2XDgZE1270iF3DaZvF6WnjpLtKQr7Fb49xLUxZZEUXVJ/UfCSrphNDwcJWfTIAUZeEnL6MntPcz75Xs0BoMj9T3m9URd4qBIUTwPlVfjgfiyG22On3+8yJHsGz4QvxDwPScbVPjLv3bD8Cr3634Fw4AVGBZkOLr4QGNpszesb/vUdxo72NJWxUDn5s8MOTa2wNUlzGaLyM61nK7iezf0MDaJwUsZUY+YbttzWv8oZI4hoPgRg0Leyvu38qcTqovUAUBp1/XRAqCaE0xKkfU27ZwIEr87tVIetZFa0d4hDFUf5rg4vp4+QPd46WdcX32IMjf31PydYfisv7RbqiyVNhvGVXbyJyeDO8CHxexFiauBSO7aDMLc4EReu0psfAW+UrzaeZFIfob+ehbXEn/4SZd/sdWbj/wjQ371XzAGz2oBGvtKw4pFnb9bjoNogeWWmcXJl99Z3y5lmFWPJeqHX4wngdAY0FGzOH9eeMFkxHQyDDptH5ZL1UBvcrvIPYmAZFzshJ+sE933MJlUrZLeK8ljQj5F5Zc+09eDP5h2T4Wo6SEPiPSpRhgWpVzdA=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d7b5a36-3022-45e8-2c9b-08d7eab0a934
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2020 13:41:17.2026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g/FwydEZOkKD8L2Z/5PqdZSCkG5j6ekC9lvh5APibOwXo5J9NpoOIH8E9cq1IoXhLWLA9DO2eM2JjMz+Uy1vJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1424
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRGV2
aWNlIGlzIGFibGUgdG8gbWVhc3VyZSBpdHMgdGVtcGVyYXR1cmUgYW5kIHJhaXNlIHdhcm5pbmcg
d2hlbiB0aGlzCm9uZSBpcyB0b28gaGlnaC4gSWYgdGhlIHRoZSB0ZW1wZXJhdHVyZSBpcyBldmVu
IGhpZ2hlciwgdGhlIGNoaXBpcyBhbHNvCmFibGUgdG8gc2VuZCBhbiBlcnJvciBqdXN0IGJlZm9y
ZSB0byBzdG9wIHJlc3BvbmRpbmcuCgpVbnRpbCBub3csIHRoZSBlcnJvciBtZXNzYWdlIHdhcyAi
YXN5bmNocm9ub3VzIGVycm9yOiB1bmtub3duICg2KSIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7Rt
ZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfcnguYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3J4LmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9yeC5jCmluZGV4IDZkZTIxMDEzOWQ4YS4uZTZkYWFjMzZmNWM4IDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvaGlmX3J4LmMKQEAgLTI4MCw2ICsyODAsMTAgQEAgc3RhdGljIGludCBoaWZfZXJyb3Jf
aW5kaWNhdGlvbihzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwKIAkJZGV2X2Vycih3ZGV2LT5kZXYsICJh
c3luY2hyb25vdXMgZXJyb3I6IG91dC1vZi1yYW5nZSBvdmVydm9sdGFnZTogJSMuOHhcbiIsCiAJ
CQkqcFN0YXR1cyk7CiAJCWJyZWFrOworCWNhc2UgSElGX0VSUk9SX09PUl9URU1QRVJBVFVSRToK
KwkJZGV2X2Vycih3ZGV2LT5kZXYsICJhc3luY2hyb25vdXMgZXJyb3I6IG91dC1vZi1yYW5nZSB0
ZW1wZXJhdHVyZTogJSMuOHhcbiIsCisJCQkqcFN0YXR1cyk7CisJCWJyZWFrOwogCWNhc2UgSElG
X0VSUk9SX1BEU19WRVJTSU9OOgogCQlkZXZfZXJyKHdkZXYtPmRldiwKIAkJCSJhc3luY2hyb25v
dXMgZXJyb3I6IHdyb25nIFBEUyBwYXlsb2FkIG9yIHZlcnNpb246ICUjLjh4XG4iLAotLSAKMi4y
Ni4xCgo=
