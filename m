Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A71B5913F3
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239350AbiHLQf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237693AbiHLQf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:35:56 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A59320182
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:35:55 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f3-20020a9d0383000000b00636d99775a2so906104otf.2
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=RaZRmh4qD37WDJAm/GBBNfMWSmmYy6aJ/s4pv9g6m0g=;
        b=e0q1USxfIiMFRyzOqo3WGrLIPCBFX5WNF2BJVHH8+IZzjDUcbEqqQt8dwUH0k+PTht
         gkv/37Yy0KWOuFXSyG4rpwd438oD6Q2vW2txBJ4m2X1XNRr2p2pfdQaYbrfVmp5IWZqQ
         Ubm0hyKo3iLyu98LRRnHrbi6KLwuI179xTr/g5ZbK3SwpguzOUceBNKeVqFZEQJJUbda
         WHpgOSvLTz6mNCrZfSyPh5cBcs6inQoZXlBb//RPjX4rClXqh2bWl9Us6VU8EUuIhp/G
         sWBRbKJHLmfb5CPWlzAEkvId3U2IoThqQsX6E5EsQABgIlda24C8r+Zo6aHAzduNyRiD
         +Dsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=RaZRmh4qD37WDJAm/GBBNfMWSmmYy6aJ/s4pv9g6m0g=;
        b=OfxXUjIDXfae+9mdWtWVMfyKV7N9vQ76CXwtyy4VbJFkQhtF2I0/HKRhXnjTkRgMWF
         Ml51hkx6RLnt/zIKT5u51kZQMhMOr4nFzp9Fajpmv0Ugq4UJAZ3Drpl/s2onaQSxlUxW
         OMGlraIwW1keIMxliqIuDVmboIhONtoh4r+CcMqBtQN6fYFXMgqnkkECxgGzdqqfpyBP
         f1gjjh+uVfHvl6JpIucpGdOHUzIEwCrfpd/NL4ZxjBXfPbEX9AkTrpLY2WILFkCGdTV0
         p5xxZzBF40v3YMDNWfgK3l5W4w+fzVtlelMGZ/ymR6GghGugntEu5eyELJzgrXVInyqg
         pQFQ==
X-Gm-Message-State: ACgBeo3vaB5NXuID5zLK5Vej5uMs0yXdP5uvf2kfSZjxDeqQfPi6LhVx
        Gey9OND0JeWf14Z6GLWzwv5HWiHvPmIO4CnlJ3g=
X-Google-Smtp-Source: AA6agR4J6OS0WK5FxNzB1jAkrTrKh9v9fnU+1LrWwXZT7DTJGj/bN6IT57B/c6abGUggNcb9afAGlevC5qmeuvJTscE=
X-Received: by 2002:a05:6830:630f:b0:61c:7c8b:ed18 with SMTP id
 cg15-20020a056830630f00b0061c7c8bed18mr1773096otb.168.1660322154791; Fri, 12
 Aug 2022 09:35:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220812154820.2225457-1-saproj@gmail.com> <YvZ8NwzGV/9QDInR@lunn.ch>
In-Reply-To: <YvZ8NwzGV/9QDInR@lunn.ch>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Fri, 12 Aug 2022 19:35:43 +0300
Message-ID: <CABikg9wm=8rbBFP0vaVHpGBJfXOi4k0bvwK7F+agMXEPfFn2RQ@mail.gmail.com>
Subject: Re: [PATCH] net: moxa: inherit DMA masks to make dma_map_single() work
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Guobin Huang <huangguobin4@huawei.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 at 19:13, Andrew Lunn <andrew@lunn.ch> wrote:
> > +     /* Inherit the DMA masks from the platform device */
> > +     ndev->dev.dma_mask = p_dev->dma_mask;
> > +     ndev->dev.coherent_dma_mask = p_dev->coherent_dma_mask;
>
> There is only one other ethernet driver which does this. What you see
> much more often is:
>
> alacritech/slicoss.c:   paddr = dma_map_single(&sdev->pdev->dev, skb->data, maplen,
> neterion/s2io.c:                                dma_map_single(&sp->pdev->dev, ba->ba_1,
> dlink/dl2k.c:                       cpu_to_le64(dma_map_single(&np->pdev->dev, skb->data,
> micrel/ksz884x.c:               dma_buf->dma = dma_map_single(&hw_priv->pdev->dev, skb->data,

Also works. Do you recommend to create a v2 of the patch?
