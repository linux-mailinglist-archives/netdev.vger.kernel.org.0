Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03E65621FE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbiF3S25 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Jun 2022 14:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbiF3S2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:28:55 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17562DD5A;
        Thu, 30 Jun 2022 11:28:53 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:47676)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o6yuJ-00ADRh-2N; Thu, 30 Jun 2022 12:28:51 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:58094 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1o6yuI-0067by-0q; Thu, 30 Jun 2022 12:28:50 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, brauner@kernel.org,
        paul@paul-moore.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
        <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
        <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
Date:   Thu, 30 Jun 2022 13:28:42 -0500
In-Reply-To: <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com> (Frederick
        Lawler's message of "Wed, 22 Jun 2022 09:24:31 -0500")
Message-ID: <87v8singyt.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1o6yuI-0067by-0q;;;mid=<87v8singyt.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19nEYAl7ZwZ3vMuIzS+P2PIngCXHdeK06Y=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Frederick Lawler <fred@cloudflare.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 506 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (2.1%), b_tie_ro: 9 (1.8%), parse: 1.04 (0.2%),
         extract_message_metadata: 12 (2.5%), get_uri_detail_list: 1.95 (0.4%),
         tests_pri_-1000: 23 (4.5%), tests_pri_-950: 1.22 (0.2%),
        tests_pri_-900: 1.10 (0.2%), tests_pri_-90: 65 (12.9%), check_bayes:
        64 (12.6%), b_tokenize: 9 (1.8%), b_tok_get_all: 10 (1.9%),
        b_comp_prob: 3.2 (0.6%), b_tok_touch_all: 37 (7.4%), b_finish: 1.00
        (0.2%), tests_pri_0: 377 (74.5%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 3.0 (0.6%), poll_dns_idle: 1.23 (0.2%), tests_pri_10:
        3.0 (0.6%), tests_pri_500: 9 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frederick Lawler <fred@cloudflare.com> writes:

> Hi Casey,
>
> On 6/21/22 7:19 PM, Casey Schaufler wrote:
>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>> used the LSM cred_prepare hook because that is the closest hook to prevent
>>> a call to create_user_ns().
>>>
>>> The calls look something like this:
>>>
>>>      cred = prepare_creds()
>>>          security_prepare_creds()
>>>              call_int_hook(cred_prepare, ...
>>>      if (cred)
>>>          create_user_ns(cred)
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
>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>> Why restrict this hook to user namespaces? It seems that an LSM that
>> chooses to preform controls on user namespaces may want to do so for
>> network namespaces as well.
> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
> CAP_SYS_ADMIN. There is a security use case to prevent this namespace 
> from being created within an unprivileged environment. I'm not opposed to a more
> generic hook, but I don't currently have a use case to block any others. We can
> also say the same is true for the other namespaces: add this generic security
> function to these too.

There is also a very strong security use case for not putting security
checks in the creation of the user namespace.

In particular there are all kinds of kernel features that are useful for
building sandboxes namespaces, chroot, etc, that previous to user
namespaces were not possible to make available to unprivileged users
because they could confuse suid-root executables.  With user namespaces
the concern about confusing suid-root executable goes away.

The only justification I have ever heard for restricting the user
namespace is because it indirectly allows for greater kernel attack
surface.

Do you have a case for restricting the user namespace other than the
kernel is buggy and the user namespace makes the kernel bugs easier
to access?

How does increasing the attack surface of the kernel make the situation
that the kernel is buggy and the attack surface is too big better?

Perhaps it is explained somewhere down-thread and I just have not caught
up yet, but so far I have not see a description of why it makes sense
for a security module to restrict the kernel here.

Eric

p.s.  I am little disappointed that I was not copied on this thread
given that it is my code you are messing with, and I was in an earlier
version of this thread.




