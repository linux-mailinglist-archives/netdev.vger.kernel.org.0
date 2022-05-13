Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F105267F5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382773AbiEMRNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359072AbiEMRNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:13:08 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91348331
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:13:07 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id j84so5571243ybc.3
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fMp2kF5ZqEIvgCfEF0zLwCa/yTVej8DzmSICLR0WqJA=;
        b=bnh88jSZHrldFBY3RLRvcF6LPCxaP7Izo+kiIQkuUy5U58fofy6J2H+9v2Otjt+SRA
         sEcnU0CmViPlbEZkuiksQTlezPNRudqIe6aOSU3L77ox2u5AqMS3RJg/Fw3xk3/pxKKY
         Skcm9XYGUXJQU3hXn49NJzyhTR59F4rvKe1E3XZb4qoOBFORxokQNniwu1k3yUSH4VYC
         tOlyr3v9WbpaVUH5jGCEOgOAhcUqgmKwPtyjIClLww3RlBJcCw4ktzUW9XqX1xpsrJ7+
         SSrtnqqmi96tJWoMXyxSkGEryonAMYt6Tdzc2ttaBJNGjJrCcq/7yhEdqMd6C2YcLUyZ
         DTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fMp2kF5ZqEIvgCfEF0zLwCa/yTVej8DzmSICLR0WqJA=;
        b=xTGlC8+DNTZFPtLR6oeF5kRr8P+6TUl4ULj+wJ5CxrXvYIU6tpfHAIpTxLqVOk+i+a
         HYvdkId/Vx7hixhFQjWWTqacnYo5tnb1N4mRmuU5C+zwuDkeXxOpqLMidKmXjl1vnxQh
         rKZh+2dmqH5JH2+7p1t6wRsp2WzkBbeBGwo1NeSbSGDdY2svhAwKmBSefzIdo7N/uSZv
         F9oJonwUs8kJm92gy/35mO4ZDYqqCcnUd6i4bzlR6erQiszxQ7eBXCkEfR9mns5CeD1E
         m+fIp59Od/L9911AfGPthWsxKKdXUpXQyAkxYXP77Jd8pIDhQcrcg5KSfZy2dbuRQ6VW
         kVBg==
X-Gm-Message-State: AOAM530Z2k6cXkVfMfBXLlt3PpnHHKOTRTO8qDdNCSpKhqiac46QbxRq
        EZ6siY/8C1Zk7iJ5WiJYdmnLfKky6OuO4OPDAayhvA==
X-Google-Smtp-Source: ABdhPJz5zq2hb6aa0opZzagpfkuDQYDMbC4Nxk2rM9q3+cRy56kvTx+LpiHY7TWxoiNDTMYreraTXVuoQtQWO+TY4Fg=
X-Received: by 2002:a05:6902:708:b0:649:4411:3aa0 with SMTP id
 k8-20020a056902070800b0064944113aa0mr5870785ybt.172.1652461986390; Fri, 13
 May 2022 10:13:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
 <20220510033219.2639364-14-eric.dumazet@gmail.com> <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
 <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
 <20220513042955.rnid4776hwp556vr@fedora> <CANn89iKSs3bwUBho_XEuSBRB+v+iR98OZTrhaSS88D4ZYwCwSA@mail.gmail.com>
 <20220513054945.6zpaegnsgtued4up@fedora> <CANn89i+Y8XO9b2LSLorER2-NEPzfcAo3uG+VDxrTcimyS-kdTg@mail.gmail.com>
 <20220513100421.7c6d9f20@kernel.org>
In-Reply-To: <20220513100421.7c6d9f20@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 13 May 2022 10:12:54 -0700
Message-ID: <CANn89iJ8XyXLZ1vdTS+vgZsFKsC_BHzi8dMLjfYLKV60rcwatw@mail.gmail.com>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
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

On Fri, May 13, 2022 at 10:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 13 May 2022 06:05:36 -0700 Eric Dumazet wrote:
> > The problem is that  skb_cow_head() can fail.
> >
> > Really we have thought about this already.
> >
> > A common helper for drivers is mostly unusable, you would have to
> > pre-allocate a per TX-ring slot to store the headers.
> > We would end up with adding complexity at queue creation/dismantle.
> >
> > We could do that later, because some NICs do not inline the headers in
> > TX descriptor, but instead request
> > one mapped buffer for the headers part only.
> >
> > BTW, I know Tariq already reviewed, the issue at hand is about
> > CONFIG_FORTIFY which is blocking us.
> >
> > This is why I was considering not submitting mlx5 change until Kees
> > Cook and others come up with a solution.
>
> We do have the solution, no?
>
> commit 43213daed6d6 ("fortify: Provide a memcpy trap door for sharp
> corners")

Oh I missed this was already merged.

I will rebase then.

Hopefully ARCH=hexagon|awesome won't trigger a new issue :)

Thanks.
