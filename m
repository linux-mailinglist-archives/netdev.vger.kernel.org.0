Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4676A31715E
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 21:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhBJU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 15:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhBJU2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 15:28:31 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A48C061574;
        Wed, 10 Feb 2021 12:27:49 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id k4so3341689ybp.6;
        Wed, 10 Feb 2021 12:27:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Fig8xpbsaW+Bl7CpYvOTWbVnzyDhnErcbBrbtE4md8=;
        b=mC1zTrBRp7e6tc2p5CkzMoAMGxWerVoGSFpOIEQsvabQtTjUAsyc6/cMDnEp8UtQ5i
         jaJhYvPARoYpDbhnPQtzKJJG2IMIrmbAfQYXMYKMpeFqa8Qh1+7jlvzr0BC7RM/bwODA
         jV5XgNqi8LlCGTvOdcQsZFguV5ygj2k2BrIpFMabKZkC3BQPQDsO2J+rLQ+qq43uLMGw
         e33s9yg5jqSnNuivP/SpUkXPVZaPv/HcJ8VPm0b9eibigG5KL7JOryhA0JBlnsbSK1yQ
         D9lMgQkFZ1qh8LePy/mZfm2U1MLs/V/ixQf0Hvz8/+ODeHYkWtxQv/2ZyLIQtSxOCEq+
         0BXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Fig8xpbsaW+Bl7CpYvOTWbVnzyDhnErcbBrbtE4md8=;
        b=aiGEy1WmMjGT1JSTAazXMUItbNygayuarh5TwzGytB0oVhHCDkZL++zORIqCp47ins
         yczQoIkFWDSkCRnIT0ST82zKXmFiE+qL+NIxQl9TsdYQuh8h20YK0l2ama6sVBebxDto
         6WQujschJTG45nrqnbt3J9gkX53vT2MgGPHjChuer9j3/fngNc6zpH8aJ3TDTjTlXT1b
         nbW4lbwk5RhY4bLRw6D28PbTC6eU0FNfecJKLrtfkuF2HPs/w3PmOCdbgYzsai1fnsV5
         2YTGJdmQ58YPuFpuFgHsfRnESKFvR4qHOLwpdGq9/vfu4W25b92YEibor+crZG6bi1hT
         Tmjg==
X-Gm-Message-State: AOAM533bUf/ppk0y75QXtHVfEiX/RJjnwauo9Fnj2/gwcYXmlVZC23vz
        VVkKk7pyBNkTZOI97KCWkT0huYNJX48mgGShmCi4w4pq1FG4Dw==
X-Google-Smtp-Source: ABdhPJyCFETFmX50Li29uERLQKy0Ge43WuewjW0KIPG1gIPnlvRYh7aRFKsvCsLatnsleTrYyXwZ5ISbcDcwV4wm1JI=
X-Received: by 2002:a25:c905:: with SMTP id z5mr6617093ybf.260.1612988868917;
 Wed, 10 Feb 2021 12:27:48 -0800 (PST)
MIME-Version: 1.0
References: <20210209193105.1752743-1-kafai@fb.com> <20210209193112.1752976-1-kafai@fb.com>
In-Reply-To: <20210209193112.1752976-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Feb 2021 12:27:38 -0800
Message-ID: <CAEf4BzbZmmezSxYLCOdeeA4zW+vdDvQH57wQ-qpFSKiMcE1tVw@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] bpf: selftests: Add non function pointer test to struct_ops
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 12:11 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch adds a "void *owner" member.  The existing
> bpf_tcp_ca test will ensure the bpf_cubic.o and bpf_dctcp.o
> can be loaded.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

What will happen if BPF code initializes such non-func ptr member?
Will libbpf complain or just ignore those values? Ignoring initialized
members isn't great.

>  tools/testing/selftests/bpf/bpf_tcp_helpers.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> index 6a9053162cf2..91f0fac632f4 100644
> --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> @@ -177,6 +177,7 @@ struct tcp_congestion_ops {
>          * after all the ca_state processing. (optional)
>          */
>         void (*cong_control)(struct sock *sk, const struct rate_sample *rs);
> +       void *owner;
>  };
>
>  #define min(a, b) ((a) < (b) ? (a) : (b))
> --
> 2.24.1
>
