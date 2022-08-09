Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D66658DC42
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241197AbiHIQk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiHIQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:40:25 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E821138;
        Tue,  9 Aug 2022 09:40:23 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:40688)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLSHF-003Ve1-S8; Tue, 09 Aug 2022 10:40:21 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:59198 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLSHE-002Sv9-L4; Tue, 09 Aug 2022 10:40:21 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com
References: <20220801180146.1157914-1-fred@cloudflare.com>
        <87les7cq03.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
        <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
        <877d3ia65v.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhSKmqn5wxF3BZ67Z+-CV7sZzdnO+JODq48rZJ4WAe8ULA@mail.gmail.com>
Date:   Tue, 09 Aug 2022 11:40:12 -0500
In-Reply-To: <CAHC9VhSKmqn5wxF3BZ67Z+-CV7sZzdnO+JODq48rZJ4WAe8ULA@mail.gmail.com>
        (Paul Moore's message of "Mon, 8 Aug 2022 15:49:48 -0400")
Message-ID: <87a68d4bgz.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oLSHE-002Sv9-L4;;;mid=<87a68d4bgz.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18HBy/xVu3Fi4ZlEEXadKSoHy1u0KD36K8=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 627 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.8 (0.6%), b_tie_ro: 2.6 (0.4%), parse: 1.32
        (0.2%), extract_message_metadata: 19 (3.0%), get_uri_detail_list: 4.5
        (0.7%), tests_pri_-1000: 20 (3.3%), tests_pri_-950: 1.49 (0.2%),
        tests_pri_-900: 1.23 (0.2%), tests_pri_-90: 95 (15.1%), check_bayes:
        93 (14.8%), b_tokenize: 16 (2.6%), b_tok_get_all: 13 (2.1%),
        b_comp_prob: 3.8 (0.6%), b_tok_touch_all: 56 (9.0%), b_finish: 0.67
        (0.1%), tests_pri_0: 471 (75.0%), check_dkim_signature: 0.49 (0.1%),
        check_dkim_adsp: 5 (0.8%), poll_dns_idle: 0.02 (0.0%), tests_pri_10:
        2.6 (0.4%), tests_pri_500: 9 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Mon, Aug 8, 2022 at 3:26 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>> >> I did provide constructive feedback.  My feedback to his problem
>> >> was to address the real problem of bugs in the kernel.
>> >
>> > We've heard from several people who have use cases which require
>> > adding LSM-level access controls and observability to user namespace
>> > creation.  This is the problem we are trying to solve here; if you do
>> > not like the approach proposed in this patchset please suggest another
>> > implementation that allows LSMs visibility into user namespace
>> > creation.
>>
>> Please stop, ignoring my feedback, not detailing what problem or
>> problems you are actually trying to be solved, and threatening to merge
>> code into files that I maintain that has the express purpose of breaking
>> my users.
>
> I've heard you talk about bugs being the only reason why people would
> want to ever block user namespaces, but I think we've all seen use
> cases now where it goes beyond that.

I really have not, and I don't appreciate being called a liar.

> However, even if it didn't, the
> need to build high confidence/assurance systems where big chunks of
> functionality can be disabled based on a security policy is a very
> real use case, and this patchset would help enable that.

Details please.  What does this look like.  What is the overall plan for
attack surface reduction in one of these systems.  How does it differ
from seccomp?

How does this differ from setting /proc/sys/user/max_usernamespaces to 0?

Why is it only the user namespace that needs to be modified to implement
such a system?

Why is there no discussion of that in the change description.

> I've noticed
> you like to talk about these hooks being a source of "regressions",
> but access controls are not regressions Eric, they are tools that
> system builders, administrators, and users use to secure their
> systems.
>
> From my perspective, I believe that addresses your feedback around
> "fix the bugs" and "this is a regression", which is the only thing
> I've noted from your responses in this thread and others, but if I'm
> missing something more technical please let me/us know.

Which is a short way of saying that the using this hook for attack
surface reduction without a larger plan will be ineffective.  If the
attack surface is not sufficiently reduced it will not achieve a
prevention of exploits and the attacks will still happen and be
successful.

With a change that is designed to prevent exploits not actually doing so
all that is left is breaking userspace and causing maintenance problems.

Earlier I asked to confirm that was the only reason cloudfare was
interested in this change.  I have asked that we have an actual
conversation about what is trying to be achieved.

Instead the conversation has simply been about implementation issues
and not about if the code will be worth having.  So far in my book the
code very much does not look worth having.  That is my technical
judgment and I don't see anyone taking about my arguments or even
really engaging in them.

Since I keep getting blown off, instead of having my concerns addressed
I say this code should not go.


>> You just artificially constrained the problems, so that no other
>> solution is acceptable.
>
> There is a real need to be able to gain both additional visibility and
> access control over user namespace creation, please suggest the
> approach(es) you would find acceptable.

The suggested hook is not at all appropriate for visibility.  Either the
user namespace needs to have some state that can be set, or there needs
to be something that is notified when the user namespace goes away.  At
best the hook can print an audit message.  So the proposed hook is
really not appropriate to add visibility to the user namespace.

For the record I don't object to adding visibility, I am just pointing
out the proposed hook is not appropriate to that task.


What is the need to have an access control?

Why do you need to fundamentally change the design of user namespaces?

Those are questions I have not seen any answers to.  Without actual
answers of what the actual problems are I can't have a reasonable
technical conversation.

>> On that basis alone I am object to this whole
>> approach to steam roll over me and my code.
>
> I saw that choice of wording in your last email and thought it a bit
> curious, so I did a quick git log dump on kernel/user_namespace.c and
> I see approximately 31 contributors to that one file.  I've always
> thought of the open source maintainer role as more of a "steward" and
> less of an "owner", but that's just my opinion.

As such it is unfortunately my responsibility to say no to badly thought
out proposals.  Proposals that will negatively affect the people using
the code I maintain.


My apologies if I have not been more elegant right now when I have been
constantly sick, and tired.  People getting scared of user namespaces
for no real reason has been an on-going trend for a decade or so.  This
isn't a new issue, and it irritates me that it is still going on.  I
have addressed real concerns and fixed code, for many many years.

This round of the people being afraid of user namespaces, I have yet to
find any real concerns.

So when I express my concerns that this is a pointless exercise and
people don't address my concern.  I say no.

Eric
