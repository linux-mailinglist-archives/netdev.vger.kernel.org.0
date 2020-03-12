Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C156183D74
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgCLXjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:39:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18778 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726608AbgCLXjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 19:39:04 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CNaoku014777;
        Thu, 12 Mar 2020 16:38:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8hufbajWR+SCjfQbqkT45Kp088fZgG2VzsRCQYrq+EE=;
 b=OQkirP7OspfOyN1AefpdKxO5ervTjb8Fl2ajaOxtUicOO0GtDufM3DOFigtPWXkSH3fi
 DSpqqammcqsGKNMa2ONsXkUE7AV5bwMuSBe1VqMsKuyI4hfoTkYM+6x7uLrztne84BSc
 fa2FCDlY8rA0KWLO63Aexcw/5zlhA+APNYg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80sdxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Mar 2020 16:38:50 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 12 Mar 2020 16:38:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2z4ShF7UNekPaiVQc4uam8VCwwzdcr32vEyd1UOM9+YwMLr9HdopGfO/cdP7fyzLn2bUD9AMcaMmqTGPGDQYEtWDiZB5bHZLkEFfb0uXpdQdGaz0Mab7t1gZe2zIUSaCJRQ6R2buua71TQEHcmlzGTKoXCpB3V5o3J4R7mCwTSXe6axmj56ACMWDeOqSj3wAdkcIU2haM3cCIUiip8MsYdGfgh36APB1lSr6/PHpuzghbnvGKxcYxsWE5n3WjBpTsXaTWhu9WTGW2dRbuBW3414LYojCs46OkV2XiFjnJJcZLcoSOXIeDw+3sjmxHeqE4mq7jK9osugunM+xUOUtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hufbajWR+SCjfQbqkT45Kp088fZgG2VzsRCQYrq+EE=;
 b=CJcvdipstU6TXgVvVlY/nbkZ0RSs0IM22TiMNHQlI2k2x1SkHNKyqDZw/VMM4WQmec55Hg8qvNgYddkW8I1E5dN3SAHubb3T6t10sLmEqKLwQlHr+AKEhdyv8ZKp+iLX7iVVerRo1ndmerD05l/icmBrfa45mccjxVfMDMju7/r1ZYwLsYvGxC2mIfE4hlrbsaGWUhCVDiUosYdlOfTfXr7Z7xGwSGF65afo1zetjPFdNzQXnG+gEUnZWrPWmWvtvBQyXFpbQVziWMEhlNMCV39lfZgxcwTWnS+ku0htEIGzIxgQkzmWbmQPrXaaPcUOJHeaQLE5qDEgqkwNnyqPCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8hufbajWR+SCjfQbqkT45Kp088fZgG2VzsRCQYrq+EE=;
 b=QhiVpRZtYWlWegnqJI6Pr+3H49kb/8kDnB20v4xHgGO4LdyrFlObbNsDMQ4Et4DzHuSdO2bhepqoDR6Hogq/vNYFabxy27OmpeTt+IEQ2yxAJ+zz7qYGQnBFrROENzj2/l+Dj+qOamO1sT5eebkqxGgu+suAzMPULa/uGPH6pCQ=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2439.namprd15.prod.outlook.com (2603:10b6:a02:8e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Thu, 12 Mar
 2020 23:38:47 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:38:47 +0000
Date:   Thu, 12 Mar 2020 16:38:45 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: abstract away entire bpf_link clean up
 procedure
Message-ID: <20200312233845.oehxavap4aapofst@kafai-mbp>
References: <20200312203914.1195762-1-andriin@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312203914.1195762-1-andriin@fb.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR13CA0044.namprd13.prod.outlook.com
 (2603:10b6:300:95::30) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:fd85) by MWHPR13CA0044.namprd13.prod.outlook.com (2603:10b6:300:95::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.7 via Frontend Transport; Thu, 12 Mar 2020 23:38:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:fd85]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ca3d863-f924-488b-361c-08d7c6de82bf
X-MS-TrafficTypeDiagnostic: BYAPR15MB2439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2439F93B002A3CEC2F7FF843D5FD0@BYAPR15MB2439.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(376002)(366004)(346002)(136003)(199004)(4744005)(8936002)(316002)(6496006)(52116002)(478600001)(5660300002)(1076003)(55016002)(9686003)(33716001)(2906002)(6862004)(6636002)(66476007)(66946007)(8676002)(66556008)(81156014)(81166006)(186003)(16526019)(86362001)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2439;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EiOaNE7bu2ZqHqnnHbchp19faDumhd+ayJTLvzRLhEpq6gSLUrJWXm5QA6zpQu6t4PtrMFMq1dHR+ZnB27sGGbxW08ruRTtKDJT1xc+a3TDxNerfHNdCewVEz6CTXXWiZ+T/PWs6Xu5YovC4SpyXFsosZl2pFQdyBTGEVqXiGBBYXPWHkd4zKK2lgver3x7mYX/YCTv3o4Y+Dtm0NxBI8J7hOec0XKcN+8qT3AyoZaxJlog8uioif0bh8qgnIkOqEkO7LKQ/v7zFAHzSl8tzWkY5ZbY3/otlaQQw/AkkjylH8LLhW632BKKFEpXdQcAEXENK9CSClT9AnZiSMXNL1UatQGdvBSsld654f5NySxYljSu8vYIxfCEXe4YL2XuQtfPzAm1K0F17sE9ZwYlWEoNla78tuTwDeVVHd3YM9+DfmeQVKDhmWJdO+NoevzIW
X-MS-Exchange-AntiSpam-MessageData: 4igX+qSGVIeYXZSbeIqt7q0tbujA2wgXaUSOJslOErHQXG7Bsissfo7NpvaES++MbbxOIvRy2w0ldtksXNJdyoCt7EGvoJwkTc0DyeL4idnokf+QBEs1EZXMJDrkd55hCbqQ3bF9jS1UIfdHcnNruAIHEdyktJyDX7G7Q/guWHVO0X6nIOskn/+5AtNT7cQC
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca3d863-f924-488b-361c-08d7c6de82bf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:38:47.7271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNv/l4/p2gzUFDMHMXr3Dz3RvqP6oRoB8sW7Yz4xgFcgNm/lCkGfpUoa3kooyCeE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2439
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_18:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=493 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003120117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 12, 2020 at 01:39:14PM -0700, Andrii Nakryiko wrote:
> Instead of requiring users to do three steps for cleaning up bpf_link, its
> anon_inode file, and unused fd, abstract that away into bpf_link_cleanup()
> helper. bpf_link_defunct() is removed, as it shouldn't be needed as an
> individual operation anymore.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf.h  |  3 ++-
>  kernel/bpf/syscall.c | 18 +++++++++++-------
Changes are only in syscall.c.  Should bpf_link_cleanup() be static?
