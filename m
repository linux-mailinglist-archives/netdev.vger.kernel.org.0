Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497AA30BE7E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhBBMno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhBBMmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 07:42:38 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE65EC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 04:41:57 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id h16so13647399qth.11
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 04:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H0azx0R1rFDr40x1vfqAcJKVCuqYeabnVQRFYbYpvEw=;
        b=pK6BMqqZYdHaAbwAggNAkcNAuzwRpaVGMaEan8CgmYg3UQh71WkUvp4ES+DYASrtho
         lUURtNEuWBl5KYn/D9lYqN0Rv7iBrLHY5zqHkVGd3ywBtiLuJd2IwmX71bnFjvMLmaRN
         0DsvvLCIFBZlC4mKTajiWGCgXwmpF60GOI/6vFU+fvMwnMj+hkxhujzrt3H8zE7EIB6q
         55X8TBlpU8LEBLRLJT58ZE5bjq1/4WyxoZC3vQwd/7f1laq27vtvUtj8oAFMSC9cRlgi
         fQSChW4ApcpThV6kAkUU7cJGnoGxU1/BNP5OY/q2ltPtenq5aZzXuxs8jS97MhChLi6/
         TeBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H0azx0R1rFDr40x1vfqAcJKVCuqYeabnVQRFYbYpvEw=;
        b=bUFpCaFLt+Xyb1EL1sP3eKJ89d3Wv/DKQlx1zwVOI9xXO5uoTd9x6E7sv+vdYxJRf4
         +VqrO2Ss2ozgtKltoqcDKqDT6da03GtRpAAcjzx+vS4us60pRLPnVM3A+j/XRonuM8A8
         rR+SQ6A6dLJkYqTINsa0kHkyA/FRIwLiUnaQ6JOhj/eM3FSrpErMpB3VQ56aEOGbvkkf
         NyoxF16H/TEZ3ZwXhPxqHm7HaRuJMMavOxZmLIFoT0NxgHwkDpMN34dIDeBOGBgi4U1h
         APz1fBv1eWAKj+IXAnCSkIqXdfortZQdpuS+XSL/f/hHqOZ+uY9aWEQsWMKd5XDY1gR4
         wy2Q==
X-Gm-Message-State: AOAM530sp8iMxMZ7zTuFBotMDHzNQ8mKHXtehNsfWRHvkVVbiHwCFgjd
        KHmGgRSLFFLld2hGrZJPLW8=
X-Google-Smtp-Source: ABdhPJyVfVfFA2qyOwkTmcDZ1sapMVTLwX0s8ycxZzdBfSbpGjWKzxwttLWIjO4yvPp27qfoN94cKg==
X-Received: by 2002:ac8:3954:: with SMTP id t20mr19174787qtb.241.1612269717073;
        Tue, 02 Feb 2021 04:41:57 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id u133sm12082798qka.116.2021.02.02.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 04:41:56 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1C1CDC0ECE; Tue,  2 Feb 2021 09:41:54 -0300 (-03)
Date:   Tue, 2 Feb 2021 09:41:54 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>, Rony Efraim <ronye@nvidia.com>,
        nst-kernel@redhat.com, John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH iproute2/net-next] tc: flower: Add support for ct_state
 reply flag
Message-ID: <20210202124154.GF3288@horizon.localdomain>
References: <1612268682-29525-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612268682-29525-1-git-send-email-paulb@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 02:24:42PM +0200, Paul Blakey wrote:
> Matches on conntrack rpl ct_state.
> 
> Example:
> $ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
>   ct_state +trk+est+rpl \
>   action mirred egress redirect dev ens1f0_1
> $ tc filter add dev ens1f0_1 ingress prio 1 chain 1 proto ip flower \
>   ct_state +trk+est-rpl \
>   action mirred egress redirect dev ens1f0_0
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> ---
>  man/man8/tc-flower.8 | 2 ++
>  tc/f_flower.c        | 1 +
>  2 files changed, 3 insertions(+)

iproute has a header copy, include/uapi/linux/pkt_cls.h.
I think it needs updating as well.

  Marcelo
