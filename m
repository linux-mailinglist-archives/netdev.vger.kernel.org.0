Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F615313EB
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfEaReR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:34:17 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34698 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfEaReR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 13:34:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id h1so1879103qtp.1
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 10:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zuZ1XNWLw+3wHDOy7/2s6iPOxVozCTMSyRlwydjk6y0=;
        b=ZLOtfvQktZ1kNiYETrn+thhewtWfRvfwBXKXQYcB/eqVtCxM66EZYnzA3VeqsaxRs9
         kC9iK7U6Jw370CftiobMo/nnGKV0ASCxgTkEit+1Xwc3R4m8gzYwwmd8z5KGRjZj38Xt
         kLxa1l6roT25Z/tTDXHFVIFYEcKbwmn5AOWHVSKqYtUof25pOHZ51+u3Xo0upBpwXOnS
         Dk9o+vj190R4eYc9o5xH6DrLLy1NdCNTy87wZkbFBi+yY7+vtPSAy53hCTAYEsHlP3MI
         UMjoanVUhox4zyO7eqrV+9G0aSGPk5hIfhfpX/YM7galQdP3/4qosnfw6iv3MDtPGDRn
         3/6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zuZ1XNWLw+3wHDOy7/2s6iPOxVozCTMSyRlwydjk6y0=;
        b=cWXiCtRFDKSXhOpyewO6DzvZmDbdIZfjx4prXbtMBAEklo9iR74ZHbqkfxnN2kLv+u
         J3Z4BALXdbA3Ys+nm0Q5zLx7JIF0/GKdOwawe1DSsB5PShpLNKY5/vV5NFnFORnFYM8f
         7EVrdAWbPkCbYZlBZwGcscrMDyRhYPJ5806OI3af0+MR/5bNmq5fiFdRoaIWmhAghWPd
         bewXQgnJ6MI7qj+kL7DMk/ypWYxprtUxbdGgDTuNI6WrphwhGrKhukJJ9oAgUSpURWYz
         Yf24nCkGjlOaOq54GM5ohoT10/uLkJb2WrIDfIsvBi1Zga6f8Ejv5qBwNePFZy54NzeQ
         C+MQ==
X-Gm-Message-State: APjAAAUuO0oxTOdrt30tcvrDdKi4rFfE9kVgNrHS0p6Sg+GmpytFtA6W
        l8la97FWwCrwPTaBSLFGnssXvUc64c2HFVDnrRIxJQBj
X-Google-Smtp-Source: APXvYqz/aWevpKhIQYUxgQWxPWdmuCSwhlu0MU6I9VF7iukvqZN00zE6WIl9Yladkd+Ui/0I7aDxbGNbBiSUC0wNxNo=
X-Received: by 2002:ac8:2318:: with SMTP id a24mr10066961qta.60.1559324056307;
 Fri, 31 May 2019 10:34:16 -0700 (PDT)
MIME-Version: 1.0
References: <1559321320-9444-1-git-send-email-tom@quantonium.net>
 <1559321320-9444-7-git-send-email-tom@quantonium.net> <20190531190704.07285053cb9a1d193f7b061d@gmail.com>
In-Reply-To: <20190531190704.07285053cb9a1d193f7b061d@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 31 May 2019 10:34:03 -0700
Message-ID: <CALx6S34m31vQQoy6-Esf9N3nYBUhQPMubPC3tXqT6RQbKzkhCQ@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] seg6: Add support to rearrange SRH for AH ICV calculation
To:     Ahmed Abdelsalam <ahabdels.dev@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com, Tom Herbert <tom@quantonium.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:07 AM Ahmed Abdelsalam
<ahabdels.dev@gmail.com> wrote:
>
> On Fri, 31 May 2019 09:48:40 -0700
> Tom Herbert <tom@herbertland.com> wrote:
>
> > Mutable fields related to segment routing are: destination address,
> > segments left, and modifiable TLVs (those whose high order bit is set).
> >
> > Add support to rearrange a segment routing (type 4) routing header to
> > handle these mutability requirements. This is described in
> > draft-herbert-ipv6-srh-ah-00.
>
> Hi Tom,
> Assuming that IETF process needs to be fixed, then, IMO, should not be on the cost of breaking the kernel process here.

Ahmed,

I do not see how this is any way breaking the kernel process. The
kernel is beholden to the needs of users provide a robust and secure
implementations, not to some baroque IETF or other SDO processes. When
those are in conflict, the needs of our users should prevail.

> Let us add to the kernel things that have been reviewed and reached some consensus.

By that argument, segment routing should never have been added to the
kernel since consensus has not be reached on it yet or at least
portions of it. In fact, if you look at this patch set, most of the
changes are actually bug fixes to bring the implementation into
conformance with a later version of the draft. For instance, there was
never consensus reached on the HMAC flag; now it's gone and we need to
remove it from the implementation.

> For new features that still need to be reviewed we can have them outside the kernel tree for community to use.
> This way the community does not get blocked by IETF process but also keep the kernel tree stable.

In any case, that does not address the issue of a user using both
segment routing and authentication which leads to adverse behaviors.
AFAICT, the kernel does not prevent this today. So I ask again: what
is your alternative to address this?

Thanks,
Tom

> Thanks,
> Ahmed
>
> --
> Ahmed Abdelsalam <ahabdels.dev@gmail.com>
