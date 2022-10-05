Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18135F4D44
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJEBDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiJEBDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 21:03:10 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1574E850
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 18:03:09 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id d14so7684178ilf.2
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 18:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=yJ/v5flpgbqzzKOS0FYLrm0MIv5XQqM/Le3ziZYOQHI=;
        b=ZC9ITz6o6buy6WwUn+AaoAusFCkjmocrVpdJxCp5hHjv2CRY8MPtaGrVAMXRv2VGix
         zYKcn3Z24SHeHcyk1I9x8BUFFVOFPuIk8Wk3ylLe42RZ0NEdKWBXCCzn6Hzy9PsSVBEk
         xllLfHngj6nxaYhz93NeNw+xexgMO6PfwmmonzAB0ivkRapnTONWOiTCAJqdzuvWLjBk
         teWXLcTESrPwRpzIvyLZ/iRmUgojm0Ky+LyJkS9cfcsU3CUvu1AXxyYvypkSOTZ8Rvap
         huqdoPP5WALMw/WBPzo19pm9krfggmqvkQ/J+TWxHu9S6h7XIRo5kDWdzAV+Sh1X51Th
         Rliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yJ/v5flpgbqzzKOS0FYLrm0MIv5XQqM/Le3ziZYOQHI=;
        b=TXCXkjmDuA0Z9ocxo7T7+oBjyfwHk2eXqOgHNBuLvtV90Xx3jfFQZ6re4EnL5WFdrF
         rZiOfg8JZI0viSg0IqJOp5b3RJwPVsmc8LgKiHd69bILq2GC8ieYY1lhtuxOLEMpmLth
         kF2oW/JBz+/IV24XhUkNpNc4PDsafD1Cq2MHLcb8RiWtULNKjmKAVM1wO3lIf5mTK63H
         FyxtzmDka85d6HxzMG3W9Z7AMUmeK4yQ9C9oUZea90UZLxTlWnij4CKbUGHMDR9FSLOX
         +vnk7yDnifXUODqc7/lNKE3NWmDnjwF2CINIet8fb2ECWWUuPWxOd99xYbbmvML3xjh0
         8wiA==
X-Gm-Message-State: ACrzQf2kQGP2FnIcquHvORDKSxY1/+I6aS3nQ/9sZH9gtbKa9K+tUjXc
        qI0d4eIkYEqiyUoJErV5D6hzPUD0UohZY6tg11+JAw==
X-Google-Smtp-Source: AMsMyM62nBzxdO94Lozo3o57NKTA5aneTHuundWNjPY59L8dQ2zGbFTKjlEmTK3cKl7Np1mP7zA1f10MgH6ZT2e0qZ8=
X-Received: by 2002:a05:6e02:17cb:b0:2f9:1fb4:ba3b with SMTP id
 z11-20020a056e0217cb00b002f91fb4ba3bmr12821161ilu.257.1664931788439; Tue, 04
 Oct 2022 18:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
 <Yzt2YhbCBe8fYHWQ@google.com> <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
 <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
 <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev> <20221004175952.6e4aade7@kernel.org>
In-Reply-To: <20221004175952.6e4aade7@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 4 Oct 2022 18:02:56 -0700
Message-ID: <CAKH8qBtdAeHqbWa33yO-MMgC2+h2qehFn8Y_C6ZC1=YsjQS-Bw@mail.gmail.com>
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 4 Oct 2022 17:25:51 -0700 Martin KaFai Lau wrote:
> > A intentionally wild question, what does it take for the driver to return the
> > hints.  Is the rx_desc and rx_queue enough?  When the xdp prog is calling a
> > kfunc/bpf-helper, like 'hwtstamp = bpf_xdp_get_hwtstamp()', can the driver
> > replace it with some inline bpf code (like how the inline code is generated for
> > the map_lookup helper).  The xdp prog can then store the hwstamp in the meta
> > area in any layout it wants.
>
> Since you mentioned it... FWIW that was always my preference rather than
> the BTF magic :)  The jited image would have to be per-driver like we
> do for BPF offload but that's easy to do from the technical
> perspective (I doubt many deployments bind the same prog to multiple
> HW devices)..

+1, sounds like a good alternative (got your reply while typing)
I'm not too versed in the rx_desc/rx_queue area, but seems like worst
case that bpf_xdp_get_hwtstamp can probably receive a xdp_md ctx and
parse it out from the pre-populated metadata?

Btw, do we also need to think about the redirect case? What happens
when I redirect one frame from a device A with one metadata format to
a device B with another?
