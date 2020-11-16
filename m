Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE62B437E
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbgKPMSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbgKPMSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 07:18:14 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE1BC0613D1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 04:18:14 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c9so23519934wml.5
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 04:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=yW4WlOePZHathOl6u0xCp0KPZxooAIfjqYVblGZkMr0=;
        b=g2fsVRYWrR9L3djER+wkAkQA5aTRCWh1HZn5yEe4GXjpPSgArdMco0+PXPdg9Upq4P
         G5y2o5pZ6QRkxwJXP/1v9CVCycAgGuUjtIhpj3C4X6t+xOml4CUiy1ZWRatQB/enY6B0
         7gdU+qrtWq1nwF5HakdBz3HDuYQoKAaoTEPNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=yW4WlOePZHathOl6u0xCp0KPZxooAIfjqYVblGZkMr0=;
        b=tmZYkj9SAsEFJRoCp3KR3FBXbWXWsuFf2aE4MoCWffIvtl3Ebwk6+pBzBJhl2sl3Tf
         +E19WBgjAcCIbu2KuM0HYg/OsLZvbvWRuhwfnvrkUaVyaIw7ZuExt8PV1aXXtPJ2EHbS
         kfh0ycrv4iXIZ2B1eXrCJX+dgqpOkkL4Ui8wZJdxRHA6E3Mb6Yf/qVRrJwcFmSNtjyCY
         KKBL1bsryXy7XHkGfJO1JbWAuNXLvr2luJoPVBuLgw6Xl3RkcEh2Mz8TBqv2exK1zzce
         9sntjDLdhMWHGimlkYRgw8d3jNDHgce1So9TgGhBmJV/aWYq42AOhPnlPKJP8QpbLbSs
         yAAw==
X-Gm-Message-State: AOAM531O1GHWYfUMF4SEcdrRSodgvOUG+oKdqCS337PiQ05D3A4ZBl0q
        D2mP/1jyDeZsPGIlOR0WyiJEnw==
X-Google-Smtp-Source: ABdhPJzMhrCC4nxbbbMPElhBZTomSITDg73gwU2ccRtd3sDgEmEe9HJJpVW0QJagbRpeJWWMMLCyMA==
X-Received: by 2002:a1c:750b:: with SMTP id o11mr12497572wmc.32.1605529092567;
        Mon, 16 Nov 2020 04:18:12 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v19sm23551077wrf.40.2020.11.16.04.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 04:18:11 -0800 (PST)
References: <X6rJ7c1C95uNZ/xV@santucci.pierpaolo> <X7JUzUj34ceE2wBm@santucci.pierpaolo>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Santucci Pierpaolo <santucci@epigenesys.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] selftest/bpf: fix IPV6FR handling in flow dissector
In-reply-to: <X7JUzUj34ceE2wBm@santucci.pierpaolo>
Date:   Mon, 16 Nov 2020 13:18:10 +0100
Message-ID: <87d00dwl4t.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 11:30 AM CET, Santucci Pierpaolo wrote:
> From second fragment on, IPV6FR program must stop the dissection of IPV6
> fragmented packet. This is the same approach used for IPV4 fragmentation.
> This fixes the flow keys calculation for the upper-layer protocols.
> Note that according to RFC8200, the first fragment packet must include
> the upper-layer header.
>
> Signed-off-by: Santucci Pierpaolo <santucci@epigenesys.com>
> ---
> v2: extend the commit message, as suggested by John Fastabend
>     <john.fastabend@gmail.com>
>
>  tools/testing/selftests/bpf/progs/bpf_flow.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 5a65f6b51377..95a5a0778ed7 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -368,6 +368,8 @@ PROG(IPV6FR)(struct __sk_buff *skb)
>  		 */
>  		if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
>  			return export_flow_keys(keys, BPF_OK);
> +	} else {
> +		return export_flow_keys(keys, BPF_OK);
>  	}
>  
>  	return parse_ipv6_proto(skb, fragh->nexthdr);

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
