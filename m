Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D11F7BE5
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKKSlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:41:02 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40655 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfKKSlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:41:00 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so11228310pfl.7
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=5e0w3CQksxVMU/lpN+cxiiEhTWlz5Cq8XlCAAEMfzs0=;
        b=jsmHBM1kJhwgwx4Wg9T663bZvEh4kV1pO8gOynTMTjaA7lsSEKYPmM64ghgH1rTNTU
         +6Z3DczHUjRPP6rzAwysi6eDjHin2m6Mjlgylu/RhpAVtsqnA2N39u5uLFrDp4ZQ0jlA
         0RvQ4JqvZGUGtPTxBgAkqsihip17fGun9vUcaozTmioiKJELuOLIA/VP5X4VUCRgc1aM
         SMIsfD+eaIpItc4Dkx6jK6ekf3GTNp5XwsD+eU/3eFQewQLNHrQEvpahexBs92RzpqV4
         JBVzWXbRz85oBX5GrEHxKriP+XTU/gPWVcirRm5wcADqV52RpACvOcXprkTWHlpXJoh2
         SGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=5e0w3CQksxVMU/lpN+cxiiEhTWlz5Cq8XlCAAEMfzs0=;
        b=Inu3TfRcTmfOT6CnPBEVQ1SAwLWf3/x6VOHj8IvudGxW1sgDI/jnVlvX7uMfzfKi8V
         NJlySG9RdIH/tnvVlpZhhObYlay+PRS1iGn8h5dOUwVA2+VvVV1E65wU7SwFc8pbyvkY
         Rhl1XU5JpavQz1iuNIeKGAQD5YsdFIpQDsjj6E++Xd9b2krwJRZBP9eZ3I/WNPFP3es1
         apYSCgoiDfTT9zdfJo8/X7eZ30D1D6Jg9rWskTMVPbe/De4c9ShYtCUNtUYtLfE+VKch
         KaTgokmRS6tKu9AnkuuDvL4dMc4jENiMinUGbdBxekjAS8z10g3byRzwvzgqiE+dD+1e
         dHQw==
X-Gm-Message-State: APjAAAXJNqe/2SVQYQsibIKKyYPYSRyacqqcWNvET8+TkD650bvSnht8
        4E13xT3l+/GzvGfOBysDK2Petw==
X-Google-Smtp-Source: APXvYqzEVIpxxwFp43Qk9kb+rMQROh8++y6Dlv3qoOGQ/XhcfQv5UkkhbMLGtlmEtDj0J+deE/EVJg==
X-Received: by 2002:aa7:870c:: with SMTP id b12mr31547925pfo.30.1573497659902;
        Mon, 11 Nov 2019 10:40:59 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id c16sm14673943pfo.34.2019.11.11.10.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 10:40:59 -0800 (PST)
Date:   Mon, 11 Nov 2019 10:40:57 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <andrii.nakryiko@gmail.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: make global data internal
 arrays mmap()-able, if possible
Message-ID: <20191111104057.0a9dfd84@cakuba>
In-Reply-To: <20191109080633.2855561-3-andriin@fb.com>
References: <20191109080633.2855561-1-andriin@fb.com>
        <20191109080633.2855561-3-andriin@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 Nov 2019 00:06:31 -0800, Andrii Nakryiko wrote:
> +static int bpf_object__probe_array_mmap(struct bpf_object *obj)
> +{
> +	struct bpf_create_map_attr attr = {
> +		.map_type = BPF_MAP_TYPE_ARRAY,
> +		.map_flags = BPF_F_MMAPABLE,
> +		.key_size = sizeof(int),
> +		.value_size = sizeof(int),
> +		.max_entries = 1,
> +	};
> +	int fd = bpf_create_map_xattr(&attr);
> +
> +	if (fd >= 0) {

The point of the empty line between variable declarations and code in
the Linux coding style is to provide a visual separation between
variables and code.

If you call a complex function in variable init and then check for
errors in the code that really breaks that principle.

> +		obj->caps.array_mmap = 1;
> +		close(fd);
> +		return 1;
> +	}
> +
> +	return 0;
> +}

