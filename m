Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83836C86AE
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjCXUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjCXUUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:20:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE121ABFF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:20:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q15-20020a63d60f000000b00502e1c551aaso1083538pgg.21
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679689199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FwIrTKE+ycLy1x+ByJ2A3bCqPV1twbLrBngNhTDxlXs=;
        b=suSyGZnrDjGVZWYbAYta931LgmufArgLwuf6r+l1ioO27gnWD6e143DL4gqr+K4KL6
         6tM5jTejHDHQmtQtKv4TBwhId9iah8dpK30lB0R6RsQbc4zPy8oZb69OGa02IcCfw8aH
         QgdCJLk0X9slLZW+uU6mVrq1tL4g8KiQDTzQqI33uZIpdzCfj2lJh+oDQnua/J8dXaaI
         CaCol24G2KkWjJdlixF+GIkVSi0WmEkuzbWXnr1CHkShl+h1EQWgKc9G7bfvZH12/HSG
         Ab5GkA9fGJKq7maGnpcsrEF5EQVjrJFULeLKoEIvTfa3UtVp8hhz2pUaKCOu1KUNhjVL
         L14g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679689199;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwIrTKE+ycLy1x+ByJ2A3bCqPV1twbLrBngNhTDxlXs=;
        b=BoF0rTj0hBAigYaVQsRrakY8Zw5EWiyNZEXO6IJQZKGsDYJgwBI1KlpQcWUKYP0nV+
         DlRjyWoGuvJYk/vF6Hoyucu4B9HMEzY1Ol7JwBfcFk74VjVT2A9+7M0l4ZHqnntNNOV6
         f72Q1XS3TuaBG6jtZa/XOzlPXZS3JxFVVr4niExUAWoj9vuePjYlihcoN9vC8KHGbuVn
         LdIKE9nlhrw0KC8qFWNxhnjaOu9AtreV9MeIs7YAfS1uVQ4t0wtvAwfHq28W4L/vql6O
         iepqxLVJ8jtl01gfMrQ1/VDUcfoxwRJ/mpW/K1wkiSP/rBG5mWSXvpTW2uTpUsIRQO2c
         mWjA==
X-Gm-Message-State: AAQBX9dJ1m5vupV+VuTFb6w2XOqnRm6Aj6SM7b7GjvJXRyPDjFzrQUoz
        1ySQ1D1928SYZPQObUSKp88YGcc=
X-Google-Smtp-Source: AKy350Z29ZoVrWmrdIMeawuQf6UltmMXOimch/S6jGfYve9LeVX3JAldaglQ3ajlhoR4fTwBaC2f3LM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a65:4986:0:b0:503:25f0:9cc5 with SMTP id
 r6-20020a654986000000b0050325f09cc5mr932313pgs.2.1679689199649; Fri, 24 Mar
 2023 13:19:59 -0700 (PDT)
Date:   Fri, 24 Mar 2023 13:19:58 -0700
In-Reply-To: <F75020C7-9247-4F15-96CC-C3E6F11C0429@avride.ai>
Mime-Version: 1.0
References: <F75020C7-9247-4F15-96CC-C3E6F11C0429@avride.ai>
Message-ID: <ZB4F7l0Nh2ZYwjci@google.com>
Subject: Re: Network RX per process per interface statistics
From:   Stanislav Fomichev <sdf@google.com>
To:     Kamil Zaripov <zaripov-kamil@avride.ai>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/24, Kamil Zaripov wrote:
> Hi everyone,

> I trying to make a BPF program that can collect per process per interface  
> statistics of network data consumption. Right now most difficult part for  
> me is RX traffic.

> I have tried to find some point in the sk_buff's way up to network stack  
> where I can extract info both about the network interface which captured  
> package and the process that will consume this data but failed. So I have  
> to listen events in several points and somehow merge collected data.

> The last point I found at which sk_buff still contains information about  
> network device that captured this sk_buff is netif_receive_skb  
> tracepoint. The first point where I can found information about process  
> is protocol's rcv handlers (like tcp_v4_do_rcv). But I have some  
> questions, to finish my program:

> 1. It seems that sk_buff modifies during handling, so how can I "match"  
> sk_buff with same data in netif_receive_skb and in tcp_v4_do_rcv?

By "modifies" - do you mean the payload/headers? You can probably use
the skb pointer address as a unique identifier to connect across different
tracepoints?

> 2. Maybe there is some good point where I can attach listener and where I  
> can extract both process and interface info for each package?

Nothing pops to my mind. But I think that if you store skbaddr=dev from
netif_receive_skb, you should be able to look this up at a later point
where you know skb->process association?

> Regards
> Zaripov Kamil.
