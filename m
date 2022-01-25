Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66DDB49ADDA
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 09:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376956AbiAYIPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 03:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448689AbiAYILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 03:11:09 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17FCC0A102C;
        Mon, 24 Jan 2022 22:44:54 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 9so6889914iou.2;
        Mon, 24 Jan 2022 22:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vVmvTKTsaxOlONO4QYlutZhtuDsocbdCqgwaw+TJzb4=;
        b=k3m12SknLZlwKx/vo2br6QSN5nsdltw57FXTxRspt8AyV/vXsNVmXsj2l+Vv7noQb4
         /wcZHwYRjIpRb3+8biyzNWGVa3z1VLT/32odwiJH5oEm1jROcwzw369C7S6/w57iOBkP
         Tt4EoV+fKiBGFEdaRwj3d415SUmGKl5lXls0IjorS0FPEx6RZwh6hh3q3pUyWfUf5aBe
         IvdPOevH1lbWLecH4Ouqo6rVTZzKVk5KMKA+8gJ8mJzE4JX/0NEaxfRCh7NNdUp/u5yW
         H2uZ6tCAy6iaDjLaeX95kf4UFdUIp6F2STAvzQzb++afxA8Dwg1kTJL396SLgVNx892R
         CQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vVmvTKTsaxOlONO4QYlutZhtuDsocbdCqgwaw+TJzb4=;
        b=5VX6sES/OU5xSymT4vD+0OqvCiUF23NU/aLQt0TQK8k9devFN4zSMupEk4HYb4eA4s
         3ANOcla46r3I1IHhT4XWNIEsVJixbUA+h2WT7uUT2kgU13NLNztn9Cc+QrR1UGegU259
         vf0HToyJfa8Ob9CajywZ0eRr9r/1bHBv3TyrqJAIye6+PaxON6pIRNCGW/WRYEmXGks2
         H9A7a9VvWROMN9mLbdb6wwioRMfpxxXPBmkgma+NtpsxyFAxiV35aOYz2VPFwFtoV3X6
         gvDZw4UanCwV8zPe+LMV/N0kEgZUwE8KJrA9DEyBpb1uWPtB7wDGeKU3dNRDiw7UR7Ss
         3JoQ==
X-Gm-Message-State: AOAM532ONfIX8QRUbL8QFKpK47UQyMBxkX6KruyAuJJuWhQALv3zJZhU
        e8lK7NMWIO9FniN/ZQcuRMI=
X-Google-Smtp-Source: ABdhPJzQ9IAlJ7cZFJwi5Eo7AwlA+zg7rkd9KQMgU92Fjhaoijao9sbiCdvy945D8wb/aU19iNTxvA==
X-Received: by 2002:a02:852e:: with SMTP id g43mr4676240jai.31.1643093094101;
        Mon, 24 Jan 2022 22:44:54 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id k1sm7497654iov.6.2022.01.24.22.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 22:44:53 -0800 (PST)
Date:   Mon, 24 Jan 2022 22:44:45 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org
Cc:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Message-ID: <61ef9c5d6056_274ca208a@john.notmuch>
In-Reply-To: <20220124151146.376446-2-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
 <20220124151146.376446-2-maximmi@nvidia.com>
Subject: RE: [PATCH bpf v2 1/4] bpf: Use ipv6_only_sock in
 bpf_tcp_gen_syncookie
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy wrote:
> Instead of querying the sk_ipv6only field directly, use the dedicated
> ipv6_only_sock helper.
> 
> Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---

Not really a fix, but LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
