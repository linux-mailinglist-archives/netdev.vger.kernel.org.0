Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC042B701B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgKQUcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgKQUcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:32:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359F6C0613CF;
        Tue, 17 Nov 2020 12:32:04 -0800 (PST)
Received: from zn.tnic (p200300ec2f10130053cbbcbd889a5460.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:1300:53cb:bcbd:889a:5460])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 018CC1EC03CE;
        Tue, 17 Nov 2020 21:32:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1605645123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=3C8iZQVCyNe8hkbWuwV/tblbPZQNKnK6sRC+nVZs2vs=;
        b=i+QDHSEnYVK5bfheQXKktIj3n8699yZScn/2NCs9OhD68XNHt/PTz4m4xxcqoXPs47+YOp
        4RRMtF6WP5zTMt0nJXguuBh6ezlTJhzfqc64pItHPlGTrV93g17OgJKd7GjeHbz+te+zvg
        r33PwHDPgyIvTfNC7i6WLaDIAwUx+M8=
Date:   Tue, 17 Nov 2020 21:31:55 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dmitry.torokhov@gmail.com,
        derek.kiernan@xilinx.com, dragan.cvetic@xilinx.com,
        richardcochran@gmail.com, linux-hyperv@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: make vmware support optional
Message-ID: <20201117203155.GO5719@zn.tnic>
References: <20201117202308.7568-1-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201117202308.7568-1-info@metux.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 09:23:07PM +0100, Enrico Weigelt, metux IT consult wrote:
> Make it possible to opt-out from vmware support

Why?

I can think of a couple of reasons but maybe yours might not be the one
I'm thinking of.

> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  arch/x86/Kconfig                 | 7 +++++++
>  arch/x86/kernel/cpu/Makefile     | 4 +++-
>  arch/x86/kernel/cpu/hypervisor.c | 2 ++
>  drivers/input/mouse/Kconfig      | 2 +-
>  drivers/misc/Kconfig             | 2 +-
>  drivers/ptp/Kconfig              | 2 +-
>  6 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index f6946b81f74a..c227c1fa0091 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -801,6 +801,13 @@ config X86_HV_CALLBACK_VECTOR
>  
>  source "arch/x86/xen/Kconfig"
>  
> +config VMWARE_GUEST
> +	bool "Vmware Guest support"
> +	default y

depends on HYPERVISOR_GUEST. The hyperv one too.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
