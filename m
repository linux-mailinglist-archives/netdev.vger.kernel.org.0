Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B1A5A799A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbiHaI5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiHaI4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:56:40 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B0713D4C;
        Wed, 31 Aug 2022 01:55:52 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j5so9645656plj.5;
        Wed, 31 Aug 2022 01:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KfqP3P5fzreqUNYWNqqi/aKR4WW6NY9UAjQRNRu9+Qk=;
        b=hIa7176CXKK35z9AVMa/XaFVWDpb5yjP+xlj/GiO89fhNWE4gtmTNjooGPlqZ+o994
         7Rdcqi7r+N+1xz4W5gP8qGxhxOCKYmY/axQ9fLB1mrAhdlqvgNjyYeWPhaH2k66JytIZ
         VPiPHN1rBshG6qgeBk91wPfP6c2SKSoMrHpGxW746IMoFhF9k6aoAQB9UFXJa80U+pV6
         1wW9H2+obpTGwGE/EB6WRbJ3mvb1XZVnQDgGmDCcklyE0sEEMkr5vEW8GgPw7DTlvDGF
         KdZUlWzJsmq21BwKPROJ40fbbnSRmtUX8dAVRZQr7sPWkElvf79G/87pcxKbaWM7VhfB
         JUHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KfqP3P5fzreqUNYWNqqi/aKR4WW6NY9UAjQRNRu9+Qk=;
        b=n7+IkV0I694J4rpXhKTvQ2D/kmn77oKWbRIcoiiePI33xCxwZH/iswHnezjL5ujCyH
         qurrjlH2dtBtblV5x/vPBu7K8EwEQ0lBVxmxKWOClEMy5VgzUFx5M0hRbJzmmJMEr+pq
         fZznIrtBAbASQl4GkjclgDNtzwhfZtMHtoVXnlWFHrW2Edd0qkKv6nFaedyuKtRPYLQL
         At44asPfGeCipSjUh3QK2mLJLdVRdhZuTnuGqZnxpyb8IJWpFG/e84DxDiLXsmI8QqRV
         aIzTPIJ00YkAGcJM0KkxVpXpepUdEH4OBC8vUL6adbD6+VYvXcmGPsu6N2+fu8El9IYr
         qx6w==
X-Gm-Message-State: ACgBeo1jOExBEkhzQi4iGd7225nuN0i3soKzVZN3c/ICFTjfLeh/D88u
        9qv8tMWgG9bhZnq/1U8VeKxgiALTxLRL2lrMv0k=
X-Google-Smtp-Source: AA6agR5Q7mDCACRvloh77FB6PS1ee4PLZBqEvQQFaTYcaEXQj3Teu0pIhv/TncaRvisJRDj1mcuXB6BJD911OydyUOs=
X-Received: by 2002:a17:902:d4c2:b0:172:c519:9004 with SMTP id
 o2-20020a170902d4c200b00172c5199004mr24457708plg.154.1661936151703; Wed, 31
 Aug 2022 01:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com> <20220830135604.10173-6-maciej.fijalkowski@intel.com>
In-Reply-To: <20220830135604.10173-6-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 31 Aug 2022 10:55:40 +0200
Message-ID: <CAJ8uoz2=OgOvh3xj5mGizMU9jbmzQEzdF_-ftn+Tync4-9W1_w@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/6] selftests: xsk: make sure single threaded
 test terminates
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
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

On Tue, Aug 30, 2022 at 4:14 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> For single threaded poll tests call pthread_kill() from main thread so
> that we are sure worker thread has finished its job and it is possible
> to proceed with next test types from test suite. It was observed that on
> some platforms it takes a bit longer for worker thread to exit and next
> test case sees device as busy in this case.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 4f8a028f5433..8e157c462cd0 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1345,6 +1345,11 @@ static void testapp_clean_xsk_umem(struct ifobject *ifobj)
>         munmap(ifobj->umem->buffer, umem_sz);
>  }
>
> +static void handler(int signum)
> +{
> +       pthread_exit(NULL);
> +}
> +
>  static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
>                                                   enum test_type type)
>  {
> @@ -1362,6 +1367,7 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
>         test->ifobj_rx->shared_umem = false;
>         test->ifobj_tx->shared_umem = false;
>
> +       signal(SIGUSR1, handler);
>         /* Spawn thread */
>         pthread_create(&t0, NULL, ifobj->func_ptr, test);
>
> @@ -1371,6 +1377,7 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
>         if (pthread_barrier_destroy(&barr))
>                 exit_with_error(errno);
>
> +       pthread_kill(t0, SIGUSR1);
>         pthread_join(t0, NULL);
>
>         if (test->total_steps == test->current_step || test->fail) {
> --
> 2.34.1
>
