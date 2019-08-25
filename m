Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDCDA08B3
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 19:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfH1Rg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 13:36:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34984 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfH1Rg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 13:36:27 -0400
Received: by mail-pf1-f193.google.com with SMTP id d85so261722pfd.2
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 10:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m0Ol9KiCJuTthVJpNdqXavAOI9ULv3o3m1zh5s9b1As=;
        b=oFW8k5shx9dzTZCg4oYfKxxrESLsvpAIA5QCO3DOe5JfSNX5ICxHFKvHATbc9VgD3w
         5+rVewSkK5+kiL+7lS0d7oAaUMKOuRqjYZaH4CxrLhIbqdMKdMJyL9TmnRR+lSFDhS+9
         H/J3m1QfdE0eP7mou/vg7EAYza9c0CwIYY860=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m0Ol9KiCJuTthVJpNdqXavAOI9ULv3o3m1zh5s9b1As=;
        b=f7k0PO8sMoVYzm3Qhxoxewjs4UPCZjOSZWVrhpwN9+H8g2nRqUWUyRUr4DiNADnMwv
         rXf0mUjym9jtF6RUjmybwLJMzlhYEzKiwZ0fSyyxBd1xahLiLXgXo3EBtHjQw3H9kfvO
         QWI+g8lkhI/fPHAARLB8ZMRDLHbzXGjy9zWOS/Qj//1NqekYdlPpUlOf+G+dSa6uTMMz
         KQdJmGEJ+zlCiGhGzLSedrtjy/okVlxCYVRw8jrLe8c4EpqfjoSW7i36P7Q3luj6NENe
         4IgCFgYvbKGtKocWPZHquJlQsoDe8RdB33lJVK24AD4U40NsJmjOwXoD4l5xPOVKBCRA
         5Zag==
X-Gm-Message-State: APjAAAX6zCpqq2bVsBdqYU/LgjKmCW1pi5amMU//HkH9rLyXvSHMapfP
        mTE4+k9MOoMc4wBLFJ/AZbfYUA==
X-Google-Smtp-Source: APXvYqyH/WYT3nu0TOtBHExVMlqdFHVZ7R0fY91sEAf7okZikcnLyqTOEJjyRHLyXhLgGQXRNGz22Q==
X-Received: by 2002:a63:f13:: with SMTP id e19mr4496092pgl.132.1567013786692;
        Wed, 28 Aug 2019 10:36:26 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d11sm4397723pfh.59.2019.08.28.10.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 10:36:25 -0700 (PDT)
Date:   Sun, 25 Aug 2019 14:59:37 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Abdurachmanov <david.abdurachmanov@gmail.com>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Abdurachmanov <david.abdurachmanov@sifive.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Vincent Chen <vincentc@andestech.com>,
        Alan Kao <alankao@andestech.com>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, me@carlosedp.com
Subject: Re: [PATCH v2] riscv: add support for SECCOMP and SECCOMP_FILTER
Message-ID: <201908251451.73C6812E8@keescook>
References: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822205533.4877-1-david.abdurachmanov@sifive.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 01:55:22PM -0700, David Abdurachmanov wrote:
> This patch was extensively tested on Fedora/RISCV (applied by default on
> top of 5.2-rc7 kernel for <2 months). The patch was also tested with 5.3-rc
> on QEMU and SiFive Unleashed board.

Oops, I see the mention of QEMU here. Where's the best place to find
instructions on creating a qemu riscv image/environment?

> There is one failing kernel selftest: global.user_notification_signal

This test has been fragile (and is not arch-specific), so as long as
everything else is passing, I would call this patch ready to go. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
