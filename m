Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0891CDC47
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 09:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfJGHND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 03:13:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38238 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfJGHND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 03:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CUxXi74mQTtzR35BL4cV3ysUkx+e3F2IaA4sSCsQ1w0=; b=oaiTg5Jfr2qIin/88nwbfCE7L
        uhSnvSqzmK92pzaP5TgWj+s9a75vvEh2WTyGFBq4bhJrlnynwHbU6MJDw92N4uvtFA/XTgVZ2sRar
        +GHtKq29NR4QVhZlPlaj3AY+LXRCiwQhD2DCZmZ2Lda/GPpBclR50eyUgalEWkJQdQ8D8DNQCb87W
        E0K+B8kAF86E86Fi+znk75LfDnUzoWIsIz6IaSUl3fnnIbwNVdjJ1OdxoCC0HL3dvuls8rhokz8XM
        budvjyIpXpmxb/cwu6rzcL/8BeL3KKXhtczOgAcpoNgKG27XwdGx4+raO+5PaSaArqKh7QxnGyREn
        EKTCOsbkA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHNCY-0003wh-6k; Mon, 07 Oct 2019 07:13:02 +0000
Date:   Mon, 7 Oct 2019 00:13:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yamin Friedman <yaminf@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 2/3] RDMA/mlx5: Add capability for max sge to
 get optimized performance
Message-ID: <20191007071302.GA15034@infradead.org>
References: <20191006155955.31445-1-leon@kernel.org>
 <20191006155955.31445-3-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006155955.31445-3-leon@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 06, 2019 at 06:59:54PM +0300, Leon Romanovsky wrote:
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 4f671378dbfc..60fd98a9b7e8 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -445,6 +445,8 @@ struct ib_device_attr {
>  	struct ib_tm_caps	tm_caps;
>  	struct ib_cq_caps       cq_caps;
>  	u64			max_dm_size;
> +	/* Max entries for sgl for optimized performance per READ */
> +	u32			max_sgl_rd;

This either needs to go into what current is patch 3 or an entirely
separate one.
