Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4240831089
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbfEaOsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:48:12 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40861 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfEaOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:48:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id q62so9883329ljq.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dCkGcOMuJ0eYPYrR933NzeA7yS467vZ8UMlGJSWZ1ms=;
        b=ytY5bK9lebhi7MqoCZvKJDDzh5pxFXHBNNiyud2Xr8InThDeCOG3rQ0ZeETV1MJFsb
         jC4lnI6LKsZ+TVYnQLhXVn+/ZX5DexoRpM+mJewKM0ilMDTJyBOD8JyV9qiNYfBlFejM
         SADTb1NNy7rwffkTkIjM0p6DgbqGPfIa+R9iMTRA51/iztoNcwRIMIzFt2ZdmoYv5SV9
         3NEyBBqathj1+Kc7ru2W9oYfj5Mc97jpTaD8OtDOozspX/pKIffxI9yn3j0kR5z3pHrx
         JOhODMPnHW3rWwELc2rYu8hCbIlwBSUx0S2WMO+yFfnri16GPC5Otc2jXZ2euRovzhWJ
         IEzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCkGcOMuJ0eYPYrR933NzeA7yS467vZ8UMlGJSWZ1ms=;
        b=kW1ssHHwkTxBq8Lo+4eBzGQonwuYzyFx53c0JASADpcn/+B+1ua3DxakH0G1xfCsK8
         oE/zuTYOqrmjlhtN8XOhrQnthBm585Glav3KTQxOenYdisiz5Q8XxNH7d5qlYtyB6vzM
         0gElSx3fu1EKGLmww6/RrYwOjjlkjSEGcG3tSRWlFNwLfnB75i+zo5717zjgeQUbDIhB
         kAWDLVFVtc3o//TJIr0zUir16UTjIjzy+sfh224AzjasiK+X69XjsSm7Bi3eIBNShlUV
         Ml57qw/3KUkOdnFKsRzJtqC71QhPq9aT96fOmunNjGRDodOXed8t2QtP814X4wqE8B7B
         UTKg==
X-Gm-Message-State: APjAAAUxwu+L0gf4T0Se+AtLnNFFjAJ/ST2T2opA8/Kwdl3h0kB0xw4P
        CQ6AEadg8HKE7OXUpM92gBqal+9H/fIU/ZEIquX5/IGrp8s=
X-Google-Smtp-Source: APXvYqymc0tl8Nfsxv+DLSA7a6Cpbgj0b4IBmrJubzo6ntldx4Z1J1CmXixAH+yt2oOTlTveuwp9YB60c0vncXSOCaY=
X-Received: by 2002:a2e:6c13:: with SMTP id h19mr557851ljc.83.1559314089677;
 Fri, 31 May 2019 07:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <1559253021-16772-1-git-send-email-tom@quantonium.net>
 <1559253021-16772-7-git-send-email-tom@quantonium.net> <20190531160535.519fdef1067aa9d681669d29@gmail.com>
In-Reply-To: <20190531160535.519fdef1067aa9d681669d29@gmail.com>
From:   Tom Herbert <tom@quantonium.net>
Date:   Fri, 31 May 2019 07:47:58 -0700
Message-ID: <CAPDqMeqvq-w8VRcw6gb1qnUntBno7G+hLD6U1ZECdNfMyAQm3Q@mail.gmail.com>
Subject: Re: [PATCH net-next 6/6] seg6: Add support to rearrange SRH for AH
 ICV calculation
To:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Cc:     Tom Herbert <tom@herbertland.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 7:05 AM Ahmed Abdelsalam <ahabdels.dev@gmail.com> wrote:
>
> On Thu, 30 May 2019 14:50:21 -0700
> Tom Herbert <tom@herbertland.com> wrote:
>
> > Mutable fields related to segment routing are: destination address,
> > segments left, and modifiable TLVs (those whose high order bit is set).
> >
> > Add support to rearrange a segment routing (type 4) routing header to
> > handle these mutability requirements. This is described in
> > draft-herbert-ipv6-srh-ah-00.
> >
>
> Hi Tom, David,
> I think it is very early to have such implementation in the mainline of the Linux kernel.
> The draft (draft-herbert-ipv6-srh-ah-00) has been submitted to IETF draft couple of days ago.
> We should give the IETF community the time to review and reach a consensus on this draft.

Hi Ahmed,

That draft is based on the mutability requirements specified in
draft-ietf-6man-segment-routing-header-19. It was quite an arduous
battle even to get them to nail down any requirements about what bits
the network is allowed to change (and even though the that draft is in
WGLC, they _still_ are making changes in the area). IMO, the AH
requirements should be part of the SRH specification as it is with any
other extension headers, but the WG chairs decided to defer that to
other docs and that is their prerogative-- hence my draft in response
which is simple and straightforward.

Regardless of the history and current state though, the current
implementation allows both AH and SRH to be configured simultaneously.
This won't work. If a user does this they may be in a world of hurt
because the effects may be non deterministic. For instance, some
packets for a flow might take a route that uses SRH, and some may not,
so some packets get through and others don't-- that's going to be hard
to debug.

IMO, we shouldn't wait for IETF to get their act together on this
which in their time frame can be years. We should take action to
address an identified issue that could adversely impact users. If
implementing this method isn't the right direction, please suggest an
alternative.

Thanks,
Tom

> Thanks,
> Ahmed
>
> --
> Ahmed Abdelsalam <ahabdels.dev@gmail.com>
