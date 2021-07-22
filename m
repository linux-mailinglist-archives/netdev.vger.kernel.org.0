Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B882F3D2F4D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 23:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhGVVDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 17:03:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51408 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231799AbhGVVDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 17:03:03 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MLSIKd026510;
        Thu, 22 Jul 2021 14:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=1wP7aVQTH/RZz6T4LAm6SF/fDV7AEKG+R/7yw3HBjAI=;
 b=fg94bT3HU5Qmmabh59Z5aJB7+3sWl3TEmiHHwyJy7zmbj6Cw/8g5e+r9Ts+Yyib9zKCw
 c8pqjkJ3TDqdmRD+lpPqTVOOAOhcqLI3LCJmoeCgHIqwiPEteCZVeZroikjtvus5EsF8
 H8oKHMa3X0tODMG3Z64T9DpuS49yuybFKUE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39y99u364k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 22 Jul 2021 14:43:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 14:42:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5rG9m1SZRZgar/l4CukduiwduvhNWhik0bUDgfeYLebV3edavOJkL4pS0IxF9U8DdZPBlLWmsZ5U/7hQJTHggy83W02Lx9kUWf4XmGCPGqJ2R10xMui3eomAzaXrWhSdXEAp0LbOtSpv1r6nLcMHmYcgRyDEdbFii+n51AGk1Q8EwVhoF6dyH5Z9NnSWG5IDFvnpjx5l6K8gEEIQXagARVoMxbvf0HtfLy0PSr7DKdgltmAhkZCqXzzQqmcyPT3P6VC0xctX94Qly11tJkhxA+OE2M/AA+LxVXmiuShv41/kIZeI1o44SD7ccBl2kGbqzq9tXDIGW07k3j9ZGWJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1wP7aVQTH/RZz6T4LAm6SF/fDV7AEKG+R/7yw3HBjAI=;
 b=Fff4qGjH/QwSWGO2cmEn0LdWjoZuJlFBqhncapSrBVA6M5CyDWc0qGxvUrB49MJgQslBKv2Ei3Fi1e/mjOdQgcmxGkHpfpd4m6q7Qbp/8OaEomG3WC/0REnV3vc6d0F8XBuNNYstqlg9/MzoRTsT4w9G0R809e5W9CUKhG3ftxC4NBklK7PXt5SbcVJhBmz3cKpiMuwknGTRReAorrV2HxOpIpsKTRc9BjC4XVizRnC0MLnuwRgOzwv345ZPkV21UkMwYqpdeQD7m2AbC2c7zrz8ewCiSjAfXV7LCIsonrsW/B+vbUkQJzPhmof5X9tSyfLcXJP4We+DOsv+ZkpR9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: amazon.co.jp; dkim=none (message not signed)
 header.d=none;amazon.co.jp; dmarc=none action=none header.from=fb.com;
Received: from CO1PR15MB5017.namprd15.prod.outlook.com (2603:10b6:303:e8::19)
 by MW3PR15MB3978.namprd15.prod.outlook.com (2603:10b6:303:40::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 21:42:58 +0000
Received: from CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9d22:c005:431:c65c]) by CO1PR15MB5017.namprd15.prod.outlook.com
 ([fe80::9d22:c005:431:c65c%4]) with mapi id 15.20.4352.026; Thu, 22 Jul 2021
 21:42:58 +0000
Date:   Thu, 22 Jul 2021 14:42:56 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <edumazet@google.com>, <kernel-team@fb.com>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <ycheng@google.com>, <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next 1/8] tcp: seq_file: Avoid skipping sk during
 tcp_seek_last_pos
Message-ID: <20210722214256.ncuz6k5bjt4vgru6@kafai-mbp.dhcp.thefacebook.com>
References: <20210722141637.68161-1-kuniyu@amazon.co.jp>
 <20210722150810.74315-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210722150810.74315-1-kuniyu@amazon.co.jp>
X-ClientProxiedBy: BYAPR02CA0014.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::27) To CO1PR15MB5017.namprd15.prod.outlook.com
 (2603:10b6:303:e8::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:b2b8) by BYAPR02CA0014.namprd02.prod.outlook.com (2603:10b6:a02:ee::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 21:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4e0f65c-1c81-4a81-ca09-08d94d59abbc
X-MS-TrafficTypeDiagnostic: MW3PR15MB3978:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB39785C88B5A56055C86F0CF9D5E49@MW3PR15MB3978.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WRb+VcrmdNj/B5lAjDrA6ZZJvEcH1oYoA+pQLFVG3oqVcocotmZRrsi9S3FvQVhNYqzx6xuISuXabUewfb7Rh+xWSO3EwLC8N/9MIDYPUDeG1yKjOMxgmiNJw5Cj73zFCXupapXYotH4q4spHZiAoqSR4D2g5mBHBr6o4aJBrEu2g96RHmu2xGU+E7rLtKOol5v9iHe2Nxi0bH3BIM8c30JER+fvMVWPJ1Rul9WqYHyGHLCbBXhMap+Fdc6Ubqqsdo+rga5KkPngRUfbXBkqOEFT1S+gvYDytCL2t8UbdDR3C0WSEfsiUfLMQpba2/bRcooZqrqjtzlCjQ7z5A8ysDuMHy+7yIsOUok8JeNPN5SipnlpiIwoMzW4o5O5y0XiJ3jGoX4BQMwejYueB9YxG/mPUe0gtVtU6KczpqveRzAVYZ9Qrdc4AVrZrth0gCh2/IKDaOgzpTSQlDZWEhqGa43WfQkoVhcfRxwkzK+5cDlVI3JFMZtdcXhA4HSdHWVyRFh7m5egMFkdnfPwrlmAH6IqvFu3TtQiheJCyqJ0LjIzspBTdjlbGu4lc7SuNBU0HWuhSRvz5fCThy7P/Xp2zx7/QCqWfFlA+g+3hC02lg/Uk+SZ2+S4A71/PG9jRCW6/KKtYPVvGANkqa3vWbdjdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB5017.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(2906002)(4326008)(8936002)(316002)(38100700002)(9686003)(478600001)(52116002)(86362001)(8676002)(7696005)(6506007)(5660300002)(1076003)(83380400001)(186003)(6916009)(66476007)(55016002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Psu3rWDCHIkurXytl3qJiMACmFIz0ISz6GnB4/Hn0o3PkSIRZNYWpoTTVZxD?=
 =?us-ascii?Q?nGq0I5oYRGOEVuU75L0xGyxnX9WdELZ1V9NJjjDLg0/2pqJtiSW+7ABSW9oM?=
 =?us-ascii?Q?K4vQ2Io1ZcjtkkpSNAnrFqZWxCv3764Gl2X1W0fAtjoV4dSlFYwpFiIr+P64?=
 =?us-ascii?Q?DVMI+tydMWKwz83qc8umAZdGmCbMNF2Mk3gmP6EcqCYNzOgsDQE6sNvhSsjJ?=
 =?us-ascii?Q?+YezQoVAYNgj6POITPRNnoM6KeVKsyx48+d7zf3UbN5gxelNVqTsFp9hm5wI?=
 =?us-ascii?Q?HCgcM2pS/PlDKYQszIZnYtPO4KHNIW5DoVd5/oHWpZHp3JTJEKnRyHj3hR2c?=
 =?us-ascii?Q?47IR8YwGwPDRoLTt5FUzwA5jqp+HovbDU+o9QbrPXqxFhgVlXU2mu5sQyHnf?=
 =?us-ascii?Q?hwx2Xd7X0DLPPi8v+7a+6YbjnoNRL2W0MTnQgUoVVMt8Mb91wxhypV8Ud6XQ?=
 =?us-ascii?Q?9+WsRKAyuYNq5a7FIoxxQ8uPMnddMz1O70/wRHcjRnu3Vs/uwY10kVWXw81b?=
 =?us-ascii?Q?qrNGN+uiLC3q4Lstra6dztjnKzQSKgX4Vfl5gKN6JNnlKohzsJ75i1/UW8ua?=
 =?us-ascii?Q?Pp4KDu3Kf74Gg3rcg5U665bhm5Cy3Eg73aOHHcsksiHWCcjuAQx5trSrPhY+?=
 =?us-ascii?Q?G+Wussj7n2DkbpTVrYBxOm5W1n7qLy5nwX46+vI0cWrh0YH525AVJEenUHXT?=
 =?us-ascii?Q?xGmOvnz/cvOy/XCEFimUKp15qlDF+2iBcamfRLwMzSv2Cq/eqChCOUHdVSKC?=
 =?us-ascii?Q?4lnQaTApfyt70Dig1AEn9ALQK5fCzU1CqeDD2GZmhaiJY/5+S6e3pvXkDXGy?=
 =?us-ascii?Q?CTXeoyvOwFAVTn46YNlmvJuGnrsjfML/GJjFkXu7e/LFf3gJ0ETnwiIP/Gz2?=
 =?us-ascii?Q?valPj+sXzfwXQ8YYJ813yCIwy3E8fRol6Q8zFdgBW4eRIAZ57yGYTbL/cR83?=
 =?us-ascii?Q?1KcVbfgGSIb9rIednhWd31TezIyMllOubrwvWfyQOq6XDuw2oA5KmJU8tJhZ?=
 =?us-ascii?Q?qHrPp9aLiGP2NnA9pOjczL7lbUMBq/PS2hhsN8BZKB1P0HedFifMlkmyVxDm?=
 =?us-ascii?Q?9LOvpZy4+11m2WdDNwpomOxdM+iRKGbmuFWJhEi17zuEccyccD4ZubsWra/K?=
 =?us-ascii?Q?0KRwVWjibERAlJC9zIHvFeTZCWSZ3WmoZBjPMqM2V5acvfuBWDLWo/NV8xOH?=
 =?us-ascii?Q?4sEYWAONdYOodLtaIcUTZhfPS/VsBxOrDVgd/DRpoUED82jSDI2yy1U1Obn2?=
 =?us-ascii?Q?Y3FYAgKhjOlk2DZ26DtnQ85SCMkCjEprPmS9GABheiumgegdkJCmIiDYL2yX?=
 =?us-ascii?Q?Vc/YinV5Y/JPv95PUPbWd7PplV3TrVamMiDb1PT4r2E9Sw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4e0f65c-1c81-4a81-ca09-08d94d59abbc
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB5017.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 21:42:58.0062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c10NTjPMX/MscCTx3C8mzAac+BELUkfzBYwB/k7Fte5s9v6yo7HE2azuFkuQO7fI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3978
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: FSOuMgY6Ti1B1afSdQQT1Zmljq7RykDK
X-Proofpoint-ORIG-GUID: FSOuMgY6Ti1B1afSdQQT1Zmljq7RykDK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-22_12:2021-07-22,2021-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 spamscore=0 mlxscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220140
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:08:10AM +0900, Kuniyuki Iwashima wrote:
> From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Date:   Thu, 22 Jul 2021 23:16:37 +0900
> > From:   Martin KaFai Lau <kafai@fb.com>
> > Date:   Thu, 1 Jul 2021 13:05:41 -0700
> > > st->bucket stores the current bucket number.
> > > st->offset stores the offset within this bucket that is the sk to be
> > > seq_show().  Thus, st->offset only makes sense within the same
> > > st->bucket.
> > > 
> > > These two variables are an optimization for the common no-lseek case.
> > > When resuming the seq_file iteration (i.e. seq_start()),
> > > tcp_seek_last_pos() tries to continue from the st->offset
> > > at bucket st->bucket.
> > > 
> > > However, it is possible that the bucket pointed by st->bucket
> > > has changed and st->offset may end up skipping the whole st->bucket
> > > without finding a sk.  In this case, tcp_seek_last_pos() currently
> > > continues to satisfy the offset condition in the next (and incorrect)
> > > bucket.  Instead, regardless of the offset value, the first sk of the
> > > next bucket should be returned.  Thus, "bucket == st->bucket" check is
> > > added to tcp_seek_last_pos().
> > > 
> > > The chance of hitting this is small and the issue is a decade old,
> > > so targeting for the next tree.
> > 
> > Multiple read()s or lseek()+read() can call tcp_seek_last_pos().
> > 
> > IIUC, the problem happens when the sockets placed before the last shown
> > socket in the list are closed between some read()s or lseek() and read().
> > 
> > I think there is still a case where bucket is valid but offset is invalid:
> > 
> >   listening_hash[1] -> sk1 -> sk2 -> sk3 -> nulls
> >   listening_hash[2] -> sk4 -> sk5 -> nulls
> > 
> >   read(/proc/net/tcp)
> >     end up with sk2
> > 
> >   close(sk1)
> > 
> >   listening_hash[1] -> sk2 -> sk3 -> nulls
> >   listening_hash[2] -> sk4 -> sk5 -> nulls
> > 
> >   read(/proc/net/tcp) (resume)
> >     offset = 2
> > 
> >     listening_get_next() returns sk2
> > 
> >     while (offset--)
> >       1st loop listening_get_next() returns sk3 (bucket == st->bucket)
> >       2nd loop listening_get_next() returns sk4 (bucket != st->bucket)
> > 
> >     show() starts from sk4
> > 
> >     only is sk3 skipped, but should be shown.
> 
> Sorry, this example is wrong.
> We can handle this properly by testing bucket != st->bucket.
> 
> In the case below, we cannot check if the offset is valid or not by testing
> the bucket.
> 
>   listening_hash[1] -> sk1 -> sk2 -> sk3 -> sk4 -> nulls
> 
>   read(/proc/net/tcp)
>     end up with sk2
> 
>   close(sk1)
> 
>   listening_hash[1] -> sk2 -> sk3 -> sk4 -> nulls
> 
>   read(/proc/net/tcp) (resume)
>     offset = 2
> 
>     listening_get_first() returns sk2
> 
>     while (offset--)
>       1st loop listening_get_next() returns sk3 (bucket == st->bucket)
>       2nd loop listening_get_next() returns sk4 (bucket == st->bucket)
> 
>     show() starts from sk4
> 
>     only is sk3 skipped, but should be shown.
> 
> 
> > 
> > In listening_get_next(), we can check if we passed through sk2, but this
> > does not work well if sk2 itself is closed... then there are no way to
> > check the offset is valid or not.
> > 
> > Handling this may be too much though, what do you think ?
There will be cases that misses sk after releasing
the bucket lock (and then things changed).  For example,
another case could be sk_new is added to the head of the bucket,
although it could arguably be treated as a legit miss since
"cat /proc/net/tcp" has already been in-progress.

The chance of hitting m->buf limit and that bucket gets changed should be slim.
If there is use case such that lhash2 (already hashed by port+addr) is still
having a large bucket (e.g. many SO_REUSEPORT), it will be a better problem
to solve first.  imo, remembering sk2 to solve the "cat /proc/net/tcp" alone
does not worth it.

Thanks for the review!
