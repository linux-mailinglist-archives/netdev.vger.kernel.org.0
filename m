Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8EA47AAA4
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 14:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhLTNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 08:50:23 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34490 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230044AbhLTNuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 08:50:22 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKB2BCM009168;
        Mon, 20 Dec 2021 13:50:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=wDLNWWKekxOkuKyfgUenBtUnLa8et13pXCayFybknvg=;
 b=w/9IoXrTGRiYnQM+GUaoRlWjDrK3EPvb5M3Al+LuEXqc9aF30PD6g+caa6bJmKBfv2wb
 uuoN36NFbB2xf8JnBI1SGaFydzGJdFLinuvT2/lPNepU1j0p/POWDCCZtXBxpwiSEUNT
 20XU2DPm8Lja4S3kk9achFzr28ef13SJ0K87ZfUGV2xh6fvJk3ZHqBGXD0j8dlJUrxv9
 bD5cdZDQNqKnfumvooRhBq24ZRMMryVz0Gr6/mTCtG1DMl+AdDaaCeSR19I/5eduKMXZ
 KtcxxbKG0XE5ImatFh9uV0x3rQR1V8pSrdcV3W/H5l8WtqWPqysOaXnHO5h2nL9jHp1J jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2rkuganj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 13:50:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BKDknL5019379;
        Mon, 20 Dec 2021 13:50:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 3d17f2kf0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 13:50:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VIfwOITbS1N/Q/5jXJKhyzfguiAG4VR6Hs7tFxDvWoYHV2LI7XkwePadsMG8+85mDRX0FfbO6X3/N+11YuZGLr0yTREcytdRHwgISjj2xb12hyfV/zXI8nOc3xad6729HzUoXnRWv0rLF6+42m+UiDFA+UjGQEdDZvJgSzEIuEQdQ31FTl/GmXyhukFi0iJtjTPJClSlAhGDQRgqLUf4oq0TI+A9/GdEn96cWWZ4tfUgGkZ3jtpqr1PRneTjwPs5XQqCNuxrUPhcofqUgay0+NLQKoFb2HPeQ5i4H+nenN+nlz1U0UE4qeVGC+sUfg46PBUh2EAIVFmzArZjYi73zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDLNWWKekxOkuKyfgUenBtUnLa8et13pXCayFybknvg=;
 b=axQu5STO6CH9Bq9Uc86Wmwb/HUR/VI91kYhGSZGjks3QHZ/WYkZusgEPLVdUy1roKWaiww8zHpHqO/pfAyO/dMQQF+BMxTGN3Z0cEvdgSF4tDuLzKpopr+QUodP6VRQ+4ztXa04525TEIoZcFc2bV3Q9gX4GxX/DNpJHI8z2TbaeD0lw44Y5UVLHs/hqi3IHHqZ2LkO3Oe6Vo9isaUWizjw5hYTkSKCeobklaEcnCgaN3gPpBAsdSjrNI/bCFiqTdc7t+9szBh5BDdUrGYyjtnZan6/ToD2g/VYpq0l6Uhjtok0N6N37FPkaUIRwSzC2SzpRVas3ocpjvz6qNDf3HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDLNWWKekxOkuKyfgUenBtUnLa8et13pXCayFybknvg=;
 b=hwWMNbvDorsTXZU4RUtRz0rd1BgZtzPNV6qcVSs34oROPWw3gR9wJgiSjQGFnDJ0ScnTkuvSYMp+e7ebPHI0jdKKFtUAC5zm5ISgf9qFQApF188vpCs68i8yWcgZ0DXfwhuF9p8sazjUlERw+cWrB2SbTOvvl6I+mGJgbocGz7c=
Received: from CH2PR10MB3752.namprd10.prod.outlook.com (2603:10b6:610:d::23)
 by CH0PR10MB5241.namprd10.prod.outlook.com (2603:10b6:610:c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 13:50:03 +0000
Received: from CH2PR10MB3752.namprd10.prod.outlook.com
 ([fe80::b012:2fbd:f463:f5ae]) by CH2PR10MB3752.namprd10.prod.outlook.com
 ([fe80::b012:2fbd:f463:f5ae%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 13:50:03 +0000
Message-ID: <a6cb8004-50de-bcec-1f1b-b61b341fd8f4@oracle.com>
Date:   Mon, 20 Dec 2021 08:50:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] bpf: check size before calling kvmalloc
Content-Language: en-CA
To:     Daniel Borkmann <daniel@iogearbox.net>, sdf@google.com,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1639766884-1210-1-git-send-email-george.kennedy@oracle.com>
 <395e51ca-2274-26ea-baf5-6353b0247214@iogearbox.net>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <395e51ca-2274-26ea-baf5-6353b0247214@iogearbox.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0102.namprd04.prod.outlook.com
 (2603:10b6:806:122::17) To CH2PR10MB3752.namprd10.prod.outlook.com
 (2603:10b6:610:d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc151bc4-96dc-40be-6336-08d9c3bf9fab
X-MS-TrafficTypeDiagnostic: CH0PR10MB5241:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB52410C24CB39230D8D42E14CE67B9@CH0PR10MB5241.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9PUXFlE2hi396Ht3haLRBPrYEbih+wxL3Es0mrRq5ZL+7kIkrGrlrIEC7+wGIi+3voEm5R0L+HeY7cLIAKBNh5jSxWXa99MFznHG1cTM33Pm2FzU7Or1k9gzstHfuNfnIf7ps9Iu7OSF4jN/OqmuJnP/Bfhm8ZHOTEn3Boi7ZtsSVPWWIP2+n1vZ4U6yemYkPg+msNkEf6c0oduLR86A1z+bGAffkg9K6dFZOHMDxmzVcB/z6NuQuy7n28W1zurjJt00lSu3cyxyw7+VWMTNWjFbfRmvRDpIUBOjYb6C1ZPtlD0780h06TEvUXbcZn01qK2YtyJHziZgC7U8Zg8H5rfifrLaPHuX+IQvnoT1NBFPw3TXtjKxpm7V/9ojysP0UImNgjZAlC2PshgbB1YqFV0jjz3Pzn+g6ekx4I8TuojysQvvTK4cE4jYacr+YsBe9241ygSxACb63YhIDaqBN8SdYGuf1AZoCzUv3LAeKX5YsNjGmHCeO/gdoYgtX35Xn8m9KPBBC/U86AOSRXx8fWBdQaBmCbP4YE4GWgPU+3AfEeAlw0+HxV6hoDnN6Rjmc6Zn5kOFSiq/+xIj1XbwGfGa1h2L1z48TB4X906kgVQmt8j+Dd4GWVLxpUR43BTNv6ErY/OT8wXgxancTr7pli8HZ4XZFJa4+NWOJ165yofYM8DOTJFO3FJPqEzQPGooHMJpcxZOJMNWOPnvLb/fVUdYYQ3U7sLg+iWbwHFro23JxkxOLIkXcjACfQXXzFKARhvORSFNVeHVg13TzRSbJ87uyTHK0IYwTr514Rf9wxY/ntjzMorm5qVUuXFbrJAR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB3752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(316002)(38100700002)(31696002)(31686004)(44832011)(6486002)(45080400002)(8676002)(36756003)(508600001)(2616005)(2906002)(4326008)(83380400001)(66476007)(66946007)(36916002)(86362001)(66556008)(6512007)(5660300002)(6506007)(53546011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG9paXhqK1NqME5STmJ2Qjd3b00xRFg0YWZoaVB0ZnViUmRIYytJYnpZR0hm?=
 =?utf-8?B?SFNZV3FSTGQ3eXRiMG96anJHMFJKUXVoMHJQenVlNDFDMkdoL1VRWWNEUWFC?=
 =?utf-8?B?dDhxYW5RT1ljTWJBaVV5ekxwTUE1ZWJTVHRKdmFjMTVHcTFKV0cwcHdrM3Zs?=
 =?utf-8?B?aHpKRFZzQTRjZ2xuUWFZMVdLUSt0MC9jMFBSeUdSNzdnMzl5c3dYaU5XYVN3?=
 =?utf-8?B?NmMyOS9Cb2d0YTBWZlEyWER1NTZQWjNHUkRWME0zUGVmOXdPRlhlSjRNVlRZ?=
 =?utf-8?B?TW1tUE81ck5SRFB5a2RLRHhNaG9yRkFQQlhMMHArU2hzZVd2WWV4TVNtcnpr?=
 =?utf-8?B?VEhIWTRGMGhpVllzQkIxN2lrL1JObXlBYVlhY0p3dVBSMk9XNEpqYWlwaVE2?=
 =?utf-8?B?UVg2TGNvNnhFWVdmOVZvWVQ2NzhqOVFyRTJWdzJZcHg4Y1lxYlhsaWJuNFNR?=
 =?utf-8?B?ZHFQN2lwRVp0cmVCcTFZOUhaaCtpNGtRZVRlamNsS1ZseFdZNForUFFuRU5Q?=
 =?utf-8?B?T05vQ0JiQmR5L0NnVDU1UDdKaFR1dlpLc0VOZC9yMFRjVXpRazNiZWlYSVNL?=
 =?utf-8?B?YlJKdUN6TEo3c1JOOTY5cllkTnVZL2JlOHMvMStLay9DRXRwT0d4dTdiRVpX?=
 =?utf-8?B?elgwdHhDYkk4R3ZBRlZTRjl4RzNDbEpBdldLZUJFQkZpNThVOG9wU2lkZ1Fj?=
 =?utf-8?B?T1lSZmhubEpEYTR3blhaUGdpbTg1OUJsMEs5Wjd4aTdnVFpIRzRNZ1dmZ3Qr?=
 =?utf-8?B?a3VZUzV3SVROdXJsRmpwSWNQd2pKZ2pHSjJ4YnU2UDRkUzFuVFUvR0lWR20y?=
 =?utf-8?B?Qy96QlpUdHVpQngrbmI2dWxHY3B0ZHJYQllRaWNoaU93M25pQk5BengydTlF?=
 =?utf-8?B?Y2EvYmhGQi9zWnF5UThJeVl3aXQvcDkxa3V5c2VuY3F4ZUN4NjF2NTRsTUtJ?=
 =?utf-8?B?VU5OMlhYQm9KeXJtUUk1ZFljVWdYUTJndlJXUUJwbnhGUVgxaTE0cC96THF1?=
 =?utf-8?B?bHBtZGc1VUpFY0lNU3VaY05UR0g3aWFNVmVJZWNmTTZEOVloNHF5dWVBa2Rj?=
 =?utf-8?B?NjhrbFhXcjE2dDdmQzJJQUhVQW5SVWphV3I4OWpQUGN0UVhwNWhhbndBb2hF?=
 =?utf-8?B?T2RVY3NkK3IwZmxkeXM5ZDI3WmYwTjkwd2libzBXWTNtb21YZ1hVZ3Q3Tlh6?=
 =?utf-8?B?ZXVYdnNDWkY5RVM5TGFLeU4rRkorbzF5RmdORGVWRHBLaitvS2FTSlFaZEdW?=
 =?utf-8?B?UzY5bHFtVHB0YU9DZGt0ak9iVzg5N2JZZnorUmE1VUIvTFJ3cU9KVWxTd09E?=
 =?utf-8?B?anY1M2xEeFBBU25WUHBsSTBVZlpoV3VCamplS0xjTFF3eFY1bHdxS3h2UENv?=
 =?utf-8?B?RG10czNnZ1A1VkJzYVR3SHVaanUwdk5Id29oQ1B1NlgxdlJzYlVUeTRVZVRw?=
 =?utf-8?B?cGNkQzcrUmhlWG01eXhZU1EvUFVsaWtrWWVXVWRUZDVGYkhESHFwUjlmMUR5?=
 =?utf-8?B?bERXdFYreG5BSnZXR1M2dkpkQWlZa3Y1ekNFa0RES1FBYmhOYzRxaThsSjJY?=
 =?utf-8?B?a2xqTmF2RVRQNVRhZUNmSys0aEtqSXV1MDVEOU1Ta2lGRXltSjJyNU1BTGRI?=
 =?utf-8?B?UUxZTnowZ1Q5elIxckhwQnFDZ3lSZjRKL2d1N1hXaUw2RTBmRjlFcHdlTEsy?=
 =?utf-8?B?UzFhMFU1S1BjNGpwek1ibEdXL3hQNzV2QkVCRDg5bFhtc2JpMWlCRGtsMEU4?=
 =?utf-8?B?em9BRmt0TkRvTzFNUmtDK3IrcURxbDNCN3U5KzV3UnBMUCtjWlJYVUFWZng3?=
 =?utf-8?B?S2o1WVBjQVh5dHBUMkVVeERqSXBGbE1zb2ZMU1p3NlcxZVhpdXBXSE5mRGF5?=
 =?utf-8?B?aktlUm9uclpRTEV4UDIzOUtBWjZvMWk5eEY4QXFrMWpaanFGYmZOZEZUREdX?=
 =?utf-8?B?bHJvR1IwUnR3VHc1TjVrMVFlZWtCMWFwd040elVxZmdMbnZvWC82bEgwWC9J?=
 =?utf-8?B?SEtVZ01oTWwzS3B5ZCsvbHhBZ1hydlNVRVhoVm9PUVdFSzhtS2Y0dXhpa09w?=
 =?utf-8?B?Z0NudXp4cFRTQ1BUVkN3b2hpcU4zdXVlZ2J5aVMzeGs3MHF1U2dTNlJWRWov?=
 =?utf-8?B?VkhDZ2VIakt0UmJzWWdYeEZkajZIWmxPb3RLSSt3dlVVQ3hrc2JneGtpZkVt?=
 =?utf-8?B?Zk1XR2x2RWZzeFNibjViT00zeXlFZWNkeGxON21DOE05U0hVc0RjaUt5S3ZF?=
 =?utf-8?B?ZHQzeGVqQUJLa282Ukc4SVJyVzlRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc151bc4-96dc-40be-6336-08d9c3bf9fab
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB3752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:50:03.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96gC5+gKtE3J1xB7tk9H1NDhTKZsK5ocBecIpIWg5Hp+3Qi/Z7482lXdA8Td/XSoSqTPkKphgUDsGHv0VE923mpPMBsYUJrGGqZJOGcdbs4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5241
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10203 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200079
X-Proofpoint-ORIG-GUID: KRfumoiHYXb78jqBuMPc-pCK76YPtIEs
X-Proofpoint-GUID: KRfumoiHYXb78jqBuMPc-pCK76YPtIEs
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/2021 5:45 PM, Daniel Borkmann wrote:
> On 12/17/21 7:48 PM, George Kennedy wrote:
>> ZERO_SIZE_PTR ((void *)16) is returned by kvmalloc() instead of NULL
>> if size is zero. Currently, return values from kvmalloc() are only
>> checked for NULL. Before calling kvmalloc() check for size of zero
>> and return error if size is zero to avoid the following crash.
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>> PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
>> Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
>> CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
>> Hardware name: Red Hat KVM, BIOS
>> RIP: 0010:0x0
>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>> RSP: 0018:ffff888017627b78 EFLAGS: 00010246
>> RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
>> RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
>> RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
>> R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
>> R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
>> FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) 
>> knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
>> Call Trace:
>>   <TASK>
>>   map_get_next_key kernel/bpf/syscall.c:1279 [inline]
>>   __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
>>   __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>>   __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>>   __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>
> Could you provide some more details, e.g. which map type is this where we
> have to assume zero-sized keys everywhere?
>
> (Or link to syzkaller report could also work alternatively if public.)

I don't think the report is public. Here's the report and C reproducer:

#ifdef REF
Syzkaller hit 'BUG: unable to handle kernel NULL pointer dereference in 
bpf' bug.

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 
04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffff888017627b78 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
Call Trace:
  <TASK>
  map_get_next_key kernel/bpf/syscall.c:1279 [inline]
  __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
  __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
  __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f62bc36f289
Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffccaa211e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f62bc36f289
RDX: 0000000000000020 RSI: 0000000020000080 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
R13: 00007ffccaa212d0 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace d203e5a1836d64aa ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffff888017627b78 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0


Syzkaller reproducer:
# {Threaded:false Collide:false Repeat:false RepeatTimes:0 Procs:1 
Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false 
NetInjection:false NetDevices:false NetReset:false Cgroups:false 
BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false 
VhciInjection:false Wifi:false IEEE802154:false Sysctl:false 
UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = bpf$MAP_CREATE(0x0, &(0x7f0000001480)={0x1e, 0x0, 0x2, 0x2, 0x0, 
0x1}, 0x40)
bpf$MAP_GET_NEXT_KEY(0x4, &(0x7f0000000080)={r0, 0x0, 0x0}, 0x20)


C reproducer:
#endif /* REF */
// autogenerated by syzkaller (https://github.com/google/syzkaller)

#define _GNU_SOURCE

#include <endian.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#ifndef __NR_bpf
#define __NR_bpf 321
#endif

uint64_t r[1] = {0xffffffffffffffff};

int main(void)
{
         syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
     syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
                 intptr_t res = 0;
*(uint32_t*)0x20001480 = 0x1e;
*(uint32_t*)0x20001484 = 0;
*(uint32_t*)0x20001488 = 2;
*(uint32_t*)0x2000148c = 2;
*(uint32_t*)0x20001490 = 0;
*(uint32_t*)0x20001494 = 1;
*(uint32_t*)0x20001498 = 0;
memset((void*)0x2000149c, 0, 16);
*(uint32_t*)0x200014ac = 0;
*(uint32_t*)0x200014b0 = -1;
*(uint32_t*)0x200014b4 = 0;
*(uint32_t*)0x200014b8 = 0;
*(uint32_t*)0x200014bc = 0;
     res = syscall(__NR_bpf, 0ul, 0x20001480ul, 0x40ul);
     if (res != -1)
         r[0] = res;
*(uint32_t*)0x20000080 = r[0];
*(uint64_t*)0x20000088 = 0;
*(uint64_t*)0x20000090 = 0;
*(uint64_t*)0x20000098 = 0;
     syscall(__NR_bpf, 4ul, 0x20000080ul, 0x20ul);
     return 0;
}

George

>
> Thanks,
> Daniel

