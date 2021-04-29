Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A90C36EF34
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 19:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbhD2RxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 13:53:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38708 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241133AbhD2RxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 13:53:24 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcAq4-00Aa8v-FA; Thu, 29 Apr 2021 11:52:36 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcAq3-0005kg-Mk; Thu, 29 Apr 2021 11:52:36 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
        <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
        <20210422124849.GA1521@willie-the-truck>
        <m1v98egoxf.fsf@fess.ebiederm.org>
        <20210422192349.ekpinkf3wxnmywe3@revolver>
        <m1y2d8dfx8.fsf@fess.ebiederm.org>
        <20210423200126.otleormmjh22joj3@revolver>
Date:   Thu, 29 Apr 2021 12:52:31 -0500
In-Reply-To: <20210423200126.otleormmjh22joj3@revolver> (Liam Howlett's
        message of "Fri, 23 Apr 2021 20:03:17 +0000")
Message-ID: <m1czud6krk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcAq3-0005kg-Mk;;;mid=<m1czud6krk.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19EXfnu02KZWm8B3o5WSHeiqcMyaK11Fy8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=8.0 tests=ALL_TRUSTED,BAYES_20,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMNoVowels,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.0532]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Liam Howlett <liam.howlett@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 402 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 13 (3.3%), b_tie_ro: 11 (2.8%), parse: 1.37
        (0.3%), extract_message_metadata: 4.5 (1.1%), get_uri_detail_list:
        1.51 (0.4%), tests_pri_-1000: 6 (1.6%), tests_pri_-950: 1.74 (0.4%),
        tests_pri_-900: 1.49 (0.4%), tests_pri_-90: 71 (17.6%), check_bayes:
        68 (17.0%), b_tokenize: 8 (2.0%), b_tok_get_all: 6 (1.6%),
        b_comp_prob: 2.6 (0.6%), b_tok_touch_all: 47 (11.8%), b_finish: 1.13
        (0.3%), tests_pri_0: 281 (69.9%), check_dkim_signature: 0.70 (0.2%),
        check_dkim_adsp: 3.0 (0.8%), poll_dns_idle: 0.67 (0.2%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn() sometime returns the wrong signals
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This entire discussion seems to come down to what are the expected
semantics of arm64_notify_segfault.  The use of this helper in
swp_handler and user_cache_main_handler is clearly for the purposes of
instruction emulation.  With instruction emulation it is a bug if the
emulated instruction behaves differently than a real instruction in
the same circumstances.

To properly fix the instruction emulation in arm64_notify_segfault it
looks to me that the proper solution is to call __do_page_fault or
handle_mm_fault the way do_page_fault does and them parse the VM_FAULT
code for which signal to generate.

I would probably rename arm64_notify_segfault to arm64_emulate_fault, or
possibly arm64_notify_fault while fixing the emulation so that it
can return different signals and so that people don't have to guess
what the function is supposed to do.

For the specific case of sigreturn and rt_sigreturn it looks sufficient
to use the fixed arm64_notify_segfault.  As it appears the that the code
is attempting to act like it is emulating an instruction that does not
exist.


There is an argument that sigreturn and rt_sigreturn do a poor enough
job of acting like the fault was caused by an instruction, as well
as failing for other reasons it might make more sense to just have
sigreturn and rt_sigreturn call "force_sig(SIGSEGV);"  But that seems
out of scope of what you are trying to fix right now so I would not
worry about it.

Eric
