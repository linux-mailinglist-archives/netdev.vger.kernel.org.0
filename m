Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D8357C3DA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 07:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGUF4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 01:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGUF4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:56:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E39C77A51
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:56:07 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id r1-20020a05600c35c100b003a326685e7cso2702360wmq.1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f1d+MAgcJOG1Mc0abOeYfw8VPp2sDoq8jRLhcEPDEtk=;
        b=ilYQiVR1RA6bztNdxQ7d+F0svqVHHHbYACglWagLpFxR8LjUS8WmJ416TPhko7TLKg
         UKnPnbGmsHHyBhqd6STeFgBipfgRpsc8QSrKRAwOG0xv4vzPd9GM90CviOoyM70rRtgV
         TwaeXde91z+UgQfJQWBxJhddTZln2vllj5tf3HYzbgaWJ8LpY8wIK4HGwUuzVkVl4n3z
         gdVq81KpXYVxC43Zm9Wqp5pSDzE+9RMpO1ALdv8ZQFDSX9RQke1LGufhWw3I6NEebP9t
         nr3aTsYkiyrtmHhi6P5bhmz5WDTGPALfr19i6Ol4NaUb0kh7wv2WODbkL8pPHpJM2XTQ
         dD3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f1d+MAgcJOG1Mc0abOeYfw8VPp2sDoq8jRLhcEPDEtk=;
        b=J0/fI7de0ox0rPXjWhIdBMUX8U8hw6UBE+tk9eoKUU4lodQlv5n6szFCJPi6xPoCPJ
         JUaFLCUmlvbuS/XFThm5h4DOD0wQnSzgn4aZB07mUSS0FbB3uk1Tq9OA4OpZ3RgiipzQ
         JbuP8o9F0B9n07wREo5Yg28qjDxWES0Jk59bPOHHvYMwmcc10Lz79HDRTi92547Tm/Q4
         NcwvDUGDcvoysFn8W/XJS6pFPSBaDu+6EUdN9D1O62Sh3EzhLy+D26og3KOErmLUlQHR
         AEaViTGb59555IhMudI8o63aCOPGWx/fmAXAbO4K0bCdXpTVuiEkhJTgIsknVxsTkRPV
         9yjQ==
X-Gm-Message-State: AJIora8nVctlgyoydr5DB5KHtrb+yTPBDcjY/0v78eHEbMHbI9YVazPE
        JO7WiEjZ6hbBklK1vCV+R9fX2w==
X-Google-Smtp-Source: AGRyM1s0OBrTQygS1h63fhZWNIScE0iGYaO3pjI8pWcLJZQLTNU1dSFu/vncbAqBcr8CU6aL223C1A==
X-Received: by 2002:a05:600c:3ba3:b0:3a3:5dd:f10f with SMTP id n35-20020a05600c3ba300b003a305ddf10fmr6675855wms.185.1658382965982;
        Wed, 20 Jul 2022 22:56:05 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o27-20020a5d58db000000b0021d80f53324sm835794wrf.7.2022.07.20.22.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:56:05 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:56:04 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 2/2] ice: support dry run of a flash update to
 validate firmware file
Message-ID: <YtjqdJcGpulWsBHs@nanopsycho>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183433.2070122-3-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 08:34:33PM CEST, jacob.e.keller@intel.com wrote:
>Now that devlink core flash update can handle dry run requests, update
>the ice driver to allow validating a PLDM file in dry_run mode.
>
>First, add a new dry_run field to the pldmfw context structure. This
>indicates that the PLDM firmware file library should only validate the
>file and verify that it has a matching record. Update the pldmfw
>documentation to indicate this "dry run" mode.
>
>In the ice driver, let the stack know that we support the dry run
>attribute for flash update by setting the appropriate bit in the
>.supported_flash_update_params field.
>
>If the dry run is requested, notify the PLDM firmware library by setting
>the context bit appropriately. Don't cancel a pending update during
>a dry run.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> Documentation/driver-api/pldmfw/index.rst      | 10 ++++++++++
> drivers/net/ethernet/intel/ice/ice_devlink.c   |  3 ++-
> drivers/net/ethernet/intel/ice/ice_fw_update.c | 14 ++++++++++----
> include/linux/pldmfw.h                         |  5 +++++
> lib/pldmfw/pldmfw.c                            | 12 ++++++++++++
> 5 files changed, 39 insertions(+), 5 deletions(-)
>
>diff --git a/Documentation/driver-api/pldmfw/index.rst b/Documentation/driver-api/pldmfw/index.rst
>index ad2c33ece30f..454b3ed6576a 100644
>--- a/Documentation/driver-api/pldmfw/index.rst
>+++ b/Documentation/driver-api/pldmfw/index.rst
>@@ -51,6 +51,16 @@ unaligned access of multi-byte fields, and to properly convert from Little
> Endian to CPU host format. Additionally the records, descriptors, and
> components are stored in linked lists.
> 
>+Validating a PLDM firmware file
>+===============================
>+
>+To simply validate a PLDM firmware file, and verify whether it applies to
>+the device, set the ``dry_run`` flag in the ``pldmfw`` context structure.
>+If this flag is set, the library will parse the file, validating its UUID
>+and checking if any record matches the device. Note that in a dry run, the
>+library will *not* issue any ops besides ``match_record``. It will not
>+attempt to send the component table or package data to the device firmware.
>+
> Performing a flash update
> =========================
> 
>diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
>index 3337314a7b35..18214ea33e2d 100644
>--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>@@ -467,7 +467,8 @@ ice_devlink_reload_empr_finish(struct devlink *devlink,
> }
> 
> static const struct devlink_ops ice_devlink_ops = {
>-	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
>+	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK |
>+					 DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN,
> 	.reload_actions = BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
> 	/* The ice driver currently does not support driver reinit */
> 	.reload_down = ice_devlink_reload_empr_start,
>diff --git a/drivers/net/ethernet/intel/ice/ice_fw_update.c b/drivers/net/ethernet/intel/ice/ice_fw_update.c
>index 3dc5662d62a6..63317ae88186 100644
>--- a/drivers/net/ethernet/intel/ice/ice_fw_update.c
>+++ b/drivers/net/ethernet/intel/ice/ice_fw_update.c
>@@ -1015,15 +1015,21 @@ int ice_devlink_flash_update(struct devlink *devlink,
> 	else
> 		priv.context.ops = &ice_fwu_ops_e810;
> 	priv.context.dev = dev;
>+	priv.context.dry_run = params->dry_run;
> 	priv.extack = extack;
> 	priv.pf = pf;
> 	priv.activate_flags = preservation;
> 
>-	devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
>+	if (params->dry_run)
>+		devlink_flash_update_status_notify(devlink, "Validating flash binary", NULL, 0, 0);

You do validation of the binary instead of the actual flash. Why is it
called "dry-run" then? Perhaps "validate" would be more suitable?



>+	else
>+		devlink_flash_update_status_notify(devlink, "Preparing to flash", NULL, 0, 0);
> 
>-	err = ice_cancel_pending_update(pf, NULL, extack);
>-	if (err)
>-		return err;
>+	if (!params->dry_run) {
>+		err = ice_cancel_pending_update(pf, NULL, extack);
>+		if (err)
>+			return err;
>+	}
> 
> 	err = ice_acquire_nvm(hw, ICE_RES_WRITE);
> 	if (err) {
>diff --git a/include/linux/pldmfw.h b/include/linux/pldmfw.h
>index 0fc831338226..d9add301582b 100644
>--- a/include/linux/pldmfw.h
>+++ b/include/linux/pldmfw.h
>@@ -124,10 +124,15 @@ struct pldmfw_ops;
>  * should embed this in a private structure and use container_of to obtain
>  * a pointer to their own data, used to implement the device specific
>  * operations.
>+ *
>+ * @ops: function pointers used as callbacks from the PLDMFW library
>+ * @dev: pointer to the device being updated
>+ * @dry_run: if true, only validate the file, do not perform an update.
>  */
> struct pldmfw {
> 	const struct pldmfw_ops *ops;
> 	struct device *dev;
>+	bool dry_run;
> };
> 
> bool pldmfw_op_pci_match_record(struct pldmfw *context, struct pldmfw_record *record);
>diff --git a/lib/pldmfw/pldmfw.c b/lib/pldmfw/pldmfw.c
>index 6e77eb6d8e72..29a132a39876 100644
>--- a/lib/pldmfw/pldmfw.c
>+++ b/lib/pldmfw/pldmfw.c
>@@ -827,6 +827,10 @@ static int pldm_finalize_update(struct pldmfw_priv *data)
>  * to the device firmware. Extract and write the flash data for each of the
>  * components indicated in the firmware file.
>  *
>+ * If the context->dry_run is set, this is a request for a dry run, i.e. to
>+ * only validate the PLDM firmware file. In this case, stop and exit after we
>+ * find a valid matching record.
>+ *
>  * Returns: zero on success, or a negative error code on failure.
>  */
> int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
>@@ -844,14 +848,22 @@ int pldmfw_flash_image(struct pldmfw *context, const struct firmware *fw)
> 	data->fw = fw;
> 	data->context = context;
> 
>+	/* Parse the image and make sure it is a valid PLDM firmware binary */
> 	err = pldm_parse_image(data);
> 	if (err)
> 		goto out_release_data;
> 
>+	/* Search for a record matching the device */
> 	err = pldm_find_matching_record(data);
> 	if (err)
> 		goto out_release_data;
> 
>+	/* If this is a dry run, do not perform an update */
>+	if (context->dry_run)
>+		goto out_release_data;
>+
>+	/* Perform the device update */
>+
> 	err = pldm_send_package_data(data);
> 	if (err)
> 		goto out_release_data;
>-- 
>2.35.1.456.ga9c7032d4631
>
