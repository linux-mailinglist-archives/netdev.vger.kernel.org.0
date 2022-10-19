Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E4B605243
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJSVwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJSVwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:52:41 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF07192996;
        Wed, 19 Oct 2022 14:52:40 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-13ae8117023so743159fac.9;
        Wed, 19 Oct 2022 14:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f9RMYhC8HnulW5HipCdWjW2jvG1uG9+hyMRLGZVjYO4=;
        b=Uh4ftnT0LUl73pP5iwf+uLlz7+W6lt/1oLfPU6OKkSDljGOmRDv5/9WuBygY043bfV
         s6LaVF94fxFD2UnyqLNmUbxGirB48+fbgo+UBmcfCZl6cw4cFTagvN2XnJzLH5Rhxz1T
         LLWi4+BLjJyGGNEm2LIuenmQnjBMQhtim6Jfx6MLEkYBF6qq+P/4QPOasWPTUXAZgAwV
         vm96bQNx2vK1Onc02803yfM2vptja6Z5BpwEMGXdqQB/brKWJ1fpiJUZhx4Fn7p94Lux
         y9t6L3CUZW3N1A6bOe3rk9aQHkdhcY/+Us7CG+N/ZRkaRX0AGuoJ5bpzHSYzYhdpBezI
         qq/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f9RMYhC8HnulW5HipCdWjW2jvG1uG9+hyMRLGZVjYO4=;
        b=rSbXnCV/HfKKDg2YCpsLAjZngEX4QM38fcnQ8laEyfwT+AZOPg4n1RAlkR35VU4KE6
         bWnWW3d6Fk0f7Q9VFdXDZIYBtqF8lV1cNN69+FAwPl64xPTUYky9tKtuHLa84UjJnkY8
         7Qs4ahVbMl4K9eKrA/zwfAZI/GyZQIRr7eieAgLklISVrc3fcgf04pM1l9I5b+G+Kfq7
         eB2ytlLhOEnNDdc+kO5EF2L9FPa8XMDFJXiH+So4PYcfPx7pX/5W9B07Q2u+tkQZX2/d
         YBhfuMB71tL4NEdzPUpjbu783rrelgFIp6kqQm0/MN0rzgK5fVHOyO+tHCYoUz6CF6Rk
         1uJw==
X-Gm-Message-State: ACrzQf0bgSXrsipCpR/JfoveaQWxw93M389TRh7scK2MR22sukqSmw5g
        JyIIyMhX9RxsCHkE8WnnmnHdVVFg0JN0/AHSP0lVDAhMvW0=
X-Google-Smtp-Source: AMsMyM7iJQkhqI7bxWXaO/FqZum5ZcSmYhHtfC/rKvQCRET3anOifqis5Vbut1c5Dg/L8R8WUX6j91POILNeM4OugKg=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr23556205oaq.190.1666216360272; Wed, 19
 Oct 2022 14:52:40 -0700 (PDT)
MIME-Version: 1.0
References: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
In-Reply-To: <20221019180735.161388-1-aleksei.kodanev@bell-sw.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 19 Oct 2022 17:25:10 -0400
Message-ID: <CADvbK_fhsgfuuqOWp4Y=yJ-CbmU400U4PbGEran4BYW2zQfCbQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] sctp: remove unnecessary NULL check in sctp_association_init()
To:     Alexey Kodanev <aleksei.kodanev@bell-sw.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org
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

On Wed, Oct 19, 2022 at 2:29 PM Alexey Kodanev
<aleksei.kodanev@bell-sw.com> wrote:
>
> '&asoc->ulpq' passed to sctp_ulpq_init() as the first argument,
> then sctp_qlpq_init() initializes it and eventually returns the
> address of the struct member back. Therefore, in this case, the
> return pointer cannot be NULL.
>
> Moreover, it seems sctp_ulpq_init() has always been used only in
> sctp_association_init(), so there's really no need to return ulpq
> anymore.
>
> Detected using the static analysis tool - Svace.
> Signed-off-by: Alexey Kodanev <aleksei.kodanev@bell-sw.com>
> ---
>  include/net/sctp/ulpqueue.h | 3 +--
>  net/sctp/associola.c        | 4 +---
>  net/sctp/ulpqueue.c         | 5 +----
>  3 files changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/include/net/sctp/ulpqueue.h b/include/net/sctp/ulpqueue.h
> index 0eaf8650e3b2..60f6641290c3 100644
> --- a/include/net/sctp/ulpqueue.h
> +++ b/include/net/sctp/ulpqueue.h
> @@ -35,8 +35,7 @@ struct sctp_ulpq {
>  };
>
>  /* Prototypes. */
> -struct sctp_ulpq *sctp_ulpq_init(struct sctp_ulpq *,
> -                                struct sctp_association *);
> +void sctp_ulpq_init(struct sctp_ulpq *ulpq, struct sctp_association *asoc);
>  void sctp_ulpq_flush(struct sctp_ulpq *ulpq);
>  void sctp_ulpq_free(struct sctp_ulpq *);
>
> diff --git a/net/sctp/associola.c b/net/sctp/associola.c
> index 3460abceba44..63ba5551c13f 100644
> --- a/net/sctp/associola.c
> +++ b/net/sctp/associola.c
> @@ -226,8 +226,7 @@ static struct sctp_association *sctp_association_init(
>         /* Create an output queue.  */
>         sctp_outq_init(asoc, &asoc->outqueue);
>
> -       if (!sctp_ulpq_init(&asoc->ulpq, asoc))
> -               goto fail_init;
> +       sctp_ulpq_init(&asoc->ulpq, asoc);
>
>         if (sctp_stream_init(&asoc->stream, asoc->c.sinit_num_ostreams, 0, gfp))
>                 goto stream_free;
> @@ -277,7 +276,6 @@ static struct sctp_association *sctp_association_init(
>
>  stream_free:
>         sctp_stream_free(&asoc->stream);
> -fail_init:
>         sock_put(asoc->base.sk);
>         sctp_endpoint_put(asoc->ep);
>         return NULL;
> diff --git a/net/sctp/ulpqueue.c b/net/sctp/ulpqueue.c
> index 0a8510a0c5e6..24960dcb6a21 100644
> --- a/net/sctp/ulpqueue.c
> +++ b/net/sctp/ulpqueue.c
> @@ -38,8 +38,7 @@ static void sctp_ulpq_reasm_drain(struct sctp_ulpq *ulpq);
>  /* 1st Level Abstractions */
>
>  /* Initialize a ULP queue from a block of memory.  */
> -struct sctp_ulpq *sctp_ulpq_init(struct sctp_ulpq *ulpq,
> -                                struct sctp_association *asoc)
> +void sctp_ulpq_init(struct sctp_ulpq *ulpq, struct sctp_association *asoc)
>  {
>         memset(ulpq, 0, sizeof(struct sctp_ulpq));
>
> @@ -48,8 +47,6 @@ struct sctp_ulpq *sctp_ulpq_init(struct sctp_ulpq *ulpq,
>         skb_queue_head_init(&ulpq->reasm_uo);
>         skb_queue_head_init(&ulpq->lobby);
>         ulpq->pd_mode  = 0;
> -
> -       return ulpq;
>  }
>
>
> --
> 2.25.1
>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
