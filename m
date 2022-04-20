Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE4508902
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345616AbiDTNQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240898AbiDTNQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:16:19 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA73C3A196
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:13:31 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id hh4so883449qtb.10
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBpAB6FDbZK4zE5ed/nvxGtuXnn9kJ3DTB27o6boGrA=;
        b=AAoC49XgCBYwRBkrug5A93BfpSzwnQ2QHz5ADG0+GiiOROP4ryHDBT40BHJNx2DRpi
         FPmkM0rFi1kUDUbBXKJhLI7gvWIldjfT17sU38UFTuvGNbd7GA5M/2ALIFsEsFAOEtRW
         92RZAMOukvGoszrxxXrmOkNmN0wvR+/Lt2gNi/AXvuncfrNvsa9cUmIrMOfxDG8Us3yF
         EMJiC0i+yiO9+yJGF5Agf2+WPmqwpbybOCwxnjhl/wBmM9zEKyyeZ/IW4oeflKm2R06p
         J93ryrZQVS/iPlo51erMrOY3R252amSBMiCEYwHi409wR8BYTd7kM8qbBi9uf9azmNvR
         MSqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBpAB6FDbZK4zE5ed/nvxGtuXnn9kJ3DTB27o6boGrA=;
        b=MnSeQOU7rbQzhssoD7EG7BRV0iwjiztCllw5I4Vm5EjeUxkfpquizKLthpGQueNy8N
         oI/E3sx5s7fAwFhQ5BIq3ZQ/3HLEq+GwM+tLNyqAzDYkC1CQx5cAB8vkEj7+HqYN7Tos
         DD1hAQxJcM8Bqvr8HzjEw3vX80uE21m2H/oBaJ9grR+SHKm1J99M+EV6b4QyuGMVM2Rq
         tNS+3pOmiAvXZqFLzeRQZXU6X6nqluXqDLeQwb3CKDu0DUJ/d7X1Nzra/OYZVNkl3mmG
         rlR+WfqPfGyMBTluiCnCa5C0a7j7hsBuP6/d0Uh8iu5nLZ01up3fkRz5dxhM8Fq4kKGk
         98Nw==
X-Gm-Message-State: AOAM531/LdPh/Xh4WncIVn4xFpC91JbcqR1xTJXahMV/2CQ7gj0dF7CO
        gCjxc1Yq1LoVtU+ODPROD3/Tzfxp++o=
X-Google-Smtp-Source: ABdhPJzfJoWz1bAmZwm11k66KgoQlpF+f6G/IlosLxIx72XIAIC8B7hoHmVE+lFynM9gP/as0SMu+g==
X-Received: by 2002:a05:622a:30a:b0:2f2:4a5:59b1 with SMTP id q10-20020a05622a030a00b002f204a559b1mr8187053qtw.546.1650460410995;
        Wed, 20 Apr 2022 06:13:30 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id g4-20020ac87d04000000b002e06b4674a1sm1757336qtb.61.2022.04.20.06.13.30
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:13:30 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id x200so2730812ybe.13
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 06:13:30 -0700 (PDT)
X-Received: by 2002:a05:6902:1202:b0:641:e3c5:f989 with SMTP id
 s2-20020a056902120200b00641e3c5f989mr19463989ybu.532.1650460409740; Wed, 20
 Apr 2022 06:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220418044339.127545-1-liuhangbin@gmail.com> <20220418044339.127545-3-liuhangbin@gmail.com>
 <CA+FuTSdTbpYGJo6ec2Ti+djXCj=gBAQpv9ZVaTtaJA-QUNNgYQ@mail.gmail.com>
 <Yl4pG8MN7jxVybPB@Laptop-X1> <CA+FuTSdLGUgbkP3U+zmqoFzrewnUUN3pci8q8oNfHzo11ZhRZg@mail.gmail.com>
 <Yl9d2L39BzUiLINN@Laptop-X1>
In-Reply-To: <Yl9d2L39BzUiLINN@Laptop-X1>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 20 Apr 2022 09:12:53 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdrramQiwoUQ7bn+US+CDFWXKr8-Bzb8X1JzJbyMNcK8A@mail.gmail.com>
Message-ID: <CA+FuTSdrramQiwoUQ7bn+US+CDFWXKr8-Bzb8X1JzJbyMNcK8A@mail.gmail.com>
Subject: Re: [PATCH net 2/2] virtio_net: check L3 protocol for VLAN packets
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Mike Pattrick <mpattric@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        virtualization@lists.linux-foundation.org,
        Balazs Nemeth <bnemeth@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 9:16 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> Hi Willem,
>
> On Tue, Apr 19, 2022 at 09:52:46AM -0400, Willem de Bruijn wrote:
> > Segmentation offload requires checksum offload. Packets that request
>
> OK, makes sense.
>
> > GSO but not NEEDS_CSUM are an aberration. We had to go out of our way
> > to handle them because the original implementation did not explicitly
> > flag and drop these. But we should not extend that to new types.
>
> So do you mean, the current gso types are enough, we should not extend to
> handle VLAN headers if no NEEDS_CSUM flag. This patch can be dropped, right?

That's right.

> Although I don't understand why we should not extend to support VLAN GSO.
> I'm OK if you think this patch should be dropped when I re-post patch 1/2 to
> net-next.
>
> Thanks
> Hangbin
