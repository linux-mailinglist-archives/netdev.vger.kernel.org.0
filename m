Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D853C1DFC4D
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 03:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbgEXBr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 21:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387589AbgEXBrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 21:47:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25E6C061A0E;
        Sat, 23 May 2020 18:47:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n18so7057046pfa.2;
        Sat, 23 May 2020 18:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MiZtZyUhvNO0RTN36GUvH+7s5VqvfFaGqxQpJXB604Y=;
        b=DlWRE4keNL1xYGr6LP7Z9dr6iDQDPvvYMwJuIn/pIXRqNGmrDDcSmH4wOySMJOlu9r
         R/3Z0WdpikEsiyrTcig2R+2qjmyfTURUOR87OLthliUvOkWLr+oxZCIaPSv71Ud6iaxX
         pP2YDXyvqEQbtJn4eptzd7DafNQ6zhj58PcaPV2KE2+G0fVR5zxHQuOocRcxPhFR88Q+
         KAG5cI2D618nv/MPnp65P3cyjOG+ntOCqmBZOZvEdfgGay76oZN5Lpot8t/Pl+i6I/3Y
         b4eIvWXswrLd2PWDQcO+2sqHOsK6mh0ymYGWdwXwwp6lYiz1svI+ZzUR8uJdv5YbWJpm
         qWwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MiZtZyUhvNO0RTN36GUvH+7s5VqvfFaGqxQpJXB604Y=;
        b=PeUduQXrt1tKhhiEdT5SE3CcWLlzZfBT8SU5HKuQlNxmsPOL3hvLZ+paupe58fxKH6
         Ab/ZuOYevEtugVpmUYyiRVv+14PeKOEsQhunTOMNQyyrYCGWRv/vjxEtlytWKzAvpg1s
         kj4axL6/VZDXotRPShYwoRAu3OMs8vqHXEKIts/J5/SVxk06GE47oti+Kiihse3xjISe
         47dsfoyNdH/J0VRcPZ6SY8uyQFIEDKEcVXSvM3GqvYfzt6eR2T6UwrRR05Zu7Vch647S
         /A0Fqtu/mRccFK1LPZ3mTT5LQBwvXXOOVsrwg3zfi74ErIi1X2XHoGYQJb+zFikihksP
         6jHg==
X-Gm-Message-State: AOAM530LUMYQKluKBIRo/4u/dFz/F7HS9mbKN0ShpXZuBituHZZcRsyu
        e+tM3LoyGTzXAu8HUVDWG+s=
X-Google-Smtp-Source: ABdhPJzNPkHzT4jcUH5lzJbYJGrTRfk3+5AMtRKlysF8ZixPkX7Nsuntu1LZYVVTbFr81nsx5i4U/Q==
X-Received: by 2002:a63:68c3:: with SMTP id d186mr20864807pgc.269.1590284845176;
        Sat, 23 May 2020 18:47:25 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q3sm9871423pfg.22.2020.05.23.18.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 18:47:24 -0700 (PDT)
Date:   Sat, 23 May 2020 18:47:21 -0700
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
Message-ID: <20200524014721.GB335@localhost>
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

> To use this feature, you should call PTP_EXTTS_REQUEST(2) ioctl with flag
> set bit PTP_KVM_ARM_PHY_COUNTER in its argument then call
> PTP_SYS_OFFSET_PRECISE(2) ioctl to get the cross timestamp and phyical
> counter will return. If the bit not set or no call for PTP_EXTTS_REQUEST2,
> virtual counter will return by default.

I'm sorry, but NAK on this completely bizarre twisting of the user
space API.

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
> +#endif
>  	switch (cmd) {
>  
>  	case PTP_CLOCK_GETCAPS:
> @@ -149,6 +152,24 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> +
> +#ifdef CONFIG_ARM64
> +		/*
> +		 * Just using this ioctl to tell kvm ptp driver to get PHC
> +		 * with physical counter, so if bit PTP_KVM_ARM_PHY_COUNTER
> +		 * is set then just exit directly.
> +		 * In most cases, we just need virtual counter from host and
> +		 * there is limited scenario using this to get physical counter
> +		 * in guest.
> +		 * Be careful to use this as there is no way to set it back
> +		 * unless you reinstall the module.
> +		 * This is only for arm64.
> +		 */
> +		if (req.extts.flags & PTP_KVM_ARM_PHY_COUNTER) {
> +			flag = 1;
> +			break;
> +		}
> +#endif

This file contains the generic PTP Hardware Clock character device
implementation.  It is no place for platform specific hacks.

Sorry,
Richard
