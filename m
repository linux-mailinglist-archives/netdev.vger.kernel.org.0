Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E427DE37
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 04:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729678AbgI3CFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 22:05:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729322AbgI3CFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 22:05:49 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08U25Xwo017994;
        Tue, 29 Sep 2020 19:05:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4Dh81dKIOhPmt5KxnSk+lckfBdDiuXgF+9OkpgFaBZg=;
 b=S9u/j5yG20oZh2CWdtDzhQEBRQ9EkgIvJ0f8djGn7TN/Ocm3Lp3YS1U8y8mrgb2FarLd
 HMT8NkzMC2hhqImtQlM2mYT78tPzXg0JgVw/sbbZXBlDnFVs5m7zv58P/soYzuCI9BUq
 GV+z6WMb5HpTDsGFmRHaAPMUijFR6do6ifc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33tshr5hgf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 29 Sep 2020 19:05:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 19:05:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIlaWdms80pxEoC7cRJ8xo+tZK3dMDn60EUmzKmJm6hiK+j5s3L7CTSf7KwvHx/LT5FyfDnKEV6XvfbzO//RdWiXjH4ogYlXWeyKeGNPvThg0K8Lpa+Ya7oFblw1P0jxEqqZVQQCLS0WmTYT/jMMsCw9uDZ2cz/finLvQ5fFekcoLqBSJWeASClxXi6w+3E+1tewkBWQD78tuwmZznxdkBXTfQnru8F95zyCJT6hdwO83KseGI8v9TxCVX6AD0owHIs/lZUn8ckzqSbgv3wyewqk0d+VibNO/YAaV+gC/WoVfBmk7p2heUr+nLLNHG/M0nXjRsfWSVczifsxdJFCuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Dh81dKIOhPmt5KxnSk+lckfBdDiuXgF+9OkpgFaBZg=;
 b=DjFGVmtTQzjfsS4rXFBiohk4MVFs2VjIb40/Zkl4wq7cdA4IYfWz0u6DXrMe9l6A4dLqJCSMStaakZPl4ugJeorlleg66inNoxFJKm6NRQzzsxta13EH3j6J79rkIYKURz5iafCj1FqwMqhRif0cQC3r9EbD7QVf1pDsLgzHxXUpiPMCCc6j8p4jCwBQMU/OO3XB9mz8Y/wF3lT8oGVayr3rSfypaNzCgLls03Y7U2PHT0YI3tK6MfA+LE7in45fq+S0IohCZfl2QQlkSYSY8Tr39Cf1dJjqKsIug+CW6G+lS247WoLmAVYs4DbmPK0lPb+bsFZyBBZ3SceYAfq8dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Dh81dKIOhPmt5KxnSk+lckfBdDiuXgF+9OkpgFaBZg=;
 b=T1tWAFtpSXrsWUgF6B6+y4a0NwRhydaG97f31J5CAxunrAyA7EgbO7xM6G5KN7tocqsreTO8IPUG3oHcztuIivbAP2j5/CPrEQviAlXmy1be6XefP9zHm74hZtu/Vis2mGy8fqsZHYwL2WR6Q26EIZTpv1mwFihSuzzV88+8EOs=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB3461.namprd15.prod.outlook.com (2603:10b6:a03:109::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Wed, 30 Sep
 2020 02:05:30 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 02:05:30 +0000
Date:   Tue, 29 Sep 2020 19:05:24 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH bpf-next v3 2/6] bpf, net: rework cookie generator as
 per-cpu one
Message-ID: <20200930020511.7isjpqenev6p2lha@kafai-mbp.dhcp.thefacebook.com>
References: <cover.1601414174.git.daniel@iogearbox.net>
 <c7bb9920eee2f05df92bfd7c462b9059fb7ff26c.1601414174.git.daniel@iogearbox.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7bb9920eee2f05df92bfd7c462b9059fb7ff26c.1601414174.git.daniel@iogearbox.net>
X-Originating-IP: [2620:10d:c090:400::5:f2d3]
X-ClientProxiedBy: CO1PR15CA0052.namprd15.prod.outlook.com
 (2603:10b6:101:1f::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:f2d3) by CO1PR15CA0052.namprd15.prod.outlook.com (2603:10b6:101:1f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Wed, 30 Sep 2020 02:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b718ed4f-2437-4370-8c16-08d864e54ec9
X-MS-TrafficTypeDiagnostic: BYAPR15MB3461:
X-Microsoft-Antispam-PRVS: <BYAPR15MB34619A1FF5A52751B208B639D5330@BYAPR15MB3461.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMxX70pH0Ju5dOfIqocn2ZRILqTOeYY99WzINFPBRSDsf/I/vUJtODuPtn9/rqeNCLOBKp7YgpgGObIXIRC5iODud0BVeIKMq95xq851vr4KbX1Yw6hhh75GchhJqMb4XNBUvrI2QtFVdJU2VOqkIdC3XoKvgk4zw1t3IaAtxTEIh9vcHibI3xqO2C2PvXTSwcnT10az1pnAnfVwaTKi5CIjjNnnYfjQACxXlibBfq+XaaIWFnWDHsZuRT9ueMJYyYPI4zLX+dPOYXx3tXkTeAzitxWsMVGZF7hmmZWgPS1X0GRg3w1ynVj+F4Yi0X8nta+Gnb84Bt0OGSDoa3m+eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39860400002)(346002)(366004)(5660300002)(6666004)(8936002)(9686003)(6506007)(2906002)(55016002)(16526019)(52116002)(7696005)(186003)(86362001)(478600001)(1076003)(6916009)(66476007)(66556008)(83380400001)(8676002)(4326008)(66946007)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wWuGVEPYFlEA2iF4Gk5ZQUK9OYbE5wQW1CtTnYiiqAFf30WusxaryalGiYkC5MqoH/DnHCkNJGIELIFe1yUHNmYcdxWcIvpERLrFyLFbOmY5kuflSIgByvK2zK3UAT6usoLdSXWvnwID8ZizLSjSuBMJuDjrOdAbA1oG9BJZyjaYQsUPLwPstQK/DkyNcrpTIw5XoNkQ7NIv8+B9MZjS90TqZ0rmn/CfQO6eaOKAhvN9A7uqIb9ZwbQAljMw3m5mpcbxkTMO8gLGCmP0QiEuxIr3X5TCA0lPUglkVfUtZg3mcu7bZR9l9LDNs/z7/Z5XFqg2M9Bj406T9X07iJn2+9eC6B1R11A74Ukw2mgcRJxeR1xc8XqCKt1FJxbbrtWvLbIKSm/SKmN6mvMKhcxdd1U7ZJ3+mPjwuPUDNw6XMI6OieroDe/iWu2UgZqdxZZLAh3PYmtzXQpbrQVJXh8S89tzR5Rx3wwLuW1aX6oxa9mEQizrOWvDADnM9tg3cP9Yi4bLtGrya4e0xQCe2uu/313uRi1bJWbLJJknaXL92wgECmfwaa2vPAqHTBU5OUuc60QEK4vExBuxrn5fLb/LjghmfshS6H+osS1LWx/NggEcbw0TK8a4zav4wIID7eQqIeQChDspa18pe4NGNgHpD0lWeOd4y9qxyq2VCUaKCTE=
X-MS-Exchange-CrossTenant-Network-Message-Id: b718ed4f-2437-4370-8c16-08d864e54ec9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 02:05:30.8143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyv2bJGAqpHJ8TeDv5r2pGs6kwiCPrt0Drh1YkZjoQ2n+7IpUau3WZs4eGYTlQey
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3461
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 adultscore=0 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009300011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:23:02PM +0200, Daniel Borkmann wrote:
> With its use in BPF, the cookie generator can be called very frequently
> in particular when used out of cgroup v2 hooks (e.g. connect / sendmsg)
> and attached to the root cgroup, for example, when used in v1/v2 mixed
> environments. In particular, when there's a high churn on sockets in the
> system there can be many parallel requests to the bpf_get_socket_cookie()
> and bpf_get_netns_cookie() helpers which then cause contention on the
> atomic counter.
> 
> As similarly done in f991bd2e1421 ("fs: introduce a per-cpu last_ino
> allocator"), add a small helper library that both can use for the 64 bit
> counters. Given this can be called from different contexts, we also need
> to deal with potential nested calls even though in practice they are
> considered extremely rare. One idea as suggested by Eric Dumazet was
> to use a reverse counter for this situation since we don't expect 64 bit
> overflows anyways; that way, we can avoid bigger gaps in the 64 bit
> counter space compared to just batch-wise increase. Even on machines
> with small number of cores (e.g. 4) the cookie generation shrinks from
> min/max/med/avg (ns) of 22/50/40/38.9 down to 10/35/14/17.3 when run
> in parallel from multiple CPUs.
Acked-by: Martin KaFai Lau <kafai@fb.com>
