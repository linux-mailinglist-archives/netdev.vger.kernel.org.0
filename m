Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 796051E3E27
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729622AbgE0J4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:56:22 -0400
Received: from mail-eopbgr10081.outbound.protection.outlook.com ([40.107.1.81]:12770
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726086AbgE0J4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 05:56:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dz9k9Wihg/0nqxFxmixjb5xlPrOzq3iwFtH20AfmO24TQiQQIUHd6H4/tjCgt02HFEcgnlXwDH/52Os7WPCw7UlS23785dOnSNJD63611wQYFMtefeg8VDYdNVHbni2w0i70W92WOrBW1Hs/NedBJvojsE118GcVgNw9wjn5VzWQOLhTU2ohy46Hyiqb4m015lKCYUcHiBc+LLb/7AkeuiiKfmpEp0ZPoK2dtEWZ74Ot1LW1NW/pM7VSrAxb0qw/u62fDcth+t0PsKnf3om7y/thTii087vDWA86LHEblCQGMR8VGB81KNrYFjh2p9p/5iRN58RjdSN/2gMzZu/7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG2AtD7tDaDCSgZ5VmZXsTWgBl6zFtfTEMuvvNnCLM8=;
 b=PlQ/lNFPm0eZcJvLDGkBwHvyBgFbBdR/4ukiM9c0pslIH029grPEy4pCfoCgLP38tvvvAqbgAAzWXgYY8f/4dwHLZ7EgmdnHeWGRYZPbgRC6KGYxgvnzM7q9rVRpAh1mPepugsLTKsMC0dpTv7Q1gnzhUSYXfVhtJWxYRwqDrq8MdFWoja4RgKcZyH9b+lfAmq5sYQmafE/N0i8KE3D18qpFGLq9CdIiQZK97Z1hV0SivnpI0JcNDrSjX7PMHRt8CJM5mYnXWLLjNN15h5huxTfh2jyT0roqdBmEizhVMYwJReKuZT+dnCIeHBcCV8hvCNQCMOAFPhrcHA0HKabXrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FG2AtD7tDaDCSgZ5VmZXsTWgBl6zFtfTEMuvvNnCLM8=;
 b=l4TnV+Ek3mxV5ABeVc8aECUCT0kvwkpcW1loyeUE/FkUfXAdXpsXI4I3H/FcfCYKWSFYVRZjQgI8CH+IHZTKb27rGNGUHEjYBYaegTiflOMzQ//pttcvHbXrSva8eY1KL33XCeWTilamQTAug8JZkEflgsiacI9uxtpXknicyNQ=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 AM6SPR01MB0055.eurprd05.prod.outlook.com (2603:10a6:20b:1b::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 27 May
 2020 09:56:18 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Wed, 27 May 2020
 09:56:18 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
In-reply-to: <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
Date:   Wed, 27 May 2020 11:56:15 +0200
Message-ID: <877dwxvgzk.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Wed, 27 May 2020 09:56:17 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c4682192-3d91-4c6f-6203-08d802243373
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0055:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6SPR01MB005554A0430CCB4EBCCD41BCDBB10@AM6SPR01MB0055.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04163EF38A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g++5ee6YF04uhuDctIGAyruy37HI45falBDun/l5wX6cJQnk91rbRZixnQt9mMaRHFlVUCuMMdk3aKOOkR0sLIW+LrmqrsoqBaYiN/Te/kU0y5Gl0QM3CmlUHnWeSw7i9xwXoX+QuqifbomD+Tx+KiKkcabHcYraDcjtOyFkT6WD7SPIIzgXDwF6dejp+cxqN8LxpdwnKD716UBPp+Yl/rh6fY4Mw9T2Ghz25eWboxuKaYTlX1RhOLQeP8R6Eu/bITlXosp5pehrE4uLauE86E2MF+cpGyfZvHwMFQ/axhuqBPTtYa12RB5LF2uhk6Q7Kd7FuaTCbPNApJAPGy1CsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(186003)(66946007)(53546011)(16526019)(8936002)(54906003)(316002)(6496006)(52116002)(66476007)(66556008)(5660300002)(8676002)(107886003)(4326008)(26005)(6486002)(6916009)(36756003)(86362001)(2906002)(956004)(478600001)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: snHKJI6zMR2S4+YUNRuCbGci06LckKPuj9lO89BzKg0smeTc6lTQMP3l6pOLFHW7djjtQbmLJPlIQPmd3Z7RzqpJjjWqM5akgklqLpuRDY+xXBSBs3zSi0gKU7NKV2NzDWG9U0y/K3BvPrhasEH9OpYwzzWdj0iYGjU4BscVUz2ZADFtCt95l0cWffr2m+eorFSFVRTmA9Wx4kiDhz972zXPiU+ZYfRmeh5b5r8YIHokdYyM4x5WeSD2jWUdjx5SUaFIkH1rMrHIbxBYTqA0kh4jNg1evC1sAyBZmRlJi/p+yWBsAuk8bya8T4xJDlPREmlw+U4ozjhfP+x7S3ogKCP/MPBoubrGIPCck/2UNCEFlwivMqoXg1r4UlIXF+CgYhVeHX6vyCihSHCUS9ffSDauTd0NIneone0nrdjdzeOGms4x9jBFLqZqhSmvFsBTHhuh1YPhlRC/7iBPcM/D356VZnDsdblmIKZhrviBxGYLGkqEElbATJNrDgEppIMR
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4682192-3d91-4c6f-6203-08d802243373
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2020 09:56:18.0271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3Ix99QTXD33LBdoLXyE2BTHJ+tbLsMY2LHBTRGxUDJY83PxBw5HDh1vpQU1JZELBK4am0EuVB44R0nF1SnIzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
>>
>> The Spectrum hardware allows execution of one of several actions as a
>> result of queue management events: tail-dropping, early-dropping, marking a
>> packet, or passing a configured latency threshold or buffer size. Such
>> packets can be mirrored, trapped, or sampled.
>>
>> Modeling the action to be taken as simply a TC action is very attractive,
>> but it is not obvious where to put these actions. At least with ECN marking
>> one could imagine a tree of qdiscs and classifiers that effectively
>> accomplishes this task, albeit in an impractically complex manner. But
>> there is just no way to match on dropped-ness of a packet, let alone
>> dropped-ness due to a particular reason.
>>
>> To allow configuring user-defined actions as a result of inner workings of
>> a qdisc, this patch set introduces a concept of qevents. Those are attach
>> points for TC blocks, where filters can be put that are executed as the
>> packet hits well-defined points in the qdisc algorithms. The attached
>> blocks can be shared, in a manner similar to clsact ingress and egress
>> blocks, arbitrary classifiers with arbitrary actions can be put on them,
>> etc.
>
> This concept does not fit well into qdisc, essentially you still want to
> install filters (and actions) somewhere on qdisc, but currently all filters
> are executed at enqueue, basically you want to execute them at other
> pre-defined locations too, for example early drop.
>
> So, perhaps adding a "position" in tc filter is better? Something like:
>
> tc qdisc add dev x root handle 1: ... # same as before
> tc filter add dev x parent 1:0 position early_drop matchall action....

Position would just be a chain index.

> And obviously default position must be "enqueue". Makes sense?

Chain 0.

So if I understand the proposal correctly: a qdisc has a classification
block (cl_ops->tcf_block). Qevents then reference a chain on that
classification block.

If the above is correct, I disagree that this is a better model. RED
does not need to classify anything, modelling this as a classification
block is wrong. It should be another block. (Also shareable, because as
an operator you likely want to treat all, say, early drops the same, and
therefore to add just one rule for all 128 or so of your qdiscs.)
