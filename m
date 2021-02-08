Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B45313A81
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhBHRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbhBHRIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:08:05 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF5C061786;
        Mon,  8 Feb 2021 09:07:25 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f67so13953337ioa.1;
        Mon, 08 Feb 2021 09:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HSRFaWzAQ8UdS4NvVN5o3Zdpy3GIl49ji37O6ltQmPQ=;
        b=YXu0+C3wx7E9PFVQc930kzd0Hkm8H/XXiRwqdWRdZLxwUYqp6XypgWlxBlRPCs0zMW
         rOE4YG5XcfVcr4R7wcAS/1jCPtAs/OYsDGlOBut0NjEc2cqmDxZ2H6ayaDUOyeQkF4Jc
         cel6EpGDo39Nf3IxL6E2rwN1oQTkA6x/Miq+3NChs3ygoOsp75XymphU/zYFlA02MwEm
         pQWvLTgxKfL+JGKYn7ok8X6lCRC6hopHVtKXssw59Wu7/P2Pdx3F8G9HZnjvAvQRdgR7
         K9v/gbpze4sOxUorS5SFLjS2awKITYdBkkxv8nEK+jJUNGm5Comx0JK5MWdJMGTyFKLo
         53wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HSRFaWzAQ8UdS4NvVN5o3Zdpy3GIl49ji37O6ltQmPQ=;
        b=dmBEHO0HKbCxt1HamvLmAfz+/dAkab/8hBK0QGBaHKsW+ZldceuwzAxQWUhdYqVgk9
         MyCF3mtXGx5XU3RjvzUTd9XB2Qz2Qgi83ohz9wPSWCzIeM+8c2t1y+cRFh2u0swPptvW
         jLWj+/0jdBZ/jbttUrKvX9ADR36ENriGO1owolrjs/O/KWpLsVVxSvlSNVlEFxXyp0oQ
         qTEUb9MnTWFvRIHHPtnc42ROXZxaGFPH406YIUyeqbzHsiD6ggYwluDOoN5yCF2rgaFZ
         /AhXJmVS7n/+wOHlQeoGz0P5OzsXnByHbZavf2wbLNeFTck6SnvQUi5MSc+bMvtbvys9
         Fusw==
X-Gm-Message-State: AOAM531yCciRKFmQerYo2j29yKWKQp1NNjE1hPI9Sz45W0N0zAO3kfrc
        oZYep2hEh7kRU9GTdkruKeRF3uW1GAp4qBlxJ6Y=
X-Google-Smtp-Source: ABdhPJyVxRyKIyiPdGFsVg2AUAB6TYewLO37E2XT8zMrav87AZWeYd/58aJkllRI/O9aluviaknaNK/3gLG4MJG1QYs=
X-Received: by 2002:a6b:f708:: with SMTP id k8mr1999806iog.187.1612804044511;
 Mon, 08 Feb 2021 09:07:24 -0800 (PST)
MIME-Version: 1.0
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com> <90961c36-b345-5a7c-5ae8-c7c2311b56a8@gmail.com>
In-Reply-To: <90961c36-b345-5a7c-5ae8-c7c2311b56a8@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 09:07:13 -0800
Message-ID: <CAKgT0Ufw-hF92SWqha+yy4hjA0WVYkAZkqZMdnP=+mTJvmvnNA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] cxgb4: remove changing VPD len
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 2:18 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> Now that the PCI VPD for Chelsio devices from T4 has been changed and VPD
> len is set to PCI_VPD_MAX_SIZE (32K), we don't have to change the VPD len
> any longer.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |  1 -
>  .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 21 ++++---------------
>  2 files changed, 4 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> index 876f90e57..02ccb610a 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_entity.h
> @@ -220,7 +220,6 @@ struct cudbg_mps_tcam {
>         u8 reserved[2];
>  };
>
> -#define CUDBG_VPD_PF_SIZE 0x800
>  #define CUDBG_SCFG_VER_ADDR 0x06
>  #define CUDBG_SCFG_VER_LEN 4
>  #define CUDBG_VPD_VER_ADDR 0x18c7
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> index 75474f810..addac5518 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
> @@ -2689,7 +2689,7 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
>         u32 scfg_vers, vpd_vers, fw_vers;
>         struct cudbg_vpd_data *vpd_data;
>         struct vpd_params vpd = { 0 };
> -       int rc, ret;
> +       int rc;
>
>         rc = t4_get_raw_vpd_params(padap, &vpd);
>         if (rc)
> @@ -2699,24 +2699,11 @@ int cudbg_collect_vpd_data(struct cudbg_init *pdbg_init,
>         if (rc)
>                 return rc;
>
> -       /* Serial Configuration Version is located beyond the PF's vpd size.
> -        * Temporarily give access to entire EEPROM to get it.
> -        */
> -       rc = pci_set_vpd_size(padap->pdev, EEPROMVSIZE);
> -       if (rc < 0)
> -               return rc;
> -
> -       ret = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
> -                                &scfg_vers);
> -
> -       /* Restore back to original PF's vpd size */
> -       rc = pci_set_vpd_size(padap->pdev, CUDBG_VPD_PF_SIZE);
> -       if (rc < 0)
> +       rc = cudbg_read_vpd_reg(padap, CUDBG_SCFG_VER_ADDR, CUDBG_SCFG_VER_LEN,
> +                               &scfg_vers);
> +       if (rc)
>                 return rc;
>
> -       if (ret)
> -               return ret;
> -
>         rc = cudbg_read_vpd_reg(padap, CUDBG_VPD_VER_ADDR, CUDBG_VPD_VER_LEN,
>                                 vpd_str);
>         if (rc)

Assuming that patch 2 is okay then this patch should be fine since it
is just toggling back and forth between the same value anyway.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
