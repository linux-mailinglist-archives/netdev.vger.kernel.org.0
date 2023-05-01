Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 849656F2E5D
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 06:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbjEAEZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 00:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjEAEZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 00:25:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3144191;
        Sun, 30 Apr 2023 21:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0YL/opZmy6D0wjx7A8o7ZcsEGCKfXNZJ75ginpuSzuw=; b=Y7nL4ulLqm1u2O5DHyEVGk2KE1
        V0WIAEzeJCx+NCsEzIfdJBY6mTo0ysz+ebtV/5UuhKLnsdm9Km75Ikft9XAAF0YnKVtnTnPBI7IgV
        9LV0OEUecPd4Y6TXU34DmgU96BgX7im+NXHkYbBE/zCjfP2QVK2MxF8Ocu3SWj0Psk1jWVQbBnEja
        vuWTyC3vkiHr3lzxqQdIKCWyrNEHs2ah9m31KEaaZsdVKo7CW8YbKyAs4BmtCpfAY2cGWsdYJ9H44
        FGZg3QY3d6THw4r5+u6OadhB/l+XRwW+6oUGQqJg4fx+cuk56Cg1iX67z9yNw6P5PIsZnIQVBS7o7
        MUeediDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ptL5o-00FECq-2k;
        Mon, 01 May 2023 04:24:52 +0000
Date:   Sun, 30 Apr 2023 21:24:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH vhost v7 01/11] virtio_ring: split: separate dma codes
Message-ID: <ZE8/FC4ONDLshya2@infradead.org>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
 <20230425073613.8839-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425073613.8839-2-xuanzhuo@linux.alibaba.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static dma_addr_t vring_sg_address(struct scatterlist *sg)
> +{
> +	if (sg->dma_address)
> +		return sg->dma_address;

0 is a perfectly valid DMA address.  So I have no idea how this is
even supposed to work.
