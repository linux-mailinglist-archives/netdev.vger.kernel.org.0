Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AB0487BA6
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348647AbiAGRzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:55:11 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32942 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348644AbiAGRzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:55:10 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 207HaIhJ029028;
        Fri, 7 Jan 2022 17:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=UTZ+M4RNXt9woyN1c0a8KTVjt8BHPlBVGWw9a8zghts=;
 b=SZ03rcQx1Rz8TaRSb9KQUuG3/qmtcNrmsw6KHwAZWAmwqeggrPhzPC6+260+SNR5EKIH
 Yd8ZynQED3aiDaHASMhj1ZBonKyyDWGYjnOOr8ESCOXET7YrS53wApOgvpCsL5HKcEjl
 4P8S8RofIA/zJ7JW0Y9LS0EwfHNWDESk/j1/K322iXMjZDunmGswavYV/hD5Aj8ZGKw5
 sItZ0ARDs+P9AaIdxgxnShiGW2o2RnLSzFIqce5IuaRhT5j253FEU75nchmKBTRaUOHm
 UHPle0bxOpAIpYNHWsrKa0JnKfMDFzhcS3oHoFsPztf80010qF78l9Enzr70ehy7GuoK kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3de4vbapdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 17:55:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 207Hfkx7046674;
        Fri, 7 Jan 2022 17:55:01 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by aserp3020.oracle.com with ESMTP id 3dej4t3n1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jan 2022 17:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJ+t1Hv8stxCciYKy6EzP7IPoenUIjBLKFodWiU7HnWBbq9BKYLkom+ndnuF+DeIynMM9oBbBBuibnl1Hm96eF0lUoBEC5umP/8KqhLmlz6VRWxnB7graVqoN9itqVP2QmA5fzQdpwtRg5+JtTviSyH2JqHM9VkYaEuK0P79anqxa2Rk6QAjkUGuKrY3K09dwI62RrM/SfRxgNfIE93H3N7AELvNUBgoZlwyM6ugTZ6NEb/4DWODen+1T4tv85ewdvZUnUOLI4Hn+uAncQ89YA4hai1s67NaO1FpxR5li4CAwzhkv9zatuyg0np9CMsXI+uXiImj8k9B5RBJPq2fKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UTZ+M4RNXt9woyN1c0a8KTVjt8BHPlBVGWw9a8zghts=;
 b=gxqc8N4Imfv3PsJgUa/aHI4rBackyK9MJNpkcLFxqAXGvfzaNOA3naZlTzMM5q0JgrPYPRQpEL3G4imEoNJyqjYe5Su3HPreBfxJjBUCP1PKf+GiDc1Q4x1vxLILWdgOSJ1lpf7tLXmw4iitQlcKBO6MD09BeEju4Y7h5CeGz9Giw3EcWgPWy15lQZZ6YvutHlulI3am9e/dfNyLs2t8Vw3kwEpa8CU01s6ZEY/kLiOZ47uSvWggwPODkTmyYqMN79XIg+SFTmMOOg7rskT09dYopEMmxPRJzlsC83Ry+xLs9RZ9BYzWSC4uWYtzg7OQFv7uyr/oN9nTYI90VUNxig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UTZ+M4RNXt9woyN1c0a8KTVjt8BHPlBVGWw9a8zghts=;
 b=HCd+3vDiyhXi2keLTy2KVoagviGbpxeB/cpmJqvppUQwgwU/Fgp9W83bi/mHCCk0YGfYUsKfZKNfcf2UW1qpgnXWhx3QRl7dBQCu3wnpOU1atiB4p6EXq7Cbyf25bSpjcW8Tr2b7OKYEvnlpjcxhhVYAu+HsbZhBqyr74CmnF/0=
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5860.namprd10.prod.outlook.com (2603:10b6:a03:3ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 7 Jan
 2022 17:54:59 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::8df0:9850:d1c2:5e81]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::8df0:9850:d1c2:5e81%6]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 17:54:59 +0000
Message-ID: <35cebb4b-3a1d-fa47-4d49-1a516f36af4f@oracle.com>
Date:   Fri, 7 Jan 2022 09:54:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: Observation of a memory leak with commit 314001f0bf92 ("af_unix:
 Add OOB support")
Content-Language: en-US
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
References: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
In-Reply-To: <CAKXUXMzZkQvHJ35nwVhcJe+DrtEXGw+eKGVD04=xRJkVUC2sPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0065.namprd05.prod.outlook.com
 (2603:10b6:803:41::42) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 730b2614-513c-4a02-6960-08d9d206d289
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5860:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5860859AED37834EE5758519EF4D9@SJ0PR10MB5860.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiyLPhpHuBaW0v7ywiGUlgEm9gzQ0NkCgxkAigM6rfpe1f+wwov0/P40kr4YF8rgNtaHxQ7tm4tr9/jBwRE/kyQVtUOGpDmCl3kZaCbd76v0y0oLeeVfHjoKQ7AtiYx+Sh6G8o2LFZcmO3q4yiivr8D0YI7RUNlLalOriqBPHR8WEt2yKywhS/Q9SnSktKB5xhqmL4Abzgc6X3oiagFslNVqF51Q1aJuKniBQ6AEJRIcibGp5u2FZ7+D9ERRp0437vSfaqpuIl5k3ESyBkOyE6ICe1yN3PHHAu12oQT68Fi5kYvLg9shFtf4oJiTvJZp8ezwEJSykK4f/AdIH89liHYHfgC3wqp0u7Sx5su3OlpZMUpLH7PbjKEtuwwokgbruiQYgAtJ3CB2SjrF0jZChKCTVAuhYWo914lOyxULZIeUe+VRWTPY2JMw7JGQJqcUk1F9KVB52IeblDQpF4m8FvHTVvohXFEGy/OjzNvkfleRaE1lnYQMqrU1xZb8h4Q9NumLk7Z0Tz8+hpKK512AadKcgTvZpXAFpNNdFZGG2/7D1AQHtaOxzyuh9p1uYsvYOYh19FV9fd5WlGN9pPzBXFo7HiZNPp/pIJEMC9rKvhcGcY8zBeP2rRNVIwbQ67i95Ap+ZcPxs3uf9juHZTjJtVvTB9/ENfv+t5i/oyTrMBt5XNyVBG9NWRZ0xNWCAcjBFu/gCZBDIn1LCXRuKnIhWcBaIHVud+oLQoBOqErF/TPxvj0c02pKv2oF+5Eat/M007TvMEiz+Nn3b55QU+yx8JZzTrDTG4MXyPNKMR/KqVBiaJAi6c0nxQ04dDaBN54E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(38100700002)(31686004)(2906002)(6512007)(6506007)(66946007)(186003)(8676002)(53546011)(316002)(5660300002)(966005)(6486002)(31696002)(110136005)(54906003)(2616005)(8936002)(4326008)(66476007)(36756003)(83380400001)(66556008)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXM2MkpPSm1iajEzL3Rjeno5OGlqcXFkaXp6UkVJRVJ0V0J2K0x0SkpsUWRI?=
 =?utf-8?B?YkVSZm81TXZTZ25HeThUNEs3dEdrOTBpd2pvNGhkdUJ3dWVKSDZENXprRjBr?=
 =?utf-8?B?d3JMSFFHQ0JYVDlPZXpkT1Y2RlpybUpsSDF2bmZGMndaV3JmVU95YWdMNlQ5?=
 =?utf-8?B?TnM2alhtemxqWDd5ZS9XZ2pJN25EbytaS0JCajhZVS9JTU04UlNwSlZjbnJH?=
 =?utf-8?B?a0JTUVNWeWxBM0c0QjNMdDQzZUFTZHZtcjlld1JMZ0VLV2FGa3dqSjVyTGJR?=
 =?utf-8?B?ME9Da0NXQXBUL2FlVHZteDN0dVlFZEpKZGtobzdDNWtuYnFOODdRbTM4dWhj?=
 =?utf-8?B?WVQ1YXdUVlNFOUdCQlROQmdQVTYvQWkvUWwyZkpJT1VWT1h5d3Bya3pNOTNB?=
 =?utf-8?B?UHhlMUsveXdPSVMxWlRNQmJIVmJ5ZlBvOGVrNk4vVVFkdm0yY0t3OVVZK1Yx?=
 =?utf-8?B?QmtYT2syMHNDU0J0K1RPTkpPWVFjYXJ2U0J1UEt0MkRCazkxcU9lTzdrMVI0?=
 =?utf-8?B?azhWdk9Ed0gwZU1mZjZzTlNhMWtaZEdwd09KVkQrMldKeVN1SUIyM3dWTVFl?=
 =?utf-8?B?NUFQLzhRcnRkL3doek5JWVUxMjRqNWJsYithTG1qTGNGNThBTVo3aFJocTVs?=
 =?utf-8?B?Vk9mK2hSYUxPWHp3UzRGLzE2SmhodTh0cC9rZy9HTWk5cXRPZFRyZjlEbEJ4?=
 =?utf-8?B?NW4xam5aOVJXeS9yUHdCcVU0WTZnMDlNeW9YdDN3RW9TWUMvZXdiK1BnclJM?=
 =?utf-8?B?eXRnZlJsSmFkd3R2WUc0RG9DbFp1R0poYTJ5alUvN3RFM0lBcHdzbXJoeVp5?=
 =?utf-8?B?a3pNWHlyd1loSlprMVBGTmdzR0d1WmIwVThmMXhZbkxSdmhNS1UwQUM0MVZ6?=
 =?utf-8?B?TFQ0YVF6YldqL1dQMjRJK2hSYlFJbGZJTFlicWZQUGExL3BOclVzQVd1dk9V?=
 =?utf-8?B?bkRVNktvT3I0dW83K1dCNzVmcUpKZmZRSUdPMEJJVTNyVWpHWFdZYXlUY2lD?=
 =?utf-8?B?UWZ0cDlWUHlReWFrYUcydTRKL0x6QmpwMENJcnBEaXZaTmhMZ1IxQ243SFpz?=
 =?utf-8?B?a3RucUhLejNpSm5ieG9YeUxmc0VGMXN1Mkg4Lzd0eU1GUEJoL0psSGZBZmo2?=
 =?utf-8?B?dk5vWGZmeDhFT2pCL1NxNisrelFwMW9yRDNldFVlcW55V0hhWjlhUFJJaGJp?=
 =?utf-8?B?YlhPd1hGL3Vuc3dFclE0S2FJYWx6cHpTdXNuYUxMQzl6UzBBczA1NU9KSEt2?=
 =?utf-8?B?TitEQUhtWmJMcVdBQnZIelhRVVJxSGxBMnVQTjdEU1NxYUxHSitDK0xhUzMr?=
 =?utf-8?B?UFJ3WFFEczdscGdIam00Z0IwOUxmUGt4YUo3ZVhBcjRNd21qVGlwSWFOMkQ4?=
 =?utf-8?B?Z29CUkF3NU5neGtTZFM2UGJyenU1eWE2NklCdnI0WUplcHhiYlBkczJtSlp4?=
 =?utf-8?B?dDdXNGUwWVBGL3NGR0ZpdUpXa3cwVHB6T1hEWEpSdFFiSC91RGNnTDQ0VDVS?=
 =?utf-8?B?YlNUUHY3R0dMNkRFSis0c0l0alhFR25sa0VLWHNoakdZSjllQ3N4RmJNMEVD?=
 =?utf-8?B?bWdtd3ZNeVBVYWJtd3RlYWdsdFd2S2NKODU1cFhpU1haRi8yTFZJMjR3V0tE?=
 =?utf-8?B?YlFxWXh5dU1pRTI3bUFEL05pQzQ2SkluRHAxaDZvaTYxZCsrYXdGcVBxQVBr?=
 =?utf-8?B?QTR3eU8wTmtXUktGQlh2TkxDdnIzWUZHc0Mxd2VRc0c2S0xzcEFvTDY0Q0R0?=
 =?utf-8?B?dGlvSGlyMWIxamtGMHl3SFdVOXM4VDRjSUp6RWs0cW1kNW1zSzQ2ckcrL2tZ?=
 =?utf-8?B?ck4wRExLZmpERC9za2FNMkxFMlVxWC9JcHh1bmNOSmtFWDI3RXFQWGxnVXhX?=
 =?utf-8?B?OFVITXFOS0hEaFpkcFIvYWtiVy93ODZCY2N0MUIwdk0vTE9RQlJYTXJFVXJH?=
 =?utf-8?B?bFlzQ2gxRDFCNTB3a09SWWNMc0tlSm14QW9ZY2NrVitDMVpOMm9WWHZGQVVE?=
 =?utf-8?B?V0xnYVgvTWRkZmxFSXY3cHNYTFh4YTlFUFE2L2llRlg1a0NULy9iYVVyWVVT?=
 =?utf-8?B?VmlCejJQTlpucHE3bm5VZU10NDNGZVBlL3RyN2hqNVFvVlk5Rkprc2ZtSGFo?=
 =?utf-8?B?bkRFZDJscEtjLzYrSG5kV1pXeDFqTDZ2Zm1nRVpKUFYxZzBJRzBnVTN1aTBa?=
 =?utf-8?Q?1ciZpu7t6JtrE7yozM/wqkw0FEGP9Df6UB7JevX6n5pQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 730b2614-513c-4a02-6960-08d9d206d289
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 17:54:59.4743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T08Ql5dnbwOJL5KfefdlPgrqLAGm8efwFFTdKRjfc+4mae4w3xWqp4FEUUQJejrBmephCCmGWMAfLiUN+voUEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5860
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10220 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201070115
X-Proofpoint-ORIG-GUID: EC_zKRyzBlPjvQjY9ulQJ_EaDRxsEiNr
X-Proofpoint-GUID: EC_zKRyzBlPjvQjY9ulQJ_EaDRxsEiNr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukas,

I took a look at the patch and I fail to see how prepare_creds() could 
be impacted by the patch. The only reference to a cred in the patch is 
via maybe_add_creds().

prepare_creds() is called to make a copy of the current creds which will 
be later modified. If there is any leak it would be in the caller not 
releasing the memory. The patch does not do anything with creds.

If there is any more information that can help identify the issue, I 
will be happy to look into it.

Note that a lot of bugs are timing related, so while it might seem that 
a change is causing the problem, it may not be the cause, it may just be 
changing the environment for the bug to show up.

Shoaib

On 1/6/22 22:48, Lukas Bulwahn wrote:
> Dear Rao and David,
>
>
> In our syzkaller instance running on linux-next,
> https://urldefense.com/v3/__https://elisa-builder-00.iol.unh.edu/syzkaller-next/__;!!ACWV5N9M2RV99hQ!YR_lD5j1kvA5QfrbPcM5nMVZZkWNcF-UEE4vKA20TPkslzzGDVPqpL-6heEhBZ_e$ , we have been
> observing a memory leak in prepare_creds,
> https://urldefense.com/v3/__https://elisa-builder-00.iol.unh.edu/syzkaller-next/report?id=1dcac8539d69ad9eb94ab2c8c0d99c11a0b516a3__;!!ACWV5N9M2RV99hQ!YR_lD5j1kvA5QfrbPcM5nMVZZkWNcF-UEE4vKA20TPkslzzGDVPqpL-6hS1luOMv$ ,
> for quite some time.
>
> It is reproducible on v5.15-rc1, v5.15, v5.16-rc8 and next-20220104.
> So, it is in mainline, was released and has not been fixed in
> linux-next yet.
>
> As syzkaller also provides a reproducer, we bisected this memory leak
> to be introduced with  commit 314001f0bf92 ("af_unix: Add OOB
> support").
>
> We also tested that reverting this commit on torvalds' current tree
> made the memory leak with the reproducer go away.
>
> Could you please have a look how your commit introduces this memory
> leak? We will gladly support testing your fix in case help is needed.
>
>
> Best regards,
>
> Lukas
