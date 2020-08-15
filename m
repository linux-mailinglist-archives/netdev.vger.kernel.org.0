Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1222D24539C
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgHOWDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728666AbgHOVvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 17:51:08 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1EDC06124F;
        Fri, 14 Aug 2020 22:21:55 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id p37so5517425pgl.3;
        Fri, 14 Aug 2020 22:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6kl9CRsSuMe4k5oZIw9J5TSUS7ssSZkQEzpcLwtOTwA=;
        b=CZUM7UYuw66dEqtL20gVt538tXU2Mcd3v6gBlDG/sqMfeSQonIv/W7kw3D/EHvRDUW
         e37kICOlAtjhdL/k9lqxN9g+TLhDdAsboP+30w5RG8jGhgisW5e9cyJ8+L9yUHBls/Tq
         WMXnOJrZhKmwtWDmcJvZiorWK9uktdLLkPiriSn+ecf5YJ+6jX1kyjE+fBvVwbrBosM9
         oosh7oZJvPHbvGpSQ4OmwRjSeJyQY/q1D3SGVmzJiXAZv2N3Q7DcQyRVDtR2I34U4M/n
         SOkJD9xAzonFoJ4cgZI+Z2EE6egxkHFhYJBvSD7qQ8K4HYRG81jjGZa+96AWY4BhJfG8
         o8fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6kl9CRsSuMe4k5oZIw9J5TSUS7ssSZkQEzpcLwtOTwA=;
        b=fJV/RTHFzyYXynNQ9fTDIZBeLjSeLxba9FOFcqR1MGFmE2/sLwjaGyE+Ts87Pai6Wj
         BR5xYL61KoqnQCKvNd2hLfCn4UOgaiUMyFxrUqKpYcTbi7zRZKco2SpeefBIYhT6Glta
         1Ql2USFHVlaengPvQkccI1WRY9DEipxylrlG9iJ3Vsyo1qQRht4zKKbOqQna+M9xKkTb
         JOn2f48igDGtgtGJdZYgexFipE8ia/cADVOo/3X9YYATucB55vDaH/V2M0zjpgYqHopu
         xIBk2YStiF7xnHhBrs0s2l41eCMKVzeZymGvfaawN93PNtgzN6VAwLvCZgmLUKwDszIw
         XiGA==
X-Gm-Message-State: AOAM530GqEIaBQXF8NDOXN01Hrto3Esv28U05DYnLbB4vtIh2+OxvUNi
        ImFJvfIlolX2QL0gQEr/ZibAtR9mUcGVHyFBeByG1hHy
X-Google-Smtp-Source: ABdhPJzBOzjTopBXgfQKB/kGjN+7/W+gfuhNpLPnV6yw1t5YbixjJXwZ+GEEytDP161ZDgO22zXLF6btzKM9IMLH6mE=
X-Received: by 2002:a63:1116:: with SMTP id g22mr3958762pgl.63.1597468914463;
 Fri, 14 Aug 2020 22:21:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200813181704.62694-1-xie.he.0141@gmail.com> <20200814.204121.2301287009173291675.davem@davemloft.net>
In-Reply-To: <20200814.204121.2301287009173291675.davem@davemloft.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 14 Aug 2020 22:21:43 -0700
Message-ID: <CAJht_EP_DKC=WXATeO8YKcRas5UW2xLYRx5Qn=pL8A1PZW=E7Q@mail.gmail.com>
Subject: Re: [PATCH net] drivers/net/wan/hdlc_x25: Added needed_headroom and a
 skb->len check
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 8:41 PM David Miller <davem@davemloft.net> wrote:
>
> Applied, thanks.

Thank you, David!
