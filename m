Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561DA31ED9B
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhBRRrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:47:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231901AbhBRRHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:07:20 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10278C0613D6;
        Thu, 18 Feb 2021 09:06:25 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id f1so619590oou.0;
        Thu, 18 Feb 2021 09:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IAeHU+ZuCyviiLpYZa0pCGB0W5e4M4NB3l+n2M4fYZU=;
        b=W2AmWeei+CA/GEK4JmFfGdwEachPjWFFyto0odTBPeQ9zEqX03doEOA5p0/5q0mKPj
         0S258LiVaiGbW6XdWkEPWad8Sy2NgjgtGYgoEWba8jvfvi4W29kEFHPCk5IbtaqGF/Di
         lzGz1a5wWVwxEb7RjYCCQTpL/smiWu4C1jvcesTdXtwg4pyWORStNl8a8Xdfnirkfq7K
         7i7F2/0va7wYCUFn/ZNzrgKjdQkZKOS2QuI2NSyf/FBRuDFaSaXpvR45ClXslV1QHkRB
         9MnVmR6SCOIIe/BdWmf0keMfx7BEQ4TpWNJgekyxZrjx2nxg99hjV7U0Ac8+ka7kIIre
         YXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IAeHU+ZuCyviiLpYZa0pCGB0W5e4M4NB3l+n2M4fYZU=;
        b=omP92B0k9VSgzMeYEDxxL7ZFnSMBb7/rE4jsKpAACyqaqjMt/vGUZfcShKr5dMIgkU
         eMnlIpZiyJAyjj5XvtciCIWLOg9ecr1ZTOzbB5wBk5lNWpGpNKDwVlz1retkB5AA6++Z
         GgtiE9p6DnZT0/ghitYd80hiTi8r0D/ixyi7tuWPUTZ5Cc09DW11XuutDD1K2DsF4tLP
         6sH1VhprcpcYKjbJr9wXLyihSecMPpXa7tWvVcCcWHTgVnzYhCB03/WbXHO3jGCvkXwk
         yy//KidvfZWS7f72Yjj2riaIlVL2+ljtb9HW7l2NtEETteY2+w1cXpYOW2K7PUW4x9cE
         L8mw==
X-Gm-Message-State: AOAM533sN86lzvhtToAW+f58637m8a2VoSjwvn+mKBnsyJagCRljU4Xk
        huEDE5s+xANuZgy3PhtdiEeTRR+He/QJIoVbtA==
X-Google-Smtp-Source: ABdhPJzkb2Wsxw93sktjBF57OYN8O/Neps2Jf8JqDDO4E3TPDKyViTk2GDUsHX4LYhOfw2va9fffTqZjko1jYxrirR8=
X-Received: by 2002:a4a:3407:: with SMTP id b7mr3732250ooa.43.1613667984444;
 Thu, 18 Feb 2021 09:06:24 -0800 (PST)
MIME-Version: 1.0
References: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
 <20210218150116.1521-1-marco.wenzel@a-eberle.de>
In-Reply-To: <20210218150116.1521-1-marco.wenzel@a-eberle.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 18 Feb 2021 11:06:12 -0600
Message-ID: <CAFSKS=OpnDK83F6MWCpGDg2pdY-enJyusB5Th1RGvq8UC1WCNQ@mail.gmail.com>
Subject: Re: [PATCH] net: hsr: add support for EntryForgetTime
To:     Marco Wenzel <marco.wenzel@a-eberle.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Amol Grover <frextrite@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Arvid Brodin <Arvid.Brodin@xdin.com>, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 9:01 AM Marco Wenzel <marco.wenzel@a-eberle.de> wrote:
>
> In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
> node does not send any frame within this time, the sequence number check
> for can be ignored. This solves communication issues with Cisco IE 2000
> in Redbox mode.
>
> Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
> Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> ---
>  net/hsr/hsr_framereg.c | 9 +++++++--
>  net/hsr/hsr_framereg.h | 1 +
>  net/hsr/hsr_main.h     | 1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 5c97de459905..805f974923b9 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
>          * as initialization. (0 could trigger an spurious ring error warning).
>          */
>         now = jiffies;
> -       for (i = 0; i < HSR_PT_PORTS; i++)
> +       for (i = 0; i < HSR_PT_PORTS; i++) {
>                 new_node->time_in[i] = now;
> +               new_node->time_out[i] = now;
> +       }
>         for (i = 0; i < HSR_PT_PORTS; i++)
>                 new_node->seq_out[i] = seq_out;
>
> @@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
>  int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
>                            u16 sequence_nr)
>  {
> -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
> +       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
> +           time_is_after_jiffies(node->time_out[port->type] +
> +           msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
>                 return 1;
>
> +       node->time_out[port->type] = jiffies;
>         node->seq_out[port->type] = sequence_nr;
>         return 0;
>  }
> diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
> index 86b43f539f2c..d9628e7a5f05 100644
> --- a/net/hsr/hsr_framereg.h
> +++ b/net/hsr/hsr_framereg.h
> @@ -75,6 +75,7 @@ struct hsr_node {
>         enum hsr_port_type      addr_B_port;
>         unsigned long           time_in[HSR_PT_PORTS];
>         bool                    time_in_stale[HSR_PT_PORTS];
> +       unsigned long           time_out[HSR_PT_PORTS];
>         /* if the node is a SAN */
>         bool                    san_a;
>         bool                    san_b;
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 7dc92ce5a134..f79ca55d6986 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -21,6 +21,7 @@
>  #define HSR_LIFE_CHECK_INTERVAL                 2000 /* ms */
>  #define HSR_NODE_FORGET_TIME           60000 /* ms */
>  #define HSR_ANNOUNCE_INTERVAL            100 /* ms */
> +#define HSR_ENTRY_FORGET_TIME            400 /* ms */
>
>  /* By how much may slave1 and slave2 timestamps of latest received frame from
>   * each node differ before we notify of communication problem?
> --
> 2.30.0
>

scripts/checkpatch.pl gives errors about DOS line endings but once
that is resolved this looks good. I tested it on an HSR network with
the software implementation and the xrs700x which uses offloading and
everything still works. I don't have a way to force anything on the
HSR network to reuse sequence numbers after 400ms.

Reviewed-by: George McCollister <george.mccollister@gmail.com
Tested-by: George McCollister <george.mccollister@gmail.com
