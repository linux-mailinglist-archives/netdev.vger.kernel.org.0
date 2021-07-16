Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679133CBE04
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbhGPUv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:51:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230415AbhGPUv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 16:51:56 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GKkQC1011409;
        Fri, 16 Jul 2021 13:48:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=oIMVxzXX9U0VkjSmSGO+ZgDWJTrUa12AlEEwTkUgHOM=;
 b=WgRHbOek3OUjOlGxlpBGx7rq6z4O10C+4+iuukMYUKwEBWyjha4CMc+8omkVXfVMvj9O
 UHPULbwhFmjSZE/FYPYqf8jQqfvNb1zf/rqivw0tLri/FSjl5rrqMcFBWWwQA+c9gMfg
 YYywu78Sv1OGTLzpAJGTsUNMbwEw1NPr5WY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 39tw3bpf8e-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 16 Jul 2021 13:48:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 13:48:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfpXf0fjz8PgTr2TssDkGVzK65XwY/p4Tj7FjmoJLSRYbIC2/f8KCrJVeSw7+XtkM5XiBGzAOvQ3RCptJrB8es9hSsS+gQ3nlWTSItffQcKrO6D9B7Upa06BaxLQVYPNS26Al560WYJSEUA3NHiiNcgsWufUf0G0PaZdoKWHlZgXBEq8QcALlUekmRaEyzFDvxiu1dW+i3PNRJyRESWKceJxT2Pgt7J8C2iwvfzN36BtQhOaTOzS9pqyDqmz+TqYBdNdt9B8aR9ahWFaq6QwNIZdMRwHLGdLG/ec7YXBn1fBY1EQO73rnVXcJHZsadhVv22VJzFt4D8peKeGyQGurQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIMVxzXX9U0VkjSmSGO+ZgDWJTrUa12AlEEwTkUgHOM=;
 b=hTCDQkeYABRkRadYpND6YuBRhw0TVv7PcqOETJLKgiWSp08pWtXgL5zI1KNODwALJ/nBlkMnGFahZnGtOtEGVs0kpRl/SU3oN/PJFdRXhJgj31bdQMuNlph2JZacIAZOgoGoCs1xZoIwag1z0FQflIjpZfjWgns/Qi2ypgKm9aF5OvqZmdsnqVnKuHlPuPwHXXgH/6Eqkmf7rVIdcp/XIxk0FJ9jBNgDuZAaHwMriSH4ACqgsEadBRYYa6EDv5EmRPvOtopGC9AgtSyhd5fk1X6BD9x2wEdp++Sv/2E8Idpt49Lm5+hFHWlGc4v//qPluZg0Se9xZW7bp0ma9A5teQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: colorado.edu; dkim=none (message not signed)
 header.d=none;colorado.edu; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB5047.namprd15.prod.outlook.com (2603:10b6:806:1da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Fri, 16 Jul
 2021 20:48:20 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::1b5:fa51:a2b9:28f%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 20:48:20 +0000
Date:   Fri, 16 Jul 2021 13:48:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Sandesh Dhawaskar Sathyanarayana 
        <Sandesh.DhawaskarSathyanarayana@colorado.edu>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Lapukhov <petr@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Prashanth Kannan <pkannan@fb.com>
Subject: Re: How to limit TCP packet lengths given to TC egress EBPF programs?
Message-ID: <20210716204817.bsh7xpoyrdmvupix@kafai-mbp.dhcp.thefacebook.com>
References: <MN2PR11MB4173595C36B9876CBF2CCFA1A6189@MN2PR11MB4173.namprd11.prod.outlook.com>
 <CAADnVQJ9M6ip6uYb9ky=eH-Z1BO-cTeGOpYs0M3EZrgURWpNcQ@mail.gmail.com>
 <CABX6iNqj-ojymaPhPtgeOGxtUS6evyrvN69MrLD7s_+Z3xAK+w@mail.gmail.com>
 <CAADnVQL2zxCjq0AwTXVgrfs9Cem_7vyzTJj2novVJqObGFK52w@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAADnVQL2zxCjq0AwTXVgrfs9Cem_7vyzTJj2novVJqObGFK52w@mail.gmail.com>
X-ClientProxiedBy: BYAPR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::23) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:507b) by BYAPR02CA0010.namprd02.prod.outlook.com (2603:10b6:a02:ee::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 20:48:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6d00e45-c194-4e84-25a6-08d9489b0b50
X-MS-TrafficTypeDiagnostic: SA1PR15MB5047:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB5047CF7D4C52579B6FC94981D5119@SA1PR15MB5047.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tFU4hecC2CBsE/VzyNDc+PlgNBAEa/KoPVkPMgTDblIHaj9MM72ncukCVIKjbiXb2rhImR+VQTvfkWZMFRATfYEu7Y1J7jlonuWQWbf7CuxiN86i2/sR6Tra0REhZKjnnRLadZVTydz65AGZigFNIPFIbud0Jl9CvZ32Gla1L2knf3+MXLEDMsyjc8j4zEmavx8jfJaoFwFFvFqo4JD1MhduOAphFF7Ed0LZIEcRb5214ZTqrktmnJ6ZqWG5XRqHdByYBU6/GFvuqTwEetf5V6EllCj40tkocdjvVeMYVZnrzEaZsDn1b+7rRhUm33Z+LaqL2Zm59U0RBf5cj5xwYf2uLUBwpAvOaCd/S9Lr/8cW6MupKtGKJ4WAAFYopuwPwfSAqjIqIAtMsNIo5ESpeAcDRQ0+Nq67KqAhtDlF+dO/iQkPGwJ6fRKVCio/jAIz6T05TdMQ+gR6tizr1iIO0x7TB8HAgAMgwU8nnr4SGgrWpagEIapUVYHL3jStv2btorsyIrHqudGwdLheSCTlOW5LePRoCYDjU+BGJDNCxjwHpzbDADSRCyAFRmEwfrolGaCLPEaYKpZonTNHjCyx5Q8agSzycMQbSaiIYvUhnrhZDloYd1m0TmmZ6hT2+glKKEs9fBjS4v2ntKP3Kle/7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(66476007)(316002)(5660300002)(83380400001)(6916009)(66556008)(2906002)(38100700002)(1076003)(8676002)(53546011)(6506007)(186003)(86362001)(66946007)(478600001)(8936002)(52116002)(9686003)(4326008)(7696005)(55016002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HIwcbUHXgqtgUKiuzp65svp2IBTn8VtDklpEJ8MnUwujtgjVNUgvxvd39vpB?=
 =?us-ascii?Q?SSqrGn2GpSE6WuMLG+d7GHzLPjHYYKb2s0JmAXEqLIgvPFaW8Gk3qGHVeKA/?=
 =?us-ascii?Q?72gPCEHsISbHqi2I0tcv8pAEpMm03GEk37WjnJVEv8CYi8e70AgOvhRxVwn5?=
 =?us-ascii?Q?IHmZi7PDCJPm34bfHjRgcgCSsa9v9YaFvYfRRXwscjS9qr1jeOhAy/XUybSp?=
 =?us-ascii?Q?XB4UFeMrcyvB46DQ6VOIGJhuZehMJwea3IbNELDwzsts/KyANXnxDnc0L3Zr?=
 =?us-ascii?Q?+jP/qUbasevh6GrINYHfyYssi/cgM1dWEVpkW5CDVCX2pSSW9lxn4YNxW924?=
 =?us-ascii?Q?YoxfEDXRk09qKylpWgHnFE++ErCjAnR6Fo1mFyCrbbDvDjxu/Q8pgUsAOpCT?=
 =?us-ascii?Q?mx7oSU0iDwcEG7SH/q4cvUi5fEzmt3plzOCWCW1LL5YuGZwMNMBLFa/+hoMz?=
 =?us-ascii?Q?ztym+Lb1NcACrnAMyjamM7wC18Zv/UXK+Dz40TibKN/brFct1uWjYzdRhWwr?=
 =?us-ascii?Q?mkRlcRaTbgKIZm+PF0ggoKsT7T5UsPcLLqoc5L6AGt7WWtz8ZiXakUAQLaFh?=
 =?us-ascii?Q?uevzT7dT7V1bg240THOBstH5OY0CFmNlBeM7iBdUtX//jNKq9ip2lywUSll1?=
 =?us-ascii?Q?UX364OovrNXseIFhgj1qhl+aIrDphYYFSKYd+MCKtsG27lwcwBcTTSQfKeQG?=
 =?us-ascii?Q?vjO/TFolIJyqYGZxh2yc86wcAeUurNxd6+OY5aOPI+X66zQvD64JJV7+2J20?=
 =?us-ascii?Q?C9zeIiOD+5hmcF9J/eOl+AN7xk8bk1DzAEUCYNovL1erbRHx8t4RYAZATYgc?=
 =?us-ascii?Q?O0GIt7I92NY37p6zE89BX+RNq7QriJ+2lBU8UYi1VfiizYVC9jxKc/VRamFS?=
 =?us-ascii?Q?Y+X9OqdKspR1xavyG8BWYJoAmR1D5uL+FGZ4310Vio7li+PBw+r7/bMJaUBR?=
 =?us-ascii?Q?255II5M71A/JND2JRT3d/ytmGoGJr+ThH8m3MPEndwlgXBj5UqQ/X+qUZ/l0?=
 =?us-ascii?Q?oDAZ3FCbo5Olgk7XwjYgbJVCiKVTeOLlBkxtprFH9kbV0YyCykBBvZpGV3JS?=
 =?us-ascii?Q?vMB0cxCKAfGfgZYSpODJ80MQAjGCz51cjQad+VYqIhEUzuHaPYxghmzqvNZy?=
 =?us-ascii?Q?p7AqcLxMSxL+34m0Wj6FCmztu/zfg8RZ6lGtgBpehdN9AS/brn4I29psRocw?=
 =?us-ascii?Q?/jeCiZuyqAOeY9FaGdZ8JxEV3trAzA0z/wfLyXa2F0en38LeVt+g8eIF6eRl?=
 =?us-ascii?Q?kFf9xhEhmodIUX9p4SCiZ/H1VT1Ba0FYkv1jQpSjolqBtBJ22NGSQA4/JUHR?=
 =?us-ascii?Q?K+g3dggYSsgpouIzQ4hq+/7u2mMCz7DAPBLrtou8xgsV3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6d00e45-c194-4e84-25a6-08d9489b0b50
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 20:48:19.9465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WOdwhdILXvuz67Xw1PHO7725iIi9uMIUgs+QopewphjCcPE9UrbUC2NZRm8y3aKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5047
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 1M2iBUIh8LdkacPPuFBozVCzY1ZqSl_g
X-Proofpoint-GUID: 1M2iBUIh8LdkacPPuFBozVCzY1ZqSl_g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-16_09:2021-07-16,2021-07-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 mlxlogscore=367 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2107160132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 05:14:45PM -0700, Alexei Starovoitov wrote:
> On Thu, Jul 15, 2021 at 4:26 PM Sandesh Dhawaskar Sathyanarayana
> <Sandesh.DhawaskarSathyanarayana@colorado.edu> wrote:
> >
> > Hi ,
> 
> Please do not top post and do not use html in your replies.
> 
> > I tested the new TCP experimental headers as INT headers in TCP options. But this does not work.
> > Programmable switch looks for the INT header after 20 bytes of TCP header. If it finds INT then it just appends its own INT data by parsing INT field in TCP,else it appends its own INT header with data after 20 bytes and if any TCP option is present it will append that after INT.
Does it mean the switch can only look for INT at the fixed 20 bytes offset?

> > Now if we use the TCP options field in the end host as INT fields, the switch looks at TCP header options as INT and appends just the data. Now that the switch has consumed TCP option as INT data, it will not find TCP options to append after it puts its INT data as result the packets will be dropped in the switch.
This part I still don't understand after parsing a few times.

Does it mean the switch has an issue when "INT" is put under a proper
TCP header option like (kind, length, INT)?

> >
> > Hence we need a new way to create INT header space in the TCP kernel stack itself.
> >
> >
> > Here is what I did:
> >
> > 1. Reserved the space in the TCP header option using BPF_SOCK_OPS_HDR_OPT_LEN_CB.
> > 2. Used the TC-eBPF at egress to write INT header in this field.
> 
> Hard to guess without looking at the actual code,
> but sounds like you did bpf_reserve_hdr_opt() as sockops program,
> but didn't do bpf_store_hdr_opt() in BPF_SOCK_OPS_WRITE_HDR_OPT_CB ?
> and instead tried to write it in TC layer?
> That won't work of course.
> Please see progs/test_tcp_hdr_options.c example.
> 
> cc-ing Martin for further questions.
> 
> > But these packets get dropped at switch as the TCP length doesn;t match.
Why the length does not match?  Which box changed the header option
without changing the offset in the tcp header?

> >
> > Also another challenge in appending the INT in the end host at TC-eBPF (currently no support for TCP) is it breaks the TCP SYN and ACK mechanism resulting in spurious retransmissions.  As kernel is not aware of appended data in TC-eBPF at egress.
hmm... so this TC-eBPF approach is a separate attempt unrelated to
the tcp@BPF_SOCK_OPS_HDR_OPT_LEN_CB above, right?

and what caused the tcp syn get dropped?  the tcp data offset (th->doff)?

I think we are not on the same page.  May be start with these questions:
1. Please share the bpf code handling BPF_SOCK_OPS_HDR_OPT_LEN_CB.
2. Exactly how you wanted the TCP header, INT, header option to look like
   for an outgoing packet from the sender end-host.  To be practical,
   lets assume there is always a timestamp option.
   Please spell out the value in th->doff (data offset) and
   also what header option "kind" you have used to store the "INT".
   It seems you have used the experimental kind (254)?
3. When the switch sees the "INT" header option, how does it
   append its data and how the tcp header will look like at the end.
