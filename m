Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4473B76BE
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 18:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbhF2Q6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 12:58:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232176AbhF2Q6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 12:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624985764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2NICKy+eY6u9v6U5C5rPMzRkfmDNI+XJLW4LIKdeOM=;
        b=VgXgZxLX6Re2snoYVLU/w9QJhBDQkwUsSU9tT/7r7j8yBsc+Z4Z0dK+T1ncIrwpz8pqG7D
        ftRA7mIQj3kDlSgzi/uAyb+aZKZlxGazHFN61hDzKw2X9my8GKz1ay4dahbPd3ZIuuLgzB
        etmfZe+fbJaTiQyctOp9C0Z1+/DL4OA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-gKV6Ww_mN0OfrtvD0A6CTA-1; Tue, 29 Jun 2021 12:56:02 -0400
X-MC-Unique: gKV6Ww_mN0OfrtvD0A6CTA-1
Received: by mail-ed1-f72.google.com with SMTP id j15-20020a05640211cfb0290394f9de5750so11167671edw.16
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 09:56:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=q2NICKy+eY6u9v6U5C5rPMzRkfmDNI+XJLW4LIKdeOM=;
        b=rr+hucG0E1SGhPsE0y7l7dic4sl6zHJkX1pPd9MyiU895W+KQWqFd9GdGhaTKn19jX
         HGcbsUoB9Pbo/wHk9vEjUe0y4byD0Y2SXgCt6fkq80w6/EsmhxqkbCMAQXdu5/7J7PiZ
         Lzzk91bxKRZQo7hjqxnhq8Y4NnjOwPGbbbKt+Sju1mWU+Z/yOvPQC2dOdhH3UCO1fF2f
         PxmbFSv5gqbiFqSZMt/CjfVmYUL16b+NC2XedejLzovkf6e5SUwhTfmKtIzEmHOCb127
         lPOKpRuOJ1TNAjabUTiduxi+SgXqueqqO49Ti4T/M1Q8Lt0nM6Xo0vkWBvm5T4guklsp
         SXSA==
X-Gm-Message-State: AOAM533kV7eKShkGg5/9zslil0ewvM/cSGK1LfsIaAeY4IY2roXMwDPI
        CCK9Qz79qtSZ0f0WJma2vZGepZ4e2DD/OGXXD7cCrcEgm70pugXCKZ7lKNOCngjLgMw2QkKpjaQ
        aorPsfvt/o07PXvNf
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr10497264edd.326.1624985761638;
        Tue, 29 Jun 2021 09:56:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6JX0kG7OliK+69WwEBKZuT8U9A5MzKTXCdCtoFvyGEIz/VAikmU9KP1H/PmK4CJpy/7zJHQ==
X-Received: by 2002:a05:6402:51c9:: with SMTP id r9mr10497251edd.326.1624985761526;
        Tue, 29 Jun 2021 09:56:01 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id gv20sm8656803ejc.23.2021.06.29.09.56.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 09:56:01 -0700 (PDT)
Subject: Re: [PATCH net v2] xdp, net: fix for construct skb by xdp inside xsk
 zc rx
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Krzysztof Kazimierczak <krzysztof.kazimierczak@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20210617145534.101458-1-xuanzhuo@linux.alibaba.com>
 <20210628104721.GA57589@ranger.igk.intel.com>
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
Message-ID: <f5ce5610-443c-a2d9-43ef-d203f9afb0d8@redhat.com>
Date:   Tue, 29 Jun 2021 18:55:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628104721.GA57589@ranger.igk.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2021 12.47, Maciej Fijalkowski wrote:

> +static __always_inline struct sk_buff *
> +xdp_construct_skb(struct xdp_buff *xdp, struct napi_struct *napi)
> +{

I don't like the generic name "xdp_construct_skb".

What about calling it "xdp_copy_construct_skb", because below is 
memcpy'ing the data.

Functions that use this call free (or recycle) the memory backing the 
packet, after calling this function.

(I'm open to other naming suggestions)


> +	unsigned int metasize;
> +	unsigned int datasize;
> +	unsigned int headroom;
> +	struct sk_buff *skb;
> +	unsigned int len;
> +
> +	/* this include metasize */
> +	datasize = xdp->data_end  - xdp->data_meta;
> +	metasize = xdp->data      - xdp->data_meta;
> +	headroom = xdp->data_meta - xdp->data_hard_start;
> +	len      = xdp->data_end  - xdp->data_hard_start;
> +
> +	/* allocate a skb to store the frags */
> +	skb = __napi_alloc_skb(napi, len, GFP_ATOMIC | __GFP_NOWARN);
> +	if (unlikely(!skb))
> +		return NULL;
> +
> +	skb_reserve(skb, headroom);
> +	memcpy(__skb_put(skb, datasize), xdp->data_meta, datasize);
> +	if (metasize) {
> +		__skb_pull(skb, metasize);
> +		skb_metadata_set(skb, metasize);
> +	}
> +
> +	return skb;
> +}

