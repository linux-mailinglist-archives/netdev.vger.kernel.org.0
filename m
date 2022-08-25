Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEE55A189E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbiHYSRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243478AbiHYSQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:16:44 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31862BD1FF;
        Thu, 25 Aug 2022 11:16:00 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:35250)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oRHOW-005Rga-9i; Thu, 25 Aug 2022 12:15:56 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:36814 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oRHOU-00DcQ7-Hr; Thu, 25 Aug 2022 12:15:55 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
In-Reply-To: <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
        (Paul Moore's message of "Fri, 19 Aug 2022 17:10:29 -0400")
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
        <8735dux60p.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
        <871qte8wy3.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
        <8735du7fnp.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
        <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
        <20220818140521.GA1000@mail.hallyn.com>
        <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
        <20220819144537.GA16552@mail.hallyn.com>
        <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
Date:   Thu, 25 Aug 2022 13:15:46 -0500
Message-ID: <875yigp4tp.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oRHOU-00DcQ7-Hr;;;mid=<875yigp4tp.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+SG3YsTIgmOSCWJtea0hxDJibtwIu7XJw=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1139 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 9 (0.8%), b_tie_ro: 8 (0.7%), parse: 1.08 (0.1%),
        extract_message_metadata: 15 (1.3%), get_uri_detail_list: 1.83 (0.2%),
        tests_pri_-1000: 9 (0.8%), tests_pri_-950: 1.31 (0.1%),
        tests_pri_-900: 1.08 (0.1%), tests_pri_-90: 178 (15.6%), check_bayes:
        166 (14.5%), b_tokenize: 9 (0.8%), b_tok_get_all: 10 (0.9%),
        b_comp_prob: 3.1 (0.3%), b_tok_touch_all: 139 (12.2%), b_finish: 1.00
        (0.1%), tests_pri_0: 912 (80.0%), check_dkim_signature: 0.67 (0.1%),
        check_dkim_adsp: 4.0 (0.4%), poll_dns_idle: 0.44 (0.0%), tests_pri_10:
        1.75 (0.2%), tests_pri_500: 7 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
>>  I am hoping we can come up with
>> "something better" to address people's needs, make everyone happy, and
>> bring forth world peace.  Which would stack just fine with what's here
>> for defense in depth.
>>
>> You may well not be interested in further work, and that's fine.  I need
>> to set aside a few days to think on this.
>
> I'm happy to continue the discussion as long as it's constructive; I
> think we all are.  My gut feeling is that Frederick's approach falls
> closest to the sweet spot of "workable without being overly offensive"
> (*cough*), but if you've got an additional approach in mind, or an
> alternative approach that solves the same use case problems, I think
> we'd all love to hear about it.

I would love to actually hear the problems people are trying to solve so
that we can have a sensible conversation about the trade offs.

As best I can tell without more information people want to use
the creation of a user namespace as a signal that the code is
attempting an exploit.

As such let me propose instead of returning an error code which will let
the exploit continue, have the security hook return a bool.  With true
meaning the code can continue and on false it will trigger using SIGSYS
to terminate the program like seccomp does.

I am not super fond of that idea, but it means that userspace code is
not expected to deal with the situation, and the only conversation a
userspace application developer needs to enter into with a system
administrator or security policy developer is one to prove they are not
exploit code.  Plus it makes much more sense to kill an exploit
immediately instead of letting it run.


In general when addressing code coverage concerns I think it makes more
sense to use the security hooks to implement some variety of the principle
of least privilege and only give applications access to the kernel
facilities they are known to use.

As far as I can tell creating a user namespace does not increase the
attack surface.  It is the creation of the other namespaces from a user
namespace that begins to do that.  So in general I would think
restrictions should be in places they matter.

Just like the bugs that have exploits that involve the user namespace
are not user namespace bugs, but instead they are bugs in other
subsystems that just happen to go through the user namespace as the
easiest path to the buggy code, not the only path to the buggy code.

Eric

