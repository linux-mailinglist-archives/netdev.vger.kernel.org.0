Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDF01E8DDB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgE3Ejw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3Ejv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 00:39:51 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB8FC08C5C9
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 21:39:51 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id y17so4561885ilg.0
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 21:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bvMtkmF/mPSIbSvP2qW/Rn0Y66DxDpELreZUZ7hA1BM=;
        b=iU4zDzdZXKt3ZlsZ+U/0qZ23tLEDo3K8UODuCSEI+iqljrKi9Z4dLiYMuRJ3L4Bm1J
         pURm/Y0bnnVc3PFw4f3J50ZESvqjcXiWfBZFBRFbNe9aWW63HLo2vSSL33sZ2Uk3KKUP
         pXmYC0VCYqo/LDpRSKoAeJRXqv3my6c9kOFFLUWcqzfkHtV/9W+DxtWPejzfL3nz2eLC
         cL6L9/c8anYkJ7feCPpbQonpGgSbVBSKnOEtWq7jD8UyM9BdMNftvBvoaikNEe0GarVH
         v5BdhPhq5+unEL8pO8NcCR09MVFciu2k07KrhRhpNGQb+IIiHPhby9D45g3vaYC8kntT
         R9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bvMtkmF/mPSIbSvP2qW/Rn0Y66DxDpELreZUZ7hA1BM=;
        b=g3OIPCKTWaV2s7e/YYn2YCnDY0Fq7mB2nnK5xclIjuZt6Ce77sCaT5XKRBhUPMvcjn
         7+dCbAVDiJ69/dAbqIcY+ByjDUIcoKaHCmOnuypk87cEiJPXDw1wjPsm+B5X8qWCfJ94
         CiryauGLw7gXQElyGN0GuftWdHtWXIspkKepo/Gc2rWd1YQDLKte8yrTRhvb5iGv72+h
         c02tRC7wi39kIynL9Zw4SgeOM1je119z65Z7NNDFoMLOJ3p4mab9f3r2+GjndtEmGhGZ
         c3NVrJfytUoqsq6miDy7/p2y0ZGFMV/nVEToUKg0RHTLaIhhTyQ1cAmx0t2OlTjV1dTc
         MdyA==
X-Gm-Message-State: AOAM531iY70wto+HnILptVXGZmRDSoq4a8EelEZFxMOzVNFZ11Hj0bUa
        LQt4WxNH4088XZxcNznE6JLoaKSmuUlocyS/85Q=
X-Google-Smtp-Source: ABdhPJzfcqbVkuvQpSfLIQSGDei12PG/pv4hbV2LsbfwFwU2s7U9ilwwDnTOHMvsa1u0p9alF1hdnTd792WqPuBLqWI=
X-Received: by 2002:a92:cb05:: with SMTP id s5mr10383311ilo.238.1590813590727;
 Fri, 29 May 2020 21:39:50 -0700 (PDT)
MIME-Version: 1.0
References: <1590809673-105923-1-git-send-email-yangyingliang@huawei.com>
In-Reply-To: <1590809673-105923-1-git-send-email-yangyingliang@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 29 May 2020 21:39:39 -0700
Message-ID: <CAM_iQpWG7kH7EDC4t5nnPhunTqHiaKycRhv+qxzsmTdvOin8Cw@mail.gmail.com>
Subject: Re: [PATCH net] devinet: fix memleak in inetdev_init()
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 8:11 PM Yang Yingliang <yangyingliang@huawei.com> wrote:
>
> When devinet_sysctl_register() failed, the memory allocated
> in neigh_parms_alloc() should be freed.
>
> Fixes: 20e61da7ffcf ("ipv4: fail early when creating netdev named all or default")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
