Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D661D2CCCDE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgLCCva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgLCCv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 21:51:29 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBE1C061A4D;
        Wed,  2 Dec 2020 18:50:49 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id v14so557333lfo.3;
        Wed, 02 Dec 2020 18:50:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GMy68q9C7d+3KAE7LrIlWLnkERUxqm2R0QWsWVT69Ww=;
        b=DPeGZPTBWkJZdL9SzFtLhiqIX2JLnwNkNYiGvRDjwrpjVBUHLq88ZV3csYxHDd2esz
         DwY6BojRaWs2/EasoytbECNGYdX2+PT5p7XQ29GpyWOQ4PUxEDHRTrO0uv5kAh34pM1/
         TFv2SYzzCisykUtq0FqGSWuHz0W3E5lP/ygWYxEkmzBiYgIz1JiR5s90uTp2zQl9EZDj
         5OOIUPByYBvZq4n2dn/sHYTh3tNG5Inxxms+rEr34Zow4tSNxQdtmfWQIMK7kGPDHiLf
         ejwLk78sdl9GBaou3xS2MYXIYewbdhyIqxaebFREamE5L4+4cgfiey3efHdPHZHhtDqb
         L9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GMy68q9C7d+3KAE7LrIlWLnkERUxqm2R0QWsWVT69Ww=;
        b=m7Uly4QpitB8uqRojUjr+2t5nS7ecB8uo8ELCpVWn47cxA53Rp+iHgaZDJd0ABJV83
         5daB1m5MSPzqzdk6PWBsh5ya/SIa20VqTsteUMKdXOPNt8Rme3Q4b0/7oac25UkKPsr+
         NFiAZuOxxNQjeOfOMsRPBSO0PCSUAC+gN/AeW6BkaPx2++qb7V41pd3eTQW8Is7WWYW/
         KtZdqpqDm4wDSGuP4rUuOkIGdc+e8DJ+9LzNy0z5dmftV9+jEz1Vis4PFek5aPLYT2nx
         87dC3TesKkXYkv7uZ+vyZLdFsZMv1U+hbdTONR1e+Gs6ijVD29ExSTwgqkvjA76l01nk
         8QHA==
X-Gm-Message-State: AOAM530KYDNW/uftMJZYmrpSQaggmxwNJTwipHkPd5azFKnIeqoFf+cS
        jTlffSjsphv+Oiern/p5bJ75Yc63Hxn8yFC5554=
X-Google-Smtp-Source: ABdhPJyiIawTnpeiuWgZSTXo83O6jgNCSlnkbmUg41w6LXwofC3bgYQQ+doG36BI/J9+kx4fbKWC/PZbetOunC/zH6w=
X-Received: by 2002:a05:6512:3227:: with SMTP id f7mr448191lfe.119.1606963847604;
 Wed, 02 Dec 2020 18:50:47 -0800 (PST)
MIME-Version: 1.0
References: <20201202103923.12447-1-mariuszx.dudek@intel.com> <20201202103923.12447-3-mariuszx.dudek@intel.com>
In-Reply-To: <20201202103923.12447-3-mariuszx.dudek@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Dec 2020 18:50:36 -0800
Message-ID: <CAADnVQKorj773WzJLKvLxAXiKNdqr3dTL_A5GLns9FBrZQ5rxQ@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 2/2] samples/bpf: sample application for eBPF
 load and socket creation split
To:     mariusz.dudek@gmail.com
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 2:39 AM <mariusz.dudek@gmail.com> wrote:
>  int main(int argc, char **argv)
>  {
> +       struct __user_cap_header_struct hdr = { _LINUX_CAPABILITY_VERSION_3, 0 };
> +       struct __user_cap_data_struct data[2] = { { 0 } };
>         struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
>         bool rx = false, tx = false;
>         struct xsk_umem_info *umem;
>         struct bpf_object *obj;
> +       int xsks_map_fd = 0;
>         pthread_t pt;
>         int i, ret;
>         void *bufs;
>
>         parse_command_line(argc, argv);
>
> -       if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> -               fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
> -                       strerror(errno));
> -               exit(EXIT_FAILURE);
> +       if (opt_reduced_cap) {
> +               if (capget(&hdr, data)  < 0)
> +                       fprintf(stderr, "Error getting capabilities\n");
> +
> +               data->effective &= CAP_TO_MASK(CAP_NET_RAW);
> +               data->permitted &= CAP_TO_MASK(CAP_NET_RAW);
> +
> +               if (capset(&hdr, data) < 0)
> +                       fprintf(stderr, "Setting capabilities failed\n");
> +
> +               if (capget(&hdr, data)  < 0) {
> +                       fprintf(stderr, "Error getting capabilities\n");
> +               } else {
> +                       fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
> +                               data[0].effective, data[0].inheritable, data[0].permitted);
> +                       fprintf(stderr, "Capabilities EFF %x Caps INH %x Caps Per %x\n",
> +                               data[1].effective, data[1].inheritable, data[1].permitted);
> +               }
> +       } else {
> +               if (setrlimit(RLIMIT_MEMLOCK, &r)) {
> +                       fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
> +                               strerror(errno));
> +                       exit(EXIT_FAILURE);
> +               }

Due to this hunk the patch had an unpleasant conflict with Roman's set
and I had to drop this set from bpf-next.
Please rebase and resend.

But it made me look into this change...why did you make rlimit conditional here?
That doesn't look right.
