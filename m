Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F663D22E6
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 13:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhGVLGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 07:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhGVLGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 07:06:30 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE30FC061575
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 04:47:04 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id bm6so5085336qkb.1
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=no5HzU2AGP2i04tSzHzClrDHs7RjfOj5uaDnvVZrTG8=;
        b=TCXRAaFLrzeyejyBzPhPi0QcLG2clI6UxlDrPmD1mbT6e+0PR1gM0bQ5QUqNcUpUne
         qRHTC8uAKemmb/tQT6ArRU3i1/O2ZGFRoNF1Uk1mkOnos2c44aiJ2v+mE3aO2Ew/6wys
         fmFhUZJ8dpnU+gBNIAyMRo3xcD99z0rt586Si8qmtaRYqH35kunHI/JINNnzYXjOT4i7
         TQd6joFNTbni4OQWxhEkO7JYIMHbLhHSAh+AZGEF7lA/2xyvFX14Ahf9dsU73gJGd340
         qZw6eY6z37oebUxOs26bK3pKubfw054ap8jWoJ/tjei6YsrISjP0BH9/D/UlTcY5Cbz8
         skMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=no5HzU2AGP2i04tSzHzClrDHs7RjfOj5uaDnvVZrTG8=;
        b=OI1pVOLk4QYB3D9VtjlBE38S0LSC3MZr/knKRBIoDMntU1DCw15pKZqTCBzjisfK7w
         W66XJHGrHBGDmSMoEw2Acu0AE6UYwe+94KH46tbeVXaawrCzuByttIdW0W3s+limYpG9
         rvYyH+tpK5YXK1qbefwb4lTEedoFNYDF8I7mWdN5EtCVnfIpeNXP62JvOA3aSFErGzzC
         ui3GXXRYCT7lxWs/41Q12n+KZzls2JlaVkfW+awM1xPLwGxCHddJsD1+dwNNAqzio0Sn
         PzYhMz7hFDWMt15bCFz/EebupT1yOH2hnvzrhU2HmhMs/agfBE1mfMnp/jiALXfCOxIs
         V6Xg==
X-Gm-Message-State: AOAM530ox+/jYdxq59L7KtNp1JRVH+NjG2ya2wuxHq5AQL2J0bRifm/v
        fUCRJ337EQnq0qonYg8N4zE=
X-Google-Smtp-Source: ABdhPJxEbTuSDHFL1UnJ903X/1FSnzpwhG/ECZU1O7GUTNwHocHRDEg6ZYCUw6EcSPWi/cT50ZgohA==
X-Received: by 2002:a05:620a:2991:: with SMTP id r17mr22635468qkp.208.1626954424122;
        Thu, 22 Jul 2021 04:47:04 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:194:8382:2ab0:43b0:3fe2:b50d:fb0f])
        by smtp.gmail.com with ESMTPSA id o1sm10002671qta.87.2021.07.22.04.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 04:47:03 -0700 (PDT)
Date:   Thu, 22 Jul 2021 04:47:01 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        netdev@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Ashish K <ashishx.k@intel.com>
Subject: Re: [PATCH net-next v2 1/1] i40e: add support for PTP external
 synchronization clock
Message-ID: <20210722114701.GA3439@hoboy.vegasvil.org>
References: <20210720232348.3087841-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720232348.3087841-1-anthony.l.nguyen@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 20, 2021 at 04:23:48PM -0700, Tony Nguyen wrote:

> +/**
> + * i40e_set_subsystem_device_id - set subsystem device id
> + * @hw: pointer to the hardware info
> + *
> + * Set PCI subsystem device id either from a pci_dev structure or
> + * a specific FW register.
> + **/
> +static inline void i40e_set_subsystem_device_id(struct i40e_hw *hw)
> +{
> +	struct pci_dev *pdev = ((struct i40e_pf *)hw->back)->pdev;
> +
> +	hw->subsystem_device_id = pdev->subsystem_device ?
> +		pdev->subsystem_device :
> +		(ushort)(rd32(hw, I40E_PFPCI_SUBSYSID) & USHRT_MAX);
> +}
> +
>  /**
>   * i40e_probe - Device initialization routine
>   * @pdev: PCI device information struct
> @@ -15262,7 +15281,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	hw->device_id = pdev->device;
>  	pci_read_config_byte(pdev, PCI_REVISION_ID, &hw->revision_id);
>  	hw->subsystem_vendor_id = pdev->subsystem_vendor;
> -	hw->subsystem_device_id = pdev->subsystem_device;
> +	i40e_set_subsystem_device_id(hw);

What does this have to do with $SUBJECT?  Nothing, AFAICT.

Thanks,
Richard
