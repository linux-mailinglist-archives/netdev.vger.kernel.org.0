Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618FE12AEBF
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 22:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfLZVMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 16:12:25 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40441 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 16:12:25 -0500
Received: by mail-ed1-f65.google.com with SMTP id b8so23730542edx.7
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 13:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifR3bZa5i0QriHC4rjkQJF0B8R/PAsK2xsDkWWvIRWI=;
        b=ytB/1k4E9l0P4uSQOXPV8ve/QWKD3scpHRVKOPra8ythtA72ee0pmwdRTCP3zO2vnl
         Ds1sEQnZIZX7D7GfqJC+p1nU3xIydEQv3Rjjgt5IUaINF9oe51Ln5Nv36Rk9QW0UdSww
         94HB3YyzMWil4LTsDcGglUiWj9x0dz2Vwzg0+Ari5PoIp9iRkF+Eyf2Kz8ogUcVQcazF
         h3Zgq0eWAxSQQmv9Nj7VUhZUdB4sUqXq1DwRzV0LPF8UdZihxsMD6JTywtVJJcGdT+gp
         QJrnB+9ljKppTu/rx52sxHYk07TrSW4WiW3R+uVgOClJyEQtWgiLWtonzF8Euw5WGQy/
         zsNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifR3bZa5i0QriHC4rjkQJF0B8R/PAsK2xsDkWWvIRWI=;
        b=RqMDbvT5CYUEh6DtiB1cWe2YuqEgNOSwu9h7Aj1/joRyZZx2hekIVfmp7CDKQtUld7
         ETQK+k7bSFVbCj4qAnGMlTXl6fKz98hxJfo1mdvN2fldAck7fqEcz6D2Pg3vVg5KmgkQ
         y23b/6+1mROAJguIg+IS8c+zJd+L8SV7Wt5rJT8Z9b6gsGpSiweQVNukP5+IJL8H0drh
         PaSha4LOys6DRHVAkGVGQUTgQonp+ETaQ6fP6v9xpcQXfLiZIU8VssU4gfC6TxICsEdd
         jxUPXHMIxb7uW4/yyjQQcWs0srmg3Orq/ymq5SqvESEkqoqj6vfg4i3sO4qEQX+kwO4p
         rjuw==
X-Gm-Message-State: APjAAAUX2kKCSqT5ZEN8lrnpuxJa82UVHjkBadre0SjFcUHroqRtUium
        msFAVP3cRsxS6z9FqCFu1PHs5StF8O98Ym1z+RONGw==
X-Google-Smtp-Source: APXvYqwD8NkpolKu/s/7LWcBUGEj9Y+AfzqWnWfZdHg8v7pG5f83vDCLmVd5jCey6vp2kj3xl5EZbSNMEPMUoEQn9gs=
X-Received: by 2002:aa7:db04:: with SMTP id t4mr51936277eds.122.1577394742964;
 Thu, 26 Dec 2019 13:12:22 -0800 (PST)
MIME-Version: 1.0
References: <1577210148-7328-1-git-send-email-tom@herbertland.com> <20191225.161927.1679721474728857271.davem@davemloft.net>
In-Reply-To: <20191225.161927.1679721474728857271.davem@davemloft.net>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 26 Dec 2019 13:12:11 -0800
Message-ID: <CALx6S36EUz_KiZ=q-uT-+NYSymBN+LsnmWG5=uMUVkrQKvBnJQ@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 0/9] ipv6: Extension header infrastructure
To:     David Miller <davem@davemloft.net>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 4:19 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Tue, 24 Dec 2019 09:55:39 -0800
>
> > This patchset improves the IPv6 extension header infrastructure
> > to make extension headers more usable and scalable.
> >
> >   - Reorganize extension header files to separate out common
> >     API components
> >   - Create common TLV handler that will can be used in other use
> >     cases (e.g. segment routing TLVs, UDP options)
> >   - Allow registration of TLV handlers
> >   - Elaborate on the TLV tables to include more characteristics
> >   - Add a netlink interface to set TLV parameters (such as
> >     alignment requirements, authorization to send, etc.)
> >   - Enhance validation of TLVs being sent. Validation is strict
> >     (unless overridden by admin) following that sending clause
> >     of the robustness principle
> >   - Allow non-privileged users to set Hop-by-Hop and Destination
> >     Options if authorized by the admin
>
> I see no explanation as to why we want to do this, nor why any of this
> is desirable at all or at any level.
>
> So as in the past, I will keep pushing back on this series because I
> see no real well defined, reasonable, impetus for it.
>
Hi Dave,

The fundamental rationale here is to make various TLVs, in particular
Hop-by-Hop and Destination options, usable, robust, scalable, and
extensible to support emerging functionality.

Specifically, this patch set:

1) Allow modules to register support for Hop-by-Hop and Destination
options. This is useful for development and deployment of new options.
2) Allow non-privileged users to set Hop-by-Hop and Destination
options for their packets or connections. This is especially useful
for options like Path MTU and IOAM options where the information in
the options is both sourced and synced by the application. The
alternative to this would be to create more side interfaces so that
the option can be enabled via the kernel-- such side interfaces would
be overkill IMO.
3) In conjunction with #2, validation of the options being set by an
application is done. The validation for non-privileged users is
purposely strict, but even in the case of privileged user validation
is useful to disallow allow application from sending gibberish (for
instance, now a TLV could be created with a length exceeding the bound
of the extension header).
4) Consolidate various TLV mechanisms. Segment routing should be able
to use the same TLV parsing function, as should UDP options when they
come into the kernel.
5) Option lookup on receive is O(1) instead of list scan.

Subsequent patch set will include:

6) Allow setting specific (Hop-by-Hop and Destination) options on a
socket. This would also allow some options to be set by application
and some might be set by kernel.
7) Allow options processing to be done in the context of a socket.
This will be useful for FAST, PMTU options.
8) Allow experimental IPv6 options in the same way that experimental
TCP options are allowed.
9) Support a robust means extension header insertion. Extension header
insertion is a controversial mechanism that some router vendors are
insisting upon (see ongoing discussion in 6man list). The way they are
currently doing it breaks the stack (particularly ICMP and the way
networks are debug), with proper support I believe we can at least
mitigate the effects of the problems they are creating.
10) Support IPv4 extension headers. This again attempts to address
some horrendous and completely non-robust hacks that are currently
being perpetuated by some router vendors. For instance, some middlebox
implementations are currently overwriting TCP or UDP payload with
their own data with the assumption that a peer device will restore
correct data. If they ever miss fixing up the payload then we now have
systematic silent data corruption (IMO, this very dangerous in a large
scale deployment!). We can offer a better approach...

Tom
