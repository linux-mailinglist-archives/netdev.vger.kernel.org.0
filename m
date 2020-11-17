Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B136E2B7080
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKQU4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:56:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64740 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKQU4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:56:40 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AHKo2Dl009718;
        Tue, 17 Nov 2020 12:56:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=vk0pBkymDLZQOy4mVrCo4yi8rfAIHZMFVMoaq4m6920=;
 b=RDmExc7/PHbtJsonzVEcs+gcOy/Ya7sF5szbn7eGj14oJ/INRPHYGdJPumI8SACVVO8x
 mXjbEMCNVGXnVaL3vD8eOUHr3V8sNhl+huwTmVMDsXdHwYvjJ0bjTtbStStxBq58dZBy
 T1vrUnIeVfnPaNZU4RzAh7wyI8zPSokmr7I= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34v7wf4m0s-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Nov 2020 12:56:23 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 17 Nov 2020 12:56:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T0i/qfjkbQ8zGfTelhW2MJ7bZh61kGEMEDWA4TMNUEpXD1xRAynPeNIDKJnLQJWNBJsw3W9Cj/zzC5n4UmuAjjmcnyQ5Pc7kAI9k7u0Ol+mL0Mgy9YPxHe9DTUGNFt0NJWLLuQP4JVZwL6J/2B8dyerKQxsCR8MiJcmdDpfgrvq7JTPbjzg9vO71vUqAaYuZ+N3m9DMzAmM0mD6JqUuaiTp7UOXknzLLDEiNVAlYVsUmUopVzlmDQ8DsEtHyHNtvmch/ZoUsCHdWyIzWONbq0Wx/8sWSsT1AF36T0ppim98u9HzDPw9ojXlBhpxy23V1YtfxEF+kipHtyNkWqAjqnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk0pBkymDLZQOy4mVrCo4yi8rfAIHZMFVMoaq4m6920=;
 b=QXywSyt1Kb/VkngIQX39wLX78SSD5CUIpHU+nIRGtgDvaW2qkXd0enGQC+MGEkYhFvlG5a/uYWXc5d43o7MUv8rP4Ijyjwq3k9z3Qy94zHcJnO9ygwHgA39nJf/PXYxB1tfvEaYcEt4N7oUqBDn03Zi6cvkls65O5FHreh3ibTAjU//KxmPO0hyStS/vQzFynlcrmdu6bovnuSHkJwH2wLps2bv4ySRedpFNWN29RPUoDImifFYFDfgfiXFir/9l9BAXcwoKFXrluorkmb6AbNOjDldRT813RJRl9KRcR4y23v4SvYUPvxmyImuioO4z5dpKnpQCSCAgIgGL4wpUGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vk0pBkymDLZQOy4mVrCo4yi8rfAIHZMFVMoaq4m6920=;
 b=k+TajFjjztuTmo13ZbEmBHEAbHStmTIyGobOuPHpmp9XENMh+Tv7OiboOag9xAZ10oKp6Q22wLmA3jx8TO6Ib2MuodWKjCmEPkHYhyFSO/lpKy6l1aRUPzWsglUCyqCjRhmFn493Fu9l56/xufiivofmmOej6qt7PP5r2Z/779s=
Authentication-Results: ubique.spb.ru; dkim=none (message not signed)
 header.d=none;ubique.spb.ru; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 17 Nov
 2020 20:56:19 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 20:56:19 +0000
Date:   Tue, 17 Nov 2020 12:56:11 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
CC:     <bpf@vger.kernel.org>, <kernel-team@fb.com>, <rdna@fb.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <songliubraving@fb.com>,
        <yhs@fb.com>, <andrii@kernel.org>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <toke@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add bpf_ktime_get_coarse_ns helper
Message-ID: <20201117205611.mwvz7tt2lsczzdh5@kafai-mbp.dhcp.thefacebook.com>
References: <20201117184549.257280-1-me@ubique.spb.ru>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117184549.257280-1-me@ubique.spb.ru>
X-Originating-IP: [2620:10d:c090:400::5:603e]
X-ClientProxiedBy: MWHPR1201CA0003.namprd12.prod.outlook.com
 (2603:10b6:301:4a::13) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:603e) by MWHPR1201CA0003.namprd12.prod.outlook.com (2603:10b6:301:4a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 20:56:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92f54d7c-8434-48da-1dab-08d88b3b3b80
X-MS-TrafficTypeDiagnostic: BYAPR15MB2646:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB26465F09083E7B36ABCC87D1D5E20@BYAPR15MB2646.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pwtm+RT9x/SS5QoSNrY9Lt6JeHDfXk60knaDWNOHyZAztFAVk1q7jWb/Yu+VuF0IFrL+hqpIAHYBoamzS1+KAz5c6IxYkpVsbbn4GDHn2gwa/LBhOnUi8+nYa5zl/SsssnXVEZ1UaHxTBNbcJbNeXLI/nSFXDGYmFqXvd6S96alRSmhLRLwivNnPspZD2mYbs2xeF3FmrGMOV59S/jInSPygyCqZEikM4BqAaQ/4qQ6u4iQKJJKtsls0nn1pN+cRnQoAUorRk3RCBFBSQrTHRgoGWN2npTksKQtVXf8xA7sUmqkX/+GU6Hte9ui+G09+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(136003)(366004)(39860400002)(478600001)(66476007)(66556008)(66946007)(4744005)(6506007)(7696005)(52116002)(6916009)(2906002)(6666004)(86362001)(16526019)(83380400001)(4326008)(316002)(8936002)(1076003)(186003)(8676002)(5660300002)(55016002)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X2gFVR1R9SW8+QHQGOufbidkz3b4CSQi13suJ6CtPqr+8WHh4UigvQ0wrpbCO4O/yL746PTPEAUExoET1DjEHeIl+E1JSd31/l7xcma4Y2+EJsOTI2ko+RRn0/qO81Zcre6KEYfZjPMv3NSeYn4nSOF0p0NSSbnmPLZuuGkB5Zdv+l1bo1kS8EDUtsvFrSB5lS+Ub4U0GcDdLJuvBtf2Ro8vs7XfDUcBSTAIm0RZ9bZqKASwftqNjfXdIzlAhYiGBVyiXiWnKatWyhf2hVb5Vc2iZpz5iCBaq2S4H17k8MUqSQCW1vDjBraI8PG/zQ7y1o5esxIfIF1z7C50WWUu+coXCaxLLePYFatGWewYNQTdisjbhHMPjkQG1QRLytXySx3ZxqtZuu2oeGiQAG8Z1bwzn+Y+inoqcHErtQcLQAgSTScrPnH1WPzKkmqBG+E5CoRAzW+7TyTZvPpXzrx7NO1mOqM76skc8GCInZSw7U5IsXyN2l0Yyy9XFLgknSIO3ceVSHAQUKdCE8upODkSi2B/MXUeDZesqUeVx6ZDEroRIqY/7KIKcCZk624GvDRIHN08lZqTlz6rQ5IryQ3QM2hKEAZLUz0KvsUSPFd+04DYzoLxTa+cQy9wEuTgzZmnUxH/dOdnb6uzH84Kfg5x6w131lj61K5lEP4puvig+PbommugxZgyt+nirty31zbfNAhpbSjg0WEZZFiG9qQ37CSwEfjuOqRCMnm2I3677+CWx8M96jxR+8MvIkXIo0INx6w6Qkqj+1peedM4320+yah84mpPSZix1fXp7Gl+joSAtbpJvyZiZOTqH5QOWkPGxNpv147eGZXke6dGOeGvlqMTICOnCwTDyxJ3oFXnB+XKM3vjUoaYOLcP+HRd4dMnwE4zl9ydNNed4SVVDCetYjTzhvGgXJ6Pm3SR8Vr+WB8=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f54d7c-8434-48da-1dab-08d88b3b3b80
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 20:56:19.3386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NfvCJmd7VnCrCTvgO0zGJeBtcmcMHBDw3z9NqlADsT/3nVWIlux63wpnqQcPoqsb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_09:2020-11-17,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011 mlxscore=0
 spamscore=0 suspectscore=44 phishscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxlogscore=960
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170154
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 06:45:49PM +0000, Dmitrii Banshchikov wrote:
> The helper uses CLOCK_MONOTONIC_COARSE source of time that is less
> accurate but more performant.
> 
> We have a BPF CGROUP_SKB firewall that supports event logging through
> bpf_perf_event_output(). Each event has a timestamp and currently we use
> bpf_ktime_get_ns() for it. Use of bpf_ktime_get_coarse_ns() saves ~15-20
> ns in time required for event logging.
> 
> bpf_ktime_get_ns():
> EgressLogByRemoteEndpoint                                  113.82ns    8.79M
> bpf_ktime_get_coarse_ns():
> EgressLogByRemoteEndpoint                                   95.40ns   10.48M
Acked-by: Martin KaFai Lau <kafai@fb.com>
