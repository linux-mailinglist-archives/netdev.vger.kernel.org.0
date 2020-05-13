Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 937CF1D1D8D
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390209AbgEMSdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390161AbgEMSdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:33:38 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFCFC061A0E
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:33:37 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s1so253500qkf.9
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5jEkS3UxUe87Y2wPxSvrFJMB7/PKitD0h6FasR/crgk=;
        b=HH0GkxApMQGELo6KtSTRbFv7cQcZajCPqwspvoC0S8TYB1txiLy4oOqflUlKZ7Aq3r
         +dzuBpK2HRe2V7Rlq6m5I86eH6nHGlbjXWPeeDPMnYKCIbaI0IP+ivHdHXiKQTXaPDtq
         OhI3Luk4W/aA7lERgvt7ZLXsmdVb1s2oUN4XkX+kZYhPKcgmZkgYgKmcovIrihRpEmsM
         tmqg1rGRNPrKlRKXVo+13XL+M+Vse+S+10CRWmc/TpfbN6m4AHwUybkDa4LUpU6MTCMI
         iuc12u6Iqnel2wE2KATyf5AHvoUuJz6fCdE0IoqLVjVz6OhbdN/rFYRtCQlmRo+3PD+P
         PRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5jEkS3UxUe87Y2wPxSvrFJMB7/PKitD0h6FasR/crgk=;
        b=pzmiqcGs4Y9A9NSQjo9qESgBVogs2TkjYfOoTcSKXEbkYXzDV3xbFMF1ZrMwX7RJDo
         4DVkcOO8naIWTye6Hc8gUCZNQQn371nbeYUDs8zrPeySrj4+z1xh6w6FXbSgKoSGdiOQ
         1NwHRCnjxfmD5Co2vRFPA6ktL7TnmVbSpc4Hl+dIzVrjSXNZ5f1qN9eChYjPzi+XuFLQ
         mQtFfNdJgdC3dl2iLSiAIeGR90wWU+M6QClh4iEguGwDRJ+ACCgMcnzK/wLU1JTrBdt3
         vd+noIBKeYywqsOuqn/FXdnbGe8CSkZekBYxyUyn1U9gHn7uZlTleJpyom04R5MkAVeJ
         JQeA==
X-Gm-Message-State: AOAM532pGtKGAdLQpu2ZO1O8RL6cYFFb1O77s+20EvxVF31FwJaW9/iu
        7DxKCmRgihl8TVchelMDGpBdiNJXWaU=
X-Google-Smtp-Source: ABdhPJw6juESvgQep2ACpKOKus6xZq/riLpiN+8lyk4Csl23ckkBDaZAL15eGckpYuMEzMVkJb4MVQ==
X-Received: by 2002:a05:620a:1512:: with SMTP id i18mr1067317qkk.81.1589394817041;
        Wed, 13 May 2020 11:33:37 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id t126sm542970qkc.79.2020.05.13.11.33.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 May 2020 11:33:36 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jYwCF-0007c3-T7; Wed, 13 May 2020 15:33:35 -0300
Date:   Wed, 13 May 2020 15:33:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/mlx4: Replace zero-length array with flexible-array
Message-ID: <20200513183335.GB29202@ziepe.ca>
References: <20200507185921.GA15146@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507185921.GA15146@embeddedor>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 01:59:21PM -0500, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> sizeof(flexible-array-member) triggers a warning because flexible array
> members have incomplete type[1]. There are some instances of code in
> which the sizeof operator is being incorrectly/erroneously applied to
> zero-length arrays and the result is zero. Such instances may be hiding
> some bugs. So, this work (flexible-array member conversions) will also
> help to get completely rid of those sorts of issues.
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  include/linux/mlx4/qp.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
