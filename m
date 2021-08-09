Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB9A3E4DFC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236244AbhHIUiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:38:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41528 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233500AbhHIUh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:37:59 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179KXl7Y022007;
        Mon, 9 Aug 2021 20:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1tY5p38S9lTtLm9pHV40BqAB6SwexSmAgffuvoh5ZTU=;
 b=BNaZ2SkkN/3SRRCpMQqyZv9ff3s7MOUSvQK5a1GLCIUEgp6Vk8olFYx9HrahVip4aHMS
 qxEtIRR97Jgsv3FH3RS4URQZvWnsd8EMWOZxGKf+m24RKqDsMm1JZm+6+e1uj/UCQjp5
 vXoFDW1E4DyVhWtqADs0ZodRfuyO2ndVEMtpAblk9OKVWNJ6HFEu0T8UEQaVeNr18nHd
 6WPmG6XGTwLPnP9DnkrTbjwx3MlD4QRvfbWPaBl7e60hS3bhE7EBL07WpVPEDzkMUdPY
 2K50oWq3gOoYfpwp39rhhfiaB8jnOUgU0tmfihg5hHYNzMHVYXZbnVObm/nHXorG1BGb AA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1tY5p38S9lTtLm9pHV40BqAB6SwexSmAgffuvoh5ZTU=;
 b=WcaX6W2U+zmoiypK1Ai3wH7PwY6FWbIvhJNKPKraX1YoPCNHPMMXt95dZNa8vIhsqXP2
 ja6sxPEu35eQz73y5HFDfACI2+abNaQhhQyc7VoBF+BSngisAiXulixU0v1jvYbIrWaX
 joWdF8bjLAsTXZjjaFQHyjyfRUGSUOszsboaZgw28IHL712TsxSzHCdOrq8jsUo7/jMd
 Mnw7zE9bCyK8bwvF8R3phk2phqZPIDGSvQYMw2qUuyNxi2F+a6gMRo9n8G+fWuO21hEw
 fVWvu/sshdN6tIP9hZK2lNBWLc2nO1p+XSr4IJ1KSkOoUOq/jvLKV7FBv4aB60sfmlLK Jw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18j9js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:37:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179Ka4jl076219;
        Mon, 9 Aug 2021 20:37:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3020.oracle.com with ESMTP id 3aa3xrvyq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIdzrO58/UoHEatMgEuP4wC+JMs/CzLj0bMsaXr2/bEl6y+W+hm2c8XpLeTfocx0K+IZ3NvRCn2cA8GTXhzoRmazAoieS4nUycq9CF6UyfWOirVsC01Cu3BLyS1J4pdsT3WRtQTkxoW9XAzrntDuyh6s9BKdP2SMBPNAOMI8+g73ST15pOLjqRRebwSaHgXRrvHXga5i8pfMXzvo5KOX2I3NTM6v2pMHi9JaQydVeQ7HFWVzuEbd03MWgQU/sHOBO6+HK3oUtoY/XFcPeYM+NszUAtafQ3Ktpo7d1gaLr5ukk3mh5EJDg+NhkdGcaqm7b5XXcdPt8j41+9iSYrw9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tY5p38S9lTtLm9pHV40BqAB6SwexSmAgffuvoh5ZTU=;
 b=CPrG3JWXnkTEnzeGepzS9dTgGs0ATvKsLU1DgrA9g3kXNaI6vhz8j4z3nrxf8ykmcB4rWu5Gi+8VXWV45ySirjG0QUC0yNL6WdeAV3hojiviHRm0LlTgCND6T2QhIHyzpETdUr2JuK/O04xCacRrMG1BVWNdmJESQOyLELD219gk2CDZxD3SQetcqNHWnXZxK0OC1X3JOu7OhONQct4LZqbpKiF2V4g9IgMNUVNRcqvYitC50JOQwfrxOn5ygim0aiTLgG3yCaaHYRu6dLU1UBQvQVOAhPQebNP8Dm6fQ0TvpXcMAo+6fBjVdgkP8w3aljnk/suq3Cf8cQM9OkuMKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tY5p38S9lTtLm9pHV40BqAB6SwexSmAgffuvoh5ZTU=;
 b=c9TFmyKiSYF7ADusy5OPS2sbGFd8iSVqmN3JCjUQwgqRhEHeJNq7J3D8NFH8o9XgQmnwlOkIey01aYOUucnaiAP7nfQ1VivOviWMKnPGIbeLJgBgYC68oPsYhhe9fPGWguXcwDz+T8icr9P/fokFAV76tGi4EB8UepLfdL2YNys=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4495.namprd10.prod.outlook.com (2603:10b6:a03:2d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 20:37:10 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:37:10 +0000
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
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <YRGKWP7/n7+st7Ko@zeniv-ca.linux.org.uk>
 <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <c1ec22f6-ed3b-fe70-2c7e-38a534f01d2b@oracle.com>
Date:   Mon, 9 Aug 2021 13:37:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <YRGNIduUvw/kCLIU@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: SJ0PR03CA0227.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::22) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SJ0PR03CA0227.namprd03.prod.outlook.com (2603:10b6:a03:39f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Mon, 9 Aug 2021 20:37:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 259b943e-3980-4e4e-9f1a-08d95b75765a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4495:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44956C62D9152516296560E4EFF69@SJ0PR10MB4495.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zZKzF8k6545HrTO1DxEhxb1KOvou5l6MKRpoOchTEtFnoBQewu6c80EYmP1qhHfruJIigdSDtotuHSBTJb1AJwlCuXuTcRWPhaXmnKfflODtLmM0odJaiwM2ET+K5xVG3Bk/XQwXip2l/lwbDgIssinLersENFA4YHs+R1ghVibRPhObjpltrgtr6Q7sXiQK2XqkGkPCpG2EsmMyUliRTBuuYtYjFPm1WS/4sIge1l7MDTMb2M/B38FrkRnLnBE11LjeFxQdHpf47qrv5VF9zdDXgzMnJ/xuw8pV5jqMUFI2a6JlRp2pPfrOuLnVB5XVFHYxMRw/CREPq8119Iw9zFS+WQkq8/PWqGTpdZ4bzFhJcQuOkhZEiBRViZUcNybAvqEKLbuy6/fl1K9F47s4GXtk0FdWd7241HVydaW+IFFd9WXHKRg5tT2DIJTrNhpf0FIcWit4RMRFsLoZUBi7Ju5jBnS3A2B0L+Za+uW/EITcz9msWEaXJF3q5EbMNKa3b5MeCnSAk38VkP+N1ye0p5Hc7JuJRE3LISNSVBRc2vswTmIM5CF+wM4fRviSF8UEm6363yFUsHwzEyytTGpHDYwNxlqFIM1EqiisoU4/u6p+ORTr869R7jF6bRLZPaYuL9Q+bfbNxAkqkL3i0B0bXReI3O9tV+SEX3xo1X1zJdgyw4a/LJXPlz3CPLY8s83HEnc2sPcogIB38MQdxDHl8RSQ/voznX34bOvBKXsFtv4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(366004)(376002)(346002)(186003)(478600001)(2616005)(4326008)(53546011)(7416002)(38100700002)(83380400001)(5660300002)(2906002)(6486002)(66946007)(6916009)(66476007)(66556008)(316002)(54906003)(31696002)(8676002)(36756003)(86362001)(31686004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUJLUlBSOVpSNmJOM3JFakxPQUVPT0JNYm9uSXV6allhS3dZSUtCU1d0WnBu?=
 =?utf-8?B?c1hyNnVFeDM2SDlqaWlsS2NOakFySmFJWHd6ZDVRUUx2MUdveVFvRGMvZ3RO?=
 =?utf-8?B?Wlo1V01USXhIMm9rRmRWUHI4WlM4TTU5YXJlSkxGZEh6a01ob0dZaTY2aW1t?=
 =?utf-8?B?NUt5ZlN4a3dYOFNkajlOWXJRT2k1MFZuRGxvc2EveHJ6L0RxRVRNOE5HN3Zo?=
 =?utf-8?B?RjZMUytnNmM5TVQ2eERReEs1cHMrT0pZQ0RrUHdGOXV5cFZOTE84S0MrNEhZ?=
 =?utf-8?B?TW1McjQyTkFWSFh3YzlHVGJQdWxEeUt1N2hIdWVsRzBWNWFmc3FKTzdEQSs5?=
 =?utf-8?B?TFRrenlmZGtLUHBlTm1WNlpBZlRCcVZNRDIzYWs5YndhK2tzTG9nMVUxMHRU?=
 =?utf-8?B?SUVJNTFkMHUzSjNqdUZPanNqbDBaU3lHaFoxUzNmUDN4QzM2MWM4ME1KYlhu?=
 =?utf-8?B?TDBRMEwwc3phWUNXak1hWHlpV1ZHT1ltSkR1TUsrRWIxcUNtOXVjNDIwYTUy?=
 =?utf-8?B?R1NLdVpUbTR3aHMwUURSVjU2MmJFNHBJdkl4RzhkZmtEVnpUY25nQTdNRklh?=
 =?utf-8?B?aUhzUFIwdVFYclh0aVpwSVFKQkw0WWIvVXdPNUkrQ1JpMHRWcVFQWTNMVCtR?=
 =?utf-8?B?MDJPY3VETDdTc2NrN203T0F2a1k4UVczbEhWay9pQjVHSTlRUWIvMkxLUEtJ?=
 =?utf-8?B?c0JTc2VXcVNiY0hsQWkvcThWM1F0SWtzT0cxaWVjMzZVQ0Q1Vmk0S3hqWXd1?=
 =?utf-8?B?MGV3UHpyVFIvZ2l3Szl4WDFVaE1BSUhFcTNWM1NNTTl4aUc1Y0xidkR3MVZH?=
 =?utf-8?B?TGNjRGFqUnFvOThaT2EvVmpIQkNuM3c2QTJSbmVYMW9nQjZjSkp2TkxGdTdu?=
 =?utf-8?B?VEsyallWTDZQVmRyYmJrYkRacWUzbjZWN1lkUWVNNzYwZ1Azd0dlTFNTaVZj?=
 =?utf-8?B?dXI5bjN1aGxoOW5qb0V1NFoxRFhLY2lmdGJLRC8xZ00rMXFic1F1aU5pUXJr?=
 =?utf-8?B?ZjI2LytRWlVyZ2M4ZU9vQTFKNWxnNDE4MitQL2x1djk5eXhXam9UNUtHbXMw?=
 =?utf-8?B?Vkx4akRnN01jcy8vTzhCbFJrWXlXUjQrMzd2Ykw5dFhaRUNidlZDa1U4Q0pJ?=
 =?utf-8?B?K214RFViamJ5ODUvM0VyZGdiMHpTdk5XOVNuZUg0TGx3dzhyQVJVcW91NjN2?=
 =?utf-8?B?S1ZTYU1ad3RrRVlQSVE0L0pneHVJcGpXajNvaktyQlBHVFF3MzVrZm0wMitm?=
 =?utf-8?B?U0E5MnM4bVZMMWtaT010K250eXllSWVhdFlwc2E5RHlqWlBySEtUNk4wY3o1?=
 =?utf-8?B?Z1kzQzh3TUlkZ3IxY0RHZWNpUUhWZjk3Qk5lVEl4Y3ZxY0ZkV2hzM0RZNHZH?=
 =?utf-8?B?SXliMUI2RVdqSE8vRXl3SzVHR1RmYXlUd0p0T2xGcjNSeGJFN3hsdTVaQjhZ?=
 =?utf-8?B?WXY1YkwyM1B4Q1llZDQxcXpCR0FCZ3dpSjczTmFPUm1TUjRYMGFBaE9vMXRa?=
 =?utf-8?B?eUtickdkODZhd0xSL0p0aXYvbFdTaDQvVDhrdk1WVC95TW1RSGV1OTR3Tndi?=
 =?utf-8?B?eGE4Z1p1OTVkd1hsVFNBNS9NQTRQeGhOM0FWV1JmdkNsbjBzRkV3VzJkdWtZ?=
 =?utf-8?B?WlBwdXJ6U3YwVitIRjh5TEdhYjVSaDdFM29uemNnQVZLcGoyS0k0cUdHZjI5?=
 =?utf-8?B?QVIvSEZiRy9rbFAyVkNEdHg1QmZuTHI1VWFIdGpTUlhWREp5WVpZeHBlUThG?=
 =?utf-8?B?UzVZTkV5OTJDd1dIYUNNK2hYVWdMMXdRMmhNcTdIV0ZVaDFDTnhFOCtyOXJ4?=
 =?utf-8?Q?luu2SPddzn1FtmeQIeRrTYO/NqZQdbdTnUMl4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 259b943e-3980-4e4e-9f1a-08d95b75765a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 20:37:10.7106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uiJNrit9qrTxV+Q7UWkHVWqwiNyERN2qqmBWmiGWzZ5uK5HhSYXidyDUvO1Us1PZpgvKf8ffvGjNj2vLp7wCOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4495
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090146
X-Proofpoint-ORIG-GUID: efDRBCVu5JlMJoylX_y1QgRW7GGTxnlC
X-Proofpoint-GUID: efDRBCVu5JlMJoylX_y1QgRW7GGTxnlC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 1:16 PM, Al Viro wrote:
> On Mon, Aug 09, 2021 at 08:04:40PM +0000, Al Viro wrote:
>> On Mon, Aug 09, 2021 at 12:40:03PM -0700, Shoaib Rao wrote:
>>
>>> Page faults occur all the time, the page may not even be in the cache or the
>>> mapping is not there (mmap), so I would not consider this a bug. The code
>>> should complain about all other calls as they are also copying  to user
>>> pages. I must not be following some semantics for the code to be triggered
>>> but I can not figure that out. What is the recommended interface to do user
>>> copy from kernel?
>> 	What are you talking about?  Yes, page faults happen.  No, they
>> must not be triggered in contexts when you cannot afford going to sleep.
>> In particular, you can't do that while holding a spinlock.
>>
>> 	There are things that can't be done under a spinlock.  If your
>> commit is attempting that, it's simply broken.
> ... in particular, this
>
> +#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
> +               mutex_lock(&u->iolock);
> +               unix_state_lock(sk);
> +
> +               err = unix_stream_recv_urg(state);
> +
> +               unix_state_unlock(sk);
> +               mutex_unlock(&u->iolock);
> +#endif
>
> is 100% broken, since you *are* attempting to copy data to userland between
> spin_lock(&unix_sk(s)->lock) and spin_unlock(&unix_sk(s)->lock).

Yes, but why are we calling it unix_state_lock() why not 
unix_state_spinlock() ?

I have tons of experience doing kernel coding and you can never ever 
cover everything, that is why I wanted to root cause the issue instead 
of just turning off the check.

Imagine you or Eric make a mistake and break the kernel, how would you 
guys feel if I were to write a similar email?

Shoaib

>
> You can't do blocking operations under a spinlock.  And copyout is inherently
> a blocking operation - it can require any kind of IO to complete.  If you
> have the destination (very much valid - no bad addresses there) in the middle
> of a page mmapped from a file and currently not paged in, you *must* read
> the current contents of the page, at least into the parts of page that
> are not going to be overwritten by your copyout.  No way around that.  And
> that can involve any kind of delays and any amount of disk/network/whatnot
> traffic.
>
> You fundamentally can not do that kind of thing without giving the CPU up.
> And under a spinlock you are not allowed to do that.
>
> In the current form that commit is obviously broken.
I am
