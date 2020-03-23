Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39B571900A0
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCWVrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:47:02 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:15815 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgCWVrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 17:47:00 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1585000019; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: Date: Subject: In-Reply-To: References: Cc:
 To: From: Reply-To: Sender;
 bh=ZNpFv8n1vyNtNLXdZYwI5uo1FnppFNp10NWp9MPwYDo=; b=NeHpgcXQfwbH86gyHu9zmd4GlGP4Nzsikg9H7xzQmLZ+lMM+YhGciPy5DMaPQK5KYNjU90ru
 5hn/bheXlSYL1FLLJKKmp8bK7aq4sEYbOZWhO2fhExfj5ALtI/V8oD51mjtPowMgbhcS0YVW
 rNdO8unC4h4PE/U1sSlEF9MVOhE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e792e33.7f2b61a663b0-smtp-out-n02;
 Mon, 23 Mar 2020 21:46:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 31ABCC44798; Mon, 23 Mar 2020 21:46:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from BCAIN (104-54-226-75.lightspeed.austtx.sbcglobal.net [104.54.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bcain)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0630CC433CB;
        Mon, 23 Mar 2020 21:46:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0630CC433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=bcain@codeaurora.org
Reply-To: <bcain@codeaurora.org>
From:   "Brian Cain" <bcain@codeaurora.org>
To:     "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc:     "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Sebastian Siewior'" <bigeasy@linutronix.de>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Joel Fernandes'" <joel@joelfernandes.org>,
        "'Oleg Nesterov'" <oleg@redhat.com>,
        "'Davidlohr Bueso'" <dave@stgolabs.net>,
        "'kbuild test robot'" <lkp@intel.com>,
        <linux-hexagon@vger.kernel.org>,
        "'Logan Gunthorpe'" <logang@deltatee.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Kurt Schwemmer'" <kurt.schwemmer@microsemi.com>,
        <linux-pci@vger.kernel.org>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Felipe Balbi'" <balbi@kernel.org>, <linux-usb@vger.kernel.org>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        "'Darren Hart'" <dvhart@infradead.org>,
        "'Andy Shevchenko'" <andy@infradead.org>,
        <platform-driver-x86@vger.kernel.org>,
        "'Zhang Rui'" <rui.zhang@intel.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        <linux-pm@vger.kernel.org>, "'Len Brown'" <lenb@kernel.org>,
        <linux-acpi@vger.kernel.org>, "'Nick Hu'" <nickhu@andestech.com>,
        "'Greentime Hu'" <green.hu@gmail.com>,
        "'Vincent Chen'" <deanbo422@gmail.com>,
        "'Guo Ren'" <guoren@kernel.org>, <linux-csky@vger.kernel.org>,
        "'Tony Luck'" <tony.luck@intel.com>,
        "'Fenghua Yu'" <fenghua.yu@intel.com>,
        <linux-ia64@vger.kernel.org>, "'Michal Simek'" <monstr@monstr.eu>,
        "'Michael Ellerman'" <mpe@ellerman.id.au>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Geoff Levand'" <geoff@infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "'Paul E . McKenney'" <paulmck@kernel.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        "'Randy Dunlap'" <rdunlap@infradead.org>,
        "'Davidlohr Bueso'" <dbueso@suse.de>
References: <20200321112544.878032781@linutronix.de> <20200321113241.531525286@linutronix.de>
In-Reply-To: <20200321113241.531525286@linutronix.de>
Subject: RE: [patch V3 08/20] hexagon: Remove mm.h from asm/uaccess.h
Date:   Mon, 23 Mar 2020 16:46:17 -0500
Message-ID: <0cc301d6015c$7e756490$7b602db0$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-us
Thread-Index: AQHqwg4Cse+u7XkWseF638AEhQYwggGRIliZqCCrVyA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Thomas Gleixner <tglx@linutronix.de>
...
> Subject: [patch V3 08/20] hexagon: Remove mm.h from asm/uaccess.h
> 
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The defconfig compiles without linux/mm.h. With mm.h included the include
> chain leands to:
> |   CC      kernel/locking/percpu-rwsem.o
> | In file included from include/linux/huge_mm.h:8,
> |                  from include/linux/mm.h:567,
> |                  from arch/hexagon/include/asm/uaccess.h:,
> |                  from include/linux/uaccess.h:11,
> |                  from include/linux/sched/task.h:11,
> |                  from include/linux/sched/signal.h:9,
> |                  from include/linux/rcuwait.h:6,
> |                  from include/linux/percpu-rwsem.h:8,
> |                  from kernel/locking/percpu-rwsem.c:6:
> | include/linux/fs.h:1422:29: error: array type has incomplete element type
> 'struct percpu_rw_semaphore'
> |  1422 |  struct percpu_rw_semaphore rw_sem[SB_FREEZE_LEVELS];
> 
> once rcuwait.h includes linux/sched/signal.h.
> 
> Remove the linux/mm.h include.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Brian Cain <bcain@codeaurora.org>
> Cc: linux-hexagon@vger.kernel.org
> ---
> V3: New patch
> ---
>  arch/hexagon/include/asm/uaccess.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/hexagon/include/asm/uaccess.h
> b/arch/hexagon/include/asm/uaccess.h
> index 00cb38faad0c4..c1019a736ff13 100644
> --- a/arch/hexagon/include/asm/uaccess.h
> +++ b/arch/hexagon/include/asm/uaccess.h
> @@ -10,7 +10,6 @@
>  /*
>   * User space memory access functions
>   */
> -#include <linux/mm.h>
>  #include <asm/sections.h>
> 
>  /*
> --
> 2.26.0.rc2
> 

Acked-by: Brian Cain <bcain@codeaurora.org>
