Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D250F379A37
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbhEJWhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:37:40 -0400
Received: from tartarus.angband.pl ([51.83.246.204]:34704 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbhEJWh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 18:37:28 -0400
X-Greylist: delayed 1784 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 18:37:20 EDT
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1lgDtp-00EKjz-Lm; Mon, 10 May 2021 23:57:13 +0200
Date:   Mon, 10 May 2021 23:57:13 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
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
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as ASCII
Message-ID: <YJmsOYzPIsQ04Zxb@angband.pl>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1620641727.git.mchehab+huawei@kernel.org>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 12:26:12PM +0200, Mauro Carvalho Chehab wrote:
> There are several UTF-8 characters at the Kernel's documentation.
[...]
> Other UTF-8 characters were added along the time, but they're easily
> replaceable by ASCII chars.
> 
> As Linux developers are all around the globe, and not everybody has UTF-8
> as their default charset

I'm not aware of a distribution that still allows selecting a non-UTF-8
charset in a normal flow in their installer.  And if they haven't purged
support for ancient encodings, that support is thoroughly bitrotten.
Thus, I disagree that this is a legitimate concern.

What _could_ be a legitimate reason is that someone is on a _terminal_
that can't display a wide enough set of glyphs.  Such terminals are:
 • Linux console (because of vgacon limitations; patchsets to improve
   other cons haven't been mainlined)
 • some Windows terminals (putty, old Windows console) that can't borrow
   glyphs from other fonts like fontconfig can

For the former, it's whatever your distribution ships in
/usr/share/consolefonts/ or an equivalent, which is based on historic
ISO-8859 and VT100 traditions.

For the latter, the near-guaranteed character set is WGL4.


Thus, at least two of your choices seem to disagree with the above:
[dropped]
> 	0xd7   => 'x',		# MULTIPLICATION SIGN
[retained]
> 	- U+2b0d ('⬍'): UP DOWN BLACK ARROW

× is present in ISO-8859, V100, WGL4; I've found no font in
/usr/share/consolefonts/ on my Debian unstable box that lacks this
character.

⬍ is not found in any of the above.  You might want to at least
convert it to ↕ which is at least present in WGL4, and thus likely
to be supported in fonts heeding Windows/Mac/OpenType recommendations.
That still won't make it work on VT.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ .--[ Makefile ]
⣾⠁⢠⠒⠀⣿⡁ # beware of races
⢿⡄⠘⠷⠚⠋⠀ all: pillage burn
⠈⠳⣄⠀⠀⠀⠀ `----
