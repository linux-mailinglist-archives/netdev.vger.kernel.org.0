Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B823E21A
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 21:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbgHFTZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 15:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFTZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 15:25:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 959EDC061574;
        Thu,  6 Aug 2020 12:25:25 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id d6so37708767ejr.5;
        Thu, 06 Aug 2020 12:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7jVwnXfyUDIWvKJ1IvnWj3XFejD3cmlEaNN5rkbj01Y=;
        b=j1YGcJOrlCx12S2/u9y1lwQC6QC0RvQ1N/LWinIdJBaERrp8+HWF1adDxm1KGOGhJn
         t1MNmPLUvhRP8S10NF3B4YXK7AYRXTSY3IfqahPVl4bahprHbAcIwDz8CI77ZuFdVvYN
         PjqE6AVCaZbEdGHDUfr0dkP6tgOeMUF12mDstHDMB6hvWrm0UKn0x11PWUkch8st2EV1
         milBRW+DtIRW+XZHFvl7/+Xnje4LsSWT17wu98CSUN6vjpgn1BVT38Prbrswp4C3W71l
         8nhRUlXCqJPv/ax2VzwctjLXWoS9tvJjIrXsvWHeejaxdbJwSwiOJABfKhwBQ1Y1PEBB
         jLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7jVwnXfyUDIWvKJ1IvnWj3XFejD3cmlEaNN5rkbj01Y=;
        b=RNFY9+yZYGxxXXp2Sw0XD6hY2AuFtbAz+HtQs+y0LZh4lTyqsTq6KvFB8VsxLVZ3GQ
         4VZ1pMCslJQoshqNak+t0Xoj6kQmMXEu7FlkM5sZG3TyNGMJ3F3jwdzJ8JC6sCV3udC0
         sosROQG+lAkvhhEIaBTzh1ciEgTsPqGyXaGHnghaEJUoss33xXPRq8s06w47A0co/8un
         2mksPzNHds4/KGCnxgjYrGtZyD0X+dUd9Sn5a6jP3pPjPmX0c5u8cDnUxZKwJiX5bwHQ
         V+9zdT1fxe5fbLe8nZMHYzMeiwD1I1Voeh+oGb68Edj+NRCF78Hu5EjQ9HitUFWunRsC
         SkPA==
X-Gm-Message-State: AOAM532KUdFyuwrbkdl2P8XiTzP0NPl51hNiG3AnY+NNIQkx1Lo638e7
        JlqukOwZYIO1I6xOI46QrkI=
X-Google-Smtp-Source: ABdhPJwwGeqSWHegNz5iETTFvyjQkDlTTMaYqwPsp1MBVYv3O7KsNk0D3J/dFC3k9LolfYo+BwM0Qw==
X-Received: by 2002:a17:906:3291:: with SMTP id 17mr6119918ejw.370.1596741924280;
        Thu, 06 Aug 2020 12:25:24 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id p3sm4014962edx.75.2020.08.06.12.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 12:25:23 -0700 (PDT)
Date:   Thu, 6 Aug 2020 22:25:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: net: dsa: sja1105: use detected device id instead of DT one on
 mismatch
Message-ID: <20200806192521.hhr34kuh3y44vehk@skbuf>
References: <60d2d8f9-1376-2047-b958-7bdbbde1538e@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60d2d8f9-1376-2047-b958-7bdbbde1538e@canonical.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 06, 2020 at 05:27:11PM +0100, Colin Ian King wrote:
> Hi,
> 
> Static analysis with Coverity has detected a potential issue with the
> following commit:
> 
> commit 0b0e299720bb99428892a23ecbd2b4b7f61ccf6d
> Author: Vladimir Oltean <olteanv@gmail.com>
> Date:   Mon Aug 3 19:48:23 2020 +0300
> 
>     net: dsa: sja1105: use detected device id instead of DT one on mismatch
> 
> The analysis is as follows:
> 
> Array compared against 0 (NO_EFFECT)array_null: Comparing an array to
> null is not useful: match->compatible, since the test will always
> evaluate as true.
> 
>     Was match->compatible formerly declared as a pointer?
> 
> 3418        for (match = sja1105_dt_ids; match->compatible; match++) {
> 3419                const struct sja1105_info *info = match->data;
> 3420
> 
> I'm not sure what the original intention was, so I was unable to fix
> this hence I'm sending this report as I think it needs addressing.
> 
> Colin

The intention was to loop through sja1105_dt_ids and stop at the
sentinel:

static const struct of_device_id sja1105_dt_ids[] = {
	{ .compatible = "nxp,sja1105e", .data = &sja1105e_info },
	{ .compatible = "nxp,sja1105t", .data = &sja1105t_info },
	{ .compatible = "nxp,sja1105p", .data = &sja1105p_info },
	{ .compatible = "nxp,sja1105q", .data = &sja1105q_info },
	{ .compatible = "nxp,sja1105r", .data = &sja1105r_info },
	{ .compatible = "nxp,sja1105s", .data = &sja1105s_info },
	{ /* sentinel */ },
};

I should have looked at the definition of struct of_device_id:

/*
 * Struct used for matching a device
 */
struct of_device_id {
	char	name[32];
	char	type[32];
	char	compatible[128];
	const void *data;
};

Honestly, I had thought it's "const char *compatible" rather than "char
compatible[128]". I'm still not 100% clear why it isn't doing just that,
though, I think it has to do with some weird usage patterns such as this
one in UIO:

static struct of_device_id uio_of_genirq_match[] = {
	{ /* This is filled with module_parm */ },
	{ /* Sentinel */ },
};
MODULE_DEVICE_TABLE(of, uio_of_genirq_match);
module_param_string(of_id, uio_of_genirq_match[0].compatible, 128, 0);
MODULE_PARM_DESC(of_id, "Openfirmware id of the device to be handled by uio");

So I had 2 options for this patch: either break the loop on
match->compatible, or on match->data. And it looks like I made the wrong
one.

Thanks,
-Vladimif
