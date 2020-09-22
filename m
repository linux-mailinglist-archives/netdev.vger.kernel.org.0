Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1418227399B
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 06:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgIVEIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 00:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbgIVEIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 00:08:34 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE15AC061755;
        Mon, 21 Sep 2020 21:08:34 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z19so11227844pfn.8;
        Mon, 21 Sep 2020 21:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K7AvY+HswYdAj30nYTTlfp9CaSnrfzdG1e4K3HI6LCM=;
        b=PkIsI9xJMJcxdysWWjncEFsvoO1IIyfYlPSOEji0QM/h3CBPA5UkEav6bbyfzk7XxU
         RCDW4IvBhCjAUqQN03V9Row1ZEoRf/jTURtSLvFtT3ShctBeuio7L3rc5LOKOdvD6XQf
         Uw1CPL+HHKVbvDvEGt0LEpQsGpvEm1EqEWrb/fYG1Rvv2hfZ7XhWtY8w0+HLTVxja+JJ
         K0fG+Gbydzde3h4jzi2e0OUT93PKSgzWXyFYi3+FtG+/Qnz4GaUqKyM9pirYWrVCk0MH
         PTzvJFrZJ87YJvBBnn1HOCP0nuuYscc7WJShJm9Jvub4aGE2bWzv7ETOncDtFHdBnfAI
         I97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K7AvY+HswYdAj30nYTTlfp9CaSnrfzdG1e4K3HI6LCM=;
        b=X0Fwc7T5sSyv20RIAu9K7TSF5j2VNyKa/6zK9GMroCf+Wc2PIPf34PYxsbvSlw1/c+
         1kADZqFvHBKDk22K++MSFMPlQVgrZDkf+S76iHKhdY4KMIEt2e7+J+iyH+vcb+IWCoqQ
         ThyM0/uIOPjgwcFY+/W9wDd8kIIIMUpLHY6krFrt9zDjZ+nKmKB3zcUotBRZfPf/S6M3
         1TafwJOgX5hnie+0MIfdwHXILFI56bbTeXrWNStNUdQJ4N5MgD5JXHeg7gUujmLLP8Jy
         AkJRstVQh1ncNfJn3R6tJtn1CoGsku6iZVZgYHeXA6IddAAyrfsjlCsl7zc0A30SplPD
         dh9Q==
X-Gm-Message-State: AOAM533kkcKWOFQpQ16qgutziUtKW27qPm8gd8UPXMM+EWuHzVub4Nxd
        CGTFyUdScP6uIOgcJqeF+k0=
X-Google-Smtp-Source: ABdhPJy1c32jkIMnLPCblvNT8MEab0kq0m5AfcoijkPG0AEIY0PIHR7yHkTrbtcnsJrXNky9WhG3MQ==
X-Received: by 2002:a63:1449:: with SMTP id 9mr2124720pgu.260.1600747714040;
        Mon, 21 Sep 2020 21:08:34 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b927])
        by smtp.gmail.com with ESMTPSA id s16sm12572924pgl.78.2020.09.21.21.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 21:08:33 -0700 (PDT)
Date:   Mon, 21 Sep 2020 21:08:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH bpf-next v3 3/5] bpf: add 'bpf_mptcp_sock' structure and
 helper
Message-ID: <20200922040830.3iis6xiavhvpfq3v@ast-mbp.dhcp.thefacebook.com>
References: <20200918121046.190240-1-nicolas.rybowski@tessares.net>
 <20200918121046.190240-3-nicolas.rybowski@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918121046.190240-3-nicolas.rybowski@tessares.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:10:42PM +0200, Nicolas Rybowski wrote:
> +
> +BPF_CALL_1(bpf_mptcp_sock, struct sock *, sk)
> +{
> +	if (sk_fullsock(sk) && sk->sk_protocol == IPPROTO_TCP && sk_is_mptcp(sk)) {
> +		struct mptcp_subflow_context *mptcp_sfc = mptcp_subflow_ctx(sk);

Could you add !sk check here as well?
See commit 8c33dadc3e0e ("bpf: Bpf_skc_to_* casting helpers require a NULL check on sk")
It's not strictly necessary yet, but see below.

Also this new helper is not exercised from C test. Only from asm.
Could you update patch 4 with such additional logic?

> +
> +		return (unsigned long)mptcp_sfc->conn;

I think we shouldn't extend the verifier with PTR_TO_MPTCP_SOCK and similar concept anymore.
This approach doesn't scale and we have better way to handle such field access with BTF.

> +	}
> +	return (unsigned long)NULL;
> +}
> +
> +const struct bpf_func_proto bpf_mptcp_sock_proto = {
> +	.func           = bpf_mptcp_sock,
> +	.gpl_only       = false,
> +	.ret_type       = RET_PTR_TO_MPTCP_SOCK_OR_NULL,

In this particular case you can do:
+	.ret_type       = RET_PTR_TO_BTF_ID_OR_NULL,

Then bpf_mptcp_sock_convert_ctx_access() will no longer be necessary
and bpf prog will be able to access all mptcp_sock fields right away.
Will that work for your use case?
