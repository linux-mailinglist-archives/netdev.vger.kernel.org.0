Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5363C1A02
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 21:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbhGHTpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 15:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGHTpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 15:45:24 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAC8C061574;
        Thu,  8 Jul 2021 12:42:42 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso4647914pjp.2;
        Thu, 08 Jul 2021 12:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VRyUFVyM+1PtPWGdrDqxIdoGIUAtfYcU5TF/ZJeIGdY=;
        b=K+71OXQbZzjvwpADqUfCXwjRDGikk9QyGPTnf7dyrszRxNhQn0quHQoVGfoIRH89n1
         wG/xT2GTmgFTkPrZQdhVkp6NU6waHk7hDD7MqhByQxVpeG9nBjhIL8n0f2L1Ju03tBCK
         UlMKr07a8LKyRTtR0fyz9C3XLAo29IQIlkYbnYl960GMGVXni/HwVxjUVg4Zdn8rW6ZZ
         W33mtt2QZHdQNKmror6qe6E8nPkvlVO1hZ8ZtbF2hCmtjRYpCd/B5FbwWtdSXaX6u6a4
         lRNPky4oSCAiW4REo90yJZnxNDll3SyhPU4hgCg7IxfZbZ2OFjKMBvNuLFp2jnWy3b95
         wthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VRyUFVyM+1PtPWGdrDqxIdoGIUAtfYcU5TF/ZJeIGdY=;
        b=tEihM5yUxmlSwfSv//cZXKq7JxHBMkR91P7wefqsWjaAaFFWkEs0yw5LrfpSWEgpPL
         WJQK/1JRRplkbbVOuMNoDtS+hE3ZGMYpoz3UUa1cbaADd0RgIov0mNKSUWspyo4GAZER
         EOq7WgYSd8E83c0KHfYJ79EcBi2t4trsWBIgZt7N+q07Y6WEifwc1sDIO51oDKksu/2x
         ocrYwWD+CCDEoTS1ntrtatr3Ly98szvoXOMQ71J2GoL4k1m0ENKReqMNixEuLQDTRmhj
         091fBYXr1es4YMHIQ/2ylqPfWU+m9j5S50OtoQCBCYwFHytp+2Z9y0nU45EyRY3YZsui
         Ui3A==
X-Gm-Message-State: AOAM5328mf8JVh47ZdxDRAv8U6phovXIvE8eR9UgV1bc7pgfUr88eo/3
        5Wa3FLCtFqhL40yhZkj8GfLhIZnHe18gzw3ZV+c=
X-Google-Smtp-Source: ABdhPJxlntUNox9k4TFdJV7qGTp0seYSllSJza3CzSsuC45rODdxpGEEveV/psf3oTVhiFBdzSn1dQPRDy2kdSKn3Lk=
X-Received: by 2002:a17:903:2309:b029:12a:965b:333 with SMTP id
 d9-20020a1709032309b029012a965b0333mr2740702plh.31.1625773362262; Thu, 08 Jul
 2021 12:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210706163150.112591-1-john.fastabend@gmail.com> <20210706163150.112591-3-john.fastabend@gmail.com>
In-Reply-To: <20210706163150.112591-3-john.fastabend@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Jul 2021 12:42:31 -0700
Message-ID: <CAM_iQpWL586pETHuxp+2FzwF-QLA0P3Vcthc74Rwx7uZf6LNKQ@mail.gmail.com>
Subject: Re: [PATCH bpf v3 2/2] bpf, sockmap: sk_prot needs inuse_idx set for
 proc stats
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 6, 2021 at 9:31 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/sock_map.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 60decd6420ca..27bdf768aa8c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -185,10 +185,19 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
>
>  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
>  {
> +       int err;
> +#ifdef CONFIG_PROC_FS
> +       int idx = sk->sk_prot->inuse_idx;
> +#endif

A nit: Reverse XMAS tree declaration style is preferred for networking
subsystem.

Thanks.
