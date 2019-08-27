Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACA9F4E6
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbfH0VQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:16:36 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43091 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbfH0VQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:16:36 -0400
Received: by mail-yw1-f67.google.com with SMTP id n205so56424ywb.10
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 14:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/m9sVpFoHDb7KFG8DyBFM/c0Tc6/6lDChm6I0kTDtKM=;
        b=N59kCynqnBaa6ofaiUHSJz+womOMzYxX6d43UFUcxNa/CccIKedBMp0+9AhJSbGLix
         2Le1Bp88RKex8wekfCgXGnoeivQZrUgtv/bfDzkreB7p97Q27TNyREDMIB4kV/+Hpw2r
         82++AgQgFRK+FtZcOJuPKct32Rn9i7+zQRp8zvnir/Bmb/CJ8M9b3GG+r1S/jSg13oc6
         B4CqrDqD7g8bCmlP9AHa/yzg/OPkntepWoXwHc07PHFjc/Xr7H+Sn6/PHUqHjQVdhsX+
         YCWL9FruV1lgd1wAdwuOyD33bbDDWwo2kZThrvNgia0ucE6RvMSHPZGybXSBuiXNu2Kl
         LloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/m9sVpFoHDb7KFG8DyBFM/c0Tc6/6lDChm6I0kTDtKM=;
        b=m1YO3yfSkIxB4ZR4i3MoWYRPEB6lfGuJakhSZHZEBa6p377E+kaVo3497N1dqpyyjq
         cDWnXPg5eGYmw9fo2f3NQmkph8LzbG6G4wfuJzET4ISnu1TegbArMkpDpQsbv4UmXj/4
         zFUvSKSNeLgWPT3Ib50jWwrxaGtEGRTUB4LvMKXcCsjyKZGabZUpzN/JvVkLgY5WTnni
         BHciFs/vgyU27RM/r2MRnte4+nYzY3Z02l64iCrzeupCMRHKBu5ooEbJb+HKAfkJrwAA
         fhBs+w8iBsOeuUtWXYadHhMLgcd3QEQbPq3skO9FcVcsXX8loJvDPIqXZDDzHJZGegdq
         mnag==
X-Gm-Message-State: APjAAAUqYipQFnJ2vfstNM70dIa8u9H4pA8P3+2XpjUjcwN5B9pmBHNP
        3+8Z2ma5RDVvzOXW9YQSVLTs9uxu
X-Google-Smtp-Source: APXvYqz/INXQ4ylg45XIWhzgRaRKUvz8HgwdYRQeFSSWFTOESGBCnMD9IVHh1uj33/22KJeeFdVOmA==
X-Received: by 2002:a81:3681:: with SMTP id d123mr761903ywa.348.1566940595444;
        Tue, 27 Aug 2019 14:16:35 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id j136sm126460ywj.105.2019.08.27.14.16.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 14:16:34 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id m9so75903ybm.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 14:16:34 -0700 (PDT)
X-Received: by 2002:a25:1ec3:: with SMTP id e186mr608498ybe.391.1566940594284;
 Tue, 27 Aug 2019 14:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190827190933.227725-1-willemdebruijn.kernel@gmail.com>
 <CANn89iKwaar9fmgfoDTKebfRGHjR2K3gLeeJCr-bvturzgj3zQ@mail.gmail.com>
 <CA+FuTSfK=xSMJvVNJB7DKdqwG_FAi2gLjbCvkXVqF99n71rRdg@mail.gmail.com> <CANn89i++59nk_RFMOgor6XL3ZZY7t9QLa70sppKe6eQBrObagQ@mail.gmail.com>
In-Reply-To: <CANn89i++59nk_RFMOgor6XL3ZZY7t9QLa70sppKe6eQBrObagQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 27 Aug 2019 17:15:58 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeVKSJHXY_LwJBiVreqm+MUSoJt+Dp3mdATKvB48DUz-g@mail.gmail.com>
Message-ID: <CA+FuTSeVKSJHXY_LwJBiVreqm+MUSoJt+Dp3mdATKvB48DUz-g@mail.gmail.com>
Subject: Re: [PATCH net] tcp: inherit timestamp on mtu probe
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 27, 2019 at 4:58 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Aug 27, 2019 at 10:54 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>
> > Sure, that's more descriptive.
> >
> > One caveat, the function is exposed in a header, so it's a
> > bit more churn. If you don't mind that, I'll send the v2.
>
> Oh right it is also used from tcp_shifted_skb() after Martin KaFai Lau fix ...

Leave as is then?
