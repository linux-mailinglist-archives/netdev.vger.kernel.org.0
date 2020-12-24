Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07172E28C9
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 21:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgLXUWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 15:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgLXUWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 15:22:36 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B237C061575
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 12:21:56 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id u19so2952186edx.2
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 12:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OSyMhhLOs+gJkV1hBlUrD8wxjF+XuKOQBS1qIF2OVBo=;
        b=GXPu9iXNKroXhBQ3NuRBUyu7qwxpJj81nQEXg6lFqE6JtI9vqTmWWqPkzUvISXEHpS
         rnEP5EeblPBviGkjtRHNCCkG13ZHUKPHzkVq93cWpTuWXWopRXTQDvOK9pA26MNpeuXa
         crtsjTt+QHR+qkS9WUBfdkJ87O06hQpwNNPYjimDPJduZA+m6xHVKw7txDROvCt2IkGW
         u2PgQfUnO1Cc/6YFyoTEce0z18kr7TuYXwthdzE/CDIswLOUpMiRDMn4p78YJqu9j32O
         p5frJeCjMv7+Qz5a5TjGCL7Ur3Z7+L6fq/nNXS5GRHEX6wh3OPGEG55SouTEzPhqv91m
         lGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OSyMhhLOs+gJkV1hBlUrD8wxjF+XuKOQBS1qIF2OVBo=;
        b=d4xh3SkZbT+DVmXI7umKBxCfmrHXNSBYFOVgd3Cxff2Wa2V0CXfVQVA8FcbSqiyQu6
         lGXk+tQQ+gIbdcK9Plh4SnQVj6zTmcC8ei1QTwXV0MrT3lcKM6D+Pih/QkXJQbkfAtzB
         f3vCJBFnbiFriQna+Po/tWCQmy1wyZ7pU2H0t4vSTxLfbKcfS67YqYMs9ePhAfAGxOmq
         S9H410bH7qEJPtgWGUHHuPlauT3TjYLCjR3jV3ejElXetD4VNz1aN79mgKZZ3iWAvImL
         aghrp0HshqK9dGdh1hYvc3siTI62Z6i9bLZp/Of8/8yAEcZPqEze6yG1F74fLvdfDgDN
         xW0g==
X-Gm-Message-State: AOAM532nM4km3dh6+WPaWmDHF21qIfV/+noMCuiYHBXhIDIf1UGFbqE1
        iS6ZrhkEf4dzp5IbIyhNKMwB1g==
X-Google-Smtp-Source: ABdhPJx+uTKMo065QA17ljoCp5G/bHHEIvKZRQvh62B1ObvYgNEWw5suRU9fRncpMLe+WStRSvqviw==
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr19785736edd.35.1608841315120;
        Thu, 24 Dec 2020 12:21:55 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id q25sm32419922eds.85.2020.12.24.12.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 12:21:54 -0800 (PST)
Date:   Thu, 24 Dec 2020 21:21:53 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     trix@redhat.com
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, gustavoars@kernel.org,
        louis.peens@netronome.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, oss-drivers@netronome.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: remove h from printk format specifier
Message-ID: <20201224202152.GA3380@netronome.com>
References: <20201223202053.131157-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223202053.131157-1-trix@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 12:20:53PM -0800, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> This change fixes the checkpatch warning described in this commit
> commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use of unnecessary %h[xudi] and %hh[xudi]")
> 
> Standard integer promotion is already done and %hx and %hhx is useless
> so do not encourage the use of %hh[xudi] or %h[xudi].
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Hi Tom,

This patch looks appropriate for net-next, which is currently closed.

The changes look fine, but I'm curious to know if its intentionally that
the following was left alone in ethernet/netronome/nfp/nfp_net_ethtool.c:nfp_net_get_nspinfo()

	snprintf(version, ETHTOOL_FWVERS_LEN, "%hu.%hu"

If the above was not intentional then perhaps you could respin with that
updated and resubmit when net-next re-opens. Feel free to add:

Reviewed-by: Simon Horman <simon.horman@netronome.com>
