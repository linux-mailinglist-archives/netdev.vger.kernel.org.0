Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D63A2EA31C
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 02:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbhAEB5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 20:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhAEB5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 20:57:52 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF08C061574;
        Mon,  4 Jan 2021 17:57:12 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i7so20274657pgc.8;
        Mon, 04 Jan 2021 17:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KiFoNCz0mL7WJA8dkCz5O3nky6l6BcwhHYdfVx2mWfc=;
        b=GY5FiKBuxQJPuAl93yNUjMNkPmk4y0hWLvUbx/4rOqLpxtdyUP70wANnnMl8Lzd/FM
         E7UXlT+hFL+nsZ8op4kuWCPp1u8tr0bAgFg+r/x6Lfty2wR5CNw0y+kllbb0uWn2SDiH
         rqeP4PnRPZ27b8L89U14ieus06JrFJUpwKxdVjti/T5BViCHr3cAMm4fitdzSPHAznaG
         FySNCSByMXhacN0JTl4aB2Wio85ls2vEVb9RPRbZPlORRSEVeNpfQgMl0dkPn7jKyqsW
         kYaSqbZGU8UW5D018FVOSHU5OIdhwg9RSIinvs/d8Wa3mobPpln25O0UV+m7QvMh3FNH
         T9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KiFoNCz0mL7WJA8dkCz5O3nky6l6BcwhHYdfVx2mWfc=;
        b=mwJxVS1vCNmHeCrssmamJenWvZ/AC62R3MDagfvvSzCSUxq7ovqavQ+iOu3+DMvc3V
         ftUQdYmpqw5Lk/g1DxM0QJLDR/IGV5VxiuoIYsF3bHAj6DAxkwHR+tenMAauaPgcrU4e
         IkqiBDfOmIs2FVbZi76Vr6+4otHZx7FHHohH4DeKB8DEY7YL6N7qV3acjn3Y+phb147X
         z1RRxlwvuHK6xvVQo46NqXEc9I0Y7BkRJocqtr/HLScMFUZf24XWBZ8RRvg8Xn+bNEEq
         hwh79q4q8UUmlX2gLZW3g2ZowuDsnaygF4MgW2Te5LCPZE8Oz0CvL5nG60CxQPguN7oh
         5QUA==
X-Gm-Message-State: AOAM532P9mxGcY92LslCcrXrujhnaKF0VtxmbtrMq5Wyyw82wvH/pOEJ
        BGxcmjbD+bsuCGa1VuXYlOA=
X-Google-Smtp-Source: ABdhPJy4xVVFKlj1qHUrO4zjwh2PdZotkPxNh03ABT/tyKZqgh/XATG4wD98ulhZdi5MAQa17KNbTw==
X-Received: by 2002:a05:6a00:228a:b029:18b:212a:1af7 with SMTP id f10-20020a056a00228ab029018b212a1af7mr67342050pfe.55.1609811831717;
        Mon, 04 Jan 2021 17:57:11 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:429b])
        by smtp.gmail.com with ESMTPSA id f24sm608852pjj.5.2021.01.04.17.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 17:57:10 -0800 (PST)
Date:   Mon, 4 Jan 2021 17:57:08 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com, toke@redhat.com,
        jean-philippe@linaro.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next] ksnoop: kernel argument/return value
 tracing/display using BTF
Message-ID: <20210105015708.bcw7l7gijeshw7fj@ast-mbp>
References: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609773991-10509-1-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 04, 2021 at 03:26:31PM +0000, Alan Maguire wrote:
> 
> ksnoop can be used to show function signatures; for example:
> 
> $ ksnoop info ip_send_skb
> int  ip_send_skb(struct net  * net, struct sk_buff  * skb);
> 
> Then we can trace the function, for example:
> 
> $ ksnoop trace ip_send_skb

Thanks for sharing. It will be useful tool.

> +
> +		data = get_arg(ctx, currtrace->base_arg);
> +
> +		dataptr = (void *)data;
> +
> +		if (currtrace->offset)
> +			dataptr += currtrace->offset;
> +
> +		/* look up member value and read into data field, provided
> +		 * it <= size of a __u64; when it is, it can be used in
> +		 * predicate evaluation.
> +		 */
> +		if (currtrace->flags & KSNOOP_F_MEMBER) {
> +			ret = -EINVAL;
> +			data = 0;
> +			if (currtrace->size <= sizeof(__u64))
> +				ret = bpf_probe_read_kernel(&data,
> +							    currtrace->size,
> +							    dataptr);
> +			else
> +				bpf_printk("size was %d cant trace",
> +					   currtrace->size);
> +			if (ret) {
> +				currdata->err_type_id =
> +					currtrace->type_id;
> +				currdata->err = ret;
> +				continue;
> +			}
> +			if (currtrace->flags & KSNOOP_F_PTR)
> +				dataptr = (void *)data;
> +		}
> +
> +		/* simple predicate evaluation: if any predicate fails,
> +		 * skip all tracing for this function.
> +		 */
> +		if (currtrace->flags & KSNOOP_F_PREDICATE_MASK) {
> +			bool ok = false;
> +
> +			if (currtrace->flags & KSNOOP_F_PREDICATE_EQ &&
> +			    data == currtrace->predicate_value)
> +				ok = true;
> +
> +			if (currtrace->flags & KSNOOP_F_PREDICATE_NOTEQ &&
> +			    data != currtrace->predicate_value)
> +				ok = true;
> +
> +			if (currtrace->flags & KSNOOP_F_PREDICATE_GT &&
> +			    data > currtrace->predicate_value)
> +				ok = true;
> +			if (currtrace->flags & KSNOOP_F_PREDICATE_LT &&
> +			    data < currtrace->predicate_value)
> +				ok = true;
> +
> +			if (!ok)
> +				goto skiptrace;
> +		}
> +
> +		currdata->raw_value = data;
> +
> +		if (currtrace->flags & (KSNOOP_F_PTR | KSNOOP_F_MEMBER))
> +			btf_ptr.ptr = dataptr;
> +		else
> +			btf_ptr.ptr = &data;
> +
> +		btf_ptr.type_id = currtrace->type_id;
> +
> +		if (trace->buf_len + MAX_TRACE_DATA >= MAX_TRACE_BUF)
> +			break;
> +
> +		buf_offset = &trace->buf[trace->buf_len];
> +		if (buf_offset > &trace->buf[MAX_TRACE_BUF]) {
> +			currdata->err_type_id = currtrace->type_id;
> +			currdata->err = -ENOSPC;
> +			continue;
> +		}
> +		currdata->buf_offset = trace->buf_len;
> +
> +		ret = bpf_snprintf_btf(buf_offset,
> +				       MAX_TRACE_DATA,
> +				       &btf_ptr, sizeof(btf_ptr),
> +				       BTF_F_PTR_RAW);

The overhead would be much lower if instead of printing in the kernel the
tool's bpf prog would dump the struct data into ring buffer and let the user
space part of the tool do the pretty printing. There would be no need to pass
btf_id from the user space to the kernel either. The user space would need to
gain pretty printing logic, but may be we can share the code somehow between
the kernel and libbpf.

Separately the interpreter in the bpf prog to handle predicates is kinda
anti-bpf :) I think ksnoop can generate bpf code on the fly instead. No need
for llvm. The currtrace->offset/size would be written into the prog placeholder
instructions by ksnoop before loading the prog. With much improved overhead for
filtering.
