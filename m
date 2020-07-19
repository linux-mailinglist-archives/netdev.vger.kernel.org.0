Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AEC2252EA
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 19:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgGSRFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 13:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGSRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 13:05:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C3DC0619D4
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 10:05:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so7611739plr.8
        for <netdev@vger.kernel.org>; Sun, 19 Jul 2020 10:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rm+ZUNmz42i49+8HSleDh8syNULnEr9j572afF7Mzjs=;
        b=c1bkVNtufUQB0LzCaDll0bv4MjFg0PvcgSuzyEv+5TBypThJ9lum4OyWA680pIheuv
         UfITsozvyM+VMZHLcUzZJMOz/L7+eF0yd5iuo00A7UnHJuBYnmYcMVvIhHiILcYgiCxW
         mBKhOpL2TylDctbQhl8AWgy9irky3vMLVJjC9BGMgpPox1UNQRvq0Q35WyNbF/yTEc6S
         to0a3S+WgW9OwiwnEf5gn6yhUnToHyNpV6Er7CRfbwpO42faOCB2ZgWhhrvwrR+7V7lu
         QOkhZ2ofXtiK/Kf+pmnq973HQMj2djwoX0G7e3qsonDKYnjt97x6uww4IOLkqglCxHbg
         p5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rm+ZUNmz42i49+8HSleDh8syNULnEr9j572afF7Mzjs=;
        b=PCNYqXhTrGohvmwMj2fqKeQWou2hIHL/ABEqkSkbWSdFmBs8nxhg42L9FSN/dRFqMV
         7t0AOKP1aqy/+beE1wY/YA4LId1PIaTEv2vhQZBKzivzmtrMwYSycztCo1m7d/iBUD+f
         +TekYQdHo3wpGofJLO7sqZn8FsGj6BILc2YWGh5k90Vcri94UVL1eEi1HZ7uN4ahBo2O
         n47hmMBLG7NjgvrCYC4MnjBR62NXQyxsYMFAMFHVx0dVhc7YtFt4jimXoYunA6fJ5ZN6
         DjTHDRJNqN42tG5Jxhph0gIKdaJSTg06NKI0tcPUHWmkYzA3jtJMR9FPIbmpTgAotHXt
         K9mw==
X-Gm-Message-State: AOAM530L9KhB4DCL3Tn4K2WewrclZEe1CGt3nDutRc43CuYMBmm8YVIq
        YJtJDVqRtRXxPgVTCdQr4dXZTQ==
X-Google-Smtp-Source: ABdhPJwuULdEXFD36AtFRB/oIPgxUFVcjKoHqbzCbXhGMUrFfqwxUWb2GXc98khAIUzH9T8stRYhWQ==
X-Received: by 2002:a17:90a:2749:: with SMTP id o67mr19839181pje.183.1595178332191;
        Sun, 19 Jul 2020 10:05:32 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t20sm14300845pfc.158.2020.07.19.10.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2020 10:05:31 -0700 (PDT)
Date:   Sun, 19 Jul 2020 10:05:22 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Bixuan Cui <cuibixuan@huawei.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <jdmason@kudzu.us>,
        <christophe.jaillet@wanadoo.fr>, <john.wanghui@huawei.com>
Subject: Re: [PATCH] net: neterion: vxge: reduce stack usage in
 VXGE_COMPLETE_VPATH_TX
Message-ID: <20200719100522.220a6f5a@hermes.lan>
In-Reply-To: <20200716173247.78912-1-cuibixuan@huawei.com>
References: <20200716173247.78912-1-cuibixuan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 17:32:47 +0000
Bixuan Cui <cuibixuan@huawei.com> wrote:

> Fix the warning: [-Werror=-Wframe-larger-than=]
> 
> drivers/net/ethernet/neterion/vxge/vxge-main.c:
> In function'VXGE_COMPLETE_VPATH_TX.isra.37':
> drivers/net/ethernet/neterion/vxge/vxge-main.c:119:1:
> warning: the frame size of 1056 bytes is larger than 1024 bytes
> 
> Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>

Dropping the NR_SKB_COMPLETED to 16 won't have much impact
on performance, and shrink the size.

Doing 16 skb's at a time instead of 128 probably costs
less than one allocation. Especially since it is unlikely
that the device completed that many transmits at once.

