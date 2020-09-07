Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2751125F7D6
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgIGKVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:21:08 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:7488
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728421AbgIGKRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 06:17:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3FArI739QBff6wmJYD8GdRrfyNTaBrKLpBMURZJr7TEd3nLCCDAgPtrEtKsxsg6HCDeTu3bg51m0azpEFFE7w0g7rdn3bUy0MN04m//ryq42i4xvS39WNMyUoj2OG7s6F8FiOkrmn+98WhOJSW3fN6PdjiUwdb2s9hVFuycuOQjxAEZpfsJ+Z+aH0KdhgBW5qd7nNdIwK19cwMpzJC25hCdPMkbUFHlQUCIi54VFRbB73bt1eZ9FKdNzBhEH03K+JQM6Cm/sGAj/+gc3PShwHCwkpTd7H4wMSVw2ptJXIckDosdO/rIzpLVtPlqQ60Tr6DQSt09uKB95QexqrOj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyaTk4nGdiD/SodbKM8DXYOjqFCAWbvWDSsuajm8qnE=;
 b=OhTTpwbS+cJ3aE+EtNgcp3C2bZXYAlzZJKYTWXm4WRzPbjoXSawJR6E4J+9qSrA3n4s8Ln8dJ9O3S3KDOOqZUzyV5u/E8uCkIknvqAFntv3NK0nzk60ZAiYFgcnBazD40xg/hRJnFPjTWAsdmrvHLgSQIOfP7bOK+SJuh8aDttmKkHFKbp4x55amT1mhtW0T580efldy4ISaRivVpzZI0tF1f69dL+SY6ZX6SyNXO6K4HiKKA/AP+R1m5QjYjESbbC7gnqyzeRQqU79XLp7CzPGHHAq80rnuWggDPSMFvEcNJfkYepD2NsWf7ijd8Ozi7io0ra/F9Dd1O96Ni2k4Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OyaTk4nGdiD/SodbKM8DXYOjqFCAWbvWDSsuajm8qnE=;
 b=QSewbqVOc1qM0X4wdKGJABXr1aeBxf28NBFDhTKomsgbXgJNTtUKH1hnhycMnQvZkfBRI5wPm8H22/xc45dXHZXjDJ4SQGxWc8MQCfL6VRVAbj+0gRsldhuPsGXknSw7jh2NMsB3Q0NY+GrsJMlikb1peSbXLLLSUb3009LHZj0=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2720.namprd11.prod.outlook.com (2603:10b6:805:56::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Mon, 7 Sep
 2020 10:16:22 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::85c9:1aa9:aeab:3fa6%4]) with mapi id 15.20.3348.019; Mon, 7 Sep 2020
 10:16:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 23/31] staging: wfx: drop useless union hif_event_data
Date:   Mon,  7 Sep 2020 12:15:13 +0200
Message-Id: <20200907101521.66082-24-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0109.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16 via Frontend Transport; Mon, 7 Sep 2020 10:16:20 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7de4d973-9da2-4069-24bc-08d8531711df
X-MS-TrafficTypeDiagnostic: SN6PR11MB2720:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB272015BA365CF6EC24FF417B93280@SN6PR11MB2720.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FWtr4sG7dStbGFVTDXKseReVdF+f7mkRctM/UuYZafjy1Hkg0VJzjCyVu7l3NwnIl1YVL212Y6O8mV/mqkraKgSD5kjHTPhOnsOeleu/VErsDCtHcKgjI7bvhQMV3hRuB4ZJk5VPgnR3+5wNubJr7EoKhFy0dp2oz9GOJxo3AbKPTJTM7dKI4OgVeoQoPi5hDfFUIAUFjhMxG6Qsd0DTWgX5J4IJ/uvXiBHqMG1ZASZFc9V9IOzPtTEkpknWnsny2JF8thWwYkFl7RKAJ657ZICmvO0AvI080RrLb9dVAG0aC5M7XrDSyd7Jpvg/82petqCzIJzVgPb4b5eebwUUiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(136003)(346002)(396003)(66946007)(66556008)(66476007)(54906003)(26005)(186003)(16526019)(83380400001)(107886003)(6486002)(8676002)(4744005)(956004)(2616005)(2906002)(316002)(86362001)(8936002)(478600001)(4326008)(7696005)(36756003)(52116002)(6666004)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MI7xZKwJnj6pUlbeaGPYYpi9eaozaC3VI22H9Npec3fYN5TLW0gyZkVZJ2LXhWxcdOpEdeHrgg0mdlNoKILLYtQ8W4dm5mLjy47ecdCkAuxJZGNSz3m83Q0Q3ujRiI3+FNbzSOERMeuC/UYqyS++4WsWI2x+t+1oTY+4QN+gjQiMRhl46gs35OaMULgruiLN/CiqNIabbh2Grnzz1ciC/5QgdzhaqXzihHbkZVSac7NxDtVckavULZQD1ETCuiQ5wvsFp2iqOumaDOHiyyk46lq+dVpD+yUz3xOikTF5gs+6yMUj5IxnBFKrXOV/xsO+MJbV6wWjn1/E5Q0IqyFJyvIjTJ1vdZi6YzMbE3WxiHM9ObAYiSZJpyBHoh5/W1yav93xVkDvh8e3y7LoIRhwd2L+LBX1hthPiRUOWA2vmbly8dtQT8jusK2mAQ4czVLcj4ivDO82+U+xwlECXoObNQPXRVOocBmDN2j7w+3ziKXhYJ5eTcfaptHCjtoB/k6tmSpgVsFovTYsB2sbpZL1oqyh/Lkv5c1BylUIbfaeQ/hZiS2vVJ6Pbb/5GVe9IvgJUEn/n4GrDkppMLO50WDF/VHufeeILXNA9cSzxF8NfBU0+B5CouRcsIqsDE3hqe1CNUvA4NCojeppbc7fyYgCTw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de4d973-9da2-4069-24bc-08d8531711df
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2020 10:16:22.5133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/49+ACX0p5YrNXyyXQ0rou7dKrDvBpl5PuwCxah7Q3R/6wIBVtWYnM5mf5H7skzyagEAnjnKvNjj6SdJmPRsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHVuaW9uIGhpZl9ldmVudF9kYXRhIGlzIG5ldmVyIHVzZWQgaW4gdGhlIGRyaXZlci4gU28sIGl0
IGlzCm5vdCBuZWNlc3NhcnkgdG8gZGVjbGFyZSBpdCBzZXBhcmF0ZWx5IGZyb20gaGlmX2luZF9l
dmVudC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggfCAxMiAr
KysrKy0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCmluZGV4IDE3Y2QzMTdkZTgyNC4uYzE4ZTc2
MjQ4NWE5IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKKysr
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5oCkBAIC01NDgsMTUgKzU0OCwxMyBA
QCBlbnVtIGhpZl9wc19tb2RlX2Vycm9yIHsKIAlISUZfUFNfRVJST1JfQVBfTk9fREFUQV9BRlRF
Ul9USU0gICAgICAgICAgPSA0CiB9OwogCi11bmlvbiBoaWZfZXZlbnRfZGF0YSB7Ci0JdTggICAg
IHJjcGlfcnNzaTsKLQlfX2xlMzIgcHNfbW9kZV9lcnJvcjsKLQlfX2xlMzIgcGVlcl9zdGFfc2V0
OwotfTsKLQogc3RydWN0IGhpZl9pbmRfZXZlbnQgewogCV9fbGUzMiBldmVudF9pZDsKLQl1bmlv
biBoaWZfZXZlbnRfZGF0YSBldmVudF9kYXRhOworCXVuaW9uIHsKKwkJdTggICAgIHJjcGlfcnNz
aTsKKwkJX19sZTMyIHBzX21vZGVfZXJyb3I7CisJCV9fbGUzMiBwZWVyX3N0YV9zZXQ7CisJfSBl
dmVudF9kYXRhOwogfSBfX3BhY2tlZDsKIAogCi0tIAoyLjI4LjAKCg==
