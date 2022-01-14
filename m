Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A19C48E4B8
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 08:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbiANHMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 02:12:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236651AbiANHMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 02:12:31 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33846C061574;
        Thu, 13 Jan 2022 23:12:31 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v123so5403141wme.2;
        Thu, 13 Jan 2022 23:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WvwkzxK8j3CRir1iwMyK3hew1DzSIzTqLWxWq027HNg=;
        b=k4BlAb+qMsYgW6YuuFj6yHaB3GQ72yQZrhc6WzYrHZjzH6c6rAnjvloHmS8Drt41Bk
         AwVld1flsnVLuMiibcDwEhCWR39x2MavRC4B1czU38n9PJO3nCC2grx3CB4X3K6RLMDB
         fFzjALVytrcZxpx+0cVJINml0saXxSOjuJxsgnzHj70+PGC/r1JQTmuevDki+YM+LxCM
         b0n3YfsIEaYdhTsjti2Jr8aOpLUE0AYXZD4+guxYjy71PzrpxpfiElA03iOonESMpCcs
         qwGqO0QmuTXl7i4fe6LApMdYdV1bcffyR5f3RxfcBds+iZrrKzSY/2OO6i+TWmu+zys4
         /ApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WvwkzxK8j3CRir1iwMyK3hew1DzSIzTqLWxWq027HNg=;
        b=NjokksSds02tGNzVYwhouTq20y+P97HpZfJ+frJb2+M9XBzGJ6CcFweJ0ePDyWiTpP
         JC5AjiHVjOQ21q6pEcDngYbnAzEeJXrA2RUDdwNnX2/tBYMsrZhVnXI8vXjmrpg5MNYu
         i2G7+QJ+6bqtMT00Vwew445/UDp6Vxrm6xBEcTRablobniObxVhvyHT0H6VDhG0useXE
         TYm8MaQAG3wHi46KHfWyxB95J2rihA8SSotlOWsnOoWqmM9UHAZqWFqkLzkS9WnHaQbH
         xLn+777lcAOGgd6ZkFOzlSGz3ImC33iQWo9OgTZSyeiAePG/Gnbp0oHv99wjzoTyWzUP
         c6/g==
X-Gm-Message-State: AOAM533m2Rnvt+tJLPWUonPGsjKuWwlthky1EsgK0+M698pVJn/p4T61
        0VCX6b8VTs25WPhEUCPgROc=
X-Google-Smtp-Source: ABdhPJweUBK1XUsIXRfTOySdTx1nEzjPqdK1a79b/pzQxDgKaXgij/E6CsiG7cOegZg+/wYt7XvY4A==
X-Received: by 2002:a7b:ce01:: with SMTP id m1mr7115034wmc.115.1642144349783;
        Thu, 13 Jan 2022 23:12:29 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m39sm9830079wms.33.2022.01.13.23.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 23:12:29 -0800 (PST)
Date:   Fri, 14 Jan 2022 08:12:26 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: crypto: BUG: spinlock recursion when doing iperf over ipsec with
 crypto hardware device
Message-ID: <YeEiWmkyNwfgQgmn@Red>
References: <Yd1SIHUNdLIvKhzz@Red>
 <YeD4rt1OVnEMBr+A@gondor.apana.org.au>
 <YeD6vt47+pAl0SxG@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YeD6vt47+pAl0SxG@gondor.apana.org.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, Jan 14, 2022 at 03:23:26PM +1100, Herbert Xu a écrit :
> On Fri, Jan 14, 2022 at 03:14:38PM +1100, Herbert Xu wrote:
> > On Tue, Jan 11, 2022 at 10:47:12AM +0100, Corentin Labbe wrote:
> > >
> > > [   44.646050] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
> > > [   44.654143] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
> > > [   44.662408] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
> > > [   44.670766] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
> > > [   44.679900] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)
> > 
> > So did sun8i_ce_cipher_run ensure that BH is disabled before
> > invoking xfrm_input? If not then this explains the dead-lock.
> 
> The issue appears to be with crypto_engine.  It needs to ensure
> that completion functions are called with BH disabled, not IRQ
> disabled and definitely not BH enabled.
> 

Hello

This minimal patch fix my issue, does it is the rigth way ?

Thanks for your help
Regards

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index fb07da9920ee..b3844f6d98a3 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -7,6 +7,7 @@
  * Author: Baolin Wang <baolin.wang@linaro.org>
  */
 
+#include <linux/bottom_half.h>
 #include <linux/err.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -53,7 +54,9 @@ static void crypto_finalize_request(struct crypto_engine *engine,
                                dev_err(engine->dev, "failed to unprepare request\n");
                }
        }
+       local_bh_disable();
        req->complete(req, err);
+       local_bh_enable();
 
        kthread_queue_work(engine->kworker, &engine->pump_requests);
 }

