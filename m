Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73D3F2883
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 08:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfKGH4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 02:56:08 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46395 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbfKGH4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 02:56:07 -0500
Received: from p5b06da22.dip0.t-ipconnect.de ([91.6.218.34] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1iSce3-0000dt-Uf; Thu, 07 Nov 2019 08:55:56 +0100
Date:   Thu, 7 Nov 2019 08:55:54 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jianyong Wu <jianyong.wu@arm.com>
cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        will@kernel.org, suzuki.poulose@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
Subject: Re: [RFC PATCH v6 4/7] time: Add mechanism to recognize clocksource
 in time_get_snapshot
In-Reply-To: <20191024110209.21328-5-jianyong.wu@arm.com>
Message-ID: <alpine.DEB.2.21.1911070852551.1869@nanos.tec.linutronix.de>
References: <20191024110209.21328-1-jianyong.wu@arm.com> <20191024110209.21328-5-jianyong.wu@arm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019, Jianyong Wu wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
>
> In some scenario like return device time to ptp_kvm guest,
> we need identify the current clocksource outside core time code.
>
> This patch add a mechanism to recognize the current clocksource
> by export clocksource id in time_get_snapshot.

Please check Documentation/process/submitting-patches.rst and search for
'This patch'.

> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index b21db536fd52..ac8016b22734 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -19,6 +19,7 @@
>  #include <linux/of.h>
>  #include <asm/div64.h>
>  #include <asm/io.h>
> +#include <linux/clocksource_ids.h>

Please place that include to the other linux includes. You might notice
that there is ordering here.

But where is that include? It's not part of that series, so how is this
supposed to compile?

Thanks,

	tglx
