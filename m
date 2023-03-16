Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B46BC4C4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjCPDdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCPDdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:33:54 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2ED4203
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:33:51 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d10so173442pgt.12
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678937631;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=StoSm2PbNeb8BVs9Lv1qEfjb9yKvLNQpYWngik2WhfI=;
        b=jg9Ki6+cctittrlV38yIj32zdJRuf4AUyfLuRskheYxC/2dC6PWgWmEsByfkuwjBYf
         2MfEH9A6MNN8E5mddJe+Oaqp34f9r/8ERqSIQmQ9ioClJkOJyh1dD4G/w6ts3JnPq24y
         iR2zBaGNn8pIEVnMlJMI4aDKJoo9mqHL/LGTWbajPBBfYErmETVQjYZIQj9yQ1My6nlC
         0OtBmz210XiD8vEBzdsx7+1tkEUN7OTM1rArbLP2+BWUdVmxBdUaHWVrXGnjtMDkiQps
         LaIMPuUBmhkU4aEjN5XEWhC/dqBkWDZ150BKg2j65aVPyoF7FUPs5oEgfPfwQGTn0Yly
         Js/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678937631;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StoSm2PbNeb8BVs9Lv1qEfjb9yKvLNQpYWngik2WhfI=;
        b=rpaIwqhDVtD71EIQv+JhMvPWzU49U16JNUmc5q+EhkfzEyPiKtOF9vbvpwX9zLuhg8
         VkLQU114hfzZPTPNvmydg65ezfmne59wl3naltP8E1+p+TsZGKUt+CX64F6vrHuVUPJp
         Ov21DpTwwFXuUne+qy5SNluPv8LS4K/qIe8bQdNtGbXY25Qi/L159z+4wxTCKNPL0xxx
         fVgWP0DniHlbsPgnowNjp7lmYnzWm5bf6NNKUy8PMJAU5F1dA5eX+rqw28r6g8Cevr0A
         3asu3VA9fUVT0emu15Qn7FKJsFovhYAZGC4yNJIWiXFSjXP/dBkBaP/f9qjboTmD7Zli
         S+kQ==
X-Gm-Message-State: AO0yUKXe37NzV2+v9uylG5eKiQ7rvOu+w8f6wCCp5DOXYs/m5kcJwOwr
        rggUqzm7R5JbE+XuvADXnmo=
X-Google-Smtp-Source: AK7set9lCrLAKJ74ECWy2Wt6TQeTNyIopvsIrq8JuNFTufHsCpViiTEAyN1dHKOOVQAZsSRbmGcTLA==
X-Received: by 2002:a05:6a00:4b:b0:5a8:c3ec:e24e with SMTP id i11-20020a056a00004b00b005a8c3ece24emr1642536pfk.4.1678937630819;
        Wed, 15 Mar 2023 20:33:50 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h11-20020a62b40b000000b0062505afff9fsm4226444pfn.126.2023.03.15.20.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:33:50 -0700 (PDT)
Date:   Thu, 16 Mar 2023 11:33:42 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG
 for tc action
Message-ID: <ZBKOFpG80d3vU++j@Laptop-X1>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com>
 <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
 <ZBGUJt+fJ61yRKUB@Laptop-X1>
 <CAM0EoM=pNop+h9Eo_cc=vwS6iY7-f=rJK-G9g+SSJJupnZVy8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM0EoM=pNop+h9Eo_cc=vwS6iY7-f=rJK-G9g+SSJJupnZVy8g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 02:49:43PM -0400, Jamal Hadi Salim wrote:
> On Wed, Mar 15, 2023 at 5:47 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> >
> > On Tue, Mar 14, 2023 at 06:35:29PM -0400, Jamal Hadi Salim wrote:
> > > Sorry, only thing i should have mentioned earlier - not clear from here:
> > > Do you get two ext warns now in the same netlink message? One for the
> > > action and one for the cls?
> > > Something to check:
> > > on terminal1 > tc monitor
> > > on terminal2 > run a command which will get the offload to fail and
> > > see what response you get
> > >
> > > My concern is you may be getting two warnings in one message.
> >
> > From the result we only got 1 warning message.
> >
> > # tc qdisc add dev enp4s0f0np0 ingress
> > # tc filter add dev enp4s0f0np0 ingress flower verbose ct_state +trk+new action drop
> > Warning: mlx5_core: matching on ct_state +new isn't supported.
> >
> > # tc monitor
> > qdisc ingress ffff: dev enp4s0f0np0 parent ffff:fff1 ----------------
> > added chain dev enp4s0f0np0 parent ffff: chain 0
> > added filter dev enp4s0f0np0 ingress protocol all pref 49152 flower chain 0 handle 0x1
> >   ct_state +trk+new
> >   not_in_hw
> >         action order 1: gact action drop
> >          random type none pass val 0
> >          index 1 ref 1 bind 1
> >
> > mlx5_core: matching on ct_state +new isn't supported
> > ^C
> 
> Thanks for checking. I was worried from the quick glance that you will
> end up calling the action code with extack from cls and that the
> warning will be duplicated.

The action info should be filled via dump function, which will not call
tca_get_fill(). So I think it should be safe. Please correct me if I missed
anything.

Thanks
Hangbin
