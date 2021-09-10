Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9DF406ED8
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbhIJQIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:08:46 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:8641
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229475AbhIJQHs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:07:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ044kyJpUUVW/BbOmEBVLy9Ca1dQXuVBY6Gwb+mWQ6ycfue2SDxcyo7/th/gCsl2p0M4H8xzf2z+pVjzmnHUTg3W3u55CdqKv4Y/s1s8YuJXxXdhM96g1aHmSJfX5wmmBKDl7W/9NHRSYkS4ha6L3Nj862nNR6i9RqYNAWhB5WZLPdsqtbBpDKoZ/PEV0mAg9FgY9w/Pu4na5zZkINsp1MCikIQqZ6MSqVfDZeORvqh99ah1iU5RDhfD4dRWWX/vgWzkD/XaceREdbS1uhwKQWFUnAzM4c9IQuvpE2tTFeHHdAktc28ot8nSfIpz4kNNh8tupn48yCB374UBpxZQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=PwE+rPnDXMSmBPY9LXea+iU8XgpVXCpEq2os+Z20oiA=;
 b=ZPESr3ASVkvfnUu38+CJnPwPgRB+hMOc0ha3sqypUffM74/8FFgTmjQ3+MEYMiQcWckg4Zj/oh294/7J9VKJiAghv538SFX9jinMnm0JRKhHLVIqxPIDlqyIeNwkCFtRiR41aPeSW2W1GzuRfvbrdfIlL+64+vsZSwZw48A1THmwsKtoBQXyVa0nDw2lI248xbsl9Kgx0W/fNbiR/IHAe4h+MjZAFIiSyozf6+fHpaO6rjg7Xv8OlkrMP/pW1Ci42rmBe80b8Fy7V7mRWYJ0dQXhLHNVQGcPUJd/lh6jre6hKmIP2p7OXBKGATKSdvpN5tZ73CxJ+JjG9+Gc1s3Ypw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwE+rPnDXMSmBPY9LXea+iU8XgpVXCpEq2os+Z20oiA=;
 b=aWiVF2erLJVCZLQ3JHmncJlZ4b8heGt7XPwRB1icrcuqwToXfKTsHZcPaQBziXeSZrtFUnVTk46dr8p6hkQf0/4MI+bB3UH4RfkWeHb9tzG25RiaExE1mVwTaE35jxHD9MbeO0PfjUmpxdqq/RuzG9kp5waQouh0HBPY1WDK3SE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3118.namprd11.prod.outlook.com (2603:10b6:805:dc::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Fri, 10 Sep
 2021 16:05:50 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:05:50 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/31] staging: wfx: declare support for TDLS
Date:   Fri, 10 Sep 2021 18:04:42 +0200
Message-Id: <20210910160504.1794332-10-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:05:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d897f397-8955-481c-8c19-08d97474dbb6
X-MS-TrafficTypeDiagnostic: SN6PR11MB3118:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB311855DB232D09AB9B48EFEE93D69@SN6PR11MB3118.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xku71NQHxxbs5AEyH1pYy+Voa6q6dv6rSm7/3EWCSABxgbiSLFid2JjtBPKsMD7nhDzvvgGykldA1meTmPRZuas/JlqtaLRdv/UWzorbIliwHM6++46xzXU/gLgzqB+dHQCStMWkGcL/3ttN9P1fKZ0mjXoNXWdQJiAyFv9t6Rsi7h/ljc5x51LUsh/PUEDuF3ydRaoymHlWLsthMU/rj3/TzgRcQhPXxvVw5aZO99De91arT7McuKTlorf3XDjrUzKJC4uc3F8Z0wr1U5uLSmr+B4ntsIE6FNQGqhrQ6ReWbIRyVE64XSN2VbYWnxlLNGopV8n3HG68F+SaeVzEitqMNIgKlVxlJmeRITTBRuRDMdsauC9tkj7tJ41/zJOGVC5vkgrzV6aIeJEyJYU5zsdo4KQX4JmectUZyRMWdYq9axmIRaTAFMKRQZyRlkUzNIuSbfwD/+I0zbQBbyAJZeA+rFZa+zhRLPmY8AWW4Nzu1tmVcgYPTi17zSj4uQPIBKbNGFn4XTrPhxhsA9udOq6Hhu+F1ANobw7Rjt40FdUFMS/Z8rZYKTyZ8gUw35E5zvAlSy2sbpYx8a8cwcadWCJfR5ueSUVS5dfcHxEzkMdK8KbMf1gp67YgdpN4EehomwnJqzXVoe2ridADh355qQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(346002)(39850400004)(396003)(4326008)(66476007)(107886003)(36756003)(186003)(316002)(6486002)(66556008)(8676002)(6666004)(86362001)(2906002)(54906003)(38100700002)(8936002)(5660300002)(66946007)(4744005)(1076003)(2616005)(52116002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlRpS04zS29vRTMzSVhXZW5lYy8yUTRyaFFrT0c0cDVCbUhkSWlTUWYwcU1q?=
 =?utf-8?B?U2dMcjEvSVhFd0xXdEFNSG1xOGd3clhUS0MrWEJ3bU5sYkxyU3NPcTgxQnRS?=
 =?utf-8?B?OE45bHRjdGZ2VEprOGllUjFsN1I2VTJjYnFQUjhqR0ZJWmtyenlQcUxlRjN0?=
 =?utf-8?B?M2Z3Z0FZUHFBWXNwTDZZcXNEdTFNcjJMY1k4cGkyd05raUNoQ0RLazB6OFVk?=
 =?utf-8?B?VC9ZMC8xeTFZc0UxSnkrVWZjdjB6YURoU084OGFFYkNudldYZFh6VEs5TW5M?=
 =?utf-8?B?V3NZZ2pBTVd1Qy9wNGUxblNvcDF4L0I4azlqdjcydjlXMTk4Zm1PRnhkYysr?=
 =?utf-8?B?c29VQXBLY2N0WFg4cE1ZMkEreEZ3RlNXSS9YNUw4YXF0TVI3UloreSs3R0F0?=
 =?utf-8?B?R2dJKzVQbUhYUUNDQ1pLNlhRaVN3NU9RT29VQitjNGppb0xTa1R4czlwN2Ja?=
 =?utf-8?B?eDJjMVNJMzVrWmc0M0tzKzAyamhJUG42Tms5dXlqUDZ6RlpkQVMvVW5FbW56?=
 =?utf-8?B?Sk5xdVBac0xFV0Rna2F6bHhuRGU5aWlKcFNXUkNRRzF5Z01yb2VoWmFPcVhs?=
 =?utf-8?B?bTc3VUNOdEdzNTNYcUdrQVlURmN0TnpIaHFmbTRGb0thb0ZxdDg5MEVKQU9K?=
 =?utf-8?B?a0xiZUZ1aHh2MUd1OS9RT21ENUl2TjcraG5PSDJvNWk5K1hNcUVFVWEva1Fy?=
 =?utf-8?B?bmxHOUIya2NHbWNReDZTRERpaXViWWxBdEdxZEd2WEYzcHVkdG9zaFM0bW9G?=
 =?utf-8?B?eHBjTDUxS3NhREZmS2R0eUtJczdWVVpUWlh1a1lhTGF0TzhpZkhOSHNTakRN?=
 =?utf-8?B?bHI2RTlnTUVkZzQzTHRlU3JJZUd4a0RQSkFpNzZJVnBCV3R0LzVNM2JFY3E3?=
 =?utf-8?B?N3NzRFRMZFNqNk9IWWE3WStIV1JjT0JYNHlvQVdJc2dJeGhYVENwcEU3aU54?=
 =?utf-8?B?QTZ4aHB5UTloM1F0c25KdUVRWWxDQUt0OU5xZjFXMmZxVzBUMUNwMW0vMnc2?=
 =?utf-8?B?U3NUamt2TUJHT1p1WjJITWhJMHZRQ2ZCOGlKcGsvUDNaSjRaY2lUWlRpcFU5?=
 =?utf-8?B?Wnh3RnhTWE1BSzFTSFhDa05NZnhpbU5MVVRWTFBXbkpudmIrdVQ5ZXhJRUtn?=
 =?utf-8?B?N2xtalczQWg0WVJvTk1uVkUzNlNSdmhoT0FnZ00wSGRZc1IwbllNdUFENW1E?=
 =?utf-8?B?bm94SjFmM2IrQ1I1ZWJxNUN6VGlPYmhJdERrMUxoN01CdHJwTENqS3E1elZq?=
 =?utf-8?B?L2wybU1HVytmdE42MlVqMnZPWVI4emJ0RnkwZFZmU1VWcVhQak1SbnAzazl2?=
 =?utf-8?B?b1JtRHB0UVVLcWp3YzY2SVJjZFhzYlMyN1NBYldOWGpzekRqQWJUSGZDaUE3?=
 =?utf-8?B?K3JsZ3BpVzE1UmxtUC9QZHhEREhDZnEvQnlVLzArSFhNRFRBRmFvc3pUS2F2?=
 =?utf-8?B?Yk9DN1hjZXBqc1pTay9rbUtvRmZhdTFiZEJKN3hKQVZYYUx1RnVxeDV4aFhQ?=
 =?utf-8?B?Z2Z3QTN5THdGZkg0ZXQ0dHNsZWFKM2VmeHBnYlZoRDlCQzBrbW1WN3hwS2JX?=
 =?utf-8?B?bit0U3dNUzB3UW5PRFdGY3hHeW15SnlPRnluQnZ0eVpoKytDMDgweHJodmtS?=
 =?utf-8?B?aHJueTArYW9RSkRFbVpiaDAyREgwMG40RFdDTWhwQlkxQ3BGUjk1NzBhNmx5?=
 =?utf-8?B?bGc2NjNWYnVGeUZzdVpBWXNBWmhYZkttNm05V29QcGc4N3BJZTVlSHk1TEtV?=
 =?utf-8?B?bnQrYjlBbFVoeEphNVJKUXROOHBKNGVLaU9CQnIxMXkvZ3E3ejlZZVc3Mmww?=
 =?utf-8?B?T1VGY05TcmVhOGRCM25rSTZORlZjaDB3RnpoTUpWdFAyakd2cXMycmpLdVZZ?=
 =?utf-8?Q?Yip2u7WSHOTza?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d897f397-8955-481c-8c19-08d97474dbb6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:05:50.3056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Co9NYFNWdvesRTyF372dSLuDs8VQzwjQI21t6lRj3uwjnVm7llDumh8q9ApgoF5xQxJx9uDq5gQLpKww/vz0Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lu
Y2UgQVBJIDMuOCwgdGhlIGRldmljZSBpcyBhYmxlIHRvIHN1cHBvcnQgVERMUy4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyB8IDMgKysrCiAxIGZpbGUgY2hhbmdlZCwgMyBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCA0YjlmZGY5OTk4MWIuLjBhOWQwMmQxYWYy
ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9tYWluLmMKQEAgLTQ0MCw2ICs0NDAsOSBAQCBpbnQgd2Z4X3Byb2JlKHN0cnVj
dCB3ZnhfZGV2ICp3ZGV2KQogCXdkZXYtPmh3LT53aXBoeS0+bl9hZGRyZXNzZXMgPSBBUlJBWV9T
SVpFKHdkZXYtPmFkZHJlc3Nlcyk7CiAJd2Rldi0+aHctPndpcGh5LT5hZGRyZXNzZXMgPSB3ZGV2
LT5hZGRyZXNzZXM7CiAKKwlpZiAoIXdmeF9hcGlfb2xkZXJfdGhhbih3ZGV2LCAzLCA4KSkKKwkJ
d2Rldi0+aHctPndpcGh5LT5mbGFncyB8PSBXSVBIWV9GTEFHX1NVUFBPUlRTX1RETFM7CisKIAll
cnIgPSBpZWVlODAyMTFfcmVnaXN0ZXJfaHcod2Rldi0+aHcpOwogCWlmIChlcnIpCiAJCWdvdG8g
ZXJyMTsKLS0gCjIuMzMuMAoK
