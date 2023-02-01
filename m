Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CEB68604F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 08:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjBAHJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 02:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjBAHJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 02:09:14 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2042.outbound.protection.outlook.com [40.107.96.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2A47AA6;
        Tue, 31 Jan 2023 23:09:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lhgD9Yd0mHJ5rvWbiLfd9jb0PjAgfsaX1raBkZr5XOmrWEFF0PgMM/ZEwxCTdGn/GE5l8EXekzR4Rq46uiL5QIXeR8ph5zPzQ8xoQOsxmUtZx6iaswj70c5/qu0XtBQ7u+8VyBQW8XmzBi3azVRqFBWuoc8EyNLtO3yP8XYmS3Hs0/bpMaAymTQsw4BshURfEjN1u8YAmTprCK0QKFL1FFDAIRu5QT9F1pvPjakC0yzonRFSlxGVg+apgUFdEvTW7bL8AxWZ7e6OM6ECRM1MMXhpCw+dM7JOFoEb5sL8pJSTNkU5GEIBEZJpQbpTbJr07RWp525BJvYU0kRFoR0eBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XUZKxzKgc+i8i4M+wG5SptjrTvbV6EAp8ug2L9evA5M=;
 b=mEetvSwOgl2jXvAlyAwoDDOWR9TweoIHumoir+3sdRsDykMwQdksvJpThm7o6rpxyB9Oap5/VHLCsRrF4ud+vBFEIrPpAwSiNdEqdsgjqmSXP3PFzXo/ObgNHXFYNxU9iG71U2Nqf+dhLyhuqXDEmPjkYjJAlB2m7kLLv0kCd+z9hs/KHjgscCWWXfNJ9Zb+96Y554cPTXW1rATcfO0vDthAd7PKhDp94nipCTO9cY0dc6iu+BFKEx6ICXYiFwUEs4cCT88Uqq/u/m+RS/qdED6lwNLte/h0FyKjunbPmPRP+QGJ2wMtwUqh9QNHdc9qSfuy9IHkKyitLbSEmpj0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XUZKxzKgc+i8i4M+wG5SptjrTvbV6EAp8ug2L9evA5M=;
 b=LDTIEnzhoaWaT4W6nHh80rl+/GDLvDzAxkt6pnCjv4RSQQZdYzyGwhTwfVm+gUw3h3NanYgcqB9sOTGeMz4/pZ1GFZO8YjNUz5uHkkYeftpI2r4XMmpGBd8bxRSTYUd5cHZ9+wl1nNDaCZWcImz1tUYz880CbRbZ59PvvKDU/DY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DM6PR11MB4441.namprd11.prod.outlook.com (2603:10b6:5:200::11)
 by CH0PR11MB5508.namprd11.prod.outlook.com (2603:10b6:610:d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 07:09:11 +0000
Received: from DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60]) by DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60%2]) with mapi id 15.20.6043.036; Wed, 1 Feb 2023
 07:09:11 +0000
From:   Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Amol Hanwate <amol.hanwate@silabs.com>,
        Angus Ainslie <angus@akkea.ca>,
        Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, Marek Vasut <marex@denx.de>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Narasimha Anumolu <narasimha.anumolu@silabs.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Shivanadam Gude <shivanadam.gude@silabs.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Srinivas Chappidi <srinivas.chappidi@silabs.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2] MAINTAINERS: Add new maintainers to Redpine driver
Date:   Wed,  1 Feb 2023 12:38:47 +0530
Message-Id: <1675235327-32629-1-git-send-email-ganapathi.kondraju@silabs.com>
X-Mailer: git-send-email 2.5.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: MA1PR01CA0169.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::21) To DM6PR11MB4441.namprd11.prod.outlook.com
 (2603:10b6:5:200::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB4441:EE_|CH0PR11MB5508:EE_
X-MS-Office365-Filtering-Correlation-Id: c3498a64-53d2-4334-ed67-08db04233801
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ulCLGU3kipgkWMEFIDSN9hhcnjNZVzBJxxilTiFal/vXALj2iMfmuelP93tgliSpWyTmpJVrCEpyWWS8t0Z5sEQxl1iNHSA2iaF51K1bOoZXUjqLA983EdI3cspv4UPD0+deZbQcGtpgr0HHbaFkecb5fy1uJ22dzE6AeC5v6sijtbReoP2dW2WQfgwFsxfJMkdtjbT0l71emas24Zr4GdM61EQVtx10MaN31Tv1P2W7B0Tq1aw8R7WoOHw8jzshPN+n6ihnurDkrbGkFXQOWaIDC+52J8aFjdUeWvI8W03Re0vgbFd6UJsR7kK+5rgnvJn0JhH7hGQzwETp4I+CpZbXHzIXzfcWrR/pySMu0sNGfXT4lB6CL/NA2ONGZ2i/VN8Ud4g91MVVF3j4Ej/7VPoMSRDkh1dqyzKR8uhLWCspQoglRxXat/E0kSIVVUW9XTqnurVqIC4Fu53nJhn7IOHeB0ITj5OV9C/f7sO6xt/u2Mu2Zp2h90R7hReK6K1UmqVH+9WJKnIAOP5m3CxXmEWSM6N4Rfg2zqaXcKsMg39hkjj+hwruch12yf5Ri3A3SiFuYQYcoVDwqtqPA4ivXx+Ez7LWydvyPukCuvYP0ZksJRiw0IjQ1RDC31/g4M+iJXP3r4DnOgQ36945Mm9pjHYZNSdftE57O8ZelQWHN+Zqj+iE8CHXakTbCY4HNOCc3sEJ5I/LoUs4xUoTdTEiOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4441.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199018)(478600001)(38350700002)(36756003)(38100700002)(83380400001)(2616005)(26005)(6486002)(6512007)(6666004)(186003)(66574015)(6506007)(52116002)(41300700001)(8936002)(316002)(54906003)(5660300002)(2906002)(7416002)(86362001)(44832011)(66476007)(66556008)(66946007)(4326008)(6916009)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1pTOGpjTkRySWkzcnN0V0pjZ1pEUFVmOWNYZ1JOWkZwNDFTWmg2UTJndWF5?=
 =?utf-8?B?eGo4aWducEVabWZTZ1RKM3Jzcm1FcTN1VUtwV1NmZDkrekJpZDRXeFlYM3Ur?=
 =?utf-8?B?cFRQRkY4Q2FJMzRZZVQyNlZJd1lSdFU1RFFUT3ZqZm5EVDNMdzJuNHZmZXVY?=
 =?utf-8?B?RzMvQktoalFuRVlOTko3OVQzZXZ5RmQyV3J0dlpGRlIyYm5EcTludWUyWVlW?=
 =?utf-8?B?TDlxYzczZ3ptSTVnSmpLb3VPWjMyYVpha05vR2N0UTk5USsxaFdKRVh4Y3pk?=
 =?utf-8?B?b0R4QkF4SldPVXM3M0crMEc2WDV5cDhCVlhqWHZhd3k4ZUxOSzQ1TFkxeExi?=
 =?utf-8?B?MjdPOXZZaGZuREsvdjBLZld6cm1JTllhZWVIVE92Q1NhcjFyWDluUm00bHNv?=
 =?utf-8?B?RXRETjJIdWNWOEJFdXA0WThkd3BxQndUdUlhTkdwMzIvNFQ5SCs3UmZYTzdq?=
 =?utf-8?B?TUNoOUNLZGhPUGtocndtQ2tDNjVFUnBDZjBvR1hFNzNnekUzV1hNaHdXMU9T?=
 =?utf-8?B?SSthcnZoSUo4NklPR0ROdUtyZHM5Q3g5ZmJLMUNXcS9MRmlJdHArbElZdHdT?=
 =?utf-8?B?MFk1KzlHemVEOWEyNlV3L2l1c0hDN3JLUVpFaGZJWk93dU0wSVNFbDdRU3VR?=
 =?utf-8?B?ZHVnSWUyaGlXaDdtWkNWYmtEbDhJMmtoUEpVS0E0c2grUDQyUWZYcjVxdDdO?=
 =?utf-8?B?M2xoN0c1cjFoeFY3QzZGS2prZmlzdFlPakY0dUs2bFM3NUhyU01hbjZ5UjJa?=
 =?utf-8?B?ZjhhTWQ3WUxRbFBKRVg1OFRENU42TUZPU3hvdTZZeTJLV2lrdTFjdHFJY1J4?=
 =?utf-8?B?c3FrdUhFTmh5QjBWNWQ2bXJYSzFwc0dmVDNTb1Y1M2ZFQXd1NGdOUzVFQWc1?=
 =?utf-8?B?djUzSW10Q0M1cmZqVitvaHJDbW1KTzNLWUNNSjhBQlI2MDZVTEF2MVRJdkZN?=
 =?utf-8?B?a2Y4N294U0diVE82cjVpWVdSUUlLMEovRTlrYlJ2KzZpWXlJdDh2bFZHYUlO?=
 =?utf-8?B?UVdJYW9NaGdXTGJsQkNId1pXaDRwb3RWdm91VlhDZ1pKMlRhQzZydVh6cm1h?=
 =?utf-8?B?c0pYMFppSFBPS0crZXl0b0NQM3U5eFZCMmpUYi9RbG5ia2pJdzIxTXQrRjQy?=
 =?utf-8?B?VEx1bytTVWFjMGxvemRuWmVXYWVDRElxZEF3YllRdG1rOGZkQk1aWE4xdDhm?=
 =?utf-8?B?TXRVaGd0a0QrYlRYMWlwTWJYeU14SFdOWVpaMnZiMk9xelVBdUhQUjRPRTdQ?=
 =?utf-8?B?VXpLYWZLbU0xT3dhQWtHdE40V1dVY1V6cTdWTXlYRU1KWEd0NFpuOW5XMGJQ?=
 =?utf-8?B?YVBqc0gvL0wvRXdWLzFoUW4vTUU2Znc0eFZJcEVGTzA5aTEzVlh0eXV2M0tX?=
 =?utf-8?B?blkvcmNONUJDQ1c0VVhqd2twaWYrOWVpd0ZCQ3hwbUdNckc3c2cvcG1QOEZ5?=
 =?utf-8?B?dzBtaHFOemlqV0g1MVR0VW5hem1sZWx5TXoyRE0yZHRFa1NvTmZaclI5ckhz?=
 =?utf-8?B?S0ZiK1dFd0pkMlpJakVhcm9yMldzWVZoeXdpdG9JRklVWkppbUxKYmxhaWFP?=
 =?utf-8?B?dTZkcVlEWXhrY0s1cit4VXZheDNpcjJuRnpPR0dxbzZPN0M0dEd5cTNKeEhq?=
 =?utf-8?B?VWdqOU1NZWVDS2VhR3k2NmJGUnhGbVBMWHprdVM1Y2UwLzYyRGdZTkxISmdM?=
 =?utf-8?B?czl6ZURENVhYNlVYcWt0OG4wUHFiR3J4ZWN2YWhLcitwV2xkcFI4VXlkaDZG?=
 =?utf-8?B?L1Rkb3dDSnd3SmJEY1EzenNFSzBpT3U2Q0ZVcE15UVRiU3RCTVk2aXY1ZW9G?=
 =?utf-8?B?cHVIelU2WlQ2MVVYVHlKbDF4V24reFU0SDluRjRKVUFsRDZ3dlZhdXM2dnIr?=
 =?utf-8?B?Y3ltc3RGZldhOU0yT2xhQ3RpTEtRVFJ6SThmdEF5aWtzMVRDSEYrYkoxM2VD?=
 =?utf-8?B?UCsxdHNBQmw1a2hBUmdBUHlEdDNuZ0MyL1RBc293ZE5LaUxDd2lyQ3MzeXU0?=
 =?utf-8?B?SFZwOHJlTmp2ZXAzQkVCZytQcENwbm4xcVRzNlR4L04rQnlQOHExNFVneE94?=
 =?utf-8?B?dXpYN2V1NDhJME5zS2hYK3BPSnFxbmkzYUc0UlQ5cFBmZTNKT2Y2T0pZUy9M?=
 =?utf-8?Q?145NYoUwddJEg4vnOQ8HSbLM0?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3498a64-53d2-4334-ed67-08db04233801
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4441.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 07:09:11.5105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KR3gCUo6+S9O6E/keFzfsMgkAApCeVOCCw3UA7qmA634aH5RVtIiPltTCjKTrlzWOKlAGqwbx9MtZW5vpW4qzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5508
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

U2lsaWNvbiBMYWJzIGFjcXVpcmVkIFJlZHBpbmUgU2lnbmFscyByZWNlbnRseS4gSXQgbmVlZHMg
dG8gY29udGludWUKZ2l2aW5nIHN1cHBvcnQgdG8gdGhlIGV4aXN0aW5nIFJFRFBJTkUgV0lSRUxF
U1MgRFJJVkVSLiBBZGRlZCBuZXcKTWFpbnRhaW5lcnMgZm9yIGl0LgoKU2lnbmVkLW9mZi1ieTog
R2FuYXBhdGhpIEtvbmRyYWp1IDxnYW5hcGF0aGkua29uZHJhanVAc2lsYWJzLmNvbT4KLS0tClYy
OgotIEFkZGVkIHByb3BlciBwcmVmaXggZm9yIHBhdGNoIHN1YmplY3QuCi0gQWxwaGFiZXRpY2Fs
bHkgcmVvcmRlZCB0aGUgbWFpbnRhaW5lcnMgbGlzdC4KLSBBZGRlZCBhIG5ldyBtZW1iZXIgdG8g
dGhlIGxpc3QuCi0tLQogTUFJTlRBSU5FUlMgfCA4ICsrKysrKystCiAxIGZpbGUgY2hhbmdlZCwg
NyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMg
Yi9NQUlOVEFJTkVSUwppbmRleCBlYTk0MWRjLi4wNGEwOGM3IDEwMDY0NAotLS0gYS9NQUlOVEFJ
TkVSUworKysgYi9NQUlOVEFJTkVSUwpAQCAtMTc3MDksOCArMTc3MDksMTQgQEAgUzoJTWFpbnRh
aW5lZAogRjoJZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OS8KIAogUkVEUElORSBX
SVJFTEVTUyBEUklWRVIKK006CUFtb2wgSGFud2F0ZSA8YW1vbC5oYW53YXRlQHNpbGFicy5jb20+
CitNOglHYW5hcGF0aGkgS29uZHJhanUgPGdhbmFwYXRoaS5rb25kcmFqdUBzaWxhYnMuY29tPgor
TToJSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgorTToJTmFy
YXNpbWhhIEFudW1vbHUgPG5hcmFzaW1oYS5hbnVtb2x1QHNpbGFicy5jb20+CitNOglTaGl2YW5h
ZGFtIEd1ZGUgPHNoaXZhbmFkYW0uZ3VkZUBzaWxhYnMuY29tPgorTToJU3Jpbml2YXMgQ2hhcHBp
ZGkgPHNyaW5pdmFzLmNoYXBwaWRpQHNpbGFicy5jb20+CiBMOglsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmcKLVM6CU9ycGhhbgorUzoJTWFpbnRhaW5lZAogRjoJZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcnNpLwogCiBSRUdJU1RFUiBNQVAgQUJTVFJBQ1RJT04KLS0gCjIuNS41Cgo=
