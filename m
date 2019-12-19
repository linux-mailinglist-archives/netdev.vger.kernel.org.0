Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2979C1261BA
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 13:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfLSMJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 07:09:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40293 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfLSMJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 07:09:28 -0500
Received: by mail-wm1-f67.google.com with SMTP id t14so5350727wmi.5;
        Thu, 19 Dec 2019 04:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9nrUrPJJmMQbUtqCwZA0Mulwi+MvmTGPon6VGzHJdQU=;
        b=fttJxGzGPT4g1tUMkB7BHa/Lk3/1X34AOEBggHngWyhREyc0qeXowAtctHMKriGOs4
         twGMdFQU9FpJYntAlDmjGj7VRedFQIcPV4wlyiCWCvNwv+3qRVP3iBWBt6fNULJjdcu7
         zkqzCOdFFp84Q4LhUOzqKLkNig0Ykds3sq8h0aZEVMwLkkho6Ic3SvYvdZ1KXR8a3qfW
         OY//UA6TYB5Faz2xxF8JBbbvCbkrUHvluirknBAXs/wcOmkLxTe7mjUgdBedmgvw3VtH
         o0AjHdGO+iXLpVasQ1/YCFfdArcb2TwJ8fd8hJ52fbglGUvy8WTM8Jo1LDUTEwRMtFKY
         VQnw==
X-Gm-Message-State: APjAAAXGacuwrC3yia9B/NhM1re9VfwEhvveA2zYhEHJoK+cA6tG28gB
        fUikYcKvlBWasnkn09snJEI=
X-Google-Smtp-Source: APXvYqwLEFQsLDtdaGgcIJLNUGUybcxU1S9YReJl9xQbTOdW6ovC30wl+rNvUJVesdErENs6wC+q+g==
X-Received: by 2002:a1c:3dc3:: with SMTP id k186mr9321820wma.95.1576757366396;
        Thu, 19 Dec 2019 04:09:26 -0800 (PST)
Received: from localhost (prg-ext-pat.suse.com. [213.151.95.130])
        by smtp.gmail.com with ESMTPSA id f1sm6137802wru.6.2019.12.19.04.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 04:09:25 -0800 (PST)
Date:   Thu, 19 Dec 2019 13:09:25 +0100
From:   Michal Hocko <mhocko@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next v4 PATCH] page_pool: handle page recycle for
 NUMA_NO_NODE condition
Message-ID: <20191219120925.GD26945@dhcp22.suse.cz>
References: <20191218084437.6db92d32@carbon>
 <157665609556.170047.13435503155369210509.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157665609556.170047.13435503155369210509.stgit@firesoul>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 18-12-19 09:01:35, Jesper Dangaard Brouer wrote:
[...]
> For the NUMA_NO_NODE case, when a NIC IRQ is moved to another NUMA
> node, then ptr_ring will be emptied in 65 (PP_ALLOC_CACHE_REFILL+1)
> chunks per allocation and allocation fall-through to the real
> page-allocator with the new nid derived from numa_mem_id(). We accept
> that transitioning the alloc cache doesn't happen immediately.

Could you explain what is the expected semantic of NUMA_NO_NODE in this
case? Does it imply always the preferred locality? See my other email[1] to
this matter.

[1] http://lkml.kernel.org/r/20191219115338.GC26945@dhcp22.suse.cz
-- 
Michal Hocko
SUSE Labs
