Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F001CEE23
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 03:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfD3BIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 21:08:00 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:45239 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfD3BH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 21:07:59 -0400
Received: by mail-yw1-f66.google.com with SMTP id r139so4696328ywe.12
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 18:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=I59Gowpm55WuTd5q3pzBBwbpPTdXSYidB4GetoWIaw0=;
        b=CfD43KnVAS4HfwnvxEYLzAaa8Z2666QM5B7UWb2Of5au1cWVKysPJ56i7GgTYkau9b
         cZRBCg188KURpxqKocormZkIA/r4I/HQtepM8hEfuiSN0kZ9kI4U6d/hpkDLon3vqr2e
         PkOD7nLM8mAulRNzYc7VQ6+gIeniIjBBHJBaWz546EXc3H1q1Q8tU5JUKncNgW/uBU+a
         cI4dHkmQVi5+7iNL7Dq8qbY3jPpLxoBJykxvT13FZKfW1HhPYUwJMl4pasES27cmjNSI
         cNGfvnjVzzOnKHev7z7bWA32Noflv0cuHBkx0ptuKreI2Qp3xzjGbXiokvFCP2Scr5Ts
         NtNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=I59Gowpm55WuTd5q3pzBBwbpPTdXSYidB4GetoWIaw0=;
        b=YuEIq/OMnq9ZCVDteSKqbOHnwMSv1lbgZJ1crxELbasZsnSi2tG++vRKsdVWNAdtje
         OBOxS6ybt46DtRLiEXHyO3w76EGVIh7zPDAck90E2QvsK4nhWqWMpJ+vskrrO+RgmspZ
         HovQBs8cRiMnoZoukSGuRw6YyW5+fbeTVWquVBdWj7VrFLu/saOTO1hUSoV6GXIridVU
         jaKgCmqFK2dnoPPb9CVaokVm2XhOeZO6muZm1Flm7Z0e2oK/h4l4TVwHhmZetKGVkiph
         SOtR02oli8GyYYJcMnSN9IRM3bAAqvPPfBzt0XF4p2qAN+hZS3XMEHZSZX18NQ3OeN60
         nWiA==
X-Gm-Message-State: APjAAAWvU6KrKLAaZkGM3wlbcQB+yObGWuDmNZudFmCBYHsMIgRj7Edv
        iV7ePfUVhGe49kM++J+FcqKWKA==
X-Google-Smtp-Source: APXvYqx/wsBOoKr1wm4c2uhSg0AuqTVbztb5hsXhxkplLVoNPWELAsBNnrE3zsliPiEcRlSGCQ61ww==
X-Received: by 2002:a25:260c:: with SMTP id m12mr53467788ybm.300.1556586478722;
        Mon, 29 Apr 2019 18:07:58 -0700 (PDT)
Received: from cakuba (adsl-173-228-226-134.prtc.net. [173.228.226.134])
        by smtp.gmail.com with ESMTPSA id p3sm11740925ywd.94.2019.04.29.18.07.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 18:07:58 -0700 (PDT)
Date:   Mon, 29 Apr 2019 21:07:55 -0400
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Piotr Marczak <piotr.marczak@intel.com>,
        Don Buchholz <donald.buchholz@intel.com>
Subject: Re: [net-next 12/12] i40e: Introduce recovery mode support
Message-ID: <20190429210755.0de283ed@cakuba>
In-Reply-To: <20190429191628.31212-13-jeffrey.t.kirsher@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
        <20190429191628.31212-13-jeffrey.t.kirsher@intel.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Apr 2019 12:16:28 -0700, Jeff Kirsher wrote:
> From: Alice Michael <alice.michael@intel.com>
>=20
> This patch introduces "recovery mode" to the i40e driver. It is
> part of a new Any2Any idea of upgrading the firmware. In this
> approach, it is required for the driver to have support for
> "transition firmware", that is used for migrating from structured
> to flat firmware image. In this new, very basic mode, i40e driver
> must be able to handle particular IOCTL calls from the NVM Update
> Tool and run a small set of AQ commands.

Could you show us commands that get executed?  I think that'd be much
quicker for people to parse.

> Signed-off-by: Alice Michael <alice.michael@intel.com>
> Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
> Tested-by: Don Buchholz <donald.buchholz@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

=46rom a cursory look it seems you create a "basic" netdev.  Can this
netdev pass traffic?

I'd suggest you implement devlink "limp mode".  Devlink can flash the
device now.  You can register a devlink instance without registering
any "minimal" netdevs, and flash with devlink.

> @@ -13904,6 +14007,134 @@ void i40e_set_fec_in_flags(u8 fec_cfg, u32 *fla=
gs)
>  		*flags &=3D ~(I40E_FLAG_RS_FEC | I40E_FLAG_BASE_R_FEC);
>  }
> =20
> +/**
> + * i40e_check_recovery_mode - check if we are running transition firmware
> + * @pf: board private structure
> + *
> + * Check registers indicating the firmware runs in recovery mode. Sets t=
he
> + * appropriate driver state.
> + *
> + * Returns true if the recovery mode was detected, false otherwise
> + **/
> +static bool i40e_check_recovery_mode(struct i40e_pf *pf)
> +{
> +	u32 val =3D rd32(&pf->hw, I40E_GL_FWSTS);
> +
> +	if (val & I40E_GL_FWSTS_FWS1B_MASK) {
> +		dev_notice(&pf->pdev->dev, "Firmware recovery mode detected. Limiting =
functionality.\n");
> +		dev_notice(&pf->pdev->dev, "Refer to the Intel(R) Ethernet Adapters an=
d Devices User Guide for details on firmware recovery mode.\n");
> +		set_bit(__I40E_RECOVERY_MODE, pf->state);
> +
> +		return true;
> +	}
> +	if (test_and_clear_bit(__I40E_RECOVERY_MODE, pf->state))
> +		dev_info(&pf->pdev->dev, "Reinitializing in normal mode with full func=
tionality.\n");
> +
> +	return false;
> +}
> +
> +/**
> + * i40e_init_recovery_mode - initialize subsystems needed in recovery mo=
de
> + * @pf: board private structure
> + * @hw: ptr to the hardware info
> + *
> + * This function does a minimal setup of all subsystems needed for runni=
ng
> + * recovery mode.
> + *
> + * Returns 0 on success, negative on failure
> + **/
> +static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *h=
w)
> +{
> +	struct i40e_vsi *vsi;
> +	int err;
> +	int v_idx;
> +
> +#ifdef HAVE_PCI_ERS
> +	pci_save_state(pf->pdev);
> +#endif
> +
> +	/* set up periodic task facility */
> +	timer_setup(&pf->service_timer, i40e_service_timer, 0);
> +	pf->service_timer_period =3D HZ;
> +
> +	INIT_WORK(&pf->service_task, i40e_service_task);
> +	clear_bit(__I40E_SERVICE_SCHED, pf->state);
> +
> +	err =3D i40e_init_interrupt_scheme(pf);
> +	if (err)
> +		goto err_switch_setup;
> +
> +	/* The number of VSIs reported by the FW is the minimum guaranteed
> +	 * to us; HW supports far more and we share the remaining pool with
> +	 * the other PFs. We allocate space for more than the guarantee with
> +	 * the understanding that we might not get them all later.
> +	 */
> +	if (pf->hw.func_caps.num_vsis < I40E_MIN_VSI_ALLOC)
> +		pf->num_alloc_vsi =3D I40E_MIN_VSI_ALLOC;
> +	else
> +		pf->num_alloc_vsi =3D pf->hw.func_caps.num_vsis;
> +
> +	/* Set up the vsi struct and our local tracking of the MAIN PF vsi. */
> +	pf->vsi =3D kcalloc(pf->num_alloc_vsi, sizeof(struct i40e_vsi *),
> +			  GFP_KERNEL);
> +	if (!pf->vsi) {
> +		err =3D -ENOMEM;
> +		goto err_switch_setup;
> +	}
> +
> +	/* We allocate one VSI which is needed as absolute minimum
> +	 * in order to register the netdev
> +	 */
> +	v_idx =3D i40e_vsi_mem_alloc(pf, I40E_VSI_MAIN);
> +	if (v_idx < 0)
> +		goto err_switch_setup;
> +	pf->lan_vsi =3D v_idx;
> +	vsi =3D pf->vsi[v_idx];
> +	if (!vsi)
> +		goto err_switch_setup;
> +	vsi->alloc_queue_pairs =3D 1;
> +	err =3D i40e_config_netdev(vsi);
> +	if (err)
> +		goto err_switch_setup;
> +	err =3D register_netdev(vsi->netdev);
> +	if (err)
> +		goto err_switch_setup;
> +	vsi->netdev_registered =3D true;
> +	i40e_dbg_pf_init(pf);
> +
> +	err =3D i40e_setup_misc_vector_for_recovery_mode(pf);
> +	if (err)
> +		goto err_switch_setup;
> +
> +	/* tell the firmware that we're starting */
> +	i40e_send_version(pf);
> +
> +	/* since everything's happy, start the service_task timer */
> +	mod_timer(&pf->service_timer,
> +		  round_jiffies(jiffies + pf->service_timer_period));
> +
> +	return 0;
> +
> +err_switch_setup:
> +	i40e_reset_interrupt_capability(pf);
> +	del_timer_sync(&pf->service_timer);
> +#ifdef NOT_FOR_UPSTREAM

Delightful :)

> +	dev_warn(&pf->pdev->dev, "previous errors forcing module to load in deb=
ug mode\n");
> +	i40e_dbg_pf_init(pf);
> +	set_bit(__I40E_DEBUG_MODE, pf->state);
> +	return 0;
> +#else
> +	i40e_shutdown_adminq(hw);
> +	iounmap(hw->hw_addr);
> +	pci_disable_pcie_error_reporting(pf->pdev);
> +	pci_release_mem_regions(pf->pdev);
> +	pci_disable_device(pf->pdev);
> +	kfree(pf);
> +
> +	return err;
> +#endif
> +}
> +
>  /**
>   * i40e_probe - Device initialization routine
>   * @pdev: PCI device information struct

