Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E86F1029
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 04:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344786AbjD1CAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 22:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344782AbjD1CA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 22:00:29 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D173C0D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:00:27 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-4404c674cefso3132037e0c.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 19:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=igel-co-jp.20221208.gappssmtp.com; s=20221208; t=1682647227; x=1685239227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gl4UcZhexIohjefd4ELF83XHOyhrEBsBVG6iR4uVgNM=;
        b=ABdw2dWYlDukm9J5D/DtEXqh1ZkOJzYRX/FH3TiKebIZ/Knwom7xTvnBcM6RBDtyBv
         /o+AGSG3yYgkFJohuBV0zBLSCW5wVo4W4ABLqmMLaj7npr2oeW7zXXDTNnmQtW1zW97c
         Xy7n3edElkqWMvaiYaCXQFZ0GwX7I55GYirDnbpn/u4FF1oBrUtk+VPn7xh0xlk2Si0Z
         +XDaJBe1wKBcAOkXuW8yvtyYdvYNaJCTqICXqUTnIxh9c8hXe+G4aDeTWYJif2kXaLYX
         622PYWOoA0S1Z1jyQ9xHyjU1Ru4af3D3Hd8TyEgTObKCimt9ltptfWqv+jCe0BTHxVZ0
         SgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682647227; x=1685239227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gl4UcZhexIohjefd4ELF83XHOyhrEBsBVG6iR4uVgNM=;
        b=TiLWVGn/HoJVXLw9t1MqNgqreJMROdZGnzKcT6/1ymGeURKm8vRKCF8E55SVtImMIR
         potlkKDLwh2XilM9pJkaJ/1Rte1s40AWpEVXeUjpn/vhCWy9w19bDKYK6NQByyvSycS3
         xO5SJvUxyYMvIC5dhAKtyZDoJoxTejoKgcOqpafv5uA/hrf8ffFOWYHwhNRGbyfZsWbt
         FFEZHgfmya/+Kvq0yS/4ZkdtxSfd7WOtuViEaAhvsVE5bF5QMAhQgnq1spZCJFU7b964
         VUmoO1F1pxy6I2ci91dcCkFBPQ/Jf/Yppswi/ty2gv7l3X/Vc1weXoCd38Eqe9GijahT
         89pQ==
X-Gm-Message-State: AC+VfDwsRv+tBjYFn/4LaU/rlcgSGSN7Hjsh1PtkGWFxI7vtLLkW9EQV
        KCktF3A6pQIkNSHN5J/oHXfs2GIffPfzmfoBhmCTrw==
X-Google-Smtp-Source: ACHHUZ6bXAHX3os0g+edZnDMBXePIfbnxThJdyz0sgMrCWX55u39Ow0FXGJjamRkioyW0WH1Feggfua5iFpnPLCBbuM=
X-Received: by 2002:a1f:3f43:0:b0:443:9b17:72e9 with SMTP id
 m64-20020a1f3f43000000b004439b1772e9mr1396826vka.12.1682647227075; Thu, 27
 Apr 2023 19:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230425102250.3847395-1-mie@igel.co.jp> <ZEl5yKYzsw/g+tQh@corigine.com>
In-Reply-To: <ZEl5yKYzsw/g+tQh@corigine.com>
From:   Shunsuke Mie <mie@igel.co.jp>
Date:   Fri, 28 Apr 2023 11:00:16 +0900
Message-ID: <CANXvt5pjEau8_h7x_2kx9E79Dsc4g1ohnof5fo5QHL=KR261AA@mail.gmail.com>
Subject: Re: [PATCH v3] vringh: IOMEM support
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon-san,

2023=E5=B9=B44=E6=9C=8827=E6=97=A5(=E6=9C=A8) 4:21 Simon Horman <simon.horm=
an@corigine.com>:
>
> On Tue, Apr 25, 2023 at 07:22:50PM +0900, Shunsuke Mie wrote:
> > Introduce a new memory accessor for vringh. It is able to use vringh to
> > virtio rings located on io-memory region.
> >
> > Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
>
> ...
>
> Hi Mie-san,
>
> thanks for your patch.
> One small nit from me below.
>
> > diff --git a/include/linux/vringh.h b/include/linux/vringh.h
> > index c3a8117dabe8..c03d045f7f3f 100644
> > --- a/include/linux/vringh.h
> > +++ b/include/linux/vringh.h
> > @@ -330,4 +330,37 @@ int vringh_need_notify_iotlb(struct vringh *vrh);
> >
> >  #endif /* CONFIG_VHOST_IOTLB */
> >
> > +#if IS_REACHABLE(CONFIG_VHOST_RING_IOMEM)
> > +
> > +int vringh_init_iomem(struct vringh *vrh, u64 features,
> > +                   unsigned int num, bool weak_barriers,
> > +                   struct vring_desc *desc,
> > +                   struct vring_avail *avail,
> > +                   struct vring_used *used);
> > +
> > +
>
> nit: one blank line is enough.
It should not have included this patch. Thanks.
> > +int vringh_getdesc_iomem(struct vringh *vrh,
> > +                      struct vringh_kiov *riov,
> > +                      struct vringh_kiov *wiov,
> > +                      u16 *head,
> > +                      gfp_t gfp);
>
> ...
