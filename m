Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B427F08C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 19:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731287AbgI3Rbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 13:31:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47820 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3Rbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 13:31:31 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UHU2QW027351;
        Wed, 30 Sep 2020 10:31:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=SfPotk7hP7wczW0zslE5SkNuqexegOoapGhu33e1C+4=;
 b=mv5dBagwEkw2rzo3X5Xo29AvjYtNiMzQZh0269YeRF3OsoTvkMtiAhdtrBpNKlWYs/ds
 9Tv8rplhMu44FdLVnLDqh4fGsc+wKaq9Wtf/VA3BB9PHpcmH42EANEU7xwg6M/Z+FD6F
 99CJQpASy60JFAGV5d+OnFhJ7yJzL055dD4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33vtgc1h0v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 30 Sep 2020 10:31:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 30 Sep 2020 10:31:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmZUxWu9zobechYJVXfRnevBnOFkHX8Ev2+NewiOIKsAhcKFZTcESdNV8wR07J9WiZwbN6r7oQCZO6IgosT9EbmlyRYsQY0kltyIR8B8JdkzVyrkuzIO2dWVIsorvI1cjq3xKZblblYnIeYEoPGVdXNfin7Skd0Jx+GZd4LUJZrf8EqCsrtTzosWCqNdsN0gis/e0Bw7RUQwgltRQ2BW3rVxd0Q/kXGWOyBrvEXprAXrhKz2DTlVj0oYYTvflRyo5zkSUI5o2T8F8mQcJezFLbAYWi9unLnt3Ibe1cbrW6uqjz7vGB3vF/79J1o+JPX5rDqUv5J3nyIFRe7Kij/71g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfPotk7hP7wczW0zslE5SkNuqexegOoapGhu33e1C+4=;
 b=kyBbxmkYeKZyD/wgoEBJQQSID0WKjyCCY8svZUMDfZArhH7fXqlMaegCkTHEFZti25MWUF8IXYNHIz7jSWJalEohFnF3hayEIxaRbWjruNwbiCEYSndEQEe3gK7LXz/uXBseiRVKmfxhLRQquHCmvmRG2fZRlP3rxyOlNiMl/4Iq6gRanomADCQckm6fGx5DaL4AYUQm4fpB7ycTZvHhv5IcijRxfEEY65fhANV25SziKD7F5ANc6fpGZkNAgsGURyCw6JDikkf4+asfzq4nXwQm6xPj2r+CyyOo/6wqmku/3W1kBrja4MM3WcMG03Px+mMiXnZIyYcV4DSmYVe6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfPotk7hP7wczW0zslE5SkNuqexegOoapGhu33e1C+4=;
 b=Xk42sQvM+f3oVyFGfwL7F0vSjXu1J78iAm0M2Q/IAPoE3K+ABBla/wDPiGrHXK0m/iz/9jUV/MMVZtOUwpHFj7wBQad4CQIqeMKd6Tpt6M0yZZhbyZUCWzZZdlv2+RtfvndXEietjFq73JFb2mPQVJGwUBwOMcDnAh5YZALhEm8=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 17:31:13 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 17:31:13 +0000
Date:   Wed, 30 Sep 2020 10:31:07 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 6/6] bpf, selftests: add redirect_neigh
 selftest
Message-ID: <20200930173107.ihuxxbmc4sby3vce@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1601477936.git.daniel@iogearbox.net>
 <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc7d9c5f9a6cc1c65b0d3be83b44b1ec9889f43.1601477936.git.daniel@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: MWHPR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:300:6c::29) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by MWHPR04CA0067.namprd04.prod.outlook.com (2603:10b6:300:6c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Wed, 30 Sep 2020 17:31:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc9eed69-7316-47d2-d25c-08d86566a0ec
X-MS-TrafficTypeDiagnostic: BYAPR15MB4119:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4119363A9D8EB756F7B1601DD5330@BYAPR15MB4119.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vezzL5f9XKCqPioAKpHW4NdONL3Xyql+/Ru3AZ6gZM9Jic/yu1mTseTBWsYHQwMSe7zjXUIt34JfSqKphKt3ilEtwdwoI2+aq4KvOMtBZm8LmmQRXa7kreff1uAzpnRG5C98Q6LXx58M/qb3dcsEKHGtZWbdKE0ApZmKjFZ/1Or+7UYOTq48tLNQ7WnPKkhm41bkuBNgtZ9xamP6WC5EKnyvv2xq1eBt8ngk/M3fXI7thZgpfDnknYevQYOVKRqRI9miRIl6TWGDNWfyzl1XgCrsXT/EjwkfnV67IuqsJiay/rEmRv0Q/Am6Xv3Yl2jOh8WXgA1zxTd0qpS682I8KQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(4326008)(9686003)(2906002)(8936002)(55016002)(478600001)(8676002)(316002)(86362001)(186003)(6916009)(6506007)(6666004)(52116002)(7696005)(16526019)(5660300002)(4744005)(66946007)(66556008)(66476007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: O8o28PmycsbIL5QnC7bwyMpUQ1OqFhmONB4lssuiSD50Wcccbwfs0qhlstl4JUFTadQ/yNDZ3ul2lXzj5Lp9koiVI4VC47l8eE5aq92M1/EIjel6ENHtda4RWFV8Uf3fPIjjemcEOKxZKFKbHsr53uXohSCvwWA/Nc8E8ewu53SVR53Gc5PkkEe/6wVSU5bWbd9t9E4HVifQgYSQBfF0NZ7SdsfWZCr+c0k7HuugrFslzI1VViqgLOo9u6A0JQTvmT2ULNTEYL28M8yfYjuD5f3LZPKNo5zyX4LNMp6/rKM6smNCJmnFhEgnyWqAsXse40XD5z+fFlbs7Z3uCF4ufN3jBHPknxSkDzC6mKHofYXiCiAdfGdoIt4/jqczDNoQHE/G57ni8k6J2f7bnaaffI+8BP8xz7mfaB5mlvOxPQXjtV2VbcXAdh38B/xkYis0RC5Gx5DoazZ4QAETfJB1nnT20cuJsseIfAM9bOI3pbiRAHD4nE1tA3I7GImaqIrjcmahM4cn0oc2UsocqKR7C2hCyi/hdV9vv3mlBBdgODvMckDwD6LNhAtb3UBcMKDggHpJVC7bS/Kk5or2nJ9KzGJbNa6oowtdon9GJvDbEx56MukZpjdhIKCFPsJAwFim8JQ5NAgXbsXYkkj1BJ6zLNmCcs6k2iQRu+L8o8WU2Yncn/Fi6zUdENRNmOX1ooVj
X-MS-Exchange-CrossTenant-Network-Message-Id: fc9eed69-7316-47d2-d25c-08d86566a0ec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 17:31:13.6598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MlQKRYNBtKevE6NwGgINMO3FAAFODrw0R9CIQV8VmkEByHtTa0rZJa7bCsWNFjzY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4119
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_09:2020-09-30,2020-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=1 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=803 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300138
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 05:18:20PM +0200, Daniel Borkmann wrote:
[ ... ]

> +ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP4_DST}/9004"
I didn't know bash can do that.  Learned something new. :)

A thought:
I am not sure how often people will run .sh tests.
I usually only run test_progs, test_verifier, and may be test_maps also.
Considering the extensive setup this test requires,  I don't have a
better idea either.

The test makes sense to me.

Acked-by: Martin KaFai Lau <kafai@fb.com>
