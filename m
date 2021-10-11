Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C614F429560
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhJKRRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:17:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:18938 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233171AbhJKRR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 13:17:28 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19BGucQs015554;
        Mon, 11 Oct 2021 17:15:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=r5vyvGCi7kS/cg1nmUACJtyS55D1NarCEyieSZZh48Y=;
 b=RWKITAHr/7TER5zitu70689rf1EXpnV6nSLT4hPspRWNOunvbH+UpaIxdGi98jGjLU/p
 p0ggYe67g25bVHRpvMxvp9ZUTGOnL+1v9NMRRG/0j+CEesRP54BAYvOKsqzOZt7hbPDE
 3Btin50rFc1kbqQ3PyJ7L+fvk7UYDA/DR1J1Dl0x1VbSpE2m9vs6N3AcLxhqCkahGl+H
 bDJ2TuH5t6Jc/G/XFnXaUjD2jjkWB7wjXfHngpuo5WvwbY4Kfhq41leOgbf3z/Dau6rG
 Z7BydsmZXDNs07Qo+zlDigCB0LWen6tC3kpJeEtRJRUwr47gzytfCk//awgmcJSEQdlN Qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmq3b93m3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 17:15:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19BHEi0w087133;
        Mon, 11 Oct 2021 17:15:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by aserp3020.oracle.com with ESMTP id 3bmadwk90k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 17:15:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+dmlnxxvQHDyLMfFfCHu8S4OEq6oWYzj7sMhBOB3hX7q/iSp2CkkoqsvJLhZxK/33F6GvV7EFTIM/Zu9hP52vs/WCncMdoqxqWZOyyQfpK2xUNov4EMR3MmoLF/zZVS+uHhMr9VztPdGV1CAW+pmA+lcz4toIWoq3jv3EQloc/z/Ps7uuEEnXg63jpLHuMy9urW/p3Czoff/U4pZlTQRb49huQR1Jm8NJDgOYPk5UFuCNI0gP3oT5WydqOGJMSMB2ZB0Jiz6fCUb/P6zHa5Ue28EVmokfAc6/ypw4LMzIiy8ZTek72APBtKcF0oeJeqgHBXmGWp8IFXorcLNSJYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5vyvGCi7kS/cg1nmUACJtyS55D1NarCEyieSZZh48Y=;
 b=XwTjL0IvnT3ZpA/GFjK3exVS43pdavvRXXzEB0LYy14qP5XWggVplIrYQclVb9FVawhOnu+F+rz8/0MYyL0iCloY94NXOGF6b4zZyY01BB3SIHKgFLoPnr26xkELs2t+NbrBbzS8y4va35vX9Q6grXl/j1euo7eAZkSYt3YA7DzulQUk8ndNjSJ8nd2XwXUxswufVf+3zz9eNvCGy7yY3F8NEiCAgYEmXmXAoXEoOQfMHLikWXosDumP9V1UcBZNapHfkMWCG6YyCwlTkhY1YWCnCFuwMdG3EBbJ9qOXlCgruQdavuVt+nKDPAcIeMLGT16Aek6Q90R28VfPWdax3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5vyvGCi7kS/cg1nmUACJtyS55D1NarCEyieSZZh48Y=;
 b=r90SGIv41istwUcvMO7wQkC3Y77GzjD7XOp3mUruPTxhG6Yd6ObLOHti+T5NPaE6Fbn35W5yI1wl7PF+6W5TWlK+7nWtmA06R/+il89NTUceuJNeEHay2w3SM2RXG5J4hKz4ab4pGWXQD5YAC3RsnrVWRID3kMOMYqysgi5b87c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Mon, 11 Oct
 2021 17:15:19 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::958c:1aaa:ad5:40c6]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::958c:1aaa:ad5:40c6%8]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 17:15:19 +0000
Subject: Re: [PATCH] r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hayes Wang <hayeswang@realtek.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011152249.12387-1-vegard.nossum@oracle.com>
From:   Vegard Nossum <vegard.nossum@oracle.com>
Message-ID: <4c7503a0-4c11-d55d-d271-b0c371d3e4ad@oracle.com>
Date:   Mon, 11 Oct 2021 19:15:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211011152249.12387-1-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0033.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::20) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
Received: from [192.168.1.13] (86.217.161.200) by PR1P264CA0033.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24 via Frontend Transport; Mon, 11 Oct 2021 17:15:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 967ed0c9-7e18-4516-7ed3-08d98cdab31a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5579:
X-Microsoft-Antispam-PRVS: <PH0PR10MB55792F5FF520DD53CABFB49097B59@PH0PR10MB5579.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZYQup0WcA1l6yNxJWQ52kPqdl4MNhqbVwRT/BLyY3iOVvfZWd/pOsiqj6fmbQ5UIa8ZbQeNuBNmMWS5C0aYNnfFisKSmHbq7RMg9DlQJg8LukjB0nSgCyEBte3zysQuDGqYKtXM/u1BvJ8nQWH1bpW3ncnHdlp8j46Y5IDKE7Tc9Zft7GwL+Yvtl5SgwfQ2QMAR4Q3oOvJ4GTeNQ1iLaePmHkfa5coJZ2HqbaQ1zO+2R3Z4Slh12buH5jPwS5WleWkmOcFSZYg5pJd0CaG0eY/SQFNdmYlh07+pk9euOk3igHIB1ePhOvfYnHD1/Aq5WJw1CDR3CQjvp3OiFOWRGYMKrCQ/Mb/1wxFgXnk3rNP8LmTgwzP2CbXwMZ7O1j9/SjA2sZ7TfJ5cKwGbWIUcpEdIPN9z+XA6flOi8RqOOjyMBUloE2nOaN7CFJJfdnfWud3Ma9j9wKdKfbKsoeJK5Mu9okfqPXlkFWC5wF0mJNqCDknlO3/Etpu2RWgkQCIaYGhOwCBi/8Ms4Wu+1WOiyeKtAMA5J4eL6ceRfUpBL/qQa3Jyf0mpCypeyRq16RUA2b90n+daIvJ5Y0aV7+Zb9K7ABhdMnHTnVSOJtLNrn+gUAZSGxs/0PC2hI8NOKFd4emX3PyXoHCr32RTLyXQxRdRUva8tt7+LNj+O7O3dZdrzZNXDT521NCov8FgICwBzIY0UZXgwwkVatdon3Xsm+ECRlQDxYcgFvJuPHfY5HyTfN8nUpvb2P3BzbP8fYjgfJe7zkBG1ppdFJnZAzXIKu+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(2616005)(956004)(83380400001)(44832011)(52116002)(6666004)(5660300002)(86362001)(316002)(8936002)(4744005)(110136005)(2906002)(31696002)(8676002)(16576012)(186003)(4326008)(6486002)(26005)(66946007)(508600001)(38350700002)(31686004)(38100700002)(66556008)(36756003)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0dLKzRMbVQrWC91RTI2YTZrV05ncllya0ZOTWx5UklIMEdYSE1JSlZjR3FT?=
 =?utf-8?B?aTdmK1ZTT1o5Q3hnQ2k5UHltcWN2aWlQa0ZaS0JKTEVhZ2x6YzA2TXNOQnM4?=
 =?utf-8?B?OTcrbE55dThpN1I3ZHBob1lETWVCY2QvaHZoTGNwTGFOVzVQZDlVL1FlRVdx?=
 =?utf-8?B?blVsSUVJRC8wRUw5Z1BHem5Ud2NxUThKZXhJaGUwOW5qNEhjcGxVS1BJbTBs?=
 =?utf-8?B?eGhvdEZDU1VSVG40MXVnaFFLQSt2d1FGZXNUZWpsYjJNcSszUnc0eTZTT0ZV?=
 =?utf-8?B?cG56Mm5lUEZqUzd3TEhBcnBnWEpENWl6OTJUNFRqeS8zZVRzRnovU1Z4Vkk4?=
 =?utf-8?B?OXlmM0lQNy8ya0VZdy93R2ZuVVF0bklnYTBvRjBHOTM4Z3VBd05HMURxcHpp?=
 =?utf-8?B?TERreUEydEZvRW1NSE5oMXVjTzZqWkFxNFFDU0Q0Q3h1ckJOSUkxcEo5UFlu?=
 =?utf-8?B?MHRmZVFpUkVJSnM2ZmRTL3VnV0ZQNjU2aUV0NXp3L1Y0MFZuU005eW05WmVl?=
 =?utf-8?B?Nlp5Z01rQ1NEMUZ3clhyZ292NnBQUW5wOHJKOWVsSjlnQXlSdlEwNXRuc1JH?=
 =?utf-8?B?S2pVY3RVUHlQaVdyMm5QMW44Z2EyMjNoRTRCR1FaYTJQeGdNZlg5SUFZRkd0?=
 =?utf-8?B?QTQ4d1I4ZnhSQVpKTHJyeVZJZkJZOWtMVjVRNlM0R3laZ21uNTIvczBEN0ZV?=
 =?utf-8?B?aTBrTXlvbkswaDNQOWprZlNYb1o2UkV5TFhYclUrbDA0UlczSVNLVXkxQmFY?=
 =?utf-8?B?UGM2QWF1T0pXSEFsdS8zcFU0bFdTTkJlZSt6TUQ3V2x5dWovekVlc1R5bTdW?=
 =?utf-8?B?b1R1TzlrdGlwNERjdEQwdzF5b3dJbkVINlFsUUNHL0hvRk9rQW5NemFMQ0NE?=
 =?utf-8?B?blZWRlVVSWZCMWl3Tmw5N1RvZzE2bExWK3F6QWE4eDZ4MU5NaFJFMUtDKzVu?=
 =?utf-8?B?WjREYVMxMERrQ2V0ckJXMHFwZG5yajdpcVNzT0lmSU9vVlFGOXNxWk5WZG1s?=
 =?utf-8?B?bjZQWm9sNVNwd1NadEZDL1NSMHZ6L3dUZ0tvcVJ5YVMvMjhSRHlnbTl6UU5I?=
 =?utf-8?B?U0NnNFdlVXZSd1BvbXplcnZQYlRYUGFxSlVwRGIyOE1UVzA1VDNReDlDeWI2?=
 =?utf-8?B?d0QwMjdYc2k3QmFnMllYUmxhMVN5RS8xWlhtRStzYTJoQUliK3dWV29ndjgw?=
 =?utf-8?B?RjFZVW5ML01aSnpUR3ROV3Q2OEtRdjdUbjJZOGdueW55MkxPZkl2ano0SDBC?=
 =?utf-8?B?Q09qd1JxdEpxc0FMNnQ2VkFUeGhTV3FhVHJ5NnZucnRCL21UUTQ4SEF0NVp2?=
 =?utf-8?B?SWpIWitBZEpPN0REZlYvMXNRNE94cnV1Ny9ya0daZWJ3QVF5VGNaNDBoOVRD?=
 =?utf-8?B?YTdyZkVENURacG0vMzBCYzJBTXdYcG5VVmU2TzdnSjE1RUZQQ3QzNWR2SEhp?=
 =?utf-8?B?dm91RDg4dkc5TDIxSUpQb1VOd2llS3ZxY0d4b2x2WkdPMDg2cTg2ZkZMeUt0?=
 =?utf-8?B?MlB4eWw5bGIwSW9GNVlPSTNnWUc4YXBLdk9JRUtMVGNzS28zcEpzMUVvejN2?=
 =?utf-8?B?NTJpQ2R3dTBZVTFZQ3FSQWxBUUpXSFAwZUZoRTNCN0FVSktRcGRxRGxmajlx?=
 =?utf-8?B?eDFJQmVLbGJJRnlwUncxU210WHZMK3VvMmkxNDFIVmdwdStTRHdxamNJaEZF?=
 =?utf-8?B?NGtlbmFaaHBhaUxwOUw3UWgrUEJvc0gxQ1cwS1ZSMkhXSThJdzNPZXdKcXo4?=
 =?utf-8?Q?N5Jx6qyukwPfr/Jib32kUHs/JmkVp/mBqm5cT/A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967ed0c9-7e18-4516-7ed3-08d98cdab31a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 17:15:18.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SlIg36MTLd9t2z5PH4MlQYrD6fVxzYE86Py2OwutG3o2g2ZXsf80HK8VG3wBE4togATFBYrabEUZcs3DOo/Jj+eNeOW7H4nWaMEbAIz6rJg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10134 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=789 bulkscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110102
X-Proofpoint-GUID: pLF4acBFZQunxrmLVmLct_hT9-JSt0ab
X-Proofpoint-ORIG-GUID: pLF4acBFZQunxrmLVmLct_hT9-JSt0ab
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/21 5:22 PM, Vegard Nossum wrote:
> Fix the following build/link errors by adding a dependency on
> CRYPTO, CRYPTO_HASH, CRYPTO_SHA256 and CRC32:
> 
>   ld: drivers/net/usb/r8152.o: in function `rtl8152_fw_verify_checksum':
>   r8152.c:(.text+0x2b2a): undefined reference to `crypto_alloc_shash'
>   ld: r8152.c:(.text+0x2bed): undefined reference to `crypto_shash_digest'
>   ld: r8152.c:(.text+0x2c50): undefined reference to `crypto_destroy_tfm'
>   ld: drivers/net/usb/r8152.o: in function `_rtl8152_set_rx_mode':
>   r8152.c:(.text+0xdcb0): undefined reference to `crc32_le'
> 

We could also add:

Fixes: 9370f2d05a2a1 ("r8152: support request_firmware for RTL8153")

for the crypto_*() calls and

Fixes: ac718b69301c7 ("net/usb: new driver for RTL8152")

for the crc32_le() call (through ether_crc()).

(Sorry I forgot to add this the first time around.)


Vegard
