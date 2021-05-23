Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E682E38DD43
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 23:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhEWVZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 17:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhEWVZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 17:25:50 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F09C061574
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 14:24:22 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id q25so1150300pfn.1
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 14:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fOhsE2MewqDZthsCUeR7m8W/hRB1VhwxZlF2yZXoOr0=;
        b=uWfY0m75BVDo1wcqbVkwQ0r0Lkn6ISXU8JNqU2748+2iXxI0r3eR4yHpUkE7RcjkkA
         6YyOKXZ22GVnfe4wa6yRWDu/DM2wZwsVMr7I0xxv6LHrw+h+H4zn7IBDilmQ2jD7liTn
         EH0VouR9VY4u02McJjZv+n3lQgHptMNk+MpozQb7YM1DInLJ03qNey/o+nOGALxDdk1t
         mqPovpz37nkzhw0/RpF1jBeY5UeYMpSc4kiga+XNyKBJy+JJu30IZCOxiKCaH1H3wvux
         x4yO+b8tcxFpFbYbOxbVL2oToSgauZ3wLg5BZ21yH9bRl1VBlQODQzUzLgE/kz/Jaq8l
         Vmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fOhsE2MewqDZthsCUeR7m8W/hRB1VhwxZlF2yZXoOr0=;
        b=E3wr5AVS9CgzDWVK2P8WcAPXLITQFVy9z4vBS6lQK6gaP43TEJr6amDRcWmwT4D5ti
         MBhweCdsr7vPdEk0lsawQfZi+1PuZobueNmckT/VNvp1xbmRjtQ2L5jAncfTrxExNSzb
         e7MhaL0DGa+WA43G+tsqmf3CYT95UGuCBYrd8Uh+DIx87TxOPB+I02NValZPgnfg3zIp
         6fe7zXkRQBOLDL6saFy7poJfLYC+dhFbPI+A2HJuHFr5r8T05x4/A53tDxCuzB3A63Aq
         HpuQgezbYw2GBxx30BFJSGBXl9HnPB/TWoleNmM9Y4ebvkk8iIJaAMdjdxrBe+WvZVUO
         DWOw==
X-Gm-Message-State: AOAM533hyNjB9ejZylXQVrlysZwy5zKYJ23p/btk6qS9WWBFzbeAIpx5
        +LD+UBfqE5CdFYsSVw3ETrL3JI7pYR8=
X-Google-Smtp-Source: ABdhPJxAjIBYzKtmRELH/lCwWsK26M16LoaaYlxngFNNTbM7FymiaHuwyuDym1ffdofeFbj4ezqOVA==
X-Received: by 2002:a62:8184:0:b029:2df:ef25:358 with SMTP id t126-20020a6281840000b02902dfef250358mr21204592pfd.5.1621805061321;
        Sun, 23 May 2021 14:24:21 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id f9sm8819364pfc.42.2021.05.23.14.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:24:20 -0700 (PDT)
Date:   Sun, 23 May 2021 14:24:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next, v2, 1/7] ptp: add ptp virtual clock driver framework
Message-ID: <20210523212418.GG29980@hoboy.vegasvil.org>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-2-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210521043619.44694-2-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 12:36:13PM +0800, Yangbo Lu wrote:
> This patch is to add ptp virtual clock driver framework
> which just exports essential APIs.
> 
> A new member is added for ptp_clock_info structure. Device driver
> can provide initial cyclecounter info for ptp virtual clock via
> this member, before normally registering ptp clock.

Why not provide this in the PHC class layer, and make it work for
every driver without alteration?

> +/**
> + * struct ptp_vclock_cc - ptp virtual clock cycle counter info
> + *
> + * @cc:               cyclecounter structure
> + * @refresh_interval: time interval to refresh time counter, to avoid 64-bit
> + *                    overflow during delta conversion. For example, with
> + *                    cc.mult value 2^28,  there are 36 bits left of cycle
> + *                    counter. With 1 ns counter resolution, the overflow time
> + *                    is 2^36 ns which is 68.7 s. The refresh_interval may be
> + *                    (60 * HZ) less than 68.7 s.
> + * @mult_factor:      parameter for cc.mult adjustment calculation, see below
> + * @div_factor:       parameter for cc.mult adjustment calculation, see below

Just use  mult = 2147483648 = 0x80000000 and div = 31.

Read the real PHC using .gettime() and then mask off the high 32 bits.

Arrange a kthread to read once every 4 (better 2) seconds to keep the
time value correct.

See?

Thanks,
Richard

