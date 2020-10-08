Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82EC287479
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 14:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730069AbgJHMpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 08:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729937AbgJHMpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 08:45:16 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC0FC0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 05:45:15 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id j15so1820887uaa.8
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XLAQaD2M+nJNhEZROwfZpa9TK59bniuYCfAuCfjl0D0=;
        b=o+025g4UoxRpmdvbRAQW+QMGUVTiOhnVE9PLA7rds1yYR9Zyq2mrXtiMY8cpcmD9x2
         sDa1Q3O1x74I8H0p0/C6KMYvJ2/oaPs/WL+h75maZjw5ey2Yvc6ocCCaRyByouGWQhpx
         TUMaEqEfQ+ONohY2UX3zEhKD7YYxQ+MdXAmmCyA/AgZpaj5dhWM7n8A98HVO7OTyhICT
         ZW/LnXwaIfFM6INoajp28wnSkmX6OzTN+LVI9UASJKUfDFD9PkmIgiPEJhwuJjbNn7kb
         vPDoUhJ5CNZC2TXOUK9vIo7vc/IkkB3aALhMsKyIUMl1YKvjgk3peukHX5sJhecxdd+M
         RP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XLAQaD2M+nJNhEZROwfZpa9TK59bniuYCfAuCfjl0D0=;
        b=W5DN2waqXAIl7crW4yrxut8k5zjGZ8RmTUc+fFrRWoYFmuY1UitLwh+MeoaltlzrRo
         vKPTD6ODUtXpQMDFyXTUNyKS1dfWef6F31lHu1QPip9apjhrp02isPFln2eDIJ/WV99x
         agvQicjCIX80aIt4c+f/MR3BdIFz98gcYzbF48MwIq3WBEgYMuOMdKKrXBrR++crnPcf
         F5HhikQAyqtcIM9wEaBDiZL+b2iVUY13bfay0a6p+BpTvopr4BYwVQPdvzWt1CLanJbp
         mH6hUuxW598NkG69cHfrKNoPCjdwL/hX7SEa7LoheT2cNGaeepN6nLaernJLKIYbDcB3
         STig==
X-Gm-Message-State: AOAM530XG/ZgYLBTizinDB5jbLHjznzVj2Q+yMSR/RMOsCliEfRN3Ict
        Fq9M0dqnP0lS65+QaSHR07KXYCOR9Mc=
X-Google-Smtp-Source: ABdhPJwXyxoS5zDaHyPG2SgWRo2rEreJMJE1qdAlC5h2JCy5+YxI4UhdQ2y9VqqdKVRdFSmB5P+vJA==
X-Received: by 2002:a9f:24e8:: with SMTP id 95mr4601306uar.12.1602161114581;
        Thu, 08 Oct 2020 05:45:14 -0700 (PDT)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id c17sm540268vke.38.2020.10.08.05.45.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 05:45:13 -0700 (PDT)
Received: by mail-ua1-f41.google.com with SMTP id w12so1816655uao.12
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 05:45:12 -0700 (PDT)
X-Received: by 2002:ab0:c11:: with SMTP id a17mr4225733uak.141.1602161112470;
 Thu, 08 Oct 2020 05:45:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602150362.git.lucien.xin@gmail.com> <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 8 Oct 2020 08:44:36 -0400
X-Gmail-Original-Message-ID: <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
Message-ID: <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 02/17] udp6: move the mss check after udp gso
 tunnel processing
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 5:48 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
> gso_size. When using UDP to encapsulate its packet, it will
> return error in udp6_ufo_fragment() as skb->len < gso_size,
> and it will never go to the gso tunnel processing.
>
> So we should move this check after udp gso tunnel processing,
> the same as udp4_ufo_fragment() does. While at it, also tidy
> the variables up.

Please don't mix a new feature and code cleanup.

This patch changes almost every line of the function due to
indentation changes. But the only relevant part is

"
        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
                goto out;

        if (skb->encapsulation && skb_shinfo(skb)->gso_type &
            (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
                segs = skb_udp_tunnel_segment(skb, features, true);
        else {
                /* irrelevant here */
        }

out:
        return segs;
}
"

Is it a sufficient change to just skip the mss check if mss == GSO_BY_FRAGS?
