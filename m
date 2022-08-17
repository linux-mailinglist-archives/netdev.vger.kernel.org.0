Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246BD59773C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241626AbiHQT6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241364AbiHQT63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:58:29 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B30B4AA;
        Wed, 17 Aug 2022 12:58:18 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:36312)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOPB9-004XQI-B8; Wed, 17 Aug 2022 13:58:15 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:46360 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOPB8-00F3nh-DV; Wed, 17 Aug 2022 13:58:14 -0600
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
Date:   Wed, 17 Aug 2022 14:57:40 -0500
In-Reply-To: <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
        (Paul Moore's message of "Wed, 17 Aug 2022 12:01:39 -0400")
Message-ID: <871qte8wy3.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oOPB8-00F3nh-DV;;;mid=<871qte8wy3.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/Z6TDdGlJ2fmDTXjd+QwmHz1uEXKk+3OY=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 379 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 4.7 (1.2%), b_tie_ro: 3.2 (0.8%), parse: 1.06
        (0.3%), extract_message_metadata: 10 (2.7%), get_uri_detail_list: 1.36
        (0.4%), tests_pri_-1000: 6 (1.7%), tests_pri_-950: 1.05 (0.3%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 71 (18.6%), check_bayes:
        69 (18.3%), b_tokenize: 5 (1.4%), b_tok_get_all: 8 (2.0%),
        b_comp_prob: 1.60 (0.4%), b_tok_touch_all: 52 (13.6%), b_finish: 0.79
        (0.2%), tests_pri_0: 222 (58.5%), check_dkim_signature: 0.36 (0.1%),
        check_dkim_adsp: 1.70 (0.4%), poll_dns_idle: 46 (12.1%), tests_pri_10:
        2.5 (0.7%), tests_pri_500: 57 (15.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> At the end of the v4 patchset I suggested merging this into lsm/next
> so it could get a full -rc cycle in linux-next, assuming no issues
> were uncovered during testing

What in the world can be uncovered in linux-next for code that has no in
tree users.

That is one of my largest problems.  I want to talk about the users and
the use cases and I don't get dialog.  Nor do I get hey look back there
you missed it.

Since you don't want to rehash this.  I will just repeat my conclusion
that the patchset appears to introduce an ineffective defense that will
achieve nothing in the defense of the kernel, and so all it will achieve
a code maintenance burden and to occasionally break legitimate users of
the user namespace.

Further the process is broken.  You are changing the semantics of an
operation with the introduction of a security hook.  That needs a
man-page and discussion on linux-abi.  In general of the scrutiny we
give to new systems and changed system calls.  As this change
fundamentally changes the semantics of creating a user namespace.

Skipping that part of the process is not simply disagree that is being
irresponsible.

Eric
