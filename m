Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A9C51D30D
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389961AbiEFIQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 04:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237626AbiEFIPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:15:52 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD1567D2B
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 01:12:10 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q4so3827557plr.11
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 01:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z99s0CMOS+blcOlyEeJ8HO7Gao/dzwW5muqWrVS03gs=;
        b=TUga4+uSqew6uyt9kdnk1p2wZEMU+jRSGkaJoPa3LAf+1uaZR59uKvl82Uwg9AKm4v
         crWmHDoMKzYmues8c+lr1V1Qojg2YVVa9cA4LyzOj+hQ6naDpSmZjCqccifElLJC5Qqt
         NXq/2RgrXazgRwjBGihJpHKvx4dcaxC08cFoR74ks4LZpDkpvZgNJFSXBXjF9MNYvwXT
         3+WfFMhvgXDRcTGXVjGrHlCuOjH/II3mW+BB6jcZNNEHSp/j0xvw3b+3vPUsT6nFR3/1
         rzlZy6ZIGAqcpGgQE0viubiZMEBJQNznzf1a5utt5PNofMFmrTa4nmiKstDlLBsJEpuQ
         dZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z99s0CMOS+blcOlyEeJ8HO7Gao/dzwW5muqWrVS03gs=;
        b=Kunr+CgYcaJkj0ek/TlySLrVwtRBGlj6dhxpBbq3FNc+lySvwb2SC9b7qRaRBe6Lce
         L2pGSyi7EGgxyGiGDvg0mIwSu/WxaOj6n7eMdNQEL8mHxULUyRctlBO8BcvujE87gBGI
         U8iqYUmUNVXndCu8vtz/ytz92bg7ZFjXVYPNxS7UX1R6K9fB3ds1H5mEL2QU9SVWp9S/
         nZdN5q5y6VEX4yksQnUs7cPFGfKKWVpia/0u/4iH/rmUpAJCBTzJ3noIr5Bdhit/BRBB
         CD+U6flSrC652SLboJSBaUQUrU0qQfjR67l1PKeBZzPNTYVYLq+wQ7NMiufhKThPc+Qz
         swnw==
X-Gm-Message-State: AOAM532I8LVxj9RCY0pHgpiQhCcFJETrpXZtn6WcM8jwOp9DSIERNlzj
        md2Q2iOROHUYTNbDfJzqX1FywyDYnbM=
X-Google-Smtp-Source: ABdhPJwSqmzjGOEeHti9TEsHNy/Qj4UFD2dEf3jGG1XT0TTyWi9pj+Ztwtj0f7D2RkntfG9bAd9x9w==
X-Received: by 2002:a17:90b:368e:b0:1d8:fcd2:c6ca with SMTP id mj14-20020a17090b368e00b001d8fcd2c6camr2842387pjb.44.1651824729544;
        Fri, 06 May 2022 01:12:09 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e30-20020a631e1e000000b003c14af5060asm2606636pge.34.2022.05.06.01.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 01:12:08 -0700 (PDT)
Date:   Fri, 6 May 2022 16:12:02 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <YnTYUmso0D29CDcg@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
 <Yl07fecwg6cIWF8w@Laptop-X1>
 <YmKCPSIzXjvystdy@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmKCPSIzXjvystdy@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 06:24:05PM +0800, Hangbin Liu wrote:
> On Mon, Apr 18, 2022 at 06:20:52PM +0800, Hangbin Liu wrote:
> > > 	Agreed, on both the comment and in regards to using the extant
> > > bonding options management stuff.
> > > 
> > > >Also, in the Documentation it is mentioned that this parameter is only
> > > >used in modes active-backup and balance-alb/tlb. Do we need to send an
> > > >error message back preventing the modification of this value when not in
> > > >these modes?
> > > 
> > > 	Using the option management stuff would get this for free.
> > 
> > Hi Jav, Jon,
> > 
> > I remembered the reason why I didn't use bond default option management.
> > 
> > It's because the bonding options management only take bond and values. We
> > need to create an extra string to save the slave name and option values.
> > Then in bond option setting function we extract the info from the string
> > and do setting again, like the bond_option_queue_id_set().
> > 
> > I think this is too heavy for just an int value setting for slave.
> > As we only support netlink for new options. There is no need to handle
> > string setting via sysfs. For mode checking, we do just do like:
> > 
> > if (!bond_uses_primary(bond))
> > 	return -EACCES;
> > 
> > So why bother the bonding options management? What do you think?
> > Do you have a easier way to get the slave name in options management?
> > If yes, I'm happy to use the default option management.
> 
> Hi Jay,
> 
> Any comments?
> 

Hi Jay,

I'm still waiting for your comments before post v2 patch. Appreciate if you
could have a better way about handling the slave name in options management.

Thanks
Hangbin
