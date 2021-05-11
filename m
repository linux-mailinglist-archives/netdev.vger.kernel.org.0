Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64A937A234
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhEKIfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbhEKIfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:35:19 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FE5C06175F
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:34:12 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id q7-20020a9d57870000b02902a5c2bd8c17so16864830oth.5
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wgdPV/AcewZdrV8IdLTwGyLrFumxsFWQvFFQfDf0wVQ=;
        b=0ZapcwACbS75HaNUVIMJA2nF3TdzK7yHK93AEsDFWQj8EPz+9cmwgw80lvA1lgAEcQ
         uz/w0p69/JLKKlrFul/W9WeNdp8+jOwBZg2fofcQkFW61UPtzJvJ6gvbq69u/kBAquis
         kkgdUMlLxWCwi3BvPFR7IUQn9zq0xmg0bVmILplyvwK/wfPbwPqlmjJeWI9Eko1doGGi
         FQWXi7kHsmCKdsmfuA+BBVIHnQXevwiPUdnh+rcK2HqBBC387AtQ519eZkHJ0SsnceXB
         Yd3siNFoRrVgjmFLca5F43CEhd/Qe8uE1M9/C1PkehqGJTLCCUm2OQX0W3w6auokH3Nm
         CFxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wgdPV/AcewZdrV8IdLTwGyLrFumxsFWQvFFQfDf0wVQ=;
        b=nCfSLLz7PyLQwXlVv660UrFVOCBuRPwZZiUEBU9Rble0PLdYhZFLgOM7bD7s7GDoTW
         UPG8aH/vVQKZb8y2aadNueurzKTSHjezsxAkeZ2gGxM0TY0VLjhJ9UNp+T/GSApyXTMY
         S5FOk22WoSrFEp1O4C2yfYuWG7hJCzXITUAVYCDoAn1ml/YZa8y0tXO7BpMxq79TzAKe
         L3f4ApQJ0oOybmAvxvfIdTHwZ+YXfSo78j0g1BQGZkyFWr/d2VumP7pdciyUF0cA/Pgq
         qPK4jKjaktcYfhdlCKbG0bBsfzL4xoMcHGtzLhk7rFnmGjjThmdQ1GsbeV41XghmVN4/
         6aDQ==
X-Gm-Message-State: AOAM531S+RuwmtyESDRn4zGDnMoO+rJ8hSTF5tK8rLRs7hv7DoH/Hubt
        qJ+9eIlqRSzez5D5pjAZXr6HBKdarvfltB22OqGzkQ==
X-Google-Smtp-Source: ABdhPJzVt5nVC9XjXq5gIom64lU88TpjNEqpB89DApWc6nOZvte02Xy9S4mlekR3eFeF5u5HlWWwHuHrS+XxZjZHixU=
X-Received: by 2002:a05:6830:4103:: with SMTP id w3mr20719290ott.27.1620722051869;
 Tue, 11 May 2021 01:34:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-5-yuri.benditovich@daynix.com> <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
In-Reply-To: <eb8c4984-f0cc-74ee-537f-fc60deaaaa73@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 11 May 2021 11:33:59 +0300
Message-ID: <CAOEp5OdrCDPx4ijLcEOm=Wxma6hc=nyqw4Xm6bggBxvgtR0tbg@mail.gmail.com>
Subject: Re: [PATCH 4/4] tun: indicate support for USO feature
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > ---
> >   drivers/net/tun.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > index 84f832806313..a35054f9d941 100644
> > --- a/drivers/net/tun.c
> > +++ b/drivers/net/tun.c
> > @@ -2812,7 +2812,7 @@ static int set_offload(struct tun_struct *tun, un=
signed long arg)
> >                       arg &=3D ~(TUN_F_TSO4|TUN_F_TSO6);
> >               }
> >
> > -             arg &=3D ~TUN_F_UFO;
> > +             arg &=3D ~(TUN_F_UFO|TUN_F_USO);
>
>
> It looks to me kernel doesn't use "USO", so TUN_F_UDP_GSO_L4 is a better
> name for this

No problem, I can change it in v2

 and I guess we should toggle NETIF_F_UDP_GSO_l4 here?

No, we do not, because this indicates only the fact that the guest can
send large UDP packets and have them splitted to UDP segments.

>
> And how about macvtap?

We will check how to do that for macvtap. We will send a separate
patch for macvtap or ask for advice.

>
> Thanks
>
>
> >       }
> >
> >       /* This gives the user a way to test for new features in future b=
y
>
