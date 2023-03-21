Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5A56C2CDA
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCUIrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCUIqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:46:53 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1946A15C94;
        Tue, 21 Mar 2023 01:45:58 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id l16so6569883ybe.6;
        Tue, 21 Mar 2023 01:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679388356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ou0zA2Nuc2lATXbmKOtaTMcIXxsKlzHd+kdeuMaNI9s=;
        b=ZuTUSTBThfJDp99rMaTqO2wP4QU3Tgml1Z8DKsW0uS3JA+veVJOyhk8rlcoM0/DYHq
         t3L5kA3f3sZqlU08udiNkkMhYlLigH08LMpn/KGDBVTY2JQbk0Z1lPkE9HtuiufX7O54
         42aLkYZPrK0pu8Kfm4Ek7IRLvyUum+AuyrQQpy48lSY8mltg0bSenlH6LfTy9CikwbC8
         pkcyOHMvBTmquCaizeKqX42LVMuLvv4qpSE0qkbtEvLNnYsW0JwLkr6/ijBkn316+S3O
         nJyDQm/jZKE1M0Ec9r/mBIj/ln7gAZ3LHciDHx1vJkXtA2YYMv7k8En9SOlG4LfYdgPg
         XwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ou0zA2Nuc2lATXbmKOtaTMcIXxsKlzHd+kdeuMaNI9s=;
        b=erioeBTcPnAE3psie6o4kpHCsdquJrT0hx+36wr5mjRFtfrSulpJU3U2jZqGnefen9
         P+l6fGZr7Gn66psZZyb4igXrgOBnZx1HUqS967oRuGIkrM8FEqBI0cKcYiTg+l710hZo
         5GZ0J6o7rH1Zw2WfRoBNoCBBna0kHc1IziL163T2qLQvLm5N3tPz84tADSP4/9xQGOn+
         FF2qgasfVpZk5Qyvf/zLjdUc+NfVuAYKXcYlJQ5y/r0yuWL8YNF28mxdCujPC8fPkFTo
         1/JIY9t/iqHVDh/mu+p3AjQriN3LbkyoV1UhvBSrdC8vv5Lqb4fRvPLAOAtUnYzVzkde
         H7qw==
X-Gm-Message-State: AAQBX9cZl5xdv95+Z4IoD8Ay37vkyykibtHjMq0dQla7HXqbBuUtMiCL
        aEq4Q67bHoATWhr9iguoYo9Sdpc7hgTmkfxLCzBITOYoma5Idg==
X-Google-Smtp-Source: AKy350YFHa9pCJfNl6wKOFH8qdb7QbqI+PjWezxi99rhGTo8JSPTYrstYADsZfKTB5Q97p8wo2RgPZUTfIgcbRKN/sQ=
X-Received: by 2002:a5b:3c8:0:b0:b67:f07:d180 with SMTP id t8-20020a5b03c8000000b00b670f07d180mr898411ybp.5.1679388356617;
 Tue, 21 Mar 2023 01:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230319195656.326701-1-kal.conley@dectris.com> <20230319195656.326701-4-kal.conley@dectris.com>
In-Reply-To: <20230319195656.326701-4-kal.conley@dectris.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Mar 2023 09:45:45 +0100
Message-ID: <CAJ8uoz3F-gWzB9vYm-8MtonAv3aBcerJDxPpEDCNfmNkwJFY=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests: xsk: Add tests for 8K and 9K
 frame sizes
To:     Kal Conley <kal.conley@dectris.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Sun, 19 Mar 2023 at 21:07, Kal Conley <kal.conley@dectris.com> wrote:
>
> Add tests:
> - RUN_TO_COMPLETION_8K_FRAME_SIZE: frame_size=8192 (aligned)
> - RUN_TO_COMPLETION_9K_FRAME_SIZE: frame_size=9000 (unaligned)
>
> Signed-off-by: Kal Conley <kal.conley@dectris.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++++++++++++++
>  tools/testing/selftests/bpf/xskxceiver.h |  2 ++
>  2 files changed, 26 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> index 7a47ef28fbce..f10ff8c5e9c5 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.c
> +++ b/tools/testing/selftests/bpf/xskxceiver.c
> @@ -1789,6 +1789,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
>                 pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
>                 testapp_validate_traffic(test);
>                 break;
> +       case TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME:
> +               if (!hugepages_present(test->ifobj_tx)) {
> +                       ksft_test_result_skip("No 2M huge pages present.\n");
> +                       return;
> +               }
> +               test_spec_set_name(test, "RUN_TO_COMPLETION_8K_FRAME_SIZE");
> +               test->ifobj_tx->umem->frame_size = 8192;
> +               test->ifobj_rx->umem->frame_size = 8192;
> +               pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
> +               testapp_validate_traffic(test);
> +               break;
> +       case TEST_TYPE_RUN_TO_COMPLETION_9K_FRAME:

TEST_TYPE_UNALIGNED_9K_FRAME

> +               if (!hugepages_present(test->ifobj_tx)) {
> +                       ksft_test_result_skip("No 2M huge pages present.\n");
> +                       return;
> +               }
> +               test_spec_set_name(test, "RUN_TO_COMPLETION_9K_FRAME_SIZE");

UNALIGNED_MODE_9K

> +               test->ifobj_tx->umem->frame_size = 9000;
> +               test->ifobj_rx->umem->frame_size = 9000;
> +               test->ifobj_tx->umem->unaligned_mode = true;
> +               test->ifobj_rx->umem->unaligned_mode = true;
> +               pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
> +               testapp_validate_traffic(test);
> +               break;
>         case TEST_TYPE_RX_POLL:
>                 test->ifobj_rx->use_poll = true;
>                 test_spec_set_name(test, "POLL_RX");
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index 3e8ec7d8ec32..ff723b6d7852 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -70,6 +70,8 @@ enum test_mode {
>  enum test_type {
>         TEST_TYPE_RUN_TO_COMPLETION,
>         TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> +       TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME,
> +       TEST_TYPE_RUN_TO_COMPLETION_9K_FRAME,
>         TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
>         TEST_TYPE_RX_POLL,
>         TEST_TYPE_TX_POLL,
> --
> 2.39.2
>
