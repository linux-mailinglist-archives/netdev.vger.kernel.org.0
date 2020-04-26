Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700881B91B9
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 18:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgDZQbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 12:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726144AbgDZQba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 12:31:30 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B317AC061A0F;
        Sun, 26 Apr 2020 09:31:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so6265507pjt.4;
        Sun, 26 Apr 2020 09:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JftPLIptlGdZQu6glQqL9kYGbquEnJgxe+P0oVuYl+k=;
        b=R5AkkzWhmKtVHFAab9dLU+POlmMCVkok7ZkJ5yko8Grt5RGlW8ECa88J+LGU2HLF/n
         yk7Qcu/xSrEuq/NJWrDYuURPtOj0/Vh1wagNVv3JHnqFal4AL0jEHldYZbXcrPnP5GDE
         NgbEcoWgOpOcAFOAVws7uYyl2WmMceqwSZOObU2w9+PnUtyqNZfE0c8j3GS9majzYcLM
         nPS2JCKJ8gi7oByY8nLXYjUUSvj/uC3fAomE4iVSGnIviQtopEKFVomaXPC2w4TfO4Iv
         S+KwsvNi+BKJjcJGqjIPzArNNu87lyBT0k+5iewF2OxQKmFuur21VkKa23FsoXsbDn7p
         lq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JftPLIptlGdZQu6glQqL9kYGbquEnJgxe+P0oVuYl+k=;
        b=bgQT+LGK/4LX2R4LtfJ+GyGiZZQ0FYerJrBE/9PX3Bpo4ayQEQWJeSU64Fz0nhUeX1
         s263WeCQU5YUrl08wtMoFjit8elqip9BYJd8rXJJfG3BKzMZWvqkRnOnnR89ZyA+Maro
         PE0qTsCAUsNOwAiD2WirN3KGrCm25iiRLmZZRPmKycVlqLmSMeh0m+cZKAj2jbOdxyVW
         wJ0YpENHQPA1zYJ+Ah9UgoCGhkixsPY3yzBL8gFvsrl4IaSMjQFiNGqyECwZlLsq2JMc
         6xQCSMqXn1TBGVo1QoFcfC1YA2jT4sV/im6qhOHIWdsBeN4SvT7CdzsVh5q4ntTD5F00
         AngQ==
X-Gm-Message-State: AGi0PuagXAFcIigDTYbLReWLFeVfiSx9UUZ/yV5qmlUKUo75GvwKctiI
        /2NmyV5e70Mm2EGPENWdvxs=
X-Google-Smtp-Source: APiQypIi/usw1t/zGxkUpQ4mu2qvt0uw/9W9UaSvCjZagIQB1lwnXigFitQliB/x2kZ1aMOJppffiA==
X-Received: by 2002:a17:902:a40e:: with SMTP id p14mr18334010plq.297.1587918689044;
        Sun, 26 Apr 2020 09:31:29 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:9db4])
        by smtp.gmail.com with ESMTPSA id u12sm10307839pfc.15.2020.04.26.09.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 09:31:28 -0700 (PDT)
Date:   Sun, 26 Apr 2020 09:31:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, bpf@vger.kernel.org
Subject: Re: [PATCH] net: bpf: add bpf_ktime_get_boot_ns()
Message-ID: <20200426163125.rnxwntthcrx5qejf@ast-mbp>
References: <20200420202643.87198-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420202643.87198-1-zenczykowski@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 01:26:43PM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> On a device like a cellphone which is constantly suspending
> and resuming CLOCK_MONOTONIC is not particularly useful for
> keeping track of or reacting to external network events.
> Instead you want to use CLOCK_BOOTTIME.
> 
> Hence add bpf_ktime_get_boot_ns() as a mirror of bpf_ktime_get_ns()
> based around CLOCK_BOOTTIME instead of CLOCK_MONOTONIC.
> 
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
...
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 755867867e57..ec567d1e6fb9 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6009,6 +6009,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>  		return &bpf_tail_call_proto;
>  	case BPF_FUNC_ktime_get_ns:
>  		return &bpf_ktime_get_ns_proto;
> +	case BPF_FUNC_ktime_get_boot_ns:
> +		return &bpf_ktime_get_boot_ns_proto;
>  	default:
>  		break;
>  	}

That part got moved into kernel/bpf/helpers.c in the mean time.
I fixed it up and applied. Thanks

In the future please cc bpf@vger for all bpf related patches.
