Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CADC46D832
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 17:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhLHQdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 11:33:32 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29638 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236955AbhLHQdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 11:33:31 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8F9Xov018447;
        Wed, 8 Dec 2021 16:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qG3YeDa4XYwjhtcpDGYJyk/w4EQPExyToQlX3ZwgoiA=;
 b=Forpr0ytC9UNkgAnfzBTvE9P06n6v4qnH+bD1Db8HS1HQ05LqbrJJ9ulTsEt785OM4Ac
 dDaYC3Cq2F3YjYy2/wr+n7Gg0ZCbzabpXKs6FFCrTijerXDUsftBZ12s4G3tLo7qGA8x
 1hpJIST4iXgx3e0zOlNY7JGgDXXdD7OO9JuowPQURtNAr0Y+LtSSrDHFXVAAUuZUx5bd
 NUdwGLIncHKghjlFn1EZSwJBrEjAs/nQfJ+5gToBC0jCE9BNJTFRODpEv8gpZbZUkL2M
 0Q3J4AIS+op3PrPBkW6LE4PANRom6PwvkRdEDMJObdK/oUtfki1EiIGHqOVYx+UZ4fsX 1g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctu96rsuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 16:29:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B8GLGj0041372;
        Wed, 8 Dec 2021 16:29:53 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2048.outbound.protection.outlook.com [104.47.73.48])
        by userp3030.oracle.com with ESMTP id 3cqwf0npxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Dec 2021 16:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QQIwm31Qw94tSSXFw528a9X/bofuYX2UlAEXOTc20R3NCltNbkzsu2v+UmV1AZHYVE9RsuleqKGlvkfsZ2yAGywtKSXglDnvpAZv+o6jMV2EZKYlEnG/EGWcNitklXTxKqfaTOFxHxyGTa/4/yRphRymZvRXHQBrErWZLIZ36vD4Ou9CO8y+utYhZwH7O+2/t3VJV0FtuxHqjtu0gDwN8JCN1Ois4CnwNT9G5e9ZNPBvkGhGIW6Q88VvMr+8R1IFA5aw9r2K+1LgHdVFaZI772e27EpAsiLrraNb2pVJ03EUoCbrTQRp6Qp8tOtREIKDjpqS9fRC4nU2mflrtkGARw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qG3YeDa4XYwjhtcpDGYJyk/w4EQPExyToQlX3ZwgoiA=;
 b=dr83tDXEus+Xgc/6iXLKSlhUDUDUv+jtoUqpFTc/x4uZJ6vBycbTpJtAI7yQ9wnHWbquWiElUr1YI/z+j7NWw6L95rdAZ0qPYZGG/mdpqmFakYOIwFnXMV8u6tDrrWQYS6QiZV0C/A5rti7XGBao7e5Qq4VywVOBmHgxSqn0vShKuuDxua7lSKMs5XJ+BBv9PFEifyFPvxugWN3o0yTY5mmKaxmGBJGGHJdcrlUjc8ArO2qB/f+pn679A4l+MGrXD3cMS8CSnHbV00MHQd1FB8WVoQUA7nEwDSbJUUE9GA7FLGuiRfXev3LKmKbRR0/CNd+qDx/8ek10+IjpSpxYag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qG3YeDa4XYwjhtcpDGYJyk/w4EQPExyToQlX3ZwgoiA=;
 b=hbQYIHwk3gO+/J+zVRFjWSM3x+ZOAUYoOXbxxrYj2GZLtTmhVPTQe67W6cn4VTpeDyUgOrkTRZYV3GkBPgj0ky7nGjZrc0/dOpFtPxhg73cDC1zwHwKzughqKK/9XYC3ZcpmndTldyy9YVGCfImfkarkI/zKeCCvKyKCdNk8HY8=
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN6PR1001MB2084.namprd10.prod.outlook.com (2603:10b6:405:2d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 16:29:50 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4440:4f39:6d92:a14c%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 16:29:50 +0000
Message-ID: <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
Date:   Wed, 8 Dec 2021 11:29:47 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Content-Language: en-CA
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
 <YbDR/JStiIco3HQS@kroah.com>
From:   George Kennedy <george.kennedy@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <YbDR/JStiIco3HQS@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0204.namprd04.prod.outlook.com
 (2603:10b6:806:126::29) To BN0PR10MB5192.namprd10.prod.outlook.com
 (2603:10b6:408:115::8)
MIME-Version: 1.0
Received: from [10.39.220.103] (138.3.201.39) by SN7PR04CA0204.namprd04.prod.outlook.com (2603:10b6:806:126::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Wed, 8 Dec 2021 16:29:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbdf389c-98e5-48d2-5bb7-08d9ba67f4ea
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2084:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1001MB20841F08C98C1DE7E4F66658E66F9@BN6PR1001MB2084.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DFysyhjuea3+yKVvOA8LaawzCgtBxQBGQb6Tg7qpUwNHl+BRtEhfmGt2RzYMk70y9jpyO+Tn1Pl9bGxr5cukAlJVUEfivvtozJHnJSjULugiCByh0vbHWfzoBVFsqXGKFeZ/jfwf7wRmGPQwtvKCpJyD1ZBUQZRvwC+i2Jg+Fh2+1oS2MyB3+zjACReFeRH0tBOKBTSpH9QKYy8TlOMRjxq1BDN4EE1yyhb16TMT0TpWEsyFF+7TP1Jzzl+fY0YywYGuQrGLvXMQ6XwrJRJTcll7dv7puzZqV4wuD/+VBbeia2+mU28EMS7jM48kFQIvLESlrv71wwyq6rA+zG+hZUCbKx7l/KOzFrQG730pMuYFGN+CVdmaewFApPxrrmbNr+UyDXdyRS0++MQ/6bIxGwCF2r9udQ2kJiJeRnrp5aW5a8ABLf1C5GpppCQo628zGERMNY2l0J/WH+VjTOnA/apD00x7SJ+7+b7GB9TgzU8GVcLI8RZWvKUgq387gLT1QgwsTrZj0IkHQUY92N2T/obb4Z9KFtd3RLXA11Td0ovIDAY49PaUHSnWSLdwxcWcMIWb8xZNqve4i6OoTog8fSKc1WNzpcwyHueUO6TkdH6NbuXQA2DxCnXHcWyKGf2N86BAEza9yZsJssvIt4O52scILw50c3/EQu8JD6HBPztgYxf3oife7oOK8j5HGw3uzhn1Y5ZbHPjoj5VG1zMveZWxeHnsWFtJhmzqz1iBzQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(66946007)(66556008)(4326008)(31686004)(508600001)(44832011)(2616005)(956004)(38100700002)(6486002)(86362001)(66476007)(16576012)(53546011)(31696002)(186003)(83380400001)(316002)(8936002)(8676002)(2906002)(26005)(36756003)(36916002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0R0VnNPbXAvWFVpeXphc2ZjeFdXNURkWWR6NUI1cEJURE4zOUc2aFhJRjVr?=
 =?utf-8?B?bUNyYjBJSlI3NXBZVlFleGNlR1hRNTdJemU0ZnpWM2UwU3FhN1lCRXk1bllN?=
 =?utf-8?B?UHBQaGpvbHhXcUhtZFRzekFlc2h5MlRaV1BnbmRjS2daZWZqZlBMYkpZTmNl?=
 =?utf-8?B?eFg1ZU5zcVVac1BnV0pKdCtuK0dVNTltVVVQTHF2czlHcUt4cmNlaGhOTGJ0?=
 =?utf-8?B?bEpvV1IxVVFLbXF0MFQ0cUhISm81eVZNRUJGdmNmUldnTmJuRE01ZG9mL09D?=
 =?utf-8?B?TkV4ejJONGdXM01IWnZkd3BBMHJNMlZUL3RuK1Q5WmtGejdPOUVmU0VpdFln?=
 =?utf-8?B?S1RLcmlzMFZSK21lZjZENGllY0xNY1JLYVlQUkhDTlR3bitiQ1hxS256alBM?=
 =?utf-8?B?YXlydWdNM3hsSlIxNHhqZ085V0NXcWlPVFJWbUJ3YUNpbmM0TEJGTFNyVGhx?=
 =?utf-8?B?WjkxbDU2Ry9ERldSVytaVUhFSWxkbHJFVEFwa080TWUvbFdJeWtERWZwS0VF?=
 =?utf-8?B?WEFCMjgrbUI4VTMrNHZmamRxeHJTWG5mQ2NMNDBES2VwMXhmeThuN2J4a0Jo?=
 =?utf-8?B?Rlh6TFFpblMwK01mbHUycFJxNVhNNVRKYzJhMzRiMkg5aXlzWmdKNDVJdGZh?=
 =?utf-8?B?YnBmaUV4SEMwNFZOR0xXa0FGNEVnOGdHcVQvZjV4RHJCM3F2d2gyZDAvdmpU?=
 =?utf-8?B?QzdpalhvUmFuSzNDSVA2VGlIQ0V1VE1ucnc1RGZidG9BNjRwc3Y3U2l4UjF0?=
 =?utf-8?B?MzNlNG9vUHF5dldGVUh2K0tnRFNOWU51UXNqVW9ybytFdVNWSFJxeU4yaGtH?=
 =?utf-8?B?VlV3QzJzRXU3SEVneFVBZFp2eVY0RlZUanlIN3JVOUlMNCtxN0VsbjYyTEVB?=
 =?utf-8?B?cFZwUlBxMjhBT1E0Y3FGQXlUY1ZneVlWem85OEsvb0tDbFFZbFlOR1U2cTB0?=
 =?utf-8?B?bnVPVkpBWjE3WnFNREZpaEFqeGNrVGQvMG1ROVNJN3o3NUVUSzNzNW12WWdQ?=
 =?utf-8?B?WFJBNmZjU3JKcjhzOU1LMEd1RHNuOTBtU2FlZXMySEhsOGJQUmhybGdLNFEr?=
 =?utf-8?B?LzZla3Jwdk5URDdhL25pTGhDeENHNTQrWDJsNG5oSWtaZXBXS3F1YnB1Rjlo?=
 =?utf-8?B?L0ZGUmxwMCtpZCtIWXlzc0R3SjVOUlp5eU5CeWdJZ20xc0ZLQ0JwSGxHWTV4?=
 =?utf-8?B?ckdhUUhNU211N2F4N3FNZEZMbTFDaVJNa2hyajZUQ0R4NXF3cVVFanVGV3Ji?=
 =?utf-8?B?Mml5d2R0YzVKdWxVcjhLbXZWMEpGTTlKNEZLejY3MjBrVlJua1ErU1BabGZx?=
 =?utf-8?B?d200aWdpakJFYVgyazNpSWFKazJiQVdBVndzandpMVA1bWFpcFJkNTRKOGtW?=
 =?utf-8?B?UldsWTM2bW11Umo2eDN6b0JNdElrL08rcmdoV21xT2hFT1FUZERxWjVSZkYw?=
 =?utf-8?B?WEk0MUhDdHZLd0FHMFhidE0zNEZsS0lXazdyTERKYXJObVUzd29mM2FpdEl5?=
 =?utf-8?B?QlYvRXpmcXZVSFUza2VDZi9LanJsTzRRaUFHaCtkcjc2M1FTYjlzdjJxYTlZ?=
 =?utf-8?B?WGpzS1NiOEFUbWVVMkhORWg0OEpVQ2k2MVFxSFJKcnJha01NdWQ3eFZvTVlu?=
 =?utf-8?B?eE5iV0VBK1E5eWpNOTR0MG42Mk9PVTAwckJGQlkyaGZ3WWFvWGZydDdJWjJW?=
 =?utf-8?B?c2xUOXRLWll0UTZyMTNzMXpBdmEwVldLM0VaSmxuYVVnUVZvWmtYOG5XTVBr?=
 =?utf-8?B?QjRUUThkU0QyemtwMi9QWnEvbzdBVXN0UHhsamdGdEtReWZwM2Z2U0lwUjlw?=
 =?utf-8?B?TjAzV3V6ZTlaeSthVUR2OU00T1RWeFI3SEJKRCtpNi9MV05YY2JLZjdnQ3or?=
 =?utf-8?B?cThoSTRpdTVpOUcvb05oVG9kM3l3VkEyNGxVbDZZTmQyUkR5ai9XeXRYN0R2?=
 =?utf-8?B?Y0pFdkN4b3gzcE1GalQzR1MwNGxLQmUyS2hyTXNxTzRsZG41bU1KYmhZREJW?=
 =?utf-8?B?SUpGblMya1FXL1RyNTZHVUdwMG9HNXlIWDY0d05xYy8xMU5NRktwMlhoR2lk?=
 =?utf-8?B?UkRFcTVnYWlHcHZuSXB0RVZqdEVzajZiRGxUZ1BvTy9lamdDS29rVGF6elZh?=
 =?utf-8?B?eVN0LytCRnBEL2pKUXk4VTRjKzdWV2haZHErQUVGbi9ZYWtoSlZYeWxJc2NQ?=
 =?utf-8?B?TXFEdXVoRjFlc01zMVBEY0xKWWdnQmU4bUlVRzJCTkFoMDRxaGhPS1c3ZkNR?=
 =?utf-8?B?czA0aXVWa1I1M2NFc1AwRENSS29RPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdf389c-98e5-48d2-5bb7-08d9ba67f4ea
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 16:29:50.5064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aitgu3lnGkuTPDZwty0EGpz3I+6cb8VgkF1Sr5ogXSfzngZY5duGAm70ja8p4ZgaPbMv2rHLW0TZexKdA6gQCui9/vqoJxhZ58JPO5Qz694=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2084
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10192 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080097
X-Proofpoint-GUID: Pboe1l0o5ijh5Fl_4CQZnvSegKUd5myk
X-Proofpoint-ORIG-GUID: Pboe1l0o5ijh5Fl_4CQZnvSegKUd5myk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2021 10:40 AM, Greg KH wrote:
> On Wed, Dec 08, 2021 at 09:43:25AM -0500, George Kennedy wrote:
>> Avoid double free in tun_free_netdev() by clearing tun->security
>> after free and using it to indicate that free has already been done.
>>
>> BUG: KASAN: double-free or invalid-free in selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>
>> CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
>> Hardware name: Red Hat KVM, BIOS
>> Call Trace:
>>   <TASK>
>>   __dump_stack lib/dump_stack.c:88 [inline]
>>   dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
>>   print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
>>   kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
>>   ____kasan_slab_free mm/kasan/common.c:346 [inline]
>>   __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
>>   kasan_slab_free include/linux/kasan.h:235 [inline]
>>   slab_free_hook mm/slub.c:1723 [inline]
>>   slab_free_freelist_hook mm/slub.c:1749 [inline]
>>   slab_free mm/slub.c:3513 [inline]
>>   kfree+0xac/0x2d0 mm/slub.c:4561
>>   selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
>>   security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
>>   tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
>>   netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
>>   rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
>>   __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
>>   tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
>>   vfs_ioctl fs/ioctl.c:51 [inline]
>>   __do_sys_ioctl fs/ioctl.c:874 [inline]
>>   __se_sys_ioctl fs/ioctl.c:860 [inline]
>>   __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Reported-by: syzkaller <syzkaller@googlegroups.com>
>> Signed-off-by: George Kennedy <george.kennedy@oracle.com>
>> ---
>>   drivers/net/tun.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index 1572878..617c71f 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -2212,7 +2212,10 @@ static void tun_free_netdev(struct net_device *dev)
>>   	dev->tstats = NULL;
>>   
>>   	tun_flow_uninit(tun);
>> -	security_tun_dev_free_security(tun->security);
>> +	if (tun->security) {
>> +		security_tun_dev_free_security(tun->security);
>> +		tun->security = NULL;
>> +	}
>>   	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
>>   	__tun_set_ebpf(tun, &tun->filter_prog, NULL);
>>   }
>> @@ -2779,7 +2782,11 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>   
>>   err_free_flow:
>>   	tun_flow_uninit(tun);
>> -	security_tun_dev_free_security(tun->security);
>> +	if (tun->security) {
>> +		security_tun_dev_free_security(tun->security);
>> +		/* Let tun_free_netdev() know the free has already been done. */
>> +		tun->security = NULL;
> What protects this from racing with tun_free_netdev()?
tun_free_netdev() is called after err_free_flow has already done the 
free. rtnl_lock() and rtnl_unlock() prevent the race.

Here is the full KASAN report:

Syzkaller hit 'KASAN: invalid-free in selinux_tun_dev_free_security' bug.

==================================================================
BUG: KASAN: double-free or invalid-free in 
selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605

CPU: 0 PID: 25750 Comm: syz-executor416 Not tainted 5.16.0-rc2-syzk #1
Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29 
04/01/2014
Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x89/0xb5 lib/dump_stack.c:106
  print_address_description.constprop.9+0x28/0x160 mm/kasan/report.c:247
  kasan_report_invalid_free+0x55/0x80 mm/kasan/report.c:372
  ____kasan_slab_free mm/kasan/common.c:346 [inline]
  __kasan_slab_free+0x107/0x120 mm/kasan/common.c:374
  kasan_slab_free include/linux/kasan.h:235 [inline]
  slab_free_hook mm/slub.c:1723 [inline]
  slab_free_freelist_hook mm/slub.c:1749 [inline]
  slab_free mm/slub.c:3513 [inline]
  kfree+0xac/0x2d0 mm/slub.c:4561
  selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
  security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
  tun_free_netdev+0xe6/0x150 drivers/net/tun.c:2215
  netdev_run_todo+0x4df/0x840 net/core/dev.c:10627
  rtnl_unlock+0x13/0x20 net/core/rtnetlink.c:112
  __tun_chr_ioctl+0x80c/0x2870 drivers/net/tun.c:3302
  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:874 [inline]
  __se_sys_ioctl fs/ioctl.c:860 [inline]
  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd496f4c289
Code: 01 00 48 81 c4 80 00 00 00 e9 f1 fe ff ff 0f 1f 00 48 89 f8 48 89 
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 
f0 ff ff 73 01 c3 48 8b 0d b7 db 2c 00 f7 d8 64 89 01 48
RSP: 002b:00007fd497632e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000603190 RCX: 00007fd496f4c289
RDX: 0000000020000240 RSI: 00000000400454ca RDI: 0000000000000003
RBP: 0000000000603198 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000060319c
R13: 0000000000021000 R14: 0000000000000000 R15: 00007fd497633700
  </TASK>

Allocated by task 25750:
  kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
  kasan_set_track mm/kasan/common.c:46 [inline]
  set_alloc_info mm/kasan/common.c:434 [inline]
  ____kasan_kmalloc mm/kasan/common.c:513 [inline]
  __kasan_kmalloc+0x8d/0xb0 mm/kasan/common.c:522
  kasan_kmalloc include/linux/kasan.h:269 [inline]
  kmem_cache_alloc_trace+0x18a/0x2d0 mm/slub.c:3261
  kmalloc include/linux/slab.h:590 [inline]
  kzalloc include/linux/slab.h:724 [inline]
  selinux_tun_dev_alloc_security+0x50/0x180 security/selinux/hooks.c:5594
  security_tun_dev_alloc_security+0x51/0xb0 security/security.c:2336
  tun_set_iff.constprop.66+0x107f/0x1d10 drivers/net/tun.c:2727
  __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:874 [inline]
  __se_sys_ioctl fs/ioctl.c:860 [inline]
  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 25750:
  kasan_save_stack+0x26/0x60 mm/kasan/common.c:38
  kasan_set_track+0x25/0x30 mm/kasan/common.c:46
  kasan_set_free_info+0x24/0x40 mm/kasan/generic.c:370
  ____kasan_slab_free mm/kasan/common.c:366 [inline]
  ____kasan_slab_free mm/kasan/common.c:328 [inline]
  __kasan_slab_free+0xe8/0x120 mm/kasan/common.c:374
  kasan_slab_free include/linux/kasan.h:235 [inline]
  slab_free_hook mm/slub.c:1723 [inline]
  slab_free_freelist_hook mm/slub.c:1749 [inline]
  slab_free mm/slub.c:3513 [inline]
  kfree+0xac/0x2d0 mm/slub.c:4561
  selinux_tun_dev_free_security+0x1a/0x20 security/selinux/hooks.c:5605
  security_tun_dev_free_security+0x4f/0x90 security/security.c:2342
  tun_set_iff.constprop.66+0x9f9/0x1d10 drivers/net/tun.c:2782
  __tun_chr_ioctl+0xdf8/0x2870 drivers/net/tun.c:3026
  tun_chr_ioctl+0x2f/0x40 drivers/net/tun.c:3311
  vfs_ioctl fs/ioctl.c:51 [inline]
  __do_sys_ioctl fs/ioctl.c:874 [inline]
  __se_sys_ioctl fs/ioctl.c:860 [inline]
  __x64_sys_ioctl+0x19d/0x220 fs/ioctl.c:860
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x3a/0x80 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888066b87370
  which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes inside of
  8-byte region [ffff888066b87370, ffff888066b87378)
The buggy address belongs to the page:
page:0000000003b0639d refcount:1 mapcount:0 mapping:0000000000000000 
index:0x0 pfn:0x66b87
flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0000200 dead000000000100 dead000000000122 ffff888100042280
raw: 0000000000000000 0000000080660066 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff888066b87200: fc fb fc fc fc fc 00 fc fc fc fc fa fc fc fc fc
  ffff888066b87280: fa fc fc fc fc fa fc fc fc fc fb fc fc fc fc fa
 >ffff888066b87300: fc fc fc fc 00 fc fc fc fc fb fc fc fc fc fa fc
                                                              ^
  ffff888066b87380: fc fc fc fa fc fc fc fc 00 fc fc fc fc fa fc fc
  ffff888066b87400: fc fc fa fc fc fc fc fa fc fc fc fc fa fc fc fc
==================================================================

>
> And why can't security_tun_dev_free_security() handle a NULL value?

security_tun_dev_free_security() could be modified to handle the NULL value.

George

>
> thanks,
>
> greg k-h

