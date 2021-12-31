Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D16482382
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhLaKoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhLaKn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:43:59 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E2CC061574;
        Fri, 31 Dec 2021 02:43:59 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so14595315wmb.0;
        Fri, 31 Dec 2021 02:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bLUkTU6YF+8VLXQUQIWE9F/hQfPP+FolDFiTd3ZDtrs=;
        b=bmY1kbjIlV/sLw6YhqPG6UsoOX4iiCGCWwkkibgh5ixxQ8zdbpjVi0HUXeLfI9ELdE
         rGqCLvHCBDW+/qRxI1fur/cYvuGt7PU0tnaIw4dhjS+2KQ5ST5/V3bWySd8d1ZD6V/2b
         egZamqr04QzT8IhF2ZTU0idJTQSJHxetevaG04biYD4Su1cy+vYsJp4YWpSNkAvfvsXl
         WTYox+UlLJHQXCiyKl3bqRboxKW3PqBF7EEZGA3vTCIgF+xwMzBL9I8gX41UA40DV33s
         xZ4U7hvU6vmu7Qwm1ka5Xq2mp6K32Kmarc4UXIkOadVRR0TdjyHelHw0qtbnzli5tNlt
         p0AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bLUkTU6YF+8VLXQUQIWE9F/hQfPP+FolDFiTd3ZDtrs=;
        b=K6qZurkjqNtVF2zJhqn2EoOIAcwkFMiqOaY1uuJ7UAU+Dpcl5me1i8u8+7eY3ATw9D
         trzCjPib/w9UpizPjceI+6d5Y0s5cth7NIg+Y2xixGIDC24adGMfXNJBAse0ogz7WIvp
         Hrjkr97xfcDWEqF/LnL+xNunJKf5K6LFEf+EeHURZSHu5ATIACzwGj7jw0uC7Ln6cbIZ
         xry01eyakAvgCslffr2nXpvyZn+tqPBouIjfOJgNbOK35MpXnNYnOacZz20HQ/rstxwb
         uj0/bNhrKPBkqvWyS6oAExRj0FOA3oB3iC7Eu8ht5MXLbWUsrtLRrnWOCEavnwlP9uSl
         BJ7w==
X-Gm-Message-State: AOAM531y8Jm1IeY7mzSy2RqD2baSqY32TOR6iATFFflxKi/Ryc2MK4uS
        owC9DQ/jTc3i8QNdbxjZJYQDO5/k0qs=
X-Google-Smtp-Source: ABdhPJwaB4oZMlIVWbJDarcy1yJ7NaobnlWBgzU0JfLp+wnpSa6WOB8j7cUNARKMaRDf+3/cuWS3cg==
X-Received: by 2002:a05:600c:1991:: with SMTP id t17mr29701332wmq.21.1640947437988;
        Fri, 31 Dec 2021 02:43:57 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b1sm29584285wrd.92.2021.12.31.02.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Dec 2021 02:43:57 -0800 (PST)
Date:   Fri, 31 Dec 2021 11:43:53 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <Yc7e6V9/oioEpx8c@Red>
References: <20211228164817.1297c1c9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Wed, Dec 29, 2021 at 09:43:51AM +0800, conleylee@foxmail.com a écrit :
> From: Conley Lee <conleylee@foxmail.com>
> 
> Thanks for your review. Here is the new version for this patch.
> 
> This patch adds support for the emac rx dma present on sun4i. The emac
> is able to move packets from rx fifo to RAM by using dma.
> 
> Change since v4.
>   - rename sbk field to skb
>   - rename alloc_emac_dma_req to emac_alloc_dma_req
>   - using kzalloc(..., GPF_ATOMIC) in interrupt context to avoid
>     sleeping
>   - retry by using emac_inblk_32bit when emac_dma_inblk_32bit fails
>   - fix some code style issues 
> 
> Change since v5.
>   - fix some code style issue
> 

Hello

I just tested this on a sun4i-a10-olinuxino-lime

I got:
[    2.922812] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): get io resource from device: 0x1c0b000, size = 4096
[    2.934512] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): failed to request dma channel. dma is disabled
[    2.945740] sun4i-emac 1c0b000.ethernet (unnamed net_device) (uninitialized): configure dma failed. disable dma.
[    2.957887] sun4i-emac 1c0b000.ethernet: eth0: at (ptrval), IRQ 19 MAC: 02:49:09:40:ab:3d

On which board did you test it and how ?

Regards
