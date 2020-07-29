Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0252231ECC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 14:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgG2MvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 08:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2MvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 08:51:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7843C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:51:05 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so2106460wmc.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 05:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V/CJ3NTA/3H0WaOZvm816/ueFkctNVkymo+bjDCPRfM=;
        b=SF+hKH90HttccXK/t5ev1GH6ydoxcTWEiHY86MMvb9bLz3elHOsvxHIjOudOOc/kmN
         jZkvfGCwQFJOyOo4msSaiMv2IL5f6smm7RSC2GWJJ5G6B9nblEYfCtO+XBTw1qcOI2AZ
         OBix0WUN0L0HR5Jtkv8+9F3b3vBbV9aGkAxZyUrfxwYlpCGVvGASLaY2O3nxZHgMFv6e
         szvjzv7on/A0PwEPb/vZ50JbDQCzDdiu8CzHlRqIbukJSQJ8c21ICMpJO0ZBXoDRUCjn
         sKcUU82o9m+HwdNRloo9GoyBrEBAsI0Kf2XTKWfqRnD9mKAiPBQFV/1SpQ2idTvcEcZk
         zHxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V/CJ3NTA/3H0WaOZvm816/ueFkctNVkymo+bjDCPRfM=;
        b=tbi7SRIZgAF88lxTeXF80N6B4J7/DvvDsApa0M0AbsJqUhUcWFC+uQnMIBkjTr/sF9
         SZgu8FJ0zFqdG1P+Cl5Se6EU6AFBX60uua4lNeX5/wYcbgs6+X1fNnvo4sIxiJJFGyVZ
         u22DoU8VU/vcFK2tkcUqvYX2qsJUnCyyiLiqPNwO3HFxEU0uk2lm1nTcbaiVwX80f4s/
         liFtz9rWHU7et1zsk/2yNWhKxwny3Fe4ypipPPwvgIyHLgahYtp7vR+TQi1OeYEn37iK
         aBT+vIci+UqsOjS6di9X0i5ffrwXf7VXQPQg7wloeePc0ZAsvUh+dCy6zg4hHJexMnqr
         wnhA==
X-Gm-Message-State: AOAM530suuvV6m7mFLaYFjZ2iVW8xuNfZhcPfM9gfxyDOg32kqhElAqv
        zdLhXZGgN4WWpP7toLY3qibnhQ==
X-Google-Smtp-Source: ABdhPJzoNBr9Oi8ZUcSZ71JYLTaWBdCseuC4Lx5d26iAn18IEx6mJwZyPZmMhgb5V5hoxjrHC5udmw==
X-Received: by 2002:a7b:c194:: with SMTP id y20mr9056005wmi.183.1596027064175;
        Wed, 29 Jul 2020 05:51:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id o3sm5030952wru.64.2020.07.29.05.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2020 05:51:03 -0700 (PDT)
Date:   Wed, 29 Jul 2020 14:51:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH v3 net-next 03/11] qed: swap param init and publish
Message-ID: <20200729125102.GC2204@nanopsycho>
References: <20200729113846.1551-1-irusskikh@marvell.com>
 <20200729113846.1551-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729113846.1551-4-irusskikh@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 29, 2020 at 01:38:38PM CEST, irusskikh@marvell.com wrote:
>In theory that could lead to race condition

Describe the problem, tell the codebase what to do.

Plus, this looks like a -net material. Please consider pushing this
separatelly with proper "fixes" tag.


>
>Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
>Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
>Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
>---
> drivers/net/ethernet/qlogic/qed/qed_devlink.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>index a62c47c61edf..4e3316c6beb6 100644
>--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
>@@ -75,8 +75,8 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
> 					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
> 					   value);
> 
>-	devlink_params_publish(dl);
> 	cdev->iwarp_cmt = false;
>+	devlink_params_publish(dl);
> 
> 	return dl;
> 
>-- 
>2.17.1
>
