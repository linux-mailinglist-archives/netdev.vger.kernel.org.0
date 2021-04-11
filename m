Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C535B5DF
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 17:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhDKPVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 11:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhDKPVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 11:21:52 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F10C061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 08:21:35 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id g38so12145115ybi.12
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gZdYxGjM5vS4dJgv0fgZ/TigJ4XDAhlJO5G9vI9SLR4=;
        b=KRh4TWatW1ReO35QFMWUqn4uWKKPMdqnAIEXI3QzH1AIRs9aGAFZuUpoOjd315Yf//
         Sfk1ZSmQV4gNzmmECso56PaWuJWAUhP0u9cxrLR3XUHiuLXCsthZvUcFBAkBPjcQk/3m
         rC1jBtnga/MCJVqAJtOWenSpoWW5VwdIbTHqVWl1tRcN9vvJj2bU8kpHD1T940txPZNZ
         liMxNA/Drd+H7s/t6cyKWfuE2B2jKjfa7bnyiSDg/I1ZHmA43ue1RUQNVWrOZOGQyFNa
         9fqzU3oPBe3l4acfG/HXixDuzcAHjFnJrWU2jkcqixydbhm7UnoSzCKlGY2PZdjEqMT5
         YolA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gZdYxGjM5vS4dJgv0fgZ/TigJ4XDAhlJO5G9vI9SLR4=;
        b=cSlayshvNd8UIo5kHK8nPxV0ZYxiaGRfvnzM+q/dkixE7C5jIPw9iT1B6vlDoRh5Aw
         qZvynSJMAovoIe82Oyh8J1sKEiSkB7du7H5oMkr2BM/MPySg/11HxOd/rioSVA2wGDnO
         7A2+lumXgU2NI9wZi2QqIowy60lEmRzipYGeZ1Ac2w1esmwdpXONtDv1tqNF8MKKbwq9
         +outWzBWek+bGsDKumABNIxmAlYRCqZQDN2shPecwhS9lpkDSA2o1NsVWewLXBS06xQj
         9GAWteKu+BgAvwaF489hrJ5TJV9Mwtew2EAGJ/qXgg5f1OZfargr/1H2F2T9Pvbzxp7h
         SR+g==
X-Gm-Message-State: AOAM531nOjBaoNeLMD9nAO65oEQi+cxd8C6lTVC2zYHLIMoIa4JQwpBb
        s803z/O/l5phGoo7ozgM/lkXElXoBGQg0eSmSDBeFw==
X-Google-Smtp-Source: ABdhPJz8YH5NXe088h2/Zx8aB0WnSxN0iV//khlFG5X5+aDsg1oeDdChzJKeRT18LUlRAggNwvOmhH6NM/X/j53OkLs=
X-Received: by 2002:a25:e89:: with SMTP id 131mr9205440ybo.132.1618154494670;
 Sun, 11 Apr 2021 08:21:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210411112824.1149-1-phil@philpotter.co.uk>
In-Reply-To: <20210411112824.1149-1-phil@philpotter.co.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 11 Apr 2021 17:21:23 +0200
Message-ID: <CANn89iL43xRD6CYrJbUDoaXYhDQ+FAh5fAMn3d3LaDgi1uz9iQ@mail.gmail.com>
Subject: Re: [PATCH] net: geneve: check skb is large enough for IPv4/IPv6 header
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 1:28 PM Phillip Potter <phil@philpotter.co.uk> wrote:
>
> Check within geneve_xmit_skb/geneve6_xmit_skb that sk_buff structure
> is large enough to include IPv4 or IPv6 header, and reject if not. The
> geneve_xmit_skb portion and overall idea was contributed by Eric Dumazet.
> Fixes a KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f
>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks !
