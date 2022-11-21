Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623DC6325BA
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiKUO0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiKUO0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:26:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F38C78F2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:24:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id n3so3546001wrp.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 06:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OshtksfIDWVyNBXwcQCfye2WB/XMxRIjggkmfmcBIj0=;
        b=jd7DxjgeYMwACxXHH9/ir3V6ph06mPEG0prTwB6eLvm6ef6t/BkCgvJ0Cr7nCDYgGo
         6XUzSwzHWDU10tre51qlrbtkfx/EnoLXcEyPAMZr1IUT+tTS8afwnrRYF0ipGLFr8bQ1
         Vd2+gzCkkQXaH8swZEH5pFvs++N/Pt+OxcBH/New9u4yrPQIBFZWzZdQ+Bc3e8Oo3fKx
         nnm04ouCoC+zyFlbMdgCLNjnSz/a8iT1OITF8VJlGxPfkHoG2Z29kSNesOqDjeJEAH6K
         qi8RNYgveFL5GPbhWPwpV4kmC7p025j9RQWhwDZ2KfR5UZRnkaygxbPb3vm9yJS6dNqS
         TZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OshtksfIDWVyNBXwcQCfye2WB/XMxRIjggkmfmcBIj0=;
        b=2n++lF8N2swsMNb1QyOejtDqksZWOZ18md6sMgC51zut8ubyYIPqItidm3dkQ/E2C3
         lvqFBHPvXvPCLj91BEXw48+hXfl513+jDqRB2qiQ8Mb4gSz9mXt/dX6zaHPI/qFxS5rR
         1tSkk8+GyhBj+J3AyeEwtjv6mvWgaP+jhB16ImdPx09Yc1WzD0H7VrrbIlSlfyFKKzAX
         ImOmysJHID/WKAyc6izj7SQaMGi898eETCdv8Hyh/JO2daoxM0FDvKT1gyBTDDnjokVD
         3lp01I447dk4cTFLKrpS8+LHtRFjjBH6HoVYBNyDjfHJ/4hMiDY5DxZpZqJ7ngYOdewO
         IqpA==
X-Gm-Message-State: ANoB5pkf3k1ezE2e31l5TUI0mSS8RFnHXz7MxovkGV8sLrKMtzMPqc/C
        sqCTNa99VLtxtxltjn2O2nw3Kg==
X-Google-Smtp-Source: AA0mqf78zhHqmsLHad8ewUUGgfibcd9NAd7VL9BHcD6RPVwDCYB4cocq7wIJjmU4QyM6FkOonJXULA==
X-Received: by 2002:adf:f612:0:b0:22e:5d66:dc5d with SMTP id t18-20020adff612000000b0022e5d66dc5dmr5516077wrp.175.1669040695937;
        Mon, 21 Nov 2022 06:24:55 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 4-20020a05600c020400b003b492753826sm13494361wmi.43.2022.11.21.06.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 06:24:54 -0800 (PST)
Date:   Mon, 21 Nov 2022 15:24:53 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Nikolay Borisov <nikolay.borisov@virtuozzo.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, den@virtuozzo.com,
        khorenko@virtuozzo.com
Subject: Re: [PATCH net-next 1/3] drop_monitor: Implement namespace
 filtering/reporting for software drops
Message-ID: <Y3uKNf53EkKMmVwh@nanopsycho>
References: <20221121133132.1837107-1-nikolay.borisov@virtuozzo.com>
 <20221121133132.1837107-2-nikolay.borisov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121133132.1837107-2-nikolay.borisov@virtuozzo.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 21, 2022 at 02:31:30PM CET, nikolay.borisov@virtuozzo.com wrote:

[...]

>diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
>index 84f622a66a7a..016c36b531da 100644
>--- a/include/uapi/linux/net_dropmon.h
>+++ b/include/uapi/linux/net_dropmon.h
>@@ -8,6 +8,7 @@
> struct net_dm_drop_point {
> 	__u8 pc[8];
> 	__u32 count;
>+	__u32 ns_id;
> };
>
> #define is_drop_point_hw(x) do {\
>@@ -82,6 +83,7 @@ enum net_dm_attr {
> 	NET_DM_ATTR_TRUNC_LEN,			/* u32 */
> 	NET_DM_ATTR_ORIG_LEN,			/* u32 */
> 	NET_DM_ATTR_QUEUE_LEN,			/* u32 */
>+	NET_DM_ATTR_NS,				/* u32 */

I believe that we need to add a CI warning for this kind of UAPI
breakage...


> 	NET_DM_ATTR_STATS,			/* nested */
> 	NET_DM_ATTR_HW_STATS,			/* nested */
> 	NET_DM_ATTR_ORIGIN,			/* u16 */
