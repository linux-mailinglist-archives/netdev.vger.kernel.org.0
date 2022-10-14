Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD555FF02C
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJNOUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJNOUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:20:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E16F4F7098
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665757233;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8iRx1e3Y3wWmfF79dg/olnU5QxZWjiaBpPqoqESj6CY=;
        b=YW44v+FYOj/e07U/hbDRtEIGf/kCVkFrIOJSTqqv+PEL6O0DWyGQeTp2npjJxFNB34/5oV
        I39VIvrNMo7W3wYrEf8w+4Mu7a4AmUFRF9lJwACxB3I2+iwoRH6p89kVlmOPI0SXoggjW9
        gPwbHNPJYZiJz3rcICrQ0pCBK2Z+bp8=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-509-_HoRCy1mOeyRGMBNU_7oFA-1; Fri, 14 Oct 2022 10:20:32 -0400
X-MC-Unique: _HoRCy1mOeyRGMBNU_7oFA-1
Received: by mail-ej1-f72.google.com with SMTP id dm10-20020a170907948a00b00781fa5e140fso2540599ejc.21
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iRx1e3Y3wWmfF79dg/olnU5QxZWjiaBpPqoqESj6CY=;
        b=UQMvZZqfaRrK70KlBYWvcINAsrEGO+WqIpaNC2PTdungmPbDYTX4YFsoJJV3TUIsUE
         8CLXaWl9NroEYkpegx63ErLQUvnN2OtcpNgf7w0GDu0y0ty9o9mTM9stjBKtAIuELVus
         h32OjL+kLgToFAZFeGw0Dm0cevXzXapJ/V2zf8gQ1Qnni+tXrmGKUbqanmGCE/oHpBF3
         PxLAY3Hv2NxwhJtU2+OWsadyQ04Q/KjpgJhKphtulHoX5XkOC6nx47wypdC8KScUGews
         F2S/SfmLurE8IL84q694SLA+HlHH3p89zMRldogdCrElod2Sjcpfvc1qr9qdRCEYWR8c
         z8CQ==
X-Gm-Message-State: ACrzQf1/5YKz6iec7hdpH9n76uiDX7Sy/Nd/nYloJSEHOI4OUIbu8B0j
        pICL09Fzn+Qi0lExgIWecu5eZsz7WPkacdbLderFs/tCNP4vob4nFAfYUzUpcZmAMXZYo3VLAVl
        tLXTxqalOCKHI8hlw
X-Received: by 2002:a17:907:a047:b0:78d:9b73:79bb with SMTP id gz7-20020a170907a04700b0078d9b7379bbmr3649817ejc.657.1665757231606;
        Fri, 14 Oct 2022 07:20:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Kl0HwOhXBUINYotiiUAayun0AWiLkjBw2XLRcxYrEKii/8SrSg8AmD0Hgxq+SPi+lkeVz0Q==
X-Received: by 2002:a17:907:a047:b0:78d:9b73:79bb with SMTP id gz7-20020a170907a04700b0078d9b7379bbmr3649801ejc.657.1665757231416;
        Fri, 14 Oct 2022 07:20:31 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e3:3300:b7f8:ebb0:9b02:7d37])
        by smtp.gmail.com with ESMTPSA id p18-20020a17090653d200b0073dd1ac2fc8sm1553784ejo.195.2022.10.14.07.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 07:20:30 -0700 (PDT)
Date:   Fri, 14 Oct 2022 10:20:27 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] net: drop netif_attrmask_next*()
Message-ID: <20221014102008-mutt-send-email-mst@kernel.org>
References: <20221013234349.1165689-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013234349.1165689-1-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 04:43:44PM -0700, Yury Norov wrote:
> netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
> is enabled. It is used in a single place. netif_attrmask_next() is not
> used at all. With some rework of __netif_set_xps_queue(), we can drop
> both functions, switch the code to well-tested bitmap API and fix the
> warning.
> 
> v1: https://lore.kernel.org/netdev/20221002151702.3932770-1-yury.norov@gmail.com/T/
> v2: Fix missed bitmap initialization in patch #3.


does not seem to fix the warning
https://lore.kernel.org/r/0000000000001d91e205eafc3d01%40google.com

is it supposed to fix it?

> Yury Norov (4):
>   net: move setup code out of mutex in __netif_set_xps_queue()
>   net: merge XPS_CPU_DEV_MAPS_SIZE and XPS_RXQ_DEV_MAPS_SIZE macros
>   net: initialize online_mask unconditionally in __netif_set_xps_queue()
>   net: fix opencoded for_each_and_bit() in __netif_set_xps_queue()
> 
>  include/linux/netdevice.h | 53 ++-------------------------------------
>  net/core/dev.c            | 35 ++++++++++++++------------
>  2 files changed, 21 insertions(+), 67 deletions(-)
> 
> -- 
> 2.34.1

