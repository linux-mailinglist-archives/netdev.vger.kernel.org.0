Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B830A7AA
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBAMcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:32:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbhBAMcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:32:01 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8104FC061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 04:31:20 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g12so24051307ejf.8
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 04:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XaQZNkSnrsxsruJLRbm9NeF04EAs0Hz6d0OqkUptI9Y=;
        b=NJhvx4ouB2bJq5rhpaffirU0K4K5N0rG0XM3SxzQxpu92A3g0lF6kFkMTXtm24w15o
         RyYgwr4Oj/1Bm/YQaH6dl1Oka3YXu/yrPR2fJGex2hocaF1TjAEMoHM4OdeJ1C4Wti+a
         URPgyDtxw7oZ+FJ8PFK63jEX6mgSRezNqYYAH/kG12ih2Zr9q5yMxyVaMej3CgOsGm7t
         UCF+fL0yyXcPvLVO2mXE9uDgMgPLpFmQMMc0Tl1Jex/l4ftIYvDJScZpe3xuGiTKA+l0
         Vaxw0rQlFLxJ17yUnxTbAW8sxxNHxHTcN4ug0K4Fn5oIdvU78YeaiJQhtuZ2A7PiZAjK
         zOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XaQZNkSnrsxsruJLRbm9NeF04EAs0Hz6d0OqkUptI9Y=;
        b=eDZXJMqrQ3nfit+TGUj3ef7nTA9OJbTmKMlAWM2O33O6CoMir0WVXqzZQHIE/RS2zU
         vNiPOfDf2vPQzN8d0FLCfonssaH1z+kHQAYgLAmf4EWXOwICjAX2nxtacpvP0QZeiRbl
         kzKuUAFh7M0DWADrgC9tNe98FtmauDLgLgbFHWmf9OeIHZslxltbVN9GGNFRqjYyAWYk
         t0MGWFppoh9Gkw4W34WNocaEqfH8ccloQ6kDhr8mYMXBqf2Mftf8OwKtXjj7KKKSwwJl
         /qMTCKWPGgMYHzXJmMusrWjuG4Aj3GKykKK2PZzY1tcZIBi7Th7Lu4DHzPaUX8CZUly2
         eh6g==
X-Gm-Message-State: AOAM5302DmFt/gPsYGCJRvVaALx2bBRUCacu9ts5AQAVp2RLrbhmIwnO
        /OZolJFQn9Kx6kz7JmGDD944zw==
X-Google-Smtp-Source: ABdhPJw+GcDCmDnqNKYvypgkVajiXdCmm/3kaWe3uTbzMY4RkWQd4BD2eEjlQpTz8tObcVqdz9c34g==
X-Received: by 2002:a17:906:c410:: with SMTP id u16mr16939708ejz.159.1612182679202;
        Mon, 01 Feb 2021 04:31:19 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id n27sm8055238eje.29.2021.02.01.04.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 04:31:18 -0800 (PST)
Date:   Mon, 1 Feb 2021 13:31:17 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>
Subject: Re: [PATCH RFC net-next] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201123116.GA25935@netronome.com>
References: <20210125151819.8313-1-simon.horman@netronome.com>
 <20210128161933.GA3285394@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128161933.GA3285394@shredder.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 06:19:33PM +0200, Ido Schimmel wrote:
> On Mon, Jan 25, 2021 at 04:18:19PM +0100, Simon Horman wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > Allow a policer action to enforce a rate-limit based on packets-per-second,
> > configurable using a packet-per-second rate and burst parameters. This may
> > be used in conjunction with existing byte-per-second rate limiting in the
> > same policer action.
> 
> Hi Simon,
> 
> Any reason to allow metering based on both packets and bytes at the same
> action versus adding a mode (packets / bytes) parameter? You can then
> chain two policers if you need to rate limit based on both. Something
> like:
> 
> # tc filter add dev tap1 ingress pref 1 matchall \
> 	action police rate 1000Mbit burst 128k conform-exceed drop/pipe \
> 	action police pkts_rate 3000 pkts_burst 1000
> 
> I'm asking because the policers in the Spectrum ASIC are built that way
> and I also don't remember seeing such a mixed mode online.

Hi Ido,

sorry for missing this email until you pointed it out to me in another
thread.

We did consider this question during development and our conclusion was
that it was useful as we do have use-cases which call for both to be used
and it seems nice to allow lower layers to determine the order in which the
actions are applied to satisfied the user's more general request for both -
it should be no surprise that we plan to provide a hardware offload of this
feature. It also seems to offer nice code re-use. We did also try to
examine the performance impact of this change on existing use-cases and it
appeared to be negligible/within noise of our measurements.

> > e.g.
> > tc filter add dev tap1 parent ffff: u32 match \
> >               u32 0 0 police pkts_rate 3000 pkts_burst 1000
> > 
> > Testing was unable to uncover a performance impact of this change on
> > existing features.
> > 
> > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> > Signed-off-by: Simon Horman <simon.horman@netronome.com>
> > Signed-off-by: Louis Peens <louis.peens@netronome.com>
> > ---
> >  include/net/sch_generic.h      | 15 ++++++++++++++
> >  include/net/tc_act/tc_police.h |  4 ++++
> >  include/uapi/linux/pkt_cls.h   |  2 ++
> >  net/sched/act_police.c         | 37 +++++++++++++++++++++++++++++++---
> >  net/sched/sch_generic.c        | 32 +++++++++++++++++++++++++++++
> >  5 files changed, 87 insertions(+), 3 deletions(-)
> 
> The intermediate representation in include/net/flow_offload.h needs to
> carry the new configuration so that drivers will be able to veto
> unsupported configuration.
