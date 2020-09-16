Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526DE26E033
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgIQQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:03:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36820 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728278AbgIQQBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:01:48 -0400
Received: from pps.filterd (m0042983.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HFPfv9001453;
        Thu, 17 Sep 2020 08:37:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=GT8vEKOaHtcIs+WE7PO4+9KfvhnFBUXyBqd0ZSPge/o=;
 b=UeqI0PKsebjd/7HCvBNwEzo6eo/unXdJn78sv/FDCTwdsiZskQvKqaIrWfZ6G8IaoFu6
 BmYZwPtwcJIR1VDgFB6cRV2SERJD9l0fz2eyossGJtjUHEB0kc0TSV3E7nDQ53vm5IT7
 qfID+LXThElfEcKLgJnWTBomRnInUoyeq6A= 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00082601.pphosted.com with ESMTP id 33m9wg8f09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Sep 2020 08:37:21 -0700
Received: from pps.reinject (m0042983.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HFbI1C026278;
        Thu, 17 Sep 2020 08:37:20 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5nbpq0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Sep 2020 16:00:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 16:00:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1iWAKvLDaU0RDfV9f1eaLYxcDIwVOxEGe2G1fP8HzhXSh6/leQJSPOR5mkrpE7CgZHhOjROZVnVQ7otF57mRxGdlxee6magluFCuwkOCrC10j4icB/FZQhHTstaShUtA/i3O6w4dq6yhqA7RJRtj4KMI8+p3t0vHhw6jkyh04Tv2mlVlcA1EO7AB8QMfL4vZrGqDU7KGnk/X4FqD+S0ig9S517YbqiSbiJQXUxf/miRJINKiy7JWgfsIPSiMzsTyXWs2mwlyQxzwz/HjkJ+QwE/8PAitiz4DtziXgAXqey4gSmkIxKqalYfp17oiQJOkt/1I2opSUxq14JOfsY29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GT8vEKOaHtcIs+WE7PO4+9KfvhnFBUXyBqd0ZSPge/o=;
 b=JDtBdjl+ZFtKe+vNTL10ETlRjnbgYi8qUgacnePvlIaNiBrpFMGrPKfEVjl0LsYckrsVNyZuXzWSmvXeVNPB7McgQ6RTfK+lmMo45dajSyjHIEMMZuDoOdyCh3yUgp6QKwLGH5EaibZmHewiIu2yha0KgyrYyeqBGzJNN3GZU1Trqb2I3K1BYAQyLuPZLw+XL55XEo194X++v3VW8AxDGTGvq98MyZ2FG0kSIWq5JMBzR4lghEknb+6cZtLybrq6F4ZZb6ERTsgsjyH0/bLiAt9n5Mz1WG4DKFDaunCKp+Vn3FiSPGmTy5zt41vJ/g4K4TqNTrddiKShb4f7j0zCWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GT8vEKOaHtcIs+WE7PO4+9KfvhnFBUXyBqd0ZSPge/o=;
 b=krmnwcTaWGQTkffegtS0KFzcH7UYl9TZezNi9bvkuLZPmRrGxiaj2qnkvpmnYnxzCxhqhFvIDXk2GPaZOw9FEoQymbXbaaueXXQhtOpGIQZRY986fOesRMKmp3k07BnDPgONzw7W4cgbfs9psuf8mK+lBa9zkMJP3eE7lMYO3ls=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 16 Sep
 2020 23:00:51 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3391.011; Wed, 16 Sep 2020
 23:00:51 +0000
Date:   Wed, 16 Sep 2020 16:00:45 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Yonghong Song <yhs@fb.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH bpf-next v4] bpf: using rcu_read_lock for
 bpf_sk_storage_map iterator
Message-ID: <20200916230045.b6ofgnbibwealhiz@kafai-mbp>
References: <20200916224645.720172-1-yhs@fb.com>
In-Reply-To: <20200916224645.720172-1-yhs@fb.com>
X-ClientProxiedBy: MWHPR17CA0064.namprd17.prod.outlook.com
 (2603:10b6:300:93::26) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2074) by MWHPR17CA0064.namprd17.prod.outlook.com (2603:10b6:300:93::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Wed, 16 Sep 2020 23:00:50 +0000
X-Originating-IP: [2620:10d:c090:400::5:2074]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dffc3f2b-f43a-4fae-ee3d-08d85a945ba3
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2453084B1303C18A397BF97ED5210@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nfA4kyvTy66G4QNzQ8qDCXrZSyzFKfVWx0ViyV9hSq8fp3bA3sCgN0fuZjFgOEV/Upjj5Q1s+COOcJCdOITiYfO8plSCLSC80MOP66iAElGyHheB1kEM/zdkkbyViZFHG7xu40s7tVgJQCTJHF8Fj5eGegnVa+pOHM/xvy4rWIYRv5llyPhDzD6WjgAPFtNhWwO41teIOZYnk3YXa1C5zVC4CEd66IFZEg28pKkrNKnUExgu0yXqNuwCho4sysTnxwHPouWA9o79CuoojWvBv4MubjUVUDQUt/z7QmP4x8tmntP7G5c96fogjPe5AmzB/b00dBkmghtQhwfxKaVi6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(376002)(346002)(66556008)(66476007)(66946007)(55016002)(5660300002)(186003)(16526019)(83380400001)(9686003)(6496006)(8936002)(52116002)(2906002)(33716001)(478600001)(6862004)(316002)(54906003)(8676002)(4326008)(86362001)(1076003)(6666004)(6636002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VIHKEgh0hiCubri8aRa2cjgIMLjqkKZs1DLNNWpqpNUUPsGcuR/ILdvu2h52uzDOk1lOVUhmUG4ONssVQDqWm6xDcTlsvhN53wa0qqDSv4YAAFs6QZAjabSh/+OPUI5qprp/WTTaKItsSO+zhDsXTMXnzijttk1lsbc3sT0e4Km1MiefEOI2fYsZBOW+SooRYO1uc0xt/BVP+pM01XMtNzUVXlo3vKF2dEEfyQzI2tBKNU/vc1yj/cWw2wsgKKNJU0S0YcOI7PVvXEqYPvGKNnsT4ygNfhpt/6QWGkdmdeap8657H5yUHLk4AIXvIapMW8wmu2sqNPKt0UPqZQsFqLcVesa0CATlrrAmUt4jNOIj0nwSDZ6QVfmC7y2p03TXAX1J8e+WvdYC+N0rt8OYnLQ20XWKv2siCNE90l8wXK7TUSNowMfZ7seq9pz2rrFuy0pw3oxYBdQ/gqTfJgB6d5sHmSO4R4l6yQX7blVHEZt01UAkDwAHRt0aJL18IxrgvNkNvtXKjHjX4Cj4oL5O7kXZiRL+l5czmwY4UbOHaBzrWWvSafCBJ5ECdt1NfNPqFBG4/UPHA0fRY12TOdmWn8lxrcXwW4goiZF14zOE/9srjXcPjOC+ekVL/ih6h1aGGGzXjFkBDBjK6kyWyxgSLEv+1kHI6ezOOPXRHPGkjW+QH7iVRd9UZYdc069FWbGg
X-MS-Exchange-CrossTenant-Network-Message-Id: dffc3f2b-f43a-4fae-ee3d-08d85a945ba3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 23:00:51.4303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rpvf8MpTPdshJEPIntxWierYMlQzhF2tosUSEyM8gf2j5ZTQl2jHvBM2z6rY6bIO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_13:2020-09-16,2020-09-16 signatures=0
X-FB-Internal: deliver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_10:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=718 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=1 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.12.0-2006250000 definitions=main-2009170119
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 03:46:45PM -0700, Yonghong Song wrote:
> If a bucket contains a lot of sockets, during bpf_iter traversing
> a bucket, concurrent userspace bpf_map_update_elem() and
> bpf program bpf_sk_storage_{get,delete}() may experience
> some undesirable delays as they will compete with bpf_iter
> for bucket lock.
> 
> Note that the number of buckets for bpf_sk_storage_map
> is roughly the same as the number of cpus. So if there
> are lots of sockets in the system, each bucket could
> contain lots of sockets.
> 
> Different actual use cases may experience different delays.
> Here, using selftest bpf_iter subtest bpf_sk_storage_map,
> I hacked the kernel with ktime_get_mono_fast_ns()
> to collect the time when a bucket was locked
> during bpf_iter prog traversing that bucket. This way,
> the maximum incurred delay was measured w.r.t. the
> number of elements in a bucket.
>     # elems in each bucket          delay(ns)
>       64                            17000
>       256                           72512
>       2048                          875246
> 
> The potential delays will be further increased if
> we have even more elemnts in a bucket. Using rcu_read_lock()
> is a reasonable compromise here. It may lose some precision, e.g.,
> access stale sockets, but it will not hurt performance of
> bpf program or user space application which also tries
> to get/delete or update map elements.
Acked-by: Martin KaFai Lau <kafai@fb.com>
