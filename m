Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5CF6AAC5F
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 21:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCDURm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 15:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCDURh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 15:17:37 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBBD1A97A
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 12:17:34 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so5427447pjg.4
        for <netdev@vger.kernel.org>; Sat, 04 Mar 2023 12:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1677961054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUaF2/cQyGgMHhHHAZ1X0lvpVBqaw9k25ZM4oArX/p0=;
        b=MGEJacBybDXKzXEfk2/LdGcMTcMrBC/41jhRCw9HOJCFstfNUPMY/biW+3by/Zx6en
         2wojZHlUR5bP0idHEMlE4QyaRFUZ4q+8YVqxtgWDMOVM4vkQsDwOBJ4QzRfBxImZu+ZX
         040xhhs7l86ZPQVc1ExATldwi4B3mYCc0jTkwBbUgfkqP18dIs/cQGDFWxmwdh5yrY8I
         dB0Kuu5K4jRikt/9xZNmE+ZBR8E5z4PWPIsi6Y+be59K6TN6laxQe81eTBQMG0OgXeDz
         jRkEzcYXNyLW7DMQ/X55r/uwLOhPv7SxYgwYDZQwIITEuPUVvW3Bs1PrMW0uid0rwhe9
         4Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677961054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUaF2/cQyGgMHhHHAZ1X0lvpVBqaw9k25ZM4oArX/p0=;
        b=Jwgcf/LDN8u1cXgponXUBFRBgD31788QFdy+8kj7qbJ/G+FahLuQihrLPMtHgp+rYU
         lpvlnM1ICZpD9jD7Yn9/n3TcRN/w9woO3bfI7eiob/fSOVpsY7QJ9jC61E+bMLbz7++J
         EUZ6TrpFpMjTW7of55vTD5xIVYBp8OiT9ks2QgF2G3ouOBj7VUxjqrjiAe0+5tRO2481
         duZ4O4ashYjFZ/DUpZQhi7SOEFU4duBHuTgPJfff2DgXn8vNAhN9JFNTmLn0cR199e4g
         3mGAb9poNxzyOnpRHSsA3uzejioAFTkczrEM+j/wNGdIcr1wVzw+QODURAuVmJgcfHC0
         9TWg==
X-Gm-Message-State: AO0yUKX1jOtZ4S9Yx2ETEIJmHCI91s8CAHdDDO80wIvrF58g+rvhsvRU
        8e2L+vksSerfpMm00P+oTFqBolN4V/SZzcX+YPvVtQ==
X-Google-Smtp-Source: AK7set9YR9416BdqD0TU4Ki0FVYzCFqwjP0jNHmGnZiQUthwhqq3ld6eyR7npcS96ScpZcZawvIl2w==
X-Received: by 2002:a17:902:d4cc:b0:19b:dbf7:f9ca with SMTP id o12-20020a170902d4cc00b0019bdbf7f9camr8204282plg.0.1677961054107;
        Sat, 04 Mar 2023 12:17:34 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id lg16-20020a170902fb9000b00192a8b35fa3sm3687682plb.122.2023.03.04.12.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 12:17:33 -0800 (PST)
Date:   Sat, 4 Mar 2023 12:17:32 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v1] netdevice: clean old FIXME that it is not worthed
Message-ID: <20230304121732.3d102b7e@hermes.local>
In-Reply-To: <20230304194433.560378-1-vincenzopalazzodev@gmail.com>
References: <20230304194433.560378-1-vincenzopalazzodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Mar 2023 20:44:33 +0100
Vincenzo Palazzo <vincenzopalazzodev@gmail.com> wrote:

> Alternative patch that removes an old FIXME because it currently
> the change is worthed as some comments in the patch point out
> (https://lore.kernel.org/all/20230304080650.74e8d396@hermes.local/#t)
> 
> Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> ---
>  include/linux/netdevice.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..82af7eb62075 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2033,7 +2033,6 @@ struct net_device {
>  	struct dev_ifalias	__rcu *ifalias;
>  	/*
>  	 *	I/O specific fields
> -	 *	FIXME: Merge these and struct ifmap into one
>  	 */
>  	unsigned long		mem_end;
>  	unsigned long		mem_start;

These fields actually are only used by old hardware devices that
pre-date buses with auto discovery. I.e ISA bus not PCI.

Since ISA bus support is gone, either these devices should have
been removed as well or they really aren't using those fields..

If someone wanted to clean this stuff out, start by seeing
if any of those devices still live. For example, the E1000e has
a couple of variants and dropping support for the non-PCI variant
would be ok.

All of arcnet could/should go away? Maybe move to staging?

The wan devices might also have been ISA only devices that are now
unusable.
