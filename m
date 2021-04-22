Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E11E367A11
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 08:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhDVGop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 02:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhDVGoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 02:44:44 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10180C06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 23:44:10 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v3so47778178ybi.1
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 23:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gKq7UYoOSXgKxRcRDCrnBQBW0R0+/HzGQMv1jLYzZ5E=;
        b=Rbo5NtMvsmOiDCI5wGzUZG7Cx3weSWIyWVAqMvlEY5pQ3dIVHjUEL/lfPaq1u6nx1m
         YasAzRo0LgycAKz8t8r49d/C4O4vM5ePvNes9asR548snpcTtg4U8HfDk7MW5FbF7bZi
         yJYCcFHxWvDGHqfAOZlEQAHpNMttcPC3heEB+9bzA5VAAIjFHMbFTxY589mlZzPyBrG2
         swNZ7iurbtdo9hxyWdbIvUM9YNoCM9L9zwga8BLpPFsg+dHNnYNOf+rdqJQ0IwloIcgl
         zRYfdUDUkGcFRfpgpQoU/n0k070/p7H3Ctfk/j5UgGSz/xNVe+CVd62xa1QOJ+2AVCgp
         op1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gKq7UYoOSXgKxRcRDCrnBQBW0R0+/HzGQMv1jLYzZ5E=;
        b=AAfCxCQWO931gVMqKQANzvN9CwcXVLUBLfPMisPGSJ++KtF7+bVjZFFr0Kqf3dHt5X
         OTdodJRW5orNt6kLBsNPAjMQfF4k3hbRlVOgQiagEtEaCej9MDGqXLyBYSMXR20DtV2F
         WR7heVzcA3p1knOnUsjgeLnKxZaRzRhTUnWMfBRPtSE5CdOjxfk2ps2rFYK76juM20RI
         p/Ic6KLENKo3L9I82zQCTtHLrvwk0Caes1QejeRJEhpj7E1Mi0AByZRDFm/D/VK+NmKb
         gVDRUSKJrpz5HvF7ZIQAEXAwz7QJwpCQdxeQG5OCHmj6hKHVkcM3q1OsActfaCw/iClE
         Sktg==
X-Gm-Message-State: AOAM530i/QEKRBVFaCUysDQhJ3Re7+Hw1avvc1amSaiWpsNt1R5f+Vgb
        N0rdQ2kF2tFK2D3g6Ikaeu1asPsFonvS+rVGtCUFaMhRivl8+g==
X-Google-Smtp-Source: ABdhPJxKTccQQ6mqU/IMIPgQBapIGJNrTFPxW3lmAO3lgf3JVA9Tgh31F3rfqhaTM2YIJYjncsgdqTfv7AHeOUK3Uos=
X-Received: by 2002:a25:cf08:: with SMTP id f8mr2769265ybg.132.1619073848914;
 Wed, 21 Apr 2021 23:44:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210421231100.7467-1-phil@philpotter.co.uk>
In-Reply-To: <20210421231100.7467-1-phil@philpotter.co.uk>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 22 Apr 2021 08:43:57 +0200
Message-ID: <CANn89iJwipuJ6tTj5XjnvXnAB3N+dF=8oeCMSUyt+A_cUbr-pw@mail.gmail.com>
Subject: Re: [PATCH] net: geneve: modify IP header check in geneve6_xmit_skb
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 1:11 AM Phillip Potter <phil@philpotter.co.uk> wrote:
>
> Modify the check in geneve6_xmit_skb to use the size of a struct iphdr
> rather than struct ipv6hdr. This fixes two kernel selftest failures
> introduced by commit 6628ddfec758
> ("net: geneve: check skb is large enough for IPv4/IPv6 header"), without
> diminishing the fix provided by that commit.
>
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>

SGTM, but _please_ add a Fixes: tag, since stable teams now depend on this,
more than human parsing the changelog.

Fixes: 6628ddfec758 ("net: geneve: check skb is large enough for
IPv4/IPv6 header")

> ---
>  drivers/net/geneve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 42f31c681846..a57a5e6f614f 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -988,7 +988,7 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>         __be16 sport;
>         int err;
>
> -       if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
> +       if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
>                 return -EINVAL;
>
>         sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
> --
> 2.30.2
>
