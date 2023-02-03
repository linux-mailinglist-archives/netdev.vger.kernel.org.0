Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B063689B2F
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233598AbjBCOLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233616AbjBCOKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:10:50 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2048.outbound.protection.outlook.com [40.107.223.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CB3A9D7E;
        Fri,  3 Feb 2023 06:08:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJFpNgbsrKONTPX/uyI6gPTaUz3c4CG1MWfqwnZbdXPi1KrUG+jjK/YKlfC+7T3/Fac13NSANVWo2G9ouoSXJ+8b3dTx7OKBHIPFLv+nWCsifUp3ZkwbMrTsZL0UUSs2th1M7FI/zLlOnpOvT6FXsSusWodHcFi/lyvFNqzgjbSeUqY3kLL9DeUKIrnJniMdJfaIQ5SDWezbQ7pcaT+aVCSC92a9JB2n6mz3syTRIgDQCw4rH4FnC3x1gAUf+U22lgbzbFxQCP9YLzUCqQii2zAnaDGn1fJBHHO4jRieaKyMp/LYMUXO4M6gSZAb9vXJKp8x2aLWx47XXZOn/egd2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSN02T+fCF0YHOt3GpqIJSUmhsmryuN72KWpKmrSX2M=;
 b=Jy9SEI5MUKkLQzrZ1bdBsATUfvENYF8w7qt7UOly2khS8dVMKb0tfKdoteMZD1qkRZki0Ka1wc4P0OYw+LrqHI+7vFlNvHdn1kmOuanZjY1gYCG56DvhlRAJROFvJmoEo6kBLWTM0mkdH4+bp8gxiJr4ukPsGfeNm2xJrncDMvlWZiihngbCIzjn8NjfkMYYj5PYZgQ/e+7Y8VIFEfT7LLWPJgFzfIheSNHOfjKPA6HK1lgA2ZLDakRNstE4tpGPRhj29XUiiHQ6Y4XPTcwbt0FwedBE+W3flipKGLBvyz171PLjQBfu9ThwcoDYF31bwWdrUwKZ96JHJt3MsYTVfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSN02T+fCF0YHOt3GpqIJSUmhsmryuN72KWpKmrSX2M=;
 b=XTlfxr6rzBK1O/XfUOyHbU8eGZ80LNZ53FbqgVSAQk5wiEBiVYYR8u44mESLQju8ISQWn6wUlaL/kEwlabiSAW6ezBcODGH1Py0nfpFMBdXHeHu5jpIz0dXI/H2QrhKl1DAdXFa+PBYLTqQDTFe06jtXqYP8glqggHoNx0VEjvI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from DM6PR11MB4441.namprd11.prod.outlook.com (2603:10b6:5:200::11)
 by IA1PR11MB6371.namprd11.prod.outlook.com (2603:10b6:208:3ad::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 14:08:19 +0000
Received: from DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60]) by DM6PR11MB4441.namprd11.prod.outlook.com
 ([fe80::54c9:632e:150:7b60%2]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:08:19 +0000
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
Subject: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
Date:   Fri,  3 Feb 2023 19:38:01 +0530
Message-Id: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
X-Mailer: git-send-email 2.5.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: MAXP287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::21) To DM6PR11MB4441.namprd11.prod.outlook.com
 (2603:10b6:5:200::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB4441:EE_|IA1PR11MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: 32907513-0ce4-4291-2056-08db05f01a22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jss0C+471SjfBSA28kYN/5quvXCfQ2wYoq8spxW6FcT1AC2isJDCqnHKOAm7aj4dA7x+4HljsZw4aTu7ti8SQs2qEF6OSJdFvRqfDj1LBQrRvfyRzykjBgiHBTWfhAMVEK18tJWDQinsF/C0EDlPSXU3PPp+dFYXS/a1heb/1ef8atBacyf4L5q8/D+eGrQEM+5hh+uUtxfkrvGJTa/8xkrqXiyS+T1OjiHItiVxlsmnw2J4y6aG/G6Jh5dvGVbRTW1hplYA2YOgh+Qo+GhIossjysA404iYh4Gr8jIKWPw5z/1+Yrl6WKWXGxan+xz7Y5ZCnH5hVN4+Hrw7OHz/PHILw6Ywiu4x3LP7E1Xoe6q9gxiXmivraaS3B5Gcv0iXhpfyyZ5Ll1UAOla0DQw/mZ69XZQjn+L4r5447gUuLDNlSQ+CLzLZ2YQ+CsJwPWAVoXO+Cg9+dFxsJR9t+cbLd2F6h86q5jLKfdwykEmCQPHNd9iWtplVcIEvd56qm/snR224y3TVEMaT/U8NCjCplJ6Xed0eRwS9vmvix8bjzPAyds6S3PbinK4z5N5XVzy6FBJXeOyZph/4gehqnc88bjQOXi9wTcpnM8gDMCrX0we5vxTWPlWiLiUkfu5ADUOT9uLJUOM9Pils5W8S536kwuOZEpGoBGqJYUmnJCftnHVJQRJxcF6oZXK3eayeYlOST3noaDrpU/0xzQa/AdH+KA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4441.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(6666004)(36756003)(478600001)(6486002)(2616005)(6512007)(66574015)(83380400001)(86362001)(38100700002)(6506007)(38350700002)(26005)(186003)(8936002)(41300700001)(2906002)(5660300002)(7416002)(44832011)(54906003)(8676002)(52116002)(66556008)(6916009)(4326008)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OER3Nk0wSXFWU2Q2V3dHYk9DTGg2ZW5HK1dsSlJTdEQrQ2hwemFadDRYYXdC?=
 =?utf-8?B?VDA1cTFSUkIvMXE1NDJTQkFsSTJxVmxkVFd1QUFlUk1QeGtmS2JzVFExSDFs?=
 =?utf-8?B?N2xPRU14NnlzdXc0a2tvR1RvUFNuTWUwclVRenI3cytIL2QweHhPY05Ca01N?=
 =?utf-8?B?M1c5SytIcENIN3FGV1gwdFM3SnlsU2YwNmk5NlMxSGtVZ005L28vUnZ0SjVE?=
 =?utf-8?B?aUdZOE5hRVpuaHNta1FpWTV1OSs1ckY4ZHowUkNxQzF4NzkzVmM3MmhNWlg4?=
 =?utf-8?B?emx6eFdwbWFQVzgrbjRMa085WndQckNzeGJLZVlCWms3aklzamVQclA0cTh6?=
 =?utf-8?B?QTZQbGpHa2dkdDliTGh6YXBZUG9UYWhZWTBNbDlCODNlaGlObVBKd1RKZEVI?=
 =?utf-8?B?czVZMTB4NE1ZMUtXQk0va3lJRU8wRUxST3ByV3lzeWM3aUVpR0JkeVBGNkR2?=
 =?utf-8?B?cUgvSURoU1ZEZ0FWcTZlT1I2NU9iRzl1bnhBVnhiemZNWi9QZkg3M2RuczBS?=
 =?utf-8?B?VUVUcytqaTZjZlBGMjhZVnIxQ3Y3Mis3S1ZoYVJkS3d4SzBMR2sxbHN2RGM5?=
 =?utf-8?B?QktaRGRzTTFvb2RUZGgwMzFmSnJZNm85UzBkUEh1Y0dZNE1UekloeTZrTjlL?=
 =?utf-8?B?ZDllQzFDZDFzTFZ5STdDMGYvOTJsNitQM2ZhUVBoWEFXNUZ0RmpWUW9SbUJh?=
 =?utf-8?B?ckY0QUtkc0xGbjBib0oyS0VEY3l1eW8vb2hzc09zejhGNjJhNHpsOTMzTzgv?=
 =?utf-8?B?VTlBeGVxcHRoMWNXOHBoZDJnSm1KWldueDY3V05SVnpKN3JvY2JOL3paVlI0?=
 =?utf-8?B?czlXSVZSVlhSb3BRUnVxcjhMa1F2NjdmRU1KclBEcml6Z2dXc0F4aW55ME4v?=
 =?utf-8?B?d1IxTmNVa1hka3lNWkMxT2h0OXRWdjRKSDZUeEM5UmxLbnRscjltUGQ3cUx1?=
 =?utf-8?B?MDJ5RmJRMzRnMlJpcjBVd21XY0hvS1JIdDM5Z010SmdrcEFNQUJibFlKT0ww?=
 =?utf-8?B?SG83MmR0a1NXMStOR203aEtOTDcvdU9wbk1UVVlxZm0zcHl5M3gzSFpOWUUw?=
 =?utf-8?B?N0NWWUN2cndjNURFNUNaZjJ2M0RHV2FYbGdwM0NWRkZHTFFrNmd5YkpudHhX?=
 =?utf-8?B?dFBLZGdYQ3c3aHduZFBJbkxpNld0ZmxzWEpnbEhNaUZKN1ZHakZkRFVzaGJx?=
 =?utf-8?B?NkZIalBrd0pwMldHWFJOamtjWkpNbTVoTVJWQ3o3aUkyMjNkWWYzYjFEczhW?=
 =?utf-8?B?NGVsNkx4Rittd1duVUJSa05mS1hkOGVoeG1GcmdOYVRNN0hJeGpkNHdtK09U?=
 =?utf-8?B?L3RVTHVTK204ZnVDZmlZRFpHMFcyQ01aMHFLY2ZmVGI4OXhUdytpOHNQdDdk?=
 =?utf-8?B?RGZ3SG5rVFI0Z1BtYkI5N2UyamlsbDd2WFk4RGFEZ290YVphSzF0eitZbWtM?=
 =?utf-8?B?T2dxV2pYNWtMeFJqNk9UMi9ScXVLeDV2alErVXR1cEhJeE5QOGxNMitod0FI?=
 =?utf-8?B?MHpLUlk5QzMvMFF6dUkwbFgvSTFwU0tnRW9SajEycnFHMlB2WkFJSi9RaFVq?=
 =?utf-8?B?bERMOVZIeWlScThBSlRIVFhUL1FLVDI5QlUweGVpbytRMllLL0lQZVd3aGVS?=
 =?utf-8?B?N2didVJxcDZ3UFl1NEUrWkNTcmlTNEdlTzFuWjBhOHNUUzVTQ0ErMGp6UXhP?=
 =?utf-8?B?ZUxJNHBZeWpoeWUwU1VLWEdVdzB2MUJLaENWQS9lVkxCNEh1MEljWmJTYUxG?=
 =?utf-8?B?T3BTRTM3a00wTlltakdlSHA0cVRGeTRISkN6ak8zWEhmQ3g1d2pLeDdPMDJK?=
 =?utf-8?B?WEtpZTVCMnErNytGZlA2MnpTMjcwQXlkSFlyUGJnamlXY2QvQ0Y1TG43cW0v?=
 =?utf-8?B?MDBBdHVFV0JRcXpVWXNQNW8vdm1TUUdzNHJSRyt3aTNMeTFSekZ0Q3IvZjdW?=
 =?utf-8?B?TmZ1RjJwL1lkOW83a2R2OU5xYXhwNkZvYmloTm5FQnpzeHNyKzdpcXV1eEk2?=
 =?utf-8?B?VDFZUGlqZUd4c21XbzdiaWgzSVB3MzFVWk9Bb0FRZjZqbWlzUzd1L25XWFVo?=
 =?utf-8?B?dlFtazRiRUMzRUplZ3BSNUVuVXNkWWdqV2VVamk4QlRTcVRzZStVM2NSVUxq?=
 =?utf-8?Q?0kCdwNDun9Iqu4NB+1q+Bx7G2?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32907513-0ce4-4291-2056-08db05f01a22
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4441.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:08:19.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d9dqcqmqgVL3uv6CU5BITHlqYb/DaB7BQirnCrsvjGpcan6P2tzjdlEvax7wuy3mm4NG3Vitb0zs/BnA4quNAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6371
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
U1MgRFJJVkVSLiBUaGlzIHBhdGNoIGFkZHMKbmV3IE1haW50YWluZXJzIGZvciBpdC4KClNpZ25l
ZC1vZmYtYnk6IEdhbmFwYXRoaSBLb25kcmFqdSA8Z2FuYXBhdGhpLmtvbmRyYWp1QHNpbGFicy5j
b20+Ci0tLQpWMjoKLSBBZGQgcHJvcGVyIHByZWZpeCBmb3IgcGF0Y2ggc3ViamVjdC4KLSBSZW9y
ZGVyIHRoZSBtYWludGFpbmVycyBsaXN0IGFscGhhYmV0aWNhbGx5LgotIEFkZCBhIG5ldyBtZW1i
ZXIgdG8gdGhlIGxpc3QuCi0tLQpWMzoKLSBGaXggc2VudGVuY2UgZm9ybWF0aW9uIGluIHRoZSBw
YXRjaCBzdWJqZWN0IGFuZCBkZXNjcmlwdGlvbi4KLS0tCgogTUFJTlRBSU5FUlMgfCA4ICsrKysr
KystCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZm
IC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUwppbmRleCBlYTk0MWRjLi4wNGEwOGM3
IDEwMDY0NAotLS0gYS9NQUlOVEFJTkVSUworKysgYi9NQUlOVEFJTkVSUwpAQCAtMTc3MDksOCAr
MTc3MDksMTQgQEAgUzoJTWFpbnRhaW5lZAogRjoJZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRl
ay9ydHc4OS8KIAogUkVEUElORSBXSVJFTEVTUyBEUklWRVIKK006CUFtb2wgSGFud2F0ZSA8YW1v
bC5oYW53YXRlQHNpbGFicy5jb20+CitNOglHYW5hcGF0aGkgS29uZHJhanUgPGdhbmFwYXRoaS5r
b25kcmFqdUBzaWxhYnMuY29tPgorTToJSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxl
ckBzaWxhYnMuY29tPgorTToJTmFyYXNpbWhhIEFudW1vbHUgPG5hcmFzaW1oYS5hbnVtb2x1QHNp
bGFicy5jb20+CitNOglTaGl2YW5hZGFtIEd1ZGUgPHNoaXZhbmFkYW0uZ3VkZUBzaWxhYnMuY29t
PgorTToJU3Jpbml2YXMgQ2hhcHBpZGkgPHNyaW5pdmFzLmNoYXBwaWRpQHNpbGFicy5jb20+CiBM
OglsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcKLVM6CU9ycGhhbgorUzoJTWFpbnRhaW5l
ZAogRjoJZHJpdmVycy9uZXQvd2lyZWxlc3MvcnNpLwogCiBSRUdJU1RFUiBNQVAgQUJTVFJBQ1RJ
T04KLS0gCjIuNS41Cgo=
