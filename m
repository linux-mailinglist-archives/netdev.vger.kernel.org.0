Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EE74086F4
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238830AbhIMIf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:35:58 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:60019
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238109AbhIMIeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3XdyyhCAMr4Aa5bBKQJWC525f1g4+E6Rz80GfnVaj3k1p1mrldVx03hx8f4OB5MCMBaifw5LTvOdZhcAUT7hm8kBNi4EtuKspWDrtjQ2slN6MB4KQtDe2JqQz/mKbpK3d+RMZcSa0D/CNhG2QzQJL5D71LBXevd5QKltqRGDtRIg9dPqIxndeU6+72u4nqUR7Op8QMr42YX+9fMCQEYfEz1U+4WRQrRXqQ4iINXdD6fskoSSBZkcBvlT4lZ0aA0pTQTzcJzBfSTm0LGE95P0FeGP8AUIP3kOn1WXv+23rhSa2fuIiHYT0YVr1r25E9QijE9OLQGAF0ISNckAxmujA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=oaQhnKNtSG5UkXUiU6j2gg/GZjyRXhqrfHnnyJNcWljSCbTD3rSDdNwyA50NfjOh87Q1D+1rlO5vMGlPUXsEzgvSdzrCAT6J/u5H75las/Zrgthj3bGrGHepH6xu79SlJ47jJpFhBT4CkUktob1WfajoExCSI9e0WCeRglA7ob8tc8IGR92Rl5LJY9SzPjP0/LaQHu8vRLixJ/SWFnrPa1jQRzXf//OlvmvlR2zBYgfTHZynYD8YgJC8AsNOe1iznE0zFo06CvUOmNfNc2UFF2LQSm2Qk3TufUA+83h0+PZGgybuXlsGiCk+x4m9AEaVVJVgzA37QFs+OqDkiQaDbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzwEfQZKRI3oV247NU8V2xMOFhCemH5anBJ8Bdc6bfM=;
 b=KUaPIrQeGeTihy6vikrj1R1caCbNRjILuRZVpZMhC2+Hgh8SjMIQOuxKa9aeLKuz4LH0AiuYFACL8h6Vx1eR/oM17eMV9Lb33SK0RneQnKydb/w+pSVhn75CFVwuEC3kPUxFxAdvDomP1xkqMOH1jp2mtHgJJml8OOsZ4BeoIIE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (52.135.97.18) by
 SN6PR11MB3263.namprd11.prod.outlook.com (52.135.109.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Mon, 13 Sep 2021 08:31:54 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:54 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 16/33] staging: wfx: declare variables at beginning of functions
Date:   Mon, 13 Sep 2021 10:30:28 +0200
Message-Id: <20210913083045.1881321-17-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58f10d22-bb48-40c6-4c58-08d97690e441
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB32634B0D438B85A8483ABAA493D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YDi5/c38qvZdf63MKcqTvH1IHTwJgux6cxnZ7Sm8ingGBPL/sgJQQLZlh7bNQb2p1qrpSqdviTree4WQux7tQo5vdjj2yWQN/OPXEPo2/nEepkzc574sqC68zklgALKhIL4GS+Onr52V+5B3iEvxT8MbVqlhfHQH/mpTjj+G5g2KIlmYPzAR++iFSfMcUUWt9IfQ75QPDFwYmVH8lmhUcbVG86QTJQliCJwESss3zbEjN+uIg5arjAQwQtobw/Wg3eNliDcjMmgaW+yKI9sv/KcOvVkZ8OVv/vgx4/amq5r61lLXUh9cHTcQ7RLPMbesD1QuXvvkLMJlyMxkSNZlfQDV7w/3XmRY0Mzl5Mk8b1yaMIzhcTp6xT7Z+OnHHXWIb6G7jZ0NNZ/d7qbEgN4ArMK0mE7lPl8XKuqibZxSbLobbsrE4q1AoC2Zy27wVzzltKcIHmMLrOx+oQBfYGE+TQr2p4nNVoq+mMr93IXsLkP8h9FPruhqjwZw3GlIN69P586ZrVnPm8N1zF0SZ3uAJcWd9SYorshwZc4FM0y43bnSISUHldCRLOk3Fo2srx7PRLyZvohu4b99zGeQwW1TbwxlAinuEnJBUMcGuiLLt9RJWHrG3OYYLyTwXXnDChslM73BQ71ROC4zh1S8IGm8ER17j/gQH/l626fXW0elpAJJOLYs0fUwnewZGHhtmWnjARTNhpuHCDgi+gWXQAzTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(107886003)(956004)(2616005)(5660300002)(54906003)(38350700002)(4326008)(6666004)(316002)(38100700002)(66946007)(26005)(66476007)(66556008)(186003)(8676002)(36756003)(8936002)(86362001)(508600001)(52116002)(7696005)(6486002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjhSRGU3T0daV2hzeEZnUlR4NFUwZEJTK01VcHRZeEcrS1MzTTlXb3dTOFV2?=
 =?utf-8?B?bExiaGhVSWFYdC9UcnpObmpXUDVBM1dvVGZLcThoTHpmZHF0bTAwYk1BRm55?=
 =?utf-8?B?eVlzeW1FREx6bS9Ub0tlbHZWSVFOLytTczdadC9LRlU5TjRSbFJzalJiM2JJ?=
 =?utf-8?B?UTgwdHU2NTdZM28rU3BSMEV2eFFWaVkxUElHUVRpU1lLdTZFNURqKzJwdXU4?=
 =?utf-8?B?UVI5Ri95OXNjNk93SklYMk9QZ2RtbnFhL2FrcWl5dTNGQUZ3Q05VWjVDZ3Nz?=
 =?utf-8?B?NGVPQklWNDZmZkptMDNoOWdYRGtKdmpteWkwSVhiV1lvemVLejlKY09raGtJ?=
 =?utf-8?B?amFMWDcvNVdsd2Z6VXg2WkJoUmkxNjhkKzYwR3NSMzU1cUI2akYxdXNCUUQz?=
 =?utf-8?B?WHRvK1BKdzBzNm5xREFWUkw3WU83MzNtTDN6OTFlSVhsR3JyVFptMVFOVlNW?=
 =?utf-8?B?cXNmWkVsb29VUWJOWVBQMC9zRW9YVldRbVFtR0cvRFdtT0tUZ1kvdWl5K1hQ?=
 =?utf-8?B?Ui80cG93eC9sYlZ4bTRPczM3Q3FqOWk0aHc2M1NrMXRxMjdtejc4bStYa0x1?=
 =?utf-8?B?THZJWEhqbm95RzdZbnpwai9WN0YveVNSaUNWVHk1RjRNWml5T1VieERUcVZv?=
 =?utf-8?B?aWVpN1ZoM0ZnZ0d4dlNmVWRWeTZ1bkFNZUp4MnRHQ3hZVTQzcnNGMWhLdHNh?=
 =?utf-8?B?UVorK1BHVldKU0h0NWllRzIyREFlRXRyM3VXcHMxUXRicUs5a2ZGMlBwZyt2?=
 =?utf-8?B?OFV2VlNWdEhJYkYrNHE1QS93cC9ycmdKR2U3S21EWkRjN1U3ZE9hWDNjN210?=
 =?utf-8?B?Q0RaUHJxUzJRSXR2R2lDWDRNZXFqREhnN0M0aHNKV25JM01sSk12QVJ0cTVl?=
 =?utf-8?B?YVZNdzlBZ0FSMWI0L2Ivd3A3RnZTNTVRMlU5dVA1TG9id0RPWkNiOU9LeFFr?=
 =?utf-8?B?bXl5MlM0anhtN0FqdXdVYmJEd0s5YVdZYk9VeFNSbnJkUndmVkVyWGVxaks4?=
 =?utf-8?B?VlQ3N2d0SWRMYUV0ZDZxSW1GY2ZkWTY0SFpPeXdyTTlCWEtYUTVJQ1hENnd4?=
 =?utf-8?B?WFJrTGVnd3hLNnZuQWFDTk02TkkvRjRNZC9RcVpyeGhrb0hGbWlrdDNvUmNx?=
 =?utf-8?B?V3VyRkhYbkZSeFkvK0pud0hyd0JmRjNidXROQ1VReWtoR1FOOStCaEFYYWZE?=
 =?utf-8?B?VWVqR2hvZWhWZFBKQWJYbW1rRDJYcUZ4UFhRT3dLcEVvNG1iMFgrWDhNRkFr?=
 =?utf-8?B?ZTFZTlk0aGkxSy92cllNWVZVZ3lMZmQ4VUVBSUlDNlkyTjIvdiswcWp4ZG90?=
 =?utf-8?B?dVJmcWZseHBqdmRDcldNZml6NmRqQWdiRnFSQ1UyR2t5a0FUcFBiTjBpbVRu?=
 =?utf-8?B?YnNteFlOdERqRlNVNERrVTRQQXh2SnJHRUkyVEtpZVFMUTZuT2txcER0WUl5?=
 =?utf-8?B?UVZZNmRja2E0QlFXakZ0bUZSZXA0Z0ovVnRONUdLQmxBUFFRTXNQRDVmUEJk?=
 =?utf-8?B?KzRUQ0RJOVhPZ0pIUXp5c2FSclp5amtNbkNvMERGMHdCUFcvVHZadWVmU3pE?=
 =?utf-8?B?akVYbUszSGd1ck1sN09NdkJUSCtMVE1CdUFKeUwrZkdHUXgwQ3BlSEt4L3BD?=
 =?utf-8?B?WC8weEJhTm9aL1ZxWmtSZE8rbERPak0ySjJaanRjOWFxc3g5djM3SXh6WjhZ?=
 =?utf-8?B?cFRsY1BEQWNmaEQzS0dLbFZzU3dJWG13dXpJbWlLNlZEZDhuTVNiUW11dmgx?=
 =?utf-8?Q?k0WUPjg9nZcbx4g+5VHZA4jXXsBraX84ilCvPj/?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f10d22-bb48-40c6-4c58-08d97690e441
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:32.7618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+8QcJHoSJNqZ2zSbpsBs/q9Q4GCe7eGVjqspV8JxUKQ2gA9xAQfqJBSVL6wZWLqkzmVS2xy8zwEK1dADUXqHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRm9y
IGJldHRlciBjb2RlLCB3ZSBwcmVmZXIgdG8gZGVjbGFyZSBhbGwgdGhlIGxvY2FsIHZhcmlhYmxl
cyBhdApiZWdpbm5pbmcgb2YgdGhlIGZ1bmN0aW9ucy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1l
IFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwppbmRleCBjYWVhZjgzNjE0
N2YuLjAwYzMwNWYxOTJiYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKQEAgLTEwOCw2ICsxMDgsNyBA
QCBzdGF0aWMgaW50IHdmeF90eF9wb2xpY3lfZ2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWlu
dCBpZHg7CiAJc3RydWN0IHR4X3BvbGljeV9jYWNoZSAqY2FjaGUgPSAmd3ZpZi0+dHhfcG9saWN5
X2NhY2hlOwogCXN0cnVjdCB0eF9wb2xpY3kgd2FudGVkOworCXN0cnVjdCB0eF9wb2xpY3kgKmVu
dHJ5OwogCiAJd2Z4X3R4X3BvbGljeV9idWlsZCh3dmlmLCAmd2FudGVkLCByYXRlcyk7CiAKQEAg
LTEyMSwxMSArMTIyLDEwIEBAIHN0YXRpYyBpbnQgd2Z4X3R4X3BvbGljeV9nZXQoc3RydWN0IHdm
eF92aWYgKnd2aWYsCiAJaWYgKGlkeCA+PSAwKSB7CiAJCSpyZW5ldyA9IGZhbHNlOwogCX0gZWxz
ZSB7Ci0JCXN0cnVjdCB0eF9wb2xpY3kgKmVudHJ5OwotCQkqcmVuZXcgPSB0cnVlOwotCQkvKiBJ
ZiBwb2xpY3kgaXMgbm90IGZvdW5kIGNyZWF0ZSBhIG5ldyBvbmUKLQkJICogdXNpbmcgdGhlIG9s
ZGVzdCBlbnRyeSBpbiAiZnJlZSIgbGlzdAorCQkvKiBJZiBwb2xpY3kgaXMgbm90IGZvdW5kIGNy
ZWF0ZSBhIG5ldyBvbmUgdXNpbmcgdGhlIG9sZGVzdAorCQkgKiBlbnRyeSBpbiAiZnJlZSIgbGlz
dAogCQkgKi8KKwkJKnJlbmV3ID0gdHJ1ZTsKIAkJZW50cnkgPSBsaXN0X2VudHJ5KGNhY2hlLT5m
cmVlLnByZXYsIHN0cnVjdCB0eF9wb2xpY3ksIGxpbmspOwogCQltZW1jcHkoZW50cnktPnJhdGVz
LCB3YW50ZWQucmF0ZXMsIHNpemVvZihlbnRyeS0+cmF0ZXMpKTsKIAkJZW50cnktPnVwbG9hZGVk
ID0gZmFsc2U7Ci0tIAoyLjMzLjAKCg==
