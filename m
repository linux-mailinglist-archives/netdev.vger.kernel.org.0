Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017DF313A51
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhBHRA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:00:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhBHRAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:00:04 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE1CDC061786;
        Mon,  8 Feb 2021 08:59:24 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id y17so13360820ili.12;
        Mon, 08 Feb 2021 08:59:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LGzOoaHfO6ykiKcUqxsrDL6YrTaESwHASHuVknVgqFA=;
        b=PoJgzz7Q6EDnRAZbB3MHO1cSjrYWFDKlCCJwE4IACpFhYoQ0nUu3+oVgiIqITVWmIX
         ivdIk6e5eT9Ttk+Buv1tlONEZD+YciTCWbY0bvSxpOdseh4F2054UdBsx1U2jaT46kv0
         K9Co9/GwvV9a/2o35rPpv4P0Nct9mqx/0kOHolFL24XRSlX2nH0cxEByBRM0gow/IVE+
         fBP5ZzLjdXIcpThKMTnBVta/1GDcB/5g9gtRL0i/ytJi03O8HU1yTufLekiUCYXQP3UJ
         HccPTyUWRI+BjAguPsSD6pBRHS8Zipn23/nz3lC7/fy5bsbaC4bufVsirsGvt3pPUi/c
         flMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LGzOoaHfO6ykiKcUqxsrDL6YrTaESwHASHuVknVgqFA=;
        b=KMXA33UP85b1uE39UH9m9dJS8JJJdsQOhF//6MuQhLnXv/fgyWwyQkfFUzbWHQk6wy
         ln68qwUhxh3KF3f8JCmGTiFtSfvtqmmiobwwq3zbfdDCXqgz+Vuqb1LCq3M6p8HcIg72
         EVQ/bDEkgQSa5wer5w+5qujEINKmtJbA3hFDfkYMz5V8c8JKASveIpXx126g+zpr8erC
         GNAQ/OgJwYkd54rBX4lLClQ8SAgRoPEOh/kMkXE4mfi5HB0pYgemUFl59weoHdAXIqBl
         0op17Ae/nigBzyjCp9krF6BLw/fq0FBeMEVb0R53ByveqIwN9dmMqnri+ipMb+ArfVpp
         Gm8Q==
X-Gm-Message-State: AOAM532tQ2xyVW5knxmp8o94dgCsr5Jv3J1skMhnu1grRi7amS5t1oEw
        IHtNZwj8tmCJtyQVZFPLHQ3JHCZnFjCPSDMSGcY=
X-Google-Smtp-Source: ABdhPJyUiTn5jJbrait8KW5QhQszo8cI8BWEtPbFDmG1Y8/yJwJjZj3thVHDaHQgILZZnlBwVphng1stVj3K1HAkPbE=
X-Received: by 2002:a05:6e02:4cd:: with SMTP id f13mr15675804ils.42.1612803563887;
 Mon, 08 Feb 2021 08:59:23 -0800 (PST)
MIME-Version: 1.0
References: <8edfa4ae-1e78-249d-14fb-0e44a2c51864@gmail.com> <0e55480b-67cb-8a2f-fb82-734d4b1b0eb0@gmail.com>
In-Reply-To: <0e55480b-67cb-8a2f-fb82-734d4b1b0eb0@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Feb 2021 08:59:13 -0800
Message-ID: <CAKgT0UcBoXv5mGr9NFxusqX16mqi3Nr7+2BUZL0=z6Js8d9A7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] PCI/VPD: Change Chelsio T4 quirk to
 provide access to full virtual address space
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

On Fri, Feb 5, 2021 at 2:15 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> cxgb4 uses the full VPD address space for accessing its EEPROM (with some
> mapping, see t4_eeprom_ptov()). In cudbg_collect_vpd_data() it sets the
> VPD len to 32K (PCI_VPD_MAX_SIZE), and then back to 2K (CUDBG_VPD_PF_SIZE).
> Having official (structured) and inofficial (unstructured) VPD data
> violates the PCI spec, let's set VPD len according to all data that can be
> accessed via PCI VPD access, no matter of its structure.
>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/pci/vpd.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
> index 7915d10f9..06a7954d0 100644
> --- a/drivers/pci/vpd.c
> +++ b/drivers/pci/vpd.c
> @@ -633,9 +633,8 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>         /*
>          * If this is a T3-based adapter, there's a 1KB VPD area at offset
>          * 0xc00 which contains the preferred VPD values.  If this is a T4 or
> -        * later based adapter, the special VPD is at offset 0x400 for the
> -        * Physical Functions (the SR-IOV Virtual Functions have no VPD
> -        * Capabilities).  The PCI VPD Access core routines will normally
> +        * later based adapter, provide access to the full virtual EEPROM
> +        * address space. The PCI VPD Access core routines will normally
>          * compute the size of the VPD by parsing the VPD Data Structure at
>          * offset 0x000.  This will result in silent failures when attempting
>          * to accesses these other VPD areas which are beyond those computed
> @@ -644,7 +643,7 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>         if (chip == 0x0 && prod >= 0x20)
>                 pci_set_vpd_size(dev, 8192);
>         else if (chip >= 0x4 && func < 0x8)
> -               pci_set_vpd_size(dev, 2048);
> +               pci_set_vpd_size(dev, PCI_VPD_MAX_SIZE);
>  }
>
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,

So as I recall the size value was added when some hardware was hanging
when an out-of-bounds read occured from various tools accessing the
VPD. I'm assuming if you are enabling full access the T4 hardware can
handle cases where an out-of-bounds read is requested?

Otherwise the code itself looks fine to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
