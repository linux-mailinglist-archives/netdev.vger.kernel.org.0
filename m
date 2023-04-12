Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994666DF50B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjDLMX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDLMX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:23:57 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822B772AB;
        Wed, 12 Apr 2023 05:23:46 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id c2so790408ybo.9;
        Wed, 12 Apr 2023 05:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681302225; x=1683894225;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LUWRNNE/JZ+baYmjcl+NKkyo+ch4BXrt9V/cFSfdS9E=;
        b=e0roAdorSyZN8o45fnTNqHMlgok99sbVKgKWJBZYlxRxKoxRZ3/kteLoTHcQNkwdrc
         L88YfpsHnhkxrpvXkWURXN/JnM1QDt9E+Soo9qy6uNfwaZevtf95xZ65xOh0LsmXV7o9
         eQHcQarWEzYc1bzgbtB8zeHSlpmMEgxAKlYFizNJ0wc5DHY3kNyP7uV42coWsrClDeSN
         2VVXp6ltyACbJTretkzPOefjhg/59ys6FBts4E+n4giyZYzU+s5hxvguSWhCBW7IdOHd
         keU4ASVDfU4GyM0hO2+vkGYGdCaU49XGUxOgSlEgiL/cixRNx1lnTn0C7W4EKDeTkQX7
         NweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681302225; x=1683894225;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LUWRNNE/JZ+baYmjcl+NKkyo+ch4BXrt9V/cFSfdS9E=;
        b=QJelOKWqyAlinAqFlSeROPzfySfye93P1lKJavyggb53HaGBQO9F9ZcIvifBzSkc5T
         9z+lAaOIZnal1V0sCT42OsSahCv3zU3lEfkfkpW5R+BDtZM+2ngJqSKUmv6NG/GgsXRX
         oRzzUDko6TB0Esr625AHYZY7l8Mv2YDjt1SK5XYzbR2JD54wTrTlOJ9UdbA2wo6XMUFF
         MLqFy4LDv446jCDgHbYmmSrjoyYUZXCvYSoGWoGM4GSjoh5gbsPQVd4Dh3oj6K3TMqD6
         80yB/B113Yx7N4S8U5Iv3EgVlueGAszh6w0FDSzZWTPXLdcAWmpDb7n3hnOIzKKWvV5L
         vAVA==
X-Gm-Message-State: AAQBX9e00V77xMwJByQ1wCcFQwEdfDLTX/gb9QcfUrM/qNl0ziwtouvR
        ZbJX1tmKBV/AHPzwKAkRbis0luV2/otEs5pV2q4=
X-Google-Smtp-Source: AKy350aW016MALydyt2LULMdwEE2qV9c2+4XVUlAcq1uW0K+sBQ2z1MZI4K5fCy6upaLfUFVbwD7YXbpZEMFUVffRkU=
X-Received: by 2002:a25:744e:0:b0:b8b:f61e:65ff with SMTP id
 p75-20020a25744e000000b00b8bf61e65ffmr3908986ybc.5.1681302225713; Wed, 12 Apr
 2023 05:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230410121841.643254-1-kal.conley@dectris.com>
In-Reply-To: <20230410121841.643254-1-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 12 Apr 2023 14:23:34 +0200
Message-ID: <CAJ8uoz11tOSUK0+45K=L9q-yj3gyMCDJVPsOjawE+Wjbe2FSTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: Simplify xp_aligned_validate_desc implementation
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, 10 Apr 2023 at 14:24, Kal Conley <kal.conley@dectris.com> wrote:
>
> Perform the chunk boundary check like the page boundary check in
> xp_desc_crosses_non_contig_pg(). This simplifies the implementation and
> reduces the number of branches.

Thanks for this simplification Kal. Just to check, does your change
pass the xsk selftests, especially the INV_DESC test? If so, then you
have my ack below.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xsk_queue.h | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index dea4f378327d..6d40a77fccbe 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -133,16 +133,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
>  static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
>                                             struct xdp_desc *desc)
>  {
> -       u64 chunk, chunk_end;
> +       u64 offset = desc->addr & (pool->chunk_size - 1);
>
> -       chunk = xp_aligned_extract_addr(pool, desc->addr);
> -       if (likely(desc->len)) {
> -               chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len - 1);
> -               if (chunk != chunk_end)
> -                       return false;
> -       }
> +       if (offset + desc->len > pool->chunk_size)
> +               return false;
>
> -       if (chunk >= pool->addrs_cnt)
> +       if (desc->addr >= pool->addrs_cnt)
>                 return false;
>
>         if (desc->options)
> --
> 2.39.2
>
