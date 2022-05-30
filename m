Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E135373A9
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 05:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbiE3DBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 May 2022 23:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiE3DBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 23:01:19 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C513F0D
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:01:18 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n8so9168320plh.1
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 20:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rks5fIGBrlcf+oralbR7Ycf4o6JiMjOQRHRBf5eMNXs=;
        b=aSEXngWz9ZkPBfNUQZPzTTkLF588Pu3AIpXU+IYMzfoBVoKlCiKGBY/e9HmAr2HqnN
         /r1cYO5U8+q+ntLv90li6OU9TQNb+MWOwv+88/ONgoBdK049GMdhZIlfSA7aC6NxXF+3
         Q6NeWvUQfHprW/a/r48RKBQlqdT+LBuKtOAqo2OrPENYH2MbBEdb51dRuJFoSMv66bij
         CSxSblnYs31jkqHSTBA0UZ9xpPn6fyh5QgYIcxQxZceewSTldbL/0CGqmDrNVgWjQe8x
         /I2fee3EgU4kaqpWHmTdjVYqc9nd5SLyYhHWR3p2vg2DtNhI9uVVjZ5NsFewZtTXHRmz
         zaaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rks5fIGBrlcf+oralbR7Ycf4o6JiMjOQRHRBf5eMNXs=;
        b=orzePJXbMX4Ul+Urw9SsdZTjyJ/d48/5yiZq8yUZn1RHzFFVME4BnImLqoVqpvX2CT
         eXWMeB19Zd3N9znRrcEQ7Yd5/IQBswnS6nQvMPnbYHB4N6R2vEfGTHUEEq11vOHFw8bL
         05lTuVDGmkzyN1jd3OQ/NNUwSz266V03+b6QIvvC4Zp0DVQQ+YwlLkU2FIXhVibysEk8
         VCnACp3QjpknCMRb3IDEcg9hefQTbaPxld/OPHFGu4dXnyQwIaLDl306vIoiQazYWMbX
         UjfeeFunGpbdJxtnY4fT5DM29v+8BM2zm9CfghsV9RJRSO+Cp25d6PkLYhYHfjAfVCUs
         WmrQ==
X-Gm-Message-State: AOAM530tqGQS5IbVL1KJHpJdqBpVTJwqKi2xWWk51nRyblgsiYP9r5ll
        6avINEHuODgu07pWuDGo0e4=
X-Google-Smtp-Source: ABdhPJw2eutZ/9GHNeqUukgjF1xmZeKgLnvbRKph1lyErvsEayu9ASRrfF8eOwzndPQJxAulp6yH8A==
X-Received: by 2002:a17:902:d5c1:b0:162:64e:8c21 with SMTP id g1-20020a170902d5c100b00162064e8c21mr42961510plh.34.1653879678300;
        Sun, 29 May 2022 20:01:18 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g20-20020aa78754000000b00517c84fd24asm7790286pfo.172.2022.05.29.20.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 May 2022 20:01:17 -0700 (PDT)
Date:   Mon, 30 May 2022 11:01:11 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, Li Liang <liali@redhat.com>
Subject: Re: [PATCH net] bonding: show NS IPv6 targets in proc master info
Message-ID: <YpQzd8BqidUc4IsT@Laptop-X1>
References: <20220527064419.1837522-1-liuhangbin@gmail.com>
 <e09cd8cf-4779-273e-a354-c1cfba120305@redhat.com>
 <18039.1653693705@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18039.1653693705@famine>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 04:21:45PM -0700, Jay Vosburgh wrote:
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
> >On 5/27/22 02:44, Hangbin Liu wrote:
> >> When adding bond new parameter ns_targets. I forgot to print this
> >> in bond master proc info. After updating, the bond master info will looks
> >                                                               look ---^
> >> like:
> >> ARP IP target/s (n.n.n.n form): 192.168.1.254
> >> NS IPv6 target/s (XX::XX form): 2022::1, 2022::2
> >> Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
> >> Reported-by: Li Liang <liali@redhat.com>
> >> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> >> ---
> >>   drivers/net/bonding/bond_procfs.c | 13 +++++++++++++
> >>   1 file changed, 13 insertions(+)
> >> diff --git a/drivers/net/bonding/bond_procfs.c
> >> b/drivers/net/bonding/bond_procfs.c
> >> index cfe37be42be4..b6c012270e2e 100644
> >> --- a/drivers/net/bonding/bond_procfs.c
> >> +++ b/drivers/net/bonding/bond_procfs.c
> >> @@ -129,6 +129,19 @@ static void bond_info_show_master(struct seq_file *seq)
> >>   			printed = 1;
> >>   		}
> >>   		seq_printf(seq, "\n");
> >
> >Does this need to be guarded by "#if IS_ENABLED(CONFIG_IPV6)"?
> 
> 	On looking at it, the definition of ns_targets in struct
> bond_params isn't gated by CONFIG_IPV6, either (and is 256 bytes for
> just ns_targets).
> 
> 	I suspect this will all compile even if CONFIG_IPV6 isn't
> enabled, since functions like ipv6_addr_any are defined regardless of
> the CONFIG_IPV6 setting, but it's dead code that shouldn't be built if
> CONFIG_IPV6 isn't set.

Yes, I didn't protect the code if if could be build without CONFIG_IPV6.
e.g. function bond_get_targets_ip6(). Do you think if I should also
add the condition for bond_get_targets_ip6() and ns_targets in struct
bond_params?

> 
> 	The options code for ns_targets depends on CONFIG_IPV6, so
> making this conditional as well would be consistent.

I will add the protection for this patch.

Thanks
Hangbin
