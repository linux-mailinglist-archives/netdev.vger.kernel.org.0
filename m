Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6613129C46
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 02:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLXBBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 20:01:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32392 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726833AbfLXBBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 20:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577149274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wKGwxLX/FCIOtXSJBKDi/gZqjDBYqgyappeRbRNyA3o=;
        b=Ce7rOeL2quuaLRin2zL49AvS9sHl4sGZt6rQBPfyHr6VMIPPDdeZ3+lHp5zKslzGWsw67u
        nqTxHzw4hPPY4eJ3k39C2MpSQZWQTMWr2cMMeNENo5zWYKgN9Jw1i6ziKYEQymI7zXOAG/
        knehgKr+lTefXFbrU9hU0nzcxJWeAzU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-r7oDA5BQMEO4lZOg875bHw-1; Mon, 23 Dec 2019 20:01:12 -0500
X-MC-Unique: r7oDA5BQMEO4lZOg875bHw-1
Received: by mail-wm1-f72.google.com with SMTP id o24so127959wmh.0
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 17:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wKGwxLX/FCIOtXSJBKDi/gZqjDBYqgyappeRbRNyA3o=;
        b=uQ+cW3ZBzAgNFomfl7JuzrwbmE/bMdQVi7g1SKFQxqP/bDPNwnKQDt+52eMoJQe5T3
         KncRDKUH9C5uU6S6WBBrhDNhE9oyiW1lMgkGp/wEcQ6g6oC/q/KPgY7KGjoJpEdPO2FV
         wG6h3HRypMTl9buK+au6keNFn9K9fIkNgPoFjPSIZZyyubdNgJux5QL6NNd09zJE+WO/
         GrtKwQ+9XahOLz8mAjdI/8xaTzWEF5mkRdobQC1oBZDTbgTWc78HDJ8Z1NwjaX8/deMJ
         iKbdHOe3EakHBHvigJoiQeXWAKHny+mr4ZFFyZZusV9nOPyXTczC10DSotVEJW3uLfm7
         LIRA==
X-Gm-Message-State: APjAAAWegfC2pLXfmwvXRB3szBV/Qo0dlnWxADB8NGpcj19H0IPTMqln
        lv5Lpl5FVARTfp2/zV94rZQlnrGfPanKWlj472Yoo0aHkPbUBbgSCgMgm3y3t8093JSzutU4RYQ
        UZH0V2Vafjthsa8z8
X-Received: by 2002:a1c:a949:: with SMTP id s70mr1259559wme.69.1577149271659;
        Mon, 23 Dec 2019 17:01:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxLJho4Amg3V4idDnN+Jv3dMGQ/eq1KBwy2KoNXgtJ84RpjLjduJdXL7MDCC5i9GKS893LNmQ==
X-Received: by 2002:a1c:a949:: with SMTP id s70mr1259530wme.69.1577149271423;
        Mon, 23 Dec 2019 17:01:11 -0800 (PST)
Received: from mcroce-redhat.homenet.telecomitalia.it (host213-32-dynamic.19-79-r.retail.telecomitalia.it. [79.19.32.213])
        by smtp.gmail.com with ESMTPSA id e18sm22330532wrw.70.2019.12.23.17.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 17:01:10 -0800 (PST)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tomislav Tomasic <tomislav.tomasic@sartura.hr>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Nadav Haklai <nadavh@marvell.com>
Subject: [RFC net-next 0/2] mvpp2: page_pool support
Date:   Tue, 24 Dec 2019 02:01:01 +0100
Message-Id: <20191224010103.56407-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patches change the memory allocator of mvpp2 from the frag allocator to
the page_pool API. This change is needed to add later XDP support to mvpp2.

The reason I send it as RFC is that with this changeset, mvpp2 performs much
more slower. This is the tc drop rate measured with a single flow:

stock net-next with frag allocator:
rx: 900.7 Mbps 1877 Kpps

this patchset with page_pool:
rx: 423.5 Mbps 882.3 Kpps

This is the perf top when receiving traffic:

  27.68%  [kernel]            [k] __page_pool_clean_page
   9.79%  [kernel]            [k] get_page_from_freelist
   7.18%  [kernel]            [k] free_unref_page
   4.64%  [kernel]            [k] build_skb
   4.63%  [kernel]            [k] __netif_receive_skb_core
   3.83%  [mvpp2]             [k] mvpp2_poll
   3.64%  [kernel]            [k] eth_type_trans
   3.61%  [kernel]            [k] kmem_cache_free
   3.03%  [kernel]            [k] kmem_cache_alloc
   2.76%  [kernel]            [k] dev_gro_receive
   2.69%  [mvpp2]             [k] mvpp2_bm_pool_put
   2.68%  [kernel]            [k] page_frag_free
   1.83%  [kernel]            [k] inet_gro_receive
   1.74%  [kernel]            [k] page_pool_alloc_pages
   1.70%  [kernel]            [k] __build_skb
   1.47%  [kernel]            [k] __alloc_pages_nodemask
   1.36%  [mvpp2]             [k] mvpp2_buf_alloc.isra.0
   1.29%  [kernel]            [k] tcf_action_exec

I tried Ilias patches for page_pool recycling, I get an improvement
to ~1100, but I'm still far than the original allocator.

Any idea on why I get such bad numbers?

Another reason to send it as RFC is that I'm not fully convinced on how to
use the page_pool given the HW limitation of the BM.

The driver currently uses, for every CPU, a page_pool for short packets and
another for long ones. The driver also has 4 rx queue per port, so every
RXQ #1 will share the short and long page pools of CPU #1.

This means that for every RX queue I call xdp_rxq_info_reg_mem_model() twice,
on two different page_pool, can this be a problem?

As usual, ideas are welcome.

Matteo Croce (2):
  mvpp2: use page_pool allocator
  mvpp2: memory accounting

 drivers/net/ethernet/marvell/Kconfig          |   1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |   7 +
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 142 +++++++++++++++---
 3 files changed, 125 insertions(+), 25 deletions(-)

-- 
2.24.1

