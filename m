Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE8D6EA463
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjDUHMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjDUHML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE781FEE
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682061085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Hel2lvkUNp3cy9BYWMzYJ5GhkmTlSKb52dwGchz6iE=;
        b=XvdrBRZRrE+wIjMfm07i5aHzqdEWFzRX6NsCaHyBhSQjt485YiCiJQZ9UtpEOyz3npZijD
        6sPqJ6m5wtMqagBH/ZJC/M4LyyQC4r1wCnDQO2MGDqyit29ENGbsDDhj3Lq3S0grx14IPD
        VJXySAZ2u4SzPwBJu3RyEXLXz3FS84g=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-x-Q8Pxb4OledCtqph_ehug-1; Fri, 21 Apr 2023 03:11:23 -0400
X-MC-Unique: x-Q8Pxb4OledCtqph_ehug-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-38be23b9905so1376363b6e.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682061083; x=1684653083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Hel2lvkUNp3cy9BYWMzYJ5GhkmTlSKb52dwGchz6iE=;
        b=VEwH9+NbKGFUqxQPxoYwxfd3v4zkiCiEVEU022qKwutFCfxK10MsnTCkKh5e6DG3/l
         xuAIDXXQB62T5RQVMt404INvoRbfjuW/aKjTKBi/CATnFsnb92u1KlFWh65SKKdCUQxp
         RSXXVBn+1ARdL0ywSHubM1DDijhRCvqE6wJtMReCgbmbsrTas7pJmjHqBGLMgve8Zooy
         D2pY8KXWYSzBHl+gG/njZxdx0RpMT3epglXEoAZS+jvwVP8oJVX/bSIrR2FiJCMLr443
         XwAPJr60nU3ZveFD1yQfNUUFfleoLt0tGITljzR66UBSUOg7LlzOcIW3mGTlOQ85W+Yc
         LrOg==
X-Gm-Message-State: AAQBX9dD759wcTscO62FHoHOHrGKUKq4qySkC5mnRVN8cubHSC5q/1P0
        Nu1FQP79Um+T4qGlEyMztMQMLRnZFPRFMxZo/8Q1t7o2yWrkGuWU0kJ+xpPNfvOZ7N9YeGRYudq
        xE6vsORUPQlDE8/Y/pxLe/+3p1FYvc0VL
X-Received: by 2002:aca:100d:0:b0:38e:1ee1:982 with SMTP id 13-20020aca100d000000b0038e1ee10982mr2391092oiq.7.1682061082567;
        Fri, 21 Apr 2023 00:11:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZdspLDBkX4UR5Dt85qLMuFsxfyjUCXK87ZmqnGFhfDDXACeESMDThi+Q9XtnTMnXrA9rajHiS8urkCLXJBtO0=
X-Received: by 2002:aca:100d:0:b0:38e:1ee1:982 with SMTP id
 13-20020aca100d000000b0038e1ee10982mr2391079oiq.7.1682061082091; Fri, 21 Apr
 2023 00:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20221123102207.451527-1-asmetanin@yandex-team.ru>
 <CACGkMEs3gdcQ5_PkYmz2eV-kFodZnnPPhvyRCyLXBYYdfHtNjw@mail.gmail.com> <20230421030345-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230421030345-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 21 Apr 2023 15:11:11 +0800
Message-ID: <CACGkMEujFHDR4NCxtBm5DyE_H=xkZA_YnH-p0SNiwbWQFPa_bg@mail.gmail.com>
Subject: Re: [PATCH] vhost_net: revert upend_idx only on retriable error
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Andrey Smetanin <asmetanin@yandex-team.ru>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 3:04=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Dec 01, 2022 at 05:01:58PM +0800, Jason Wang wrote:
> > On Wed, Nov 23, 2022 at 6:24 PM Andrey Smetanin
> > <asmetanin@yandex-team.ru> wrote:
> > >
> > > Fix possible virtqueue used buffers leak and corresponding stuck
> > > in case of temporary -EIO from sendmsg() which is produced by
> > > tun driver while backend device is not up.
> > >
> > > In case of no-retriable error and zcopy do not revert upend_idx
> > > to pass packet data (that is update used_idx in corresponding
> > > vhost_zerocopy_signal_used()) as if packet data has been
> > > transferred successfully.
> >
> > Should we mark head.len as VHOST_DMA_DONE_LEN in this case?
> >
> > Thanks
>
> Jason do you want to take over this work? It's been stuck
> in my inbox for a while.

Andrey,

Any update on this patch?

Btw, if we haven't heard from Andrey for a week, I can do that.

Thanks

>
> > >
> > > Signed-off-by: Andrey Smetanin <asmetanin@yandex-team.ru>
> > > ---
> > >  drivers/vhost/net.c | 9 ++++++---
> > >  1 file changed, 6 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > > index 20265393aee7..93e9166039b9 100644
> > > --- a/drivers/vhost/net.c
> > > +++ b/drivers/vhost/net.c
> > > @@ -934,13 +934,16 @@ static void handle_tx_zerocopy(struct vhost_net=
 *net, struct socket *sock)
> > >
> > >                 err =3D sock->ops->sendmsg(sock, &msg, len);
> > >                 if (unlikely(err < 0)) {
> > > +                       bool retry =3D err =3D=3D -EAGAIN || err =3D=
=3D -ENOMEM || err =3D=3D -ENOBUFS;
> > > +
> > >                         if (zcopy_used) {
> > >                                 if (vq->heads[ubuf->desc].len =3D=3D =
VHOST_DMA_IN_PROGRESS)
> > >                                         vhost_net_ubuf_put(ubufs);
> > > -                               nvq->upend_idx =3D ((unsigned)nvq->up=
end_idx - 1)
> > > -                                       % UIO_MAXIOV;
> > > +                               if (retry)
> > > +                                       nvq->upend_idx =3D ((unsigned=
)nvq->upend_idx - 1)
> > > +                                               % UIO_MAXIOV;
> > >                         }
> > > -                       if (err =3D=3D -EAGAIN || err =3D=3D -ENOMEM =
|| err =3D=3D -ENOBUFS) {
> > > +                       if (retry) {
> > >                                 vhost_discard_vq_desc(vq, 1);
> > >                                 vhost_net_enable_vq(net, vq);
> > >                                 break;
> > > --
> > > 2.25.1
> > >
>

