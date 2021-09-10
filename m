Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2787406EE8
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbhIJQJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:09:14 -0400
Received: from mail-mw2nam10on2058.outbound.protection.outlook.com ([40.107.94.58]:51435
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230010AbhIJQIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dSq7hpQcsEwT0n7VgGC1GbPIXzirulYpvS7JoIF1S8iW8atmuGZYW6XfuOWwx7JFOBWKfxwTasUVWeP2Fd6xDNtQtCBzRa2z7iQGEGSm6+SdBXsrm64g/zDATOaJG4vBw5XpBOlJffyRxOjJthCeSS9EDgQqsb9C6GNz2EsB+INK7UNzOWwZBu34z0Uh/IPqADciKTdWrFFODwm4QoFaH3kNlHVtSqu5W/hyoam8agzRuuLaLFXaoNPNErdV+EUI5Dw2Mua9jqi1z8qBCdEWusDljpbctnhcRd79GGOccAeP8jh0aRGCD/6lcTRuAI4dIsdAyx6M1DDXdoUTXbdqHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=jLdGk0AJDq77llqS7a/TBjNdllPyz9qfRomY/e8MXOFZx3RyDZZ8dy4ylJurtq3Q3V5tiI/8MFV3NA3XRIea3wq3QnoOHf/ADjCeZRj2RK6rNQETQtDkfatdKA8kuBM3pHazT1PL2l75HonE+buGpSysDbHHL4KPF9Uzibs8obAb+4LTas146b4X3GA+ItxpCHiy5EaOCHUvIYRHHR1DBVuADmEet0wlbZmyI9mgXbFcWU6MzkVWhCFfr1n7rghCMuS1I0AySk9ynFspoePtXXJ7fGzNoylRJGOt6kTZdqCb44Ivu0EiYwrQIzx3SSKj1pV2PRsxLJnVEgBzdKw5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDkjZof4E6J1md+k828W5KwU9LtaDDRXypasdbyr1bo=;
 b=gsLrxpUHFqg2CrYApSab9nFuEtCAmmLYnO2xuEB1O+voI3reLf2wZbdUk/LT3Uk3aNAzBs7sTZmjQiVjuaNk0jsEKKzW895jkaGTmenUnyv1HKPeiQtoipMED6e8fd9dfVMbIe8uODBkOeFKuNctAWnZnYsKJiTFULcVJlcum94=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:14 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:14 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 22/31] staging: wfx: remove useless debug statement
Date:   Fri, 10 Sep 2021 18:04:55 +0200
Message-Id: <20210910160504.1794332-23-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5bfbb32-33ef-4e3d-77ea-08d97474ea25
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50024C319DDFBA3F223088E893D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cKsiSgGAELKwg1S4iwg+VTRbu8RsSJRqFH6ZNP/0uV4b49k/yjlNkjSqCJnJ27cVX2ra3N1VK93hjWLYt25FlhYlTZRgpxrxJjO9BPmmuCmfhGNG9wPhPLsYfgxpp1iMiq9lVtCJfwiCo0qlQPD73XDEYqZSJF9aUgLvfsif2cw/8cHPtXf5RG6nkpZTPuy4WD5p+YtZffCW49NV6QvXzhaPSpgOckcZUcgvmfSE9eNJz8U5Ip5+vfjHrOkzdNNjf/li7CuzOKBHLaiWk5oSoBijCi2q8sHT0XuwGvnz+wjE6WzTJB3WnY+M3eED23I8fvyVSMfiddBVIoQax6xEcoF9628Zu1U4tII+ZKLgrPdR5Y+ub0sVI3Ml41ZMbm/3KOnPDOIBbavwcH2/7Y8upZuJOKlDKtLBT8AEbG+J9pU9wVROGKxazv2iFY1NaQq8rvtHecIhKqYdZA5h0ir/VWqhN4RTJrJnCAJD/mMhitY3YZw7o4UOeAj115n51z18ESaaTDyaQI0bH5DINxCbMq+dhN6Qj6obwqPw7p0b43z8w29qAoUuVqpRCdUDphxLxtYJOzP7ZZaHYoyQHiJ5ccvLMEVf2aZwWB9AUuNlDpYaUndpvoz0d7qpKjmaAAWaRgAJ3/Hxj2Z4NQrvweVrYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(66574015)(7696005)(4326008)(508600001)(8676002)(4744005)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFpuVTJpWC9teSsxZTlOTnVEZXhFZ3U3eHBsMHZNM3pUWHRYbDVVQUdnK1lv?=
 =?utf-8?B?RG1UOSthSFR6bzJuL2JqWE93NG91Q3FiaFZzTlZuQVhVRG9HT3ZyY0hkVG9O?=
 =?utf-8?B?VTl1cFdHaGpoR3R3Z1RyZHFrNWhpNlJ0RDZtNGs1TVFmTFJydVdnVm82RWQr?=
 =?utf-8?B?eitLM3JpeFk4MjIvcnA0QVhrUDE3WXRCMlJ3UUtMaWllTVl2NTdpNGdEVW8y?=
 =?utf-8?B?emZXWTlqd3JjYmgwR0Z4S0tlSllyMVI4aWJZVlVoSkxtUXgzd29aeEVMV1NN?=
 =?utf-8?B?a3NvQ1lPbjFlTmNKWDh5THQza1YvYkM0R1Nkb21CTjZMUEtxWmM4aWxTU1ls?=
 =?utf-8?B?ZzI1WFJydXNYRW5OWWdhMDdGYm56M01hWHluOEw1KzhjUUF0UW5abFMyRXpF?=
 =?utf-8?B?Uit6TTNFOEIwMWtaN0xQMWVGbExoVWRkQjNXNllnMlN6RzZvRDIzaERrdllI?=
 =?utf-8?B?UTQ4SHcyZjVEQ0dGZGdZc0tBOGhjQkdHWGYycUR2QjRKeXE5UmNILzZtSVFE?=
 =?utf-8?B?TlFQYm9tQnZ2SkFRVm9JM3AxZ3BkRDhNN3IrODZVNkJ4VXQxL1BHaTFrQXI5?=
 =?utf-8?B?RDd6andHVEk1VkZWTk9MZDlnVGJWd2pYV0RPZEwzQnVocDg4emt4bHM1WmZQ?=
 =?utf-8?B?c3dtWEpXRVE1cVBwaXVreC9rdzhRZ0JVMjB0TkFWVmIzVkh5ZlM2aXN2N2p6?=
 =?utf-8?B?b2pzSmdoeEcvT3hGaDJ5WDV6dEdpdklRUFhPNWNIMHdiSmpQcnkzUDJUS21I?=
 =?utf-8?B?V3R5N2RYL2xqUTFSNDNpRU1uK29FMzBJaFBSZko0bC9NeW5QQks3Rjc5ejRW?=
 =?utf-8?B?bWVvcXI3RGlqNmFNR1kyc3gxdGdCZzJjMFZ4OExiRHo4Ui9vTENEWDNZa2Zk?=
 =?utf-8?B?Y1d0THcxbEJoajlNQnhYd0FZcEs0SllVUlJKNDVXajlyZzZzVm1ERUpHclVv?=
 =?utf-8?B?VEVEUlJ4cHZKLzZlZ2dIYUlNR2I1NVNWTUJOaWYwWXU1NTZIUmk1Vk1EQ3ZW?=
 =?utf-8?B?L2ZzZXI2WDVCTTdoZUhkeHdqUXIrVEtheElHUStONzZwUXhobENSbHZiVU9L?=
 =?utf-8?B?V0tLSkszWGYvbU1OdmlhYys0dXdKSXBRbTlmWUw1NTNMZVpySFY1cjVOOGJC?=
 =?utf-8?B?cHJ2UnluUjZuMnMrcCtIR2pKYU5NNzc0Z1RLNE9Ea2l1aTgxdFlkVFI4bXdT?=
 =?utf-8?B?NlJzb29WRFVJTGZwc0ttNzZBZHdiZldSeDljblpMditWUmw0UFJNcUNZTHBh?=
 =?utf-8?B?QXFyR3RKbTlHZVp6bjlwdVVHWG9FeUNmc2o1K0VTK1RRZk1aWmhBd25FYUY4?=
 =?utf-8?B?ZHZLRU96Q2lLLzNtUDkvb2NhOXM1Zm83bjB5cXZEV3VHR1JtTGlqN3d6c2w2?=
 =?utf-8?B?b2VycWN0RCtxWTNQcjQ0ZSswclVGSVlBQVBGem1SRzV6bVVua1dBeExyM3RH?=
 =?utf-8?B?WitWVzFaOWFJNklWaG5NL2xZbzh4dHNqNDlrNjQyYjhLanlBZVlWbDc5QmpZ?=
 =?utf-8?B?WTNGRTd6TnhJbklnOG9KakJsUGQza3JnWERIVWVWZVk0YnVXdEEyYmJZSlIr?=
 =?utf-8?B?NEtIcW9iU2ErZ0UrTFkweFREZkdaYUxBWi8zZ293c2pvSHdUa0FobzFNM3U5?=
 =?utf-8?B?d1BMUWFrMkJuWHlLVWF5a00yYVZqS25RNm9nTU0yYXBzQ3hCdWlhbEJqM25M?=
 =?utf-8?B?NVBnZERaVUlPUitjaXluTU1GeklOd3h3OVFwTEsvbEd6ZFpYU3Rxd2tEZG12?=
 =?utf-8?B?S2EyUkVtdDJ0azBtQW5remFwWjlDdnlCdWJvSlNDYjV0Q2FtOUJ2bVVIVGky?=
 =?utf-8?B?WnkvQWRjMlhveDBaeTFoWXJLTzBYc05lVW0vRFhiYjVaUmEvelhBbE9SSHYz?=
 =?utf-8?Q?CiWDU56bvB3Xh?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5bfbb32-33ef-4e3d-77ea-08d97474ea25
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:14.5486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AynfuWgmioOHnIMmoQwP4rWJRDXednZhVNZxu31ki0LA/gofcovRxAPsmW0olG48qV8VqpidWtQ2S8E4rlFaOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
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
