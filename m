Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A25193890
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCZGZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:25:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8192 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgCZGZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 02:25:35 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02Q6NIIU031263;
        Wed, 25 Mar 2020 23:25:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=NGqB1P6u0oJlQ96FbK7M8O5McVRzcVuGWaKgkLXOJ28=;
 b=mLqOFiJEk+AJaX9J7P0kI6r0tlHBSqdRl+qMsVvAkEYESTs/Nur3k/i8jZvVP+14mYuG
 CgIrhqTzVesWG7mwVCZi4vafHuvZtsXqcLh46LEPz9pwzKeP99bFvND/dkq0z1LbLV54
 QuevNxdKEfAY2uivOj2Gme4sl4tepSj81/g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yyws7057v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 25 Mar 2020 23:25:20 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 25 Mar 2020 23:25:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rq4SOL+gX1RorvfmgfxsOvHvAIPdSkj3/cWVvbbIIQdb2ZONRtxLfonPEhaDpCCX6VR4LuDpECUtjttFahQ8bhr5EeuPADHkyXGoKc7ymW/3hQh081y+Qku4EiLx4VLrYnzV21Tx10yQETY276gc1Sq3tkYV0epxYs+Drj3197PzNvievi7vhsYHM/L4VlkvWmR8NB9SgvUcna+FKLYHfFyHGQUIj1d+TyhhppaWqashfN/hhtBDFWl18mz3w2jsJ/ZdIbXW3qpo+moKT6zOq27XlW8hYiQRopIT89SS1hck0pALqvP9FBVxQZLjjq4mOpK9J5Fs0vVWbZAjwgJzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGqB1P6u0oJlQ96FbK7M8O5McVRzcVuGWaKgkLXOJ28=;
 b=ErJ7VztfFqqqcl4tOtZjO9TGKnefccGnjy9QoXq/9rBbGbi33tw7TP2hP67t6URXpAkmjH8f6u5OrD3c3TVC6PXocgMCShhLCUTyWC83yDFpIIe968PV8ZTEHBRLA1OMDepyKu9BNsWReALTpCKA2V1BiPdGU2jJGrfGU5xJnjaHjLba/42ZVYTPym28I9b+1s75i/vGe1XTrrHsd4svuLmDJOccHp1r/hXUqtO74naatu6MEjJWnqgH4DrMSxYpuYnK9ocI4XpUAhkCTOjnnzZTULJiOmRAuME1XUpp977xgo5o8lHL9SXLI/SOfBeulJETG8R0/00rgM5WJL+Rog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGqB1P6u0oJlQ96FbK7M8O5McVRzcVuGWaKgkLXOJ28=;
 b=MtqKEfKZRhiis1VuMbp/eJSl03Z1+7Yxyx8iEHeuJIgNAIGCV2Q8qCoydAxdNx+emWQBWPNJIUxoZik4LH5ZzGAUldQec30jure7yeGDVrTEW0VhJxy0cwi9PgUE1mIkq5YJjaAqKO7DkchK7dFl04+IawZwnu8mp2AcQZh0pIk=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27) by MW2PR1501MB2185.namprd15.prod.outlook.com
 (2603:10b6:302:12::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Thu, 26 Mar
 2020 06:25:18 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::2ca6:83ae:1d87:a7d9%7]) with mapi id 15.20.2835.025; Thu, 26 Mar 2020
 06:25:17 +0000
Date:   Wed, 25 Mar 2020 23:25:14 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joe Stringer <joe@wand.net.nz>
CC:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests: bpf: add test for sk_assign
Message-ID: <20200326062514.lc7f6xbg5sg4hhjj@kafai-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <CACAyw9-jJiAAci8dNsGGH7gf6QQCsybC2RAaSq18qsQDgaR4CQ@mail.gmail.com>
 <CAOftzPiDk0C+fCo9L5CWPvVR3RRLeLykQSMKAO4mOc=n8UNYpA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOftzPiDk0C+fCo9L5CWPvVR3RRLeLykQSMKAO4mOc=n8UNYpA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR21CA0049.namprd21.prod.outlook.com
 (2603:10b6:300:db::11) To MW2PR1501MB2171.namprd15.prod.outlook.com
 (2603:10b6:302:13::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:cd36) by MWHPR21CA0049.namprd21.prod.outlook.com (2603:10b6:300:db::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.2 via Frontend Transport; Thu, 26 Mar 2020 06:25:16 +0000
X-Originating-IP: [2620:10d:c090:400::5:cd36]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03511939-014b-4566-4400-08d7d14e73c2
X-MS-TrafficTypeDiagnostic: MW2PR1501MB2185:
X-Microsoft-Antispam-PRVS: <MW2PR1501MB2185E1EFF8C09662D9E47C41D5CF0@MW2PR1501MB2185.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(136003)(346002)(366004)(396003)(39860400002)(54906003)(55016002)(4744005)(1076003)(66556008)(86362001)(53546011)(6916009)(66946007)(316002)(66476007)(9686003)(8676002)(6496006)(478600001)(81166006)(8936002)(33716001)(52116002)(5660300002)(16526019)(81156014)(2906002)(4326008)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2185;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wjBE65WfA25Ajz2f7ltKBvCxvGFfk5z9kptjZkWdYMXP3jBL7EmviAOJP0g/jB+xWjToz5lQToc1k3BmU90qseFErUmdiimxNM4UuJNSJzcE1ej6tHuJdvoosNYko0I61MmQ53iMSFT8tL80ulqXrDi9WkoIJt4bSd0rbsOOEIB78A7cA4ukTYZQF+ddtp6gcbWmuZ/9VvmkBtxlKi4j1lFRPsrX+eMocrQdKeULT779rK7/4/5YGaHWbkVSZ4YydMXBzQziT28ndklXC5DKi8dRz0Ppxq7DJ5zRAygFhttdHWY36taxiNPasKuhWQINzxhhZlGHZX3mFnzvvyHlNtoiIrrHsrcD20UIuuUp5xi5Q079HtSf0ZQVB4aQdTP8z9tYu8wBfMbXM5UFiDKsLrlOU2H4vifCRaMep+/8YbQTlY4wXoIHzgCvuRQ96cDO
X-MS-Exchange-AntiSpam-MessageData: zsWSDRU4xcndiNcPmel+mhLAm/Piz+NRYb9dRql3VvbxtE2aYew2v3jkhLsQChuoXEP7jIhCLnrYjnTq2PIQ9JbUdw5q7ffDTWGhf13wCDFzIaPfO4IvEc7dbTTtHekrziDA77cLLa9l840rqMCf0Dof3U3OCCk59g5z/FjWbBW+2c030cm1pH/4e7Ocuw2P
X-MS-Exchange-CrossTenant-Network-Message-Id: 03511939-014b-4566-4400-08d7d14e73c2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:25:17.8018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SqLo6ETnOKB4J+zmDOj8oeNqPAKnY+RqeK0H3C49dQc7UF0rwjo7GWz6cvwigOof
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2185
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_15:2020-03-24,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 suspectscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=917 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003260042
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 01:55:59PM -0700, Joe Stringer wrote:
> On Wed, Mar 25, 2020 at 3:35 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Wed, 25 Mar 2020 at 05:58, Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > From: Lorenz Bauer <lmb@cloudflare.com>
> > >
> > > Attach a tc direct-action classifier to lo in a fresh network
> > > namespace, and rewrite all connection attempts to localhost:4321
> > > to localhost:1234 (for port tests) and connections to unreachable
> > > IPv4/IPv6 IPs to the local socket (for address tests).
> >
> > Can you extend this to cover UDP as well?
> 
> I'm working on a follow-up series for UDP, we need this too.
Other than selftests, what are the changes for UDP in patch 1 - 4?
