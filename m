Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FE6E7FE
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 17:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfGSPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 11:32:33 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48180 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSPcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 11:32:32 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoUs1-0002I0-Fb; Fri, 19 Jul 2019 09:32:29 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoUs0-0005zu-CO; Fri, 19 Jul 2019 09:32:29 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
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
Date:   Fri, 19 Jul 2019 10:32:13 -0500
In-Reply-To: <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca> (Richard
        Guy Briggs's message of "Wed, 17 Jul 2019 20:51:45 -0400")
Message-ID: <874l3ighvm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoUs0-0005zu-CO;;;mid=<874l3ighvm.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+51FYWsW8BRSUlMyR1nWn6IFnz4uCKOTQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Richard Guy Briggs <rgb@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 656 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 2.9 (0.4%), b_tie_ro: 1.94 (0.3%), parse: 0.88
        (0.1%), extract_message_metadata: 3.3 (0.5%), get_uri_detail_list:
        1.18 (0.2%), tests_pri_-1000: 7 (1.0%), tests_pri_-950: 1.56 (0.2%),
        tests_pri_-900: 1.50 (0.2%), tests_pri_-90: 23 (3.6%), check_bayes: 22
        (3.3%), b_tokenize: 7 (1.1%), b_tok_get_all: 6 (0.9%), b_comp_prob:
        1.93 (0.3%), b_tok_touch_all: 4.5 (0.7%), b_finish: 0.60 (0.1%),
        tests_pri_0: 598 (91.1%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 2.2 (0.3%), poll_dns_idle: 0.60 (0.1%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 6 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On 2019-07-16 19:30, Paul Moore wrote:
>> On Tue, Jul 16, 2019 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2019-07-15 17:04, Paul Moore wrote:
>> > > On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> 
>> > > > At this point I would say we are at an impasse unless we trust
>> > > > ns_capable() or we implement audit namespaces.
>> > >
>> > > I'm not sure how we can trust ns_capable(), but if you can think of a
>> > > way I would love to hear it.  I'm also not sure how namespacing audit
>> > > is helpful (see my above comments), but if you think it is please
>> > > explain.
>> >
>> > So if we are not namespacing, why do we not trust capabilities?
>> 
>> We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>
> Ok.  So does a process in a non-init user namespace have two (or more)
> sets of capabilities stored in creds, one in the init_user_ns, and one
> in current_user_ns?  Or does it get stripped of all its capabilities in
> init_user_ns once it has its own set in current_user_ns?  If the former,
> then we can use capable().  If the latter, we need another mechanism, as
> you have suggested might be needed.

The latter.  There is only one set of capabilities and it is in the
processes current user namespace.

Eric
