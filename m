Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E4C24CDDB
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgHUGR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:17:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46466 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbgHUGR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:17:57 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07L6AL1j015834;
        Thu, 20 Aug 2020 23:17:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : from : to : cc
 : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GOMPJ/5KGFRYG+9qq2Lx/0bveKlIwOLMYbSaSZkQjy8=;
 b=BU0Z4gTB6dGvcWL6ycgSdhCRhD2eaUCmlvtswaXFFqwNZvTq4xw+sz+1rEkss2jfeG1b
 10s5yd+xEfW66NnoGOeT43svnYwbMfe2WZ/MSZeoqEVsNjKKxB7UJbrlSJjNiyEWhQFe
 1u+Kr3GpYzon1oS2fBMyOLiMvwRn7AiiLOI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304ny2t6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:17:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:17:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I5vymyjwavnNifoidHk5fNSxJ0IkNv9ypQyLACJ9MUphGF1AT0jZ/euJzOOcpk2dZuqYc1u6v1Rlz5P2Dr8+Lk300Dz/smletqeJZ5F1XWc8hGxkT4pOWERYO5s+E7vT14U5EWQKRWTJPp5T+7Wl5IqJVTz1CIiZIICFZaxQqkKJmyCVxoBGsjvgsZ2t7WKUl2StZRCRpoGhIvEGFTwwSV5Sn7nZju3Eq8fJLsv9bSFgoeY0UmrnrtA2arxWMApRfncTSJn1uGW4O4dTU4ybQF0ap3mHKWbmi+VV4+70FMnpELEfMRlJ7Y1/nntl0zgzfWMwy2MM2EqC64toTNcQDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOMPJ/5KGFRYG+9qq2Lx/0bveKlIwOLMYbSaSZkQjy8=;
 b=KKaaRBCTg0JdGAO6r/KoYwJVxhKbdBbxVuv1Vprje6bX34XV9Oj7O8hyWoZmwk5fLyu+7negxG5uaYUM08X3QMu6GxQKYmMUujMZxfc/rgot6Oy4qKsjeKNZ1v00aeSvjVsrkkL3LZdUza9t4Og0eb51gDRAq4xuYboH086S790F4v96djhAKNGiyDpxMubjnJxQ7TRlJpqqRm9wFcuxWfhuamFzm2iLCEGwalD4YGwppKjo5ZTguxgdU13C3fhmCaHJXluRVE3bRlZ7x7Lm7w6qeiETzcd8h+TmLrFZfhbPx1LTayG+d/L1bqZhoCTg8G5Rt1dsz3He23a8qk548A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOMPJ/5KGFRYG+9qq2Lx/0bveKlIwOLMYbSaSZkQjy8=;
 b=Ndao8R6yO2eT0qgrusSNvJu9f/4pwO27tf/s9NClCgk2qUz69d1OuSBSi2e76GkG+aTFdmh8WNGSH/8cMTAi5M160Va2VdgVO3wtnp4gNTW87NbDKQMYua2nPvcsYab2l5tu6dDQc4XpZ4wuD1ne8pWqrdyGD88toy6JgFqDHf4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2325.namprd15.prod.outlook.com (2603:10b6:a02:85::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 06:17:50 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:17:50 +0000
Subject: Re: [PATCH v2 bpf 1/2] bpf: verifier: check for packet data access
 based on target prog
From:   Yonghong Song <yhs@fb.com>
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200821002804.546826-1-udippant@fb.com>
 <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
Message-ID: <d9df934c-4b64-1e28-cc7e-fb03939d687d@fb.com>
Date:   Thu, 20 Aug 2020 23:17:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <9e829756-e943-e9a8-82f2-1a27a55afeec@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::15) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR07CA0005.namprd07.prod.outlook.com (2603:10b6:208:1a0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Fri, 21 Aug 2020 06:17:48 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaec00a4-5aff-4ec9-79dd-08d84599ee26
X-MS-TrafficTypeDiagnostic: BYAPR15MB2325:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB23251FEB97441EC47837BA78D35B0@BYAPR15MB2325.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhQ04WB8jgVAwiBe/EHEu02++tjR2WlyZGnc8o0P18I5Nv8znbQgAl+nwNhgdP61Rbk20ndjDsiPP83Wq/JDrPul6u3oYlszPYPrgyW15lh0Cb9upZkYZpaDX3WonzKbRw4HYXWaW6IIm+3949FeqP/KK6bYtRRrP990ntFPZo+kgAZ5KW56JvPPKBE9XCU0qs9RQRNd8qm3DtaKrNINDSQ1BHLs4D3t/byxwLIUH7bqLpHF80LsgJqZY+0sL6ygryNEc7j1kZnp9lAaFLg/TWkRYss8d6bXiY8MjB3/A2ggwOZ86HQW3ttbEI1cu3kJUazGJXMZDZKlD2wMN9X9F3u4sbw+69gYV8CIWvNw1tqylc33PXK+Y8hkGWFSrT5FaQU5Wlb/Nit//gD+1Z4XITQ0kK/DDSS0RBGBSFb6Pj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(376002)(39860400002)(186003)(316002)(6486002)(6666004)(110136005)(16576012)(110011004)(52116002)(53546011)(83380400001)(86362001)(956004)(66946007)(8676002)(2616005)(36756003)(31686004)(31696002)(4326008)(2906002)(478600001)(66556008)(66476007)(8936002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: hCOiGF9DqRT0jV7K4mei+eUjxi/yy/jzBbNYzMl5UY14oSIDxI+XvivHxydn2xPpqRZo46IWrL6M9zw4vb/CQgayPdgetjNqXsuw47oLiBbfT+QMOPs59X2VMVQq/sM35fkh5VzkFHgIGpZkp+BGr9NDY+18zPbUnibLPFnCL8d0yWIivZHXB1MG9Ci3iNOVOIH86K+cASfOR5QxDjOkgkgdP9jgSYiaV2eqPWSS4qPrvyDjv2Q20yI9TXSJ3gIxiyk/kmavkwe0NQcoMGSH4J60PVsboLglZNLA4bM0Nyy6oZCJhYKquf35t4itNZ921CZu7fgeVqpy0Bw1IpTmWi8BmjttwPbxc54BvIZi1nae+Tmsy8xzNwUTLbAxAWhAIA/HL3QDJDy7QfCudJosg+TRpZ0aiMQI3kpt4Z8cQUQ39ATK29PTuAbr+5U/4KXXEJayjHSt6Efgl8VNu2ehhdkrwNnRVJCRcTYAQvqO6RBzoh5488NsAnDI8BRLxnsr8aoId3Fk2MSe95OUlZgbY2QuBksMAt84ZJ3axHcKO6wheXtjMmX7dIJ63ETIovHd93LzmzE17ysNTvuwp76VMV3L3GbZrCKgCVxEGykK4jfZGQvh4fhQfIFfWdv+psTF11hq2AQoSdRt6iVoz2slJEt3Na1aM5BeKdbrrw7Wdjw1Redv7lvqLM3waodTnu8v
X-MS-Exchange-CrossTenant-Network-Message-Id: eaec00a4-5aff-4ec9-79dd-08d84599ee26
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:17:50.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vTjoSEqBYbcMCr1CFFHKfC4ZFe44Xh7gW+MCCL+pQcgmlq9V5QYfbrkFnZcuWF4l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 malwarescore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210059
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 11:13 PM, Yonghong Song wrote:
> 
> 
> On 8/20/20 5:28 PM, Udip Pant wrote:
>> While using dynamic program extension (of type BPF_PROG_TYPE_EXT), we
>> need to check the program type of the target program to grant the read /
>> write access to the packet data.
>>
>> The BPF_PROG_TYPE_EXT type can be used to extend types such as XDP, SKB
>> and others. Since the BPF_PROG_TYPE_EXT program type on itself is just a
>> placeholder for those, we need this extended check for those target
>> programs to actually work while using this option.
>>
>> Tested this with a freplace xdp program. Without this patch, the
>> verifier fails with error 'cannot write into packet'.
>>
>> Signed-off-by: Udip Pant <udippant@fb.com>
>> ---
>>   kernel/bpf/verifier.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index ef938f17b944..4d7604430994 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -2629,7 +2629,11 @@ static bool may_access_direct_pkt_data(struct 
>> bpf_verifier_env *env,
>>                          const struct bpf_call_arg_meta *meta,
>>                          enum bpf_access_type t)
>>   {
>> -    switch (env->prog->type) {
>> +    struct bpf_prog *prog = env->prog;
>> +    enum bpf_prog_type prog_type = prog->aux->linked_prog ?
>> +          prog->aux->linked_prog->type : prog->type;
> 
> I checked the verifier code. There are several places where
> prog->type is checked and EXT program type will behave differently
> from the linked program.
> 
> Maybe abstract the the above logic to one static function like
> 
> static enum bpf_prog_type resolved_prog_type(struct bpf_prog *prog)
> {
>      return prog->aux->linked_prog ? prog->aux->linked_prog->type
>                        : prog->type;
> }
> 
> This function can then be used in different places to give the resolved
> prog type.
> 
> Besides here checking pkt access permission,
> another possible places to consider is return value
> in function check_return_code(). Currently,
> for EXT program, the result value can be anything. This may need to
> be enforced. Could you take a look? It could be others as well.
> You can take a look at verifier.c by searching "prog->type".

Note that if the EXT program tries to replace a global subprogram,
then return value cannot be enforced, just as what Patch #2 example shows.

> 
>> +
>> +    switch (prog_type) {
>>       /* Program types only with direct read access go here! */
>>       case BPF_PROG_TYPE_LWT_IN:
>>       case BPF_PROG_TYPE_LWT_OUT:
>>
