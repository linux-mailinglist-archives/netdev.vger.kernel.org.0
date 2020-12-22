Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7712E0BF3
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgLVOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:43:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgLVOn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:43:57 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9152FC0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:43:17 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id d17so18545345ejy.9
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l51Vl/66zJ59AIPEZGKyMy6YACsuq5hw7uT1znpJ0dE=;
        b=CVGm6Cmk+eM5bpPpG/5c6ZL7HLaiNW5hnM92js7n0EevDWCa97C95e6aZX6WPkJApp
         FKX5eMr2yaMOmae7NBQpd6fun/rkPL3te9xjyHtW2/ck2IPE+1FxGPJia+p7yrgd6ROt
         +tdUqUI8P5VHcVmvx7BLQMQJV9VW0VvtpJB0z0ZQtzpDIRK6GP+awLoAZFKLEJhXkTxq
         +lbrbuss7cxKpeHTjTloQ1AqtVsMUPMvSMiZsQ3rOXj6LWjwp98r5osXZOmpv8+qDzZS
         wdwGYd439gVFb9lfpAMZP9s6VkvUEhLGI+30IurmFJfmmqSlMxcm7wr1rLflGUGcIWwE
         DfiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l51Vl/66zJ59AIPEZGKyMy6YACsuq5hw7uT1znpJ0dE=;
        b=I4UFgVh2baVPCo3obOj96TOJXFlKNW1l9jWV2/0GPiCl5bug9Xs+jWrxmqggrf8hzY
         cuziJr/hEti1YlVfMaLtFO+yBDDrln/ZNVFkdDbDttBd0jhsDzN4s03Pz8B9G8kIP3Lx
         tpdDtgnKW4zV8FxDE758H9IW9e/QTIxwtJBKcfIJTPyIMPmBu0QOco0CSTsI7pdPqtHy
         d8pHA9n0OhUZHxT5XnRPBMoxhjAyY5EgYHd6TqVqXIVfvkUMbyUBqAsk4u14T5MQ7VRQ
         Nxt9Xzo2wlBWI68MnTqInWTGpRjZhm3U8A89rQcvhg7aF0Psniigm70Z9t9BXRxd6M2Y
         /4cw==
X-Gm-Message-State: AOAM530sKwLd20zkK9BCdRTtg5PmY8KXPurgMrFtyHPfVYsYdOqOMVIQ
        Ea6ALDgH7ZQmTEHfmTl8vgXu10OlFoyBbuNZbmU=
X-Google-Smtp-Source: ABdhPJxff63UIip4gtTWp23jgbTm2ELtibD4QurCSC0/9PR5lHs3j255hgn6mr0/DB/4Lw5XxKmwNvoFSh2YAIKp0T4=
X-Received: by 2002:a17:906:30d3:: with SMTP id b19mr13820060ejb.538.1608648196367;
 Tue, 22 Dec 2020 06:43:16 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-6-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-6-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:42:40 -0500
Message-ID: <CAF=yD-L0uqGHp3u0Oi_eJYZAJ2r8EeaWihiKbK3RVwSTLK87Dg@mail.gmail.com>
Subject: Re: [PATCH 05/12 v2 RFC] skbuff: replace sock_zerocopy_put() with skb_zcopy_put()
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> Replace sock_zerocopy_put with the generic skb_zcopy_put()
> function.  Pass 'true' as the success argument, as this
> is identical to no change.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

uarg->zerocopy may be false if sock_zerocopy_put_abort is called from
tcp_sendmsg_locked
