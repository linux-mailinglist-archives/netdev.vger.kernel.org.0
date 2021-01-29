Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C683D30857C
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbhA2GH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhA2GHZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:07:25 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5891AC061573;
        Thu, 28 Jan 2021 22:06:45 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 16so8180460ioz.5;
        Thu, 28 Jan 2021 22:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=z1upcokDa9M3p7R0rq2fGbu55r01gKcaNgSaRbQ/XcM=;
        b=MXK/GJnZZzBuf9C5qkj8lbmIEhRzgDxKsZy2YxRN+PES1OApV9pWTQ2Toi31SJuYS8
         SGYwDhO1wTBUHAw226o9PIHzxO9Krix/WJ6JYLF/oIZzCViI0uEF30L/Z3MxnqvJZeXZ
         DSLa9pnv36d8M/XHgwE/GfVWHDvUNwqEDdiAh6nKwpvBXsNAYPuJAYUG9xvugU7zvDAL
         ArC3uP1MOM+/vqUk7NSeaku+vYLZAdjuPZFSX9GS8afnSxG/CzYSOF+ATZYv7yMoCIbk
         cll68zQ5wvPd1MZEIw0blQSSnIR6lIKOgtIcoC/Ca3OK+JQBEMjRenKt3RDdFyFvU8gg
         gm4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=z1upcokDa9M3p7R0rq2fGbu55r01gKcaNgSaRbQ/XcM=;
        b=MXSUHTeVhLnpA6pDsCb/nXcx3N83ZPTKjlmFYqS6qY9sJfsBTvn/rUG3rxVZ5s0yrv
         YyE+JdaW0QClx1Pg7+Op9sejnupMUKvsj81e5irUEumk9Vvd5cZ9pP1nhi0MdntISiXH
         5NrzGsWJdEYJoASFyMwOF3jXg7B7fpy0xJEgjA5mfWHOGNpNtrebvra2ngqEVJ4Q8Tr8
         oMSHgE9X/L8bjAJl4KasV33y8niKkUtXGf82PNi14/IXYr6MUpXhNGhIYWpcn0zZlBMK
         Kihfd226wDWxWUYQ83+QyO3RdziMhr+d6CY/eb1vc2yo6oIKzk19ptULRFhDmYXyter0
         tCbQ==
X-Gm-Message-State: AOAM532iPjvowrXEZxP0BiC89ag169u/Dl8tZ50dB0FUVheCCkEAD66M
        ofX5YUFpunX7LBB9Lssju9M=
X-Google-Smtp-Source: ABdhPJyi86XiwUiFErCD4vOYtAHx6v38tZVMH0OpwFfJV3Eac7/2HCweysMuyO9Oeo46qtSf6AMQQw==
X-Received: by 2002:a05:6602:24d4:: with SMTP id h20mr2169366ioe.64.1611900404886;
        Thu, 28 Jan 2021 22:06:44 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id i8sm3939046ilb.38.2021.01.28.22.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:06:44 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:06:36 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Message-ID: <6013a5ec3f7c7_2683c208a5@john-XPS-13-9370.notmuch>
In-Reply-To: <161159456731.321749.5837621737819856023.stgit@firesoul>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159456731.321749.5837621737819856023.stgit@firesoul>
Subject: RE: [PATCH bpf-next V13 3/7] bpf: bpf_fib_lookup return MTU value as
 output when looked up
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED. The BPF-prog
> don't know the MTU value that caused this rejection.
> 
> If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> need to know this MTU value for the ICMP packet.
> 
> Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> value as output via a union with 'tot_len' as this is the value used for
> the MTU lookup.
> 
> V5:
>  - Fixed uninit value spotted by Dan Carpenter.
>  - Name struct output member mtu_result
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
