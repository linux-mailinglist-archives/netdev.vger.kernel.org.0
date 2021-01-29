Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F830856E
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhA2GBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhA2GB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:01:27 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5498DC061574;
        Thu, 28 Jan 2021 22:00:47 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n2so8155459iom.7;
        Thu, 28 Jan 2021 22:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=/LLeDxItZKrrnU9Awl6b7I+nhc/rbMqwWQ09Fd8m3xU=;
        b=HINYYcxHL3poLcnle97ncEvDtFb6CLRSHYv9txKGEo/qAmeMAt0uLCoVRQqASFogjM
         VqsWqeCKbh1zKIMi1INYIxs9IxOzIGvnmWPYg+ZE92UNmqzLpBjTmSKs/ir2lcPw94J6
         eEXn9U43XwpgoSCrFImNauBWbG9SpdLcGi+EtJfaD8ih0Rcb85EaOjsmWjqx5BP30QVa
         g3m01PRjN9Q3yelGANqWbXxM+qxnYRAOVZftI6pZqJU3xwtc24RTPyECrbdAJIP4YcQQ
         dv9P1kUfB/uOclIzTbLiBu825UtwARLDkl8VFC3br3WcayJgQ4hiVX60U71C10DZ/s5m
         Vr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=/LLeDxItZKrrnU9Awl6b7I+nhc/rbMqwWQ09Fd8m3xU=;
        b=ILENxQG4QSldx8l6o4pJ6TPlP+CjIi5PfZEgUNRvHhFy8CDqYDVPmRnVio1izpwc1L
         TMT0IyRpbps3e9T+YpfEfTspBU1ypLUoSSaqGb50P9Zs665JK5NGvOUYkwwZ11zc5ptU
         xrNN0q/7s8uE3e3tLJVcl5HMN+odlX5PF/Ato5vLt8uEbAYgcnNKMdXl6Fn3w2eBpkIq
         5AGjHOr2mkwlXBOWzMB/NVnF/5ZzNL5BXhcne83nmGtqmZ+X1Nw+pZ4cGBKKGvgl9qkm
         VbxisabrgooMRyeuU4H8OvImKbZSMIyJc2HpUdzwLvsc+Krbvroov5IWKEBoYZ0rXN5d
         L4vg==
X-Gm-Message-State: AOAM533qja0moMJmk5K43NwF5vlvomOwuTbIq1eSirNgwcIokZVZ3+oF
        1A8QtYPd2yc7jikG3BJmNpI=
X-Google-Smtp-Source: ABdhPJyEBIPX1th482CN5kn8udFikOVbhhD2vdaEUBig1yp1A3FNXwnCL63H5lJE7NCAziPvUymFGw==
X-Received: by 2002:a5e:c702:: with SMTP id f2mr2202406iop.133.1611900046813;
        Thu, 28 Jan 2021 22:00:46 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id y11sm3712149ilv.64.2021.01.28.22.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:00:46 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:00:38 -0800
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
Message-ID: <6013a4869b7df_2683c20839@john-XPS-13-9370.notmuch>
In-Reply-To: <161159456224.321749.17429593575682232016.stgit@firesoul>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159456224.321749.17429593575682232016.stgit@firesoul>
Subject: RE: [PATCH bpf-next V13 2/7] bpf: fix bpf_fib_lookup helper MTU check
 for SKB ctx
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> BPF end-user on Cilium slack-channel (Carlo Carraro) wants to use
> bpf_fib_lookup for doing MTU-check, but *prior* to extending packet size,
> by adjusting fib_params 'tot_len' with the packet length plus the expected
> encap size. (Just like the bpf_check_mtu helper supports). He discovered
> that for SKB ctx the param->tot_len was not used, instead skb->len was used
> (via MTU check in is_skb_forwardable() that checks against netdev MTU).
> 
> Fix this by using fib_params 'tot_len' for MTU check. If not provided (e.g.
> zero) then keep existing TC behaviour intact. Notice that 'tot_len' for MTU
> check is done like XDP code-path, which checks against FIB-dst MTU.
> 
> V13:
> - Only do ifindex lookup one time, calling dev_get_by_index_rcu().
> 
> V10:
> - Use same method as XDP for 'tot_len' MTU check
> 
> Fixes: 4c79579b44b1 ("bpf: Change bpf_fib_lookup to return lookup status")
> Reported-by: Carlo Carraro <colrack@gmail.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
