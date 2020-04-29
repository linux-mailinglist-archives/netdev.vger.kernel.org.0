Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFD11BD263
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 04:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2Coz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 22:44:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61510 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726345AbgD2Coz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 22:44:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03T2cBLp012880;
        Tue, 28 Apr 2020 19:44:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=NjbUI9CCbntLwhLCI/8HdsqCZAYVcHtQ9Sc4MegNSgQ=;
 b=lrenbJi0PPpuE5GtgwXt+tnKgcNg7CItWuoLFkGxRn61bMdRetE+QGYjvEHsCLEhF6Xq
 DK+Wc/GcKsQrU6eF9mjhkBJ7aibkRKqGFewCOUbtxg5P1tCKbXowNFVyUSmCWbzXpymf
 pw2UOEEY3CRXgJ4OctzdsJ9GUEvW0Qu8q90= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30mgvnrdpp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Apr 2020 19:44:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 19:44:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/nLIHgrgtgZTPJHQB9433ng1v50xE3U/X5fLqeBH9N68IJUsi0b/1GsZCTKOIdO3tlEg9PDA9EjGoK1Nb6ZPOKhEfVpUMCcNA3B2/TaZkcbUEvcGZe4A4Wj7u5XPeiYZIRoAPm8L3pFwSFv2Uu2CilItHPGd3mL2XXntReJvgZH+Ttb5DOhUs1G9SJO/mXkzTpCrzF75KC1bLMlYEXasDRDSSX2tMORagineMF4LzHMQmUv/trKwgsVpl+/AZjit5smg8BbJuMjhPenq9ltXe9GudhmbV5kGfLRy/ObDDJrEuM327jP+sYGpJ+xAujrjWYzMcNY8sxs++jRv3dN0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjbUI9CCbntLwhLCI/8HdsqCZAYVcHtQ9Sc4MegNSgQ=;
 b=OqtTi58RDVz10ZjsN/9Bn7wZTRqkZheFIdUKA6gYzY09qS3srzoYmeNFlxUK39s7nGPXXtuFlpWHLjMAQXgQBql9H3ioFhi7gcUy/DaoRK9etV2kScafasbgdvVOHuQtY42Vhwq4N28ykpUb9QtG6EteXmGWAIzDOmlANnGu4gdnTbAUMFihfoejkGJS0b3S61oueEBUkm54ALY9nOksLrjRncJsdX1WWVUtNMIZn8PcFguNmZMZG/iCyAyQgPXBgC1Ck8jFttdIUF8zuJuQGDE6NiTkJmjMkhkjou6pP4WSnXMjvIm8MBWMJuxmVH0cuyS7DfGbE2E8dc5UmkiyuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjbUI9CCbntLwhLCI/8HdsqCZAYVcHtQ9Sc4MegNSgQ=;
 b=J3xYk08EBCWpWdptHH48CB3rIHMDYyOrYC/XyYZ0VyELHwd4kSCC/555xclSpTL/q9jEI3C89pwWJQczuxJ418wq1Rww95h0PvnIut7JMNDuC0bfKIvKlI+Ut5alK7+CM1+09yJcoflD9tZREBmESisty8I5KteAcULRzuUxxTY=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3771.namprd15.prod.outlook.com (2603:10b6:303:4f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 02:44:40 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::3032:6927:d600:772a%7]) with mapi id 15.20.2937.023; Wed, 29 Apr 2020
 02:44:40 +0000
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
        <kernel-team@fb.com>
References: <20200427201235.2994549-1-yhs@fb.com>
 <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp>
 <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
Date:   Tue, 28 Apr 2020 19:44:37 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
In-Reply-To: <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR05CA0101.namprd05.prod.outlook.com
 (2603:10b6:104:1::27) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::11b6] (2620:10d:c090:400::5:3700) by CO2PR05CA0101.namprd05.prod.outlook.com (2603:10b6:104:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.9 via Frontend Transport; Wed, 29 Apr 2020 02:44:39 +0000
X-Originating-IP: [2620:10d:c090:400::5:3700]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c93b8d1-8d3f-4c75-5199-08d7ebe74369
X-MS-TrafficTypeDiagnostic: MW3PR15MB3771:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3771450B2F2F8F4FB49357A2D7AD0@MW3PR15MB3771.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(366004)(376002)(396003)(136003)(6486002)(86362001)(8936002)(52116002)(6636002)(36756003)(186003)(66946007)(2906002)(16526019)(4326008)(2616005)(8676002)(31696002)(5660300002)(478600001)(31686004)(66476007)(316002)(110136005)(66556008)(54906003)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Y75UB/wYeu2aiBsdOsQNG4tQjf4Im3dPTqskXQ0GOHJ2oTKycsLpB8iaMf8/dCJvDjm3ZVbsD9fLZllW4T2rsHz2Aa545pHoO1aMzd+9Ofng/ojI6Q8QCoftSbKes3TeMTG6I79cw4Knvw2i4sU+OLK0QaugvQ4stix5+g+yyh1+6I6HB4HEOeS7tJFze0DIo2aWZTDn3HLc1u0pOKLgqTSMAkoC6OmtnByAW/ldpyt1937lRtU3m3nI02800/8yaL+UnmVrcMegwdtogCWCs+pQoettk/RkfeivlbRVCnA916JpVkukd1hNvb4UBm/dAVv3CG8dnElbBdVf6j0JujwH/qBnNFseLv85ko/udI7TkCqgXxV0TfdMR8kf7xwCMsPh/vgn8sh3DCyYnzsgvW7rGIFRtV2iBgrZcluo18paE8qkiehrFVyxBIEo3E7
X-MS-Exchange-AntiSpam-MessageData: iC9eYmKz/igqELX4UpyjH5gULyVjTGkfNSOOHcMnBjWJc1e3DNmC36AF6pkunghMdh9qJmv+pTfHd6MI9LVOMVoABnseLMx26lpc66y/tq+v7qFdjbMuRPkIDJ1n4r3rboqcoM7RZKYdBCxhYxqpd+kyx2g5PG7bTBML1AAjdtPhW70Uk4/4NGImR5iyenasOStwKDozfB9YEJbxt+fBH+VJeWmNsZ1Ai+wLbzVCdhmCvkARpT4lgnyU4R4N8pzwKhId9vQg/g7M58kf/9VRm9UEdky5CrqfYe0+VC8Ja1WkBTcigHxrhpC9iWCvAerCx2vhq2QawhK6oxMHYBheTvifJsnRQrKkeiB4dBWpewVzKeZBz7rLnVlPm5gFl+mVsJtXd9BR/dIMPl3hE7HgbLhAratOZXHMh8KDOJn6vLxeuUeCbnDh0gL3Lex5icDlQge9FQneYrtjxQYhy1jsALBJ1W8zjdCqjjufI94gKWcChglCzTu2E8wuknbXyBRNtwF7Mi2x2O6m7i6k8fj4BHjBCgJ/+IavoQRmA/6VbSqhzfnQSYBPwUn4B1+FjTWdm0UDeYwsWEuzD4JbQIx3c3nVYizw/Itj2/YwEdTS2j7GThmp3rbCJUHxjF3zZ98m81froqG+BgmpJjBkO4r2XqP2SGWVT0S0l9ZnqcCvIOZmNxRpVbaqifdUOB0fpCcUoQ68CUQVesL4ExM8LdC/P/tidlm1uRLBizQo44ulxFnObt1rXVTsqpASLJk283+jhgozNYHgZgwhv3QJYquTILl97631YzG+wS0P90urZJyXdMnsDwjVWhIPAluD71T8kBdf/HG5lFWBUzBv0KSf0g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c93b8d1-8d3f-4c75-5199-08d7ebe74369
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 02:44:39.8516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4r850ndC6Kv6Vjvz1MbwJQXtO9DQAtvb5JFdNJhYzPH60jXWMKODzT74i7TsZEDK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3771
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004290020
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 6:15 PM, Yonghong Song wrote:
> 
> 
> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct 
>>>> bpf_iter_seq_map_info),
>>>> +                 &meta.session_id, &meta.seq_num,
>>>> +                 v == (void *)0);
>>>  From looking at seq_file.c, when will show() be called with "v == 
>>> NULL"?
>>>
>>
>> that v == NULL here and the whole verifier change just to allow NULL...
>> may be use seq_num as an indicator of the last elem instead?
>> Like seq_num with upper bit set to indicate that it's last?
> 
> We could. But then verifier won't have an easy way to verify that.
> For example, the above is expected:
> 
>       int prog(struct bpf_map *map, u64 seq_num) {
>          if (seq_num >> 63)
>            return 0;
>          ... map->id ...
>          ... map->user_cnt ...
>       }
> 
> But if user writes
> 
>       int prog(struct bpf_map *map, u64 seq_num) {
>           ... map->id ...
>           ... map->user_cnt ...
>       }
> 
> verifier won't be easy to conclude inproper map pointer tracing
> here and in the above map->id, map->user_cnt will cause
> exceptions and they will silently get value 0.

I mean always pass valid object pointer into the prog.
In above case 'map' will always be valid.
Consider prog that iterating all map elements.
It's weird that the prog would always need to do
if (map == 0)
   goto out;
even if it doesn't care about finding last.
All progs would have to have such extra 'if'.
If we always pass valid object than there is no need
for such extra checks inside the prog.
First and last element can be indicated via seq_num
or via another flag or via helper call like is_this_last_elem()
or something.
