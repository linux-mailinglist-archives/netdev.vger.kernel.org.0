Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11ED4086B6
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238348AbhIMId7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:33:59 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47168
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238153AbhIMIdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNLBxbZampHeIvpKS4gt6Sf5zdnCyIPOZ+fFhLxpRW+7H5aLf7VMnHwbN9ENfqfg0NQ/uFanCw7dPTU+pXgdGyMgoEveR6ashI5HotZzR1cAzp9BcicreDs8aMvRzW/RZvDDlinGlXDhajAABp1aGWhEzkXFb5l2/I6XDoa3ylxRL4k/aYVHvQ/+8lMMi0TKyX2B/xeoO32BUdzYb5wKKFbANTMPKJpElw3902Rqr7RO4N99H4oE24P6Gl0Fp1BYWJLk0CCMaJoZvsrjSzrVA2tG8Aqj/oxSu9BbhFBRrSWbAFxNhBm/oEWY3M8j4poSUG2MpmXAaljyr2Vdfa85CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=Iv5sb7jRxTUY6DW38gcuIaBnoIxhYrCv66hUu3G2JGf0QpkiIgTwByBBHKhSSMhZ10yemEfGAjuD5pOkIiubsI+MI6WIC67+RaU2agEfINj6f1cnxn53yhlUB1tFmnmUOMpUmsZdVOHWRwDNl3ENP61YYEpLlSHxkc3ubeIBZ5rEt5OBNoZpXL83VsMRURvFmR5hLY88pmbuT1GBVVqlkH4ObJK3wwpkM6wYmKYtpTrgwOjgqmljTXF+TnzBQyb21zgglIbJEyYseJ5H7oONID54/2pbm64IAT9KOGFhNEXQIjIJBiKJFJMlZvfMEwuFLxhyzG93dX0U18B1EsQ4pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=eEOUXY4cn6IQoinINZWs+KYsa39Up77a7R2kojTKjrShbjLuB5S/nyXmBXOuvAqHGJiLrb77dsw8il5hrGOxo3QVKSESId+T4kmb1DhU3++VxxoGmp8MCpOtgDn+5yl6L8qnOsq0NffQby6UgDy/lFDEiCVnfds/NVB9A43U7dE=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:31:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 22/33] staging: wfx: remove useless debug statement
Date:   Mon, 13 Sep 2021 10:30:34 +0200
Message-Id: <20210913083045.1881321-23-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71a2b5c4-c658-417c-6d4d-08d97690eac4
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB27178FF132850B1494CE1B2193D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jloJ/QYivMXd0Vi4neUJCfGLltLma3FYGo1yXlER5JZYVzUuT+bE5QslZ7HzmU0SdNCsGO1gGHQypWhuVyHKuH8l7aUbV+tA/TCuteEqLSe0/oamibucAKV36n49y/ssP/R5zdxQE8++HsYNvlIvhK1tm/TNbhCMEw+/da4WWESg4QzBpvBTsrV7qgCHb8sK4hUzsAgOetSAVyC0JQ3vKqOeqV1m5xlZdNXc9jVqb8unwlWt28Cs3qabutT1qUUh8PohUCiN5oottwQXoGXTe+xzvE93/avt52j43eN/MUytGud0r1SFH4eGjF4cxmXstFICJYW+GMsXXzejop3qBrwYO5HefzlYG5LpYLIJzt0WHgpAkleAO3f2km21F+V6X1sYLXQKKF4x+SvM6/G2d7+Ve09JRkmYUIxjKetRueh/C4Z4z3s2F/yf6qBrdSirc4wKuu5uAzno8Gk433k6VvceJLiX7/JeFuhwXG814rQe6kb7PNLLeSoJ143cU8+gLPKlaNYEeMMtmzHYj4U5xY3pCzBNE1Dl2apx1Vd0s6MG1RlgAvSVLvS8EjLeRUqcT8RUZ5RYuPnBjvcuEfoB2K9LdYKoBJsuonX8ja9zqoGmqGIWC1kfyYGvRiyPNLbd7O8jdyUHO49nLQlX5c6ttpA6nI92eP3gJ4HG0XLQDus7D5peWOm8pDpEV2TLd70yhjHXdx90woHDTGKIKiLBpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(4744005)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXF1OHBDV1FUTE5PSUlYV2JDOU5yRk5PMVVlM245WVJncmxaR1VTeWhEUWZP?=
 =?utf-8?B?MDhUWktlU29rcnBsbURhazZvMEdQTDVHNUM3VytkVElGUXY3UkNPK2Q3T2tM?=
 =?utf-8?B?QkdPMlg0Vi9VbkU2SWpvcGQzclN1alpJVEozQjhzZS9VbXRsdS9kczNOTWNY?=
 =?utf-8?B?OGRXY0x2bmlzSTE2U05nTTJ2d2hHZU9MMlN6YjNzVzZLanVxUlQ3T2hXTzNS?=
 =?utf-8?B?anR2aVk2VU0xQURmYW01cllGYUl4bnM3emFQVVJSL0tVOTdIVE5pUzdaRFgw?=
 =?utf-8?B?a0xKQkZMNUJmNEVMT1hrUHVNbHRYQllKcmxZV2tJTjdXektseCszcURzVFpB?=
 =?utf-8?B?Z1hITFhWT1k5S1VLaFFQaE5LL3JLUkN0NlFxamNHVVd3RW55MUNpSnpNc1Jr?=
 =?utf-8?B?RUtUa0c0QzM5a3VCRlUwYmIrRW0wQ1dUTXFNUHhnb1hqVXFqa3R6akZ1S0k1?=
 =?utf-8?B?NlV1SUgrcm5JYlJjS25kRGNFYnROT3BhSWtjNUdURjhiUDdOQlBaZDFsT2Zy?=
 =?utf-8?B?cEEwOVFnYUl3TnJ0dHVMaHdEOW5iRFJWa2k4WFNYOEpQbFpqcXo4Y0NPVDd5?=
 =?utf-8?B?UEl0dDBadDczZmpsTldJOTE1TmcrVERlUWtJT1A2eTlzUDY3RGg0Q0JWRGNR?=
 =?utf-8?B?YloxZVdwRVJ5cENGazZ0a0ozQmptVWpRRFgrcGNmaWZsYitVYVR6YTk4U09o?=
 =?utf-8?B?ak9FQmNkMEhpRS84cnB1Y3hGM0Qvd05XazBDaXZRQVVDV1lwMmV0ditlckJE?=
 =?utf-8?B?K2NTbW0vdStLd1BqTVdhQXV2V3JhV3Z4YW9DeENEUDVMOHBITUhnTGUzSUEx?=
 =?utf-8?B?SVlhbEd6STRTZUorN2puWUxsNEpxN3ByclkxNGh5eXRJTnIwZ0Z6QmFnQmhr?=
 =?utf-8?B?YVdFZ2RIa29DaDZRQS94MFdTZnc1MzBBcHk2YTZQUlM0enE1VUZiWEVyMHUy?=
 =?utf-8?B?cmRhWHZlZVdrNnZ3dGtxQ0JMSDJFdUczcjQ4a0NuUnpuVUFGcVdpOXdPV3FM?=
 =?utf-8?B?enY3bTQ1UG1xOUN0K0d5OWRCYzU3M0VRNE93djRHOGxjYllwSDR6alJFZ0Jp?=
 =?utf-8?B?Y0pnZ3RxcnlZTk4zWXpXQzVkM3pwZzI0dlhyWXhwQS9lMkJkTmc3VXVYclBu?=
 =?utf-8?B?dGs5OEVkays4OXE1aWJhcWpwN2dBN0VZWFBKZ2M5ckxPNjFBdE52NGUvVTBJ?=
 =?utf-8?B?RGtHM054Z3Q4VkZkOGFHWEM1bjR5NmNPdHdLMXMyMmU0cFUrVTFWWmFlWm5v?=
 =?utf-8?B?aGdrazlWS0QxTzN1b1ZFNC9mU054alhvMkg0emsybFIrSjZrRVZaTEE3TkJ0?=
 =?utf-8?B?QVJLSEhoOUhZcmwyZ01HeVRnWWNHa0JSZGZEWGFaUTA1c2ZSaWtucFR5SW9O?=
 =?utf-8?B?b09ONThEdlFKNC9yZkpuTC8ybDhyc0QxbysyV3Nnd3F2aFZHOXhLbEtEM3ky?=
 =?utf-8?B?d2NwMW1IcmExdGR4dmYzMy85L0ZXd1NiNmFOa0tEK1dGLzhOMk4wdW1ad3Qv?=
 =?utf-8?B?ODZId1JkT2dzWDFoNGpCejhtcGpxeG9QVjk1VkhlTDlIMzQwcWdla015Vjls?=
 =?utf-8?B?SVZOREo5TDJhNEx0a2NEQXJuZzNNL25RSTNMMmxmYjIwY1V4ZlRyZWhJL3cr?=
 =?utf-8?B?cWR5dzVyUXQrb1VidXptM2ZyaHhwYzBjd2tXbkJjVEYzZlZCVWZIU3V6NmxX?=
 =?utf-8?B?ajdYSGJvNnlxcFJWY1JSNXAyK2tzbEhQaEFmeDBmYWZKRHkwb0c0NnVpSTFQ?=
 =?utf-8?Q?iysneGVETrBPSUHivFnBKvixyrKaDX4NYloGeOT?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a2b5c4-c658-417c-6d4d-08d97690eac4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:43.8344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +h3758FUe99H5ehoPy5NldOMi60bkqioFzNuuDjoVtyd+UXPnON6cIfpz9NGwTu3hV3VRcYBVtoOsKAvSyxf+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
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
