Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63155E77F0
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404234AbfJ1R4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:56:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43044 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730395AbfJ1R4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 13:56:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id n1so3411426wra.10;
        Mon, 28 Oct 2019 10:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yAgZMtf/VMvYmjG/BeZrCrg9OryuwBnaN7WoS0QCndo=;
        b=lsYd+IrBzjmG3qfteumSThkMdXzznfqx5E28vX8HNjBNCvlLPm2zTiCTD9/dTnIovI
         GzciN/1SNDxwcb3dI4c7inPDt3Hn1zePT9aEjzauaWC4X4XHzeI3iOssBTzebbmSBYbK
         iw9dq7cMOa+QfqT6oq7EeynrMbkg0UTIa0UaHj8aoHhyrOud3GUr+5wKjq+B52SUinmq
         rU2NppWWK8r0eepPXqrNWMhh2Byfl47OLXgNpnkgEHVaX8DxEXdrD26CeeGKb+5UpCaz
         +79sOdQIF+WoGFbd5JS8021/3NKCotJ6B/r3XblTC5bxhsVGT8XqxqSRJP6Tz2mgeWMp
         jECA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yAgZMtf/VMvYmjG/BeZrCrg9OryuwBnaN7WoS0QCndo=;
        b=uSXAEKjdn14PZ8nluHJaL3b5vkAGGnv6NgfAPfW6vc3UuWlcFxG2wav9CQkbjrxwtw
         CoLjEJoErGwVU2KXWYAHPZP0HBNjqQPTY7hl7kw7+ZAiPxLgw7YBNpxCcaElvbM33/W3
         ASvqCf2cmoqqgxZ0k7viZNRhg3dnoM30L4EtyxV4w8IeDobBfqNnIFAI9uFqFBS1ovWO
         +T/PMzTOtS0yRdLoGAy8RGNjfmRFyTG8jq+d26Wb/t3NZLYkHHQeNZjixSVUL2GKm4cG
         epj3uiizpRy7PBX7FJxTk0BnFAo/CxyCYSuWTgy+wJ5EI/t4ArpOlqQhNcZG8HILJZxB
         Lv+w==
X-Gm-Message-State: APjAAAVO4S6qrItEd4vdqoU9f4FwEgQ13kSyrMII3GMz0BYLbiaSb5mB
        hQ6UTAOvok1X3w642fAMSpgNRPfAv4neD36BWp8=
X-Google-Smtp-Source: APXvYqxnORJpDwc4s1jCy3Q5X+6OC0fEfKMsIR8ZweCFnT0Pjd7LJxMWaOSFSH1x4BZ/57s6J/Kd17r2Xg5+gEdaz8Q=
X-Received: by 2002:adf:ed02:: with SMTP id a2mr15784221wro.11.1572285399932;
 Mon, 28 Oct 2019 10:56:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191021145149.31657-1-geert+renesas@glider.be> <20191021145149.31657-4-geert+renesas@glider.be>
In-Reply-To: <20191021145149.31657-4-geert+renesas@glider.be>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Mon, 28 Oct 2019 13:56:26 -0400
Message-ID: <CADnq5_Mcs1EzvETV=+XjWZcbJff-bfLycYZ3N+SVE9-KA7U-Sw@mail.gmail.com>
Subject: Re: [PATCH 3/5] drm/amdgpu: Remove superfluous void * cast in
 debugfs_create_file() call
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     =?UTF-8?Q?Breno_Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
        <dri-devel@lists.freedesktop.org>, linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 6:23 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> There is no need to cast a typed pointer to a void pointer when calling
> a function that accepts the latter.  Remove it, as the cast prevents
> further compiler checks.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied.  Thanks!

Alex

> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
> index 5652cc72ed3a9b3a..b97a38b1e089b3d6 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
> @@ -1090,8 +1090,8 @@ int amdgpu_debugfs_init(struct amdgpu_device *adev)
>  {
>         adev->debugfs_preempt =
>                 debugfs_create_file("amdgpu_preempt_ib", 0600,
> -                                   adev->ddev->primary->debugfs_root,
> -                                   (void *)adev, &fops_ib_preempt);
> +                                   adev->ddev->primary->debugfs_root, adev,
> +                                   &fops_ib_preempt);
>         if (!(adev->debugfs_preempt)) {
>                 DRM_ERROR("unable to create amdgpu_preempt_ib debugsfs file\n");
>                 return -EIO;
> --
> 2.17.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
