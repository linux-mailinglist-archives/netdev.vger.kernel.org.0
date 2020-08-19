Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C431249280
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 03:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHSBnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 21:43:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7004 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726367AbgHSBnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 21:43:00 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07J1eADA004781;
        Tue, 18 Aug 2020 18:42:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TMA6lbxpOgWh0l8DBEg2DoGwGcC310tq0E4OlReHxeU=;
 b=IW9OsbmkyzN5rlh4OlEtUsuH7tGLcoDFIGflq4ypGG3uTfWoR1dtxCpoq3c8KoGF0q4g
 vHI56CVRQkDsXVsUM2r9jiNHuI2GndhZ4A56nE21rGcGldcukgi3C3rTEckw2TZ6HfaP
 qtWcv6ewZT16+/1d5AZAUNhKyDyOrRiaWH4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3304jbe4mv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Aug 2020 18:42:48 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 18:42:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml0rYXOgogZP69IFZYfytsUifNRMOxdZAQ8KJNGfrNsMiTX6fL3Vrcuu59IzNtyPstVXeM/yQ2uXEPI84nJ5TF9zPry8OiWfsUhzOFMy2gAfF/xrEhojVSW1/WcABdQRyyG7SvvltWEAv4hUpuyflN22xYXmaL2D59bys5fzlhn46tfwbkGxTIBMMnqMZV7bJWMjBFJ5ia/Wd9E5TH3dUeWgJzOQYy7NMZAiMsgRIs6bYzUykgqFlb6CxxwrSPrfdB6Dz/UlOsU2YFIEPwV9632CuoJQeSuaFP3jJupbe5Iy15dzXrz9uF36tACnQoMheUBPHAsQYbwCsvbyo+LeUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMA6lbxpOgWh0l8DBEg2DoGwGcC310tq0E4OlReHxeU=;
 b=EyCh4MEqEKfZsq90xkEaqOwAKrXd/D0nbjHARK3zqnikcbmwhntmUatllVfGcLtyPyj2YlqR06Q+2XoY0De+vjjqKB46aWgN4kQKqm5gmGH8C6Vz1h0jIjLdQGyAPP9H1FkrQtEG0N2YoyU+30c9phGUmzXEPCdkWWrB4gSt5s/SVucNCl9XgwyNSieSsMqhwq47OBUdfm54hWo00xT1I1WlfEKg05J2iTVJw9+4IfCszryfT1iD7O1Pfhd6W5LwXlE87B0kn1buhI3woyUhHCSl5QLE/PiFNTkq2Fn+qIidY88XeTpkSI4Uneev7dwN1pdJPy3wEnbuf9y1KsUSTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMA6lbxpOgWh0l8DBEg2DoGwGcC310tq0E4OlReHxeU=;
 b=EgZ00/ZuAI2A9Qi8xbLcauw0vu5YeQCk7T8R0fnmvQGfVvz+8mhuJNSx3chUwn5IKmqcLamD1zEAU+f175ytyYVvZ/cxYXsnDoF6jmfwcvsXQnIBCaVBmE3Kxiq8oaLOxIfaz3aYVbWZMegok8M0fZx2d+mHHFWBX08mEzwXhGI=
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3948.namprd15.prod.outlook.com (2603:10b6:303:4b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Wed, 19 Aug
 2020 01:42:46 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::6db3:9f8b:6fd6:9446%3]) with mapi id 15.20.3283.028; Wed, 19 Aug 2020
 01:42:46 +0000
Subject: Re: [PATCH v3 bpf-next 0/4] libbpf: minimize feature detection
 (reallocarray, libelf-mmap)
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>
References: <20200819013607.3607269-1-andriin@fb.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <0cca0a66-3676-1176-6c89-c50be43bc6d3@fb.com>
Date:   Tue, 18 Aug 2020 18:42:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200819013607.3607269-1-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::21) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103::16b] (2620:10d:c090:400::5:20fd) by BYAPR03CA0008.namprd03.prod.outlook.com (2603:10b6:a02:a8::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Wed, 19 Aug 2020 01:42:45 +0000
X-Originating-IP: [2620:10d:c090:400::5:20fd]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ac0003c-fd89-478d-62d0-08d843e12bf6
X-MS-TrafficTypeDiagnostic: MW3PR15MB3948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3948D91AA16E9989BF8BA34ED75D0@MW3PR15MB3948.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g/21q8sGMesXOKOL9wvCshvngk/dPW83x0eHSLezjBSkilTwsJEhmsa+HDLvn+oYEaHMiiwH6kZ8r+i7rIEuw3CKzweBTluA4+Acil6vkkX1FWoUNJJ5OxTln79vzkURHvFKRy8eYp3nHYJ1jqcMftKJEd1zdr349P0C6oxydw0MBPQu4uk9sn5B04lj5WAC+ngnhFv6riMmu7g3tT5cteyvIhVLqWq+FzmPSJUSDunRz+0uBqPQenJmCK4nMSDDG02pRziOwWQVaIibzS7Sc1glBOkLhlOJsjoWgsZ1WouK/fNoD6zWjxBsFzrVIKUmhKDXDIb3aZwfCN5BO+iuSYk+Z+Hln9RAlG3djPxRPBFMEGMNB8J29BFKShcEkmDK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(52116002)(36756003)(478600001)(8676002)(4326008)(53546011)(6486002)(86362001)(66556008)(31696002)(66476007)(66946007)(316002)(83380400001)(2906002)(8936002)(16526019)(186003)(5660300002)(31686004)(4744005)(2616005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nduQPzmy3MJGXYLBi/s8lCjZ/ZO5Zus7ZjahFqNT3eZLclfC8FuDV4OMby46nPWggWZoGn2Y18WCW/+y0uJJ7reMorJErptDKDqKVG1l1PvfHZlQClM8eyzmAINaYOPU5slGcKt9ZCB0yLrWzDZyLfJUxKm4wq70PakxqNeja5HKAgJTNrZq3fAanrg29cZ+GpgPpRMTvPPzxxwtfuDXh4xIqiQzEEkKF2zEtdQBrLWk7y67ZEq7+4xm1zdakddxILVoU+Ac2D96QvtXvCmKzqm5MOtnnqnX6Hj3diPTRBOOCffs+fQX3+wr2CstfuO6NBXlX5GD625l0dDuMHQJY4hzfB+DmnLXej2Sdo1okc2G5WHOPclMAOEKVxum1dIF1cJHLdvoH0LyhwOPx57CD2mS2wDDJgaj+p4Qu1cyjh236KBUDIZFcs8ylfKW5EmeKG8kdEXNWTlCrPG3uEpTySuiPFhEj3kgGC9ySvcDq2GUhpKJd2i9TtsLTx7uyCDGqYq1bo+KSWjyURlDtrzBAdPjzAhsG4cn9Pmlrj66qS3JWpq2U5vktqsRLl8lJrViOfu9bRL8kX4T3FcYYBj8JfEyT2+eGPrhIklVIvj/MPVUMBdJYNrTbiLr8Jt9LoSU74gU24QBRUXhuITra1Bg5A0Ja1VlZs6IV6zz0VtstZE=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac0003c-fd89-478d-62d0-08d843e12bf6
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2020 01:42:45.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oD/oM/WSi3H49phZ+dpBTX5uJrqdiQ0tq/t6qVC1jPXdOzAay0e4dcVFZT/9q+nh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3948
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008190014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/20 6:36 PM, Andrii Nakryiko wrote:
> Get rid of two feature detectors: reallocarray and libelf-mmap. Optional
> feature detections complicate libbpf Makefile and cause more troubles for
> various applications that want to integrate libbpf as part of their build.
> 
> Patch #1 replaces all reallocarray() uses into libbpf-internal reallocarray()
> implementation. Patches #2 and #3 makes sure we won't re-introduce
> reallocarray() accidentally. Patch #2 also removes last use of
> libbpf_internal.h header inside bpftool. There is still nlattr.h that's used
> by both libbpf and bpftool, but that's left for a follow up patch to split.
> Patch #4 removed libelf-mmap feature detector and all its uses, as it's
> trivial to handle missing mmap support in libbpf, the way objtool has been
> doing it for a while.
> 
> v1->v2 and v2->v3:
>    - rebase to latest bpf-next (Alexei).

Applied. Thanks
