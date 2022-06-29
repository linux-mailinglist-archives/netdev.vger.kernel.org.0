Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB656011B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbiF2NS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiF2NS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:18:26 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9E319033;
        Wed, 29 Jun 2022 06:18:25 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s206so6300838pgs.3;
        Wed, 29 Jun 2022 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=k/nCs7YbljBccueLhA/3lc/MN4JwIPE8bj7UgrJbxJg=;
        b=SL/3Avn+Zpyll1ee0FT3z3o8y4GLJ/BO3ODR82sWl21U8ED15emus86iairgzf3Av+
         6TyBU3YZu+30U8x/FikpEEEFBxkf+8Il34Kmk8qkrKvQd2DzQs9Jzeo63715t+S8XSxg
         UrsiU18kTdMDvznRABi2VWteq0axPNsUS7XJgAXX/Axd8tfxKaL+MWBG/+fYqEsYffEo
         VIcWiacueLIn7BO3yashAAm3AD8f2YKHGa4cuNsoB8g3fKjdB6BjO+NuwByuj/OAogSB
         lHMKsgqqCy4q1mhls5+WJnIfVnVq1PrxvgicbPAWuI4rjz/NkruxlxFBxntBZV/EYQir
         6Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=k/nCs7YbljBccueLhA/3lc/MN4JwIPE8bj7UgrJbxJg=;
        b=Ty31bNSiXWHHPlP29fjPiA37AHNr6GMud+KIz+xpsZyaAdTqhTx83aAzrSVTU+3K88
         wmdy+RdkcuzcxXN7dz5VgBoVj37bUk/kZVWrDn+8g+vv/e+e/cr/yiNYJdRndFvW3aNt
         9BBX+PXmO6OEYDg+sbyIp5tzfY6j1/ROnpX5XVgGF4ESxYoFEAPf083CK/3IpNNb/CZv
         Embzgo65wtycNymSmCFFP8cv7dJSZNU+OSw2IoyrkiJ4SPNIjzvHDcUCwW+onlGdX3a1
         Sup6w4hfeg2bzZkHA9Afyn3sRi1H+0ebrMqfHkdqUwhZfmCpLeH09KIxJtWAeLznny9a
         kEQA==
X-Gm-Message-State: AJIora/IsQmgIvDpNVJYjs/m/OqEIaXgwa3U6XaTkv5xthl9/GagYLhz
        XnL24N1LfROmmxb/Skjjldu06PTKUh6b0XvDnIc=
X-Google-Smtp-Source: AGRyM1tGObwTZe58zJ5YJJ7A3o1A0stpoXc/mJQ452TORZ6XWRkEToK3+NJj8CMAExVVVMQfwj+YxaCAXSnF//C9eyc=
X-Received: by 2002:a63:7c5a:0:b0:40c:a376:6176 with SMTP id
 l26-20020a637c5a000000b0040ca3766176mr3042978pgn.156.1656508704809; Wed, 29
 Jun 2022 06:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220629105752.933839-1-maciej.fijalkowski@intel.com>
 <CAJ+HfNj0FU=DBNdwD3HODbevcP-btoaeCCGCfn2Y5eP2WoEXHA@mail.gmail.com> <YrxLTiOIpD44JM7R@boxer>
In-Reply-To: <YrxLTiOIpD44JM7R@boxer>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 29 Jun 2022 15:18:13 +0200
Message-ID: <CAJ8uoz1mLPukkNmR4Qeege03_=+mCY+hPSJ906fjDTX7EC5RHA@mail.gmail.com>
Subject: Re: [PATCH bpf] xsk: mark napi_id on sendmsg()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 2:58 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Wed, Jun 29, 2022 at 02:45:11PM +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > On Wed, 29 Jun 2022 at 12:58, Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > When application runs in zero copy busy poll mode and does not receiv=
e a
> > > single packet but only sends them, it is currently impossible to get
> > > into napi_busy_loop() as napi_id is only marked on Rx side in
> > > xsk_rcv_check(). In there, napi_id is being taken from xdp_rxq_info
> > > carried by xdp_buff. From Tx perspective, we do not have access to it=
.
> > > What we have handy is the xsk pool.
> >
> > The fact that the napi_id is not set unless set from the ingress side
> > is actually "by design". It's CONFIG_NET_RX_BUSY_POLL after all. I
> > followed the semantics of the regular busy-polling sockets. So, I
> > wouldn't say it's a fix! The busy-polling in sendmsg is really just
> > about "driving the RX busy-polling from another socket syscall".
>
> I just felt that busy polling for txonly apps was broken, hence the
> 'fixing' flavour. I can send it just as improvement to bpf-next.
>
> >
> > That being said, I definitely see that this is useful for AF_XDP
> > sockets, but keep in mind that it sort of changes the behavior from
> > regular sockets. And we'll get different behavior for
> > copy-mode/zero-copy mode.
> >
> > TL;DR, I think it's a good addition. One small nit below:
> >
> > > +                       __sk_mark_napi_id_once(sk, xs->pool->heads[0]=
.xdp.rxq->napi_id);
> >
> > Please hide this hideous pointer chasing in something neater:
> > xsk_pool_get_napi_id() or something.
>
> Would it make sense to introduce napi_id to xsk_buff_pool then?

Only if it has a positive performance impact. Let us not carry copies
of state otherwise. So please measure first and see if it makes any
difference. If not, I prefer the pointer chasing hidden behind an API
like Bj=C3=B6rn suggests.

> xp_set_rxq_info() could be setting it. We are sure that napi_id is the
> same for whole pool (each xdp_buff_xsk's rxq info).
>
> >
> >
> > Bj=C3=B6rn
