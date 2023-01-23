Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2476786B6
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjAWTr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjAWTr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:47:27 -0500
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED67D2658B;
        Mon, 23 Jan 2023 11:47:26 -0800 (PST)
Received: by mail-pj1-f46.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so16272575pjg.4;
        Mon, 23 Jan 2023 11:47:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YBsOuBeZmizkCpiObnueSyLNHUyq18ijoTACbxi/qCw=;
        b=Dw9BfdBWliHV0N8cKzHmU8CLiNbimIE/tdLAWWL2geYJrLJfHZmzpKTudxyHmXC8/w
         MXm9B6u068iGXMBcMMzTzAPvtCat3G8V9DgEM/qNYAwS7TBRKDdcXLs8hC+sbZ1E0rAw
         Tm9d3cl6hepYvwmpiZiICAOfljNSSg76t1kQ1q3UsgUS0oDvE8uZ4ULAcaIyhsOjBMeo
         Erw2gu6yfIgHJib6rAwfYBP71OdUeYvEF8yliaGnZA9IWWzidcSeqwN9WHF64L4pD+ca
         H7M/g4Q9htUf3pFcdD/b5A5HzJuit0cORlUXjYEgNi42HCZAEqSdeRnqYyKIz5yqeKjq
         xmCg==
X-Gm-Message-State: AFqh2konTEDyi9BJTSOo4353OxKTrmdCqH/yzCNn6VbkigySme+HGLDc
        iQhu29cvCyQPjf4JwV6sHGI=
X-Google-Smtp-Source: AMrXdXvfK5mbs8dNd8I/pgphfjpkG9tj7Pxsz/hA5VFQ+HwYWwvNOoHEYzZM9wNmI4uRnGef/Yze9g==
X-Received: by 2002:a17:90a:b002:b0:229:932:a0f3 with SMTP id x2-20020a17090ab00200b002290932a0f3mr27137965pjq.27.1674503246346;
        Mon, 23 Jan 2023 11:47:26 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:dbe2:4986:5f46:bb00? ([2620:15c:211:201:dbe2:4986:5f46:bb00])
        by smtp.gmail.com with ESMTPSA id gd23-20020a17090b0fd700b00212e5fe09d7sm39962pjb.10.2023.01.23.11.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 11:47:25 -0800 (PST)
Message-ID: <771236a2-b746-368d-f15f-23585f760ebd@acm.org>
Date:   Mon, 23 Jan 2023 11:47:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [LSF/MM/BPF proposal]: Physr discussion
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     lsf-pc@lists.linuxfoundation.org, linux-mm@kvack.org,
        iommu@lists.linux.dev, linux-rdma@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev, Shakeel Butt <shakeelb@google.com>
References: <Y8v+qVZ8OmodOCQ9@nvidia.com>
 <Y84OyQSKHelPOkW3@casper.infradead.org> <Y86PRiNCUIKbfUZz@nvidia.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y86PRiNCUIKbfUZz@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/23 05:44, Jason Gunthorpe wrote:
> I've gone from quite a different starting point - I've been working
> DMA API upwards, so what does the dma_map_XX look like, what APIs do
> we need to support the dma_map_ops implementations to iterate/etc, how
> do we form and return the dma mapped list, how does P2P, with all the
> checks, actually work, etc. These help inform what we want from the
> "phyr" as an API.

I'm interested in this topic. I'm wondering whether eliminating 
scatterlists could help to make the block layer faster.

Thanks,

Bart.

