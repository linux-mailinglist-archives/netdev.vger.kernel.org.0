Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223F93E8300
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233749AbhHJSak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:30:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3876 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231580AbhHJSaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:30:35 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17AIBq15028336;
        Tue, 10 Aug 2021 18:29:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6azRTZ2rJ3/br0KxnQ/+dZL3tCfQ42QsTh3W+6M1n+4=;
 b=f3zM2H41xuNEr0mMTwAONnOeqOcMZLvYJrkNQguLn3Ecd62TOmB69teoGf6C41mE7ToQ
 aUSctjZ970iqCpt+7mUUcZLeeM9uYrn9gyaNwESaiRshc+rU6uF6FAA4XLWqwWeFRs7X
 dRIvCfOeWPV+sPit4vOdKG27dO0PFbR8+uRg8IOuu0kVbzT477BAQB9twuH7bC9YTx4e
 9ACwxM9/JMposYcYg062UrxNXOxBW9cxAsG3X0BfemrSpWfma5Mc6G/nL4aV+7/v5SVI
 AmLvfPZOwICQ6JD18Gp7KFrQDfdKirbj13kqpyk5CrUda0a1NG4tv5Xkg9sR41QjirfQ Ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6azRTZ2rJ3/br0KxnQ/+dZL3tCfQ42QsTh3W+6M1n+4=;
 b=xCvnbwTmpfSRYVUC2j6bTjopDCLltFJG50VtF8LW+SdPgGy79rlUCsJP72XV4Quh8CJA
 Zdsg4vNpb73k0KxZMG2u+3HPV2a2/w3aqROzP/sacyIUHuqM1dooLl+3stpkHq1M113k
 ewOhKv7fjQ6Pr8lt/FwK811Ec7RO5Q1w8p1vh6dsMnSBibwdK9zO+57my7KyovRvnDY6
 Zya0R1r/ORUi4cxDCfYghvviOj613WKQ2wtwDGvzjWjxvZnIvsykl6TSyfEJDLKb0Om9
 9vUrB43/bee6K2xeUgYRiylxrql3jYU2oKiudpHmCg/T9UWWENxDpKuJsDuuCJmi+ZFN gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aay0fvmk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 18:29:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17AIASV5039874;
        Tue, 10 Aug 2021 18:29:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3030.oracle.com with ESMTP id 3abx3u9yx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 18:29:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4AMpgxPWKYOcLFtJGH6He1pW/Dd2K/c/OkPS4IJwhoQE7v9o7yGFdOngpw9kaOnmeEccl+AYz+LvQqjOkQ6m5lS8a2jze4eoh8BlKi2lfgiRnLaonapmSBGKGBGn1CgYg6z4phgQZPFrzLe4qMosuYV0oI5Yv9+Lg6ur5S8RRq4A+X/KQT94HmquOcyc+/WWV12PUuoAf69Z6kddwQJUORDIT4HTj2WhoW3EKguHdIn5ETy51uwsFcZyHRtfTrKQiL4k5ygz1cQnf5GmrqxFZ6njrG6HpELVmBa2tn3OMXeftJbTBFqWsCx6wIblbxJTIETzj3+QKOpy7vb3yihbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6azRTZ2rJ3/br0KxnQ/+dZL3tCfQ42QsTh3W+6M1n+4=;
 b=C4p4OXDaVr1/F2wYhVKvpwB2S2g+0HhbB12G4P3ptSU1lJLAp/LcDrt4Ngf27UkSxLmcprX1dJ8MTqo2IQOj5bhwUCqlppUx1tt3huqmaA/MSwgZc87cKMfTKzMfgOj6sHp/u41BgCP1JjpbLw+AYRPkmZ1NyAsrB2qjOJuQstiENkpYce849eQkeLbNQHezDljQyBBL8s/KtTmqDSmMEl/cCFQxW4IdBZtSqOF14ULZjpHe63uS3xED0IWyQ1JIMY3NrqluOmlDPybb9nWbgIersFYgUWbUqkNe8+5V5WW81o8IdDbZtOU1tKBDoBgXsCnR1B0lf3cFCQMmlzzYzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6azRTZ2rJ3/br0KxnQ/+dZL3tCfQ42QsTh3W+6M1n+4=;
 b=vFSkPaEqOtqaTJiAKd8gdH9XrOus+yt21jqhlQoFP0iJT4Qnu+eEMblSSKlhV6q8EvCkSYi6iRMNARXOeS6qshHa5yRR6gUJqqrLvXXspzH8qRMV2nGKbzY7dpSe6menDgte11cc4C+1uNeXDN/GLAmLsOpi7xkfpSb93XjF9H4=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB5647.namprd10.prod.outlook.com (2603:10b6:a03:3d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 10 Aug
 2021 18:29:49 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 18:29:49 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
 <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
 <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com>
 <66417ce5-a0f0-9012-6c2e-7c8f1b161cff@gmail.com>
 <583beba4-2595-5f4c-49a8-f8d999f0ebe7@oracle.com>
 <CANn89iJOFoMa2-Dx+_b8p0-FNNKhYn4DsB3AbtL7zR4bvNR5DA@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <53cda27e-418f-40e6-b33e-ba891fde655b@oracle.com>
Date:   Tue, 10 Aug 2021 11:29:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CANn89iJOFoMa2-Dx+_b8p0-FNNKhYn4DsB3AbtL7zR4bvNR5DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN6PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:805:de::27) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::1ee] (2606:b400:8301:1010::16aa) by SN6PR05CA0014.namprd05.prod.outlook.com (2603:10b6:805:de::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.4 via Frontend Transport; Tue, 10 Aug 2021 18:29:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dc60755-90cc-4e46-f678-08d95c2cd61e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5647:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB56475A329786F1327F8BA43BEFF79@SJ0PR10MB5647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3eoSe6uF1IBcCQTXIbgCAKKoPM2CQFdQCHS5wDaUcAl9NTuCQC3juaeeeoSg8FvxqohP5o7kPEqiZ1q/pXg1qT3fcdPvngiIm++u+AXlnjucUbJVS5IL498gFAkhE2e6v7RL9Hg3iKjKnr/RSFf50WeNZk8SeHXCHy1Thf4jXr0aOqu03K9XqPp+8BgUagnuGIKr1Q5HZYdjis79WQL5K4g/fu+d1ysvN2ogftQedVU+3LqXNnNolV53mwTwdCz1UTs4W6wayWoKuILXQ6dS4mXal+pBy/I13ofMUQ7FGW86o2BQdadeGftUNw77PO2LO/KCwFOW7YaFy2xnfKQONR+aypZ0cxWz0TXBIeMhWN7e+r4rUDpQiH3NYf/25aRzlxW8tXbZV0Z12/vsZ+iT+V7ACqMGBKJyQfkd3laCHVKqCWbT71u2paHTsToen68cRnZ4NUUjtbPioeJfLUaui2M6wmIoU1kGTySEhs9c/dVGDTZSKkA//iGDkdaEJbIRgIWGBgRF/HG/tiuD8SZAYS5asclVGKCV6ylG7qytiKoiEHKyFzexXO+hP21T/A0Kx5A1rTs6XxexwPDdF6A3/rnZcHw0644egc46cANSxzCsCMYgDHEjl0AJCGRscb5cdTU3PFPiKnfiO2lkBIFK8hEgwNmVagE8r1kb5EMJ42rj8OZBQn4wBWtiZ77KqEmrWswIS/bMq3lbFg0ygjllT6J/3jb/7/HNG+YxdPALgOUjc8yNA0eqTCDLmfMZ2vmfoH+Tl2ttKUsPfR4isiX17A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(39860400002)(346002)(376002)(38100700002)(86362001)(2906002)(54906003)(36756003)(66946007)(4326008)(53546011)(8936002)(6916009)(2616005)(8676002)(7416002)(6666004)(478600001)(186003)(66556008)(316002)(83380400001)(31696002)(5660300002)(6486002)(66476007)(31686004)(582214001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjFPTWtnQW93WkR5dDZFUUYxUUJjWGt1bDZPYkpaU2lpd0x5TlMzam1YU09t?=
 =?utf-8?B?R2tQKzJyWGN1MFJwRmhZM1pNd2NyR0tZeCtTVllEWWcvdGhWZ28yZm1JSnlG?=
 =?utf-8?B?UldJOUE2MzhOTEZaR3BFNXhSOHg0Q29qVEtQd2NHSGUrcW1ENFdIeHozWXNm?=
 =?utf-8?B?QmEzYXpTdDRPTS9ERndNK1QxTW8za3laRk9ONzU1cUI2ZkJqSytvc1FNdDJm?=
 =?utf-8?B?cjJtSVNsNDY2Y0pXRjBWaHpYY3g2cTFMNTgvbklSMDZSNWJrdE9zcDBYK2dV?=
 =?utf-8?B?Rm90U2VuTy9lYWZVbXJ2b3Zqc2E2UjU4dXFQeFo3ZFhycU9pMW1rVjRZUVRT?=
 =?utf-8?B?VmxlajdBMDVGZUZ1dWxodU0wUUZ6UVlYbEZReTE5UUpsNFkzZWN6aUJsd3Fr?=
 =?utf-8?B?NmcwRUIzTy9YZnlPY25qWWdiK09icGd5cE92cjhyL0FFckRuSi9zRGl3enl0?=
 =?utf-8?B?bktNMzdkdGVPYW9vejVQcFV1eHN0OUNKVkF4RmpJSFhnd2hWSnFneCtlT0pW?=
 =?utf-8?B?SGxSdGJtY09LQ0gxbHp3U2t2NW5FWHFaNmxPMjZTdGpjLzI1aStLZHNzZHZC?=
 =?utf-8?B?emdhZmJIOUlZUGhjTDVrUXczZDAydTU3a0RxVVlKZUFYdFNsUldlaVF1K1hV?=
 =?utf-8?B?NUdwSXYwUXIzRW00N1VneWlFeWN2a1IwQ2thWjIrS1dIaGYzN0pLUXVoeXdp?=
 =?utf-8?B?eVRiRE9CSXZqdys3Y0JHSEVOeWUwdXN5Nk00YWQ3YTcrUGUwdmg3MTNEWHZ3?=
 =?utf-8?B?TVZXQit4OUgxMkxXWTFWYXVSTnZOdE0yMUtqWE0wQk5IdHJ6WnJsdlpVTTJ6?=
 =?utf-8?B?TlhDT3Z3ekp6TmZWRytGNVNUcHJpd01JRy9Ma1NrK0NFN0oxQjZSaTcwanps?=
 =?utf-8?B?aFA4T2dsSk5DYW1jQVh4aWE0VFRSTHBGeDd3eDdGaDhXY0VjelhZNHYwOGxn?=
 =?utf-8?B?emZCa1hHSER0T2hsVTNqR1V3VU01aWdXcEUreHE1UDUvS3l5VURjZnQ1dk1s?=
 =?utf-8?B?aGZxQ2lPcGRnT3V1cUxOYTEvaGc4NDd6ZWxHeWN6dVR6MTBUZy9OUzZEd2xU?=
 =?utf-8?B?NVlFZkpEZXdHYS9OU3pFNDlpR0JBUkR3aGFxcHpib3VpUHdPeDlqdFZsMzZZ?=
 =?utf-8?B?aCtlOEY5Vm54Zy8wYms0UnB0WWxQY3hpamlMZCtEb1RWQXdXNDFLaWlDYnJT?=
 =?utf-8?B?eTY1cjNuOWszYXozclJTTTgxSExFZEZXOVU1ZWxuYkFFS0NBKzR3azF6TDBM?=
 =?utf-8?B?T0VDOE92TnRWQTgxY3FMY0VJVGtlL2tTU1J2UXRZdlVRYlpzTlU5aDdoK29M?=
 =?utf-8?B?NU1YaXo1RmdrNDM5NFdDNE5vZmRzTzhHU2ZVbHE4OUF5UUh6eUNvWGZGQTZC?=
 =?utf-8?B?QU9CdTc0cFhUaTlHQ1UvMHlKRW5aaDk2dW13eFYvc1lqNEdsSmRDanhVZTM4?=
 =?utf-8?B?enV5RDdNOXBQcWU1QWZiWDllWmNkUmM4dVREcEpCZHo2VlVkdGRuSEFlNjhS?=
 =?utf-8?B?VHJTbkVPTmprdmwzb0NYcWxIY3N1Wkp0dVZ1ZVE4S1NBYjF4MExNKyt3N2lM?=
 =?utf-8?B?NC9UUVF6WnhoMnRScUw3QlJMNnBxbWhyKzlhUWtYckU5L3k0bVpaVk1lQjdq?=
 =?utf-8?B?dEVzYk5VNWYwc3cwM081OEFDSlhEaTVvKzNLZFUwRG8zbUxGS2s5V1pJeVdO?=
 =?utf-8?B?bkxCWmg2dHlnNlJUQmxBdWRKQzNxdHlUMXNCM1MybHBrZWRRR1lBU2lWR0lF?=
 =?utf-8?B?VDdhZ2xEVHVIZ2g3cWxKaVNYNEY4NDROUVVqbXVOMk1DZVp0R2licDFuNEJ2?=
 =?utf-8?Q?QEs1cHtcGepcPP18V1J9BlSYICIo+bvHdj30o=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dc60755-90cc-4e46-f678-08d95c2cd61e
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 18:29:49.2575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2yVjBuhdXM+wT3X5cMQHHynqW3YLzO2r10YOjHfkxlb00Um4XOXBt8INfpt+m6DDyoDizJAf9tdcDhi3rnr+TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10072 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100120
X-Proofpoint-ORIG-GUID: xoN5NcoftQGs1wnF6BXjjVaUDg-FRWiG
X-Proofpoint-GUID: xoN5NcoftQGs1wnF6BXjjVaUDg-FRWiG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/10/21 11:02 AM, Eric Dumazet wrote:
> On Tue, Aug 10, 2021 at 7:50 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>
>> On 8/10/21 2:19 AM, Eric Dumazet wrote:
>>> On 8/9/21 10:31 PM, Shoaib Rao wrote:
>>>> On 8/9/21 1:09 PM, Eric Dumazet wrote:
>>>>> I am guessing that even your test would trigger the warning,
>>>>> if you make sure to include CONFIG_DEBUG_ATOMIC_SLEEP=y in your kernel build.
>>>> Eric,
>>>>
>>>> Thanks for the pointer, have you ever over looked at something when coding?
>>>>
>>> I _think_ I was trying to help, not shaming you in any way.
>> How did the previous email help? I did not get any reply when I asked
>> what could be the cause.
> Which previous email ? Are you expecting immediate answers to your emails ?
> I am not working for Oracle.
>
>>> My question about spinlock/mutex was not sarcastic, you authored
>>> 6 official linux patches, there is no evidence for linux kernel expertise.
>> That is no measure of someones understanding. There are other OS's as
>> well. I have worked on Solaris and other *unix* OS's for over 20+ years.
>> This was an oversight on my part and I apologize, but instead of
>> questioning my expertise it would have been helpful to say what might
>> have caused it.
>
> I sent two emails with _useful_ _information_.
>
> If you felt you were attacked, I suggest you take a deep breath,
> and read my emails without trying to change their intention and meaning.
>
> If you think my emails were not useful, just ignore them, this is fine by me.

Hi Eric,

I went back and looked at the two emails. You are correct.

> Are you aware of the difference between a mutex and a spinlock ?
>
> When copying data from/to user, you can not hold a spinlock.
The second line is useful but the first one was not necessary.

Shoaib

