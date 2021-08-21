Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40A03F3C51
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 21:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhHUTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 15:51:50 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52704 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229484AbhHUTvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 15:51:49 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17LG25le021505;
        Sat, 21 Aug 2021 19:50:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qyJgXIoGxiwVWNdHNSo+To2OAkWyd7wODxDco2OCpVs=;
 b=Yz8aFY6tTbfbhaYzeb8AbAH9oaSjgAy08afe8fjmkk7igurjezVBUFgBqhknrqGVTM+1
 a3fR/lVlC2Bnwbgw6CEu3LR6vfsH4HZWc3je8vYw3MG8+HzlkCLqJU6JNwDnm3gOYq0E
 Kb+68GrirbcJsDFILpf+a50jWIFp4dKda74WjbNAzhBG4c7w1OTJfhKmZ02jAgDG0X6+
 CIH8Uw5/9qtdrhM4pkwj9k7Zp3KDqvjw4vDr0kD+0TZgeovphRsBYT2iIhQakaZqTEPn
 ytiQOjP4l+LPxU926St7OeuxfAJFai6PWt47+Dwup0Zvz+3dglxSmee83yEq/tGA8pAY 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=qyJgXIoGxiwVWNdHNSo+To2OAkWyd7wODxDco2OCpVs=;
 b=NqNN7uKa7t7lsJTfMdUyC8OlUogBunulmHyLGCS31w2gqIZzW6j28wRTNbf31AYwQfXK
 5RzloUmtfKxhTZj0jHyJvRB7Qkei+57RMX0vr2GLJ+aj/VIharEwCkKOs7W5IpRysm20
 aqf0HHvqwKJ1Y3HwhYV0gnCNr7ygy1eb9K387k3YKmOOQpY+GpFhL9Ci3soAoAlo8bY1
 OCrfZnI0tQJzpJGg1pQWq216y7i7HdSO2JhD8OONsHoPghxCqRsXHd3toEaznhC3UpXE
 YdR+79IAaC/v6yuDUVWx/K0icwfe+j8amgTdwCgNB/Oi8wEnbns90ujZmYedOIzsCwmv fQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ajuahrns7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Aug 2021 19:50:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17LJfPYN082180;
        Sat, 21 Aug 2021 19:50:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3ajrtmdt3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 21 Aug 2021 19:50:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOvfu/iOqsZktA1n9eG6kkyoA18gaPLQ0U6eSGfpKf4QIGxd0LDuBbbRXRXcPuuznRGpOM7MbiwNsKvssjtQon3evGu0HVAlMOSJGtqNgsLF0vVCO3vmb6JlSKc4cKO8QHNCD4kNXGUwRJcj6nJO/8F6UdD1h5+3yYEGRwryM2qd118SAWt3oLoKdfwZfyZIXgtfWKczUc25/YXASAhZjxJOj28kgVhxnHkfMM36hmErx6tGBJziepxLJ6INkfbTAmQjgFv0G4eaKki6ttutfFj2cfuGDeqcPD82/eYux0mw0kfxr1ZVKKva/ZirFDOlXkr6C5Ac4MY0VNhH8OlcAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyJgXIoGxiwVWNdHNSo+To2OAkWyd7wODxDco2OCpVs=;
 b=FESUSWcYDtsWndgzhU15hE67SkesyoiXNVYEpI6nPCk0M3OfK4/1OWikgbKSqhZxlcoYfeIlOKKlTcGcRbEt9dRwtOG1X9k3PeZsgn/pKlsxe6b8XmohTjJLM+EShvBA8xphmqVtGiT2xtBv1o8MWi0eNArPV+88ReipQ/W3oa0Y7Vqpk15E8FRdRdOO8ymgY6FZ+w6ypoHzdcT8f0wgvGV+dMEcTz4VpZLX7Pb/fNTZc3NAE4TSea1KPvszGKA/oLjqb9DTv0lT/S8ADrbtPpA1aKqEilisuMXl6RSCOITIC3AxiQBFU7LtjMjHoD5gGQyiwCkKfEcovtkVvpuRJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qyJgXIoGxiwVWNdHNSo+To2OAkWyd7wODxDco2OCpVs=;
 b=qPk6q3aKgelGOmQNNUSHeKr6AERdNGqSik5wWMmUIXAXmJ6SVcjfylFomPDl+tbAK56YCrd1eUJ00fv0yp6O8oQFKQE5Isz5Z0ZOhYKGV3JMvF87svM8Uds8v6+J5rlwOzDFW2incB7uTochNozap1neENb0y4lGtDtA1yummn0=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4558.namprd10.prod.outlook.com (2603:10b6:a03:2d8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Sat, 21 Aug
 2021 19:50:24 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%4]) with mapi id 15.20.4436.019; Sat, 21 Aug 2021
 19:50:23 +0000
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in
 unix_shutdown
From:   Shoaib Rao <rao.shoaib@oracle.com>
To:     syzbot <syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com>,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        cong.wang@bytedance.com, daniel@iogearbox.net, davem@davemloft.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
References: <000000000000cdb89d05ca134e47@google.com>
 <b2f64546-9198-1550-c377-28d0e0aa31fc@oracle.com>
Message-ID: <1707343b-f7d1-1804-6240-3f6bb6603f93@oracle.com>
Date:   Sat, 21 Aug 2021 12:50:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <b2f64546-9198-1550-c377-28d0e0aa31fc@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0165.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::20) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7444:8000::133] (2606:b400:8301:1010::16aa) by SA0PR11CA0165.namprd11.prod.outlook.com (2603:10b6:806:1bb::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 19:50:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8995a12-bfd2-4f67-7d3a-08d964dcea58
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4558:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4558ED7F61C7DB3C475C6951EFC29@SJ0PR10MB4558.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nna5EsGUUT4QTLIdEFGu+JPpXomUXL++zJehlf8OmA6IKUu2aJ+iZ6aIZoi81luFJQDQ5cxbyMVc15/TUjfVpxkfXj0eymHNyLSj0Kimmwouj9+22Wxh926tSb1fEZ0jkLwDJcOu90BSOwzTh/J/SDyw1URln2Df4kx7zMP53XJ+06eWsjrpTQh9EtNiUiqoQlORZmlKVMzDPblQXremZOddsX7MGSZOrPUM8+N6QuFJ/TyNnHn1NuVzEuNIgFmx4FY+E+aAyaOB8VCOUVa/eESE/2uL1UNCHjotSozAemjk1xo+WxT8DILRXsncQJAyadbBMjGtXhIsMI+Sw5S+jdm8/dd5pqjKIRPDsjEWToG3qczW1QN7O1WLemaX1fsyoOLFWXsweyXz3q/0idObN2PHWIZltVilF6NEiI3haU+TzR4m86E2AqUyiwalzjEQ5fjSsyKma3WCKbkBhNs+UbIItUUlfNGJIZAA+p8pBfkUU+CwgTlav3BKK9iPHxCYfmS0tqQTPacp4AQNPJ+iU8nwD8FYtRoyYcW1DFPNAUHwwTN8CUm7xzqCVpFQfbBgmwi2z/L9NOvompViGc9dkarkMhPMqNuzBlRZyKKBKuO5Z+HTTSVD/czugEBrjRdUk1xt6uEUTNWW2JkH5iCLNBalTZNcQH/ytXxjLpCNyiBUCq/fnUf0WEEHdHPkcX/aB21IHuxON4SF/YtAulGrf49QmvaiVE4KTXCHa0f/ZD5s8UvQlGS47plU/HKv8YaNCPF6d/vLXx/m7qkfXfe5bLEThxVB4WkjrwqzJMvcqEdad96AkqRMmARFmzMuS5OQ4FBX9HE4TRgbH4Mvi01j9+cycxK3xgoTMgRcBNW6d0zbvSLdudathtVgxXU3LUVtNqTY6P1mLu0MWSDuHujLCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(6486002)(966005)(45080400002)(66946007)(316002)(66476007)(508600001)(66556008)(2906002)(7416002)(2616005)(53546011)(5660300002)(8936002)(186003)(921005)(86362001)(31696002)(36756003)(31686004)(38100700002)(8676002)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M09mallYdlAzTEFFYkJmQjdDRkwvVUEzSGM3Y0lWWDROWEEwWEZFekRBYm1Q?=
 =?utf-8?B?Z0Q0cllrQkVDMFBEcTU2V0ZsRWZpU3pOZ0NXMzNzbFpWVytaOTQ3TFN2cE9m?=
 =?utf-8?B?Smo4aGlob1pxcnUvTVEzdWtFMzZuS3Q0SHJ0NVc4RjN6ZFZFSE01YzNQaVpB?=
 =?utf-8?B?QVc0QU4yT0d1aUZ3MmtwU01tZG1XVU16N0dkc0lHMHJRTTJiYkxkbnhEOTJy?=
 =?utf-8?B?cUk0VVFMODREdzNPcmFOZTJENWdiU3pQRDdDdnZlRW9iM3pGQUFDTEpXTWZR?=
 =?utf-8?B?T2N0eVhEUE5wUEQwZDMrdnNDTDBQMDhGbklnYVhlYVZtTGdTd24wKzJsekhX?=
 =?utf-8?B?NURwdnEza1E0SW02QUliUzZBcjNxWG5JYkh2b3lLRU0vdVVTYzBBMXR2UUti?=
 =?utf-8?B?V1NyZG1KWCs4eVJoRnBhT3Z0WVBMNkxoMnhUbXp6RnRMK1ZpS2U3UlphNzRu?=
 =?utf-8?B?UHJJOWRsaVRGd1pMdEh6cWdVV1NITzNVM1AvY045R29nZDZoWmQ2RkhzZEVH?=
 =?utf-8?B?TEtsUDRiRGNOM3lyQ3BpSGFHcmVGUUtJVXV6WWFNTW5MeUREMUs4WU1xWUVZ?=
 =?utf-8?B?L0grME5QL1lIL1JhYUVHT3VZSS9ycHgvWXM0NU4wby9zazMrVWZPVGUyWHMw?=
 =?utf-8?B?UjdKaHlhb0FPWFRBL2dtMHYxR0JkMk9QZjdnQTc5UHk1M3RrT1V0MVlkZGZ3?=
 =?utf-8?B?QnlOZyt5TTFYZ1gyWENhZzZkMFk5TXRCcGJQVWY1V25HaGRXWWZnUUFWY2VM?=
 =?utf-8?B?aGt4T2RZZmRldmgxbFBnUXcyNlRlSktvRjNCMitwRHJYVUR5TEJVN3pCK2Qv?=
 =?utf-8?B?RVFrYTVTRE1zdHRXeTZ2STNpdEpxeDJpdzFDK2w2eWx6MFEzVm0xaGVEaDdh?=
 =?utf-8?B?Wk5tRDR3VWVSbXAvNTlZRXcwU2tldU51MDFLZmV4RGQwL1pWWkppWnk0QnFP?=
 =?utf-8?B?NlhrVW9lL2FIbFBROTZvQTdLbGdkNGl3WlYxUmZRVHBwYnZZT1lka0xLUEk2?=
 =?utf-8?B?bG1RaWltLy90TTU2S1Q2SjEreTdUS0FyVlZwZDN0ejZ3UXlmS012YW9CTmhw?=
 =?utf-8?B?K29yWVFvbFhycGVEbkcyRlhkOFR0UHc5QUZKOUdpQkl3T2JvTU91SXhkTVB5?=
 =?utf-8?B?YzJKcm1XWVJ2dDhqS09tamhwL09RaHlEVGd2SWVpdFBHZ2FkMGlUYXFWeUJw?=
 =?utf-8?B?ZENWNUcvL1IrSUM0Qi9zUnBxVE4wSW56OHkvSVY4ZUMraU1xRlhJOW9sN3Fx?=
 =?utf-8?B?NHJyTTU5LzViN1lvK3J6M0ppbjZrUTRueUR0bmNJU1FTdDhSRG1UakZON2JS?=
 =?utf-8?B?V3drd1FVOS9TZ1FqZjFtWkc5aDIyWkcwNi9jY2F1OTdRUkRBVUxUc1RSRGRV?=
 =?utf-8?B?c3RzcmRNRm94RUNGQk8xQUlQbFZjNkJSWWVpRWFDdHBtblNYaVVzUEI4aTNX?=
 =?utf-8?B?UTBTalF3UjFUS1RlR1dKSkYvbzJnS1FoSnRUUER4aFpLUXFxUlAxS29XMmF2?=
 =?utf-8?B?RUFCQ3h3YU45aHZXTko2UTJoaGUyb1pmdGcwY0VQMmd6OThtLzFFVkVWZ2h2?=
 =?utf-8?B?RUZld0NQNDFiQ1hjMndBRTJoMVgxWlNMTUg5a1M2c1VsdEUxWHd0ZzNiVFlS?=
 =?utf-8?B?c0E2MytIN2lWNEJpeGFhUEdMMXZhMnQ4cEx4Q2NIbEwxcTZtaUJCalBzTFoz?=
 =?utf-8?B?ZGM3czBwaE9QZEY3RUlQcnVJTFR4akxGQWVwQk5OclZPUjRqenFhYjR1UW9Z?=
 =?utf-8?B?aVJwUHo0akZ6SDcxZTNzY2NaZ09ma0toOVBUZjRzY3N3dDNGWE9nZUVWRm5o?=
 =?utf-8?B?S2dRTU1DTEtOQW5ERXFXZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8995a12-bfd2-4f67-7d3a-08d964dcea58
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 19:50:23.8708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GGYmYgrQVRcWNiz0B92IR9MTAkVt1q0TT75sv4SsX0GdSOAcpfpBu+c52uJVIt3pAxUs7MAL9ZBhh1th10Ec6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4558
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10083 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108210123
X-Proofpoint-GUID: UdSDnEMuqOpm4GzRmXP41ycnyl1hdLqB
X-Proofpoint-ORIG-GUID: UdSDnEMuqOpm4GzRmXP41ycnyl1hdLqB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resending as plain text

On 8/21/21 11:43 AM, Shoaib Rao wrote:
>
> I just tested my changes using the C reproducer and do not see the 
> issue. andy.lavr@gmail.com had contacted me earlier in the week about 
> a similar panic and I tested shutdown and could not reproduce the 
> panic, Andy tracked it down to
>
> https://lore.kernel.org/patchwork/patch/1479867/ 
> <https://urldefense.com/v3/__https://lore.kernel.org/patchwork/patch/1479867/__;!!ACWV5N9M2RV99hQ!dCQkqhyYNMmbH4T4zQ7Ko0sVqSmut7DBj-QmuLRiHuH4xiBwxXc5cbtLaZgKdYGH$>
>
> If that is not the culprit please let me know.
>
> Shoaib
>
>
> On 8/21/21 8:19 AM, syzbot wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    9803fb968c8c Add linux-next specific files for 20210817
>> git tree:       linux-next
>> console output:https://syzkaller.appspot.com/x/log.txt?x=1727c65e300000
>> kernel config:https://syzkaller.appspot.com/x/.config?x=681282daead30d81
>> dashboard link:https://syzkaller.appspot.com/bug?extid=cd7ceee0d3b5892f07af
>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>> syz repro:https://syzkaller.appspot.com/x/repro.syz?x=13fb6ff9300000
>> C reproducer:https://syzkaller.appspot.com/x/repro.c?x=15272861300000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by:syzbot+cd7ceee0d3b5892f07af@syzkaller.appspotmail.com
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>> #PF: supervisor instruction fetch in kernel mode
>> #PF: error_code(0x0010) - not-present page
>> PGD 6f812067 P4D 6f812067 PUD 6fe2f067 PMD 0
>> Oops: 0010 [#1] PREEMPT SMP KASAN
>> CPU: 1 PID: 6569 Comm: syz-executor133 Not tainted 5.14.0-rc6-next-20210817-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> RIP: 0010:0x0
>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>> RSP: 0018:ffffc90002dcfe38 EFLAGS: 00010246
>> RAX: dffffc0000000000 RBX: ffffffff8d27cfa0 RCX: 0000000000000000
>> RDX: 1ffffffff1a4fa0a RSI: ffffffff87d03085 RDI: ffff888077074d80
>> RBP: ffff888077074d80 R08: 0000000000000000 R09: 0000000000000001
>> R10: ffffffff87d03004 R11: 0000000000000001 R12: 0000000000000001
>> R13: ffff888077075398 R14: ffff888077075b58 R15: ffff888077074e00
>> FS:  0000000001747300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffffffffffffd6 CR3: 000000006f93f000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   unix_shutdown+0x28a/0x5b0 net/unix/af_unix.c:2857
>>   __sys_shutdown_sock net/socket.c:2242 [inline]
>>   __sys_shutdown_sock net/socket.c:2236 [inline]
>>   __sys_shutdown+0xf1/0x1b0 net/socket.c:2254
>>   __do_sys_shutdown net/socket.c:2262 [inline]
>>   __se_sys_shutdown net/socket.c:2260 [inline]
>>   __x64_sys_shutdown+0x50/0x70 net/socket.c:2260
>>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>> RIP: 0033:0x43ee29
>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffdc0b3c908 EFLAGS: 00000246 ORIG_RAX: 0000000000000030
>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee29
>> RDX: 00000000004ac018 RSI: 0000000000000000 RDI: 0000000000000003
>> RBP: 0000000000402e10 R08: 0000000000000000 R09: 0000000000400488
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402ea0
>> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>> Modules linked in:
>> CR2: 0000000000000000
>> ---[ end trace f541a02ac6ed69b5 ]---
>> RIP: 0010:0x0
>> Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
>> RSP: 0018:ffffc90002dcfe38 EFLAGS: 00010246
>> RAX: dffffc0000000000 RBX: ffffffff8d27cfa0 RCX: 0000000000000000
>> RDX: 1ffffffff1a4fa0a RSI: ffffffff87d03085 RDI: ffff888077074d80
>> RBP: ffff888077074d80 R08: 0000000000000000 R09: 0000000000000001
>> R10: ffffffff87d03004 R11: 0000000000000001 R12: 0000000000000001
>> R13: ffff888077075398 R14: ffff888077075b58 R15: ffff888077074e00
>> FS:  0000000001747300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: ffffffffffffffd6 CR3: 000000006f93f000 CR4: 00000000001506e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> ----------------
>> Code disassembly (best guess):
>>     0:	28 c3                	sub    %al,%bl
>>     2:	e8 2a 14 00 00       	callq  0x1431
>>     7:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
>>     e:	00 00 00
>>    11:	48 89 f8             	mov    %rdi,%rax
>>    14:	48 89 f7             	mov    %rsi,%rdi
>>    17:	48 89 d6             	mov    %rdx,%rsi
>>    1a:	48 89 ca             	mov    %rcx,%rdx
>>    1d:	4d 89 c2             	mov    %r8,%r10
>>    20:	4d 89 c8             	mov    %r9,%r8
>>    23:	4c 8b 4c 24 08       	mov    0x8(%rsp),%r9
>>    28:	0f 05                	syscall
>>    2a:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax <-- trapping instruction
>>    30:	73 01                	jae    0x33
>>    32:	c3                   	retq
>>    33:	48 c7 c1 c0 ff ff ff 	mov    $0xffffffffffffffc0,%rcx
>>    3a:	f7 d8                	neg    %eax
>>    3c:	64 89 01             	mov    %eax,%fs:(%rcx)
>>    3f:	48                   	rex.W
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> Seehttps://goo.gl/tpsmEJ  for more information about syzbot.
>> syzbot engineers can be reached atsyzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status  for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
