Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F142CC942
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgLBV7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLBV7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:59:51 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DDB6C0617A6;
        Wed,  2 Dec 2020 13:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=6ePFlyNqgVUo+qmHPHjN7o9GPIjt1fzjnVUtW7yGRt4=; b=zW8E237WE9t9laQ5Dh8iqYCxyF
        XodExrzAdTZcdTgxOJ9583RH7qW6nEvMKlH38mlRrNbBL/AqYbxFez9tkFWj6nKGr3cOI79B89/S5
        I9B0Mt/baLpmiAwdnn61uG6zeZ5QlyeqbTzczsatuV+unfBW6k8PVFc1mGqmWxpbjT/mDj1miuATO
        n+RGlimuDnkDGQjY0soxJyPSnpDNib+wLnYaWST30whGHaPVn+pt1VgR68kTWPRNvdx39hLUqSaSc
        fuG7n1riavmuATf7OKheQ2cbc4ixEZAooiavbCcBzrVRYPvE8Rp3tWjqD5SJRscANV/b+bpa8q+hd
        7to5ezxg==;
Received: from [2601:1c0:6280:3f0::1494]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kka9V-0002mf-9R; Wed, 02 Dec 2020 21:59:09 +0000
Subject: Re: [PATCH v2 1/2] x86: make VMware support optional
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org
References: <20201202211949.17730-1-info@metux.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <caa568a2-cd96-d74b-b2f8-40c8e2981982@infradead.org>
Date:   Wed, 2 Dec 2020 13:59:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201202211949.17730-1-info@metux.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 1:19 PM, Enrico Weigelt, metux IT consult wrote:
> Make it possible to opt-out from VMware support, for minimized kernels
> that never will be run under Vmware (eg. high-density virtualization
> or embedded systems).
> 
> Average distro kernel will leave it on, therefore default to y.
> 
> Signed-off-by: Enrico Weigelt <info@metux.net>
> ---
>  arch/x86/Kconfig                 | 11 +++++++++++
>  arch/x86/kernel/cpu/Makefile     |  4 +++-
>  arch/x86/kernel/cpu/hypervisor.c |  2 ++
>  drivers/input/mouse/Kconfig      |  2 +-
>  drivers/misc/Kconfig             |  2 +-
>  drivers/ptp/Kconfig              |  2 +-
>  6 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f6946b81f74a..eff12460cb3c 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -801,6 +801,17 @@ config X86_HV_CALLBACK_VECTOR
>  
>  source "arch/x86/xen/Kconfig"
>  
> +config VMWARE_GUEST
> +	bool "VMware Guest support"
> +	default y
> +	help
> +	  This option enables several optimizations for running under the
> +	  VMware hypervisor.
> +
> +	  Disabling it saves a few kb, for stripped down kernels eg. in high

	                           kB or KiB or even KB, but not kb
	                                                         e.g.

> +	  density virtualization or embedded systems running (para)virtualized
> +	  workloads.
> +
>  config KVM_GUEST
>  	bool "KVM Guest support (including kvmclock)"
>  	depends on PARAVIRT


-- 
~Randy

