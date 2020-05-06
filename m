Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25281C7DBD
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEFXID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:08:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:4324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725869AbgEFXIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 19:08:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 046N3InP006630;
        Wed, 6 May 2020 16:07:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kv8m2m7cHm4C32TwXGW4b3dy8Q0nJh9rBKEuUx7BviM=;
 b=CWDUjUxEXOHwzpmyBC/JmJUDSbTuLTXhZy9g9sr1sbjbfFNSNWjt03UqF/PUGRxmOid2
 z/+BVdwalSuwPjdyBYQWdzzCdU6jrjjjsHNY6jx19ut2k/xB8l0vyhKVRaoWcI60DlFC
 c56jNCO3gQ8ZMLMJc/+A79YLaIn6c8HT3As= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30srw049je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 May 2020 16:07:49 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 16:07:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDIaE0uMFBUwvUodvgfCgaornEHGbdFJc/boqW95aY3BvcCjsNMJ/Ffqkkc4rJHbdjXMV7ftoc3pNVxVUkr57lltRwII4ksKQkfCq1xGFutdXrLhSr5H1KD7ueXOTujN+QxmXa1qCHHde3GfqXhLk97xjvvDXXbcXTZkRJVwBZpSnHhSmlmKSq7oQQq9js20ZRJznPymQ4yTc9ADEQNuzFjR4yuNqrlI4WsIRfHA7scoVr6RoBZ4M54Jbh2pv842o/l5uSCfgXCTS6Hj56O5dXbSmvufojp9F8lJTU1HjrCL/AJTwnvTECgfMnkTLiy5r8v2G6es4SmxhTHMRGUTxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv8m2m7cHm4C32TwXGW4b3dy8Q0nJh9rBKEuUx7BviM=;
 b=C1JxjZdE1ExX7e2hZHPXCadgqsJwVqZUB8H+lu/hRxl+1iIRTQ8OlxCeRJ/PZVMhcYrv8oZLy+sjP5Vzf1G8iK/5kxUnuJMuEXHFhLkyK0XAQAjJp8D+c3J3XFvLhjpBaT0lwZJtS/b/UV9esdhz+Fsjy5A0iW0KWHnc54QLA2rPc+c22+sbiGpENRwe/mqMLh0kH8M+nlu9Ix5WP1jpFYOprwxDKejV9Kx8/Q40wZRZlXJkmHHs1voabSuPJtk586pIFTEAyvtYTR0dAV2xLbcQOmB/F3HDhfr6UMwq4ChcxdDmE3DU3eemOGKEwxnb+RmgtA8RzKtp1fjea2uILA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kv8m2m7cHm4C32TwXGW4b3dy8Q0nJh9rBKEuUx7BviM=;
 b=DtDVQfgBrMbcO9L+gDQXxW/ZXhMBpYj079Q4QcHJdr0Lrd2xp+gVZgpnk4PNuT6Du35YalciFwso1J4u91p4omTQCt3FdXHCwmoGsbmWDxoRYycx6bn7tKZFchurBFyGQ50AxPBkEdp9/WWAoVijnwbXrsj6dK2YHzyE3ZMKP4s=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2581.namprd15.prod.outlook.com (2603:10b6:a03:15a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 6 May
 2020 23:07:33 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.030; Wed, 6 May 2020
 23:07:33 +0000
Subject: Re: [PATCH bpf-next v2 18/20] tools/bpf: selftests: add iterator
 programs for ipv6_route and netlink
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20200504062547.2047304-1-yhs@fb.com>
 <20200504062608.2049044-1-yhs@fb.com>
 <CAEf4BzaGsk2hgLHvU=9b2gv7V0y788MNw0hwkSQxE4kg4zSe=w@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <5bddef07-6cc0-e4d5-9394-f8691860015a@fb.com>
Date:   Wed, 6 May 2020 16:07:30 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <CAEf4BzaGsk2hgLHvU=9b2gv7V0y788MNw0hwkSQxE4kg4zSe=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:66a9) by BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29 via Frontend Transport; Wed, 6 May 2020 23:07:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:66a9]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4aed524-2003-4389-8983-08d7f212424b
X-MS-TrafficTypeDiagnostic: BYAPR15MB2581:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2581DF7372376BF52E4BDA99D3A40@BYAPR15MB2581.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 03950F25EC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZF/c3ReTeNgLkj7nk4GwOx7Rkh3oJaD/aTS/WrF0UzJtB5Yb1LtCeom1YR+zT4WRVNjERK/4fGM4wLKZpjlaKSk9BtG2tfMDCJy/rNGrAffDHwP2os7mRdV29KamFtzutOnLMDqs3PkcoxC3HodbWhYkAMj5IGymQh3+67UdSV9HQpLW+KNEeMZsv+auVTWDRQyeCr9J52phYwOz7kjbjPtBtkBG0e3hUgnAqjqawpIdF5NoTSS4ZTt8gRsE/D1gFXUv3IYnLZzspy50LtAU7uKm9FBaLLsugJhrIj2aMPGlpCuFBwZrhKjPE48Re9KDsPymcHrfqfLcAYTgX1QaB9s9NF/YejUZyeJrb146NU31V1npC+VQLkh8WAvGotzUmrpjnbvdktPe2I2pQue+lHuj2Nodv32hLlRINNdh3QW3GS7zHM4MNfJ8m/tKsnPbGQrLWuoYZanhhcBBrZYbKECx1qmpu5XzPPr7Td0S3loNoTvUZIf6VCi1M+2JOY78S/eF2b8wdkzW8kuvg9whgXiMaOsGMUlGj9pEQ55uUZnIpdXEkNWNwfO3nH7UYUx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(33430700001)(52116002)(2906002)(5660300002)(6512007)(16526019)(186003)(31686004)(36756003)(316002)(31696002)(86362001)(2616005)(66476007)(66556008)(66946007)(33440700001)(478600001)(54906003)(6916009)(8936002)(53546011)(6486002)(6506007)(4326008)(8676002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cSUnHwtQdiVKT7pFc95uAobS2sBQW8VH8HNePajFJPOY/ev15IGtM95fTP27B72C355TggmKlqRtIQ3qqA1592zXnFk1bDe5QBLcszK/kMUsOYuSO3DGuJYG1SRTnI809HhBMepm3iffo0YERUwDVP6ljxYDlB43iGd3DTK4FJpuaCwrb7yAs9yP0rrb8s92txyOuzmvWa/kHQXB5V2v0UlZi8IQMLyCa1sIFrZGDpOzcpu0UjK7SEREw2qUTZfpdkYPQ0atdxEYawt55irpuAswylrS7y7lEWTYgIGILUebdMd5N+VGrY5nXfTjygRvA6WW4bHaUgcAJQ8BSlOEgmB8Ix60ROvSs1Tpp+gwLMdufrpw04pTLnLE7Peu4pfShkVGnMTiJbZUrvVyoQS9DXkyvD0oeDQP2lVTt3e0lpUG+S3XD+4R5rHGAdYptUmaPVTlZ5vzELuDlts1R5mXs0NCxIPIkqEDGfTFIepoyWVwb7JwkTpqxluIqd+H30QXAbTslDJSM42X4GNAUxKXWw7B7RGhdj0S/sfajGhZ6r5U3BdDXkDjXDZoZFsJovw2B/hiUXbbCy+T40C4NIoH/x5AKSccmVXeC+Sas+IUOyjvHiLhmC0TtrSI8vYcyyRPMwOrZUBtMiJXSFvC2iflGmMY6OwwY9UNyVAtWLP8YFI7//RMxJ3Xg0OiYg5k9DrDJPjitC3mrdZuCvtuJWe4yCEWOa2Y/KBZCWAMk5g3u1MROt/by3L0/KuGAtnJUTQrJEicWqMO/GbWFxELK40ll9NNs7j9Hdj2JUqOK5L8VfH39cOnXlAXGcEO7HXcz/ohcS4DI1bet8P4h3qqbFlAyA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f4aed524-2003-4389-8983-08d7f212424b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2020 23:07:33.4462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLHcIjjCswRGD9DHwg4x0OcUIO403zZmIhbPh6fBrVTVLZVwtzc4vmjzvoAs1TWq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-06_09:2020-05-05,2020-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005060185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 11:04 PM, Andrii Nakryiko wrote:
> On Sun, May 3, 2020 at 11:30 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> Two bpf programs are added in this patch for netlink and ipv6_route
>> target. On my VM, I am able to achieve identical
>> results compared to /proc/net/netlink and /proc/net/ipv6_route.
>>
>>    $ cat /proc/net/netlink
>>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>>    ....
>>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
>>    $ cat /sys/fs/bpf/my_netlink
>>    sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>>    000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>>    00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>>    00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>>    000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>>    ....
>>    00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>>    000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>>    00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>>    000000008398fb08 16  0          00000000 0        0        0     2        0        27
>>
>>    $ cat /proc/net/ipv6_route
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    $ cat /sys/fs/bpf/my_ipv6_route
>>    fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>    00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>>    fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>>    ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>>    00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
> 
> Just realized, this is only BPF programs, right? It would be good to
> have at least minimal user-space program that would verify and load
> it. Otherwise we'll be just testing compilation and it might "bit rot"
> a bit...

Totally agree. My latest selftest in test_progs actually tested loading, 
anon iter creating and reading(). It did not verify contents though.

> 
>>   .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 63 ++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_netlink.c    | 74 +++++++++++++++++++
>>   2 files changed, 137 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>>
> 
> [...]
> 
