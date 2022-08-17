Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8DC59729E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240776AbiHQPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240632AbiHQPId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:08:33 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B203E9C8CE;
        Wed, 17 Aug 2022 08:08:31 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:37894)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOKei-006IBh-F4; Wed, 17 Aug 2022 09:08:28 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:57490 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oOKeg-004bdV-9U; Wed, 17 Aug 2022 09:08:28 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
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
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com,
        Paul Moore <paul@paul-moore.com>
References: <20220815162028.926858-1-fred@cloudflare.com>
        <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
Date:   Wed, 17 Aug 2022 10:07:50 -0500
In-Reply-To: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
        (Paul Moore's message of "Tue, 16 Aug 2022 17:51:12 -0400")
Message-ID: <8735dux60p.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oOKeg-004bdV-9U;;;mid=<8735dux60p.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+M/EzBB2yHTS3inlqfrtzf1DGaD1mEXx4=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1527 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 4.5 (0.3%), b_tie_ro: 3.2 (0.2%), parse: 0.94
        (0.1%), extract_message_metadata: 3.9 (0.3%), get_uri_detail_list:
        1.97 (0.1%), tests_pri_-1000: 3.6 (0.2%), tests_pri_-950: 1.28 (0.1%),
        tests_pri_-900: 0.99 (0.1%), tests_pri_-90: 125 (8.2%), check_bayes:
        123 (8.0%), b_tokenize: 7 (0.4%), b_tok_get_all: 9 (0.6%),
        b_comp_prob: 2.3 (0.2%), b_tok_touch_all: 102 (6.7%), b_finish: 0.82
        (0.1%), tests_pri_0: 1368 (89.6%), check_dkim_signature: 0.40 (0.0%),
        check_dkim_adsp: 1.90 (0.1%), poll_dns_idle: 0.55 (0.0%),
        tests_pri_10: 2.9 (0.2%), tests_pri_500: 9 (0.6%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> I just merged this into the lsm/next tree, thanks for seeing this
> through Frederick, and thank you to everyone who took the time to
> review the patches and add their tags.
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git next

Paul, Frederick

I repeat my NACK, in part because I am being ignored and in part
because the hook does not make technical sense.


Linus I want you to know that this has been put in the lsm tree against
my explicit and clear objections.

My request to talk about the actual problems that are being address has
been completely ignored.

I have been a bit slow in dealing with this conversation because I am
very much sick and not on top of my game, but that is no excuse to steam
roll over me, instead of addressing my concerns.


This is an irresponsible way of adding an access control to user
namespace creation.  This is a linux-api and manpages level kind of
change, as this is a semantic change visible to userspace.  Instead that
concern has been brushed off as different return code to userspace.

For observably this is a terrible LSM interface because there is no
pair with user namespace destruction, nor is their any ability for the
LSM to allocate any state to track the user namespace.  As there is no
patch actually calling audit or anything else observably does not appear
to be a driving factor of this new interface.




The common scenarios I am aware of for using the user namespace are:
- Creating a container.
- Using the user namespace to sandbox your application like chrome does.
- Running an exploit.

Returning an error code in the first 2 scenarios will create a userspace
regression as either userspace will run less securely or it won't work
at all.

Returning an error code in the third scenario when someone is trying to
exploit your machine is equally foolish as you are giving the exploit
the chance to continue running.  The application should be killed
instead.


Further adding a random failure mode to user namespace creation if it is
used at all will just encourage userspace to use a setuid application to
perform the namespace creation instead.  Creating a less secure system
overall.

If the concern is to reduce the attack surface everything this
proposed hook can do is already possible with the security_capable
security hook.

So Paul, Frederick please drop this.  I can't see what this new hook is
good for except creating regressions in existing userspace code.  I am
not willing to support such a hook in code that I maintain.

Eric
