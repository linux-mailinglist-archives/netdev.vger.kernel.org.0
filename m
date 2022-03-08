Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6CC4D0FB4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 07:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343696AbiCHGET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 01:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbiCHGES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 01:04:18 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1D9338AE;
        Mon,  7 Mar 2022 22:03:21 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id q11so5200338iod.6;
        Mon, 07 Mar 2022 22:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jdj7UvN4JlhtbGcBhBgVL5c92dLwKF5liiIiJPmclNk=;
        b=RzBVKh9xt7w5vqKVgzGOB38zm3dXdN40cAbUcD34ErUe0Bccin0ZnwHgoTV3EM+3s+
         yAQmgNMwSDsfXGmDVNYGwys7J0oce9DqPI+6uE8nRjmEFgrROMdmOPE9Dd8/5wgt4o7L
         v/6on9wLsw9sjOiiIgWartFuCvIuSXBEs3VNEFROzlAEqkCRmXngGO1clSnOEiBHnVRg
         A+VcSjHXCZUX+dpNBiwCveDZd1m5cmGzc64nEmetUbTx37Vim94+FO77k53mdEd54S11
         f+F57LpCjsB4A9IC95YUOuFysr2ALBtR/QYUmLyikBZyl7pw0UmeyaslZYaiNMjxvstZ
         K3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jdj7UvN4JlhtbGcBhBgVL5c92dLwKF5liiIiJPmclNk=;
        b=c8yY/F1vDpr8saqL4W5UM6UtaeJu7U0YW19KPUFm3WyNyo9Iv5+SKa5vXfKL8fVyoV
         jvFYYohNOQ6wvCd/WnXcF8t+3ez87G6nf3cKvEuCfowlTHG8acHXp81ZqOPoT1/tYf4j
         h3s/vPzxvzg4R+hbiCc5y2cD6xf9wcXgDDyYNLZ1eXrWY37oqs7w13kz52EhxiedtlFq
         18fUmB/vAluez/ZAsODpSzAlVuCRwCERu9KyQnM1nwFE7PUOT1I3d6tkbFdI1+2GTO9K
         UBYRrfLCiu8yQS5zMqBpmc6tasX8hYaSYb26kiyEWoPjBvlEICBd103NWkkY4p7sBIOL
         lPrw==
X-Gm-Message-State: AOAM532q+J5W5qkjHN3v/r2Uv6me4qFEGsSixIk4YDDJB7z82Q4oyrdt
        Y+W7Gi7rjWqILpSQDLXnqwJUyEjDklD8y0ccYpk=
X-Google-Smtp-Source: ABdhPJwezQtoIgRReqYdIawmVjRwaVU9F0VeFr5yitfBdNleVnAM2hurtGtco6eYjEEvBKCrhbyperM36DsiXchS+Vo=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr4437860ioi.154.1646719400724; Mon, 07
 Mar 2022 22:03:20 -0800 (PST)
MIME-Version: 1.0
References: <20220301132623.GA19995@vscode.7~>
In-Reply-To: <20220301132623.GA19995@vscode.7~>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 22:03:09 -0800
Message-ID: <CAEf4BzYm=3Awdz2H32JC6bB4anCY40=+_LWF6E57CbR8a9TFxg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: unmap rings when umem deleted
To:     lic121 <lic121@chinatelecom.cn>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Tue, Mar 1, 2022 at 5:26 AM lic121 <lic121@chinatelecom.cn> wrote:
>
> xsk_umem__create() does mmap for fill/comp rings, but xsk_umem__delete()
> doesn't do the unmap. This works fine for regular cases, because
> xsk_socket__delete() does unmap for the rings. But for the case that
> xsk_socket__create_shared() fails, umem rings are not unmapped.
>
> fill_save/comp_save are checked to determine if rings have already be
> unmapped by xsk. If fill_save and comp_save are NULL, it means that the
> rings have already been used by xsk. Then they are supposed to be
> unmapped by xsk_socket__delete(). Otherwise, xsk_umem__delete() does the
> unmap.
>
> Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
> Signed-off-by: lic121 <lic121@chinatelecom.cn>
> ---

Applied to bpf-next as well. Changed the name to Cheng Li while
applying. Thanks.

>  tools/lib/bpf/xsk.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index edafe56..32a2f57 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -1193,12 +1193,23 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
>
>  int xsk_umem__delete(struct xsk_umem *umem)
>  {
> +       struct xdp_mmap_offsets off;
> +       int err;
> +
>         if (!umem)
>                 return 0;
>
>         if (umem->refcount)
>                 return -EBUSY;
>
> +       err = xsk_get_mmap_offsets(umem->fd, &off);
> +       if (!err && umem->fill_save && umem->comp_save) {
> +               munmap(umem->fill_save->ring - off.fr.desc,
> +                      off.fr.desc + umem->config.fill_size * sizeof(__u64));
> +               munmap(umem->comp_save->ring - off.cr.desc,
> +                      off.cr.desc + umem->config.comp_size * sizeof(__u64));
> +       }
> +
>         close(umem->fd);
>         free(umem);
>
> --
> 1.8.3.1
>
