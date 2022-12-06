Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E91643F56
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiLFJHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231641AbiLFJHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:07:23 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90ACE1DA52
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:07:22 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z92so19409130ede.1
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 01:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/ByKMkKyg5nTyb4wVcMWPeyxtYEza/ZX6fncMKHx678=;
        b=o0wukHixZM2FsnGiEjbnQY3WJpZIq6JqoLXx0gMUZL4eRNcmDVrfAwOjx0V1WoGRey
         jArIZpGTH/v5M2XwDQcda30VNExwHLjeH0nySG/o45avQt1SZycnAa4Hb2Fvs9VssS0q
         auHCEN+zGmtW8inzlrFKPO6XaxHS/n4Bpalc0tVkdO9Z7siOF0ePuRHzO3aXA7L7F6MQ
         rZhkIj4CBMTFsGjTc0g04x6d+yJQvvety8OiQ95c7bjKEEpW1vXchtr+XZ5cwHA5aoac
         qHNprx1XPZKI4HEsqDb3ta++xf2GhAcSwE33h7HJOp9zlnBrzINOn6iGwGdD0fPJw79q
         UHPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ByKMkKyg5nTyb4wVcMWPeyxtYEza/ZX6fncMKHx678=;
        b=haEpW6CPI5gf8QsKZ6//3qL0dllQCrRSjkJmJnYkRoLWyplXIU02sdFkda4RqhHYiH
         O4vHCXHm41j1fEeqSKPYrTHVIFWWBGyRqejDeXFoATHi6SF+HwCsrUO9bIoO+tQfNS3V
         aPrgVnZJHonJVvuHkOqsL6g1eumpB5CV7mRZVNy+nCV8Bf4AjsnRILFGXYoaQySwspt+
         tP8pPc8qdE+zRE17gOgJvW64IXSEiDKzL/LJ0O6zZnBMQ592PDj2sP5k+YIYwVhMejUB
         e0jIbZ9tVShVqRURvCTjX2xvmpBQLlCSSlkWbnxU39eoW6cIe7+9s6ojeuwnJHUFsa9Q
         wzbw==
X-Gm-Message-State: ANoB5plLDRn5NfoL1TsBqndJXjjlST+e2RLhaD2MHBxioQHLINcKOoyY
        70nwU8pU++7HSb03qQNlz/7o4A==
X-Google-Smtp-Source: AA0mqf4kE9iJ8TxJTPrJiEY4l4/V3Mw/+lOcu4PokJRUFrUHbY8fPOk28UaFrmSFpTxmfCdZdLoaBQ==
X-Received: by 2002:a05:6402:4028:b0:467:c33e:edd6 with SMTP id d40-20020a056402402800b00467c33eedd6mr24822752eda.146.1670317641093;
        Tue, 06 Dec 2022 01:07:21 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id dn18-20020a05640222f200b00463b9d47e1fsm736661edb.71.2022.12.06.01.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 01:07:20 -0800 (PST)
Date:   Tue, 6 Dec 2022 10:07:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <Y48GR+NShwJiIBTc@nanopsycho>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205172627.44943-2-shannon.nelson@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Dec 05, 2022 at 06:26:26PM CET, shannon.nelson@amd.com wrote:
>Some devices have multiple memory banks that can be used to
>hold various firmware versions that can be chosen for booting.
>This can be used in addition to or along with the FW_LOAD_POLICY
>parameter, depending on the capabilities of the particular
>device.
>
>This is a parameter suggested by Jake in
>https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
>
>Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
>---
> Documentation/networking/devlink/devlink-params.rst | 4 ++++
> include/net/devlink.h                               | 4 ++++
> net/core/devlink.c                                  | 5 +++++
> 3 files changed, 13 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>index 4e01dc32bc08..ed62c8a92f17 100644
>--- a/Documentation/networking/devlink/devlink-params.rst
>+++ b/Documentation/networking/devlink/devlink-params.rst
>@@ -137,3 +137,7 @@ own name.
>    * - ``event_eq_size``
>      - u32
>      - Control the size of asynchronous control events EQ.
>+   * - ``fw_bank``
>+     - u8
>+     - In a multi-bank flash device, select the FW memory bank to be
>+       loaded from on the next device boot/reset.

Just the next one or any in the future? Please define this precisely.


>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 074a79b8933f..8a1430196980 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -510,6 +510,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
> 	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
> 	DEVLINK_PARAM_GENERIC_ID_EVENT_EQ_SIZE,
>+	DEVLINK_PARAM_GENERIC_ID_FW_BANK,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -568,6 +569,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME "event_eq_size"
> #define DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
> 
>+#define DEVLINK_PARAM_GENERIC_FW_BANK_NAME "fw_bank"
>+#define DEVLINK_PARAM_GENERIC_FW_BANK_TYPE DEVLINK_PARAM_TYPE_U8
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 0e10a8a68c5e..6872d678be5b 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -5231,6 +5231,11 @@ static const struct devlink_param devlink_param_generic[] = {
> 		.name = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_EVENT_EQ_SIZE_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_FW_BANK,
>+		.name = DEVLINK_PARAM_GENERIC_FW_BANK_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_FW_BANK_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>2.17.1
>
