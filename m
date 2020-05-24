Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301A51DFC60
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 04:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgEXCLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 22:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388225AbgEXCLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 22:11:11 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40444C061A0E;
        Sat, 23 May 2020 19:11:11 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so6006247plr.4;
        Sat, 23 May 2020 19:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1NYHauUBWTQgbc43oFTAJCreNKv+baIo/68K96Zs4rc=;
        b=J786UewExllUKHofcVvgLTI358KCYatvgJpAOm0F2OufvL+pVNAtJGo1pj6JUBbbpC
         3NF7ePvGe1k+NcGAVJWA2jqXhGQgat6fKQL9C+cfS+HDIRW3Ap1PV2RjfeIRroac1Ezk
         KhFr6z8QBUa1W8cUNJnD/40ivm8kFHrTlkiHK7cocLe4YIU63lxvhlKVJLa1uVkKSRXG
         K5T/3uWMrNaxJoDU2eQqFcsAoD5BLt9X90hzco/4eRKjYTM1gkTYB1q7X53w991RSW2v
         1MVV+EKruZWQnr+ZrRghABtNQQDfIE7Sfy1pYYOvIS3EeWc8l92vFliiDW9EjpixaL1h
         Qflg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1NYHauUBWTQgbc43oFTAJCreNKv+baIo/68K96Zs4rc=;
        b=Qb9sNV064AArRV05HIGQ6y9u5uXrTjVSEBDbki/iMQ+pi6j7p0mSaz7zYpV8sJK7F1
         SnAKETVrr1kiqND/xtpj4rTmJ9vDJM+gDlH52p7fXgi4gG8VYHHviqdgh/Q4pxlqmAE+
         2Ggp+8zUpP/PC7mDAtUyCoKozvF6tWfXW9FGgI9Ladfgltn3de2A83j8bmyweAdp4IFd
         5IJA7kOiPgVGF/fMG9bwkVtorZ6tqIR6U+ZV0GYyMR10vbPUM0ylo0BttwhPdmmdw2Vs
         BxwwMcRtOUFn79f+TZkIWI9NrvKLHRHNyWiPEiQcaMQ5OPE4RrqRbsoBPLixUJVgMUsV
         DrtQ==
X-Gm-Message-State: AOAM533jwINdWIdx6a8eKtZ9wcS5OrU277jRE5R+DietqyoGPCTLCQ8w
        YqCuEBXqLwmNMfVyen4AWDM=
X-Google-Smtp-Source: ABdhPJzjaswgBjGeZOebznwn3ru9lufOX3WhHax+o+4Bd9NRfLzG3TqcRXoKe1CoWCEUQMaErKCTqQ==
X-Received: by 2002:a17:90a:10c1:: with SMTP id b1mr7863131pje.232.1590286270773;
        Sat, 23 May 2020 19:11:10 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id p1sm1961780pjz.36.2020.05.23.19.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 19:11:10 -0700 (PDT)
Date:   Sat, 23 May 2020 19:11:06 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jianyong Wu <jianyong.wu@arm.com>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        Mark.Rutland@arm.com, will@kernel.org, suzuki.poulose@arm.com,
        steven.price@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Steve.Capper@arm.com, Kaly.Xin@arm.com,
        justin.he@arm.com, Wei.Chen@arm.com, nd@arm.com
Subject: Re: [RFC PATCH v12 10/11] arm64: add mechanism to let user choose
 which counter to return
Message-ID: <20200524021106.GC335@localhost>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-11-jianyong.wu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522083724.38182-11-jianyong.wu@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:37:23PM +0800, Jianyong Wu wrote:
> In general, vm inside will use virtual counter compered with host use
> phyical counter. But in some special scenarios, like nested
> virtualization, phyical counter maybe used by vm. A interface added in
> ptp_kvm driver to offer a mechanism to let user choose which counter
> should be return from host.

Sounds like you have two time sources, one for normal guest, and one
for nested.  Why not simply offer the correct one to user space
automatically?  If that cannot be done, then just offer two PHC
devices with descriptive names.

> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index fef72f29f3c8..8b0a7b328bcd 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -123,6 +123,9 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  	struct timespec64 ts;
>  	int enable, err = 0;
>  
> +#ifdef CONFIG_ARM64
> +	static long flag;

static?  This is not going to fly.

> +		 * In most cases, we just need virtual counter from host and
> +		 * there is limited scenario using this to get physical counter
> +		 * in guest.
> +		 * Be careful to use this as there is no way to set it back
> +		 * unless you reinstall the module.

How on earth is the user supposed to know this?

From your description, this "flag" really should be a module
parameter.

Thanks,
Richard
