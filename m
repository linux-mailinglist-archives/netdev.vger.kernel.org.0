Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595301CC6E5
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 07:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgEJFHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 01:07:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726660AbgEJFHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 May 2020 01:07:24 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04A57CSu029329;
        Sat, 9 May 2020 22:07:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EmJPIYEBFdhTqOxCI8f4WyMtRLjwBDFR37Rvnr9B2TM=;
 b=J8MUidGSMfm1j4+2HMClO3T3hH65z0pkia+sBD7k53gu6QkYE/JftR1dF13RVHSB/2Me
 Y7GLz4xr5RSNcAEBE3BVyM2Ciz0ZZjokKmpew5i1fISv6YF6oXkGadsyTrkFaTl/j5Vi
 jbO/8qoYQQIige0cuBIb3jG4hO6XAJ0j8pk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30ws55b8w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 09 May 2020 22:07:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 9 May 2020 22:07:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cS0bbJ/NXqrR1Q8fNbVL+YfcSiOhjkk2X+ocRhtIpvr3Pi0AT6xfP+QaSjPS1qMSM04JMOo6F+syMVPAF7StEms/Rhm29hMaxwrEiL1c6lz8Ol/rTPMRM5ZdVgU6pM761RAJ0kW3ZBd7+jLWspTCwsXSRy6qOMjeJls1Jy1NLwwRUBonKAeb5XOUcpslxjFCfO+oPUmIrLHSG1ywd7ThMonn/a9yVYqQh8oeUIX1rFV6TWeNdZ77BkwFUNf7jk3iK/e20BZKRxAmf4qDeB+YG0OdNJact8gq7JNWd7/al7bpLjFO6KbWBxqugjNxOoLUA3M6t1HKh9o9iMCVQSsxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmJPIYEBFdhTqOxCI8f4WyMtRLjwBDFR37Rvnr9B2TM=;
 b=mJU2bpaZpi3B8IjtRF0r/ptBz3e8LiGISw5wa0XXgG0EURTYPxPyjOQndg1HQFnCXrK6Fv0HFOL+YebdYk/xOG82VmF7Xx/oIfc4kCfRYpUrTJcAeLyfdAibcvaup1kc4N5tnHfPpa7GJIPf3zSBMYuIVAN8CW9ksiuAJ1sXmVwStVM/MZCaMX36CGRA+aQ8y5lKCN5TAVhBxGiay9JO3wvU+U0YDGl6Ra0R9qTIFiyoaZK0ZnkNLPuYAUYDH9raWaOTynDpK8rhNSI272wg7t9Q4lyu3lCdVChgjJQluB15ZtSNgWRSgKSb8VDrmyX4KUP7PTK2qPcUvCRgsVM9LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmJPIYEBFdhTqOxCI8f4WyMtRLjwBDFR37Rvnr9B2TM=;
 b=Gmc7R42jDRHHHYIFJ4Q0JDRY2ZKPFyCXikUIhBZ76UjspG4+7CKAAUW0nq8QThmxi6Op8uPRC8YqYpXMveoszH+/l58uqT8onogG1qFWa8ORJQ65KvguCJyh5jlW5ZDnUgjiZID0qyWyqlZbogEbIhendvoNFTGMfMX1FqOni+s=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2869.namprd15.prod.outlook.com (2603:10b6:a03:b3::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Sun, 10 May
 2020 05:06:47 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::8988:aa27:5d70:6923%5]) with mapi id 15.20.2958.035; Sun, 10 May 2020
 05:06:47 +0000
Subject: Re: [PATCH bpf-next v4 16/21] tools/libbpf: add bpf_iter support
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175917.2476936-1-yhs@fb.com>
 <20200510003535.rfnwiuunxst6lqe5@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <51a07f55-6117-58c2-e1f4-a1f38130976d@fb.com>
Date:   Sat, 9 May 2020 22:06:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510003535.rfnwiuunxst6lqe5@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0026.namprd21.prod.outlook.com
 (2603:10b6:a03:114::36) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:e956) by BYAPR21CA0026.namprd21.prod.outlook.com (2603:10b6:a03:114::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.2 via Frontend Transport; Sun, 10 May 2020 05:06:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:e956]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 934a3623-1cea-4822-13a9-08d7f49ff0e5
X-MS-TrafficTypeDiagnostic: BYAPR15MB2869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2869CD750D5C86332A0D9118D3A00@BYAPR15MB2869.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +M8PMG45FWcDPaStCeIRghe3W5dtacPK+iKrU4t8OuUFC3zq7negCO9dd6YKZrIraWH/fbCPlEzy00q0JKGoqrA374OMYYcsl7sEg/bglr+bLYPie9Y/in7hhJexF9Rpq2+9CNufYOR+wjY6kgvklr2m+l4LKqfzXaybTa69vSYd4XbLmQX2KVJoY4puzBXgdLOON1RYpV6+1uBpyuf0OnR0yko2prZI7RvbjLPh277XL8Y2+qNoeOyQv7WFK/Y81oLvV0zHXOcb8tjX9S6wrFt9A1s1sXQXHG6CoFzxhJgqDknHi/FIYauzeQXsZP00cLDY+cVFppTLvHMS6A4l88Sviha2rQqPw2vZZP2+LBauA62MKKQTwZ4VuwpDy8f33Lzo1lY1ps0KjlZHD0dMknxzVBRo0ITfXfrw94rolzG53oGoT67xjm06CsbqjrYW8f0DUyt926b36IGE1BDVKIp4sW5e6HngLerwEoo9gAGx10/SrWvEAEqP7Xtqa0QCHcHgzU9KJzoccQCIDkxKHK/lk6SG97pdnFmj/JI2PuSYQ1+pIHr6UY79+KTuGAcr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(33430700001)(86362001)(66946007)(6506007)(2906002)(316002)(52116002)(53546011)(2616005)(4326008)(6512007)(33440700001)(6486002)(6916009)(186003)(5660300002)(16526019)(66556008)(36756003)(8936002)(66476007)(4744005)(54906003)(31696002)(31686004)(8676002)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0yd6tQNNL5yg4UGokaSBeuTVuJt5FHvyVnnwbAaHlUnKGj/PC0Lc6AH8zM4j4/YxVlnZTVFjKoOxOT4bbNXNZp1nR/K57LCM6xJvK4gXMsxE/7FpogmjQHo0pgD85nKs+C6q7w0dzzbPCP/crZHRNo1LsUdvWA9YS/elxQmb8Uv3mu4ePuubVqGyDtd1gAT0qcCbc4VuauDcmRWr/y6ojaDmuVty30YRFe4zTKdSWtHAjyIlLbhkPVPC3Yy33jkEPMjzaVHfimfcZi1rwc/D6OXScUs1ZlMIWjR1iDi8yvMZw8hrF2oT4fDSFucABC3Dnz8CFNFe3Ln2w9cKVZOZupjbWQIWd4Ksl6L0Bt/3fJaSla0FIpAHfd4WZXj3rXSVBY57rUOlQKunprd0cgF+yg5tFAEsuNVq3d6/YjWPJ1n1TXLVGA8A/35WznSyDwnfXA7s68kwZcNQXUGfMrVdijTKe5968toD/qTNSOK91Kl2dktPYb0fs0I8UVcGVI+3OmYAQJifx6tD/W5UcMefgQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 934a3623-1cea-4822-13a9-08d7f49ff0e5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 05:06:47.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yMqYmxP7lRu9G96Tkm+QF1Nl5cyP40z0dd8alI93+klCu6irdvU2qdkV1xriCjAn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2869
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-10_01:2020-05-08,2020-05-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005100046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:35 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:17AM -0700, Yonghong Song wrote:
>> @@ -6891,6 +6897,7 @@ static int bpf_object__collect_st_ops_relos(struct bpf_object *obj,
>>   
>>   #define BTF_TRACE_PREFIX "btf_trace_"
>>   #define BTF_LSM_PREFIX "bpf_lsm_"
>> +#define BTF_ITER_PREFIX "__bpf_iter__"
>>   #define BTF_MAX_NAME_SIZE 128
> 
> In the kernel source the prefix doesn't stand out, but on libbpf side it looks
> inconsistent. May be drop __ prefix and keep one _ in the suffix?

Currently, I have context type as
    struct bpf_iter__bpf_map
Based on the above proposal, we will have function name as
    bpf_iter_bpf_map
It is quite similar to each other. My current usage to have
     __bpf_iter__bpf_map
intends to make func name and struct type name quite different.
Or maybe
     bpf_iter__bpf_map vs. bpf_iter_bpf_map
just fine as user should not care about func name
bpf_iter_bpf_map at all?
