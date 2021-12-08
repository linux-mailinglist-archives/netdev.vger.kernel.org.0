Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B398346DE4D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 23:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbhLHWYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 17:24:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26756 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240776AbhLHWXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 17:23:21 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8JpZ6d027346;
        Wed, 8 Dec 2021 14:19:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=LwL4n2xgjF+4QGdJqTV3qSqVkbFuibCPu34OcGdtObk=;
 b=WqrC7Rh/vBvAAeE4i1rBThhghMlHQZnPCx0DOE2LMpT5l9xXLfkIvlzonX2OR1b7Nafp
 qLUKz8negyJMJFZ3VPLV8vfhX58kqQ2EH+ye8Dhv/Vk2BilnVsXI4j3WO2PH1zDog213
 xesuuK9T+wuvKv/h3s4tgb7xOgrkVPyTL24= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cttpvvsxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 08 Dec 2021 14:19:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 14:19:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bKOX+HiUcC6fAYbIBzhgRAcQ+w6BLvlRFy+A/wlNZ1ToDFbUFPNOQ73JyzWkdz6k84IVhsU5GYAWEW1e9W/wcwUgmy4K+ISncrYzr0+XQ2Ngu6/JyGVe+FJK/oDsTTzU7uExy2OLKRhR4+RBrd+sIfd60xJ9CIzhfLuSbcCrKzwOYXmS8SEts4RvjyLeyZ+i0YyAb9oKJBlbeSVZwM7sR+od8hNOSFec2Pcwgp1r0uOWDN1N5mnmug9PJlFlCmp64IoH7DrB6tacPlevDyGsqjfy8RL+yvZmGOQo5NsqAyWCoTfIFG59/REWLd47xoV8nKngQgSZ25MDfuYeopiS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LwL4n2xgjF+4QGdJqTV3qSqVkbFuibCPu34OcGdtObk=;
 b=Zcoe3BhhoU5WjsBJldSPsKoLzr4oywyvrf54MswiFIMeTEYX2oZwj1FUrCn9Vm5f+upmsCCui/tjBPzOqrSR7bzxr7CdCPBb2lp9ks9IkUlniOiJvJojz4OSMa+tfqV3k2um4bnhBVz2Xf6jaoXkfYLKrqq4RLBaUyVp+uPbcMA7p7WCoyzRdEnu9F6u9ZCn7V5r1zE9f42l3sOMV2KRwl8wQXrBE6LcUeGcSkrSOBU/ZjAUMoWyo06PAobF4GKBYETyQw7NABzuz72VlJ131gYQhYBzKAFpnS3BTtZnGDf9eMkWO1XQL4rQlHUujkapJ9Dz2YGHj+sguGUl42vkeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
 by SA1PR15MB4353.namprd15.prod.outlook.com (2603:10b6:806:1ac::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Wed, 8 Dec
 2021 22:19:29 +0000
Received: from SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010]) by SA1PR15MB5016.namprd15.prod.outlook.com
 ([fe80::e589:cc2c:1c9c:8010%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 22:19:29 +0000
Date:   Wed, 8 Dec 2021 14:19:25 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
Message-ID: <20211208221924.v4gqpkzzrbhgi2xe@kafai-mbp.dhcp.thefacebook.com>
References: <20211207020102.3690724-1-kafai@fb.com>
 <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net>
 <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1ef23d3b-fe49-213b-6b60-127393b24e84@iogearbox.net>
X-ClientProxiedBy: CO2PR07CA0054.namprd07.prod.outlook.com (2603:10b6:100::22)
 To SA1PR15MB5016.namprd15.prod.outlook.com (2603:10b6:806:1db::19)
MIME-Version: 1.0
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5f6e) by CO2PR07CA0054.namprd07.prod.outlook.com (2603:10b6:100::22) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 8 Dec 2021 22:19:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a143e653-db39-46e5-2957-08d9ba98ccd0
X-MS-TrafficTypeDiagnostic: SA1PR15MB4353:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4353184BA11EB0C938CFBE87D56F9@SA1PR15MB4353.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JXpeTHQr+BFsyjY32fOXo6bo4RHVvw6Hc1SDeMlJ9Vyv7e8xURwNTj6GTUt4fa8f3zlFybcsELt7yXFpvg3yoe/8W348QBn+uqZt75MJDMZg5AINf0eRgpzEHbgBecRY2sAPN2SzrdBLeynOMZYyA/EnLJ06TnZlm6iG3dhbe/eoKURbpUzjglRKPVcmGr3PpMG4rezvO/FpJV2Q1iFgjSPVvnTN3ZwwylF64FFLRdRB1SZe+POS7lj8v3yTQGorCQKlNRVi6s2yv7yq4s/1+RFWKeGPcIcOaEUZ/qq0jXkF3+NNmoE0LFexaSgpehz/i9RbEQrQeoGcmPxDmoHxOxltQUGOMVebGdz8Lp66WE+CCdEW7hRgorjXuH7S3Su/GypYfzHobOY14Rw0D/YO3XXX3DqcoOs7Z3xz4xGv3Z6VUD6ShE5tjhC4i/qCbAo0fNZNEjavqzYXehN8fp2AnIMRpIXm7FEt5iSUU2Hf6TWsTT/gWlYznrbRbIk/zWWI+2uX3IrRcEMK3y4BZRJWwL5Gc5SY0htVH6UArDuSrEGUM0bUdOhFvTCX/jfyFjRxSN1rquP2cFd0Q2iCKBYfdraI7VDJ7UgIyQYMzwgY+tzbseRJAPrUR4nlHSfQUhf4rVMUB+QPWn6J19Zdg6cyJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5016.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(1076003)(316002)(508600001)(8936002)(86362001)(186003)(5660300002)(54906003)(2906002)(6916009)(4326008)(38100700002)(7696005)(6506007)(8676002)(53546011)(55016003)(9686003)(66946007)(83380400001)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4a26Oz9slfAyLVsTFnbdTiSsYO1F7IecY9NwREgYWkvhjP+AhrVz/HNwiZk?=
 =?us-ascii?Q?QXi+Bru0CO+4UbQWgBIBH9/4Jx33EngHLkHTdEygwIUoEHAkBdraB8C1X1Sr?=
 =?us-ascii?Q?T+hjnNPwHoS33Y1TCQFFbTgX6DNDtXjcFQPF85mvanmHi5BzFxSu23HniG1X?=
 =?us-ascii?Q?tOWAMO4fv5vw1UFpVwQn9Nmz7IE1RDB1RWJqYZ5BDsCkR9FbA5NQJ5ul6v1p?=
 =?us-ascii?Q?KI7uHiAmipjqMmOqM6CbWCyWH3cUhKwniE7rAwisz0DqlMr+fgrRfsnsNAch?=
 =?us-ascii?Q?uEDYZ7pSXLVIgGnZnJHOEyloa/aIkttBvAbgRxrsXtdEAf1hIUvA1Ra8swcI?=
 =?us-ascii?Q?zM9h5h8VVjsYugv9ytzcJYgkX/OhGiTqC2v6zu7Y1BHbfSuBGeRRpttW1zcF?=
 =?us-ascii?Q?54ZhXmEpQx0c4N0OXlyBDyds1Knm1ri2I5sNWv8sX08nt5oqrzkeuIHduHDU?=
 =?us-ascii?Q?EchcpM7UEHzQohHHd+i+yM59Z/+1KBRLuAGosrLvnkDyd0Sjfq7HB7Y3Xw8j?=
 =?us-ascii?Q?3UPFp9yshvHk67FOQyLSPhzRVlUCvTwr8BTEdg7KV2XTk2XRzsceQVHXgM//?=
 =?us-ascii?Q?N45kNGk08Mprc1AGoENPfDnl0EvlJt2V+EamESOtfi2llkIrzuIl4YhYFrvb?=
 =?us-ascii?Q?gf8ZcsXM6vkk/SrsgwmTG+zzfDah5iT5aAZ3L56pCUbNXU247JGaIXLU4II7?=
 =?us-ascii?Q?ZXUjkhP5jkaOu5NrdUhSzMwbQeTveBUfBhHbhl5BMb73rzI9cn8PwFRed7z4?=
 =?us-ascii?Q?2rRRujQCkdhHjgScX7HdyHpdnH0Y7uS4P8YMgUIGySCXnMR9tfHF2J+Zmtc/?=
 =?us-ascii?Q?8Mb/QewXwVbN1oR0qzhzTVMyWGa7blOrlJ7UmJN9MCBGp/4krTz9J8kWcnfV?=
 =?us-ascii?Q?HsIJg/74uovlomleKF5x9vceZLSR3xkQH4zDNupACpxs5f2DHYEZPgbqWizD?=
 =?us-ascii?Q?xpmMkOv7CMjV1rSdryZE3KNnwaVfI0jBimMp/4FWAnWsuBiJsiKgueL7nigk?=
 =?us-ascii?Q?PQ09iOR05h/NkS8yBMfYKWG6UIMkDcN4NrqAUUSx02g9DBLdphNIYlHXetLE?=
 =?us-ascii?Q?iynpZupb7bOo6nJIvtUAsbhCDjJhQj5vQnSxOuLPkW5du0cTEpeYPMgwnmHi?=
 =?us-ascii?Q?SwS86nwYArb6XBPF9c9mVIDs1NlqHovreXd4TprB/GN5gik1xCRH6HE0kEWP?=
 =?us-ascii?Q?1m7py5gOT7x59bRjoHoABv1cVaFGzA29UCrTrazgqwrkpMCOsEUCRYm33juh?=
 =?us-ascii?Q?sjcaRsvIKyeqW9ilf29t8b+bPRF+zWZ/wE7ajFagheKQtKD4Mqiu2s0GCKSd?=
 =?us-ascii?Q?vUJy+XS1roW/tYCeYGWkI3tqUbSlHFWmnOwevKdx9ZUtaouWRseSQjNucLjL?=
 =?us-ascii?Q?JYsTkUI0M2Ri/aoftp7DozniwJF4haNDnb11GQd+wSI2ZX48lot5KKRXTKQT?=
 =?us-ascii?Q?mcEYX3JlFy1nfSu4gnwZkUn15YLa+ADxMLy/k23CmU4YIDg4FBjRIrUyszs3?=
 =?us-ascii?Q?GOQzpuQzLdw/cPec3c5M+MWbvnPLfHV3HNu9H88929xtzMwK+joYh7CclhbT?=
 =?us-ascii?Q?4PEtPYDPjLiU++R6X8xIt+pmDPYpV21TeDvq/t54?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a143e653-db39-46e5-2957-08d9ba98ccd0
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5016.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 22:19:29.3243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9Ay1rQIMvPW63yfYIOJ/f6azkmPqTBbDy8GTuTaV0gLw0vdcqRFyAP9XErXJ+LE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4353
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: DCdioobG__i2t-PTcnKgEJyaC8f5T61n
X-Proofpoint-ORIG-GUID: DCdioobG__i2t-PTcnKgEJyaC8f5T61n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_08,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxlogscore=821 malwarescore=0 clxscore=1015 phishscore=0 mlxscore=0
 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 08:27:45PM +0100, Daniel Borkmann wrote:
> On 12/8/21 9:30 AM, Martin KaFai Lau wrote:
> > On Wed, Dec 08, 2021 at 12:18:46AM -0800, Martin KaFai Lau wrote:
> > > On Tue, Dec 07, 2021 at 10:48:53PM +0100, Daniel Borkmann wrote:
> [...]
> > > > One other thing I wonder, BPF progs at host-facing veth's tc ingress which
> > > > are not aware of skb->tstamp will then see a tstamp from future given we
> > > > intentionally bypass the net_timestamp_check() and might get confused (or
> > > > would confuse higher-layer application logic)? Not quite sure yet if they
> > > > would be the only affected user.
> > > Considering the variety of clock used in skb->tstamp (real/mono, and also
> > > tai in SO_TXTIME),  in general I am not sure if the tc-bpf can assume anything
> > > in the skb->tstamp now.
> 
> But today that's either only 0 or real via __net_timestamp() if skb->tstamp is
> read at bpf@ingress@veth@host, no?
I think I was trying to say the CLOCK_REALTIME in __sk_buff->tstamp 
is not practically useful in bpf@ingress other than an increasing number.
No easy way to get the 'now' in CLOCK_REALTIME to compare with
in order to learn if it is future or current time.  Setting
it based on bpf_ktime_get_ns() in MONO is likely broken currently
regardless of the skb is forwarded or delivered locally.

We have a use case that wants to change the forwarded EDT
in bpf@ingress@veth@host before forwarding.  If it needs to
keep __sk_buff->tstamp as the 'now' CLOCK_REALTIME in ingress,
it needs to provide a separate way for the bpf to check/change
the forwarded EDT.

Daniel, do you have suggestion on where to temporarily store
the forwarded EDT so that the bpf@ingress can access?

> 
> > > Also, there is only mono clock bpf_ktime_get helper, the most reasonable usage
> > > now for tc-bpf is to set the EDT which is in mono.  This seems to be the
> > > intention when the __sk_buff->tstamp was added.
> 
> Yep, fwiw, that's also how we only use it in our code base today.
> 
> > > For ingress, it is real clock now.  Other than simply printing it out,
> > > it is hard to think of a good way to use the value.  Also, although
> > > it is unlikely, net_timestamp_check() does not always stamp the skb.
> > For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
> > may be save the tx tstamp first and then temporarily restamp with __net_timestamp()
