Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0741341B598
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 20:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242142AbhI1SDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 14:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242141AbhI1SDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 14:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E2E761355;
        Tue, 28 Sep 2021 18:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632852127;
        bh=HY18neId2WaX6wpzfWt+dQQHizRoIxiibaY/CcI97RI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLHf5TVcem0C10GuB2V4tPD/0YlUgseuUAUkIuIjRCoII6sLthmkHHGARndxSjQRv
         pkao+pg6nUzFCcy1GP4PA0w24/kZYSuLcseISzEl7xon34gYE51TkqHdyNekP3UF21
         PrbQBwJxN1ERDzeV8id5ZmajDry2B28Gk0JpVEHRY0CxcHA0Jtq1aKFEAZhNuWPEXc
         a4QJBER9nydYY8SNcoJBQUe+p/7Fm8pbRh4DGRPtQQDm0AhLlqFmmVckOztnmYDy7S
         LW7n77sB4SN1eYvXsQU/JvPnICyX0ub3uD1VTe2dZKElXsF8AS1dQ6DZqNg00yjWYl
         vC45Sln3ocCaA==
Date:   Tue, 28 Sep 2021 23:31:57 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Luca Weiss <luca@z3ntu.xyz>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: combine nameservice into main module
Message-ID: <20210928180157.GE12183@thinkpad>
References: <20210928171156.6353-1-luca@z3ntu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928171156.6353-1-luca@z3ntu.xyz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 07:11:57PM +0200, Luca Weiss wrote:
> Previously with CONFIG_QRTR=m a separate ns.ko would be built which
> wasn't done on purpose and should be included in qrtr.ko.
> 

Yes, that's not intentional. Good catch!

> Rename qrtr.c to af_qrtr.c so we can build a qrtr.ko with both af_qrtr.c
> and ns.c.
> 
> Signed-off-by: Luca Weiss <luca@z3ntu.xyz>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

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
