Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EDE19FDDB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDFTHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:07:06 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34133 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgDFTHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:07:06 -0400
Received: by mail-qt1-f194.google.com with SMTP id 14so718517qtp.1;
        Mon, 06 Apr 2020 12:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lZeDLbiW+mo56bzDSgHAprymaonj9lFYTP3H0Hpk8ks=;
        b=ZfRKaMUXPetktgkfrJdTiBOk52hFhx3+WH17XS9mNajbbUiB3+WfaYbISd9DU/kL34
         diRAUsgXQjkUolJ0Y37YVKmnxHiuFVJd9warjxujP1dojH6o52mYYspwgB8r8+xHpjSm
         94I84UTeCpByKb34Bsq6ZgtLBrqxGaaPKrNXhEuEIKpYVvkZeOlaX/swt9TF1yw/FU+Z
         JGRK0W+QjIV5PtcHzKPSgJUavcFmEdF6hbWD4wrsG6VRxnQi6ofF16SM47HI9Z8TTtit
         alQOQpMrImVStD1CLc8ETZsCLW3Z+on9R+w0cCuRtneQ0yq9MDzkh0xYJNj3RZqwPMtu
         d//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lZeDLbiW+mo56bzDSgHAprymaonj9lFYTP3H0Hpk8ks=;
        b=fUIhgllZ0LODUJGw8XzJFOEngbBKUS1CDA213PiVAUzlc1uCe4VwnK9avQtSKE1p/U
         u+9h6CyicZmx77czXTZ/iMPQCoK7ky/UO5GGa84ZIEolG+kkb3zPy8EJ9giaN8nSm/EQ
         fJg50G9ZvwGtwgNAXTbhYqka4gt2J1DyJ5a1yBiiTYlRrgwZ0Xt5EK6iOyVbxi5SgzrS
         AyECvlz7SNSwooyr9zEPrmJtpBtXwjcLPHABt2eos39e6LK+FcChl2Mh1OFai3g88JoS
         KbiJKfNy8zQ8LvzSes5aWK8qgG1E5cBOJfNT+e3vW/m3X8h5hqQ7cUjHPDZ7+TwzS8Y2
         ZzTg==
X-Gm-Message-State: AGi0Pubtc+mjP+l6CeX7sz5BfI3iKlsZqP647Mo0UQxYPYNf2ZaxFXOd
        pNqjmuHRYlRF1eGq+cPeBS0gAiz8tXBcJikFSH0D21YO
X-Google-Smtp-Source: APiQypITUf1eoUPzRCRcIOpF8mEtBPBbeuxd9vCDtzgR5VwHNx2RpKMLTMN1Z+HVDZ1G+YlQLDKhPzItgJVLBAy1Adg=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr978248qtj.93.1586200025423;
 Mon, 06 Apr 2020 12:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-5-andriin@fb.com>
 <87pnckc0fr.fsf@toke.dk>
In-Reply-To: <87pnckc0fr.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 6 Apr 2020 12:06:54 -0700
Message-ID: <CAEf4BzYrW43EW_Uneqo4B6TLY4V9fKXJxWj+-gbq-7X0j7y86g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/8] bpf: support GET_FD_BY_ID and
 GET_NEXT_ID for bpf_link
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 4:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add support to look up bpf_link by ID and iterate over all existing bpf=
_links
> > in the system. GET_FD_BY_ID code handles not-yet-ready bpf_link by chec=
king
> > that its ID hasn't been set to non-zero value yet. Setting bpf_link's I=
D is
> > done as the very last step in finalizing bpf_link, together with instal=
ling
> > FD. This approach allows users of bpf_link in kernel code to not worry =
about
> > races between user-space and kernel code that hasn't finished attaching=
 and
> > initializing bpf_link.
> >
> > Further, it's critical that BPF_LINK_GET_FD_BY_ID only ever allows to c=
reate
> > bpf_link FD that's O_RDONLY. This is to protect processes owning bpf_li=
nk and
> > thus allowed to perform modifications on them (like LINK_UPDATE), from =
other
> > processes that got bpf_link ID from GET_NEXT_ID API. In the latter case=
, only
> > querying bpf_link information (implemented later in the series) will be
> > allowed.
>
> I must admit I remain sceptical about this model of restricting access
> without any of the regular override mechanisms (for instance, enforcing
> read-only mode regardless of CAP_DAC_OVERRIDE in this series). Since you
> keep saying there would be 'some' override mechanism, I think it would
> be helpful if you could just include that so we can see the full
> mechanism in context.

I wasn't aware of CAP_DAC_OVERRIDE, thanks for bringing this up.

One way to go about this is to allow creating writable bpf_link for
GET_FD_BY_ID if CAP_DAC_OVERRIDE is set. Then we can allow LINK_DETACH
operation on writable links, same as we do with LINK_UPDATE here.
LINK_DETACH will do the same as cgroup bpf_link auto-detachment on
cgroup dying: it will detach bpf_link, but will leave it alive until
last FD is closed.

We need to consider, though, if CAP_DAC_OVERRIDE is something that can
be disabled for majority of real-life applications to prevent them
from doing this. If every realistic application has/needs
CAP_DAC_OVERRIDE, then that's essentially just saying that anyone can
get writable bpf_link and do anything with it.

>
> -Toke
>
