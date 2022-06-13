Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0425489D6
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378206AbiFMNnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 09:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378245AbiFMNmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 09:42:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE59B2AE03;
        Mon, 13 Jun 2022 04:31:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id e24so5393567pjt.0;
        Mon, 13 Jun 2022 04:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nMWdvtrj+OldWO4NXe/eIDkQiub7F0ElQKShA7oIA/U=;
        b=SZUntsOha3tO0F6PwuNxu1ozWXb8cwOE380d2nvDcLNrTjpa/4rvPqbEXfo+kXGZHZ
         JuWgMftKXrS9+Mdr3Ims5kvP4fEjWdGhQKn9qi3UnmTN926/IF8Obhk8PRs0tu3Nu5vd
         1yY5x21ovneKiPNKg1wEBCjvhzUiyMbxbW8ufBFRBa0FkVFYJb4e24Ox3d9ffwglxuum
         Wmhe9LGC6bnUNZjsXYBwa5dJK4SaBqX03XucW5fE5G7WwZ1lVZWj6TtKAAgqioqXSeLY
         jgU2QpjQT/Lo4XPO8vj8GGxdiQ1keryNKSwg+nNlwk6VADCuJvn7tHaYnPJrpoOpoEWg
         Wt4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nMWdvtrj+OldWO4NXe/eIDkQiub7F0ElQKShA7oIA/U=;
        b=BoehAHZRC3SQNWLYDLbs/61pFKYewK7MWQnDouIAm+U+QKeYkppmVmB7aTikb9dlUF
         nDZk1eChoB4GWUDnqaY8IiQyqtH+/j4GTX00vzQLR2+UCzLlV1fGs2ukPKKh5gbgmtS0
         c3pLftfa2DZkP27MXtkBoELme5B69GE9FbqWO6TnrKMSKddinZBGgL3G16sdjFj5yHzk
         k0d0Dl/6Cduhx89yqh6MjeOok+ivMeNK6s36xSTnDZMFMyY2FwTYe1vA8eKOnHW8OxS8
         BmzJI/vJeBvOTp01apDFGSdVAuo7GW2YsvxwqKNoBDgx/aoQIVHkUH1YibtsRtZd0/IK
         /pjw==
X-Gm-Message-State: AOAM53144eXh2SXWWfG7XtDnEcX2HNwDkcW/rSGg4OQVfCugKGi8mwqV
        tenzbe0prXzxRJgeoLoGAtoo8RzSe1Xg6dE+nyI=
X-Google-Smtp-Source: ABdhPJwR/CayTGe/JfBieNEzO+8XfjRtDXxh3CH/yxaDn94X6k+ACFtFSlTiLzqULOg4dJUQzlmGqQE6R4I7mL3nwoM=
X-Received: by 2002:a17:90b:350d:b0:1e6:7780:6c92 with SMTP id
 ls13-20020a17090b350d00b001e677806c92mr15335101pjb.46.1655119890346; Mon, 13
 Jun 2022 04:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com> <20220610150923.583202-9-maciej.fijalkowski@intel.com>
In-Reply-To: <20220610150923.583202-9-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 13 Jun 2022 13:31:19 +0200
Message-ID: <CAJ8uoz1ftdghLf+vwhPu2_kuggGiRyG6jMMKc2tOCgxvqVamnw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 08/10] selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 10, 2022 at 5:40 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Some of the drivers that implement support for AF_XDP Zero Copy (like
> ice) can have lazy approach for cleaning Tx descriptors. For ZC, when
> descriptor is cleaned, it is placed onto AF_XDP completion queue. This
> means that current implementation of wait_for_tx_completion() in
> xdpxceiver can get onto infinite loop, as some of the descriptors can
> never reach CQ.
>
> This function can be changed to rely on pkts_in_flight instead.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 3 ++-
>  tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 316f1dd338fc..c9385690af09 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -965,7 +965,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>
>  static void wait_for_tx_completion(struct xsk_socket_info *xsk)
>  {
> -       while (xsk->outstanding_tx)
> +       while (pkts_in_flight)
>                 complete_pkts(xsk, BATCH_SIZE);
>  }
>
> @@ -1269,6 +1269,7 @@ static void *worker_testapp_validate_rx(void *arg)
>                 pthread_mutex_unlock(&pacing_mutex);
>         }
>
> +       pkts_in_flight = 0;
>         pthread_exit(NULL);
>  }
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index b7aa6c7cf2be..f364a92675f8 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -170,6 +170,6 @@ pthread_barrier_t barr;
>  pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
>  pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
>
> -int pkts_in_flight;
> +volatile int pkts_in_flight;
>
>  #endif                         /* XDPXCEIVER_H */
> --
> 2.27.0
>
