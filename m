Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843575A5243
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 18:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiH2Qx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 12:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiH2Qx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 12:53:27 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE117E019;
        Mon, 29 Aug 2022 09:53:21 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id w28so6591323qtc.7;
        Mon, 29 Aug 2022 09:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=u3/yEWHuMKupQktQ2vj0ZP873HVpq5mZ7bFLwxYlglM=;
        b=ZxLJPGm4uO+8INwf2ksnPcgTAEM/x6ycQF+u7olIKaaI3UaCLrQ+EpuKE2PfxSLxdZ
         g6+M9Fw1Ye94jIBjMVc0AJ8obrFrQ0PQwYemM7/EZLErQPCqWxAHjdmule+TB7mR1VRN
         zWQOnakiFTP37ERbGWUbbZM0L/oVn7d1ir814wZkKPFAkDzdS7Dk9owJtexoJmcwyBOa
         9Z29bMczGQOWMs27BTpNQTDALpmlS/kC1sFYECg3FLh2Vcxd5qA854OSRB/t7FLxqa68
         Wp6LTyWzHl/2E1fJlYyLGzLxZkcmIFedjQFIb8NPRWG7XBjcm2sMlQk93mcyMUoD37rb
         zjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=u3/yEWHuMKupQktQ2vj0ZP873HVpq5mZ7bFLwxYlglM=;
        b=MFtYq2eethLKNJ3vkyBmZUaH3O2ernIJChWDT6k3vucc/XryyX9moIJ64bF7WrMwv+
         kkdTOR3AfVwTDlz2vMbrrBng6OpFKFU3RIJ6575F7D5ZTXEJbK6B7UHJTML0Dp3yjnai
         qnClPP7c0TaOcDWdXHQsDeHeSc1VQOUyGvCZVOAIDFYYZtdz1y32qxfxds0UKJigKQpX
         /xye23UEx4ksV+FppyoKg4TP/ICep5+SwcQU16flooVN8m/DjDSEEgaiOa+D34TjvGq1
         8H6ziubaosbSIMjaPFYlisSg+1hqPHfry2NGFBu4iGa2M5ilqFn75Wcof99Kf8jpKK0A
         5m3w==
X-Gm-Message-State: ACgBeo27fFRqPQm2bIEkp2DZ6kIU8kAWUFprU8ito+v0Ky9Dj6dBXv4V
        9ZIz/Sk8ve6dP425CNm5OEE=
X-Google-Smtp-Source: AA6agR4cBzx1hfhQOhVjTpzcH4eQlEoFJBw/VtQhPb3FVshesbh9pkN8tW0Oo4yDB5nXJmFF/JeL9Q==
X-Received: by 2002:ac8:5d49:0:b0:344:9232:be56 with SMTP id g9-20020ac85d49000000b003449232be56mr10595888qtx.122.1661791999700;
        Mon, 29 Aug 2022 09:53:19 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:8fb6:8017:fac7:922b])
        by smtp.gmail.com with ESMTPSA id y2-20020ac85242000000b00339163a06fcsm5540268qtn.6.2022.08.29.09.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:53:18 -0700 (PDT)
Date:   Mon, 29 Aug 2022 09:53:17 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure
 infrastructure
Message-ID: <Ywzu/ey83T8QCT/Z@pop-os.localdomain>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
 <cover.1661158173.git.peilin.ye@bytedance.com>
 <20220822091737.4b870dbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822091737.4b870dbb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 09:17:37AM -0700, Jakub Kicinski wrote:
> On Mon, 22 Aug 2022 02:10:17 -0700 Peilin Ye wrote:
> > Currently sockets (especially UDP ones) can drop a lot of packets at TC
> > egress when rate limited by shaper Qdiscs like HTB.  This patchset series
> > tries to solve this by introducing a Qdisc backpressure mechanism.
> > 
> > RFC v1 [1] used a throttle & unthrottle approach, which introduced several
> > issues, including a thundering herd problem and a socket reference count
> > issue [2].  This RFC v2 uses a different approach to avoid those issues:
> > 
> >   1. When a shaper Qdisc drops a packet that belongs to a local socket due
> >      to TC egress congestion, we make part of the socket's sndbuf
> >      temporarily unavailable, so it sends slower.
> >   
> >   2. Later, when TC egress becomes idle again, we gradually recover the
> >      socket's sndbuf back to normal.  Patch 2 implements this step using a
> >      timer for UDP sockets.
> > 
> > The thundering herd problem is avoided, since we no longer wake up all
> > throttled sockets at the same time in qdisc_watchdog().  The socket
> > reference count issue is also avoided, since we no longer maintain socket
> > list on Qdisc.
> > 
> > Performance is better than RFC v1.  There is one concern about fairness
> > between flows for TBF Qdisc, which could be solved by using a SFQ inner
> > Qdisc.
> > 
> > Please see the individual patches for details and numbers.  Any comments,
> > suggestions would be much appreciated.  Thanks!
> > 
> > [1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
> > [2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/
> 
> Similarly to Eric's comments on v1 I'm not seeing the clear motivation
> here. Modern high speed UDP users will have a CC in user space, back
> off and set transmission time on the packets. Could you describe your
> _actual_ use case / application in more detail?

Not everyone implements QUIC or CC, it is really hard to implement CC
from scratch. This backpressure mechnism is much simpler than CC (TCP or
QUIC), as clearly it does not deal with any remote congestions.

And, although this patchset only implements UDP backpressure, it can be
applied to any other protocol easily, it is protocol-independent.

Thanks.
