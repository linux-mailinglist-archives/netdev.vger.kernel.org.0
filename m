Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80136408BB2
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbhIMNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:05:21 -0400
Received: from mail-dm6nam10on2042.outbound.protection.outlook.com ([40.107.93.42]:9633
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240091AbhIMNEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 09:04:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JtC7cSyeohkk9CAMmRxr55np665xY3G1fj/LRxEXiz125BPsw8IAox9XhnoQ+u2U89YEwcEcIxlIiu1lsQWPDMF9MEIpJVzKB1YIgHlmuo0OoJEUNKUS7oPYp0bn2VoPvurYH0mmmDU++nrPZq+Bo+LBaUcdXSLsoNILj0V9CIxJyijV66zGeUbjNZBOXOM0GuKYLrlQGtJ59wBL07PwmVgPUceUJepeE4XPuadqHB3HX5j9GyfE6b6/RaCgfKlhW6EucZjpUt35SBU+SdaqrxLkhLq98tdKxqUXzxwOA0j42wk5f2LvwQFjdCHgiEjLWUGnR19Ed97vjHw+OtUnUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=LeP/tj+sfDkPiHVqrJJH3mJn/XhuCh5TdIE0XgitP92YwxSjrdOUz+Qchj8WG//EgVihnB1ifwWVUA+VkvbhRFQnvWQpdC+bWfIMbES9EyE6822A6FoWAqlyF7gBe4PtaLyl3DbB91KYkxdOBj0Wh+fOOl11re90KCpkZxpRUzzPSyOzhugATUlSWqHZNQUOSpstU5U9KhhsdVMudfwU/6gPLSmtUpgA4rfCeL0L0Lu6uO/rByVwFeUm1N393tBcD8eL2ITVSGzzgS/nMA7ZEbkIq6jKhTaXWNGZ300pK5W83rae0G+ubE2ITC7rnTAWaDP/1VBEwbwgHtnizQQUuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=f2o0DLIuFmcWUmA5lvZTCzX1BDOwj4TMx2l1AgL59KZbL3h6CnKx+uwb7U0uGm0IU2PNbF1QaRSm8BQbnGs8r539GsOOsiJRsDXxX1OP/mQt/NWHruMCW0NXsq/oMo/pn5oBKx14MOFXnGbhuoaa1/aMfRcKMNgAlRQExlSv2As=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB3502.namprd11.prod.outlook.com (2603:10b6:805:da::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:02:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 13:02:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v3 22/32] staging: wfx: remove useless debug statement
Date:   Mon, 13 Sep 2021 15:01:53 +0200
Message-Id: <20210913130203.1903622-23-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
References: <20210913130203.1903622-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:02:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5a1f103-3945-41d7-d64b-08d976b6cf2d
X-MS-TrafficTypeDiagnostic: SN6PR11MB3502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB3502772739E1CC686A1763E493D99@SN6PR11MB3502.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rvkk0pPXt1qIjKel8MJjeRsoqzn9sm6/PcV78jrDrtdaNmCTPpeepG5dnA86fvZ0Qu54H5IW2tOAIdMuQCmLQhEv2aUMLOvQXQ3X4PjTdtAdWfnCaARbfuDamWSyFjpCiLskuG8jH8mcoQLIaSSvEada7S9Jpz9Z5+4Dq7wuDkptZiUezWV8Vdr7894bwFxvTcqj5Qis6hQrC9DZrfJreFS8xmP0NPXnBlx/Udu72KR/vL/gcNRrmo/ATuNCdhSEpRYlh57Fu6QfM8x8HbudkaBQJiTvb4H1XbUAVP6xUywqlPL2btOVR6fdCBnn5wU/HIOx+Q52tmcdssR2cgy2HeS+fSVigEzvYL3LvZshNXpct5JdZfsbQY2Kd8e6K6KPwgQIFvB+g+I4RvWvZfNhRSaL/OnSxukipqZ+rP7cPcsrfMNpri+JCa4HB5YriLktDesc/a4jvQLI+H5CuLoWh9iD8NNWf7MWTjmSH6XMaTIaF8Xabr9AoF/nOWil5iHDnkdGPVMfT3i8XfanWiMlEAbrTZDeuFFY206LDHFS7FhqEMX0nbQ1ZOVVnBqn2RTzzAqkq7lCzQwUBuSaIeqV+XOAagCBKm8yADhD6O6FQ673GQAprBIDPCTS36nS5pGKn1zJmM65166XYiEcxhuzCldI23Bujx2YYYYxxz4izZvGmOw1F6LqA79/uv9JslV8b7BhzLyt1zat+XRN0AHpfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(396003)(376002)(346002)(366004)(6666004)(316002)(66476007)(8676002)(186003)(4744005)(7696005)(52116002)(66946007)(26005)(4326008)(66556008)(2906002)(54906003)(107886003)(6486002)(2616005)(478600001)(1076003)(36756003)(5660300002)(66574015)(956004)(8936002)(86362001)(38100700002)(38350700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1oybFE5N3R0OVhOeXV5dGdJN0FraGVVTXBmSlNRTnlKRGRhWEJyVy9uRWRW?=
 =?utf-8?B?UHhXREhUUXdyM0FYSTRNcXRHVG54dkFaM0Zvc0tmY0J6dUJVd3FuQittcytz?=
 =?utf-8?B?UVo3NHJhdXUzMmlRaXZDQS8zTjU2SDQzVkNiMWp6VlZXWGo5RzZpMWM2dWdF?=
 =?utf-8?B?SlFwUTkwMFVLVm5OYnpVT0lDQ3IwTjNremxNekxQSXJZb0hnZU5sM1NiaXR4?=
 =?utf-8?B?YTBCdGtJYUZXdnMxRGthM0NldG9GeHhPdkFNNndGVzRObmxyZ2pkRHpIaUJM?=
 =?utf-8?B?NmgrK0c2cmlORndDMzdHekh5VGlUa0luTTRNL0FmT01INmc1V2lSY1l5T0Q3?=
 =?utf-8?B?R1krS3RPZC91VkxjVzg0QkVDOTJiN1hYQjdwN2ZnWGpnY1lXSjdiT2YwR3lw?=
 =?utf-8?B?SEJhaENXd1ErM2tONmczNzI2L1QzSS9SNjdBS0RqbnRjWWhZQnRkanEyVDNa?=
 =?utf-8?B?MTc2U3J5bEdRMDVSa2Y5bVZWMzB6dVg5Vng5MXZVTEI0MUZIcXp0c0pqRzQ3?=
 =?utf-8?B?aHhKV1hGbFp1SGg4eXRrSEZ0eE1uN080eFk3MVRSYmxTTEtzdGQ1UHhiRUVM?=
 =?utf-8?B?ejJJZC82dFNXd3NjWDB4aTVZZ1BGcWIwWktPVVFZb0RXMFJkZjdNdXFJZXBk?=
 =?utf-8?B?K3BZZHNFdzVtcVJJYzY5NTZOT1ZlcXdCeXp5Q3lZUVZNampvaTk4L1NXbW9O?=
 =?utf-8?B?TnkxQVFxeC9vTzJGVUJNb3M0TW9paW5mNkJlVU5UbkltYVlUQlAzOTg1WHl1?=
 =?utf-8?B?UDBxOVVxRDBIQ3FmaHdpbGVIdUU4OTY1eXNNMjB0TzNqVDJIdU9VNWhjWi9W?=
 =?utf-8?B?OVlrdnFaQmpYSEhGd3hyL3ovTEVkZTEzRnU1aGQ3TXNHbWpOelZJbHpianBL?=
 =?utf-8?B?SFlLTlp1UlZWTUtObjRXMkpiclJiRmZQWTBCWmNVdkY1ZlBJRFF0ZnBueit4?=
 =?utf-8?B?UjZUQXdXNzJVckl4QUp5MXIxQk43YzJuZ0FzTk84OFVkOEk2VGNDc0s4ZHUw?=
 =?utf-8?B?QTZldFFXS2w1WGJPckg4WGo5K01acEpqYXZJbzlDV0ViNmpVclhuclVmdGdk?=
 =?utf-8?B?ZU56azlSSTJ4V3o0M0VwVnV0dkhRZUNlTi84bGhpeU1LZVplQUhaWGRXMGJh?=
 =?utf-8?B?a2lZdUltNEIwR045djFVK2l0UFdEMWE2VWRnaUcycnQwK3hxMHRNTmp3YU9Z?=
 =?utf-8?B?VmxMcmV1dytKaFRzTEYrODBKb0dYMGVrZGp3YkJLdUxlWmlYMkE0ajZuYUJj?=
 =?utf-8?B?TlRCTFZRYXJrTFp5aWliOVZ0Vkg3NzYraExKZ0N3Qld3STFUVzBVZDFwbU01?=
 =?utf-8?B?a2JxdVNVb0VqV3UzT1FRTkx6QktPRE1keDZWWlAvL3F6NG1ENkg0enZkOWlG?=
 =?utf-8?B?bzJGZ3F5QkNLOGdnZzRUdytFZVNUOWF6eXFzdXM5TVZUQVdYMG9FQSsvOGo4?=
 =?utf-8?B?SXdGZ0c5UTdkWGFtQy80d2JoVTRxK1BCRkxzWStscmdIVk1sNDFlbnBXNDlG?=
 =?utf-8?B?cGlNaHlDc3R3Wng2ZXZhaksxbHhwMDBWbURzZE9jWXp0MDdSdEY1SjV4SXFT?=
 =?utf-8?B?OUV1Yys2dlZ4bVIrZXhQZmEzSTBuM0JydWlEQkRjM3hYL0o1ZXNVNlVYcXY2?=
 =?utf-8?B?bGtTMVhpMHMzc3Rxa1k2bjVsNm55M3FuMGUydkFHMGJoQng2UzVxbVB6QUl5?=
 =?utf-8?B?UWdVbkgxN1pZMGgyblpOSUo4RkVKU3I2VEVsU1RHYXZUeGhqTFBJMURVbWZT?=
 =?utf-8?Q?D9AEh5+uimgUR4VSs4yHmJBvzBzQn8epavNAkG2?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a1f103-3945-41d7-d64b-08d976b6cf2d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:02:58.4297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2eawy0tq3JHj2AtFtEsGzNJPAjI3ov/2t3wHjI5f/YXRadN5FYAp71qoxm9RztKi/KlnjNWNwU4YdpRaTZqdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3502
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIGVhcmx5IGFnZSwgaXQgd2FzIHVuZXhwZWN0ZWQgdG8gYWNjZXNzIGEgVklGIHRoYXQgZGlk
IG5vdCBleGlzdC4KV2l0aCBjdXJyZW50IGNvZGUsIHRoaXMgaGFwcGVucyBmcmVxdWVudGx5LiBI
YXZpbmcgYSB0cmFjZSBhc3NvY2lhdGVkIG9uCnRoaXMgZXZlbnQgYnJpbmdzIGFic29sdXRlbHkg
bm8gaW5mb3JtYXRpb25zLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCA1
ICstLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDQgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvd2Z4LmgKaW5kZXggNTZmMWU0YmIwYjU3Li5hOGVmYTI1YTM4YWMgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaApA
QCAtOTksMTEgKzk5LDggQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qgd2Z4X3ZpZiAqd2Rldl90b193
dmlmKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQgdmlmX2lkKQogCQlyZXR1cm4gTlVMTDsKIAl9
CiAJdmlmX2lkID0gYXJyYXlfaW5kZXhfbm9zcGVjKHZpZl9pZCwgQVJSQVlfU0laRSh3ZGV2LT52
aWYpKTsKLQlpZiAoIXdkZXYtPnZpZlt2aWZfaWRdKSB7Ci0JCWRldl9kYmcod2Rldi0+ZGV2LCAi
cmVxdWVzdGluZyBub24tYWxsb2NhdGVkIHZpZjogJWRcbiIsCi0JCQl2aWZfaWQpOworCWlmICgh
d2Rldi0+dmlmW3ZpZl9pZF0pCiAJCXJldHVybiBOVUxMOwotCX0KIAlyZXR1cm4gKHN0cnVjdCB3
ZnhfdmlmICopIHdkZXYtPnZpZlt2aWZfaWRdLT5kcnZfcHJpdjsKIH0KIAotLSAKMi4zMy4wCgo=
