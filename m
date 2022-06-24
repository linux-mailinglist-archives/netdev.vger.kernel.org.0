Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FDCF5593CE
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 08:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbiFXG4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 02:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiFXG4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 02:56:54 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FCB67E7B;
        Thu, 23 Jun 2022 23:56:53 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id 65so1744822pfw.11;
        Thu, 23 Jun 2022 23:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CQLW04s8vb4y/9XuYLHdde+ABYigEI4asQuaKgLJKrc=;
        b=EaJlsD5vomAKolqToFKbaK9jwrVvh6ooFjnstoPX7A0a2umRNYpz9NH3KVmtY32G2B
         Z4bLBwWRl9uhoasIHDdcc0KQsrwKQZv9VvU01IopJVPIUBlIMIJvOfnu6MdnHgDfh+R/
         7HkwqeOZxFh4Vr5R/T0/yUt4MWFSjHTHXT5zFX5xC3eFhJ0HjCnQ6nSNzOVddcUL36Um
         /EaACA5h/5jcM9LgrgwK8gw/bIBn2/maGcajsmMxsUUVbIThGdxN8OPvBY+8Ap82xzCm
         NXX9mNyyt0URHsVvVPA3+b3RzFREjJ4Fm89nB9WyMb+8XXVrakT1VRbIzyj5Ryya9u3U
         Qojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CQLW04s8vb4y/9XuYLHdde+ABYigEI4asQuaKgLJKrc=;
        b=MYzRDJ2s5+B3ku/692qVpek7T8DA8Ae0hxIei/Od71t/Qza5P17xBSQMPRhmV8k5Xe
         uchBIiGmkkiTK3IyOD5U8SOa5tqBQzpgUSc4nsSDoBhS+ZQV/0Ju/Nu5CZWpjfLef3b4
         IiKVYrTFgcParMA85w/9p5uvGBHw7uBWEvO5K60f5kLHPld+QmvFHqTIpuTV6tF+5qq0
         /x3WXVuzgVEIqQqNoS0rvRxgWyWhuUEGQlQ70PhCD6qc668sA/gdGytxkQhiM9EGaOQB
         6tUGoDM6LVg4tAX2bSo22HD2owVrkEMpbT3E0K4u3uxzYNpHa97kVmIyLZcrRTm4xsAU
         rDMg==
X-Gm-Message-State: AJIora/8HNLZyR+UfCLnA09fRfGR/SnKnMoBrJFLQM8e/Psfyq1LFWsS
        oAZMvpjUgk5/mCK3nPiCzc/GpubfFAt1cQ==
X-Google-Smtp-Source: AGRyM1vE7dCW7jW8K5Sj06K5myCG9Uagi6GaFVdToms/HjUTM7g5G2vtGxXs54WjU2i5Yk8Z8Vx0Ww==
X-Received: by 2002:a63:680a:0:b0:40d:bb2:19f4 with SMTP id d10-20020a63680a000000b0040d0bb219f4mr10564952pgc.593.1656053812518;
        Thu, 23 Jun 2022 23:56:52 -0700 (PDT)
Received: from archdragon (dragonet.kaist.ac.kr. [143.248.133.220])
        by smtp.gmail.com with ESMTPSA id 9-20020a170902c20900b0015e8d4eb1dfsm985871pll.41.2022.06.23.23.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 23:56:52 -0700 (PDT)
Date:   Fri, 24 Jun 2022 15:56:48 +0900
From:   "Dae R. Jeong" <threeearcat@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KASAN: use-after-free Read in cfusbl_device_notify
Message-ID: <YrVgMPxy2vNT9stU@archdragon>
References: <YrVUujEka5jSXZvt@archdragon>
 <CANn89iKLpGamedvzZjnhpNUUpPJ7ueiGo62DH0XM+omQvhr9HA@mail.gmail.com>
 <YrVYywPFYiqWJo4a@archdragon>
 <CANn89iJOibYQCsY+ekObagmwmPap0FGqYdJacsO1mVvOgkKmdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJOibYQCsY+ekObagmwmPap0FGqYdJacsO1mVvOgkKmdg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 08:32:31AM +0200, Eric Dumazet wrote:
> On Fri, Jun 24, 2022 at 8:25 AM Dae R. Jeong <threeearcat@gmail.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 08:15:54AM +0200, Eric Dumazet wrote:
> > > On Fri, Jun 24, 2022 at 8:08 AM Dae R. Jeong <threeearcat@gmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > We observed a crash "KASAN: use-after-free Read in cfusbl_device_notify" during fuzzing.
> > >
> > > This is a known problem.
> > >
> > > Some drivers do not like NETDEV_UNREGISTER being delivered multiple times.
> > >
> > > Make sure in your fuzzing to have NET_DEV_REFCNT_TRACKER=y
> > >
> > > Thanks.
> >
> > Our config already have CONFIG_NET_DEV_REFCNT_TRACKER=y.
> 
> Are you also setting netdev_unregister_timeout_secs to a smaller value ?
> 
> netdev_unregister_timeout_secs
> ------------------------------
> 
> Unregister network device timeout in seconds.
> This option controls the timeout (in seconds) used to issue a warning while
> waiting for a network device refcount to drop to 0 during device
> unregistration. A lower value may be useful during bisection to detect
> a leaked reference faster. A larger value may be useful to prevent false
> warnings on slow/loaded systems.
> Default value is 10, minimum 1, maximum 3600.

We are using the same config that Syzkaller uses. So its value is 140.

I'm not a network developer so I don't know whether there is a
possibility of a false alarm. Our fuzzer is a research prototype in
development, and I don't want to interrupt you with false alarms...

> > Anyway, this UAF report seems not interesting.
> >
> > Thank you for your quick reply.
> >
> >
> > Best regards,
> > Dae R. Jeong.

Best regards,
Dae R. Jeong.
