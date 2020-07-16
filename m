Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6328A222A28
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbgGPRme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 13:42:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58282 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728182AbgGPRmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 13:42:32 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06GHeNEs008164;
        Thu, 16 Jul 2020 10:42:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=yJ+wXwraS39AJFosE2QJnSKQam4WTxpXlQSxaUyV6Qo=;
 b=Tu3UHfDDkNlSnXH0fVU2qy68IXOP+EuspBQfhPW2w0AJ9gFLzUO4BpBriq/lBNB+QUr7
 GzO8EUz3D9nL5gRiyoLVB6tKaGqECxv+n1FaBr6zPuxkp0TdZ1Ya9lqrWzaIl7IsfcmH
 pZzuKtD+yBsKYABxqbCcu73RH5JLxHyfwGE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32au0ag5sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 16 Jul 2020 10:42:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 16 Jul 2020 10:42:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQEp4SXBue66jzGXhjnbIcTULONm8AjxaSJe5jbNOvvWhPXvOdL88c//suaftsHpAryEyFmOz6GDJVmWq5Q+9ERVTabR19VLp/kBVbir8AnJ8GY3PVxFXfdKwfr80F2XVlny+IhAB9QVuzUAcqn1Wq7FpAYjqVNPmrpjxn4mXyDLM5qB3NmeVdSN5lV+oLB/DbqmeLxzzbrGhPJsuEg0anXVjGFZmdA1kG5Q9duwbSRHqEkPebCWXQOBU2A/A+vnQPM0Y4mm4ibI6ho/80HtMtbQcaiHdi1gP87TcB0FqWEblV2v5bgWXa2cPjpdHmFp4X3bS0DqBDPW5vBB8qTSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ+wXwraS39AJFosE2QJnSKQam4WTxpXlQSxaUyV6Qo=;
 b=ZvN9RSE9auHOwcqSUyTNy9jzH5cf89a1iYQ1hIWLerpXQrvpeFzjL+mDrdrEZY6XY+Ibuaks05WEBeLO+WahP4jfGEAmL0JALTKpqhn9UgiG0hD8be8kV+WG9GvlgmjghqZbN2KtiavIhw8KjuIzwOuIqXYI1L6gZJDjoJXHtS0Z12Y/6nmsw5MHfQr/I3gvCWwgW6nh+uhgVDSCKM1XDE6mWAaBLjz9rrsvRinJlCt+apPBP3Kbg0he9crrnkmxQkUBclpJCYpmctADcNj/+2HgsvHPBEJWeC83T8tWsy2Y4RjIHDwOtdrEZyD1ncdO2wygB1PVNfRRVHbCfGu4NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yJ+wXwraS39AJFosE2QJnSKQam4WTxpXlQSxaUyV6Qo=;
 b=Bi9gb5NgsHEHnix7UlzV0WKKLh+B8nQSZ/VwngUo9gtJfik3KI0z8fmKBzwnMGmH35JYewauOtbJs2IMrCL3tAOPuWSukiMGRCWz4soPdsOmq0t6qWB21O55Yn4uW8ugWSrpJwQ5lRXMWX5i6a6gqTzviSt8IvdxbmfCNlkizjI=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3509.namprd15.prod.outlook.com (2603:10b6:a03:108::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Thu, 16 Jul
 2020 17:42:15 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 17:42:15 +0000
Subject: Re: [PATCH bpf-next 09/13] tools/bpftool: add bpftool support for bpf
 map element iterator
To:     Quentin Monnet <quentin@isovalent.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
 <20200713161749.3077526-1-yhs@fb.com>
 <9f865c02-291c-8622-b601-f4613356a469@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c70ebb0a-538c-a84f-f606-1d08af426fde@fb.com>
Date:   Thu, 16 Jul 2020 10:42:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <9f865c02-291c-8622-b601-f4613356a469@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::32) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::1176] (2620:10d:c090:400::5:4e0d) by BYAPR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:c0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.9 via Frontend Transport; Thu, 16 Jul 2020 17:42:15 +0000
X-Originating-IP: [2620:10d:c090:400::5:4e0d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cd4abf6-04ea-4bce-99d2-08d829af9429
X-MS-TrafficTypeDiagnostic: BYAPR15MB3509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB350927AF05F46E976A041503D37F0@BYAPR15MB3509.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F1HxJvIgGPx2CPpsHAEF8pluzy3dY4UCPO8yQfDpdM8Hcv3zsiJ80rk1loFGKZ8sWO2T2VEebMOjkUMfqO4/KDc7Yt0Da/23cLQjRaLjJtPOqFMYOkORVHMX9Vcj82Nva1OFVEnO56BOQqGuoP4O004HibBmqnhI++i/ZPIArF9h+pA+4KG3HUXF/N/DFb1Foi1l2qZA9JvIoxLdPOHAtcFMsOguAS2l8X4COfu7Vk1/w0UmvxUh37LjJM8HQ2cilCB5A504aWJ6VzSlWwWSVFPurRW5pINnr4rqF6Wr7Itj5ZEV6D9Acc7k+4xxdTFc3n/39MMGhs7Z4EQRbm2IEXQ04/hvng7wzX4fQm5WQibGEMyjUcNfvpP/n7JPpPI0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(366004)(39860400002)(136003)(346002)(4326008)(2906002)(66556008)(66476007)(31686004)(2616005)(66946007)(186003)(316002)(54906003)(53546011)(16526019)(6486002)(52116002)(5660300002)(8676002)(31696002)(8936002)(478600001)(83380400001)(36756003)(86362001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yxHWWjIErO26kspPSFtmzT7mNzGEgaEbwvMiyZQP0e6aBb27KHpzTWqKRg093SDcco0fdjjYsA05z9qNy1VuOiZ+gzPngE/o3Mqew3vLH1BWhU0r+W9gJNUt95LDB0XlY4uaGpfTAKOyDPMgQZvfr5yMivY5EWILchmtQqEkOwZXh8044Ldcn9XF/KsYaLViLtTbDans2KNQj5AI1Zhheh2+CY40N0/GxZdcgSEWVrW6qlsUmwyeoYYpPIWW8H5ZaN7wOp9Gh3MNYkcZnavGP1GYcpTJ3fjo3GOQQNKp45ToJVwQ4UNTZcKPAnMtm9LbhVteCIM5OXkD9N4GD8jaSajEFDpbCfAUelfleL2YcVNtyG19XgPIKCHvw60JAnTbMg1LTXDCd/rvD9Bc5ntHD3vIL+yNvp2kKRwqc+TZwLeszrLk3C6geLbQJIJxtRM72GoXXqKSlPahaDfn5vzy99VibiaFReRfLVGxDXg2tl6GM65CPb6EB6vI/FQ9iAphZzqZ7pKCbNIG5QWcVgXdkg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd4abf6-04ea-4bce-99d2-08d829af9429
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 17:42:15.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DcRk22qFzkT0QFKljxtg4k3LOrWoKKFOkU3PTONQHgugaW7eksydQVcUW4+EUCKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3509
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-16_07:2020-07-16,2020-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 phishscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/20 9:39 AM, Quentin Monnet wrote:
> 2020-07-13 09:17 UTC-0700 ~ Yonghong Song <yhs@fb.com>
>> The optional parameter "map MAP" can be added to "bpftool iter"
>> command to create a bpf iterator for map elements. For example,
>>    bpftool iter pin ./prog.o /sys/fs/bpf/p1 map id 333
>>
>> For map element bpf iterator "map MAP" parameter is required.
>> Otherwise, bpf link creation will return an error.
>>
>> Signed-off-by: Yonghong Song <yhs@fb.com>
>> ---
>>   .../bpftool/Documentation/bpftool-iter.rst    | 16 ++++++++--
>>   tools/bpf/bpftool/iter.c                      | 32 ++++++++++++++++---
>>   2 files changed, 42 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
>> index 8dce698eab79..53ee4fb188b4 100644
>> --- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
>> +++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
>> @@ -17,14 +17,15 @@ SYNOPSIS
>>   ITER COMMANDS
>>   ===================
>>   
>> -|	**bpftool** **iter pin** *OBJ* *PATH*
>> +|	**bpftool** **iter pin** *OBJ* *PATH* [**map** *MAP*]
>>   |	**bpftool** **iter help**
>>   |
>>   |	*OBJ* := /a/file/of/bpf_iter_target.o
>> +|       *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
> 
> Please don't change the indentation style (other lines have a tab).

Will fix.

> 
>>   
>>   DESCRIPTION
>>   ===========
>> -	**bpftool iter pin** *OBJ* *PATH*
>> +	**bpftool iter pin** *OBJ* *PATH* [**map** *MAP*]
>>   		  A bpf iterator combines a kernel iterating of
>>   		  particular kernel data (e.g., tasks, bpf_maps, etc.)
>>   		  and a bpf program called for each kernel data object
>> @@ -37,6 +38,10 @@ DESCRIPTION
>>   		  character ('.'), which is reserved for future extensions
>>   		  of *bpffs*.
>>   
>> +                  Map element bpf iterator requires an additional parameter
>> +                  *MAP* so bpf program can iterate over map elements for
>> +                  that map.
>> +
> 
> Same note on indentation.
> 
> Could you please also explain in a few words what the "Map element bpf
> iterator" is? Reusing part of your cover letter (see below) could do,
> it's just so that users not familiar with the concept can get an idea of
> what it does.

Will do.

> 
> ---
> User can have a bpf program in kernel to run with each map element,
> do checking, filtering, aggregation, etc. without copying data
> to user space.
> ---
> 
>>   		  User can then *cat PATH* to see the bpf iterator output.
>>   
>>   	**bpftool iter help**
> 
> [...]
> 
>> @@ -62,13 +83,16 @@ static int do_pin(int argc, char **argv)
>>   	bpf_link__destroy(link);
>>   close_obj:
>>   	bpf_object__close(obj);
>> +close_map_fd:
>> +	if (map_fd >= 0)
>> +		close(map_fd);
>>   	return err;
>>   }
>>   
>>   static int do_help(int argc, char **argv)
>>   {
>>   	fprintf(stderr,
>> -		"Usage: %1$s %2$s pin OBJ PATH\n"
>> +		"Usage: %1$s %2$s pin OBJ PATH [map MAP]\n"
> 
> You probably want to add HELP_SPEC_MAP (as in map.c) to tell the user
> what MAP should be.

Good suggestion.

> 
> Could you please also update the bash completion?

This is always my hardest part! In this case it is
   bpftool iter pin <filedir> <filedir> [map MAP]

Any particular existing bpftool implementation I can imitate?

> 
> Thanks,
> Quentin
> 
