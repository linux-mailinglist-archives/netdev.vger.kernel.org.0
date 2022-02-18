Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A014BB17F
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiBRFhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:37:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbiBRFhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:37:42 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C352E1162B2
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:37:24 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id v22so809142ljh.7
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 21:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PogQDqQWtuXLFALQMWLRiDm3xg80eD4oeLLmrMMy540=;
        b=nAiXK4bilPuf7Uavegp3S4W5n+isvO/A5Qt+vwI44QFoZUlzX7Fcwz6sK88zHlIvr3
         bheKdNej6dD7Ooij2rq+VN+RVPxk+CTYTRGmTsVxXDJwhVvworM0/iT2terUHZ6EVBkW
         ujtO8g8HiGJjeqckwDw4r0p35rCFZu6VtmdUQ915SWVi8XTUVAlNhMK432hnZK0HOZlD
         ufTL5UJ/JYCPCfCTouLeZyjLdQZgMiPyu5sfNaY8gdrUuXGqvQyrNRZSLHjiJJPGm6dw
         7lkEzOQj35P3yTvW0pyOXzGjhPfhfgbqWBWCpXaGQpz5tR7ipYq1QuABCS2mQ4i4uY8k
         8KEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PogQDqQWtuXLFALQMWLRiDm3xg80eD4oeLLmrMMy540=;
        b=wEkNfY1JzJfLkth05Qs1IQGzs+c+Up/KUmMcuWgcK47Hjx0Er743oTYKYHQUlspVc5
         QKxTdAYlM6sJg6kqeN+4xJUcMXfn69wDZWHUWac+qUqBeVEtgOk7rLeoFlWJG6efIoWy
         eFXBeNchAZ1yBGmiHYKX+MfdjOHDx1HbLSsZcBoICNqkd2a9eqX4m3sNIOpeNR+eqgQA
         bJEpggP7u/DguEthv5qOvRUsmJhp3RykY36XrAV5asd+QCZ/W8MkvDd8IvhHd0w7Mnzs
         UtCkm+1bInrsce8yZCHTudPAop8Zamj9QFdKxDEcOHmxcMjzjPhQ6urrLu3Vp/+7oSjJ
         oi6A==
X-Gm-Message-State: AOAM531yzRANWOUjOaoIthNpuCqtxwdyABjeKYlBT+VfvA1tZ6pp36DG
        CuhO7h+zLi2OddZ3bjOEc+CtucpFXBScEP76v1v8lXX8KBecpw==
X-Google-Smtp-Source: ABdhPJzH/6jmgqX8ZIaglx1htRU/L3uOJpDNXe1psH63I+wGZEbSp/Iqe1zADOL5jlGUjrvENUulxxvEt10zW0mfu0c=
X-Received: by 2002:a2e:9847:0:b0:245:5aa9:91ad with SMTP id
 e7-20020a2e9847000000b002455aa991admr4572884ljj.59.1645162642658; Thu, 17 Feb
 2022 21:37:22 -0800 (PST)
MIME-Version: 1.0
References: <1645109346-27600-1-git-send-email-sbhatta@marvell.com> <20220217090110.48bcad89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217090110.48bcad89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Fri, 18 Feb 2022 11:07:11 +0530
Message-ID: <CALHRZuqP15pP8Mgi=Q2BfMZuaG04uPYPKwCGAE1cJtJP0SVPYg@mail.gmail.com>
Subject: Re: [net-next PATCH 0/2] Add ethtool support for completion event size
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subbaraya Sundeep <sbhatta@marvell.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        hariprasad <hkelam@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Thu, Feb 17, 2022 at 10:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 17 Feb 2022 20:19:04 +0530 Subbaraya Sundeep wrote:
> > After a packet is sent or received by NIC then NIC posts
> > a completion event which consists of transmission status
> > (like send success or error) and received status(like
> > pointers to packet fragments). These completion events may
> > also use a ring similar to rx and tx rings. This patchset
> > introduces ce-size ethtool parameter to modify the size
> > of the completion event if NIC hardware has that capability.
> > A bigger completion event can have more receive buffer pointers
> > inturn NIC can transfer a bigger frame from wire as long as
> > hardware(MAC) receive frame size limit is not exceeded.
> >
> > Patch 1 adds support setting/getting ce-size via
> > ethtool -G and ethtool -g.
> >
> > Patch 2 includes octeontx2 driver changes to use
> > completion event size set from ethtool -G.
>
> Please add an explanation to ethtool-netlink.rst so people can
> understand what the semantics are.
>
Sure

> I think we may want to rename CE -> CQE, we used cqe for IRQ config.
>
I used CE because not to be confused with CQE mode in coalesce. I will
change to CQE

> Does changing the CQE size also change the size of the completion ring?
> Or does it only control aggregation / writeback size?

In our case we change the completion ring size too.

Thanks,
Sundeep
