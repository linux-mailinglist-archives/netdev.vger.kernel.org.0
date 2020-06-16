Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625281FB88B
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgFPPz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732774AbgFPPzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:55:10 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570EAC061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:55:10 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id p18so14643952eds.7
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 08:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4MZz+gQSjrUiW8A5Rr9Cr5uWAGuLGgGCK1CinfFgSlU=;
        b=tlnUH+VagKBnH9ClkpjWYL0SERYZg7BlqN9stIkcg71xVuSQ+oqkWnR+vu45BNYGH1
         Et5y5B7NtMttydbUfa3FW7KL79Bxef0U8pGww+jPFhSSBUTptUfmCrC97zY5vO6j/s8C
         aS0pA553dqyKS/mKSz729DF/OTw1yldb8osWPOYNjaPfsvJ5FfJ9hKDBvNIwtCYYHIQh
         EXVVUAvJRabayHQdxWSaw3nLwxWot9c7Xpk6/uchbuA8hby42bNtruyErqyWDSpwDdx3
         EwYsaAKZekIHIBQPa6w4JtrFIkzBmRrlGVCRuYz+vvNAncJjqs07BR6VXru5oPbBEBoN
         ASHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4MZz+gQSjrUiW8A5Rr9Cr5uWAGuLGgGCK1CinfFgSlU=;
        b=gPbK0lkjnBddv2H8U3o3ccn8vSUIym5X7cR3nzW8akCPKB5coNXqprDnkyNTu6vyp4
         kYhmTe7ayvO/yWaL+7TCvTwIM9565/CrhO7QuSHpF+lPNS6o4tPkh5z4tVPzm1C0Hyzp
         ilNKY9Pd/ShwU35/+rvunJfUxWHxLOsEJhhGbeT/SAJE2rtxTrYnqdZMFN6tFLE+vvIX
         o5CUogwVA1MA0Ue924u6dGxPiY0WHxe6QEivG30mgceJ/YN3vEjfPUK4ZXP7zqzjz1rM
         MexX35fP03NZIcPdgGxtltGTDleIoeRGW5lGLMzQQhQ+ne4hKO4gMVgRq7da3uVSTwNE
         yocQ==
X-Gm-Message-State: AOAM532zZZ5QWKxsUxUABMcQAs58C1H9LT5oSJreCka6ya16qRyyuuRf
        b7wYUVCpymGBy7abdVV/W73w9A==
X-Google-Smtp-Source: ABdhPJyw6Haz8kay07oFbDG4pMcKeG0MwI2wMasmKqXJB3XnqQpZ3xYrOU2nXh0gnE4/MVjZwuoYmw==
X-Received: by 2002:a05:6402:a49:: with SMTP id bt9mr3285952edb.300.1592322909106;
        Tue, 16 Jun 2020 08:55:09 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id qt19sm11345955ejb.14.2020.06.16.08.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:55:08 -0700 (PDT)
Date:   Tue, 16 Jun 2020 17:55:07 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        vladbu@mellanox.com
Subject: Re: [PATCH net v3 1/4] flow_offload: fix incorrect cleanup for
 flowtable indirect flow_blocks
Message-ID: <20200616155506.GA18143@netronome.com>
References: <1592277580-5524-1-git-send-email-wenxu@ucloud.cn>
 <1592277580-5524-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1592277580-5524-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 11:19:37AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> The cleanup operation based on the setup callback. But in the mlx5e
> driver there are tc and flowtable indrict setup callback and shared
> the same release callbacks. So when the representor is removed,
> then identify the indirect flow_blocks that need to be removed by  
> the release callback.
> 
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

