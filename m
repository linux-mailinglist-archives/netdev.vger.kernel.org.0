Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E262309C22
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 13:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhAaMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 07:50:17 -0500
Received: from mail2.protonmail.ch ([185.70.40.22]:45536 "EHLO
        mail2.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbhAaMMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 07:12:39 -0500
Date:   Sun, 31 Jan 2021 12:11:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612095102; bh=Ykp5oBUQqC+epeovOARUFyMIlBz94OtNSxnarlpoxCM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=LJR8R1X2kFUuhJewwMRVd3JmaazqCi9JsjdefF2SfLX05I5/jCfUIZc11l6MuTL+g
         i2HRMCEoZW525NoYLuMFEhfi5Ff4oJag2t4PUqvGxfO/UeX8QeM09STbyYmmrADfiv
         d38pZbH8Aw0/L9PXz4Cj0AuTmTscavwrO/hApgtreB+QxjqPu7STFPDYf89SxgYW2l
         BwgzfpPv0NXCY9a8JwzqiNGowkucW/e4I1nM9oTv4eKTRyDzY5vAmyWDokdDtpadYh
         mPnb0wI0VKahgRNsSolhFuKmahSWnIIFEIJRgthufSr718lYZg4Q7e9VIIzUli3fIQ
         4a1lSZhgJ4HNw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        David Rientjes <rientjes@google.com>,
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
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v3 net-next 2/5] skbuff: constify skb_propagate_pfmemalloc() "page" argument
Message-ID: <20210131120844.7529-3-alobakin@pm.me>
In-Reply-To: <20210131120844.7529-1-alobakin@pm.me>
References: <20210131120844.7529-1-alobakin@pm.me>
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

The function doesn't write anything to the page struct itself,
so this argument can be const.

Misc: align second argument to the brace while at it.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/skbuff.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9313b5aaf45b..b027526da4f9 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2943,8 +2943,8 @@ static inline struct page *dev_alloc_page(void)
  *=09@page: The page that was allocated from skb_alloc_page
  *=09@skb: The skb that may need pfmemalloc set
  */
-static inline void skb_propagate_pfmemalloc(struct page *page,
-=09=09=09=09=09     struct sk_buff *skb)
+static inline void skb_propagate_pfmemalloc(const struct page *page,
+=09=09=09=09=09    struct sk_buff *skb)
 {
 =09if (page_is_pfmemalloc(page))
 =09=09skb->pfmemalloc =3D true;
--=20
2.30.0


