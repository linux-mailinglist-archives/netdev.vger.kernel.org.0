Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7D41413C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 07:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbhIVFbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 01:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhIVFbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 01:31:23 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D137FC061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 22:29:53 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d21so3035458wra.12
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 22:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pFXvTtOISyIVnaTrC4TqcPHAMbH5+YnOEdGA0JAXIJE=;
        b=JroXW0YEVu64Ao0ORDOGN/OMFaTukX72QGsgj2mNlLguto/OPxzyQ/Bcp7JG0xjLZL
         laWDKysmG25xml4BP5hKDpJKfPHu60Ork+ewXcabzFB11KtAgLM69YM4ZV88/hnmK1ef
         g8Dwh9ViLXfnjm/f7Rv3Yqi2JwkDSozr/bvGrzxtebBRdiETxL+8g8+DCERfYE/rAOtS
         Ipxu4tigTWrP1HvuIeY64DkwKnm5fzyHY7Bds/tJVPVupEEgL10e0S7Ez7ia55HOPcug
         eyRTrrZ1qSvANFYDe5CiuJO4rHCFb5rpSDswQKYQby9Wl9Wt8MKXXc3rDY49naVH9HWF
         ZGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pFXvTtOISyIVnaTrC4TqcPHAMbH5+YnOEdGA0JAXIJE=;
        b=c8iy6Vw2baWtiOkdwmXT7q4UVsl2XITWSP4WFIF1aMhnSQ6hZ/p5Y5nxBZfbNpq+SI
         pU6ysAXusKjWQhOvFoEtcD5MGIHglKcUbTxN8mwr+yRPhnnA3Lq7sz+nvsNsiFKVtyvb
         hzxvzXdAM3yoP7dZVWKZVDWjNMfFnOwb8SX+e8rBoBRd1lweRS7Na+rQZ3dt40IsiPWR
         uxVK8fR0U0NtdtOiSBTihiCunyKOXdTvhm7J8ZtM4Oz9CheZaq1N2skWPRD70cuG2TKY
         CMj0eAkfKsxUvuKwvEpyU8q+lc4biqRj8Z/PEWU/rGi/6nTAOl8tpMiSVMVKxcPIRcGt
         ekMQ==
X-Gm-Message-State: AOAM53138w/cfOOWGg5BvvAKK3viwa2Sx71NcNHvCg1VnIxAemq6Ckjd
        mdypSzxNjQTnpsm1/MK1r039vS+0iojp31Ym2AVOJqs2lUg=
X-Google-Smtp-Source: ABdhPJzf/8VU+zBL1W4rRrjORT5k3qwfSzrUrvPJ7fYLVS7hbe9hWEQh4xfLZyyMi0E1zWYnzpGRgFLxjUEx/O5HCSc=
X-Received: by 2002:a1c:4486:: with SMTP id r128mr8530978wma.8.1632288592493;
 Tue, 21 Sep 2021 22:29:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com>
 <CADvbK_c_C+z6aaz0a+NFPRRZLhR-hMvFMXvaNyXpd84qzPFKUg@mail.gmail.com> <CAM_iQpU+CMLbDGyTQvo3=MwfbPghnb5C0tPLFmrhe_kaYzP6UA@mail.gmail.com>
In-Reply-To: <CAM_iQpU+CMLbDGyTQvo3=MwfbPghnb5C0tPLFmrhe_kaYzP6UA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 22 Sep 2021 13:29:41 +0800
Message-ID: <CADvbK_c7byweHe=ejKe8DPFDXP=ymXC_ps2H49ioaSSmAC+-jQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: sched: also drop dst for the packets toward
 ingress in act_mirred
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 11:53 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Sep 21, 2021 at 12:02 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Tue, Sep 21, 2021 at 2:34 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> > > >
> > > > Without dropping dst, the packets sent from local mirred/redirected
> > > > to ingress will may still use the old dst. ip_rcv() will drop it as
> > > > the old dst is for output and its .input is dst_discard.
> > > >
> > > > This patch is to fix by also dropping dst for those packets that are
> > > > mirred or redirected to ingress in act_mirred.
> > >
> > > Similar question: what about redirecting from ingress to egress?
> > We can do it IF there's any user case needing it.
> > But for now, The problem I've met occurred in ip_rcv() for the user case.
>
> I think input route is different from output route, so essentially we need
> a reset when changing the direction, but I don't see any bugs so far,
> except this one.
Yes, this one seems more reasonable to do this reset when changing
the direction.

Maybe because in common env, it rarely redirects an egress pkt to ingress by TC.
OVS does flow control quite flexibly(complicatedly), when it offloads NAT to TC,
this problem starts showing up.
