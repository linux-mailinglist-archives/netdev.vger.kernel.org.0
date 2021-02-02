Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061D130BFB4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhBBNjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:39:49 -0500
Received: from mail-40133.protonmail.ch ([185.70.40.133]:45999 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhBBNbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 08:31:43 -0500
Date:   Tue, 02 Feb 2021 13:30:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1612272656; bh=NakdAHBTDBfMpPGylkZuE67yNEL45d0nvbHsNhM+ASQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=hTkyc/xJhSWuLvTkbdhPeXxd8CVlFW2dw0ecszzPmiYDS+I0+PQH+xqCTDMo/z/Ob
         wM0XDKrep+r1NuokS1sVHFS9rOzr9IA0lKi0kTFRN4Wf/2LkS/lY+USTE4XVV9iuhU
         e0y/X7KVuxOZ2kqI2sU6enEWI+u//whBo7kgYu6KmxX6pRIuhmyXqVv3Fh+TfcfvZ+
         k3ExwydIsux8ua7DwfqLQYvr9FgX5+oUbIfWiVpsT4ujrWzxKIy2RA8Woo9UnD+MrK
         Xa9OWKH6/dilD6rTqVWdc2VLfReoTIzXDcuucrLhPCyrfnIshcm11l9uSJZyFbQpYE
         JMTN8TOSVY6gA==
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
Subject: [PATCH RESEND v3 net-next 1/5] mm: constify page_is_pfmemalloc() argument
Message-ID: <20210202133030.5760-2-alobakin@pm.me>
In-Reply-To: <20210202133030.5760-1-alobakin@pm.me>
References: <20210202133030.5760-1-alobakin@pm.me>
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
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: David Rientjes <rientjes@google.com>
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


