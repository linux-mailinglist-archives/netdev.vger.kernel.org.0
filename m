Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39DC57DA31
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbiGVGWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVGWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:22:05 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44180237F6
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:22:04 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l23so6922039ejr.5
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4teoEu/6jlLuEBrXi44fco9oNrxWO5E3FOKoNlVFqt0=;
        b=t3B5GXw6DpT2iiC9VZrGPQ9dZdP4it222ntyWbkA7gc7T+Es9QMWLlJF/ExWdrue/p
         JCXxlpOV6SV2xFbXBfeMUgZvPqLOm852Mg+cWfKgopgnx+R7DJqu6wapWPPbrXhPjCtS
         FHt0GRAYOe0SMjmmo3QXCE+mLDpgW+Zgqo906IOaFvOlDxY8+/SlruI3ogxOuSuFFNIT
         JeG4vvXowtlx6IZmrCv/th0ARb2poce+diA8ESZ1TInEXEBlNbAF7m5KkBfYUjYKlZ7r
         AtF8oxJeHfqG2JJovTTp491EZddMBq0sJwsycE8RR8r+74+/zb4l2LtOQP6J9e2XzSMp
         9rww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4teoEu/6jlLuEBrXi44fco9oNrxWO5E3FOKoNlVFqt0=;
        b=UV0uWKy6XR8U5dZUy7/U9PIItFH47NBXxKQXuyTrlVEhEnDym/u06KB2oTVmNes3II
         agwFH7GDPosMADfPYlNyPIYEpSE0N0e1u98AXCHCviYi61pHRL67EYWEVRGmirOOiMbs
         /Sh928e/csKARp5omZM1hfQOkNAc3B1gLSP+5JuQtLXzmILpWPx2qNxzVHCZ5YG9opeq
         zdhlQrGMVvSw3iBkknAMsoM9OkM36JHPxgYiFgCMzjPKZcDPHQKpnh5pAYF0wqYyEtKk
         ETUJAAKI0bh5pSI8PnNZWusgcfwmsIRb0/cWqQMqZ5t5rsNlESLBLyguccCmuFiEkYSB
         RC1g==
X-Gm-Message-State: AJIora/yeSficDipCAtZXH8VUjy+3Cj6r3RW1yILz9P0adhggkmDurHN
        l5pm2XIcu7RsCcPEig3WLMZsog==
X-Google-Smtp-Source: AGRyM1tSgeFH8GK9rM+Z8I/XNtKmZF3Zn7iGX2ibiPOuos6BiMjb++c1IXuGJ7/YHhxeWKMWoK0wZQ==
X-Received: by 2002:a17:907:2d0e:b0:72b:4af7:7ccd with SMTP id gs14-20020a1709072d0e00b0072b4af77ccdmr1839404ejc.209.1658470922733;
        Thu, 21 Jul 2022 23:22:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y3-20020aa7ccc3000000b0043577da51f1sm2055425edt.81.2022.07.21.23.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:22:01 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:22:00 +0200
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
Subject: Re: [iproute2-next v2 3/3] devlink: add dry run attribute support to
 devlink flash
Message-ID: <YtpCCFiXSAFWoUdg@nanopsycho>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
 <20220721211451.2475600-7-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721211451.2475600-7-jacob.e.keller@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 11:14:51PM CEST, jacob.e.keller@intel.com wrote:
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
>Changes since v1
>* Make dl_kernel_supports_dry_run more generic by passing attribute
>
> devlink/devlink.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
> 1 file changed, 43 insertions(+), 2 deletions(-)
>
>diff --git a/devlink/devlink.c b/devlink/devlink.c
>index 1e2cfc3d4285..24f1a70a9656 100644
>--- a/devlink/devlink.c
>+++ b/devlink/devlink.c
>@@ -296,6 +296,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
> #define DL_OPT_PORT_FN_RATE_PARENT	BIT(51)
> #define DL_OPT_LINECARD		BIT(52)
> #define DL_OPT_LINECARD_TYPE	BIT(53)
>+#define DL_OPT_DRY_RUN			BIT(54)
> 
> struct dl_opts {
> 	uint64_t present; /* flags of present items */
>@@ -372,6 +373,8 @@ struct dl {
> 	bool verbose;
> 	bool stats;
> 	bool hex;
>+	bool max_attr_valid;
>+	uint32_t max_attr;
> 	struct {
> 		bool present;
> 		char *bus_name;
>@@ -701,6 +704,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
> 	[DEVLINK_ATTR_LINECARD_STATE] = MNL_TYPE_U8,
> 	[DEVLINK_ATTR_LINECARD_TYPE] = MNL_TYPE_STRING,
> 	[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES] = MNL_TYPE_NESTED,
>+	[DEVLINK_ATTR_DRY_RUN] = MNL_TYPE_FLAG,
> };
> 
> static const enum mnl_attr_data_type
>@@ -1522,6 +1526,30 @@ static int dl_args_finding_required_validate(uint64_t o_required,
> 	return 0;
> }
> 
>+static void dl_get_max_attr(struct dl *dl)
>+{
>+	if (!dl->max_attr_valid) {

if (dl->max_attr_valid)
	return;

and then you can drop the indent.


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
>+static bool dl_kernel_supports_attr(struct dl *dl, enum devlink_attr attr)
>+{
>+	dl_get_max_attr(dl);
>+
>+	return (dl->max_attr_valid && dl->max_attr >= attr);

Return is not a function. Drop the "()" here.


>+}
>+
> static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 			 uint64_t o_optional)
> {
>@@ -2037,6 +2065,16 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
> 			dl_arg_inc(dl);
> 			opts->linecard_type = "";
> 			o_found |= DL_OPT_LINECARD_TYPE;
>+		} else if (dl_argv_match(dl, "dry_run") &&
>+			   (o_all & DL_OPT_DRY_RUN)) {
>+
>+			if (!dl_kernel_supports_attr(dl, DEVLINK_ATTR_DRY_RUN)) {
>+				pr_err("Kernel does not support dry_run attribute\n");
>+				return -EOPNOTSUPP;
>+			}
>+
>+			dl_arg_inc(dl);
>+			o_found |= DL_OPT_DRY_RUN;
> 		} else {
> 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
> 			return -EINVAL;
>@@ -2115,6 +2153,8 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
> 		mnl_attr_put_strz(nlh, DEVLINK_ATTR_RATE_NODE_NAME,
> 				  opts->rate_node_name);
> 	}
>+	if (opts->present & DL_OPT_DRY_RUN)
>+		mnl_attr_put(nlh, DEVLINK_ATTR_DRY_RUN, 0, NULL);
> 	if (opts->present & DL_OPT_PORT_TYPE)
> 		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_TYPE,
> 				 opts->port_type);
>@@ -2326,7 +2366,7 @@ static void cmd_dev_help(void)
> 	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
> 	pr_err("                              [ action { driver_reinit | fw_activate } ] [ limit no_reset ]\n");
> 	pr_err("       devlink dev info [ DEV ]\n");
>-	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ]\n");
>+	pr_err("       devlink dev flash DEV file PATH [ component NAME ] [ overwrite SECTION ] [ dry_run ]\n");
> }
> 
> static bool cmp_arr_last_handle(struct dl *dl, const char *bus_name,
>@@ -3886,7 +3926,8 @@ static int cmd_dev_flash(struct dl *dl)
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
