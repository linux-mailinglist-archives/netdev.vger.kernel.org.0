Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41AE20ECCA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 06:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgF3ErY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 00:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgF3ErX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 00:47:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA00C061755;
        Mon, 29 Jun 2020 21:47:23 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id h19so20850308ljg.13;
        Mon, 29 Jun 2020 21:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=daIZyTHIPdbyeKvYiblnWQv2KSo0hTAfj7ReUORgrLs=;
        b=BN9xTgwT7WfcP+fNoc3TcEc47SGCNW9ReSYwNbOsturRTrtitOlcrHfZ02fygnEymJ
         ZFzq0uPZOFrqfo4tZjtTyebRKhKBlSqtWy/DssXL6Xo2PlptuwK5/PajMWE6zhA7HQ3p
         /uocEvOJdsr4wXSBsK1r0Hx6uqMSbEed3t7vH1GwH2C+h5cSj8x0qSqK5JsARWQl5C6Q
         VOxhNGW5Eccvu9JbN09lXLpnKBuijRfyj4lrbe6jyRFhGyS3yFLS68xaK1jojvcgpMQR
         9Wb8uPZmOMAlw86o61yu0n5cvpl+BnSNo/6bolixNBW3MhyTL+O9f4fYCgTSF2iLYuPT
         hARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=daIZyTHIPdbyeKvYiblnWQv2KSo0hTAfj7ReUORgrLs=;
        b=k21ZmvSiSJyHIS5wiatcunVU65Cl4ND1EVF+XjotpMaunvaldVfLxy26vC+qdgc6zb
         P20/kZC2K4HIroEZWocmq3OLUVOWCpc5dit3x2hjXFVLotDhXZBSk1lbMR8cDU8lNA+W
         VblSXFEt+c5o+T1hXaAHe90a5H+wFIojTmcwbu5XjqZLL76Zomg44TaFMptWkb63+vQo
         r9/DlyEy4elVBvVSwZisEoX4M6JTUWH9qWwr6DOds+Qa46ur8OfzRFkCqAF1QBpp1Vi8
         JS/ou6FQ3RLrtZfIUFgu9424nj07FBHc2X4VQ1nK1uBC5FhzevsAmgldBYJR4lhjsIZR
         /N1w==
X-Gm-Message-State: AOAM5307zJFRGsBJ8JEmWctNNWZ7vMB8LybAehT3yISzF6Zws/GqXVbQ
        5o2y0/E4Sjo8uqse0jWRN4bQDRxOYwIXlucip24=
X-Google-Smtp-Source: ABdhPJyjO5UTeapZ72OBuwf5s91n7OeqMekNU+F8BIaXduWkUAIHWcjnZe9o5qr9xaqi9XzOSdZjvE+IstpfKrb2+1Q=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr5622422ljh.290.1593492441463;
 Mon, 29 Jun 2020 21:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200629221746.4033122-1-andriin@fb.com>
In-Reply-To: <20200629221746.4033122-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 29 Jun 2020 21:47:10 -0700
Message-ID: <CAADnVQLkPPxvFV4ZftGeTNWfhtVnGR+Y8NAYZUmuyOcU_M_Y8g@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: enforce BPF ringbuf size to be the power of 2
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 3:19 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> BPF ringbuf assumes the size to be a multiple of page size and the power of
> 2 value. The latter is important to avoid division while calculating position
> inside the ring buffer and using (N-1) mask instead. This patch fixes omission
> to enforce power-of-2 size rule.
>
> Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  kernel/bpf/ringbuf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
> index 180414bb0d3e..dcc8e8b9df10 100644
> --- a/kernel/bpf/ringbuf.c
> +++ b/kernel/bpf/ringbuf.c
> @@ -132,7 +132,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t data_sz, int numa_node)
>  {
>         struct bpf_ringbuf *rb;
>
> -       if (!data_sz || !PAGE_ALIGNED(data_sz))
> +       if (!is_power_of_2(data_sz) || !PAGE_ALIGNED(data_sz))
>                 return ERR_PTR(-EINVAL);

What's the point checking the same value in two different places?
The check below did that already.

>  #ifdef CONFIG_64BIT
> @@ -166,7 +166,8 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
>                 return ERR_PTR(-EINVAL);
>
>         if (attr->key_size || attr->value_size ||
> -           attr->max_entries == 0 || !PAGE_ALIGNED(attr->max_entries))
> +           !is_power_of_2(attr->max_entries) ||
> +           !PAGE_ALIGNED(attr->max_entries))
>                 return ERR_PTR(-EINVAL);
>
>         rb_map = kzalloc(sizeof(*rb_map), GFP_USER);
> --
> 2.24.1
>
