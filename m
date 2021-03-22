Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EA034523C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 23:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCVWIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 18:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhCVWH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 18:07:56 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B1C061574;
        Mon, 22 Mar 2021 15:07:56 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id y2so11138275qtw.13;
        Mon, 22 Mar 2021 15:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bp6cadiLp9JG4ot8VD8DrNUhLvtl3tOiutuJ7QXWznQ=;
        b=iaV83Ux9xBDgj/qom3Bk+Pnnd+Npq2g7l2Wcj4hhm0C9/Wqa5sWw8p1Jsa6IVtm0yS
         TdIiUfQGXTD6NiCLV6NBiRXyZP2uVw+Q2q6lU7LXwrWQJ/Maefvj0xV0Uec18FcSeRXF
         vIJU9u5du1ZOWFtkZrF5/qMHCMqhC93pFGIqrrKl6XUhkAUrPxcx4X0Batpu84izU0rl
         6nUs9IEvPSvLgj3W8ej7UliIwlqDMHRm/QB8uQcgZsL5UpAnoTMEMr+Ed2fl6upuTDTk
         ++B/wzn6EYS99xzPoQfKZFL2om7c/ZVOPmZEz09Ms8KU+NvgtrohB8esdB1kDZFPOvri
         10Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bp6cadiLp9JG4ot8VD8DrNUhLvtl3tOiutuJ7QXWznQ=;
        b=jddVdzHLZz2NLlLHjp0TkxvOdobYmwIcsRfDz43S9CFMgwI6TEXRlThUYBHL7DFV9b
         gOa92HNWwoDSRkqVYVlI0BKYvme8oTkIYrywMDwuDEZD+f7Nd+SgW2vMFPU2Y/ZgHGv9
         8DcdPpLuvX/4QwJl/eheuOGhYjNqzD2KIPddxqKjxkXpojo3sx2MHAgXKHfAG5vdvl8q
         gTh26lkjlS21BE/MxMOOpXmg3Fw12LsMjuu0FL9RGMZVLHpGJHK3OaCn/Oneo5TDlA81
         SjFtjZKeXFt6gGKSdluw9RxLjVHv07zCPIOjWOd5byuVg2idPbZfrSZyASsQBeOVZ8wh
         qFNg==
X-Gm-Message-State: AOAM531+E1ZFq+tytPnVB1oAQCFhOqNCBR3sw/ZixFYdAtr+N7KAvVtF
        mtiROIlC6hZ3TDVxxsn0+RE=
X-Google-Smtp-Source: ABdhPJw2Q59a1ZLYugiGOh0k53LBnL3VNySQVKoaoySDrE/bFUhGmQDuP132X+ofXKkmUC96EG1Wbg==
X-Received: by 2002:ac8:5281:: with SMTP id s1mr1870981qtn.293.1616450875002;
        Mon, 22 Mar 2021 15:07:55 -0700 (PDT)
Received: from [192.168.0.41] (71-218-23-248.hlrn.qwest.net. [71.218.23.248])
        by smtp.gmail.com with ESMTPSA id y19sm12052651qky.111.2021.03.22.15.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 15:07:54 -0700 (PDT)
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
To:     Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Ning Sun <ning.sun@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
From:   Martin Sebor <msebor@gmail.com>
Message-ID: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Date:   Mon, 22 Mar 2021 16:07:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20210322202958.GA1955909@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 2:29 PM, Ingo Molnar wrote:
> 
> * Arnd Bergmann <arnd@kernel.org> wrote:
> 
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> gcc-11 warns about using string operations on pointers that are
>> defined at compile time as offsets from a NULL pointer. Unfortunately
>> that also happens on the result of fix_to_virt(), which is a
>> compile-time constant for a constantn input:
>>
>> arch/x86/kernel/tboot.c: In function 'tboot_probe':
>> arch/x86/kernel/tboot.c:70:13: error: '__builtin_memcmp_eq' specified bound 16 exceeds source size 0 [-Werror=stringop-overread]
>>     70 |         if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>>        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> I hope this can get addressed in gcc-11 before the release.
>>
>> As a workaround, split up the tboot_probe() function in two halves
>> to separate the pointer generation from the usage. This is a bit
>> ugly, and hopefully gcc understands that the code is actually correct
>> before it learns to peek into the noinline function.
>>
>> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>   arch/x86/kernel/tboot.c | 44 ++++++++++++++++++++++++-----------------
>>   1 file changed, 26 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
>> index 4c09ba110204..f9af561c3cd4 100644
>> --- a/arch/x86/kernel/tboot.c
>> +++ b/arch/x86/kernel/tboot.c
>> @@ -49,6 +49,30 @@ bool tboot_enabled(void)
>>   	return tboot != NULL;
>>   }
>>   
>> +/* noinline to prevent gcc from warning about dereferencing constant fixaddr */
>> +static noinline __init bool check_tboot_version(void)
>> +{
>> +	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>> +		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
>> +		return false;
>> +	}
>> +
>> +	if (tboot->version < 5) {
>> +		pr_warn("tboot version is invalid: %u\n", tboot->version);
>> +		return false;
>> +	}
>> +
>> +	pr_info("found shared page at phys addr 0x%llx:\n",
>> +		boot_params.tboot_addr);
>> +	pr_debug("version: %d\n", tboot->version);
>> +	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
>> +	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>> +	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>> +	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
>> +
>> +	return true;
>> +}
>> +
>>   void __init tboot_probe(void)
>>   {
>>   	/* Look for valid page-aligned address for shared page. */
>> @@ -66,25 +90,9 @@ void __init tboot_probe(void)
>>   
>>   	/* Map and check for tboot UUID. */
>>   	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
>> -	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
>> -	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>> -		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
>> +	tboot = (void *)fix_to_virt(FIX_TBOOT_BASE);
>> +	if (!check_tboot_version())
>>   		tboot = NULL;
>> -		return;
>> -	}
>> -	if (tboot->version < 5) {
>> -		pr_warn("tboot version is invalid: %u\n", tboot->version);
>> -		tboot = NULL;
>> -		return;
>> -	}
>> -
>> -	pr_info("found shared page at phys addr 0x%llx:\n",
>> -		boot_params.tboot_addr);
>> -	pr_debug("version: %d\n", tboot->version);
>> -	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
>> -	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
>> -	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
>> -	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> 
> This is indeed rather ugly - and the other patch that removes a debug
> check seems counterproductive as well.
> 
> Do we know how many genuine bugs -Wstringop-overread-warning has
> caught or is about to catch?
> 
> I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> until GCC-11 gets fixed?

In GCC 10 -Wstringop-overread is a subset of -Wstringop-overflow.
GCC 11 breaks it out as a separate warning to make it easier to
control.  Both warnings have caught some real bugs but they both
have a nonzero rate of false positives.  Other than bug reports
we don't have enough data to say what their S/N ratio might be
but my sense is that it's fairly high in general.

   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overread
   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overflow

In GCC 11, all access warnings expect objects to be either declared
or allocated.  Pointers with constant values are taken to point to
nothing valid (as Arnd mentioned above, this is to detect invalid
accesses to members of structs at address zero).

One possible solution to the known address problem is to extend GCC
attributes address and io that pin an object to a hardwired address
to all targets (at the moment they're supported on just one or two
targets).  I'm not sure this can still happen before GCC 11 releases
sometime in April or May.

Until then, another workaround is to convert the fixed address to
a volatile pointer before using it for the access, along the lines
below.  It should have only a negligible effect on efficiency.

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 4c09ba110204..76326b906010 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -67,7 +67,9 @@ void __init tboot_probe(void)
         /* Map and check for tboot UUID. */
         set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
         tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
-       if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
+       if (memcmp(&tboot_uuid,
+                  (*(struct tboot* volatile *)(&tboot))->uuid,
+                  sizeof(tboot->uuid))) {
                 pr_warn("tboot at 0x%llx is invalid\n", 
boot_params.tboot_addr);
                 tboot = NULL;
                 return;

Martin

> 
> Thanks,
> 
> 	Ingo
> 

