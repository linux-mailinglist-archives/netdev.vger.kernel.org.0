Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DBD57D96D
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 06:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiGVEYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 00:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGVEYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 00:24:02 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E1397A1A
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:24:01 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y9so3495299pff.12
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 21:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ee4+yiq2wuTRWAWDhT2tmaPwcxtERkJb7KZRNYmv3OY=;
        b=q3kkFJzzksE1bItcprBQU2tuqOyyiu3EIlsaKu5Nn8xKhNI2zVBUnMd4Sh4Wrf5Zuv
         jNWf3XbpwaDaoKhFnYruYFmyb4L3dhopepVtmf8gr9LMIYS+chjru7tniG3N+7LHUf1c
         0j14G/HFpdCDv22dZrdESTpeAtdNyq2qKu73qHg869yo9vRe/ryV6NCF1oyx2MX4MVI5
         0iOj1mEeB/4/Xucn+sQ9Hbq+XXXjgAkp/PMOSgh+gItL7sR56Vfv3gRE+PtEYT82u3ZP
         wIYJLJa+KYxKIaMvse5Jx5xuVy50Qd09RjWcm820j6cCYxrpDUPjtbamF4S75qBrnzGn
         dbPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ee4+yiq2wuTRWAWDhT2tmaPwcxtERkJb7KZRNYmv3OY=;
        b=6QbjOty2s/YMBEsn3YUgy9OLnwemr7kAR5uCzcaKr+U9yqmglv9UP0ABS8RM37cpQw
         o9SbTUOXYvrXGAEqgzvH7x92tdIqY23SDCJff6XLYGMgZbG7slvCDAsS+YSvaiAQmmE8
         iOUuHQZYYzmxeiphqQY4MqbfTJbP4rSg5W8qtlwKbZz0J/ae9+FjQYwmu/q9MtFlPm2Z
         fsXzp+u72ouKiakyZ83dDdHCziVhHUHNl+mHKDyo+39UIQiIvlIiWuc0oiCs/poTa3/v
         e+nhEpzDeutH+mqAkSbj8DS7SeBhKnsteNdCX8WdVB4aIhit1da/INGF33PWWKRlldrR
         Jthw==
X-Gm-Message-State: AJIora9VB1PslWJpC4rbrMqmNtx1dMIO3QvkDzMgM6f73+W8uyZZ87+N
        +yuZlYsGQSVI7UwbAhl5eBY=
X-Google-Smtp-Source: AGRyM1unOT9RK5jGUrzDbMxNgdi/RYtbf3S/Gx/cXHm56N4oU7KHkUnuJ3vmxGXamK/7Xwhe4wR7gQ==
X-Received: by 2002:a63:7e4c:0:b0:412:f7e:9ab6 with SMTP id o12-20020a637e4c000000b004120f7e9ab6mr1500148pgn.494.1658463841013;
        Thu, 21 Jul 2022 21:24:01 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bi5-20020a170902bf0500b0016bfea13321sm2498143plb.243.2022.07.21.21.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 21:24:00 -0700 (PDT)
Date:   Fri, 22 Jul 2022 12:23:54 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Message-ID: <YtomWhU9lR3ftEM+@Laptop-X1>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
 <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
 <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com>
 <YtoNCKyTPNPotFhp@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtoNCKyTPNPotFhp@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 10:35:52AM +0800, Hangbin Liu wrote:
> > I found this bug while testing another syzbot report.
> > (https://syzkaller.appspot.com/bug?id=ed41eaa4367b421d37aab5dee25e3f4c91ceae93)
> > And I can't find the same case in the syzbot reports list.
> > 
> > I just use some command lines and many kernel debug options such as
> > kmemleak, kasan, lockdep, and others.
> > 
> 
> Hi Taehee,
> 
> I got a similar issue with yours after Eric's 2d3916f31891
> ("ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()").
> I use force_mld_version=1 and adding a lot of IPv6 address to generate the
> mld reports flood. Here is my reproducer:

BTW, thanks for your fix. With your patch the issue is fixed. Please feel free
to add

Tested-by: Hangbin Liu <liuhangbin@gmail.com>

Cheers
Hangbin
