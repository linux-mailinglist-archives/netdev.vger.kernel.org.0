Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621CC37A38B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 11:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhEKJ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 05:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230427AbhEKJ00 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 05:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAA5561469;
        Tue, 11 May 2021 09:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620725119;
        bh=SxEDkhQ4NDmmQJU/qD2f8WKt2ZN30zjdTiLd/JmT63A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qYIzsO6/tiOl8TGJ6a2eiShRAv5ZaMzH0UMz1Okj8KRt9xtY+LR/anIcVUrTbZiX4
         89BZ53+EXyXMYuHsL+U06kiuxNXt/5HwXMQCdDP/VjD4quHGFE+7gbD3gJVXax5DaY
         uPQ39ZXYcixN6FyJ12+nOvdmqwpol10wPiVFzbtkGhu9sXEQXyPXQcHwYGaPn1WAFe
         4EHVQRoUTs78Ah0GJIhGex565u4aOD5+o97KCk6BlvJCrZe2QVlJEyby3BUR9BJh2D
         ihJkCCdqkHc4Kaa3576AZpMqo1MX3GKHjJMVLdhoGH+hccpOnzojw8qINBpykxkRxP
         IMzqRB+GVylEA==
Date:   Tue, 11 May 2021 11:25:08 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
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
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as
 ASCII
Message-ID: <20210511112508.4547bca8@coco.lan>
In-Reply-To: <de6d1fa5b7934f4afd61370d9c58502bef588466.camel@infradead.org>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
        <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
        <20210510135518.305cc03d@coco.lan>
        <de6d1fa5b7934f4afd61370d9c58502bef588466.camel@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 10 May 2021 14:49:44 +0100
David Woodhouse <dwmw2@infradead.org> escreveu:

> On Mon, 2021-05-10 at 13:55 +0200, Mauro Carvalho Chehab wrote:
> > This patch series is doing conversion only when using ASCII makes
> > more sense than using UTF-8.=20
> >=20
> > See, a number of converted documents ended with weird characters
> > like ZERO WIDTH NO-BREAK SPACE (U+FEFF) character. This specific
> > character doesn't do any good.
> >=20
> > Others use NO-BREAK SPACE (U+A0) instead of 0x20. Harmless, until
> > someone tries to use grep[1]. =20
>=20
> Replacing those makes sense. But replacing emdashes =E2=80=94 which are a
> distinct character that has no direct replacement in ASCII and which
> people do *deliberately* use instead of hyphen-minus =E2=80=94 does not.
>=20
> Perhaps stick to those two, and any cases where an emdash or endash has
> been used where U+002D HYPHEN-MINUS *should* have been used.

Ok. I'll rework the series excluding EM/EN DASH chars from it.
I'll then apply manually the changes for EM/EN DASH chars=20
(probably on a separate series) where it seems to fit. That should
make easier to discuss such replacements.

> And please fix your cover letter which made no reference to 'grep', and
> only presented a completely bogus argument for the change instead.

OK!

Regards,
Mauro
