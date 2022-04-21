Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB2750A062
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 15:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiDUNLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 09:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiDUNLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 09:11:31 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6264934B9F;
        Thu, 21 Apr 2022 06:08:41 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b5so3026098ile.0;
        Thu, 21 Apr 2022 06:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0gbAMjlBZ2KfVBxbajyk+nWcBqkToDNe664P1yHb2h8=;
        b=fZfLZf0fDNHzczSHqxQ9NSYKcWeJ9kjmggGHn4aAakuWlsCPvZUef27Gdo11/hB59Y
         Wp0BlFHzNBztbpkUNE7TIO9KNbw1og0kCWoj3s5mnV9jCmtyfFFYnwADRmIOk0gLu/JB
         A/X1G54mO3M3mHKwP8y89aXQJX2RHCgX3/rINdMvZ3fapBC/4rMGfYXU/bw6dgHEU+EP
         FQAMsjBR9Z4/elpb1jFrjhPOdE20Opn1u+cx/YtATm58F/rByVLq+prmKM5gtcwd46km
         FrbRORDP+DjfvOzfG7dzun+yUWZ7WJM4HPClsHJLYKqCe7RPpReSUJm1mnVYmE/pGIzE
         2SQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0gbAMjlBZ2KfVBxbajyk+nWcBqkToDNe664P1yHb2h8=;
        b=SSaKgtaKE6mRzMTfzpRCAviP/t2nTg4wWCSK+2yzovja4SXIS5Eemki731ds5mncJv
         c5zwAcjh6XRVBRKbn4mglXlHkQr3Yr91bjleUUDW5n11RHtgNA1xjgRcpTThsTdLwtul
         wa+4g4Ed0yzczm1pVqRI07M8mQv3P6EuZt03LPc4cDJwN7EFZX+CC2+3kHQsa0zhVeBk
         5O01s5g079IZ5qBUXgrDcfrvI31a0UvFCg6B743NGas6ZP9p/vWK2Y90bibQgGtG7ksk
         PgMZY/OIztfyeN2OBKOuClPwKoIA/YfmHRXFvNL1EnvwE3NRGKvstQdQwbSFuqaNOX9H
         3PVQ==
X-Gm-Message-State: AOAM533jdkHl5QHPV1eKNRNPmWRBe4FFBRBeLKOKLXXxD7zHVUzorLqe
        H300Atn8nYcE22SLgWjIx0kK8XgVvCmzYCTE0Y4OmVIAW6DzdetF
X-Google-Smtp-Source: ABdhPJy0UJj0XTD3mtaTIV/QqIeSQwf1HNsW6okbbbK/hyj3Rl0YMplqM/8Ymi0e2jtfurOS5n1ASP2B9AuqeLHwXZw=
X-Received: by 2002:a92:c548:0:b0:2cc:47f1:815 with SMTP id
 a8-20020a92c548000000b002cc47f10815mr5623592ilj.257.1650546520453; Thu, 21
 Apr 2022 06:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220421094320.1563570-1-asavkov@redhat.com>
In-Reply-To: <20220421094320.1563570-1-asavkov@redhat.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Thu, 21 Apr 2022 21:08:04 +0800
Message-ID: <CALOAHbB=kSKat5bLMTD+kSz-XD9o2z6Anr_np_wA9PXmcu0rRw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix map tests errno checks
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Thu, Apr 21, 2022 at 5:43 PM Artem Savkov <asavkov@redhat.com> wrote:
>
> Switching to libbpf 1.0 API broke test_lpm_map and test_lru_map as error
> reporting changed. Instead of setting errno and returning -1 bpf calls
> now return -Exxx directly.
> Drop errno checks and look at return code directly.
>
> Fixes: b858ba8c52b6 ("selftests/bpf: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK")

Ah, it is caused by the LIBBPF_STRICT_DIRECT_ERRS.

> Signed-off-by: Artem Savkov <asavkov@redhat.com>

Reviewed-by: Yafang Shao <laoar.shao@gmail.com>

P.S: It seems that other files which use libbpf 1.0 API mode are also
impacted, and it seems you are working on fixing them, thanks.

> ---
>  tools/testing/selftests/bpf/test_lpm_map.c | 39 +++++--------
>  tools/testing/selftests/bpf/test_lru_map.c | 66 ++++++++--------------
>  2 files changed, 37 insertions(+), 68 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_lpm_map.c b/tools/testing/selftests/bpf/test_lpm_map.c
> index 789c9748d241..c028d621c744 100644
> --- a/tools/testing/selftests/bpf/test_lpm_map.c
> +++ b/tools/testing/selftests/bpf/test_lpm_map.c
> @@ -408,16 +408,13 @@ static void test_lpm_ipaddr(void)
>
>         /* Test some lookups that should not match any entry */
>         inet_pton(AF_INET, "10.0.0.1", key_ipv4->data);
> -       assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -ENOENT);
>
>         inet_pton(AF_INET, "11.11.11.11", key_ipv4->data);
> -       assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd_ipv4, key_ipv4, &value) == -ENOENT);
>
>         inet_pton(AF_INET6, "2a00:ffff::", key_ipv6->data);
> -       assert(bpf_map_lookup_elem(map_fd_ipv6, key_ipv6, &value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd_ipv6, key_ipv6, &value) == -ENOENT);
>
>         close(map_fd_ipv4);
>         close(map_fd_ipv6);
> @@ -474,18 +471,15 @@ static void test_lpm_delete(void)
>         /* remove non-existent node */
>         key->prefixlen = 32;
>         inet_pton(AF_INET, "10.0.0.1", key->data);
> -       assert(bpf_map_lookup_elem(map_fd, key, &value) == -1 &&
> -               errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd, key, &value) == -ENOENT);
>
>         key->prefixlen = 30; // unused prefix so far
>         inet_pton(AF_INET, "192.255.0.0", key->data);
> -       assert(bpf_map_delete_elem(map_fd, key) == -1 &&
> -               errno == ENOENT);
> +       assert(bpf_map_delete_elem(map_fd, key) == -ENOENT);
>
>         key->prefixlen = 16; // same prefix as the root node
>         inet_pton(AF_INET, "192.255.0.0", key->data);
> -       assert(bpf_map_delete_elem(map_fd, key) == -1 &&
> -               errno == ENOENT);
> +       assert(bpf_map_delete_elem(map_fd, key) == -ENOENT);
>
>         /* assert initial lookup */
>         key->prefixlen = 32;
> @@ -530,8 +524,7 @@ static void test_lpm_delete(void)
>
>         key->prefixlen = 32;
>         inet_pton(AF_INET, "192.168.128.1", key->data);
> -       assert(bpf_map_lookup_elem(map_fd, key, &value) == -1 &&
> -               errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd, key, &value) == -ENOENT);
>
>         close(map_fd);
>  }
> @@ -552,8 +545,7 @@ static void test_lpm_get_next_key(void)
>         assert(map_fd >= 0);
>
>         /* empty tree. get_next_key should return ENOENT */
> -       assert(bpf_map_get_next_key(map_fd, NULL, key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, NULL, key_p) == -ENOENT);
>
>         /* get and verify the first key, get the second one should fail. */
>         key_p->prefixlen = 16;
> @@ -565,8 +557,7 @@ static void test_lpm_get_next_key(void)
>         assert(key_p->prefixlen == 16 && key_p->data[0] == 192 &&
>                key_p->data[1] == 168);
>
> -       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
>
>         /* no exact matching key should get the first one in post order. */
>         key_p->prefixlen = 8;
> @@ -590,8 +581,7 @@ static void test_lpm_get_next_key(void)
>                next_key_p->data[1] == 168);
>
>         memcpy(key_p, next_key_p, key_size);
> -       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
>
>         /* Add one more element (total three) */
>         key_p->prefixlen = 24;
> @@ -614,8 +604,7 @@ static void test_lpm_get_next_key(void)
>                next_key_p->data[1] == 168);
>
>         memcpy(key_p, next_key_p, key_size);
> -       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
>
>         /* Add one more element (total four) */
>         key_p->prefixlen = 24;
> @@ -643,8 +632,7 @@ static void test_lpm_get_next_key(void)
>                next_key_p->data[1] == 168);
>
>         memcpy(key_p, next_key_p, key_size);
> -       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
>
>         /* Add one more element (total five) */
>         key_p->prefixlen = 28;
> @@ -678,8 +666,7 @@ static void test_lpm_get_next_key(void)
>                next_key_p->data[1] == 168);
>
>         memcpy(key_p, next_key_p, key_size);
> -       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_get_next_key(map_fd, key_p, next_key_p) == -ENOENT);
>
>         /* no exact matching key should return the first one in post order */
>         key_p->prefixlen = 22;
> diff --git a/tools/testing/selftests/bpf/test_lru_map.c b/tools/testing/selftests/bpf/test_lru_map.c
> index a6aa2d121955..4d0650cfb5cd 100644
> --- a/tools/testing/selftests/bpf/test_lru_map.c
> +++ b/tools/testing/selftests/bpf/test_lru_map.c
> @@ -175,24 +175,20 @@ static void test_lru_sanity0(int map_type, int map_flags)
>                                     BPF_NOEXIST));
>
>         /* BPF_NOEXIST means: add new element if it doesn't exist */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
> -              /* key=1 already exists */
> -              && errno == EEXIST);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
> +       /* key=1 already exists */
>
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, -1) == -1 &&
> -              errno == EINVAL);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, -1) == -EINVAL);
>
>         /* insert key=2 element */
>
>         /* check that key=2 is not found */
>         key = 2;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* BPF_EXIST means: update existing element */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
> -              /* key=2 is not there */
> -              errno == ENOENT);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
> +       /* key=2 is not there */
>
>         assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
>
> @@ -200,8 +196,7 @@ static void test_lru_sanity0(int map_type, int map_flags)
>
>         /* check that key=3 is not found */
>         key = 3;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* check that key=1 can be found and mark the ref bit to
>          * stop LRU from removing key=1
> @@ -217,8 +212,7 @@ static void test_lru_sanity0(int map_type, int map_flags)
>
>         /* key=2 has been removed from the LRU */
>         key = 2;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* lookup elem key=1 and delete it, then check it doesn't exist */
>         key = 1;
> @@ -381,8 +375,7 @@ static void test_lru_sanity2(int map_type, int map_flags, unsigned int tgt_free)
>         end_key = 1 + batch_size;
>         value[0] = 4321;
>         for (key = 1; key < end_key; key++) {
> -               assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -                      errno == ENOENT);
> +               assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>                 assert(!bpf_map_update_elem(lru_map_fd, &key, value,
>                                             BPF_NOEXIST));
>                 assert(!bpf_map_lookup_elem_with_ref_bit(lru_map_fd, key, value));
> @@ -562,8 +555,7 @@ static void do_test_lru_sanity5(unsigned long long last_key, int map_fd)
>         assert(!bpf_map_lookup_elem_with_ref_bit(map_fd, key, value));
>
>         /* Cannot find the last key because it was removed by LRU */
> -       assert(bpf_map_lookup_elem(map_fd, &last_key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(map_fd, &last_key, value) == -ENOENT);
>  }
>
>  /* Test map with only one element */
> @@ -711,21 +703,18 @@ static void test_lru_sanity7(int map_type, int map_flags)
>                                     BPF_NOEXIST));
>
>         /* BPF_NOEXIST means: add new element if it doesn't exist */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
> -              /* key=1 already exists */
> -              && errno == EEXIST);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
> +       /* key=1 already exists */
>
>         /* insert key=2 element */
>
>         /* check that key=2 is not found */
>         key = 2;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* BPF_EXIST means: update existing element */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
> -              /* key=2 is not there */
> -              errno == ENOENT);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
> +       /* key=2 is not there */
>
>         assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
>
> @@ -733,8 +722,7 @@ static void test_lru_sanity7(int map_type, int map_flags)
>
>         /* check that key=3 is not found */
>         key = 3;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* check that key=1 can be found and mark the ref bit to
>          * stop LRU from removing key=1
> @@ -757,8 +745,7 @@ static void test_lru_sanity7(int map_type, int map_flags)
>
>         /* key=2 has been removed from the LRU */
>         key = 2;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         assert(map_equal(lru_map_fd, expected_map_fd));
>
> @@ -805,21 +792,18 @@ static void test_lru_sanity8(int map_type, int map_flags)
>         assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
>
>         /* BPF_NOEXIST means: add new element if it doesn't exist */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -1
> -              /* key=1 already exists */
> -              && errno == EEXIST);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST) == -EEXIST);
> +       /* key=1 already exists */
>
>         /* insert key=2 element */
>
>         /* check that key=2 is not found */
>         key = 2;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* BPF_EXIST means: update existing element */
> -       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -1 &&
> -              /* key=2 is not there */
> -              errno == ENOENT);
> +       assert(bpf_map_update_elem(lru_map_fd, &key, value, BPF_EXIST) == -ENOENT);
> +       /* key=2 is not there */
>
>         assert(!bpf_map_update_elem(lru_map_fd, &key, value, BPF_NOEXIST));
>         assert(!bpf_map_update_elem(expected_map_fd, &key, value,
> @@ -829,8 +813,7 @@ static void test_lru_sanity8(int map_type, int map_flags)
>
>         /* check that key=3 is not found */
>         key = 3;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         /* check that key=1 can be found and do _not_ mark ref bit.
>          * this will be evicted on next update.
> @@ -853,8 +836,7 @@ static void test_lru_sanity8(int map_type, int map_flags)
>
>         /* key=1 has been removed from the LRU */
>         key = 1;
> -       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -1 &&
> -              errno == ENOENT);
> +       assert(bpf_map_lookup_elem(lru_map_fd, &key, value) == -ENOENT);
>
>         assert(map_equal(lru_map_fd, expected_map_fd));
>
> --
> 2.35.1
>


-- 
Regards
Yafang
