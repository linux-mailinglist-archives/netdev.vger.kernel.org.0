Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426B83450C9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhCVUaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhCVUaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:30:03 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B7DC061574;
        Mon, 22 Mar 2021 13:30:03 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id j3so20927381edp.11;
        Mon, 22 Mar 2021 13:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7QH2qH8OXw7astC9J+hBZNIvd5jFa6HOZzbSlRf+8Ek=;
        b=T8MfESZQxe3NObZ/7MqvvJi28NxxdFf3ab07gERPhzLT804c2DkkhJkBMdizuiX7N5
         CHF46uFWWZ0cEHLJOYnXTiyTVv5tLvjO1lmS5Ohg2XPP88nZmWW9F5ARG6cD601rZ5/K
         zoiBTqPm5H0nLHbAPcra7yZ3RbLdPm8oZKbWma9nQPHRlRk5CMs6B2AjWWGtpKPrvkGd
         rL5fFWVmWmq+K/IWUKd2YrrT8XNdUQvFpqJ+tfEUQNjkhvUoBFoAG9jEiozLdABWs7F1
         P6ZC1gmMny9VZsWnwgXXF/Dsydybb92YeAKNqz04oOvYAWJ3XKyrs6O1pidMSVkxvnmE
         iM1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7QH2qH8OXw7astC9J+hBZNIvd5jFa6HOZzbSlRf+8Ek=;
        b=leNPY43U+GP3bVKZwkB+lJg2KyM9KE3J2BFaL8GyBbtK5FxkdvSf+O+fr0RWMe3JBd
         J7pP+6GAbA+ttwYqzvfe5+RYYtWD1pM01ZARcqk0btY2WCJiNCPFuC0laaXjjVFH09Py
         ubBTXmpqEEOMZ8KePXTQTSV3vAyBWlsigmNBoEOHhkFE2B8OFPKIE4dl6iUCSj8A8foG
         G1eG3/aJkkn+TJlbpoZssdMKGsnjJcJTlO9zI2eELfmnhvJdvsKnaXzdbDm3d630n6/T
         WldJsHY4wqV54f6O95BiFajQOa6pNIMMhqwGcg2vfF+wP8w/6cJxlS00s9lFIe/Eigpc
         0hQQ==
X-Gm-Message-State: AOAM532Pysb8L0q7VJmQYDTpgC9fAhOi7Ab3X/7FI4p5/vspOoI7oA7t
        8M2UPdz24vWHYaXoLgOFcP4=
X-Google-Smtp-Source: ABdhPJwU1mWLXQUCBk/cr2I4/KV5sNA0QBX6NdJBSPel6aICLgwoK3n4c4u3DzEAz75RN+WAzRwu0Q==
X-Received: by 2002:aa7:c447:: with SMTP id n7mr1365222edr.171.1616445001869;
        Mon, 22 Mar 2021 13:30:01 -0700 (PDT)
Received: from gmail.com (54033286.catv.pool.telekom.hu. [84.3.50.134])
        by smtp.gmail.com with ESMTPSA id x1sm10321496eji.8.2021.03.22.13.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 13:30:01 -0700 (PDT)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Mon, 22 Mar 2021 21:29:58 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
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
Subject: Re: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Message-ID: <20210322202958.GA1955909@gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322160253.4032422-3-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


* Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-11 warns about using string operations on pointers that are
> defined at compile time as offsets from a NULL pointer. Unfortunately
> that also happens on the result of fix_to_virt(), which is a
> compile-time constant for a constantn input:
> 
> arch/x86/kernel/tboot.c: In function 'tboot_probe':
> arch/x86/kernel/tboot.c:70:13: error: '__builtin_memcmp_eq' specified bound 16 exceeds source size 0 [-Werror=stringop-overread]
>    70 |         if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> I hope this can get addressed in gcc-11 before the release.
> 
> As a workaround, split up the tboot_probe() function in two halves
> to separate the pointer generation from the usage. This is a bit
> ugly, and hopefully gcc understands that the code is actually correct
> before it learns to peek into the noinline function.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/x86/kernel/tboot.c | 44 ++++++++++++++++++++++++-----------------
>  1 file changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
> index 4c09ba110204..f9af561c3cd4 100644
> --- a/arch/x86/kernel/tboot.c
> +++ b/arch/x86/kernel/tboot.c
> @@ -49,6 +49,30 @@ bool tboot_enabled(void)
>  	return tboot != NULL;
>  }
>  
> +/* noinline to prevent gcc from warning about dereferencing constant fixaddr */
> +static noinline __init bool check_tboot_version(void)
> +{
> +	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
> +		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
> +		return false;
> +	}
> +
> +	if (tboot->version < 5) {
> +		pr_warn("tboot version is invalid: %u\n", tboot->version);
> +		return false;
> +	}
> +
> +	pr_info("found shared page at phys addr 0x%llx:\n",
> +		boot_params.tboot_addr);
> +	pr_debug("version: %d\n", tboot->version);
> +	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
> +	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
> +	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
> +	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);
> +
> +	return true;
> +}
> +
>  void __init tboot_probe(void)
>  {
>  	/* Look for valid page-aligned address for shared page. */
> @@ -66,25 +90,9 @@ void __init tboot_probe(void)
>  
>  	/* Map and check for tboot UUID. */
>  	set_fixmap(FIX_TBOOT_BASE, boot_params.tboot_addr);
> -	tboot = (struct tboot *)fix_to_virt(FIX_TBOOT_BASE);
> -	if (memcmp(&tboot_uuid, &tboot->uuid, sizeof(tboot->uuid))) {
> -		pr_warn("tboot at 0x%llx is invalid\n", boot_params.tboot_addr);
> +	tboot = (void *)fix_to_virt(FIX_TBOOT_BASE);
> +	if (!check_tboot_version())
>  		tboot = NULL;
> -		return;
> -	}
> -	if (tboot->version < 5) {
> -		pr_warn("tboot version is invalid: %u\n", tboot->version);
> -		tboot = NULL;
> -		return;
> -	}
> -
> -	pr_info("found shared page at phys addr 0x%llx:\n",
> -		boot_params.tboot_addr);
> -	pr_debug("version: %d\n", tboot->version);
> -	pr_debug("log_addr: 0x%08x\n", tboot->log_addr);
> -	pr_debug("shutdown_entry: 0x%x\n", tboot->shutdown_entry);
> -	pr_debug("tboot_base: 0x%08x\n", tboot->tboot_base);
> -	pr_debug("tboot_size: 0x%x\n", tboot->tboot_size);

This is indeed rather ugly - and the other patch that removes a debug 
check seems counterproductive as well.

Do we know how many genuine bugs -Wstringop-overread-warning has 
caught or is about to catch?

I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
until GCC-11 gets fixed?

Thanks,

	Ingo
