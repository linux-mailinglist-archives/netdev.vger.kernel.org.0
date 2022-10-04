Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A8A5F46B1
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJDP3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJDP3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:29:40 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3076CB73
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 08:29:39 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c24so12974943plo.3
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 08:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=nUL++0YrOYbJH41lSNmtuJxacmngBwCLovlOvSL11Ig=;
        b=ulsx/+XspxWuKPRcjNEAJd2ZO+D5ZkL81pDBqHkyEnvxo/b+WtFVCTCkGdEOLCbv71
         3+6TvnN/Ijg0UMtzwYMglPeeBcLFOSqglCT5yhBBfZ0uSnfdUM7f4n4bPFqR5xo5JTkM
         DsKVf/xWua2m/9BpE9subFfd4Tw/JCuMzzkhxVLBUBRzBeibJYzqAkw8mMaQ8MyJRWQK
         3rspifJH8Jf2iwsnUEtAa+zyhvkTteWqPjHbnP3E7qB+0QLzLjfuz8ha8ULHKmG5UjZY
         fz45gQN7a/ZuNBvS2hVXe7HxjRijdTH6dU3uLqEC+L07VPC0q6ErtpS1ZrgmSPtcR9lU
         a4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nUL++0YrOYbJH41lSNmtuJxacmngBwCLovlOvSL11Ig=;
        b=B/ozlMd1Q4SvNjUh0cxsIc07hv4ttXp6NpVpXlTpA3cXE5x+ApV2KfwuCeB/aOxuBJ
         Sf3YaV9iOsxipaHIqLe8rvlDaWjF7Jsv3Pex714ST7IX3pafskgJh0R1WU87TbBF0Pq+
         qnp1IDpnytGVhLBUglxbURFHgynLzK6RdUgHHltjdk1+twkv6EobIMWdu/4MhCnRe2ZK
         G2duNek3rSL8UM6jf9JnFQnm5N6iwUAlI4srQHbixr090tMt2BWQu12lIuZhRjqT+Yvj
         T8ZGOoNDrGuyHS54ORq4gejEAhhG3FzmQOfrRdhZkTmKNSFdzIy2XyHDGZbI72xvW96W
         nf+g==
X-Gm-Message-State: ACrzQf0f8TKQePVZxHokfJYrGnryHIfiNgvm3Sx7zxsD4BzyJLeYPdF/
        GBqiZulICRG7kREKi+NigvD0MA==
X-Google-Smtp-Source: AMsMyM6tSkfKGnSMw+t++Suvs7KT14XyVMsN2c8nid0Q9jzlfgmlAuLvTLOohKpnN20t8Zx9Aie7XQ==
X-Received: by 2002:a17:90b:4c8b:b0:203:5db5:8b71 with SMTP id my11-20020a17090b4c8b00b002035db58b71mr280183pjb.51.1664897378665;
        Tue, 04 Oct 2022 08:29:38 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id px9-20020a17090b270900b002009db534d1sm8158299pjb.24.2022.10.04.08.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 08:29:38 -0700 (PDT)
Date:   Tue, 4 Oct 2022 08:29:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] net: benet: use snprintf instead sprintf and IFNAMSIZ
 instead hardcoded constant.
Message-ID: <20221004082936.0d0c9bcb@hermes.local>
In-Reply-To: <20221004095034.377665-1-pkosyh@yandex.ru>
References: <20221004095034.377665-1-pkosyh@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  4 Oct 2022 12:50:34 +0300
Peter Kosyh <pkosyh@yandex.ru> wrote:

> printf to array 'eqo->desc' of size 32 may cause buffer overflow when
> using non-standard IFNAMSIZ.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>

NACK
Non-standard IFNAMSIZ will break uapi and many things.
I see no reason for kernel or tools like iproute2 to support or
fix those related bugs.
