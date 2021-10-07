Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B3D4260BC
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 01:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbhJGXy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 19:54:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58444 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238068AbhJGXy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 19:54:26 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 197MM6I4023291;
        Thu, 7 Oct 2021 16:52:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=h+nJXLTRtLkyFHxWx1eBEquu1VP7+GG0FLmCG+9IsGM=;
 b=l0G/JOhNvxD7JNfvkqIU1SMsx9aiVyfmNEPDPVdoLlztnOPUAg9qTxS73mzP3HULVUa9
 rmiAKkQYDo2jWQw7q0ehvgbuoveh5eRp6UyJcxWl9KF6g2UIffr2zjThT4hVLMvZ2yYU
 ajqTELaS2/k68kw4z8tio3xluRWNZU7o4mA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3bj99qgnx1-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Oct 2021 16:52:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 16:52:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoAARxmBKS3VQlpxuJtE3/gBNaxdcMykIkZXw/int9t/xms1+mk9TCbG8YcAnq9VEmXSN2z/61TO+8TfenstVmZNSC9Xqrknvj7ftk+VXugiSDJb9VWviqC9n4OhYR+Tni6RsxwNOdi94G1qfKfY0yYI0O3JtYECA77eg0uae1BDw30K8dlw3wdPVdOiMTsbo95iK5ntr2klLLn8CScLNExCsVtaoXA2DdVUMK7XD+new2BaVdIKVWOJ2peQq3Uagj5OUMXh/pnDoBjE3KiLzu8HmM6kBGtJsTnlJcyF2851fwN78nDVFkW96wtALPP7vmWfNTbChm4COfytPVY3Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+nJXLTRtLkyFHxWx1eBEquu1VP7+GG0FLmCG+9IsGM=;
 b=mg5qCkjvCopmca6fnjnRSC0x87PiLzv0vs2aRlVFOXslqVTxuRSam2sMp9YJZUjmWCaztJI6cohygrRBBeHgHqhgaFJfcRPbLowhl496HKzY4/mzGDAdezl1/T1c+qrg6b7VYGVa8fxVSvRQ0g+C0oHUjvm1EG7njS7E5MYTHmiJY/vH7nyGhLEpBckIYDVRKI2D1m8muIIgh/hOPj9wKc4/p9sDTfQtb/4U1BKCUoF1NPJMHZgJh18B4+LLjAVwVRPJL60PgQPFaaEOQm9d5vUhup/9oNeRPtqHvHAH/JRzaFsSZhhBYV8pmDMG7yOeNyQeP2wKFlGn+vzjuAfb4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SN6PR15MB2302.namprd15.prod.outlook.com (2603:10b6:805:19::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 23:52:08 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::6c34:bcb:51af:6160%8]) with mapi id 15.20.4587.019; Thu, 7 Oct 2021
 23:52:08 +0000
Date:   Thu, 7 Oct 2021 16:52:03 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Joanne Koong <joannekoong@fb.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
Message-ID: <20211007235203.uksujks57djohg3p@kafai-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk>
 <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
X-ClientProxiedBy: MN2PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:208:d4::25) To SA1PR15MB5016.namprd15.prod.outlook.com
 (2603:10b6:806:1db::19)
Received: from kafai-mbp (2620:10d:c091:480::1:fb9f) by MN2PR04CA0012.namprd04.prod.outlook.com (2603:10b6:208:d4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Thu, 7 Oct 2021 23:52:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b569c086-9345-4eac-da37-08d989ed7948
X-MS-TrafficTypeDiagnostic: SN6PR15MB2302:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR15MB2302B9DB1F6616BF7DC44707D5B19@SN6PR15MB2302.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8TUXMTRUc9wVgNzV4lnYIrudg5ofxguM/lD+bymB8jV3l6HiHyCBt9DcWGvB2BdYyfOY/TvOupngTHEptT8mvn/bH4Iuyfw/KuLz9o7hE48QEmzwAEz7T/NdnIRrEmkYMB9dT30QzB7bMVqmaOoa1Zl+qF19tJ5uGlr63dEUD6mt2kVhutj4MiSyMMyS/CG1Fhr3WTJSvwCV6VkpGPAQfxnlJOjgo+UR5gp7IH9mD0/oqZrX10rBZX11h1QGX1QuaJAZyvX/W+5Tb9vVWClSXXS2IHRktIM/Iu1yWqVoa0NPehOkU/4rYZaaKuWO5xaOSDKacrVl64CPyX0Nw7596EN5DFvLW4spYXA8Cb62wjmcYlOlnQQyNoDh4uicAe8SBF58XvFltvKj4w94gcM+JpirV2P3NaVpZEiBv6nNbHYirkabYlTRDE1keGtaL+tlW6xGMgyFaE6ApRGEY7AxSb2S2gg10/AA7vKNxEWh95AC8ZZ1++0kHzKbvqf274uksf2BucTsR7pw7ZA+3qZtOIsyZpEMLO1PS7IoIrcqJYrrpKitWMuxPKI24cNU8xqPOIN1F97A70zYTrS02dWY9ZjhuYhtihLvCIBgbeyA18bqTH0aC8GxDxRwr+za0TtYovRgfJbpD0j6weTvyvrCFvQjEpREsh55DrClY7ltWD03QtYH1zBrav+T+MGY1+x1Du6VMbvU+fotyxaB4NfBCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(86362001)(6916009)(55016002)(38100700002)(33716001)(66946007)(52116002)(8936002)(6666004)(6496006)(966005)(66476007)(66556008)(54906003)(508600001)(5660300002)(316002)(186003)(1076003)(9686003)(4326008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yK2PsTkVUt7wy/rlcOYIlPnQjPdHq094M6cxvDChWYFHTJeRdz3fp+zGlT6L?=
 =?us-ascii?Q?bpQ4iuM1y0StcshSdDUI83xJFD+i0QhcPaWjN0pbg0eR3ro3m1hzbt2/JRJe?=
 =?us-ascii?Q?cNV2IPVBGFBzW+I+ZLCIFBQ+RdbfXeYcw65xsf+/2PfX0YuMS4CTtyx0Zl9Q?=
 =?us-ascii?Q?Tq1GE7AfApXZxa0LcbbokheTIDsUcwCOoVlXKiPNv51zmBGKWw6l54Ie2Y1C?=
 =?us-ascii?Q?Oxhl1nqr38CLy7ANXIEI6b8UavgE1pyQrYdK5IbJxRUP7koMvtsqXK3UyYlH?=
 =?us-ascii?Q?mXOJMUpzdYIbY6G9trzCavAQDyJTDi2k0ssXgx7m6YhLTcuRUptkA5u0uKog?=
 =?us-ascii?Q?/t8RzlW01Dvy++rgw0yG81la6WovoF2n37RtO15YFToGg/CKGZ26Ny6RMnjz?=
 =?us-ascii?Q?+Xnci2j0x3mtEOXqTrp5kyVdjJ4JFXr0lnoUEM9AvhATfl0F+AaNjIO/kzFU?=
 =?us-ascii?Q?nRoR9D0kZ1sYycKNTvVxd9okRjmuc1IMKAIJb32C60F3OFYQM7DbARzoM6x9?=
 =?us-ascii?Q?wzRQaIDdSFey85dJFNpKxRs2/HRfURUEZ59dqyKyhMbzcfZ68KLg26CzAoxm?=
 =?us-ascii?Q?5fgG9xRIcekG4GiJfphzvhOSpt38gPa0vA3GuV7fw4kEitaN0OkP6s88VXVp?=
 =?us-ascii?Q?BmCKMNjMRGiRtGIBO+jxn+wVLe4A9YLCFGzc0AAS8zTLz8AKbDHsbAuonOUS?=
 =?us-ascii?Q?l6penPSO+cRTx7vmaeZymVVozZWATVlVi9v6I//PzlXIm1nXxYajsgOue57N?=
 =?us-ascii?Q?p4gCTvByur1UPLC3lbPNWj1MJ0r6izhTKzp0W/utGB28u/JKyiTaZS/jiad0?=
 =?us-ascii?Q?cGcg+Rm6yKgRJgEz/NUg3MtzOw5C+3XxJv1cAQ1CNMPX26hgsxCVdZZdYnuD?=
 =?us-ascii?Q?yIbxEr6tJhDJURRj7ean+Kbi2s4KIfd2qC2KQhUKEdWVhEU4qJ+HUwU+q+yN?=
 =?us-ascii?Q?1aLNkhtaijxemypsR2V7lo5gln1pOCp5EqJnAEu0AXdIObpERtOEO3QqCd7n?=
 =?us-ascii?Q?s01jgWSHpMChGlEmRIBut7QKQOemOd8hNchzlyEO5O0+47HBOlalsEZY2MgK?=
 =?us-ascii?Q?tc5Me0YzUtwxlMswvpyE4oU1hAeQsrSrPWuXVPzcFxRXhZZ92wJyHUo+GdrA?=
 =?us-ascii?Q?9exMq3EaVXpcHqrAcSRzqzTVR7Z/CeVIB9ihl8eRtLjC2IkwzSBcAc7NImt6?=
 =?us-ascii?Q?yPerupBStzqaQlKKpyVCBRcKr2VCie5x8imdtiDtGfRSWWBlCsdrfAnnG8jJ?=
 =?us-ascii?Q?ReEUyUsV2OmECK7p7zG6QC59ao1hDbvbf5VLMWhMHUIkzAaor3zQ2IUilq1r?=
 =?us-ascii?Q?bLzkvoTyScoA+yb7Kdc4oP2MNtmfk/NCxnbozVEpGfTrAQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b569c086-9345-4eac-da37-08d989ed7948
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 23:52:08.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jA8wO8UDMe4pQ8cK4/yBpO1p10+UgLTRQK8DDj4TAaob0T09cgnBSzbPvSc049LE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR15MB2302
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: IG-2q33SkBUBCJsE1_e-zrZXs7sFNq3d
X-Proofpoint-ORIG-GUID: IG-2q33SkBUBCJsE1_e-zrZXs7sFNq3d
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_05,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=733 mlxscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070148
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 11:25:29PM +0200, Daniel Borkmann wrote:
> I tend to agree with Toke here that this is not generic. What has been tried
> to improve the verifier instead before submitting the series? It would be much
> more preferable to improve the developer experience with regards to a generic
> solution, so that other/similar problems can be tackled in one go as well such
> as IP options, extension headers, etc.
It would be nice to improve verifier to recognize it more smoothly.  Would
love to hear idea how to do it.

When adding the tcp header options for bpf_sockops, a bpf_store_hdr_opt()
is needed to ensure the header option is sane.  When writing test to parse
variable length header option, I also pulled in tricks (e.g. "#pragma unroll"
is easier to get it work.  Tried bounded loop but then hits max insns and
then moved some cases into subprog...etc).  Most (if not all) TCP headers
has some options (e.g. tstamp), so it will be useful to have an easy way
to search a particular option and bpf_load_hdr_opt() was also added to
bpf_sockops.

When bpf-tcp-hdr-opt was added, the initial use case was only useful in the
TCP stack because it wants to change the behavior of a tcp_sock.  When
bpf allows to add tcp-hdr-opt easily at tcp stack, it opens up other use
cases and one of them is to load-balance by the tcp-hdr-opt "server_id" in
XDP [1].  The same user that writes the bpf_sockops prog to add/parse
tcp-opt needs to do extra tricks to get this work in xdp prog.  The user
had repeated a similar try-and-error exercise (e.g. while the logical thinking
is to somehow bounded by the max tcp header size but that does not work
in unroll.  With the current cases in the loop, 15 is the max
magic number that works and hoping it will continue to work).

[1]: https://linuxplumbersconf.org/event/11/contributions/950/
