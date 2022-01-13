Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5360348E0AE
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 23:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238110AbiAMW4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 17:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbiAMW4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 17:56:54 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37FFC061574
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 14:56:53 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id p5so19279281ybd.13
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 14:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdLBfNgvUFOklxfhjYz1A331Y+Tddvzy2s727R0/HE8=;
        b=PaOKxkfRo0RD1yP5Lci3dW1kXB/cJTOcNZQvZ9RQUkQKshA0+wDBoSVu93Vdd4sjCQ
         ZN0YK0AAeNpUNnEffpHDVQQ9cWvFob1RfEBnrE4h3c0I6h5Gp0gEpBH6jmlozSQzy8re
         Zuw+nuGbKb9Y5sf9F0vUT2gdUp9S5evflDKg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdLBfNgvUFOklxfhjYz1A331Y+Tddvzy2s727R0/HE8=;
        b=gYFPjOBMs+9WNxDDJUkgI24RHK7nN5oCQ1P8GGMBUKTNrRd3+dV4f/f61JHylbgOge
         lMC5fFhY8dtxNdcdAaFD/CczHDZAl74RlGqV2mq50NmFiFN1N/H/hAGGTpqYiC7IEmwB
         BRv3wAP0rvYC8xW3PrOm+m3hhqo1u+1BJM14tVqsikPWhj/iPuZQbQsh94H3dPyvefAi
         nl6sQ+yOOw42z8DJ16KlxY4Zi1IHynDAb52VjyxlGx3uig4EnhZVRbn6HFmDTAYie7+0
         1K4KGxApLSebkAGDEKrSzlREmnAbCbsgQ9OH/vBJVMR3NBY/Ak5lAMymAzE4XARYISFz
         FZ2w==
X-Gm-Message-State: AOAM530VlTGOXw9hZv4UNkJyV1ALOp+bBvdvH9xcFJtf8m+blptWYgSn
        HaILx0PDLVFTFWBYBfQLhz60h88Kh2LZF2JpHlMIEw==
X-Google-Smtp-Source: ABdhPJzGbrMynQ7+aMQIVDpW80Bpn1ZGmuWQ9yG5AskVlcM5ahCzRUbFTotiM58HTj+CFF9MGCzUOQ3Jrtn2rS/lwO8=
X-Received: by 2002:a25:7482:: with SMTP id p124mr8486408ybc.266.1642114612866;
 Thu, 13 Jan 2022 14:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20220111192952.49040-1-ivan@cloudflare.com> <CAA93jw6HKLh857nuh2eX2N=siYz5wwQknMaOtpkqLzpfWTGhuA@mail.gmail.com>
In-Reply-To: <CAA93jw6HKLh857nuh2eX2N=siYz5wwQknMaOtpkqLzpfWTGhuA@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Thu, 13 Jan 2022 14:56:42 -0800
Message-ID: <CABWYdi0ZHYvzzP9SFOCJhnfyMP12Ot9ALEmXg75oeXBWRAD8KQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tcp: bpf: Add TCP_BPF_RCV_SSTHRESH for bpf_setsockopt
To:     Dave Taht <dave.taht@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 1:02 PM Dave Taht <dave.taht@gmail.com> wrote:
> I would not use the word "latency" in this way, I would just say
> potentially reducing
> roundtrips...

Roundtrips translate directly into latency on high latency links.

> and potentially massively increasing packet loss, oversaturating
> links, and otherwise
> hurting latency for other applications sharing the link, including the
> application
> that advertised an extreme window like this.

The receive window is going to scale up to tcp_rmem[2] with traffic,
and packet loss won't stop it. That's around 3MiB on anything that's
not embedded these days.

My understanding is that congestion control on the sender side deals
with packet loss, bottleneck saturation, and packet pacing. This patch
only touches the receiving side, letting the client scale up faster if
they choose to do so. I don't think any out of the box sender will
make use of this, even if we enable it on the receiver, just because
the sender's congestion control constraints are lower (like
initcwnd=10).

Let me know if any of this doesn't look right to you.

> This overall focus tends to freak me out somewhat, especially when
> faced with further statements that cloudflare is using an initcwnd of 250!???

Congestion window is a learned property, not a static number. You
won't get a large initcwnd towards a poor connection.

We have a dedicated backbone with different properties.
