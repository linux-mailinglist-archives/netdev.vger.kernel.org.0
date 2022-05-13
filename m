Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A0D52638D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 16:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbiEMOPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 10:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbiEMOO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 10:14:59 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DBF58E72;
        Fri, 13 May 2022 07:14:58 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:54854)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1npW4F-007lqp-Uy; Fri, 13 May 2022 08:14:56 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:38036 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1npW4D-00BRmA-PN; Fri, 13 May 2022 08:14:55 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
References: <20220510082351-mutt-send-email-mst@kernel.org>
        <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
        <87czgk8jjo.fsf@mpe.ellerman.id.au>
        <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
        <87mtfm7uag.fsf@mpe.ellerman.id.au>
        <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
        <CAHk-=wg=jfhgTkYBtY3LPPcUP=8A2bqH_iFezwOCDivuovE41w@mail.gmail.com>
Date:   Fri, 13 May 2022 09:14:46 -0500
In-Reply-To: <CAHk-=wg=jfhgTkYBtY3LPPcUP=8A2bqH_iFezwOCDivuovE41w@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 12 May 2022 10:19:24 -0700")
Message-ID: <87bkw1ecyx.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1npW4D-00BRmA-PN;;;mid=<87bkw1ecyx.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+P1XTvzh2gWV+avxp7O0g4DyqAEC77CWU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1573 ms - load_scoreonly_sql: 0.48 (0.0%),
        signal_user_changed: 13 (0.8%), b_tie_ro: 10 (0.6%), parse: 1.68
        (0.1%), extract_message_metadata: 17 (1.1%), get_uri_detail_list: 2.9
        (0.2%), tests_pri_-1000: 18 (1.1%), tests_pri_-950: 1.53 (0.1%),
        tests_pri_-900: 1.19 (0.1%), tests_pri_-90: 119 (7.6%), check_bayes:
        117 (7.4%), b_tokenize: 10 (0.6%), b_tok_get_all: 18 (1.1%),
        b_comp_prob: 4.1 (0.3%), b_tok_touch_all: 81 (5.1%), b_finish: 1.36
        (0.1%), tests_pri_0: 1365 (86.8%), check_dkim_signature: 1.09 (0.1%),
        check_dkim_adsp: 3.5 (0.2%), poll_dns_idle: 0.79 (0.1%), tests_pri_10:
        4.2 (0.3%), tests_pri_500: 28 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] virtio: last minute fixup
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, May 12, 2022 at 10:10 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> And most definitely not just random data that can be trivially
>> auto-generated after-the-fact.
>
> Put another way: when people asked for change ID's and I said "we have
> links", I by no means meant that "you can just add random worthless
> links to commits".
>
> For example, if you have a (public-facing) Gerrit system that tracks a
> patch before it gets committed, BY ALL MEANS add a link to that as the
> "change ID" that you tracked in Gerrit.
>
> That's a Link: that actually adds *information*. It shows some real
> history to the commit, and shows who approved it and when, and gives
> you all the Gerrit background.
>
> But a link to the email on lkml that just contains the patch and the
> same commentary that was introduced into the commit? Useless garbage.
> It adds no actual information.
>
> THAT is my argument. Why do people think I'm arguing against the Link:
> tag? No. I'm arguing against adding links with no relevant new
> information behind them.
>
> I don't argue against links to lore. Not at all. If those links are
> about the background that caused the patch, they are great. Maybe they
> are to a long thread about the original problem and how to solve it.
> Thats WONDERFUL.
>
> But here's the deal: when I look at a commit that I wonder "why is it
> doing this, it seems wrong" (possibly after there's been a bug report
> about it, but possibly just because I'm reviewing it as part of doing
> the pull), and I see a "Link:" tag, and it just points back to the
> SAME DAMN DATA that I already have in the commit, then that Link: tag
> not only wasn't helpful, it was ACTIVELY DETRIMENTAL and made me waste
> time and just get irritated.
>
> And if you waste my time with useless links, why would you expect me
> to be supportive of that behavior?

You know.  I have exactly the same reaction about your proposal to
remove the Link tag.

I hate it when v1, v2, v3, v4, etc are not part of the same thread.

I find it very useful to go directly to the patch submission by
following a single url and see the whole entire conversation right
there.

I don't relish the need to instead perform a search and waste my time
filtering through similar submissions just to find the thread where
things happened and what people were thinking.

It is human and messy and unstructured so we probably need a search
engine to find parts of historical conversations, but gosh darn search
engines can take a lot of work to get useful results out of.


As for finding the original problem that can be very hard.  I recently
had someone report a problem in code that had not changed in a decade or
so that had just appeared.  They had just happened to run ltp on a big
enough machine where a poorly written test stressed the hardware on a
large enough machine in just the right way that things started falling
over.

It took asking several times to find that out.


So sure let's aim at getting more and better information in commits and
in the urls that we place in commits.  But let's not throw the baby out
with the bath water and stop doing the part we can automate, because
we have done such a good job of automating the indexing that we can
usually find it with a simple search.

Let's instead aim to keep the conversation connected, and the threads
not broken so that following the url that is the easy thing to create
gives us much more information.

Eric

