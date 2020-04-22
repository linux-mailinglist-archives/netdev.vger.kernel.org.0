Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 736E01B50ED
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 01:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgDVXjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 19:39:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgDVXjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 19:39:36 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MNdCc9020975;
        Wed, 22 Apr 2020 16:39:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=wzva3E9+mzfMrzWF3RGK66KlFj4QGazwHm0CA3K7BZU=;
 b=aqK4NiQvKjhVuvsNCFeGRrpy41bcXfH7HeLrXcwcx6ji334q2rQ7pWdnq49N/Z0liEq/
 lwZCCSBGM/9zak0ZjDyFMA5VURhRcf05tM5x/sFWQ+vENnWl3j5EFHld7AhQve8WBsbL
 oipYXhwQmrmZz+qdb+9ZcFUbNLzi5vNaRKI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30ghjwmka4-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Apr 2020 16:39:15 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 22 Apr 2020 16:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dhv8nQW8Ll3RS2gyUd+7XeYXam13YAakLST3k8Iy02uVTTxgXXw9gKiAeivZtkBffex7HdTGuehsPkTlv1cuw6pw9lKt9/l4mvXppjjKKXiRng0U16mIPFdIEc1iB6Je+bgyqk5vMXf+b9jKQkz9bL4bVNld0qTa900AzJRzSFPsAQnWTHSRQgqtoyIoBjNUhdK9Ic6o91+LC0B67b/eQEeW1+ZEenWwRfCS6b56FYW9Y+WAAGHYF5oLulunVVAm9Q0pEJdptMe3SnGNaRGYKEO9GOz60DOSly8TDkeGefCtc246BCPTdBxppK9XDk9ZsXbV51YvwRXwWPwYNQcZjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzva3E9+mzfMrzWF3RGK66KlFj4QGazwHm0CA3K7BZU=;
 b=eyYQHPYN9H8A8ZAv1UBfYL+orUbsSEuOjMucOviLYIBLm1gwudxwOwf27jYnedquPHvkmdv6woNvgm+3ldYT8l4FvYZln26mDyG6ulgA21VM0IAwVVF628C4ns/Xi1dB7yrfbBFOEsvbasLSpZGGQuZsCIduTyd5WdoZs/e7xq1eJDJzPgegbnJ5INFfPjny/+Wyn3jAq9EnRiahh9bgz5gzABxWWpvZ+RFHuXPw/c6WdChXt0Jg1Mhje9Yzd5ORftOZFRsUkiPsbLHE2SKnZ+yJ5IYH7hPA4DXgqfR/zPP9J23V2Iawr2FolwuTmlhL4C0oXLehd8mw9KmSUgnIWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzva3E9+mzfMrzWF3RGK66KlFj4QGazwHm0CA3K7BZU=;
 b=W+pZTNI0S3n1bf2PA04wjyPny0Spb01BVJArUE6gBQO3oYlbVBoThgE6QWzlkuWTqegr1bzBMqhTVF953opFGUMI4NC1uX5NisFd8oFoY+01GV33NNQYkDN991WK6jM+UAXz73R4pZA9BQcFQpWjXeZezZtr6DRMY9bKe2tFmic=
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3301.namprd15.prod.outlook.com (2603:10b6:a03:101::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 23:39:11 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::90d6:ec75:fde:e992%7]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 23:39:11 +0000
Date:   Wed, 22 Apr 2020 16:39:08 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH 1/5] bpf-cgroup: remove unused exports
Message-ID: <20200422233908.GA6764@rdna-mbp.dhcp.thefacebook.com>
References: <20200421171539.288622-1-hch@lst.de>
 <20200421171539.288622-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200421171539.288622-2-hch@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: MWHPR01CA0036.prod.exchangelabs.com (2603:10b6:300:101::22)
 To BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:1d4c) by MWHPR01CA0036.prod.exchangelabs.com (2603:10b6:300:101::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 23:39:10 +0000
X-Originating-IP: [2620:10d:c090:400::5:1d4c]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52fa7f1b-6da2-48c2-1583-08d7e7165b9b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3301:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3301FB1949B321ED945C96B8A8D20@BYAPR15MB3301.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(39860400002)(396003)(136003)(376002)(346002)(8676002)(4744005)(2906002)(4326008)(316002)(52116002)(81156014)(7416002)(9686003)(6486002)(86362001)(54906003)(478600001)(186003)(6496006)(16526019)(1076003)(6916009)(66946007)(8936002)(5660300002)(66476007)(33656002)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UziuiDcb/36oW/khu66eo7L9mIIZzGWRzZ7lfqYqKvTl7epH18rmobkjHIk8/LpU0/rk5gMntjQL9JFHxA67Q3Z2FY+OsX3B0o3Ui4q5jbKNg0PXrxTZ+7PPT2jZ4A64NzLRVS9zbnY8Qw8qKzk3l54GOpTIXmGlGZKn4rrxPMmVw7LsnhcgdUiQMv+Zl3tL4LGSQQHbQ/eXi82OdLgJ+rGpW7YzPgwKg6yvCnQG+U9N9oWaQXMobGdQ5xEDwpkdUPINpksAz9ivT1hKs39HiwSfUO1b9nHivTqVBZxGiSb4d+wsgz3M3g4pacQQRjZQAmEcT890gWrGu28DtSbduvgf412tHglO/JzA1tD/9mtK34yDZrG9+fkc1Y5PNzKS/FrtUJvj1UXtOHxFDISqekkwMPECjRXk9r6wy82/K88uTUKsqGfphCmfVHnUUrN8
X-MS-Exchange-AntiSpam-MessageData: lFxiQxdBmDEWMMz0Nlk152lO+2OOCJcTwy7IzalcVAGJggDN3j4GQvUzh+vqma80AJiHVW/cbQwlN3uVNUS/68ldhtvbidKcwX62Ue8+xwAo/HksF31MjWXq+vfL9oV276A102NZFTKQrVdpu+kZsUNh6hrYAMKkC2QDPHU0narsxqR6g8t4fZlihC9J9Im1
X-MS-Exchange-CrossTenant-Network-Message-Id: 52fa7f1b-6da2-48c2-1583-08d7e7165b9b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 23:39:10.9620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49rRClL6HjZP11D540B8PYtI4M2PczEED0cX9zKFmIt9MOwZ0067IhZPuOQ2c8Mh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3301
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_08:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 adultscore=0 mlxlogscore=847 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220181
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> [Tue, 2020-04-21 10:17 -0700]:
> Except for a few of the networking hooks called from modular ipv4 or
> ipv6 code, all of hooks are just called from guaranteed to be built-in
> code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I checked it as well it see same thing:

- __cgroup_bpf_check_dev_permission is called in
  security/device_cgroup.c under CONFIG_CGROUP_DEVICE;

- __cgroup_bpf_run_filter_sysctl is called in fs/proc/proc_sysctl.c
  under CONFIG_PROC_SYSCTL;

- __cgroup_bpf_run_filter_[gs]etsockopt is called in net/socket.c under
  CONFIG_NET;

All three configs are bool-s so LGTM.

Acked-by: Andrey Ignatov <rdna@fb.com>

-- 
Andrey Ignatov
