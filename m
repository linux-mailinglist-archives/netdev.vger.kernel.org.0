Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29E57DA3F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbiGVG0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiGVG0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:26:14 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D0485FA7
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:26:12 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id j22so6939370ejs.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yMVE49QTpYIAzKMre5/nLQ7uVcVNklEmnBRfrBYsHL0=;
        b=Clw+vWYWK9cODwTMjVZuKWbwl+iTUfN2dQCmUX6jPG5IpTaJuAQYig9hApmoPqUrgn
         aXkFaH5E1hIrqovdcfGOBkh5pgrJqhgNjL0Z21dKfmAZCmiqvxKJZb4KKCGDj6TR2VmL
         riOblQnCo+Z10A5hLUbz5zSoxcm7jbIn3CSZfkKngShEMbe9PLZf/ORgJkRv6mHAn35L
         eyM6mOCvL1H0jNszMqYPJ9sTSni8TDf6VtFSISInmQ9rYxobuHKJ7drBJSYmchmZ8qab
         0dtIMik9KH6L/a8c0+8BGuiYzowe3f0fJla090nt5jMQBqxlFMe5pB0Rp4E7hE1JSTbj
         HIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yMVE49QTpYIAzKMre5/nLQ7uVcVNklEmnBRfrBYsHL0=;
        b=a6AFSm/xhNtAgPu/xnInQJKPWULz8kpEBwLoAQUtHuteN6NC8EFKMrjH2lR0O3oNGO
         jS4zOLrmWCWvATymAYIu43L24T8ctR2+TAYPFNijTtdoK0dzU2HveFbXS+DNFqwAkPLN
         7UFln6hWhfdVfggur05buUwiaws+YtS8aHeTL1RXD8C4JOepTHnoIqf9TiQfX8Ll2mju
         XBrDn6N2gV1FZRvEqhHs1iC24C7ibd5/l1ea4dN75jC2XdfMSyNB6nH7OyGqvVuZfctw
         IpvYsxR4caTkzIWQChRkBcah9IOksBEcV9AFyD1nhZIBr/zPlIA9YzfJFfX726hryYfu
         GvFg==
X-Gm-Message-State: AJIora+GRJ2YjX6QWlwhcS5ezM2QPewQCYKGugtrqMvyPtwGKnTpZz5m
        PHoXwTnQ1A4TJVsFwmBjsBdCJA==
X-Google-Smtp-Source: AGRyM1srQgoGRk2mHXtOr5D80qB898XHyn5r/b2frEFFaVuftb9wpJV5LXYyuy6tYPL8DU0b5fc3Pw==
X-Received: by 2002:a17:907:94cf:b0:72f:1c2a:d475 with SMTP id dn15-20020a17090794cf00b0072f1c2ad475mr1917361ejc.237.1658471171023;
        Thu, 21 Jul 2022 23:26:11 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g22-20020a17090670d600b006f3ef214e27sm1633362ejk.141.2022.07.21.23.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:26:10 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:26:09 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-doc@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [net-next v2 1/2] devlink: add dry run attribute to flash update
Message-ID: <YtpDAQS+eQI9C+LV@nanopsycho>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
 <20220721211451.2475600-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721211451.2475600-2-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 11:14:46PM CEST, jacob.e.keller@intel.com wrote:
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
>
>Changes since v1:
>* Add kernel doc comments to devlink_flash_update_params
>* Reduce indentation by using nla_get_flag
>
> .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
> include/net/devlink.h                         |  4 ++++
> include/uapi/linux/devlink.h                  |  8 +++++++
> net/core/devlink.c                            | 17 +++++++++++++-
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
>index 780744b550b8..47b86ccb85b0 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -613,6 +613,8 @@ enum devlink_param_generic_id {
>  * struct devlink_flash_update_params - Flash Update parameters
>  * @fw: pointer to the firmware data to update from
>  * @component: the flash component to update
>+ * @overwrite_mask: what sections of flash can be overwritten

Well, strictly speaking, this is not related to this patch and should be
done in a separate one. But hey, it's a comment, so I guess noone really
cares.


>+ * @dry_run: if true, do not actually update the flash
>  *
>  * With the exception of fw, drivers must opt-in to parameters by
>  * setting the appropriate bit in the supported_flash_update_params field in
>@@ -622,10 +624,12 @@ struct devlink_flash_update_params {
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
>+	 */
>+	DEVLINK_ATTR_DRY_RUN,			/* flag */
>+
> 	/* add new attributes above here, update the policy in devlink.c */
> 
> 	__DEVLINK_ATTR_MAX,
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 98d79feeb3dc..1cff636c9b2b 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4743,7 +4743,8 @@ EXPORT_SYMBOL_GPL(devlink_flash_update_timeout_notify);
> static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 				       struct genl_info *info)
> {
>-	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name;
>+	struct nlattr *nla_component, *nla_overwrite_mask, *nla_file_name,
>+		      *nla_dry_run;
> 	struct devlink_flash_update_params params = {};
> 	struct devlink *devlink = info->user_ptr[0];
> 	const char *file_name;
>@@ -4789,6 +4790,19 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 		return ret;
> 	}
> 
>+	/* Always check dry run last, in order to allow verification of other
>+	 * parameter support even if the particular driver does not yet
>+	 * support a full dry-run
>+	 */
>+	params.dry_run = nla_get_flag(info->attrs[DEVLINK_ATTR_DRY_RUN]);
>+	if (params.dry_run &&
>+	    !(supported_params & DEVLINK_SUPPORT_FLASH_UPDATE_DRY_RUN)) {
>+		NL_SET_ERR_MSG_ATTR(info->extack, nla_dry_run,
>+				    "flash update is supported, but dry run is not supported for this device");
>+		release_firmware(params.fw);
>+		return -EOPNOTSUPP;
>+	}
>+
> 	devlink_flash_update_begin_notify(devlink);
> 	ret = devlink->ops->flash_update(devlink, &params, info->extack);
> 	devlink_flash_update_end_notify(devlink);
>@@ -9004,6 +9018,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
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

Reviewed-by: Jiri Pirko <jiri@nvidia.com>


