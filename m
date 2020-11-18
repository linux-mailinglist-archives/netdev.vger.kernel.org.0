Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0EC2B8341
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbgKRRn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:43:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgKRRn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 12:43:29 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33A0C0613D4;
        Wed, 18 Nov 2020 09:43:28 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id g7so1881030pfc.2;
        Wed, 18 Nov 2020 09:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=sRCwxS66ZR/salGsNwKnPDw68R6cz9+hKE+O0/zoZds=;
        b=P2OJByOvtXt2Zw19OkJszopeo0esTfCMKBmd8GiWJ3QnCIKrCNBWlAaMzPTWqV70yq
         lOydr4PFY0q6hEsUCAvYkSBFKtdbOL3a9Er4wM+rOhjZi5+slOhsjzaNE6UaRTOtCRdo
         5ne9iiwfUr1xct54IImgomC4LPsJHrHXEuY5McP4NzscRrS0JgMqmIPm35PtfrcK5vvp
         HlkALaI60jCZtZ/nGEoDqidOZMSrHPaBd3AghIrkXX0ixpDT4/mjXWhTQv0o4QEBFtf7
         JHLhX0/0lqJAAcnAo7tUyUp8T32M6VUel3LG9vSTIYU+g6J8UUEVbzvynXcuzYUntLMQ
         WNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=sRCwxS66ZR/salGsNwKnPDw68R6cz9+hKE+O0/zoZds=;
        b=TP4mGNTlyXQ4oPdnqOspoG0l8FXZteOzKMs9bn4PaYeqA37a/fXXutTfzvIbhc4T2y
         82jutrjtPjH8pmC8WzxqSGHYBA0RSFNXQSR+rj3a50HyoNZ0Vs0cbD70fOAldfELJRDC
         kmXLAiBzN6rm1OiD8rAFspoTcvxqVcYs9EaLKrx9tKLPFCvXox2s9mUOXedJaFuH6uiG
         6lRK41/cP2C7B5dGlKKdErNa5dbNLIJhPDQE6xHeBcSSELSsEPRwhHZ5Pd14Ge2hwLda
         8F+4o2xWv/d9WqKaz1b/jh74WKrqjlr53ZvjydKMZMIBTzvARi6zhT6RIIoCcdtgNlPQ
         LnQg==
X-Gm-Message-State: AOAM530yaFCwnkji6vtbmrvYUFDs4B+12ScDZPhkc8LWptAjXLtMmBFS
        SpyVympuett4Xmb6LeGtD9U=
X-Google-Smtp-Source: ABdhPJx2oirokdS8J6FmAhxzUgb4AS+8DHOeTjlmkVKnjDoLb1upkYDTtW4fa52PUg47t50SrXiAVA==
X-Received: by 2002:aa7:955d:0:b029:18b:f646:7d21 with SMTP id w29-20020aa7955d0000b029018bf6467d21mr5174578pfq.61.1605721408542;
        Wed, 18 Nov 2020 09:43:28 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:e6dc])
        by smtp.gmail.com with ESMTPSA id a84sm26024058pfa.53.2020.11.18.09.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 09:43:27 -0800 (PST)
Date:   Wed, 18 Nov 2020 09:43:25 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     daniel@iogearbox.net, ast@fb.com, andrii@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, brouer@redhat.com,
        haliu@redhat.com, dsahern@gmail.com, jbenc@redhat.com
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_version() function to get
 library version at runtime
Message-ID: <20201118174325.zjomd2gvybof6awa@ast-mbp>
References: <20201118170738.324226-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201118170738.324226-1-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 06:07:38PM +0100, Toke Høiland-Jørgensen wrote:
> As a response to patches adding libbpf support to iproute2, an extensive
> discussion ensued about libbpf version visibility and enforcement in tools
> using the library[0]. In particular, two problems came to light:
> 
> 1. If a tool is statically linked against libbpf, there is no way for a user
>    to discover which version of libbpf the tool is using, unless the tool
>    takes particular care to embed the library version at build time and print
>    it.
> 
> 2. If a tool is dynamically linked against libbpf, but doesn't use any
>    symbols from the latest library version, the library version used at
>    runtime can be older than the one used at compile time, and the
>    application has no way to verify the version at runtime.
> 
> To make progress on resolving this, let's add a libbpf_version() function that
> will simply return a version string which is embedded into the library at
> compile time. This makes it possible for applications to unambiguously get the
> library version at runtime, resolving (2.) above, and as an added bonus makes it
> easy for applications to print the library version, which should help with (1.).
> 
> [0] https://lore.kernel.org/bpf/20201109070802.3638167-1-haliu@redhat.com/T/#t
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Unless iproute2 adopts scrict libbpf.so.version == iproute2.version policy
and removes legacy bpf loader no iproute2 driven changes to libbpf will be accepted.
Just like the kernel doesn't add features for out-of-tree modules
libbpf doesn't add features for projects where libbpf is optional.
