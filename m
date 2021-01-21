Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11ABA2FF7BD
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbhAUWJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:09:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4470 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726444AbhAUWJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:09:33 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10LLxMSs004403;
        Thu, 21 Jan 2021 14:08:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aIQLfYJMXcjSdh0840zMWcZF9MwkhA5uIiP8LC+eryI=;
 b=YkKK8+f6dyXwUzYrvgyEcDX5603HsHvu6wo+dTJZ19XOApX8JlnaKEb3X/1lIH1vnm3k
 dQO1qmywQK4Hh5W7rUT4gNTMGHkelpobGrT+KHKgqR2nMePYDhRMfl9ExFbsF0GoZw/s
 I8iKE0TCo4iIP8eEt/1H2J/GuzDtRJK2Vxg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3668psdqq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 21 Jan 2021 14:08:44 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 14:08:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBUcVzgWAPfKLvdDxGAX4daKgrRfLgt3w687bofacDzQvxmMPT5M0R4Ba6poOWzQXRvh/8HZmXdDiTNfXrMfqz7ByceSVMWPmRaZQSQB/vtOGXsbQv69XMVCNTCU5U08grNcicpsxTtKI/6jSy8Yvd1L5J8WhiKTEUpgKSCRiHXD2Ijd8MmRwN/Gu0a9+WMqmGroedIby9sc8MW+yXk48gpSKzAN//8OWshpFhp3f5o5d4xCixkN52vthjwypCaw8gYTuJw4Vgh7dJG1jCFyYs0cuhUyO4wuNFKjWeVugfo5aafU1t7T80X+68YTPF6S8n7+49H8h939em4sI1SQ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMPdQ9vxsl1AO8DtpvwQag3nOuGe56o+FEdpqjs/uXk=;
 b=RoOnnOV/a/FoQHgF35U4YrOl+s7QJgjRxsMsL28HAiF1weMfmdoRUUBxTo2An+AxJXpGirH7GvSmge6arzs9knNclmjZe1ZhglsUMa0i1iiInCniI7GTcVy9aJSE3tb7dEbyE729jxStnzdClzhETnVPbgM51XRmA2OlFPZECbaKdp9MmLna8gtUpauqwmRe44HSfMTgunGRgtJn+oxQ8fmCQlXJwwSAg9flbESkOC572Jo88bX5Zi1B8qfb4Gr5mF7XEIEJu9Q2W4yPA4kY+WNmJ+43GUG7/3XXcry7eG/jHa/ujX14xf1OEpnjKdc50TXNIuQrzJN0rnQcOTeuJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMPdQ9vxsl1AO8DtpvwQag3nOuGe56o+FEdpqjs/uXk=;
 b=EteuneCMnfLFNDnqw/at5u1kZyD1H6BaPs5cvI05UBi2A40iC+3ljIGVXW2mGYvvxdwZfJS+D9idqh+hDCp5rEACCfbCC2ir9I/cDgQCTouz6VeXCUNA+GDDYGIojzGfCVR36TR+T/q0cDwxxbPTCpmz1AKc5AB7YF+XUmKGHog=
Authentication-Results: mildred.fr; dkim=none (message not signed)
 header.d=none;mildred.fr; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3702.namprd15.prod.outlook.com (2603:10b6:610:e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Thu, 21 Jan
 2021 22:08:40 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::a875:5b25:a9b4:e84e%7]) with mapi id 15.20.3784.012; Thu, 21 Jan 2021
 22:08:40 +0000
Date:   Thu, 21 Jan 2021 14:08:31 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Shanti Lombard <shanti@mildred.fr>
CC:     Jakub Sitnicki <jakub@cloudflare.com>,
        Shanti Lombard =?utf-8?Q?n=C3=A9e_Bouchez-Mongard=C3=A9?= 
        <shanti20210120@mildred.fr>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: More flexible BPF socket inet_lookup hooking after listening
 sockets are dispatched
Message-ID: <20210121220831.vdzjcn4mpwqicirx@kafai-mbp>
References: <afb4e544-d081-eee8-e792-a480364a6572@mildred.fr>
 <CAADnVQJnX-+9u--px_VnhrMTPB=O9Y0LH9T7RJbqzfLchbUFvg@mail.gmail.com>
 <87r1me4k4l.fsf@cloudflare.com>
 <e1fc896faf4ad913e0372bc30461b849@mildred.fr>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <e1fc896faf4ad913e0372bc30461b849@mildred.fr>
X-Originating-IP: [2620:10d:c090:400::5:2363]
X-ClientProxiedBy: CO2PR04CA0176.namprd04.prod.outlook.com
 (2603:10b6:104:4::30) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:2363) by CO2PR04CA0176.namprd04.prod.outlook.com (2603:10b6:104:4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 22:08:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48d11d4a-f3ca-440b-98fe-08d8be591bd0
X-MS-TrafficTypeDiagnostic: CH2PR15MB3702:
X-Microsoft-Antispam-PRVS: <CH2PR15MB3702FB30CE69DAB8EE045E77D5A10@CH2PR15MB3702.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: krfcg7lLZh1hJKFNpZwGw2DzLM/9l31zKDv+XG6+Yion0gVlx4ygDaKFdMwpq1eI8bRKZ6K/1nO/b/Nyo1EmQlrw0iCwuNvj3uE2KUM8w7dMNGhETqPbzT3TpLcyHvlbDVHHkPFo8QwAygRh92fK9q1Z4MQ0szeP6QkDyCUYDDdfFHkgDnRiggNqB2BcTrJzLsPIvKCn5JIbFagZmtVKbsvDcwop6jGA86ZBJtbyPgZy5UTkDzJlXeV12eEnWbM+tOMI/J5iAMhnnAYGErwuYVifNOhn2P2y/U6UpKFGi7r3GIbQjV8vZ2fen3fjoXNGO1FiYj81z2JCBGE1MQxwyJhaqdNpLVWXYdAWtw2jX7q3i5OvDUgsp4KRft9FXW15OrQwj/4B8Qb4c54GUXGfvHDD+H5E9Vq75p7JWw8282tG7+UkNZ0GEmUMFnW+S2CN3lstb3HAHr8+udY09gzm7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(366004)(396003)(53546011)(66574015)(66946007)(6916009)(966005)(6666004)(55016002)(8936002)(478600001)(8676002)(2906002)(1076003)(316002)(83380400001)(16526019)(33716001)(54906003)(52116002)(86362001)(5660300002)(6496006)(66556008)(4326008)(66476007)(186003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?z80jhf+2CvchTgOaghogWZItpAALKg+HZjxbyFrI401BmCBVZyRE0eS/8B?=
 =?iso-8859-1?Q?NyTK3UOQAbQA2tEEHSGv9JUwg+ELNwRnwszBqdwJZmMdIA7+gx8/F8MPPr?=
 =?iso-8859-1?Q?XG3lw9pU+F0qew0Fm+9NMuIq4CpBWu2KI5QsPqybhwk18Abrom/MLw/TIX?=
 =?iso-8859-1?Q?RfDnGZOk9EAyFk9pKFWb0la/EKzW0w1G/RHX6Sh0rupXwuF/+dB4wmt1p4?=
 =?iso-8859-1?Q?+9fjXp9ZkhlHi9PY2JDAk4jJNsOj94PZAM6UkewUUt9W/sDjPp2bc5km49?=
 =?iso-8859-1?Q?Afyozy+6Pn5EqYXpOmqam5bJ+JvDzL0c5RdCmP+cUDBCX4ZIoxLyFyEEYa?=
 =?iso-8859-1?Q?Ty/M6TwxkEXjoV5LG6vBaG2zBShTX7y85tfjEYiWil5r+4/aKt/q+D9Qji?=
 =?iso-8859-1?Q?fNusExos3rh+9UsqzhsHDQe4cTsmL2C75zwpS3PcT0iqJFyKXJs3xA7pXV?=
 =?iso-8859-1?Q?5lNeIq1wl+5uzdOofQJ6q5+RbW6KgQ+l1kLiBpkDucOeg2SPY/YjD4QKKp?=
 =?iso-8859-1?Q?yb08DUpBzP8v1x98GgMzpdxYJMzXpN3td3M57xq1AVmMw1LPUVru7C8mdc?=
 =?iso-8859-1?Q?bRv0UON3HtOcwOsFyYFDrR6wWGe6FZscbCTd/4KoUJD52H1L6Ukolt6LdV?=
 =?iso-8859-1?Q?YF8YAwCqI/3eFNrTO+kRgwgmzh4RJBwYktqpf13L8YYxMPGasGkqrwodEi?=
 =?iso-8859-1?Q?qo7PzpoUjUqjLhU/MAum00p31tqlxmPBxaB74P71dG4cbqHRwVwkszQV4+?=
 =?iso-8859-1?Q?SWE8ZCIbZw+AIxTIYPZ73x+7vOYnroeMsuXVODkN5G2p5H33fAZI4kYlCS?=
 =?iso-8859-1?Q?l10ioCw27sLE+Hp4i/tk6gRT1ZWZLe3x071lKBNUEIEmy4UoOKPNBLxblN?=
 =?iso-8859-1?Q?ppRx8g+K7MdCwJo6Si4D4BmHgs+EwrZrNWWNrJSH1BNzzdWtkv7pIqMxSw?=
 =?iso-8859-1?Q?V1M0zFr44MuzNhP1MOmeRGNATH9pwMgIqs72QJEcOw8b1h4PnC8mptknPd?=
 =?iso-8859-1?Q?vUjKWD3YUKhi3QFRy3BRZM+BetZnR+XirqW+dHQwOvHszN4jAoC6MKlhR7?=
 =?iso-8859-1?Q?Qg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d11d4a-f3ca-440b-98fe-08d8be591bd0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 22:08:40.3725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kt3XqNA+AgBcaWVtGcOg3YjXxObzuwU4af1DdSSGp7Blxg0g7w0EeywCaVhJUhxY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3702
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_10:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210112
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 21, 2021 at 09:40:19PM +0100, Shanti Lombard wrote:
> Le 2021-01-21 12:14, Jakub Sitnicki a écrit :
> > On Wed, Jan 20, 2021 at 10:06 PM CET, Alexei Starovoitov wrote:
> > 
> > There is also documentation in the kernel:
> > 
> > https://www.kernel.org/doc/html/latest/bpf/prog_sk_lookup.html
> > 
> 
> Thank you, I saw it, it's well written and very much explains it all.
> 
> > 
> > Existing hook is placed before regular listening/unconnected socket
> > lookup to prevent port hijacking on the unprivileged range.
> > 
> 
> Yes, from the point of view of the BPF program. However from the point of
> view of a legitimate service listening on a port that might be blocked by
> the BPF program, BPF is actually hijacking a port bind.
> 
> That being said, if you install the BPF filter, you should know what you are
> doing.
> 
> > > > The suggestion above would work for my use case, but there is another
> > > > possibility to make the same use cases possible : implement in
> > > > BPF (or
> > > > allow BPF to call) the C and E steps above so the BPF program can
> > > > supplant the kernel behavior. I find this solution less elegant
> > > > and it
> > > > might not work well in case there are multiple inet_lookup BPF
> > > > programs
> > > > installed.
> > 
> > Having a BPF helper available to BPF sk_lookup programs that looks up a
> > socket by packet 4-tuple and netns ID in tcp/udp hashtables sounds
> > reasonable to me. You gain the flexibility that you describe without
> > adding code on the hot path.
Agree that a helper to lookup the inet_hash is probably a better way.
There are some existing lookup helper examples as you also pointed out.

I would avoid adding new hooks doing the same thing.
The same bpf prog will be called multiple times, the bpf running
ctx has to be initialized multiple times...etc.

> 
> True, if you consider that hot path should not be slowed down. It makes
> sense. However, for me, it seems the implementation would be more difficult.
> 
> Looking at existing BPF helpers <https://man7.org/linux/man-pages/man7/bpf-helpers.7.html
> > I found bpf_sk_lookup_tcp and bpf_sk_lookup_ucp that should yield a socket
> from a matching tuple and netns. If that's true and usable from within BPF
> sk_lookup then it's just a matter of implementing it and the kernel is
> already ready for such use cases.
> 
> Shanti
