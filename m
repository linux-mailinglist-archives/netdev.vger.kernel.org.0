Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64A24A6A8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 21:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgHSTPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 15:15:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27318 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbgHSTPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 15:15:40 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07JJ6Z4h010475;
        Wed, 19 Aug 2020 12:15:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fZe8R9hSNR3bAEvWFDXAJhqcVXjDPmgFVqcjilsCCKg=;
 b=ZVpoGnox+NqD8dqyCTJHLY4PYxrw3r8ZU8eZJXc/+WuSwW5Ek9zl7rZATJnFRvTXLPNc
 KnaBksoc95tqqaskg0kd8NJYSAryl6XcQtMhWoA+c1saJwEH9cC+sBWkgywHz7nU8cBX
 Pit/PdqSQT6V2tvAyqe3+T5O3liBugwYzOo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304pb26y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Aug 2020 12:15:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 19 Aug 2020 12:15:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHE3sdORZ2QasZBiCTIOmqDmFni2fnP1h4nr1gb6xrmoWXCFnGwPqa23pB1omPYDcjApdo42wVToizGXXaRZ38tvOz77eR+VSjlKvOVcq7jgsGeGjyOvstD3M72xlqIFtbD0Ey7eO3xW0/J80amq7T9hEOqW1RxyOSRMU8alVEQuktZRpES6j3eVflFNehoolyJ00AHNAuXeYFljRZchxIW0e+mFTpNQW4NNjBKYlPgNky0PMTairkLN3jCn6AYBvAGviO1hmSSaW64FzhEMPAncSkyN0RmqmmbXIZvcbKZrr9lABBYGXFOXw0Cx414Xx9YHfQfUgCR+DX33vLw2sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZe8R9hSNR3bAEvWFDXAJhqcVXjDPmgFVqcjilsCCKg=;
 b=Sh9LjgjtduRc0kOKA+WCzsh+Ifc/7fRH0W2XEz7pnsQX1v1cXXfZ7G9hg75uOiu4XjLgNkwx6V/ul7NKZay0RC8o0HVGxFbMPGJSU2M/fAjSikeTvqfl8DNObxX86o4CGrRrJpgy5/I/ukoQKuhU4OcnF4sMe2JBV+x5Z9u50AzhSRfwulliHX4qk85te/GrvsVmw+9b02K1NhfS9TkNXbFnY5t9qsaMc0rqWOycwu1G+5G2SzpKxxNMqZfLQIqigI0CMHJVIBLa3pGa2dlTXl14N+K5AhhyL4WfEig+O2yxlHgjzD02DNAFCh/lY7i6Mf/pWCBJ2YLsKcPFaPe8Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZe8R9hSNR3bAEvWFDXAJhqcVXjDPmgFVqcjilsCCKg=;
 b=c+wEvtokwW1KFIRwtSTonJjLHrwBnvwpKtLa/prJQKTCW6aDPNNY+ZbvoyN3yP0BFyaVw+gRpXiXguWdRTY8B+WqU6XLjOVTBO07NhVVupVMWx1xhs/aXvcCDjRR87k54wgYfDCg0S958b9/0ZvnxnUyRUM8mTRutgtzZz9opUU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 19:15:23 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 19:15:23 +0000
Subject: Re: [PATCH bpf-next 3/6] bpf: sockmap: call sock_map_update_elem
 directly
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200819092436.58232-1-lmb@cloudflare.com>
 <20200819092436.58232-4-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <1dfcc278-98cf-525c-7f35-483f461b2f5c@fb.com>
Date:   Wed, 19 Aug 2020 12:15:18 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200819092436.58232-4-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0044.namprd05.prod.outlook.com
 (2603:10b6:208:236::13) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c0a8:11e8::10d3] (2620:10d:c091:480::1:d29f) by MN2PR05CA0044.namprd05.prod.outlook.com (2603:10b6:208:236::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.16 via Frontend Transport; Wed, 19 Aug 2020 19:15:21 +0000
X-Originating-IP: [2620:10d:c091:480::1:d29f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21cb0444-aeb6-4046-b7b4-08d84474389e
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2582C829F862397AD7EC59D6D35D0@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(376002)(396003)(39860400002)(4744005)(31696002)(83380400001)(5660300002)(31686004)(86362001)(16526019)(53546011)(6486002)(186003)(316002)(52116002)(36756003)(66946007)(4326008)(6666004)(2906002)(478600001)(8676002)(110136005)(66556008)(7416002)(66476007)(8936002)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-CrossTenant-Network-Message-Id: 21cb0444-aeb6-4046-b7b4-08d84474389e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 19:15:23.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSBgROU53/dyxtSgmB9mZ6MMz7jC4+Q+Kl7rX0Vg1tPN9J/5ejGlYk/J7hH74tjY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_12:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 mlxlogscore=986 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/20 2:24 AM, Lorenz Bauer wrote:
> Don't go via map->ops to call sock_map_update_elem, since we know
> what function to call in bpf_map_update_value. Since
> check_map_func_compatibility doesn't allow calling
> BPF_FUNC_map_update_elem from BPF context, we can remove
> ops->map_update_elem and rename the function to
> sock_map_update_elem_sys.
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
