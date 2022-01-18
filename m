Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF041492096
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 08:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343613AbiARHw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 02:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343594AbiARHw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 02:52:57 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19461C061574;
        Mon, 17 Jan 2022 23:52:57 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az27-20020a05600c601b00b0034d2956eb04so2683134wmb.5;
        Mon, 17 Jan 2022 23:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=44gDUy5K3yK/LK4CWy+8U+XmfAKikin5v6yugPO1Ses=;
        b=ahdRawPXnNwZHQJ7XdWYHeN8ha0g7ktxwX4TqGc1Q96DuaKS9IIZGSt/GQwRtlRzgz
         jY2TU0FA6Pau7F/lSiiQ758/fXd/GgdWrT6hpk6+E0nK47CsoyUhd6uRM8+imohlV2pW
         mnBdC6TE9/abfA3PxXSRt05p8pAVlLtK7vbfjkEScjBJfHmE6GovLpxL3m9/y/9S8LAU
         NxGKtC5FQVSsl4hrkMQO5XtG397tcMFM1CrSXHWDQPYA3cbTBjq+1mz+3vTZUchV+t6Q
         2AFvMB5K43jqXI9UIQ96zrgdA/2ZirZAmwPgaDdt0cUptzKVUJulgWblRiwsD3qvHMvU
         1J2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=44gDUy5K3yK/LK4CWy+8U+XmfAKikin5v6yugPO1Ses=;
        b=sieuU/LGC0iykw4KTclYKleZqhqVVDQ/+0P/r0xk6STH2IU8wYHxjaEXjl2JygxQ1G
         MDod0w9Lgvd8zwbpmLy0th3oLy1Yg+ijJUiGKHyahMhKuqodNqca1xQHOABMpddX9NEc
         u3+OcDwiIzR4JAj+jUyzvduL7wvTnIKc2HW0X0nA1OPR9qlzHWoiANLjElc0AfTNB2dj
         3J0wE9R76ZynYSLtCLKO3XKC4mCvR7DfOhyhGFu4hufJWso9De7fgwSrSAuFOs4d5kgk
         Lw/aX/sSS6j2CUvgiiF7Zf76t/EoNU/rY5miRSLxnP5AkmYspZsPWuzsHeUa4k9PRBUi
         GIRw==
X-Gm-Message-State: AOAM532mBvBpHLSoHfLyHkUmjE7J860uW9sf4pq4HWsK0uflg9S0vbhO
        5/EsxzQcLoLyhp8Ke0Yv1mm9KgRPTNM=
X-Google-Smtp-Source: ABdhPJxuyCwEFsb4U7fwu4plIZDcfgaLFcVBLRDOZi4dnWLUdxTtxoKSOwiT8sVgD2qQgVIpkihQsA==
X-Received: by 2002:a05:600c:2113:: with SMTP id u19mr23489123wml.16.1642492375722;
        Mon, 17 Jan 2022 23:52:55 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id r19sm1542277wmh.42.2022.01.17.23.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 23:52:55 -0800 (PST)
Date:   Tue, 18 Jan 2022 08:52:53 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: crypto: BUG: spinlock recursion when doing iperf over ipsec with
 crypto hardware device
Message-ID: <YeZx1aVL0HnT9tCB@Red>
References: <Yd1SIHUNdLIvKhzz@Red>
 <YeD4rt1OVnEMBr+A@gondor.apana.org.au>
 <YeD6vt47+pAl0SxG@gondor.apana.org.au>
 <YeEiWmkyNwfgQgmn@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YeEiWmkyNwfgQgmn@Red>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Fri, Jan 14, 2022 at 08:12:26AM +0100, Corentin Labbe a écrit :
> Le Fri, Jan 14, 2022 at 03:23:26PM +1100, Herbert Xu a écrit :
> > On Fri, Jan 14, 2022 at 03:14:38PM +1100, Herbert Xu wrote:
> > > On Tue, Jan 11, 2022 at 10:47:12AM +0100, Corentin Labbe wrote:
> > > >
> > > > [   44.646050] [<c0100afc>] (__irq_svc) from [<c080b9d4>] (xfrm_replay_advance+0x11c/0x3dc)
> > > > [   44.654143] [<c080b9d4>] (xfrm_replay_advance) from [<c0809388>] (xfrm_input+0x4d0/0x1304)
> > > > [   44.662408] [<c0809388>] (xfrm_input) from [<c03a3d88>] (crypto_finalize_request+0x5c/0xc4)
> > > > [   44.670766] [<c03a3d88>] (crypto_finalize_request) from [<c06a0888>] (sun8i_ce_cipher_run+0x34/0x3c)
> > > > [   44.679900] [<c06a0888>] (sun8i_ce_cipher_run) from [<c03a4264>] (crypto_pump_work+0x1a8/0x330)
> > > 
> > > So did sun8i_ce_cipher_run ensure that BH is disabled before
> > > invoking xfrm_input? If not then this explains the dead-lock.
> > 
> > The issue appears to be with crypto_engine.  It needs to ensure
> > that completion functions are called with BH disabled, not IRQ
> > disabled and definitely not BH enabled.
> > 
> 
> Hello
> 
> This minimal patch fix my issue, does it is the rigth way ?
> 
> Thanks for your help
> Regards
> 
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index fb07da9920ee..b3844f6d98a3 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -7,6 +7,7 @@
>   * Author: Baolin Wang <baolin.wang@linaro.org>
>   */
>  
> +#include <linux/bottom_half.h>
>  #include <linux/err.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
> @@ -53,7 +54,9 @@ static void crypto_finalize_request(struct crypto_engine *engine,
>                                 dev_err(engine->dev, "failed to unprepare request\n");
>                 }
>         }
> +       local_bh_disable();
>         req->complete(req, err);
> +       local_bh_enable();
>  
>         kthread_queue_work(engine->kworker, &engine->pump_requests);
>  }
> 

Hello

With my patch, I got:
[   38.515668] BUG: sleeping function called from invalid context at crypto/skcipher.c:482
[   38.523708] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 84, name: 1c15000.crypto-
[   38.532176] preempt_count: 200, expected: 0
[   38.536381] CPU: 6 PID: 84 Comm: 1c15000.crypto- Not tainted 5.16.0-next-20220115-00124-g13473e8fac33-dirty #116
[   38.546551] Hardware name: Allwinner A83t board
[   38.551100]  unwind_backtrace from show_stack+0x10/0x14
[   38.556358]  show_stack from dump_stack_lvl+0x40/0x4c
[   38.561428]  dump_stack_lvl from __might_resched+0x118/0x154
[   38.567107]  __might_resched from skcipher_walk_virt+0xe8/0xec
[   38.572955]  skcipher_walk_virt from crypto_cbc_decrypt+0x2c/0x170
[   38.579147]  crypto_cbc_decrypt from crypto_skcipher_decrypt+0x38/0x5c
[   38.585680]  crypto_skcipher_decrypt from authenc_verify_ahash_done+0x18/0x34
[   38.592825]  authenc_verify_ahash_done from crypto_finalize_request+0x6c/0xe4
[   38.599974]  crypto_finalize_request from sun8i_ss_hash_run+0x73c/0xb98
[   38.606602]  sun8i_ss_hash_run from crypto_pump_work+0x1a8/0x330
[   38.612616]  crypto_pump_work from kthread_worker_fn+0xa8/0x1c4
[   38.618550]  kthread_worker_fn from kthread+0xf0/0x110
[   38.623701]  kthread from ret_from_fork+0x14/0x2c
[   38.628414] Exception stack(0xc2247fb0 to 0xc2247ff8)
[   38.633468] 7fa0:                                     00000000 00000000 00000000 00000000
[   38.641640] 7fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[   38.649809] 7fe0:i 00000000 00000000 00000000 00000000 00000013 00000000

This is when testing hmac(sha1) on my crypto driver sun8i-ss and crypto testing authenc(hmac-sha1-sun8i-ss,cbc(aes-generic)).

Do you have any idea to better fix my issue ?

Regards
