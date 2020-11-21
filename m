Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC912BBC71
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgKUC72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:59:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgKUC71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 21:59:27 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AL2uX2q026425;
        Fri, 20 Nov 2020 18:59:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=fhg47LzGKTSJrtFr8FQZfj7Mxs6MlqW4ByYlk6cCWoY=;
 b=B0vG3UX1jpPZcXQgKvaaW/bgnsmSWq0UC4qe3Vmp3QgKz4kD/GqBnpT998SgWI5Fe1ID
 m4RCxxuNcL/XxmHxgGfIjLC9Hd1qYQ7HYK/Ot14X/4c4SkjM1nEbqDKqlqVrCU3dRtjb
 crd7VCt0Q6I4cL/HrHE9McOHPefgJk22EpU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wx1ss26e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 Nov 2020 18:59:11 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 20 Nov 2020 18:59:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUJfV9fpIa28BSmtUIRtAMxeunDxQJXQdFACbWBC77kjU1nyvBcxTA60nV8idlQYxSESoWESLd4JqI+uocg1kmKV13AfSbySLS0dALsFIMeO/BbO6tPyGobjHJbcbzmgkzwsatdkAQYFvrgnm0WdJ7l50T9b0HLm4yI7khAboGLKzIoZ2Eb4C2sDQNS/HhpTyywpGdWOmt191Dn91lbb5+jrObGcRZ/29KZDDaBN/Ju6kzXvf0N0lHAsF5WnbTuD7ct4o9JsInzPac051eod/Aq8iPaQDbB1s+Emr9Gso82A5Oep+9iUxU0GpbVd3d5pxvx3oGGd04ROs1YF6J2VVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhg47LzGKTSJrtFr8FQZfj7Mxs6MlqW4ByYlk6cCWoY=;
 b=JVzLoP9+Exuvyf69pBPfacZ7mqlAMFOV4qitCOf2L1ivVk9UFDtN9WqLzLKG+PZoLUtT7qH8z++6i/TP9zbQoJAy+/CDWjv1nYacwKPi/3QATVNtXuNa5StX8RJhFbjrO9PTYBNtVRPODR5pqkO1+SxEeRJchR5x2Hx95dw+tKgFyD0S9bQpi4OylgEa7f6FV7Ij6E1ExS3rRAaKWHJrFAdD3879/8ZMzJbmSdeTXJWcORYwR9UrJMcwxxIb8s/nGYgCnW2cEA1lyMiu1uhQhnl6mQ/XygqlCRK139JI9r3wcSCEZ3XnYzMdwaS57K6KCb2Lp3SfwyW/HmuKw4/1CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhg47LzGKTSJrtFr8FQZfj7Mxs6MlqW4ByYlk6cCWoY=;
 b=ReU+zE5Gbnv/i1/ouvAyqA89GMkbN4i2AHjCUG/Vf/GBxumv7KKJb8YV/Mi+ngkR3KplxLfOOs5MO2GRKbkjrTtXupolN7yFYMXu4DUhPKtZXJlIrPEZ7DB4YLNP9d1bUzEgw2VX7RjMFzEbnzlrZrwckNIR2xJMigIv4YG1/Jw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BY5PR15MB3554.namprd15.prod.outlook.com (2603:10b6:a03:1b5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.25; Sat, 21 Nov
 2020 02:59:09 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%7]) with mapi id 15.20.3589.021; Sat, 21 Nov 2020
 02:59:09 +0000
Date:   Fri, 20 Nov 2020 18:59:04 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     <bpf@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <andrii@kernel.org>,
        <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v7 32/34] bpf: eliminate rlimit-based memory
 accounting infra for bpf maps
Message-ID: <20201121025904.GA478375@carbon.DHCP.thefacebook.com>
References: <20201119173754.4125257-1-guro@fb.com>
 <20201119173754.4125257-33-guro@fb.com>
 <20201121025227.dypweojhaz7elwb3@ast-mbp>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201121025227.dypweojhaz7elwb3@ast-mbp>
X-Originating-IP: [2620:10d:c090:400::5:e649]
X-ClientProxiedBy: MWHPR22CA0033.namprd22.prod.outlook.com
 (2603:10b6:300:69::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:e649) by MWHPR22CA0033.namprd22.prod.outlook.com (2603:10b6:300:69::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Sat, 21 Nov 2020 02:59:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7c5fc46-3933-41ea-e9fb-08d88dc96a6d
X-MS-TrafficTypeDiagnostic: BY5PR15MB3554:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR15MB35547966E080A4F9EE37ACC5BEFE0@BY5PR15MB3554.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Omj25KAvZ43+Aqt2tpF2SqX377blQ1O0icaTK1lEZ/IEFopFfC0NYDRhev4Au1J+UQWJSUb5W67eEuubgjpJlD/fFWWSlF2uLP4ghPM3Uhnm6Wo5EHdHI6zn3Qt24jIMm5nllnHt2idBK7n2uE7JXefoeJMkEcuCWKATJoqKx2giv5ZopmZIiOCrp7YV42ADiCsLVWm9vsH05cJcd3hdfUHPk5lDd4EaUWq8fXAhaskd7VCbOVd5/g4O6tSUzhx2L9jgUb9wf7JgSqZzfRwRrXhwLhMTAb3I6ew5kqWD1V0gNg9NRtUVXk/RDabshtpKZaN/pL915myBPlKveWKQdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(136003)(346002)(366004)(316002)(9686003)(2906002)(8676002)(186003)(16526019)(1076003)(55016002)(83380400001)(5660300002)(33656002)(7696005)(52116002)(66556008)(6916009)(66476007)(8936002)(6666004)(478600001)(6506007)(4326008)(86362001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 855hzYznFeq76B92WLnk72ElZQ836S6QflsnHGN0Xmf/jYQgUJ9RsnvCl+lxGf5oqalIxukdENNFlD54bTLEv+dbYZa5Qiq7bHI8KIONG1pHtjtdh+g9D/eXO4gC2xdwFaNKyUKYZGFkFD++hMbTER7g/xwfKE0quyQTBis5rhEBP1sOsZD3CTOIz91RiC+q2eWGdoy7X4Zd3XBlk/cJercI9kOAgEYp8BrA0Vqq+sPZ9heU8BWKijUnlUBIXDObFDID9+tratPP5aMblmrIgNwooelaWKbpR65kXvAEVPZW5Z0m/4c8dgE45dUiMT2gu6/PZQBl+tEcIZGtFFeutERqeIS456XkbtTdTyruf8f7lezgeiZJmWzQvN9a+hdQ/rZLkwOSpVTdfpJePC/qI52mCwExntoXvFQCUocvND7oK+Yv6M10uKbVPrme28B43W9F7WvF38Bwq+lxTyCCjBCMqj9Ctkv/tOAUd+FnM+YEI9xqD9x2JnzqQfMWrLFm1XOWlLDxA1VeuLTYBvHLwhQS+eYpSN108lJuPRXqsDD/mUNYhVa+KNt7p2zWOGn+IbTJgBseNCD2vzeCdOfEK5kjxB6x2xmt4/TZExETqMCHisnBvqUZgN0R2CTkLfhmszoszCCJZwkQ2WHNeUsCFwJBCf0qCckOPMc833AXDBg=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c5fc46-3933-41ea-e9fb-08d88dc96a6d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2020 02:59:09.1473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: czvZHuWA0XM3/CSqaGtBDrVViddUu3lgQfdsWYsB+Uhmk6Q/Tg/J4VFazFX9kJg2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3554
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_17:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=1 malwarescore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011210021
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 06:52:27PM -0800, Alexei Starovoitov wrote:
> On Thu, Nov 19, 2020 at 09:37:52AM -0800, Roman Gushchin wrote:
> >  static void bpf_map_put_uref(struct bpf_map *map)
> > @@ -619,7 +562,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
> >  		   "value_size:\t%u\n"
> >  		   "max_entries:\t%u\n"
> >  		   "map_flags:\t%#x\n"
> > -		   "memlock:\t%llu\n"
> > +		   "memlock:\t%llu\n" /* deprecated */
> >  		   "map_id:\t%u\n"
> >  		   "frozen:\t%u\n",
> >  		   map->map_type,
> > @@ -627,7 +570,7 @@ static void bpf_map_show_fdinfo(struct seq_file *m, struct file *filp)
> >  		   map->value_size,
> >  		   map->max_entries,
> >  		   map->map_flags,
> > -		   map->memory.pages * 1ULL << PAGE_SHIFT,
> > +		   0LLU,
> 
> The set looks great to me overall, but above change is problematic.
> There are tools out there that read this value.
> Returning zero might cause oncall alarms to trigger.
> I think we can be more accurate here.
> Instead of zero the kernel can return
> round_up(max_entries * round_up(key_size + value_size, 8), PAGE_SIZE)
> It's not the same as before, but at least the numbers won't suddenly
> go to zero and comparison between maps is still relevant.
> Of course we can introduce a page size calculating callback per map type,
> but imo that would be overkill. These monitoring tools don't care about
> precise number, but rather about relative value and growth from one
> version of the application to another.
> 
> If Daniel doesn't find other issues this can be fixed in the follow up.

Makes total sense. I'll prepare a follow-up patch.

Thanks!
