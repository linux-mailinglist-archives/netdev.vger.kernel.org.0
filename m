Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718DC368684
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 20:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238583AbhDVSYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 14:24:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48480 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbhDVSYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 14:24:03 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lZdz3-00FE0J-4i; Thu, 22 Apr 2021 12:23:25 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lZdz1-0002QV-Qf; Thu, 22 Apr 2021 12:23:24 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Will Deacon <will@kernel.org>
Cc:     Liam Howlett <liam.howlett@oracle.com>,
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
In-Reply-To: <20210422124849.GA1521@willie-the-truck> (Will Deacon's message
        of "Thu, 22 Apr 2021 13:48:50 +0100")
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
        <20210420165001.3790670-2-Liam.Howlett@Oracle.com>
        <20210422124849.GA1521@willie-the-truck>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Thu, 22 Apr 2021 13:22:04 -0500
Message-ID: <m1v98egoxf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lZdz1-0002QV-Qf;;;mid=<m1v98egoxf.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18OxciQMXgnIAFK7zvjgsqQsTkQAuA57qY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMNoVowels,XMSubLong,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4287]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa08 0; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: ; sa08 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Will Deacon <will@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 774 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 14 (1.8%), b_tie_ro: 12 (1.5%), parse: 0.96
        (0.1%), extract_message_metadata: 4.6 (0.6%), get_uri_detail_list: 2.7
        (0.3%), tests_pri_-1000: 3.8 (0.5%), tests_pri_-950: 1.49 (0.2%),
        tests_pri_-900: 1.17 (0.2%), tests_pri_-90: 314 (40.5%), check_bayes:
        311 (40.2%), b_tokenize: 11 (1.4%), b_tok_get_all: 14 (1.7%),
        b_comp_prob: 3.4 (0.4%), b_tok_touch_all: 277 (35.7%), b_finish: 1.62
        (0.2%), tests_pri_0: 418 (54.0%), check_dkim_signature: 0.78 (0.1%),
        check_dkim_adsp: 3.0 (0.4%), poll_dns_idle: 1.32 (0.2%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 8 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn() sometime returns the wrong signals
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will Deacon <will@kernel.org> writes:

> [+Eric as he actually understands how this is supposed to work]

I try.

> On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
>> arm64_notify_segfault() was used to force a SIGSEGV in all error cases
>> in sigreturn() and rt_sigreturn() to avoid writing a new sig handler.
>> There is now a better sig handler to use which does not search the VMA
>> address space and return a slightly incorrect error code.  Restore the
>> older and correct si_code of SI_KERNEL by using arm64_notify_die().  In
>> the case of !access_ok(), simply return SIGSEGV with si_code
>> SEGV_ACCERR.

What is userspace cares?  Why does it care?

This is changing userspace visible semantics so understanding userspace
and understanding how it might break, and what the risk of regression
seems the most important detail here.

>> This change requires exporting arm64_notfiy_die() to the arm64 traps.h
>> 
>> Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
>> failing to deliver signal)
>> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
>> ---
>>  arch/arm64/include/asm/traps.h |  2 ++
>>  arch/arm64/kernel/signal.c     |  8 ++++++--
>>  arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
>>  3 files changed, 22 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
>> index 54f32a0675df..9b76144fcba6 100644
>> --- a/arch/arm64/include/asm/traps.h
>> +++ b/arch/arm64/include/asm/traps.h
>> @@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
>>  void arm64_force_sig_fault(int signo, int code, unsigned long far, const char *str);
>>  void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const char *str);
>>  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const char *str);
>> +void arm64_notify_die(const char *str, struct pt_regs *regs, int signo,
>> +		      int sicode, unsigned long far, int err);
>>  
>>  /*
>>   * Move regs->pc to next instruction and do necessary setup before it
>> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
>> index 6237486ff6bb..9fde6dc760c3 100644
>> --- a/arch/arm64/kernel/signal.c
>> +++ b/arch/arm64/kernel/signal.c
>> @@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
>>  	frame = (struct rt_sigframe __user *)regs->sp;
>>  
>>  	if (!access_ok(frame, sizeof (*frame)))
>> -		goto badframe;
>> +		goto e_access;
>>  
>>  	if (restore_sigframe(regs, frame))
>>  		goto badframe;
>> @@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
>>  	return regs->regs[0];
>>  
>>  badframe:
>> -	arm64_notify_segfault(regs->sp);
>> +	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp, 0);
>> +	return 0;
>> +
>> +e_access:
>> +	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
>>  	return 0;
>
> This seems really error-prone to me, but maybe I'm just missing some
> context. What's the rule for reporting an si_code of SI_KERNEL vs
> SEGV_ACCERR, and is the former actually valid for SIGSEGV?

The si_codes SI_USER == 0 and SI_KERNEL == 0x80 are valid for all
signals.  SI_KERNEL means I don't have any information for you other
than signal number.

In general something better than SI_KERNEL is desirable.

> With this change, pointing the (signal) stack to a kernel address will
> result in SEGV_ACCERR but pointing it to something like a PROT_NONE user
> address will give SI_KERNEL (well, assuming that we manage to deliver
> the SEGV somehow). I'm having a hard time seeing why that's a useful
> distinction to make..
>
> If it's important to get this a particular way around, please can you
> add some selftests?

Going down the current path I see 3 possible cases:

copy_from_user returns -EFAULT which becomes SEGV_MAPERR or SEGV_ACCERR.

A signal frame parse error.  For which SI_KERNEL seems as good an error
code as any.


On x86 there is no attempt to figure out the cause of the -EFAULT, and
always uses SI_KERNEL.  This is because x86 just does:
"force_sig(SIGSEGV);" As arm64 did until f71016a8a8c5 ("arm64: signal:
Call arm64_notify_segfault when failing to deliver signal")



I think the big question is what does it make sense to do here.

The big picture.  Upon return from a signal the kernel arranges
for rt_sigreturn to be called to return to a pre-signal state.
As such rt_sigreturn can not return an error code.

In general the kernel will write the signal frame and that will
guarantee that the signal from can be processes by rt_sigreturn.

For error handling we are dealing with the case that userspace
has modified the signal frame.  So that it either does not
parse or that it is unmapped.


So who cares?  The only two cases I can think of are debuggers, and
programs playing fancy memory management games like garbage collections.
I have heard of applications (like garbage collectors)
unmapping/mprotecting memory to create a barrier.

Liam Howlett is that the issue here?  Is not seeing SI_KERNEL confusing
the JVM?

For debuggers I expect the stack backtrace from SIGSEGV is enough to see
that something is wrong.

For applications performing fancy processing of the signal frame I think
that tends to be very architecture specific.  In part because even
knowing the faulting address the size of the access is not known so the
instruction must be interpreted.  Getting a system call instead of a
load or store instruction might be enough to completely confuse
applications processing SEGV_MAPERR or SEGV_ACCERR.  Such applications
may also struggle with the fact that the address in siginfo is less
precise than it would be for an ordinary page fault.


So my sense is if you known you are helping userspace returning either
SEGV_MAPERR or SEGV_ACCERR go for it.  Otherwise there are enough
variables that returning less information when rt_sigreturn fails
would be more reliable.


Or in short what is userspace doing?  What does userspace care about?

Eric
