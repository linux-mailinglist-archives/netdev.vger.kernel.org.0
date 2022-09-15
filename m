Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEADF5B93E7
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 07:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIOFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiIOFUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 01:20:20 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F80D760D0
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 22:20:19 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b75so11714432pfb.7
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 22:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OzGu+lEBtit1jaOhWWlw6AVPAPYnWE/5tgCcmWrUquI=;
        b=bj5OrTMgZuf9Dpwe1VCStyREaSavWB+M6uM1C5HvINjTEhzKcNXoAHnWFztkj7pIjr
         wk4O+BZ6EpHFAj4FjF8+HVGhV/DESvLt2C+ZdODuEr+O+A3GGwem0i26gNFMJUg2dxhF
         hjlcFQkKmVO0yufevoshiOoPCn7lX7yCwFz6sdVhfqGcIUbo13GngbtM/Kj1KiqWuT8K
         IbkQZSyc39i2SzTCMLDyFRKXl3Bv/Gz94SlQQWpkniryUIVLgUeYRhySig5W32xgWMjd
         FfthbTifKehqoO8ZGZ3ZDAY2r4J3NM1KsgY+igYDAkVAZr/CgRtkkl/15cvMJHDV345A
         8KOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OzGu+lEBtit1jaOhWWlw6AVPAPYnWE/5tgCcmWrUquI=;
        b=2ZEqRPfE9FRXJvCjWQInYmAnOSuk6aAp8EaiiLqMpk8S9O7G0Jx2jQQqra6ngvNUMN
         iOJkpVmHHhvGQcP5bsMmMbcFFpisPUWUtuHPsmA71iaA+j7lL0N7bct6RwTQEiIo5M+g
         MIiI32FMGOhKuMb2S2w4UBwBDCV9E2a6lVaILD81H4YgBKopHKIVsgYqFLyF21UMcX64
         fX36/PmTT8iUblMPd7FOFh/a9JE41G9y2QLHVwb9NACMdSwaxa1OVrS14ouAOVC7/MVA
         RbwWFYqE6ktkNL60XGkdW+ui0MM9ypflGw78sZZySojyY+wG8RgNKzLq32dv9QSjmlcC
         KWGQ==
X-Gm-Message-State: ACgBeo0/9aWsafC51K1gEo7aJ3gND5lJZxsY6FNMBGgWzK8wyOJtKxdJ
        hsixfMnNL8iv7qleGuajCp5+/TMOB8pLw7Tvdtk=
X-Google-Smtp-Source: AA6agR4uTNqUjD4XHYi9pnUr6zH+ibuCSJin6qeY+me1RklDL5NpKj2BUh4/GM/IEovqwQ0pgJd2Xf/Oz1i0HTU5qp4=
X-Received: by 2002:a65:5688:0:b0:3c2:1015:988e with SMTP id
 v8-20020a655688000000b003c21015988emr34839540pgs.280.1663219218991; Wed, 14
 Sep 2022 22:20:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220906052129.104507-1-saeed@kernel.org> <20220906052129.104507-8-saeed@kernel.org>
 <CALHRZuq962PeU0OJ0pLrnW=tkaBd8T+iFSkT3mfWr2ArYKdO8A@mail.gmail.com>
 <20220914203849.fn45bvuem2l3ppqq@sx1> <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
In-Reply-To: <CALHRZup8+nSNoD_=wSKGym3=EPMKoU+1UxbVReOv8xnBnTeRiw@mail.gmail.com>
From:   sundeep subbaraya <sundeep.lkml@gmail.com>
Date:   Thu, 15 Sep 2022 10:50:05 +0530
Message-ID: <CALHRZuqKjpr+u237dtE3+0b4mQrJKxDLhA=SKbiNjd0Fo5h1Nw@mail.gmail.com>
Subject: Re: [PATCH net-next V2 07/17] net/mlx5: Add MACsec offload Tx command support
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>, liorna@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>, naveenm@marvell.com,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>, atenart@kernel.org
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

+ atenart@kernel.org


On Thu, Sep 15, 2022 at 10:44 AM sundeep subbaraya
<sundeep.lkml@gmail.com> wrote:
>
> On Thu, Sep 15, 2022 at 2:08 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
> >
> > On 14 Sep 20:09, sundeep subbaraya wrote:
> > >Hi Saeed and Lior,
> > >
> > >Your mdo_ops can fail in the commit phase and do not validate input
> > >params in the prepare phase.
> > >Is that okay? I am developing MACSEC offload driver for Marvell CN10K
> >
> > It's ok since i think there is no reason to have the two steps system ! it
> > doesn't make any sense to me ! prepare and commit are invoked consecutively
> > one after the other for all mdo_ops and in every offload flow, with no extra
> > step in between! so it's totally redundant.
> >
> > when i reviewed the series initially i was hesitant to check params
> > on prepare step but i didn't see any reason since commit can still fail in
> > the firmware anyways and there is nothing we can do about it !
>
> Yes, same with us where messages sent to the AF driver can fail in the
> commit phase.
>
> > so we've decide to keep all the flows in one context for better readability
> > and since the prepare/commit phases are confusing.
> >
> Okay. I will do the whole init in the prepare phase only and return 0
> in the commit phase.
>
> > >and I had to write some clever code
> > >to honour that :). Please someone help me understand why two phase
> > >init was needed for offloading.
> > >
> >
> > I don't know, let's ask the original author, Antoine ?
> > CC: Antoine Tenart <atenart@kernel.org>
>
> Thanks. I added antoine.tenart@bootlin.com in my previous mail but bounced back.
>
> Sundeep
> >
> >
