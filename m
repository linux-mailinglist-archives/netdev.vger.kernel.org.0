Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A020643F4B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiLFJE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234510AbiLFJEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:04:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646391D650
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:04:49 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id bs21so22512921wrb.4
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5W1h6/i5cvVbXlFJedDVpvYE2wYMSyu9xiZsaFR6d0=;
        b=D0VMPRg+z7sMBp4yqkz/EWxSQOqhfAGBPI/1ot4/Y095V936InEjlN2RflzZe59Si0
         H5pa4aEiJEbuoMfMmz5GRiGLDkNJ+ixCmDSCTPC/NLcZbwqJPnnM14PVFArJEVWl2f/z
         lQX2SNCnUnzFmA+tm7FIO5PfG53iboZ3gzFoBytP3aDHaBdjMK22yIWo6JSUt0BRlrVG
         /I9samVAXXRz5nJtxsRra9ZCTGPWvIUCu8dPiyZX5Z5I2JqPy3Y4SJdnHZDEOajezGhr
         xjnXK5fDS5ZF47l3DD3Bl9I8Ba8ddclnSha7doYvUKbN8Zn1HsyxPs3aPS24wYgqTZDI
         ZQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5W1h6/i5cvVbXlFJedDVpvYE2wYMSyu9xiZsaFR6d0=;
        b=NaXhk134LPoHDQkoSU1hKhlMKNgNKXW6xas/xogVAAgGMPU6+Nvl1GafFhZRW84Tlt
         UatLHFbT4gUVYn+fKE7Ou9Dxipl98oCn6smi4J7HRs2GtoJ6YZZ7wYSWqkZ8WzBiuZee
         h8YmIZSoTLUcEz+jLAykBXpW1cj8rXDUo39yaRw877G9Z+FJUuinJc3aodBlfIz7DayM
         ppA2firNmOcDYQYg9/00N2J5ojJHcLwJPxZCgnIcFW4JCYQrXt9o9kYC36Dl8wY2uMB7
         rX0vcu5sRB4KMM6MawN8ETjVDTGvJJL8XsiFtHn6f6GPAt2uTc4B6fGT72aiO/lx05IK
         kBYA==
X-Gm-Message-State: ANoB5pk4pwY2K/nVvVuLPxeiuDPYAhs/nGaKw5hvmRsSe5REesxxx2fq
        s61UapTeBz2JBCh1YCMY7/D02w==
X-Google-Smtp-Source: AA0mqf7nkJzszwhfwbrw3Q51BRjCgLMmMnBzh79tUMAxUkWiff4fs26/5PbQ9zZHmiQvGQB9R7W4DQ==
X-Received: by 2002:a5d:5266:0:b0:242:5878:2927 with SMTP id l6-20020a5d5266000000b0024258782927mr6595859wrc.488.1670317487836;
        Tue, 06 Dec 2022 01:04:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o29-20020adfa11d000000b0024278304ef6sm952092wro.13.2022.12.06.01.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:04:47 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:04:46 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 2/2] devlink: add enable_migration parameter
Message-ID: <Y48FrgEvbj21eIMS@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-3-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205172627.44943-3-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 06:26:27PM CET, shannon.nelson@amd.com wrote:
>To go along with existing enable_eth, enable_roce,
>enable_vnet, etc., we add an enable_migration parameter.

In the patch description, you should be alwyas imperative to the
codebase. Tell it what to do, don't describe what you (plural) do :)


>
>This follows from the discussion of this RFC patch
>https://lore.kernel.org/netdev/20221118225656.48309-11-snelson@pensando.io/
>
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>---
> Documentation/networking/devlink/devlink-params.rst | 4 ++++
> include/net/devlink.h                               | 4 ++++
> net/core/devlink.c                                  | 5 +++++
> 3 files changed, 13 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>index ed62c8a92f17..c56caad32a7c 100644
>--- a/Documentation/networking/devlink/devlink-params.rst
>+++ b/Documentation/networking/devlink/devlink-params.rst
>@@ -141,3 +141,7 @@ own name.
>      - u8
>      - In a multi-bank flash device, select the FW memory bank to be
>        loaded from on the next device boot/reset.
>+   * - ``enable_migration``
>+     - Boolean
>+     - When enabled, the device driver will instantiate a live migration
>+       specific auxiliary device of the devlink device.

Devlink has not notion of auxdev. Use objects and terms relevant to
devlink please.

I don't really understand what is the semantics of this param at all.


>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 8a1430196980..1d35056a558d 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -511,6 +511,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
> 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
> 	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>+	DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -572,6 +573,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
> #define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
> 
>+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME "enable_migration"
>+#define DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE DEVLINK_PARAM_TYPE_BOOL
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 6872d678be5b..0e32a4fe7a66 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -5236,6 +5236,11 @@ static const struct devlink_param devlink_param_generic[] = {
> 		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_MIGRATION,
>+		.name = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_ENABLE_MIGRATION_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>2.17.1
>
