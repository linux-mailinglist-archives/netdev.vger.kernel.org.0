Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2B5A95D4
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbfIDWPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:15:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:32781 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDWPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:15:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so251095qkb.0
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 15:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HbbWeuojg9myphsl//SxbIwtbZw/1t0n4VEYITtHt28=;
        b=PSIMADQgjfuBiQRtkhfWDrzbkGpESpQK81gPQzrWCFL+OnJjtUq9VEJENZ0R1ZEsOY
         ZIB2k6wtR2jqX5v1Fk/fhRJPgeTBO56y4tzH315EhtcC1HiE/hYnBPirvQXetoyVTUVU
         qArYG7dwtBNTkaUB9V3ZwkgXdJMQmTx6pjDS8v4QS/mDNLbRXIsSz6msUAvJ4yhE1CWc
         iSdHljRj+QsHodEt9R5PvCPWBmYVgRN6HFLd5YE6tevC/wO7mSnVoVZqR9BrRbO84RDh
         Qlnh0Dm/u9V9Ajp5XcTBNg7Od62dhVSgOzNjnZ6dp6UEmNy7C2OD02tFMEJy7Ol+7JcE
         ZeVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HbbWeuojg9myphsl//SxbIwtbZw/1t0n4VEYITtHt28=;
        b=JxziMY7VadKEu5Y7ivM5PbBqT+ij0sjG1oZVjMMe5zg0nQI2ViDIiigLY4VfqJ6Pis
         96ejf48aw4eUugQujz3tKu4Ow5bC/w5GLhEk+GbEsfZOuphrDmRsTBfk8zgKez85qUmS
         zg4xwL8aPZRRcvkSR6zblM6Xxr63uUa9cK7BP7kpTX1iXx0O4/D7u8mMCbl55i5BfE+2
         KNjWa/dH8hfMsFhRhRPhxqGqfRkRSpo0smgAw3ZYnFGny1mPPF9h3msO1h0u30rF/K6I
         8Gkh3BcibX+m6ncrgwfCebbovfRabQ83f9OhZDwRzDHp8waGes02s8LhnVBE/aML2aRu
         mrqQ==
X-Gm-Message-State: APjAAAU3ihHc/3A677zQWZuiZAXW+BRVuCVBVh4d7QLTe3gkyVUlfjBk
        SL+G5LFsVzzo81ThdME2/SL1xbC+XhY=
X-Google-Smtp-Source: APXvYqy+hTofq/AU4rh9biTLEwcAZHO3vQCCXENy4yAtWKdeSO/x2Wn2XxAFY6MesMVSfyePzsKMvA==
X-Received: by 2002:a05:620a:530:: with SMTP id h16mr14021310qkh.396.1567635341806;
        Wed, 04 Sep 2019 15:15:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:fd80:308b:67d1:79a0:786e])
        by smtp.googlemail.com with ESMTPSA id j4sm169243qkf.116.2019.09.04.15.15.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 15:15:40 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] bpf: fix snprintf truncation warning
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
References: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <83242eb4-6304-0fcf-2d2a-6ef4de464e81@gmail.com>
Date:   Wed, 4 Sep 2019 16:15:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/4/19 9:50 AM, Andrea Claudi wrote:
> gcc v9.2.1 produces the following warning compiling iproute2:
> 
> bpf.c: In function ‘bpf_get_work_dir’:
> bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |                                                 ^
> bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  lib/bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 7d2a322ffbaec..95de7894a93ce 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
>  static const char *bpf_get_work_dir(enum bpf_prog_type type)
>  {
>  	static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
> -	static char bpf_wrk_dir[PATH_MAX];
> +	static char bpf_wrk_dir[PATH_MAX + 1];
>  	static const char *mnt;
>  	static bool bpf_mnt_cached;
>  	const char *mnt_env = getenv(BPF_ENV_MNT);
> 

PATH_MAX is meant to be the max length for a filesystem path including
the null terminator, so I think it would be better to change the
snprintf to 'sizeof(bpf_wrk_dir) - 1'.
