Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FBE412EEF
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 09:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhIUHDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 03:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhIUHDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 03:03:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0E8C061574
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:05 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d21so36079528wra.12
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 00:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HfIARBfVCCT7vPYMtN3+SPdDH+ThIQoGLpcaGKSdVGk=;
        b=Zb0d2wP/g3UAFvd0gS+m37e/oOVwbP75x9esu0xGEAip7KPW3+UYmPJDaLBxNrtKx1
         P38XhXNCMA2Us8TcDAcMXfGUNWfzCAn6/Xm3PDu/G7IOqNAlJh484WdSkBMdi+UpoxQq
         9BaUqzw2MhweiGIx2a58sy3hN88u8H7VQXDZe3epIajSLRfJNiTS2CK3CqTNZQRt009O
         RTaZwHW4BSwvdp/XCdMRxubZjSrh+3rsSBhhvzfAZ+A9aexIj2jSFq2VQsSbwQFx+php
         y9hfRnrIkQL7yAw+rRCwiHyuJeGFjzOUjXSa40WZzDfUBXMMuCrdKaUTwnCOHbOkyAgt
         J7AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HfIARBfVCCT7vPYMtN3+SPdDH+ThIQoGLpcaGKSdVGk=;
        b=icGX8KaLZv97cUDjBaToZiRzsmZ6LxoeZdb32YugS1uSsz92O3jpGCBLz4kb7xo4bo
         dm9bE44JDNLfCssIlPy0a9BcNyocUvLTtToQRDNMHmoidW9olLDgawhYEN1xOymmhXbP
         RmkQsh8SsRnWnxh/nVZuBHQsUfvIlRX09ezw4NRjQo/uMMa7xe3zcJQaK5PUMOrvhnR4
         BV0N4UwNJ8GTo+QqY1QSLKl0g8LmwQr4ewfHmWolqEhH193RP/gKHLC/SHmHiEmTxQdS
         YcUSnWkNu15jh6FdD9iJdkyd6n9a3s/mp+adwx/gRGkuaHOWCexjTNa+9EKeYqz8zRXE
         EyKQ==
X-Gm-Message-State: AOAM532TLogEybCDSYKNDd4o/+FbBzxZAGSJPUAWFcrsizV2q0coB9k2
        Ciz7edsZJ7rfmDl5QHXeanEis4JSp9NZImXuksvfm9it+yNmHw==
X-Google-Smtp-Source: ABdhPJxAPCkhTzDAZ336WwmL8b7wBL8zKg+mjYsC/mtlam85cyLYzQ5iKF95uQewNeFpWVrRQe2CbP1VGkmnheKe8N0=
X-Received: by 2002:a05:6000:104e:: with SMTP id c14mr32732165wrx.130.1632207723041;
 Tue, 21 Sep 2021 00:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1632133123.git.lucien.xin@gmail.com> <a1253d4c38990854e5369074e4cbc9cd2098c532.1632133123.git.lucien.xin@gmail.com>
 <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com>
In-Reply-To: <CAM_iQpVvZY2QrQ83FzkmmEe_sG8B86i+w_0qwp6M9WaehEW+Zg@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 21 Sep 2021 15:01:52 +0800
Message-ID: <CADvbK_c_C+z6aaz0a+NFPRRZLhR-hMvFMXvaNyXpd84qzPFKUg@mail.gmail.com>
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

On Tue, Sep 21, 2021 at 2:34 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Sep 20, 2021 at 7:12 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > Without dropping dst, the packets sent from local mirred/redirected
> > to ingress will may still use the old dst. ip_rcv() will drop it as
> > the old dst is for output and its .input is dst_discard.
> >
> > This patch is to fix by also dropping dst for those packets that are
> > mirred or redirected to ingress in act_mirred.
>
> Similar question: what about redirecting from ingress to egress?
We can do it IF there's any user case needing it.
But for now, The problem I've met occurred in ip_rcv() for the user case.

>
> BTW, please CC TC maintainers for TC patches.
added Jamal and Jiri.

Thanks.
>
> Thanks.
