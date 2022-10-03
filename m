Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C415F3562
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJCSNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiJCSNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:13:20 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA482BE34
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:13:16 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-13207a86076so9645514fac.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 11:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=KAs5TktNgqDwCFtnLFoqnF5GPiDw8jq4bhTzJL6oC2o=;
        b=bstPVNkcw2cwlhviw1F6eW68R9NRurdhXZiUO028nbGbM1ZwsBym9A8bSp1cSmlcT4
         3P551Z9VCP12ptRQAnW7tWsjo6iZH1maYjIfF16NkQR5R+Eh5hu9DmgxevDPKNPHNc8V
         6xaNaDXg2cJ33Y71Lw+I5ooVBJvCflYiOim1lwYPKdxawP003EHtI4ef6rzkfVMk2eFx
         WQ2fkaqJvG1HabYCa0itDr0dyL5uDHoDHovBX4rBVHhX88WGg910mBvnqXSyWJJ+xntr
         KHoJKrK2nnlOAbt4m5g8IpINWvzQjR2yG9CJa1Tca6ut+VtELzulzx9qIbUfiMYFvzib
         K0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=KAs5TktNgqDwCFtnLFoqnF5GPiDw8jq4bhTzJL6oC2o=;
        b=JLJdYh0UfwFvkNtQVBZQdsbW+df/gAdffDxeKZzVeodajTvJlWDbdd5msUXZUT62Nb
         8pRnsfOBobgZ2uq10aHrW3qHuyEjLS4mDesvrlQQvE5mYHvdqxr50gn7Ltdmr8fGdK92
         gOj+vt8tDrvPW7rXxc6ZLGm0W05yCp4G8sbUSS2Mi4DTQlYXqQ7so05z4bGLYXS3fTOV
         HX5e9+IO0s66K9grsqIiNMVC3h265yHYKa2n4RCchW001TTSjB2M5+SDNQS47TtNlGGo
         eVRretfVu1Ewfn8gie4lm6z2CGPm1ETLiIYjxoqiWcFXgtJ/17zbe6ISm5Y8xZO6K+P9
         o2Fw==
X-Gm-Message-State: ACrzQf21e+9CYcmhFXHGb3Vj1Fpu9qMqAkxynQBvqtN9Gd+0V5HQAYfi
        qfJYSVVwO73QqSfUscjD4vU=
X-Google-Smtp-Source: AMsMyM6F2IXP4LX8GhMu4aX6BqKtDnh/n/EXeX6CgKPJh4L/z4rXFiLkVIWrB+w5uiBqz455pSaWVg==
X-Received: by 2002:a05:6870:5626:b0:127:5f1b:12d2 with SMTP id m38-20020a056870562600b001275f1b12d2mr6168186oao.248.1664820796129;
        Mon, 03 Oct 2022 11:13:16 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id b17-20020a056870d1d100b00127a6357bd5sm3072951oac.49.2022.10.03.11.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 11:13:15 -0700 (PDT)
Date:   Mon, 3 Oct 2022 11:11:05 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH 0/4] net: drop netif_attrmask_next*()
Message-ID: <YzsluT4ET0zyjCtp@yury-laptop>
References: <20221002151702.3932770-1-yury.norov@gmail.com>
 <20221003095048.1a683ba7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003095048.1a683ba7@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 03, 2022 at 09:50:48AM -0700, Jakub Kicinski wrote:
> On Sun,  2 Oct 2022 08:16:58 -0700 Yury Norov wrote:
> > netif_attrmask_next_and() generates warnings if CONFIG_DEBUG_PER_CPU_MAPS
> > is enabled.
> 
> Could you describe the nature of the warning? Is it a false positive 
> or a legit warning?
> 
> If the former perhaps we should defer until after the next merge window.

The problem is that netif_attrmask_next_and() is called with
n == nr_cpu_ids-1, which triggers cpu_max_bits_warn() after this:

https://lore.kernel.org/netdev/20220926103437.322f3c6c@kernel.org/

Underlying bitmap layer handles this correctly, so this wouldn't make
problems for people. But this is not a false-positive.

Thanks,
Yury
