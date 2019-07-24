Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7685874072
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfGXUxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:53:12 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43048 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGXUxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 16:53:12 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so9149646qka.10;
        Wed, 24 Jul 2019 13:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5EpkRFFvgeAt0nL+hNBcZ+U2NkFxnbvcSf3cki+3DA=;
        b=PO7hinLFq3VFv+ooVfZfkXHUFKFsUauDMz7qczK0IejHr9Xbvef73lKFG7PUClE09N
         jpXXO3hwY78SrylxapqREKIH/tXYzqVOzetb7kOm1IkAO2/P4aM3VZcGmZQJUiGj0V2E
         T6HuDnb5PWbJoDEFvOEqXAVtHNDgEowEluhoZG9zgOlxJXzi4XIlufKYFvm4Y/itVCzv
         cYPTDkin1sJujrBFaeoFQmCZ9bwanBSYl8ZhtuQJFJ71kiyyi/JnRCKnonYCvABMCemR
         HFE+RfiZ1P8u3MAxWc7bvaIBjFF6Zh8RY3dQxrm5KSYLKJZpfdIZP8IQyKqtM6uQW/pj
         3O5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5EpkRFFvgeAt0nL+hNBcZ+U2NkFxnbvcSf3cki+3DA=;
        b=JVievqKYKMMpRmcOWEh9Tb5/SjFeN9o/WIdq+jSQUfzZWNWiX8/ypqHRBwJJ+PnkUg
         HVYP8WJ5A8jDp4/uSwr1MQzg/SJNKRLsPgv+ftI7t3YW+ht11ATKcF4QRHILm49VBR5g
         EeFW0NjTfqZ0jLs3yfCMRzZ73bUflvkEMEDDPqVFYJURepDjTGFUCzY5LE0QjLw0KxL8
         LFVmfyykwI6IQDsONNnfhKSkACu1Axi+vNgkIZLXiCQ2xp1iBO4UMyUj3zWTZjemoHvY
         mdiQ7Vf0sd5SKCWWqZKTVdpItTLvcyrJxhmtuao+C3kOSlNiu5w1UEskpg+oAj4yf0tC
         veOQ==
X-Gm-Message-State: APjAAAWkelVgbfqrp7yLbpwG49zWSc7qN8cTQyRSs9ACNK864WgbIKhz
        KBe/sTJvEEYZ7KH65ETnxsc/RNQBXkufncFsOHpsR5Su
X-Google-Smtp-Source: APXvYqycjV23O2jrVhScZbVxlyvDRHLnHUWOh7urEY5E8B0lZkIFywjV65DeQv3X/fGC4vS0gF9Ab++9zBMlilHwQeM=
X-Received: by 2002:a37:6d85:: with SMTP id i127mr55779207qkc.74.1564001591445;
 Wed, 24 Jul 2019 13:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-2-brianvv@google.com>
In-Reply-To: <20190724165803.87470-2-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 13:53:00 -0700
Message-ID: <CAPhsuW5dXr4X9O3JtOVe=K+9yXzUY=WQuSgvhNWDKbJ57bnFAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] bpf: add bpf_map_value_size and
 bp_map_copy_value helper functions
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
> Move reusable code from map_lookup_elem to helper functions to avoid code
> duplication in kernel/bpf/syscall.c
>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

Some very minor nits though.

> ---
>  kernel/bpf/syscall.c | 134 +++++++++++++++++++++++--------------------
>  1 file changed, 73 insertions(+), 61 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 5d141f16f6fa9..86cdc2f7bb56e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -126,6 +126,76 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>         return map;
>  }
>
> +static u32 bpf_map_value_size(struct bpf_map *map)
> +{
> +       if (map->map_type == BPF_MAP_TYPE_PERCPU_HASH ||
> +           map->map_type == BPF_MAP_TYPE_LRU_PERCPU_HASH ||
> +           map->map_type == BPF_MAP_TYPE_PERCPU_ARRAY ||
> +           map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE)
> +               return round_up(map->value_size, 8) * num_possible_cpus();
> +       else if (IS_FD_MAP(map))
> +               return sizeof(u32);
> +       else
> +               return  map->value_size;
                  ^ extra space after return

> +}
> +
> +static int bpf_map_copy_value(struct bpf_map *map, void *key, void *value,
> +                             __u64 flags)
> +{
> +       void *ptr;
> +       int err;
> +
> +       if (bpf_map_is_dev_bound(map))
> +               return  bpf_map_offload_lookup_elem(map, key, value);
                  ^ another extra space after return, did replace? :-)

Thanks,
Song
