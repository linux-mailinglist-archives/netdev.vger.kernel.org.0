Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E888867FAA
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 17:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbfGNPKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 11:10:25 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728440AbfGNPKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 11:10:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=kfltrTJrE3zX7/0aquoXG3ZtLDR7tIyzP8CHDmkORWM=; b=K/3ZWln8pQ5/S/82QEvh320MR
        GxKvRhj461S8yl1Idc2bdc8An7e4c8StSBzkldlTd0Jg0UewJ2RRGg5JjSPC6p8D4/rfG424xXb4U
        fvHK7PmBG+fj2NSqxj4by5+/XjAK+t/iamqHYHAxknHlnxl5eQIazfo7z3/I2C37imCjIXBE18Xn5
        KzQumgLiSPamzlQ9ozcJhla9x0d2DKP8qzihqZzFU3+nlfjgUkK66opfrmZTJHMDmZ1PKWhT5n+CC
        xmEu0Im/DDzQ40V7LRXAUKmFbrpHZORGGnVVQrHoKaAAOKjukrUWAnW9HISaCoF/jsasJMem48pjA
        MeE48xLZA==;
Received: from 201.86.163.160.dynamic.adsl.gvt.net.br ([201.86.163.160] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hmg8o-0004f9-E5; Sun, 14 Jul 2019 15:10:18 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hmg8k-0007Sw-U6; Sun, 14 Jul 2019 12:10:14 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Sean Paul <sean@poorly.run>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Rich Felker <dalias@libc.org>, Takashi Iwai <tiwai@suse.com>,
        Daniel Vetter <daniel@ffwll.ch>, x86@kernel.org,
        alsa-devel@alsa-project.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        linux-sh@vger.kernel.org, David Airlie <airlied@linux.ie>,
        linux-crypto@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        dri-devel@lists.freedesktop.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-input@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/8] docs: some improvements when producing PDF files
Date:   Sun, 14 Jul 2019 12:10:05 -0300
Message-Id: <cover.1563115732.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jon,

This series addresses your concerns related to CJK fonts that are
needed for translations.pdf.

It touches only the documentation build system, not the docs
themselves.

It ended to be bigger than I originally foreseen, as I found several issues
when running "make pdfdocs" for the distros that are recognized by
the  scripts/sphinx-pre-install script.

It also took a lot of time, as I tested it with several VMs (each
one updated to latest packages):

- Fedora 30, CentOS 7, Mageia 7, ArchLinux, Ubuntu 18.04, Gentoo, 
  OpenSuse Tumbleweed.

Patch 1 addresses an issue that could be related to the fact that I
don't use openSUSE. Basically, I was unable to find the right package
for texlive to use CJK fonts on openSUSE. [1]. So, the first patch on this
series adds a workaround: if the needed CJK font is not found on a
system, conf.py won't use xeCjk extension. That sounds a good
thing to have, as other distros may not package it, or maybe the
one building the doc is not that interested on translations.pdf file;

[1] I actually found some, but they are not recognized with the
    font name conf.py is expecting ("Noto Sans CJK SC"). Perhaps
    SUSE uses a different name for those fonts?

Patch 2 fixes the logic with recognizes CentOS/RHEL;

Patch 3 is another workaround: CentOS 7 (and similar distros) don't
package all texlive packages we need. So, it just ignores PDF when
recommending packages on such distros, and point to a URL with
explains how to install TexLive outside distro-specific package
management (for the brave enough people);

Patch 4 fixes latexmk dependency on a few distros;

Patch 5 suppreses a Gentoo specific instruction if the user already
followed in the past;

Patch 6 is the one that actually does what you requested.

Patch 7 solves an issue when SPHINXDIRS is used with make pdfdocs:
right now, using it will produce a lot of warnings and won't do anything,
if a dir-specific conf.py file is not found. With the patch, latex_documents
are now properly updated when SPHINXDIRS is used.

Patch 8 is a cleanup: with patch 7 applied, we don't need to have anymore
any conf.py file due to pdfdocs. 

With regard to the load_config.py extension, It keeps accepting custom
configuration. That's helpful if someone wants, for example, to have
something like:

	Documentation/media/conf_nitpick.py

with would enable extra nitpick options if one wants that.

-

Jon,

Please let me know if you prefer if I submit those together with the big
pile of doc files I have, or if you prefer adding (some of?) them on your
tree after the merge window.

Regards,
Mauro

Mauro Carvalho Chehab (8):
  docs: conf.py: only use CJK if the font is available
  scripts/sphinx-pre-install: fix script for RHEL/CentOS
  scripts/sphinx-pre-install: don't use LaTeX with CentOS 7
  scripts/sphinx-pre-install: fix latexmk dependencies
  scripts/sphinx-pre-install: cleanup Gentoo checks
  scripts/sphinx-pre-install: seek for Noto CJK fonts for pdf output
  docs: load_config.py: avoid needing a conf.py just due to LaTeX docs
  docs: remove extra conf.py files

 Documentation/admin-guide/conf.py      |  10 ---
 Documentation/conf.py                  |  13 ++-
 Documentation/core-api/conf.py         |  10 ---
 Documentation/crypto/conf.py           |  10 ---
 Documentation/dev-tools/conf.py        |  10 ---
 Documentation/doc-guide/conf.py        |  10 ---
 Documentation/driver-api/80211/conf.py |  10 ---
 Documentation/driver-api/conf.py       |  10 ---
 Documentation/driver-api/pm/conf.py    |  10 ---
 Documentation/filesystems/conf.py      |  10 ---
 Documentation/gpu/conf.py              |  10 ---
 Documentation/input/conf.py            |  10 ---
 Documentation/kernel-hacking/conf.py   |  10 ---
 Documentation/maintainer/conf.py       |  10 ---
 Documentation/media/conf.py            |  12 ---
 Documentation/networking/conf.py       |  10 ---
 Documentation/process/conf.py          |  10 ---
 Documentation/sh/conf.py               |  10 ---
 Documentation/sound/conf.py            |  10 ---
 Documentation/sphinx/load_config.py    |  25 +++++-
 Documentation/userspace-api/conf.py    |  10 ---
 Documentation/vm/conf.py               |  10 ---
 Documentation/x86/conf.py              |  10 ---
 scripts/sphinx-pre-install             | 118 ++++++++++++++++++++-----
 24 files changed, 131 insertions(+), 237 deletions(-)
 delete mode 100644 Documentation/admin-guide/conf.py
 delete mode 100644 Documentation/core-api/conf.py
 delete mode 100644 Documentation/crypto/conf.py
 delete mode 100644 Documentation/dev-tools/conf.py
 delete mode 100644 Documentation/doc-guide/conf.py
 delete mode 100644 Documentation/driver-api/80211/conf.py
 delete mode 100644 Documentation/driver-api/conf.py
 delete mode 100644 Documentation/driver-api/pm/conf.py
 delete mode 100644 Documentation/filesystems/conf.py
 delete mode 100644 Documentation/gpu/conf.py
 delete mode 100644 Documentation/input/conf.py
 delete mode 100644 Documentation/kernel-hacking/conf.py
 delete mode 100644 Documentation/maintainer/conf.py
 delete mode 100644 Documentation/media/conf.py
 delete mode 100644 Documentation/networking/conf.py
 delete mode 100644 Documentation/process/conf.py
 delete mode 100644 Documentation/sh/conf.py
 delete mode 100644 Documentation/sound/conf.py
 delete mode 100644 Documentation/userspace-api/conf.py
 delete mode 100644 Documentation/vm/conf.py
 delete mode 100644 Documentation/x86/conf.py

-- 
2.21.0


