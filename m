Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36A360DD0B
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbiJZI2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiJZI2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:28:46 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4028CC4DA4
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:28:45 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id j21so10001781qkk.9
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MLSwOWFY8u6E5fLHUkZmlThgK4Uo0S+g5manfostVQc=;
        b=XAeQFLugcon26no+DfmTPEV+PN8pOrRxNSy3aO2qp4Py8CVjyzlVTGflPAruI7kNLz
         eR2p/8GfFeZB+zd7NrpLCLAhkDL0zobCJAECug7+u2tI09f806IGtwLbR//SpCe2WbB/
         TyZ6FGQAY95ScGkWqjyo4FRx4JJwLynCa7f/9HIeiGe87mH0CHI2OroFs/ui5uAYFYWS
         MvNDWQS7G+1ZEInGJDg2RLEB5DB3cEIZBsp7bqqvEMY+xa3QGAQriYQUX4QVSxnmnTK3
         ng2a4hpcgtrg7AiE/Xn5Mts5piMZ2uiydOPi5N2wt5CBusN40OkNWRomaG12VrMS62dH
         UmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MLSwOWFY8u6E5fLHUkZmlThgK4Uo0S+g5manfostVQc=;
        b=7eFhNfp8lEQU12wNHUH4goqjL2KEi0jNsMH0RSfg9HAUPiAvzWKI1JxB3iB91lFQXH
         PAKvCgxByemFa3YlS9vY7YthJLCm451tujFtiqI1wnpGDs6DribBK8aT8ok0BI+6NSGP
         xjNt1Ht63C1j95g/SUtwJISDBsjY3tmq2YoFYDuaiHjfbiQgKLH8iQ65yg5o0JxzhJxy
         eL70A2CjRdAeMT1Ou+dBKTDw6RSibIU/j11kEVoNuDPRyMBr9I7PQvGdAPBt6Of3wq9+
         XaazvmgqkhQsxdo3HbmGN0eUrxWpuEAgDZkJWz/nwhAtCNI4IuNsqgmlkC1qug9yttEk
         /qnQ==
X-Gm-Message-State: ACrzQf38HKJrPsM784vZE4K1Xay+uQ4cXr6+Lig3NWb+5uKVrgynavw7
        kpBoOLKpJZmB1gRiHHY9KAY8Og+2wfphjvZBdr8=
X-Google-Smtp-Source: AMsMyM7Jw8Jfuk6f78c6WHth+TCmxkqeF/ei8KTlOn3wA3MlETNwu9z1dGxbXsXlqwDN4B4aHkvJSgXzHXTGKTpuC6c=
X-Received: by 2002:a05:620a:f11:b0:6cf:be4e:e953 with SMTP id
 v17-20020a05620a0f1100b006cfbe4ee953mr29846206qkl.437.1666772924405; Wed, 26
 Oct 2022 01:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221025135958.6242-1-aaptel@nvidia.com> <20221025160039.GA26372@lst.de>
In-Reply-To: <20221025160039.GA26372@lst.de>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 26 Oct 2022 11:28:35 +0300
Message-ID: <CAJ3xEMiwkNsqOJy-0m9r3MNn+x-To00Pi7a4TifSJYPJbv=pYQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/23] nvme-tcp receive offloads
To:     Christoph Hellwig <hch@lst.de>
Cc:     Aurelien Aptel <aaptel@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 25, 2022 at 7:04 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Tue, Oct 25, 2022 at 04:59:35PM +0300, Aurelien Aptel wrote:
> > The feature will also be presented in netdev this week
> > https://netdevconf.info/0x16/session.html?NVMeTCP-Offload-%E2%80%93-Implementation-and-Performance-Gains
>
> That seems to miss slides.

to be presented on Friday this week.. AFAIK slides are uploaded little later

The design/principles were presented last year
https://netdevconf.info/0x15/session.html?Autonomous-NVMe-TCP-offload
