Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FAF58DBA6
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 18:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244941AbiHIQIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 12:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240145AbiHIQIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 12:08:24 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933DB1132;
        Tue,  9 Aug 2022 09:08:21 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:51188)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLRmD-003S1H-KH; Tue, 09 Aug 2022 10:08:17 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:57438 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLRmC-00C526-5Z; Tue, 09 Aug 2022 10:08:17 -0600
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
        <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
Date:   Tue, 09 Aug 2022 11:07:51 -0500
In-Reply-To: <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
        (Paul Moore's message of "Mon, 8 Aug 2022 18:47:21 -0400")
Message-ID: <87czd95rjc.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oLRmC-00C526-5Z;;;mid=<87czd95rjc.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/OKOUHv1PWhUjp+g6EbQWzYWXeUfqqFrY=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 844 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.3%), b_tie_ro: 10 (1.1%), parse: 1.67
        (0.2%), extract_message_metadata: 26 (3.0%), get_uri_detail_list: 5
        (0.6%), tests_pri_-1000: 26 (3.1%), tests_pri_-950: 1.75 (0.2%),
        tests_pri_-900: 1.45 (0.2%), tests_pri_-90: 129 (15.2%), check_bayes:
        126 (15.0%), b_tokenize: 20 (2.4%), b_tok_get_all: 14 (1.6%),
        b_comp_prob: 6 (0.7%), b_tok_touch_all: 81 (9.6%), b_finish: 1.15
        (0.1%), tests_pri_0: 632 (74.8%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 7 (0.9%), poll_dns_idle: 0.63 (0.1%), tests_pri_10:
        1.97 (0.2%), tests_pri_500: 9 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Mon, Aug 8, 2022 at 3:43 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>> > Paul Moore <paul@paul-moore.com> writes:
>> >
>> >>> I did provide constructive feedback.  My feedback to his problem
>> >>> was to address the real problem of bugs in the kernel.
>> >>
>> >> We've heard from several people who have use cases which require
>> >> adding LSM-level access controls and observability to user namespace
>> >> creation.  This is the problem we are trying to solve here; if you do
>> >> not like the approach proposed in this patchset please suggest another
>> >> implementation that allows LSMs visibility into user namespace
>> >> creation.
>> >
>> > Please stop, ignoring my feedback, not detailing what problem or
>> > problems you are actually trying to be solved, and threatening to merge
>> > code into files that I maintain that has the express purpose of breaking
>> > my users.
>> >
>> > You just artificially constrained the problems, so that no other
>> > solution is acceptable.  On that basis alone I am object to this whole
>> > approach to steam roll over me and my code.
>>
>> If you want an example of what kind of harm it can cause to introduce a
>> failure where no failure was before I invite you to look at what
>> happened with sendmail when setuid was modified to fail, when changing
>> the user of a process would cause RLIMIT_NPROC to be exceeded.
>
> I think we are all familiar with the sendmail capabilities bug and the
> others like it, but using that as an excuse to block additional access
> controls seems very weak.  The Linux Kernel is very different from
> when the sendmail bug hit (what was that, ~20 years ago?), with
> advancements in capabilities and other discretionary controls, as well
> as mandatory access controls which have enabled Linux to be certified
> through a number of third party security evaluations.

If you are familiar with scenarios like that then why is there not
being due diligence performed to ensure that userspace won't break?

Certainly none of the paperwork you are talking about does that kind
of checking and it most definitely is not happening before the code
gets merged. 

I am saying that performing that due diligence should be a requirement
before anyone even thinks about merging a patch that adds permission
checks where no existed before.

Sometimes changes to fix security bugs can get away with adding new
restrictions because we know with a very very high degree of probability
that the only thing that will break will be exploit code.  In the rare
case when real world applications are broken such changes need to be
reverted or adapted.  No one has even made the argument that only
exploit code will be affected.

So I am sorry I am the one who has to be the one to get in the way of a
broken process with semantic review,  but due diligence has not been
done.  So I am say no way this code should be merged.


In addition to actually breaking existing userspace, I think there is a
very real danger of breaking userspace, I think there is a very real
danger of breaking network effects by making such a large change to the
design of user namespaces.


>> I am not arguing that what you are proposing is that bad but unexpected
>> failures cause real problems, and at a minimum that needs a better
>> response than: "There is at least one user that wants a failure here".
>
> Let me fix that for you: "There are multiple users who want to have
> better visibility and access control for user namespace creation."

Visibility sure.  Design a proper hook for that.  All the proposed hook
can do is print an audit message.  It can't allocate or manage any state
as there is not the corresponding hook when a user namespace is freed.
So the proposed hook is not appropriate for increasing visibility.


Access control.  Not a chance unless it is carefully designed and
reviewed.  There is a very large cost to adding access control where
it has not previously existed.

I talk about that cost as people breaking my users as that is how I see
it.  I don't see any discussion on why I am wrong.

If we are going to add an access controls I want to see someone point
out something that is actually semantically a problem.  What motivates
an access control?

So far the only answer I have received is people want to reduce the
attack surface of the kernel.  I don't possibly see how reducing the
attack surface by removing user namespaces makes the probability of
having an exploitable kernel bug, anything approaching zero.

So I look at the calculus.  Chance of actually breaking userspace, or
preventing people with a legitimate use from using user namespaces > 0%.
Chance of actually preventing a determined attacker from exploiting the
kernel < 1%.  Amount of work to maintain, non-zero, and I really don't
like it.

Lots of work to achieve nothing but breaking some of my users.

So please stop trying to redesign my subsystem and cause me headaches,
unless you are going to do the due diligence necessary to do so
responsibly.

Eric
