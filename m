Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2670B3E2ED8
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhHFRW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 13:22:27 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38936 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhHFRW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 13:22:26 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 176HC1jn018630;
        Fri, 6 Aug 2021 17:22:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7Y9vioIceweTTmcOmlo7hxL4SrImClhPSaCdYc+s4mY=;
 b=Q5vGWRXdMHbdAJ78fIeMgNtXxfV1Yd1Oro/nrHyTtPYNxqDu2iR1iQcYCi3iAIlHsSDk
 AJYz6Q2qIZX+6sA/aeAa/BWeWJHPyOho63ebPaoT3Og6eesci1fst/9xoIq3Co9t3UDR
 dtjwFpFuK47Ct78nX22hCN2F+k7rsqC1cbOA548cNabDNPHZ5Fk5INEeTJtmA3Di5Ms9
 0p4Gwt8s8ijYhO+CpXnxgv1ikfEDC3W0sTLvzPV4S2TJTB2xMmll2eCOXghFdKRAvuIa
 bdduzR0gYK3nvuQIFomRNLwnAa8o8xrYujCZw+zRWVNslPdWA2Jzek0guUcCdXAUKpM8 GA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7Y9vioIceweTTmcOmlo7hxL4SrImClhPSaCdYc+s4mY=;
 b=cC38AstPbI9d4W2H8yP4FTGGXWu1GkZn6Ao26iiJvYUW3GSPXO2/5HyFYAEXFEQVYRuX
 PTA9D5nF3jyzY6Vh3z2clydFPB5GtDX+wUB4bLYywDwxXO/lYGNF1IAwS30QGgIX+J7C
 xVeX32Fz1jRhBBZf5tD/7ZburbzCPL+Tm5EI311Qvv76wu79c+E1/tUEqRHo2ASBkOGq
 rl8Ez/iWGtBMOtTNqo2vkRF0XodyJFOKo6c/mNGMg4uf/Nd1kdbUXdyE+YROQHKNwXk7
 YxbVkta4Vrj38kgByty0QX3SIWOciqUzIL23knQpnBP0VYl0t/NDgGET9EcNugupKUMf HA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a8vy3smv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 17:22:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 176HGA3A062917;
        Fri, 6 Aug 2021 17:22:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3020.oracle.com with ESMTP id 3a7r4byj9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 17:22:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fb5M28PN94IJpNmfnNfBPasjB74LqCHGmvrQp0hdv/AKvx31kj+Q8B+zZu7/IenaWAXyxxoLeJL2AIc3iiSdTzZs/XiNfHJtu6KmtSwjrL6j/3k2+/3xd0YPZcbR9BCOvEgW9acKVJVShS3JLqitXQ1e8aTipRrW1CJrS17rtULaXP/I9onYk0iC99u5+MY67cwITlCanihMa+0N+ocq8wrFroZNyCxdEskwL/at3FTh/sjc49aRpAThhZGJFgIcXycJElDDHMcZTJNy+H0x3M457avzP/LpggM76Mfuoj3o8oV/ukgytA9DHCD6wcFvWaWTIGIt9xprp4yvmt/g9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y9vioIceweTTmcOmlo7hxL4SrImClhPSaCdYc+s4mY=;
 b=kCvyJbyahs8/uanZsItV53BEu3MNB5hPZ7gjPS2SjXOWc3/O7P1t9aI0rL4X/nmzuA4yvwZ1R+1w0bvgmQGfrY0TLaaz13fa5a4ilqJy8jmowoGRgWpqnsJo7BS5eJFUB71zRRWkSeWD0AW8RghlfXoIwCaZLR2NFfCtgD2WJMA/B2g0vUPCGOp8ak7/9T9QvXrn/eLuIR+ASXRGaK7Nng5RoaFOuZdfrCUIzibSDx53bq7fAYjtwCZjVfEC2a6gB69zdrUgC8rejcIg+EBIuLhDCOtCYcj6vF4NA6LJsZ80FOIBN5FYifxGOYdfBka1kSq3FQpvLBk5BWHi3cOH9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y9vioIceweTTmcOmlo7hxL4SrImClhPSaCdYc+s4mY=;
 b=B9rdiHOaHBjJpHQZnGgGGlax8q102K3TVGQ1WEh8uthQ61gJ44si5wVg1akb9EvPd4gj2eIKiWwaCtrYZhuN0y80sAsZ1+h+VtOb/4PcdfGhhX0Ea6Obg02ouoCzq1TApe6y/jktCmidoipFiyCFZxHZM/jWA2y5+wddBLG52/w=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4624.namprd10.prod.outlook.com (2603:10b6:a03:2de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 17:22:03 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.017; Fri, 6 Aug 2021
 17:22:03 +0000
Subject: Re: [net-next:master 2/15] net/unix/af_unix.c:2471 manage_oob() warn:
 returning freed memory 'skb'
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org
References: <202108051610.IrlkPw7d-lkp@intel.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <d5011700-18f1-a223-c6da-bee7f1526caf@oracle.com>
Date:   Fri, 6 Aug 2021 10:22:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <202108051610.IrlkPw7d-lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN1PR12CA0095.namprd12.prod.outlook.com
 (2603:10b6:802:21::30) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7444:8000::7bc] (2606:b400:8301:1010::16aa) by SN1PR12CA0095.namprd12.prod.outlook.com (2603:10b6:802:21::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 17:22:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c500d893-7945-46e4-2bc2-08d958feb4f1
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4624427A525EB8BAB0D33DD5EFF39@SJ0PR10MB4624.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:138;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jAiyv6pI/zVYLP5Hu2m12BYykzcFYj0rDKEKpJJi4LQi6ZhmpsvcJi0iyoM8QzCg66MrdUbgLcvQIKf8pgN3mqpejO99zqNtXiMGuo+b8sA2FGs/6c193EYesyDBx5vVtZJRrolHsSpqg1fejaT/Ac1hI7ujx2vfh0MRkwAs5b3tkp9S6VboNFxkhK7+WRBIt65zwhhFIdyXmuJQOxfYGTAyCNpJOlK3IbBFUJAqsNLC7AFAyAD4m8rDiGqgrVHGPcxPeMX5VOLDMqTQGTc+htGgCZPZqK3aw0KNCyrkzttL4UTphb9G6Bpjk2CB9yhjO0EVXXjqbKgaDW6GTbfZ21ft0PNCjrDFoBQSIM21IbdoywQHkYd51KGpyzEbTWjtN5UktSJU+uYbWNfLFi7cOxA9hrVo2ATVcvo2eXUbqQRU4W+n21zm1497b0t36F6K9Zcd9XdlqzyBBTPVO7oZHllY9MsqPa00xDYtN3d9LBGin1cppiThe5A6cm2zZMPDYEF1SgJhre2BtDsyQF7EPM5MYwcDW+wRQ0EH9jv8f5awB27ephKTd6wtMZ7gfAmkuJXY3bvcGmsLH6iZy7BF5dZOYB3JWRFccmAj7KC1OTbs79AQdMkEenAsHxa7aMv0NQQRqDWMCrUMcktYu270Elhp5J2rg3mWMaIWwiJEbBn4yiuByhQKltF/qMKZgfj6u3yj/UIqrH1spdslTFK8A46pEyMTMSpMGMxV25Byerz/wuqwgjZ+G48w9VWC/Y6f5wYkXESQaiQfnyWGtYfTxUG/6srLSrgeocTUgdcrQg1j5sizgCWklCmkmXaNqv14QYoJwOyRXDQiad+yiedQceIgAXJaDbPcE5svTu3Bjro=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(966005)(6486002)(36756003)(83380400001)(4326008)(2906002)(508600001)(8936002)(2616005)(66556008)(66476007)(38100700002)(86362001)(53546011)(31686004)(66946007)(186003)(8676002)(31696002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1llbnpDd0dCT0swZG1yaUZMVE1CQm5YWVlWUXVpUElFWGlxT2FpSW56Q0R4?=
 =?utf-8?B?YUJuSUhoaDlGM2RRWVFvQXJOYm9sdGJ0dGIyOWFqcTI3M29odEp0TEtVcG8z?=
 =?utf-8?B?N2hxWURUY0J6RU1SMjJuRWN2a2lnamJtalZTTGtoTlIvb2ZMM2RnaGVyVk90?=
 =?utf-8?B?WWNVR2NQbXQ5TXArQllUMUVIN0QrQjVHcFQwSGNxdE1DYjhVN2RzZklkSVdV?=
 =?utf-8?B?TFY3Z3d1WXJ6bndnK3RCYmkrSXFQQm43TC9lODVYWjNRdWJzaEpldjBwWU9s?=
 =?utf-8?B?VVYyQk9sb2NSdjg3aXR4Wmp5SDFJM1l1aVJnT2wyaGVjQ0Z2Q1ROaU1aL3FS?=
 =?utf-8?B?anB2SDE5VkkxOW9zbUlEMHZGZCtZelFwdmw2K1JmcWR0c002TjNwRFhtR2Zo?=
 =?utf-8?B?RmxRZGlxNFlsM0I2TGx3Z0xCaVBBNnZGVk1XNkJGdmdMb2RudlNEMHBkc0FB?=
 =?utf-8?B?dGxlT2VSYVpqUUtrejV5eHBIb3pQak53YlNiVDJDSnc1dGlvZWM1bDRHR3RH?=
 =?utf-8?B?VEIrKytFRmJCdWFwL01XK1pqcy83dEt2YlhmLzJJT1VsRklDRGJieVpWRVcx?=
 =?utf-8?B?bkx2SXZiaU4vUHpYSlFvOTgzWHRYMWd2VUgwSHA1RXdqWHFpcEczRWFWaG0v?=
 =?utf-8?B?VkZ2U2NWOUFYNkQrUmRmN0dWckRKai9iQlNLNDJ0OFJWUHppRklhWkZzME5i?=
 =?utf-8?B?cDdWRmJsVXZnSm4vYjRQV05mbm9YMndrcFJOa01wSC9FczFNd3NBRDVneUNn?=
 =?utf-8?B?cDlYakVXUDJaNHdYYmRXWkJaU3pVNXFxMVcwb3lvM3N0YmEyaWxuRDVIQzZp?=
 =?utf-8?B?Lyt3YnpHSTV3WFF6NFBTb0gwNk1GSzYxZStsQ2ZGOFcrN1BNMjlvdmtUVzhW?=
 =?utf-8?B?SFBHT0UySzVra3dNVzdnTUlUc3VZc1d0SzBTL2RjcTRFTHlPOHgrTVNaek9i?=
 =?utf-8?B?VlM4WTNTWVczbFZRZ3lkMC9qM3ZSWFRKeFBUTlRNUG93K2xrY0EyeWRFVUpE?=
 =?utf-8?B?U01wYkk5ZDBMbnpQVVFVckl5dnlGM2MzNVl3azhzQ0FRcmFiaXRLNVRKcHRu?=
 =?utf-8?B?ZUNzV3Fxa25RNVlLdis5SzBHM3BtOGVoY1BCOG85RllEdHNUOFYxMXc2NHUw?=
 =?utf-8?B?bnZhQnVFaHdTd1JUWEhmRW9XM0huRnRqWmZ6VXd4Q2o4dUEwTEZMOGdwZldM?=
 =?utf-8?B?K2tlcE1OdlRFZXlSand6ZzNQaUNMYzMrSmRqVE8wWG42NXBvVi9BZDJwRU5E?=
 =?utf-8?B?TDY1TGUrcnF0Zy9URHNDYnp3czJlNjlxaW5IMDhlNDBDQVowcnYyMW95Tngx?=
 =?utf-8?B?eXF2UUs4dHpJampWNlRMNWpRZ1VBMHQ2WjdPaDdkUFpTRXNQbUpRMGNYWFU2?=
 =?utf-8?B?Rk5PM0YrSXFXZFFlOVUrcVBXVTR1K2xBdVh4N2pBTmk0MjcrekVVMEpGVkRm?=
 =?utf-8?B?K0lyMDFFRXR5VXZCNkdmc2FrNG1DdUpxdmR1ZkFDVjBTMFhhWDBZemJYQTI0?=
 =?utf-8?B?M2hqQ0EwcVdCL0xWR2dSMDZiSjdKclpBNHBxU2hKUVphQlJEY1BOREVDKzds?=
 =?utf-8?B?a3BVYXRBcU9qbkJVemhOZkhhYlIvK0tHcmg3SnVVcGtIQldjRkMxb0EvSlZU?=
 =?utf-8?B?OHd5Z0tiSjZMcm9qZzhKUFJCaWU1R3dUTEcyZTNjVGFkQWJualVMVjhyT09l?=
 =?utf-8?B?WGFCYUZtREV1TzJxc1ovdzBrN0J4Z0JBdVVTNE9QTlpYOUdoMDZiQ0xNWW9x?=
 =?utf-8?B?Wkd6SVVUa0k1YnU5V3Q4WjFIczAzNEZuTGNTSnAvVWFuck1CNmVpSm5tZ1Nk?=
 =?utf-8?Q?L+1iFrw8hd1lD/rv5ZDpa3sk0OGL+QK5Iey/U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c500d893-7945-46e4-2bc2-08d958feb4f1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 17:22:03.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eSFkP1hiGiIOJ/KBvF4kyEs5wH4n/wLYmkN8Br9sUaEgAcTmGbsqaDkGUOVgFLYG06w4HaXcNej/o8bqOxZGvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4624
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10068 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060118
X-Proofpoint-GUID: FOSWM7XKQqZdqwj3wXAlkKr2y4sK9f95
X-Proofpoint-ORIG-GUID: FOSWM7XKQqZdqwj3wXAlkKr2y4sK9f95
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a false positive. consume_skb does necessarily frees the skb, it 
decrements the refcnt abd if no reference exists frees the skb. In this 
case skb will not be freed. I used consume_skb as that is what the code 
uses.

Shoaib.

On 8/5/21 4:57 AM, Dan Carpenter wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   c2eecaa193ff1e516a1b389637169ae86a6fa867
> commit: 314001f0bf927015e459c9d387d62a231fe93af3 [2/15] af_unix: Add OOB support
> config: nios2-randconfig-m031-20210804 (attached as .config)
> compiler: nios2-linux-gcc (GCC) 10.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> New smatch warnings:
> net/unix/af_unix.c:2471 manage_oob() warn: returning freed memory 'skb'
>
> vim +/skb +2471 net/unix/af_unix.c
>
> 314001f0bf9270 Rao Shoaib 2021-08-01  2446  static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
> 314001f0bf9270 Rao Shoaib 2021-08-01  2447  				  int flags, int copied)
> 314001f0bf9270 Rao Shoaib 2021-08-01  2448  {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2449  	struct unix_sock *u = unix_sk(sk);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2450
> 314001f0bf9270 Rao Shoaib 2021-08-01  2451  	if (!unix_skb_len(skb) && !(flags & MSG_PEEK)) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2452  		skb_unlink(skb, &sk->sk_receive_queue);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2453  		consume_skb(skb);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2454  		skb = NULL;
> 314001f0bf9270 Rao Shoaib 2021-08-01  2455  	} else {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2456  		if (skb == u->oob_skb) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2457  			if (copied) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2458  				skb = NULL;
> 314001f0bf9270 Rao Shoaib 2021-08-01  2459  			} else if (sock_flag(sk, SOCK_URGINLINE)) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2460  				if (!(flags & MSG_PEEK)) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2461  					u->oob_skb = NULL;
> 314001f0bf9270 Rao Shoaib 2021-08-01  2462  					consume_skb(skb);
>
> Need to set "skb = NULL;" after the consume.
>
> 314001f0bf9270 Rao Shoaib 2021-08-01  2463  				}
> 314001f0bf9270 Rao Shoaib 2021-08-01  2464  			} else if (!(flags & MSG_PEEK)) {
> 314001f0bf9270 Rao Shoaib 2021-08-01  2465  				skb_unlink(skb, &sk->sk_receive_queue);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2466  				consume_skb(skb);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2467  				skb = skb_peek(&sk->sk_receive_queue);
> 314001f0bf9270 Rao Shoaib 2021-08-01  2468  			}
> 314001f0bf9270 Rao Shoaib 2021-08-01  2469  		}
> 314001f0bf9270 Rao Shoaib 2021-08-01  2470  	}
> 314001f0bf9270 Rao Shoaib 2021-08-01 @2471  	return skb;
> 314001f0bf9270 Rao Shoaib 2021-08-01  2472  }
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
>
