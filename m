Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6B6247B69
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 02:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgHRAOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 20:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726324AbgHRAOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 20:14:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B672C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:14:51 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c80so14686581wme.0
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 17:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yGv/4URxeGP8OrkMz246qgPy2SDlzkCa7CY4xv595zQ=;
        b=TNjoVvmn2PAZpmXOJy7UkV3G66rnwrSi3oIwTIXGZqsSDUf8bpcU4PtM/BpO9M01mD
         u/IkXjjDRRfw84Zvdfet9KwaDjz3YGyZiGMo5S4oevo5Xge1zPYJWLW/lc/Is2Y5a8uL
         6BHJ3qJ3u+jiDgyc3MGxRN4a1jwrAN+wve5j4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yGv/4URxeGP8OrkMz246qgPy2SDlzkCa7CY4xv595zQ=;
        b=lqph8meeDzUPYBzkZWptfDvmhC7buN6RD/25VdFGgRFez46ro9aVWkCrQwFiNjBxy8
         1wm7NR3UUKoihoFG1pGaTSSr8AXFd8/0pv2SblRQH7/Qodvpx8pYJRrwn18HbJq+saX+
         pUNd43SX6CXGEfKlvQiKCsmPs9gNaC78a3eL7b1wDDZUJJj82s7tdidgwppKUzwZmXgX
         ACnumRv8zU8JK2c42Ojuneae4q2DOHzjf2hVvpTWdCen9vY5sBYW0rKCjeiQJCMisvtp
         4zi4Zb2Y8ZeuOmrN0PGUez7i+UE5MDGPIlMcvQsvm+1FeO8ZmV8PrMe3+54Fd2DEUMZZ
         /DXQ==
X-Gm-Message-State: AOAM533K4vuhmTQpG4oRv8nR+DjRFJNvH9isAMQFa2yaVTXhmGsWlbcf
        pZkvFTCCz8TgPrAdMkoaeACYhg==
X-Google-Smtp-Source: ABdhPJxhcxVNrXBnn9lFe2DY9wx7SGMAZAp6qAPYKGP6pMrzcjatKHn9BAQ5fomgAg6oQ7Gw8jP9cg==
X-Received: by 2002:a7b:cb17:: with SMTP id u23mr17017023wmj.79.1597709685690;
        Mon, 17 Aug 2020 17:14:45 -0700 (PDT)
Received: from kpsingh-macbookpro2.roam.corp.google.com ([81.6.44.51])
        by smtp.gmail.com with ESMTPSA id o2sm31231763wrj.21.2020.08.17.17.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 17:14:45 -0700 (PDT)
Subject: Re: [RFC PATCH v11 bpf-next 10/14] bpf: Add d_path helper
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20200809150302.686149-1-jolsa@kernel.org>
 <20200809150302.686149-11-jolsa@kernel.org>
From:   KP Singh <kpsingh@chromium.org>
Message-ID: <c99e9d34-a807-93eb-4a2f-34c79793628b@chromium.org>
Date:   Tue, 18 Aug 2020 02:14:44 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200809150302.686149-11-jolsa@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09.08.20 17:02, Jiri Olsa wrote:
> Adding d_path helper function that returns full path for
> given 'struct path' object, which needs to be the kernel
> BTF 'path' object. The path is returned in buffer provided
> 'buf' of size 'sz' and is zero terminated.
> 
>   bpf_d_path(&file->f_path, buf, size);
> 
> The helper calls directly d_path function, so there's only
> limited set of function it can be called from. Adding just
> very modest set for the start.
> 
> Updating also bpf.h tools uapi header and adding 'path' to
> bpf_helpers_doc.py script.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: KP Singh <kpsingh@google.com>

Thank you so much for working on this! 

> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

[...]

>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> 
