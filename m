Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4C42A0E96
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgJ3TYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgJ3TYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 15:24:31 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C58C0613CF;
        Fri, 30 Oct 2020 12:24:30 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id j41so1843330oof.12;
        Fri, 30 Oct 2020 12:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nsaXaT+4r0OxSMEFB6ln4viCGb+YY29jtbW9XqB3Z9c=;
        b=MVXHtPRoo+4YT9iWaoW2FeGC+Rsk2VquzaGbyURIWOxzBxapJwVSBl8A6oXCXTxqTl
         6FtEr+OxSkDFrnJVkxSE87/bwmMAS5L4hVXmZKfiZioE1RWvKMCpt9xHDT8y4hxSF/Gv
         +YNQcAdn6qgHMWyDOu9XJwibNJp9S5YTlX3IWgP3ZpOF1sYMfEIA4no3PqDMzeXts1Iu
         CxpyAcEz8O8EGGglU1KkT/dzNfwPdxOm80/vonvaN7Z2fcaNo5+MsXBJNRk/2tSeDogy
         xRDaDI8svb7Sy99YmyGCxhg3DEG4uQMg15uEPBNFhYUmP4yZp3t+6nTk0QuAcV+Ifb0f
         E+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nsaXaT+4r0OxSMEFB6ln4viCGb+YY29jtbW9XqB3Z9c=;
        b=aQDGQ120ebcA9JqrnFoQf+q7f+vCpfOiYWZvEj/wzr6VhbkFWi8paVUnLdEhnR0qGO
         U3UcZfmZpD7IEazsECdF/Hb1CYthw8ngbfuWK8T4ETZHTxy+i7TmeDABEAh9juhQdzwK
         hvQSC5MDoIbNQKMa/zrppcJpobvpcKlIBP1Di0FgZ5uS9Vo1tQHx0RyNge7ibbOVqIGJ
         ZwVFGXzubSmCI8v2XYQkfnO4DKd4miDnvuwJJwePqNOqlG8xC+xWucJ8wjWyIu537Lq/
         wp6+ZebuKxtdZUNJQLkBdqFkwOJfohQF9k116v/ohFSiG0wvSYtuTuq/xYag7oNy17eD
         0W+w==
X-Gm-Message-State: AOAM532Y1sRx5ktHq3O1PMOtbk9zSRKtm1P9/j1NSFLke1GIcZN8FnF+
        sQnFNcik4+8fRXSj1MwUzcf+3qymQx4p4Q==
X-Google-Smtp-Source: ABdhPJyAVoMMFTK8y0GcmqDkM8YGJHdrnHcu9iZraGUdq8McAsBrMLlsaQbxZWz5du6f+4hk7uPBzA==
X-Received: by 2002:a4a:83d7:: with SMTP id r23mr3089232oog.5.1604085869833;
        Fri, 30 Oct 2020 12:24:29 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d26sm1500158otp.3.2020.10.30.12.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 12:24:29 -0700 (PDT)
Date:   Fri, 30 Oct 2020 12:24:21 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Message-ID: <5f9c6865b0e4e_16d42081b@john-XPS-13-9370.notmuch>
In-Reply-To: <160381601014.1435097.12501509708690649646.stgit@firesoul>
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
 <160381601014.1435097.12501509708690649646.stgit@firesoul>
Subject: RE: [PATCH bpf-next V4 1/5] bpf: Remove MTU check in
 __bpf_skb_max_len
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
> __bpf_skb_max_len() as the max-length. This function limit size against
> the current net_device MTU (skb->dev->mtu).
> 
> When a BPF-prog grow the packet size, then it should not be limited to the
> MTU. The MTU is a transmit limitation, and software receiving this packet
> should be allowed to increase the size. Further more, current MTU check in
> __bpf_skb_max_len uses the MTU from ingress/current net_device, which in
> case of redirects uses the wrong net_device.
> 
> Patch V4 keeps a sanity max limit of SKB_MAX_ALLOC (16KiB). The real limit
> is elsewhere in the system. Jesper's testing[1] showed it was not possible
> to exceed 8KiB when expanding the SKB size via BPF-helper. The limiting
> factor is the define KMALLOC_MAX_CACHE_SIZE which is 8192 for
> SLUB-allocator (CONFIG_SLUB) in-case PAGE_SIZE is 4096. This define is
> in-effect due to this being called from softirq context see code
> __gfp_pfmemalloc_flags() and __do_kmalloc_node(). Jakub's testing showed
> that frames above 16KiB can cause NICs to reset (but not crash). Keep this
> sanity limit at this level as memory layer can differ based on kernel
> config.
> 
> [1] https://github.com/xdp-project/bpf-examples/tree/master/MTU-tests
> 
> V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
