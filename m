Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313D8574A29
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 12:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiGNKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 06:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiGNKK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 06:10:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 77AE54E85F
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657793425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g7jS+6/ePhfbGrbrEFBGQoeAmsGK2zeWD9uz663dq4I=;
        b=Lfc7zZwyGHti9uGZboBCRwLkcIfJdVHp3GyZvXAov5/D3p+SxKDJ1ZPi3RNUGMV5r/wR5h
        kudZ+2/p2uGvNGEuCVUG+kBR7QzpFbKbDr2Yydn6ZqywG8oMmSa0+nljKeLe8gzsOmc43K
        Z+sM0718VB3RuQ+Bs/y0q0NkhuJlick=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-iY2Sg7JkMoWo_xnDG_dNUQ-1; Thu, 14 Jul 2022 06:10:24 -0400
X-MC-Unique: iY2Sg7JkMoWo_xnDG_dNUQ-1
Received: by mail-lf1-f71.google.com with SMTP id k25-20020a195619000000b00489e6a6527eso571576lfb.8
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g7jS+6/ePhfbGrbrEFBGQoeAmsGK2zeWD9uz663dq4I=;
        b=vv7404M8lDwnlvASjHPZbY5237YPoZED84K246fPsHHQQG4SEY/IdybwwxdwgxfwvW
         ZNu6/Dup6844Ftwqvzum/G7JJGjzBMvi1/0F9vyXsiAHRaBuIlzf0y5kvEOctM7l1nGZ
         lWkPvFeUbAKyUnDNY8mtagKknWlEH+PaAAHMPR8R71JoltZB7tFg/yBcsGk1YyMsJy5A
         xyJbfz+kDA1asxwIfbj+rvWHRZazhQwaMHfALvQ7oCAAG+MAQrLosA16lv4QpEYxVz6e
         kz4PfmI7bbUgmRuUb/U+sRQ0SGoF00rtjtba/EP/GMiT0uJRbXnJaocAebr89ka4N+M4
         7rQw==
X-Gm-Message-State: AJIora/H9ptmjWTPH2VwP1Nwzb2e1xA3SBruKV+TXoddT/1eYYW36KD/
        lPSS/wZLFKkBHNBhmqXdErqemhdBwf19Ps8x/WWwbRfVW1ONsUxkf7A09CAVFc12Ut3VJp2xGWX
        8dIhZ6YQho5iRe4P+bYoTGRemmL6x4TbB
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id h21-20020a0565123c9500b0048a03d109dfmr4880414lfv.641.1657793422221;
        Thu, 14 Jul 2022 03:10:22 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOzQrWbN1I0pe1k48wduzgwFqRCgCxPc/EFrheZX3LgJneoo7JoEpDZZddGGxrWxL4pC/WtuW6739MvbeGvH8=
X-Received: by 2002:a05:6512:3c95:b0:48a:3d1:9df with SMTP id
 h21-20020a0565123c9500b0048a03d109dfmr4880402lfv.641.1657793422054; Thu, 14
 Jul 2022 03:10:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
 <20220713200203.4eb3a64e@kernel.org> <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
 <CAJs=3_BNvrJo9JCkMhL3G2TBescrLbgeD7eOx=cs+T9YOLTwLg@mail.gmail.com>
 <CACGkMEtiC1PZTjno3sF8z-_cx=1cb8Kn1kqPvQuurDbKS+UktQ@mail.gmail.com> <CAJs=3_B74L0wf-3xbAqkQ=eypmO-8FBh--QraLrzF2wkw_1Zow@mail.gmail.com>
In-Reply-To: <CAJs=3_B74L0wf-3xbAqkQ=eypmO-8FBh--QraLrzF2wkw_1Zow@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 14 Jul 2022 18:10:11 +0800
Message-ID: <CACGkMEt-KpkKHbnSdDRSSCFgK3qvWvPWRFViWUM2mggiBv0CBg@mail.gmail.com>
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 3:23 PM Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
>
> > So we use sq->napi.weight as a hint to use tx interrupt or not.
> > We need a safe switching from tx interrupt and skb_orphan(). The
> > current code guarantees this by only allowing the switching when the
> > interface is down.
> > So what I meant for the above "Update NAPI" is, consider that users
> > want to switch from tx_max_coalesced_frames from 0 to 100. This needs
> > to be down when the interface is down, since the driver need to enable
> > tx interrupt mode, otherwise the coalescing is meaningless.
> > This would be much easier if we only have tx interrupt mode, but this
> > requires more work.
>
>
> So, If I understood correctly, you're suggesting to add the following
> part to the
> "interrupt coalescing is negotiated" case:
>
> napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
> if (napi_weight ^ vi->sq[0].napi.weight) {
>    if (dev->flags & IFF_UP)
>         return -EBUSY;
>     for (i = 0; i < vi->max_queue_pairs; i++)
>         vi->sq[i].napi.weight = napi_weight;
> }
>
> Before sending the control commands to the device.
> Is this right?

I think it should be after the control commands were sent. Other looks fine.

Thanks

>

