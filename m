Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671881D8AA5
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 00:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgERWSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 18:18:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726640AbgERWSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 18:18:05 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04IM9aiI008773;
        Mon, 18 May 2020 15:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=BKPQ8L7UXUwGva9ninuS38Dizvg16Vca99JzBWW5UUs=;
 b=fI+Q8kblN+JI8OH0S5CFPGttNVfcvsgV97nhLc+JDFTVU0NvTjg2WowKkJWkuXOq1O9Y
 h9thAs7sQivwq7EwSkDNZhUiyWQ+9mgvuVqMc25+bkHcvzehOux+SlDFx3vNxx8SwoZZ
 /9NVv2bTGAFN4VNLkOb7TsvdznjSQKtYrE8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31305rsac0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 May 2020 15:17:49 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 15:17:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGL8WtrfdbFQ99LH7s3HcDX3FzrBqpZB1zAQJETI8DQOCv5kj0Z4Ka+MxGZ4aJRzwPVQaIJ5zTw+1fy7mlyVY/f18ioGZfqY4zYBPcDhyUXTm1B392lJ0TyeEV/8/1lHgQpIH2cWrJEmqNMKf/lcKMoZCFbvcWH7gJkgVHi2bxRqF2XjyJUvCrDcOEQ0sXw/RK9txEmVY1Jsyu4pouvGxIb8DEXnPuth7Gd3t2n81oNTW2Sm/Zwujn8baccar/gpGBR0Jt0ZwmedZDdNTX6KKDugMQdQGDDhnYf8TceXCfdxMl8hIIM1QyjBfH7xtzRW4bE8Hb9p7VFpCvUTynJlCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKPQ8L7UXUwGva9ninuS38Dizvg16Vca99JzBWW5UUs=;
 b=R/OoJPDos65wGy1kOxjz06kDJKTI3GE3ZTbu5rkW0GCvw7q4wkz7gQicNDuwvhPqY+iO9TiO9csviY0e/83rbrLPzT3xAtQc4JcAUst+rERoXs8jLLIQf282y42R3JKkXkmH0VUcGxozKGlH7CRrXwVpal9o4ul7ECjZd3mgdvko3WR8fYS3fx9RQwlYZyphxCyAY8vpYGTIuZA0glHxAHzrla5z9t0n/tvjxrb1Xcb0XoOB93x1hovlVoWlWxB8Tmumgy8s2//G8pNpy71uhauOfPh8Ei7WWaHATXy/AwK+JwYEEASBWRKJv48wn/QR4xK939aHD7HT917kAm4NBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKPQ8L7UXUwGva9ninuS38Dizvg16Vca99JzBWW5UUs=;
 b=Ctz8tkSUBQle8gqWPxylfsSqScYJXC5/AgBHh2JK7rrSRMoss2P9NV7Ks6kXSGjpalSbp1THLuxeYaq/P8PhK//3KjUPGPWOH9i0PAcBMBoIsuZQi+VUnVALMuvMsncnDh78zxok5ZOOR8LpDA/H62mFqi13fKdqlQm8nW2RU+E=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4119.namprd15.prod.outlook.com (2603:10b6:a02:cd::20)
 by BYAPR15MB3191.namprd15.prod.outlook.com (2603:10b6:a03:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Mon, 18 May
 2020 22:17:47 +0000
Received: from BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::f9e2:f920:db85:9e34]) by BYAPR15MB4119.namprd15.prod.outlook.com
 ([fe80::f9e2:f920:db85:9e34%6]) with mapi id 15.20.3000.033; Mon, 18 May 2020
 22:17:47 +0000
Date:   Mon, 18 May 2020 15:17:46 -0700
From:   Andrey Ignatov <rdna@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <sdf@google.com>
Subject: Re: [PATCH bpf-next 0/4] Add get{peer,sock}name cgroup attach types
Message-ID: <20200518221746.GA52807@rdna-mbp.dhcp.thefacebook.com>
References: <cover.1589813738.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1589813738.git.daniel@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-ClientProxiedBy: BYAPR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:a03:100::16) To BYAPR15MB4119.namprd15.prod.outlook.com
 (2603:10b6:a02:cd::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2620:10d:c090:400::5:2799) by BYAPR08CA0003.namprd08.prod.outlook.com (2603:10b6:a03:100::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Mon, 18 May 2020 22:17:46 +0000
X-Originating-IP: [2620:10d:c090:400::5:2799]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 891e7299-ee5a-4f62-86f7-08d7fb794b45
X-MS-TrafficTypeDiagnostic: BYAPR15MB3191:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3191DF1F475AE4E592CE9270A8B80@BYAPR15MB3191.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04073E895A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zfG1+UhjL5BD8VUUNKisZNv8jAKRfIwqN9/kRYpDFmg8SVY5rXfIsyo4jexLTFuyAG3fA9tVAZ6002Yx6bZvykiXNSPvHSybceLTnQuWAQvzuQAHlxTAHEMoolB9S6Eo62XZglaJFLb5igtA/wKlH9pC2Rdbh/kWcMRNseuFHLYAQS4JyS6uJovl+3eGgzg75jM+lRxHwCWFkayjposO7Eyk1OkDB4ZOz7lAbYEkV32b4qPZZstAMoyKf7XtgyQUdqDdVaJ2C94MB9Q0DwcnFDKCl82eoEndcMXJp/8U4TRl6f9WitkOgYDgbXoIW3sKqScOb2o954ySbPb57yUPxUr19AluElkj/tHOiyssN4JCU2WrcoS9SpS13snQNuTA2P0pGk8e5tv4Ny36mjJ4241NIkn+VB3KcvfO52LT/3NyX/y1L94DBFU9DmZIlwnySbKhoGzZlSdTLoQh8YFId5chYKzcvK6PPPERJPiHWK4EeYR8ETcyzhTWZTVWmWj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4119.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(366004)(136003)(346002)(376002)(9686003)(8676002)(66946007)(66476007)(66556008)(2906002)(33656002)(478600001)(4326008)(86362001)(5660300002)(6486002)(6496006)(6916009)(16526019)(316002)(8936002)(52116002)(1076003)(186003)(142933001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: zyicEcoN0P16Iyv6X03/gwYj+5lUIkjGJl2v7BIFvi+GnRQ+kX+DwkZH75mv7SStVBdEAsHWOg5sSSTQKszCPEV9AH67zmMqE9E+E7myEKgiSBAp62Di7UWnbVN6bWCZ2WqWHSZ+QpaOmwveOswmIuOfo0hlijrMl9wbPbh4D5e9EMOAcpAwqU0jR4r5cnMAof/C0DTgqdv+7iOC3K2psCFyNYVEucjMuSiZiOo5zfQQdnYxu2tkoJ/zSSFcceB2Na7VYqraWld/WzMoHVrt4fDG4JGnE89/B7pyecH4WLVgTj704c3lU3LDNyS47mhMgRhxMadW+8gykvqJcMwvUcaYnqdt3ZrSgSwk7Bndc9M8bd+6aq9wXwFiBdW12kOwwbVX/BqRr0LWdfXOx4CUkiPl9NFDWy/d0Fo9BzXyfR92aeopIssIPAvX+/kgJ4GG4fr6/ivqwxXUY1UYKHgcmZ4glMP0HZze7LTta7/L/jyUWCsgGzY0xNHyjlZ05vXkxTiMcgQJdM6io8c6K3lWUQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 891e7299-ee5a-4f62-86f7-08d7fb794b45
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2020 22:17:47.0765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PBnNQ8X69RxaOOhkp+b7I2kl6bJvspX3O1RrXYoFlXjnIZYimHPWvXY1UM4XJowe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3191
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005180187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> [Mon, 2020-05-18 08:35 -0700]:
> Trivial patch to add get{peer,sock}name cgroup attach types to the BPF
> sock_addr programs in order to enable rewriting sockaddr structs from
> both calls along with libbpf and bpftool support as well as selftests.
> 
> Thanks!
> 
> Daniel Borkmann (4):
>   bpf: add get{peer,sock}name attach types for sock_addr
>   bpf, libbpf: enable get{peer,sock}name attach types
>   bpf, bpftool: enable get{peer,sock}name attach types
>   bpf, testing: add get{peer,sock}name selftests to test_progs
> 
>  include/linux/bpf-cgroup.h                    |   1 +
>  include/uapi/linux/bpf.h                      |   4 +
>  kernel/bpf/syscall.c                          |  12 ++
>  kernel/bpf/verifier.c                         |   6 +-
>  net/core/filter.c                             |   4 +
>  net/ipv4/af_inet.c                            |   8 +-
>  net/ipv6/af_inet6.c                           |   9 +-
>  .../bpftool/Documentation/bpftool-cgroup.rst  |  10 +-
>  .../bpftool/Documentation/bpftool-prog.rst    |   3 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |  15 ++-
>  tools/bpf/bpftool/cgroup.c                    |   7 +-
>  tools/bpf/bpftool/main.h                      |   4 +
>  tools/bpf/bpftool/prog.c                      |   6 +-
>  tools/include/uapi/linux/bpf.h                |   4 +
>  tools/lib/bpf/libbpf.c                        |   8 ++
>  tools/testing/selftests/bpf/network_helpers.c |  11 +-
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../bpf/prog_tests/connect_force_port.c       | 107 +++++++++++++-----
>  .../selftests/bpf/progs/connect_force_port4.c |  59 +++++++++-
>  .../selftests/bpf/progs/connect_force_port6.c |  70 +++++++++++-
>  20 files changed, 295 insertions(+), 54 deletions(-)
> 
> -- 
> 2.21.0

Just one minor nit on network_helpers but other than this LGTM.
Thanks for adding these helpers Daniel!

Acked-by: Andrey Ignatov <rdna@fb.com>


-- 
Andrey Ignatov
