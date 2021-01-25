Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108593049CE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbhAZFXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:23:20 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:21372 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730892AbhAYQsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 11:48:19 -0500
Date:   Mon, 25 Jan 2021 16:46:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1611593227; bh=VZmsQgsGD/2KxVsDk2CgN0UPiozU/OwIb092ldM9UwI=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=QDBwMIqEu/ITPMltyup2y+v8iLaO4QNWPB6K9HIAhdhe39c9a/Wn0TTBHho5ovptq
         RWf8zFxHjJHha5tTlwwn4J9qpQS3tZwfqjq/D1TTwvWZMQR8/8mCGuOGwIuRHtZbGH
         BmrcrWS03XzTmRVRlJki1jbhWYyV6im+kKGM4T8V32on+fRG9oZElnS8JclK6UvQzR
         03gspPI1DhAzE3n/nus/4HktPXehSZ7wsM1ALoyvn7/OvxYNdCVwG3NP01er+dJDcl
         qdzAIojEWdnwIi/WNFK/hGJBZrWJQVC0Zm8DbWpmOIhPC2yIUQUIi4LIzjiH8rWjqU
         6QwaXqYlzAQ/g==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org,
        Alexander Lobakin <alobakin@pm.me>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next 1/3] mm: constify page_is_pfmemalloc() argument
Message-ID: <20210125164612.243838-2-alobakin@pm.me>
In-Reply-To: <20210125164612.243838-1-alobakin@pm.me>
References: <20210125164612.243838-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function only tests for page->index, so its argument should be
const.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 include/linux/mm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ecdf8a8cd6ae..078633d43af9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1584,7 +1584,7 @@ struct address_space *page_mapping_file(struct page *=
page);
  * ALLOC_NO_WATERMARKS and the low watermark was not
  * met implying that the system is under some pressure.
  */
-static inline bool page_is_pfmemalloc(struct page *page)
+static inline bool page_is_pfmemalloc(const struct page *page)
 {
 =09/*
 =09 * Page index cannot be this large so this must be
--=20
2.30.0


