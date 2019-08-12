Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC79389ACD
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfHLKGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:06:55 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38998 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfHLKGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 06:06:55 -0400
Received: by mail-ot1-f66.google.com with SMTP id r21so150764996otq.6;
        Mon, 12 Aug 2019 03:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8nCPUFYSV3W2ZY/9ifJedm0QroBzrSP7heeMdjE0RYc=;
        b=dUtQ31FuyY2lGlBy1y1AG4y7lkQyg7ft8JrEFprD4sPlp5AZvxcNbEfmxXBu/cQcnV
         o/6S5ToiBsnRk2m7c2rYVo3Mx6LO20q4qXxSfMzmV36xwyLtb92p3crtdbN9w2rkfL43
         ZSA1yR8NMWYNtBgKPex3VwSOWkuP9emYKXHLQ5P6tscw80wVV7D/fdjwmtMIhq1WqP9H
         k3unDUqZENUGiurOH/iaTHrpZUh6nB4JHIR2W3Qxwmlp1bbIWJtszfXtedEo5R08z9th
         EkaJ90LYXfqoRBSy2w0Po2NRFfNk9a+zezHKL1kKRwJX6R2jelWe/NuQi2qz2wIl+xU/
         vNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8nCPUFYSV3W2ZY/9ifJedm0QroBzrSP7heeMdjE0RYc=;
        b=GI7aLP7S2mGV2YUdnxP0xgYnaQkDzfD1tC9PY8VfhkzzMYQq9Jbxbdhk9TgpujjLoZ
         DFPe2xwXaNW2WFmOR+L67Kz5rd89hYVgef7HTTjHVwekhs6Oa4qKqaDlgb8r+BHxWgyM
         zXBjhI/vcKbnbfJiUfNhOVV6WMpG2uQUlyzqqErWss+V3os8voTR5VUAWOaatXrWgkpp
         yBFD895VbJIrwFAu+rytskENIv/iHo148h9UUGGig8aMCiRbPuo4a4I4OB2rrbLo8QEn
         ESGD6ENJM6cvD2UoPLOCQy+LPz4IcVP8xZ2rLoJ0WRDI5zwrUvAwvqCcIK6osy7KorxR
         +AnQ==
X-Gm-Message-State: APjAAAVEUCKUzTxcUfLyC5G4vhca8ALH1oYr1nhRA6iNhwoleGj5D4pS
        6q/Wq0w6ZXpNYgCXu69n21tu32HhQ7BiQN6czxY=
X-Google-Smtp-Source: APXvYqxvqfA09aURLU8YM9tv/GT/gYr0AjzO6i/r2Gsv8wwZfS5HHnycPV8077bbQrYrQDoZ28O0i43Zg3+AJ/6SAy4=
X-Received: by 2002:a5e:d817:: with SMTP id l23mr33366249iok.282.1565604413971;
 Mon, 12 Aug 2019 03:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190812094242.44735-1-marc@koderer.com>
In-Reply-To: <20190812094242.44735-1-marc@koderer.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 12 Aug 2019 12:09:52 +0200
Message-ID: <CAOi1vP_SDOKzh+oyhv8gKVZwdWNY8NpTZ+oM+xSn+k1KCnu_sg@mail.gmail.com>
Subject: Re: [PATCH] net/ceph replace ceph_kvmalloc with kvmalloc
To:     Marc Koderer <marc@koderer.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 11:42 AM Marc Koderer <marc@koderer.com> wrote:
>
> There is nearly no difference between both implemenations.
> ceph_kvmalloc existed before kvmalloc which makes me think it's
> a leftover.
>
> Signed-off-by: Marc Koderer <marc@koderer.com>
> ---
>  net/ceph/buffer.c      |  3 +--
>  net/ceph/ceph_common.c | 11 -----------
>  net/ceph/crypto.c      |  2 +-
>  net/ceph/messenger.c   |  2 +-
>  4 files changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/net/ceph/buffer.c b/net/ceph/buffer.c
> index 5622763ad402..6ca273d2246a 100644
> --- a/net/ceph/buffer.c
> +++ b/net/ceph/buffer.c
> @@ -7,7 +7,6 @@
>
>  #include <linux/ceph/buffer.h>
>  #include <linux/ceph/decode.h>
> -#include <linux/ceph/libceph.h> /* for ceph_kvmalloc */
>
>  struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
>  {
> @@ -17,7 +16,7 @@ struct ceph_buffer *ceph_buffer_new(size_t len, gfp_t gfp)
>         if (!b)
>                 return NULL;
>
> -       b->vec.iov_base = ceph_kvmalloc(len, gfp);
> +       b->vec.iov_base = kvmalloc(len, gfp);
>         if (!b->vec.iov_base) {
>                 kfree(b);
>                 return NULL;
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 4eeea4d5c3ef..6c1769a815af 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -185,17 +185,6 @@ int ceph_compare_options(struct ceph_options *new_opt,
>  }
>  EXPORT_SYMBOL(ceph_compare_options);
>
> -void *ceph_kvmalloc(size_t size, gfp_t flags)
> -{
> -       if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
> -               void *ptr = kmalloc(size, flags | __GFP_NOWARN);
> -               if (ptr)
> -                       return ptr;
> -       }
> -
> -       return __vmalloc(size, flags, PAGE_KERNEL);
> -}
> -
>
>  static int parse_fsid(const char *str, struct ceph_fsid *fsid)
>  {
> diff --git a/net/ceph/crypto.c b/net/ceph/crypto.c
> index 5d6724cee38f..a9deead1e4ff 100644
> --- a/net/ceph/crypto.c
> +++ b/net/ceph/crypto.c
> @@ -144,7 +144,7 @@ void ceph_crypto_key_destroy(struct ceph_crypto_key *key)
>  static const u8 *aes_iv = (u8 *)CEPH_AES_IV;
>
>  /*
> - * Should be used for buffers allocated with ceph_kvmalloc().
> + * Should be used for buffers allocated with kvmalloc().
>   * Currently these are encrypt out-buffer (ceph_buffer) and decrypt
>   * in-buffer (msg front).
>   *
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 962f521c863e..f1f2fcc6f780 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -3334,7 +3334,7 @@ struct ceph_msg *ceph_msg_new2(int type, int front_len, int max_data_items,
>
>         /* front */
>         if (front_len) {
> -               m->front.iov_base = ceph_kvmalloc(front_len, flags);
> +               m->front.iov_base = kvmalloc(front_len, flags);
>                 if (m->front.iov_base == NULL) {
>                         dout("ceph_msg_new can't allocate %d bytes\n",
>                              front_len);

Hi Marc,

I'm working on a patch for https://tracker.ceph.com/issues/40481 which
changes ceph_kvmalloc() to properly deal with non-GFP_KERNEL contexts.
We can't switch to kvmalloc() because it doesn't actually fall back to
vmalloc() for GFP_NOFS or GFP_NOIO.

Thanks,

                Ilya
