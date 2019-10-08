Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8FDD012E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfJHT2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:28:49 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45220 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbfJHT2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:28:49 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so39011473iot.12;
        Tue, 08 Oct 2019 12:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=hKUGwdiN8CcAzSwm1K0zrzI1YBggiWbMrqJXJpOw9rI=;
        b=noxZXtofntjndArr8gNgCk6HCpAHUeq3QEZZ0cRFis1JmEO8QpSsLaAodgVDk+Pk6L
         OYzv0/rV7PDyMYKYWB1yGLW2H2mNd910OAoqlB0O7UO1VwjaBZgkXchrziyVeRZDdDTR
         A6kQAGQ4FQo4/rg6iwMEg81aAwVj8BUBG8AopmYh9r3Vka/62E4jnX0z/+kUTfd92blY
         /uB8XSnPEAk0KTCxh2r4IF4epahVcS+pHUsJuebCd9GPcs1Y8ph+yRd2FLSMsxsY7hh7
         KqE3GLhI2xzixAGWChcwqdg+gvsf4jnZWEbdh8mGKQy1NhdDMcdlc1wBQFh5JOoqeUex
         UBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=hKUGwdiN8CcAzSwm1K0zrzI1YBggiWbMrqJXJpOw9rI=;
        b=Q9ZC2Dwbnrf8/lBZGVu8kLsi+utCIht6DzM57VuJdt1GIjdnarj3SmE9b+nSlK+6UL
         w62g7Lf+FUtiHprrPo5N/A2Yvd2B2eF/6SmvWm9CxSoZBQppOSLNxaJRoL4HYv/b/RCF
         2U9vXg8mKl5VrSKyszpqP3Vu0WJsz/hjqcElQsWfsOqbLla4IeV69sYQo7rOnVOpCSVs
         ShOXCJ8VUAdKyP70i1zwMi0v2QcOxHF3wR8ONwtnZioUH4bWcOlU6sl42EoXNwVskjVY
         sBdV+CerODZz5wkBp5GTgONhmgMPY10T9JeN5yuozSiXMXqOSp+s4B5jrHi1uIRsbff/
         pwdg==
X-Gm-Message-State: APjAAAX75St9qRo/DgVcRJIDLM6IiyS3DamO0RVAu/daZk6ZQtBAkwSL
        QVfXxUg6HYYlz1GFGjv88hg=
X-Google-Smtp-Source: APXvYqy2e/8FcOcI62SHTcbBbl+r9RyeZVYuM2/15zjG3CoBI0yMr6FOv/ibHqWHCLcA9RBQ8HbVmg==
X-Received: by 2002:a92:b74f:: with SMTP id c15mr383830ilm.43.1570562928746;
        Tue, 08 Oct 2019 12:28:48 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id 28sm10601898ilq.61.2019.10.08.12.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 12:28:48 -0700 (PDT)
Date:   Tue, 08 Oct 2019 12:28:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Message-ID: <5d9ce369d6e5_17cc2aba94c845b415@john-XPS-13-9370.notmuch>
In-Reply-To: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
References: <1570530208-17720-1-git-send-email-magnus.karlsson@intel.com>
Subject: RE: [PATCH bpf] libbpf: fix compatibility for kernels without
 need_wakeup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> When the need_wakeup flag was added to AF_XDP, the format of the
> XDP_MMAP_OFFSETS getsockopt was extended. Code was added to the kernel
> to take care of compatibility issues arrising from running
> applications using any of the two formats. However, libbpf was not
> extended to take care of the case when the application/libbpf uses the
> new format but the kernel only supports the old format. This patch
> adds support in libbpf for parsing the old format, before the
> need_wakeup flag was added, and emulating a set of static need_wakeup
> flags that will always work for the application.
> 
> Fixes: a4500432c2587cb2a ("libbpf: add support for need_wakeup flag in AF_XDP part")
> Reported-by: Eloy Degen <degeneloy@gmail.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 109 +++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 78 insertions(+), 31 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index a902838..46f9687 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -44,6 +44,25 @@
>   #define PF_XDP AF_XDP
>  #endif
>  
> +#define is_mmap_offsets_v1(optlen) \
> +	((optlen) == sizeof(struct xdp_mmap_offsets_v1))
> +
> +#define get_prod_off(ring) \
> +	(is_mmap_offsets_v1(optlen) ? \
> +	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.producer : \
> +	 off.ring.producer)
> +#define get_cons_off(ring) \
> +	(is_mmap_offsets_v1(optlen) ? \
> +	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer : \
> +	 off.ring.consumer)
> +#define get_desc_off(ring) \
> +	(is_mmap_offsets_v1(optlen) ? \
> +	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.desc : off.ring.desc)
> +#define get_flags_off(ring) \
> +	(is_mmap_offsets_v1(optlen) ? \
> +	 ((struct xdp_mmap_offsets_v1 *)&off)->ring.consumer + sizeof(u32) : \
> +	 off.ring.flags)
> +
 
It seems the only thing added was flags right? If so seems we
only need the last one there, get_flags_off(). I think it would
be a bit cleaner to just use the macros where its actually
needed IMO.

Thanks,
John
