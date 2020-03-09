Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D8C17DDE3
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 11:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgCIKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 06:48:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34743 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIKsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 06:48:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id z15so10435019wrl.1
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 03:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QDtfNY0PtHAEuqCxAZYt1IpZOfYRa1Dm9r/IK3jLViM=;
        b=h6RCjfKOW6CQrHIT4su6O5wA/EVLqBCvaJhdE/bZFIZ91dOgWvfrm+AiAorgjwTfiZ
         YqH2UGwJ1HNsYBnyllUsOl5PHSe8b4TOw0qh03foPQ1OemQqlMq9ePpkPQtpvAsf8ekK
         nVW0G2akAF17plOBwHmZ+Hy7wbRmbOGCo0U4Z9I343jdT1ui/fwYceeFQAnBIZqetiGV
         FH4v7wi0Ci8d3xn5LF8QVZFwVz+foLiP6kcU89fd9U4sPNVmJI1F7irUhwgROfnPWLrc
         tJNGciW9CsqppS4RaGVJgpyQUe6LjMFWZWraGGcBj5ARHZ8ewOY5A5UoYz59QwvQlfy4
         +aqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QDtfNY0PtHAEuqCxAZYt1IpZOfYRa1Dm9r/IK3jLViM=;
        b=eu4nnxfZ/AK/vplr0/FPhnKS3LhsfQv0pmxL/GvycDE1Zt9pu309GoDymhCbR2AL3m
         QIF4zn3awwaLuvSZsDkmiI6O098RiUc2Y4NZoLqsDOZPgDTbyrin62BgTor7A/z+kErs
         ytKkNGOZKZFk+o866r2PVTWpzcio6zHgIY5emt1tocYDSrljkuj5yxSgj3QVhqzO0IpP
         pEE6ilpZAA4vqOPCQNwaKcWOqB6Z+Rsr+4/rPe6owwTWhKanmo9f29NA/aJyEn8RcaRr
         XldnV5PWYGXBIUEhDJxZUtzbXFCfEOIWTjMsveX4GYTUGd0c9iiK7zrHrr1ZdGpC13uL
         QxBw==
X-Gm-Message-State: ANhLgQ1pVCXKU3wo7g3YMYmkss3auvk+qOeoeAChl9lIVzindFhycz5r
        pn4mPOof1XdLqRT411DJf4Ld/VDmLzsmVzpvg0pF7dnJ
X-Google-Smtp-Source: ADFU+vvcduqVWXImN9jCW1idt2snqnIKeRknJUJz1NgOzwWw9QagldgBcOZ0kpGC3ay/HvP5eTBWotdb8M90V7hmRRo=
X-Received: by 2002:adf:9d8b:: with SMTP id p11mr10480648wre.270.1583750888344;
 Mon, 09 Mar 2020 03:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
 <37097209-97cd-f275-cbe2-6c83f5580b80@nextfour.com>
In-Reply-To: <37097209-97cd-f275-cbe2-6c83f5580b80@nextfour.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 9 Mar 2020 18:50:19 +0800
Message-ID: <CADvbK_dqRXr3D1WgLDXqiBhpyw+QGRrvwugqDhOMr_kpQVi3QA@mail.gmail.com>
Subject: Re: [PATCH ipsec] esp: remove the skb from the chain when it's
 enqueued in cryptd_wq
To:     =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 6:07 PM Mika Penttil=C3=A4 <mika.penttila@nextfour.c=
om> wrote:
>
>
> Hi!
>
> On 4.3.2020 10.51, Xin Long wrote:
> > Xiumei found a panic in esp offload:
> >
> >   BUG: unable to handle kernel NULL pointer dereference at 000000000000=
0020
> >   RIP: 0010:esp_output_done+0x101/0x160 [esp4]
> >   Call Trace:
> >    ? esp_output+0x180/0x180 [esp4]
> >    cryptd_aead_crypt+0x4c/0x90
> >    cryptd_queue_worker+0x6e/0xa0
> >    process_one_work+0x1a7/0x3b0
> >    worker_thread+0x30/0x390
> >    ? create_worker+0x1a0/0x1a0
> >    kthread+0x112/0x130
> >    ? kthread_flush_work_fn+0x10/0x10
> >    ret_from_fork+0x35/0x40
> >
> > It was caused by that skb secpath is used in esp_output_done() after it=
's
> > been released elsewhere.
> >
> > The tx path for esp offload is:
> >
> >   __dev_queue_xmit()->
> >     validate_xmit_skb_list()->
> >       validate_xmit_xfrm()->
> >         esp_xmit()->
> >           esp_output_tail()->
> >             aead_request_set_callback(esp_output_done) <--[1]
> >             crypto_aead_encrypt()  <--[2]
> >
> > In [1], .callback is set, and in [2] it will trigger the worker schedul=
e,
> > later on a kernel thread will call .callback(esp_output_done), as the c=
all
> > trace shows.
> >
> > But in validate_xmit_xfrm():
> >
> >   skb_list_walk_safe(skb, skb2, nskb) {
> >     ...
> >     err =3D x->type_offload->xmit(x, skb2, esp_features);  [esp_xmit]
> >     ...
> >   }
> >
> > When the err is -EINPROGRESS, which means this skb2 will be enqueued an=
d
> > later gets encrypted and sent out by .callback later in a kernel thread=
,
> > skb2 should be removed fromt skb chain. Otherwise, it will get processe=
d
> > again outside validate_xmit_xfrm(), which could release skb secpath, an=
d
> > cause the panic above.
> >
> > This patch is to remove the skb from the chain when it's enqueued in
> > cryptd_wq. While at it, remove the unnecessary 'if (!skb)' check.
> >
> > Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for=
 GRO packets.")
> > Reported-by: Xiumei Mu <xmu@redhat.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/xfrm/xfrm_device.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> > index 3231ec6..e2db468 100644
> > --- a/net/xfrm/xfrm_device.c
> > +++ b/net/xfrm/xfrm_device.c
> > @@ -78,8 +78,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *sk=
b, netdev_features_t featur
> >       int err;
> >       unsigned long flags;
> >       struct xfrm_state *x;
> > -     struct sk_buff *skb2, *nskb;
> >       struct softnet_data *sd;
> > +     struct sk_buff *skb2, *nskb, *pskb =3D NULL;
> >       netdev_features_t esp_features =3D features;
> >       struct xfrm_offload *xo =3D xfrm_offload(skb);
> >       struct sec_path *sp;
> > @@ -168,14 +168,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff=
 *skb, netdev_features_t featur
> >               } else {
> >                       if (skb =3D=3D skb2)
> >                               skb =3D nskb;
> > -
> > -                     if (!skb)
> > -                             return NULL;
> > +                     else
> > +                             pskb->next =3D nskb;
>
> pskb can be NULL on the first round?
On the 1st round, skb =3D=3D skb2.

>
>
>
> >                       continue;
> >               }
> >
> >               skb_push(skb2, skb2->data - skb_mac_header(skb2));
> > +             pskb =3D skb2;
> >       }
> >
> >       return skb;
>
