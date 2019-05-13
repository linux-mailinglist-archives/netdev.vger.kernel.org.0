Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 015691B13C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 09:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfEMHgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 03:36:00 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:37960 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfEMHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 03:35:59 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 231832DC0069;
        Mon, 13 May 2019 03:35:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1557732958;
        bh=aa+i95blYOSxhGwoRx9zFnMo5oG4XUfXT748BNmFJIU=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date:From;
        b=aSet9rLYykQxcyXFS2GF9u8JjdaPfKwlu1qpX3Ek5B3X+zmGgF+1WtmJH8QDHUKVR
         POJW18jnNWqKlc9WV/y9wswfLzQAdORTjoBGt6wbLb+XQzz+YSA8YT8exQIamI1hKA
         NgBZZqdAOIFcj5X4mKMcpOALzVECo4ayuE60g+CPH7CvPt6lSOfmFpWRNnpn+wYPF4
         P6SqYrz3uRsFocaNWbLb6GRXp8TE8CKtYMYUEeB/QfMAnGJ7U/FZrL/hYqxDE0ryBG
         /8/mtlXRqGs0pBJCO5WKEQDm1lzWRXt40l8YPyEBjUBm/McmvG1Iafbx2EfRhysC43
         vKIF2BpJNTxkposUCWaXgJuoNekulC6f7wlHUlNkNooeQHpAKXYuClI/ikmvCrnCff
         Vy/fK7azMrun4S9M5k0UdX9IUayiM9Y1AVv1iAHjIJrMhP8ELgeNkTypKa35MyJMjx
         LmIQVy3zVwlAOW1mMnZhrLapo90FKO26dOcJq140LOTx0ZahhIuR6KISKy+FuwYBfp
         cNemDFNeNEkfGRWxw0VhCsOArzkI9iJJSDwhVYx2DI4O1xJX2kFEObBeq4rx25ClRK
         PDCjVeuymuPU3aUBQKrJtdTxur1fcbH6SvSnl3OKtvCVGly9Za8zstBXG1KdRUNuvp
         kOJclMVcOxeDGLfkA1Mcr7AQ=
Received: from Hawking (ntp.lan [10.0.1.1])
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x4D7ZjC4057687
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 13 May 2019 17:35:46 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Alastair D'Silva'" <alastair@au1.ibm.com>
Cc:     "'Jani Nikula'" <jani.nikula@linux.intel.com>,
        "'Joonas Lahtinen'" <joonas.lahtinen@linux.intel.com>,
        "'Rodrigo Vivi'" <rodrigo.vivi@intel.com>,
        "'David Airlie'" <airlied@linux.ie>,
        "'Daniel Vetter'" <daniel@ffwll.ch>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Karsten Keil'" <isdn@linux-pingi.de>,
        "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        "'Tom Lendacky'" <thomas.lendacky@amd.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>,
        "'Kalle Valo'" <kvalo@codeaurora.org>,
        "'Stanislaw Gruszka'" <sgruszka@redhat.com>,
        "'Benson Leung'" <bleung@chromium.org>,
        "'Enric Balletbo i Serra'" <enric.balletbo@collabora.com>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Alexander Viro'" <viro@zeniv.linux.org.uk>,
        "'Petr Mladek'" <pmladek@suse.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steven Rostedt'" <rostedt@goodmis.org>,
        "'David Laight'" <David.Laight@aculab.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Intel Graphics Development'" <intel-gfx@lists.freedesktop.org>,
        "'DRI Development'" <dri-devel@lists.freedesktop.org>,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        "'netdev'" <netdev@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "'linux-wireless'" <linux-wireless@vger.kernel.org>,
        "'scsi'" <linux-scsi@vger.kernel.org>,
        "'Linux Fbdev development list'" <linux-fbdev@vger.kernel.org>,
        "'driverdevel'" <devel@driverdev.osuosl.org>,
        "'Linux FS Devel'" <linux-fsdevel@vger.kernel.org>
References: <20190508070148.23130-1-alastair@au1.ibm.com> <20190508070148.23130-4-alastair@au1.ibm.com> <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q@mail.gmail.com>
In-Reply-To: <CAMuHMdVefYTgHzGKBc0ebku1z8V3wsM0ydN+6-S2nFKaB8eH_Q@mail.gmail.com>
Subject: RE: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines of repeated bytes
Date:   Mon, 13 May 2019 17:35:47 +1000
Message-ID: <04de01d5095e$7f6af730$7e40e590$@d-silva.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-au
Thread-Index: AQGz7QD7bMLLz3XdMyQiMIIzLY+D4AJkmwv+AXBy99KmjDiokA==
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Mon, 13 May 2019 17:35:53 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Sent: Monday, 13 May 2019 5:01 PM
> To: Alastair D'Silva <alastair@au1.ibm.com>
> Cc: alastair@d-silva.org; Jani Nikula <jani.nikula@linux.intel.com>; =
Joonas
> Lahtinen <joonas.lahtinen@linux.intel.com>; Rodrigo Vivi
> <rodrigo.vivi@intel.com>; David Airlie <airlied@linux.ie>; Daniel =
Vetter
> <daniel@ffwll.ch>; Dan Carpenter <dan.carpenter@oracle.com>; Karsten
> Keil <isdn@linux-pingi.de>; Jassi Brar <jassisinghbrar@gmail.com>; Tom
> Lendacky <thomas.lendacky@amd.com>; David S. Miller
> <davem@davemloft.net>; Jose Abreu <Jose.Abreu@synopsys.com>; Kalle
> Valo <kvalo@codeaurora.org>; Stanislaw Gruszka <sgruszka@redhat.com>;
> Benson Leung <bleung@chromium.org>; Enric Balletbo i Serra
> <enric.balletbo@collabora.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Alexander Viro
> <viro@zeniv.linux.org.uk>; Petr Mladek <pmladek@suse.com>; Sergey
> Senozhatsky <sergey.senozhatsky@gmail.com>; Steven Rostedt
> <rostedt@goodmis.org>; David Laight <David.Laight@aculab.com>; Andrew
> Morton <akpm@linux-foundation.org>; Intel Graphics Development <intel-
> gfx@lists.freedesktop.org>; DRI Development <dri-
> devel@lists.freedesktop.org>; Linux Kernel Mailing List <linux-
> kernel@vger.kernel.org>; netdev <netdev@vger.kernel.org>;
> ath10k@lists.infradead.org; linux-wireless =
<linux-wireless@vger.kernel.org>;
> scsi <linux-scsi@vger.kernel.org>; Linux Fbdev development list =
<linux-
> fbdev@vger.kernel.org>; driverdevel <devel@driverdev.osuosl.org>; =
Linux
> FS Devel <linux-fsdevel@vger.kernel.org>
> Subject: Re: [PATCH v2 3/7] lib/hexdump.c: Optionally suppress lines =
of
> repeated bytes
>=20
> Hi Alastair,
>=20
> Thanks for your patch!

And thanks for your politeness :)

>=20
> On Wed, May 8, 2019 at 9:04 AM Alastair D'Silva <alastair@au1.ibm.com>
> wrote:
> > From: Alastair D'Silva <alastair@d-silva.org>
> >
> > Some buffers may only be partially filled with useful data, while =
the
> > rest is padded (typically with 0x00 or 0xff).
> >
> > This patch introduces a flag to allow the supression of lines of
> > repeated bytes,
>=20
> Given print_hex_dump() operates on entities of groupsize (1, 2, 4, or =
8)
> bytes, wouldn't it make more sense to consider repeated groups instead =
of
> repeated bytes?

Maybe, it would mean that subsequent addresses may not be a multiple of =
rowsize though, which is useful.

> > which are replaced with '** Skipped %u bytes of value 0x%x **'
>=20
> Using a custom message instead of just "*", like "hexdump" uses, will =
require
> preprocessing the output when recovering the original binary data by
> feeding it to e.g. "xxd".
> This may sound worse than it is, though, as I never got "xxd" to work =
without
> preprocessing anyway ;-)

I think showing the details of the skipped values is useful when reading =
the output directly. In situations where binary extracts are desired, =
the feature can always be disabled.

--=20
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva     msn: alastair@d-silva.org
blog: http://alastair.d-silva.org    Twitter: @EvilDeece



