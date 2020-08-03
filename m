Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90223AC50
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgHCS0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCS0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:26:34 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A9C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:26:34 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id l60so431348pjb.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xwqP56W01fv0a/3zaGYTc7MIrrflXinpAM39CihWa6Q=;
        b=JfYNAR6/v9YYGIl/CYcMN4dCOBywuztDH1VWF2Hs7oXtLhrwXul5QFo0B/JtoJnbrN
         tdkDAvYCjOuAAYVPVUwZDcz8alrbx+aQCR7gEtTSs8aj8wGUtlkAHnpE5Ng9wB4W+Xn5
         ea8TohL9vZpzjaPtULR0UBsWGi2OaC/jbx6jmfttaB7lLFOpvSY4w45X05mWqDj3SXaM
         sFg3ZyqbR4d5eJVwOATfrKcNYf1Mzc19gcI3itWrgd+y7+L+byQ8wMG4bMwDmZXQVHnX
         i4Q5tn6fM3Qj2z0Svn/Lo9mUW3WgZRn91aFeX+d1ZDgBAC8xHonfOT3RPnFxG+UHwexR
         MeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xwqP56W01fv0a/3zaGYTc7MIrrflXinpAM39CihWa6Q=;
        b=YpuufqRcBg26ZEvCSxtglReya7Hz3GUrLC38iPuUGuVMfnwfpWApvnTJHTmouxzMZ2
         Gt/rg6Qy/7+T2HvIW7ExHnklRemNJBTjia2A6jXYL8j+D8+zHR+z755nOOYXImwMg/0a
         muppq/WW5p/7aj4vi9iqk3hFGVxsOClWGzq5FcIIOJ7f1g3NCl1jPgJ1ejCGVN6f/cWa
         leyUZIYadoc6xPJmxnNvztJPzFZMQN9ZTEcKvTVAs99igdZy5HP7cDQxAWs0gi+ACaPC
         ypW5Sha1rP9XS/5tpJPbGmHQsCH1m3KSacktMFJ6/FcpophxmvwuLNmWuUZNq1peDDG7
         hUIQ==
X-Gm-Message-State: AOAM533LTGiX/hcddMZ4JaMm8nPBA7JzyjQcuF/VU9NEutO3Nu+MCdV8
        rzu7YmkIk1sVp2mUIJ0Huts=
X-Google-Smtp-Source: ABdhPJyZHD9GvT5xBFL2t3DFMsmG0j5lX3Hi0eeE1SxSb/TgS3VDjtYx5LkdSHVfhTtdPg7rRaAx7A==
X-Received: by 2002:a17:90a:2110:: with SMTP id a16mr598052pje.104.1596479194365;
        Mon, 03 Aug 2020 11:26:34 -0700 (PDT)
Received: from hoboy (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id r77sm21354532pfc.193.2020.08.03.11.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 11:26:33 -0700 (PDT)
Date:   Mon, 3 Aug 2020 11:26:31 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: poll for extts events from a
 timer
Message-ID: <20200803182631.GA28007@hoboy>
References: <20200803175158.579532-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803175158.579532-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 08:51:58PM +0300, Vladimir Oltean wrote:
> The current poll interval is enough to ensure that rising and falling
> edge events are not lost for a 1 PPS signal with 50% duty cycle.

> Fix that by taking the following measures:
> - Schedule the poll from a timer. Because we are really scheduling the
>   timer periodically, the extts events delivered to user space are
>   periodic too, and don't suffer from the "shift-to-the-right" effect.
> - Increase the poll period to 6 times a second. This imposes a smaller
>   upper bound to the shift that can occur to the delivery time of extts
>   events, and makes user space (ts2phc) to always interpret correctly
>   which events should be skipped and which shouldn't.
> - Move the SPI readout itself to the main PTP kernel thread, instead of
>   the generic workqueue. This is because the timer runs in atomic
>   context, but is also better than before, because if needed, we can
>   chrt & taskset this kernel thread, to ensure it gets enough priority
>   under load.

Makes sense to me.

Acked-by: Richard Cochran <richardcochran@gmail.com>
