Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975B61AD132
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730600AbgDPUgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:36:22 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40974 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgDPUgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:36:21 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jPBF9-0003Wf-Lk; Thu, 16 Apr 2020 14:36:15 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jPBF8-0008Kz-Fm; Thu, 16 Apr 2020 14:36:15 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>, nhorman@tuxdriver.com,
        linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
References: <20200318215550.es4stkjwnefrfen2@madcap2.tricolour.ca>
        <CAHC9VhSdDDP7Ec-w61NhGxZG5ZiekmrBCAg=Y=VJvEZcgQh46g@mail.gmail.com>
        <20200319220249.jyr6xmwvflya5mks@madcap2.tricolour.ca>
        <CAHC9VhR84aN72yNB_j61zZgrQV1y6yvrBLNY7jp7BqQiEDL+cw@mail.gmail.com>
        <20200324210152.5uydf3zqi3dwshfu@madcap2.tricolour.ca>
        <CAHC9VhTQUnVhoN3JXTAQ7ti+nNLfGNVXhT6D-GYJRSpJHCwDRg@mail.gmail.com>
        <20200330134705.jlrkoiqpgjh3rvoh@madcap2.tricolour.ca>
        <CAHC9VhQTsEMcYAF1CSHrrVn07DR450W9j6sFVfKAQZ0VpheOfw@mail.gmail.com>
        <20200330162156.mzh2tsnovngudlx2@madcap2.tricolour.ca>
        <CAHC9VhTRzZXJ6yUFL+xZWHNWZFTyiizBK12ntrcSwmgmySbkWw@mail.gmail.com>
        <20200330174937.xalrsiev7q3yxsx2@madcap2.tricolour.ca>
        <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
Date:   Thu, 16 Apr 2020 15:33:13 -0500
In-Reply-To: <CAHC9VhR_bKSHDn2WAUgkquu+COwZUanc0RV3GRjMDvpoJ5krjQ@mail.gmail.com>
        (Paul Moore's message of "Mon, 30 Mar 2020 15:55:36 -0400")
Message-ID: <871ronf9x2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jPBF8-0008Kz-Fm;;;mid=<871ronf9x2.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18QCbICEec/DdkpMxCQSiOIlOx7aNlCCNU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSlimDrugH,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4839]
        *  0.7 XMSubLong Long Subject
        *  1.0 XMSlimDrugH Weight loss drug headers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Paul Moore <paul@paul-moore.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 436 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 13 (2.9%), b_tie_ro: 11 (2.5%), parse: 1.53
        (0.4%), extract_message_metadata: 19 (4.2%), get_uri_detail_list: 3.2
        (0.7%), tests_pri_-1000: 19 (4.3%), tests_pri_-950: 1.66 (0.4%),
        tests_pri_-900: 1.33 (0.3%), tests_pri_-90: 67 (15.3%), check_bayes:
        65 (14.9%), b_tokenize: 11 (2.5%), b_tok_get_all: 8 (1.9%),
        b_comp_prob: 2.9 (0.7%), b_tok_touch_all: 40 (9.1%), b_finish: 0.79
        (0.2%), tests_pri_0: 296 (68.0%), check_dkim_signature: 0.77 (0.2%),
        check_dkim_adsp: 3.1 (0.7%), poll_dns_idle: 0.23 (0.1%), tests_pri_10:
        3.5 (0.8%), tests_pri_500: 10 (2.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH ghak90 V8 07/16] audit: add contid support for signalling the audit daemon
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Mon, Mar 30, 2020 at 1:49 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> On 2020-03-30 13:34, Paul Moore wrote:
>> > On Mon, Mar 30, 2020 at 12:22 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > > On 2020-03-30 10:26, Paul Moore wrote:
>> > > > On Mon, Mar 30, 2020 at 9:47 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > > > > On 2020-03-28 23:11, Paul Moore wrote:
>> > > > > > On Tue, Mar 24, 2020 at 5:02 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > > > > > > On 2020-03-23 20:16, Paul Moore wrote:
>> > > > > > > > On Thu, Mar 19, 2020 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > > > > > > > > On 2020-03-18 18:06, Paul Moore wrote:
>
> ...
>
>> > > Well, every time a record gets generated, *any* record gets generated,
>> > > we'll need to check for which audit daemons this record is in scope and
>> > > generate a different one for each depending on the content and whether
>> > > or not the content is influenced by the scope.
>> >
>> > That's the problem right there - we don't want to have to generate a
>> > unique record for *each* auditd on *every* record.  That is a recipe
>> > for disaster.
>> >
>> > Solving this for all of the known audit records is not something we
>> > need to worry about in depth at the moment (although giving it some
>> > casual thought is not a bad thing), but solving this for the audit
>> > container ID information *is* something we need to worry about right
>> > now.
>>
>> If you think that a different nested contid value string per daemon is
>> not acceptable, then we are back to issuing a record that has only *one*
>> contid listed without any nesting information.  This brings us back to
>> the original problem of keeping *all* audit log history since the boot
>> of the machine to be able to track the nesting of any particular contid.
>
> I'm not ruling anything out, except for the "let's just completely
> regenerate every record for each auditd instance".

Paul I am a bit confused about what you are referring to when you say
regenerate every record.

Are you saying that you don't want to repeat the sequence:
	audit_log_start(...);
	audit_log_format(...);
	audit_log_end(...);
for every nested audit daemon?

Or are you saying that you would like to literraly want to send the same
skb to each of the nested audit daemons?

Or are you thinking of something else?

Eric
