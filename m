Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2E4B846B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiBPJcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:32:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiBPJcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:32:04 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41D99AE46;
        Wed, 16 Feb 2022 01:31:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrRNAx1263jSra6Xo20WmHHSrCsUEoryc9gftVmKgjFyVT2gVIknyUovoIUB2nzuMoRCABv65ReIkfDQMUfWdpbvsZNEb251tP/U1LVmtgQIRqXtDvwIUYqBagFsI6TW1lEYnKcwdjaWNrs/Pal66Uqs5HCZ4vuvDXp61belFICYqOkrXgOyxWG3y5bOU0T/4vaAPYb5R0ZFlxGYvzBzcgm5VgBuNJyhMXN2s4iRa78p9UNFOlPiPTppWkj7qMO6j63kB9OQpd+1LDz+DpXkeNi/LOu7fDfI4TnxgJvpMGP7IOxg175ELJbPFr2/5WVrRZiM/IUPmTiwhr8Ko54eig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWOwn1GnKjwSy8Gf5ME1ihXMyTNHn/MamwdclytDq4M=;
 b=ZkGKgfPdBbATXiBctFv5ntWWpAcNMN5DNhoRavym9DV+MRFfQ25WCWksifnYBK2WImhu/9b8dnPdEY9+Q0GTe1bpYfH78V1m5aAlnOiQWnparDL3QXN6lTI9bt7Ffcux8LEpx5gkAsVdZFgsELzRixgftU++b9aBSiwj1lAs3GLbqH3edKUM1063RG4iPGTX+9huDc272GASnZRdr5sV/JXHQlROuqe4jAwyMxjrdyt09HF/vV3Al3sJwwIe/rYC04OP2vOwlyTTi7rlsZJmIwSAJImjgkm4F0k88xJdrjDEYFek1Nta7MPBMiy3/8djUnv2MqH1rvJ8dQJnYs28Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PWOwn1GnKjwSy8Gf5ME1ihXMyTNHn/MamwdclytDq4M=;
 b=Vw+KvlP/i4capshFhResBwK0nxHT3il20XwPn3xBe7/YIFVCdiGVzJVK5ymxIcbZbxP7fgxFjcn4H4lKeJULolYZ/OjZilyH6OZWL40wRvYYklW/0NgfUYzwRGWmBpmZV7haTeaE4YvCOEGJGJCmVJQ2PaMnkGv6vwnvn3W3k3w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 09:31:48 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 09:31:48 +0000
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
Subject: [PATCH 2/2] staging: wfx: apply the necessary SDIO quirks for the Silabs WF200
Date:   Wed, 16 Feb 2022 10:31:12 +0100
Message-Id: <20220216093112.92469-3-Jerome.Pouiller@silabs.com>
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
X-MS-Office365-Filtering-Correlation-Id: bb6d7b26-aebd-46ed-029e-08d9f12f27a5
X-MS-TrafficTypeDiagnostic: PH0PR11MB5029:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5029524A8BE619390CAB983C93359@PH0PR11MB5029.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Egn3s5uaN5TFiu7vC78cV6ExM2yhApNnmnaxW1kiVtcoZXJAI7xhyY4FRmqZ1QD7n/U0QxsQgEdwXfnhEE9AM7TJdZH6xnktw6n//+CvQrW//KS88HJItOwSX655CxjG986K+tCHPBV+2he9MpDMRsPd4cZ8oCzFGkSQeviLcCLtGglKGigugTaegF8TovEjjSzt7o0VCp85KP0ppAEhWDGM+SQI76pzMQcJtApuQE9gsdYvEcU+HMl+WZFi6oYmdM4hTs+RBvpd8MFsgdxQFdq5ypMRG7KeeIgZkb+Ta0PE0jE2X57FvdUAM1n29E91JwIjGLi5nngSzquyqkUqjTsPAH9uSw/aJqp7m8DaXzv4/zZVn63+31jYPTFyA5ceMww3aQRAOBZfZG1One2DoiT5yBIK1bYVNGjk8ajlH2TVp58TL2OTzuUl/oj1fliIuku21mICotHLx53DX+oKoOoAm7f+4d2VTyQazM05PEvf+uiQiiNE45fbn8x42UiZsmqNJN3gPAFBd9SQo16kKP5kE3xmI5uOkJMBGzEtoCNjLLaEgiUnjPMfpun2HtrlNIVYITToitRBlgw2KZeULPaJfqrOOPJaA1GdbckYGujA2feh0FK0wDlZMJkNbYX9hwZwSG8IraHEXaLjK/eSgLggIa+enRi2KAPBpC1Tb3H3D9r4UtMxhF0Urkp/UJ3Pr1ouBEwfBsmNeMzJ1L6Ryg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(66946007)(508600001)(6506007)(6666004)(6512007)(8936002)(54906003)(66556008)(8676002)(4326008)(2616005)(1076003)(66476007)(316002)(6916009)(26005)(83380400001)(107886003)(6486002)(38100700002)(86362001)(2906002)(7416002)(5660300002)(52116002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjVSR0VUdjh4QnVjOFJ4aWZCT01ZVmZ6SENtZzNPMXk3bFRWS3lISDZ5cmZR?=
 =?utf-8?B?Zk5jbXNFakplZXd4OVBLZDhQNGR4SThGN0lOdWlvRjBoWHllQUlicUFRY21U?=
 =?utf-8?B?ZWc2VGpCdHlGbTVsOEJpa1gyOFlQb3UzYm1SYTdaV2V3amdoMldpT1ZWT05j?=
 =?utf-8?B?a29UL2RtRTJCeFNSQ1cwelZzTzBtQTNpMFhBVloxVHlieW8rOVNtdTdDVFlw?=
 =?utf-8?B?Z2JKYlJNVGovNkhFVXhOQ2dQRHA0ZGV5M3V0OXRFRUQ5ODZKWExqTFpFSGtr?=
 =?utf-8?B?V3BCdmxLZjFVeGdPVjlrbEd4ck5ZNVV6WllxWHRKSUFBWGhyWURjUmlJMG9U?=
 =?utf-8?B?VjNSSlZTUHE1SWNNaG5LMWs3YUcwakFWSHdYL2lvcy9BczB5VndiaEJMcS9w?=
 =?utf-8?B?a05leS9mSHFhSFZLaU9zNkEyVDgvdi8zUVpueEJWZlZTQld4ekQ3NVE4dzht?=
 =?utf-8?B?NlFiNnhiaWRxeFhLT2J1RmI2aG01amIyUjZsWmw3blNHT1FqaEFpMFppWTY2?=
 =?utf-8?B?M0pCYmk3czRZT2xaRkdaSjU0SzZvWHVnTFl2WEs5YXBDZ0Q2OUk5NWxyenB6?=
 =?utf-8?B?cmNUMXYvdVFtK0dmQzlBK01XV2pUYTFxNWRMVSt0dVpBUUVFb1RKMHV5WWwz?=
 =?utf-8?B?SW1sWG9uNC9Lamlha3JZbW44bTMySVJBV3BBQ2c2TnpGa2lWSE5oZ3UvTEFB?=
 =?utf-8?B?SzV3MjdTMzZ0U05pelhmd2dJNWNMTlRsVS9LOHBYc2c2QUdWTFl6QlJuNktR?=
 =?utf-8?B?eXZVNnFlOVJCcDM1cWlIcDM1NTF4c0NSUnJVb0VobFlmaFNHWEczYmtNdkVH?=
 =?utf-8?B?Q1VJOG1yRllmMFlMcFFSR1FYTzRFUzhHZTRQRWNTUHd4aWpnaVpTNlFxcXBi?=
 =?utf-8?B?RFhNL2VmUzdYRXJnVU5Jano5NXhBUit1d0lRaU5DUzZBSnYyblA2TWlkUGNu?=
 =?utf-8?B?MjZGSVR2ZUNLenNTblQyOFJoRkRrbUFQSytGR3hLMU50cEpFN294ZFBxd0xn?=
 =?utf-8?B?YjR0U1FMeVdDdHhQNzNVcTNMTElFN0wxM2pjclNmbWFPMEdUTTEyTFN4OGlw?=
 =?utf-8?B?bCtiRGlsN0YrckJBMVhxVXN2dVFXeUUxalBiK2FQRFQweThUTHBaL3M4d1Zl?=
 =?utf-8?B?T1ZEVzE2aUZmeGhGQkZRdldtcXpMdHhydFF6QlJDWXliYStVYTVCbWJybjFx?=
 =?utf-8?B?TWx0Qjc2M2pGNFRyUi9UT1NlOVNEd29yOVZGOGlSY21pL0JOVFl6ZytIZm9h?=
 =?utf-8?B?NzhxVDExUGFPbFVXazZMTnZNY1crR0o1KzNQRklOaWsvSklVVURBOWQyVnZM?=
 =?utf-8?B?RlFhOGxRbEdKQitHcGZLTFh1czdlNjVrVUJGSDJtTWxiK0Q4UTN1eU1MZGcz?=
 =?utf-8?B?ODJsaVN0Nk9BLzdFY3NKdmJqdkd0N3VVY1pKRFVYRzUzaVdieHNZZVlIQjNX?=
 =?utf-8?B?dkVVYkVadGhXNmdVVkthUC9GOGxEMUhYcm1ZWGk2d3k1Uk1wREtvc1FDYnBT?=
 =?utf-8?B?YlMrekJzYzZJRXlUdDIvNHpYTUx3OEVOSVBvNUZZYndwaHpIS3Y4NXRqekN4?=
 =?utf-8?B?MXRHcUtFOWtBT09uVkMxenRzYW5GSkxqVGhCbzR0M1gyT3dtU1R2ZDZITUFy?=
 =?utf-8?B?dU1mSXdNaHIvMzRDQVFmc25WSXZpU1AzVUdSdHBPdHlrcXRodjQxWGorOGNi?=
 =?utf-8?B?UkhyQVVwM1lWSEdIU2NLK3pJdGQ4NERUUkpLTWZETkdBZEV4TEcrRE5PcFR4?=
 =?utf-8?B?bGdCTElkelcrUnVyVm1JcHVRZDRQdzE1MHVkTmRtbEpqSTJYZGpJVS9qVHkw?=
 =?utf-8?B?Z3dJVXJjTFlWNHBNNW1vOHpsMk9oVjVDR0RtMVR0QmM0VmFndDBTMElVTzRL?=
 =?utf-8?B?SEZCK1dkUWhXK2lGNkdGUGZNUDVINWRRMUZKdDFrNXhRbEJvemJzQ3Y0YUE3?=
 =?utf-8?B?QWttL2UwMVU3bzdqSGpXY2xqRnMwTEtQRGlYZ3drTGZ2dlJ1ZHJCRnhlZVZ3?=
 =?utf-8?B?T0FFWEpqUW5pWEg5YTFiQ1N6Tm5lV3Vxa01xM05ibzBpcnpsM3NvRVpXeUxS?=
 =?utf-8?B?NFZUc3JMZzFUQUJ0Sm5sYnJZTFBwTEVqZE5yV21uSGM3bVFIYXN3Z3Y1M2J0?=
 =?utf-8?B?eVBWMGExa2p2eG4yR2gzckRubnVFRzVOOUY2VE1HUHVXRnVoWWkvL0VFUFgw?=
 =?utf-8?Q?3Utl0p6OlmlW7W8WMmW/SZ8=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb6d7b26-aebd-46ed-029e-08d9f12f27a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 09:31:48.1768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2uYsdyuzISTCjJ1I4tV1lOcMNFoK+7NCZt9Y38uzP9VEqQdeVvyUEHn0ZNQ1PrErZwtxQnrH7SmiU+/Z+qOpQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FORGED_SPF_HELO,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVW50
aWwgbm93LCB0aGUgU0RJTyBxdWlya3MgYXJlIGFwcGxpZWQgZGlyZWN0bHkgZnJvbSB0aGUgZHJp
dmVyLgpIb3dldmVyLCBpdCBpcyBiZXR0ZXIgdG8gYXBwbHkgdGhlIHF1aXJrcyBiZWZvcmUgZHJp
dmVyIHByb2JpbmcuIFNvLAp0aGlzIHBhdGNoIHJlbG9jYXRlIHRoZSBxdWlya3MgaW4gdGhlIE1N
QyBmcmFtZXdvcmsuCgpOb3RlIHRoYXQgdGhlIFdGMjAwIGhhcyBubyB2YWxpZCBTRElPIFZJRC9Q
SUQuIFRoZXJlZm9yZSwgd2UgbWF0Y2ggRFQKcmF0aGVyIHRoYW4gb24gdGhlIFNESU8gVklEL1BJ
RC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4KLS0tCiBkcml2ZXJzL21tYy9jb3JlL3F1aXJrcy5oICAgICAgfCA1ICsrKysrCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMgfCAzIC0tLQogMiBmaWxlcyBjaGFuZ2VkLCA1
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMv
Y29yZS9xdWlya3MuaCBiL2RyaXZlcnMvbW1jL2NvcmUvcXVpcmtzLmgKaW5kZXggMjBmNTY4NzI3
Mjc3Li5mODc5ZGM2M2Q5MzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbW1jL2NvcmUvcXVpcmtzLmgK
KysrIGIvZHJpdmVycy9tbWMvY29yZS9xdWlya3MuaApAQCAtMTQ5LDYgKzE0OSwxMSBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IG1tY19maXh1cCBfX21heWJlX3VudXNlZCBzZGlvX2ZpeHVwX21ldGhv
ZHNbXSA9IHsKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbW1jX2ZpeHVwIF9fbWF5YmVfdW51c2VkIHNk
aW9fY2FyZF9pbml0X21ldGhvZHNbXSA9IHsKIAlTRElPX0ZJWFVQX0NPTVBBVElCTEUoInRpLHds
MTI1MSIsIHdsMTI1MV9xdWlyaywgMCksCiAKKwlTRElPX0ZJWFVQX0NPTVBBVElCTEUoInNpbGFi
cyx3ZjIwMCIsIGFkZF9xdWlyaywKKwkJCSAgICAgIE1NQ19RVUlSS19CUk9LRU5fQllURV9NT0RF
XzUxMiB8CisJCQkgICAgICBNTUNfUVVJUktfTEVOSUVOVF9GTjAgfAorCQkJICAgICAgTU1DX1FV
SVJLX0JMS1NaX0ZPUl9CWVRFX01PREUpLAorCiAJRU5EX0ZJWFVQCiB9OwogCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zZGlvLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1
c19zZGlvLmMKaW5kZXggMzEyZDJkMzkxYTI0Li41MWEwZDU4YTkwNzAgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1
c19zZGlvLmMKQEAgLTIxNiw5ICsyMTYsNiBAQCBzdGF0aWMgaW50IHdmeF9zZGlvX3Byb2JlKHN0
cnVjdCBzZGlvX2Z1bmMgKmZ1bmMsIGNvbnN0IHN0cnVjdCBzZGlvX2RldmljZV9pZCAqaQogCWJ1
cy0+ZnVuYyA9IGZ1bmM7CiAJYnVzLT5vZl9pcnEgPSBpcnFfb2ZfcGFyc2VfYW5kX21hcChucCwg
MCk7CiAJc2Rpb19zZXRfZHJ2ZGF0YShmdW5jLCBidXMpOwotCWZ1bmMtPmNhcmQtPnF1aXJrcyB8
PSBNTUNfUVVJUktfTEVOSUVOVF9GTjAgfAotCQkJICAgICAgTU1DX1FVSVJLX0JMS1NaX0ZPUl9C
WVRFX01PREUgfAotCQkJICAgICAgTU1DX1FVSVJLX0JST0tFTl9CWVRFX01PREVfNTEyOwogCiAJ
c2Rpb19jbGFpbV9ob3N0KGZ1bmMpOwogCXJldCA9IHNkaW9fZW5hYmxlX2Z1bmMoZnVuYyk7Ci0t
IAoyLjM0LjEKCg==
