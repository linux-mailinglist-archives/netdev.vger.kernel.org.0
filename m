Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9B25793D9
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbiGSHJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbiGSHJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:09:28 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EC825C54
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:09:27 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id b133so8938154pfb.6
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXMGWlNaGaOEHet64VswotUi5kCwecaKee1diV6zcXQ=;
        b=icNyjmrUFEPWKJ9lW8Kd4eDsVQcs+r18uNqi31F35PxlI8ovtdBOoHm1MQyp0CAKnm
         xWjjqeugNMtIO+DdY3Fr9jv8VOPRVa3XJLawh+r0TCLyCrZvlKVOHU5KlBIWFz+JTgS1
         qMy/8kQSuCnnB2peWZQgFUYOnCNWwAVDZRE9fn74cxOTNQVwuHST6WLlNPI032wC++A+
         sUHkXNqPxfvvecEQ+77AkWzGmF3/DS4NnKUNe/xM/rB2Jd+uRRX8snZJIMtwoD3/Llzv
         nwh3CN8oq+HX6tmzSedmvoD5GY2SMkJN5YpV4wZDaNAohPiBJ28yRMhd3pSkkOkY9SKY
         7oVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXMGWlNaGaOEHet64VswotUi5kCwecaKee1diV6zcXQ=;
        b=WSqghclZWyE5rJHO66Q/0lqwe5IQa7mcic+bqqDaVddELjhrgN1dzV3SFgZ+ZxoIyL
         lcIPjyASSgCUZEch3/HczI5VdYc4QbzJTMJvE6G4bf3Aj/u05CcTIBcYht58433xoN+7
         HI822lcxidcXCwbDyAfk5Wo52GdjUYO55EhH3X1f7RIvKfpbJjK4sCu8jQIICYmg/rL7
         KbOMFlKacbe6DSn0B9Vxp572UwDN8zRy/bbLOYiM+barcwNM4nMECGOez173OYuSduUi
         tcHP54Ph4YivqbPd8TD/F/MhWzZqDZ4bhpiHdCjERPaQnUgDi8mNiv/d9IIizlN0XY+q
         goKA==
X-Gm-Message-State: AJIora+r8oKt+/KkYfXHmLRunhE3UGKAADhFpVA/9s8JjkSHei0W714A
        0YqPr0oYjDMSU1JlS0X9OYQiGcz6LE0PcVEJ3QmZiw==
X-Google-Smtp-Source: AGRyM1ugzNLQi0rPMC8GvnlXU+zRu+f6X8i33wsJMSEbll2UDL6KImst2IKiZGBlC3hlC5sT7k6cNaTMz8S0LbSkJa8=
X-Received: by 2002:a63:1246:0:b0:41a:58f:9fee with SMTP id
 6-20020a631246000000b0041a058f9feemr11975545pgs.413.1658214567052; Tue, 19
 Jul 2022 00:09:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com> <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com>
In-Reply-To: <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Tue, 19 Jul 2022 10:08:51 +0300
Message-ID: <CAJs=3_CQmOYsz5N0=tX-BKyAuiFge3pfzx9aR46hMzkcP7E4MQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing support
To:     Jason Wang <jasowang@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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

Hi Jason,

> This seems an independent fix? I wonder what if we just leave it as before.


Before this patch, only ETHTOOL_COALESCE_MAX_FRAMES was supported, now
we support ETHTOOL_COALESCE_USECS as well.

ETHTOOL_COALESCE_USECS is meaningless if VIRTIO_NET_F_NOTF_COAL
feature is not negotiated, so I added the mentioned part.
