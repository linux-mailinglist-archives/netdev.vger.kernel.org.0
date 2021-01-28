Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A194308156
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhA1WqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhA1Wpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:45:47 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F88C061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:44:58 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id u67so4982394pfb.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=QyEif4VyZcju9R1mKoD/tD54DKRTJWeE0Dgl2QjUm3c=;
        b=E26b/trYarb6KK70wmR2E+OJdxnTogS0ETGiS4abIvOyQHhJ8LxMz2KTBkXLCM/Ivv
         Z38c7DceiM9rPWg4EbbGD6Ndc94tPNlIyO57WDIxZs4kdZgV97NjdGB3o5Yc6EYFHBS+
         U3hVoCrWKgtF8D8GyAEm5f79ee+yC8aG/DXgUbcf3HYHiFYYUQ5CGmnWh76CpA+C7kdh
         3v+fSEyuTVwNSc1mPIqvneBw0dEwM3GsCF44182C+FnDx+qf6IugERbk0zPFcebbc2bV
         8l3NyThctWYb7ePNlX/3tABBo7cx0nuwxSgaikbyDSHp2llydDsZu3tdNCYcUtBzOvvy
         Y1QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=QyEif4VyZcju9R1mKoD/tD54DKRTJWeE0Dgl2QjUm3c=;
        b=ODVRqtx2RWoE5LY1SgthvLI8ntdmHg3n5kb3Wnpv7ucbkak761LaoTXumlpfekDKVz
         NkpnmuL33ZJ8UcTWG1iacyWQZZJYGGEaucFVWGDTxHnSUAoOtvOAm8YiR+NcN/V0YHB3
         P1lvn14iKZP8fxkMfWOulfDttPe04P5y+3BiFtvYsFs6rBFH+yIZbdWo8T5hi170i/Pz
         6TCI1wjoZ+SOIokuDW70ocpVME9tSbxgaDcADD7hnRieBEgCyrjA2EThvk0D24S59hse
         D68ASI6qPabmusrTppyg4PMgZ/SSNpW8rr5sBlrOiKwlf1+x/JUXbA4xEILrCphTFHLB
         1yVw==
X-Gm-Message-State: AOAM5307Dmx/LmMFe+zmWXRugry2AFMk0utDl/H+mrT4UHfUfoVX7qQT
        GdkAxtIyi14za77vmLa889Mxrg==
X-Google-Smtp-Source: ABdhPJwWaYtvgJm8E+ti9h4XRgK7o9llC19o2oBo8G1fBLSQVe7N3WjmyzApdRZlT+yP8f2GiPEGsw==
X-Received: by 2002:a63:2259:: with SMTP id t25mr1530428pgm.395.1611873898388;
        Thu, 28 Jan 2021 14:44:58 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id 6sm6490348pfz.34.2021.01.28.14.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 14:44:57 -0800 (PST)
Date:   Thu, 28 Jan 2021 14:44:56 -0800 (PST)
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
Subject: Re: [PATCH v2 net-next 1/4] mm: constify page_is_pfmemalloc()
 argument
In-Reply-To: <20210127201031.98544-2-alobakin@pm.me>
Message-ID: <cf211a78-7ce7-90e0-a589-1eb0bdc44222@google.com>
References: <20210127201031.98544-1-alobakin@pm.me> <20210127201031.98544-2-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021, Alexander Lobakin wrote:

> The function only tests for page->index, so its argument should be
> const.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Acked-by: David Rientjes <rientjes@google.com>
