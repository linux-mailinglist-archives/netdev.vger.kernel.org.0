Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980F25745D3
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbiGNHXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236983AbiGNHXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:23:16 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520983057A
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:23:15 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j3so1098834pfb.6
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 00:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1PbFPH/bob6x3njzTKefKAzMkU9a+m2VS58Z6RfGAZI=;
        b=2KlOZOQF8U+jdVt/UUt3GApOgWqAlKUYFYoT9WLN7diBW0dTeHKn5BWCSU0ik53Psc
         yVAAhjNQmUtRTw3TquE073RJtJ1MWgDZSSoRQ2I+sDzfUK/3GTl23lNKHb83CsmuwnJL
         kZbs9y0jwogor6jLrrNoPVXI2QjPntjQx5XmsD0lmSOmfOEKefFvqakTtcxQsDJSpMSh
         JwiJ3zvgfFvfBhT1gAYOztrSgPOuZQViIotMaY33aA07Oq5tg6fmtUL666l9BFkug7Kk
         Gl7Oy4aYwoC+THE3+RMlZLYGhpQ5+IhyqqLWqXX926KfCe7M/z6tFphuorY4D3O/jym3
         PWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1PbFPH/bob6x3njzTKefKAzMkU9a+m2VS58Z6RfGAZI=;
        b=eqkI7FNpfTKhiTqU10Al0WCZ+Lr1QJA9T4YbLt6xIBfE/oXIll5NTX9TYukzYRvK8J
         owGrav9bPJ8Lf9pKl+d3D1B3P7oLMc+GWV4dd0TGovooT9cskC1KPsMzZ69I4OD2pEAQ
         BVofoUmFHyUMCQi6AERUYGqbiGBZnhwPbeVh2DiGlTX+WNsGni6H8p1vCwU8oJvIVIgu
         UC1qIR/RZIU8zLavis2Uj8eJz2aT1ZIjMnhIoOAV6F61oA2GSVp7obQVgV8+mTJg91Kv
         JjRCygFI+qBY8UEwFbh4rTC4VHNKrXZCKGS8lykQPYMc5NPpJuP5AmAZDmCXAYZ3bKFq
         lxZQ==
X-Gm-Message-State: AJIora83DA9pjsE74bJ5O1io6PJURoLvnnLjSZjN3RjZt6tSfO/ULRyy
        AmNae28hE+KTkAWCrKOufgLQEWYsxhcjVTd+UJX35Q==
X-Google-Smtp-Source: AGRyM1sy4YoEXG/43axQ2Da8FvUFsrNfbem9JIzxmKoK1lqlWU412ebtMdKyRXehm6lWgNja9bVFVhdIHC1VWxFuXqY=
X-Received: by 2002:a63:f043:0:b0:412:b11f:c364 with SMTP id
 s3-20020a63f043000000b00412b11fc364mr6208703pgj.289.1657783394816; Thu, 14
 Jul 2022 00:23:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
 <20220713200203.4eb3a64e@kernel.org> <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
 <CAJs=3_BNvrJo9JCkMhL3G2TBescrLbgeD7eOx=cs+T9YOLTwLg@mail.gmail.com> <CACGkMEtiC1PZTjno3sF8z-_cx=1cb8Kn1kqPvQuurDbKS+UktQ@mail.gmail.com>
In-Reply-To: <CACGkMEtiC1PZTjno3sF8z-_cx=1cb8Kn1kqPvQuurDbKS+UktQ@mail.gmail.com>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Thu, 14 Jul 2022 10:22:39 +0300
Message-ID: <CAJs=3_B74L0wf-3xbAqkQ=eypmO-8FBh--QraLrzF2wkw_1Zow@mail.gmail.com>
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So we use sq->napi.weight as a hint to use tx interrupt or not.
> We need a safe switching from tx interrupt and skb_orphan(). The
> current code guarantees this by only allowing the switching when the
> interface is down.
> So what I meant for the above "Update NAPI" is, consider that users
> want to switch from tx_max_coalesced_frames from 0 to 100. This needs
> to be down when the interface is down, since the driver need to enable
> tx interrupt mode, otherwise the coalescing is meaningless.
> This would be much easier if we only have tx interrupt mode, but this
> requires more work.


So, If I understood correctly, you're suggesting to add the following
part to the
"interrupt coalescing is negotiated" case:

napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
if (napi_weight ^ vi->sq[0].napi.weight) {
   if (dev->flags & IFF_UP)
        return -EBUSY;
    for (i = 0; i < vi->max_queue_pairs; i++)
        vi->sq[i].napi.weight = napi_weight;
}

Before sending the control commands to the device.
Is this right?
