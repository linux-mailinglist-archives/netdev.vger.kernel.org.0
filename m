Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7181747C637
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241150AbhLUSRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:17:45 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19998 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240053AbhLUSRn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 13:17:43 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BLHK7rA023709;
        Tue, 21 Dec 2021 18:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2Oao9GOk70AKGUIKx9nW2Y+iy3o/mJ6cjyAcgw2A9eg=;
 b=AiKYCWKZz0Z7lxZVx3shU4SRrHcx2Vfe19ncBNXp2hbavbd165hKnk3eeQgQZHB1MTDI
 EXV/fhCjLM4mgBe7LsvejIXeXikvXcNOkwC/1oNo7Ce/fiiT3RFF+10ByAs4+VeP67Pv
 lelJUKqTGZAhfr3qZLedWkXY0+X+kDLz9R1CDVeJleKb3kyUdSjBMRsvJsvLWLFAjb8v
 mnDPW3QuUMQrayp7bNvP5PidoPId6VV3P2YupkFUzQSFuOrlDW5taXETNfV9Bp89h8zl
 +9xdqLpVSbhswMqbA6gK0Jdy5/oNSU5Z5UcmLDYmtVZi2RmC78uuDyxQ/bX4gLAPEQyM Lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2qk2c2w4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Dec 2021 18:17:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BLIGvkT138066;
        Tue, 21 Dec 2021 18:17:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3d14rvx4p5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Dec 2021 18:17:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/J/JQfYCqq2LRnfXCrcBAz/wd8+vADo+rOAov2teaPZmFZtaLpyWHf0Oy7hdb/V07ncQSCcW586o7R/HLJ5Wek0RvCQ4VuDplfzZXngOnY2CRA9Uugz0ekUve3tx6ZqA6uAArbjOUk662XZ40IRQUYWqQYCaCHpt/ptXQ2j1H0HMDLLFQG0TcyyCn9qrD8Lq3aHC+mFJ7eLaYz9U2AXUFwkAVv3S/pelU6KD/IllTxmGixgRGwttFpyAFwiY3x8pX7djlq4EQHRMZApTOQmSQxfW7qeEDRUkOJ+waDhu/TU8iizo7r+r6UG6YelwBWVbH6/W6rMymYclN+vSVe0uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Oao9GOk70AKGUIKx9nW2Y+iy3o/mJ6cjyAcgw2A9eg=;
 b=VI2SNzzn0emOMGHsawLK/UhqTkntVrUX+QvpCg4sTXrG0p+lPyXhozvpl9bs9g0hby6AqrUpYJVZRMdnnia7tYjgKW3ZtPRAe12mu7QWEeLU+7tUSok7MkPWqsyCauTAMgbKHP7CF/5IDX3vHORFwReGrzxW09spxM440vYkAtlYcD7guaojIxMIm6fEAb7rrGhSTByxzqXBb/8gknJlIu+rxkw9YJBW4XDGDlqy7ZFruCNfRVXpdBnlCumUyOkaovzu9q/pvzNn+U3WQ3aZBlsbDy8SqA2OXITo/YgsBqK1kS8t23K9J1lM5q2XCojhwnsM6Ntdb8RzNzkrVFfs+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Oao9GOk70AKGUIKx9nW2Y+iy3o/mJ6cjyAcgw2A9eg=;
 b=e05h32mlb8EkViOQ24l1dfmc1q7SpqkDMBrQ/GtrVTYvM0bV6Do6y43d+c7dFpZsFvwbidRlT1sXKZ8pKHWc+P5NXCtpSXjm/xRlftMrWm6FBNihZ5e5D2Cabouej+XbwyXJe4OCtaNpk0eZu8qD7wnYDQdOgCBVvRo0/eCuhbI=
Received: from CH2PR10MB3752.namprd10.prod.outlook.com (2603:10b6:610:d::23)
 by CH2PR10MB4118.namprd10.prod.outlook.com (2603:10b6:610:a4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 18:17:23 +0000
Received: from CH2PR10MB3752.namprd10.prod.outlook.com
 ([fe80::b012:2fbd:f463:f5ae]) by CH2PR10MB3752.namprd10.prod.outlook.com
 ([fe80::b012:2fbd:f463:f5ae%4]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 18:17:23 +0000
Message-ID: <dd139846-830e-9363-91d3-1dc31be7702c@oracle.com>
Date:   Tue, 21 Dec 2021 13:17:20 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] bpf: check size before calling kvmalloc
Content-Language: en-US
From:   George Kennedy <george.kennedy@oracle.com>
To:     Daniel Borkmann <daniel@iogearbox.net>, sdf@google.com,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1639766884-1210-1-git-send-email-george.kennedy@oracle.com>
 <395e51ca-2274-26ea-baf5-6353b0247214@iogearbox.net>
 <a6cb8004-50de-bcec-1f1b-b61b341fd8f4@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <a6cb8004-50de-bcec-1f1b-b61b341fd8f4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR18CA0015.namprd18.prod.outlook.com
 (2603:10b6:806:f3::6) To CH2PR10MB3752.namprd10.prod.outlook.com
 (2603:10b6:610:d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ecce68d9-903a-439a-6648-08d9c4ae2290
X-MS-TrafficTypeDiagnostic: CH2PR10MB4118:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB4118439A024D70F99823E4A7E67C9@CH2PR10MB4118.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fv7GGGFljxHCEkcKynfvyhZN1G1mpUmpiczQnoRkolu4JeiVGlmEaQRG/wRAwc99BQAAmeI7XG06xd29CKEHOC8ZybxAW45Pb5afUQ74fpMjV6ZU8w8iE+HsW5iIhGJjg9ns5xMVEkbvZ+8R51bsC9wAjZA/dcIfMBdwhmnsWHUbxoA307+adgLtdEiqPjT/w+XXsJZ9UlaKl/OB55Lpjrv8Qjqn1us510JMkQ+98CWKdqb/J0OVvMPU5MW1gpEH5L0ccGXOnS5/04HF807M8rd7rKH4FPT7PEA3XVeKMpklc5QyAjex9mHd5FmyKOWtYPcbdB1pi6TfEV3ZFPnzL0mI4wtJHJG7q8s7HpLFyMol5Us0Tb1qDGOKMIJGGfulXNLWMSpUl96WneeCr5LbDtXkVVZyHiIZeEbCjK2/OLGuOnQbjr6v3cyqSvDRkju3oz7ztcqD5xzIrYrnRCTff2kp8Ifc7TJNGXh4ZSDMWl7tOTVrpIFzbV0TnOdqXViYeFed3WQwiKKsMSnqLHiW1RIugvd9g9mBCV5SQYuNAjBY05B10J6ugey5fKMnS3gjWFDPeSb+F9NVb3zQy48Uu0G3HZ0/U0GWdEMNTg+d0ToYyrerCOAl7mudU5Slp7p1i6r/Yz/Aic0VctR58a/zCSKzTP7R1fft5vy5elUhIbHFmvEi8tCjMBBo0n4Mc96EmnsPM25Lq9sg24lLXYi3ivMLYWGIhiw6X3azDrFIWuGWyF5RMuW8eIX0VwfMD5x6PcY2gT7SQPUfiJ02KzzvXgIvJkXpssoF97NrgXprs7uj6EEjeRZZzUOIhOJ6DOZ6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB3752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(508600001)(30864003)(316002)(31686004)(31696002)(6506007)(2616005)(6512007)(45080400002)(4326008)(5660300002)(8936002)(44832011)(8676002)(6486002)(66556008)(36916002)(66946007)(86362001)(66476007)(83380400001)(186003)(53546011)(2906002)(26005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDhMOExKcGVlY1ZlVmVLTWhscXpZc0J2c1lPdmIrNFBUcndOSE8zejFKclEr?=
 =?utf-8?B?amVLOWFQOHMxT3VZUjZraFNyd3VXaDh1dmQwd3FtU2lDQ3UrK3lDV2xjWTl3?=
 =?utf-8?B?SG03c1NBV2ZwWHpJalRPQi9ua21SK3JYaWZOYWFmbHprdGdKRVRuby9hUkxw?=
 =?utf-8?B?b1ZLQkFJL0VjYmx2RFdlR0o2akcvTk94ZGx3VG16SUY1emx6ZmFLY0RHWXpr?=
 =?utf-8?B?blprWCtUM2VZQW5tMnBLU29YejhSY2YwTVdYTlF4bWFPL1kvdVd2VEVackhZ?=
 =?utf-8?B?SVhMQWI1ZHE2a0N4VkJzbm96YUhORHlpZmdMMVlPS2JvdXYrSG4vaFl0N2Zu?=
 =?utf-8?B?Q1FsVUVIMUpWRWwrcEJvK000NVBSWE9LOGxBNlRXTm5BMkd3c1E3SkZEcDBH?=
 =?utf-8?B?NXVEaURiS2psbE9oRGxxQitsb3A2cXdmbkFVa0IvQ2REOWRLZ0RpTjJ3UnVR?=
 =?utf-8?B?TUZ2dHY5bE9hMWp6cllBamNNeEVjQUpUZUluanZQNXpTaWtjS1BUeWhPTjN6?=
 =?utf-8?B?WUI4RHpjUnA4eWQrWEpjK3Q5N3c2NXFYM1V1R0JWK1NmMDBwajBkeVdWbVIy?=
 =?utf-8?B?eU9YVk5IMWxSdmoyMFZZQy9NL2FSZnhGdzR0L0JCL2gvTjN5UzBHWGswV2lR?=
 =?utf-8?B?MnV0Yisyb2ZYeGYvU2k5OVFsNFhPTjdoVmo3UU80QUVLU0dmTzZRUWd6c0tP?=
 =?utf-8?B?Z0NIWHJybk1WTjVOWkljdHorZ3JJdktBRkh5M0xEc2U5eHd5SXNGNjNaSFV4?=
 =?utf-8?B?NkdjN3N1ZjVBaFhnUVY3NjVIRFJETDhpVGsreDYzNlJNb0tSRGp5SUlZWXhZ?=
 =?utf-8?B?VWh5NUtRanVGUzkyZ3lId3JxVVhYNU9CNVExZ0FvNzRGdDNjbytVSDlsWFlU?=
 =?utf-8?B?TTA2T0pUOUxoZmJjczlYcyt0cFkzUkxtN09maVg5cmtvVjErUmJGNTFFbktS?=
 =?utf-8?B?RldXUTFFM2hCR2VyVEx1RFBpbC9vUHJrOVZuY1VFT1ZOOFhZeWk1RCt5UUYr?=
 =?utf-8?B?b0ZHbHRLZ0pxRXExR1h5ZG5QbTVKMEs4eU4yVjI5ejMrbzVNNk41YXl0cXVT?=
 =?utf-8?B?aFZZK0Z6clluL0l5U3M1VEY4WFVsL0s4MU5HUjVTTTFvcXdERHBSK0xDUzdo?=
 =?utf-8?B?U2lDZkZDUStiS2pFS3RwRUxFSVRjbjNmRjNBby93bjBaSEVxV2xsb2pxYkwr?=
 =?utf-8?B?VlgvYUpmdEJvOENRZHR5dVE5ZUZpMU9VMFR4N0FHL2t3SVdaN1h0dlpBbHZJ?=
 =?utf-8?B?eElmNmJlVVhFcCtrZllzZS9IS0YwRjJDbktzSlVCb2V6ZjJQSlVwclBKWTFz?=
 =?utf-8?B?M2wvRWNIbHB6aGdwUWE1ZVhYT0hCYnZLSEZ4YTZDL1lYdjVBRlV4Q3lsSVFE?=
 =?utf-8?B?b1J6d0ZLd3EyU29pem1BUFZueDl2Y1dYWDFMMXBaQXdHTFFuRG4xcHdMZkd5?=
 =?utf-8?B?SFZGUUt3ZXN6b0ZneHlFMlRITlhOL0plb0hvN0hUUnZKT3lvZkpMMk0xSjV0?=
 =?utf-8?B?eWxGOTREZVlRWndUNlpkblR2UGFyRlJOTzdsRGNMSENFN0ZYYndNamIzblkw?=
 =?utf-8?B?UnhXTmU4NTVrRE9JNUlTTzJ3WUxzbUJ4SE9zSHNMdlhrZ1R2YlFMeWVVS3ZZ?=
 =?utf-8?B?RGtLOTQrTk5LWGhLd2pOWTBlZzdHS04rQ0NjdW9VaGtEYlFvU0g5U29yRnla?=
 =?utf-8?B?a2hSYkltMjk2MXBrbUtKQzBubi9qbDQxLzM2dGtsaW5jUUdVaWNkRDBHa0dn?=
 =?utf-8?B?UkhRczVFS1R1Uy9xSDlOWEZWcTRIUWhtRCtXT2VkVEIrU2l2SGRJK3NidVky?=
 =?utf-8?B?a2hWcU5iNWJNdWlxczNoZ25Ec1RYRTg4SkRCY1VtcXBERUJZdW11cHo4UjRo?=
 =?utf-8?B?aEhUM2NvMVZqb1h3NVN3Uk5ON3hLYmd3RlRPZ3N5TGdQbGlrR0tZNVpNditX?=
 =?utf-8?B?MmgyS1Mvb0xMT3hzOGtMcEU2YkJNZndLd1dmREhVVGZReGxsaGhUdms5RnlW?=
 =?utf-8?B?Y3pWN1pqSER3R2xFaGN6RmhneDJreWtkUUZyMEI5aitHQjZrKzN1MU4rajJO?=
 =?utf-8?B?N011L2huRUhHNThnZkVCQXo4WW5la085MG43MTJBOVdVeVVvdW1obHV0Wktv?=
 =?utf-8?B?Z0NDWU5UZmxreUw1YWZnQU9nSXB1MC9qVXp0aXlsWmpzK252L2piS0NRUWNl?=
 =?utf-8?B?cysySmFFQmxCZGRMMUluR1Qvd1hQTkR0RThWVnpoWFFybTlLWFFKcW5oN29C?=
 =?utf-8?B?SmowZVZTalZINjhadzU0a1Rjbmd3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecce68d9-903a-439a-6648-08d9c4ae2290
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB3752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 18:17:23.5690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyQ4USV5X+5uKtGMxc9bOdMEJHvRhdMapFIO99njyEhiqYpnK9aO+HVIcZXJjk//9mG1CZG+nK8WQyOTlGmxl4e/oU/3sOhD/6dqd2iqhYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4118
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10205 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112210090
X-Proofpoint-GUID: gwcv-KyDsqQveui60YgOUyR79JSHklUY
X-Proofpoint-ORIG-GUID: gwcv-KyDsqQveui60YgOUyR79JSHklUY
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/20/2021 8:50 AM, George Kennedy wrote:
>
>
> On 12/17/2021 5:45 PM, Daniel Borkmann wrote:
>> On 12/17/21 7:48 PM, George Kennedy wrote:
>>> ZERO_SIZE_PTR ((void *)16) is returned by kvmalloc() instead of NULL
>>> if size is zero. Currently, return values from kvmalloc() are only
>>> checked for NULL. Before calling kvmalloc() check for size of zero
>>> and return error if size is zero to avoid the following crash.
>>>
>>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>>> PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
>>> Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
>>> CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
>>> Hardware name: Red Hat KVM, BIOS
>>> RIP: 0010:0x0
>>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>>> RSP: 0018:ffff888017627b78 EFLAGS: 00010246
>>> RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
>>> RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
>>> RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
>>> R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
>>> R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
>>> FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) 
>>> knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
>>> Call Trace:
>>>   <TASK>
>>>   map_get_next_key kernel/bpf/syscall.c:1279 [inline]
>>>   __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
>>>   __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>>>   __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>>>   __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
>>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>>
>> Could you provide some more details, e.g. which map type is this 
>> where we
>> have to assume zero-sized keys everywhere?
>>
>> (Or link to syzkaller report could also work alternatively if public.)
>
> I don't think the report is public. Here's the report and C reproducer:
>
> #ifdef REF
> Syzkaller hit 'BUG: unable to handle kernel NULL pointer dereference 
> in bpf' bug.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 1030bd067 P4D 1030bd067 PUD 103497067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 1 PID: 15094 Comm: syz-executor344 Not tainted 5.16.0-rc1-syzk #1
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 
> 04/01/2014
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff888017627b78 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
> RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
> RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
> R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
> R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
> FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
> Call Trace:
>  <TASK>
>  map_get_next_key kernel/bpf/syscall.c:1279 [inline]
>  __sys_bpf+0x384d/0x5b30 kernel/bpf/syscall.c:4612
>  __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
>  __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4720
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f62bc36f289
> Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 
> 01 f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007ffccaa211e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f62bc36f289
> RDX: 0000000000000020 RSI: 0000000020000080 RDI: 0000000000000004
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
> R13: 00007ffccaa212d0 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace d203e5a1836d64aa ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
> RSP: 0018:ffff888017627b78 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff8880215d0780 RCX: ffffffff81b63c60
> RDX: 0000000000000010 RSI: 0000000000000000 RDI: ffff8881035db400
> RBP: ffff888017627f08 R08: ffffed1003697209 R09: ffffed1003697209
> R10: ffff88801b4b9043 R11: ffffed1003697208 R12: ffffffff8f15d580
> R13: 1ffff11002ec4f77 R14: ffff8881035db400 R15: 0000000000000000
> FS:  00007f62bca78740(0000) GS:ffff888107880000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000002282a000 CR4: 00000000000006e0
>
>
> Syzkaller reproducer:
> # {Threaded:false Collide:false Repeat:false RepeatTimes:0 Procs:1 
> Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false 
> NetInjection:false NetDevices:false NetReset:false Cgroups:false 
> BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false 
> VhciInjection:false Wifi:false IEEE802154:false Sysctl:false 
> UseTmpDir:false HandleSegv:false Repro:false Trace:false}
> r0 = bpf$MAP_CREATE(0x0, &(0x7f0000001480)={0x1e, 0x0, 0x2, 0x2, 0x0, 
> 0x1}, 0x40)
> bpf$MAP_GET_NEXT_KEY(0x4, &(0x7f0000000080)={r0, 0x0, 0x0}, 0x20)
>
>
> C reproducer:
> #endif /* REF */
> // autogenerated by syzkaller (https://github.com/google/syzkaller)
>
> #define _GNU_SOURCE
>
> #include <endian.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
>
> #ifndef __NR_bpf
> #define __NR_bpf 321
> #endif
>
> uint64_t r[1] = {0xffffffffffffffff};
>
> int main(void)
> {
>         syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>     syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
>     syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
>                 intptr_t res = 0;
> *(uint32_t*)0x20001480 = 0x1e;
> *(uint32_t*)0x20001484 = 0;
> *(uint32_t*)0x20001488 = 2;
> *(uint32_t*)0x2000148c = 2;
> *(uint32_t*)0x20001490 = 0;
> *(uint32_t*)0x20001494 = 1;
> *(uint32_t*)0x20001498 = 0;
> memset((void*)0x2000149c, 0, 16);
> *(uint32_t*)0x200014ac = 0;
> *(uint32_t*)0x200014b0 = -1;
> *(uint32_t*)0x200014b4 = 0;
> *(uint32_t*)0x200014b8 = 0;
> *(uint32_t*)0x200014bc = 0;
>     res = syscall(__NR_bpf, 0ul, 0x20001480ul, 0x40ul);
>     if (res != -1)
>         r[0] = res;
> *(uint32_t*)0x20000080 = r[0];
> *(uint64_t*)0x20000088 = 0;
> *(uint64_t*)0x20000090 = 0;
> *(uint64_t*)0x20000098 = 0;
>     syscall(__NR_bpf, 4ul, 0x20000080ul, 0x20ul);
>     return 0;
> }
>
> George
>
Hi Daniel,

I missed another set of kvmallocs. Here's another report and reproducer:

Syzkaller hit 'WARNING: kmalloc bug in bpf' bug.

------------[ cut here ]------------
WARNING: CPU: 1 PID: 15091 at mm/util.c:597 kvmalloc_node+0x11d/0x130 mm/util.c:597
Modules linked in:
CPU: 1 PID: 15091 Comm: syz-executor949 Not tainted 5.16.0-rc5-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 04/01/2014
RIP: 0010:kvmalloc_node+0x11d/0x130 mm/util.c:597
Code: 01 00 00 00 48 89 df e8 01 4f 0c 00 49 89 c5 e9 68 ff ff ff e8 b4 82 ca ff 45 89 e5 41 81 cd 00 20 01 00 eb 95 e8 a3 82 ca ff <0f> 0b e9 4b ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44
RSP: 0018:ffff888017687b50 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000080000001 RCX: ffffffff81b63b8a
RDX: 0000000000000000 RSI: ffff888101916500 RDI: 0000000000000002
RBP: ffff888017687b70 R08: 0000000000112cc0 R09: 00000000ffffffff
R10: 0000000000000000 R11: ffffed1004a71db0 R12: 0000000000102cc0
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff888025092800
FS:  00007f0794bc3740(0000) GS:ffff888107880000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000500 CR3: 00000000299d0000 CR4: 00000000000006e0
Call Trace:
  <TASK>
  kvmalloc include/linux/slab.h:741 [inline]
  map_lookup_elem kernel/bpf/syscall.c:1099 [inline]
  __sys_bpf+0x415b/0x5a80 kernel/bpf/syscall.c:4618
  __do_sys_bpf kernel/bpf/syscall.c:4737 [inline]
  __se_sys_bpf kernel/bpf/syscall.c:4735 [inline]
  __x64_sys_bpf+0x7a/0xc0 kernel/bpf/syscall.c:4735
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f07944ba289
Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc3a07dcd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f07944ba289
RDX: 0000000000000020 RSI: 0000000020000240 RDI: 0000000000000001
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000004006d0
R13: 00007ffc3a07ddc0 R14: 0000000000000000 R15: 0000000000000000
  </TASK>
---[ end trace 67ed3be15b904c13 ]---


Syzkaller reproducer:
# {Threaded:false Collide:false Repeat:false RepeatTimes:0 Procs:1 Slowdown:1 Sandbox: Fault:false FaultCall:-1 FaultNth:0 Leak:false NetInjection:false NetDevices:false NetReset:false Cgroups:false BinfmtMisc:false CloseFDs:false KCSAN:false DevlinkPCI:false USB:false VhciInjection:false Wifi:false IEEE802154:false Sysctl:false UseTmpDir:false HandleSegv:false Repro:false Trace:false}
r0 = bpf$MAP_CREATE(0x0, &(0x7f0000000500)={0x1e, 0x0, 0x80000001, 0x1, 0x0, 0x1}, 0x40)
bpf$MAP_LOOKUP_ELEM(0x1, &(0x7f0000000240)={r0, 0x0, 0x0}, 0x20)


C reproducer:
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
*(uint32_t*)0x20000500 = 0x1e;
*(uint32_t*)0x20000504 = 0;
*(uint32_t*)0x20000508 = 0x80000001;
*(uint32_t*)0x2000050c = 1;
*(uint32_t*)0x20000510 = 0;
*(uint32_t*)0x20000514 = 1;
*(uint32_t*)0x20000518 = 0;
memset((void*)0x2000051c, 0, 16);
*(uint32_t*)0x2000052c = 0;
*(uint32_t*)0x20000530 = -1;
*(uint32_t*)0x20000534 = 0;
*(uint32_t*)0x20000538 = 0;
*(uint32_t*)0x2000053c = 0;
	res = syscall(__NR_bpf, 0ul, 0x20000500ul, 0x40ul);
	if (res != -1)
		r[0] = res;
*(uint32_t*)0x20000240 = r[0];
*(uint64_t*)0x20000248 = 0;
*(uint64_t*)0x20000250 = 0;
*(uint64_t*)0x20000258 = 0;
	syscall(__NR_bpf, 1ul, 0x20000240ul, 0x20ul);
	return 0;
}


It seems like kvmalloc and its friends are used with no size check
throughout the kernel. It seems like the commit that returned
ZERO_SIZE_PTR ((void *)16) should be backed out.

Should I send out a v2 of the patch including the other kvmalloc
calls or do you have a suggested fix?

Thanks,
George

>>
>> Thanks,
>> Daniel
>

