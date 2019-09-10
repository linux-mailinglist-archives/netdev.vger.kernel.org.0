Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2140EAF2E7
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfIJWZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:25:32 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39460 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfIJWZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 18:25:32 -0400
Received: by mail-oi1-f195.google.com with SMTP id w144so12534406oia.6
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 15:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InJGYhxAXvo8w2S6veaaU5lbecp++jQH4xBEFpanQZI=;
        b=QK2OFlzoLJlkdfnoYI8LD00kZpLsQJmjvdeE0hPS7M6u+vzr1JoPD/xVEyI+dYqQel
         zAfnjT2vTmdBPz9CNTr+CkaSRAFB2OQ0+qVQpX1pmABI2VHfJ7qe+Ndy7uUmnAn1YysG
         e2qlYk0LSzQMrYwsQY3glZXeJJQlIVGZTt8vi42u211xhEWKbpT2KfIN0sPSTlmBwqod
         SqtAvZVktUcAPKSxBDchYgVgffFMl+0L5y1efTC7jur/hktJz3aThWvy5P93KVkLSaVa
         QF5oQZG15iNm90GijBMP4RwYNZUSojdh2bacPfp+HWShpRYprh2d+6NQOU2ASH6YMGzq
         Vp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InJGYhxAXvo8w2S6veaaU5lbecp++jQH4xBEFpanQZI=;
        b=G3eZAk9iUCpzA4t5N9m4HpYRKoijE2aFWZAtpPGEv6RNt/5Jzfw7e8SQwmCD0p9aB1
         PzBPRNoJ9LFzVrmss9EIcQGOh5xrh4HxyafLgQRWQ4o6eXEcYnM7o37+JNXckoE7bcW9
         eF0upigirT3+WkC1WU9zJ1/eXdAt5LG2PcawXEvQJ867H/p/H1HyWGESzRY2snPtRvxO
         kmZ8qsKCeujCLLPD3ZhoHceiBj+IJIYAHKtkNwIdWvmObAfciEV/LRti9lR3TzQLuaaF
         P6GeCQKtA8BKH8fFDlHMvutMsCsTnivaCCe5phbn5XVGgsp9PuvdpB0OJ96kq5p6fa5e
         TD/w==
X-Gm-Message-State: APjAAAWmXQ5bXcRPVDP7nePkDIILHwJhxWGs9oRd6U3gMW2oFYMQhEXo
        0dyDrMHO2qapywOmA1s2qW5ZK+SzgfdMmkosNwVLEQ==
X-Google-Smtp-Source: APXvYqw3LRwgci2kGk5n+O+BBiicQcQMr+m9kL3O49cdDziPhYsUf1oMGNxA9CEcYaGd7B05p9HiD8b0AvJvH4Zqjwo=
X-Received: by 2002:aca:c38b:: with SMTP id t133mr1552062oif.22.1568154330778;
 Tue, 10 Sep 2019 15:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190910201128.3967163-1-tph@fb.com> <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
In-Reply-To: <CANn89iKCSae880bS3MTwrm=MeTyPsntyXfkhJS7CfgtpiEpOsQ@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 10 Sep 2019 18:25:14 -0400
Message-ID: <CADVnQynvcnMi28DUCz3HPc79nz+7UduDT3S6A+fN49p7KxLDdg@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: Add TCP_INFO counter for packets received out-of-order
To:     Eric Dumazet <edumazet@google.com>
Cc:     Thomas Higdon <tph@fb.com>, netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 4:39 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Sep 10, 2019 at 10:11 PM Thomas Higdon <tph@fb.com> wrote:
> >
> >
> ...
> > Because an additional 32-bit member in struct tcp_info would cause
> > a hole on 64-bit systems, we reserve a struct member '_reserved'.
> ...
> > diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
> > index b3564f85a762..990a5bae3ac1 100644
> > --- a/include/uapi/linux/tcp.h
> > +++ b/include/uapi/linux/tcp.h
> > @@ -270,6 +270,9 @@ struct tcp_info {
> >         __u64   tcpi_bytes_retrans;  /* RFC4898 tcpEStatsPerfOctetsRetrans */
> >         __u32   tcpi_dsack_dups;     /* RFC4898 tcpEStatsStackDSACKDups */
> >         __u32   tcpi_reord_seen;     /* reordering events seen */
> > +
> > +       __u32   _reserved;           /* Reserved for future 32-bit member. */
> > +       __u32   tcpi_rcv_ooopack;    /* Out-of-order packets received */
> >  };
> >
>
> Unfortunately we won't be able to use this hole, because the way the
> TCP_INFO works,
>
> The kernel will report the same size after the reserved field is
> renamed to something else.
>
> User space code is able to detect which fields are there or not based
> on what the kernel
> returns for the size of the structure.

If we are looking for something else useful to use for a __u32 to pair
up with this new field, I would suggest  we export tp->snd_wnd
(send-side receive window) and tp->rcv_wnd (receive-side receive
window) in tcp_info. We could export one of them now, and the other
the next time we need to add a field and need some useful "padding".
These fields could help folks diagnose whether a flow is
receive-window-limited at a given instant, using "ss", etc. I think
there was some interest in this internally in our team a while ago.

neal
