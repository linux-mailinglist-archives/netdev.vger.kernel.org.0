Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BADAC32B5C
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfFCJEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:04:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:38611 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfFCJEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 05:04:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id l3so8464856qtj.5;
        Mon, 03 Jun 2019 02:04:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g2QwBu8ax58zFupkTk8anfcW357IE8MthSaFY0SgoUg=;
        b=EW3sJiz/xqBxxG+AlxBzsFl8Lwi9i0HPKCFMbvYIa2xiVxyKi/bFuSeogN43nCsuQM
         zjbemBP1cExPv7tRPjj9ON/mFKk8waFYQ8xSe9k8pd/naf1sfGpMJyf0hVdkncuMDFJt
         mqq0uI8whDWXC1H7USY65XrLGkqMAngYxu7pw+AniTPAKLDzXapAkdN5Ke4ZT3lYsjrI
         47r9b6Y1uOrmA0Ch31bfO26GlxDqCsoEcU3UHxXAkUYQwOEIbtjaoutcNrjvfuxdfxnk
         TopSHsY2mmZ3snNxTS+irVFfHHPaoYCIQ0uPOHx470fsF5fZHuycOmsu3LG3Fqlqdz1Z
         ObCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g2QwBu8ax58zFupkTk8anfcW357IE8MthSaFY0SgoUg=;
        b=Nu/jW+KVXKmQK+Xy/BkKxO9u+Y1iOwfRXA9mZ9hGEL4r5s6gNw6UaXxi0texIF5+Z1
         rg+RlWxFryDheVabyk03MF56hJnEjZKiAyS9ZXqG4KbBwoF+005eYZxIbyhGe/ZMblwG
         6aJ9WsQmvD2a3Z0UUeldVYakIb9Rez9feXiRyC2gkUEcmtoKp++GoQux7QS8qv3Paowk
         4Zm5baldWKqYRetK6cbnRiKRQ0IIB81NkcZUGggiJPq2FFzFOt0qJobxflX1OW2iX6lr
         dsi7S2puRZxqTLN3/HiuHzYI+x4+Zc7hjSCeKa9X5FWK2gbBYA2MNo88jJ1ItgP2vk8k
         e61g==
X-Gm-Message-State: APjAAAWvrTS4EXbCUAiYC82RjA6EzUOZ/FUtkGIaZUkns6p+OeKTmHFI
        a92ZT68H2NjheFh6rbNNc5fJ212TNleZma6txnk=
X-Google-Smtp-Source: APXvYqznnUho3VaXCk1XSKH7BR3D0OjkAUBhsktYSP1dIhR+eqSS07XbDu6e+i8tHBIVrL9c7JugdSODkvBiLCSeQhE=
X-Received: by 2002:ac8:19ac:: with SMTP id u41mr4589742qtj.46.1559552670323;
 Mon, 03 Jun 2019 02:04:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <b0a9c3b198bdefd145c34e52aa89d33aa502aaf5.camel@mellanox.com> <20190601124233.5a130838@cakuba.netronome.com>
In-Reply-To: <20190601124233.5a130838@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Jun 2019 11:04:18 +0200
Message-ID: <CAJ+HfNjbALzf4SaopKe3pA4dV6n9m30doai_CLEDB9XG2RzjOg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Jun 2019 at 21:42, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 31 May 2019 19:18:17 +0000, Saeed Mahameed wrote:
> > On Fri, 2019-05-31 at 11:42 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > >
> > > All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
> > > command of ndo_bpf. The query code is fairly generic. This commit
> > > refactors the query code up from the drivers to the netdev level.
> > >
> > > The struct net_device has gained two new members: xdp_prog_hw and
> > > xdp_flags. The former is the offloaded XDP program, if any, and the
> > > latter tracks the flags that the supplied when attaching the XDP
> > > program. The flags only apply to SKB_MODE or DRV_MODE, not HW_MODE.
> > >
> > > The xdp_prog member, previously only used for SKB_MODE, is shared
> > > with
> > > DRV_MODE. This is OK, due to the fact that SKB_MODE and DRV_MODE are
> > > mutually exclusive. To differentiate between the two modes, a new
> > > internal flag is introduced as well.
> >
> > Just thinking out loud, why can't we allow any combination of
> > HW/DRV/SKB modes? they are totally different attach points in a totally
> > different checkpoints in a frame life cycle.
>
> FWIW see Message-ID: <20190201080236.446d84d4@redhat.com>
>

I've always seen the SKB-mode as something that will eventually be removed.

Clickable link:
https://lore.kernel.org/netdev/20190201080236.446d84d4@redhat.com/ :-P

> > Down the road i think we will utilize this fact and start introducing
> > SKB helpers for SKB mode and driver helpers for DRV mode..
>
> Any reason why we would want the extra complexity?  There is cls_bpf
> if someone wants skb features after all..
