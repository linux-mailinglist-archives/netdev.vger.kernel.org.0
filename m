Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76276C2CE8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbjCUIs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCUIsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:48:04 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39524617A;
        Tue, 21 Mar 2023 01:47:23 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id j7so16134477ybg.4;
        Tue, 21 Mar 2023 01:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679388441;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BBcmCiZrY50ZVCjcfSorkVtQXTza6Z7SWwBdqZaP/I4=;
        b=jbbXeahRIqpklGCp3MMQY1+jUyR8wUFH0caEcc0b0DmB1P+wNncEkjPsSf353eg/7G
         d3dZkKvPH2/Z1nh/s0WulwtfPsUM60B+NLbpP8AmLFXU3s/3k9LTCXJUFMsGXGtabdCS
         bslaPjaxVJY3cm4x3Pfuap23HzOqlRVMHERY0KYJzPp2lZ6gDyKF9gxPciuwMjHI7lCH
         p+7OiRuEPi1jmpc3yek4j7JMfLrwMisttLNRNFkjTG+2qZu2AY1j8Rt+dDy8PeFOkDcg
         UFjILYnGHhb2KEUUsgvHDNQuCHQ9F5Uhf5I9laD2Vftwj5VkfY3B1GvSGBqSnkk1T4Cz
         RFWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388441;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BBcmCiZrY50ZVCjcfSorkVtQXTza6Z7SWwBdqZaP/I4=;
        b=Kut79ysIsxL+rjG8QCOOtCnG/BqQIjLPiOl2AXyRvDU0ZGkxahC/vTAO7ApGgrLt8w
         6e70Xwi5XtyaNWBWfQstbEoqcPsfGOaCwu+fwNBbyFpEXwo89gKqO+Z2ZaecvFX1pNqo
         U6VxAMD8WuDDEiNq4jHtNEZTxNsOZgyqtk136LnnNMMnBKURb5TWHQjbqn6FSbn8WJhF
         r02E1KaZha8hIW+aZTSWkJldVfOaR7miq0/6RQLMBL9qWhTEIEqtGLubDVrXegeN3ZkT
         8zSMGzyFJ0/pfoL54ugk9Xa4xiFNBbA8vEaY3K+sYFqGKnFTI5Y6pppjt+LYqyQgRBg4
         dkqg==
X-Gm-Message-State: AAQBX9eKjrn4DGCFruL6zr+J+8PvY4pUofHNx9AIlBhjGhmuDCd6UYgP
        QmD+whghO+4D9iFO9BMTi+T1Slo37TEmRFfbQVw=
X-Google-Smtp-Source: AKy350ah4ZHOodkxV7oojAcvrqsXLiq4Vm5Q1MNdWojdKwbYAju+Jmek2XYJr95HmruI+ZHpqKTBHqmWyXC1J7AvSh4=
X-Received: by 2002:a05:6902:1104:b0:9fc:e3d7:d60f with SMTP id
 o4-20020a056902110400b009fce3d7d60fmr728215ybu.5.1679388441642; Tue, 21 Mar
 2023 01:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20230319195656.326701-1-kal.conley@dectris.com>
 <20230319195656.326701-4-kal.conley@dectris.com> <CAJ8uoz3F-gWzB9vYm-8MtonAv3aBcerJDxPpEDCNfmNkwJFY=A@mail.gmail.com>
In-Reply-To: <CAJ8uoz3F-gWzB9vYm-8MtonAv3aBcerJDxPpEDCNfmNkwJFY=A@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 21 Mar 2023 09:47:10 +0100
Message-ID: <CAJ8uoz2LU14oCAGSmUMfxMytF0KsiBGK55n+A7qPBuxpXBz6gA@mail.gmail.com>
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

On Tue, 21 Mar 2023 at 09:45, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
>
> On Sun, 19 Mar 2023 at 21:07, Kal Conley <kal.conley@dectris.com> wrote:
> >
> > Add tests:
> > - RUN_TO_COMPLETION_8K_FRAME_SIZE: frame_size=8192 (aligned)
> > - RUN_TO_COMPLETION_9K_FRAME_SIZE: frame_size=9000 (unaligned)
> >
> > Signed-off-by: Kal Conley <kal.conley@dectris.com>
> > ---
> >  tools/testing/selftests/bpf/xskxceiver.c | 24 ++++++++++++++++++++++++
> >  tools/testing/selftests/bpf/xskxceiver.h |  2 ++
> >  2 files changed, 26 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
> > index 7a47ef28fbce..f10ff8c5e9c5 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.c
> > +++ b/tools/testing/selftests/bpf/xskxceiver.c
> > @@ -1789,6 +1789,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
> >                 pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
> >                 testapp_validate_traffic(test);
> >                 break;
> > +       case TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME:
> > +               if (!hugepages_present(test->ifobj_tx)) {
> > +                       ksft_test_result_skip("No 2M huge pages present.\n");
> > +                       return;
> > +               }
> > +               test_spec_set_name(test, "RUN_TO_COMPLETION_8K_FRAME_SIZE");
> > +               test->ifobj_tx->umem->frame_size = 8192;
> > +               test->ifobj_rx->umem->frame_size = 8192;
> > +               pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
> > +               testapp_validate_traffic(test);
> > +               break;
> > +       case TEST_TYPE_RUN_TO_COMPLETION_9K_FRAME:
>
> TEST_TYPE_UNALIGNED_9K_FRAME
>
> > +               if (!hugepages_present(test->ifobj_tx)) {
> > +                       ksft_test_result_skip("No 2M huge pages present.\n");
> > +                       return;
> > +               }
> > +               test_spec_set_name(test, "RUN_TO_COMPLETION_9K_FRAME_SIZE");
>
> UNALIGNED_MODE_9K

_9K_FRAME_SIZE it should have been. Hit send too early.

> > +               test->ifobj_tx->umem->frame_size = 9000;
> > +               test->ifobj_rx->umem->frame_size = 9000;
> > +               test->ifobj_tx->umem->unaligned_mode = true;
> > +               test->ifobj_rx->umem->unaligned_mode = true;
> > +               pkt_stream_replace(test, DEFAULT_PKT_CNT, PKT_SIZE);
> > +               testapp_validate_traffic(test);
> > +               break;
> >         case TEST_TYPE_RX_POLL:
> >                 test->ifobj_rx->use_poll = true;
> >                 test_spec_set_name(test, "POLL_RX");
> > diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> > index 3e8ec7d8ec32..ff723b6d7852 100644
> > --- a/tools/testing/selftests/bpf/xskxceiver.h
> > +++ b/tools/testing/selftests/bpf/xskxceiver.h
> > @@ -70,6 +70,8 @@ enum test_mode {
> >  enum test_type {
> >         TEST_TYPE_RUN_TO_COMPLETION,
> >         TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
> > +       TEST_TYPE_RUN_TO_COMPLETION_8K_FRAME,
> > +       TEST_TYPE_RUN_TO_COMPLETION_9K_FRAME,
> >         TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
> >         TEST_TYPE_RX_POLL,
> >         TEST_TYPE_TX_POLL,
> > --
> > 2.39.2
> >
