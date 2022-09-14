Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D2C5B8249
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 09:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiINHvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 03:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbiINHve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 03:51:34 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FCB72EFE;
        Wed, 14 Sep 2022 00:51:23 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q11so7208633qkc.12;
        Wed, 14 Sep 2022 00:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=gdXKGj9UVTzuUiW5uUdlSuJRenGy+NzCqxW+E3MayDc=;
        b=pu0zULfYPDmGATtFEVxA/ovR08fqreDUy27T8WPwd3RWNm5Nvd0zYYp8RtxLZOiOiO
         wzwmun1tLkSi/P7mhYpA2TgLywo2P3Lqe4CgDdldLGN0FcO0QBWnNR3Of80mGvPW8eKQ
         ERAstnZLUDgWQJ6UNpLIj5LdG0JQcerfPDHQArA29lYjNPhzVS9qat/piy7wmoU5ZW+v
         /96rNozxDF9g+qUCO5WvW409EMw8/FI0/hfz+fSjp35h2meYw2V1Vm60rs+ly+pFgRMG
         F6J50Pb4PrR5NF23IvZSjHxqiYBO3mw+nopEiUYDHXCkO7w/ButX0axtZwfM39GvyT/q
         y7kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gdXKGj9UVTzuUiW5uUdlSuJRenGy+NzCqxW+E3MayDc=;
        b=YcxL/WaWlTjYLEwHcfSRehEgo4qeHDCbzJIfG4/7+Yr/lMvkvykB0pXTaanlU3edC6
         +jer9JkuyaczJ5zozKGQm5W/LqWjosCHpWG/mipqFLX5AD5zOXVOtwpPHBPUHQrzG+0x
         RA9+qr+F6L+vwN7WwuivNj5PimYt8JR/SX1Vu2XFXzGWEsDEnT2nW9usccCMoI1cPCxD
         7QHWbxhAs0TAYpjKzX6w9bidxCj7MKPl5LGCt9e/PfFbFOMUkhneHO2D6q4d7PWHHNm/
         gHnzGaeZd6nVKRFshe/gTIuc6s/ftEAe6ggeSqr5G/DCzoiP2IjRUaVU93vXlX6A1gF4
         ZfHg==
X-Gm-Message-State: ACgBeo2c8WpJemL0XgOjSyoVh5VSHrU77rubKZbsrk+dsdDuss8IwZFq
        uO8igJwccSkd0OaLR316VWQl5ziemQ==
X-Google-Smtp-Source: AA6agR594kpnbfFsrBU/yBAHj+HZ6+J9FMKtbzG+cn9iF+3JDnuqGRp4wmbYLMO8i1y4tEWPOQR/3w==
X-Received: by 2002:a37:4349:0:b0:6ce:4c0a:3abc with SMTP id q70-20020a374349000000b006ce4c0a3abcmr8408010qka.706.1663141882298;
        Wed, 14 Sep 2022 00:51:22 -0700 (PDT)
Received: from bytedance (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id i10-20020a05620a404a00b006b98315c6fbsm1455786qko.1.2022.09.14.00.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 00:51:21 -0700 (PDT)
Date:   Wed, 14 Sep 2022 00:51:18 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: Use WARN_ON_ONCE() in {tcp,udp}_read_skb()
Message-ID: <20220914075118.GA17613@bytedance>
References: <20220908231523.8977-1-yepeilin.cs@gmail.com>
 <20220913184016.16095-1-yepeilin.cs@gmail.com>
 <20220913193050.GA16391@bytedance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913193050.GA16391@bytedance>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 12:30:50PM -0700, Peilin Ye wrote:
> On Tue, Sep 13, 2022 at 11:40:16AM -0700, Peilin Ye wrote:
> > Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> > Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
> 
> Sorry, I forgot to add Fixes: tag.
> 
> Those WARN_ON() come from different commits.  I will split this into two
> in v3 to make it easier.

Cong suggested not sending v3 since this is not fixing a bug, and thus
no need to add Fixes: tags.

