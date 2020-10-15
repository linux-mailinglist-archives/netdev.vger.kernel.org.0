Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B693228ECD6
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 07:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgJOFrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 01:47:14 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33972 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727397AbgJOFrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 01:47:13 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09F5i7nW013987;
        Wed, 14 Oct 2020 22:46:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=m3o+TsTDV2mRvzDWf8Qn0JszL3xarw0rAa5Qme36LhE=;
 b=Ce7pTYbuQQGsCrk8sbqg3/Ad6MMrayyaANfi1QVmXjN4lBkLU4q0NU+UZWPWHdPosH5h
 seld8yr9NHChHBQBbhZiFPlJjVH8r6ndnHhTuATavvPlSoYge9uskvJXvZtT+a5HjDYK
 1EdBmYifuECI7iB8fPRgUrOc+yxe1yn9G3s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 345p2cyhv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 22:46:58 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 22:46:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQO9U3YFAV6GkOhWS51eaNRcqE3GTKuiee3hZO2SSdyFOWN1Et7U8Lkq5uHmgGRyvC+VIDEPCa4UbiG0UQSBTEBjP9VICeSAd17KuO2u6eze+sJinT85iY4q3SPgQMSiV2DCNQ561qz5mkUOkm1oK1fJ74p1vwRmv8voXpEm00WQxRrp/oHIi7VkPyNIVknutBQ93dgLXJIxT/ct6dcRMH4Ttyx3xzSJa2erL2dFV9FbDm2gGFvJ1muYxBvwDim6lF3LZR1G7yoEeShlsrnT8d7jkblRMaPXlRg90/2CnGSO+k9UQeCjh1DytTkE97oAax3S3YNcooKog69EBhjk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3o+TsTDV2mRvzDWf8Qn0JszL3xarw0rAa5Qme36LhE=;
 b=aqeiPw3SGYUfLMDuZtnrv7T4254v5xpSzPLgrrpLqCFKkLcpRctZ2OM+BhlI7NJnubGDe+q7ccftBQLjW8nQuuxAVfZbBfe+HzXeXZx1Q0LipZ7/319HM1McptkZ09/F8yNRxQlCDpCrXvBteSRezfcDr88Ry4RxI2LDN1dZhq5lvQLVaqBSn6Q21Zs8fy+q0xJ4y0q6btH+ousE1voYIbF+eCrLQeKoW83NAfmb8w4mlZXs0eLjo6ck7FaHQZLllOMvAF2JtyFCB+nA9RwTgy7o8EbTPu9jCem3+LvdY9zoEZDWum2Fs8yNCOMUmT5ACx35+ZRJzHNmTpYP5Yz55Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m3o+TsTDV2mRvzDWf8Qn0JszL3xarw0rAa5Qme36LhE=;
 b=UQ/JOkYHBRXK8FU9yyy/sIJGC6nRHc6W9ST8eXgTBcldvYS1a4MJhLG6AeMihWYqW+7hYEKCdVwvUS/N4PCFzrk6f+0xZuM2d9pyRh0BfU2W6iGr4OdO5S4+lNAxMn0L6k9axcv9n+ico3ZFlhich1f3sINbAJU0/OCFa9kFuZY=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Thu, 15 Oct
 2020 05:46:52 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8887:dd68:f497:ea42%3]) with mapi id 15.20.3455.030; Thu, 15 Oct 2020
 05:46:52 +0000
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4ec07471-5d8c-5aba-1f0e-65fe61c4d298@fb.com>
Date:   Wed, 14 Oct 2020 22:46:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
In-Reply-To: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
Content-Language: en-US
X-Originating-IP: [2620:10d:c091:480::1:2a8a]
X-ClientProxiedBy: MN2PR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:208:237::6) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11c9::138b] (2620:10d:c091:480::1:2a8a) by MN2PR15CA0037.namprd15.prod.outlook.com (2603:10b6:208:237::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Thu, 15 Oct 2020 05:46:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a1cc8e2-6577-4353-e33d-08d870cdb78d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB3571361046916971434ECEB8D3020@BY5PR15MB3571.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6wm0vrN4MuqOA6VWCV2YOcE5N/wnEtBr/pbcpSIK3Ih7FWhEOpBAHyjloz2IUssSizigzVviqS7sDNewFP4K1yD8oTBubbliKEGq/cuzmmRjKBZdZ+Cv+tXltTJZKoL99Vw/1mtVXrwGRDhg2fvlGbJ2HrWHtxqwrOGQ7s8a+Vf4Zq6S2j8hZ2HPrxjTYR2TAU4fSwIF2fKStKLGnBB29PbWiJuzje46vwxaY2ofUPoSRtjsIaXKkFyAIaLlnYUgdfooSOpFVGjTcau/xW2KbvjGmkMXO05IuG6ZyCH9CzJtRbZ8NQsJ0dJVyMvA0b2sT6oAJxqOuY2mdvingN9I4lrG/qGt4hvYCnKL9Sa267bqhq8Al0MI+KRlJJZ7E9z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(396003)(39860400002)(6666004)(186003)(86362001)(16526019)(6486002)(53546011)(36756003)(316002)(2906002)(4326008)(31696002)(8936002)(478600001)(66946007)(8676002)(5660300002)(52116002)(31686004)(66556008)(2616005)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7d6bDLYLh6agErE2ZehJvZy3P5C/k4LOo3Y0SR+bwXR/rreCK0orqcYhOGFdJY79quGPKoNxj64T6sqT3TpFLknRaKL/iRL+CpcyVI1MheMV+NormityfZWkhnfXzWm2uSlqVHovuR86Wf9zZIC5BltFcq6twU4I4INKhHqGRFMQx+t9aI1WIgxLM3hlUZlsJk5FkoUM+l5zjY/+UZIa6/HqBTBQ4e8iBaUZFj4Qk+HccPQV0roqtdKbuqCfjXRZLKyJBOmG+BR1IgbY+FfKGTIp0qMjQ9EPXTB5hJMcemjdr5D0y1TN+sY6xZ35AQjKVnTwpSqiAq19ZzJ0ncY4dZAza+Z5is9NoM0HnEKVWrmEdOvgbpI2wGfzxfnzwAPeFrgEWGCbUIDNhbThc+EoRo73MP65c9IYYIpsgXRluzeusDwikHNPxDhtQu9p3i3JoH+N/lyJi1CgWJm8FOIstKwgeU9iUKCnvxAhzgHUfiYiGNUzVPUm45vcb8HzTLF+OHutVigZcApQMGbDP9yO2avrI1DdBM/qR4ELfosHM4ZoXJ8NVpD/BFylmqBer99Q7j5CI8XrW/fMfmfQyKNwNsdFeRzdTTxk3ZXQlBScQ9jl2xoZsgdnf/QLIvU5FIAsYeMFLjygXeJhFO1h84V4jYVLzVbkorg7gOw3y0cKoQU=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1cc8e2-6577-4353-e33d-08d870cdb78d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2020 05:46:52.6249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Ot6PtnYFR7EXbxUC9bpRl6CeCAcXB1yll7LqZeTZN4MAqqK7x89Yolz8BpsovPg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3571
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-15_03:2020-10-14,2020-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/20 10:56 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> true or false branch. In the case 'if (reg->id)' check was done on the other
> branch the counter part register would have reg->id == 0 when called into
> find_equal_scalars(). In such case the helper would incorrectly identify other
> registers with id == 0 as equivalent and propagate the state incorrectly.
> Fix it by preserving ID across reg_set_min_max().
> In other words any kind of comparison operator on the scalar register
> should preserve its ID to recognize:
> r1 = r2
> if (r1 == 20) {
>    #1 here both r1 and r2 == 20
> } else if (r2 < 20) {
>    #2 here both r1 and r2 < 20
> }
> 
> The patch is addressing #1 case. The #2 was working correctly already.
> 
> Fixes: 75748837b7e5 ("bpf: Propagate scalar ranges through register assignments.")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

This fixed an issue appeared in our production system where packets may
be incorrectly dropped.

Test-by: Yonghong Song <yhs@fb.com>

