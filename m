Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA2A52DC27
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243465AbiESR7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 13:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243464AbiESR7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 13:59:02 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA11AD4101;
        Thu, 19 May 2022 10:59:00 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24JFGAW1013372;
        Thu, 19 May 2022 10:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=3JWtK0uhVfAGTpfPZSRZ58UBtBoXRW/gxN/zRIp02fQ=;
 b=Xos3KmqtDg6xrdJiyuSk5IRFVHrDH6j+ODbVWpyjmNePLgrkPDsVCMOmD+DPCAmQhV20
 3Heo5zrUUcHHuJf2toroXKWLk3UeQACu+OQErfH0n1awV5u9j/YNdSz9yuFoxkloPBa2
 bxXwiuFl5gPo5kThI6szT9q5MqKiesWp0EU= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by m0001303.ppops.net (PPS) with ESMTPS id 3g4myhwnys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 10:58:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDs4dMeaBRpJ0BYrG/gCgUn5tRLgv10U9raS/gKnGQV9uBci9opwLZKXdAXJg2JlHpkbGVn1GkKMB2it34/AteFAjR3mtPGbgZ6Pj9ficSxG/dwNJ24y/tdGYF6LU0gpR3aNvTDWT4sJzgSAfqx5FZnxoPA64BAHE0NVToKSL9uJlgCrMLk+21Is07Xzb9y4aRUG0zcn386VANEqidoLO/qZe/VInhfbAaDGqPqKin2JelcDcKZsRgzJsUj0mNS8aacIbVu6EEOeB6ljCg6YhBGSEgtTuASdt4tyELWVybXX5lFi0EOkhXWtGIu2myFSnklC+n/zd7cRbC1EupwsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JWtK0uhVfAGTpfPZSRZ58UBtBoXRW/gxN/zRIp02fQ=;
 b=Vox0sublqfS6Q0UNgxZAPdWrw+YnmygrI5Je9oXkDbyIL094/HUcnzLY1vqVP3wASNp3eh9mGFUNupaiofkXmd6JXNNTW1w6s6NxZQZk8pZVW5Irk8Lj+MyiWWOfhp0XNCkIXxZ7YgbYDUxljqo+T0JuvijHjldYIMduxeLiSJ5h8eiEqIdJUwhcvpAGjpWY2ddF4ZJ1CRJ5Hlt4VH4HkxVWmwui2JPMkgF08kwVwqozDq9ArPCZSwjgu9XwKhv4mznnbTKDv8kP/4BhGBNpL5c5JrCioG1dZ1aAObpT3E00WsknSY+IBtXYno17JZAqhIycPe+SqiAwKriTcsMYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by BN6PR15MB1490.namprd15.prod.outlook.com (2603:10b6:404:c5::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Thu, 19 May
 2022 17:58:35 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::f172:8f37:fe43:19a3%6]) with mapi id 15.20.5273.016; Thu, 19 May 2022
 17:58:35 +0000
Date:   Thu, 19 May 2022 10:58:32 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v4 1/7] bpf: add bpf_skc_to_mptcp_sock_proto
Message-ID: <20220519175832.huxwykgksqyeopvw@kafai-mbp>
References: <20220513224827.662254-1-mathew.j.martineau@linux.intel.com>
 <20220513224827.662254-2-mathew.j.martineau@linux.intel.com>
 <20220517010730.mmv6u2h25xyz4uwl@kafai-mbp.dhcp.thefacebook.com>
 <CA+WQbwvHidwt0ua=g67CJfmjtCow8SCvZp4Sz=2AZa+ocDxnpg@mail.gmail.com>
 <CAADnVQJ8V-B0GvOsQg1m37ij2nGJbzemB9p46o1PG4VSnf0kSg@mail.gmail.com>
 <cb2c23b0-a41a-bbf6-1440-69bbc58f8e8b@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cb2c23b0-a41a-bbf6-1440-69bbc58f8e8b@linux.intel.com>
X-ClientProxiedBy: SJ0P220CA0019.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::35) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba4424ff-5293-423c-8fe7-08da39c13193
X-MS-TrafficTypeDiagnostic: BN6PR15MB1490:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB1490B470AF85B83E97C6AF66D5D09@BN6PR15MB1490.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHFrhTmuXRn2Kjkk1lWxDWAUND2wEaSYyBB0oDHhlXk5hSahMWal5iScgwk8BPsUp5LO7sUP8s20XedD4SykNZD60JTr3FwdFDgO2SiL3VdgHmgG6Px37VPdmN3UM0XC9osSDvsw8revgADezXKGK9+ZoaY3kZHgsPXKovh/tn8iD4Yg5ANyNw2++fIq0fHmqcyPsF4/t3jBVb70EoHa7uqNmdOB3z5Tr4eQZ/A5oln0bFjEZsPXaDCHZqSv8aG/dt5YaMye9pzuOMQ+Yrnojf1K9A+Vz4Es97ovbWnVhLBaJjcZ0rOgke/aq39VDkGyMYRcdxoU3od8E+fy/mNx4uSuLa4JxCIdqUGTHOGA51T2nhInEUeSOrjiDfkfhpv8vbYcgeiJxL9ht7qKf7OFOWSPFbiocWJ8njK5tzVFD6D6gtwjqtxVjuoKIsz2AV0WDQ+LryV4wPXgu+sELQ8HspO0dFksGtk/v6sMIOhnjlJyYp9THXbfukKIZa/3X0qr4PjXy7XlkD8mi9OHtuKoPu4VoNqDE2NhnRwbryUyM6qSr+gsY0oNRLpJZgCS6aEiK0sM6fdyRr8RKYG58cBquC1KJdlWG0sk/HtW2S1HypV6SJQ+nu69n+0WM+0YR3EN+BfCK0IDTZs877tzGyiUeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(316002)(66476007)(508600001)(54906003)(6916009)(66556008)(66946007)(1076003)(33716001)(186003)(3716004)(52116002)(4326008)(6506007)(2906002)(53546011)(6666004)(6512007)(9686003)(38100700002)(5660300002)(8936002)(6486002)(86362001)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1dWQ2V3Zk1JWFNva21nNy93bXFaN2xUdlJDbEFwdmNweVo0SmpxS1UyelBW?=
 =?utf-8?B?UzVJTTd0dzF6N0tWT3ZwT1BPY1dLd3ZXd0llZ0hWTCszWWpwZ3V3NTh0OXcw?=
 =?utf-8?B?YXo4dEZCV2ttVnhBalZTSlk1d3dyVlgzM3hzUm5IS2lhRndXcDQzRXZxRm04?=
 =?utf-8?B?WFVvdjBrYWttaXorZzZlanEwSTRCL3FVM1d1ZVFrNUM1NUpHT3p1Rk44SGQ2?=
 =?utf-8?B?bi93NnFhZGFXRVRTU3hjMHo1SnFkQjVmdzhQbmZxVVU5Sy9tZ2UwZE8wVHE5?=
 =?utf-8?B?RFpLNHN3Qk85Wjk3WW9oMG54R1NZSWpBTmZHd2FKWGxqWElrWERNNXV3Si9o?=
 =?utf-8?B?L2xwR1FCSS9tV0VGNXhlOWVZRWF3RHVDT1pVaEV4N1piNGNpY09Gci94a29V?=
 =?utf-8?B?M0hqUGJ2SVRKeDhodG53OGpXQlFLREdkaEVDcHFUOWxvNUZPb2FvV0p6VkN2?=
 =?utf-8?B?WHBGVHJzM1BCalZxaWUzZzRtOE1CWkZoVnZCamEwMUpsWkZ4bHg4T0NqcGRH?=
 =?utf-8?B?M2x2aGw0NkwvbEtYbHdrZi9iZEZtb1l5NUh5eG13dTQ4RHVBRGhQcFlCNzJX?=
 =?utf-8?B?bHlpcnpzeXZuS1BaTlhHWXorcG11T0lqTE1BVDN2dzNNdmVxdmgwODYrRE85?=
 =?utf-8?B?MHluMUcvMzhBaUE3Ym55RllrK1V1Y3kyM0V1MjloUGJOUTVFa0lWZ1FhbHpm?=
 =?utf-8?B?NlR1TWorSWxRQlFES2lDeWsxYmtxTk5aL2dibFI3V3pkeHZjSTR4TFBmZjQy?=
 =?utf-8?B?d0FoLzJ6bFltQWJrQitsWWVuL3VqS1FKcUVmKzV4UUFNNHlidE04Q2JPdmtJ?=
 =?utf-8?B?Y0U0bUxLT3RIVEoySXJCWjExbTdPUUZRVUdEaEhSdG0zOHVwNi8ycWlDZkZk?=
 =?utf-8?B?ZHJyNUU2RHJiMmpKdVVKakluM3JLLzE5aldURTlNZEpab3MzUWpRdThTMGJE?=
 =?utf-8?B?Q08rQjJUKy9kRzFUNnVKY1RpMCsxanFyNXZ5ZEEwbFRrRVFycC9zLzU2SkNK?=
 =?utf-8?B?eS9SZ0ZsNXFaamE1WDNNdm9UUndTMTJmNUwzUDBBemZZRFlseitMaDhiTVh5?=
 =?utf-8?B?MHVXbnNGR24zeXpBQ2lrYWRmVGxuL3ZWQ3NkSS9CV0Y4bTBlTStqYUVCMHpx?=
 =?utf-8?B?QzVPejg1aWNQa015Ukp4QWZmck8yampNNzlWTU11MUZDZ3pZNTZVNFA3SFhK?=
 =?utf-8?B?Q2JQUngwN3hVRG1CMStNVWRiejRhRG9xMENZZU5hWmdZV0RFL1NvNVVnbEVG?=
 =?utf-8?B?aFFHOHdSbFF3cEhybTlRTy94M245SE9DVGIyb2Zsa253b3Q0OFN1ZXdpWU9v?=
 =?utf-8?B?N1lTbE5PZTN3Y0tnVlNFMnY1bkNtazRISzR6R25qZDBHY3dmd1BDSVc4RnFx?=
 =?utf-8?B?TXlmTVRUbGw5cTJYUFBhQjJHaHlJM1lWQmxHNXRuVnc1UDk5c3kvcVU0SENP?=
 =?utf-8?B?ZGxZbkQwQ044TmRtVlZqbW1UbW9BOC80aTFaZS9zWDZneEdVU1E0TnNVZEVO?=
 =?utf-8?B?WkFKQ3lBdFBaUThNUHNFRGs5M1B6TmNIMUNsbHdEcGc0QnBCSXlYSTYvNmxn?=
 =?utf-8?B?dC9TRGZCeFppRXhqRXhSdXVSZUE1M243RVlyaFhhWHkrTXJFdWlSSTh5QmR5?=
 =?utf-8?B?NFVObGFBUHJmZHg1cmN3YjMxRHk5WG8yeUcxZC9IMjJDMzNXWCtrN0ltTlQw?=
 =?utf-8?B?UHprV3dWLzRrZ1dwWWFVRUlXY0RmR3Zhbk9Na2VXZXJDL29OblVZbEd1RG1Z?=
 =?utf-8?B?Mi9pbFdTakFaLzRxVUkrSHl5UXVlM200SnIyeXlDQitDOE5GSFpTdWtIQkNs?=
 =?utf-8?B?RjY0cHhKcVdGTE9WUHVCdmhBc0tVa1hqaXVwRFFLbVRYc01SYmFMZi9sOFZa?=
 =?utf-8?B?WDJYclVZRXFEZzRTSEtRYXBIT3ZObzlMcmduSGowRStQeVlnSU8xc2VQaldl?=
 =?utf-8?B?RXBIb25qL2o3dGJuZEVwc0N3OXIrbXRVSkhER2xReGxwVEVWWHdxN05FTjBt?=
 =?utf-8?B?VktHM3d0RmFMSlgvSGJqSUd2NTYyT2ZxVmNzbTVxUWx4aGlPZ3ZWTFFNL1NH?=
 =?utf-8?B?NHhWeTJDMDNjQ2VpZjhoSWZpVUZraEpRT2IyTHRVT1ZEdzJKc0pwaVNsVEtm?=
 =?utf-8?B?c3h5VDREM2xRSUZpN0owQWRrVHBSN0E0VGN4eXJtNEdweTdGaXRuSUlBZlNU?=
 =?utf-8?B?cEZoZkg4Mm1pbys2YkRib0gyYW1iSnZwRWFybEFHOVIvQU1od2xPaUtyUWFs?=
 =?utf-8?B?K0JtSzlwTk9MRWp3dTZLeThNeWVsZWJnNTlCRUNuc3RLc0JzeTdpbDdGR0ha?=
 =?utf-8?B?M0ZiUHcrS3NPSzRTQ0lIZUlqVVcrMFFnNlJ0UmttZm9iZGQ2eW5kL1IzZktQ?=
 =?utf-8?Q?6RHtoNLlnFk8du6o=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba4424ff-5293-423c-8fe7-08da39c13193
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2022 17:58:35.1134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tjp4swJWZJgpJR1rAOIZPoeZRwVIAdexYzp7eRI7lUb8MmVeGKDjXhk4acARXuTl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1490
X-Proofpoint-ORIG-GUID: I6KTJ4nmW1vBfSSmiXlzr7Ecv81KKNJs
X-Proofpoint-GUID: I6KTJ4nmW1vBfSSmiXlzr7Ecv81KKNJs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 05:38:43PM -0700, Mat Martineau wrote:
> On Tue, 17 May 2022, Alexei Starovoitov wrote:
> 
> > On Mon, May 16, 2022 at 10:26 PM Geliang Tang <geliangtang@gmail.com> wrote:
> > > 
> > > Martin KaFai Lau <kafai@fb.com> 于2022年5月17日周二 09:07写道：
> > > > 
> > > > On Fri, May 13, 2022 at 03:48:21PM -0700, Mat Martineau wrote:
> > > > [ ... ]
> > > > 
> > > > > diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> > > > > index 8b1afd6f5cc4..2ba09de955c7 100644
> > > > > --- a/include/net/mptcp.h
> > > > > +++ b/include/net/mptcp.h
> > > > > @@ -284,4 +284,10 @@ static inline int mptcpv6_init(void) { return 0; }
> > > > >  static inline void mptcpv6_handle_mapped(struct sock *sk, bool mapped) { }
> > > > >  #endif
> > > > > 
> > > > > +#if defined(CONFIG_MPTCP) && defined(CONFIG_BPF_SYSCALL)
> > > > > +struct mptcp_sock *bpf_mptcp_sock_from_subflow(struct sock *sk);
> > > > Can this be inline ?
> > > 
> > > This function can't be inline since it uses struct mptcp_subflow_context.
> > > 
> > > mptcp_subflow_context is defined in net/mptcp/protocol.h, and we don't
> > > want to export it to user space in net/mptcp/protocol.h.
> > 
> > The above function can be made static inline in a header file.
> > That doesn't automatically expose it to user space.
> > 
> 
> True, it's not a question of userspace exposure. But making this one
> function inline involves a bunch of churn in the (non-BPF) mptcp headers
> that I'd rather avoid. The definitions in protocol.h are there because they
> aren't relevant outside of the mptcp subsystem code.
> 
> Does making this one function inline benefit BPF, specifically, in a
> meaningful way?
I believe this is similar to the already inlined mptcp_subflow_ctx().

> If not, I'd like to leave it as-is.
Sure, it is fine to leave it if the churn is too much.

Was suggesting because all other bpf_skc_to_* cast helpers
don't have this call-out.  Just in case if those cast helpers will be
inlined by verifier in the future, this won't be the only one that
got left behind.
