Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF8E4B8463
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbiBPJcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:32:04 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiBPJcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:32:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09449AE43;
        Wed, 16 Feb 2022 01:31:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jBgdlHH1+pApWcpY/R8vTzeC9fAf/H4gFdkyWRoUflIkOacGuF/0fp0WdwWc6rNjXD1/+/K9aCzWZd/t6xpToe40tA+nwlVQfDkJk0oSCsvlvQR+mciuAJPJ175mLeAHzIO2s4aD38ORmX7ZcLPtJlaWKE1vvi24eW8yeu4AIwF2P8qXzLwyuJfH7l8Ah8/5UylLp+rrsVMXG9kNksJ20pqYa8oAv58MR1MkRSaYX1ABcmMGdAxRyME+eyarFcZqjotXSAvcMcg7GGHqJsuNlrIQxrXC+UsK3Wq8qsoiITRIdJMOiDDVsRiNJ+NdHiDm6JlfrEfq3GwaWjXGYgwWLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXUUviQ9L3vGUdKHjfXlc+gn0liG7pMo//txll0Wcf0=;
 b=Y128oF2/rvtGP8kdfgBb5J5qvWPU8SUxr44cHCeBweh6eEbzmUpMmkvbRaLpvWxKQaXkRs02586pW5UFNUGs5Ubya2cY3HsoHbzb5z5oxUGlv07cAyauFbIEgS49KEAXeqmJRy6ugWElbQY8o0sGCD0jsqKRtmJomTuOH8amHqcykH6RMger383rzdMCUFprV4Md7DpzhWlWxI1zFVBwXnjJoQ9J8uGTL8eo5OliWEpTdoZI/23It17icanNW+bLs9L7UT9JkU8CG2z2EZRo1IQq3D0K3SL5OaNaSzR8bOlOiC9UMwBF59OcYFl5/4DhnmCe1AcwhgYCVrCQFlMC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aXUUviQ9L3vGUdKHjfXlc+gn0liG7pMo//txll0Wcf0=;
 b=RVM0fuhtzRaZnARPECRxj4XCjxDU3uyMBEO6w+ZQh1EyOiVEpmJQDqZoaYnhlkELmHW1QUMkEeqh5i98AcFpCGIzwzugAXBzSAfHQMqrlrHm2e7iccQ4sqeIPIJr+W7fKj9UJoauj+TWUtBswhnJ+txawKPyBAcoBJf3UbapHc4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 09:31:45 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 09:31:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 1/2] staging: wfx: WF200 has no official SDIO IDs
Date:   Wed, 16 Feb 2022 10:31:11 +0100
Message-Id: <20220216093112.92469-2-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
References: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0050.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::25) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09a763c6-9436-474b-77c5-08d9f12f261b
X-MS-TrafficTypeDiagnostic: PH0PR11MB5143:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5143AA3A9B2A7DF6FAD8BD7293359@PH0PR11MB5143.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9To83nnaBYzEmXl8G1IBDQrI6iDo49RXbxXSn9nCYeDhwqjiZP/MAaMuYYmycbEFg5lrNFqopep6BQxAgvIeNE4ud6owEMpZLwXDzDhgBrTz2XA+02q63mEPQsm0kyDeKFkY9j5cuudCyVHLn+ooCC870xgwRwrfmhK5kF1o91NMNI0pUsQgbPBTko6qJRhrjN/Wc+lvEUFuEzGBHAFdyuu/zhklzqypprazVDMFk3S1EltLoU140sGvh/rE6WV3wpionU+zHcquYxKKVrDe9da2V2z1yC98VctjjezbbuVRPkK4u5RHl8327PhOkQw0qhtMtVZi04daOjSunm+vJblLv9wc/mRN9H2hUNCFO3sDGkwNx89rwxJeFPPLPNmUmKXfHc0qOpOfaaMN//uFqpVCbI40s36hIxqdTbsH8PDva5VNTNrOksewSd+LssIDg1ATC/RX03oVh3dCra4NVsqyK7khHrt4IS+NLLpTXvmaYA4xucMTkxmunKFeN2fzRpRl2cQ9hIJttD2QE7tDjP0W9wuh/exkGxbPBMzIVavNrO8g0Uo/dHNVCZoiyVAQqg8IlSCRSTaNKJJnLVjPszlkiqhtHZsTv5MH25fWgxIkvkyXB++nAD5RcLK9qvPwWuiQVbLLzFzIjOhQogVlD52wtpb8pHxdatyTjd27/Qif7IS0b2nmLkYKXYvxRHFA0m59ar+z2RhiBWXqT+22pA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(36756003)(2906002)(26005)(107886003)(83380400001)(2616005)(6666004)(1076003)(186003)(6512007)(6506007)(52116002)(316002)(508600001)(6486002)(66946007)(54906003)(38350700002)(5660300002)(8936002)(8676002)(6916009)(66476007)(4326008)(66556008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmZQdWhvOVNPN0RnalFXWCtaVnAvMmVPZVluYXVYbS96dWo5dlM4U003bFU2?=
 =?utf-8?B?dnJGVHZzdWc3MCtVRTAvM3ZRL0R3VURmWUs4aWd0Qy80cGJtOE9WRTE0bTBt?=
 =?utf-8?B?WVA2MnkwTTNTRVlmclFTQ0VCdmJtdmwvNkVWZE9ZWXVGYnd4ZzV2VW5DbVN1?=
 =?utf-8?B?MUpyQVN1dXlYTy85aldCWFdmM2ZsTkhJNEMvQjRhOWtWU0o5ZkRrUnByZXJy?=
 =?utf-8?B?TVNDOXI2RHY4Y1JSWnArTUxxWFlMWW9LY0puUEd6N2Z6aVFnVW11N1F0L3VQ?=
 =?utf-8?B?RzBVWGkvYTZlaFV6OG9saG54dDlwbnBmMjVwcCtTWERYdUp4L1ZSUkgvdHdH?=
 =?utf-8?B?SVV1Tlp1M0taSEdWY1RreDJETS9VNDk0TGE5UUJtQ2dKVThwZURaNUNiaWlN?=
 =?utf-8?B?ZENtY3lJY0NkS3BmRE4yV3lUREFneG56dUx3ZTdOYS90alM3VWhMQ1JtcjJG?=
 =?utf-8?B?RkpjQXBTRkdNTVdScHNLM2d4Q0VQQUkvUVFySE00MVJLYWswRHZyZUxaRjRK?=
 =?utf-8?B?bFQrVXFJSlJLZnJ6Z2U5Z2FCVWtEbzlwUXpuSnRRcVFLOENXMldqNUZkSTV6?=
 =?utf-8?B?WkhvQkxacGVIbnQ1VitteHp3NVoxTm5KcUFyYkhYVmoxdERjTkk5WHd0aVd5?=
 =?utf-8?B?NlljQStVNkJSWDlHSUl1eE5yeUNzYkpNYlM3REUra1NMSzdCa2JLY0xRWkpB?=
 =?utf-8?B?WmlyamtMRTZ0M3pmZEdMN3FpbnB5Y0J0SFREZzliSjBnVmQrMzhlSmMrcG9W?=
 =?utf-8?B?VkxUVlBPVk51RmtZWThaVk10Ulo0MlZVZnoxdmFTR1ZIVmtaZk0zV0tNS1JR?=
 =?utf-8?B?SnNoZzFxVkhWOEhGUlRQVmRiY25idFhndHplSGhHcTUySnp3WmNCZ1Y5VG16?=
 =?utf-8?B?UkZnMjBqb0NiYXZ4QmRiUU1zdVZiYzY5cExMUS9xUlYyS3lPc0x1Q0oxdERT?=
 =?utf-8?B?N3J3bTk3SVk0NGY4eTF0NndQejNmZjhORVlvNm1CL2Nka1N2OVJrUDJ4S1Uz?=
 =?utf-8?B?VGZabG9WU0lHU1RsMkJpbEN0NFg4VStPL0NHL3hGZFEyUHZJdEJXZDVGeGdY?=
 =?utf-8?B?TUp1S0ZEcVRqSVRNbWtSZUlpSi9EZTY2SUxDYlo3MktQK3lEWWdJOU83Y056?=
 =?utf-8?B?Q3ZPaktiNThDOEl4UWdOem1HRXV4RG81eFVqem1kU2hRVEJkOSt1dTFoeEZM?=
 =?utf-8?B?VTdEQlBKUHlrdDllcDcxL2J4UFBvQXVLd0FsSmVvQnFPSWVGUE5PbEZ4eXJw?=
 =?utf-8?B?NU1iZXh4Z0xsQVhtZVBwWjV3em83TW5SOW5HOG1yV3ZNempHSEpsMGxMZFBH?=
 =?utf-8?B?dk5sWnFsM3d6VFN5NnRMNENxOG94eFlsdTdhQlo3ZGlHQ1kvdEV6bTFhTXNB?=
 =?utf-8?B?QW94Y0pYZm80ZjZZRkdBZUQ2eWF5LzBxbGVDa2R1c29FamRrZWhDb2piM0Zj?=
 =?utf-8?B?eitkSitMTU9KNVBDNU1ZWlhocGNPTHJHYWx6dVhyMkNKYmlZYlRqNGdjYmlK?=
 =?utf-8?B?cDYyOWJrU0tWNUZMTlh1a3RoQ1VIVTB6Qlo1cllmaDJTdG43ekFxMlllREl1?=
 =?utf-8?B?Slowam9YZVlVc0NDZFF4WjJHR3lkY2NsbnMzMDZNS0lEMUt4L0doRHlORWpI?=
 =?utf-8?B?bFVqQXJvZmprd2xJRE1Wd0tUWGlSNlJYc1p5R2JySUNDemxoRkJLN29ISzVZ?=
 =?utf-8?B?UkdJQ2tYNXgwZTN0K0NTdmM5SkhpSlJOcWxuRkVOVzkvZXZkY0I4M2hrMGRL?=
 =?utf-8?B?QWFkRDZQQTRWT2pWZFUvTTY3QjNJKzE3UHQxT3ZQYUN0VWFLOUd1cGovc2VG?=
 =?utf-8?B?dTVZVlB2MTZrbklQYWhOWFdwUWp0NnZTM0haTkRoeUVldkNhaDVRb2FuZUsy?=
 =?utf-8?B?elllWjcvWVUyWTh2Z1VYcEZtUTVIbDhOdTUzVFN3RmhFbDNzL29NQncxMWVO?=
 =?utf-8?B?TUwxOCsydXdCV01rNHA1RUY0MFR5QWdtbm0vUmpEazhTcUlwdVV0eWExUWt1?=
 =?utf-8?B?NU03SVoxQzUvdUlNS2x0NTNrZ04wMXhSMHRSam5icGs0amJVTmsyWjdkWnVY?=
 =?utf-8?B?QWc3NUd3SlVJRjhLSVJGTTR5eDVadFlsK053ZHVjd0E2NVAvZElYU3lsc3gv?=
 =?utf-8?B?VXVKeVpnQ256Q1FRa2tENVV6R3dJMnlCVE9HOW85YjhWRXN2d1BuaXFDWmFS?=
 =?utf-8?Q?86Yfwc/GHXYbjEeadKzeryY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a763c6-9436-474b-77c5-08d9f12f261b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 09:31:45.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: da021bhSjbv4tUy7GNF4GXdd+l+1V2M/BOFX2StnnzsuUqt4k5HFawPPO6uu9X2FT0u53zOTEoz00w7Nj89Vqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU29t
ZSBtYXkgdGhpbmsgdGhhdCBTRElPX1ZFTkRPUl9JRF9TSUxBQlMgLyBTRElPX0RFVklDRV9JRF9T
SUxBQlNfV0YyMDAKYXJlIG9mZmljaWFsIFNESU8gSURzLiBIb3dldmVyLCBpdCBpcyBub3QgdGhl
IGNhc2UsIHRoZSB2YWx1ZXMgdXNlZCBieQpXRjIwMCBhcmUgbm90IG9mZmljaWFsIChCVFcsIHRo
ZSBkcml2ZXIgcmVseSBvbiB0aGUgRFQgcmF0aGVyIHRoYW4gb24KdGhlIFNESU8gSURzIHRvIHBy
b2JlIHRoZSBkZXZpY2UpLgoKVG8gYXZvaWQgYW55IGNvbmZ1c2lvbiwgcmVtb3ZlIHRoZSBkZWZp
bml0aW9ucyBTRElPXypfSURfU0lMQUJTKiBhbmQgdXNlCnJhdyB2YWx1ZXMuCgpTaWduZWQtb2Zm
LWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQog
ZHJpdmVycy9zdGFnaW5nL3dmeC9idXNfc2Rpby5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQs
IDIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2J1c19zZGlvLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMKaW5k
ZXggYmMzZGY4NWEwNWI2Li4zMTJkMmQzOTFhMjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvYnVzX3NkaW8uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMKQEAg
LTI1NywxMCArMjU3LDkgQEAgc3RhdGljIHZvaWQgd2Z4X3NkaW9fcmVtb3ZlKHN0cnVjdCBzZGlv
X2Z1bmMgKmZ1bmMpCiAJc2Rpb19yZWxlYXNlX2hvc3QoZnVuYyk7CiB9CiAKLSNkZWZpbmUgU0RJ
T19WRU5ET1JfSURfU0lMQUJTICAgICAgICAweDAwMDAKLSNkZWZpbmUgU0RJT19ERVZJQ0VfSURf
U0lMQUJTX1dGMjAwICAweDEwMDAKIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc2Rpb19kZXZpY2VfaWQg
d2Z4X3NkaW9faWRzW10gPSB7Ci0JeyBTRElPX0RFVklDRShTRElPX1ZFTkRPUl9JRF9TSUxBQlMs
IFNESU9fREVWSUNFX0lEX1NJTEFCU19XRjIwMCkgfSwKKwkvKiBXRjIwMCBkb2VzIG5vdCBoYXZl
IG9mZmljaWFsIFZJRC9QSUQgKi8KKwl7IFNESU9fREVWSUNFKDB4MDAwMCwgMHgxMDAwKSB9LAog
CXsgfSwKIH07CiBNT0RVTEVfREVWSUNFX1RBQkxFKHNkaW8sIHdmeF9zZGlvX2lkcyk7Ci0tIAoy
LjM0LjEKCg==
