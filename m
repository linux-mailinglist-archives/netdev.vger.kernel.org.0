Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B683C20ABED
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728062AbgFZFnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:43:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38694 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728051AbgFZFnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 01:43:50 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05Q5aUlT009150;
        Thu, 25 Jun 2020 22:43:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=gF+x2K9Nsd4Qt9ko1+uoJI6eKmaJKjIE/K+o4PwWbVg=;
 b=f6lJfYwR/0qpHDD8QkhZ1n/Vj/IOwGbhoL1LwkEA8gWd/mruzWRxF2kjDReleI5yOvgp
 +HPQPp8HLCPSnNcGkobSamSSR2xTv8MP+Y6sdk2dCzFDK/shYolaW9HNvdCs88BXUUda
 7TN5I+TTLyZIEnxuNnDe5ASzxKFz0GK5+JA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31w3w2hg80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Jun 2020 22:43:49 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 22:43:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQmtD/SwRqZJbWU5JYbufT1IwjxbMpnktOV52ay3SS7fJXmNyC54LY9NlBAqGdJCHnEuLdmLzNoubk5uxGHTQhbKmpyZmmHmkfGI3gfUuydtdTxFl1a8j3R9dVvrGZ+sQ7BKta0f8srrUI7za8+DgUJ/NdTfGdA+gtzVlAvm7rsR08T/rJRcxIX36xi5r5Ct9/O2/n5bYVD3Q5SrW0jr6jAT7JtUKtJ5GHI/qFDApkhyjSlubxkUFWrZgyB6Ra2PRHkvohOWSlXmsZSs+FijOoB0BbJsygVtX92LyW5SVJ6n15MhggdirH7hCbiSwRby2ukrKywSPC+LB9rwGDcXXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF+x2K9Nsd4Qt9ko1+uoJI6eKmaJKjIE/K+o4PwWbVg=;
 b=m0myb3hBnMDT9IorxqrmZQLSTHA/1PMf/m84KXVULoQFpDQgEEc9/4O2sXo1WAfKUAjOuUscsxe5dBmN4O1NnR/xR7nSO3iqyCDwpuzNLd9D4YbIuLu6r8wnLcTB9sYdyM/F95O8L7sq03KCu7fFWIZT5G9fShusNc4FbeQs2avNX7IFGurTmlNvLAevDx7OI2olQbNPt7HlsNjjmYwb9ro45UtvHwJ3FndYrzlOgJuiYRWDLMk91FRt2sEtZJApTXNoZLColnamkwGnfckMSJ0NN+4wttPDxtW0shFx6FA7vH8jvpHsvtWORQGSNkRI89emy1rohljpDYGsSAlBSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gF+x2K9Nsd4Qt9ko1+uoJI6eKmaJKjIE/K+o4PwWbVg=;
 b=QewmyY8tjgi+TCYandRrX0SNSdWuMyJ+weBlcKOHd5/2imBjqwu3q7t6GSgujMeLaqOc1Zu/rW6WGKGtc8Sy0tskU6r6UH54kPj87nEqNYrsz2lHsqlKFOjQGq+mvM8rDmTYTY3EM4K+98TNFdsmhC1Cz4D4/R7YBM+knkmMxA8=
Authentication-Results: cloudflare.com; dkim=none (message not signed)
 header.d=none;cloudflare.com; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB3580.namprd15.prod.outlook.com (2603:10b6:5:1f9::10)
 by DM6PR15MB2316.namprd15.prod.outlook.com (2603:10b6:5:8d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 05:43:47 +0000
Received: from DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc]) by DM6PR15MB3580.namprd15.prod.outlook.com
 ([fe80::c8f5:16eb:3f57:b3dc%5]) with mapi id 15.20.3131.021; Fri, 26 Jun 2020
 05:43:47 +0000
Date:   Thu, 25 Jun 2020 22:43:45 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 3/4] bpf, netns: Keep a list of attached
 bpf_link's
Message-ID: <20200626054345.rhcg2vyokvju5xps@kafai-mbp.dhcp.thefacebook.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
 <20200625141357.910330-4-jakub@cloudflare.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625141357.910330-4-jakub@cloudflare.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BYAPR06CA0068.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::45) To DM6PR15MB3580.namprd15.prod.outlook.com
 (2603:10b6:5:1f9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:7d5a) by BYAPR06CA0068.namprd06.prod.outlook.com (2603:10b6:a03:14b::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 05:43:47 +0000
X-Originating-IP: [2620:10d:c090:400::5:7d5a]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5494d31d-9442-4625-1e2d-08d81993e58d
X-MS-TrafficTypeDiagnostic: DM6PR15MB2316:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB23164EF88B6D720BE6197389D5930@DM6PR15MB2316.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5c1QTMbecjjSrziYr6xAkDV6q2e3rZNmLLSVgEp03pYiceKA8UAG+zaQIWSeKVgtxgvQUz7wkAUxIgx8MfT3CIB49yfIctbhYFNeCbuMT5SoUR5PD78zhG1QmreKzXvYiV9N1ptJXQzrGCQRHz6tHjyY2y8MXpY6p2n2a/EVIO6fm4Mf4ysm/4UG2iD2KIbPVAmFGnjcepZ/cEEd0qYi2xZmgXtDyC9J5l62+bz+lT+zhmOR0/RDI9/y0ykoK1nE11WnVD1KsSk6E64UJPsEVXdsvXOK1xQHPZ3iq7lZo6XjC2aHg0nP2mcDbcitG2K7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB3580.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(346002)(39860400002)(136003)(396003)(316002)(8936002)(6916009)(2906002)(9686003)(1076003)(66946007)(7696005)(4326008)(52116002)(66556008)(8676002)(66476007)(4744005)(86362001)(16526019)(6506007)(478600001)(55016002)(186003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: n1IIe2ICIkleQbmvdTKW3ubsbtKIniklCI5qwCF1KERniSdCeIarV3B83+6bc38QWrqvA4+DWLNKG6R5i8/3029rlF9FRpZVA0MEFQhTgzArlSlPTDiNJV1iAz8OkkTUKGuNb4wkoRn2vFXh222jsfAxOWFIIY7RHaTJdpP724R+SWLZeV6EVtX87EDnnFWAVJCOQ+6WsZC8aw+jKMbnTOFRZwXBS7HwV+EnPJNeZx8W0KIQV7Rg96J+o+jFu0A5QbWqTyPiw3Sh04gmc/YkybSkWMw317u0efxuvfj8rdRyVgTqnI3Qaln2kAbslHVD22cEhMO2sTV0dzRR2kMRt4yIxklC936bGsFtZAaJQFQG4L+5dCUQAf0/pRhMAtIUegX2Hn8t4L8nc7ZX8efnPZLC92LTu+vMkIAv7v93JYO6WUM9tTmtPYwffNtfZM/yk91H4LGIYE+6DIVhvaj1zoqNVnbgxbEIqhmx7tjcW2kMBSNTxE1LBNE9DECoW28ynaba+AzrZi+4L/gfcF6Ojw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5494d31d-9442-4625-1e2d-08d81993e58d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB3580.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 05:43:47.7121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxjbtYTIY79PwCcfkltkEHO1ivZBhwCREUEkBEl9RyrKtQvnZSTORM9G7FMzghUt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2316
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_01:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=680 cotscore=-2147483648 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 04:13:56PM +0200, Jakub Sitnicki wrote:
> To support multi-prog link-based attachments for new netns attach types, we
> need to keep track of more than one bpf_link per attach type. Hence,
> convert net->bpf.links into a list, that currently can be either empty or
> have just one item.
> 
> Instead of reusing bpf_prog_list from bpf-cgroup, we link together
> bpf_netns_link's themselves. This makes list management simpler as we don't
> have to allocate, initialize, and later release list elements. We can do
> this because multi-prog attachment will be available only for bpf_link, and
> we don't need to build a list of programs attached directly and indirectly
> via links.
Acked-by: Martin KaFai Lau <kafai@fb.com>
