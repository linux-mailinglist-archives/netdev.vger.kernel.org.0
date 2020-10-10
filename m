Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B05289DFD
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgJJDhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730593AbgJJDKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 23:10:07 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ACEC0613D0;
        Fri,  9 Oct 2020 20:09:56 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id p15so11416737ljj.8;
        Fri, 09 Oct 2020 20:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boOxhSTKvuA6vO6wuUXDhR47z04re8mQZXd9X7sgCr8=;
        b=PD2tnD3HyQjTglqnXFxm251pj8OGL1yLJP2r+fMHM1WFKD9rG0yop3oUDYF1De/wqW
         KN03y1Yn6lZI8Pd6n5/AsUaQTc0e3YMDeTeSlOfIVkF88IcDs3u3WiS+9i9QJg266IEg
         gfpfKwsFiMGpoggqgsULFownHcdYY+UDXCYLblsBvD1GnPM5csk6g2CubiExuER2emmG
         yvGK2gdNnHGG3VVlWErRwPjmyrJiNOVSmB8414biEct8SReDNcenCl6mNZtHcIxYoN4N
         tvzk/vN/ORFyf02ETp/o9p84sOLIeKqmye2PXTU31FM9oV8sOnIzxXfzrV2yFnGpPQZy
         HWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boOxhSTKvuA6vO6wuUXDhR47z04re8mQZXd9X7sgCr8=;
        b=rLQNrEzXmIGAXchSM7dc+MMlkampXwyvXwl3rhcDMFS4jod2aC3g3pno4eglF2CA6V
         0Uom1hPjSRKJVVpK+nFL4l1sJm2JZuN5vTxKpUAJBgWUozyU8qIaOb0aTH++yh2MByc3
         cYb46Z7iHK+XLqMFU+sLSqPAVui7IQwdpRu7oqSauvMUqqElDE0SjImtwyUm2lFj1yBr
         Drv6l0tPARKgVCFrAsifdTzZcFAfBxslrxe+pY73STPzcLFpdMPrsmFNUCCeVcE28bx1
         HwiX88mIDXps6TwlUCXIscb1LQOcOd8YF5UdOfY/9diGNebbPZJImPdZ1C+uWoXYmEzc
         POUQ==
X-Gm-Message-State: AOAM531M4WuM+FuLIeme6P+8Q76lrgjpUY/B2tKyaAl1kQG+40buCulJ
        pFw75wO/9yiRU/Cv+J+/x/EaSKW7Pj0nOkvL5Ho=
X-Google-Smtp-Source: ABdhPJw+PZXbP8hvBhTJBQ+BtI29CQw6myRhG/Ka1Ztyn/U9C782aag732wKZiGOF4PdZ0YziDGhXtAq3tiyanOA9zc=
X-Received: by 2002:a2e:2d09:: with SMTP id t9mr4720098ljt.51.1602299395028;
 Fri, 09 Oct 2020 20:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20201009103121.1004-1-ceggers@arri.de> <CABeXuvpg4EkuWyOUEU-4F5Hd_iF7pjGX=K8KmMVZGWTt0P_EkQ@mail.gmail.com>
 <CA+FuTScqLoAQTVwEJ+OcyTpQ-bbns6G5xq+p-Swc4hR7Hf5RLQ@mail.gmail.com>
In-Reply-To: <CA+FuTScqLoAQTVwEJ+OcyTpQ-bbns6G5xq+p-Swc4hR7Hf5RLQ@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 20:09:43 -0700
Message-ID: <CABeXuvofXme9y92mmOuWmqEhNWSBD7ja7G2pKAJnryCkrHeYAg@mail.gmail.com>
Subject: Re: [PATCH net 1/2] socket: fix option SO_TIMESTAMPING_NEW
To:     Willem de Bruijn <willemb@google.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linux Network Devel Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 5:43 PM Willem de Bruijn <willemb@google.com> wrote:
>
> On Fri, Oct 9, 2020 at 8:30 PM Deepa Dinamani <deepa.kernel@gmail.com> wrote:
> >
> > On Fri, Oct 9, 2020 at 3:32 AM Christian Eggers <ceggers@arri.de> wrote:
> > >
> > > The comparison of optname with SO_TIMESTAMPING_NEW is wrong way around,
> > > so SOCK_TSTAMP_NEW will first be set and than reset again. Additionally
> > > move it out of the test for SOF_TIMESTAMPING_RX_SOFTWARE as this seems
> > > unrelated.
> >
> > The SOCK_TSTAMP_NEW is reset only in the case when
> > SOF_TIMESTAMPING_RX_SOFTWARE is not set.
> > Note that we only call sock_enable_timestamp() at that time.
> >
> > Why would SOCK_TSTAMP_NEW be relevant otherwise?
>
> Other timestamps can be configured, such as hardware timestamps.
>
> As the follow-on patch shows, there is also the issue of overlap
> between SO_TIMESTAMP(NS) and SO_TIMESTAMPING.

I see. Thanks for clarification. I think I had missed that you could
have both software and hardware timestamps enabled at the same time.

> Don't select OLD on timestamp disable, which may only disable
> some of the ongoing timestamping.
>
> Setting based on the syscall is simpler, too. __sock_set_timestamps
> already uses for SO_TIMESTAMP(NS) the valbool approach I
> suggest for SO_TIMESTAMPING.
>
> The fallthrough can also be removed. My rough patch missed that.

Sounds good.

-Deepa
