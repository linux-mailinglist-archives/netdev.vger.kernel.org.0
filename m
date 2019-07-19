Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99286E859
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfGSQAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:00:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58713 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfGSQAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:00:52 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVJR-0000DQ-Q5; Fri, 19 Jul 2019 10:00:49 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVJF-00007t-01; Fri, 19 Jul 2019 10:00:49 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        nhorman@tuxdriver.com
References: <20190529153427.GB8959@cisco>
        <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
        <20190529222835.GD8959@cisco>
        <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
        <20190530170913.GA16722@mail.hallyn.com>
        <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
        <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
        <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
        <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
        <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
        <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
        <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
Date:   Fri, 19 Jul 2019 11:00:24 -0500
In-Reply-To: <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
        (Paul Moore's message of "Thu, 18 Jul 2019 17:52:58 -0400")
Message-ID: <87muhadnfr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoVJF-00007t-01;;;mid=<87muhadnfr.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18MlRZOnz5KekqSTfqL1FafpgF6dgr4Jq4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 12445 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 3.0 (0.0%), b_tie_ro: 2.0 (0.0%), parse: 1.79
        (0.0%), extract_message_metadata: 20 (0.2%), get_uri_detail_list: 3.3
        (0.0%), tests_pri_-1000: 13 (0.1%), tests_pri_-950: 1.51 (0.0%),
        tests_pri_-900: 1.26 (0.0%), tests_pri_-90: 34 (0.3%), check_bayes: 31
        (0.3%), b_tokenize: 10 (0.1%), b_tok_get_all: 9 (0.1%), b_comp_prob: 6
        (0.0%), b_tok_touch_all: 2.6 (0.0%), b_finish: 0.85 (0.0%),
        tests_pri_0: 380 (3.1%), check_dkim_signature: 1.03 (0.0%),
        check_dkim_adsp: 3.3 (0.0%), poll_dns_idle: 11972 (96.2%),
        tests_pri_10: 2.1 (0.0%), tests_pri_500: 11982 (96.3%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> On 2019-07-16 19:30, Paul Moore wrote:
>
> ...
>
>> > We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> > ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>>
>> Ok.  So does a process in a non-init user namespace have two (or more)
>> sets of capabilities stored in creds, one in the init_user_ns, and one
>> in current_user_ns?  Or does it get stripped of all its capabilities in
>> init_user_ns once it has its own set in current_user_ns?  If the former,
>> then we can use capable().  If the latter, we need another mechanism, as
>> you have suggested might be needed.
>
> Unfortunately I think the problem is that ultimately we need to allow
> any container orchestrator that has been given privileges to manage
> the audit container ID to also grant that privilege to any of the
> child process/containers it manages.  I don't believe we can do that
> with capabilities based on the code I've looked at, and the
> discussions I've had, but if you find a way I would leave to hear it.

>> If some random unprivileged user wants to fire up a container
>> orchestrator/engine in his own user namespace, then audit needs to be
>> namespaced.  Can we safely discard this scenario for now?
>
> I think the only time we want to allow a container orchestrator to
> manage the audit container ID is if it has been granted that privilege
> by someone who has that privilege already.  In the zero-container, or
> single-level of containers, case this is relatively easy, and we can
> accomplish it using CAP_AUDIT_CONTROL as the privilege.  If we start
> nesting container orchestrators it becomes more complicated as we need
> to be able to support granting and inheriting this privilege in a
> manner; this is why I suggested a new mechanism *may* be necessary.


Let me segway a bit and see if I can get this conversation out of the
rut it seems to have drifted into.

Unprivileged containers and nested containers exist today and are going
to become increasingly common.  Let that be a given.

As I recall the interesting thing for audit to log is actions by
privileged processes.  Audit can log more but generally configuring
logging by of the actions of unprivileged users is effectively a self
DOS.

So I think the initial implementation can safely ignore actions of
nested containers and unprivileged containers because you don't care
about their actions. 

If we start allow running audit in a container then we need to deal with
all of the nesting issues but until then I don't think you folks care.

Or am I wrong.  Do the requirements for securely auditing things from
the kernel care about the actions of unprivileged users?

Eric
