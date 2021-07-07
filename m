Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6C3BE880
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhGGNE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhGGNEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:04:25 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195BAC061574;
        Wed,  7 Jul 2021 06:01:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i94so2978045wri.4;
        Wed, 07 Jul 2021 06:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vmLjLRUq+yxP/wkZQjOT0KYjSuiMk+aQDBKUpNKnec0=;
        b=s30GPeJdYb31qcdMOnJ9YMQCmMkL3LDeziK0NbNDxiSIcBhFjsPAyszDZpRls1MPUM
         F0e0Ft/iEeLB5bvekHv5WEa9cbq4raEQ86XNyIuAtn2ly1vGaoKwHVBUFpuVY/tAcQfz
         8xrxz8YGkHzBVpGXE5Am1D+tbjQ2Ekau+6I9KD3HuWxVOoaI7JVE5BuagyV5fAoEfD6r
         BnuBNRkwy2GdYKFfjGWcE1AjFsHJphVhVRqyJHFe70h4D0tQw6MqPc8nDNCisS3BC2Fj
         wQu5aAHiJnmrkkOr2tBXGzl0Yp63WnhY+JsJU1w9CZvif4La+828skgEfHr22i/YUjy1
         pY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=vmLjLRUq+yxP/wkZQjOT0KYjSuiMk+aQDBKUpNKnec0=;
        b=rF+EwX5yh7KJ5+8gFUvXmA552fiJgzHrAUMnlVitImD7GAEBKfzDh6vxlAXndiXtyr
         jAUH6pdD1lKOOubAmiBBGuOtNlfEG9MWARMA4vz0kM56OQoOfuHgdsVnw/pXK82Qyz1p
         iRSP6AXwu53vRgk0DK6bJw7KymuNGJIg67bAMSgW1L42Xv+Ey8xYycwAph3vpEwV9ToR
         ikZrZ2eB+4HYOr71cJLaxPZNJiSmVb9H2i6mrYQ0tO5GC0TPcc+Q38bFEUZHUn0v674s
         2+YIOSTIrwTlR6O75U4FmDi6opSJgqzFx2H52pgTtIx1BkysJqUY433JCehgHnlMcJ9m
         zt4w==
X-Gm-Message-State: AOAM530VLQW6cDe1+HT1rq0bK+S6rd7WLVL2Z6CIcC81kfYe8O6b/+HQ
        Ta9By9uxLP9GOzUOPEh73eg=
X-Google-Smtp-Source: ABdhPJwhNY8EFVwptl+H8Sfq6Ur8SsvKFyOcFUyTyT1UYqZXBElcJVCZgz+W3MY0sNKdUtgMcmWLYg==
X-Received: by 2002:adf:f850:: with SMTP id d16mr27640485wrq.258.1625662903761;
        Wed, 07 Jul 2021 06:01:43 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id v1sm21532097wre.20.2021.07.07.06.01.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Jul 2021 06:01:43 -0700 (PDT)
Date:   Wed, 7 Jul 2021 14:01:40 +0100
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sfc: revert "reduce the number of requested xdp ev
 queues"
Message-ID: <20210707130140.rgbbhvboozzvfoe3@gmail.com>
Mail-Followup-To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ivan@cloudflare.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210707081642.95365-1-ihuguet@redhat.com>
 <0e6a7c74-96f6-686f-5cf5-cd30e6ca25f8@gmail.com>
 <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACT4oudw=usQQNO0dL=xhJw9TN+9V3o=TsKGvGh7extu+JWCqA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 01:49:40PM +0200, Íñigo Huguet wrote:
> > And on line 184 probably we need to set efx->xdp_tx_per_channel to the
> >  same thing, rather than blindly to EFX_MAX_TXQ_PER_CHANNEL as at
> >  present — I suspect the issue you mention in patch #2 stemmed from
> >  that.
> > Note that if we are in fact hitting this limitation (i.e. if
> >  tx_per_ev > EFX_MAX_TXQ_PER_CHANNEL), we could readily increase
> >  EFX_MAX_TXQ_PER_CHANNEL at the cost of a little host memory, enabling
> >  us to make more efficient use of our EVQs and thus retain XDP TX
> >  support up to a higher number of CPUs.
> 
> Yes, that was a possibility I was thinking of as long term solution,
> or even allocate the queues dynamically. Would this be a problem?
> What's the reason for them being statically allocated? Also, what's
> the reason for the channels being limited to 32? The hardware can be
> configured to provide more than that, but the driver has this constant
> limit.

The static defines in this area are historic only. We have wanted to
remove them for a number of years. With newer hardware the reasons to
do so are ever increasing, so we are more actively working on this now.

> Another question I have, thinking about the long term solution: would
> it be a problem to use the standard TX queues for XDP_TX/REDIRECT? At
> least in the case that we're hitting the resources limits, I think
> that they could be enqueued to these queues. I think that just taking
> netif_tx_lock would avoid race conditions, or a per-queue lock.

We considered this but did not want normal traffic to get delayed for
XDP traffic. The perceived performance drop on a normal queue would
be tricky to diagnose, and the only way to prevent it would be to
disable XDP on the interface all together. There is no way to do the
latter per interface, and we felt the "solution" of disabling XDP
was not a good way forward.
Off course our design of this was all done several years ago.

Regards,
Martin Habets
