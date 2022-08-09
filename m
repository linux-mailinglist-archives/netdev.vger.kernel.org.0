Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834DB58E1F3
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiHIVlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiHIVlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:41:16 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E3A5D0E8;
        Tue,  9 Aug 2022 14:41:14 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:53108)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLWyM-00E7HV-Jn; Tue, 09 Aug 2022 15:41:11 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:49148 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLWyL-003L0d-Hd; Tue, 09 Aug 2022 15:41:10 -0600
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
        <87czd95rjc.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhQY6H4JxOvSYWk2cpH8E3LYeOkMP_ay+ih+ULKKdeob=Q@mail.gmail.com>
Date:   Tue, 09 Aug 2022 16:40:41 -0500
In-Reply-To: <CAHC9VhQY6H4JxOvSYWk2cpH8E3LYeOkMP_ay+ih+ULKKdeob=Q@mail.gmail.com>
        (Paul Moore's message of "Tue, 9 Aug 2022 12:47:03 -0400")
Message-ID: <87a68dccyu.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oLWyL-003L0d-Hd;;;mid=<87a68dccyu.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18KQ9aFqAGQLWmWStMCKmpNtmakBekivvk=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 491 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 10 (1.9%), b_tie_ro: 8 (1.7%), parse: 0.95 (0.2%),
         extract_message_metadata: 12 (2.4%), get_uri_detail_list: 1.51 (0.3%),
         tests_pri_-1000: 8 (1.6%), tests_pri_-950: 1.25 (0.3%),
        tests_pri_-900: 1.04 (0.2%), tests_pri_-90: 96 (19.6%), check_bayes:
        94 (19.2%), b_tokenize: 8 (1.6%), b_tok_get_all: 8 (1.7%),
        b_comp_prob: 2.7 (0.6%), b_tok_touch_all: 72 (14.7%), b_finish: 0.74
        (0.2%), tests_pri_0: 339 (68.9%), check_dkim_signature: 0.55 (0.1%),
        check_dkim_adsp: 3.1 (0.6%), poll_dns_idle: 1.34 (0.3%), tests_pri_10:
        3.6 (0.7%), tests_pri_500: 17 (3.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:
>
> What level of due diligence would satisfy you Eric?

Having a real conversation about what a change is doing and to talk
about it's merits and it's pro's and cons.  I can't promise I would be
convinced but that is the kind of conversation it would take.

I was not trying to place an insurmountable barrier I was simply looking
to see if people had been being careful and doing what is generally
accepted for submitting a kernel patch.  From all I can see that has
completely not happened here.

> If that isn't the case, and this request is being made in good faith

Again you are calling me a liar. I really don't appreciate that.

As for something already returning an error.  The setuid system call
also has error returns, and enforcing RLIMIT_NPROC caused sendmail to
misbehave.

I bring up the past in this way only to illustrate that things can
happen.  That simply examining the kernel and not thinking about
userspace really isn't enough.

I am also concerned about the ecosystem effects of adding random access
control checks to a system call that does not perform access control
checks.

As I said this patch is changing a rather fundamental design decision by
adding an access control.  A design decision that for the most part has
worked out quite well, and has allowed applications to add sandboxing
support to themselves without asking permission to anyone.

Adding an access control all of a sudden means application developers
are having to ask for permission to things that are perfectly safe,
and it means many parts of the kernel gets less love both in use
and in maintenance.

It might be possible to convince me that design decision needs to
change, or that what is being proposed is small enough it does not
practically change that design decision.

Calling me a liar is not the way to change my mind.  Ignoring me
and pushing this through without addressing my concerns is not
the way to change my mind.

I honestly I want what I asked for at the start.  I want discussion of
what problems are being solved so we can talk about the problem or
problems and if this is even the appropriate solution to them.

Eric

