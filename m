Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447116DF531
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDLM2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjDLM2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:28:39 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD9D2697;
        Wed, 12 Apr 2023 05:28:36 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id f188so43265731ybb.3;
        Wed, 12 Apr 2023 05:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681302515; x=1683894515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/O6Nj/K8x+UbB7+iXw6fuXB1jhbuZSXJ2zfOCDmF/mM=;
        b=TG8EySB6eP49fXKnStYVjTdbyTT2n29bAyQp5kNp8Wq5e3jvPMIkWlq0xhBoOoUlUY
         co0XbxU6SoCTyB+UJEfgyBagFASojXaAwI2FMV6eYk6pEpqUmItVq1Gr5hUS39vrJkIQ
         7NX/XtKCIedG9qUeLJzg6oJVoUyzH9UOr3jtVlBHHCmbjJo9rbMbqlVdlVeBNVmmIhxp
         MphnqjtEHJYJTUEE1XX9uIUr+25YSa/BEdhXAYzgzesGtnF4GEKDtwlFhugWwIeJ7Cis
         e76o0Rc6kSlyGSjFDP1LjHnQ4PmzIKUlxSysVgIzewEd9VPQyjm+EEd6ZLlOaX7wbd6k
         m4og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681302515; x=1683894515;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/O6Nj/K8x+UbB7+iXw6fuXB1jhbuZSXJ2zfOCDmF/mM=;
        b=t9FIczBBRVo03pKUhp3ip9q030djoY8/u7LJUk9vxrDw5Nz8LxLVBOgTW9HMPdZ+1/
         pXlbJ5vku5LS5zO8a6r19g3apOxoRdGlJbnaod/SJUTsuQX94aBJfm8dJeNT41MtUyCt
         emxgzmWV71mMhorEa322Ao3uAfxHS00xwxPW5wgIrgd6bCE+zIj/DmIIu9O0iVLilF1V
         EW1022s1sF/YPJF4pFejrtG1dlilhH4vnNtrEMnVFXvmVYhoG01XumYUtHYpasb4/iga
         aQn0fugdW9EDAk22j2CSqx0EY7Bf+GRVPAglER5T22Y0CC2Ljj1zTlXeXmSr5N0Q7Nb6
         2vwA==
X-Gm-Message-State: AAQBX9cwYtCe66qU/QIOXhirSrgS+2p80rBS+JdwaXBeGt5Fh1vFhR2t
        TFMbSJ96MsQb9EBR/fX4F0t+L1kqDcJyIcYZCQEmnz8AjwEf9A/hXdU=
X-Google-Smtp-Source: AKy350arg2s+GAcKzuo4vbCQF9JHdJBQbeL2qCzbBPULQaXQR64X0CufG3HSjgcla5mJyFtJYyV8rWeV1flBe7BNCIg=
X-Received: by 2002:a25:be11:0:b0:b7d:4c96:de0 with SMTP id
 h17-20020a25be11000000b00b7d4c960de0mr6885329ybk.5.1681302515601; Wed, 12 Apr
 2023 05:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <20230411130025.19704-1-kal.conley@dectris.com>
In-Reply-To: <20230411130025.19704-1-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 12 Apr 2023 14:28:24 +0200
Message-ID: <CAJ8uoz3W8uHQANJ2hxVydCbz7-d=kO9KKn_iBLX3wsWy-OGUvQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] xsk: Elide base_addr comparison in xp_unaligned_validate_desc
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

On Tue, 11 Apr 2023 at 15:03, Kal Conley <kal.conley@dectris.com> wrote:
>
> Remove redundant (base_addr >= pool->addrs_cnt) comparison from the
> conditional.
>
> In particular, addr is computed as:
>
>     addr = base_addr + offset
>
> where base_addr and offset are stored as 48-bit and 16-bit unsigned
> integers, respectively. The above sum cannot overflow u64 since
> base_addr has a maximum value of 0x0000ffffffffffff and offset has a
> maximum value of 0xffff (implying a maximum sum of 0x000100000000fffe).
> Since overflow is impossible, it follows that addr >= base_addr.
>
> Now if (base_addr >= pool->addrs_cnt), then clearly:
>
>     addr >= base_addr
>          >= pool->addrs_cnt
>
> Thus, (base_addr >= pool->addrs_cnt) implies (addr >= pool->addrs_cnt).
> Subsequently, the former comparison is unnecessary in the conditional
> since for any boolean expressions A and B, (A || B) && (A -> B) is
> equivalent to B.

Thanks Kal! Just checking again that you ran the xsk selftests on your
change and that it passed? If so, here is my ack.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  net/xdp/xsk_queue.h | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index 66c6f57c9c44..dea4f378327d 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -153,16 +153,12 @@ static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
>  static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
>                                               struct xdp_desc *desc)
>  {
> -       u64 addr, base_addr;
> -
> -       base_addr = xp_unaligned_extract_addr(desc->addr);
> -       addr = xp_unaligned_add_offset_to_addr(desc->addr);
> +       u64 addr = xp_unaligned_add_offset_to_addr(desc->addr);
>
>         if (desc->len > pool->chunk_size)
>                 return false;
>
> -       if (base_addr >= pool->addrs_cnt || addr >= pool->addrs_cnt ||
> -           addr + desc->len > pool->addrs_cnt ||
> +       if (addr >= pool->addrs_cnt || addr + desc->len > pool->addrs_cnt ||
>             xp_desc_crosses_non_contig_pg(pool, addr, desc->len))
>                 return false;
>
> --
> 2.39.2
>
