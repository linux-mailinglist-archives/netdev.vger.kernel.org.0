Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5A43613C0
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhDOU6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:58:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50994 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234838AbhDOU6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:58:01 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13FKhdLR021708;
        Thu, 15 Apr 2021 13:57:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Cnv+le7p49hT+BmWZjnHdzmVORvn+yZgASgB4D7QvJU=;
 b=HpDJ4iQgAoVHKKNPG24In/b3JHz5h8Wv9Mb6yJZ8JHgraMFar+5o6AZ3zVeaiUt4Gleu
 dj0tTr8mQCzHh/eKas0/UNFK804NPppuWmHOqXYRdyO4xtFi2+FQKLLrcqs1p/NYD5Ft
 RnQ1AtAOSWAvye9QfGQvMtZDnU6tZWz8Vx0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37wvcmt6rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 15 Apr 2021 13:57:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Apr 2021 13:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcevPTbPpN6b2G/ULsttfI0EYBLLNeAWQqXstlrJNCXr9SMNqX2MTtZEZ+LlaytmDtUtCju6/oQc7MaC/UfYR+WF5Hszm9R1NG6sxDIFW3GCEGTHzJUAlBVPAJVcJzRbCa1L7iusi4QWv8fjQHWjx4JbP+PJ6VGvSSkwvGVRrGLjwFvKJSbs8bGQs32P2491fK+yqoQzUaBNn/dQN50O8yWtvFKGkFJ8UaHey2NMAuUkKbjXbFgrp3QwXHHX8KN/BzHrJLmNx+kK4ON0RXGITT6gdBfZDGPJ/Uc1Zhg3ZJiACQKXeD/W20zMfgncBNIfa9ZIkxfh5v16x9XV0qQXCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cnv+le7p49hT+BmWZjnHdzmVORvn+yZgASgB4D7QvJU=;
 b=HCHJl5s5kLkY0rZoyQZREg7/7XWxNQpxGUtJspytYaco3TZxJYFCWeXBWDMyPf6zmWknQaOX799HV7fNV0xlM/CpJeDHFlCx59IVWM4xX6Il9u7XlowATPOq3c8obeN1emk+s1DCe/TWdw7k6BhdJR8ACwjTwvwtO3numEbkp2/yz57sG2WR/t2zethXnqDLZHuptt/uRMZdnk9QhFvs3IG6DqOgmC48LflwjZJO0T1/KG00yrqEmstcXcz3aJS5Qwvf3tB3vkxkJRXLj6o5DCapPbx1l9qGslX4NBuru/QIjbO5d0KXwp+LzNu2vvurGGBkgrDH1pZSDraowDVf/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from DM6PR15MB3289.namprd15.prod.outlook.com (2603:10b6:5:165::25)
 by DM6PR15MB3768.namprd15.prod.outlook.com (2603:10b6:5:2b0::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 20:57:21 +0000
Received: from DM6PR15MB3289.namprd15.prod.outlook.com
 ([fe80::f5c5:b681:9d22:70e8]) by DM6PR15MB3289.namprd15.prod.outlook.com
 ([fe80::f5c5:b681:9d22:70e8%4]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 20:57:21 +0000
Subject: Re: [PATCH bpf-next 12/17] libbpf: support extern resolution for
 BTF-defined maps in .maps section
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
References: <20210414200146.2663044-1-andrii@kernel.org>
 <20210414200146.2663044-13-andrii@kernel.org>
 <f3f3bcc5-be1a-6d11-0c6e-081fc30367c4@fb.com>
 <CAEf4BzZnyij-B39H_=RahUV2=RzNHTHt4Bdrw2sPY9eraW4p7A@mail.gmail.com>
 <20210415020138.2dbcflpxq2zwu6b2@ast-mbp>
 <CAEf4BzZXLi8Z=4fy5TpH-po-d__7eg6PrgBJWk_3epmT-n3SMA@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <df0201be-219e-7e75-dcef-bf60112c5137@fb.com>
Date:   Thu, 15 Apr 2021 13:57:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <CAEf4BzZXLi8Z=4fy5TpH-po-d__7eg6PrgBJWk_3epmT-n3SMA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:62e6]
X-ClientProxiedBy: MWHPR18CA0064.namprd18.prod.outlook.com
 (2603:10b6:300:39::26) To DM6PR15MB3289.namprd15.prod.outlook.com
 (2603:10b6:5:165::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:62e6) by MWHPR18CA0064.namprd18.prod.outlook.com (2603:10b6:300:39::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Thu, 15 Apr 2021 20:57:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6e037c7-5a1f-4bb4-7750-08d900510ff6
X-MS-TrafficTypeDiagnostic: DM6PR15MB3768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB37680D02D4BECBA39B469C3BD74D9@DM6PR15MB3768.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uda+kl8zL7UZGgu8mSpK/S2qhbO779+lQlXx3/QVPVH3jFjaaCzw+qHE5xsR4PwBz+Zf/HNnaUBCgZ/3Iwho7Q39fLXnqgEgRzSgsYfwFahNd1vbS2X8usrj6oouorIeMRcSrngDfD5bcxkxg9GuHXlj+7Z3nNbAvApeFm6n96husmZXmUbR4yj3l0m3WZfrmcVC83FwFT6OkDy2ChisCKgdURzFkSFYukes9zukdkPsJD+Q6zLowCxi9gdEeDG4uzZ5Koy2hLcqFskhRQnuh31tbhlAUadV4hdgEESU6NP0nmt3Ouc7h/7l7L6GYBMONKP042P0WcThfL2+z2WBgGugNk/cVwNw342YYQqQxnXoAhR6a2Pkx6FPVIxLaG3DhMhQXvZ2irru+5LU5vIBywo1dW/8CV981eBsm8D32Dt1h3KQJxNsSwNNl3N3ok1SYOtc+lljMWu5Hua/KsCIiyv0nmQ74Mm3rX046X7XsdmfxcCzflgfhG7ptEk4dCcJygcu5SfB4vh7TNCKOpYy0975NqV44R+hUiz83BCxUjdOJKxBuj/BMZIzuBXvA2kx9Z76KqkjijhHFhJ5NaXI2mJ1YOyDIXqo2UlrsSkZTsr3DRkjpCK2x6zUFK9nfW+xHEFnpDCHLfoBs46BKuZ+5e95tpUoagNeWHB9syLKtBoG77YXWEAZcqiNJf66HmCl6LNnqXuAAKhn4gc0oI2nRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3289.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(366004)(346002)(396003)(16526019)(8936002)(8676002)(6486002)(2616005)(4326008)(38100700002)(36756003)(31696002)(2906002)(186003)(86362001)(54906003)(31686004)(66556008)(66946007)(66476007)(5660300002)(478600001)(4744005)(52116002)(6666004)(316002)(53546011)(110136005)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?czFyamdkY1V3RDQzWEFhUEJOdnpYRUV3NmF5UDlBayt1OWZ4K1hwOXpFdEp6?=
 =?utf-8?B?TmN6VVYrYVdMeFgrWXVRL1V6ZzhjakFsZ0k3K3ZENUlNbDc4eERrL2JyZGlh?=
 =?utf-8?B?OFRNQXJVYldGRkdhckliTHA3QnZYeEpPUWlRZEI2N1NuR1dWRFM4Q1lMbHJY?=
 =?utf-8?B?T2lTdmdLUmpnQ0V1YXdrbmdzREgxVHpyckhIQlhSbEROTTlrWUpLMFB3VlVy?=
 =?utf-8?B?K3ZyYmxRRkM1V0RwZkxPOGlrS1VXWG8zY0NnQWh2ZDFZeW01RjZpQVp2dEI1?=
 =?utf-8?B?L2xsZWlkcC9URlFQSDBhYmhlWXVrNnlxU0huUWhIRUhZU0QweEdPWXBIeU83?=
 =?utf-8?B?UzRCdGdwdWZXL1hqeGdsNTB6SHMzNG5mTTdoTDFwSEt0bnlRa0ZleXd1RnVG?=
 =?utf-8?B?b0JZeVhDMy9kOHpiaWFtSjNIRGpoeDcvVmZ0cHFBNDJsNjY0RmVlS3pvQ2Uw?=
 =?utf-8?B?S0ZRQ1BFWVhrZ2hadStERlVEL1FCckVzaXc5azIxMzNtTEwzUis2M3VUWU1G?=
 =?utf-8?B?Tm9RdFFkemcxWkNYVUNJeXhSaUh5bWd5VlBZbUhNRXFJT0lLdkdCamxEL0Fn?=
 =?utf-8?B?L2lIYWxqRWV5SDhwM01GYVpUR2Z6RVZIRzhaTE9JVVdHbzFla2l0YmVLd2h5?=
 =?utf-8?B?TDdFTVkwOElyaUdZUittOTc3bEtHUmh4UDdCcjZaSWFpSUs3MjluYU1Oa1hZ?=
 =?utf-8?B?M1EzaGVoSXZ5dHd5NXBzdHp2VldwNk14K1ZUeG9QbXdVZFBuVHlOYjRuWCsy?=
 =?utf-8?B?dzlpRDllNjVJT1FDZWJnZUpKOVUvckNLNU16ZUlrN3VMWE1GcWtzbFU5MjB1?=
 =?utf-8?B?cy9zM1d5Zld6VERjRUNSRUZMeitOVVhEdnk1UDFGdk9RU09jWlVBNVdJVWVI?=
 =?utf-8?B?U3V1aUtTQTI1dzh0V1IyRnA3eEpuSGNwVU5xQ0c1cUZjTHpNMVk1MnVZd0FK?=
 =?utf-8?B?Y2JxbFRkMHRSTVcrQlkvTnd6dW1QMWlTMksxSUYwZndsSE9adnlqczJlWjZR?=
 =?utf-8?B?UDM5Wk1KdG9sc1dEN1lERnFFNFNuU1VQMzRRV1hPZUplQmtHZmdWZi9OV0ho?=
 =?utf-8?B?K3V3NTVWMnMxbTdqaGpnWml5RzFPVjB5NWhYNzBWYXM4ZTYwTWpUMTRhMXJw?=
 =?utf-8?B?bnRsbkFuWE92cDBLZWNsM1BmMXl5dGFYTmFRbzh3KzNxb1lTWjJiQU0raGI3?=
 =?utf-8?B?OHhSait3UVlLRjF5cHZTbThaUVkyRWJSZkdFT0kzYkRacG04UldPYWxhMSsw?=
 =?utf-8?B?WG5FT0oxQmVkbS9qeFhFSnhqZVlmUHZOZVducEVEcSs5R2gzWG9qQXZBUFN0?=
 =?utf-8?B?RVpobHFBTHZEYmQwa1NjVmlGam52Q2w5ZDk2eGt1Y3BvdHFBalQ1YVIyWUE5?=
 =?utf-8?B?OWN3NW5YVnFyYnE3N2NuWTdETXNEQVN4ZzNmNEptWGRsNFJxUGEvRzI2NG9D?=
 =?utf-8?B?b0tiRkUyc3hna1lna3FPbjNkNS84dDlVcWw2UVdlOWx5K2p3YlRhNUIyUERK?=
 =?utf-8?B?S0pVejNjb1pUeEZoOVJxMXhjbXFOTVl0UGZNT2RsbmNYbTJOZGw2d0RZZUov?=
 =?utf-8?B?c3ZhSWY3dWFSWWRzcm1mMmtMWlpKOWJEMXFXMWgyZDVjdXhHeHJBaW14WDlY?=
 =?utf-8?B?K3B1M21maFkwNEEvbHF5MzNXMS8yQVJYSE5uU3lxNHYyUWhMLzlNR0NHdE5H?=
 =?utf-8?B?Y1pxcU9jSnJWYU9RZEVwTHdJb0d0S2QrVGtPQSs3WHdUTnRpYXFiRnRDVnc3?=
 =?utf-8?B?ZmQ2M2svelQ1WXdhZ202MXM1OThFMzlMVzVFME1xYXZSbWEwL3lPVVVVeGVt?=
 =?utf-8?B?YnJuVStuL2NwM1BPZ0xjdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e6e037c7-5a1f-4bb4-7750-08d900510ff6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3289.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2021 20:57:21.1986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lRorQOeiEFceqMXC4r/sp+NjAqnJeoerpmkq9ak5yvtPPMmoASyvO+8KOG4eUKrk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3768
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: Qs26npteB-InNi7-lQv8boCEkUBdmhCb
X-Proofpoint-ORIG-GUID: Qs26npteB-InNi7-lQv8boCEkUBdmhCb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-15_09:2021-04-15,2021-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104150130
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/15/21 1:35 PM, Andrii Nakryiko wrote:
> 
> How about we start in the most restrictive way first. Each extern
> would need to specify all the attributes that should match the map
> definition. That includes max_entries. That way the typedef struct {
> ... } my_map_t re-use will work right out of the box. Later, if we see
> this is not sufficient, we can start relaxing the rules.

+1

>>
>> btw for signed progs I'm thinking to allow override of max_entries only,
>> since this attribute doesn't affect safety, correctness, behavior.
>> Meaning max_entries will and will not be part of a signature at the same time.
>> In other words it's necessary to support existing bcc/libbpf-tools.
>> If we go with 'allow max_entries in extern' that would match that behavior.
> 
> Ok, unless I misunderstood, allowing and checking all map attributes
> as a starting point should work, right?

yes. thanks!
