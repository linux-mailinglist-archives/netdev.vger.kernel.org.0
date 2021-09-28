Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4111441B518
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 19:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242062AbhI1R0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 13:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242055AbhI1R0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 13:26:10 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE43C061745
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 10:24:30 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id d12-20020a05683025cc00b0054d8486c6b8so7848618otu.0
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 10:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tz7rXxaL4F/0f9c2pv27juc+BGdU7ScDq2tqCmIv38Y=;
        b=tR2pRCj/qKxjNExZrPW1JMusgHTkF217aDaxwmJWEm2fFtDA/r7cVLoE6t7EzHMG+j
         4cnF8eefX32CXwbIWS6Fb2aNitjEQgYmhl/kiZWdzTtTEgr5BzM5bDrNr0xGoQcnHfo4
         ukAyh1JNMGUrNsZ4ZRwG+Cz3NZM+zUpCggoPt4Asg9JC7DVN8QeAGxfMPgjNvvfvWI+o
         VTDg52u12ACCsADmcqS7lLTm4+uCVoHSAG1DP1EAuiZkXe6vAFC8vMFuc33DT81Th2U9
         zWszlzIR4HpkbUqmWejkpNV+2ZUU010wD19zv6P/NL6yj08YpU3BBQ76/wRQfklSWNK4
         xWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tz7rXxaL4F/0f9c2pv27juc+BGdU7ScDq2tqCmIv38Y=;
        b=5c5ZwccZQP4/c+VmHMOFecNpMLucXzDj5X3r+9iXqFV59bCd1nejtVd+5Id+0RmuEu
         iDIb6/ATLE5S+TnlJkfTlwzYRA8a8ZbiMATP8D2Lszeawjbuc5stqgaIsJDMFZmJ+RKg
         j08o29VF9BpdmH9aulxdkROKZU/U1QOCqrfcC6oFpApoYAosCqZ5cQZjMCg9PxJYXebN
         BQRP4KvmE1pGzhhSM3RsGQhRYC6TgcJH1rG0nFu6Drv5gwNEKTuyDn2jGSc8fCHAb/bw
         GPkRNdOYGkh/ItenUJeahCjY4VauGSZoj6RNXK2Q0ojtt5vTljg6/HZ1dJTh5AWLjVX5
         Hg9Q==
X-Gm-Message-State: AOAM530ib4AnLLKPpIAODfCZAGcmCTSLxBJU70Q0yJaPCNZBZ6xHZW29
        rUTEAXmb5Lt8o+QBLQYmsF6W4w==
X-Google-Smtp-Source: ABdhPJwIoTF2vk7NvGDYXmuN/1D5SS3NUp6rSCUQCZ5HX/Jvkr7HMFjXoFn7PWmdaYmAJBezNd8FNg==
X-Received: by 2002:a05:6830:1d43:: with SMTP id p3mr5968746oth.80.1632849869862;
        Tue, 28 Sep 2021 10:24:29 -0700 (PDT)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id z1sm5225337ooj.25.2021.09.28.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 10:24:29 -0700 (PDT)
Date:   Tue, 28 Sep 2021 12:24:27 -0500
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: combine nameservice into main module
Message-ID: <YVNPy+IAtLiKI19Q@builder.lan>
References: <20210928171156.6353-1-luca@z3ntu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928171156.6353-1-luca@z3ntu.xyz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 28 Sep 12:11 CDT 2021, Luca Weiss wrote:

> Previously with CONFIG_QRTR=m a separate ns.ko would be built which
> wasn't done on purpose and should be included in qrtr.ko.
> 
> Rename qrtr.c to af_qrtr.c so we can build a qrtr.ko with both af_qrtr.c
> and ns.c.
> 

Nice, I don't think we ever intended to end up with "ns.ko" on its own.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
> ---
>  net/qrtr/Makefile              | 3 ++-
>  net/qrtr/{qrtr.c => af_qrtr.c} | 0
>  2 files changed, 2 insertions(+), 1 deletion(-)
>  rename net/qrtr/{qrtr.c => af_qrtr.c} (100%)
> 
> diff --git a/net/qrtr/Makefile b/net/qrtr/Makefile
> index 1b1411d158a7..8e0605f88a73 100644
> --- a/net/qrtr/Makefile
> +++ b/net/qrtr/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_QRTR) := qrtr.o ns.o
> +obj-$(CONFIG_QRTR) += qrtr.o
> +qrtr-y	:= af_qrtr.o ns.o
>  
>  obj-$(CONFIG_QRTR_SMD) += qrtr-smd.o
>  qrtr-smd-y	:= smd.o
> diff --git a/net/qrtr/qrtr.c b/net/qrtr/af_qrtr.c
> similarity index 100%
> rename from net/qrtr/qrtr.c
> rename to net/qrtr/af_qrtr.c
> -- 
> 2.33.0
> 
