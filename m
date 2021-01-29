Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F063A30861A
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232062AbhA2GzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbhA2GzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:55:09 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38490C061574;
        Thu, 28 Jan 2021 22:54:29 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id z22so8233734ioh.9;
        Thu, 28 Jan 2021 22:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=w1qFvHGQrgqVJ85D0sHlcLhT5Dm3LE2q2Y+BTD7Vsv4=;
        b=BQGARVbE3npzSq7MtlSHqM9zDHDZQcF48nYtTfdcGte4dIa3tpUr/wpvmz0RzKD8Hy
         s0JzAeRY1tDVJzuyilq2Sf68hPvIYhtHcQKibinBJz0N8+e/SxiZ/B6F2ZVUYhzsAOHJ
         IT+wFJR8xtbuSSnGTsKLZBffpVN76aNLc8olCNHgzOWIZb9XiHT4SnueiVT4AZWhy5Ve
         adsWj6Rm8Nhav4ZPttqhvBO8dUG6i5G+p9c0hr96tAemwylkq/QqRYROPoc7ZjI+fGDx
         +o0IHIyEqNZ2rXjTGuLsHtU2gnZsDWgTxQ2SdpmnXXG8PDpfJP953e4N2xSHFwzSJSaw
         BzGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=w1qFvHGQrgqVJ85D0sHlcLhT5Dm3LE2q2Y+BTD7Vsv4=;
        b=VyAOf/WVwHY0roQShKJb91EyGiVEfiLykxWE8pF+e9i30LEiH5W7QWcDH7vsilh45H
         Y1lGtgoGo0pQj/3qZKRHL6XbiJGJOdHFVYNEaUMQro0Kcl1Fp63EvCK4XdHrnZJKXRSD
         2j8eRzQisYuLHZAJC3cUmy7Nzktgf7mJ2YXnsk2coXkUYBwCpWEqDzOO9ko+/SGfWrEi
         joGZP2Gb/dmhvvmyPifUJ+88G9sfxH+fBd4d0r5SrnOw48bsNryYIzNc4K96Kxyi/SCm
         yR2EeMmW+jgWnxlrZ5oP6kOMNRfEQfow0wvbxh+Saz1i8rkgSSTSnTnhZ+ng8xecWuus
         7X+w==
X-Gm-Message-State: AOAM530gUYdmozWkvx4d82PSVTYBNKdYuGYRFvR3gPE+GkA3JPO76tgu
        2LYjuoRPCRxKZjsbzXb/Wbg=
X-Google-Smtp-Source: ABdhPJwurA+QY6mnuFYRtTw6wlAfQDi/XHlyeQiJeSeKdDb/YsinkXj/2S+jTIjk4TL2bk6shmBjKg==
X-Received: by 2002:a5d:89c3:: with SMTP id a3mr2858844iot.85.1611903268800;
        Thu, 28 Jan 2021 22:54:28 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id z16sm4003281ilp.67.2021.01.28.22.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 22:54:28 -0800 (PST)
Date:   Thu, 28 Jan 2021 22:54:21 -0800
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
Message-ID: <6013b11d98ad2_2683c20876@john-XPS-13-9370.notmuch>
In-Reply-To: <161159457746.321749.16725918278187413283.stgit@firesoul>
References: <161159451743.321749.17528005626909164523.stgit@firesoul>
 <161159457746.321749.16725918278187413283.stgit@firesoul>
Subject: RE: [PATCH bpf-next V13 5/7] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer wrote:
> The use-case for dropping the MTU check when TC-BPF does redirect to
> ingress, is described by Eyal Birger in email[0]. The summary is the
> ability to increase packet size (e.g. with IPv6 headers for NAT64) and
> ingress redirect packet and let normal netstack fragment packet as needed.
> 
> [0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/
> 
> V9:
>  - Make net_device "up" (IFF_UP) check explicit in skb_do_redirect
> 
> V4:
>  - Keep net_device "up" (IFF_UP) check.
>  - Adjustment to handle bpf_redirect_peer() helper
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
