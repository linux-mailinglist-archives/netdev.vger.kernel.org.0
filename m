Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C94551DE
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 01:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhKRA7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 19:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbhKRA7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 19:59:15 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A6AC061570;
        Wed, 17 Nov 2021 16:56:16 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 136so3816463pgc.0;
        Wed, 17 Nov 2021 16:56:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8D2EoFezMd3GTWFdDBCZbiurCMPRo1KyJLa15TK9Byo=;
        b=RbjRLOfVDGBdoY7zWUE6TdkffsS7DYP3K33hmYf+OC3fOP5zbXy/r+KGVkg8y501FK
         DInXykxRLrUB4ixBwL95nkLmTXw7KaWRits/UIsu6YtCk/C9FeQlWOzllLLOF2+QLF0b
         AAQqG0HqkTrObSGLmG8rVjv4+npv2150DbyRm4DdRtZPXOEZHGmVsBXuDwUhX0B5Lq07
         E4YPMBkHRQkytNTRUUwz96mJjkYtE2kMYtJCRCBWhvw9HXC19+GrvwwjncX1LjrLSGkX
         Sk5XAUDoqDXyFpqY1LBwwE3h0eLMFm1tHUje75fk1vp482OYe3pZC0ZhiBL0xrZuA94c
         MOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8D2EoFezMd3GTWFdDBCZbiurCMPRo1KyJLa15TK9Byo=;
        b=2Ltw+6I2m3FU00zgOQ3ScpICDDYfewn97YTrJEwbSoQfd3piWJJIjA00O17ANfxRKQ
         SRV+rmblvn6sILu/kTFwMdSwTyw7eO2eSqBwwdZIpfYQ+dipyMRLY9n5bD7J3HSBitcj
         XsvuSAgq4G1T4DRMhx2mpaQrCFm/dC6IRTfuw+fe2DMj+uDCKBql7gQ7Tk58Eo/0Dx7i
         XVQaenpHDoaTeng9xqhRLsXDqvGHAG6SeP0+38n5hP3XW/bXG5RbOYboB2JEfU2wjg3U
         1LxnHbY/+JfZgUTRXeum3eoRhXIA9F+4xYsV4pzzFEj7lvOTWThcfWR2Q2ZEcOzNrD1X
         57Iw==
X-Gm-Message-State: AOAM532+X1RkfN3XzNZ6eZnsSbdQjVoOagL0TosfzVOdCngiJuQAG5ju
        68CpCthomIRmFS6kfgElAlg=
X-Google-Smtp-Source: ABdhPJz7QPstrYe55jfGRBxbYgFm9OJvEy1hOMtX21l0BSLPBkW0ZVQfZ6Rr4OMMZu/oQFirdEyeNw==
X-Received: by 2002:a62:884c:0:b0:49f:9947:e5cd with SMTP id l73-20020a62884c000000b0049f9947e5cdmr11149344pfd.45.1637196975898;
        Wed, 17 Nov 2021 16:56:15 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:6d])
        by smtp.gmail.com with ESMTPSA id c20sm809202pfl.201.2021.11.17.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 16:56:15 -0800 (PST)
Date:   Wed, 17 Nov 2021 16:56:13 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH 2/2] bpf, doc: split general purpose eBPF documentation
 out of filter.rst
Message-ID: <20211118005613.g4sqaq2ucgykqk2m@ast-mbp>
References: <20211115130715.121395-1-hch@lst.de>
 <20211115130715.121395-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115130715.121395-3-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 02:07:15PM +0100, Christoph Hellwig wrote:
> filter.rst starts out documenting the classic BPF and then spills into
> introducing and documentating eBPF.  Split the eBPF documentation into
> three new files under Documentation/bpf/ and link to that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  Documentation/bpf/index.rst           |   30 +-
>  Documentation/bpf/instruction-set.rst |  491 ++++++++++++
>  Documentation/bpf/maps.rst            |   43 +
>  Documentation/bpf/verifier.rst        |  533 +++++++++++++
>  Documentation/networking/filter.rst   | 1059 +------------------------
...
> +.. Links:
> +.. _eBPF: ../bpf/instrution-set.rst

I think the split would be good in the long term, but please make the links
more obvious somehow in the filter.rst, since a bunch of posts on the web
link back to that file. The folks who will be reading the revamped filter.rst
would need a very obvious way to navigate to new pages.

In terms of followups and cleanup... please share what you have in mind.
