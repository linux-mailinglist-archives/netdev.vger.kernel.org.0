Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE092E8961
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 00:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhABXur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jan 2021 18:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbhABXuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jan 2021 18:50:46 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA914C061573
        for <netdev@vger.kernel.org>; Sat,  2 Jan 2021 15:50:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id hk16so8195105pjb.4
        for <netdev@vger.kernel.org>; Sat, 02 Jan 2021 15:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R43VJ7kFEw6xD4G2PhkEToYHEmegnysAfZkQ7BXQuFA=;
        b=iHyYJbyoLsFZo1SXaYzTyZaUKmW+mX/e3dFNbmzI8iMvOx15k4qY9zyMvrsH4I7OHi
         yxSniEZHzIk62gctfyMepcGHn5q4lz+GS94mQMZ7KNBOMyB9+SVHotfeZfLiceraWybq
         C4vkxNlJ8kuPzeK2N4YZ54l5mRoStRoB/Si9B6QTwDSQKdr4rS8PBp/hgjNOwwDkXol4
         L0Bo4RLnxFkYr7OrsoE3C6LvoD7ZWAif4vWVvCHGFUV4RIhVTeHDaIXkX9DB7mQ1aW1B
         PbvGhZHOQ5eZtCpWjcNTv5+fUigUkBUjZ6BdalsWji9LYv8fl3oBUOmJd7MtxQ50L5r8
         w8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R43VJ7kFEw6xD4G2PhkEToYHEmegnysAfZkQ7BXQuFA=;
        b=RiNu3lLw01OJop4Iq07d+bnkWcyp9SUnRC44vHLUndyxo0pn6sVH9srQHwv6viHCgx
         f+LSv2K/3qIjbfGaVSVxwkA/Rv/PlAe+quWvI/lMKks/Wss/x1GQinuaLPiBKzfLThPX
         NvE/kaBXOeDHyKMEaOQkGrkzzr7e8m7EbjKHAsZNPAFyT1AmIF/pmsOOvZCmBG83Rk3X
         nILzmuozuUeBO08qR41YXoxASkipRP9G7wPyAls8dumPUtKvRnkRkXteuEG0r/kpI+/c
         1AfzX6gOg9quz0oYLhspzmyoWRs4UZO1j/Cz5267rcKGpFiCschluJZUpw2me48qJ/8C
         nYDg==
X-Gm-Message-State: AOAM533a/I6MPb8botzd5K7lEHLVviBxId2VL2pMKuscCOpcJKjILX3v
        A/7lQ4o9g09DAEPrQY+go93mTIN5zoeNf0zJB1Q=
X-Google-Smtp-Source: ABdhPJzhHEnErNYAhOM2n1K6QinT1iK1SXfjaSyXVs9lU0N6OfJ9/6U6d9HXUDmtDVUW3d+gSK/Og+0TXlbSF2ThINM=
X-Received: by 2002:a17:902:7242:b029:db:d1ae:46bb with SMTP id
 c2-20020a1709027242b02900dbd1ae46bbmr66799254pll.77.1609631406244; Sat, 02
 Jan 2021 15:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20201231034417.1570553-1-kuba@kernel.org>
In-Reply-To: <20201231034417.1570553-1-kuba@kernel.org>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 2 Jan 2021 15:49:54 -0800
Message-ID: <CAM_iQpW1ZMyb33j4uLNMXXW+vQSS6FB1-BhxSQ7ZShi9dT2ZoQ@mail.gmail.com>
Subject: Re: [PATCH net] net: bareudp: add missing error handling for bareudp_link_config()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        martin.varghese@nokia.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 7:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
> @@ -661,9 +662,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
>
>         err = bareudp_link_config(dev, tb);
>         if (err)
> -               return err;
> +               goto err_unconfig;
>
>         return 0;
> +
> +err_unconfig:

I think we can save this goto.

> +       list_del(&bareudp->next);
> +       unregister_netdevice(dev);

Which is bareudp_dellink(dev, NULL). ;)

Thanks.
