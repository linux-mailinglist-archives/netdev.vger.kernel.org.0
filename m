Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E417F62CF83
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiKQAYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiKQAYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:24:39 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B2163178;
        Wed, 16 Nov 2022 16:24:38 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id kt23so1189621ejc.7;
        Wed, 16 Nov 2022 16:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HFdsqLs7je4oOkfLXUnwsRZehDVieYlbWUW8cGeHsGk=;
        b=dKpzEETPdUuJaiJDM4QfZDmUTQNsrn3XbGn6ofCFuP5uwNZwVY7MwPHo7794zps3f/
         NAnrdhmVwBWCnObEZTdA69Azzcm+bJGELkMCmQ/zukDHbdFx6hxxBMgpBi/h/+F6UnVB
         L5COuBc+8/2clHIcgi+lDt9QHCk7qAQDQjPpLhx+cyMp6nKHAWdy1bLthXy0v+9uCE+0
         tf+sZDzwKf0D+EGoVdnskYL7OBsAj1q1LVpmW+uzG9bLoDKwWSnMK7PXc+vWTzLtpfhO
         hJMofTQr3Fu5eJPnuIO/jVL2/02ySfSydQxrHAS5LwohWB6me3bBGluHy+Cok5LaFgx5
         xIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HFdsqLs7je4oOkfLXUnwsRZehDVieYlbWUW8cGeHsGk=;
        b=XKyrdHuaATOQZTSQgb8X41dSJDviS0F8cKuhFIJ8gMUItJlwAWirs9yjolWeolRDPI
         J6mLjYDzRyQzgfAkD8VyGX7iXff8qUsP1LFjqUg5a14KU29z+E56GXSmzPTx56DffLMY
         VhlBXeV5ZoUgHhZWS4j1uamldAJ+m7plVWWf6Htg7px0wF96r83Y+g4oHLXJUueGgPoF
         dDzcE9VBWxnSamrDQqcIyTWdL/TwXtELVofocAx2rZAZqCANAP9hrCaI4W8jWHSwqp3T
         o16yaMExiPWjZZJtInuP9muBq3I+d+OHZu8h2XpZlP2JqAXh45vumX74xjVPeXABpBXH
         b4PA==
X-Gm-Message-State: ANoB5plEsxFTYCG695cG0+wAnX46gCHEoOyQ5gVYmgScTWwSjDb/Maea
        NuNKzcaEzAsfb9Lq2QR43kM=
X-Google-Smtp-Source: AA0mqf5lNv6pSY5WPSv9bvoYLzpAB5turqhVmeJg9rx3urMPWrljiRWABbtUbkLZ3F78G+6B4zx/3g==
X-Received: by 2002:a17:906:4d16:b0:78b:15dc:2355 with SMTP id r22-20020a1709064d1600b0078b15dc2355mr206206eju.306.1668644676212;
        Wed, 16 Nov 2022 16:24:36 -0800 (PST)
Received: from skbuf ([188.26.57.53])
        by smtp.gmail.com with ESMTPSA id kv7-20020a17090778c700b007b29eb8a4dbsm42426ejc.13.2022.11.16.16.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 16:24:35 -0800 (PST)
Date:   Thu, 17 Nov 2022 02:24:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-11-14 (i40e)
Message-ID: <20221117002433.dvswqnfo5djobpfp@skbuf>
References: <20221115000324.3040207-1-anthony.l.nguyen@intel.com>
 <20221116232121.ahaavt3m6wphxuyw@skbuf>
 <Y3V6OLY6YlljYZFx@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3V6OLY6YlljYZFx@boxer>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maciej,

On Thu, Nov 17, 2022 at 01:03:04AM +0100, Maciej Fijalkowski wrote:
> Hey Vladimir,
> 
> have a look at xdp_convert_zc_to_xdp_frame() in net/core/xdp.c. For XDP_TX
> on ZC Rx side we basically create new xdp_frame backed by new page and
> copy the contents we had in ZC buffer. Then we give back the ZC buffer to
> XSK buff pool and new xdp_frame has to be DMA mapped to HW.

Ah, ok, I didn't notice the xdp_convert_zc_to_xdp_frame() call inside
xdp_convert_buff_to_frame(), it's quite well hidden...

So it's clear now from a correctness point of view, thanks for clarifying.
This could spark a separate discussion about whether there is any better
alternative to copying the RX buffer for XDP_TX and re-mapping to DMA
something that was already mapped. But I'm not interested in that, since
I believe who wrote the code probably thought about the high costs too.
Anyway, I believe that in the general case (meaning from the perspective
of the XSK API) it's perfectly fine to keep the RX buffer around for a
while, nobody forces you to copy the frame out of it for XDP_TX.
