Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9E95A2134
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbiHZGvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHZGvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:51:21 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F15D1261;
        Thu, 25 Aug 2022 23:51:20 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 27Q6l0vH019295;
        Thu, 25 Aug 2022 23:51:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=ow6qtujK/qNK71weWfznGcpY9dN1gl0UfmKNs9pfPyk=;
 b=rbrneYRDz4h9BcyJF3+zBfgueyAEamNowOMoWu8f/IYk3HqzxJFq1Um2fDAoXkZhL02s
 oKDD+tK4d1ISjOaPqiV2JmniwNR4CGru/15l6FXT3cZN/Xw5fIb8TztZ7c3MfSiXv3Bo
 fF4Zxngj8LqPxzIOzsdYJCvAoWuq82MlIso= 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by m0089730.ppops.net (PPS) with ESMTPS id 3j6s7100es-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Aug 2022 23:51:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEHcZUH2cPsACOfcpuDyDwYUWZkcfHXfwJ4g08YSRCwjXazi+RCV2+DoU1tKe8YK5XTXG76+gggbIGnHGHz7n7ltBfwt+xHrAiQnrNp2Bgv0BkEpJjzyBsXTyEO0XXZVJT+XqBDIHGfmJRoW8crWedaWHL+06xtsBNtcR0Z+8MslG20cy7aFspc4NjtvVbweAVQixmcT0xQ7zeMz1DxZq3APWu529lt0b0ldmU5qrpTptjSbpNC+LQVQf3YNq9XyTQEBchtYmAWjeT/SCL+PCbnFxNt1oCqMUKGq53pcvyA7zmnsJgdNWbtlBE5cqdoschizZCLQ3hiEnKEPmmrsww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ow6qtujK/qNK71weWfznGcpY9dN1gl0UfmKNs9pfPyk=;
 b=k/k/XiguNe5fijVUQsN724bEN71bsT8fbQ7Zf23Os7R3yIGUkm2y8BxxiacSaRr4CvnmiwJv7iqVisDvqBdHXmFTaYXZxpmsqYn8eLqI0dE45gAdRyufUWYUiyztXgy4aUwm9SxQWnrvTqWCgoYDHZdsAaWHqrSE6p80ksVose4GHl1nmhiWZ8lT4lGvcOXZmkGQUUO5GYCh0BQQMnHCzrdkYPIvsyHjecMUW0/X3wWBZVq57D5LHMa9nXO1tm5QuVEZ2JFLP0X5FH/nvbA4/xqeuKpRko0v7mgz4qsf/KMPGJXBerzYab/Tu8yOncF/QAfxu0a5v8QiP/2HKX58Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
 by DM4PR15MB5378.namprd15.prod.outlook.com (2603:10b6:8:61::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 06:51:01 +0000
Received: from MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e]) by MW4PR15MB4475.namprd15.prod.outlook.com
 ([fe80::1858:f420:93d2:4b5e%3]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 06:51:01 +0000
Date:   Thu, 25 Aug 2022 23:50:59 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        "brouer@redhat.com" <brouer@redhat.com>, lorenzo@kernel.org
Subject: Re: [PATCH bpf-next v4 2/3] bpf: Add xdp dynptrs
Message-ID: <20220826065059.bwoorr6mwppgop57@kafai-mbp.dhcp.thefacebook.com>
References: <20220822235649.2218031-1-joannelkoong@gmail.com>
 <20220822235649.2218031-3-joannelkoong@gmail.com>
 <CAP01T77h2+a9OonHuiPRFsAForWYJfQ71G6teqbcLg4KuGpK5A@mail.gmail.com>
 <CAJnrk1aq3gJgz0DKo47SS0J2wTtg1C_B3eVfsh-036nmDKKVWA@mail.gmail.com>
 <878rnehqnd.fsf@toke.dk>
 <CAJnrk1YYpcW2Z9XQ9sfq2U7Y6OYMc3CZk1Xgc2p1e7DVCq3kmw@mail.gmail.com>
 <CAP01T75isW8EtuL2AZBwYNzk-OPsMR=QS3YB_oiR8cOLhJzmUg@mail.gmail.com>
 <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826063706.pufgtu4rff4urbzf@kafai-mbp.dhcp.thefacebook.com>
X-ClientProxiedBy: BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38)
 To MW4PR15MB4475.namprd15.prod.outlook.com (2603:10b6:303:104::16)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61e294f4-7ee8-4cc5-480c-08da872f56b4
X-MS-TrafficTypeDiagnostic: DM4PR15MB5378:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaxHYENZgVh6z2DW2bQmTv9PkvAAV4+sjURbdBsSsYiCEV5sOe2Hz0GcDQpszDXNGDBqNoGuOphs6s26SiUZjPPhpd1qvkh8gHHytOcQCGPr85kDkLfG4fozY9p4YfbiA9QLDjScve6k9+pX6yB919NAC/NfEH87qQf9V0aumgKxmJoF7zRwlSjkgUpj0JHsIYtUQTLFCjnpAJ9YTdJsM+rEhAlPby4sStzzsOPbhE7Dq3RE/desGPGhGz+TvrZ0LVwrAxsBfzHSTErTBiFTrUvrlo203TPTbKHcwBMiKI+1gTUL0g43YGOh+5q6yMDa42u2hIlCzIQsAM+13BjMoUw63UkrLRW8toPoC8a55MF1qOP55O2A71fjfsjB+TOAFLiTKY3gU5XDrXA7fWhQR2WhQ0i7F+stm2q0i0ZKt2MwayUBwyLBq/BseLe217BAjZyyFO3IysMwAalTAXNd/NRy/zoscLum6RPG5b4F40R63Ssl1Xt+NnLXeLgar7GvbRPa+aOiivUrglMEHdlmaVPtO3IQRGAuR0U/lhxAq5ekqMlxeDXBaCjZyKTK3gTSLJ7LNCzW1QNFH7BQiETdUINKM+oIpbuItormvkbw51INLJ8pBC7o4AGwZMEdlLepFe95UhVGQBALSzb6nxytZfi4TEbVyuLx9vkQlfLuZ8fERdBmnpjf/SMJRUbVdxNgbCYQDwC32cfK7G8SfKGDGYZEYFGX+rHCZz9BSkxvqmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4475.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(8676002)(4326008)(66556008)(66476007)(38100700002)(66946007)(54906003)(6486002)(966005)(478600001)(6916009)(41300700001)(2906002)(6506007)(9686003)(86362001)(1076003)(52116002)(6512007)(7416002)(8936002)(186003)(5660300002)(316002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8MzAMHptrwobz7ZFSVm6s6/aMNXZU2WWMLFNc9V8DTCroNTKc+zu1eGG7Rx?=
 =?us-ascii?Q?8NyDnufJA4EAiBylhpYDifhIuOEcCTqlqdkuIIp7GFTBC+I3dKdckyVCukDN?=
 =?us-ascii?Q?LwZEnf1fiwQZGOMB1ycr/PX+D3mvpI6G9nx2+UIzJ0ySFODKto5gmMJPza5t?=
 =?us-ascii?Q?XJvp9Nrxiw4fKTWKnYmng7Uz3S3tvdhy2fVF0gT19W0g+cQVnTIYPv0YTk3l?=
 =?us-ascii?Q?1YAhMJjqFPu2QNI0FvVWljQByds0qU+RyNhkOux4zUdtaIa7UVIr+jm/LJU1?=
 =?us-ascii?Q?X4GyIfR/YD3Fjy8D96feEokjB2F9C4tlsE/8UhLcCOUr6mKwrcGc6GtKIU8F?=
 =?us-ascii?Q?dFZuFMJ1LO73qJGB00feFB7XE55hGRyJz61b0A6jALz/07skVFA3HA6S9pvw?=
 =?us-ascii?Q?vMvAvLjkLbfSLsVQS3QdPl+vgT1vPLpGl4r4rd5PgnZrHeoPLyNVKLUdbyG6?=
 =?us-ascii?Q?H+tEXBHVwyR6pT42to0i7cop1gQ872hghhmtIhmgOxB862RoczhdBd9T0T2s?=
 =?us-ascii?Q?SfTYHKnourpILa/KgtMbiO2xq6ir5ZPqIjEzh0jfc/Y8rEZuPCFBVZQDTW9N?=
 =?us-ascii?Q?1AE477+DSlSSuRYoHNbK3PJjshfiDX8hFBLLOSBWaMMjgUxFZCLcfh2B3b2B?=
 =?us-ascii?Q?PgRc+n8rAcntr+eE+KEHtFfk/zTwYzDebSTjUXdRo2GyWaBf/hmwhUQdrnFk?=
 =?us-ascii?Q?rWPK9ib+au8+tDLRERX+yf7wuSzeFZ3QDo8K7mqc3gu6/GXgguCr2dZKQqu/?=
 =?us-ascii?Q?pUkycYcLdAHsXKpvL37xGhiN6/XYDrd3tkzgIhoJ2gzDE1DT/XcY77JIBrn8?=
 =?us-ascii?Q?jj4mePLaZVUAeuaS8ll7kQXgXHwQdFDFUgbPtHvyqPXvYvvpfwR0N0L0Vrlf?=
 =?us-ascii?Q?qhWQhocvreLfomTxVgNgQx758UFur13WqG3KkYQE1I/5QAIdl/KnUTNVUWRm?=
 =?us-ascii?Q?n4K7LG7LJUT9/3nIX2wad9Cm5K6QbQ/teEnly9Jf176SLD59PN8c95L+Jf5U?=
 =?us-ascii?Q?iL/FPbdlfhEFLVCqTiw0UKM326CnkiktObEY2J/+a2wdMEqgCrbsjOHJmCKZ?=
 =?us-ascii?Q?nW/53gRpPPslVPJ5nZN3j67wsdAd+MbfYu3WlcTC9juH5VqI0MNaFDM0zQtj?=
 =?us-ascii?Q?NGUACtTEIUb6yKbiqQFGpDIwbhVu3crbYObdmy8oKed3Ih9/opTRKeAgtFaP?=
 =?us-ascii?Q?+nCl8Kt1CQnEqxazdWZmTRzOZDo31/C6SztzmFe9B1hvulCYuuuGpsCsqPVJ?=
 =?us-ascii?Q?aoohr2ZhHgKRZLND/35xGokMkpGdqWPADidEp2z1UiAo9I8YGZjobo9bAdmf?=
 =?us-ascii?Q?v9r/68cq7Q0333gpt7x4M+GPedp9ES36nFtLGPr9B0lFb9nWRgu2OX3a5ZRE?=
 =?us-ascii?Q?QTgX++Nh3xv09FaFuNX9gFp+3s3dN7ghGiFKW7kyM3OUYQ1z7LZ+PIWtLxf/?=
 =?us-ascii?Q?m10q9guPKJLxYn1G+sVuMPpIcqDPNzq5o9cHZjJkrKyqW+PD+/85TwQI0pm7?=
 =?us-ascii?Q?Ps5YC8j/jhr2YdXnD4Ur/JnCmvYs9sfzYcuwbhyrH0QrRHPI9D9a9HWSnWcz?=
 =?us-ascii?Q?vJC8sLmcjcSXXq2srQqSAO8pt7n0U1+pLHsnDmyf8wNOPwx9h6kBXauDwc7R?=
 =?us-ascii?Q?Yg=3D=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61e294f4-7ee8-4cc5-480c-08da872f56b4
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4475.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 06:51:01.5620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VjIj+L4qc4nck8vy0gGGvsxug1HF0SmrfJxpvr4fH/RZaNMXOYADWOays0tS6QHJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5378
X-Proofpoint-GUID: a8YO9RphEdi89og3DaZ9tP7jFS3WYC4Y
X-Proofpoint-ORIG-GUID: a8YO9RphEdi89og3DaZ9tP7jFS3WYC4Y
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_02,2022-08-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:37:08PM -0700, Martin KaFai Lau wrote:
> On Thu, Aug 25, 2022 at 01:04:16AM +0200, Kumar Kartikeya Dwivedi wrote:
> > On Wed, 24 Aug 2022 at 20:11, Joanne Koong <joannelkoong@gmail.com> wrote:
> > > I'm more and more liking the idea of limiting xdp to match the
> > > constraints of skb given that both you, Kumar, and Jakub have
> > > mentioned that portability between xdp and skb would be useful for
> > > users :)
> > >
> > > What are your thoughts on this API:
> > >
> > > 1) bpf_dynptr_data()
> > >
> > > Before:
> > >   for skb-type progs:
> > >       - data slices in fragments is not supported
> > >
> > >   for xdp-type progs:
> > >       - data slices in fragments is supported as long as it is in a
> > > contiguous frag (eg not across frags)
> > >
> > > Now:
> > >   for skb + xdp type progs:
> > >       - data slices in fragments is not supported
> I don't think it is necessary (or help) to restrict xdp slice from getting
> a fragment.  In any case, the xdp prog has to deal with the case
> that bpf_dynptr_data(xdp_dynptr, offset, len) is across two fragments.
> Although unlikely, it still need to handle it (dynptr_data returns NULL)
> properly by using bpf_dynptr_read().  The same that the skb case
> also needs to handle dynptr_data returning NULL.
> 
> Something like Kumar's sample in [0] should work for both
> xdp and skb dynptr but replace the helpers with
> bpf_dynptr_{data,read,write}().
> 
> [0]: https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/T/#mf082a11403bc76fa56fde4de79a25c660680285c
> 
> > >
> > >
> > > 2)  bpf_dynptr_write()
> > >
> > > Before:
> > >   for skb-type progs:
> > >      - all data slices are invalidated after a write
> > >
> > >   for xdp-type progs:
> > >      - nothing
> > >
> > > Now:
> > >   for skb + xdp type progs:
> > >      - all data slices are invalidated after a write
> I wonder if the 'Before' behavior can be kept as is.
> 
> The bpf prog that runs in both xdp and bpf should be
typo: both xdp and *skb

> the one always expecting the data-slice will be invalidated and
> it has to call the bpf_dynptr_data() again after writing.
> Yes, it is unnecessary for xdp but the bpf prog needs to the
> same anyway if the verifier was the one enforcing it for
> both skb and xdp dynptr type.
> 
> If the bpf prog is written for xdp alone, then it has
> no need to re-get the bpf_dynptr_data() after writing.
> 
> > >
> > 
> > There is also the other option: failing to write until you pull skb,
> > which looks a lot better to me if we are adding this helper anyway...
