Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E496D73D4A
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404030AbfGXTvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 15:51:54 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:47037 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391707AbfGXTvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 15:51:52 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so48167940edr.13;
        Wed, 24 Jul 2019 12:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2p2ZfklHVEaOI9/2iCtD+yerzjFCKwVXOTunjKilUyg=;
        b=bFoeW529ejuAL1azYCFXDwwZiIKojlT53AEBYIQE493V9F2hmIMpWNNMYMyuedouB6
         Sfs0q/fXYDTeMHxjBC9GbtUNpcM4en6eXqDvF4577koXwZhd2X7v9WrYl5LrP83rTQxF
         a0jgfQxns67iKj6MkzBaqU4xi+tKgBQmYCFx/Tqx+cRGcA2h5LJzwhUMurzbBeqtryIq
         dyruxHxkK6fIJBZP8GQ8JLrVMKKv/TGpGloP8VPiYz3eQAyx/qlFaFkGqL3L9y2i/9D5
         MbrIySIPL4sGxM9qz07W9sBGzrSQCUc7sT+3+6FBbv/JRJfFjYIPrwa8x1b8vmo5aT/W
         fz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2p2ZfklHVEaOI9/2iCtD+yerzjFCKwVXOTunjKilUyg=;
        b=smN3qBO1sdjsXT7HUfFydkIDbkuAr6/02YufkbaXdu+3XWAzI25KL0vwwtzJr3fTAU
         k/7uSSMFCKb0zt8o5n+LX9J3IKixEoJ50YvRc6E/l4F/VVz/dNv+ahYI8E6D0wvjPglC
         lv+VWADLbm82iqoVcZTq2LEeM2guFrX4oS84MJE0VLQvbBhREvl/gObTzbO7HsnWNZNU
         1fW3ZvPK+GilkEK9oI3Ohb/x/SH1RtYzI/mkZvsAL9tKJjRNcFqev8oH12W6SDN9wrN6
         LWyksY2hV6Vkk9HZP4wAUT8u3HUzEUpgn63n6TqV2EpsNbU3EolUkk1AL8zcRX+6NZl/
         hCPw==
X-Gm-Message-State: APjAAAUOSnUZ40MS/2RdlhswDRNHBSfO4AAyPuUcr2OsTWoyJOx5I81U
        WnYqgxF2rA+NTIarUEan3H3raaJsNdOaMciVAVs=
X-Google-Smtp-Source: APXvYqz6lDBsK7IbvQCQQ8DzdG95VM5F+tel/b9fEJ/VBGexchGp+5i3AhySanNozFo55HqE6Gklar0VK6DseEVJEtg=
X-Received: by 2002:a50:eb8f:: with SMTP id y15mr73599212edr.31.1563997910491;
 Wed, 24 Jul 2019 12:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-5-brianvv@google.com>
In-Reply-To: <20190724165803.87470-5-brianvv@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 24 Jul 2019 15:51:14 -0400
Message-ID: <CAF=yD-LgN3-a1LtoN+EffvBYzw+7c29AUy5yVGJ1-iBpS0s2=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: support BPF_MAP_DUMP command
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 1:10 PM Brian Vazquez <brianvv@google.com> wrote:
>
> Make libbpf aware of new BPF_MAP_DUMP command and add bpf_map_dump and
> bpf_map_dump_flags to use them from the library.
>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tools/lib/bpf/bpf.c | 28 ++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h |  4 ++++
>  2 files changed, 32 insertions(+)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index c7d7993c44bb0..c1139b7db756a 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -368,6 +368,34 @@ int bpf_map_update_elem(int fd, const void *key, const void *value,
>         return sys_bpf(BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
>  }
>
> +int bpf_map_dump(int fd, const void *prev_key, void *buf, void *buf_len)
> +{
> +       union bpf_attr attr;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.dump.map_fd = fd;
> +       attr.dump.prev_key = ptr_to_u64(prev_key);
> +       attr.dump.buf = ptr_to_u64(buf);
> +       attr.dump.buf_len = ptr_to_u64(buf_len);
> +
> +       return sys_bpf(BPF_MAP_DUMP, &attr, sizeof(attr));
> +}

This can call bpf_map_dump_flags internally to avoid code duplication?

> +
> +int bpf_map_dump_flags(int fd, const void *prev_key, void *buf, void *buf_len,
> +                      __u64 flags)
> +{
> +       union bpf_attr attr;
> +
> +       memset(&attr, 0, sizeof(attr));
> +       attr.dump.map_fd = fd;
> +       attr.dump.prev_key = ptr_to_u64(prev_key);
> +       attr.dump.buf = ptr_to_u64(buf);
> +       attr.dump.buf_len = ptr_to_u64(buf_len);
> +       attr.dump.flags = flags;
> +
> +       return sys_bpf(BPF_MAP_DUMP, &attr, sizeof(attr));
> +}
> +
