Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066BB52F57B
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353820AbiETWFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243602AbiETWFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:05:03 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE7A13F90;
        Fri, 20 May 2022 15:05:02 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id m2so9618787vsr.8;
        Fri, 20 May 2022 15:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vEa8wOAy1yjkPGX5niq7cKlzEqEbn5vgGX01uFZeyx0=;
        b=pf70By7pF1e4r2VxjsJ+FR0Y8tv1NHuzHngxTbWZ4GdEEmJFJRgFbpOAbwK+6OMDmo
         HOvHve0yGJJSxZqdrIQ2BZry2tZa3COk6oPdZ+A++RYVd+PQVLNsNFMfPlz+YsdaWQV8
         3mHnHJbDXP8vf77dloAQ6q43VBjMCXepxMrst0GTmUtgics4M3b4YsJNeycrrJZUM5Qz
         mAdTnX/o+Duku4LqfFR34vbyjHYPjxIpW7sBGc1Eet99H6RajPD4lMbQfruCKJOBXN5G
         sB2UFGzQugUs5xojtTwkqJF+3sjfGMiHR69OxghqKVkML9qWYKJZDe3EkZM3xLsSIcI4
         NXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vEa8wOAy1yjkPGX5niq7cKlzEqEbn5vgGX01uFZeyx0=;
        b=5vFid8GigkJ5F+XG39D1PWKyZdOeKs78ACXpkaWv2OEHuvS0YU7JwdvxqehWdbHAMC
         R0Smk5W75cHLEOEQYZcQ2c8pIMQedNxlXYlJhCLkzC6H8Z07nrvEdKusFymDs0B+2WvO
         Rh8AdNimQFGUCFs0WwBKL0CxZuUqAjuxYuN6JrHAAPy8Dx6c7UrqttciKTro2cP6Io6K
         t2mSHu2SOlvymVRm+iTq9lAVDuBkni5JMUcZhYTwtepPeFUmWJd3dEwzU0OINUhCFDFJ
         wRukI8zwkIqDQrBqWADpYzTuycM3wua2HOw0sOkJS84pF2QzwDIoFB1HqMAWwK9Yn9Ud
         krMQ==
X-Gm-Message-State: AOAM531xtyZ/JLOJDSWAYi6SuHlWxaSFMqDy4qfdpqsZ3wbpS2jS2Zog
        ajKhBW0SvHR2QSHhU9wSqJxHJWg0IK/bWQ98B35sMho9
X-Google-Smtp-Source: ABdhPJylF+Cpre/GiNn3g19TPGrcInAvsIOw3/g+SromJnXzeeMISXrmlBvn+4RN1atdrpxe1dwbke3HGSoWnNXtBmc=
X-Received: by 2002:a67:f745:0:b0:335:e652:c692 with SMTP id
 w5-20020a67f745000000b00335e652c692mr4980498vso.52.1653084301990; Fri, 20 May
 2022 15:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652870182.git.lorenzo@kernel.org> <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
In-Reply-To: <e95abdd9c6fa1fa97f3ca60e8eb06799784e671a.1652870182.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 May 2022 15:04:47 -0700
Message-ID: <CAEf4BzZuKOR2y1LOzZLWm1sMFw3psPuzFcoYJ-yj0+PgzB2C1g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 5/5] selftests/bpf: add selftest for
 bpf_xdp_ct_add and bpf_ct_refresh_timeout kfunc
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, pabeni@redhat.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Wed, May 18, 2022 at 3:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce selftests for the following kfunc helpers:
> - bpf_xdp_ct_add
> - bpf_skb_ct_add
> - bpf_ct_refresh_timeout
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../testing/selftests/bpf/prog_tests/bpf_nf.c |  4 ++
>  .../testing/selftests/bpf/progs/test_bpf_nf.c | 72 +++++++++++++++----
>  2 files changed, 64 insertions(+), 12 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index dd30b1e3a67c..be6c5650892f 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -39,6 +39,10 @@ void test_bpf_nf_ct(int mode)
>         ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
>         ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
>         ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
> +       ASSERT_EQ(skel->bss->test_add_entry, 0, "Test for adding new entry");
> +       ASSERT_EQ(skel->bss->test_succ_lookup, 0, "Test for successful lookup");
> +       ASSERT_TRUE(skel->bss->test_delta_timeout > 9 && skel->bss->test_delta_timeout <= 10,
> +                   "Test for ct timeout update");

if/when this fails we'll have "true != false" message not knowing what
was the actual value of skel->bss->test_delta_timeout.

This is equivalent to a much better:

ASSERT_GT(skel->bss->test_delta_timeout, 9, "ct_timeout1");
ASSERT_LE(skel->bss->test_delta_timeout, 10, "ct_timeout2");

>  end:
>         test_bpf_nf__destroy(skel);
>  }


[...]
