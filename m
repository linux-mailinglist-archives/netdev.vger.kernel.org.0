Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181E324D904
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 17:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgHUPq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 11:46:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725828AbgHUPq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 11:46:26 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07LFjXdk009503;
        Fri, 21 Aug 2020 08:46:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qy8eyuKSDqRkkp6Siw8XdjEsivmY+/4nPZZ4JrzUznI=;
 b=P/axgW8NDTo8xQJ71UYaeHUaf/PNBRPzeYuWzL+gAXaaTB/iKCfjY5P4v9PHMuXQ7GC5
 qeE6tGCboUaUEoYQNDuWWxmOPF6B1ViYHJrj8u16HsMUgByrmS3RRefBasKSdph/w2oN
 0SrBWuUOAB0O4Ii8HouCLw+suv601Qmumqw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331d50t96d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Aug 2020 08:46:12 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 21 Aug 2020 08:46:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6TKONwRGLKNr1dP/N4GcW15chJu+reBhPpD3t+1zymCl9mzEJ8GYKTYMEc0HW4slbIi+zapaiOAtsAofa1JoIXpEk2SGDsCG4YbVUoLEcyRzpmdz4xnX40zBFegRPfQgxARIfNdHUhTiyZc4Wdzjpq0FilBJSjbZDtYL7Qtxnroybqb3glJzIT5Gy4wFOn8nKJi7EjfarWreaFi3g092YeayfqwT80jEkh6+Ujv0Yn8uWduXV5PlOR4FCRlrhYS3wbA6vXZLzmB1aqwWWs8bvvu/g355bAAj28Q3wbj3cBpJVAWkrH4mA1aiH2tRR0IIgevWa+qnnG4yFuX3CXJEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qy8eyuKSDqRkkp6Siw8XdjEsivmY+/4nPZZ4JrzUznI=;
 b=Hdy87Sdp8vfAZ2EPIOrUN5z/linRNRc1dNdsZ6AhhmbOmEr6Xh3ORbY6ewR8g2T008YavR8mrVaqo4vt6/sKcEd5PKQScuFLKvmw8752JxYUiqJav8qW8/5IgvGRnYXjnTQRxRbjbGRFN8ZJPUFZ95mRUrFFPNwnX1xEzoJ1+RjHcH825op7FufUleY0D4PNpeWKfJQPsCHw+eqatSrlsDCy/JJc9+uMsluibgNra98a+FC8PK2C6Yt+WC4oN0n/FSiEGCL5SeT6yDaXHdo7uG+IrgYHfRUzlnMcQEv5sg2CwvafaOsQjPvzLVV+Oi06nfUyIKREWMvqt5zVw7ztbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qy8eyuKSDqRkkp6Siw8XdjEsivmY+/4nPZZ4JrzUznI=;
 b=C5OdQn0irLIiP4Pby+cUNriTsn3yo+JFpoYYtyVlNEU4shz/mfCGCYLWsJKBlWWKkeisTG1JG5jww7vMW7jHoHenskYkwT3+dnOSY5A53yt4QwmKmM94YNqdVaasI68W3EyZ1h8JOm6vFoMxaKKMox7R4CT5YIT6wekiMCVklXk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3046.namprd15.prod.outlook.com (2603:10b6:a03:fa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 15:46:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 15:46:09 +0000
Subject: Re: [PATCH bpf-next v3 4/6] bpf: override the meaning of
 ARG_PTR_TO_MAP_VALUE for sockmap and sockhash
To:     Lorenz Bauer <lmb@cloudflare.com>, <jakub@cloudflare.com>,
        <john.fastabend@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     <kernel-team@cloudflare.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200821102948.21918-1-lmb@cloudflare.com>
 <20200821102948.21918-5-lmb@cloudflare.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <f140db9b-ed23-7e56-e5b9-d90caf6493cb@fb.com>
Date:   Fri, 21 Aug 2020 08:46:05 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821102948.21918-5-lmb@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:208:257::11) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BL1PR13CA0036.namprd13.prod.outlook.com (2603:10b6:208:257::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.10 via Frontend Transport; Fri, 21 Aug 2020 15:46:07 +0000
X-Originating-IP: [2620:10d:c091:480::1:8c09]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9afca455-4227-40ca-021a-08d845e952f5
X-MS-TrafficTypeDiagnostic: BYAPR15MB3046:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3046E096E62B2AE9A9EE014ED35B0@BYAPR15MB3046.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7rTlbuhdhUxNjZWC43ECzLb1dOs2Fo9822q/hCODA2JkohEMrT7m/JYIO/GIXZZkjsrKDTeblVGTNwrUyKjOrMO+n47e+pDeTj/sQ6mI129vvdWalm/DEZ3Fe3KdMyoYj+44UVLkLkWP0075paSGdVz7c0GBYFUUXWMPcpjlzTJDVvMu8zmXvEPs3Qe9CJBRA7HirlIc6C84ci5SxFCguacY8bl4awjXycheipqeuS+UOCgB66rP4kwlTf7TU8/Ib/JB8nUuR0POCMGFWS/a7ZZflELjIZAE1fLon94rz1mipK1I9JQd8M6RnL0gGmPKS5PMKexGJPqI6p0xKWsbGSodcpMFgN+A1PYemXrYWsVBO59PAiwvkryD/FwnmkgZ9E51ii3/5Tz3k3j12W7uvU6fRffDa1FlPIh6h62MOWg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(396003)(136003)(346002)(478600001)(66476007)(4326008)(186003)(36756003)(8936002)(16576012)(5660300002)(110136005)(8676002)(52116002)(2616005)(31686004)(956004)(110011004)(316002)(83380400001)(66946007)(31696002)(6486002)(2906002)(66556008)(86362001)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X8leT9dd/Ep/X7grllCxKIMKBJ6fRDDO1szTKhlXW6TbSJrXrPzWoyVUL+uP2AOirMO38C+QXveUMxPLGC4cDIp6k9Jw/BWpKghNEEu+i33Zlo+Oy5dXP6749iivyb08xBIbkSwGPT896RdpBw47A6xyLrhLSfv2M+k5MEkm0PvyVHxH5BvHUg8N3fU7tzwBtRcvV8TyE2tdqgN40UrrWd5qv+lApCmomVvMjJWINvGOAwM+JGmSP/nlMOIiENGulo+E5WrrkyK7h+USq/isLuc3IfQ6CrRoxyKcLNgWa4ZMJsDAFlZ8d50yXRvj+bzOkCw32SN4fmvG37q6AGXZRB1X7s3Y4uYdXCdVgc5TRGMmM7iQM9s6h368JP/aHvGG7L8TXtNSZc09K72O5cWU/k+IVURmmVJ834Zr0IfGPhYVkVA2pMgA47v2LlvDNT/h9cIAWP/DzoNFXR01VRhP5ueEndDJUCmRK8rpeSJ1G9WjpSDMWGwtMjTFhINq/NbWkYNr/C04TfgBis9xcimzjC4nq0O2V4xHRc4FvQVvKeH7LOfN/5b0LpNpuB9QmhboZfh00OOm50QfTGqVLLlp+KmlId3RLwMiUhX1IsPQxk9nAt/ZDvDwzM1D5y2TjJu6nOGuOCozDLXlXPPzlVOjGATHNTFpnYPsEqlaFstwfQRie9ESvS0UrcETA4Cfmr40
X-MS-Exchange-CrossTenant-Network-Message-Id: 9afca455-4227-40ca-021a-08d845e952f5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 15:46:09.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IS+mQUTi+bi7CVLndCtFptqOB8fnqDsCd7EQYyjLzZiTNkGRPyUDBhW/Y9E0a0Lq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3046
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_08:2020-08-21,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 mlxlogscore=545 priorityscore=1501 impostorscore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008210147
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 3:29 AM, Lorenz Bauer wrote:
> The verifier assumes that map values are simple blobs of memory, and
> therefore treats ARG_PTR_TO_MAP_VALUE, etc. as such. However, there are
> map types where this isn't true. For example, sockmap and sockhash store
> sockets. In general this isn't a big problem: we can just
> write helpers that explicitly requests PTR_TO_SOCKET instead of
> ARG_PTR_TO_MAP_VALUE.
> 
> The one exception are the standard map helpers like map_update_elem,
> map_lookup_elem, etc. Here it would be nice we could overload the
> function prototype for different kinds of maps. Unfortunately, this
> isn't entirely straight forward:
> We only know the type of the map once we have resolved meta->map_ptr
> in check_func_arg. This means we can't swap out the prototype
> in check_helper_call until we're half way through the function.
> 
> Instead, modify check_func_arg to treat ARG_PTR_TO_MAP_VALUE to
> mean "the native type for the map" instead of "pointer to memory"
> for sockmap and sockhash. This means we don't have to modify the
> function prototype at all
> 
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>

Acked-by: Yonghong Song <yhs@fb.com>
