Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB00C26576E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 05:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbgIKD3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 23:29:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3684 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbgIKD26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 23:28:58 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08B3PsKk023138;
        Thu, 10 Sep 2020 20:28:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=/oXBVAiCur4THPr6A5stgqN+aXbA+pCa5iN5T3nikvg=;
 b=T9HxR9AJoKNFtduiE9AfKGQ0HtF2macpBcQ+exNeDUg9nuHQw2HgAmeORqpGd3glsuRW
 JZBYq6UXH6wmEwKtGiFHzSSn6oJlpnFM/4kzM14SpjPw5Of2XJJ7bY5Rfzmh8+tKVPhB
 8se/v2I0MwqZmezYikZkwVfjzTrxAsR7fhs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33f8bff5u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Sep 2020 20:28:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 20:28:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzWf15PfQ3VPfsf041MuGFUkcDUhJaAESax4EXvtdp4UGBJLSYz2EAJ3aJMepFAGdwLnoHs5iOyRID6s20iLEkXS952Zm/az419KblJCies9i8lRO0J86+R9975l4blDbYVPXEfrs3eAUNrM9FUQYQL2MGl24fKq6bS46REup0N1wUOqcls2BWDzA4sV9g3vdrJQISSb3VsnPD8+JaEa6fX9M6J1tRHlr/JQ5uZ7/exyMqC33fnM9rx4ah96wH7t2pbbjovkwwfJRe10KShJCKH4ZfeOWBH7AoCc3uoBHYfP2fXkld+6LdE7VxLsQJ0VAkZlFYYM5veR/ih1cWwilg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oXBVAiCur4THPr6A5stgqN+aXbA+pCa5iN5T3nikvg=;
 b=N4dUyAWO6jDhEreUn6nxbJRl+xAq/Oqwofwsx++bfzVFsEp+fjuxyI7aia8vlIRCObcwNZhGVR2l2r0gog8S06MAhCIev7YWA3PcZ1Heyf8+wxwTsXF2Dr9y94WRTlSbGeUc7hTYuyUP13NaJqxGiG4zGWcP4fbVyEOst0TU9TrXRh3IvqVtjVFg6jkIBlkvGAdm+awld3APgKvIVTdQXPK1HfC48NYDko6wz5plSWA+fLP1cQQOCn3xHgHFtqd6+XGdP1mVp3QVOJgRqKqvun6mNlIdR3J2HSOIyAo0njcA3qO7mgtbImU63Hv9ABn3e0wLKbxe1rHuSuDU7bvFWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oXBVAiCur4THPr6A5stgqN+aXbA+pCa5iN5T3nikvg=;
 b=jsnwItxMWyOe5MON+8Z9aAzx8fXjE2RD1Z0eG5d2c78KwGxye2t/fInDdE9KbLiRpS73chVPOd8O48W2BNGpphXFDkOIrHNO5ZvagH37QeYzKyWf3gmSFZ0Zr87QRX3//A3PY+h2kB78pFAF8eUPOHECuR2/MCPZGOMj6y1MzmU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2262.namprd15.prod.outlook.com (2603:10b6:a02:8c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 11 Sep
 2020 03:28:50 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::c13c:fca9:5e04:9bfb%3]) with mapi id 15.20.3370.016; Fri, 11 Sep 2020
 03:28:50 +0000
Date:   Thu, 10 Sep 2020 20:28:44 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>, <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH bpf-next v3 0/5] tcp: increase flexibility of EBPF
 congestion control initialization
Message-ID: <20200911032844.wrlgcpoc6fkk2gw4@kafai-mbp>
References: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910193536.2980613-1-ncardwell.kernel@gmail.com>
X-ClientProxiedBy: MWHPR18CA0048.namprd18.prod.outlook.com
 (2603:10b6:320:31::34) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:5083) by MWHPR18CA0048.namprd18.prod.outlook.com (2603:10b6:320:31::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Fri, 11 Sep 2020 03:28:49 +0000
X-Originating-IP: [2620:10d:c090:400::5:5083]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68629830-23f9-4438-17b9-08d85602ccfa
X-MS-TrafficTypeDiagnostic: BYAPR15MB2262:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2262EE4E9915DEDE49194FD2D5240@BYAPR15MB2262.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 98JRoaQiIwP0BcrCOlOpjVv+ocRbRhPTH9Q7Ds5Io/0Uz2/QcOy8KnLaug0bVn1vv/vPL4MykZH8fdxbcXq/xSzG9zMeYLXWGI51wZmY3fEnGHt2eH3bNXy2NP+QQrdWi6tUvqg8pSqvDnscqcYjpMPTixpK3zh7UqDSLOAkHkqG5KhSMgcrHChtmL6xy9UDoh90LBqiptrOAgzV5dYo12DH2SkogIL+p7f3VzLzCVcWeo4KS2AZwSn86Ili5DWK3ypObvh92ZTIplhK4EVkVNSlsFM1MxCCV+rasYTTqMg+TTImadD915fFy/H12mbdWv+HKYlbu7TI9nEUb4hOfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(55016002)(83380400001)(316002)(52116002)(8936002)(86362001)(33716001)(6916009)(186003)(1076003)(2906002)(6496006)(478600001)(5660300002)(9686003)(66946007)(66556008)(66476007)(8676002)(16526019)(6666004)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ilxfR5tY6Jl+tHG9V+mzyZIXTATceLr/0aI9NwrEuE+EC/BVklmoPB795msD6B0lkNSfcEIRYpEWdlx514pxMWsK0C1WiTwO7OCYGbsab3gYShnuY2+sDHtIuUE/miJaGtYpOF2T0TJ8rRK2+XCtSACDerFhrJYAxtOAg7KYVxLcwfXWXS0z7KSlpy/vQ5t1ICEjkhvLQAQpIynxfN/rxZHWyqM5YvegmUydBs2ECrV8+GX3plkvEp4VE3v3K9Lj6p6tzBHwP3KdKYDeDCb6J81jZ5oCP0lbdah4C2gxz2kpeQAyvScl8cxgaw0XiMt69S4kX+4mv49Fxm+X1M6HvbL22xedxCAeqlKkaVjyvQVwDGBWtwx86XGhayyfaEe1Lwqu3IjA8l6Pwdo17c3G2cENyA43URDiOyB+DlSKa/z0S3GLr4fh2Q4p9YjduKB9zvCyG5HVE/6/UUqjlIL4b8je6jGYfwCT5mVOUiH+p0P4s1+HRXn5nvRLQe4hvUnV18UBjrwwuREexvfEjjOUBvCOYTvrpyjB3euMo9fceSelGc52ZCI7hKKVdjk6tH8IidzMoXwO1ect6yq0gzCxrZodVKZBYNpRPngRAwSPocrl7c+Niu4VHXKl3xtzYq8ZjL+zLy7tmvM/uCGtmwa+isvmCMWayVNBWu4TwzLzynY=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68629830-23f9-4438-17b9-08d85602ccfa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 03:28:50.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJohjuvdtqyoDQEIejVAJDgWFznePt3fo50kIZvip/OxlCthMsF2pyHUYfky9iMo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2262
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_01:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=926 suspectscore=1 clxscore=1011
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009110026
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 03:35:31PM -0400, Neal Cardwell wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> This patch series reorganizes TCP congestion control initialization so that if
> EBPF code called by tcp_init_transfer() sets the congestion control algorithm
> by calling setsockopt(TCP_CONGESTION) then the TCP stack initializes the
> congestion control module immediately, instead of having tcp_init_transfer()
> later initialize the congestion control module.
> 
> This increases flexibility for the EBPF code that runs at connection
> establishment time, and simplifies the code.
> 
> This has the following benefits:
> 
> (1) This allows CC module customizations made by the EBPF called in
>     tcp_init_transfer() to persist, and not be wiped out by a later
>     call to tcp_init_congestion_control() in tcp_init_transfer().
> 
> (2) Does not flip the order of EBPF and CC init, to avoid causing bugs
>     for existing code upstream that depends on the current order.
> 
> (3) Does not cause 2 initializations for for CC in the case where the
>     EBPF called in tcp_init_transfer() wants to set the CC to a new CC
>     algorithm.
> 
> (4) Allows follow-on simplifications to the code in net/core/filter.c
>     and net/ipv4/tcp_cong.c, which currently both have some complexity
>     to special-case CC initialization to avoid double CC
>     initialization if EBPF sets the CC.
> 
> changes in v2:
> 
> o rebase onto bpf-next
> 
> o add another follow-on simplification suggested by Martin KaFai Lau:
>    "tcp: simplify tcp_set_congestion_control() load=false case"
> 
> changes in v3:
> 
> o no change in commits
> 
> o resent patch series from @gmail.com, since mail from ncardwell@google.com
>   stopped being accepted at netdev@vger.kernel.org mid-way through processing
>   the v2 patch series (between patches 2 and 3), confusing patchwork about
>   which patches belonged to the v2 patch series
Acked-by: Martin KaFai Lau <kafai@fb.com>
