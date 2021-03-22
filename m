Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA273445AB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCVNZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhCVNZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:25:33 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78452C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:25:31 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id jy13so21229545ejc.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RzGVqvydaU2pcFvburwGQw65//bVPJkzupq7gpXbi5k=;
        b=oAh5n2jvC9UAafqtZsaVo2+xHY+JNSvVxXwWeIqyv8VpafL2/xOyxomr9gtHl2cpau
         bR6Rh7JyXXkVWOtwZTf+KxX6puxRteBDSrVKKSpsRIwEdVJKff3BYiKlv6sfy/8fhCPS
         vZHUWWP1bMTJKVREehlo+KCwgzPteJFGHp1bE5IbfiyXgsZdLcIqB1rpqEFxPKrXxUrW
         gRyJ5PnRjxgS0b3g3cxmAdwWsSlyzOHlz+jQSZyigfJnOPqRuBHrXZLf0ftxlA+HvlHs
         EkgXW8J0ioo4+f6FomtOH8kYvJ1T5lZiEmTGR3vlxAdCHCt8P2mTurnw32QPG9lHo3yk
         rAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RzGVqvydaU2pcFvburwGQw65//bVPJkzupq7gpXbi5k=;
        b=UEO0wcDQza49R3dPNyNUfHXJIOQCWUeCFUXyudyKLtJrW4UrM62EMU1D5OWeGQn45q
         /2NRcJnBW+gD1f4Y2oPOwY/6sBHmyfGUa8mXTz4eGR85QvLqy4F4HULrhegCh3IK+OWx
         57CYPoaxv7jOpV/B6hh9hFkgz3k/RBodeKhjCubB/VX4hPNnuc6z3pkb72xYHIQpaonI
         U8oSD7tr9RmLHFstpZyIkZNriia2zB+ySLk7mk/vs3zHMoUz92nsK3M0D0AKKyBeuR6+
         uf9Y3Ax4i24MxnMltWF/j9+XsMUi6jUwaPdsGCExeHPtGT6eu9a/IgsIQ0fztKIPWh/p
         gRKw==
X-Gm-Message-State: AOAM532vuAXoFCkkKgOzdG7nXDwVScSPV9ZJme+iOPWhb8hP5doTk/4v
        +mKItqMsjgeRcxmiRg58djIKG6iezuA=
X-Google-Smtp-Source: ABdhPJx9uMDelGKQjJSsV5K6kQnK+mFDsnnTIr6Gd9SnNbWeFO2ZPds49gFQeMxM9ZEGzVh4axmV2Q==
X-Received: by 2002:a17:906:1182:: with SMTP id n2mr19747037eja.234.1616419529644;
        Mon, 22 Mar 2021 06:25:29 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id u59sm11897007edc.73.2021.03.22.06.25.28
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:25:29 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id v4so16743059wrp.13
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:25:28 -0700 (PDT)
X-Received: by 2002:a1c:e482:: with SMTP id b124mr15563197wmh.70.1616419528410;
 Mon, 22 Mar 2021 06:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
In-Reply-To: <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 22 Mar 2021 09:24:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
Message-ID: <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/8] udp: skip fwd/list GRO for tunnel packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> If UDP GRO forwarding (or list) is enabled,

Please explicitly mention the gso type SKB_GSO_FRAGLIST. I, at least,
didn't immediately grasp that gro forwarding is an alias for that.

> and there are
> udp tunnel available in the system, we could end-up doing L4
> aggregation for packets targeting the UDP tunnel.

Is this specific to UDP tunnels, or can this also occur with others,
such as GRE? (not implying that this patchset needs to address those
at the same time)

> That could inner protocol corruption, as no overaly network
> parameters is taken in account at aggregation time.

nit: overaly .. is taken -> overlay .. are taken

You mean the packets on the frag list may have mtu exceeding the mtu
of the tunnel? Please make the constraint more explicit.

> Just skip the fwd GRO if this packet could land in an UDP
> tunnel.

Could you make more clear that this does not skip UDP GRO, only
switches from fraglist-based to pure SKB_GSO_UDP_L4.

> The current check is broader than what is strictly
> needed, as the UDP tunnel could be e.g. on top of a different
> device, but is simple and the performance downside looks not
> relevant.
>
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
