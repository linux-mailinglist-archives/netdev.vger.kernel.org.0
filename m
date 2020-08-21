Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4518724CDE1
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgHUGTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:19:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19490 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725958AbgHUGTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:19:32 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07L6IQgv020225;
        Thu, 20 Aug 2020 23:19:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=qSaNSKJZDxeT1oqdi8e6Nh3ubGvTqmvuHlbHapoqzCQ=;
 b=PNZ8e/AIzqWRisUtaTSIl3MGObK6YBKO7Z1hEwIV0zTcfo352ngTGaHKJUeODBmSc16T
 P9Vzbe05QN9ox2BZQumy3sIC2dENyAtd099hJQU8ZaIGN+2WVIY0L95EUQuagiTKimTk
 0TnL26moKKVmiu3SEydoUnl0qvM/C4MRP6U= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjjrn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Aug 2020 23:19:28 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 23:19:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gbc6mH3x/Q3HaR6G75Vs6O6/KqH7iMrO3Dc6npC21x1n7pd2xGV58S93+iZ/hJ/MA8tuh/Eb3FqO+WaTPuYOVAC2mp4yxxzhbwy7lKZ545T2b/D2Ez2LQJoucNsqkGfPQulrZ5PLhTmolMn9PFei/sfL0aBju98pDZquaXnukOROotugwfk/OCkrtrUEcRtOSMFsublzWCN3Jw0Zj0hCXgtBHhMKsM+4BIJNhhwomIgUfuPwjFGxhRukdwb6H3L0XUbWibPohLx2/2/u/rF2HMRlYvkilQeMk3W8acwyNqoVI5AMMzcS5wyMvVFOWhyBL4vGLFZjr+noOcTZ0Z6XLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSaNSKJZDxeT1oqdi8e6Nh3ubGvTqmvuHlbHapoqzCQ=;
 b=B20MNuxNdCvGD3iuGPo+4wjNLxP17+s12vda4WT8H6QVImB6f35d/sTHTqsPwIVhB7inrlhjD4XCPdSrtSRLgyMQCl1tfS3m5tuueEpKn5PwhP2bObJK1lcI/0on49JlROPXi9tziOur6BNfpeCWg+2IackrebrA6cr/A2DGgki+YXxW/OMJaMODnUUbGRyKBhcZT+m3jJqhujMDtGSR0QJe/G2hMpfVC3qgrAfx072rrrvHvvhUlr6ONAn0MKEyvPC/S/RZ158du0zsvkLCe+GB+OmdwDbK6+L6I4XgZPiutbj8Y/kahSTMLx7xmjZmLk4m5FqX4IUcETBs8Wrj+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSaNSKJZDxeT1oqdi8e6Nh3ubGvTqmvuHlbHapoqzCQ=;
 b=gIw5doONKDu8jrhzz+bVHMq3ZCe58++eNylY0yru//L5OcenRfGhZv5hD0QDzWRjS+cQ7LQWe8JSn6ziwW9hvcDL7jUP5sxkWs67vChaQUvs6FmgW1eo3/vz2a0pGZ1MouN1PVC1Z5ub0VW0V06i+lGcXfQYG0nHNQu7WAq20XE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 21 Aug
 2020 06:19:25 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3305.026; Fri, 21 Aug 2020
 06:19:25 +0000
Subject: Re: [PATCH v2 bpf 2/2] selftests/bpf: add test for freplace program
 with write access
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200821002804.546826-1-udippant@fb.com>
 <20200821002804.546826-2-udippant@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <4b521b2a-a431-2ca1-46ab-a6ddba9e65cb@fb.com>
Date:   Thu, 20 Aug 2020 23:19:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <20200821002804.546826-2-udippant@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR07CA0011.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::21) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by MN2PR07CA0011.namprd07.prod.outlook.com (2603:10b6:208:1a0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Fri, 21 Aug 2020 06:19:23 +0000
X-Originating-IP: [2620:10d:c091:480::1:a192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36c5c61b-c33e-46f3-b795-08d8459a2722
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408724739C585DBF5358DDA1D35B0@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vcMuAfHk2F/8jPod4sDpuF3ndvIy4rQYhDDhAM2zF2y/hYWjgrTJH618uLai/q9Kz/6Zhd8bTNu2CGNnP6HYs3V0mOfjT2nkfwDhI2H9+SFqlbkoi+m4ygZQE56icvRstsw3lfA+r9GjqHDd33yQKDL8Ed413WRa0FTsTnwI7t/DuYT1/RAXHiPkhjarZxKKSVQxrseQz31E6Fq3lR2uKVOEY1HyX7FmuikJNdiTYJxmvkx+P8cpWd5v9tPgd5R+D5hpMZaaZ7zaP+7XsDzFaEGPs7AzdqWG/kgRP7PfGHl8IExVrX3WcU8jH7TPyNL383t7YQvA/QvEIgI+a6TB2FjKv96BfRyZfnzCrw6UccbxfwHU1ZX4a09HupaH2GDT1mk3wpuH0sD75OyDslzoww02O1ChVFC3arFezmC/c0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(376002)(39860400002)(66476007)(31696002)(66556008)(66946007)(2906002)(83380400001)(86362001)(53546011)(2616005)(5660300002)(36756003)(478600001)(6486002)(186003)(4326008)(956004)(52116002)(8676002)(31686004)(316002)(4744005)(110136005)(8936002)(16576012)(110011004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: x+fyUVXUYcoi+jrF6eeNJbPjPfQOgENvhovLLoyfjxUf2ZzQ634cvod3kKHZSgx19YjVjfnDE5WH+tfdtMd1C6/r+pCJfDoEir14tqMpnpK3STuSk1lXnYiEt+fYgorsn1AdU7GjDGJXAeTklkgVyLBluZ5CHuUXa/8yfuKVnRoITWJMdXEjYV1HOW4UQvtVrIJyr9etrAw66bnJkFB+tVFRWOYSzkGUZd/3aHJXkZu7dQW4lIsAf4PioxbOqrDVc/uiJaz5U86FICRFRcjYOtzb70IFFKAyLFiUYlbiKDy/cCydUQJi4fFDSkbtdge/FoRP46lC6bdyUjP0/Jv+dHZOq8qD2rNUIg3XQQj32Z2mTZeb9DWRlLwC3EOAD4dOMgSboNDQfrhIZtl1A4b3btQa0qFyC7vILFMtyg2YZxPohN0dCxrZxA3WSmRoak/fUOB6RIy7Ua0etJDqehBmc1aLVX/WtQ9JDciIsEsgTZy9FKt52LCTY6BtFVkwYfESg4eo0ER/yk2iYKj8OORGPu6MKDQSFBvPj3bwo7tp+ybV7MXAf/4NA7wZqS1abO/K+vA3rKIkzy/JqNkXd9UdXPkUdJhe6nw4RaGrDZjQNzlGKiRqVpaWKHO43f6Iuu38HjsqOdkcNDpNBZy5rR4IkDzv52SyXq3d91BXPRvuKrlV0H1wdR0asMyA/yy96zrX
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c5c61b-c33e-46f3-b795-08d8459a2722
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2020 06:19:25.8830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Wz5jOJl4HPLdq9ZWVDKYvzVALWpqnuaYAIJ/FIE4NM4rb6b96hgImGWgW8O/rrY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-21_05:2020-08-19,2020-08-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008210060
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 5:28 PM, Udip Pant wrote:
> This adds a selftest that tests the behavior when a freplace target program
> attempts to make a write access on a packet. The expectation is that the read or write
> access is granted based on the program type of the linked program and
> not itself (which is of type, for e.g., BPF_PROG_TYPE_EXT).
> 
> This test fails without the associated patch on the verifier.
> 
> Signed-off-by: Udip Pant <udippant@fb.com>
> ---

Acked-by: Yonghong Song <yhs@fb.com>
