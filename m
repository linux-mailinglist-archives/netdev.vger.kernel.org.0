Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB56441BA78
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 00:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243137AbhI1WhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 18:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238632AbhI1WhC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 18:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C43C613A2;
        Tue, 28 Sep 2021 22:35:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GTNnSeWe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1632868520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPWuglAA+pM+844nfpR7jSxUXxh1nwnrVvWjOJ7zYX4=;
        b=GTNnSeWeXVXzWUZYwytqGwtidlES73nQDNqEv0Txhthvn6/soYVu7jpVRoKxTSceyLyABh
        l0eiF500PpRTBPbQ5+Pb/o5KOq1ZWvl9ndC0D7m3bjKjqADQFIsz6tmpckBCr2fmi66a9K
        sxq/QqLBvC83rFFPGMtSvLazsryoQP0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 6e6ab329 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 28 Sep 2021 22:35:19 +0000 (UTC)
Received: by mail-yb1-f170.google.com with SMTP id f133so954437yba.11;
        Tue, 28 Sep 2021 15:35:19 -0700 (PDT)
X-Gm-Message-State: AOAM532u51S1Asyqy6TBsRup7juomvIKGkfuZ6s56f6cHbjOWS3ryCRx
        aO4yzPhd4B71mNteLrG1MCONhJPG+V4TOyT7+a0=
X-Google-Smtp-Source: ABdhPJztIE1n2egm9kh722hpynruMvz2FLQdgLLwsTr7zzqYYI+rbd0WIEPGD8GMRu5zzbdfTO9bKI0xp9sW6QMkRYQ=
X-Received: by 2002:a25:e792:: with SMTP id e140mr9061977ybh.416.1632868518792;
 Tue, 28 Sep 2021 15:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210928221705.GA279593@embeddedor>
In-Reply-To: <20210928221705.GA279593@embeddedor>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Sep 2021 16:35:07 -0600
X-Gmail-Original-Message-ID: <CAHmME9o7dapX5-aQ76HtXWPmUHJ0GutxSfzWJ9TbpCrkvunt_g@mail.gmail.com>
Message-ID: <CAHmME9o7dapX5-aQ76HtXWPmUHJ0GutxSfzWJ9TbpCrkvunt_g@mail.gmail.com>
Subject: Re: [PATCH][net-next] net: wireguard: Use kvcalloc() instead of kvzalloc()
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

table_size never exceeds 8192, so there's really not an issue with
integer overflow here. However, I checked the codegen of before/after
this patch, and it looks like gcc realizes this too, and so elides
them to be basically the same. So I'll apply this to the
wireguard-linux tree. Thanks for the patch.

Jason
