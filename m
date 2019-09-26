Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C8FBEAB8
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 04:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfIZCrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 22:47:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43938 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfIZCrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 22:47:24 -0400
X-Greylist: delayed 6453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2019 22:47:24 EDT
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iDI8M-0007Sc-CO; Wed, 25 Sep 2019 18:59:50 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1iDI8L-0000kj-M1; Wed, 25 Sep 2019 18:59:50 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     netdev@vger.kernel.org, yhs@fb.com, brouer@redhat.com,
        bpf@vger.kernel.org
References: <20190924152005.4659-1-cneirabustos@gmail.com>
Date:   Wed, 25 Sep 2019 19:59:20 -0500
In-Reply-To: <20190924152005.4659-1-cneirabustos@gmail.com> (Carlos Neira's
        message of "Tue, 24 Sep 2019 12:20:01 -0300")
Message-ID: <87ef033maf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1iDI8L-0000kj-M1;;;mid=<87ef033maf.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18iPrb45ynyeSpkvVPFOD8DdZHUateqSWc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4989]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Carlos Neira <cneirabustos@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 340 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.5 (0.7%), b_tie_ro: 1.76 (0.5%), parse: 0.62
        (0.2%), extract_message_metadata: 2.7 (0.8%), get_uri_detail_list:
        1.31 (0.4%), tests_pri_-1000: 3.0 (0.9%), tests_pri_-950: 1.08 (0.3%),
        tests_pri_-900: 0.88 (0.3%), tests_pri_-90: 21 (6.1%), check_bayes: 19
        (5.7%), b_tokenize: 6 (1.7%), b_tok_get_all: 7 (2.1%), b_comp_prob:
        1.64 (0.5%), b_tok_touch_all: 2.9 (0.9%), b_finish: 0.64 (0.2%),
        tests_pri_0: 294 (86.5%), check_dkim_signature: 0.42 (0.1%),
        check_dkim_adsp: 2.4 (0.7%), poll_dns_idle: 1.03 (0.3%), tests_pri_10:
        1.69 (0.5%), tests_pri_500: 4.7 (1.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH V11 0/4] BPF: New helper to obtain namespace data from current task
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Carlos Neira <cneirabustos@gmail.com> writes:

> Currently bpf_get_current_pid_tgid(), is used to do pid filtering in bcc's
> scripts but this helper returns the pid as seen by the root namespace which is
> fine when a bcc script is not executed inside a container.
> When the process of interest is inside a container, pid filtering will not work
> if bpf_get_current_pid_tgid() is used.
> This helper addresses this limitation returning the pid as it's seen by the current
> namespace where the script is executing.
>
> In the future different pid_ns files may belong to different devices, according to the
> discussion between Eric Biederman and Yonghong in 2017 Linux plumbers conference.
> To address that situation the helper requires inum and dev_t from /proc/self/ns/pid.
> This helper has the same use cases as bpf_get_current_pid_tgid() as it can be
> used to do pid filtering even inside a container.

I think I may have asked this before.  If I am repeating old gound
please excuse me.

Am I correct in understanding these new helpers are designed to be used
when programs running in ``conainers'' call it inside pid namespaces
register bpf programs for tracing?

If so would it be possible to change how the existing bpf opcodes
operate when they are used in the context of a pid namespace?

That later would seem to allow just moving an existing application into
a pid namespace with no modifications.   If we can do this with trivial
cost at bpf compile time and with no userspace changes that would seem
a better approach.

If not can someone point me to why we can't do that?  What am I missing?

Eric

> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
>
> Carlos Neira (4):
>   fs/nsfs.c: added ns_match
>   bpf: added new helper bpf_get_ns_current_pid_tgid
>   tools: Added bpf_get_ns_current_pid_tgid helper
>   tools/testing/selftests/bpf: Add self-tests for new helper. self tests
>     added for new helper
>
>  fs/nsfs.c                                     |   8 +
>  include/linux/bpf.h                           |   1 +
>  include/linux/proc_ns.h                       |   2 +
>  include/uapi/linux/bpf.h                      |  18 ++-
>  kernel/bpf/core.c                             |   1 +
>  kernel/bpf/helpers.c                          |  32 ++++
>  kernel/trace/bpf_trace.c                      |   2 +
>  tools/include/uapi/linux/bpf.h                |  18 ++-
>  tools/testing/selftests/bpf/Makefile          |   2 +-
>  tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
>  .../selftests/bpf/progs/test_pidns_kern.c     |  71 ++++++++
>  tools/testing/selftests/bpf/test_pidns.c      | 152 ++++++++++++++++++
>  12 files changed, 307 insertions(+), 3 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_pidns_kern.c
>  create mode 100644 tools/testing/selftests/bpf/test_pidns.c
