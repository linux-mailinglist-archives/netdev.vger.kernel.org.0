Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38236365C0B
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbhDTPV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 11:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDTPVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 11:21:25 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6ED9C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:20:53 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i22so27646463ila.11
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 08:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8cpGB1WdUvkWC3MjEjAA0I18SBZshOPXVC+/iyLpkn0=;
        b=noICZPY+vi/hnqyC9CkjZM+T82jkPJEu19vWYqZvWhVbWSJblnlunuLOzTc3Rgr7sd
         2wx2MI6qau/kCuUdgRCG6/YfkMXPBqC6IwpDtMfG3rjiksCrwCCZz6hq7D3UmMt4OeaV
         o5qfhVWZn0n1qjLxMVpw4Pugfghi5uF1o2bm/yIeMjxaeO+lWtgeDB+s4mfCm0EXoD6t
         3gbDzqnsb/+hyz2r91HjTVVHPxbKKD5AH2seMuAYiOYstWSrPVBEgMw8DCjrguC+DjPj
         SPWnHFe1mAan8fa1O803q0KYcgUTSHSmJHshbFJE2hDQw5UIxylSG5pArH7wTvNZ3v2w
         kCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8cpGB1WdUvkWC3MjEjAA0I18SBZshOPXVC+/iyLpkn0=;
        b=pj9ZUfhPEuUWxNDx0pt+TU+FHN4LPSu1Xq0ka2ec+lxRtxTkceSPLLkycvn7C4T4AW
         dZeWBFLrI+hkeCoWyBKGWrOuMgyr5YztDE+yg+8hcLmx3qdphKMEDh/CwEV7v9yvmTnt
         DXAiH25XZJgvhJqL7bYuJOuZU3UN9oBdeIdtVLfqP+xCart1Umf37zXi0m0db/NbhAND
         W/iJN+9TyTzEfA9aD786bvgDIW8M4j+YhInlImL6doR7F+gpusEpE46w/PIhG31YOsjQ
         GGTD2lwLBy3ywa+NKjIwd5hgZB/gCLNIwH0FvLqAJSdZLWQVIb2mWpXzYBlOz8G+PoHO
         b9yA==
X-Gm-Message-State: AOAM531O+cFssAucYlejvyhFzns9DSNLTVnU8931dT1nungUNJ1fJ8YI
        4chgEWPuOKKFvS8lWhmX1YI=
X-Google-Smtp-Source: ABdhPJxufm05KS1aRNyvJbiaC2v2B8yi8vhTgnXg27fWowXUXFpC8TBpuaZU5rh9VKwOd+ZxXLeC+A==
X-Received: by 2002:a92:bf11:: with SMTP id z17mr22971436ilh.146.1618932053341;
        Tue, 20 Apr 2021 08:20:53 -0700 (PDT)
Received: from ?IPv6:2601:441:457f:c2fd:841:577:9473:19ae? ([2601:441:457f:c2fd:841:577:9473:19ae])
        by smtp.gmail.com with ESMTPSA id w6sm8517062ilq.64.2021.04.20.08.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 08:20:52 -0700 (PDT)
Message-ID: <66a81665633fbf41bdde3b831053fa1e8aed6848.camel@gmail.com>
Subject: Re: [PATCH net-next V2] icmp: ICMPV6: pass RFC 8335 reply messages
 to ping_rcv
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 20 Apr 2021 10:20:51 -0500
In-Reply-To: <CA+FuTSfNxNj1o3QE=PL=NQ9ux27xiW7vVgjwgoWMeUb-GyBuUQ@mail.gmail.com>
References: <20210412212356.22403-1-andreas.a.roeseler@gmail.com>
         <CA+FuTSfNxNj1o3QE=PL=NQ9ux27xiW7vVgjwgoWMeUb-GyBuUQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-04-13 at 17:51 -0400, Willem de Bruijn wrote:
> On Mon, Apr 12, 2021 at 5:25 PM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
> > 
> > The current icmp_rcv function drops all unknown ICMP types,
> > including
> > ICMP_EXT_ECHOREPLY (type 43). In order to parse Extended Echo Reply
> > messages, we have
> > to pass these packets to the ping_rcv function, which does not do
> > any
> > other filtering and passes the packet to the designated socket.
> > 
> > Pass incoming RFC 8335 ICMP Extended Echo Reply packets to the
> > ping_rcv
> > handler instead of discarding the packet.
> > 
> > Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> for future patches: please add reviewers of previous revisions
> directly to the CC:

Please let me know if there is any feedback/comments for this patch

