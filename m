Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF7E17CB5A
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 03:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCGC5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 21:57:10 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38933 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgCGC5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 21:57:10 -0500
Received: by mail-pf1-f196.google.com with SMTP id w65so1476552pfb.6;
        Fri, 06 Mar 2020 18:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/L6/iGkj1kByXgIY4L/2D8oQym7mkFksfifoaI+e6tk=;
        b=TYDhPoTdoywK92PBXuQhg4xSTASJ+Me0CRdeS/P/STBeK4zQYR+ba3X8azegJ8DSh4
         E0Vk0UCEAvF8UqgfN+o71Memj3WzibyhhiDArvXGDtHJ95RuNJi3S0qF1PIJOjY2bXNn
         0HwL3OMH73Xq6BkSHnq8uLGAQaUrM8IYQwnqX2BbUsm5wyRUAd5pflevwVaYADPklgwZ
         uFhu1PGuCPyONp+/kZL4hEf8eFwH2SsoFiIuaiS0H1hSYiF2aJFOLAaO5kuMKzVFzXhR
         XwlIRY0KB7dyQlzbQgZuo7l8n13BfJs4cYhvxxByvQQ86zweth5RI474tbvkXOCjw6nt
         HsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/L6/iGkj1kByXgIY4L/2D8oQym7mkFksfifoaI+e6tk=;
        b=Es3XXWedJ8HcXLxlOl3KbpCLncFikF57FTO5XoWQ/gI+hTV9Y0cXhxi0VqUo3ybMIJ
         lxtAWrbMWG0qtg2jngghxmuX/dFHP2O4YYcati4W2lk61gNYC49JbUsfI1sJ8vi41yyt
         FeNvCU19i6boV9egVGJ1zjTIfi7qfcEpGog/JzYy700eelPCSiwvg8bjwgADe6SrEwKI
         H3U0D/RNmyhEeRjUjf5Y49YLobhfrmtD+49y8sBUxBrrf0xJnPIRTZxjz9ktEVeibPuy
         BSLZUKPeceonuGajyt3Ez6Aik8mc/9wlUigmuXzUuQzzhu3DKKg6O8VB5+ybjpqLCxTP
         soZw==
X-Gm-Message-State: ANhLgQ3fuEjxBAyXi2ZvD0HjDCgs3YIGfqprnBTwkm1VzNQrBDMv7uGG
        CA/qwsIT2njyCxft2StWB58=
X-Google-Smtp-Source: ADFU+vs6aDbQ3Up3AGhvd2Rp5nhTrKCDv5+Wg5bG2lHtySbNtjUZKCrw/3FSdNwqXy/WXEeLBleeWQ==
X-Received: by 2002:aa7:84c6:: with SMTP id x6mr6386156pfn.181.1583549829289;
        Fri, 06 Mar 2020 18:57:09 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r11sm8823975pfh.176.2020.03.06.18.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 18:57:08 -0800 (PST)
Date:   Fri, 06 Mar 2020 18:57:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Message-ID: <5e630d7c42319_5f672ade5903a5b8c5@john-XPS-13-9370.notmuch>
In-Reply-To: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
References: <158348514556.2239.11050972434793741444.stgit@xdp-tutorial>
Subject: RE: [PATCH bpf-next] bpf: add bpf_xdp_output() helper
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron wrote:
> Introduce new helper that reuses existing xdp perf_event output
> implementation, but can be called from raw_tracepoint programs
> that receive 'struct xdp_buff *' as a tracepoint argument.
> 
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  include/uapi/linux/bpf.h                           |   27 ++++++++++
>  kernel/bpf/verifier.c                              |    4 +-
>  kernel/trace/bpf_trace.c                           |    3 +
>  net/core/filter.c                                  |   16 ++++++
>  tools/include/uapi/linux/bpf.h                     |   27 ++++++++++
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   53 ++++++++++++++++++++
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   24 +++++++++
>  7 files changed, 150 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 40b2d9476268..41a90e2d5821 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2914,6 +2914,30 @@ union bpf_attr {
>   *		of sizeof(struct perf_branch_entry).
>   *
>   *		**-ENOENT** if architecture does not support branch records.
> + *
> + * int bpf_xdp_output(void *ctx, struct bpf_map *map, u64 flags, void *data, u64 size)
> + *	Description

feels a bit odd to have flags in the middle of a signature but it follows
bpf_perf_event_output() so I guess its better to have the two use the
same signature vs break it here.

> + *		Write raw *data* blob into a special BPF perf event held by
> + *		*map* of type **BPF_MAP_TYPE_PERF_EVENT_ARRAY**. This perf
> + *		event must have the following attributes: **PERF_SAMPLE_RAW**
> + *		as **sample_type**, **PERF_TYPE_SOFTWARE** as **type**, and
> + *		**PERF_COUNT_SW_BPF_OUTPUT** as **config**.
> + *
> + *		The *flags* are used to indicate the index in *map* for which
> + *		the value must be put, masked with **BPF_F_INDEX_MASK**.
> + *		Alternatively, *flags* can be set to **BPF_F_CURRENT_CPU**
> + *		to indicate that the index of the current CPU core should be
> + *		used.
> + *
> + *		The value to write, of *size*, is passed through eBPF stack and
> + *		pointed by *data*.
> + *
> + *		*ctx* is a pointer to in-kernel struct xdp_buff.
> + *
> + *		This helper is similar to **bpf_perf_eventoutput**\ () but
> + *		restricted to raw_tracepoint bpf programs.
> + *	Return
> + *		0 on success, or a negative error in case of failure.
>   */

Otherwise,

Acked-by: John Fastabend <john.fastabend@gmail.com>
