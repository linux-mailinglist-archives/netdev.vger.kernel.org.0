Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7269A1DDC91
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 03:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgEVBVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 21:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 21:21:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD632C061A0E;
        Thu, 21 May 2020 18:21:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cx22so4232098pjb.1;
        Thu, 21 May 2020 18:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TZwOFAehJhxFSvAbpPiaXGl9kNQ99WA4rC3x0B7grHY=;
        b=e1lqh4lUUQIY1SGzPcM+5IDiOkwsTzcJRQ4NvN5TcxO4Xrxpac1KeCAnXx/FtADn6I
         dNq6Hthku7xO0NY9s0s3IwsgcYG3HzJo4EjQAEFaekrWvr4vxoJmTQ/acsCpK+aUHrX4
         0nTzoyXS1c2hsQhKNpVjX91GTBdMAuSyCz0p/h25FgzTP5Ur3jzfAC38/92FgzvL3vLx
         kNvaIWEXtZf2cP6jc1OxQCN55kXYUhkZjaMcQ97m+pjRb8TIP1X0QE0Np62NUMvcj6eH
         0oIC56z1zBM39Z0BIZd+K4uCE09H8SwkZ+j3tDWwLfTDKGqig8E9/YP7ZpuCIWsqabwW
         wr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TZwOFAehJhxFSvAbpPiaXGl9kNQ99WA4rC3x0B7grHY=;
        b=aB3jjffUEvtzbWJKMvRQJQd4Mw+C7c42aG68e5gzJL9HA7n5WkxHUNROCcKfbEbOuk
         C32MENS6pLq6cAMHAxb2NMIDMZsBm01263Pwp6bZNg1lBPohOR6dNRFVkXfavdn713WC
         lpl8QU1FVhrxZ5BpwB7wJnleOOJFi5VAtEfu0HmqKiLT9FGIupRnXCpp/n99OIFa6ezu
         WVvuEQxEMCfss5LvNAVBv5C+E3DdW1zzbAyUX1/i7cLbUH2X/fDgriVMI7Pa8vgMWlui
         X9FbH9wEBZjjkBIZ2NVJfucbS3EoysO01o67P0DHi+sr2bU1b9Y190PoCd9t3JwHRcmd
         VWMg==
X-Gm-Message-State: AOAM530/qGNGljbG+RP5y+9cDczwISGuj70nlIEKJjS+ylpCvBqFv8oU
        1Qc+dL+/EeRX4RaHWXOy/mWS3DKC
X-Google-Smtp-Source: ABdhPJxcZpx5UfKc30FR1KjEf/YW8wBR91rdc/EfNbgCLREIUHMitBVraVrIn56qG2ikJ3He3/da0A==
X-Received: by 2002:a17:90a:7c48:: with SMTP id e8mr1510622pjl.135.1590110510238;
        Thu, 21 May 2020 18:21:50 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e680])
        by smtp.gmail.com with ESMTPSA id d7sm5466316pfa.63.2020.05.21.18.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 18:21:49 -0700 (PDT)
Date:   Thu, 21 May 2020 18:21:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH v2 bpf-next 6/7] bpf: add BPF ringbuf and perf buffer
 benchmarks
Message-ID: <20200522012147.shnwybm5my7dgy4v@ast-mbp.dhcp.thefacebook.com>
References: <20200517195727.279322-1-andriin@fb.com>
 <20200517195727.279322-7-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517195727.279322-7-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 12:57:26PM -0700, Andrii Nakryiko wrote:
> +
> +static inline int roundup_len(__u32 len)
> +{
> +	/* clear out top 2 bits */
> +	len <<= 2;
> +	len >>= 2;
> +	/* add length prefix */
> +	len += RINGBUF_META_LEN;
> +	/* round up to 8 byte alignment */
> +	return (len + 7) / 8 * 8;
> +}

the same round_up again?

> +
> +static void ringbuf_custom_process_ring(struct ringbuf_custom *r)
> +{
> +	unsigned long cons_pos, prod_pos;
> +	int *len_ptr, len;
> +	bool got_new_data;
> +
> +	cons_pos = smp_load_acquire(r->consumer_pos);
> +	while (true) {
> +		got_new_data = false;
> +		prod_pos = smp_load_acquire(r->producer_pos);
> +		while (cons_pos < prod_pos) {
> +			len_ptr = r->data + (cons_pos & r->mask);
> +			len = smp_load_acquire(len_ptr);
> +
> +			/* sample not committed yet, bail out for now */
> +			if (len & RINGBUF_BUSY_BIT)
> +				return;
> +
> +			got_new_data = true;
> +			cons_pos += roundup_len(len);
> +
> +			atomic_inc(&buf_hits.value);
> +		}
> +		if (got_new_data)
> +			smp_store_release(r->consumer_pos, cons_pos);
> +		else
> +			break;
> +	};
> +}

copy paste from libbpf? why?
