Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E46BBABFD
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 00:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbfIVWbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 18:31:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40577 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbfIVWbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 18:31:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so6835756pgj.7
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 15:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=gKQf29wHUne7HHUcaKWuvokQuQFXQ6ewB4zZKn2Wb8A=;
        b=rxIoHHOuPAHiex0ATA3NwAkvdUDhn398Gw9ANyEwEQTp3jFRq47IIqRBnvAarmvOhm
         QriLpOeHJRbKP/RkxgfCl2w+6IBXY5HbuRA2eMy0Id0mVfsHM5wPdS5N0aNUs8iGnKiN
         bAJVWrmeHu5sSKJXSS8GevJDXAOEo/5h+WfZK3XRTBjGD8eqDsKvLljnvizbcqyhEuVD
         gyz6LEyRcl9+IzQNaBR1B5VErLFF8ThF0pRZAdN15A9DIPo80SKYRQtL8JL0rAKhq0lz
         Va9/ySEc1rpn0TZj/JmqSUIpoPjRSIuZUZuDwV354ragUKcHae92QjjHMHt/4Wo7rKQ2
         bWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=gKQf29wHUne7HHUcaKWuvokQuQFXQ6ewB4zZKn2Wb8A=;
        b=lRrojM68U+Uw686pKi3ikjo04o5sZRFV8nFPoRDhyqhf9bs954RQmqkmJGeHbB9Ela
         vXKubp/RwfdjOEJS1V/DAXh/LA30LTWO7cjiyOtJu52ItjZyLDqyWpiU3xn83d2kPLmu
         Xb9l/dcTj4hIX/wtAKprXnZZw+CF2wbyOOX3C8GwWsWZuXrDUN6DZW77R+DNYfa1ikYL
         BmNzSsfzYFBxLsNKrJq96Mft3+tN8I3HLnM7DfRIwk0MTsepCr0A7VyGiMcRs6qsjNky
         /I6YvOLy7f7rN5ZhOt3SuMEZqlc7rPjmDE5jHspOQa60gNOfM/YPS0mSmzKfh+TX+3TW
         bi+Q==
X-Gm-Message-State: APjAAAWw0vw4qjPyVH2mHWMxuN3mUrruoLz3nHx+YJhVpfIjpSPe0IXi
        b0YU5Y+b63ub94OZ4h+6nd6xkA==
X-Google-Smtp-Source: APXvYqx7KKQS2DvlD5zTbylJ6r5f5totuAKe8v107VUjOM7io2MFqQ3bchgOHBIhHyy5gWEpVsWntw==
X-Received: by 2002:a63:c09:: with SMTP id b9mr25936584pgl.245.1569191495395;
        Sun, 22 Sep 2019 15:31:35 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id x6sm10770768pfd.53.2019.09.22.15.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Sep 2019 15:31:35 -0700 (PDT)
Date:   Sun, 22 Sep 2019 15:31:32 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bitan Biswas <bbiswas@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Fix page pool size
Message-ID: <20190922153132.0c328fe7@cakuba.netronome.com>
In-Reply-To: <20190920170127.22850-1-thierry.reding@gmail.com>
References: <20190920170127.22850-1-thierry.reding@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Sep 2019 19:01:27 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The size of individual pages in the page pool in given by an order. The
> order is the binary logarithm of the number of pages that make up one of
> the pages in the pool. However, the driver currently passes the number
> of pages rather than the order, so it ends up wasting quite a bit of
> memory.
> 
> Fix this by taking the binary logarithm and passing that in the order
> field.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Since this is a fix could we get a Fixes tag pointing to the commit
which introduced the regression?
