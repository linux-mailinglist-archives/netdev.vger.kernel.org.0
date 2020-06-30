Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69420F3B0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 13:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733045AbgF3Lle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 07:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733041AbgF3Lld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 07:41:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4757C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:41:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f139so19264073wmf.5
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 04:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kS/ihn4I7gBA1s//7CfmIRKE50kgObglKHu1jFyAkcw=;
        b=Riqjdk1FEU2lTYQ723CMZXxakGT8I6LEw4Rb5Isax71tz0TDVGju5NvwqTQpIH2blu
         NU7MChP5ooPEONarZGJkoVnw7fF26EpZGt/OPcmE1CVQq2WJXhHyeOTiUbbzzNbRbttq
         tNO084BpHK5/GM10XqE8uX8oe3NvJRPHu9Vo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kS/ihn4I7gBA1s//7CfmIRKE50kgObglKHu1jFyAkcw=;
        b=pZ30rqzvMon+h0Z617/4ESWr+UfYd2DWI5EyIMMlnRxW4Wffw49qqB5lRkCnIcRmW1
         bBTmOBEevoYMcoF0RSelvw5wIFW/v7urALMBtFCuxb+iUfpE3ig232eozPXv6msnkb2m
         OT2Kxw4b55ZZRV5EQ54nWDqQ2PFlf/rud8J4zHuCMsQagfzKF+1gW7acRLqtp/hlK2sE
         IIievc0jLf51suK7jF/TIC+gvCCAk1buAcBoj23JlpPgxHqcIjyBEp/kQkGoCK8tPuin
         YykRKF9S7fqlBFu8CY48DirUYUoNccfYDkUBmqKQkkeyP+NP2mKkPCV/B+KN7PGghnQa
         oSLA==
X-Gm-Message-State: AOAM531o32gyhB+VX6iGkr8I1nC+UH7nPT6zuNgV5RCRseAsNf9M3VSn
        CfbbNww3LKCz+Kn/TcHvfhi3ng==
X-Google-Smtp-Source: ABdhPJyq2K90Ft5jATln3kdT46BEoGknl0+k6a9ORzS2FTrccO5gvkXZWexF6XXPdio9RAFQEapY0w==
X-Received: by 2002:a7b:c348:: with SMTP id l8mr22873949wmj.54.1593517291516;
        Tue, 30 Jun 2020 04:41:31 -0700 (PDT)
Received: from google.com ([81.6.44.51])
        by smtp.gmail.com with ESMTPSA id p13sm3559287wrn.0.2020.06.30.04.41.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 04:41:31 -0700 (PDT)
From:   KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date:   Tue, 30 Jun 2020 13:41:29 +0200
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, paulmck@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 3/5] bpf: Add bpf_copy_from_user() helper.
Message-ID: <20200630114129.GA420871@google.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-4-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630043343.53195-4-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29-Jun 21:33, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Sleepable BPF programs can now use copy_from_user() to access user memory.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Really looking forward!

Acked-by: KP Singh <kpsingh@google.com>

> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       | 11 ++++++++++-
>  kernel/bpf/helpers.c           | 22 ++++++++++++++++++++++
>  kernel/trace/bpf_trace.c       |  2 ++
>  tools/include/uapi/linux/bpf.h | 11 ++++++++++-
>  5 files changed, 45 insertions(+), 2 deletions(-)
> 

[...]

> +	/* */
>  
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> -- 
> 2.23.0
> 
