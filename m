Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D323A117EB4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 05:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfLJEEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 23:04:50 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38259 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfLJEEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 23:04:50 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so18419273wrh.5;
        Mon, 09 Dec 2019 20:04:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DDrjvXdE6ph10LD4+5fidaxj4ypwlOJmA/tlMqkSe4I=;
        b=sHuiMeYxX+KVKwt2xc13hNWoLbpp4/5svsCu+mt/cgOPDOuw7sDkCN5gdLaL1BSChv
         DBTnqkjEbAaq7aPuZ4U/At4ccM8Z4IvBLXlg7xHfws2FMliFwAm4JbuXV9S43ADIVICT
         2iwfkNV+jyiiQAZhvLhzZxaZ/N0D4cRNHuivT00fO/VZlGaKZuU8oB978DnPX2vIwHpO
         mAwUtJDyQHh5nTML7pB46SAoi0gCtDzQWfOAYHRE6m16N5aWc7qT78RLwuMersQ3BSnF
         OS8urJlGk2+e1KqVU1IjwqnrE3DkNIGECpT7RdO4H0lcUJYAa8rsFRFVYk/6qORSn50s
         9How==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DDrjvXdE6ph10LD4+5fidaxj4ypwlOJmA/tlMqkSe4I=;
        b=i0AWTSlLpKK5KABFrjTBvVQu0vkzqvL+bSfA7Lalyl97Peqzf0C/Gc6J2iGW5JhCVU
         iHw3VZNWVeI41HULAHvkazoiiL5u3Loig1ZlQLtjuAqMD7QEAXKvetUj3EsY8cGmpLhp
         bKD63+XNtLKeyqPEjpQvjoutE9XYIgMbTy54Cjh7lU7xgM0IBsPlJH3+QRuLyim9iqJO
         ggif9fplmhVuVAKruc3bcm09fxPfracFRewaCNNYDo4OLLdcofApznfLBNYKXHd2+y8e
         dRG0sKF1BTETVM1SGPqUquoR/D3z4u5Q5PNWYLMi/oU+aC6HMbb/V10nrOAskhGliug0
         OWTA==
X-Gm-Message-State: APjAAAVzdcUPJMHZdB8Xa89a+ZcTUzgIg5J3ZlsOKbK/fU4pO5l53oD4
        ozW6xmwE0KVcb7FDuUNDty9hEEgzeCb6uFA3FLIyG9pF
X-Google-Smtp-Source: APXvYqyV33a0QOBHTJjJor71DbcciQlpzcHeZ2RFwW8HrrMF08aJ2InfzFbP/kGmpyKUxHoFJ2pEziHEC58TzMUFQGQ=
X-Received: by 2002:adf:cf12:: with SMTP id o18mr454530wrj.361.1575950687690;
 Mon, 09 Dec 2019 20:04:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575779993.git.lucien.xin@gmail.com> <981718e8e2ca5cd34d1153f54eae06ab2f087c07.1575779993.git.lucien.xin@gmail.com>
 <20191209200317.GA10466@netronome.com>
In-Reply-To: <20191209200317.GA10466@netronome.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 10 Dec 2019 12:05:15 +0800
Message-ID: <CADvbK_fJjN0MsYpmoJ+WD=rRNYub96+nHsv3EozHTj5MG2d1ag@mail.gmail.com>
Subject: Re: [PATCH nf-next 1/7] netfilter: nft_tunnel: parse ERSPAN_VERSION
 attr as u8
To:     Simon Horman <simon.horman@netronome.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 4:03 AM Simon Horman <simon.horman@netronome.com> wrote:
>
> Hi Xin,
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
> I have concerns about this change and backwards-compatibility with existing
> users of this UAPI. Likewise, with other changes to the encoding of existing
> attributes elsewhere in this series.
userspace(nftables/libnftnl) is not ready for nft_tunnel, I don't
think there will be
any backwards-compatibility issue.

Pablo?

>
> >       switch (version) {
> >       case ERSPAN_VERSION:
> >               if (!tb[NFTA_TUNNEL_KEY_ERSPAN_V1_INDEX])
> > --
> > 2.1.0
> >
