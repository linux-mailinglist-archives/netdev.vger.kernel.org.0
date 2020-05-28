Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43B41E5C5C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 11:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbgE1Js5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 05:48:57 -0400
Received: from mail-eopbgr40053.outbound.protection.outlook.com ([40.107.4.53]:14646
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728300AbgE1Js5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 05:48:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MxoQUJzxhBL5jrbskz0cx4k5Wh8FozLJSzee0NQBlcJEHbkH54IGXGUibfIezFkwl9SW4nPVX8pVjLM5xGkJkjXPQjCsZt1utHmxUYalswlEakZNzAp06sV/qj8Zzm/Oy9Gke99w3bnqDXoBfjGq6uVaIAaHUuqgXRtaIxgOtmG3f6lRyiMqx4Qh2fGUn9IBTihbuXGlck3616ErTq5YjobHXEAUe30j95R01mjqLQaBh5gfHQqXh9FXQ4Nwgyu7zCeNbNAjZfzlQi0MuCXQGFdFdUTjr+ptsp805gncs+JQjST4n2ZJJbSDlSpQnqmquuy4g6KxR9/BFILn5dMTaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FX/bwpjy5etvILCDJ7qfdc+++Ms40nN04lHykwkwfc4=;
 b=OHBOGvLvGDuFUZN0l8yInUwLc+kP8an6PvIP4ppAk1DJ1zwBmga7ew1faVG0TIH/h1KYFOE06yMdbChrA+h92YbiQ5/zh1tZR3o+NzehbMF5dCMA1rNPSMuF024xmPK7pl6mCeC43yFIf9iWRvC9gYUYW+LuHfpj8g9pcG2hm1cW091BL7FWSRHC9Y0fFIFhdJu0dG1qknFvswg+11U8PotEaMEkgvgk9hiB+fCo4k1WrHAm9MB2gIA1q2Incu2gT5eZN470Vcm+ECpl/mqkcJsXXCDtEeDUeateMxN1L7IohC1rT6WYAo+KDOzZL16QBDWw+RHZCZOx236COJQlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FX/bwpjy5etvILCDJ7qfdc+++Ms40nN04lHykwkwfc4=;
 b=fdhgbmPFsdaGPexxJcMQPXtm+COWsNjPjNVPVubprCJwjqZ8gWDyNeHR9iqlScYKPx92Gcgrz1cqT1Fw1lYuJQFUmQBlShBulR33aJKtUbzBqPo5E6j7Xum84y8qRGowlfBh+Mh+XvB+h2xSSEVTrNj7jUsvNVj0oF2MR20uGkY=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4540.eurprd05.prod.outlook.com (2603:10a6:7:98::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.24; Thu, 28 May 2020 09:48:52 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 09:48:52 +0000
References: <cover.1590512901.git.petrm@mellanox.com> <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com> <877dwxvgzk.fsf@mellanox.com> <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
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
In-reply-to: <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
Date:   Thu, 28 May 2020 11:48:50 +0200
Message-ID: <87wo4wtmnx.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR04CA0016.eurprd04.prod.outlook.com (2603:10a6:208:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Thu, 28 May 2020 09:48:51 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 565724fb-9b65-41cc-d1cc-08d802ec53f8
X-MS-TrafficTypeDiagnostic: HE1PR05MB4540:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4540D5CBE2BBD71BCC22330ADB8E0@HE1PR05MB4540.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/0ML7gfAXVE8TnCGKVfWgHplLgaluG8xD7SnYCpDoTB3NYmESeQM4zAL6NXQVjtjLN9FkuzN3yeh+UzSqFuS9Hsd7GOzxGxtkXkY+8AN6wp9MoowB9P9cwNQtI2Y+K+uyQCO6nUUcww26e18tgki64pDZf8gXsHm6R94pOplVOHh4g5IeBaewTJ+XlL7Vuo+XmJGFOt6Yx/WMCdG2psosNBbvZBRLJc/Ia67TMmD1BDxpJsfDe4n3inV1PkLh0M4tc3oNTV2ZIqiXcsQeQGxhLjsFnAUPHbZlrSm/4faI+9vMonM1vyefYiqgJMnKda7PMfGODZUJ0OXHcHFPNviw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(6486002)(4326008)(36756003)(16526019)(86362001)(26005)(107886003)(186003)(53546011)(956004)(83380400001)(66476007)(66946007)(66556008)(2616005)(478600001)(6916009)(6496006)(52116002)(8936002)(2906002)(5660300002)(8676002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oUqRG2DhbuN7TvkVkenXVlz30eXFzuoCc8yLO6dvG4PqutDG6Vp1EJTh66TB0tJA87qqGQl0DUl4XzMj8Xe0AEfY3VoQ0VHAzNWYzDQ0riDKCAynkGUV2CQBrDwwmIZwYBzoMLp1K2o/zqMg23roPE9DHFZd+ddDPGsKq9Ciy8DPj1lHA6433BBufD631Q0qEFEgx6MLg7PnZcLMNnA/MOmOzSzo0hfG0/XKmhBewDYgV6T71ziRPhVEh4uNXtgPALvD7LpZJotJVaM/ujgnl7x4kAJ1L5ox/QdhYjQ8y1DscLY0pjpV/qVsrC6aoXgDPSKKiDybnq4PA6fflCGFyYRgTZO+S1L8P/HyzQCpeMT36KvqlQYY8Ts8oKvRKK74pKsUatL7aItP0o3PKeL3W92cH1kHbiTceEeHomzfsE+BBfR7AIOtcqvbXLWloldi1kfVETLku2IbmDxkBK7G+l9E1bXaflgHtvQI2WzbZO+o9axdLazSCeOtnf92nkwL
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565724fb-9b65-41cc-d1cc-08d802ec53f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 09:48:51.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ymjFIzOwdo+YVoOZvd88fHqgZRWwYlzeqhQ2H2zhbt+rJRZSy5Kca+NxSOtCCMJcswHpV1F85JGtFTLkBsfKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4540
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Cong Wang <xiyou.wangcong@gmail.com> writes:

> On Wed, May 27, 2020 at 2:56 AM Petr Machata <petrm@mellanox.com> wrote:
>>
>>
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>
>> > On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
>> >>
>> >> The Spectrum hardware allows execution of one of several actions as a
>> >> result of queue management events: tail-dropping, early-dropping, marking a
>> >> packet, or passing a configured latency threshold or buffer size. Such
>> >> packets can be mirrored, trapped, or sampled.
>> >>
>> >> Modeling the action to be taken as simply a TC action is very attractive,
>> >> but it is not obvious where to put these actions. At least with ECN marking
>> >> one could imagine a tree of qdiscs and classifiers that effectively
>> >> accomplishes this task, albeit in an impractically complex manner. But
>> >> there is just no way to match on dropped-ness of a packet, let alone
>> >> dropped-ness due to a particular reason.
>> >>
>> >> To allow configuring user-defined actions as a result of inner workings of
>> >> a qdisc, this patch set introduces a concept of qevents. Those are attach
>> >> points for TC blocks, where filters can be put that are executed as the
>> >> packet hits well-defined points in the qdisc algorithms. The attached
>> >> blocks can be shared, in a manner similar to clsact ingress and egress
>> >> blocks, arbitrary classifiers with arbitrary actions can be put on them,
>> >> etc.
>> >
>> > This concept does not fit well into qdisc, essentially you still want to
>> > install filters (and actions) somewhere on qdisc, but currently all filters
>> > are executed at enqueue, basically you want to execute them at other
>> > pre-defined locations too, for example early drop.
>> >
>> > So, perhaps adding a "position" in tc filter is better? Something like:
>> >
>> > tc qdisc add dev x root handle 1: ... # same as before
>> > tc filter add dev x parent 1:0 position early_drop matchall action....
>>
>> Position would just be a chain index.
>
> Why? By position, I mean a place where we _execute_ tc filters on
> a qdisc, currently there is only "enqueue". I don't see how this is
> close to a chain which is basically a group of filters.

OK, I misunderstood what you mean.

So you propose to have further division within the block? To have sort
of namespaces within blocks or chains, where depending on the context,
only filters in the corresponding namespace are executed?

>>
>> > And obviously default position must be "enqueue". Makes sense?
>>
>> Chain 0.
>>
>> So if I understand the proposal correctly: a qdisc has a classification
>> block (cl_ops->tcf_block). Qevents then reference a chain on that
>> classification block.
>
> No, I am suggesting to replace your qevents with position, because
> as I said it does not fit well there.
>
>>
>> If the above is correct, I disagree that this is a better model. RED
>> does not need to classify anything, modelling this as a classification
>> block is wrong. It should be another block. (Also shareable, because as
>> an operator you likely want to treat all, say, early drops the same, and
>> therefore to add just one rule for all 128 or so of your qdiscs.)
>
> You can still choose not to classify anything by using matchall. No
> one is saying you have to do classification.

The point here is filter reuse, not classification.

> If you want to jump to a block, you can just use a goto action like

I don't think you can jump to a block. You can jump to a chain within
the same block.

> normal. So your above example can be replaced with:
>
> # tc qdisc add dev eth0 root handle 1: \
>         red limit 500K avpkt 1K
>
> # tc filter add dev eth0 parent 1:0 position early_drop matchall \
>    action goto chain 10
>
> # tc chain add dev eth0 index 10 ...
>
> See the difference?
