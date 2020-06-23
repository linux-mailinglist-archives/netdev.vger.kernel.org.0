Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B73820556E
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbgFWPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:04:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732862AbgFWPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:04:12 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NEsVpe026266;
        Tue, 23 Jun 2020 08:04:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=igANHcKPYAXOsEkVIIT94l+9ZPy2Qt342HUA9jHglK0=;
 b=AV6Md3TfzIr4izGtsCgpO8O5l9jOIoxSqW1W15gzfy/tdWCMegzXqDRmyNJlMkdc0aVq
 O/udMPxDfHLA3HJ3sw7iOdj9f2XmTcysV0igMpH7R0i5LKmqY6rX7snlRxhbcewW1iVt
 tSR/s+lq9M+X4BkHhCu7rxzyShHrQoRj1aI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31uk208awm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 23 Jun 2020 08:03:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 08:03:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSJteSTcDpwweJDTZRipDqn0SxUZVPy7p31ojuCnqwp2ftCXX/qodt/NoJsSyDc4Ce8uOFiyUXV0rbK5ba5lz/X+KhsYYK1lBMremtz7wrgCX6h6aiYZavDa4vf+Ca5B7QbEMvWk1vY3X4+9tXtIAbBB15VhyO/6U/tUwIMkJOJpKOB1/trvm4q53qVWbjrPGI9DJUXvOAjfz94A3nisn961VlWpFQbrD+tnqXFF6fTCaQ0Mh1zZghlWpxIDsu4Q3FNbVrRB4R1F0oZnZqbuZZgBwNX8mqArbNaS7EcCfKZnn6/mJjhdJQHVzzKhkqgXqvBl7EyBzg4NxWE4uduMAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igANHcKPYAXOsEkVIIT94l+9ZPy2Qt342HUA9jHglK0=;
 b=UVNV8oLRD7vXOUGW0STr+5V/VPdVLaetfhXC61nh9ZhI751HruJC+ezJMAtv3+zcEyPlkdautIzhJwIx3GaIqbRVH1pDsA8uY4+plxShPZIDvRGrb6ihc3rOhADnqwmxZEYsnZfb/8HDk4cEwntKw/wXdzo6IHNTbTgdp0HIODghGcmrkXD+dCrDTGghII25yJsiilFpAnlHLCoyGq6GRwuVE7zV9HnMgZ5vkUi428vzzB9OUTKEwV3xDUywpqO0pBpqESyBLYSSXth8Iwc27i/DRZThkXb7XPR99AxU/N57MwnBPrSKKYDaNGC+/RVow9OXWw391mHwRTDgt8y8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igANHcKPYAXOsEkVIIT94l+9ZPy2Qt342HUA9jHglK0=;
 b=fwG97mbNLKugk3dCeMlF74ShDc1iAv/phaOxcgoNCdoEoanuXGWNzpbwkYM0nomC8/VlF7Dvpi7pJZtp8Sm1/I6ufZhusSABZlf1E5b7j5aNUj4VMEipFCmvk8pE/covBKsiMEfH5fatEUFuHWraCrFBdDBXAwUvdQ40+Hx4qj4=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2584.namprd15.prod.outlook.com (2603:10b6:a03:150::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 15:03:54 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 15:03:54 +0000
Subject: Re: [PATCH bpf-next v3 14/15] tools/bpf: add udp4/udp6 bpf iterator
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
 <20200623003642.3075027-1-yhs@fb.com>
 <CAEf4BzZB+dBR8be3FYjHNqn+artvu_Ca21uLuZeVrhDvL6FDQA@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <ecd218f2-71b2-3109-9616-2ce0b1aa9a0d@fb.com>
Date:   Tue, 23 Jun 2020 08:03:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <CAEf4BzZB+dBR8be3FYjHNqn+artvu_Ca21uLuZeVrhDvL6FDQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0066.namprd02.prod.outlook.com
 (2603:10b6:a03:54::43) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21d6::1377] (2620:10d:c090:400::5:7789) by BYAPR02CA0066.namprd02.prod.outlook.com (2603:10b6:a03:54::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Tue, 23 Jun 2020 15:03:53 +0000
X-Originating-IP: [2620:10d:c090:400::5:7789]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbfd5d81-acb1-4d85-326c-08d81786a529
X-MS-TrafficTypeDiagnostic: BYAPR15MB2584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB258421926FE44A4652A79DB7D3940@BYAPR15MB2584.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KnT4aJr0MoRXf/yNUfCzbej0yP+5NFmIgYQJ9YlHjdU/dFALT5z4qruVqmWe2N81FBGeswJLOYkEtdzjzQdrrXhWFWoflTrWfE0PSLkDPMwJnSdQp1BO3CtI1Dgi6Wf3Fvqorq1uj9u4UemotIcH1T3PiVa1HpMlLUE+i8dpiSBPPeAP/440ZWmfSsU0gK7WDs4MATzVHsEO24hY1tMsSFTEWnU3fkM5D5MyG5FgyP6xNEyD3rC6NiaSiilzRe6PsJIGKssrjvpZvfWvrl9nNGIohHqodLd+jIlpZwbPG7mm877A53C/PcmPfKjehYKUEsEf4eUWLtqOQUvHTtXKqYQNMQ3zrxQgf4d3vO1+7qbH1sfFrf13yPAPmMxdz2l9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(86362001)(2616005)(5660300002)(66946007)(66476007)(66556008)(316002)(31696002)(6486002)(6916009)(4326008)(31686004)(478600001)(54906003)(8676002)(16526019)(2906002)(186003)(53546011)(8936002)(36756003)(52116002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lCcvbuD0Jz2AKCTzodkkEsdMBvPxD+H5fZO+UoIAIYxwz7v3HZKwut+2zwh5JDO2LBCae0WlZh/0LwP9KmVV/SpLyJgkOTGeJbxfllnzMS1OnTXAFX69HBP51HTapQjrBHVnrjaj4XPw/ckhBlX/8lfcrAtedD6f7N8ZtfR9fJ9TsI9iS2SHLhx94QvEN2Z8hOB3MDP5qAuLBynT8OoKih3fxXV+IOwDSb1Ld1Il9zEm7FM4+2CjHIcCfIOvBbqhf9yiGIAKsqMO65epiZlw1HnzXOtod0ShXLKSN5b49vFH4H4pvTiHHwW85ocaEyfJlrGpsk8thkJQKHtpOeJTpGS54wENisd8g/kUbaaORVf0EWvVb2lYPLrwYDNh+XxTtFaQlNOxE2R9Zzou2PhQ3i+F02fvrtyIzT0e62KwU0kVXMl+apxR9/OyGeaXsIhuLm+oy4IRDYSZNNayF10VNAk+DpNmHoKGsjZTG5foRmP6S/aK9ipzeRZqYE1j1CqKH7/l8sTbL+cIAkR99tEvEA==
X-MS-Exchange-CrossTenant-Network-Message-Id: fbfd5d81-acb1-4d85-326c-08d81786a529
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 15:03:53.8571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnBovNHIWOwbQ9WRICK5OOOIN7ygXaegcRW/m7ghbCxBp+skYbVNmf9KcK2NFMLS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2584
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_07:2020-06-23,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 mlxlogscore=813 spamscore=0
 impostorscore=0 clxscore=1015 priorityscore=1501 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006120000 definitions=main-2006230117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/22/20 11:57 PM, Andrii Nakryiko wrote:
> On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>>
>> On my VM, I got identical results between /proc/net/udp[6] and
>> the udp{4,6} bpf iterator.
>>
>> For udp6:
>>    $ cat /sys/fs/bpf/p1
>>      sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops
>>     1405: 000080FE00000000FF7CC4D0D9EFE4FE:0222 00000000000000000000000000000000:0000 07 00000000:00000000 00:00000000 00000000   193        0 19183 2 0000000029eab111 0
>>    $ cat /proc/net/udp6
>>      sl  local_address                         remote_address                        st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops
>>     1405: 000080FE00000000FF7CC4D0D9EFE4FE:0222 00000000000000000000000000000000:0000 07 00000000:00000000 00:00000000 00000000   193        0 19183 2 0000000029eab111 0
>>
>> For udp4:
>>    $ cat /sys/fs/bpf/p4
>>      sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops
>>     2007: 00000000:1F90 00000000:0000 07 00000000:00000000 00:00000000 00000000     0        0 72540 2 000000004ede477a 0
>>    $ cat /proc/net/udp
>>      sl  local_address rem_address   st tx_queue rx_queue tr tm->when retrnsmt   uid  timeout inode ref pointer drops
>>     2007: 00000000:1F90 00000000:0000 07 00000000:00000000 00:00000000 00000000     0        0 72540 2 000000004ede477a 0
>> ---
> 
> patch subject prefix is misleading: tools/bpf -> selftests/bpf?

Sure I can do this.

> 
> Otherwise:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
>>   tools/testing/selftests/bpf/progs/bpf_iter.h  | 16 ++++
>>   .../selftests/bpf/progs/bpf_iter_udp4.c       | 71 +++++++++++++++++
>>   .../selftests/bpf/progs/bpf_iter_udp6.c       | 79 +++++++++++++++++++
>>   3 files changed, 166 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c
>>
> 
> [...]
> 
