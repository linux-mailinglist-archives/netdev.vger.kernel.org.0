Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F217597853
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 23:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242127AbiHQU4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 16:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbiHQU4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 16:56:47 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE86A99E9;
        Wed, 17 Aug 2022 13:56:38 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:43026)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOQ5c-007tAA-3N; Wed, 17 Aug 2022 14:56:36 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:44962 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOQ5b-006es9-5Q; Wed, 17 Aug 2022 14:56:35 -0600
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
Date:   Wed, 17 Aug 2022 15:56:26 -0500
In-Reply-To: <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
        (Paul Moore's message of "Wed, 17 Aug 2022 16:13:39 -0400")
Message-ID: <8735du7fnp.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oOQ5b-006es9-5Q;;;mid=<8735du7fnp.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/Xn3ZKbDRXVpMvUTRIq5cONwBCXE13Nz4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 383 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 10 (2.7%), b_tie_ro: 9 (2.3%), parse: 0.91 (0.2%),
         extract_message_metadata: 14 (3.6%), get_uri_detail_list: 1.36 (0.4%),
         tests_pri_-1000: 18 (4.7%), tests_pri_-950: 1.24 (0.3%),
        tests_pri_-900: 1.00 (0.3%), tests_pri_-90: 74 (19.2%), check_bayes:
        72 (18.8%), b_tokenize: 8 (2.1%), b_tok_get_all: 9 (2.4%),
        b_comp_prob: 2.6 (0.7%), b_tok_touch_all: 49 (12.9%), b_finish: 0.77
        (0.2%), tests_pri_0: 242 (63.1%), check_dkim_signature: 0.54 (0.1%),
        check_dkim_adsp: 2.7 (0.7%), poll_dns_idle: 10 (2.7%), tests_pri_10:
        1.71 (0.4%), tests_pri_500: 19 (4.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Paul Moore <paul@paul-moore.com> writes:
>>
>> > At the end of the v4 patchset I suggested merging this into lsm/next
>> > so it could get a full -rc cycle in linux-next, assuming no issues
>> > were uncovered during testing
>>
>> What in the world can be uncovered in linux-next for code that has no in
>> tree users.
>
> The patchset provides both BPF LSM and SELinux implementations of the
> hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
> If no one beats me to it, I plan to work on adding a test to the
> selinux-testsuite as soon as I'm done dealing with other urgent
> LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
> run these tests multiple times a week (multiple times a day sometimes)
> against the -rcX kernels with the lsm/next, selinux/next, and
> audit/next branches applied on top.  I know others do similar things.

A layer of hooks that leaves all of the logic to userspace is not an
in-tree user for purposes of understanding the logic of the code.


The reason why I implemented user namespaces is so that all of linux's
neat features could be exposed to non-root userspace processes, in
a way that doesn't break suid root processes.


The access control you are adding to user namespaces looks to take that
away.  It looks to remove the whole point of user namespaces.


So without any mention of how people intend to use this feature, without
any code that uses this hook to implement semantics.  Without any talk
about how this semantic change is reasonable.  I strenuously object.

Eric

