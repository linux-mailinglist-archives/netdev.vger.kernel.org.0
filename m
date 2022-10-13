Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5124B5FD63D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 10:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiJMIdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 04:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJMIdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 04:33:09 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B7B285
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:33:08 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bu25so1398706lfb.3
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 01:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2ZpTw3WTAoEOQKKnmdLeptRF2P2Fy9YbHeutJDGoVvc=;
        b=g/+qzeK7WiAdajY0cbcic6EKhScsY14YRSNUyAqw6NJjNfLWcF/4VDGD3ZPYW6RfF2
         OBVgOP8o7Bfw9Rqk5s8o2o+NSZfAQSrSM0aSEPHf54P3m+r0zTR9mo/ulvAFRG6wkKcv
         O9pDduxtI1lU5HG3p9M0WrBtZDvujtIiY/bZLu37OlzcQD4YSGN1dbCm/d/HreN8X5qE
         rWCjOx3EiPzTOUvQfWU4f6AawBO9bzZeChwy2v7M6Q6TYoyd4teJ1+2mFtg8tXfyNJH9
         U3meemjy/MGXNM6QWEmk4oGXtqixxonlc8n0wUZWz3mNgp6Y9Uq34sevX9zpPRKtlszA
         ApLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ZpTw3WTAoEOQKKnmdLeptRF2P2Fy9YbHeutJDGoVvc=;
        b=VRV6PGcj6bxjBFea0m+n88AxObe1JKv9A1XwGOZ3dZxqUbQ4iYKBOrsaKaWfy/0EkJ
         UidnMoa+pFy85qZXunsaQeTNA6aC/Y0Dsjmr2/T7QBo/RabXOWfgXTVZU8Ec1OiuNdWq
         hmNLOM5b8bgbh8V2epdPMbIXryVursxj6VwxGNflECvbZjxqXjzYEX+1TgDWYho6Nbkb
         Xh0AdQwOrCNrzIYH+8OzoDwRSZ+gbdqn61eelYF7sWcl50ZcY/3+HE6n87nrns3eFDUS
         0jeOqa4GvoFmYNXPVUF3UXyVsmn+5biw4riyYsINOzZW/vNsZB4YDfuPmq9INH98mktu
         AwHg==
X-Gm-Message-State: ACrzQf3nf0KRt58HJkxB1iaOsupTGBSvDSYjvlws/I+yj6nFwsp+lcWR
        jGOnI+aJBR9R+omwtmrj2mbgja4q1TpSJj9cjhtN0g==
X-Google-Smtp-Source: AMsMyM69fjgjLenLVofuWDr0iuvaEcVhBwHeqNq+PoQdDTghqNkAkz8PHUJeuADOS5GpyTgolGdRx9FRhAX2wBtD+Js=
X-Received: by 2002:a05:6512:25a4:b0:4a0:547a:b29b with SMTP id
 bf36-20020a05651225a400b004a0547ab29bmr11276088lfb.469.1665649987002; Thu, 13
 Oct 2022 01:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal>
In-Reply-To: <Y0fJ6P943FuVZ3k1@unreal>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 13 Oct 2022 10:32:55 +0200
Message-ID: <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> > Hi Leon, hi Saeed,
> >
> > We have seen crashes during server shutdown on both kernel 5.10 and
> > kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> >
> > All of the crashes point to
> >
> > 1606                         memcpy(ent->out->first.data,
> > ent->lay->out, sizeof(ent->lay->out));
> >
> > I guess, it's kind of use after free for ent buffer. I tried to reprod
> > by repeatedly reboot the testing servers, but no success  so far.
>
> My guess is that command interface is not flushed, but Moshe and me
> didn't see how it can happen.
>
>   1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
>   1207         INIT_WORK(&ent->work, cmd_work_handler);
>   1208         if (page_queue) {
>   1209                 cmd_work_handler(&ent->work);
>   1210         } else if (!queue_work(cmd->wq, &ent->work)) {
>                           ^^^^^^^ this is what is causing to the splat
>   1211                 mlx5_core_warn(dev, "failed to queue work\n");
>   1212                 err = -EALREADY;
>   1213                 goto out_free;
>   1214         }
>
> <...>
> >
> > Is this problem known, maybe already fixed?
>
> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
> Is it possible to reproduce this on latest upstream code?
I haven't been able to reproduce it, as mentioned above, I tried to
reproduce by simply reboot in loop, no luck yet.
do you have suggestions to speedup the reproduction?
Once I can reproduce, I can also try with kernel 6.0.

> And what is your FW version?
here is ibstat output
CA 'mlx5_0'
CA type: MT4119
Number of ports: 1
Firmware version: 16.27.2008
Hardware version: 0
Node GUID: 0x08c0eb030054b372
System image GUID: 0x08c0eb030054b372
Port 1:
State: Active
Physical state: LinkUp
Rate: 100
Base lid: 15
LMC: 0
SM lid: 1
Capability mask: 0x2651e848
Port GUID: 0x08c0eb030054b372
Link layer: InfiniBand
CA 'mlx5_1'
CA type: MT4119
Number of ports: 1
Firmware version: 16.27.2008
Hardware version: 0
Node GUID: 0x08c0eb030054b373
System image GUID: 0x08c0eb030054b372
Port 1:
State: Active
Physical state: LinkUp
Rate: 100
Base lid: 12
LMC: 0
SM lid: 4
Capability mask: 0x2651e848
Port GUID: 0x08c0eb030054b373
Link layer: InfiniBand


Thanks for your help!
>
>
> > I briefly checked the git, don't see anything, could you give me some hint?
> >
> >
> > Thanks!
> > Jinpu Wang @ IONOS
