Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0BF48372E
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 19:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiACSrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 13:47:53 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:5660 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235519AbiACSrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 13:47:52 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 203I2XWB011677;
        Mon, 3 Jan 2022 18:47:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=61NHZ33J2oyAN394fm3frJP/KzxIvj3Hp6vari9N5As=;
 b=C9HCaw8vsuP5DOsG/GJ7+xNV/l7qrI992rHjQUkggjzOdw1RO54eFJGhSo7GadCN4ynJ
 52K+Dp3+DVf8esYn6nF9c6rGeFoHuECi6+aJDLRQyt6SkjowU3yL2qnUxpxdsh0wPkIo
 16aCHQgOXOFLWVBrLWUXkSRSX1XQA3I543ZTItIolVSh9XwNbnmcs0rZ00RIcSo5cpo2
 zQDxdG46tdQyxQNCNZl0NJM9fuEM6DkxYs/OSvOcDtZhOo4V2a3XXeYnG036uQ86sEh0
 7p2cS8ncDywQr8u80BftOKc8zOalkCvxTVltXNhwnZTy6A49AdRTd7/HpCdGTWisFKDt kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3daeuakcja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 18:47:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 203IfZGJ168382;
        Mon, 3 Jan 2022 18:47:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3020.oracle.com with ESMTP id 3daes2n145-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Jan 2022 18:47:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqlODX69H4EyEin/QHk+m4Ca1m4Nn359MRUfOrS9qNnCli6SKdPYlculTFRbVeYvX8sP0En5bCwHzmEacYm60KFtRRGo62j+4hsIYY3l4iiJMohWQAR9lOTPPkV5OB0oWNDGtc/UZVaWps6kQY7zDGiaZjmtQdG9LL0wW08O/q+BiXUcgbI5hJoDJ7jFh/WoErH2gHz0+6fDjchfQSWOj+qGi0GIndfvnCfVOdTCVkULw+tuFWwuTh6C3YcNpFrf2js265EONsObtK+YYYGrV8meBRqFu2Or390SIvZ84lEyg5eZ3cuSpyjuHnLDbPczYKTOsAGoQ+rb9wnOU4QR6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61NHZ33J2oyAN394fm3frJP/KzxIvj3Hp6vari9N5As=;
 b=KAW0bIjQjuAxuHT4AuTEaRmlcna0URbg/letpHR4z87tCv7fZ0LIHo1O9eqe7i7HYKZJhXUi3buW8qhDb1FLtxRTinqG7egYT2ywEDOwqeReePzFsZjbO2CHQUJOJ8k5GzzWyTnfNhO1BetklLol+XVT1ujUd8w7m+Z2RU8bTFJUQRiMmvKWIDL0PAUXc98mVx532CfLMrAQVaZacm9eFNow1Hd9QZaHSFpmk4GDv+oCaTyFOSiy25BU95p3vkcILcvnWpKRMTUOEU+Piw56lT5ZQfKATilH6N1Et38bVvBQ4rwr9w29RTeJzUgqNFWGLcujmx789o+k4jQI4P4f1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=61NHZ33J2oyAN394fm3frJP/KzxIvj3Hp6vari9N5As=;
 b=Zm541BpuaNi2cSXBGTNnfSvIBu2byu/b3ifRStI607bIZWnlL1wIBSQlFhYQWMh8VKZsUvK1TGq41Wdbx4CmvDb4MpneFBE3IIUURLtvxCCzVVybLn6DQtkQuXYnzX/Oqfi3hfuNdpEO8W2UWUiUX+CR/IcMfFYTR1G5zmYyBzE=
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4637.namprd10.prod.outlook.com (2603:10b6:a03:2d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Mon, 3 Jan
 2022 18:47:26 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::8df0:9850:d1c2:5e81]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::8df0:9850:d1c2:5e81%6]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 18:47:26 +0000
Message-ID: <555a3e2b-3981-672d-c6cf-5ecb357d2fa6@oracle.com>
Date:   Mon, 3 Jan 2022 10:43:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH] af_unix: missing lock releases in af_unix.c
Content-Language: en-US
To:     Ryan Cai <ycaibb@gmail.com>, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        cong.wang@bytedance.com, viro@zeniv.linux.org.uk,
        edumazet@google.com, jiang.wang@bytedance.com,
        christian.brauner@ubuntu.com, kuniyu@amazon.co.jp
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220103135830.59118-1-ycaibb@gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
In-Reply-To: <20220103135830.59118-1-ycaibb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0029.namprd05.prod.outlook.com
 (2603:10b6:803:40::42) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fd616cb-a2f7-4456-f5f9-08d9cee97c1a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4637:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4637B62609BC9DFDDE20519AEF499@SJ0PR10MB4637.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qBr6nUBJJP/NRc+YbsPe98ShCE4fHy7pIfZd1rJ88iLkCHDtdg6kSSSBtFqU3rEj35l2NSmbT+U2uL/HnCrg694NbVEZPT1QSmGakrSpbC275e0D/7cpUHQwjxaeUyaiRogKVt2pcVF+8PgHTsTB+4sxS6BLzANB16UYORK5u7RTyKuzESYE+QNaslaX/NYdXz6JMvNvioiJ0ExVUiQa0tHMkLQ6ds+iz/nvC8wRqJ8BMuZHbgAbF/zX5GW6r7aDC0gKEQ42hqYyDSMu0X/bwHSrZM3FLYZEGPuBS/2gQrYAuyFM461NJ+hywdB5lxWunNC7BNXzFNoBIXb1lMQcCtmXkkdd97RIroUWqlZoNExhgkz9zbGftV5Tjgsl2f6iPwP9GI2EJlRETwPdnpF8ZMdgXCERLVWFrcEaC0sq13t9f7ESxVNphUIoiA9zj917umxwgVkE9zmCIYMypLLq7SP6u1kwE+KufyWXWibAccdPVZbyl345PdFjjjz1+xUgT2ZqsqCFQHoqznmOi5L/p3mrYjhsBhATOIXFVetcHYKAi+hXYl6eStTgTFDC7csKb8Is7HXXCCstSyjpaOOaNz8YnPUIXEHGqQv0UayVwAavvM55zb6D8cDqtJIFpHMTd4mJEn3gszPgFvbk2NCCFs2/TJx1oB3rnSrC6SG2VD/A0a988u1dUhKKY1n+jSLK1qe7deVNZcoPmWqibY+dqFCtXuLXnLtq0aeNzxpC9XbZQl4AhOk4sOsJZI1q9Qbj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(4326008)(36756003)(2616005)(5660300002)(921005)(38100700002)(66476007)(4744005)(66556008)(6666004)(83380400001)(86362001)(8676002)(66946007)(6486002)(6512007)(6506007)(8936002)(31686004)(316002)(53546011)(186003)(31696002)(7416002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUNxV1Q4dzRrU0pLdHpiR0o0ZTc1VzNMYUIxdW5sTFdHaVlDQmdpSnJVQ2lZ?=
 =?utf-8?B?TkFmZExoL0dCblFmWENmdHhRUXQzSS8yem1LM2dlZXJoOFhaMkt6Njd5dTF6?=
 =?utf-8?B?LzEvK1lnbTV1S01Ud25oT0wwOS9uUUZ6OWJEMlNWbWh6TUFUaGNOclJnWHlH?=
 =?utf-8?B?b2crZFhONHFUb0hnU29PRUtZWlVpV0RZRWZiVnliTFNaQm9IOUZjNVNkWGhv?=
 =?utf-8?B?NVpna2l3MVhtYmRiUVAxUUF6eC9aQXRSeEJLVXVYM2ZLeU84TndYeDM5N1Bl?=
 =?utf-8?B?NWhNYlFnUmE0RkFZMUJJbGp2Q2grNWtCeEJpNXc2UzZ2c1UvUHBJZjl4U2s1?=
 =?utf-8?B?bGowWnNvT1B6YWtQY0dvY2FPU2J2ZnRXVjdsN1BsaHFpdTdRUXk0eEI0Y0F6?=
 =?utf-8?B?cTQ2QlZlZ05iVmpIZ0hQRkZnTStTRjI0bUFMblEyQWVpQzhhMDJ2b0xHVnNO?=
 =?utf-8?B?QmlWa1ord2xGQzczQXVnRHNZSjV0V2Jrbnd5SlNHK25OdTMzUFNKekNLWGY1?=
 =?utf-8?B?Z1dVMjFtb2JwSGpaSzBNTlp4NHdrM3FlWDJkQnpzRE9CKzFvd0pEZEU1TU80?=
 =?utf-8?B?a3VqL2RJZmRXNGo0andlTXIrWFduZjhpcWRzWnZDWDBCSlYxNlJyc3RTQnBH?=
 =?utf-8?B?NWhaNjR5NVNoZ2RzcEhZdTFGTmRyZ0o2T0pRQVZqUmh5U2xWK2RhTVhOTzFQ?=
 =?utf-8?B?NmFQbnJmOXJGdkRwNERMbm5RQm1nUzNsaWtSK1JDMGg3T000cUFWM052SmVO?=
 =?utf-8?B?b2ZPYnBnL081UkZBT1g2LzNkdUFGRkVub0pvM0lrWG5aUWtoRGxTcUMzK1VB?=
 =?utf-8?B?Ull6L3JGVnpqUjhQTE0reDZkMGszWlI1aVRjOCs2K0dTU2F6dnV1UFpnd0Rt?=
 =?utf-8?B?WW5ZNlpHSmY2bUdDNEZhRHlWaUJoTWZvL3dmYm5XdUgzaXd1dGZWYzBZNEJ5?=
 =?utf-8?B?WVhPR0IzV2hXbDl4aHVMRTVIOCtnTFh0QlFxZjBON2d4ZHVFYnRrV1ZoOFpI?=
 =?utf-8?B?NEd3S0xLNnBPY0Vuanp4anZxUXFCaFBrUFk0d25zYkhFM0QrdnU0RHBpV242?=
 =?utf-8?B?Z0dKQUl0Ymw5RWdiZmM1SWtVekFqWTN3SEMxRWdtM0ZoWlBHZVQwTm9ndXhJ?=
 =?utf-8?B?RExnOWV6aHVWL3NhNjE0RnByOHljOVBkUkdaNUV0SktibnB5am1HV3I1OWgw?=
 =?utf-8?B?ZlpkTVZlcUV3bG1xNzkrRzZ2R1hTM0hsRHZnZkdQczJlM2tJdG1ZY1VLZ3or?=
 =?utf-8?B?YzBNQnY4V3oxaW9LZ3REMmlsRjRUT3JVNXkyVkhXZEdBVnVBdGZZeFpkczlQ?=
 =?utf-8?B?RVh4Q1F5OWtHUFZ2OXFZbTMwZ2pPN2d5VG9IWUxLRjZWSWNMOGUxNHFtbXBJ?=
 =?utf-8?B?ZGFXTlVwSUhoMUZFbEVGS3JzZFQ1ZHdLd0oxRmFmc0VBa0R2RU83QTNMTk5W?=
 =?utf-8?B?c2NJQXFaeWtaTGdWenI5NWVTNWd4cVFsbDBtZ1UvdkZyY2QxTGdlWGRtVVNy?=
 =?utf-8?B?RWhXZHhxUzFqSlFSMXJ5WlI3S0pSanV6VnI0YTRaMzNEVnA3M3JsYXYwaVU2?=
 =?utf-8?B?cnhLaE5HaDZTTFplUlkwWk11c2ltYUpZR3B1dmpEbTdnL1hOZURwNk45MXdZ?=
 =?utf-8?B?ODFoN3IwZmtRUTBidS8yK3FwaDJtN1RSVlBOa2NYUzdJOEl3a3AxNExEN0pL?=
 =?utf-8?B?c3oxMXJ1Q1pEelBGSnpKZkk0YURDSVRmbnB1Y2FqYis1d0lHTEk4cys4RktI?=
 =?utf-8?B?TjltRngvNHdpTXFmZWlubHkvdXN3d0pRaHZPTWQrc3F1b2FBU0tkOEFucm93?=
 =?utf-8?B?VUFScjRxdnMzK2RkQjk5NFo5YXFDTFJ1WTJWQVNBN2Q3bnJuSHd0d2lua2Na?=
 =?utf-8?B?SHdYQWhlcnFFZU1MUUxCaGc3SzZLU2ZBRGhGSUIzUk1VaDRrQk9Tay9NU2VI?=
 =?utf-8?B?S0xVSHEvUUF3YWdFdFJJRXZTWUJQdTRONU0xaTNicTR5c3cyY1doWlZaeWFW?=
 =?utf-8?B?RUVVa21aRjJlNmRXUXBsd09NNUNLazdxL0JTa3pDUEdndnRPWGpWSjgxcGFk?=
 =?utf-8?B?R0gra2gxZjhheEN4MkdGbWdtbU1reG5iS0VNcGhSZ3VqakpQeHhJQThaMDg2?=
 =?utf-8?B?WUVUdDNiNzRadWJYNFVRck9tZnE4QVZOUUVrY1p2VDZIb3ZFZkxlalRhT3Fa?=
 =?utf-8?Q?b31OJTjz/pYTT6CmeeezUkOzQtpWwDLcKuTRycUSW0kH?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd616cb-a2f7-4456-f5f9-08d9cee97c1a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2022 18:47:26.0560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kZVDi/RIKA607nuVBRGI/k4Vlq109cNZlMr5hFtgGZLKEUyS5TfxDAthcIzvYgwGr1uGhgJQ1r4pWIiWMRmGLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4637
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10216 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201030127
X-Proofpoint-GUID: n8GKkUcUUsyCkkcATQ18VEuaQ8Lmbsjv
X-Proofpoint-ORIG-GUID: n8GKkUcUUsyCkkcATQ18VEuaQ8Lmbsjv
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/3/22 05:58, Ryan Cai wrote:
> In method __unix_dgram_recvmsg, the lock u->iolock is not released when skb is true and loop breaks.
>
> Signed-off-by: Ryan Cai <ycaibb@gmail.com>
> ---
>   net/unix/af_unix.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index b0bfc78e421c..b97972948d9d 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2305,6 +2305,7 @@ int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
>   		if (skb) {
>   			if (!(flags & MSG_PEEK))
>   				scm_stat_del(sk, skb);
> +			mutex_unlock(&u->iolock);
>   			break;
>   		}
>   

It seems to me that the unlock at the end will release the mutex?

out_free:
         skb_free_datagram(sk, skb);
         mutex_unlock(&u->iolock);

Shoaib

