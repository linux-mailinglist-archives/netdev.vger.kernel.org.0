Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C50E931209
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfEaQM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:12:56 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34566 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaQM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:12:56 -0400
Received: by mail-vs1-f67.google.com with SMTP id q64so7057461vsd.1;
        Fri, 31 May 2019 09:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2FrzY2ydP6cRNV+r5FtjF3XxLGeE0yW0UZ3D62L58K8=;
        b=S3GztADFEAoU+iw/DnAiHFJ3lrTsPcmRSrKsm/LzCege+lnNoRkyVn/FELbj4RaZuI
         m1jwpfvPsd6GEv2I+N6KmXzxt7p59N5Yax/hj4JVDhA7OtPXVm1avoeqMZZXy8rKePup
         fxPb+68HFJLF7c5/upjWaYPIGfg6BgVQfewJO6HIoBXRTpihL9NEJRE0WEpPBxjzRQ6Y
         UGYbiORtjNwxie/uELHw9dOY06/YsERdaU/eaVhF4rA7C+Fpr1yFqJmRUPaSlwWBkaq9
         Zv6sUldoUN9qmIclWOz12WHQOp4V65Jsz9DpvE0W6vg0d4ut+3TM4ftdhn4111umrPAr
         MwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2FrzY2ydP6cRNV+r5FtjF3XxLGeE0yW0UZ3D62L58K8=;
        b=cqoEm2LePBt7guTkKjLnTnDCCIfYWGjMpNW5Ldkd7aWwFX/XEb28Q7zPA6j9+HSonP
         GnQQtlKcEuEXMP8PJ72iVWv4KR4R9t72FcK0O/gHXrzpeZfsxm9u/kFmxNSGEHnwzuFY
         vA9iPux0qLSFUq3GtQw2HN6sfqimlM7E0hQPXd0D9cPg4sW6entckxhhQHbYoMt2XrdT
         rZpWPfr7FOUXqVo36qgeKv71i3OVmgRq4p3/wbVUK4B8Hq4OX5wQfobRJUVJOScx4nLe
         LSs9Y5kphGRLwE0ONyGU4eTTNkCS77uf8BgQYpXMaECz/RLx+cUTirvlgk6+tgv1UxTo
         4KEQ==
X-Gm-Message-State: APjAAAUACi237cK9vJ4RoQRrLmAfk9e9D7pB98jZJf9hmMk0/baUQ/sY
        ORxmBs/GG1O4+bTAyk5ITL9cIAdFjyGlQJfTNbE=
X-Google-Smtp-Source: APXvYqzpClzX/KpZ2ht67YbTaKY+nKDPKhMXtzGMq+1rT3NpFl0F8uttTZW6AktbeDItrcpGTvJGLINAhxENtCRIxoY=
X-Received: by 2002:a67:d68e:: with SMTP id o14mr6221973vsj.140.1559319175577;
 Fri, 31 May 2019 09:12:55 -0700 (PDT)
MIME-Version: 1.0
References: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
 <c83f8777-f6be-029b-980d-9f974b4e28ce@gmail.com> <20190531062911.c6jusfbzgozqk2cu@gondor.apana.org.au>
 <727c4b18-0d7b-b3c6-e0bb-41b3fe5902d3@gmail.com> <20190531145428.ngwrgbnk2a7us5cy@gondor.apana.org.au>
 <56a41977-6f9e-08dd-e4e2-07207324d536@gmail.com>
In-Reply-To: <56a41977-6f9e-08dd-e4e2-07207324d536@gmail.com>
From:   Yang Xiao <92siuyang@gmail.com>
Date:   Sat, 1 Jun 2019 00:12:19 +0800
Message-ID: <CAKgHYH0nocPY5NBu-5Bmp8WMv2-mf-1Hj+_1=7ixzdGCm0XSqw@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Prevent overrun when parsing v6 header options
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:57 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/31/19 7:54 AM, Herbert Xu wrote:
> > On Fri, May 31, 2019 at 07:50:06AM -0700, Eric Dumazet wrote:
> >>
> >> What do you mean by should ?
> >>
> >> Are they currently already linearized before the function is called,
> >> or is it missing and a bug needs to be fixed ?
> >
> > AFAICS this is the code-path for locally generated outbound packets.
> > Under what circumstances can the IPv6 header be not in the head?
> >
> >
>
> I guess this means we had yet another random submission from Young Xiao :/

Excuse me, what do you mean about random submission from Young?
A month ago, I submitted the patch, and I was told that the format
should be correct.
Then, I resubmitted again.


>
> Thanks.
>
