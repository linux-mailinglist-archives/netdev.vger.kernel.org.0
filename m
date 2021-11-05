Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF90446087
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbhKEIYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:24:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:58732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhKEIYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 04:24:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636100502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eXP5U3uNsWvkcsdX8yeKebSDhuiPkgqH2wJBMCP0fuY=;
        b=UIZRi0GfuugTWvEK1CfCiDscTxU5PZBZhb8VyBkSPK0dxxe9CzlBHyQiBj4kwFiKVS8s0Y
        KUCKizgESQij6urHdc9XmSUB59WbO0LHujh2/z+TO71eXG6nwAjYC0E4FX2v0GwDFnrlIw
        tn6hJNz5LVolIk8qynhsWO7hoDtcNa8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-GvRSk8xeObOBbNIFanz_Xg-1; Fri, 05 Nov 2021 04:21:41 -0400
X-MC-Unique: GvRSk8xeObOBbNIFanz_Xg-1
Received: by mail-pj1-f69.google.com with SMTP id u11-20020a17090a4bcb00b001a6e77f7312so1506365pjl.5
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 01:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eXP5U3uNsWvkcsdX8yeKebSDhuiPkgqH2wJBMCP0fuY=;
        b=bXX/n5vqvE9aSZyUY9sOkbI66/APeBZWRGlVWYZaonBKaKRTF4Xd4zPMBTdk6LcE7k
         XaKGrpz2qkOFHIxrNLVv/gIN5/qkgZJ8OKiC+3fEw9fFNny6ogVeOtrCxzeERXjWETg6
         96MUt98OTtfhliczRKnzSQsUfYCfD+AkEibQ1D9ZPOHpEOWs416sWaQq8Ol9vpPMuG15
         vp4Xkq99z3ZPh3E5t5hbojV6TA14lFX5TB+wW9EY80LnTmyBbhcjH63TM689P29/R+ul
         4SxC1OTMD9qTeeMafgpgTIGdNJCdFYnuHsl6oCxkvIjOFXoKahq+e2pYTprpwRbo/BnH
         veVw==
X-Gm-Message-State: AOAM530Fu2N2mzWiVFTwYVFlJI9CEaepYUqogZuA2qsCHA22MPsjDWeU
        KXYLmcvcLuiM/qdmXGlR7+urJlmWaFQBjuvaWhsVIzy1rLotGf++q3ljw02Ngj/k7xnauk1cgR7
        vjlqg1TzZV3zPKxwZqGYB5uE5JK77zQgK
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr9550546pjb.36.1636100500726;
        Fri, 05 Nov 2021 01:21:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPxHxFSeu0FtL7TWnXMMqNac9cTKg8uNr7M+sgjlEIu0zdtYQ2owqSDYCgPMhpgjqVODvOrXmQUca9CHHjYAc=
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr9550531pjb.36.1636100500505;
 Fri, 05 Nov 2021 01:21:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
 <20211021123714.1125384-4-marcandre.lureau@redhat.com> <CAGxU2F4n7arHPJ3SpbpJzk1qoT1rQ57Ki3ZjeHquew+_SpRd_A@mail.gmail.com>
 <89E7CE3A-364F-4D42-8B7A-651A105524D7@vmware.com>
In-Reply-To: <89E7CE3A-364F-4D42-8B7A-651A105524D7@vmware.com>
From:   =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date:   Fri, 5 Nov 2021 12:21:29 +0400
Message-ID: <CAMxuvaxtukoYOs_7ONnH-=ANGX7Ld5aA4zQH1aOcaVPVD-ePGg@mail.gmail.com>
Subject: Re: [PATCH 03/10] vsock: owner field is specific to VMCI
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Wed, Oct 27, 2021 at 12:13 PM Jorgen Hansen <jhansen@vmware.com> wrote:
>
>
> > On 26 Oct 2021, at 13:16, Stefano Garzarella <sgarzare@redhat.com> wrot=
e:
> >
> > CCing Jorgen.
> >
> > On Thu, Oct 21, 2021 at 04:37:07PM +0400, Marc-Andr=C3=A9 Lureau wrote:
> >> This field isn't used by other transports.
> >
> > If the field is used only in the VMCI transport, maybe it's better to
> > move the field and the code in that transport.
>
> If the transport needs initialize these fields, that should happen when w=
e
> call vsock_assign_transport. So we would need to validate that
> get_current_cred() gets the right credentials and that the parent of a
> socket has an Initialised owner field at that point in time.
>
> sock_assign_transport may be called when processing an
> incoming packet when a remote connects to a listening socket,
> and in that case, the owner will be based on the parent socket.
> If the parent socket hasn=E2=80=99t been assigned a transport (and as I
> remember it, that isn=E2=80=99t the case for a listening socket), then it
> isn=E2=80=99t possible to initialize the owner field at this point using
> the value from the parent. So the initialisation of the fields
> probably have to stay in af_vsock.c as part of the generic structure.
>
> Is there a particular reason to do this change as part of this series
> of patches?

No particular reason, it was just related code.

thanks

>
> Thanks,
> Jorgen
>
> > Thanks,
> > Stefano
> >
> >>
> >> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> >> ---
> >> include/net/af_vsock.h   | 2 ++
> >> net/vmw_vsock/af_vsock.c | 6 ++++++
> >> 2 files changed, 8 insertions(+)
> >>
> >> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >> index ab207677e0a8..e626d9484bc5 100644
> >> --- a/include/net/af_vsock.h
> >> +++ b/include/net/af_vsock.h
> >> @@ -41,7 +41,9 @@ struct vsock_sock {
> >>                                       * cached peer?
> >>                                       */
> >>      u32 cached_peer;  /* Context ID of last dgram destination check. =
*/
> >> +#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
> >>      const struct cred *owner;
> >> +#endif
> >>      /* Rest are SOCK_STREAM only. */
> >>      long connect_timeout;
> >>      /* Listening socket that this came from. */
> >> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >> index e2c0cfb334d2..1925682a942a 100644
> >> --- a/net/vmw_vsock/af_vsock.c
> >> +++ b/net/vmw_vsock/af_vsock.c
> >> @@ -761,7 +761,9 @@ static struct sock *__vsock_create(struct net *net=
,
> >>      psk =3D parent ? vsock_sk(parent) : NULL;
> >>      if (parent) {
> >>              vsk->trusted =3D psk->trusted;
> >> +#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
> >>              vsk->owner =3D get_cred(psk->owner);
> >> +#endif
> >>              vsk->connect_timeout =3D psk->connect_timeout;
> >>              vsk->buffer_size =3D psk->buffer_size;
> >>              vsk->buffer_min_size =3D psk->buffer_min_size;
> >> @@ -769,7 +771,9 @@ static struct sock *__vsock_create(struct net *net=
,
> >>              security_sk_clone(parent, sk);
> >>      } else {
> >>              vsk->trusted =3D ns_capable_noaudit(&init_user_ns, CAP_NE=
T_ADMIN);
> >> +#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
> >>              vsk->owner =3D get_current_cred();
> >> +#endif
> >>              vsk->connect_timeout =3D VSOCK_DEFAULT_CONNECT_TIMEOUT;
> >>              vsk->buffer_size =3D VSOCK_DEFAULT_BUFFER_SIZE;
> >>              vsk->buffer_min_size =3D VSOCK_DEFAULT_BUFFER_MIN_SIZE;
> >> @@ -833,7 +837,9 @@ static void vsock_sk_destruct(struct sock *sk)
> >>      vsock_addr_init(&vsk->local_addr, VMADDR_CID_ANY, VMADDR_PORT_ANY=
);
> >>      vsock_addr_init(&vsk->remote_addr, VMADDR_CID_ANY, VMADDR_PORT_AN=
Y);
> >>
> >> +#if IS_ENABLED(CONFIG_VMWARE_VMCI_VSOCKETS)
> >>      put_cred(vsk->owner);
> >> +#endif
> >> }
> >>
> >> static int vsock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
> >> --
> >> 2.33.0.721.g106298f7f9
> >>
> >
>

