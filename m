Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097D42CFDBB
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgLESnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgLEQ4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 11:56:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E4DC09426B
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 05:20:40 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id e23so5304256pgk.12
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 05:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F3W6qVKQcB0ziUwB6VG3hfXWnDQgFC7OKtlMEQrc8lw=;
        b=hTf4rWuZxZBO+kE+LP8+NNygdwvQQnwDmEV2BP6NIXDk/dYTxI0LMr3HMALIzya/B+
         gc5/E6AJqL+HjHZ5pWAtMdDrTV2QARNHsyMqCUQFoRzVl8tToiLyJZNyei2ezObJ+zBf
         j7nyNbvrERfxLYJk3hTK9Y8qHHv9BNPiolgOOaHRqRF/cfu5NL4IWpZ9P7GkFdzGlGkE
         SysBJdYGprSdO4A6edTJbteA6EUdWkt9HZ5M95Vkye4XeNhzULlmhHXDK4vlxgtbkXVs
         ZOqsgvOT+W52co0rdCN5tqOQXqToI8YQV0Sj3LdBKQfx+MUBZOgFpXbq4OQxdJd6NW9n
         PJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F3W6qVKQcB0ziUwB6VG3hfXWnDQgFC7OKtlMEQrc8lw=;
        b=snIDrbSWuylxjtIqbMn2JQdcI+J0FNawHtd0Sbu9c2MbNOoL9ruio48gm5uZci8/r/
         HnfnbfBrrJr6IHb1zm9ludzXLtk679/FhEPkHH01Sv8I3QoQAAo838P/k6Rzfed0QTGo
         XdKJlw8g3mReg+SuIwxn0Zxp7DYDm21PTOxLzcgwaQGOHbZSc2NvAjsLs1KL61edO0MM
         TArD8QVG1DYecWGBpOHTE+ZxvnbzMUHv4LytZagIXoXycUrDsJ+C76tM2gG0JoNufRPe
         vfyS68Qjq/bYIwxSv047CaGvvV3CPFllaFkY1FOLmnleeghe4XyrRJ/FQd3ifUdL9CMw
         dgzQ==
X-Gm-Message-State: AOAM5319YveeisrF3YvgFV8hZ9mY/XJKvs9yaYgqnCJLKl3xq3WZIfgL
        39g9BQT0e8NsPO6bV2RvJWY=
X-Google-Smtp-Source: ABdhPJzeULbO2z2reTA7qMQSt3dX5pqoWTnrrWkF+ydxhDc0NsGNuCrVC0K87fs58OWtO71WlsPgoQ==
X-Received: by 2002:a63:4d45:: with SMTP id n5mr11303653pgl.387.1607174440424;
        Sat, 05 Dec 2020 05:20:40 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id l15sm6860022pgr.87.2020.12.05.05.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 05:20:39 -0800 (PST)
Date:   Sat, 5 Dec 2020 05:20:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201205132036.GA14800@hoboy.vegasvil.org>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201205014927.bna4nib4jelwkxe7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201205014927.bna4nib4jelwkxe7@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 05, 2020 at 03:49:27AM +0200, Vladimir Oltean wrote:
> So there you go, it just says "the reference plane marking the boundary
> between the PTP node and the network". So it depends on how you draw the
> borders.

It depends on the physical link technology.  You can't just "draw the
borders" anywhere you like!

Thanks,
Richard
