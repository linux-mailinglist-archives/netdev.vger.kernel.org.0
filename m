Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5620B30815B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhA1Wq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhA1WqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:46:06 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C292CC0613D6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:45:25 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o7so5307451pgl.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:45:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=cbREDcYUxdGPWuZgrjmxI5lJSyINoM6pZuP8VJQYcBo=;
        b=ewjgG2AitYQp4pR9LLq/tqMYwnkFQZMJwHV8dd5+P0lSWU/WAGkDWJkNSkhhHO1LhD
         yWduDr7ASEWl6p1Gh5LXct/KLCVZRbh1Vz7VPKX6RvOQzaN7p70IOUlTuf5IXKs4Yh87
         5BgRM1DILAYPL4ZGok0do/GOURwRmcb22SyrNd5SfM/gixVkT8qoX+cyJpEv8fa5m9Ib
         jprArihDrGfUsIobODolmJ0tGUvqPW98PLhRZX1SdPYWKnUb0eMHVkotno395LYey9rq
         0v//KPAC4zpmFUMGUIcHUt7amWMNjxhruYpGecyr1o4snnqTuvdYBgDKi75JeHKcplS1
         lLAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=cbREDcYUxdGPWuZgrjmxI5lJSyINoM6pZuP8VJQYcBo=;
        b=hu85U1li2Bwk4ID7oOd8cqwXETJ3nOSwnE1wQvMEzJA4Yfh3xWskcDnvt5BjyETRkk
         WDb2aJwqDaviN9Bq5fAQjL0lKqtSyOR6NFgmWl9n3pVgsnRYhqDtXecRCYD2W7Wft9jQ
         lzXLi6GFRKBMmYcV/JyfN+4hHTze87n2WfZFz4U4peDggPFnXkY4JVAUCmjQ9g2TaSl2
         azyVgrFPFaJG83XUiBH6Uoyhwdj0LjRwdWbIeDP009SZH5uCb8h05SPtGandAGoJsRy0
         NmFdcg+oODCIaDimueoc0luGOZUwLHkqS/qkA3T3hwhH+WcsvKznhwxSFA6RizF4VT6W
         ifvA==
X-Gm-Message-State: AOAM5308DhI69lW5PnhXFksjiERIPDAUV4vx5CUk2/WUmoSRJxqawNi6
        Ujcllv6nDOTsOww9yFQrjYZ8wQ==
X-Google-Smtp-Source: ABdhPJwWjMZAyLfJ0E9B8GRyN2meuwNffp9+5ZYWtwCpfUrwQjj8uej2C7H59DTF1LfNJWBTTZ9/zA==
X-Received: by 2002:a63:db54:: with SMTP id x20mr1543682pgi.200.1611873925104;
        Thu, 28 Jan 2021 14:45:25 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id d21sm6051801pjz.39.2021.01.28.14.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 14:45:24 -0800 (PST)
Date:   Thu, 28 Jan 2021 14:45:23 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Alexander Lobakin <alobakin@pm.me>
cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 net-next 2/4] skbuff: constify skb_propagate_pfmemalloc()
 "page" argument
In-Reply-To: <20210127201031.98544-3-alobakin@pm.me>
Message-ID: <b1d34275-1564-a46c-601b-a4b9865f50c7@google.com>
References: <20210127201031.98544-1-alobakin@pm.me> <20210127201031.98544-3-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021, Alexander Lobakin wrote:

> The function doesn't write anything to the page struct itself,
> so this argument can be const.
> 
> Misc: align second argument to the brace while at it.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: David Rientjes <rientjes@google.com>
