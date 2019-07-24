Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3377412D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbfGXWBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:01:50 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33150 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfGXWBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:01:49 -0400
Received: by mail-qt1-f193.google.com with SMTP id r6so42887491qtt.0;
        Wed, 24 Jul 2019 15:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iCz2IMFEgYtpsiaPqVRSeU/gy5zfE8yEHnumCqXuCmY=;
        b=aGLR5rynOFb6xV1aNeI6iAwlo/zDoZFwfmnn+8UJN7B0JjX2GFUPadSflTn6IQgIwx
         FDbFEKS+hOyMX0W4HlxdlhbuwEztePwYH1PezrGqloFSNHAiXZmmFBbBKlKExz3FUPeG
         CcriJI3GuxlubvzSeRJYODXnzT2V7Di6UtCqknsJHkAIIuhwz+arq3wK+kb/j9Ul4U3n
         TjlZwX504FKgk65Pvf3ioXOHUMvBOwbPWFiThZ33n7/jvRJbyVScIcJMfq2/OzOBR8YC
         0UeUuOZbCMd0n1wlDP71ZfxurVERldi31cx/HKYtfenHkkU1gMLsTelBA7QN7NxUPSQH
         Ir6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iCz2IMFEgYtpsiaPqVRSeU/gy5zfE8yEHnumCqXuCmY=;
        b=HCWVURqDZp2zEda0bA6dKyJJxDGSJe64nAweios6Jj4J4gOygym+OFF718JpuMZZGB
         G6pIeB9s2bAJ3OCZc2Fdo7eSjNaaUvhCVm9r/GV+h88blOhmQuy7z5jnnVCaveLrRuGd
         v6E5NFBM0BwPoXffr7qi++m6Uykk+YwXEm1qyAVPiEboZ8KdLepuPzBAUQsUsyOp6Yv2
         t7utcB/eEcAtMgfqI1bt332BmYDLyMagQL8IVx1cr7hYKGCS0cd4/h2Ncu/DEcLXt6z2
         L2J0SIFnjsL54QFfNI1hK8coixBTxLaHQAzPKgdw0DKuQrdxridlOSMCPNy4Mxp+RIP2
         t8AA==
X-Gm-Message-State: APjAAAXlyHjEwbrghxpunISwdwEiE5KKgQTC8urCqnNkxHP87kK9qOIJ
        B8f/ZeKjrhhAo1NW2Xp2r8hpS2CLLXxJ/Igevjw=
X-Google-Smtp-Source: APXvYqzcRFGcF+9xmjdr5o3m+vYNcDJbGlfgWdNodqE802pFyJVpA5ZZ8O9TM1BmiGRZf0KBcdt5n+gJhb1SfIacEiQ=
X-Received: by 2002:ad4:4423:: with SMTP id e3mr47699791qvt.145.1564005707952;
 Wed, 24 Jul 2019 15:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-7-brianvv@google.com>
In-Reply-To: <20190724165803.87470-7-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 15:01:35 -0700
Message-ID: <CAPhsuW7248PfqX-PS2ioDx04iKY1g1S9W5amzwBLYNK-u_cLnA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/6] selftests/bpf: add test to measure
 performance of BPF_MAP_DUMP
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
>
> This tests compares the amount of time that takes to read an entire
> table of 100K elements on a bpf hashmap using both BPF_MAP_DUMP and
> BPF_MAP_GET_NEXT_KEY + BPF_MAP_LOOKUP_ELEM.
>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tools/testing/selftests/bpf/test_maps.c | 65 +++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
> index f7ab401399d40..c4593a8904ca6 100644
> --- a/tools/testing/selftests/bpf/test_maps.c
> +++ b/tools/testing/selftests/bpf/test_maps.c
> @@ -18,6 +18,7 @@
>  #include <sys/socket.h>
>  #include <netinet/in.h>
>  #include <linux/bpf.h>
> +#include <linux/time64.h>
>
>  #include <bpf/bpf.h>
>  #include <bpf/libbpf.h>
> @@ -389,6 +390,69 @@ static void test_hashmap_dump(void)
>         close(fd);
>  }
>
> +static void test_hashmap_dump_perf(void)
> +{
> +       int fd, i, max_entries = 100000;
> +       uint64_t key, value, next_key;
> +       bool next_key_valid = true;
> +       void *buf;
> +       u32 buf_len, entries;
> +       int j = 0;
> +       int clk_id = CLOCK_MONOTONIC;
> +       struct timespec begin, end;
> +       long long time_spent, dump_time_spent;
> +       double res;
> +       int tests[] = {1, 2, 230, 5000, 73000, 100000, 234567};
> +       int test_len = ARRAY_SIZE(tests);
> +       const int elem_size = sizeof(key) + sizeof(value);
> +
> +       fd = helper_fill_hashmap(max_entries);
> +       // Alloc memory considering the largest buffer
> +       buf = malloc(elem_size * tests[test_len-1]);
> +       assert(buf != NULL);
> +
> +test:
> +       entries = tests[j];
> +       buf_len = elem_size*tests[j];
> +       j++;
> +       clock_gettime(clk_id, &begin);
> +       errno = 0;
> +       i = 0;
> +       while (errno == 0) {
> +               bpf_map_dump(fd, !i ? NULL : &key,
> +                                 buf, &buf_len);
> +               if (errno)
> +                       break;
> +               if (!i)
> +                       key = *((uint64_t *)(buf + buf_len - elem_size));
> +               i += buf_len / elem_size;
> +       }
> +       clock_gettime(clk_id, &end);
> +       assert(i  == max_entries);
> +       dump_time_spent = NSEC_PER_SEC * (end.tv_sec - begin.tv_sec) +
> +                         end.tv_nsec - begin.tv_nsec;
> +       next_key_valid = true;
> +       clock_gettime(clk_id, &begin);
> +       assert(bpf_map_get_next_key(fd, NULL, &key) == 0);
> +       for (i = 0; next_key_valid; i++) {
> +               next_key_valid = bpf_map_get_next_key(fd, &key, &next_key) == 0;
> +               assert(bpf_map_lookup_elem(fd, &key, &value) == 0);
> +               key = next_key;
> +       }
> +       clock_gettime(clk_id, &end);
> +       time_spent = NSEC_PER_SEC * (end.tv_sec - begin.tv_sec) +
> +                    end.tv_nsec - begin.tv_nsec;
> +       res = (1-((double)dump_time_spent/time_spent))*100;
> +       printf("buf_len_%u:\t %llu entry-by-entry: %llu improvement %lf\n",
> +              entries, dump_time_spent, time_spent, res);
> +       assert(i  == max_entries);
              ^ extra space after i.

> +
> +       if (j < test_len)
> +               goto test;
> +       free(buf);
> +       close(fd);
> +}
> +
>  static void test_hashmap_zero_seed(void)
>  {
>         int i, first, second, old_flags;
> @@ -1758,6 +1822,7 @@ static void run_all_tests(void)
>         test_hashmap_walk(0, NULL);
>         test_hashmap_zero_seed();
>         test_hashmap_dump();
> +       test_hashmap_dump_perf();
>
>         test_arraymap(0, NULL);
>         test_arraymap_percpu(0, NULL);
> --
> 2.22.0.657.g960e92d24f-goog
>
