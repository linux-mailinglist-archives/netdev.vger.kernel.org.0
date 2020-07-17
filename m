Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45422435F
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgGQSxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:53:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9478 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726205AbgGQSxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 14:53:14 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06HIZ9SF030836;
        Fri, 17 Jul 2020 11:53:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=a59wO4L262LnLMSRi2DHtdAMFkNo0WC7nKFiMRcM5Ew=;
 b=fqAcVbVhZJLS+gLZ6+AIFwuKe9xslrqj/iAgh90V0VWur9/WFg8EvSuplYIVCMiBI/lb
 AwtbrB54uVAvisuZoAaREMOcrnn3UYzf9J5BBSXXH75Wq1anqYixs3haffiPHQTLkOx1
 desNxAGU+jwJPbkTcgwxaXDFDGy+7GAul1M= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32a7x7tq9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Jul 2020 11:53:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 17 Jul 2020 11:52:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bvw/unoezXQ88UukbMFKslaEH0/nUGEIuG1c/EXH7DxcegiKGnx06KS8U1Z7pD48/kBLA8U8zGiOy5aKcf8MTXn9pyIqjdvm7Fl+9HO1Um2TGK/AaLTV7E7G9DoLuOJNaGWbiuP2axO3zasHHN+hkD4HyHdE8JAP5g45Qr2SEiObUOs0OqWZpoJrbunBYS7wkFc4fab8LpnzZuqWugR8rRP/Ad1sR+59l6BJtQIpNa1D3lOyG+g9k4v3TGBUSkEW1qUYO2zgcL0UGpczfLMijKYN0ZkNsGUgtl2X93X2CtubVJEUAdXN0YSay8ybjMQdUi6gvIGw/a3lceH7WnhnFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a59wO4L262LnLMSRi2DHtdAMFkNo0WC7nKFiMRcM5Ew=;
 b=bN/VaojjEOzqigvQtQ5QeaFhmk4OA1hiN6keAIcMhw767FitUUe5421TtiI3X9rqPzQZgZSLEVdRufaehUBBn/ZpNtFMO2agb/BDs5lMXGqwnfkm6uLCUrera4+xXLBTEMWbVl4bRRUr9SEhkLzvRW1ypCSxQMI2FFJ3DokyVxuStCDK6EGn2eA+Yhe4ifN8Et8NYlRZlyk+vUce0zgWm8ClZfFvlFUD1bEiy1/Y8DIDHluRGwI9/uW5hiHNZUJykUXCacNtY+/FRmyU7Xv5XMweE/7I9IIgncchwI1ZNyMBxK65/jvrtPTxBNjOB/Z9fZIancTn03nOtY9L1hYiMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a59wO4L262LnLMSRi2DHtdAMFkNo0WC7nKFiMRcM5Ew=;
 b=QR/WRarVaDcUOFUtfyQFYUeHX9XSZU/3htA6SatmEloiZnDrkIkTf56OszKNn2eKS+vZ7fccnl6BO73EKyY+NhqveB3ThmgnvTAaz3MzEYamnElp5fnPHzvt0IO8LAZmOzVXfQ9/HauV4hLIEXmvaaEKQRTY9lnSnce0V2wqS1s=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2246.namprd15.prod.outlook.com (2603:10b6:a02:8d::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Fri, 17 Jul
 2020 18:52:58 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 18:52:58 +0000
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
 <c70ebb0a-538c-a84f-f606-1d08af426fde@fb.com>
 <b845b429-0b9b-72cd-eaf4-3e621055fe71@isovalent.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <2712b760-f203-564a-c559-f1b7546a0e83@fb.com>
Date:   Fri, 17 Jul 2020 11:52:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <b845b429-0b9b-72cd-eaf4-3e621055fe71@isovalent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0037.namprd07.prod.outlook.com
 (2603:10b6:a03:60::14) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::1160] (2620:10d:c090:400::5:32be) by BYAPR07CA0037.namprd07.prod.outlook.com (2603:10b6:a03:60::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Fri, 17 Jul 2020 18:52:57 +0000
X-Originating-IP: [2620:10d:c090:400::5:32be]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ee54a41-4f65-43b4-a038-08d82a829f57
X-MS-TrafficTypeDiagnostic: BYAPR15MB2246:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB224648B4F3E91C228B0FAC1ED37C0@BYAPR15MB2246.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PP8OV8qkqd5NCbc2Qc3rbfSdDEVl/bD2qX4ABIYYsDjCyE/U71pdiS8DJ/1FMJ9Bwt71rIXSMTSsxxFv5L+n2GdtX4L6PrOWu1keyIjSfXr0VH9dFEqq7zI4j4NZt2x+hogLaRB8gzfQPBjeCXWrX0enl8C8upaXlG33+VIV1xf2og6KutZo55ocDTsE/nm8CzRJdYKjOYT0H90YJdAR30tIBnNrO5P1xsFWy1dTfeyqfy6NIr26jdOvefT2f2Zn/7T+h3pcd74VXdi703B4+7EhB3ON6oJS4Vk2ejUsNy5p2PdhUd8vOlJQPZ8tsCi19i5ocHTV90lAqAxwrd6NW5FulYYHYQzNqWqt3Wk03i25am43MLlHG8AwofxS0ND8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(366004)(136003)(396003)(376002)(346002)(31696002)(86362001)(66476007)(5660300002)(8676002)(66946007)(52116002)(66556008)(83380400001)(36756003)(478600001)(6486002)(16526019)(31686004)(186003)(53546011)(2906002)(8936002)(2616005)(4326008)(316002)(54906003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iHFCDfYXbeitSWl0HY63xZatH0CgkksWxu+rqrXrg8NexfiPfXUdnFsdpYQBZgsONTVt2vNgNVX8IQcBVibXAjSg5EVe08VqlNIJmW11tirfBqQp8a/mSEjlAvG13lD69Sf1b1L8JImJyjZzTkGGwsFieoYu93YoiX3COf30iK1U3LBbbJFA8p/iT8QTLBZGLH2Bodhmn04RGAXDqmfd6iMajBfaP4zNqLvVTP4QvCJkIVphUeNHV666lFyHoVo4mfH3RDQBHckulRc5RmZ0kq6TSEHbRDoL5CwTz3gKMsS2WIYU7ClzMbjS1knKgAxiD2WnYVTqdcrbYXC3LOdozbPZFY87UYuyqGKvGqiXIDnBJqizP/h0rU2jq/exG5Ys6x8I9hQj9PjTbF6UClo2qY6HsYWEXra9HO2Myu6cHOiY94WQsYnB7g1GzdGMbFvf2lQwRgrHIobiEmWvbikYKsGPDPqOT0Ck015ancTKvp11MyZY28NRqR/O57Kie98+ZSFJw5i6r0HN+E7VyoR8Hg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee54a41-4f65-43b4-a038-08d82a829f57
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2020 18:52:58.2259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cK3MqtjkCQR7T3tvyB91oqzZy8WHo/CplekfY4BcstsGui27UAKlSGZa7NYVa0zd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-17_09:2020-07-17,2020-07-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007170130
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/20 5:57 AM, Quentin Monnet wrote:
> 2020-07-16 10:42 UTC-0700 ~ Yonghong Song <yhs@fb.com>
>>
>>
>> On 7/16/20 9:39 AM, Quentin Monnet wrote:
>>> 2020-07-13 09:17 UTC-0700 ~ Yonghong Song <yhs@fb.com>
> 
> [...]
> 
>>> Could you please also update the bash completion?
>>
>> This is always my hardest part! In this case it is
>>    bpftool iter pin <filedir> <filedir> [map MAP]
>>
>> Any particular existing bpftool implementation I can imitate?
> 
> I would say the closest/easiest to reuse we have would be
> completion for the MAP part in either
> 
> 	bpftool prog attach PROG ATTACH_TYPE [MAP]
> 
> or
> 
> 	bpftool map pin MAP FILE
> 
> But I'll save you some time, I gave it a go and this is what
> I came up with:
> 
> ------
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 25b25aca1112..6640e18096a8 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -613,9 +613,26 @@ _bpftool()
>               esac
>               ;;
>           iter)
> +            local MAP_TYPE='id pinned name'
>               case $command in
>                   pin)
> -                    _filedir
> +                    case $prev in
> +                        $command)
> +                            _filedir
> +                            ;;
> +                        id)
> +                            _bpftool_get_map_ids
> +                            ;;
> +                        name)
> +                            _bpftool_get_map_names
> +                            ;;
> +                        pinned)
> +                            _filedir
> +                            ;;
> +                        *)
> +                            _bpftool_one_of_list $MAP_TYPE
> +                            ;;
> +                    esac
>                       return 0
>                       ;;
>                   *)
> ------
> 
> So if we complete "bpftool iter pin", if we're right after "pin"
> we still complete with file names (for the object file to pin).
> If we're after one of the map keywords (id|name|pinned), complete
> with map ids or map names or file names, depending on the case.
> For other cases (i.e. after object file to pin), offer the map
> keywords (id|name|pinned).
> 
> Feel free to reuse.

Thanks a lot! Will reuse and mention your suggestion of this code
in commit message.

> 
> Best,
> Quentin
> 
