Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B205C4EA
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfGAVUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:20:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35896 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbfGAVUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:20:08 -0400
Received: by mail-qk1-f195.google.com with SMTP id g18so12288218qkl.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=TWsp+Ci3cG3EdUPzHwmfsrPWgFxsFW/NIRYtp0vKG3U=;
        b=RiaOTsErZ8KcpskY5SXl3c3TcBuY7EwdEWSu6UOS7bLuPpKXnSaNyw4YciJKziq+K/
         hxQ36KSdmRd9vsE9+6MAtKt8Ca83dYFRP3VsCyIQfZ0VFT7Y7uHJ7hdniMzVVrfcfF+A
         ADtI7pHo25Dq+tjdSUqE7nBymQ3lRvFGHqnmK3/E5DPF4MG9bDYyJjKgvsmzhwZRA9aP
         EiwwC4+kSva3Q7bLUT1zGvfbq0azHIUXfyYv+2JbceQyrRg43nMB/GeK48oC5I66xsWP
         uwGz+b1w/iaOW6ulrIASlcVGqybVPIHf5wcWnKyzwp5tywehakQecCO4xtfdjyXUdGBc
         /R3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=TWsp+Ci3cG3EdUPzHwmfsrPWgFxsFW/NIRYtp0vKG3U=;
        b=PeReP01276vSLuZ7glzYruXLaDCFO2aI6aOLWjjHshKL0CMvdpwkfeE9kTj42bjuBa
         V1I7EH6rwuFcHfdzpMXPnnZNCeIcyFG7Stz159PGPF4bCDSDArpZyaojShM7uBfGKPCH
         0puuMrLzqpN6xMjPo+b5y9BXkLaYGCXgJqWhwcIEQ1Lc8u5kKUj8y5W/OYlqAgDxVfzr
         KEGlz/Ti/BSCXFrHbZDfCIaztzK1ud/bvihg38YJMiQ3WQgzIUusXo48/Uz5HBnpRUwc
         r3MsHnDNaHzfT60hoOQllabsAjlShrJ3r4tRQTOuhK7hzk3t3On140D/FrsBeNyTYVNz
         cyIg==
X-Gm-Message-State: APjAAAUpFdgsjzhT6t/TvxUuzHWSdANbqWVmVTglP2TZDt0+wCfKzHE+
        8uy/GhQllHnXvi6U4QkrbyFIxQ==
X-Google-Smtp-Source: APXvYqxNT9WoAy1VbQKKLaHtJEHrWiC2xU1PxjaTtlvDwBOTIhiNpzI7sTH6WlBksIE11DhFh+oXHA==
X-Received: by 2002:a37:c248:: with SMTP id j8mr12648978qkm.494.1562016007461;
        Mon, 01 Jul 2019 14:20:07 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x35sm6256872qta.11.2019.07.01.14.20.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 14:20:07 -0700 (PDT)
Date:   Mon, 1 Jul 2019 14:20:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Laatz, Kevin" <kevin.laatz@intel.com>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH 00/11] XDP unaligned chunk placement support
Message-ID: <20190701142002.1b17cc0b@cakuba.netronome.com>
In-Reply-To: <07e404eb-f712-b15a-4884-315aff3f7c7d@intel.com>
References: <20190620083924.1996-1-kevin.laatz@intel.com>
        <FA8389B9-F89C-4BFF-95EE-56F702BBCC6D@gmail.com>
        <ef7e9469-e7be-647b-8bb1-da29bc01fa2e@intel.com>
        <20190627142534.4f4b8995@cakuba.netronome.com>
        <f0ca817a-02b4-df22-d01b-7bc07171a4dc@intel.com>
        <BAE24CBF-416D-4665-B2C9-CE1F5EAE28FF@gmail.com>
        <07e404eb-f712-b15a-4884-315aff3f7c7d@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Jul 2019 15:44:29 +0100, Laatz, Kevin wrote:
> On 28/06/2019 21:29, Jonathan Lemon wrote:
> > On 28 Jun 2019, at 9:19, Laatz, Kevin wrote: =20
> >> On 27/06/2019 22:25, Jakub Kicinski wrote: =20
> >>> I think that's very limiting.=C2=A0 What is the challenge in providing
> >>> aligned addresses, exactly? =20
> >> The challenges are two-fold:
> >> 1) it prevents using arbitrary buffer sizes, which will be an issue=20
> >> supporting e.g. jumbo frames in future.
> >> 2) higher level user-space frameworks which may want to use AF_XDP,=20
> >> such as DPDK, do not currently support having buffers with 'fixed'=20
> >> alignment.
> >> =C2=A0=C2=A0=C2=A0 The reason that DPDK uses arbitrary placement is th=
at:
> >> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - it would stop things working o=
n certain NICs which need the=20
> >> actual writable space specified in units of 1k - therefore we need 2k=
=20
> >> + metadata space.
> >> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - we place padding between buffe=
rs to avoid constantly=20
> >> hitting the same memory channels when accessing memory.
> >> =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 - it allows the application to c=
hoose the actual buffer size=20
> >> it wants to use.
> >> =C2=A0=C2=A0=C2=A0 We make use of the above to allow us to speed up pr=
ocessing=20
> >> significantly and also reduce the packet buffer memory size.
> >>
> >> =C2=A0=C2=A0=C2=A0 Not having arbitrary buffer alignment also means an=
 AF_XDP driver=20
> >> for DPDK cannot be a drop-in replacement for existing drivers in=20
> >> those frameworks. Even with a new capability to allow an arbitrary=20
> >> buffer alignment, existing apps will need to be modified to use that=20
> >> new capability. =20
> >
> > Since all buffers in the umem are the same chunk size, the original=20
> > buffer
> > address can be recalculated with some multiply/shift math. However,=20
> > this is
> > more expensive than just a mask operation. =20
>=20
> Yes, we can do this.

That'd be best, can DPDK reasonably guarantee the slicing is uniform?
E.g. it's not desperate buffer pools with different bases?

> Another option we have is to add a socket option for querying the=20
> metadata length from the driver (assuming it doesn't vary per packet).=20
> We can use that information to get back to the original address using=20
> subtraction.

Unfortunately the metadata depends on the packet and how much info=20
the device was able to extract.  So it's variable length.

> Alternatively, we can change the Rx descriptor format to include the=20
> metadata length. We could do this in a couple of ways, for example,=20
> rather than returning the address as the start of the packet, instead=20
> return the buffer address that was passed in, and adding another 16-bit=20
> field to specify the start of packet offset with that buffer. If using=20
> another 16-bits of the descriptor space is not desirable, an alternative=
=20
> could be to limit umem sizes to e.g. 2^48 bits (256 terabytes should be=20
> enough, right :-) ) and use the remaining 16 bits of the address as a=20
> packet offset. Other variations on these approach are obviously possible=
=20
> too.

Seems reasonable to me..
