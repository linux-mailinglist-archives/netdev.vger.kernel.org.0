Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E768839CAAB
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 21:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFETKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 15:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhFETKd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 15:10:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C76CD61073;
        Sat,  5 Jun 2021 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622920125;
        bh=tTJEbMfaqLm+MQIdZ6b17P+wEJbY3/9z+X1SQ27izYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JkQm3FNW5iQVYmgT/Gt9sN9r1LoTem2cqXUl0EjU+fiv82NY1pLAYU3Bw6unpEki9
         JXsjuSgQIFHSyh38wM93iu29TbJXvLcRhJNrLaI3uPlTWuv27IKsdkFioKL4INshFP
         X6wWHZCeoF+O8iMlmhkcXx84GYrwHdtLzik9jQie2+N1FEL3MtfoR0dRqJZtRSpa3B
         75ZFgP9ntAFhWGSiwsFlzS8kJV4vdjx4gNxci+2IKGEj7omJo8VOW1W/h4rNmExnEf
         Cyd+38BTHzfhwZ6TVmr+dpfprstE/6hddhXmgX9dnEe4dYMoT8QPViKF/MrmqKI8pR
         fNqEWypa3GLOg==
Date:   Sat, 5 Jun 2021 21:08:36 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "=?UTF-8?B?TsOtY29sYXM=?= F. R. A. Prado" <n@nfraprado.net>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        coresight@lists.linaro.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/34] docs: avoid using ReST :doc:`foo` tag
Message-ID: <20210605210836.540577d4@coco.lan>
In-Reply-To: <20210605151109.axm3wzbcstsyxczp@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
        <20210605151109.axm3wzbcstsyxczp@notapiano>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 5 Jun 2021 12:11:09 -0300
N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:

> Hi Mauro,
>=20
> On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab wrote:
> > As discussed at:
> > 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> >=20
> > It is better to avoid using :doc:`foo` to refer to Documentation/foo.rs=
t, as the
> > automarkup.py extension should handle it automatically, on most cases.
> >=20
> > There are a couple of exceptions to this rule:
> >=20
> > 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> > 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> >=20
> > It should also be noticed that automarkup.py has currently an issue:
> > if one use a markup like:
> >=20
> > 	Documentation/dev-tools/kunit/api/test.rst
> > 	  - documents all of the standard testing API excluding mocking
> > 	    or mocking related features.
> >=20
> > or, even:
> >=20
> > 	Documentation/dev-tools/kunit/api/test.rst
> > 	    documents all of the standard testing API excluding mocking
> > 	    or mocking related features.
> > =09
> > The automarkup.py will simply ignore it. Not sure why. This patch series
> > avoid the above patterns (which is present only on 4 files), but it wou=
ld be
> > nice to have a followup patch fixing the issue at automarkup.py. =20
>=20
> What I think is happening here is that we're using rST's syntax for defin=
ition
> lists [1]. automarkup.py ignores literal nodes, and perhaps a definition =
is
> considered a literal by Sphinx. Adding a blank line after the Documentati=
on/...
> or removing the additional indentation makes it work, like you did in your
> 2nd and 3rd patch, since then it's not a definition anymore, although the=
n the
> visual output is different as well.

A literal has a different output. I think that this is not the case, but I=
=20
didn't check the python code from docutils/Sphinx.
=20
> I'm not sure this is something we need to fix. Does it make sense to use
> definition lists for links like that? If it does, I guess one option woul=
d be to
> whitelist definition lists so they aren't ignored by automarkup, but I fe=
el
> this could get ugly really quickly.

Yes, we should avoid handling literal blocks, as this can be a nightmare.

> FWIW note that it's also possible to use relative paths to docs with auto=
markup.

Not sure if you meant to say using something like ../driver-api/foo.rst.
If so, relative paths are a problem, as it will pass unnoticed by this scri=
pt:

	./scripts/documentation-file-ref-check

which is meant to warn when a file is moved to be elsewhere. Ok, it
could be taught to use "../" to identify paths, but I suspect that this
could lead to false positives, like here:

	Documentation/usb/gadget-testing.rst:  # ln -s ../../uncompressed/u
	Documentation/usb/gadget-testing.rst:  # cd ../../class/fs
	Documentation/usb/gadget-testing.rst:  # ln -s ../../header/h

If you meant, instead, :doc:`../foo`, this series address those too.

Regards,
Mauro
