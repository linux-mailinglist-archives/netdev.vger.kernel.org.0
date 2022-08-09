Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E888B58E226
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 23:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiHIVwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 17:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiHIVwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 17:52:19 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33F265662;
        Tue,  9 Aug 2022 14:52:18 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:51104)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLX97-0045M3-3O; Tue, 09 Aug 2022 15:52:17 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:49750 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oLX95-003Mhu-4e; Tue, 09 Aug 2022 15:52:16 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
References: <20220801180146.1157914-1-fred@cloudflare.com>
        <87les7cq03.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
        <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
        <877d3ia65v.fsf@email.froward.int.ebiederm.org>
        <87bksu8qs2.fsf@email.froward.int.ebiederm.org>
        <CAHC9VhTEwD2y9Witj-1z3e2TC-NGjghQ4KT4Dqf3UOLzDcDc3Q@mail.gmail.com>
        <87czd95rjc.fsf@email.froward.int.ebiederm.org>
        <f38216d8-8ee4-d6fd-a5b1-0d21013e09c6@schaufler-ca.com>
Date:   Tue, 09 Aug 2022 16:52:06 -0500
In-Reply-To: <f38216d8-8ee4-d6fd-a5b1-0d21013e09c6@schaufler-ca.com> (Casey
        Schaufler's message of "Tue, 9 Aug 2022 10:43:30 -0700")
Message-ID: <87bkstaxvd.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oLX95-003Mhu-4e;;;mid=<87bkstaxvd.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19MEtOIAQH6CwOw14KNBbhM4tqX1/pJm0A=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Casey Schaufler <casey@schaufler-ca.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1377 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 4.2 (0.3%), b_tie_ro: 3.0 (0.2%), parse: 0.70
        (0.1%), extract_message_metadata: 8 (0.6%), get_uri_detail_list: 1.09
        (0.1%), tests_pri_-1000: 7 (0.5%), tests_pri_-950: 1.12 (0.1%),
        tests_pri_-900: 0.84 (0.1%), tests_pri_-90: 77 (5.6%), check_bayes: 76
        (5.5%), b_tokenize: 6 (0.5%), b_tok_get_all: 9 (0.7%), b_comp_prob:
        2.1 (0.2%), b_tok_touch_all: 55 (4.0%), b_finish: 0.80 (0.1%),
        tests_pri_0: 1263 (91.7%), check_dkim_signature: 0.38 (0.0%),
        check_dkim_adsp: 1.66 (0.1%), poll_dns_idle: 0.25 (0.0%),
        tests_pri_10: 3.0 (0.2%), tests_pri_500: 9 (0.7%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> Smack has no interest in using the proposed hook because user namespaces
> are neither subjects nor objects. They are collections of DAC and/or
> privilege configuration alternatives. Or something like that. From the
> viewpoint of a security module that only implements old fashioned MAC
> there is no value in constraining user namespaces.

The goal is to simply enable things that become safe when you don't have
to worry about confusing setuid executables.

> SELinux, on the other hand, seeks to be comprehensive well beyond
> controlling accesses between subjects and objects. Asking the question
> "should there be a control on this operation?" seems sufficient to justify
> adding the control to SELinux policy. This is characteristic of
> "Fine Grain" control.

I see that from a theoretical standpoint.  On the flip side I prefer
arguments grounded in something more than what an abstract framework
could appreciate.  We are so far from any theoretical purity in the
linux kernel that I can't see theoretical purity being enough to justify
a decision like this.

> So I'm of two minds on this. I don't need the hook, but I also understand
> why SELinux and BPF want it. I don't necessarily agree with their logic,
> but it is consistent with existing behavior. Any system that uses either
> of those security modules needs to be ready for unexpected denials based
> on any potential security concern. Keeping namespaces completely orthogonal
> to LSM seems doomed to failure eventually.

I can cross that bridge when there is a healthy conversation about such
a change.

Too often I get "ouch! Creating a user namespace was used as the easiest
way to exploit a security bug. Let's solve the issue by denying user
namespaces."  Which leads to half thought out policies made out of fear.

Which is where I think this conversation started.  I haven't seen it
make it's way to any healthy reasons to deny user namespaces yet.

Eric
