Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 682E111C3D3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 04:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfLLDTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 22:19:47 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33642 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfLLDTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 22:19:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id d139so2587678wmd.0;
        Wed, 11 Dec 2019 19:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8aKAK2wIbXo8MeQVudDOrxWtQIV7GTCJgC/T3O4iEuI=;
        b=YRtRGE7VHgSvgu92ycD7KxiObgAE/MDagw4eIyqUaD4HGUFO3rvyMS0qK+m1nr4JDr
         c1260O7hU0VrPQHoOa45ahYRRO8jzTVPzA54agZbHqKZFlkeKoTlNRARIK0BKweymD9M
         +MqynsMIUw3qGKJCCwBpt+36C7EENZ9QhEY0plZUB7G2wA6ew4ViaSaiER0ZDm8BkhS3
         SB+AlN3GYg5uY4Z1lAqjXBYnHF1ei2C3TZq1LJooZuGYkkJVZP3Zb7bkAv7y478dmi++
         IWMAtHnXwxW+v8ukLSkXQTQf9G5hsRpWAS38Rm7/L2BohhZwwlS0gOZeMC/OUqlvpSH4
         MBtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8aKAK2wIbXo8MeQVudDOrxWtQIV7GTCJgC/T3O4iEuI=;
        b=UeeVmnPQG/XQjAaKh4L1LYX83TLExkvdJr4nB//I8K2yRAl6jWIGpPAnD40jV8wxg+
         l3ERtj0KiO4g3eE5nQghcPeL+Lup3XaMkQRW1TS3emrWJWMjPMTWqRQLxZi6OCb1mAvH
         7kwrF7KPvz2LnSVOIHjHG557pzvld3FTbw5tIJhN0/101LyhPvPvKadlfK1Q+iAAs1Nj
         C2BytPBhCQF1UjiER4UDD2OCeMBKDtGdryWldYCNtPKI3g+k4X41pINNdzfghc4Oah/1
         ceVXio8jmiZjnYnuNwVmkUUJ5NQb73j0IYcV/aWuAkbRnuaQX1lBaMNfCcAV2VwLaC0U
         l5Ig==
X-Gm-Message-State: APjAAAUKlRqs2BRRySWmgC0fu9PyrETuMwHDAuZ0WeU5NVIrWDWN2Dl9
        d+ZSAhWOpCQKZ6UkPlmvSHlkhJvwrtcEEy8Wz3PP69KV
X-Google-Smtp-Source: APXvYqxI42jVAyxXWFlKHEIL1wk2L/adOyS9dnzLHQdpyerrKTVanUvZukzdPNIouQigUOGCnYr5du9WaNEChkUpyKI=
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr3374252wmm.145.1576120785215;
 Wed, 11 Dec 2019 19:19:45 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575779993.git.lucien.xin@gmail.com> <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <20191211215104.qnvifdmlg55ox45b@salvia>
In-Reply-To: <20191211215104.qnvifdmlg55ox45b@salvia>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 12 Dec 2019 11:20:19 +0800
Message-ID: <CADvbK_cxeZmJa_FMd+p_35CPOSMDfnos1j3TC0_3u9TdmZZH=g@mail.gmail.com>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 5:51 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi,
>
> On Sun, Dec 08, 2019 at 12:41:31PM +0800, Xin Long wrote:
> > To keep consistent with ipgre_policy, it's better to parse
> > ERSPAN_VERSION attr as u8, as it does in act_tunnel_key,
> > cls_flower and ip_tunnel_core.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/netfilter/nft_tunnel.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
> > index 3d4c2ae..f76cd7d 100644
> > --- a/net/netfilter/nft_tunnel.c
> > +++ b/net/netfilter/nft_tunnel.c
> > @@ -248,8 +248,9 @@ static int nft_tunnel_obj_vxlan_init(const struct nlattr *attr,
> >  }
> >
> >  static const struct nla_policy nft_tunnel_opts_erspan_policy[NFTA_TUNNEL_KEY_ERSPAN_MAX + 1] = {
> > +     [NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U8 },
> >       [NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX]       = { .type = NLA_U32 },
> > -     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR] = { .type = NLA_U8 },
> > +     [NFTA_TUNNEL_KEY_ERSPAN_V2_DIR]         = { .type = NLA_U8 },
> >       [NFTA_TUNNEL_KEY_ERSPAN_V2_HWID]        = { .type = NLA_U8 },
> >  };
> >
> > @@ -266,7 +267,7 @@ static int nft_tunnel_obj_erspan_init(const struct nlattr *attr,
> >       if (err < 0)
> >               return err;
> >
> > -     version = ntohl(nla_get_be32(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]));
> > +     version = nla_get_u8(tb[NFTA_TUNNEL_KEY_ERSPAN_VERSION]);
>
> I think NFTA_TUNNEL_KEY_ERSPAN_VERSION as 32-bit is just fine.
>
> Netlink will be adding the padding anyway for u8.
>
> I would suggest you leave this as is.
okay.

do you think I should prepare another patch/fix for the missing nla_policy part?
[NFTA_TUNNEL_KEY_ERSPAN_VERSION]        = { .type = NLA_U32 },

Thanks.
