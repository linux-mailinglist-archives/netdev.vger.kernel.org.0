Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8B421F818
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgGNRW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGNRW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:22:58 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B381EC061755;
        Tue, 14 Jul 2020 10:22:57 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k6so23342802wrn.3;
        Tue, 14 Jul 2020 10:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pheP1kJGsc/bgG20Ji/efDMiA70yhRoR3//pfmFfHt0=;
        b=pJNqZA/Y8gybnZvxV9XuBFl+Wtg5rni/vS0kyjC66/yg8fsmuiYT5YXEWqMfvteuDU
         GyJcXGRRvNUzAgGzOFk/74ckk41y5zKkZTiDXPQG5047BR5czMQr8T0apkwLjun7e34R
         1oHGphg5ToaQt632ZdtomzRtMrJ2nneN/nn6nvH3ZNHw3NX/hFf+BkmP08I9u03guWl/
         KN7E03f1qc0rFvDS8I7/WMka3NlSvYqXi1T19jIc0rtMgVwZUL77P5/N7BFAg5sWcybM
         k0mLESj7WBNRt6VIe6wRph6svuPJie7iZR4BeChD7z7c/GCXJcNlhPeB9ePNtTLNB5BK
         hlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pheP1kJGsc/bgG20Ji/efDMiA70yhRoR3//pfmFfHt0=;
        b=WXK2ybrQvN7Gnoj9eaDLOwVMnIiotglbkc6cTBJMhJBTLUDXLqy1HcorgGS7ZXDAj8
         AaVqaN2WFmSfMlwL+dvQSWC246rV7uFD0el04U+8aWDaODbXWtvSJ0tI6g0K/NeSh5bW
         pwq+idMG0q0F91M7+vUEZA4Xmv699BaqxQNoqCjl9wIUdOABQCn/DIwfkDyurzCjUe0T
         GI2sISYGqps7hkw4Dbvogw0qAal3Q+40sfa5T4JnVz8rn6h2d4MwguhanBR5Yy8rerE0
         Fk7CUDdF1ucLfuU2wxGC8rTysWrQ7kKymQwM69jdwCJc5/A6+EOmjqTVn/PDYRMoXJCy
         7dWg==
X-Gm-Message-State: AOAM530UVxUeGzOQyvDDr6YWV2CoBlDjncn6cHhC6y+DYYWz9klwRnwj
        aLFequi/jrjbZdnf5e4/jzBTWa15JiAU8z+3Md0=
X-Google-Smtp-Source: ABdhPJxKa/JOT8+bB/S1HL3Ib/LUEbPKt+cPNVznJn0ug0GUn/5l7usGfo2sGAkIItY73A2OiqrnAPBHujCKmEy7UEU=
X-Received: by 2002:a5d:4649:: with SMTP id j9mr6742763wrs.270.1594747376355;
 Tue, 14 Jul 2020 10:22:56 -0700 (PDT)
MIME-Version: 1.0
References: <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <cover.1594036709.git.lucien.xin@gmail.com> <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
 <CA+G9fYv1Zx7ptDDs-WAeJ_rhsUX6ZJ1Kx2Nk=BUt_hjKiKhC+A@mail.gmail.com>
In-Reply-To: <CA+G9fYv1Zx7ptDDs-WAeJ_rhsUX6ZJ1Kx2Nk=BUt_hjKiKhC+A@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 15 Jul 2020 01:33:12 +0800
Message-ID: <CADvbK_dna1OSgiUU7i7pP5FMy3f5pYD=v=gTeVwanPCNtm6nFA@mail.gmail.com>
Subject: Re: [PATCHv3 ipsec-next 06/10] ip6_vti: support IP6IP6 tunnel
 processing with .cb_handler
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        kbuild test robot <lkp@intel.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>,
        lkft-triage@lists.linaro.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks

I'll check it soon.


On Tue, Jul 14, 2020 at 10:37 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> On Mon, 6 Jul 2020 at 17:32, Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Similar to IPIP tunnel's processing, this patch is to support
> > IP6IP6 tunnel processing with .cb_handler.
> >
> > v1->v2:
> >   - no change.
> > v2-v3:
> >   - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
> >     the build error, reported by kbuild test robot.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/ipv6/ip6_vti.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> > diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> > index 1147f64..39efe41 100644
> > --- a/net/ipv6/ip6_vti.c
> > +++ b/net/ipv6/ip6_vti.c
> > @@ -1218,6 +1218,26 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
> >         .priority       =       100,
> >  };
> >
> > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> > +static int vti6_rcv_tunnel(struct sk_buff *skb)
> > +{
> > +       const xfrm_address_t *saddr;
> > +       __be32 spi;
> > +
> > +       saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
> > +       spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
>
> arm build failed due this error on linux-next 20200713 and  20200713
> 15:51:27 | net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
> 15:51:27 | ip6_vti.c:(.text+0x1d20): undefined reference to
> `xfrm6_tunnel_spi_lookup'
>
> ref:
> https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/812/consoleText
>
> config link,
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/am57xx-evm/lkft/linux-next/811/config
>
> --
> Linaro LKFT
> https://lkft.linaro.org
