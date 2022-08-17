Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255595978E4
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbiHQVYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 17:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiHQVYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 17:24:41 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A59E5AC4E;
        Wed, 17 Aug 2022 14:24:39 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:40598)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOQWj-00Efck-85; Wed, 17 Aug 2022 15:24:37 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:32940 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOQWi-006mnP-7Y; Wed, 17 Aug 2022 15:24:36 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
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
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
References: <20220815162028.926858-1-fred@cloudflare.com>
        <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
        <8735dux60p.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
        <871qte8wy3.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
        <8735du7fnp.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
Date:   Wed, 17 Aug 2022 16:24:28 -0500
In-Reply-To: <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
        (Paul Moore's message of "Wed, 17 Aug 2022 17:09:07 -0400")
Message-ID: <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oOQWi-006mnP-7Y;;;mid=<87tu6a4l83.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/L7Q+eLO/zhN6zCRTrP7mmcvX3T2bbYZI=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 451 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 11 (2.5%), b_tie_ro: 10 (2.2%), parse: 1.12
        (0.2%), extract_message_metadata: 17 (3.7%), get_uri_detail_list: 2.4
        (0.5%), tests_pri_-1000: 23 (5.2%), tests_pri_-950: 1.20 (0.3%),
        tests_pri_-900: 1.02 (0.2%), tests_pri_-90: 62 (13.7%), check_bayes:
        61 (13.4%), b_tokenize: 9 (2.1%), b_tok_get_all: 10 (2.1%),
        b_comp_prob: 2.9 (0.6%), b_tok_touch_all: 35 (7.7%), b_finish: 0.88
        (0.2%), tests_pri_0: 319 (70.7%), check_dkim_signature: 0.64 (0.1%),
        check_dkim_adsp: 3.1 (0.7%), poll_dns_idle: 1.15 (0.3%), tests_pri_10:
        2.7 (0.6%), tests_pri_500: 10 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, Aug 17, 2022 at 4:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>> > On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> >> Paul Moore <paul@paul-moore.com> writes:
>> >>
>> >> > At the end of the v4 patchset I suggested merging this into lsm/next
>> >> > so it could get a full -rc cycle in linux-next, assuming no issues
>> >> > were uncovered during testing
>> >>
>> >> What in the world can be uncovered in linux-next for code that has no in
>> >> tree users.
>> >
>> > The patchset provides both BPF LSM and SELinux implementations of the
>> > hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
>> > If no one beats me to it, I plan to work on adding a test to the
>> > selinux-testsuite as soon as I'm done dealing with other urgent
>> > LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
>> > run these tests multiple times a week (multiple times a day sometimes)
>> > against the -rcX kernels with the lsm/next, selinux/next, and
>> > audit/next branches applied on top.  I know others do similar things.
>>
>> A layer of hooks that leaves all of the logic to userspace is not an
>> in-tree user for purposes of understanding the logic of the code.
>
> The BPF LSM selftests which are part of this patchset live in-tree.
> The SELinux hook implementation is completely in-tree with the
> subject/verb/object relationship clearly described by the code itself.
> After all, the selinux_userns_create() function consists of only two
> lines, one of which is an assignment.  Yes, it is true that the
> SELinux policy lives outside the kernel, but that is because there is
> no singular SELinux policy for everyone.  From a practical
> perspective, the SELinux policy is really just a configuration file
> used to setup the kernel at runtime; it is not significantly different
> than an iptables script, /etc/sysctl.conf, or any of the other myriad
> of configuration files used to configure the kernel during boot.

I object to adding the new system configuration knob.

Especially when I don't see people explaining why such a knob is a good
idea.  What is userspace going to do with this new feature that makes it
worth maintaining in the kernel?

That is always the conversation we have when adding new features, and
that is exactly the conversation that has not happened here.

Adding a layer of indirection should not exempt a new feature from
needing to justify itself.

Eric

