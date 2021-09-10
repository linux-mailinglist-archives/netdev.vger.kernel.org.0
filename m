Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF6D406F0D
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhIJQLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:00 -0400
Received: from mail-mw2nam10on2043.outbound.protection.outlook.com ([40.107.94.43]:53728
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233046AbhIJQI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OduPl0D7kMXbdJNNRfoYkm8I0e78mQPuoww36fjIex7NcBvBRXLx8t/rbwDHfCOz9bsIh5oF34Yw5RUukkDmBBL/AC8sJWPiCOTyoIqaxP58PgxBy76W+p9u/BGg9M5as9zwJox3yVqmDAlm2wsu+YvbD8TBihsapK9vPFh8B9qkWhII3vZOHlBD2VzaKMs5+C62G8feokPjb67wBoaBgB+x2sRpn5vHJmpgYyM0N5cSsWr+hwQ0Uq//KqOwoqi0aL3nAl5OWWY8H4mLPZNQV86zmaC7ia1Dd+GC8+ccZFZVaapLcN+m2zvRtmdsDZUc6dcXNmM7B0gtnUzEBBMvTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/9CXAv3pbajm4uAipmOpsP1Jb6a/7Ntio8z4lp4096o=;
 b=iCMG8iXmaPPyifJ5fOR3+7tmoMYcjdYoi0CWlxSEEt10njdyPJNhXrYRFhruExC5cZoiKzJPKe3ZXh+Kt+/uoplG8kNlWmgBUu0Z8QvRHiQj/JA7C2xo6Kj1MIyVjERZTm0C0N5uCDl9ruWDO5CoUS2wHa297wdxoiiYBrcslSpXnk5dZ6F7nn7hpAl11HkvTftCfc+LmqPCYb4qp/Jhm3LG+61yv4O5vognr50sdJouBwC6ieO18GQJGON+14ikMOPaOp6Uuta4yy0WEkJfx1IauZiAkShTIMiFGog99vfp+KAL0wQ9z1aiHbeNzu6ma+hTtmHF1oP03jLY/ROXUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9CXAv3pbajm4uAipmOpsP1Jb6a/7Ntio8z4lp4096o=;
 b=TkVO/Xu36YfGD3xiMiSSBgoti6EWClWniTGyRQIA4zT7ymN/465gWIlOSJct8v9bLR6UHADnwn7kDAbcgFKhFe7R2Ck2FE2K+Pm9y98VEvoj1zX2zAH0lRYt68pczRceUC0yVmXSwmbXadbVSTV+n5898MbZQrrB6nO0h1I/mVw=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/31] staging: wfx: update with API 3.8
Date:   Fri, 10 Sep 2021 18:04:46 +0200
Message-Id: <20210910160504.1794332-14-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50c2cdf2-b644-469b-4a16-08d97474e049
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB31186D400C1AF21F6D99D3D193D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:206;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RbW0swkWQhz8XvMFt6AWVkgobhs0a/pIkVVU0zJjoqmA00kLciw0G0+6ktUDM7v101pcOQW2HsgmXn2UVaHCTOWcIzCzYngZMo7iFbn+6WHbjB9WZASlJE6Qc4UBlDByH5XxGu3ca6x44w1Hex9V/wUlE5Fitp5my1+AJUuB+faftgT24+DP20WBgcdet7tUPguohMKHDiMuA6mEUSmfR3icoKsf7JFJu3gjvPZFFZ9+w/zbjn5X9JcJg0wisBYh/bI1uQZqAx9cEryZz5vNQdh38jq0DR95qA9iQYC/WPHY7jMuNJ2rBMnMvDaX3KHjwC2sKQlnLjfbkKZNb3U6f9Tb0rXxv62M+YVB+N8K2HAU59aEmOY3CzOBr9F2bGNQFLE8fn5ozFhirgEW7dEOUtQ25WszxH2dTIbuhGy8dlO+R4pN2VHsaXB0nq1S9HTHrLejghP1oQW7SOYNOJDsIlP6DCNVZEJFhgqOD+9HqKG/EDmjcTTU5j92LTLNPDRUjduY+1nIsy3Ja8V1lPEiUGuE3OneselBgB46GW0/oyW05eBjMhRZ8dKY8a/vl8BbIZn97LqxxukLqVoFTNEkApon0Ysg0dC+/AvDQps290gOZN0KvQ1p3YSlHChhMnKtZ+Uf4f8L/oe1bEuOQiXIAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(83380400001)(8936002)(66574015)(5660300002)(66946007)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2RLSmFLOUI3TlU4RDZseHZKVTVQUVVOMlVlQmErb0tsMVE3RDVGb0RhYVg4?=
 =?utf-8?B?SVJiNUNsZk1DQ0cxNHJ4cTZJRDdsT3NEaDJBSnlzd1RkaUNod0lBU3BnVnNt?=
 =?utf-8?B?VS8wZ2RseFlOTnAwUnFveFUwOE1uK2g3OElwNjVYTGVnNWlZVDR6dFhuOE1F?=
 =?utf-8?B?S1NxeW9NVzFEenl0bzBqQkZuSnNvQ0huZXZ0em9xYlVZSFFzQ3RyemdveFND?=
 =?utf-8?B?Tmt5VkdzWEp2bncxWFhWMmxhcHBmdXQ5TENISVBJTTFZQzB4TG9SUXNTY1pI?=
 =?utf-8?B?NGNoc2Z0NUlTcXgrTWpGTm9BTjJ3QmdKL2hCSmxvWnliQkh6dDNXU2tCZmRW?=
 =?utf-8?B?d0U4bzdhZmdqc2VNalNnaHVhYTdkZGVxU3BwbDNMeUwxanJyc0dpcXRxUFlS?=
 =?utf-8?B?RDd0czhUUFMwK2J5ZnJqdmNudHRNZzUyODZPYTVITnZGTG9WQ01LbEcxamZu?=
 =?utf-8?B?anNhRndjUUt4L3hqSDVrU1JCZUhHSXFWcVB2bUQvQXUxSUxVTGFrM1pPYVJy?=
 =?utf-8?B?N0ZuNk9HMEFucVNNdzBhQUZUMVpGcTJQeDUyR3ZVZmxpQzR1eUNESGhPZnlo?=
 =?utf-8?B?M092Wk45QWZrSmZFV3hZcStjajM3YTN4c0syZlN1WWlIbys0Z3ozUUhrTzFy?=
 =?utf-8?B?Mmc0Q3FIY2dKeVd1em5KaCtLOHFuWGY5TkJtSGhvSGtZdWMzMGtEcndmN3lS?=
 =?utf-8?B?b1FSOGFiTkxDMHNDMWlUY25QVXhnNFJMRXBGYXpGMzNSZUl3T1U4dnpNUjcv?=
 =?utf-8?B?WHE3eHc0dFBHNlp1bWo1VXdrZHVpNms2NlZUQmxXaFJHRHhYdURBeDByMVFL?=
 =?utf-8?B?dXJHUytuYWh0WWJsQjVFZ2ZyRGJxek1pQ2prYUVLdnZ6OUs0MndiOW1mU0RI?=
 =?utf-8?B?VmVGYytYMGxJcktpREROWDdFTnlPc29yTFk3U3hyODQ4dVkrTWVkWmdsM1Ez?=
 =?utf-8?B?cVpLeGd5K2k2cmhXaWxmZUJSM3RreG1NNW1BUzQ1a2liT0dFajdZcC8vNFhq?=
 =?utf-8?B?SWgweUlYNDFscUoyK0liZHgrZTEwQS9laTYzeklxV3NHRFZxRjJBcjVaT2Vt?=
 =?utf-8?B?VHdsbnJkYUpyVzB2OForcmNLNEtmdStPZjZ2dk5vVjB2Yk9lUjFNQ0tnb0d2?=
 =?utf-8?B?dUpwNmkxUDJOK0lsYjZ5bFJ6VTdUVkZEeEhLTW55aVFWcmQxM1hBUW9zU1Fp?=
 =?utf-8?B?dkNPOFJGOERWYzkyZTg0eUNOV0QrdHdQUWZ0cFZSbjJMeEVKSllZdGhHOU9M?=
 =?utf-8?B?ZmFIU2srcGVVY2lIWVZXTWVPbGVBbDFveUJzTGgzMmxOeFpZRXpiQkhibjJm?=
 =?utf-8?B?Zi85UDUxcU8vamsxeXFYL2F1MUpiVEUzaUhvb08xMHg0K1RKWG1wRU5GRWFM?=
 =?utf-8?B?dzFSSnFxWU16VTVXcUpzYUpaOVZCbm9yUXlHcEMrR1NwTVpkUytRa3ZjMG8z?=
 =?utf-8?B?TTJJZWJNUkFiSW5hbE4ycVZ3NGdsVlNvb09SMDBobzVkOWlTYjQyR2RiY1J2?=
 =?utf-8?B?dkNES1JXblZPNmtRVytNd1FXdG1jK3lCRzVCOVN4Vkw2NGdzNTRQUTRUb25s?=
 =?utf-8?B?cUtOMkduNmxta2VYWDZZdGFmZ2ZxR1NxdTZyUitiZWRsQnZjL2NzS01YTlNS?=
 =?utf-8?B?RnhkdXpOekpweGZUVGQ5YUVPS2lkeFBEVlRIblhuTU02NUxWNHVUQ1B3NTNj?=
 =?utf-8?B?aUZzN0M0Tm4wdURmRnFKeUdhUkRXZ0RNTjNjS2JiUGxnWUR2eGRIaUpqRjhu?=
 =?utf-8?B?cm51dGpDb1NuRHU3dkdKZVgrcCtGbVFnaHkxRkx5ckJxaFdPM1JJUWZmV1M5?=
 =?utf-8?B?cmZDdmE0RnNCZ1M0VmQzUjBlMHFlWWEyTDZuYnNpN2dZejIwZ0k3OGliZmxk?=
 =?utf-8?Q?1TzXcQsabpkeR?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c2cdf2-b644-469b-4a16-08d97474e049
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:58.0302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v6vN7u1VwW5z8iKgpYGBugIggVEyywR3oGLUQcHtd2y4md/+bGjggGYa8xBlOz5KXn9bPWGYUuBIFdeX85vwXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQVBJ
IDMuOCBpbnRyb2R1Y2VzIG5ldyBzdGF0aXN0aWMgY291bnRlcnMuIFRoZXNlIGNoYW5nZXMgYXJl
IGJhY2t3YXJkCmNvbXBhdGlibGUuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8
amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1
Zy5jICAgICAgIHwgMyArKysKIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaCB8IDUg
KysrKy0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kZWJ1Zy5jIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kZWJ1Zy5jCmluZGV4IGVlZGFkYTc4YzI1Zi4uZTY3Y2EwZDgxOGJhIDEwMDY0NAotLS0g
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9k
ZWJ1Zy5jCkBAIC0xMDksNiArMTA5LDkgQEAgc3RhdGljIGludCB3ZnhfY291bnRlcnNfc2hvdyhz
dHJ1Y3Qgc2VxX2ZpbGUgKnNlcSwgdm9pZCAqdikKIAogCVBVVF9DT1VOVEVSKHJ4X2JlYWNvbik7
CiAJUFVUX0NPVU5URVIobWlzc19iZWFjb24pOworCVBVVF9DT1VOVEVSKHJ4X2R0aW0pOworCVBV
VF9DT1VOVEVSKHJ4X2R0aW1fYWlkMF9jbHIpOworCVBVVF9DT1VOVEVSKHJ4X2R0aW1fYWlkMF9z
ZXQpOwogCiAjdW5kZWYgUFVUX0NPVU5URVIKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5n
L3dmeC9oaWZfYXBpX21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oCmlu
ZGV4IGFjZTkyNDcyMGNlNi4uYjJkYzQ3YzMxNGNjIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl9hcGlfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21p
Yi5oCkBAIC0xNTgsNyArMTU4LDEwIEBAIHN0cnVjdCBoaWZfbWliX2V4dGVuZGVkX2NvdW50X3Rh
YmxlIHsKIAlfX2xlMzIgY291bnRfcnhfYmlwbWljX2Vycm9yczsKIAlfX2xlMzIgY291bnRfcnhf
YmVhY29uOwogCV9fbGUzMiBjb3VudF9taXNzX2JlYWNvbjsKLQlfX2xlMzIgcmVzZXJ2ZWRbMTVd
OworCV9fbGUzMiBjb3VudF9yeF9kdGltOworCV9fbGUzMiBjb3VudF9yeF9kdGltX2FpZDBfY2xy
OworCV9fbGUzMiBjb3VudF9yeF9kdGltX2FpZDBfc2V0OworCV9fbGUzMiByZXNlcnZlZFsxMl07
CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX21pYl9jb3VudF90YWJsZSB7Ci0tIAoyLjMzLjAK
Cg==
