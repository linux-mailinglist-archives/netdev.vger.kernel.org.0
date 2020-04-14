Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D851A8B72
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505191AbgDNTsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505187AbgDNTr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:47:27 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF49C061A41;
        Tue, 14 Apr 2020 12:47:25 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w70so10498992qkb.7;
        Tue, 14 Apr 2020 12:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mpc+sTxJHNgCL6DC53l01eU/l7JWX8zxLeg8Sj6y+7s=;
        b=oBzKeFpmpzHy7a13xXFzO6jaiA4qtehVRoZG0W3K7IuRUWTOehYAONSKU8Djz6VTcf
         ujz28/FWGy9bSLl+o3NO6CFhpGM8rsNjKOljHSQAX933b4vfM6D7gTfp4VajHRlsFmdl
         RRfDk6r05RkBvQoeSkrcTUCoojEuoakoVike86hBggj8Ype+BWNmAy+OYAAYuFwtE/I0
         q3ujK+r0KtHfNk8dCZez7bTlf3QqMQKdovvjbFYdAI0x1i+pYTXiNHmAEw+jwgtWx28s
         bD+n/dl/SXW8z5sg5BRMR52jV8ued/us+mFj2zDMF+Wu10jTOTOLLhVr5Kd8FLfMQuw7
         Gp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mpc+sTxJHNgCL6DC53l01eU/l7JWX8zxLeg8Sj6y+7s=;
        b=WBo72Cgyg8Y54w5snfFtpyH5tJl5UAKHMs7sgpuT7Z5QPFn3O2Nzu8uhChPxvWmT16
         2hACL1GEcMu3iWQtdUYrIb+ca79fI3CS1UV5CFVArZQMPjfm63TMObTcWtXWoa2BG0hE
         +Dd+tpUmvn3B+jV13MWUQifHcPzTLCVKjvuYAK1YKZx1vmahmud5D/LkIlwj8yZPojZn
         vtVbv60pCpXuEndFv4Eyd1N0SdB4lw2pz+FQ+bMR1Q12tGe0dsC/o5hq/wCvHqY7GOkR
         Z2hiCgFllG7CU60MnvuGY+AtrtjUexmS39/CHjZ2zM2K+Cxl8+ntp3lYGyo3Mown7GOy
         bdag==
X-Gm-Message-State: AGi0PuaaALdwOBN+eoQPBA6NBE8Y2/7AP3HxIUrl1AoiG27JKMU/SEIg
        DJJuinDFwEbqXDQhrF5VoH2ivTP4
X-Google-Smtp-Source: APiQypKWXIrFm+BBoPwc8R9/RRLrLkSI6f6EsIc69Ms4KBPYP2hcHmRfFPDIrP+7dhztQQV3lOzwog==
X-Received: by 2002:a37:8b04:: with SMTP id n4mr22912251qkd.222.1586893643313;
        Tue, 14 Apr 2020 12:47:23 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:d8ef:5c3c:c55b:860b? ([2601:282:803:7700:d8ef:5c3c:c55b:860b])
        by smtp.googlemail.com with ESMTPSA id v27sm2375542qtb.35.2020.04.14.12.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 12:47:22 -0700 (PDT)
Subject: Re: [PATCH bpf 1/2] libbpf: Fix type of old_fd in
 bpf_xdp_set_link_opts
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200414145025.182163-1-toke@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3d270607-6fbb-b56a-ce77-ddc8fc26460d@gmail.com>
Date:   Tue, 14 Apr 2020 13:47:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414145025.182163-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/20 8:50 AM, Toke Høiland-Jørgensen wrote:
> The 'old_fd' parameter used for atomic replacement of XDP programs is
> supposed to be an FD, but was left as a u32 from an earlier iteration of
> the patch that added it. It was converted to an int when read, so things
> worked correctly even with negative values, but better change the
> definition to correctly reflect the intention.
> 
> Fixes: bd5ca3ef93cd ("libbpf: Add function to set link XDP fd while specifying old program")
> Reported-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 44df1d3e7287..f1dacecb1619 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -458,7 +458,7 @@ struct xdp_link_info {
>  
>  struct bpf_xdp_set_link_opts {
>  	size_t sz;
> -	__u32 old_fd;
> +	int old_fd;
>  };
>  #define bpf_xdp_set_link_opts__last_field old_fd
>  
> 

int is much better. Thanks,

Acked-by: David Ahern <dsahern@gmail.com>

