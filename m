Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD0D660246
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbjAFOdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbjAFOdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:33:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF13F809B3
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673015551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FPnjHGl5U2fM4bO0Wa2HwHOnAYb2TV6VJrSUBVf3ffk=;
        b=E2VBPgOzWN1WbLmsObubv5n3TxrssfQiytHvFucNYHjBarV2nzufa00v+W0XNZQIHbqhQY
        MKIeuMFhuQgnnabtShlb6Lb2of7AKJL/DAk83Z47d+it29CD6JdJilPpBt5VmORF1mmTwp
        i40ZXNdBjVzcXYOdSZOBemUV7SzNTuw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-rfCgmrgTNeO33DBkeltR4A-1; Fri, 06 Jan 2023 09:32:30 -0500
X-MC-Unique: rfCgmrgTNeO33DBkeltR4A-1
Received: by mail-ej1-f69.google.com with SMTP id sd1-20020a1709076e0100b00810be49e7afso1250312ejc.22
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:32:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FPnjHGl5U2fM4bO0Wa2HwHOnAYb2TV6VJrSUBVf3ffk=;
        b=glBLKj81cG7zRMR4yif7ut6x44+GAx78qrxjZDYtK+q+WWaAMr+zxV8MYbyyLh8N+I
         X79Sh+UhB5MZKrQUf2j1kkhN1XgCM8GchJNzEfK0BHlP42ZUgVED46GWGjjolM17/d9x
         KaJM5zmiIZjbRbeq6d8suBBRDoVGNrZ/3pLRg7Qex5b08kuRVPz74+FFgEJ4YTM71Eo9
         wQ+BjAaTLtkbFpGWtx1Yc71aBIgy83PS3zU8rM1fbqBN6+1R2vSa3mEmf8ijvX3vx66e
         FDilmNZ62FKVnj0hbXBTizbOIjwWLcrt2HVrWCe1X21ASq0osWBpE5oocr2+4UYABff5
         cEOQ==
X-Gm-Message-State: AFqh2kpKGcMm8tgNKBLSMSQvt1lKXg1kxApUNVnGCwHof/X1eNqbi7Uq
        L0mAuMGlkhFJwvhhsQPlpRDybel8b0xOelXH737HgrZchyHnasWUpLMuKZOe4di9iS6Xt1UsIbd
        z/VShAI8yeQ6SqCqS
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr43804987ejb.15.1673015549511;
        Fri, 06 Jan 2023 06:32:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvnrZ9rpZuKDsvXkAh+SxO/SxiefgC7uDRQP2iQXEJhGPq/Rtujq4Td3f3Dl5oZtVnbPnXK+g==
X-Received: by 2002:a17:906:65a:b0:7c1:7045:1a53 with SMTP id t26-20020a170906065a00b007c170451a53mr43804970ejb.15.1673015549303;
        Fri, 06 Jan 2023 06:32:29 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id ti5-20020a170907c20500b007c0cd272a06sm441154ejc.225.2023.01.06.06.32.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:32:28 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e57019f3-cdc3-4938-dea3-68f2e9d06553@redhat.com>
Date:   Fri, 6 Jan 2023 15:32:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 10/24] page_pool: Convert
 page_pool_put_defragged_page() to netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-11-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-11-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> Also convert page_pool_is_last_frag(), page_pool_put_page(),
> page_pool_recycle_in_ring() and use netmem in page_pool_put_page_bulk().
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 23 ++++++++++++++++-------
>   net/core/page_pool.c    | 29 +++++++++++++++--------------
>   2 files changed, 31 insertions(+), 21 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

