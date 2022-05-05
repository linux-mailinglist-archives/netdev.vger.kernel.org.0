Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D60B51C88D
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 20:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384764AbiEETB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 15:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343580AbiEETBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 15:01:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7CD3633C;
        Thu,  5 May 2022 11:57:41 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245IsCDC021810;
        Thu, 5 May 2022 18:56:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=XNUaK5MXNumQ2GC419CM2tT56hGe0D54FACFQZzubag=;
 b=gSD1byPqJD9U14RM7yqXNGjhCvGv5EceJcS49ikn+rpVMYCw5l/cE2/RfhpfxgDrdFXF
 bkw+3uP6vU/C7MIPvjf+1/BQcDGTmd58m1jCKBcC75Xc3IwagCsVfPCOPegq8b4MZ3p/
 mQN9mkPuV1Btua3UKzIpudLBdtJkA5WoYucCFThdzTDSpYwo6Nc6tDpcKD+hvfEHi+OM
 CWja8vfEeVW5JzydzGv1uvP94K0n/yjRgwV8RQXFJagBheg9E5Imh/dRMjKSs9LZirwJ
 /CWejco2WiCA9LRB8XRjw7cjAD2OqALQniaNM+6CBO4ZnFoxNe9gtVMrz4B16UghR6hV VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvm92012c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 18:56:22 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 245IuAu6029325;
        Thu, 5 May 2022 18:56:21 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fvm92011f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 18:56:21 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 245IbA58012918;
        Thu, 5 May 2022 18:55:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3ftp7fvexe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 18:55:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 245ItaGm14352888
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 May 2022 18:55:36 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B81D11C05B;
        Thu,  5 May 2022 18:55:36 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6820611C04C;
        Thu,  5 May 2022 18:55:10 +0000 (GMT)
Received: from [9.211.36.212] (unknown [9.211.36.212])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  5 May 2022 18:55:10 +0000 (GMT)
Message-ID: <3c34d8e2-6f84-933f-a4ed-338cd300d6b0@linux.ibm.com>
Date:   Fri, 6 May 2022 00:25:08 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 08/30] powerpc/setup: Refactor/untangle panic notifiers
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-9-gpiccoli@igalia.com>
From:   Hari Bathini <hbathini@linux.ibm.com>
In-Reply-To: <20220427224924.592546-9-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FmL43udCg7zOaYTyNU5fYcYIiC3L3tsY
X-Proofpoint-ORIG-GUID: op15TFwB187r4kWWn80Xf8P42QMt9UB1
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_08,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205050125
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/04/22 4:19 am, Guilherme G. Piccoli wrote:
> The panic notifiers infrastructure is a bit limited in the scope of
> the callbacks - basically every kind of functionality is dropped
> in a list that runs in the same point during the kernel panic path.
> This is not really on par with the complexities and particularities
> of architecture / hypervisors' needs, and a refactor is ongoing.
> 
> As part of this refactor, it was observed that powerpc has 2 notifiers,
> with mixed goals: one is just a KASLR offset dumper, whereas the other
> aims to hard-disable IRQs (necessary on panic path), warn firmware of
> the panic event (fadump) and run low-level platform-specific machinery
> that might stop kernel execution and never come back.
> 
> Clearly, the 2nd notifier has opposed goals: disable IRQs / fadump
> should run earlier while low-level platform actions should
> run late since it might not even return. Hence, this patch decouples
> the notifiers splitting them in three:
> 
> - First one is responsible for hard-disable IRQs and fadump,
> should run early;
> 
> - The kernel KASLR offset dumper is really an informative notifier,
> harmless and may run at any moment in the panic path;
> 
> - The last notifier should run last, since it aims to perform
> low-level actions for specific platforms, and might never return.
> It is also only registered for 2 platforms, pseries and ps3.
> 
> The patch better documents the notifiers and clears the code too,
> also removing a useless header.
> 
> Currently no functionality change should be observed, but after
> the planned panic refactor we should expect more panic reliability
> with this patch.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Hari Bathini <hbathini@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

The change looks good. I have tested it on an LPAR (ppc64).

Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>

> ---
> 
> We'd like to thanks specially the MiniCloud infrastructure [0] maintainers,
> that allow us to test PowerPC code in a very complete, functional and FREE
> environment (there's no need even for adding a credit card, like many "free"
> clouds require ¬¬ ).
> 
> [0] https://openpower.ic.unicamp.br/minicloud
> 
>   arch/powerpc/kernel/setup-common.c | 74 ++++++++++++++++++++++--------
>   1 file changed, 54 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index 518ae5aa9410..52f96b209a96 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -23,7 +23,6 @@
>   #include <linux/console.h>
>   #include <linux/screen_info.h>
>   #include <linux/root_dev.h>
> -#include <linux/notifier.h>
>   #include <linux/cpu.h>
>   #include <linux/unistd.h>
>   #include <linux/serial.h>
> @@ -680,8 +679,25 @@ int check_legacy_ioport(unsigned long base_port)
>   }
>   EXPORT_SYMBOL(check_legacy_ioport);
>   
> -static int ppc_panic_event(struct notifier_block *this,
> -                             unsigned long event, void *ptr)
> +/*
> + * Panic notifiers setup
> + *
> + * We have 3 notifiers for powerpc, each one from a different "nature":
> + *
> + * - ppc_panic_fadump_handler() is a hypervisor notifier, which hard-disables
> + *   IRQs and deal with the Firmware-Assisted dump, when it is configured;
> + *   should run early in the panic path.
> + *
> + * - dump_kernel_offset() is an informative notifier, just showing the KASLR
> + *   offset if we have RANDOMIZE_BASE set.
> + *
> + * - ppc_panic_platform_handler() is a low-level handler that's registered
> + *   only if the platform wishes to perform final actions in the panic path,
> + *   hence it should run late and might not even return. Currently, only
> + *   pseries and ps3 platforms register callbacks.
> + */
> +static int ppc_panic_fadump_handler(struct notifier_block *this,
> +				    unsigned long event, void *ptr)
>   {
>   	/*
>   	 * panic does a local_irq_disable, but we really
> @@ -691,45 +707,63 @@ static int ppc_panic_event(struct notifier_block *this,
>   
>   	/*
>   	 * If firmware-assisted dump has been registered then trigger
> -	 * firmware-assisted dump and let firmware handle everything else.
> +	 * its callback and let the firmware handles everything else.
>   	 */
>   	crash_fadump(NULL, ptr);
> -	if (ppc_md.panic)
> -		ppc_md.panic(ptr);  /* May not return */
> +
>   	return NOTIFY_DONE;
>   }
>   
> -static struct notifier_block ppc_panic_block = {
> -	.notifier_call = ppc_panic_event,
> -	.priority = INT_MIN /* may not return; must be done last */
> -};
> -
> -/*
> - * Dump out kernel offset information on panic.
> - */
>   static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
>   			      void *p)
>   {
>   	pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
>   		 kaslr_offset(), KERNELBASE);
>   
> -	return 0;
> +	return NOTIFY_DONE;
>   }
>   
> +static int ppc_panic_platform_handler(struct notifier_block *this,
> +				      unsigned long event, void *ptr)
> +{
> +	/*
> +	 * This handler is only registered if we have a panic callback
> +	 * on ppc_md, hence NULL check is not needed.
> +	 * Also, it may not return, so it runs really late on panic path.
> +	 */
> +	ppc_md.panic(ptr);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block ppc_fadump_block = {
> +	.notifier_call = ppc_panic_fadump_handler,
> +	.priority = INT_MAX, /* run early, to notify the firmware ASAP */
> +};
> +
>   static struct notifier_block kernel_offset_notifier = {
> -	.notifier_call = dump_kernel_offset
> +	.notifier_call = dump_kernel_offset,
> +};
> +
> +static struct notifier_block ppc_panic_block = {
> +	.notifier_call = ppc_panic_platform_handler,
> +	.priority = INT_MIN, /* may not return; must be done last */
>   };
>   
>   void __init setup_panic(void)
>   {
> +	/* Hard-disables IRQs + deal with FW-assisted dump (fadump) */
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &ppc_fadump_block);
> +
>   	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
>   		atomic_notifier_chain_register(&panic_notifier_list,
>   					       &kernel_offset_notifier);
>   
> -	/* PPC64 always does a hard irq disable in its panic handler */
> -	if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
> -		return;
> -	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);
> +	/* Low-level platform-specific routines that should run on panic */
> +	if (ppc_md.panic)
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +					       &ppc_panic_block);
>   }
>   
>   #ifdef CONFIG_CHECK_CACHE_COHERENCY
