Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02AD921FDB0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 21:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729939AbgGNToe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 15:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgGNToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 15:44:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92AAC061755;
        Tue, 14 Jul 2020 12:44:33 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r12so24310087wrj.13;
        Tue, 14 Jul 2020 12:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W5RYcljkQ5mqtU2mZsO86/YNRyWjVXxZl5aisgzk1gs=;
        b=AKfmYUSCWEEShSuHdgZbjej54EFiYUDyT41QpNtyNqkNWZJXjScb8xayRoI1zzjHiq
         FFFz69XcjnbudTxaDefs0/40qA2cW4WM16Cvp9924BaH4mQWHLXeF9q7Qalvxlcx+ky5
         HunccMdvKsZk82fTkNo6xDlKb0WVCJhUKos0NxNlvus866PueWD3+f3HtaJ6W3HmslIb
         TPrOIpQ1HDR3Kf6AUzdTwHCkqLRi/yLjPIrym3zzO7s1h/r55/nW366t0B+o6j5MD+pJ
         B/Aa1NZyFQIqXT1xgNWrtwbUYz5z2utR3W118GxW/IgkvXKOzEiSz/l9kBkWa9AC1Chr
         E2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W5RYcljkQ5mqtU2mZsO86/YNRyWjVXxZl5aisgzk1gs=;
        b=BotDrwCXT2GBtq2dilJ+CH/Qn+GUHBGRd5vXaWPwOmWYgajt45Lww/DfhjeXOHohZ2
         qX1Cf6Tx+f1wzv84FGZRbMaAZGvBgaqJv7FL8xiuqaeHa1VFupZkBOTZqXwvDXLZN1CB
         iqKt9Vo4pFDCky2dQABy3XAiyqQvuJ+tK0R9p0A4hknQhX5GihxVF6ojvxibFyZ1+csk
         wk1ayMpqBGjx3Tf9Ph8U97w9JFJybqW7F8Iwjxcm6+IyaUeG+qzxiS0ilqN8HNlBpFRL
         fxooiv+ajzpyBrVS9GZEHdWiUfhgeh2MRbOhy87JR/oN6DCLpcaTChtEG0Z1qUJBCiWN
         zm8w==
X-Gm-Message-State: AOAM531FliIUVCmkfoQ7Mrk64NHxwFVUTMoTPo71yNqDKQaQz2TWDq4k
        4hATEH8inYngetm5N+yTI+p7fjZ3scelBfXAU0AYgKNu
X-Google-Smtp-Source: ABdhPJw1monefUEQnTUL5Mtd+9Ds5pVAIyIE0SPiKX8YMY1bp5Mpf0x0BRQ6XPyEiXMppI9P91jxCRThZBN7vQuPaY8=
X-Received: by 2002:a5d:4649:: with SMTP id j9mr7292277wrs.270.1594755872458;
 Tue, 14 Jul 2020 12:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <2fa6dda741a8a315405989bf3276d9158f4d92e2.1594036709.git.lucien.xin@gmail.com>
 <e852e03656d09a9e469c3fe9c04af25a0551075c.1594036709.git.lucien.xin@gmail.com>
 <2a8edf158432201b796f13ccc2e80f2fcafbb8d8.1594036709.git.lucien.xin@gmail.com>
 <b588daa77c6304119b8578d31d3e29fbc8959178.1594036709.git.lucien.xin@gmail.com>
 <cover.1594036709.git.lucien.xin@gmail.com> <97bd8d867973d769486f5a9b98fe6e13ba3fa821.1594036709.git.lucien.xin@gmail.com>
 <a0c059b3690e690248cbbe1130e160b96b30d989.1594036709.git.lucien.xin@gmail.com>
 <CA+G9fYv1Zx7ptDDs-WAeJ_rhsUX6ZJ1Kx2Nk=BUt_hjKiKhC+A@mail.gmail.com> <CADvbK_dna1OSgiUU7i7pP5FMy3f5pYD=v=gTeVwanPCNtm6nFA@mail.gmail.com>
In-Reply-To: <CADvbK_dna1OSgiUU7i7pP5FMy3f5pYD=v=gTeVwanPCNtm6nFA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 15 Jul 2020 03:54:48 +0800
Message-ID: <CADvbK_fqkhGO1T0tBdJAaLciOwjoyFexUE7vZic7ukYxOL_vwg@mail.gmail.com>
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

On Wed, Jul 15, 2020 at 1:33 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> Thanks
>
> I'll check it soon.
>
>
> On Tue, Jul 14, 2020 at 10:37 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Mon, 6 Jul 2020 at 17:32, Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > Similar to IPIP tunnel's processing, this patch is to support
> > > IP6IP6 tunnel processing with .cb_handler.
> > >
> > > v1->v2:
> > >   - no change.
> > > v2-v3:
> > >   - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
> > >     the build error, reported by kbuild test robot.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/ipv6/ip6_vti.c | 33 +++++++++++++++++++++++++++++++++
> > >  1 file changed, 33 insertions(+)
> > >
> > > diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
> > > index 1147f64..39efe41 100644
> > > --- a/net/ipv6/ip6_vti.c
> > > +++ b/net/ipv6/ip6_vti.c
> > > @@ -1218,6 +1218,26 @@ static struct xfrm6_protocol vti_ipcomp6_protocol __read_mostly = {
> > >         .priority       =       100,
> > >  };
> > >
> > > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
This can be fixed by using IS_REACHABLE()

> > > +static int vti6_rcv_tunnel(struct sk_buff *skb)
> > > +{
> > > +       const xfrm_address_t *saddr;
> > > +       __be32 spi;
> > > +
> > > +       saddr = (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
> > > +       spi = xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
> >
> > arm build failed due this error on linux-next 20200713 and  20200713
> > 15:51:27 | net/ipv6/ip6_vti.o: In function `vti6_rcv_tunnel':
> > 15:51:27 | ip6_vti.c:(.text+0x1d20): undefined reference to
> > `xfrm6_tunnel_spi_lookup'
> >
> > ref:
> > https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-next/DISTRO=lkft,MACHINE=am57xx-evm,label=docker-lkft/812/consoleText
> >
> > config link,
> > http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/am57xx-evm/lkft/linux-next/811/config
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
