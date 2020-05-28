Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CC1E52D3
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbgE1BTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgE1BTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 21:19:22 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFD8C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:19:22 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id z13so2360082vsn.10
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 18:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wSADy6VtwbU/IzpWuyGk41O+edRDArDU2SKOy/GfpL4=;
        b=AL/5Wq4rVwEoWqi+MZduZTbSUJbixzsdBq2wRNeenko6n7eP9EEnb29G+z6pfNlfxD
         //3gI2hVhNU7+NYNYj+DtpaTBu4qy6qMpeI68E8vepp2JZtc03YrZCBuyecpaPIOUj1X
         ViK+LlKXcpXL3oTeTLGhya5H9+ztSz2EN9PRG3GbYsf6NtBu+tAUoNb1Wfq0oe+11bmO
         gEayCmSFvLSLJBTZAt7TZA+X2q/hsYhihE550Yvb5JNMRu48sirVSNhu8JhVLAFlt2L0
         l+Am5cGoTtu8ThIA//LNbUiB/9fmDXf7JyxbGu4Am4KiIE4/PR9hX5FhlsXsz+fCsf7T
         J3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wSADy6VtwbU/IzpWuyGk41O+edRDArDU2SKOy/GfpL4=;
        b=TMPXmhhUPMGicYnhN4ohXpPbSTlwx/MxpeLvuQCQGQDb7Z1KI86oJmAaDArTXrKi7Q
         FO7dGEJt3TpD2wdyca/gMxDxc7UPjMVohAklP0xfLzesuRRjMNT2Oys0ZEDHrGKSaxwn
         5hJ7XqkrJDcoRORdsT774HDwywTRNjhpuJSLuQos5x3Sr5rad14HOXmC8fPKyADJwK5H
         fIL1bU/XOyFjVVC7nZD4zkwGFXOYim7GR5/ME9FZghOn0ndL73Q6bb3Hn0kaLasDyyz7
         rdQd6hEBR7yAi+2hzNF0+HiMxBkxsobYUADT4bpR+JEAqXD2unetG7d8yJVI+AjMCSrP
         4Jww==
X-Gm-Message-State: AOAM532/m335XdXrpd+RKiviGITA90RgJXvfghP91rbjBdXUQ1Tu0FbE
        //cz8ofNHKs4MJGVq1d1t43SvBMh2aYfQ3ZD5StNGg==
X-Google-Smtp-Source: ABdhPJyJi4dVystIP83IuzoYRa1JcRe60BROoP93xVeaqrTe+JIYP7IVzI7jnYbfGLZzDbMBfbBq/NNJ8jruNISu8aI=
X-Received: by 2002:a67:d098:: with SMTP id s24mr374853vsi.25.1590628761496;
 Wed, 27 May 2020 18:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200528003458.90435-1-edumazet@google.com>
In-Reply-To: <20200528003458.90435-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Wed, 27 May 2020 21:19:05 -0400
Message-ID: <CADVnQy=2JrtKf-AO8pMn4QFSDQJP4Vm0anBCNx6WggRPd7OA=Q@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: ipv6: support RFC 6069 (TCP-LD)
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 8:35 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Make tcp_ld_RTO_revert() helper available to IPv6, and
> implement RFC 6069 :
>
> Quoting this RFC :
>
> 3. Connectivity Disruption Indication
>
>    For Internet Protocol version 6 (IPv6) [RFC2460], the counterpart of
>    the ICMP destination unreachable message of code 0 (net unreachable)
>    and of code 1 (host unreachable) is the ICMPv6 destination
>    unreachable message of code 0 (no route to destination) [RFC4443].
>    As with IPv4, a router should generate an ICMPv6 destination
>    unreachable message of code 0 in response to a packet that cannot be
>    delivered to its destination address because it lacks a matching
>    entry in its routing table.
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks, Eric!

neal
