Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F13D9C70
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhG2ECa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhG2EC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:02:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DE8C061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:02:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so7449687pjd.0
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xG63JwIn8oXd4KFAp+ZF12D7k4Mxe3aRwpN9OD4bUTs=;
        b=J9mcUiT2fjrxYbwi/b3yYQSWvUw/+KKni6DrUUw71KzpaEocGnLkFZqwfGmgOUHV4z
         vYr1s1Oe73GPlNz6VSRJSDFfpkAl3uyVbORwimK3zIOHmV0IOawUIttdDXY1ATOnXS2o
         hfhxFpeMzX1jMu0cJBmX/Bl3Engzc1oeV0if1XyFgPCbXKKtJ0UxXrpXkCvzHtUOx+Md
         i113ygZhubtjwwwRs3SW4/Qfbj04QKpLfZe0zo/X0wpGTOdcKZlacN+EDH0onIq8ZBtB
         5U49DV8l7xOIUoVrxmjJHG8Q6/azzSa3Suq6zQFIAseT5RT1QqgAUVN0MXWgGc5M+QzX
         rHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xG63JwIn8oXd4KFAp+ZF12D7k4Mxe3aRwpN9OD4bUTs=;
        b=N6XyNmGhtoRM9hWRirmNA+lasF6zOrEs9miuxqZAVe3aT1O3pqFUX8dnsbw7HT0Ezm
         wlsQRljJm/9XKvOkPEgX0n119QWE21WCgcNq+yLWbbQhqMlGUKgB9/zGXBoVuBVR1m7Z
         zmE2e/A1drq2dIszslvOpv43YRDPvzhU14BnMmAv4Wdnm5mbSh0Qqc9J8UCWGbOvqIt4
         nV05k5bTZ5zNRp9RKglaP6aPMCPbpsYWHm4NtpXtWxSFHoHpHnxEgfrlfPc4Ph+CfAG2
         yCS9PzTSEMXs92nyyhfyqDqmU1YT1MNfoV8Vceb66wbArMVfKJ+4QQqlbTQWPI+Oy2Z2
         uqIQ==
X-Gm-Message-State: AOAM533J4fnv8UEf84nHMoE+P8OuMtXK1CsIakkxkho3K5ctKqPYPQ3q
        +ZoP8nOAF3uPGmjyaSLqAsfaPQ==
X-Google-Smtp-Source: ABdhPJzDXamjaPDf8+YV2QSUooxp1SocpuXsgrnUxgR1XUUKed7Jp+1BGJ+lvn69eH3u3Es+4WNkMw==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr12640738pjb.113.1627531345499;
        Wed, 28 Jul 2021 21:02:25 -0700 (PDT)
Received: from [10.255.137.154] ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id u21sm1542281pfh.163.2021.07.28.21.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:02:24 -0700 (PDT)
Subject: Re: [PATCH] lib/bpf: Fix btf_load error lead to enable debug log
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        chenzhuowen.simon@bytedance.com
References: <20210728093321.16500-1-zhoufeng.zf@bytedance.com>
From:   zhoufeng <zhoufeng.zf@bytedance.com>
Message-ID: <f4e53471-aa20-3579-6d44-85e6b3524b9f@bytedance.com>
Date:   Thu, 29 Jul 2021 12:02:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728093321.16500-1-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



ÔÚ 2021/7/28 ÏÂÎç5:33, Feng zhou Ð´µÀ:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Use tc with no verbose, when bpf_btf_attach fail,
> the conditions:
> "if (fd < 0 && (errno == ENOSPC || !ctx->log_size))"
> will make ctx->log_size != 0. And then, bpf_prog_attach,
> ctx->log_size != 0. so enable debug log.
> The verifier log sometimes is so chatty on larger programs.
> bpf_prog_attach is failed.
> "Log buffer too small to dump verifier log 16777215 bytes (9 tries)!"
> 
> BTF load failure does not affect prog load. prog still work.
> So when BTF/PROG load fail, enlarge log_size and re-fail with
> having verbose.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>   lib/bpf_legacy.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
> index 8a03b9c2..80c49f08 100644
> --- a/lib/bpf_legacy.c
> +++ b/lib/bpf_legacy.c
> @@ -1525,13 +1525,13 @@ retry:
>   	fd = bpf_prog_load_dev(prog->type, prog->insns, prog->size,
>   			       prog->license, ctx->ifindex,
>   			       ctx->log, ctx->log_size);
> -	if (fd < 0 || ctx->verbose) {
> +	if (fd < 0 && ctx->verbose) {
>   		/* The verifier log is pretty chatty, sometimes so chatty
>   		 * on larger programs, that we could fail to dump everything
>   		 * into our buffer. Still, try to give a debuggable error
>   		 * log for the user, so enlarge it and re-fail.
>   		 */
> -		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
> +		if (errno == ENOSPC) {
>   			if (tries++ < 10 && !bpf_log_realloc(ctx))
>   				goto retry;
>   
> @@ -2068,8 +2068,8 @@ retry:
>   	errno = 0;
>   	fd = bpf_btf_load(ctx->btf_data->d_buf, ctx->btf_data->d_size,
>   			  ctx->log, ctx->log_size);
> -	if (fd < 0 || ctx->verbose) {
> -		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
> +	if (fd < 0 && ctx->verbose) {
> +		if (errno == ENOSPC) {
>   			if (tries++ < 10 && !bpf_log_realloc(ctx))
>   				goto retry;
>   
> 

Sorry, this patch is wrong. please ignore it. I will send a new one.
