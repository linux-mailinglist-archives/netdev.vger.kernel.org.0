Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3646C5FFCBA
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 02:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiJPA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 20:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJPA0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 20:26:39 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D672E9FB
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 17:26:38 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 29G0OvVm073141;
        Sun, 16 Oct 2022 09:24:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sun, 16 Oct 2022 09:24:57 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 29G0Ouh1073132
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 16 Oct 2022 09:24:57 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <23488f06-c4b4-8bd8-b0bc-85914ba4d1c6@I-love.SAKURA.ne.jp>
Date:   Sun, 16 Oct 2022 09:24:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [syzbot] WARNING in c_start
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     syzbot <syzbot+d0fd2bf0dd6da72496dd@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com,
        Andrew Jones <ajones@ventanamicro.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        caraitto@google.com, willemb@google.com, jonolson@google.com,
        amritha.nambiar@intel.com, linux-kernel@vger.kernel.org
References: <0000000000007647ec05eb05249c@google.com>
 <Y0nTd9HSnnt/KDap@zn.tnic>
 <2eaf1386-8ab0-bd65-acee-e29f1c5a6623@I-love.SAKURA.ne.jp>
 <Y0qfLyhSoTodAdxu@zn.tnic> <Y0sbwpRcipI564yp@yury-laptop>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <Y0sbwpRcipI564yp@yury-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/16 5:44, Yury Norov wrote:
> Add people from other threads discussing this.
> 
> On Sat, Oct 15, 2022 at 01:53:19PM +0200, Borislav Petkov wrote:
>> On Sat, Oct 15, 2022 at 08:39:19PM +0900, Tetsuo Handa wrote:
>>> That's an invalid command line. The correct syntax is:
>>>
>>> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>
>> The fix is not in Linus' tree yet.
>>
>>> Andrew Jones proposed a fix for x86 and riscv architectures [2]. But
>>> other architectures have the same problem. And fixing all callers will
>>> not be in time for this merge window.
>>
>> Why won't there be time? That's why the -rcs are for.
>>
>> Also, that thing fires only when CONFIG_DEBUG_PER_CPU_MAPS is enabled.
>>
>> So no, we will take Andrew's fixes for all arches in time for 6.1.
> 
> Summarizing things:
> 
> 1. cpumask_check() was introduced to make sure that the cpu number
> passed into cpumask API belongs to a valid range. But the check is
> broken for a very long time. And because of that there are a lot of
> places where cpumask API is used wrongly.
> 
> 2. Underlying bitmap functions handle that correctly - when user
> passes out-of-range CPU index, the nr_cpu_ids is returned, and this is
> what expected by client code. So if DEBUG_PER_CPU_MAPS config is off,
> everything is working smoothly.
> 
> 3. I fixed all warnings that I was aware at the time of submitting the
> patch. 2 follow-up series are on review: "[PATCH v2 0/4] net: drop
> netif_attrmask_next*()" and "[PATCH 0/9] lib/cpumask: simplify
> cpumask_next_wrap()". Also, Andrew Jones, Alexander Gordeev and Guo Ren
> proposed fixes for c_start() in arch code.
> 
> 4. The code paths mentioned above are all known to me that violate
> cpumask_check() rules. (Did I miss something?)
> 
> With all that, I agree with Borislav. Unfortunately, syzcall didn't CC
> me about this problem with c_start(). But I don't like the idea to revert
> cpumask_check() fix. This way we'll never clean that mess. 
> 
> If for some reason those warnings are unacceptable for -rcs (and like
> Boris, I don't understand why), than instead of reverting commits, I'd
> suggest moving cpumask sanity check from DEBUG_PER_CPU_MAPS under a new
> config, say CONFIG_CPUMASK_DEBUG, which will be inactive until people will
> fix their code. I can send a patch shortly, if we'll decide going this way.
> 
> How people would even realize that they're doing something wrong if
> they will not get warned about it?

I'm asking you not to use BUG_ON()/WARN_ON() etc. which breaks syzkaller.
Just printing messages (without "BUG:"/"WARNING:" string which also breaks
syzkaller) like below diff is sufficient for people to realize that they're
doing something wrong.

Again, please do revert "cpumask: fix checking valid cpu range" immediately.

 include/linux/cpumask.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c2aa0aa26b45..31af2cc5f0c2 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -118,6 +118,18 @@ static __always_inline unsigned int cpumask_check(unsigned int cpu)
 	return cpu;
 }
 
+/*
+ * We want to avoid passing -1 as a valid cpu argument.
+ * But we should not crash the kernel until all in-tree callers are fixed.
+ */
+static __always_inline void report_negative_cpuid(void)
+{
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	pr_warn_once("FIXME: Passing -1 as CPU argument needs to be avoided.\n");
+	DO_ONCE_LITE(dump_stack);
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+}
+
 /**
  * cpumask_first - get the first cpu in a cpumask
  * @srcp: the cpumask pointer
@@ -177,6 +189,8 @@ unsigned int cpumask_next(int n, const struct cpumask *srcp)
 	/* -1 is a legal arg here. */
 	if (n != -1)
 		cpumask_check(n);
+	else
+		report_negative_cpuid();
 	return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
 }
 
@@ -192,6 +206,8 @@ static inline unsigned int cpumask_next_zero(int n, const struct cpumask *srcp)
 	/* -1 is a legal arg here. */
 	if (n != -1)
 		cpumask_check(n);
+	else
+		report_negative_cpuid();
 	return find_next_zero_bit(cpumask_bits(srcp), nr_cpumask_bits, n+1);
 }
 
@@ -234,6 +250,8 @@ unsigned int cpumask_next_and(int n, const struct cpumask *src1p,
 	/* -1 is a legal arg here. */
 	if (n != -1)
 		cpumask_check(n);
+	else
+		report_negative_cpuid();
 	return find_next_and_bit(cpumask_bits(src1p), cpumask_bits(src2p),
 		nr_cpumask_bits, n + 1);
 }
@@ -265,6 +283,8 @@ unsigned int cpumask_next_wrap(int n, const struct cpumask *mask, int start, boo
 	cpumask_check(start);
 	if (n != -1)
 		cpumask_check(n);
+	else
+		report_negative_cpuid();
 
 	/*
 	 * Return the first available CPU when wrapping, or when starting before cpu0,
-- 
2.18.4

> 
> Thanks,
> Yury

