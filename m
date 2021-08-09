Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C716E3E4DBB
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhHIUTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:19:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:49816 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233061AbhHIUTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:19:11 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179KCF6F031692;
        Mon, 9 Aug 2021 20:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OAjrgrx6VpuRnnKE5vTLWbZdQ6xeWGytEMfsBcFKRgk=;
 b=gdm1M4kOeAUIscABQ5q6IG+MsZ55szUEKijtA7UvDoApWN5W4T9Db/oiXwljil/5kY1H
 JN9V0aQD1lrJQONgLriLayeElMCBgYXotVYIpOPs5sHesBunt2RxywRHpjVcDnM9fWeq
 MfqeiqBqzgh4lyq/SgNNokH23zzXcfKOddHBauFe3TfXKz6RnrRFLEfb+8+hpbYm5wq6
 13//u2XfZd2I91T6fLjVdc0FGmHqAnE2Ggu6jpvM4L2YhJ+eUd0C3Ct5PKEwKyGsO2Ze
 UnZBb8O/h4iateFPhKwMfyKp86RqXdrw7XVGkZlgWjXbvixQjp8wW4IPFbjTQwGuZ9f5 Ew== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OAjrgrx6VpuRnnKE5vTLWbZdQ6xeWGytEMfsBcFKRgk=;
 b=F2smsh1xGzB16ZT5/XCfaXg3fAzXcVrpSIP4H2O/9KNMxnqkiOHBS1X156JjVgdiWo19
 gHKdRZdy00op2/oKMicdCeI0w4yN9tgb/C0Ya0S4K+Y/rpoN/MuRpfwSoX6OGe4FuxG5
 EGbAIf2n74wFei49OWaCMIvvUEp2hewTwPQahrbahvKnJtrOJVNdqIQ1HOUxMMjnf1J/
 so08rIgJib1Xwc8sh4Ik8uPQ3NXHWmID85CAZ4BdZyeAKLLtDVTNeSMYCBRR2ErecSHh
 4RCa6PQ0ulIiM1JJV9lSAYi0YMBPHt6Jevu0Jt6GyyJCYzFCpyCmdacYflTLbSH8OjnI mg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaq8aa9eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:18:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179KAUN1071513;
        Mon, 9 Aug 2021 20:18:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 3aa8qrw558-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:18:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O/VVUOxNMgk6nyZSfPTXqOxTKXmBAAYvCv7PhqpGi6w7U7241K6cYgHA+fRaNIYXxcWLH+oZGpDPFlWuWYSAE/qZWUEvLUMq0roaqD2mbNtG0iaA9n+agsdkBujG2Iq5jJ+5nVqsG1HVvYXQRJx5VaclHT4B3KGjVF7jx5QfTuWwrZiKEWmLPFL80la+d0ohMCClTRf7RURV0cvGljKIh7hOFwBZYriZYbqqdxhcEyWM7ZWwoMeIGsBHi9g0lg02BDNBo6TG2e2GnZkDtBPNvKpn/j4rF+rPMlzyPFHtMkcUZ/rrgC66HagBQwTsvV8yev5N9/NSGXrb6SdHWxvJxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAjrgrx6VpuRnnKE5vTLWbZdQ6xeWGytEMfsBcFKRgk=;
 b=GxyKjsRcdXN7R+09A+DSWLSJZ+qLZ/iaaYObw36f6BCgpXD1prF1nC7PaFogldGq3yQONcdfCPxVMasKSP/NvWcgAXoNOQvLR8u+rJ2QU8lU9OrvqBF0GsS1SGSKmbso65zzDfdvb16nZyO7E3jYMxpzG9PX8yY6g/2E2pRh0GkJDx7JByFJXspwvOrpy8Gief3or0o2dvirvPu++zncRMN0+xcR9I+CWof3XVneAUAzXr3TPZKkRznyfnhKTnR9AUTiGR8wqpov3blsG4Kq2H0oGzabWfMF7gdgpWHL2ZvSvTsd0CkrX4MFHqkqW9yUQOZF/bbfWCTugDFzp0peTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAjrgrx6VpuRnnKE5vTLWbZdQ6xeWGytEMfsBcFKRgk=;
 b=AnZAJ4b4HOvHVCanuEpiQxZOGPWuc3aNRL+6q5mpNv9yTxXbJF1y8yAPDQbzTRXAXjae2oXFf7TKR60vueXmWm7JFkwoEkSvzIoF19K4UCTaK7Bp7kTr+s/lpHVeJD3gKqBzX4rBZPcpRtpaRv9tEVTMqk17+TNRfvCuudWoNII=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4656.namprd10.prod.outlook.com (2603:10b6:a03:2d1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 20:18:22 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:18:22 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        christian.brauner@ubuntu.com, cong.wang@bytedance.com,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        jamorris@linux.microsoft.com, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <YRGIkv/dw+Bfq7BK@zeniv-ca.linux.org.uk>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <0171777a-2f4b-2b0c-4887-86f6d8563bea@oracle.com>
Date:   Mon, 9 Aug 2021 13:18:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YRGIkv/dw+Bfq7BK@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA9PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:806:20::18) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SA9PR03CA0013.namprd03.prod.outlook.com (2603:10b6:806:20::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 20:18:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ef70d34-232e-403f-be4d-08d95b72d5e6
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4656:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4656C9C3BF91A7F3C7547227EFF69@SJ0PR10MB4656.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZVPBRIDA5lKyj/RqIfrNif2Q8t923t82G1MnSJd0kGANkvoWLLshQAjmIkaAXgIRdHdseBPLfayeM+JUWCTJ3lLKMOHzHmy2aDwasKn9LamRXHq/1/srI5eoFLPYMcWPCvl38pkzJK0YQsh9Q+JoZHb1uEUFNXX6C1SRooxz5wOZSbs+uY1BdPUOMvR8Iyzzu39mMSUxQYxJ02Ufuckn2SltVTlZ+EDbRdL5yjEj0zzIzIbycafx0kNHLSBd70ZrdYK/Ihwb+quddNXefQf8inIyHMS8K7vmnktB4lMJaO7cR0Gp8MMWhS/9iWd3AuRcY4oIQSyetPuvzBANFSZoGKN5I8InltxIQQ9mFsqnAXKw/beB354/e9dkxfhMebQs4GuxHMzjlKRhT4PdDY0iVgmPul1m9aPufVqzMJ0TSvgALcFh6gW0xiOAC99FfZIBF/+ZMllPif8EHDGHzsLcQn0UNAy4NXeIKJlkAZLKq92Da6UZViKYpDLTeSf7peDNJXmGaXH7Qng5hFReR8Mkmsht5HCFWJD81WVaIchTgZ/MzecCzsS9n1WWsJhJPspar7XUQEeJgU2GHtcc0Iipt0xszDDcS6hmLxOJkLMl7xnQjI3JROvwN1f0IpDoUqrodVd9+HUB0Vs4x/8Y+/3o5Zqy84sBMbDHz8QO8wEskDb9iAIDj4ZxR5z1gLsStAhxal3kKeHoQ9Xze49zGl1+jMsvZCHij0xlieacxAqSQ2IIAVYvLmacZcCldzkjoDN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(83380400001)(316002)(4326008)(53546011)(186003)(54906003)(508600001)(6916009)(86362001)(7416002)(66556008)(8676002)(8936002)(36756003)(31696002)(6666004)(66476007)(6486002)(66946007)(38100700002)(5660300002)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3Z6b2d5OEdEOUNiZ3Y1SHBjelljczM1Q0JwS1FuSzZjWWczZWI3Wmk3dG4r?=
 =?utf-8?B?WWVDb0l5Y01leVdKUmpVR2FDK0YwTWtIQWR1aTJITnFLdmFyT1dVZXhMcEhx?=
 =?utf-8?B?dHdpaE5zWlJrTjltV1hWTnQrQVBGV2N3NVBSOVF3d29BOGgzcHU3L25NM1Ny?=
 =?utf-8?B?RDEvSkF5ODdyQktvclcwcnZhVzRWUDQ2RW8wa2VXdzc2R2JCWjhFTWtMYkdr?=
 =?utf-8?B?by9TUmpuVzVnb3dWUWJzYk1oaXRldWNIUWRVVEVxVG83d0xodUxYQ3lhZnVs?=
 =?utf-8?B?cVVEL3hwbUs1Y3hmYUd4bFUxTTRnR0tSMVRaOStZeVBVSEFRMzBtTHZSQzQ4?=
 =?utf-8?B?LzVBL01xRFRxMGg0ZW9TNWdqajdIdFUvV1kydHY1ZWFYcWRsREhqMVZHL3g3?=
 =?utf-8?B?RFJWN3EwRjgzTWVYTndwYWlEU21La0pDMFQ5ZmlWSlU2UklDT003Vm8welI4?=
 =?utf-8?B?dEVJVXRkdXJHMHpENExYb21wMGlEZTV5YTFDdzRwNTN6cXFSR0RFQUIzVGJK?=
 =?utf-8?B?Wjh6T3JCa0RDdEE0cnllUUsveDJvV2ZjL0JjdDREclNFOFlSQUlOUlRnczZB?=
 =?utf-8?B?V1REaUxDTTRlY28rL3Y3aFJxeW9PSGRWUENnMmFtY3lGRzRIRWt3UnlXNDFx?=
 =?utf-8?B?UmVoZkI4VjQ0aDhLTGxkOENtcFdDMExhWjE2VVUwRlNwamZxcGhPUFd4RVFq?=
 =?utf-8?B?eXpuRStEcmJzeGVoOTl0R1pmcVM5VXhlUHNjYmxvT3JnVDFQenpHdWhIN3h1?=
 =?utf-8?B?ZEVDc3VCQWhjeGhEMDlVbHllQkZjZ0kwdnhWQ3M2KzRXWXFleklwQjlvL1l1?=
 =?utf-8?B?VGVraHpZYVZkbzg3QnlQQ1l3V1kzb2xFREFWYzNJUFBpdmZIcWZRZjIwUFRy?=
 =?utf-8?B?RkNlbjgrYUtMa2hRb2JQeEU4Q21aTS9vUUpoNWhDbW1FSzVnVVlKby9ydHU5?=
 =?utf-8?B?b1hFRHNOWHNuT1RtSS9lSTdYVTBIYVlQUVR3K3lldHl2eFBtR3Q1Wm1pRWoz?=
 =?utf-8?B?disxcmtvYmppSmQ0aEFpaFVLNHNsdXBkd0lsckhCdWhaVkQ5ZStIU0N0MlRY?=
 =?utf-8?B?TU5LVFN3Ym9HUHNLN0xaVWdNMEszS3IyM25TUm5MRWtoRnB5aG9yTHNVSlJE?=
 =?utf-8?B?dHJSUGNPby9FQUxUL2dLQ3Rrbi9XMzlQZXQxQmtoTzdralhFTy9WVElHdk56?=
 =?utf-8?B?NGFudEw3WWZDQkh0NjZkOFd1NnN2YzdCcWNJSzVZcmU5TkswVjZjQlRCa2Qr?=
 =?utf-8?B?OHlYVldLZnNHTzE1MVR0NTUzUFNtY3NWWGZ2dFJnNlBsZi9XVzUvRTFuZ09W?=
 =?utf-8?B?R012WGhRczdFakp5YUJ6UjBkMTUwdXZ2U1JmS3ErVGt3T3B6Mnprb0Y0dTBM?=
 =?utf-8?B?UTc5N3JuK3F2czhiN3A3MWFBWUpYTWdScnBHQ0dVRi9ZdWJrWkJ6RHpiK08x?=
 =?utf-8?B?M1RrUUtYS3YrZDVOcklkb1lKSXJFeUZuU2tQeng2dVhhUEpxcVRreGZIczVj?=
 =?utf-8?B?TFcwaW9TOEZmTVpORkRTZHQvRFdZaEowcHcwWFJ5b3Y3ZkxTS2UwZjhKUUdF?=
 =?utf-8?B?am9ONVExQTA3SGdSUDNVUlFLYkVmZjJrRnYzU29VVm0rSzFXUUIvdGM0cEJW?=
 =?utf-8?B?dmVTamdKWVhzTytPQUxITVpBN1QrVDFyMm53S0x6amxhS0ZuMm9TcTNKdURP?=
 =?utf-8?B?Vm90aDI3TXUrbG1Tam53a01hWmo4V21iMEwza0ZlQ1VMU2YyM0NPc0J1US8y?=
 =?utf-8?B?TXNrWmFZaDJzN01KYkQ4b3QyUTJMSHBZRDU0SVR1WTlKYlpDUjFPbkliNFl1?=
 =?utf-8?Q?nK20SpZI5RFsSy5yyRwasc+oKeB6eLPqWkHSo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef70d34-232e-403f-be4d-08d95b72d5e6
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 20:18:22.5840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgdysLfyob9YHBOAEgfjDTA6KCUbNSyA7cA4gbLlnPNMfPD1OKL0lioiU21eToYS1vEZVmRAQAZwKeCM/Sg5jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4656
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108090144
X-Proofpoint-ORIG-GUID: fekoCyt30fVrON3fb90uSfZEEqzLpGFS
X-Proofpoint-GUID: fekoCyt30fVrON3fb90uSfZEEqzLpGFS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 12:57 PM, Al Viro wrote:
> On Mon, Aug 09, 2021 at 12:16:27PM -0700, Shoaib Rao wrote:
>> On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
>>> On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>>> This seems like a false positive. 1) The function will not sleep because
>>>> it only calls copy routine if the byte is present. 2). There is no
>>>> difference between this new call and the older calls in
>>>> unix_stream_read_generic().
>>> Hi Shoaib,
>>>
>>> Thanks for looking into this.
>>> Do you have any ideas on how to fix this tool's false positive? Tools
>>> with false positives are order of magnitude less useful than tools w/o
>>> false positives. E.g. do we turn it off on syzbot? But I don't
>>> remember any other false positives from "sleeping function called from
>>> invalid context" checker...
>> Before we take any action I would like to understand why the tool does not
>> single out other calls to recv_actor in unix_stream_read_generic(). The
>> context in all cases is the same. I also do not understand why the code
>> would sleep, Let's assume the user provided address is bad, the code will
>> return EFAULT, it will never sleep, if the kernel provided address is bad
>> the system will panic. The only difference I see is that the new code holds
>> 2 locks while the previous code held one lock, but the locks are acquired
>> before the call to copy.
>>
>> So please help me understand how the tool works. Even though I have
>> evaluated the code carefully, there is always a possibility that the tool is
>> correct.
> Huh???
>
> What do you mean "address is bad"?  "Address is inside an area mmapped from
> NFS file".  And it bloody well will sleep on attempt to read the page.
That is exactly what I said :-). There are times when copying 
thread/task may sleep when the page is not there and it does not have to 
be an NFS file, Linux supports mmap without backing memory and page 
faults occur with files all the time. With the bad address I meant that 
the user passes in an incorrect address.
>
> You should never, ever do copy_{to,from}_user() or equivalents while holding
> a spinlock, period.

Yes spinlock should not be held if the process can sleep. In this case 
it wont but there is no way to indicate that. Thanks for pointing that 
out, as the second lock I am holding is indeed a spinlock (it is 
accessed via unix_state_unlock so I missed the spinlock). I will modify 
the code and resubmit. I am glad we found the root cause.

Shoaib

