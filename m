Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BC058CE1D
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 20:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244061AbiHHS4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 14:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243680AbiHHS4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 14:56:49 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6B61834B;
        Mon,  8 Aug 2022 11:56:48 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:35272)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oL7vh-00BiRy-6H; Mon, 08 Aug 2022 12:56:45 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:45314 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oL7vf-00HUDL-GZ; Mon, 08 Aug 2022 12:56:44 -0600
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
Date:   Mon, 08 Aug 2022 13:56:18 -0500
In-Reply-To: <CAHC9VhRpUxyxkPaTz1scGeRm+i4KviQQA7WismOX2q5agzC+DQ@mail.gmail.com>
        (Paul Moore's message of "Tue, 2 Aug 2022 22:10:07 -0400")
Message-ID: <87wnbia7jh.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oL7vf-00HUDL-GZ;;;mid=<87wnbia7jh.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+Nfaifvy48ZLTWFCOzOsrcFXZE8jWgnyo=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1107 ms - load_scoreonly_sql: 0.09 (0.0%),
        signal_user_changed: 12 (1.1%), b_tie_ro: 10 (0.9%), parse: 1.45
        (0.1%), extract_message_metadata: 23 (2.1%), get_uri_detail_list: 3.2
        (0.3%), tests_pri_-1000: 59 (5.3%), tests_pri_-950: 1.94 (0.2%),
        tests_pri_-900: 1.62 (0.1%), tests_pri_-90: 105 (9.5%), check_bayes:
        102 (9.3%), b_tokenize: 13 (1.2%), b_tok_get_all: 15 (1.3%),
        b_comp_prob: 8 (0.7%), b_tok_touch_all: 59 (5.3%), b_finish: 1.30
        (0.1%), tests_pri_0: 881 (79.6%), check_dkim_signature: 1.57 (0.1%),
        check_dkim_adsp: 12 (1.1%), poll_dns_idle: 0.42 (0.0%), tests_pri_10:
        2.4 (0.2%), tests_pri_500: 15 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Mon, Aug 1, 2022 at 10:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Frederick Lawler <fred@cloudflare.com> writes:
>>
>> > While creating a LSM BPF MAC policy to block user namespace creation, we
>> > used the LSM cred_prepare hook because that is the closest hook to prevent
>> > a call to create_user_ns().
>>
>> Re-nack for all of the same reasons.
>> AKA This can only break the users of the user namespace.
>>
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>
>> You aren't fixing what your problem you are papering over it by denying
>> access to the user namespace.
>>
>> Nack Nack Nack.
>>
>> Stop.
>>
>> Go back to the drawing board.
>>
>> Do not pass go.
>>
>> Do not collect $200.
>
> If you want us to take your comments seriously Eric, you need to
> provide the list with some constructive feedback that would allow
> Frederick to move forward with a solution to the use case that has
> been proposed.  You response above may be many things, but it is
> certainly not that.

I did provide constructive feedback.  My feedback to his problem
was to address the real problem of bugs in the kernel.

It is not a constructive approach to shoot the messenger
and is not a constructive approach to blow me off every time you
reply.

I have proposed that is there is a subsystem that is unduly buggy we
stop it from being enabled with a user-namespaces.

Further this is a hook really should have extra-ordinary requirements,
as all it can do is add additional failure modes to something that
does not really fail.  AKA all it can do is break-userspace.

As such I need to see a justification on why it makes sense to
break-userspace.

> We've heard from different users now that there are very real use
> cases for this LSM hook.  I understand you are concerned about adding
 > additional controls to user namespaces, but these are controls
> requested by real users, and the controls being requested (LSM hooks,
> with BPF and SELinux implementations) are configurable by the *users*
> at *runtime*.  This patchset does not force additional restrictions on
> user namespaces, it provides a mechanism that *users* can leverage to
> add additional granularity to the access controls surrounding user
> namespaces.

But that is not the problem that cloudfare encountered and are trying to
solve.

At least that is not what I was told when I asked early in the review
cycle.

All saying that is user-configurable does is shift the blame from the
kernel maintainers to the users.  Shift the responsibility from people
who should have enough expertise to know what is going on to people
who are by definition have other concerns, so are less likely to be as
well informed, and less likely to come up with good solutions.

> Eric, if you have a different approach in mind to adding a LSM hook to
> user namespace creation I think we would all very much like to hear
> about it.  However, if you do not have any suggestions along those
> lines, and simply want to NACK any effort to add a LSM hook to user
> namespace creation, I think we all understand your point of view and
> respectfully disagree.  Barring any new approaches or suggestions, I
> think Frederick's patches look reasonable and I still plan on merging
> them into the LSM next branch when the merge window closes.


But it is my code you are planning to merge this into, and your are
asking me to support something.

I admit I have not had time to read everything.  I am sick and tired
and quite frankly very tired that people are busy wanting to shoot
the messenger to the fact that there are bugs in the kernel.

I am speaking up and engaging as best as I can with objections that
are not hot-air.

You are very much proposing to merge code that can only cause
regressions and cause me grief.  At least that is all I see.  I don't
see anything in the change descriptions of the change that refutes that.

I don't see any interaction in fact with my concerns.

In fact your last reply was to completely blow off my request on how to
address the concerns that inspired this patch and to say other people
have a use too.

At this point I am happy to turn your request around and ask that you
address my concerns and not blow them off.  As I have seen no
constructive engagement with my concerns.   I think that is reasonable
as by definition I will get the support issues when some LSM has some
ill-thought out idea of how things should work and I get the bug report.

Eric





