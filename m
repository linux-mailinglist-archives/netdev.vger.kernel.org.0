Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC1699F94
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBPWGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjBPWGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:06:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033A73C2BC
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:06:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bg2so3304290pjb.4
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1676585160;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dsokVW/tCExMxhk8VX9RWsBpGC4IU5J7oPXpiFyWHoM=;
        b=ki3OV/VlPi4lrL4e6MCgui1JPjdvWWCJ+uXdgJkLGl4bTfR7LNRuJmzEtSxC/Tk5yW
         Ym06nCmOllmyMMVKEQylRcThynOh2s9gtrFyGaFoOkPbBPs/EmFmuEATAlDFndg4iAYX
         cuvDJr80aNJmS2M6T57bX8oTR3CXAijEHHWju/ormUMDBFH7QSTZbjephoW1CBq5jfo3
         PUnFtLDgnqIZGDhKF1KFhdVji4r2uvUTsSC9nYMsrk9vYk+AmmJYf/aoAv6q3k8wZRFl
         nvmqo3lzaHGvhaJbJfMzYSPhbc50JNm1XpJw4J3tBR2Muz/VfsWmCPX/0VUxftBBo++E
         NJmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676585160;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dsokVW/tCExMxhk8VX9RWsBpGC4IU5J7oPXpiFyWHoM=;
        b=0r/T9v21SBGct0r6INHDX/83V+P/YkRO4Gr9ypHGcRqGmCC6WHoNnINA2KJdwXUBSq
         zcIV1gcYXv/WFXz2WRBcfT95EC4p43opBo8q4lrd816A+Yq3SV6gOQl7zNYAySg14G3O
         t4U23Dt3X+tiUTxlbXyK0Bwys0Zf2dDcpeg3G2SzVtKXhX7S26Li3Ae/SJb49Omn0j+S
         +1HwRonhRohG0PfWQJjEj5rjPv4xEFyn+B1SS5CYr9SCQxTZDE6lYu7Ni9a4vzfKGwMy
         L5t3CNl6Re7UX3MyuNEQhxAVOHlXbWm2EM/ZufNzH9TFtJtz7RHjIk26eaC73RvHFApn
         5i0Q==
X-Gm-Message-State: AO0yUKXTtEQeR6sXkDl7PjitfEXTEyzFmdAoG22dR1RImSbTiK/XEofa
        CEZd44h8Ex3uaneG7wOl/3A=
X-Google-Smtp-Source: AK7set+n42lnEg/Ut67wVQ5KH93qa+kRRAlqO1kyYBvdsM6g/r0rQ1JuS0VpeUapGVGhgccoiRWKNw==
X-Received: by 2002:a17:90a:840f:b0:234:117e:b122 with SMTP id j15-20020a17090a840f00b00234117eb122mr6686518pjn.0.1676585160310;
        Thu, 16 Feb 2023 14:06:00 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id l4-20020a17090ab70400b00233864f21a7sm3658955pjr.51.2023.02.16.14.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 14:05:59 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:05:56 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     yangbo.lu@nxp.com, mlichvar@redhat.com,
        gerhard@engleder-embedded.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net] ptp: vclock: use mutex to fix "sleep on atomic" bug
Message-ID: <Y+6oxBvxlApui8Ei@hoboy.vegasvil.org>
References: <20230216143051.23348-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230216143051.23348-1-ihuguet@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 03:30:51PM +0100, Íñigo Huguet wrote:
> vclocks were using spinlocks to protect access to its timecounter and
> cyclecounter. Access to timecounter/cyclecounter is backed by the same
> driver callbacks that are used for non-virtual PHCs, but the usage of
> the spinlock imposes a new limitation that didn't exist previously: now
> they're called in atomic context so they mustn't sleep.
> 
> Some drivers like sfc or ice may sleep on these callbacks, causing
> errors like "BUG: scheduling while atomic: ptp5/25223/0x00000002"
> 
> Fix it replacing the vclock's spinlock by a mutex. It fix the mentioned
> bug and it doesn't introduce longer delays.

Thanks for taking this up...

> I've tested synchronizing various different combinations of clocks:
> - vclock->sysclock
> - sysclock->vclock
> - vclock->vclock
> - hardware PHC in different NIC -> vclock
> - created 4 vclocks and launch 4 parallel phc2sys processes

Could you please try it with lockdep enabled?
 
> @@ -43,16 +43,16 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
>  static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  {
>  	struct ptp_vclock *vclock = info_to_vclock(ptp);
> -	unsigned long flags;
>  	s64 adj;
>  
>  	adj = (s64)scaled_ppm << PTP_VCLOCK_FADJ_SHIFT;
>  	adj = div_s64(adj, PTP_VCLOCK_FADJ_DENOMINATOR);
>  
> -	spin_lock_irqsave(&vclock->lock, flags);
> +	if (mutex_lock_interruptible(&vclock->lock) < 0)
> +		return -EINTR;

Nit: please drop the '< 0' from the test.

> @@ -281,9 +280,10 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
>  		if (vclock->clock->index != vclock_index)
>  			continue;
>  
> -		spin_lock_irqsave(&vclock->lock, flags);
> +		if (mutex_lock_interruptible(&vclock->lock) < 0)
> +			break;

This is the only one that I'm not sure about.  The others are all
called from user context.  Clean lockdep run would help.

Thanks,
Richard
