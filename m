Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9AB198C24
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 08:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgCaGQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 02:16:30 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:34425 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgCaGQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 02:16:30 -0400
Received: by mail-pj1-f66.google.com with SMTP id q16so696490pje.1;
        Mon, 30 Mar 2020 23:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bwmhd/qMjqfnmk2NrehDvM1RwoFtBpq3lJKU07oCmio=;
        b=BrlCLFDzmYc+AAViMVJVSU5y9FL+KqUA4BqUSoK609nYetQshxMF/effuwVDgh498L
         lo1znnTTWkyuHwvouUUPEFNHP9EK8sxou4uRHhA8cyeeReFYXGdElPzZiO06KHP/b7S/
         ZhXQJAk8N/oGrHQNIV0s39CbjXV91aCJvzFEqqIBq6WUcx+SVkIl08GRQPldoznO1qv4
         dsRgRmshya91/ZiNoxWK+WKssv7svxOaizzG0KC/mDMFswKy6+QNtWiEk2dNiIu9AkMu
         ie0ACeXCtfQGMgFi90S0g2QwPeKwf+xLdBHvbT4+3rLpl/bZeAAurnSm9g2x/XzRrL+N
         bEQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bwmhd/qMjqfnmk2NrehDvM1RwoFtBpq3lJKU07oCmio=;
        b=Ml99XNV6+Ckan0T5nVEi155lHrO+hoNf75tNGUEy4wJhw8t9EGkoODxB00jRP8fceP
         LL1AzAiypdtGRlWHn/8iK5l19aykq8SRidQT6mG+XsWbJWAvjdzTjrvZTnWmdsbjnUHy
         2wI6V8VUACUp4AJSAYw60x0wHF55inxYKnq9NIMAM+S3wAR7PRrIFdpOKYwZMLYSeGmr
         8Ueelnf/HpTu7OisciEYyC6TxlMsVrwe8cNH8r71ztCYu40ymj3Kjp5AY1f+tjVV5kuA
         xDBjDsVHFrOEmHLpaofwCXZE+mrazvgBD1XYTw75Ns0C7C280TxWKfKarSdWsl3zzbqF
         ewog==
X-Gm-Message-State: ANhLgQ2mSplLmnMLCI+4OXxWL17AzkxJZ4tSZ6mhcT0zi0LsFjjUAIK9
        RwEVnKxP6ex+J4fxusd5qxspGDNk
X-Google-Smtp-Source: ADFU+vuxifUfFthlKQHiaJVcNmCEOiFKoz4dTaCr9rahtDFCWUIJvQ7xy7kDcFwH7wc8FIzdBt2q4Q==
X-Received: by 2002:a17:902:d695:: with SMTP id v21mr15590318ply.135.1585635388219;
        Mon, 30 Mar 2020 23:16:28 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id p1sm1037307pjr.40.2020.03.30.23.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 23:16:27 -0700 (PDT)
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
To:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        jwi@linux.ibm.com, jianglidong3@jd.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
 <20200331060641.79999-1-maowenan@huawei.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
Date:   Tue, 31 Mar 2020 15:16:22 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200331060641.79999-1-maowenan@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/31 15:06, Mao Wenan wrote:
> xdp.data_hard_start is equal to first address of
> struct xdp_frame, which is mentioned in
> convert_to_xdp_frame(). But the pointer hard_start
> in veth_xdp_rcv_one() is 32 bytes offset of frame,
> so it should use head instead of hard_start to
> set xdp.data_hard_start. Otherwise, if BPF program
> calls helper_function such as bpf_xdp_adjust_head, it
> will be confused for xdp_frame_end.

I think you should discuss this more with Jesper before
submitting v2.
He does not like this to be included now due to merge conflict risk.
Basically I agree with him that we don't need to hurry with this fix.

Toshiaki Makita

> 
> Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>   v2: add fixes tag, as well as commit log.
>   drivers/net/veth.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index d4cbb9e8c63f..5ea550884bf8 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -506,7 +506,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>   		struct xdp_buff xdp;
>   		u32 act;
>   
> -		xdp.data_hard_start = hard_start;
> +		xdp.data_hard_start = head;
>   		xdp.data = frame->data;
>   		xdp.data_end = frame->data + frame->len;
>   		xdp.data_meta = frame->data - frame->metasize;
> 
