Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDEF369911
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbhDWSSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:18:00 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47648 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbhDWSRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:17:52 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1la0Mc-008m9P-7t; Fri, 23 Apr 2021 12:17:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1la0MZ-003Td1-1s; Fri, 23 Apr 2021 12:17:13 -0600
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
Date:   Fri, 23 Apr 2021 13:17:07 -0500
In-Reply-To: <20210422192349.ekpinkf3wxnmywe3@revolver> (Liam Howlett's
        message of "Thu, 22 Apr 2021 19:24:00 +0000")
Message-ID: <m1y2d8dfx8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1la0MZ-003Td1-1s;;;mid=<m1y2d8dfx8.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/UwPDjsxU9+66isrrncXVLA0O7KRwrPSI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMNoVowels,XMSubLong,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4789]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 0; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
X-Spam-DCC: ; sa03 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Liam Howlett <liam.howlett@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2622 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.5 (0.1%), b_tie_ro: 2.4 (0.1%), parse: 0.91
        (0.0%), extract_message_metadata: 12 (0.5%), get_uri_detail_list: 5
        (0.2%), tests_pri_-1000: 9 (0.3%), tests_pri_-950: 1.03 (0.0%),
        tests_pri_-900: 0.79 (0.0%), tests_pri_-90: 125 (4.8%), check_bayes:
        124 (4.7%), b_tokenize: 16 (0.6%), b_tok_get_all: 15 (0.6%),
        b_comp_prob: 3.4 (0.1%), b_tok_touch_all: 86 (3.3%), b_finish: 0.63
        (0.0%), tests_pri_0: 666 (25.4%), check_dkim_signature: 0.48 (0.0%),
        check_dkim_adsp: 3.1 (0.1%), poll_dns_idle: 1793 (68.4%),
        tests_pri_10: 1.61 (0.1%), tests_pri_500: 1800 (68.6%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH 2/3] arm64: signal: sigreturn() and rt_sigreturn() sometime returns the wrong signals
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liam Howlett <liam.howlett@oracle.com> writes:

> * Eric W. Biederman <ebiederm@xmission.com> [210422 14:23]:
>> Will Deacon <will@kernel.org> writes:
>> 
>> > [+Eric as he actually understands how this is supposed to work]
>> 
>> I try.
>> 
>
> Thanks to both of you for looking at this.
>
>> > On Tue, Apr 20, 2021 at 04:50:13PM +0000, Liam Howlett wrote:
>> >> arm64_notify_segfault() was used to force a SIGSEGV in all error cases
>> >> in sigreturn() and rt_sigreturn() to avoid writing a new sig handler.
>> >> There is now a better sig handler to use which does not search the VMA
>> >> address space and return a slightly incorrect error code.  Restore the
>> >> older and correct si_code of SI_KERNEL by using arm64_notify_die().  In
>> >> the case of !access_ok(), simply return SIGSEGV with si_code
>> >> SEGV_ACCERR.
>> 
>> What is userspace cares?  Why does it care?
>
>
> Calling arm64_notify_segfault() as it is written is unreliable.
> Searching for the address with find_vma() will return SEG_ACCERR almost
> always, unless the address is larger than anything within *any* VMA.
> I'm trying to fix this issue by cleaning up the callers to that function
> and fix the function itself.

I can't see the rest of the patches in your series so I am not quite
certain what you are doing.

Looking at the places that arm64_notify_segfault is called I do
think you are right to be suspicious of that function.

swp_handler seems a legitimate user as it emulates an instruction.
For that case at least you should probably add the necessary
check to see if the address is contained in the returned vma.

user_cache_maint_handler calls it with the tagged address, when
it should use an untagged address with find_vma.  Otherwise
user_cache_maint_handler is also performing instruction emulation
and should work the same as swp_handler.

The only other users are in sigreturn and rt_sigreturn, where the
address is iffy.  But assuming the proper address is passed sigreturn
and rt_sigreturn are also performing instruction emulation.

> I don't have an example of why userspace cares about SI_KERNEL vs
> SEGV_ACCERR/SEGV_MAPERR, but the git log on f71016a8a8c5 specifies that
> this function was used to avoid having specific code to print an error
> code.  I am restoring the old return code as it seems to makes more
> sense and avoids the bug in the calling path.  If you'd rather, I can
> change the notify_die line to use SIG_ACCERR as this is *almost* always
> what is returend - except when the above mentioned bug is hit.  Upon
> examining the code here, it seems unnecessary to walk the VMA tree to
> find where the address lands in either of the error scenarios to know
> what should be returned.

Ignoring the possibility of a parse error what the code has is -EFAULT.
If we want to distinguish between SEGV_ACCERR and SEGV_MAPERR we need
the find_vma (and confirmation that the found vma contains the specified
address) to see if there is a mapping at the specified address.

Or as you point out later this could be a SIGBUS situation.

>> This is changing userspace visible semantics so understanding userspace
>> and understanding how it might break, and what the risk of regression
>> seems the most important detail here.
>> 
>> >> This change requires exporting arm64_notfiy_die() to the arm64 traps.h
>> >> 
>> >> Fixes: f71016a8a8c5 (arm64: signal: Call arm64_notify_segfault when
>> >> failing to deliver signal)
>> >> Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
>> >> ---
>> >>  arch/arm64/include/asm/traps.h |  2 ++
>> >>  arch/arm64/kernel/signal.c     |  8 ++++++--
>> >>  arch/arm64/kernel/signal32.c   | 18 ++++++++++++++----
>> >>  3 files changed, 22 insertions(+), 6 deletions(-)
>> >> 
>> >> diff --git a/arch/arm64/include/asm/traps.h b/arch/arm64/include/asm/traps.h
>> >> index 54f32a0675df..9b76144fcba6 100644
>> >> --- a/arch/arm64/include/asm/traps.h
>> >> +++ b/arch/arm64/include/asm/traps.h
>> >> @@ -29,6 +29,8 @@ void arm64_notify_segfault(unsigned long addr);
>> >>  void arm64_force_sig_fault(int signo, int code, unsigned long far, const char *str);
>> >>  void arm64_force_sig_mceerr(int code, unsigned long far, short lsb, const char *str);
>> >>  void arm64_force_sig_ptrace_errno_trap(int errno, unsigned long far, const char *str);
>> >> +void arm64_notify_die(const char *str, struct pt_regs *regs, int signo,
>> >> +		      int sicode, unsigned long far, int err);
>> >>  
>> >>  /*
>> >>   * Move regs->pc to next instruction and do necessary setup before it
>> >> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
>> >> index 6237486ff6bb..9fde6dc760c3 100644
>> >> --- a/arch/arm64/kernel/signal.c
>> >> +++ b/arch/arm64/kernel/signal.c
>> >> @@ -544,7 +544,7 @@ SYSCALL_DEFINE0(rt_sigreturn)
>> >>  	frame = (struct rt_sigframe __user *)regs->sp;
>> >>  
>> >>  	if (!access_ok(frame, sizeof (*frame)))
>> >> -		goto badframe;
>> >> +		goto e_access;
>> >>  
>> >>  	if (restore_sigframe(regs, frame))
>> >>  		goto badframe;
>> >> @@ -555,7 +555,11 @@ SYSCALL_DEFINE0(rt_sigreturn)
>> >>  	return regs->regs[0];
>> >>  
>> >>  badframe:
>> >> -	arm64_notify_segfault(regs->sp);
>> >> +	arm64_notify_die("Bad frame", regs, SIGSEGV, SI_KERNEL, regs->sp, 0);
>> >> +	return 0;
>> >> +
>> >> +e_access:
>> >> +	force_signal_inject(SIGSEGV, SEGV_ACCERR, regs->sp, 0);
>> >>  	return 0;
>> >
>> > This seems really error-prone to me, but maybe I'm just missing some
>> > context. What's the rule for reporting an si_code of SI_KERNEL vs
>> > SEGV_ACCERR, and is the former actually valid for SIGSEGV?
>> 
>> The si_codes SI_USER == 0 and SI_KERNEL == 0x80 are valid for all
>> signals.  SI_KERNEL means I don't have any information for you other
>> than signal number.
>> 
>> In general something better than SI_KERNEL is desirable.
>
> I went with SI_KERNEL as that's what was there before.  I have no strong
> opinion on what should be returned; I do favour SIGBUS with si_code of
> BUS_ADRALN but I didn't want to change user visable code too much -
> especially to fix a bug in another function.

I hadn't noticed earlier, but I agree that what the code is doing is a
little strange.  I get SIGBUS and SIGEGV confused when I have not looked
at the recently.  I think SIGBUS is for mapped access that fail, and
SIGSEGV is for everything else.  

>> > With this change, pointing the (signal) stack to a kernel address will
>> > result in SEGV_ACCERR but pointing it to something like a PROT_NONE user
>> > address will give SI_KERNEL (well, assuming that we manage to deliver
>> > the SEGV somehow). I'm having a hard time seeing why that's a useful
>> > distinction to make..
>> >
>> > If it's important to get this a particular way around, please can you
>> > add some selftests?
>> 
>> Going down the current path I see 3 possible cases:
>> 
>> copy_from_user returns -EFAULT which becomes SEGV_MAPERR or SEGV_ACCERR.
>
> Almost always SEGV_ACCERR with the current bug, as mentioned above.
> find_vma() searches from addr until the end of the address space, it
> isn't just a simple lookup of the address.

Which is clearly a logic error.

In practice I don't know if anyone cares how sigreturn fails so we are
in a grey area.

>> A signal frame parse error.  For which SI_KERNEL seems as good an error
>> code as any.
>> 
>> 
>> On x86 there is no attempt to figure out the cause of the -EFAULT, and
>> always uses SI_KERNEL.  This is because x86 just does:
>> "force_sig(SIGSEGV);" As arm64 did until f71016a8a8c5 ("arm64: signal:
>> Call arm64_notify_segfault when failing to deliver signal")
>> 
>> 
>> 
>> I think the big question is what does it make sense to do here.
>> 
>> The big picture.  Upon return from a signal the kernel arranges
>> for rt_sigreturn to be called to return to a pre-signal state.
>> As such rt_sigreturn can not return an error code.
>> 
>> In general the kernel will write the signal frame and that will
>> guarantee that the signal from can be processes by rt_sigreturn.
>> 
>> For error handling we are dealing with the case that userspace
>> has modified the signal frame.  So that it either does not
>> parse or that it is unmapped.
>> 
>> 
>> So who cares?  The only two cases I can think of are debuggers, and
>> programs playing fancy memory management games like garbage collections.
>> I have heard of applications (like garbage collectors)
>> unmapping/mprotecting memory to create a barrier.
>> 
>> Liam Howlett is that the issue here?  Is not seeing SI_KERNEL confusing
>> the JVM?
>
> No, the issue here is that arm64_notify_segfault() has a bug which sent
> me down a rabbit hole of issues and I'm really trying my best to help
> out as best I can.  The bug certainly affects this function as it is
> written today, but my patch will generate a consistent signal.

Not so much.  There are other cases where -EFAULT causing a failing
return in that function.  So I think you have in practice made the
matter worse.  As after this patch it becomes less clear what the
return code is.

>> For debuggers I expect the stack backtrace from SIGSEGV is enough to see
>> that something is wrong.
>> 
>> For applications performing fancy processing of the signal frame I think
>> that tends to be very architecture specific.  In part because even
>> knowing the faulting address the size of the access is not known so the
>> instruction must be interpreted.  Getting a system call instead of a
>> load or store instruction might be enough to completely confuse
>> applications processing SEGV_MAPERR or SEGV_ACCERR.  Such applications
>> may also struggle with the fact that the address in siginfo is less
>> precise than it would be for an ordinary page fault.
>> 
>> 
>> So my sense is if you known you are helping userspace returning either
>> SEGV_MAPERR or SEGV_ACCERR go for it.  Otherwise there are enough
>> variables that returning less information when rt_sigreturn fails
>> would be more reliable.
>> 
>> 
>> Or in short what is userspace doing?  What does userspace care about?
>
> I think I've answered this, but it's more of trying to fix a bug which
> causes an *almost* reliable return code to be a reliable return code.
> Am I correct in stating that in both of these scnarios - !access_ok()
> and badframe, it is unnecessary to search the VMAs for where the address
> falls to know what error code to return?

You have answered you don't know what piece of userspace cares.

For access_ok failure you are correct we don't need a find_vma call
to tell what kind of failure we have.

For anything return -EFAULT we don't know as -EFAULT has less precision
than the instruction itself.

My sense is that you should concentrate on the userspace instruction
emulation case from swp_handler or user_cache_maint_handler.  Because
those instructions can run unemulated we know exactly what the semantics
should be in those cases.

I suspect arm64_notify_segfault should be renamed arm64_notify_fault
and generate SIGBUS or SIGSEGV as appropriate.

In fact I suspect that proper handling is to call __do_page_fault or
handle_mm_fault as do_page_fault does and then parse the VM_FAULT code
for which signal to generate.   Possibly factoring out a helper
converting VM_FAULT codes to signals.

Eric

