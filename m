Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A52E37A2D5
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbhEKJB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:01:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230439AbhEKJBU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:01:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E709E611F1;
        Tue, 11 May 2021 09:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620723613;
        bh=ETvFtPpZWz6DN3iWb3G2WAPhojmYo6ps7EuchaChQ+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PLGy/1LSbmraLJz9I+ZFpgkDxkCfvpVNiHxpQ06jZIl8i8GhyxDYM7Gy1/DkHiCt5
         klo7h/HCiZCdE58jLyhFWvaAVP5oc9x+G/BoSRcOX7C3Tl/sTRBZmSPn8j1vcyPJNt
         mRJS0yxqm/yCxF+CPVj6SxA/ae6jVWIEkJrXhN8oiyzJkjvRZFRVAZch9kSHP1iP93
         oW7IG29Utyoqz+QwiX4h4Rg5Qegv470eEj7pH0f2MN9paDsUyx4y03dGzSMfb4uf2a
         FDLqKCDGwM78HAqr/sdfeYExPB7ah8JOeYwd9qD22mRbJt8d7NaYnvORLTCVIJ25K4
         6sDaroZmf8XGQ==
Date:   Tue, 11 May 2021 11:00:02 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as
 ASCII
Message-ID: <20210511110002.2f187f01@coco.lan>
In-Reply-To: <ed65025c-1087-9672-7451-6d28e7ab8f92@gmail.com>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
        <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
        <20210510135518.305cc03d@coco.lan>
        <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
        <YJk8LMFViV7Z3Uu7@casper.infradead.org>
        <ed65025c-1087-9672-7451-6d28e7ab8f92@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 10 May 2021 15:33:47 +0100
Edward Cree <ecree.xilinx@gmail.com> escreveu:

> On 10/05/2021 14:59, Matthew Wilcox wrote:
> > Most of these
> > UTF-8 characters come from latex conversions and really aren't
> > necessary (and are being used incorrectly). =20
> I fully agree with fixing those.
> The cover-letter, however, gave the impression that that was not the
>  main purpose of this series; just, perhaps, a happy side-effect.

Sorry for the mess. The main reason why I wrote this series is because
there are lots of UTF-8 left-over chars from the ReST conversion.
See:
  - https://lore.kernel.org/linux-doc/20210507100435.3095f924@coco.lan/

A large set of the UTF-8 letf-over chars were due to my conversion work,
so I feel personally responsible to fix those ;-)

Yet, this series has two positive side effects:

 - it helps people needing to touch the documents using non-utf8 locales[1];
 - it makes easier to grep for a text;

[1] There are still some widely used distros nowadays (LTS ones?) that
    don't set UTF-8 as default. Last time I installed a Debian machine
    I had to explicitly set UTF-8 charset after install as the default
    were using ASCII encoding (can't remember if it was Debian 10 or an
    older version).

Unintentionally, I ended by giving emphasis to the non-utf8 instead of
giving emphasis to the conversion left-overs.

FYI, this patch series originated from a discussion at linux-doc,
reporting that Sphinx breaks when LANG is not set to utf-8[2]. That's
why I probably ended giving the wrong emphasis at the cover letter.

[2] See https://lore.kernel.org/linux-doc/20210506103913.GE6564@kitsune.sus=
e.cz/
    for the original report. I strongly suspect that the VM set by Michal=20
    to build the docs was using a distro that doesn't set UTF-8 as default.

    PS.:=20
      I intend to prepare afterwards a separate fix to avoid Sphinx
      logger to crash during Kernel doc builds when the locale charset
      is not UTF-8, but I'm not too fluent in python. So, I need some
      time to check if are there a way to just avoid python log crashes
      without touching Sphinx code and without needing to trick it to=20
      think that the machine's locale is UTF-8.

See: while there was just a single document originally stored at the
Kernel tree as a LaTeX document during the time we did the conversion
(cdrom-standard.tex), there are several other documents stored as=20
text that seemed to be generated by some tool like LaTeX, whose the
original version were not preserved.=20

Also, there were other documents using different markdown dialects=20
that were converted via pandoc (and/or other similar tools). That's=20
not to mention the ones that were converted from DocBook. Such
tools tend to use some logic to use "neat" versions of some ASCII
characters, like what this tool does:

	https://daringfireball.net/projects/smartypants/

(Sphinx itself seemed to use this tool on its early versions)

All tool-converted documents can carry UTF-8 on unexpected places. See,
on this series, a large amount of patches deal with U+A0 (NO-BREAK SPACE)
chars. I can't see why someone writing a plain text document (or a ReST
one) would type a NO-BREAK SPACE instead of a normal white space.

The same applies, up to some sort, to curly commas: usually people just=20
write ASCII "commas" on their documents, and use some tool like LaTeX
or a text editor like libreoffice in order to convert them into
 =E2=80=9Cutf-8 curly commas=E2=80=9D[3].

[3] Sphinx will do such things at the produced output, doing something=20
    similar to what smartypants does, nowadays using this:

	https://docutils.sourceforge.io/docs/user/smartquotes.html

    E. g.:
      - Straight quotes (" and ') turned into "curly" quote characters;
      - dashes (-- and ---) turned into en- and em-dash entities;
      - three consecutive dots (... or . . .) turned into an ellipsis char.

> > You seem quite knowedgeable about the various differences.  Perhaps
> > you'd be willing to write a document for Documentation/doc-guide/
> > that provides guidance for when to use which kinds of horizontal
> > line?
> I have Opinions about the proper usage of punctuation, but I also know =20
>  that other people have differing opinions.  For instance, I place
>  spaces around an em dash, which is nonstandard according to most
>  style guides.  Really this is an individual enough thing that I'm not
>  sure we could have a "kernel style guide" that would be more useful
>  than general-purpose guidance like the page you linked.

> Moreover, such a guide could make non-native speakers needlessly self-
>  conscious about their writing and discourage them from contributing
>  documentation at all.

I don't think so. In a matter of fact, as a non-native speaker, I guess
this can actually help people willing to write documents.

>  I'm not advocating here for trying to push
>  kernel developers towards an eats-shoots-and-leaves level of
>  linguistic pedantry; rather, I merely think that existing correct
>  usages should be left intact (and therefore, excising incorrect usage
>  should only be attempted by someone with both the expertise and time
>  to check each case).
>=20
> But if you really want such a doc I wouldn't mind contributing to it.

IMO, a document like that can be helpful. I can help reviewing it.

Thanks,
Mauro
