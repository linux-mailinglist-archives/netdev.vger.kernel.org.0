Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46235521897
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiEJNjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243333AbiEJNfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD2612BFBF3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652189090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrQk331dY+acOKtsHio4tuTM5tl4Z2AS4qgsAPiJY2U=;
        b=ZMYUhcFxH76k9VKPpFikqzFnp14g0x0uRua7+Ua9L+euwb+gKfZTtwWXzG/Hqs3EFSvpQ6
        Da6ACRYguzluNX2Tgyx7G8tp2fJ+pRlklrnZyNlPQix8/zS2rG3t7A3ehsBgFY97+bd3Rw
        HDS9DW5WxYWvuAzBi+8xrqBG2BJZ0i4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-oYy4iUNPNg6uZix-OC4hIw-1; Tue, 10 May 2022 09:24:49 -0400
X-MC-Unique: oYy4iUNPNg6uZix-OC4hIw-1
Received: by mail-wr1-f69.google.com with SMTP id d28-20020adf9b9c000000b0020ad4a50e14so7015633wrc.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:24:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=qrQk331dY+acOKtsHio4tuTM5tl4Z2AS4qgsAPiJY2U=;
        b=J+TaURaRpsUwQ1UM15rbOGeOlsDkTDk8AJLeyimNSptnZ4lfyGzAefx92En160FoGC
         yD0qEebZRJkqUtVv4J8n6wXbiF75ykl3myG3BEobIJd7Zj3nNJIhsxc6JoBYTpAYCAWJ
         wDsX4aImiFIbJKU1zgfeq73kyCrjD0X+smXunyuGV/FjliTFsyDbbe0v0gShy5agBssM
         +JYpMw9jRdw/ta3JamaoCanbUZAryshPQBdkzXnI6/6hzV3eVKCZzPp9RBYbQwwVADzS
         8DvsygnsvzLU/QpgxlytxBpV9iqH1F1xvpQjfei8+7D8RhubMBGsakVNAg3pJvGcbuz1
         Iu6Q==
X-Gm-Message-State: AOAM5313Mph0uYlA+dtULsuXS8EDbK6tdWU3u2EzJNOU/vVknzG1RS4d
        pQWubbDBvmuv3DSkrArIjlkxxHSQKTAoUuuWKomQBTwIV8KEOr+vRcLakeejsgz0aw10KkkXvMK
        clt2583dOeYViRtYO
X-Received: by 2002:a7b:c341:0:b0:37b:c619:c9f4 with SMTP id l1-20020a7bc341000000b0037bc619c9f4mr52520wmj.38.1652189088026;
        Tue, 10 May 2022 06:24:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqwwogMAcS1Mjth3MHCVBlRUf2i94V/nGy/gavPvqLn2BGjAVyi0GQ29U+7t2tPijI+iv5XA==
X-Received: by 2002:a7b:c341:0:b0:37b:c619:c9f4 with SMTP id l1-20020a7bc341000000b0037bc619c9f4mr52495wmj.38.1652189087788;
        Tue, 10 May 2022 06:24:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d654b000000b0020c6b78eb5asm13892257wrv.68.2022.05.10.06.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 06:24:47 -0700 (PDT)
Message-ID: <19e704ace63483a765a3298610218c5d110bb0e4.camel@redhat.com>
Subject: Re: [PATCH] net: macb: Increment rx bd head after allocating skb
 and buffer
From:   Paolo Abeni <pabeni@redhat.com>
To:     Harini Katakam <harini.katakam@xilinx.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, dumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
Date:   Tue, 10 May 2022 15:24:45 +0200
In-Reply-To: <20220509121958.3976-1-harini.katakam@xilinx.com>
References: <20220509121958.3976-1-harini.katakam@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-09 at 17:49 +0530, Harini Katakam wrote:
> In gem_rx_refill rx_prepared_head is incremented at the beginning of
> the while loop preparing the skb and data buffers. If the skb or data
> buffer allocation fails, this BD will be unusable BDs until the head
> loops back to the same BD (and obviously buffer allocation succeeds).
> In the unlikely event that there's a string of allocation failures,
> there will be an equal number of unusable BDs and an inconsistent RX
> BD chain. Hence increment the head at the end of the while loop to be
> clean.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

This looks like targeting the "net" tree, please repost adding a
suitable Fixes tag.

Thanks,

Paolo

