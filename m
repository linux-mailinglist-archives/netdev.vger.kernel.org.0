Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D78C58CE86
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244315AbiHHT0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiHHT0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:26:15 -0400
Received: from out02.mta.xmission.com (out02.mta.xmission.com [166.70.13.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23268A186;
        Mon,  8 Aug 2022 12:26:14 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:40090)
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oL8OC-001noO-Bu; Mon, 08 Aug 2022 13:26:12 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:47070 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oL8OB-00HYY7-HW; Mon, 08 Aug 2022 13:26:11 -0600
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
Date:   Mon, 08 Aug 2022 14:26:04 -0500
In-Reply-To: <CAHC9VhS3udhEecVYVvHm=tuqiPGh034-xPqXYtFjBk23+p-Szg@mail.gmail.com>
        (Paul Moore's message of "Mon, 8 Aug 2022 15:16:16 -0400")
Message-ID: <877d3ia65v.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oL8OB-00HYY7-HW;;;mid=<877d3ia65v.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1+z7lTpSBDaB94moY7v76QqS9bgdJh4/0Y=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Virus: No
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 287 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 3.9 (1.4%), b_tie_ro: 2.7 (0.9%), parse: 0.64
        (0.2%), extract_message_metadata: 8 (2.7%), get_uri_detail_list: 0.68
        (0.2%), tests_pri_-1000: 10 (3.5%), tests_pri_-950: 0.98 (0.3%),
        tests_pri_-900: 0.84 (0.3%), tests_pri_-90: 67 (23.3%), check_bayes:
        66 (22.9%), b_tokenize: 5.0 (1.7%), b_tok_get_all: 6 (2.2%),
        b_comp_prob: 1.46 (0.5%), b_tok_touch_all: 50 (17.6%), b_finish: 0.65
        (0.2%), tests_pri_0: 184 (64.3%), check_dkim_signature: 0.38 (0.1%),
        check_dkim_adsp: 1.63 (0.6%), poll_dns_idle: 0.39 (0.1%),
        tests_pri_10: 1.73 (0.6%), tests_pri_500: 7 (2.5%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCH v4 0/4] Introduce security_create_user_ns()
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

>> I did provide constructive feedback.  My feedback to his problem
>> was to address the real problem of bugs in the kernel.
>
> We've heard from several people who have use cases which require
> adding LSM-level access controls and observability to user namespace
> creation.  This is the problem we are trying to solve here; if you do
> not like the approach proposed in this patchset please suggest another
> implementation that allows LSMs visibility into user namespace
> creation.

Please stop, ignoring my feedback, not detailing what problem or
problems you are actually trying to be solved, and threatening to merge
code into files that I maintain that has the express purpose of breaking
my users.

You just artificially constrained the problems, so that no other
solution is acceptable.  On that basis alone I am object to this whole
approach to steam roll over me and my code.

Eric

