Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B20F5883AA
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 23:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiHBVfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 17:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiHBVfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 17:35:09 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E9EB1E5;
        Tue,  2 Aug 2022 14:35:07 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:53070)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oIzXb-007SMb-IA; Tue, 02 Aug 2022 15:35:03 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:48544 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oIzXa-008ty7-FF; Tue, 02 Aug 2022 15:35:03 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Frederick Lawler <fred@cloudflare.com>, <kpsingh@kernel.org>,
        <revest@chromium.org>, <jackmanb@chromium.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <jmorris@namei.org>, <serge@hallyn.com>,
        <stephen.smalley.work@gmail.com>, <eparis@parisplace.org>,
        <shuah@kernel.org>, <brauner@kernel.org>, <casey@schaufler-ca.com>,
        <bpf@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <selinux@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@cloudflare.com>, <cgzones@googlemail.com>,
        <karl@bigbadwolfsecurity.com>
References: <20220721172808.585539-1-fred@cloudflare.com>
        <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
        <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
Date:   Tue, 02 Aug 2022 16:33:39 -0500
In-Reply-To: <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
        (Paul Moore's message of "Fri, 22 Jul 2022 08:20:10 -0400")
Message-ID: <87a68mcouk.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oIzXa-008ty7-FF;;;mid=<87a68mcouk.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX18lynnmgZ2Re2lm2I0EfjAG9MQaqRZMbyU=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 357 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 4.1 (1.1%), b_tie_ro: 2.8 (0.8%), parse: 0.67
        (0.2%), extract_message_metadata: 11 (3.0%), get_uri_detail_list: 0.90
        (0.3%), tests_pri_-1000: 32 (8.9%), tests_pri_-950: 0.99 (0.3%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 71 (19.8%), check_bayes:
        69 (19.4%), b_tokenize: 6 (1.6%), b_tok_get_all: 7 (2.0%),
        b_comp_prob: 1.69 (0.5%), b_tok_touch_all: 52 (14.4%), b_finish: 0.76
        (0.2%), tests_pri_0: 224 (62.7%), check_dkim_signature: 0.40 (0.1%),
        check_dkim_adsp: 1.89 (0.5%), poll_dns_idle: 0.49 (0.1%),
        tests_pri_10: 2.6 (0.7%), tests_pri_500: 8 (2.3%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On July 22, 2022 2:12:03 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
>> On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>> used the LSM cred_prepare hook because that is the closest hook to prevent
>>> a call to create_user_ns().
>>>
>>> The calls look something like this:
>>>
>>> cred = prepare_creds()
>>> security_prepare_creds()
>>> call_int_hook(cred_prepare, ...
>>> if (cred)
>>> create_user_ns(cred)
>>>
>>> We noticed that error codes were not propagated from this hook and
>>> introduced a patch [1] to propagate those errors.
>>>
>>> The discussion notes that security_prepare_creds()
>>> is not appropriate for MAC policies, and instead the hook is
>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>
>>> Ultimately, we concluded that a better course of action is to introduce
>>> a new security hook for LSM authors. [3]
>>>
>>> This patch set first introduces a new security_create_user_ns() function
>>> and userns_create LSM hook, then marks the hook as sleepable in BPF.
>> Patch 1 and 4 still need review from the lsm/security side.
>
>
> This patchset is in my review queue and assuming everything checks
> out, I expect to merge it after the upcoming merge window closes.

It doesn't even address my issues with the last patchset.

So it has my NACK.

Eric
