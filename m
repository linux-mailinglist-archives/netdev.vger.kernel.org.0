Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEBC2CC941
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbgLBV7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLBV7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:59:43 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F03C0613D6;
        Wed,  2 Dec 2020 13:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=kb88isD6UQQ4pziP8SfHAEy2NFf6PJ4pThmNMqkixS8=; b=TZ2iztmnYBglqeDgARHeQtuI6D
        w/4ool4sdNQUoWgs40IzXH3FWlzlME6PYj49zBlJjKcLxncikwnCK2K47Wgnq20V0gNtlPUuXXPXu
        HRV7v9vJsoXGBAiLtXTP8zN5m4Zmq74k8a4Hphk9gt82isbMNjBVvIx4BQAfyDVtm6RPjaTxsifGT
        PDBUqLrqyF0eRLaH9glhquxGL7b1msYMlyGKTE83ZYHq4lNJSF90BmjcaDHN6rZ0rCqcpjc2YB/5k
        xUP5JMr8s+eX/S0MsLTHkVktRhWvC1zwA07W/Un9HDKhkipVWY9e5A6OLmIyjQcnjwtLDVG0SjCw4
        VoEqQc7w==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kka9K-0002lr-W9; Wed, 02 Dec 2020 21:58:59 +0000
Subject: Re: [PATCH v2 2/2] x86: make Hyper-V support optional
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201202211949.17730-1-info@metux.net>
 <20201202211949.17730-2-info@metux.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e898aa1b-84e8-9898-c834-48c599be7ffd@infradead.org>
Date:   Wed, 2 Dec 2020 13:58:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202211949.17730-2-info@metux.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 1:19 PM, Enrico Weigelt, metux IT consult wrote:
> Make it possible to opt-out from Hyper-V support, for minimized kernels
> that never will by run under Hyper-V. (eg. high-density virtualization
> or embedded systems)
> 
> Average distro kernel will leave it on, therefore default to y.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  arch/x86/Kconfig                 | 11 +++++++++++
>  arch/x86/kernel/cpu/Makefile     |  4 ++--
>  arch/x86/kernel/cpu/hypervisor.c |  2 ++
>  drivers/hv/Kconfig               |  2 +-
>  4 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index eff12460cb3c..57d20591d6ee 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -812,6 +812,17 @@ config VMWARE_GUEST
>  	  density virtualization or embedded systems running (para)virtualized
>  	  workloads.
>  
> +config HYPERV_GUEST
> +	bool "Hyper-V Guest support"
> +	default y
> +	help
> +	  This option enables several optimizations for running under the
> +	  Hyper-V hypervisor.
> +
> +	  Disabling it saves a few kb, for stripped down kernels eg. in high

	                           kB,                           e.g.

> +	  density virtualization or embedded systems running (para)virtualized
> +	  workloads.
> +
>  config KVM_GUEST
>  	bool "KVM Guest support (including kvmclock)"
>  	depends on PARAVIRT


-- 
~Randy

