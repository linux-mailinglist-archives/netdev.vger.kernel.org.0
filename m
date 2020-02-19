Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0469B163CFB
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgBSGWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:22:36 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:34405 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgBSGWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 01:22:36 -0500
Received: by mail-pf1-f172.google.com with SMTP id i6so11989051pfc.1;
        Tue, 18 Feb 2020 22:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=TrbhfVCFo4eiZs7If2SmBui5/PR2q3ebKEJnN022wQk=;
        b=Ck7p+Cp63kEC0mH8JMEpp/3ktzgQvCv8GgMq69rpcBQWlF2k5S1cauptZw4Ps5l80+
         wcewweUSRnD1nElLwA5Fl4a4GuW1fwVKOcNKrDSVstULNiG62Zh9v5C1fccbup3H6fXZ
         9c5DkgAtpF4xoxsvdXrUSi7AGgAY0Zz4MhuzEyLDD71F4hQKKZECX/R3nphUoT4HpF8x
         VS8b82sV+mn9kzIOHZfKeiviaSd3ENnttCwcPH0+EMLl38pzWr00sVOCKODdtt3g8euh
         Zp7HXzL6lGcB5yzFsFl27mBVM5uWgglOHOFqVA7l7OTy2HcHpvYem9RyY3z1U28D8ygr
         B83w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=TrbhfVCFo4eiZs7If2SmBui5/PR2q3ebKEJnN022wQk=;
        b=jxCB+RqwLFLdGCGOyVD1Th9LDXcsmhZfI7yIl5A7qjY10HsqCrec3xzQp2QpKeI/xU
         psulzfFW99blF28sjIgSH2MBvYbSKy8H1cnIMDNMehQY6ZGP1qhRJiYbmVxfp+MBO452
         o0ixclfWxt+itsOkU/3WgmAN9JTpkSPK2algMRlRFNzSBCsacVFfs13tKmJy1FuSbLVJ
         /BjF7U4hfZzgpMVaTVavKU+tGa3sj2/Esw2L/ckv0VQiUQm8JDnuPMv70JDEQoP+YyMX
         ifR8gX865dY/Ro3UQ/e6tHtYqZAy9pcviwa9pPCKaGEvCrE62pi9uoDVhsYNK4tJWuw5
         4Cqw==
X-Gm-Message-State: APjAAAWv+zhUjLLgzd6bGWJdgu9my9J9CZ6EoHYaQarKT4OfSpws+ekH
        cYKr34wnyYhhKARgALvYzxVsMZPK
X-Google-Smtp-Source: APXvYqyfseWkYtYKa7ymoBY1modzGcMfSN8zMB8uPz5E0KV8XVGMzMASbR2b6VDNkiNk60UsBbGbAA==
X-Received: by 2002:a63:ed49:: with SMTP id m9mr26086578pgk.304.1582093355385;
        Tue, 18 Feb 2020 22:22:35 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y197sm1201574pfc.79.2020.02.18.22.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 22:22:34 -0800 (PST)
Date:   Tue, 18 Feb 2020 22:22:26 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e4cd422daa81_404b2ac01efba5b4c8@john-XPS-13-9370.notmuch>
In-Reply-To: <20200217121530.754315-4-jakub@cloudflare.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
 <20200217121530.754315-4-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 3/3] selftests/bpf: Test unhashing kTLS socket
 after removing from map
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> When a TCP socket gets inserted into a sockmap, its sk_prot callbacks get
> replaced with tcp_bpf callbacks built from regular tcp callbacks. If TLS
> gets enabled on the same socket, sk_prot callbacks get replaced once again,
> this time with kTLS callbacks built from tcp_bpf callbacks.
> 
> Now, we allow removing a socket from a sockmap that has kTLS enabled. After
> removal, socket remains with kTLS configured. This is where things things
> get tricky.
> 
> Since the socket has a set of sk_prot callbacks that are a mix of kTLS and
> tcp_bpf callbacks, we need to restore just the tcp_bpf callbacks to the
> original ones. At the moment, it comes down to the the unhash operation.
> 
> We had a regression recently because tcp_bpf callbacks were not cleared in
> this particular scenario of removing a kTLS socket from a sockmap. It got
> fixed in commit 4da6a196f93b ("bpf: Sockmap/tls, during free we may call
> tcp_bpf_unhash() in loop").
> 
> Add a test that triggers the regression so that we don't reintroduce it in
> the future.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../selftests/bpf/prog_tests/sockmap_ktls.c   | 123 ++++++++++++++++++
>  1 file changed, 123 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
> 

I'll push the patches I have on my stack to run some more of the
sockmap tests with ktls this week as well to get our coverage up.

Acked-by: John Fastabend <john.fastabend@gmail.com>
