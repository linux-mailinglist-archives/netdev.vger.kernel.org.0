Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966635776DB
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 17:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiGQPBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 11:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiGQPBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 11:01:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6279EF5A5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:01:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t5-20020a17090a6a0500b001ef965b262eso10374593pjj.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 08:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eHmxskJR4C6TrLAX5qPZZkTkW9agqDS2T3FWMmXfkOs=;
        b=a8cOiQC0DCjG++sCm+lo9zYRG3/RLJWKeZt0xMXTV+NzTSR4cmfK0kpPFBDQoieOiB
         N8Xe8gi0U0fbjJ5rX/esGIxkd+AP1l4LugekZ4XV0iyWVhqNzlD/Vq8ZSFWti9Bkzy4Z
         rAwUxX6AsWekBXKJBoQZ4lnPySO7taxQbyYCoULnciy4d51F5dZfGVtxalVQOSA0MnCI
         +EJLrMUX/txLNm2nEpGEwcHE3H0xj4AyplCEyUU8fzdVcSYTnIHoHLBDsh9v6BsMATNV
         aVxqncReYGDcxrw7Zezch6bREdNRNujz5p2hOgtbnHDJqZov5P2mu/UkqHrhtvfZz7CL
         WUkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eHmxskJR4C6TrLAX5qPZZkTkW9agqDS2T3FWMmXfkOs=;
        b=jJeqgO6SL79BPHDWZi/tRkQy1NsUL0tauDyAS0Wx+YXUAUJDiYYwJ8jQoZVJrKfxBe
         x+0A4j4QPToJ3b57boP0P9PDchqG36PAnkYzWidFeBtKXr0PqakIr7XOjAk52KAiZ0mj
         89HuinlHFOGepKwykAOXTObkLC/MmxAw3l4ADwI4riyQW+D9212Z+neC8Ci4ULxqgS2r
         P7GEOQ5RczAonSF7pIJ9rr5vgdcR1uOYihagTNwaadwqeAqIH0MCMzGI3uRrBqJpj1bq
         OkKs6n4g8qBg8cGhybZFVikWIQ7O3vWzfQiB+g3nmlGrFgrhRy+4l6HCDSY2X1Ut3xU4
         g+ng==
X-Gm-Message-State: AJIora93JAF9qKfh8pXIECp/KzLp+glbbSGgZXU2IrL3hJ+6ymtvWV2K
        UkDJC7MOCt5I8eaX6aCrQ8gGYRYrnXStVQ1I4pg0/Q==
X-Google-Smtp-Source: AGRyM1syc+GP1SF+bI/UDP8GCuuNPwkwaCydzNjVO7ErSWwcv7TCAyeQYWQqXfGPoNRuIN2JlYGCPi3imZfvtdy+eow=
X-Received: by 2002:a17:90b:17c1:b0:1f0:1fc9:bcc7 with SMTP id
 me1-20020a17090b17c100b001f01fc9bcc7mr34268562pjb.53.1658070071768; Sun, 17
 Jul 2022 08:01:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220714142027.3684622-1-alvaro.karsz@solid-run.com> <CAA93jw6Z2vfh3cAVbmnHTsvbfNoqhdjdfAjrbKDyCeV9wHHv7w@mail.gmail.com>
In-Reply-To: <CAA93jw6Z2vfh3cAVbmnHTsvbfNoqhdjdfAjrbKDyCeV9wHHv7w@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Sun, 17 Jul 2022 18:00:36 +0300
Message-ID: <CAJs=3_DbPS9LpDFavP867udnDgRUywDBLJyxZYX1ZbfGmLrQTQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v3] net: virtio_net: notifications coalescing support
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

> What are a typical range of settings for these?


This entirely depends on the user, and the values are set using ethtool.
$  ethtool -C <interface>  tx-frames X rx-frames Y rx-usecs Z tx-usecs W

> Bytes = time.  Packets nowadays have a dynamic range of 64-64k bytes,
> and with big TCP even more. would there be any way to use
> bytes rather than packets?


This feature should follow the VirtIO spec.
The parameters are set with ethtool, so we should use the defined
ethtool parameters.

The parameters are set with the virtnet_set_coalesce function, which
is the ethtool_ops set_coalesce callback.
