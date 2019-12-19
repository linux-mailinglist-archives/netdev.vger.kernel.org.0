Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B4D12711D
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLSXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 18:02:36 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38612 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfLSXCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 18:02:36 -0500
Received: by mail-qk1-f193.google.com with SMTP id k6so6088942qki.5;
        Thu, 19 Dec 2019 15:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M09H0ZMAaBQYslcyoATNj3Hi1r1I6SKTpimgZ+0tR4s=;
        b=bWG0dxC8qQ/ulgnsDc5r1GcT3msL3qcaVcnfsea9eDOiFK6CTo/S60Xb/i5t2LtYQN
         cUCLVo/+Q+KKibecYReaNopIrTSd9G9zcp8gqrSP8ZZeF9RhIwMPoxt4sDsn+UXii8br
         otbe9HF+Q+ERN75SVy2nPYMru9g2a9TWOyQvwDX23IYls+VZGNSJR59s5eHszIMPxgl1
         pFCinILWmBr8apGIflaL7l43TQZA2WfjEJhHBuLNfaWhrHG+vB3b8EV+DBdOX7UZF+V2
         b3UH8XC3XJ3H0mHyPUnVl96j5WcTuNt/Rp5/8G1wahIJpH0l3YNcU2176IJJ8zbypIeJ
         Gpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M09H0ZMAaBQYslcyoATNj3Hi1r1I6SKTpimgZ+0tR4s=;
        b=djBGfWLSXH6XzuLIZS3NGPaWhp0gPx8NuzE3TPhD58ihEU/rx+pCqTFbKCCeGLnMTV
         bfw5mDiWz6Eku45aCDr4cwBxD+nKrhH9N5EicL9vv0jxLZLsjdeiR61g2F2zZN/sxsbz
         s8AHtR0YjPFBa+49KblCG4P0lCo3z6feaUHZBOa3KBZXunr5luJuFE+k05z2eePVfghV
         ErV0Y+4AAtN0UN+YCngZ9R3xCxp4JL9fV9lQTjoo+qlkKSt0FhiMOkSHfGICtr/CSDpW
         IRFmZCHY+MPCsFj8WGGSKvzHK5BrdnJMqcbhLf8V0gB2HN3/P3abV1JerCFZ+jg4+9Xu
         gBgg==
X-Gm-Message-State: APjAAAVyvxfA7JqdExUdns1vElDzKCTsfDDQkAFmoPobG+Jt/Gw/MZhy
        /J9gGTQD+buWVRp6Kzfs3NEzMGy7Q8+vHjnkf1Y=
X-Google-Smtp-Source: APXvYqzF3yiSbUPtZjlVQIWuoTrT3/AHsXrmM+88NyvkDpiBok1Tzt5+AFSuH8D3KuetYXh4nYV0aW7HOjLyZ/FhSrM=
X-Received: by 2002:a37:a685:: with SMTP id p127mr11056420qke.449.1576796555393;
 Thu, 19 Dec 2019 15:02:35 -0800 (PST)
MIME-Version: 1.0
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
In-Reply-To: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Dec 2019 15:02:24 -0800
Message-ID: <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 3:04 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Add a test that will attach a FENTRY and FEXIT program to the XDP test
> program. It will also verify data from the XDP context on FENTRY and
> verifies the return code on exit.
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
>  2 files changed, 139 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>

[...]

> +       /* Load XDP program to introspect */
> +       err = bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);

Please use BPF skeleton for this test. It will make it significantly
shorter and clearer. See other fentry_fexit selftest for example.

> +       if (CHECK_FAIL(err))
> +               return;
> +

[...]

> +
> +static volatile __u64 test_result_fentry;

no need for static volatile anymore, just use global var

> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
> +           struct xdp_buff *, xdp)
> +{
> +       test_result_fentry = xdp->rxq->dev->ifindex;
> +       return 0;
> +}
> +
> +static volatile __u64 test_result_fexit;

same here

> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
> +           struct xdp_buff*, xdp, int, ret)
> +{
> +       test_result_fexit = ret;
> +       return 0;
> +}
>
