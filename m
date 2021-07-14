Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF7C3C8823
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 17:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbhGNP70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 11:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239897AbhGNP7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 11:59:25 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933B8C061762
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:56:33 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 141so4163029ljj.2
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 08:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=WzBK9ERHaZxFdBxPHSrbA4IYumXCPn8UfReAHKrj0v0=;
        b=w5jc7OAKHRzl4YTn6zAvJ++zfto0ZvfyzqmrXKgj7WmDcPy30D6INjI2tBQTJIWzab
         37qtPfPCPHNuNH7269XPrQvqhXATnXxYMs37hHzeuBM7n4FJJ2H/AYq/eyPhiZew4gdD
         MtYYjmrcRruL3LO+c6gMkb+SJ8e00riguWgR4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=WzBK9ERHaZxFdBxPHSrbA4IYumXCPn8UfReAHKrj0v0=;
        b=ppNrgHxTDPMP9fd3VKDhRRYbSH2JnIebzqzpjMfeiC3qPOpi9LxNiii0wWkAhU6834
         ZArLnXzJyv9z4ej0oWzHs7/S0/wJBHM8ogbpOhIhpoW1BiHXIp7K1B/CBEtZvxIE7DrT
         SsY4hBYvd/CSE+NwhWGLT1bac2b74zydCouhQNam4jfeQw5z9Q88DTG60x2elzyQK2dG
         V+IztffRTwEG0LCAwRHvBji6EphvufmobapS/KDCOqzgY/TvDOgmESenirIA4jxXGAeF
         bSnbCzllnDrVoWzvGWIEKYaj8By5HlfWe3ppgPkrEFwd6JDyV7MkDihzt9QQyEbWteSX
         qVGQ==
X-Gm-Message-State: AOAM531ATLPEr2PZYoAh5+RjVY9UtZdsLM0a75entE7MMEifHl3/+q6r
        TWnVWBUwymJhNpkuxZfBI76NfQ==
X-Google-Smtp-Source: ABdhPJyV0huv3JF5YuH6LhKvklYRlJLVKfmbyztk2SWOSdYbNSzfUzpDoVpN+RqID0QtAhEYsaDYhA==
X-Received: by 2002:a05:651c:1aa:: with SMTP id c10mr10124921ljn.56.1626278191979;
        Wed, 14 Jul 2021 08:56:31 -0700 (PDT)
Received: from cloudflare.com (79.191.183.149.ipv4.supernova.orange.pl. [79.191.183.149])
        by smtp.gmail.com with ESMTPSA id a3sm191060lfl.134.2021.07.14.08.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 08:56:31 -0700 (PDT)
References: <20210713074401.475209-1-jakub@cloudflare.com>
 <CAM_iQpVV1XRTsbyEbG_GTb4GHHx47m+TOYYw_z3euX3UYvDt9Q@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf, sockmap, udp: sk_prot needs inuse_idx set for
 proc stats
In-reply-to: <CAM_iQpVV1XRTsbyEbG_GTb4GHHx47m+TOYYw_z3euX3UYvDt9Q@mail.gmail.com>
Date:   Wed, 14 Jul 2021 17:56:30 +0200
Message-ID: <87wnpsris1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 02:51 AM CEST, Cong Wang wrote:
> On Tue, Jul 13, 2021 at 12:44 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
>> We currently do not set this correctly from sockmap side. The result is
>> reading sock stats '/proc/net/sockstat' gives incorrect values. The
>> socket counter is incremented correctly, but because we don't set the
>> counter correctly when we replace sk_prot we may omit the decrement.
>>
>> To get the correct inuse_idx value move the core_initcall that initializes
>> the udp proto handlers to late_initcall. This way it is initialized after
>> UDP has the chance to assign the inuse_idx value from the register protocol
>> handler.
>
> Interesting. What about IPv6 module? Based on my understanding, it should
> always be loaded before we can trigger udp_bpf_check_v6_needs_rebuild().
> If so, your patch is complete.

That's my understanding as well. The lazy update_proto call chain is:

sock_map_update_common
  sock_map_link
    sock_map_init_proto
      psock->psock_update_sk_prot
        udp_bpf_update_proto
          udp_bpf_check_v6_needs_rebuild

If that happens we are being passed an AF_INET6 socket. Socket has been
created so IPv6 module must have been loaded.

>>
>> Fixes: 5e21bb4e8125 ("bpf, test: fix NULL pointer dereference on invalid expected_attach_type")
>
> Should be commit edc6741cc66059532ba621928e3f1b02a53a2f39
> (bpf: Add sockmap hooks for UDP sockets), right?

Thanks. Fixed in v2.
