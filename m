Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5211FFB8B
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbgFRTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgFRTJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 15:09:46 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53081C06174E;
        Thu, 18 Jun 2020 12:09:46 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id a13so6950435ilh.3;
        Thu, 18 Jun 2020 12:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6IBczb4kdESWB+hwv7Y/EqKNNCjEHpD367/7iKBzQeg=;
        b=ilcNBpp4n+Dk8Np0QClpGicPlk/LuLVga5lRALNS8fJJC4h/hzUvTHWbdS1t0HgKjT
         nXMwTG3m2Yq59nhTPd8kQwvPMLH3/deFEdFj9ObWq9zew3S4fpeqJ6oH5lDZdyQwkCa1
         SIuSRctv5D3gEZANQKuY92fo+s542Mtf5c+HW8iQthMypvJZAO7YAC94q9hDhI5rJXfi
         KKr5A1skl2qQ4d2kUdryE+y4zH4NNXs/hM/WyhaFGAiZ4vHCjJX1YKW0Be0aRiJbHOij
         ulKC36UlZNA/fe1LBM4Jdf1GYyLQMh+pkSJaiipWcXSeq6wCeVjQilPdR8Ajugv5QZrL
         Mt+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6IBczb4kdESWB+hwv7Y/EqKNNCjEHpD367/7iKBzQeg=;
        b=KpKgJ2UDVA03JpyVDlxxmga8JHYt9YmVAa14EE5wLlEahqADWirv7+FKfr4Q0EuHIL
         CY2SohSpkkUmPbwrc6Q4Hrv/rSjAekPrBoD/qEE8TET9sJNeN0D/R0BDC/sDo5TBGeAu
         rDbKVhUE0kzofLjFjLrUPO7HVE63bisZ/WBRjni5qvcI3EiAiIYRaG46Go8OKbVs18vr
         JXWdi9vR80wjwR68H9BriTkbFnEAdHnVkZ2hfc0d88jiaVAwh5SemS0CoODXXA2AbHrc
         K+GGj0Lo/cTBmDO3rt7TVJ8KpSJx2/gQVGn7eiUcDwlIUbffZBaotrq47C7lmKpByDTR
         E1XQ==
X-Gm-Message-State: AOAM530ePb6ES7lnuAALSqiOpQBftJZEcsojgx8RLM6si7Ek2aWfOgdn
        2dXK/Db5CjJS3VfijqhBLRE=
X-Google-Smtp-Source: ABdhPJylgxbxpzMxEgHLmcmn7pqbENP1FanyK8WWk3EdKjG0Urfb8NmKdqnCt3ugJcvOW9l16EGIww==
X-Received: by 2002:a92:dc47:: with SMTP id x7mr5929701ilq.130.1592507385742;
        Thu, 18 Jun 2020 12:09:45 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id t14sm1868055ilp.73.2020.06.18.12.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 12:09:44 -0700 (PDT)
Date:   Thu, 18 Jun 2020 12:09:35 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Christoph Hellwig <hch@lst.de>
Message-ID: <5eebbbef8f904_6d292ad5e7a285b883@john-XPS-13-9370.notmuch>
In-Reply-To: <20200616050432.1902042-2-andriin@fb.com>
References: <20200616050432.1902042-1-andriin@fb.com>
 <20200616050432.1902042-2-andriin@fb.com>
Subject: RE: [PATCH bpf 2/2] selftests/bpf: add variable-length data
 concatenation pattern test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Add selftest that validates variable-length data reading and concatentation
> with one big shared data array. This is a common pattern in production use for
> monitoring and tracing applications, that potentially can read a lot of data,
> but usually reads much less. Such pattern allows to determine precisely what
> amount of data needs to be sent over perfbuf/ringbuf and maximize efficiency.
> 
> This is the first BPF selftest that at all looks at and tests
> bpf_probe_read_str()-like helper's return value, closing a major gap in BPF
> testing. It surfaced the problem with bpf_probe_read_kernel_str() returning
> 0 on success, instead of amount of bytes successfully read.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> +/* .data */
> +int payload2_len1 = -1;
> +int payload2_len2 = -1;
> +int total2 = -1;
> +char payload2[MAX_LEN + MAX_LEN] = { 1 };
> +
> +SEC("raw_tp/sys_enter")
> +int handler64(void *regs)
> +{
> +	int pid = bpf_get_current_pid_tgid() >> 32;
> +	void *payload = payload1;
> +	u64 len;
> +
> +	/* ignore irrelevant invocations */
> +	if (test_pid != pid || !capture)
> +		return 0;
> +
> +	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in1[0]);
> +	if (len <= MAX_LEN) {

Took me a bit grok this. You are relying on the fact that in errors,
such as a page fault, will encode to a large u64 value and so you
verifier is happy. But most of my programs actually want to distinguish
between legitimate errors on the probe vs buffer overrun cases.

Can we make these tests do explicit check for errors. For example,

  if (len < 0) goto abort;

But this also breaks your types here. This is what I was trying to
point out in the 1/2 patch thread. Wanted to make the point here as
well in case it wasn't clear. Not sure I did the best job explaining.

> +		payload += len;
> +		payload1_len1 = len;
> +	}
> +
> +	len = bpf_probe_read_kernel_str(payload, MAX_LEN, &buf_in2[0]);
> +	if (len <= MAX_LEN) {
> +		payload += len;
> +		payload1_len2 = len;
> +	}
> +
> +	total1 = payload - (void *)payload1;
> +
> +	return 0;
> +}
