Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D54A1308195
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhA1Wz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhA1Wwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:52:38 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB6AC0612F2
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:48:46 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id u67so4987806pfb.3
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=jRc+9koAFnFriBYMbCECl8bNtNHOFnGAZDdGQS3iVDU=;
        b=VX8To19226WV8RDTkFQ5ObLuNZF9XVTO28Kn6srr7oOvy3bJROldWKCMUzp1PQKXf9
         DxW/pzBX8qvpyf9JYyEV0tsfWnIQwh8StSLFabjSv9bq/h+LrM8BcShVwk+8h5JEIVAC
         m7rR/FINIdZ5nzLJ4PtqwDLyuNTB4ApMNbGX1tO8SauTFQvq0jZUXb6tQjVnZTTurC4o
         JnT9bk1zHAxQ/KJOZ2l5CO8dDG2tvWtV2Yqs/XVrEpJuA4GCbDFdVRNie/dpc5yVuHhc
         6tpUXWl/fB3cIiNkDeifZnbig6ARvwbuNY0PAKYEKLOUWsV+N9z5P3YBgnwxTr3v/Wvb
         uKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=jRc+9koAFnFriBYMbCECl8bNtNHOFnGAZDdGQS3iVDU=;
        b=sZXibGQxX27MDojFAspVwHIdbyWVjGsMYTrll5TDYZIcwWApKwnZV0bR/T7CZV+OeQ
         BP0rkjWMlbB6+HAEpivWvwMO+ebsfjA9lt97ZaLKhaY6WLDa4E9LUfAIXclgpaoIOQo/
         2oNOEkf8Andw0YVU/IXxlqnthkAwixkPdp1WspNKTTtHPKi/3UQ0sMcmUmUIjcye6KOc
         aTAG5ZnB2BTGZDWpqzjkUTLyReciH8NgjRzUsyLV2j8//vgUfDAR9skOBeDbnkoZdFjh
         JaQLCYPySIjMVT+SzC0K4o1rOFL03g3CzVT1W/dx1x9NyauS4vNjf2YHzoRyHzJDZBT9
         XFIQ==
X-Gm-Message-State: AOAM5331t19SK3LXKpVFg7xIN0i+1T2aBIOpWTt59kqThscx8wqOuzc7
        Bh4pEmo93rgL10FMr+Dt8kpPTg==
X-Google-Smtp-Source: ABdhPJwBVbXS8W3fPe5c+jU1CL/MRyTOw1r5xPcMxMQku9sVK6cWDkTe2rvBDuGwi5tcagKuWF06SA==
X-Received: by 2002:a62:f943:0:b029:1a5:43f9:9023 with SMTP id g3-20020a62f9430000b02901a543f99023mr1512252pfm.75.1611874125638;
        Thu, 28 Jan 2021 14:48:45 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id v1sm7110414pga.63.2021.01.28.14.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 14:48:44 -0800 (PST)
Date:   Thu, 28 Jan 2021 14:48:43 -0800 (PST)
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
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common
 dev_page_is_reserved()
In-Reply-To: <20210127201031.98544-4-alobakin@pm.me>
Message-ID: <d8e86f1a-d2a6-d8af-142c-f735fd3be9f2@google.com>
References: <20210127201031.98544-1-alobakin@pm.me> <20210127201031.98544-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jan 2021, Alexander Lobakin wrote:

> A bunch of drivers test the page before reusing/recycling for two
> common conditions:
>  - if a page was allocated under memory pressure (pfmemalloc page);
>  - if a page was allocated at a distant memory node (to exclude
>    slowdowns).
> 
> Introduce and use a new common function for doing this and eliminate
> all functions-duplicates from drivers.
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Looks even better than I thought!

(Since all of the changes are in drivers/net/ethernet/, I assume 
everything directly or indirectly includes skbuff.h already.)

Acked-by: David Rientjes <rientjes@google.com>

Thanks for doing this.
