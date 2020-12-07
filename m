Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBFB2D1486
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgLGPTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGPTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:19:50 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6303AC061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 07:19:10 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id lb18so4985558pjb.5
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 07:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=odNpdlp0DsGsT5QtyqIedVECsUqYdgsL3aIlthPmLbw=;
        b=nhw4BDpV1/BYT7R5h2ljmI97Vp8zVzIQNhdDEdZnWs5aH1tVjspR3MLZ3y8IA+Jqgb
         7ryXYLbM+NHoPcvCox515XrcDVHT7kRrWDBCqK5x5USWtEfmmgTlRl9ZbUfsdAnYb2+L
         badeGTJchS6GvrlWYPjFbVkXnBNOe91mQqq5Vk3ycRjSvB2ejgjF4jX1+V7ptWtFtjTs
         megv/Rmut3L+Rn1jFF5ZfcSMAPN6WwmY/B8h6FwbSnD2zNaCKEt/xTrOM1s8SHHyIoQp
         lFoD/ozR5m/IC5HTOPZPzyThxJj7+fHalGL85fYHvqRwWR9yGGvYgk3cnRdlgLDnioyC
         PvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=odNpdlp0DsGsT5QtyqIedVECsUqYdgsL3aIlthPmLbw=;
        b=dB6peyLm3X1tV7XkTHXPrTvkQv0FTqiu1LjkcYN3nScZaTTC2m79m7zb6WDsGcZdvW
         G6knJAPXUMFczsvlVPIBRRU6UJIJ/JhNxWI7BFJkqAa8j8CEQdGffOcboQxLvcVn7u8V
         QHUJF1ymsmfagPlm3rZaLSLvdVMePYpXb1KpKcBUH6fu3OSTfevTila92VBTwRjYwrwt
         dl/Khy7bM0kWdjSaJTAmzAu3mh/IFrzNjCofmtnmvTbdiZqDYj6s0LECiQQrmHUw358P
         ybifbo9ewQV6ibpQcWXHC8/S87XiQxlTJzIEqcbB0nuTBwx1ef9iC1QkZ7RWB3zBEWuA
         ashw==
X-Gm-Message-State: AOAM53387l5+vtLx5mCsqhF6ISAGvEwFqbUI6ajENmyiGzatK4CItTaA
        ymx+Rckkf3+9G1SW3fUrBqs=
X-Google-Smtp-Source: ABdhPJzSnVNw/8QLDg22YTN0K6kEdXFn3EgZVFYp/p6JvNM0b9jAvi8V/UUdcKyyaRhbbiicw57+Xg==
X-Received: by 2002:a17:90a:6287:: with SMTP id d7mr16733398pjj.80.1607354349971;
        Mon, 07 Dec 2020 07:19:09 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id fv22sm11315177pjb.14.2020.12.07.07.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 07:19:08 -0800 (PST)
Date:   Mon, 7 Dec 2020 07:19:06 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Eran Ben Elisha <eranbe@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201207151906.GA30105@hoboy.vegasvil.org>
References: <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
 <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
 <20201206170834.GA4342@hoboy.vegasvil.org>
 <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a03538c728bf232ccae718d78de43883c4fca70d.camel@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 12:37:45AM -0800, Saeed Mahameed wrote:

> we are not adding any new mechanism.

Sorry, I didn't catch the beginning of this thread.  Are you proposing
adding HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY to net_tstamp.h ?

If so, then ...

> Our driver feature is and internal enhancement yes, but the suggested
> flag is very far from indicating any internal enhancement, is actually
> an enhancement to the current API, and is a very simple extension with
> wide range of improvements to all layers.

No, that would be no enhancement but rather a hack for poorly designed
hardware.
 
> Our driver can optimize accuracy when this flag is set, other drivers
> might be happy to implement it since they already have a slow hw

Name three other drivers that would "be happy" to implement this.  Can
you name even one other?

Thanks,
Richard


