Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA8A57C403
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 08:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbiGUGAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 02:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiGUF7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 01:59:50 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EE27AB16
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:59:33 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso232917wmq.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 22:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PTPpkJIjElUZLn7IzCpsUmD0e1l5cBBgKM5G33JAlOE=;
        b=oAxrgxbqbPe6sQKAA0kra7IBPVFkbKDTKa9qH85wGIV+E6N7wvic56OgevSaQ6SobL
         Vb2PjDYccQsgFX1VLVL8KqiWUvq0K6AwFQEiI/PHxVZ6dCQAap60LPaYCfRe1NO3hMzw
         8xlXS4Xg9fqrmw6+k5moCvQRUbcBg4bXZ6CVTTiiUoMgBSMys3l6y9hEQ9t+tW1VK4Sx
         84f9Sjdi6Y5vdUqNDsFzqm0nmp28k3VQdbMND6F1g8Q9XysdShJdjUc+jsMhQcbpTTxD
         g0TQdx8RpWe1bRLAoNuMM0fgha0GE3GG0gonFBMz5wcIq6SEdxTooQVG95tbZLhzCNqY
         Ff/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PTPpkJIjElUZLn7IzCpsUmD0e1l5cBBgKM5G33JAlOE=;
        b=rGhl423XpHzwl8zs9q51wfd4bnIfjP92EovhutRpOdS6cIX5sXLfHIRwfn/NRDV5GQ
         f9vs0cng8BOdSOmSnmWkImIT/+Yl9SPl3zC9YRaE+ixLaIMrTuTHBMeDkBWU7XtjeAHI
         K/EqYbiNBPJCWdaCV0RIo9RxPwJG7Ks1AgI0Vq39TlKrmbwG8MyxXgd7aQ84Z4L7ks66
         iLnWYRMgqFuR3gmCWx+ujfP5/uOXUhsmLBzfcV9ocIVh1GVKotuMMpszmHqAjoaQStx0
         uUX/dr5G8jvHxu642YAEZsJ2xsZEh5lABYKZxK+iSHx8K0CAETizHDEwEJAScdcaMPG5
         VoMw==
X-Gm-Message-State: AJIora/8ZaZw3QXw+Ds/3Yc2cXgKK30Y7YIaPvM5oxhVSW+zfyH8vMxO
        VJmmXjFMT1JCSl/SsrITuyav2Q==
X-Google-Smtp-Source: AGRyM1s2nay5eIxmIoXV7q+89weaNeAba2nqe/FUrEZudTrmfUKmINigbIJdhAxw30yeMvHvLRrOTw==
X-Received: by 2002:a05:600c:4f13:b0:3a3:3077:e5b7 with SMTP id l19-20020a05600c4f1300b003a33077e5b7mr1181084wmq.107.1658383172106;
        Wed, 20 Jul 2022 22:59:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u24-20020a05600c211800b003a2e655f2e6sm711024wml.21.2022.07.20.22.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 22:59:31 -0700 (PDT)
Date:   Thu, 21 Jul 2022 07:59:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [iproute2-next PATCH 3/3] devlink: add dry run attribute support
 to devlink flash
Message-ID: <YtjrQhPVw1ZtBSAN@nanopsycho>
References: <20220720183449.2070222-1-jacob.e.keller@intel.com>
 <20220720183449.2070222-4-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720183449.2070222-4-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 08:34:49PM CEST, jacob.e.keller@intel.com wrote:
>Recent versions of the kernel support the DEVLINK_ATTR_DRY_RUN attribute
>which allows requesting a dry run of a command. A dry run is simply
>a request to validate that a command would work, without performing any
>destructive changes.
>
>The attribute is supported by the devlink flash update as a way to
>validate an update, including potentially the binary image, without
>modifying the device.
>
>Add a "dry_run" option to the command line parsing which will enable
>this attribute when requested.
>
>To avoid potential issues, only allow the attribute to be added to
>commands when the kernel recognizes it. This is important because some
>commands do not perform strict validation. If we were to add the
>attribute without this check, an old kernel may silently accept the
>command and perform an update even when dry_run was requested.
>
>Before adding the attribute, check the maximum attribute from the
>CTRL_CMD_GETFAMILY and make sure that the kernel recognizes the
>DEVLINK_ATTR_DRY_RUN attribute.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>---
> devlink/devlink.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 43 insertions(+), 2 deletions(-)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index ddf430bbb02a..5649360b1417 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -294,6 +294,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
> #define DL_OPT_PORT_FN_RATE_TX_MAX	BIT(49)
> #define DL_OPT_PORT_FN_RATE_NODE_NAME	BIT(50)
> #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
>+#define DL_OPT_DRY_RUN			BIT(52)
> 
> struct dl_opts {
> 	uint64_t present; /* flags of present items */
>@@ -368,6 +369,8 @@ struct dl {
> 	bool verbose;
> 	bool stats;
> 	bool hex;
>+	bool max_attr_valid;
>+	uint32_t max_attr;
> 	struct {
> 		bool present;
> 		char *bus_name;
>@@ -693,6 +696,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
> 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
>+	[DEVLINK_ATTR_DRY_RUN] = MNL_TYPE_FLAG,
> };
> 
> static const enum mnl_attr_data_type
>@@ -1512,6 +1516,30 @@ static int dl_args_finding_required_validate(uint64_t o_required,
> 	return 0;
> }
> 
>+static void dl_get_max_attr(struct dl *dl)
>+{
>+	if (!dl->max_attr_valid) {
>+		uint32_t max_attr;
>+		int err;
>+
>+		err = mnlg_socket_get_max_attr(&dl->nlg, &max_attr);
>+		if (err) {
>+			pr_err("Unable to determine maximum supported devlink attribute\n");
>+			return;
>+		}
>+
>+		dl->max_attr = max_attr;
>+		dl->max_attr_valid = true;
>+	}
>+}
>+
>+static bool dl_kernel_supports_dry_run(struct dl *dl)
>+{
>+	dl_get_max_attr(dl);
>+
>+	return (dl->max_attr_valid && dl->max_attr >= DEVLINK_ATTR_DRY_RUN);

This looks like it would be handy for other attrs too. Could you make
this a generic helper accepting attr type as function argument?



>+}
>+
> static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 			 uint64_t o_optional)
> {
>@@ -2008,6 +2036,16 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 			dl_arg_inc(dl);
> 			opts->rate_parent_node = "";
> 			o_found |= DL_OPT_PORT_FN_RATE_PARENT;
>+		} else if (dl_argv_match(dl, "dry_run") &&
>+			   (o_all & DL_OPT_DRY_RUN)) {
>+
>+			if (!dl_kernel_supports_dry_run(dl)) {
>+				pr_err("Kernel does not support dry_run attribute\n");
>+				return -EOPNOTSUPP;
>+			}
>+
>+			dl_arg_inc(dl);
>+			o_found |= DL_OPT_DRY_RUN;
> 		} else {
> 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
> 			return -EINVAL;
>@@ -2086,6 +2124,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
> 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
> 				  opts->rate_node_name);
> 	}
>+	if (opts->present & DL_OPT_DRY_RUN)
>+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
> 	if (opts->present & DL_OPT_PORT_TYPE)
> 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
> 				 opts->port_type);
>@@ -2284,7 +2324,7 @@ static void cmd_dev_help(void)
> 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
> 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
> 	pr_err("       devlink dev info [ DEV ]\n");
>-	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
>+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ] [ dry_run ]\n");
> }
> 
> static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
>@@ -3844,7 +3884,8 @@ static int cmd_dev_flash(struct dl *dl)
> 			       NLM_F_REQUEST | NLM_F_ACK);
> 
> 	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_FLASH_FILE_NAME,
>-				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE);
>+				DL_OPT_FLASH_COMPONENT | DL_OPT_FLASH_OVERWRITE |
>+				DL_OPT_DRY_RUN);
> 	if (err)
> 		return err;
> 
>-- 
>2.36.1
>
