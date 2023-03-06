Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85D96AC8B3
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCFQuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjCFQuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:50:00 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE6F41094;
        Mon,  6 Mar 2023 08:49:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id i5so11096531pla.2;
        Mon, 06 Mar 2023 08:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678121270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODdiL2GGQjRs6UwWBSlS8tiPxUSq4W658M+jg5aLzG0=;
        b=od03gzqIR/mda4Ivh4c35xj4H8MJ3LtwWgh4nUKI98xxP9dDaugu6XB1/14yx4aeRi
         ZeZ6kdymbthL1vwtKA7xTUPy4bnFBzSrAVRh+ucBnG89jkMPnLmwekrzp6L8f+WoALgS
         5hiTxyAlc9r+80xcAzGXtOA2c6ewkFcX7NC0GLfjuFwXnZJaLevNcg+UPu6a1Kfz/vzK
         +thb1EElRdooU8NyHFpiNl30EVOfbLU9G3bMVhSpnMfJ4cqFGtyRXssoTdyyF8XJg2bD
         vkpTEWevMdRsoan+Iv9RJVHGZBXPVFGQqmae6lAkgeOESL9ODCPENasuzLAzorYNqeXq
         GxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678121270;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODdiL2GGQjRs6UwWBSlS8tiPxUSq4W658M+jg5aLzG0=;
        b=U5mIh/v7JF4bTMNSxGpOf/uWJ9YSSUswYH4NTBVjlPFoLCDI5t72yDKS0zKHPSS//Q
         Oo/+bhXF1vaFjBUKKvKyMreUiXpAFadJ9FlVKBvBkvxuXklfcSX1Sy7XA5X6BTR9KUAT
         tM+LROjGhH/lU9yuGNP/vMLmZ/zDyNel/SJ5+M3aNhJVliu7DRJ0t2vycviw6YN96xN7
         Hd5lrbtoLmhTZNIsAX5Ry/mtMiE/LbmTnBDhN/IhkF0tzfGCQxe4KSE4WmkKvL64qBRA
         r9RZFcrCmqskW7hXuZeKK+0znvVCCFpuKHYPuH/BkrCha855+jAJceGlbCKp2LhKVblA
         OT6w==
X-Gm-Message-State: AO0yUKUujpFpWGynZyugRHgD0gMhu0PY2pSWlBV9QMkUKvHl6Hm1T1Py
        vHLta8UUVeni1lvg5rceqnrRBLWBQT4=
X-Google-Smtp-Source: AK7set/QPoZiDC4TbcumqnuEDD22DJBGZsx/R7WR0KaLLby38WnIdWFktBpxENYvtSNYNfABEju4hA==
X-Received: by 2002:a05:6830:3485:b0:68b:d9d3:d8f with SMTP id c5-20020a056830348500b0068bd9d30d8fmr6085883otu.3.1678120746784;
        Mon, 06 Mar 2023 08:39:06 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id w6-20020a056830144600b00693c9f984b4sm4234153otp.70.2023.03.06.08.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 08:39:06 -0800 (PST)
Date:   Mon, 6 Mar 2023 08:39:03 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Vernon Yang <vernon2gm@gmail.com>
Cc:     torvalds@linux-foundation.org, tytso@mit.edu, Jason@zx2c4.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
        james.smart@broadcom.com, dick.kennedy@broadcom.com,
        linux-kernel@vger.kernel.org, wireguard@lists.zx2c4.com,
        netdev@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/5] cpumask: fix comment of cpumask_xxx
Message-ID: <ZAYXJ2E+JHcp2kD/@yury-laptop>
References: <20230306160651.2016767-1-vernon2gm@gmail.com>
 <20230306160651.2016767-6-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306160651.2016767-6-vernon2gm@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:06:51AM +0800, Vernon Yang wrote:
> After commit 596ff4a09b89 ("cpumask: re-introduce constant-sized cpumask
> optimizations"), the cpumask size is divided into three different case,
> so fix comment of cpumask_xxx correctly.
> 
> Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
> ---
>  include/linux/cpumask.h | 46 ++++++++++++++++++++---------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 8fbe76607965..248bdb1c50dc 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -155,7 +155,7 @@ static __always_inline unsigned int cpumask_check(unsigned int cpu)
>   * cpumask_first - get the first cpu in a cpumask
>   * @srcp: the cpumask pointer
>   *
> - * Returns >= nr_cpu_ids if no cpus set.
> + * Returns >= small_cpumask_bits if no cpus set.

There's no such thing like small_cpumask_bits. Here and everywhere,
nr_cpu_ids must be used.

Actually, before 596ff4a09b89 nr_cpumask_bits was deprecated, and it
must be like that for all users even now.

nr_cpumask_bits must be considered as internal cpumask parameter and
never referenced outside of cpumask code.

Thansk,
Yury
