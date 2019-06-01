Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54BC831923
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 04:52:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfFACwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 22:52:03 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32802 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFACwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 22:52:03 -0400
Received: by mail-lj1-f195.google.com with SMTP id v29so76566ljv.0
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 19:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l8i89NPVyc/oLT6HSbw99cIa+5k/cBRkqR+GXyBRRPM=;
        b=u9mK23atPIT3PCdhs3p9hZQQ1m1u+G6y3JzWFgsryZm2z7XCwSQ1UbrWoUe7qWv066
         3V4RrhtLOUSVTQpAhWxcMnui/CvVbeUJ+DMpJS2evlKZtvrfw41/K7SOCLiHfwze4T0M
         SKSW+QvNSStbSCsFlJ+6qOeYo22u/MgeGg0bdCLU09TO9PLb8U794Y1uGktAeS9ZieSd
         fB3iI+4KWT3+VFWa7pT7L6hDa72JXCQyDBUHN0RdnJAxWmqvk994qRONZBvvCRpfOVaj
         fv6j3+nIx5YkKub0swJcNu27v6sZRyMCnYynPJmdOquv/fmimozdfCNRUT2Nl1pbWydS
         39+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l8i89NPVyc/oLT6HSbw99cIa+5k/cBRkqR+GXyBRRPM=;
        b=LXEyjwRHfjKxI1TLaWVQPfWrKWD+cJgOwV0rDPEX9EwDxMKCOrzMk1PHxz7q0TM2zq
         U2N2bKSR4MvqPgBc1IwuJ/H7YK4tPrXxeD15z2te9SNxqzWWO+GGh8WnTb5ZPOS7T0Zm
         dUvoSMseyNf2hjYkLQJfbHSLDZdArPIzBqLl98l997QdM5vpgkgHb3DtKSp3JFI1ap/N
         W8skGn/UOrlmd/AfbV3kWrunAk7aFgxauuuFgr9E+eRBQ6PImTZV7RsML26BDDtVW5gC
         T7W6J4Kwct2cTwpNqhXU+VX8/A9PVDiM0ERITduSI8OWU5oNj7mspaI19gJS8utjjINJ
         DdfA==
X-Gm-Message-State: APjAAAU8J+aHDbUaZSm21oZxRHWEt38ZskllHgoiRbccoGKBtM0iYqOq
        1dX40+d5Ddp991pYelh6YVaX5vok13bDcx1Z60U=
X-Google-Smtp-Source: APXvYqy9Cfm6MjI2XofBf9yvjbihQzThAI3hRgIJPyHu1xCRLiZC2hjjq1+WISWF5QeVBizW9SuUd6QeMdIApgktwiw=
X-Received: by 2002:a2e:994:: with SMTP id 142mr7709414ljj.192.1559357521424;
 Fri, 31 May 2019 19:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com> <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net> <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
In-Reply-To: <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 19:51:49 -0700
Message-ID: <CAADnVQ+yj28xchvW6jCPfXCneuHxN+0MNHVquA1v10rWQ=dBMQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 2:38 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/31/19 3:29 PM, David Miller wrote:
> > David, can you add some supplementary information to your cover letter
> > et al.  which seems to be part of what Alexei is asking for and seems
> > quite reasonable?
> >
>
> It is not clear to me what more is wanted in the cover letter. His
> complaints were on lack of tests. I sent those separately; they really
> aren't tied to this specific set (most of them apply to the previous set
> which provided the uapi and core implementation). This set is mostly
> mechanical in adding wrappers to 2 fields and shoving existing code into
> the else branch of 'if (fi->nh) { new code } else { existing code }'

Are you talking about this one?
https://patchwork.ozlabs.org/patch/1107892/
From single sentence of commit log it's not clear at all
whether they're related to this thread.
Will they fail if run w/o this set?
