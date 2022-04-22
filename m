Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 838E050B4EE
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446412AbiDVK1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380820AbiDVK06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:26:58 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CAD54BE5
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:24:05 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id x80so7610364pfc.1
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4v9POtAVAQecXhsmVKokwPgmyWas01DeFSnVlgAeFb8=;
        b=UlwEqQog6wXzOaJmRsF4wopKD6VSWmoTgqS2O+/EkGzAsnX8no6xK5nycuQdYWMpyn
         cjYvmotFhX0JF1uu5O+cN8W673kNifKQiRpID/EHSz6NR2wkYHw8qio4BNtM3QeDtyya
         pdbTvvpwlDgFRFQfvXk+dDgSTb2j9Ua73vj1uqaXJBg4Ne1FzJJNu/jwzB1PzKupQKo7
         OMtCgatUKSwHklT0FdowB+9CMm1ozsv6AgY4WE6jCUvnAOwIYVl4lQC2RREEx7Qys0iG
         UO79yiB6PstHsMuN0+Zp5XMJa5wPq8Oxn0CC/fQF0wlqWiRo+HMA2coA9mgfWD0sXcJQ
         ZeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4v9POtAVAQecXhsmVKokwPgmyWas01DeFSnVlgAeFb8=;
        b=B/qHKZQVGM9V5S/EiDjO0g5rg61vp/uict5OVC0fN6UuFctJHeA0FrrUxM46W86Tjn
         jf5zMJmIYiqWTm6T1GZLzQstz388AIoB7a0s5Hr40wn0ZducsrcCILm3XueeopitdQPU
         ZCLBcboaarR17pn3Rzl0Uz18WHtJPQG6mX5iSdOWyTmTE4raxbawc6F1ZYhqiLITQxpa
         c19HIKi3hXac3tVc96BeSz6NE3QqhQ2f10iVt2b+qy644CkLT5ixIN/s/UjAsjwakyD0
         GmxbjRaqQox/FSBoJhU9fNNXsKhCbJpzy/kXBgnTe67C5vcL5Fqw2dC0ERGzfzmusw9T
         nMcA==
X-Gm-Message-State: AOAM532nGFRyArAyGcWbC0/VOrn3I955CNQfbB7eGIMFaLlKpzlRNKoJ
        3iMM7rR5vLa9r9Qn4Gzz0aaEz9dxSas=
X-Google-Smtp-Source: ABdhPJxpQ4nnjmIgfr78mjE2ZTAz/zjoJ5PmeuLT73dcQPQpOWYCk1IXBJSNlDsvx/XJ1WIlXbtvUA==
X-Received: by 2002:a63:1252:0:b0:39d:aa7a:c6e1 with SMTP id 18-20020a631252000000b0039daa7ac6e1mr3341134pgs.436.1650623045437;
        Fri, 22 Apr 2022 03:24:05 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j1-20020a17090a7e8100b001d2edf4b513sm5699458pjl.56.2022.04.22.03.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:24:04 -0700 (PDT)
Date:   Fri, 22 Apr 2022 18:23:57 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] Bonding: add per port priority support
Message-ID: <YmKCPSIzXjvystdy@Laptop-X1>
References: <20220412041322.2409558-1-liuhangbin@gmail.com>
 <1d6de134-c14e-4170-d2ad-873db62d8275@redhat.com>
 <20134.1649778941@famine>
 <Yl07fecwg6cIWF8w@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yl07fecwg6cIWF8w@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 18, 2022 at 06:20:52PM +0800, Hangbin Liu wrote:
> > 	Agreed, on both the comment and in regards to using the extant
> > bonding options management stuff.
> > 
> > >Also, in the Documentation it is mentioned that this parameter is only
> > >used in modes active-backup and balance-alb/tlb. Do we need to send an
> > >error message back preventing the modification of this value when not in
> > >these modes?
> > 
> > 	Using the option management stuff would get this for free.
> 
> Hi Jav, Jon,
> 
> I remembered the reason why I didn't use bond default option management.
> 
> It's because the bonding options management only take bond and values. We
> need to create an extra string to save the slave name and option values.
> Then in bond option setting function we extract the info from the string
> and do setting again, like the bond_option_queue_id_set().
> 
> I think this is too heavy for just an int value setting for slave.
> As we only support netlink for new options. There is no need to handle
> string setting via sysfs. For mode checking, we do just do like:
> 
> if (!bond_uses_primary(bond))
> 	return -EACCES;
> 
> So why bother the bonding options management? What do you think?
> Do you have a easier way to get the slave name in options management?
> If yes, I'm happy to use the default option management.

Hi Jan,

Any comments?

Thanks
Hangbin
