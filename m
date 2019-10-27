Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26343E6530
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfJ0UA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:00:28 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43652 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfJ0UA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 16:00:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id l15so4965498qtr.10;
        Sun, 27 Oct 2019 13:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=x+WfWwtwB/Isht1ifjFrERqUhi4H5M7ftwjAV6a8H14=;
        b=RA8+ZC7++hpIdQKh9fFtIODvN08B4xk9vtjjKXe6wwtTAevy9wVFiGibBprnzj3uUX
         IfpQnt5B7AbXg9IM2j33+59laKSfMGaGQ/ifGehvhg7K7p6Mhd0Kw/ZQjX8XW2vlyFhB
         7I5WWsi3UTZw8MGWftDz7NvJziW/6R/XsC9s1wclNQQuUaV9edldqg33xkmAs67ZCsE3
         UmLXxfPoXDCBp7HdMfrBHZ9hxtyhYQfi3y7LYt5SYIcGRUfkpw7e7mbDY6pxR0FlXZl+
         wiupXdTgysOKJ6xQa5k4qaYoPG06ry1P7PllcYYHThg3k203qv7lALhfoOZ9OUXUcvwa
         IM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x+WfWwtwB/Isht1ifjFrERqUhi4H5M7ftwjAV6a8H14=;
        b=pfsh+uJ+fTXIeFh0K+z1DgzcC4HEjxbIejkkvYVqTkYejVurkGeAUN2lhty1n4MGNX
         Xj31Eu58V2V7wZwO+0GnZkjHa21wR5/qG49KDITb/EakjFeEx/LJIJ0UeHUSGFKR3BEH
         Rlv2MwzuCneZEwQQO96wHkRHe4bNLru8OtSmEKSPDHv/TYpbbHuFPgS9JdMiXGtijFEs
         t0AFUFA3C5o+reSIGlgZj1n5aXRGYt4fRjyIZg3umsy7+8pcCkEUXGoeFOEGmHj2TZAL
         tRmpky0NFC3fzcNTNA3Dmhz1da+UMVTfVUwiNHre8ShnIPnCvbUbXcy98S1AUkyceWx8
         mXMg==
X-Gm-Message-State: APjAAAUKR0Te0yMLtq4S6/wG0uRzdEv5SkO77pHhokPzbmNOzZpGVV52
        PqAVapKrBapuZNCNiOx2t9zTZUikSGcsFW6KYlc=
X-Google-Smtp-Source: APXvYqxtZZDwsyMMeZO43RXJemx5uHeatLHpj6GyXaY4rAcamKHinvfgt6IvvmgvIpDfaIPVbSZgSXiXGZ3FoGVlkKc=
X-Received: by 2002:ac8:108e:: with SMTP id a14mr13698954qtj.171.1572206426170;
 Sun, 27 Oct 2019 13:00:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132107.237336-1-toke@redhat.com> <CAEf4BzZAutRXf+W+ExaHjFMtWCfot9HkTWZNGuPckBiXqFcJeQ@mail.gmail.com>
 <87sgnejvij.fsf@toke.dk>
In-Reply-To: <87sgnejvij.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 27 Oct 2019 13:00:15 -0700
Message-ID: <CAEf4BzYC6U-QC48nRkicb9YHNt+6xPkQAmTZcoEFt+u_vkExYw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_set_log_level() function to
 adjust logging
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 4:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Oct 25, 2019 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Currently, the only way to change the logging output of libbpf is to
> >> override the print function with libbpf_set_print(). This is somewhat
> >> cumbersome if one just wants to change the logging level (e.g., to ena=
ble
> >
> > No, it's not.
>
> Yes, it is :)

As much fun as it is to keep exchanging subjective statements, I won't
do that. I'll just say that having written a bunch of applications
utilizing libbpf and speaking with people (not libbpf contributors)
who have write their own apps w/ libbpf, setting up custom logging
hook was never mentioned as a problem, not even a single time.

I'll go even further and will say that the fact that libbpf (a
library) can print out something to application's stderr is already
pretty bad behavior and for big production applications is a big
no-no. Library shouldn't pollute program's stdout/stderr with extra
unsolicited output. We might actually consider changing that
eventually.

>
> > Having one way of doing things is good, proliferation of APIs is not a
> > good thing. Either way you require application to write some
> > additional code. Doing simple vprintf-based (or whatever application
> > is using to print logs, which libbpf shouldn't care about!) function
> > with single if is not hard and is not cumbersome.
>
> The print function registration is fine for applications that want to
> control its own logging in detail.
>
> This patch is about lowering barriers to entry for people who are
> starting out with libbpf, and just want to find out why their program
> isn't doing what it's supposed to. Which is not the point to go figure
> out an arcane function pointer-based debugging setup API just to get

Which aspect you find arcane? that's it's a callback? that's it as
function pointer? that it's using va_list? what exactly is confusing
here?

> some help. Helping users in this situation is the friendly thing to do,
> and worth the (quite limited) cost of adding this mechanism.

It is not a small cost. It's a new mechanism and a new set of
conventions, which are not orthogonal to existing logging mechanism
and can easily break. If application sets its own debugging callback
(and your specific user might not even know about this, because he's
working on an application, which has a separate libbpf initialization
part done by someone else), this new API will do absolutely nothing,
confusing people as much or even more.

Further, this is introducing a new global state that we need to
maintain. We've been ignoring multi-threading concerns so far, but
this will have to stop and we'll need to deal with the need to
synchronize things, at least for global state. So adding more global
stuff is bad and has its costs.

>
> If you're objecting to the new API function, an alternative could be to
> react to an environment variable? I.e., turn on debugging of
> LIBBPF_DEBUG=3D1 is in the environment? That way, users wouldn't even hav=
e
> to add the extra function call, they could just re-run their application
> with the env var set on the command line...

Should this envvar be re-read every time libbpf might log something?
Or just once before libbpf is initialized? If the latter, when
precisely this envvar should be read? before first bpf_object is open?
or we should re-read every time new bpf_object is open? And so on...

Or, why not, say, a special agreed-upon (or maybe it should be
overridable through extra options) file somewhere, that will control
logging verbosity? Or maybe we should support a custom (and, of
course, optional) signal handler to be installed so that we can
trigger more verbose libbpf output without having to restart a
long-running application?

All this would be very helpful for some specific subset of situations,
but that doesn't mean that libbpf has to support all these custom
cases. It already provides a generic and easy to use mechanism to let
application decide for itself what it wants to do. And we should keep
it that way.

>
> > If you care about helping users to be less confused on how to do that,
> > I think it would be a good idea to have some sort of libbpf-specific
> > FAQ with code samples on how to achieve typical and common stuff, like
> > this one. So please instead consider doing that.
>
> The fact that you're suggesting putting in a FAQ entry on *how to enable
> debug logging* should be proof enough that the current API is
> confusing...

No, I'm suggesting, if you really think libbpf's logging is confusing,
to rather spend your efforts on writing a tiny piece of documentation
explaining how libbpf logging is done and, as a simple example, show
how to do verbose logging to stderr. That way you'll eliminate any
confusion explicitly, instead of adding another API call that: 1)
confused user will still have to find and 2) will now have to figure
out why the hell libbpf has two different ways to do logging, one of
them working only under a specific set of circumstances.

>
> -Toke
>
