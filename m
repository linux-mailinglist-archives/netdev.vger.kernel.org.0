Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D87300CA1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 20:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729329AbhAVTUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 14:20:31 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51764 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbhAVSnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 13:43:24 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MGP6mg125561;
        Fri, 22 Jan 2021 16:31:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=VKj7cqRS1lDqnMPoJXAIyPEjdEi5+/rMPAHZDTBK/0Q=;
 b=ODG+p78iu3UdUuR+NmY7ntlpbBZmI2qnf3RGxugQlvH/VOqu3YW1LphB8GiBGXo4+50g
 lxu9xxEfbOP6tD3S1NW62MzssyX+KxMoq7Hs4GHbUDHZkZMAI3rzMvJ7ejQsk69GsG5G
 j/pD0gUfVt0NK1myL/rqyrC5Db2oQ6K4b6kRHxbvRvB/5MAwMFBGlPSwPlBnN2aOU8Xf
 +dJnzgYJi2c4OYIjIsTXsrRUoyzFeAaw0wBT8aoPFuIfhy+SL1fsRzW9wg5cpXaDeSi3
 1OWO2Nbwy9TNDU3gM6OyOp8rM8GFDPcBeB8xZXj48FILSyBcmjZ+25oq3uovaIq8vozo gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3668qrmw19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 16:31:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10MGPC6Y110852;
        Fri, 22 Jan 2021 16:31:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 3668r19dxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 16:31:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CK5ihlSRn45tWA1JPOH7hM2I6iRltyOghOD3mx/JmqSbHddUeE7tVYPawhLJOXzdCHyfDpezIIY8AKYWbasGnOdhXJiZlzolbxSnGnYPmTMoTpQQAd+M5Wco3oBPK7DaCFAfxiqNZyDjoODnSIHEeDauhs++wEzhE6c+O+JIimqgz0dmI6OcJ8P9YPPNpPP5qW2Jnne0iEfN/fxwhusKrRYhRTnRqEm4RocufOTbj+VCfYSMkszxCxzJELE/sTbrFAylVVO5OUAXGWyzFtrAR0NQWxz1TxHIYDAGZIGO7SmgLsCC1ITA07o+6NuJatyBuWQBIaJ8VAR2fpVEeubn+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKj7cqRS1lDqnMPoJXAIyPEjdEi5+/rMPAHZDTBK/0Q=;
 b=LY/Kpl6mb254Ozqj6rgejP0hKhlwEbky++mloWi54vDG86xZxgsZ803iqK2vl6DSQJGLqQ5hiIqsJiXHQRCWhvuWOMfIhoMw0CCjpWzuQjjglBosdV3y6Wl0xmJ/FWtj/GoG36ZGiYuUJRm8v3wFFc7nsXrviR5IA+D8d+02/JPHiFhkVhdZNle6BOCTuZAL4A6RbKTpI8x9qhdW+tcPgXJMvgay4YarD8g8W9velSg4SQ4ydTq5PtHRoHJzatcInZMrqpKXJLTiEKBFQDZW+rMknjvaGnkjQAu+xtxvwnrYRocJ302aq22bvf5JpsvW/rGpHyH1JLk7OvJ+KAQCPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKj7cqRS1lDqnMPoJXAIyPEjdEi5+/rMPAHZDTBK/0Q=;
 b=t/rEgXnR79kDgxGCxqxEglSab8t9JrzBWzcHGstylc6sznpVpYGJKyjH7rPvhBoLcdAAfbQ+LtWV2ExQsiqywEklNeoVIZGO2fv4QeNMF+NM3Ncj4WWfvbcQhqhizJUnBCD8m9ENDxXxZcle1ZGvetesGxU/0vAHwcuVw0QqFK0=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4465.namprd10.prod.outlook.com (2603:10b6:303:6d::15)
 by MWHPR10MB1966.namprd10.prod.outlook.com (2603:10b6:300:10d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Fri, 22 Jan
 2021 16:31:29 +0000
Received: from CO1PR10MB4465.namprd10.prod.outlook.com
 ([fe80::e1ea:5126:3fce:4046]) by CO1PR10MB4465.namprd10.prod.outlook.com
 ([fe80::e1ea:5126:3fce:4046%7]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 16:31:29 +0000
Date:   Fri, 22 Jan 2021 16:31:15 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Bill Wendling <morbo@google.com>,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: BTF dumper support for typed
 data
In-Reply-To: <CAEf4Bzb4z+ZA+taOEo=N9eSGZaCqMALpFxShujm9GahBOFnhvg@mail.gmail.com>
Message-ID: <alpine.LRH.2.23.451.2101221612440.12992@localhost>
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com> <1610921764-7526-4-git-send-email-alan.maguire@oracle.com> <CAEf4BzZ6bYenSTUmwu7jXqQOyD=AG75oLsLE5B=9ycPjm1jOkw@mail.gmail.com>
 <CAEf4Bzb4z+ZA+taOEo=N9eSGZaCqMALpFxShujm9GahBOFnhvg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
X-Originating-IP: [2a02:6900:8208:1848::16ae]
X-ClientProxiedBy: LO2P123CA0043.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::31)
 To CO1PR10MB4465.namprd10.prod.outlook.com (2603:10b6:303:6d::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a02:6900:8208:1848::16ae) by LO2P123CA0043.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 16:31:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd8574d4-992a-40a8-a0cc-08d8bef32bb9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1966:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB196613CC3061A4F45D113877EFA09@MWHPR10MB1966.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GJolM//ygff0HSrHeElxr+hALN82uPeo7pVbzWFJSK/rGOgv4e014+JcRdKi2M7vgnr5r+oZQ4bNTfJK+CXOlGhLOnJqwEFTZUqadEDSkmTeFb+9RPvhZ9lm/ZW0ZnYopQwbE5PLgbkTd3EMLm1jfZxS8aQy03qgAknTjLe3chOwKkjCtFZ+5lm4omlTGIxshbVm1W40i3HtHTI0i7h9wnZTgeBGvELAOmVNxCkkDHhWI7Sln2xe1pd/cYXOHak9dHD5dD86ML86/uM9vBKSfuBFv8dPmCj8C+0uJlD5aLh1CWARNYGIGOE6wBXM+hI9o7laUVs56BkfYnJ5lweky3eI6z48sC/Ut69UyF+OVqG8wLbSd8jn2Z/Ypv2YLZCl3IWpNP45HyBG1GwwhmAR0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4465.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(66556008)(6916009)(6486002)(66476007)(4326008)(498600001)(53546011)(9686003)(8676002)(16526019)(6506007)(44832011)(54906003)(8936002)(6512007)(33716001)(186003)(66946007)(9576002)(7416002)(6666004)(83380400001)(86362001)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GHIbOjhkXhma3/xZaj4Ss+q6w49AD1LRPdvHuGZqWXswWoNGW7jkNvxUDEPG?=
 =?us-ascii?Q?NroPF7qHB2lK+MSfyiciuVlvD5KH1h2JYjDpN60dvzRDLib9KV8EQAH//cis?=
 =?us-ascii?Q?MkEeqXbwSRbngEC2i50Hi32ho6T3RdRgGf6pm+GxyG3t4z1BRe4ZAtaG7YlT?=
 =?us-ascii?Q?DxViyz0k9fJGQ/jdlscSCJpx4BQZ8vXZud9KkRSukQdX2FFjK1KNzDqFcHBb?=
 =?us-ascii?Q?LnqWIRY/HwAFIssTmbLgYpGUQBijdfU9icxvYsW1suIKPYFu8SxlBl959+vX?=
 =?us-ascii?Q?e5aOsZx0Rc63QsrYyqertM+TAVw1tOeb6jkP+GTlbGARokx0eWgHy8ocIT0e?=
 =?us-ascii?Q?BJoUXPkP/LPTiSIbkdRWkV8vCO9EgBHDgl+BlNIRWei8RpMUPCBAfQylUVtp?=
 =?us-ascii?Q?AVGMEL6oeik+qb7smFA6BHqKhVKZ+juG5UYrBRjN8PZh1Wfii+VxKJPBaUpb?=
 =?us-ascii?Q?RbPVsgbdwE+fBXOR/ZBuDYTygyyo2/6upifxc/n4gm6zmWH2TxVlCJ2R02x7?=
 =?us-ascii?Q?rHcn0gWSG4plxnKz/ORNLoIZbuzJXpb10nth5s2PDkQZdHYqIfFCtiVFQ/42?=
 =?us-ascii?Q?mwq7pY0kVcwWpQHDHLY4I81dyDvmU3M9Mp7F8N9zJrGBLAWbVB8TXuvn8U8D?=
 =?us-ascii?Q?j78HtXZya/7bCfIaELx4CRlKnljwxSaRfYX3DArB4yvs/C+z2+NiM5bfkXhs?=
 =?us-ascii?Q?Kdn68vK8rE1B7mlIh1dbOFmw5uLgQBCfyd9AJi2XEYzN8zJFKfG6srnbRcAs?=
 =?us-ascii?Q?DsDSVI0TJGrwbH5FB/4jciEkpVInEwnRzNyyyjrmdHrCY9Nk0b/q5qnIS4ma?=
 =?us-ascii?Q?eco2sCIBp2Ilt4JwWeZkwWpI5wwlvBX/kzikbzumYSUIq1jWBQVd0kn34UWB?=
 =?us-ascii?Q?iP4uhBesRmkehXw7k8PpR2WabtYUGq4dfAIJyYceWXgIDqs2xYdrARofsf+u?=
 =?us-ascii?Q?f1Q+DTsJfKgpXRAXlMKGIKaZb+H+lrOzLrwCjpKDGKbrcdEOaxnfkoT5pi48?=
 =?us-ascii?Q?DjZKYnMcQtkIs+PbtdGsH1zgbT0lZJEbjEX+4VjmcXp//2+NVNWbibWxanwO?=
 =?us-ascii?Q?UQ07FzdGK6POBDhRsq52/ecQQGbmYgVv1sEx5IJ6oOJMOpGT3lE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd8574d4-992a-40a8-a0cc-08d8bef32bb9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4465.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 16:31:29.3996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VuvKDKMAY9MPosvNh3Jm4NG42U9RNQPiRkXThVhwdt9xznKRG9lhBTtjd6ABdEjrAY6ZqSh2C8uRlBFTGkG4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1966
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101220089
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021, Andrii Nakryiko wrote:

> On Wed, Jan 20, 2021 at 10:56 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, Jan 17, 2021 at 2:22 PM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > Add a BTF dumper for typed data, so that the user can dump a typed
> > > version of the data provided.
> > >
> > > The API is
> > >
> > > int btf_dump__emit_type_data(struct btf_dump *d, __u32 id,
> > >                              const struct btf_dump_emit_type_data_opts *opts,
> > >                              void *data);
> > >
> 
> Two more things I realized about this API overnight:
> 
> 1. It's error-prone to specify only the pointer to data without
> specifying the size. If user screws up and scecifies wrong type ID or
> if BTF data is corrupted, then this API would start reading and
> printing memory outside the bounds. I think it's much better to also
> require user to specify the size and bail out with error if we reach
> the end of the allowed memory area.

Yep, good point, especially given in the tracing context we will likely
only have a subset of the data (e.g. part of the 16k representing a
task_struct).  The way I was approaching this was to return -E2BIG
and append a "..." to the dumped data denoting the data provided
didn't cover the size needed to fully represent the type. The idea is
the structure is too big for the data provided, hence E2BIG, but maybe 
there's a more intuitive way to do this? See below for more...

> 
> 2. This API would be more useful if it also returns the amount of
> "consumed" bytes. That way users can do more flexible and powerful
> pretty-printing of raw data. So on success we'll have >= 0 number of
> bytes used for dumping given BTF type, or <0 on error. WDYT?
> 

I like it! So 

1. if a user provides a too-big data object, we return the amount we used; and
2. if a user provides a too-small data object, we append "..." to the dump
  and return -E2BIG (or whatever error code).

However I wonder for case 2 if it'd be better to use a snprintf()-like 
semantic rather than an error code, returning the amount we would have 
used. That way we easily detect case 1 (size passed in > return value), 
case 2 (size passed in < return value), and errors can be treated separately.  
Feels to me that dealing with truncated data is going to be sufficiently 
frequent it might be good not to classify it as an error. Let me know if 
you think that makes sense.

I'm working on v3, and hope to have something early next week, but a quick 
reply to a question below...

> > > ...where the id is the BTF id of the data pointed to by the "void *"
> > > argument; for example the BTF id of "struct sk_buff" for a
> > > "struct skb *" data pointer.  Options supported are
> > >
> > >  - a starting indent level (indent_lvl)
> > >  - a set of boolean options to control dump display, similar to those
> > >    used for BPF helper bpf_snprintf_btf().  Options are
> > >         - compact : omit newlines and other indentation
> > >         - noname: omit member names
> > >         - zero: show zero-value members
> > >
> > > Default output format is identical to that dumped by bpf_snprintf_btf(),
> > > for example a "struct sk_buff" representation would look like this:
> > >
> > > struct sk_buff){
> > >  (union){
> > >   (struct){
> >
> > Curious, these explicit anonymous (union) and (struct), is that
> > preferred way for explicitness, or is it just because it makes
> > implementation simpler and thus was chosen? I.e., if the goal was to
> > mimic C-style data initialization, you'd just have plain .next = ...,
> > .prev = ..., .dev = ..., .dev_scratch = ..., all on the same level. So
> > just checking for myself.

The idea here is that we want to clarify if we're dealing with
an anonymous struct or union.  I wanted to have things work
like a C-style initializer as closely as possible, but I
realized it's not legit to initialize multiple values in a
union, and more importantly when we're trying to visually interpret
data, we really want to know if an anonymous container of data is
a structure (where all values represent different elements in the
structure) or a union (where we're seeing multiple interpretations of
the same value).

Thanks again for the detailed review!

Alan
