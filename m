Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0414A47FC46
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhL0LkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236454AbhL0Lj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 06:39:59 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE60C06173E;
        Mon, 27 Dec 2021 03:39:59 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id x15so11233653plg.1;
        Mon, 27 Dec 2021 03:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ue3UcdwJ+Dvyqxy+9ne3pye+qmUspCkO0hrkxjCa1Kc=;
        b=kqPydr2fywkJsQKbNDVOrWGU9EFDSxQs8CZ/IqlIy/E6oq+5ulZ5qr5kCDy+6wUTKR
         Rq7oWfGUfbpYd0WljWa6Y/P+4BVminwiin1sueU115WV2zVtiX46TRHDVwmeJSb1oZcN
         5f3YOou41LAXIHjDGOvPyTumny71osgqrQSlEYREh5lwkvVYOhu62giIy4faG8fG72eG
         tuPPUGdK8DTG4HFgZ/dlgW1Jz/qak4t1USSLNVGWPXDMz81O80hAjQuFXbvRknCmojrB
         /BNLrm/hW/e6EBWwToX04qna2Ta7X+xUtVhQQaS30oD0oZimb0A3nEsBsaYhfymMzJW4
         znKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ue3UcdwJ+Dvyqxy+9ne3pye+qmUspCkO0hrkxjCa1Kc=;
        b=55etZnUlPMNvGBlWM+YKZ2Rao/ag5A7Ukb5AJOUYZMRZ4EW6InKIeQowDwyK26SeYc
         +aq504zr+bFdZHXpuTD/PyfOGgRcaZfyOtmlOXC73BJQEjmGWn0vpm+C2MxJ4lMKkOfS
         l5eLD3VrhMFMYPFkxP5UEKf66xtYGi1iB6p4TXueIhAgu8I3SdZfRRzaqYncsTj5ZqJu
         N/9vsNZXmGu27s+efbnkWX1BvYQvStBclDR3QgTHad75IH5Z+deQOWx21tGDxjSVPBwJ
         SClZ5JRupxRpaGvCb+UWLiUBrN+EiXcG+QHQophL4urYl6jqHlo9dBe2nXlTNVMYeePJ
         fRTg==
X-Gm-Message-State: AOAM532ZF/58YJsY9T9SHJ/imcjhypzIQvRVo/6Xq+UFjtwuvViJNKZm
        vkK3qDkWwR9GhLXQ8He6LcR0sPDSjgQH8Q==
X-Google-Smtp-Source: ABdhPJz4MsuHGmBCC2/yLCzkDMjbQ9B+/SFyR6UdB4SedwZsz2HIvpGqKiHowoz/qboEZQ1VCTVkeQ==
X-Received: by 2002:a17:90b:1c8d:: with SMTP id oo13mr21031980pjb.139.1640605199154;
        Mon, 27 Dec 2021 03:39:59 -0800 (PST)
Received: from [192.168.255.10] ([203.205.141.115])
        by smtp.gmail.com with ESMTPSA id s29sm14427063pgo.34.2021.12.27.03.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Dec 2021 03:39:58 -0800 (PST)
Message-ID: <24ebf2ef-7ea6-67a1-65f1-08ce3e5529c4@gmail.com>
Date:   Mon, 27 Dec 2021 19:39:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] libbpf: Support repeated legacy kprobes on same
 function
Content-Language: en-US
To:     Qiang Wang <wangqiang.wq.frank@bytedance.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhouchengming@bytedance.com,
        songmuchun@bytedance.com, duanxiongchun@bytedance.com,
        shekairui@bytedance.com
References: <20211225083242.38498-1-wangqiang.wq.frank@bytedance.com>
 <20211225083242.38498-2-wangqiang.wq.frank@bytedance.com>
From:   Hengqi Chen <hengqi.chen@gmail.com>
In-Reply-To: <20211225083242.38498-2-wangqiang.wq.frank@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/12/25 4:32 PM, Qiang Wang wrote:
> If repeated legacy kprobes on same function in one process,
> libbpf will register using the same probe name and got -EBUSY
> error. So append index to the probe name format to fix this
> problem.
> 
> Co-developed-by: Chengming Zhou <zhouchengming@bytedance.com>
> Signed-off-by: Qiang Wang <wangqiang.wq.frank@bytedance.com>
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
> ---
>  tools/lib/bpf/libbpf.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b7d6c951fa09..0c41a45ffd54 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -9634,7 +9634,9 @@ static int append_to_file(const char *file, const char *fmt, ...)
>  static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
>  					 const char *kfunc_name, size_t offset)
>  {
> -	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx", getpid(), kfunc_name, offset);
> +	static int index = 0;

Add empty line after variable declaration.

> +	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(), kfunc_name, offset

Missing a comma after offset.

> +		 __sync_fetch_and_add(&index, 1));
>  }
>  
>  static int add_kprobe_event_legacy(const char *probe_name, bool retprobe,
