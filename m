Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661392D8F41
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 19:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgLMS0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 13:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbgLMS0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 13:26:46 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99FC0613CF
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:26:05 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id t13so13274211ybq.7
        for <netdev@vger.kernel.org>; Sun, 13 Dec 2020 10:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dNzEKXq4B7dPSwIwCae03yy2Str3nKK65XKVe4GMS8s=;
        b=C3hZlaojWTYspr8k1MAVDmI6Cw5VNjpv3WyFVkhUiNabVEGshSBTXvw0l+5Bgle1QW
         L4qc9sVZo2XpB5kgH+kLdz+XCfnpATngWBFn9m44MbvW7CtW4qhD0UA3mA/DZmUph2lS
         W9h882Yl1NgEdq4TcU/yLyGhLuGBXOdzb9umg5fXChkJJGwHtMsy+zf8eqdu825G30QM
         MVr6iJOeaOMxqRmTgiDFEqfY8CCGVkZLXRXqf+aH5KUP7HW5KgI2vffP+6DG6iqwSaPN
         SeUa4P8JOjOPJwc5Iqd+SwEDHU+TdAOm2NqbjpuwS8UwgRBfyVkgsGEbUG2bFHn+jGp4
         K4xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dNzEKXq4B7dPSwIwCae03yy2Str3nKK65XKVe4GMS8s=;
        b=HLPen7TPw1/wcWivVtvYnTX4x5cHrhOBneDcDBhC3NdCuwekda53fRGHHADZvf7BP9
         MlUgIhdZH9Jj+aRtvVmmS8TjybCofE7+BgElOxvDD7EgGIqhnfoVm18wToyF9VuLTu8D
         wpW4QIIDepN1UExSQkRK3UCQ50qn8btyV3hkbEt7BBFIWNGqE0/GlbzGzYIXa0KexSFw
         EIpR3B3EmbwTRwkwHZTuhAN2VW/qUFUR5WAbqoAcwNL3Tn04y9JZpKRI8UASXHurQcaO
         HSRu60pG1hJ3o+ufh29+rFMaGMsVR8XAWKgrkzz32vbIMQC5xxP+L1hguTieX04FzXrf
         fkLw==
X-Gm-Message-State: AOAM5309yBwL5MGhI9mo8j1bYNk78Iy85+Rwdtd/zumiCiE25Q3Xvcqf
        bFyEaOUd8/BFhz053L7YHA8DlmMrb/Sl5qc40+o=
X-Google-Smtp-Source: ABdhPJx9PuyDQMfauqoOCiZd6v+C1vvie3j8tiVZuEywjBm7Ee3qrYapm09/MbZm50n0BchpzSHR0LRv1G3O7GoU2Xo=
X-Received: by 2002:a25:a86:: with SMTP id 128mr29999826ybk.370.1607883965033;
 Sun, 13 Dec 2020 10:26:05 -0800 (PST)
MIME-Version: 1.0
References: <20201211122612.869225-1-jonas@norrbonn.se> <20201211122612.869225-9-jonas@norrbonn.se>
 <CAOrHB_BC3847Oi--N84=tT5nrdpmL6a5Csvah19qJ0Czyng1JQ@mail.gmail.com> <a4fa00b1-5e9c-eaf2-2017-93416e7532f0@norrbonn.se>
In-Reply-To: <a4fa00b1-5e9c-eaf2-2017-93416e7532f0@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 13 Dec 2020 10:25:54 -0800
Message-ID: <CAOrHB_ASo6Ng+0OvaXzaDLnBrrVEqcAjVHn7u1fD318ugYPJJQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 08/12] gtp: set dev features to enable GSO
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 11:50 PM Jonas Bonn <jonas@norrbonn.se> wrote:
>
>
>
> On 12/12/2020 06:31, Pravin Shelar wrote:
> > On Fri, Dec 11, 2020 at 4:28 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >> Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
> >> ---
> >>   drivers/net/gtp.c | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> >> index 236ebbcb37bf..7bbeec173113 100644
> >> --- a/drivers/net/gtp.c
> >> +++ b/drivers/net/gtp.c
> >> @@ -536,7 +536,11 @@ static int gtp_xmit_ip4(struct sk_buff *skb, struct net_device *dev)
> >>          if (unlikely(r))
> >>                  goto err_rt;
> >>
> >> -       skb_reset_inner_headers(skb);
> >> +       r = udp_tunnel_handle_offloads(skb, true);
> >> +       if (unlikely(r))
> >> +               goto err_rt;
> >> +
> >> +       skb_set_inner_protocol(skb, skb->protocol);
> >>
> > This should be skb_set_inner_ipproto(), since GTP is L3 protocol.
>
> I think you're right, but I barely see the point of this.  It all ends
> up in the same place, as far as I can tell.  Is this supposed to be some
> sort of safeguard against trying to offload tunnels-in-tunnels?
>

In UDP offload this flag is used to process segments. With correct
flag GTP offload handling can directly jump to L3 processing.
