Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19408B9F98
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 21:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388127AbfIUTaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 15:30:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34924 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbfIUTaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 15:30:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so6661137pfw.2
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 12:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=N5OUyVGtqkwJdXry+NIP0y5qN8tV/VizLt1lN/4K5Rw=;
        b=mi9XAYzB2MduS18nvOzNl01eeEfLpwRzDoIIfcSrvA1/4QNcM0DN76fTPJ7a6htoKy
         UiIlecOJvclP2+7id4hxPM5S47JdEZ0ndN9W5bGarQXDQitRomrvJNyB10NuvkYypQQ3
         5Bs4CiG2cWA7kJ47dxguaCH7M06kSl09ZygnNB6ChuAciICf2GgycBK19AWeOH4HieT1
         5M0uwajwZp/7GZQz0RO/BShNY/2d22OyNBm6WQKpVS6ezVERnTp3l5kqz/cge4yB2BtJ
         2k0zsFoJ3m0TGZCaJm54yY1S9igLxOz7j7qHBO4XM1RLz5HX37IOv4QmE6PA1DHOko4E
         +vsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=N5OUyVGtqkwJdXry+NIP0y5qN8tV/VizLt1lN/4K5Rw=;
        b=VMRgayoUNq1rbInpcJL8NfyAbT77p6AmN1nQiAoQyeZU24UYavdn9RpQhCkENNRvEF
         dwHlULkRPXXeMpXUInupt3dtw/03+5Ysf/hzWi8EWn9k3++a5xRTOX5tVUBHn9dnca3T
         +Vpr8iMcDX4MIoU6vb/TyWYMQCf+WZujs0qYsXWgtACLU0Ldiwq3ZyB2eg2OMmhYLnHT
         BwjmVp969+/e0n53TEW/R/bg30EXvz1YbYx3s0s7G3ZIEztAhpISl2uQZRDn8CD6nCs8
         /6fCfYHr/gmckZuuVOLOSPhNhVVrWX9L2/s+7F2yaMBKora83dtexGaAQvrWcuX/F+r/
         YCGg==
X-Gm-Message-State: APjAAAUY791B49JKLBB1humUmrTdt4XmJmJ5cuanBTOSIHwN4PE5+XMp
        7+MZ875jX5UORTahhhUE6IpIew==
X-Google-Smtp-Source: APXvYqz7rTy0ENkxJK88emu6Te1Q/1M3x5X/ooaxKlS5Weh+TPB0yvNWhCqtGF/MRIQgGC2pk3yXgA==
X-Received: by 2002:a62:2ad6:: with SMTP id q205mr24243390pfq.46.1569094209963;
        Sat, 21 Sep 2019 12:30:09 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id z3sm6962724pjd.25.2019.09.21.12.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 12:30:09 -0700 (PDT)
Date:   Sat, 21 Sep 2019 12:30:06 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH net,stable] usbnet: ignore endpoints with invalid
 wMaxPacketSize
Message-ID: <20190921123006.64d36883@cakuba.netronome.com>
In-Reply-To: <87h855g68k.fsf@miraculix.mork.no>
References: <20190918121738.6343-1-bjorn@mork.no>
        <20190920190303.149da58a@cakuba.netronome.com>
        <87h855g68k.fsf@miraculix.mork.no>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 14:54:03 +0200, Bj=C3=B8rn Mork wrote:
> Jakub Kicinski <jakub.kicinski@netronome.com> writes:
> > On Wed, 18 Sep 2019 14:17:38 +0200, Bj=C3=B8rn Mork wrote: =20
> >> Endpoints with zero wMaxPacketSize are not usable for transferring
> >> data. Ignore such endpoints when looking for valid in, out and
> >> status pipes, to make the drivers more robust against invalid and
> >> meaningless descriptors.
> >>=20
> >> The wMaxPacketSize of these endpoints are used for memory allocations
> >> and as divisors in many usbnet minidrivers. Avoiding zero is therefore
> >> critical.
> >>=20
> >> Signed-off-by: Bj=C3=B8rn Mork <bjorn@mork.no> =20
> >
> > Fixes tag would be useful. I'm not sure how far into stable we should
> > backport this. =20
>=20
> That would be commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), so I don't think
> a Fixes tag is very useful...

It's slightly useful to add it anyway, IMHO, even if it's 2.6.12,
because it may save people processing the patch checking how far
it applies. You already did the research, anyway.

Granted, that's a little `process-centric`, rather than `merit-centric`
view.

> I haven't verified how deep into the code you have been able to get with
> wMaxPacketSize being zero.  But I don't think there ever has been much
> protection since it's so obviously "insane".  There was no point in
> protecting against this as long as we considered the USB port a security
> barrier.
>=20
> I see that the v2.6.12-rc2 version of drivers/usb/net/usbnet.c (sic)
> already had this in it's genelink_tx_fixup():
<snip>

Thanks for the detailed analysis!

> So, to summarize:  I believe the fix is valid for all stable versions.
>=20
> I'll leave it up to the more competent stable maintainers to decide how
> many, if any, it should be backported to.  I will not cry if the answer
> is none.

Right, I'll put it in the stable queue, we'll see if it passes Dave's=20
and Greg's filters :)

> > Is this something that occurs on real devices or protection from
> > malicious ones? =20
>=20
> Only malicious ones AFAICS.
>=20
> I don't necessarily agree, but I believe the current policy makes this a
> "security" issue.  CVEs have previously been allocated for similar
> crashes triggered by buggy USB descriptors.  For some reason we are
> supposed to protect the system against *some* types of malicious
> hardware.

I see, the patch is fairly intrusive and very unlikely to cause to lead
to regressions on real devices, so regardless of the practical impact
shouldn't hurt.

> I am looking forward to the fixes coming up next to protect against
> malicious CPUs and microcode ;-)

I hope not before we retire..

Applied, queued for stable, thank you!
