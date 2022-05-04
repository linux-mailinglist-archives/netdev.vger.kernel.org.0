Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DB5192A1
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243628AbiEDARH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236338AbiEDARG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:17:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B6613F37;
        Tue,  3 May 2022 17:13:33 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id e24so16762109pjt.2;
        Tue, 03 May 2022 17:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lrv6JjVDd5xci3Uj6JO2t4bk1n/CIJ8pZC08DqD624o=;
        b=e1wd40kzz7Uy/yWBPhgZBC/CaIu14Vk0TzUilfDKSMMeng0rNwQy4KRWjcDEK/2jwu
         D7hLk+gSOi+pvYTAjAjj5HB9FX2EqJ+4TGGhkvuDSfNX1eXvWsp8itTI9OIrblpf8PyR
         sb4grZUbNAIPEXgGywx+zNEjRoL1aYy/uIDGFIOb3oygLdk56yCPHOnIQtsR3ag+gZDX
         lNKwNhklTNuuv9rHFD8k5ipSL843CcS/ITUaM+fCCHA6wqqW5p4GSKYamVjUMniMa/FI
         rs6qehTa+17+rG2iALcWMUJWoQfd9rWdW7p2SPaZyliwXhydVd3oTxPlVzNZkT2O0psW
         APeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lrv6JjVDd5xci3Uj6JO2t4bk1n/CIJ8pZC08DqD624o=;
        b=GReeqfe8JqIo6g0Lml78yNdEztE+Ue5sjiOS85HxUCWCQsgDOFYyWYqmSd/QZkNNjm
         W6Nr3MZDCFXAtAAHJe9MqPeq5V6oQSKu4Yqprm9rhS+z+iFJVYhwSJcNIh66v3X9687e
         NzxK0UV9uy6Q3EC7VuiF/qhKKLNG2kSeQh1TqX0pE1679N7jM5xtWQxiCkqxUYcoVP7N
         Prvg5d+K8EfiiY4udjYJV+UEes+7238gkzPWPuk7GlWan6FkDgO21iuKcIkdfq/xxwLJ
         dns7v/OMg2qJ/e82CKDAeegJRYYpdowUk6+o+pYgLqT12WYqst3SI0S0br4IIzRX7Utx
         9Tuw==
X-Gm-Message-State: AOAM530oRyBvgQPKKthWx7eYiVKmN3EPr7EVCb8/M4f94NiK0Ybqhg0S
        ddHmN4+DqzZQMJVNyHypx0kWcH1wyX7T7puTK5qimSztfHk=
X-Google-Smtp-Source: ABdhPJz00iQB2Y9B32Quwzz7cnnxKMyU4mGjSvyUnFvEbWkiQdmw6EtrbRmf+Vgu8mHC++10yZr+tsebwuyUVkKNPg0=
X-Received: by 2002:a17:903:2d1:b0:156:7ceb:b56f with SMTP id
 s17-20020a17090302d100b001567cebb56fmr19325260plk.11.1651623212627; Tue, 03
 May 2022 17:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220502213705.1170077-1-ctakshak@fb.com> <20220502213705.1170077-2-ctakshak@fb.com>
In-Reply-To: <20220502213705.1170077-2-ctakshak@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 May 2022 17:13:21 -0700
Message-ID: <CAADnVQJjmd4Y0aMePdO+19UMPFTLQEUo3uDN_sAYPBY9FnKi8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/2] selftests/bpf: handle batch operations
 for map-in-map bpf-maps
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, ndixit@fb.com,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
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

On Mon, May 2, 2022 at 2:37 PM Takshak Chahande <ctakshak@fb.com> wrote:
>
> This patch adds up test cases that handles 4 combinations:
>  a) outer map: BPF_MAP_TYPE_ARRAY_OF_MAPS
>     inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
>  b) outer map: BPF_MAP_TYPE_HASH_OF_MAPS
>     inner maps: BPF_MAP_TYPE_ARRAY and BPF_MAP_TYPE_HASH
>
> Signed-off-by: Takshak Chahande <ctakshak@fb.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---
>  .../bpf/map_tests/map_in_map_batch_ops.c      | 245 ++++++++++++++++++
>  1 file changed, 245 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/map_tests/map_in_map_batch_ops.c
>
> v3->v4:
> - Addressed nits; kept this map test together in map_tests/  (Yonghong, Andrii)

Looks like it's causing another test to fail in CI.
https://github.com/kernel-patches/bpf/runs/6264834580?check_suite_focus=true
