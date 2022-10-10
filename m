Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB875F9C2E
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiJJJqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiJJJqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:46:00 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2B16567A
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:45:58 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id d26so16564993eje.10
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 02:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=89t0fmxpfi+MN7XN16LJF3/w509j7KVWzr+Dzj8Jcuc=;
        b=AcjFjUydLE2BB5dua8a+501YZkeQSpKUZz++OFFWcHGewQ7pFTF4rikBqwFDn6burL
         6WS4avnhXNkBmOKRYXAi84tzP4wtslXV2nyd0l7xVnVb/oKzSlWgYrMpDGx/tizwND3V
         5zyB8bFOASZreloGFW3PVFlwEWUGP4+U+o+RQNMjidw8+1tBHLgywdVoK6aWA9zzUZgs
         Drgf9O52g4eQX2MuyvPb5O3t5K5kM1JB68O5USyHE9Ni0B52hc6e7sw0a+wMUA0jyDeK
         xiY1KX0lqN0WAZqqn0XCmUQzlzPOb74vVMoTZChmajZcJStKpqf/gYSXL3+gdR91HC4B
         1a6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=89t0fmxpfi+MN7XN16LJF3/w509j7KVWzr+Dzj8Jcuc=;
        b=QYcHXDdMGHo1SWXyUHyDTK8AyadBRmReoFT0dRjx8HhnhGH1cOa4/NGQceivk0SW7b
         KxpQ30bTbsp5eyCAZa1XPZ6bZqoZ6QnHlXhFLJ4X3OUFCeHwAO+mBf2izh7BhAU3Cipi
         dzLrB0OG1bp/BKgJ5mMrCMqMdG6mUs9w584SO4gTaTAJTFQyx8HiT4W0/B7YHbPkjPyF
         aGxqBmOrwwyzCDVjHpeCJyNoN//ij8fJA9jZESy2FXlQOfHuOS7mDsK7pK9rcQ3CvQQN
         7LYrjCC5wEvrkoJ9/LTr1zCrdYv1DJ9SvRQSlZc+iU8XELhAckLNypojcnKmv5bIMJQ4
         c/Sg==
X-Gm-Message-State: ACrzQf1uZ3La4oJJnfDTRpBIIi4RyLT9PcrcZnSTUedhPoFmDkEFMGRw
        VJcUDgBUIaWb3VA0r/hpK+c50tQbxGaNBgCW
X-Google-Smtp-Source: AMsMyM4Frup54P7KdL89txKbMCsbWlnlbp00icN0GyXCiI33uNDIo6cnLF5Wg5jt6sUthwz1GmX0pQ==
X-Received: by 2002:a17:907:2723:b0:78d:95d3:47aa with SMTP id d3-20020a170907272300b0078d95d347aamr8440690ejl.367.1665395157487;
        Mon, 10 Oct 2022 02:45:57 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j24-20020a17090643d800b0078d2a2ca930sm5047966ejn.85.2022.10.10.02.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 02:45:56 -0700 (PDT)
Date:   Mon, 10 Oct 2022 11:45:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 4/6] dpll: get source/output name
Message-ID: <Y0Pp019euDMHOjJu@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-5-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010011804.23716-5-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 03:18:02AM CEST, vfedorenko@novek.ru wrote:
>From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>
>Dump names of sources and outputs in response to DPLL_CMD_DEVICE_GET dump
>request.
>
>Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---
> drivers/dpll/dpll_netlink.c | 24 ++++++++++++++++++++++++
> include/linux/dpll.h        |  2 ++
> include/uapi/linux/dpll.h   |  2 ++
> 3 files changed, 28 insertions(+)
>
>diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>index a5779871537a..e3604c10b59e 100644
>--- a/drivers/dpll/dpll_netlink.c
>+++ b/drivers/dpll/dpll_netlink.c
>@@ -31,12 +31,16 @@ static const struct nla_policy dpll_genl_set_source_policy[] = {
> 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
> 	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
> 	[DPLLA_SOURCE_TYPE]	= { .type = NLA_U32 },
>+	[DPLLA_SOURCE_NAME]	= { .type = NLA_STRING,
>+				    .len = DPLL_NAME_LENGTH },
> };
> 
> static const struct nla_policy dpll_genl_set_output_policy[] = {
> 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
> 	[DPLLA_OUTPUT_ID]	= { .type = NLA_U32 },
> 	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
>+	[DPLLA_OUTPUT_NAME]	= { .type = NLA_STRING,
>+				    .len = DPLL_NAME_LENGTH },
> };
> 
> static const struct nla_policy dpll_genl_set_src_select_mode_policy[] = {
>@@ -100,6 +104,7 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
> {
> 	int i, ret = 0, type, prio;
> 	struct nlattr *src_attr;
>+	const char *name;
> 
> 	for (i = 0; i < dpll->sources_count; i++) {
> 		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
>@@ -132,6 +137,15 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
> 				break;
> 			}
> 		}
>+		if (dpll->ops->get_source_name) {
>+			name = dpll->ops->get_source_name(dpll, i);
>+			if (name && nla_put_string(msg, DPLLA_SOURCE_NAME,
>+						   name)) {
>+				nla_nest_cancel(msg, src_attr);
>+				ret = -EMSGSIZE;
>+				break;
>+			}
>+		}
> 		nla_nest_end(msg, src_attr);
> 	}
> 
>@@ -143,6 +157,7 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
> {
> 	struct nlattr *out_attr;
> 	int i, ret = 0, type;
>+	const char *name;
> 
> 	for (i = 0; i < dpll->outputs_count; i++) {
> 		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
>@@ -167,6 +182,15 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
> 			}
> 			ret = 0;
> 		}
>+		if (dpll->ops->get_output_name) {
>+			name = dpll->ops->get_output_name(dpll, i);
>+			if (name && nla_put_string(msg, DPLLA_OUTPUT_NAME,
>+						   name)) {
>+				nla_nest_cancel(msg, out_attr);
>+				ret = -EMSGSIZE;
>+				break;
>+			}
>+		}
> 		nla_nest_end(msg, out_attr);
> 	}
> 
>diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>index 3fe957a06b90..2f4964dc28f0 100644
>--- a/include/linux/dpll.h
>+++ b/include/linux/dpll.h
>@@ -23,6 +23,8 @@ struct dpll_device_ops {
> 	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
> 	int (*set_source_select_mode)(struct dpll_device *dpll, int mode);
> 	int (*set_source_prio)(struct dpll_device *dpll, int id, int prio);
>+	const char *(*get_source_name)(struct dpll_device *dpll, int id);
>+	const char *(*get_output_name)(struct dpll_device *dpll, int id);

Hmm, why you exactly need the name for?


> };
> 
> struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>index f6b674e5cf01..8782d3425aae 100644
>--- a/include/uapi/linux/dpll.h
>+++ b/include/uapi/linux/dpll.h
>@@ -26,11 +26,13 @@ enum dpll_genl_attr {
> 	DPLLA_SOURCE,
> 	DPLLA_SOURCE_ID,
> 	DPLLA_SOURCE_TYPE,
>+	DPLLA_SOURCE_NAME,
> 	DPLLA_SOURCE_SUPPORTED,
> 	DPLLA_SOURCE_PRIO,
> 	DPLLA_OUTPUT,
> 	DPLLA_OUTPUT_ID,
> 	DPLLA_OUTPUT_TYPE,
>+	DPLLA_OUTPUT_NAME,
> 	DPLLA_OUTPUT_SUPPORTED,
> 	DPLLA_STATUS,
> 	DPLLA_TEMP,
>-- 
>2.27.0
>
