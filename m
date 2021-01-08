Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6F2EFAC6
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 22:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbhAHVs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 16:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbhAHVs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 16:48:57 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE90FC061574
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:48:16 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id w79so9864936qkb.5
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 13:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZdyOJU/afRjOU/cKKectEALaNNEvp0ji0Tq2uxsOc7I=;
        b=Vdz6K0gwK52+95eibkxGmwQk3k+qUaI54C6uNsEJsRk+9wEJ2eAmFkaHedmAVcrhpr
         p4ag6tn56ccKUmUQXIH/xnyfRmVYXzhngQGkKB9lJQD7Y+s0YpMrWHEPRRGCKfvlb3mb
         ekFU6sRU/fDQ2npjTsirvSLrfJ2tBFr1tRDiA6crlUlSFaGJHaGBE7t2IHNBiHkbYR1E
         07bxGTYjx3n7a3GmoCs3Dp9w7G6sUhKXnpiZ0FEaoUM3EiWL9RwC1ilvqq0qV/93xHHo
         i1ntvtNY24ajoPcsUfjEafOevXVHOlC4bipiZgDWSQM9jZUPBkUPIbuE6uSpOdODjTxz
         cYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZdyOJU/afRjOU/cKKectEALaNNEvp0ji0Tq2uxsOc7I=;
        b=V+BmpoNoEtIPZSNQwNKlTeJl4ESyrg7XtwjpXqlImiwZpu76yZilQrwBhXwDeSlvCm
         j1mp5C3QPnbPWwqFCOmQQRrlFHwVSFU89E7YUdDcyfjCCCq/0MV2wPWtoIyirXtbl4uy
         2y0X33lYGslmlotcu1ECrd35GiV7LYIizD3z/2TqrJRrvYI8OyvxthfV0UF2UK8PfVWy
         HVofGUd0yLogwUN7vy49WVle2qUmupDuezgCtd5rDAdPwAYRoWPjRt/SYHDM/U5vDvXV
         T0RkR/bghNssrJbL1JEo0a7J+0DFeZ2pnWPtuAQ4JjgBT2zVetX1gretwLg1Ak14rfEQ
         bo6g==
X-Gm-Message-State: AOAM533jmHadc7rQBAiagPB1vsbKt+xvCN6qZh6wv2tCQHELAQxFbllw
        /R8fkNNHBvvTNuHkVu1KVlU=
X-Google-Smtp-Source: ABdhPJzloCznyEb62AMWAsnX4+7hyBDemmPHi+Cfkc6Er/qVYLzvY4dWP83qK3UzIPpqkSTI1JzMKQ==
X-Received: by 2002:a37:584:: with SMTP id 126mr5947068qkf.332.1610142495927;
        Fri, 08 Jan 2021 13:48:15 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.157])
        by smtp.gmail.com with ESMTPSA id j142sm5616534qke.117.2021.01.08.13.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:48:15 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 5A936C0095; Fri,  8 Jan 2021 18:48:12 -0300 (-03)
Date:   Fri, 8 Jan 2021 18:48:12 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210108214812.GB3678@horizon.localdomain>
References: <20210108053054.660499-1-saeed@kernel.org>
 <20210108053054.660499-9-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108053054.660499-9-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 07, 2021 at 09:30:47PM -0800, Saeed Mahameed wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Connection tracking associates the connection state per packet. The
> first packet of a connection is assigned with the +trk+new state. The
> connection enters the established state once a packet is seen on the
> other direction.
> 
> Currently we offload only the established flows. However, UDP traffic
> using source port entropy (e.g. vxlan, RoCE) will never enter the
> established state. Such protocols do not require stateful processing,
> and therefore could be offloaded.

If it doesn't require stateful processing, please enlight me on why
conntrack is being used in the first place. What's the use case here?

> 
> The change in the model is that a miss on the CT table will be forwarded
> to a new +trk+new ct table and a miss there will be forwarded to the slow
> path table.

AFAICU this new +trk+new ct table is a wildcard match on sport with
specific dports. Also AFAICU, such entries will not be visible to the
userspace then. Is this right?

  Marcelo
