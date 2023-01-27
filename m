Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F48867E239
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjA0KvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:51:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjA0KvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:51:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E7377505
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674816623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e6QQWJJDFfvuR34r8vo62794czTYXTPwwmv4OKhg8IA=;
        b=gYcdtwNR2wI++jy9X/9geDBlCnkMIjdufZMqYbSqCUMZ52zTe80DAEWU2xPbyiudlPvh2j
        Zushb+2frL/Fw7BMb7MSEtwQp2283RZnGx9SfUt61Q0hycbiyNEqgf74lyI90yFr8zMoTk
        edi/Bd6KVoQhHHA1U9IYOKP7Bskxs9I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453--OOwFuqTMEi4tJ0vBnlzfw-1; Fri, 27 Jan 2023 05:50:22 -0500
X-MC-Unique: -OOwFuqTMEi4tJ0vBnlzfw-1
Received: by mail-wm1-f72.google.com with SMTP id fl5-20020a05600c0b8500b003db12112fdeso2577708wmb.5
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:50:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e6QQWJJDFfvuR34r8vo62794czTYXTPwwmv4OKhg8IA=;
        b=T11762R/GFchsK0K8znLEUwgmVSx92lJ0vh8kocrl18RQNnEoUmhK+DF4jX1yyXQtA
         r7LQMWhKQI38k0v/ts9G3ADAldJR6WdGTfKVtEZkZUkC6oWEmJkNWdpLLekg4lmom7M7
         +646Uma02DEKUqlRnN6tVBJ2weYU/B4dgMQ6zLZ0jitVdyG1Wh/YXgUeapp6UDS2VTKa
         NpFoftpoiLSAY5mk6Qqpy/sv9x4BAVTSi5BPyow5PIVxqYXJz6iknEZYgmuDOjr2KJHt
         tW6L6iotS2SpJSb/vKn6xNIIRfiQ/lhaAd5PuF1ME0WSK1b2A9ycEv8fqqoGjqMEEBtT
         wKig==
X-Gm-Message-State: AO0yUKV5uU8LTyKHhTFNW1XO8US6tVA5KDP/VOcfxI7Pa8ohx5B922wA
        LYFdLrQQbzuiGiMTziF3rh5NrbK1+ZpdvNPSPcOhRAJt+yKvBqD7ZK8M+Aaluqr4VLEvoj0uB+f
        /FUQvUpXe6C+ii8tw
X-Received: by 2002:adf:b101:0:b0:2bf:bf27:2dd2 with SMTP id l1-20020adfb101000000b002bfbf272dd2mr6551714wra.45.1674816621130;
        Fri, 27 Jan 2023 02:50:21 -0800 (PST)
X-Google-Smtp-Source: AK7set/7lgmtf5rOocNhu0ReRu5wt0w+ADtDEaMdvPhhFUBbTuaomhkLfU7JRAPfl8uNkgHKB61G3A==
X-Received: by 2002:adf:b101:0:b0:2bf:bf27:2dd2 with SMTP id l1-20020adfb101000000b002bfbf272dd2mr6551695wra.45.1674816620853;
        Fri, 27 Jan 2023 02:50:20 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id e7-20020adfe387000000b002be15ee1377sm3698377wrm.22.2023.01.27.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:50:20 -0800 (PST)
Date:   Fri, 27 Jan 2023 05:50:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        jasowang@redhat.com, ioana.ciornei@nxp.com, madalin.bucur@nxp.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net v2 0/5] net: xdp: execute xdp_do_flush() before
 napi_complete_done()
Message-ID: <20230127054959-mutt-send-email-mst@kernel.org>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125074901.2737-1-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 08:48:56AM +0100, Magnus Karlsson wrote:
> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be followed by a xdp_do_flush() from the
> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found in [1].
> 
> The second reason is that the XDP_REDIRECT logic in itself relies on
> being inside a single NAPI instance through to the xdp_do_flush() call
> for RCU protection of all in-kernel data structures. Details can be
> found in [2].
> 
> The drivers have only been compile-tested since I do not own any of
> the HW below. So if you are a maintainer, it would be great if you
> could take a quick look to make sure I did not mess something up.
> 
> Note that these were the drivers I found that violated the ordering by
> running a simple script and manually checking the ones that came up as
> potential offenders. But the script was not perfect in any way. There
> might still be offenders out there, since the script can generate
> false negatives.


BTW all this series is stable material, right?


> v1 -> v2:
> * Added acks [Toke, Steen]
> * Corrected two spelling errors [Toke]
> 
> [1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
> [2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
> 
> Thanks: Magnus
> 
> Magnus Karlsson (5):
>   qede: execute xdp_do_flush() before napi_complete_done()
>   lan966x: execute xdp_do_flush() before napi_complete_done()
>   virtio-net: execute xdp_do_flush() before napi_complete_done()
>   dpaa_eth: execute xdp_do_flush() before napi_complete_done()
>   dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
> 
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c        | 6 +++---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c      | 9 ++++++---
>  drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 6 +++---
>  drivers/net/ethernet/qlogic/qede/qede_fp.c            | 7 ++++---
>  drivers/net/virtio_net.c                              | 6 +++---
>  5 files changed, 19 insertions(+), 15 deletions(-)
> 
> 
> base-commit: 2a48216cff7a2e3964fbed16f84d33f68b3e5e42
> --
> 2.34.1

