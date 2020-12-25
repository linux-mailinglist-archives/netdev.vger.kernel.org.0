Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D782E2956
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 01:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgLYAum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 19:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728914AbgLYAul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 19:50:41 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A17C061573;
        Thu, 24 Dec 2020 16:50:01 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id s2so3772185oij.2;
        Thu, 24 Dec 2020 16:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tUcbf0/5kFSHpbnINiAwr5z5XqMGqzPagwcsvJX6bBc=;
        b=iTWax7kVaE7/2quYQ7BEN6fzFSflmL5oFNU+MQshM6Wfq9qhHPU4PlSOpxAtoUBYb7
         F7MBG/ph94JDgD1d7d68x+C+Oo+HwZ6+eSjS2kFk/gUvlutOAlN/Dr/rJvM7H8PBaqiq
         rtj+gVGFvF1dK5vGsyuB/Sn4y3YkrcT8NSUItE9eZeU/PcYsjAq/Yh8Q1g72cTaAbz9I
         qqXrFiXPD2TvnJ5cb1fCVfnqsEigsKVJb3u7J2utyKvIlMa8mquQlN2EBHwuq6BoRU2C
         AfmjjVCRXG+JiiuYkL6MsmE41MyuG668nNOArg/6BToMgTiD1few+dxnfdm2Mazwc2eI
         Wv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tUcbf0/5kFSHpbnINiAwr5z5XqMGqzPagwcsvJX6bBc=;
        b=n/IQSOhAGXSzu6STNCRJyWIXfmPTn1RTq0BCoQpfAiSrkaLF8gZnq3kBWZncWSx+o7
         z2U6LerU6+0pWS4dNkuvGERMJRGd4hTVtSEY9WHR5WKvhFGBTaTvcBvBQpkW1zQc5i0k
         sSBn/v180Ctq4/7Zj2u/T4lHMuC/mbh2ijkigXXF9TgMxX2w29StLicCaoWB+Fl5DSVl
         FmAt/1F7UiDFaG+H7OjYLr2SY9LxlLfNGh/Sy4TixF6Y5No7mhlzL+X7A/lQwNVErq2R
         ga+2NQ8fZO5z+yllndWAPFnVeIAuXLk1ima/z2wYmZUSSLI4d3jU+d8NhGm8NOC510AR
         imTQ==
X-Gm-Message-State: AOAM533u53nIelnup1IBtdIbYwY3XIwFK1Fu0nYLMn39rnptcFyBz9NQ
        kdXQZ7cnNW+nDawrQuG8jL18aug8kYs=
X-Google-Smtp-Source: ABdhPJz15axGDXO5d4uqd3jsnWAx+j8ol/W3HiRnu4P+wf1BgjFpvdxMyp2sjJC9O40mRvNBC1HQnw==
X-Received: by 2002:aca:cc01:: with SMTP id c1mr4321575oig.18.1608857399639;
        Thu, 24 Dec 2020 16:49:59 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:413b:36ec:90b2:7739])
        by smtp.googlemail.com with ESMTPSA id s66sm5996272ooa.37.2020.12.24.16.49.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Dec 2020 16:49:59 -0800 (PST)
Subject: Re: [PATCH] bpf: fix: address of local auto-variable assigned to a
 function parameter.
To:     YANG LI <abaci-bugfix@linux.alibaba.com>, ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1608793298-123684-1-git-send-email-abaci-bugfix@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <00a09a61-be9b-4b5a-bd46-6f7604a4358d@gmail.com>
Date:   Thu, 24 Dec 2020 17:49:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1608793298-123684-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/24/20 12:01 AM, YANG LI wrote:
> Assigning local variable txq to the outputting parameter xdp->txq is not
> safe, txq will be released after the end of the function call. 
> Then the result of using xdp is unpredictable.

txq can only be accessed in this devmap context. Was it actually hit
during runtime or is this report based on code analysis?


> 
> Fix this error by defining the struct xdp_txq_info in function
> dev_map_run_prog() as a static type.
> 
> Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
> Reported-by: Abaci <abaci@linux.alibaba.com>
> ---
>  kernel/bpf/devmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index f6e9c68..af6f004 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -454,7 +454,7 @@ static struct xdp_buff *dev_map_run_prog(struct net_device *dev,
>  					 struct xdp_buff *xdp,
>  					 struct bpf_prog *xdp_prog)
>  {
> -	struct xdp_txq_info txq = { .dev = dev };
> +	static struct xdp_txq_info txq = { .dev = dev };
>  	u32 act;
>  
>  	xdp_set_data_meta_invalid(xdp);
> 
