Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A90483819
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 21:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiACUxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 15:53:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiACUxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 15:53:14 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D5EC061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 12:53:14 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id v14so42088889uau.2
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qN7fe4mmHGgFy/d8+J43DIO3BZsqvDSIvbErVhx/mCE=;
        b=KieuSJYARazc+vaV0zJkPkAL4N/9rFLFMpYr4j9Rr5TT2vrvFRQYFUFT9xPci/VCGJ
         L5xzMh32JamKyN6EHiG+t5AYEmQLkhc79bz2jHWVPWNKa7jyzlXVuQK+XA5iq1bdKrHs
         k7P+n2AyBemSEXwTcqS7xhyuNwW5bg3Fhtixo30gE86yV12JP8YceORSNGv9KWfJmOwR
         6H0Nub0Vz0nP0XAKdx56nBVu3Z1ngeKMRxYFrbgZ55agEFI01NWqkdMBdeC9l21u9WMZ
         VSGShgzUSF/qDnZO6MhdWKV9aSxSYOmB+DLv0c32TRwDGe+NOrrkE3WOsCCzQrYodk+E
         KMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qN7fe4mmHGgFy/d8+J43DIO3BZsqvDSIvbErVhx/mCE=;
        b=0+uoR+LrK9b9LrzMVfwPT1yaIrJWOtWh26KMdXEDpmhXypL/0Ob1Z7OXwuhWF1Ap4a
         4AC6lyAj+1gwUc8vkZjxRyL42A3BXVnWFuP0xixG+7ZTri9qRgl0qBlzSajFXZNhDEb7
         H7lIt6bULpflu93CqRUeqJDs7CAIIRf5HwDgMdZa/S4ID6bbbhTFcGSkWB/6YyuNQEyZ
         267ctHmrMPtUq83lZ/GeNRpiCyr1ZLPu37rBoLHwynFS52H8VYo26rW70YuLiNbe99xo
         +FSuN187Js0xotif840udUdUqnDQgRTj3ocqsEFKVRpe5VC0K/lbP0Y81ZaPcfX0FMvp
         S6Qg==
X-Gm-Message-State: AOAM5333gHwrkx8v1rt/XjjHwTKpLzTBZ43VEMj9sjoKQgEDjDrBBySH
        yAif9W+10LEKsI2wqh3Mfsh7Auij0sM=
X-Google-Smtp-Source: ABdhPJxfS0/7oOnmsG7AJK1/GP1N6AMDtaQU7LMIRHtngTV8rIaNzYbnpj1PQWUotKn6GhJ6d+ZKJA==
X-Received: by 2002:ab0:6518:: with SMTP id w24mr11172721uam.63.1641243193410;
        Mon, 03 Jan 2022 12:53:13 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id k23sm7847961vsm.1.2022.01.03.12.53.12
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 12:53:12 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id i5so44680323uaq.10
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 12:53:12 -0800 (PST)
X-Received: by 2002:a67:f141:: with SMTP id t1mr13485768vsm.35.1641243192352;
 Mon, 03 Jan 2022 12:53:12 -0800 (PST)
MIME-Version: 1.0
References: <20220103171132.93456-1-andrew@lunn.ch> <20220103171132.93456-2-andrew@lunn.ch>
 <b675e0e5-3469-0854-3767-b2a9ec68bd8f@gmail.com>
In-Reply-To: <b675e0e5-3469-0854-3767-b2a9ec68bd8f@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 3 Jan 2022 15:52:36 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeydAbz296i_ObW9ci1ddPqOzC=JvYUOwQA2ngaqA8CaA@mail.gmail.com>
Message-ID: <CA+FuTSeydAbz296i_ObW9ci1ddPqOzC=JvYUOwQA2ngaqA8CaA@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 1/3] seg6: export get_srh() for ICMP handling
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 3, 2022 at 12:31 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/3/22 10:11 AM, Andrew Lunn wrote:
> > An ICMP error message can contain in its message body part of an IPv6
> > packet which invoked the error. Such a packet might contain a segment
> > router header. Export get_srh() so the ICMP code can make use of it.
> >
> > Since his changes the scope of the function from local to global, add
> > the seg6_ prefix to keep the namespace clean. And move it into seg6.c
> > so it is always available, not just when IPV6_SEG6_LWTUNNEL is
> > enabled.
> >
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/net/seg6.h    |  1 +
> >  net/ipv6/seg6.c       | 29 +++++++++++++++++++++++++++++
> >  net/ipv6/seg6_local.c | 33 ++-------------------------------
> >  3 files changed, 32 insertions(+), 31 deletions(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>
