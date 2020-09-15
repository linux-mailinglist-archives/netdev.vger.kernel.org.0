Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D651C26AEC4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 22:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgIOUj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 16:39:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45702 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728047AbgIOUiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 16:38:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FKDrnL007408;
        Tue, 15 Sep 2020 13:15:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=CTPYSW4b21jovnf9HxVLM+5hmjxoccT2xjBJAqAWoQc=;
 b=d9BWTapJtra0+F3UFNvQmqFIzDWyJJQrTBwkSjXZbfRWIUsU8P31pzDujmH9B7fHxKUQ
 +pI7Jh98uOOmoYVpEbicCzknWB/eNKHk+qW0DlCmgqNiJyqPvAnyVOo5eXxEIyhkW9Dh
 5rnC8oAYzZh8D26oNetnxCSvwgN5BsFk1Wc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33gv2phq78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 15 Sep 2020 13:15:01 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 13:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxHgUK6OiW6HT4yUKn9antsjGfS4WmuA4pBvDRE1xhYefCWZoM35+gBzYYLJIoR6HEPCsMZnXxyiAVuqjEI7p3n9+qtAg0w3d7j1kkaxJ3zjn+OXPxwaAJHGvdq1B3RKjiNJvKE8E8mjDVk+qhL6Jm9RN1QbfF3ysLIUv1Fv2FkSKhx0MGWxHwZITnhsKjFHk/TlIJqN1dtQS+/E5oEIacB3s0fwZCEowMBrEx4j9rIVaYjSr720kZyS33GOHHInUsk+Z6I8UCZWEgKDbRHSPyyAS8vfxqq4Al0U1WyMAKDTCWRQ78pZDz1uPW0AvMo5hCKCdLi/scFSFginb5/8VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTPYSW4b21jovnf9HxVLM+5hmjxoccT2xjBJAqAWoQc=;
 b=LS92sVU4tBFJVaNv83E+lJfPM2tvIrqUqeaMYTrs5AHd5FORnOWj97GKQIABKhSDc01ZbTTHq0L4dCF8ZIZTO4WnN2Z+ErNSYjQ8RczukkehE11Elq3OJURuHF1DjLFvSFE8l2xWf+5zHRjUD3qsxf2wIMANnNBiro7Wxte/9bWhZA9jRvx1Ov4J46Cneg37q6NT/PlvaUrRF1QlqwCY9L53HlXDTZvx4yAa+NnLgkBCZTFQoTCyZ7zN6MOI/aNO3dnp/5umGFPhBuHtgACuHrm/alQ6yvZvLAHrKRCe6RSd2+dflAexORRj222NVyzEpjc3I0iqryyqjHhJyfxSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTPYSW4b21jovnf9HxVLM+5hmjxoccT2xjBJAqAWoQc=;
 b=dv4mzcy6WXfF7KheYk8xbmPlHOWq6iQNB1ezydUuR2n15cF8ILS26XUu5medISg1aGgQ4qqNpT8KU/56tHpRwtOadwXUjKz5nsEJBUpurHT3modEU/ehlSq8fcsDzX0/6TmSfg32vRUyYQosv23N/xubW9HnOcneh40wczY71S0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2822.namprd15.prod.outlook.com (2603:10b6:a03:15b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 20:14:59 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3391.011; Tue, 15 Sep 2020
 20:14:59 +0000
Subject: Re: [PATCH bpf] bpf: bpf_skc_to_* casting helpers require a NULL
 check on sk
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
References: <20200915182959.241101-1-kafai@fb.com>
 <5c3d74e4-a743-38c5-64ed-1cb8a6ed2a6c@fb.com>
 <20200915200418.pjtenydbspik2kzb@kafai-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <18ae853a-9456-b017-f088-4aff056efafc@fb.com>
Date:   Tue, 15 Sep 2020 13:14:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
In-Reply-To: <20200915200418.pjtenydbspik2kzb@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR18CA0046.namprd18.prod.outlook.com
 (2603:10b6:104:2::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::1005] (2620:10d:c090:400::5:15d8) by CO2PR18CA0046.namprd18.prod.outlook.com (2603:10b6:104:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Tue, 15 Sep 2020 20:14:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:15d8]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b10f248-3252-44ff-fbee-08d859b40516
X-MS-TrafficTypeDiagnostic: BYAPR15MB2822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2822627BDD3616639CDA344AD3200@BYAPR15MB2822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NRzvDjwC7/t30m+JizpeOygASNOb6ZCxnwpEVW7NQ1YMD2erm5hDa2t4Z1JySQSTM4XMhg7brm7xbb0BZKNWFKI9gMZiamL9ZD/XquKSdvmbW5D2BPjlx7jP3r014HSeXXoV6mXx7vc5rzJOqNr7p5mHoUPmeWKWQLYTHq9Fa0AvA5ieS/pt5T+fcCLGG0Hvls9Qoq2gkeKFogr7rnEqWPBjZrulzr+KqPpqNP7yBXT+qoj3D+nRcRx0M8mZserLK1ygL2GXQFcw9+Rc+QzhnNBZWmF4Zk774CJKR+BlebfXV8sHLv8UL4JFFcqpNQmPZDxZPszV8U/TT980RheOgq23BXFabb3Xr6nU0vTXNMuQdcWBHRLPEKfeZGAM3t1d
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(366004)(136003)(8676002)(316002)(36756003)(6862004)(2906002)(4326008)(8936002)(6636002)(2616005)(5660300002)(16526019)(66556008)(66476007)(186003)(66946007)(52116002)(6486002)(86362001)(478600001)(31696002)(31686004)(53546011)(54906003)(83380400001)(37006003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: g/PtuEwxDMiom8GvLy2V8I8oHWhGIyula3iSnNJbACPR8sBulY5GKw5lo9Tb8V7z1cZt33r5f50m5kZVfI799oDTVjdqwElwO6uDDcCq1jmgdXt9Kqvr8E1UDime7a5h4xJysIvpWsClPuPbea7A4pTkoUfu3Tv2whvxwxLZS7fbaFOQTB5wbKw+P2unTmX3CV2ZewXhnHBEhe2+AtVOOXWiMw2ZOZqHJAGHk/m1QG8DSI1E/m/7ujQ2vDiejf+jvXbaOOYMNJrulvyMO/8olaOHhEKkX948K5mm+i/6F7dGmhECS+kol00H5egb4Gh/OpeONiYDnZCozY2oYJBSTrF2pgQH/bqaNBCoa0FoMJ3/de6HrKLOemSQUpJGHGbXdIgCB6uqG6KmugWTt3vTEpGpD1r5J0O28g3C7R4lURKZV+ceQ3/7b6LdCfaNboiqdL9un7pD2Uoza9qMeMG12AA6wjvQKLlF1aFWRfDGcmIRzPWpHY+TVjVD44e5KGvN9yBcR02J1QrmKX0k2JGMJ/5EiPiFd7g5koi4tESekttqTn8TcUGCLqUxGrOeH46thl1GAdNtJAIX2RhdBZZEvq2Fil5BKw9k/CzSe85K7wffUW+gznJUO8jeHeaxibit2SQvnTXr9HfSc2Jv3yKTrAWCqzin4AMuoG3DZnKzv/g=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b10f248-3252-44ff-fbee-08d859b40516
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 20:14:58.8552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lR5I+Zm6ILkcPwHv/Rl8HiZKPMDq/lp9sq7GgG5Vlg/6NoxOAKZWHBp6PmG8plFz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2822
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_13:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=817 lowpriorityscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150158
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/15/20 1:04 PM, Martin KaFai Lau wrote:
> On Tue, Sep 15, 2020 at 11:58:01AM -0700, Yonghong Song wrote:
>>
>>
>> On 9/15/20 11:29 AM, Martin KaFai Lau wrote:
>>> The bpf_skc_to_* type casting helpers are available to
>>> BPF_PROG_TYPE_TRACING.  The traced PTR_TO_BTF_ID may be NULL.
>>> For example, the skb->sk may be NULL.  Thus, these casting helpers
>>> need to check "!sk" also and this patch fixes them.
>>>
>>> Fixes: 0d4fad3e57df ("bpf: Add bpf_skc_to_udp6_sock() helper")
>>> Fixes: 478cfbdf5f13 ("bpf: Add bpf_skc_to_{tcp, tcp_timewait, tcp_request}_sock() helpers")
>>> Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>
>> Thanks for the fix!
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
> Thanks for the review.  A follow up question.
> Is PTR_TO_BTF_ID_OR_NULL still needed?

I would still like to preserve PTR_TO_BTF_ID_OR_NULL vs. PTR_TO_BTF_ID
difference for ctx arguments. PTR_TO_BTF_ID_OR_NULL means a NULL check
is required and PTR_TO_BTF_ID means NULL check is not required.

