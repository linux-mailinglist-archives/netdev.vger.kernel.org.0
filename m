Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E0D3F1E7B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhHSQ6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhHSQ6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 12:58:16 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0BDC061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:57:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id x11so14393983ejv.0
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4tGqtodxm8cq9s5nssrQK8UELCa81JVaJ+mdBHNrMA=;
        b=MFNDt8U3uf+R5KlZ32EtgNfNPP7b6zj1iTV2LzL0Y9SV+rkF+HQCrG+AI+wr7GaOlX
         1pGPelfy2gRTJHkJTMj1vQD/4eRKq0H9+ziqXzcaLYdt6UF5KWNYJOgq/FpUb+YCgeKr
         uwjJXo87PB9Tw8aljBbRBc3Ko1vLy89qNQoSXPlkAcxjso5FpvdGlrVxawCQFRE1/GiF
         PMuVBYEgsnO7jyIMU3QmK/mkM11JJ/RfaIV0XJ4PW/3bIXsnK1Cmk0HLSD7qmTv13guX
         CHjvT/I9G0FnpCr2mlk/fUGARp2RGs4dn/R3xuYXPpkeJWqfKUBqhz2b2T2fSKaAOvxi
         8RAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4tGqtodxm8cq9s5nssrQK8UELCa81JVaJ+mdBHNrMA=;
        b=qjJHGJ3BtBC9DS7jckHWuJdx06SNh5nq1dA6pIDzHxDD++wEEnp855h+uP9LdrqzUZ
         xAH0dj1xEVvv6+2AKlPiyHY7kudOT+wlzsAMP9DWBfYWqbXb1dutkJHlSA9/eibdQdEj
         hzEv2iHM5vjNFpcIEJQLT1NFmv7gHjmmfR5e8QiRKstKSPPL7fIqLeaHTsTlPOxBa2Iy
         5Txlb4n20EOmhOAfPZuq+zY+xDcKV5rzYU1OgaDi38cg0VcHrkUMNk/1b98Y9o7nCks6
         501QZ4w8rHI/dfUoPxvaMKJnMVDu8aqn2WXVB1BeI9xicHsHNUCmDh40AJcDuAZ1+d8I
         IMGA==
X-Gm-Message-State: AOAM532xE3wfd3bZdYmw5/WCuwRNSvdQj0bxqUQXB6N99q6Yr9Jc9m86
        HyXo3mneOtePwnz6zAQslMSnY+GzA14=
X-Google-Smtp-Source: ABdhPJzwK7s50aJ8UnQ5GjJh9oR2Uj0ggQqfJzMDZoD7NLQJyqPB6ZcJV24+Vug1Gdf6l1SGI9yPUg==
X-Received: by 2002:a17:906:2bc2:: with SMTP id n2mr16660615ejg.455.1629392258589;
        Thu, 19 Aug 2021 09:57:38 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id r27sm2019065edb.66.2021.08.19.09.57.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 09:57:37 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id x12so10054104wrr.11
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 09:57:37 -0700 (PDT)
X-Received: by 2002:a5d:494d:: with SMTP id r13mr5017809wrs.12.1629392256880;
 Thu, 19 Aug 2021 09:57:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
In-Reply-To: <20210819143447.314539-1-chouhan.shreyansh630@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Aug 2021 12:56:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
Message-ID: <CA+FuTSdsLzjMapC-OGugkSP-ML99xF5UC-FjDhFS1_BDDSJ2sg@mail.gmail.com>
Subject: Re: [PATCH] ip_gre/ip6_gre: add check for invalid csum_start
To:     Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 10:35 AM Shreyansh Chouhan
<chouhan.shreyansh630@gmail.com> wrote:
>
> If we get a ip gre packet with TUNNEL_CSUM set, an invalid csum_start
> value causes skb->csum_start offset to be less than the offset for
> skb->data after we pull the ip header from the packet during the
> ipgre_xmit call.
>
> This patch adds a sanity check to gre_handle_offloads, which checks the
> validity of skb->csum_start after we have pulled the ip header from the
> packet in the ipgre_xmit call.
>
> Reported-by: syzbot+ff8e1b9f2f36481e2efc@syzkaller.appspotmail.com
> Signed-off-by: Shreyansh Chouhan <chouhan.shreyansh630@gmail.com>

For the ipv4 portion:

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")

For the ipv6 portion:

Fixes: b05229f44228 ("gre6: Cleanup GREv6 transmit path, call common
GRE functions")

It's possible that a similar bug exists before those, but the patch
wouldn't apply anyway.

Technically, for backporting purposes, the patch needs to be split
into two, each with their own Fixes tag. And target [PATCH net]
