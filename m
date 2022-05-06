Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C875B51E0FE
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 23:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387998AbiEFVYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 17:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245548AbiEFVYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 17:24:40 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB49546B7
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 14:20:55 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id w187so14996974ybe.2
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 14:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fqXz+dTLxQYjyFYnjfmDpRRrgvtCHF11B1aDW4J8nAc=;
        b=oXfguIMZVUgzBCQtteAuUppjw42A26ne7jK/u6cHHSSLGCrgtBSWOLxxlevWYKJmSF
         Vgkp8WCTxq1Gn2HEpNaAmOVd1i0uD8d3ARmC+Y59v3W5tc16GnlZ+Nd6UYUI+RL044Wh
         6bWwlA9U8Mk90X//cokN3/V63T6GN8b0YRmKhKLKZnf/nsXNUZdZa/0KwTBVmnIW5Hj5
         o1w6suYtMeQ0q0BcLB+GGufdiGDPO9Q1xJts1jse71TYikrmgEwztqtbQT7j0Ox5Odf7
         6MCbXc+XXuSgA+vNGW0MtlkYhSvnUB/vMjlaCryQxRZKde6zHBl9kH6IdDn3rlMX3J68
         i4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fqXz+dTLxQYjyFYnjfmDpRRrgvtCHF11B1aDW4J8nAc=;
        b=TVZ9+hiPG1Rpmeln+p6Cjd4M/JCzzppTmfMeeE131gxPYI292FQkVGARH/xEkZCaT8
         HJbcbchvaexc4QV1hfefP+zejxqQtG5auGG/MxV4fAu4JWfUXl+gANtKIrp9/CUjzoQb
         c7FVd9NQ7kPoma7FhYD92lEn8xM0v31wuTDtjBZhfkBNZUG2TJ0QTHD3i4ZyZyNdPmBs
         5lWvarrdDjXevwgHxi5hnSaxcIEjS3AKPSt1Cyw9J7ZkNP9GrQpH10VV8jM+NGKIWIGj
         mKu/fiMEQ17jfpFljilSLk4jrdhUhyIhd2ek7IhB3lkKdf/6qd1jacIoYF6m9vy8QCcV
         37CA==
X-Gm-Message-State: AOAM533PBc17N6VFbB6sY0j6nOz6FU73ySHKqZ1qTmN8Fj9Hp+SGgXbd
        HVxahRbtlqBm4B8X4seb1idlkzK8T0OWIdyvhRRQLA==
X-Google-Smtp-Source: ABdhPJy3LlKTwB0juQz3WOZih07yxh0CjcrPKXOUgStHzSyO2nQcvDnSzSBpKwFy+wCL4/YAoha9A7AOhwAO1mZf+bM=
X-Received: by 2002:a25:ba50:0:b0:649:b5b2:6fca with SMTP id
 z16-20020a25ba50000000b00649b5b26fcamr3804973ybj.55.1651872054218; Fri, 06
 May 2022 14:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
 <20220506153048.3695721-3-eric.dumazet@gmail.com> <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
In-Reply-To: <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 6 May 2022 14:20:43 -0700
Message-ID: <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 6, 2022 at 1:48 PM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, 2022-05-06 at 08:30 -0700, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> >
> > This enables ipv6/TCP stacks to build TSO packets bigger than
> > 64KB if the driver is LSOv2 compatible.
> >
> > This patch introduces new variable gso_ipv6_max_size
> > that is modifiable through ip link.
> >
> > ip link set dev eth0 gso_ipv6_max_size 185000
> >
> > User input is capped by driver limit (tso_max_size)
> >
> > Signed-off-by: Coco Li <lixiaoyan@google.com>
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> So I am still not a fan of adding all this extra tooling to make an
> attribute that is just being applied to one protocol. Why not just
> allow gso_max_size to extend beyond 64K and only limit it by
> tso_max_size?

Answer is easy, and documented in our paper. Please read it.

We do not want to enable BIG TCP for IPv4, this breaks user space badly.

I do not want to break tcpdump just because some people think TCP just works.

>
> Doing that would make this patch much simpler as most of the code below
> could be dropped.
>

Sure, but no thanks.
