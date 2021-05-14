Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980AF380515
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 10:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhENIWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 04:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233416AbhENIWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 04:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C728061408;
        Fri, 14 May 2021 08:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620980488;
        bh=gH2wh+Hc0GOhQOIRbo/h4JAX62sDUeKs2tmsR+5ILos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e4qbUbfx0hxY+yj5rwe10X7fv77kQb6ZtXwJRT57564V2F/AP6l30KEqmfnQ8Z9/m
         GbE6KTSFaLVgK/IALz8lgNCCJI09Wv6ypJxw7X8+NYsSH+qLTaA3rBVUJFbnXj6RkO
         OLP+toeaBJ59mDypgIfhUX1EfHY2OFa2Ex63sriWaBCbSg8WSO+y0qdrgc5mMfEUKi
         zoIKuKJCbIWchz7V1P1kNvQQPYr/hVEIXMXwl9v4IpEIdTp9mOKu3ZsGi5lbDjocf7
         LN9AhGRwhMXdDuYb3SF+qI1QUoGfgKM56pIxwAOv5jsDOpM5r9sAA4fr4BFVLy6RmQ
         IhAi7M7Jw2dRw==
Date:   Fri, 14 May 2021 10:21:18 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
Message-ID: <20210514102118.1b71bec3@coco.lan>
In-Reply-To: <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
        <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 12 May 2021 18:07:04 +0100
David Woodhouse <dwmw2@infradead.org> escreveu:

> On Wed, 2021-05-12 at 14:50 +0200, Mauro Carvalho Chehab wrote:
> > Such conversion tools - plus some text editor like LibreOffice  or simi=
lar  - have
> > a set of rules that turns some typed ASCII characters into UTF-8 altern=
atives,
> > for instance converting commas into curly commas and adding non-breakab=
le
> > spaces. All of those are meant to produce better results when the text =
is
> > displayed in HTML or PDF formats. =20
>=20
> And don't we render our documentation into HTML or PDF formats?=20

Yes.

> Are
> some of those non-breaking spaces not actually *useful* for their
> intended purpose?

No.

The thing is: non-breaking space can cause a lot of problems.

We even had to disable Sphinx usage of non-breaking space for
PDF outputs, as this was causing bad LaTeX/PDF outputs.

See, commit: 3b4c963243b1 ("docs: conf.py: adjust the LaTeX document output=
")

The afore mentioned patch disables Sphinx default behavior of
using NON-BREAKABLE SPACE on literal blocks and strings, using this
special setting: "parsedliteralwraps=3Dtrue".

When NON-BREAKABLE SPACE were used on PDF outputs, several parts of=20
the media uAPI docs were violating the document margins by far,
causing texts to be truncated.

So, please **don't add NON-BREAKABLE SPACE**, unless you test
(and keep testing it from time to time) if outputs on all
formats are properly supporting it on different Sphinx versions.

-

Also, most of those came from conversion tools, together with other
eccentricities, like the usage of U+FEFF (BOM) character at the
start of some documents. The remaining ones seem to came from=20
cut-and-paste.

For instance,  bibliographic references (there are a couple of
those on media) sometimes have NON-BREAKABLE SPACE. I'm pretty
sure that those came from cut-and-pasting the document titles
from their names at the original PDF documents or web pages that
are referenced.

> > While it is perfectly fine to use UTF-8 characters in Linux, and specia=
lly at
> > the documentation,  it is better to  stick to the ASCII subset  on such
> > particular case,  due to a couple of reasons:
> >=20
> > 1. it makes life easier for tools like grep; =20
>=20
> Barely, as noted, because of things like line feeds.

You can use grep with "-z" to seek for multi-line strings(*), Like:

	$ grep -Pzl 'grace period started,\s*then' $(find Documentation/ -type f)
	Documentation/RCU/Design/Data-Structures/Data-Structures.rst

(*) Unfortunately, while "git grep" also has a "-z" flag, it
    seems that this is (currently?) broken with regards of handling multili=
nes:

	$ git grep -Pzl 'grace period started,\s*then'
	$

> > 2. they easier to edit with the some commonly used text/source
> >    code editors. =20
>=20
> That is nonsense. Any but the most broken and/or anachronistic
> environments and editors will be just fine.

Not really.

I do use a lot of UTF-8 here, as I type texts in Portuguese, but I rely
on the US-intl keyboard settings, that allow me to type as "'a" for =C3=A1.
However, there's no shortcut for non-Latin UTF-codes, as far as I know.

So, if would need to type a curly comma on the text editors I normally=20
use for development (vim, nano, kate), I would need to cut-and-paste
it from somewhere[1].

[1] If I have a table with UTF-8 codes handy, I could type the UTF-8=20
    number manually... However, it seems that this is currently broken=20
    at least on Fedora 33 (with Mate Desktop and US intl keyboard with=20
    dead keys).

    Here, <CTRL><SHIFT>U is not working. No idea why. I haven't=20
    test it for *years*, as I din't see any reason why I would
    need to type UTF-8 characters by numbers until we started
    this thread.
=20
In practice, on the very rare cases where I needed to write
non-Latin utf-8 chars (maybe once in a year or so, Like when I
would need to use a Greek letter or some weird symbol), there changes
are high that I wouldn't remember its UTF-8 code.

So, If I need to spend time to seek for an specific symbol, after
finding it, I just cut-and-paste it.

But even in the best case scenario where I know the UTF-8 and
<CTRL><SHIFT>U works, if I wanted to use, for instance, a curly
comma, the keystroke sequence would be:

	<CTRL><SHIFT>U201csome string<CTRL><SHIFT>U201d

That's a lot harder than typing and has a higher chances of
mistakenly add a wrong symbol than just typing:

	"some string"

Knowing that both will produce *exactly* the same output, why
should I bother doing it the hard way?

-

Now, I'm not arguing that you can't use whatever UTF-8 symbol you
want on your docs. I'm just saying that, now that the conversion=20
is over and a lot of documents ended getting some UTF-8 characters
by accident, it is time for a cleanup.

Thanks,
Mauro
