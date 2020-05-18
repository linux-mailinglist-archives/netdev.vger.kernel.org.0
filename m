Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8391D6FFE
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 06:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgEREyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 00:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726040AbgEREyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 00:54:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C8DC061A0C;
        Sun, 17 May 2020 21:54:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t7so3738638plr.0;
        Sun, 17 May 2020 21:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CNyAh3C19OfyBhM8UYQrB5bR+7wKmGoyo3pyav8YnVo=;
        b=BsCVTvxE0mGB5xc/3+LSNQW99Lq6bU0DvZnZ7VAbz3ttY2BP2Qjxecfp/BUfMEsCFV
         jZoOi2MgCyZConAzujtJZwKveV8yckPzTq7SCpQuKdCk58EAaLhE3rWvuu4VJt5PlpiH
         NkdeL6e6F8UpgW0FdQrDQja+1QMUl78qTTyhIUCJaLO6hlW6qU6MAl/r7jUCiBM1RYzT
         c7TRlKmCbZlO8x4vPJ/P1O5M9nGZPljHjKZ8h9JvjF/LZPnTxNUu/Tn6QbN/cGtlIIGx
         xqo1TzA+VmnV50mgLBTcvy2JljOeGq1D6CXH3W6DjOgNviBKCjIYEugK62csu1ZOJYIr
         pc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CNyAh3C19OfyBhM8UYQrB5bR+7wKmGoyo3pyav8YnVo=;
        b=aV7NCSvHs3dKTNKjE26WhUH9z3S1C3BbhMoTmW8MPrmlrGBB7Zo+Y01vupKzLTrgyT
         vmC2sxfWUX3xPHeS2PhuePYd3m2FebqbrtvtkZ3Zd3l3ppVJbPB7iNxd6SyQmO+R4/OU
         ic8Kc/KkSKgV243Uj4paIUym7K/hCe2Jkc4SI2BFuAxM6kGAA86zWkw3zL4SojO99Vih
         DDsvOyj5JkLHcL4oInqg6xm8e7wdavb6aruLfR3sAkMtaf4o61gXjS6+46b2tkECy96T
         MW8Xnm+9QHOaw0dzWR6AWmYgW1mzcwb7QFt94TvlLXyBnWWlmvUYkO8z2grP6548BTL5
         wuWw==
X-Gm-Message-State: AOAM532DMxyID1219SO8n5Ni78XSy6ZtF8PxWuGixB93a4vz9MpQN4X9
        Fb/ePin5ptcSc+6JGKARHBfnkZbeOiGYag==
X-Google-Smtp-Source: ABdhPJzqwUM4FYI2rhy+2ZBNtNxAHPmwoAipKaMxVpRm7Z/NIRE2PgJIIrTSk05knuGDBQfGA/9Www==
X-Received: by 2002:a17:90a:ce18:: with SMTP id f24mr3604918pju.198.1589777652680;
        Sun, 17 May 2020 21:54:12 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id q3sm1549124pgp.69.2020.05.17.21.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 21:54:11 -0700 (PDT)
Date:   Mon, 18 May 2020 13:54:07 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Xiangyang Zhang <xyz.sun.ok@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: qlge: unmap dma when lock failed
Message-ID: <20200518045407.GA73179@f3>
References: <20200517054638.10764-1-xyz.sun.ok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517054638.10764-1-xyz.sun.ok@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-17 13:46 +0800, Xiangyang Zhang wrote:
> DMA not unmapped when lock failed, this patch fixed it.
> 

Fixes: 4322c5bee85e ("qlge: Expand coverage of hw lock for config register.")

> Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
