Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A2DC243E
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 17:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731924AbfI3P1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 11:27:35 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:42873 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728424AbfI3P1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 11:27:35 -0400
Received: by mail-yb1-f196.google.com with SMTP id v6so4388099ybe.9
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ycLBzrPjNz3ipjIpo+K/baf2aY77mjAzKC07stxthdE=;
        b=FwABfb1FfogN2l+pRdVxCz3nXIEVycL3xyeFvtgfkwCzeVLOCwXAvMxkdHNTwl3yZ7
         dd0FfPfgAFueMyfnj1cEEJs0Hzi6qNUX03ZiyJvtIGE+HV1kM+1mH5IQr9RO6bYA3d+E
         xVqihAxY+BYcgj0vowDRX63+mMz1oa2osb5vBkBB2gBMF0J0YU1cc3FUNBFOFyoL1Vkf
         mMjimek3iNTQF98R6QFtLeERJJpFCgHH7pDPL1qO4u/mos10k5I4mvfxQuqFqLotPmfL
         zaLhXcfHN8kF+OhibkDlzEZRFAaW7s6cqmHCik6GGFyNI/SoHvme/oInHxClUZwn7CMR
         dhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ycLBzrPjNz3ipjIpo+K/baf2aY77mjAzKC07stxthdE=;
        b=OfD3Dev9P9twMboVFUXcVbiwdIgEGEb2tM8SGaCQeRXG2vNB2X7u3O+q7ON0PeaLgE
         +EA3X20lzrxl5y0bOTUatVRXsbycxb1K/wHAbyyLmdqKQaA0H2zb8tP6+YM5v0tuROOK
         2QgDOoMhO3zwjCU6xUzSlfaaDHQPHu8CO284UuA+qmjuG2VstnjKEMfp2u4Mn1Rg+rss
         IEhgRspwGDEYyoLR0pcd8zm5g+vcd5kJZRgP5F4733xxFUlSD0VZEpRag59hXBD+ZFM4
         Ru465cTfWnf5mqJVaVb6yeAiTisUYUgb40le+4f7Pv39Qdrb3m48FyNZTb+TnU80SxzB
         XDeQ==
X-Gm-Message-State: APjAAAVBY0X2CJ8CLd4prmpEGoXp/GXWL1IPAMo5HV+6HNgFZxM2ilkp
        1MM14sB3sKAetQ0nKghTxkTpF4zc
X-Google-Smtp-Source: APXvYqzUk6LlcQ1+aE9M+xPXho1G6vHqV4ftGEpzS9N5SKntX9ZT/66Uh4GiYqPOC2VWv3bO5yqTWQ==
X-Received: by 2002:a25:9d84:: with SMTP id v4mr15831790ybp.106.1569857253897;
        Mon, 30 Sep 2019 08:27:33 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id y205sm2837968ywc.6.2019.09.30.08.27.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:27:32 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id w125so4382319ybg.12
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 08:27:32 -0700 (PDT)
X-Received: by 2002:a25:d390:: with SMTP id e138mr14316239ybf.419.1569857251999;
 Mon, 30 Sep 2019 08:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
 <20190920044905.31759-4-steffen.klassert@secunet.com> <CA+FuTSdqc5Z1giGW3kCh3HXXe8N=g+cESEXZAZPMkPrO=ZWjxA@mail.gmail.com>
 <20190930062427.GF2879@gauss3.secunet.de>
In-Reply-To: <20190930062427.GF2879@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 30 Sep 2019 11:26:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
Message-ID: <CA+FuTScxNZKdb0FqAXjxPXY4XEhFFh+_COy0QjCfvw4phSQF3g@mail.gmail.com>
Subject: Re: [PATCH RFC 3/5] net: Add a netdev software feature set that
 defaults to off.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 30, 2019 at 2:24 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Mon, Sep 23, 2019 at 08:38:56AM -0400, Willem de Bruijn wrote:
> > On Fri, Sep 20, 2019 at 12:49 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> > >
> > > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
> > > index b239507da2a0..34d050bb1ae6 100644
> > > --- a/include/linux/netdev_features.h
> > > +++ b/include/linux/netdev_features.h
> > > @@ -230,6 +230,9 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> > >  /* changeable features with no special hardware requirements */
> > >  #define NETIF_F_SOFT_FEATURES  (NETIF_F_GSO | NETIF_F_GRO)
> > >
> > > +/* Changeable features with no special hardware requirements that defaults to off. */
> > > +#define NETIF_F_SOFT_FEATURES_OFF      NETIF_F_GRO_FRAGLIST
> > > +
> >
> > NETIF_F_GRO_FRAGLIST is not really a device feature, but a way to
> > configure which form of UDP GRO to apply.
>
> NETIF_F_GRO is also not really a device feature. It is a feature with
> no special hardware requirements, as NETIF_F_GRO_FRAGLIST is.
> Fraglist GRO is a special way to do GRO and should be configured in the
> same way we configure standard GRO.
>
> >
> > The UDP GRO benchmarks were largely positive, but not a strict win if
> > I read Paolo's previous results correctly. Even if enabling to by
> > default, it probably should come with a sysctl to disable for specific
> > workloads.
>
> Maybe we can just keep the default for the local input path
> as is and enable GRO as this:
>
> For standard UDP GRO on local input, do GRO only if a GRO enabled
> socket is found.
>
> If there is no local socket found and forwarding is enabled,
> assume forwarding and do standard GRO.
>
> If fraglist GRO is enabled, do it as default on local input and
> forwarding because it is explicitly configured.
>
> Would such a policy make semse?

Making the choice between fraglist or non-fraglist GRO explicitly
configurable sounds great. Per device through ethtool over global
sysctl, too.

My main concern is not this patch, but 1/5 that enables UDP GRO by
default. There should be a way to disable it, at least.

I guess your suggestion is to only enable it with forwarding, which is
unlikely to see a cycle regression. And if there is a latency
regression, disable all GRO to disable UDP GRO.

Instead, how about adding a UDP GRO ethtool feature independent of
forwarding, analogous to fraglist GRO? Then both are explicitly under
admin control. And can be enabled by default (either now, or after
getting more data).

>
> >
> > If so, how about a ternary per-netns sysctl {off, on without gro-list,
> > on with gro-list} instead of configuring through ethtool?
>
> I'd not like to have a global knob to configure this.
> On some devices it might make sense to enable fraglist
> GRO, but on others not. Also it would be nice if we can
> configure both vatiants with the same tool (ethtool).
