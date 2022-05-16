Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D83B527BEB
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 04:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiEPC3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 22:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiEPC3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 22:29:11 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79010F5BF
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 19:29:10 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id a3so5703007ybg.5
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 19:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/QnB2791DS3VNfnONpIROjislrYd0gY3YfBGJ1KQmBg=;
        b=ZLSGab4vzPaSqXTptYYPlNys/2wJ1Fwd1uA0yetf2Fo64ifeka6HqXUm/VGfcivReU
         4FVLSD01jSQ5ajsFD+QcMDfKCwypStNueJI0KN5EV9b+DZpomhZi84n8WD2YlcSeE/Xf
         C6iC2ZxXS2jtue1b6W7t8IKPzxC5veCatbjyYI+4JgRIUE0zXI88znLYr5PKnsV+gdKC
         oxI6gcE29oZF//AS4qHLbNOJXpyX0tbc3Wi0eSMBdIVqYxHZbtytFWCpxv3+WFQZ+Vci
         mUflMRMMbzqWRlXSOTytMyXOuvZxN3klyMgpnuaDQSCo3UlwwMigP1F0Rwi9JwT+qn43
         /0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/QnB2791DS3VNfnONpIROjislrYd0gY3YfBGJ1KQmBg=;
        b=PVKBKMkP2qHwJKgiBtmEdBQEPd+mLXvGCuu+kZTKfTUOPvr6Xb02QlvkbXCBLFW/Mf
         Hg4U6+Ehx3F475F6/kuGE+/QX+dubQ4pjuPEneYLkm7CKLQfxMv2kfmR9z9DjLMbULp4
         BkHgmt5olBCX2NdA4WYaBipsaGpozAJer9mwCa+t0FsH20VxRrwUhLtkmWxINHCsLb8B
         90gobV+TdCOHxRwrnnfYtMa9QJbSNNc4nB58gGoafrm49f4Lwyc4Hdv/uIZXuRcMyA6d
         V+AJaAnRZRfaEw8HDakLIHD0/tHv8E4fvO7Nqx3UwtCc9HobipV+S+GJkaMceligyxHj
         IrWA==
X-Gm-Message-State: AOAM533ARex7XlOh0EU4/ovBhOp9z5VOJ/0X0px6MidXvjSHtrRZqDqL
        G8pKmCIZs/l2nS2rm3d+GrMOXHRVqU3MEHlu9cNSVBsYr+Y3yA==
X-Google-Smtp-Source: ABdhPJxkFWXaMQeWNFASyU+JN1lAeYogHoqfbhk6TpWi0E9dmvENbVxAfSy5DIpkXyhjBZziOK9r/fKgHq1pCYldppE=
X-Received: by 2002:a25:bcc3:0:b0:64d:a7c0:3238 with SMTP id
 l3-20020a25bcc3000000b0064da7c03238mr2889168ybm.598.1652668149418; Sun, 15
 May 2022 19:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <e8c87482998ca6fcdab214f5a9d582899ec0c648.1652665047.git.lucien.xin@gmail.com>
In-Reply-To: <e8c87482998ca6fcdab214f5a9d582899ec0c648.1652665047.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 15 May 2022 19:28:58 -0700
Message-ID: <CANn89iJxX6LMPUEvadqpxHU0XW71cNwKSaggPOAHQwFHxQJYoQ@mail.gmail.com>
Subject: Re: [PATCHv2 ipsec] xfrm: set dst dev to blackhole_netdev instead of
 loopback_dev in ifdown
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 6:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> The global blackhole_netdev has replaced pernet loopback_dev to become the
> one given to the object that holds an netdev when ifdown in many places of
> ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
> blackhole_netdev to invalidate dst entries").
>
> Especially after commit faab39f63c1f ("net: allow out-of-order netdev
> unregistration"), it's no longer safe to use loopback_dev that may be
> freed before other netdev.
>
> This patch is to set dst dev to blackhole_netdev instead of loopback_dev
> in ifdown.
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
