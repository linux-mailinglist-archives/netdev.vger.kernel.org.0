Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE357C3D9
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 07:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiGUFyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 01:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiGUFyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:54:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AD861D7D
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:54:49 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id b11so1256082eju.10
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wV8wXx1y9KpvFyYj6uH9WU74dhMkrj+G9DPKhZ/Da10=;
        b=kJ9osDvkiyc9OHJg6BlpxjGcmy+zIpItERkkcxDfsPQ0aWztHlgC0SGh8hrgQa/QG9
         dHleeDfbS2F0DaZaWTeb8TYvcxGpCwlKWSesobUTlvQ7Mdt4KOOyMTkrNtADB7veWzXL
         ptZTCa0b7/IidHh/K7ujXT4pjNnbd78WBDUqBujExtj8ziLSshfVOVx4Nd0NuuuywSso
         YKqXqAJ2wSIAI1BpA7D8xmUHl3UCu2SHoQYKHuDrgQa2r5Y6h4i3yTleH4/1Cd0uBLNc
         scHZKql3cCMnTk3wGlA80q5id3VPshm9yzwVPDRXwdQPuvUDssvXbtiLZ2LJOlaglU3H
         /ImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wV8wXx1y9KpvFyYj6uH9WU74dhMkrj+G9DPKhZ/Da10=;
        b=FWybz5vcIdJJ2KHoQmRgVaF/rCBs9ewC50Gh4fxuPnWgy6EUO7TKvDroIyLyE7NbWY
         TOmm1Zm1tB3d/mShpCF8y7Je26pHEyok7Wk0weyAE/+66y7+3i3vT+eQstMk8uBYlv4B
         GGAwD0Fy1qu+rX6MyC+orV+Ji9WMdzS06o2RRZx4R66woTK6lI/cOqYy1b96r9ysnmrY
         DCHXtm9T/WZbsJJsYrvNmkw36lS122OiLxSZFjvcktYrR8sO7bC6L9wDH/aCgJ8bpBgN
         SU0DMbdOlW/m9fi36w0t54YL9c7b2fc9EF5DHVnMzrTR/Cf+OIEnVePTGDaZgb54UDtx
         s6HA==
X-Gm-Message-State: AJIora87uLjK9ipl4fmmddTsR+2RpPU7vm/JWnNAazHNkgpVMTt71tKf
        aQvFW1IckLjUR5qHClX46Bn5duwQJCsXtQycv7c=
X-Google-Smtp-Source: AGRyM1t7Uam+iE7nMAAWzcqdcfjz0P233Hg/4+8jXY+ImrY900XvtEwZp3hiTF6CYNjc0nAZpcTS+Q==
X-Received: by 2002:a17:906:846d:b0:72f:3901:de1c with SMTP id hx13-20020a170906846d00b0072f3901de1cmr16037542ejc.199.1658382888336;
        Wed, 20 Jul 2022 22:54:48 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e16-20020a1709061e9000b0072b4da1ed9asm406623ejj.225.2022.07.20.22.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:54:47 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:54:46 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next PATCH 1/2] devlink: add dry run attribute to flash
 update
Message-ID: <YtjqJjIceW+fProb@nanopsycho>
References: <20220720183433.2070122-1-jacob.e.keller@intel.com>
 <20220720183433.2070122-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183433.2070122-2-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 08:34:32PM CEST, jacob.e.keller@intel.com wrote:
>Users use the devlink flash interface to request a device driver program or
>update the device flash chip. In some cases, a user (or script) may want to
>verify that a given flash update command is supported without actually
>committing to immediately updating the device. For example, a system
>administrator may want to validate that a particular flash binary image
>will be accepted by the device, or simply validate a command before finally
>committing to it.
>
>The current flash update interface lacks a method to support such a dry
>run. Add a new DEVLINK_ATTR_DRY_RUN attribute which shall be used by a
>devlink command to indicate that a request is a dry run which should not
>perform device configuration. Instead, the command should report whether
>the command or configuration request is valid.
>
>While we can validate the initial arguments of the devlink command, a
>proper dry run must be processed by the device driver. This is required
>because only the driver can perform validation of the flash binary file.
>
>Add a new dry_run parameter to the devlink_flash_update_params struct,
>along with the associated bit to indicate if a driver supports verifying a
>dry run.
>
>We always check the dry run attribute last in order to allow as much
>verification of other parameters as possible. For example, even if a driver
>does not support the dry_run option, we can still validate the other
>optional parameters such as the overwrite_mask and per-component update
>name.
>
>Document that userspace should take care when issuing a dry run to older
>kernels, as the flash update command is not strictly verified. Thus,
>unknown attributes will be ignored and this could cause a request for a dry
>run to perform an actual update. We can't fix old kernels to verify unknown
>attributes, but userspace can check the maximum attribute and reject the
>dry run request if it is not supported by the kernel.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
> include/net/devlink.h                         |  2 ++
> include/uapi/linux/devlink.h                  |  8 +++++++
> net/core/devlink.c                            | 19 ++++++++++++++-
> 4 files changed, 51 insertions(+), 1 deletion(-)
>
>diff --git a/Documentation/networking/devlink/devlink-flash.rst b/Documentation/networking/devlink/devlink-flash.rst
>index 603e732f00cc..1dc373229a54 100644
>--- a/Documentation/networking/devlink/devlink-flash.rst
>+++ b/Documentation/networking/devlink/devlink-flash.rst
>@@ -44,6 +44,29 @@ preserved across the update. A device may not support every combination and
> the driver for such a device must reject any combination which cannot be
> faithfully implemented.
> 
>+Dry run
>+=======
>+
>+Users can request a "dry run" of a flash update by adding the
>+``DEVLINK_ATTR_DRY_RUN`` attribute to the ``DEVLINK_CMD_FLASH_UPDATE``
>+command. If the attribute is present, the kernel will only verify that the
>+provided command is valid. During a dry run, an update is not performed.
>+
>+If supported by the driver, the flash image contents are also validated and
>+the driver may indicate whether the file is a valid flash image for the
>+device.
>+
>+.. code:: shell
>+
>+   $ devlink dev flash pci/0000:af:00.0 file image.bin dry-run
>+   Validating flash binary
>+
>+Note that user space should take care when adding this attribute. Older
>+kernels which do not recognize the attribute may accept the command with an
>+unknown attribute. This could lead to a request for a dry run which performs
>+an unexpected update. To avoid this, user space should check the policy dump
>+and verify that the attribute is recognized before adding it to the command.
>+
> Firmware Loading
> ================
> 
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 88c701b375a2..ff5b1e60ad6a 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -622,10 +622,12 @@ struct devlink_flash_update_params {
> 	const struct firmware *fw;
> 	const char *component;
> 	u32 overwrite_mask;
>+	bool dry_run;
> };
> 
> #define DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT		BIT(0)
> #define DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK	BIT(1)
>+#define DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN		BIT(2)
> 
> struct devlink_region;
> struct devlink_info_req;
>diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>index b3d40a5d72ff..e24a5a808a12 100644
>--- a/include/uapi/linux/devlink.h
>+++ b/include/uapi/linux/devlink.h
>@@ -576,6 +576,14 @@ enum devlink_attr {
> 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
> 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
> 
>+	/* Before adding this attribute to a command, user space should check
>+	 * the policy dump and verify the kernel recognizes the attribute.
>+	 * Otherwise older kernels which do not recognize the attribute may
>+	 * silently accept the unknown attribute while not actually performing
>+	 * a dry run.

Why this comment is needed? Isn't that something generic which applies
to all new attributes what userspace may pass and kernel may ignore?


>+	 */
>+	DEVLINK_ATTR_DRY_RUN,			/* flag */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index a9776ea923ae..7d403151bee2 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4736,7 +4736,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
> static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 				       struct genl_info *info)
> {
>-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
>+	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name,
>+		      *nla_dry_run;
> 	struct devlink_flash_update_params params = {};
> 	struct devlink *devlink = info->user_ptr[0];
> 	const char *file_name;
>@@ -4782,6 +4783,21 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 		return ret;
> 	}
> 
>+	/* Always check dry run last, in order to allow verification of other
>+	 * parameter support even if the particular driver does not yet
>+	 * support a full dry-run
>+	 */
>+	nla_dry_run = info->attrs[DEVLINK_ATTR_DRY_RUN];
>+	if (nla_dry_run) {
>+		if (!(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
>+			NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,
>+					    "flash update is supported, but dry run is not supported for this device");
>+			release_firmware(params.fw);
>+			return -EOPNOTSUPP;
>+		}
>+		params.dry_run = true;
>+	}
>+
> 	devlink_flash_update_begin_notify(devlink);
> 	ret = devlink->ops->flash_update(devlink, &params, info->extack);
> 	devlink_flash_update_end_notify(devlink);
>@@ -8997,6 +9013,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
> 	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
> 	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
>+	[DEVLINK_ATTR_DRY_RUN] = { .type = NLA_FLAG },
> };
> 
> static const struct genl_small_ops devlink_nl_ops[] = {
>-- 
>2.35.1.456.ga9c7032d4631
>
