Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A85B67F288
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 00:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjA0X60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 18:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjA0X6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 18:58:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E049F70D54;
        Fri, 27 Jan 2023 15:58:24 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so6175440pjb.5;
        Fri, 27 Jan 2023 15:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rO313v24AJrMc3K3kp7GIC4oc88I2uUQS5zObcxa3DM=;
        b=lU4E0o2OxaHIEdzlGJyWUL0HngJwIgo+n1LE7HEiZeUkiq4scAL6pyA5/ZTzPIObdJ
         JUGNT7IFNE6jHSl9VndTJVidaXN7mlyj/Y/QUgUWN0JaO1dVLNYkZdK/BVok79Qz7SWs
         x1VMwj607og8tfefBil3DKELuOTCm8lKpjFptAph2VnqW6ucd7OKAlrIy+BHGM7IRRyA
         S1MJW69620UMCz6PbWEKHWAukc5tdK9ta8HvTmMYnr7atxArXuy7BwwCn0E2sl5zzrxb
         TMVlQ76/MJIa2DL5AfPsAX+k0nHV2uLpuRiKDKbOmZDTcH48jL/9iif6Dtz9v66A31C9
         mWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rO313v24AJrMc3K3kp7GIC4oc88I2uUQS5zObcxa3DM=;
        b=rRQVSBqrO67+1BH69hKK88ZkUvbeM9on8W+v43y4v/5ZeYE6Xe7lkBOqN/IrIJzSF4
         T6DF4PyOwvlduSWGpLeP0zwDUkVcd6vo9obftXJQVW8mjTBBsbSYojkhfbUzjhKXJ1O4
         EWwgSdvJPuI0zNqz/VrxUylkZYye3l9AwFTYBjcAtuvNiyw0iTEfdaU6Niu20Bt39r4C
         pwYlLoovfHY/gBX5CJM3tziPOXcr1i7LgtrSkoHt3I842RaplScYmsjzvtZzZQ7tGcB9
         Ea8ArDOK1CPf51Pi37yBrxaPXyZSTWBDTcxznlFg/b7a4fr0eXDkTR4GLRui84IoxL+o
         ICjw==
X-Gm-Message-State: AO0yUKVDZ5CFm/YLRnXMaQXpR3wSSToDbuiieEGc26uOhTggoEkRpzUi
        gs8YaXHNjSAUuq4eB2OVApY=
X-Google-Smtp-Source: AK7set+0NO+j3Eiwlhntu7gqb4REyiI3+6vfvcm5EBJzCVRRgBm4i2aypM3AYWgmRMrP0a5NjBrEOQ==
X-Received: by 2002:a17:902:e482:b0:191:7d3:7fdd with SMTP id i2-20020a170902e48200b0019107d37fddmr22949ple.60.1674863904327;
        Fri, 27 Jan 2023 15:58:24 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902b60200b001948cc9c2fbsm3401169pls.133.2023.01.27.15.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 15:58:23 -0800 (PST)
Date:   Fri, 27 Jan 2023 15:58:20 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: ptp: add one more PTP dependency
Message-ID: <Y9RlHIqbVNG7SoDw@hoboy.vegasvil.org>
References: <20230127221323.2522421-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127221323.2522421-1-arnd@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:13:03PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When only NET_DSA_MICROCHIP_KSZ8863_SMI is built-in but
> PTP is a loadable module, the ksz_ptp support still causes
> a link failure:
> 
> ld.lld-16: error: undefined symbol: ptp_clock_index
> >>> referenced by ksz_ptp.c
> >>>               drivers/net/dsa/microchip/ksz_ptp.o:(ksz_get_ts_info) in archive vmlinux.a
> 
> Add the same dependency here that exists with the KSZ9477_I2C
> and KSZ_SPI drivers.
> 
> Fixes: eac1ea20261e ("net: dsa: microchip: ptp: add the posix clock support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Richard Cochran <richardcochran@gmail.com>
