Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73395F111F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiI3Rq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbiI3Rq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:46:56 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA51739E0;
        Fri, 30 Sep 2022 10:46:54 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f21so1021464lfm.9;
        Fri, 30 Sep 2022 10:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=PMgFczjI5lITGvvybViAzGzLZhgfUg66njHzJimv/LI=;
        b=Nh9WyItHvE2pZgrzjzfFUOah/OxRC1kVqE1Xt8InKsUnIstm7mvUzN3aQ6N4NtqVM2
         A3eiEQWs8PMBXY+U+DKg9cvCY+eC5c3zDh/50VmNw59wJ3hXH5SJJwWVfJzKapsizvdJ
         Qb8ifISVrq/WCw07mUWwmpbp+Ana2mTNqX5pGf5qgQkPABiLJQ8uR8jhf/NQ1JN16Xu/
         uhkY3GJi/fgrVlqEaRn5fclHDobo/CiyIpcvMItPPGIHfGrdANf7nTo7ibZpjcX/WojP
         oc1LKjW/OPVD1+SoMnCmpl0JDNks0sNf3Ty9pK/ETbGTaoDfkqISCKpmzq1eirhHPD1Q
         W6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=PMgFczjI5lITGvvybViAzGzLZhgfUg66njHzJimv/LI=;
        b=1s4iPfHsf5UWoexJ0FIBA/93r6DAmgKQ8HBCa+MwZLpMjQU9HSF7GaoTEawdRfy+Hj
         2Rq09c7rJFCkxO09i5GabkZLeC8J+VDoaz53sp7F7m6xG9kFS+2fEJl4fYXffUJbcjqm
         aphZo8xrKHcTW0EbWuHlaBXTq056Qql70errxx2X1ziBxce07xZ8C0Xgm4ZPUuRvNRme
         ceHyLVbdaR3AsL2/mrdMn39DaHiRrjCoJwiqFAIgNqrP3By4eCaNuFubh8pZ3mm7z0Ol
         A+TNGlqruq70sTo9HV65VkEJGX4uS29E3fDz4Dle7Eak6W75BcrX1gIbHdeyCJ5mRHp6
         961A==
X-Gm-Message-State: ACrzQf1DlkAY72GXLWdnc1W4spiTtAteaOAYC4/bKIET/Vux7DCAnf7F
        vk/UKCQNQZ8G+PHduax+0z1TTg15aEYvzn/daBE=
X-Google-Smtp-Source: AMsMyM60Sn37g1vsWtCfPmp5oKqpbppdcXL2K1TH09KGjw/kR39OBVCSYQX54yR2TsXM9pxJFVe2w3UdE3LsIEO9x8o=
X-Received: by 2002:ac2:5cb9:0:b0:498:eb6f:740d with SMTP id
 e25-20020ac25cb9000000b00498eb6f740dmr3441812lfq.106.1664560013017; Fri, 30
 Sep 2022 10:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <CABBYNZKSnFJkyMoHn-TU1VJQz3WNNt0pC8Nvzdxb3-4-RtcQGw@mail.gmail.com>
 <20220930160843.818893-1-iam@sung-woo.kim>
In-Reply-To: <20220930160843.818893-1-iam@sung-woo.kim>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 30 Sep 2022 10:46:41 -0700
Message-ID: <CABBYNZLyCzQ_RUJKUi8dpZorPjUsyCxXcZ-ScmMHWx0a86Ra5w@mail.gmail.com>
Subject: Re: KASAN: use-after-free in __mutex_lock
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kim,

On Fri, Sep 30, 2022 at 9:09 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> Hi Dentz,
> How about to use l2cap_get_chan_by_scid because it looks resposible to
> handle ref_cnt.
>
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> ---
>  net/bluetooth/l2cap_core.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 2c9de67da..d3a074cbc 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -4291,26 +4291,18 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
>         BT_DBG("dcid 0x%4.4x scid 0x%4.4x result 0x%2.2x status 0x%2.2x",
>                dcid, scid, result, status);
>
> -       mutex_lock(&conn->chan_lock);
> -
>         if (scid) {
> -               chan = __l2cap_get_chan_by_scid(conn, scid);
> -               if (!chan) {
> -                       err = -EBADSLT;
> -                       goto unlock;
> -               }
> +               chan = l2cap_get_chan_by_scid(conn, scid);
> +               if (!chan)
> +                       return -EBADSLT;
>         } else {
> -               chan = __l2cap_get_chan_by_ident(conn, cmd->ident);
> -               if (!chan) {
> -                       err = -EBADSLT;
> -                       goto unlock;
> -               }
> +               chan = l2cap_get_chan_by_ident(conn, cmd->ident);
> +               if (!chan)
> +                       return -EBADSLT;
>         }
>
>         err = 0;
>
> -       l2cap_chan_lock(chan);
> -
>         switch (result) {
>         case L2CAP_CR_SUCCESS:
>                 l2cap_state_change(chan, BT_CONFIG);
> @@ -4336,9 +4328,7 @@ static int l2cap_connect_create_rsp(struct l2cap_conn *conn,
>         }
>
>         l2cap_chan_unlock(chan);
> -
> -unlock:
> -       mutex_unlock(&conn->chan_lock);
> +       l2cap_chan_put(chan);
>
>         return err;
>  }
> --
> 2.25.1

Ive sent a fix yesterday:

https://patchwork.kernel.org/project/bluetooth/patch/20220929203241.4140795-1-luiz.dentz@gmail.com/

Both are sorta similar but the one above end up causing less code
changes which might be easier to backport.

-- 
Luiz Augusto von Dentz
