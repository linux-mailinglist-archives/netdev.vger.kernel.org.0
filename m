Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A581DDC88
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgEVBUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgEVBUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:20:38 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9B1C061A0E;
        Thu, 21 May 2020 18:20:37 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so2756611plv.9;
        Thu, 21 May 2020 18:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZNF3l3Rf/hyTRthjPLDXuO3hRE38OnT2OCuLH8saVWU=;
        b=Ft7Gz1UYohvNdKPw6xvUWoyngsqlRLlUbcy+e1TrUs9xaDDKwQrLe7wqU03T/R6s5U
         DWJIGyppQTq6eSPHOU2DmpEV5d1Inezhk0CYGHqrXv+pTysjD+Y5/PIqpsYsY2wS4Sxx
         ekVxXmByMBz+fUqoWtlUzj7avi/0K8RqX2RJmE+bSyNYIhAhuxwdJ+kAqukNUmrlE5vN
         rx91Fd9m5bXvKIAiby/0AHg32PJ7ERrIyM8lZVy/i8JVVlX48UFKTk1Jpl6oevyQ3fed
         vNvtbONYwGyjeEJcwsuNcP1daMZQ3kfNVuZQnE7onzsIhnWFaN3qGUsYUax1ZOKaQ0PB
         eEjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZNF3l3Rf/hyTRthjPLDXuO3hRE38OnT2OCuLH8saVWU=;
        b=caeN66uRiJoQkQ8FNxuwqC0wDoPe52nUE7ODrnOaLhZw0KbAP21vT4XBaF0IqOWPF3
         PmFLlLnZymMB4xS6+K53VlmMXeroPlM2SK4Q4B0l5FiBQDU1mKrEbqGwVQ8FEaXL11uu
         jZXjJ6xEuT+IJ28GfTk62X2Z5jMPsUiENDqb6pFluwgq4tbQ4qWZFUQ7U1dZWmMwU9fA
         ubc/pDrpbzUmUt5WO9REQhAJmIjRRkk5KAKEpJlw4Pw3B2JOMx9P4lbz3dbi1tDCkboj
         hKw4ra22ET7FPZmYIW0npvYstfBwaZIqhE/bfyBFc64JmPrGEccfFwx03zG53HuyWpMw
         lw/Q==
X-Gm-Message-State: AOAM530HC4yrfWFI/j0Do+8NC628Oec5G7xl8z0nl0yeoKCcz46YonHc
        ZuwiANQEF1zdqv83HJm2wz0=
X-Google-Smtp-Source: ABdhPJyWVA0/DZPA7pKuDYpn8ZiILHLDdH8s0mHO0XHMSJGrJmg6I+epzClXhjsImqcSMJ8WIDBnRg==
X-Received: by 2002:a17:902:9a03:: with SMTP id v3mr3130075plp.6.1590110437222;
        Thu, 21 May 2020 18:20:37 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id m188sm5562888pfd.67.2020.05.21.18.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:20:36 -0700 (PDT)
Date:   Thu, 21 May 2020 18:20:34 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 5/7] selftests/bpf: add BPF ringbuf selftests
Message-ID: <20200522012034.sufpu7e62itcn2vg@ast-mbp.dhcp.thefacebook.com>
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-6-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-6-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:25PM -0700, Andrii Nakryiko wrote:
> diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
> new file mode 100644
> index 000000000000..7eb85dd9cd66
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_ringbuf_multi.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook

oops ;)

> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +char _license[] SEC("license") = "GPL";
> +
> +struct sample {
> +	int pid;
> +	int seq;
> +	long value;
> +	char comm[16];
> +};
> +
> +struct ringbuf_map {
> +	__uint(type, BPF_MAP_TYPE_RINGBUF);
> +	__uint(max_entries, 1 << 12);
> +} ringbuf1 SEC(".maps"),
> +  ringbuf2 SEC(".maps");
> +
> +struct {
> +	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
> +	__uint(max_entries, 4);
> +	__type(key, int);
> +	__array(values, struct ringbuf_map);
> +} ringbuf_arr SEC(".maps") = {
> +	.values = {
> +		[0] = &ringbuf1,
> +		[2] = &ringbuf2,
> +	},
> +};

the tests look great. Very easy to understand the usage model.
