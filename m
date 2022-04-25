Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D163050E927
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbiDYTI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238763AbiDYTI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:08:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA37221E06;
        Mon, 25 Apr 2022 12:05:51 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id bx5so6475319pjb.3;
        Mon, 25 Apr 2022 12:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8BTa2zUpGurx+0zTiTi5KLzMhsEOnJ4yDviZ2KNo380=;
        b=TkM9nwho7iyu/T36e2WC2dsmKOQej6nKiy3Rw9KRdZTew1l17p9vqHA7RyPLhE9mra
         SAcZVegNyhwvv1jKWSD3L5b0qPmxn+kOKROoAnzzxDRbTKJ3VSgAzPVPzysOL1AY93iK
         zJ+o6CwXpfK4xoPUQIYogLtSVi0uVCztWnVTQXJ27JZq9v7n6EdjQHimfGBz/ZnkYPFn
         h5pqmnyuDParbCz40b8PxMt89In5fXzrWjEskyQHYQvzNzhTzciRUTg6NiCA2kIUITaj
         yTe7da/kSYX6lxpfU+UMnA721US4IUnUD28YdDVBjNrv1EDGFHCDrD1KYwj3gKFIcIbz
         Pmuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8BTa2zUpGurx+0zTiTi5KLzMhsEOnJ4yDviZ2KNo380=;
        b=r/kH0r1piYq1hYW72ZdsGbqXuRTPbsknfMHPnva6WcxRi95qLKDSPptPCjhyG7dTyv
         06SwQhwtT2D/E/viyDzkECLkAgb2y9sdog49jw+z9uPuTg15qrjBZiV6kXZHrehlJUHS
         zp9dtnabZo4DKOd6zK8B5ZMIEhrGKQGLMGz3I6e/ilz8lSNwZjRb/EkO4UlwEICbJdtZ
         /C0n5yAQNU9hauo8jx8N21q8AMDAXhOJzExRzmtcLtNitMWpz4JxjgkqZlda9FheKBCs
         EDA0aPsQBqn4mTN2ITVzrlD4hBAqe7g53kAn61Qu3oyhxbVKTLQW+h1uYwke3rq2EGqk
         1h/w==
X-Gm-Message-State: AOAM532DbbwSu2UdDA8ktxXJa3fMcS8M3eH6FxxIXxtQukY7OEH7kxvC
        fNU3mPu4I5Slqf3t9TJBDQ==
X-Google-Smtp-Source: ABdhPJx5ynNtHJwOAQ9bAmgn9hP4sqAmb5Qu/oBN5mn3mXKdYPvWPQQ2V2O+iwMzn23d/SSovaP2iw==
X-Received: by 2002:a17:90b:1a8a:b0:1d2:e93e:6604 with SMTP id ng10-20020a17090b1a8a00b001d2e93e6604mr33218316pjb.233.1650913551187;
        Mon, 25 Apr 2022 12:05:51 -0700 (PDT)
Received: from bytedance (215.178.194.35.bc.googleusercontent.com. [35.194.178.215])
        by smtp.gmail.com with ESMTPSA id x36-20020a056a000be400b0050a40b8290dsm12006538pfu.54.2022.04.25.12.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 12:05:50 -0700 (PDT)
Date:   Mon, 25 Apr 2022 12:05:42 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Make [IP6]GRE[TAP] devices always
 NETIF_F_LLTX
Message-ID: <20220425190542.GA40273@bytedance>
References: <cover.1650580763.git.peilin.ye@bytedance.com>
 <20220425110259.389ed44b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425110259.389ed44b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Mon, Apr 25, 2022 at 11:02:59AM -0700, Jakub Kicinski wrote:
> On Thu, 21 Apr 2022 15:43:42 -0700 Peilin Ye wrote:
> > This patchset depends on these fixes [1].  Since o_seqno is now atomic_t,
> > we can always turn on NETIF_F_LLTX for [IP6]GRE[TAP] devices, since we no
> > longer need the TX lock (&txq->_xmit_lock).
> 
> LGTM, thanks, but please repost on Thu / Fri. The fixes make their way
> into net-next on Thu so until then we can't apply.

Thanks for the review!

> > We could probably do the same thing to [IP6]ERSPAN devices as well, but
> > I'm not familiar with them yet.  For example, ERSPAN devices are
> > initialized as |= GRE_FEATURES in erspan_tunnel_init(), but I don't see
> > IP6ERSPAN devices being initialized as |= GRE6_FEATURES.  Please suggest
> > if I'm missing something, thanks!
> 
> Probably good to CC William when you repost.

Sure, I will resend then.

Thanks,
Peilin Ye

