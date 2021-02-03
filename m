Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6AA30DBCF
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 14:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhBCNvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 08:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhBCNvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 08:51:04 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B068C061573;
        Wed,  3 Feb 2021 05:50:24 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id e9so14442557plh.3;
        Wed, 03 Feb 2021 05:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJZTLx+wKAWIbKuFm4LnLXwbwiJWc4BnsCezUdYc3sM=;
        b=hWKPKYPMRwVInqHOLoFeqYKaNXcKDNSkIZeUbxx05bVkNId4uj+SWLdONYQvKciJQN
         Y5PcMgglVFRLMPKUQOm5RCj97kVaKviYNlhDYlRiwNJbokm10Grs59j2g4HTL4p/u+aW
         FCxEYfGr0/Jy5IhL2a1ugaM7KxeiDOTPN++2T/QxTQhVsRydS2qfzeyB9ODFi8Jssyai
         J5BhyqnaDkRSsFrKft7F7nLdBRupgurZyHWjhQmPRd6cZ7gDdDIuMrbGm0kGruYCKHiC
         Muh86zXtdEK1dQrUd5HUIgYMEnoNio1nBDE0HJF/M0wUEroGlE3RuHcgYgoliEhEcVsm
         xPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJZTLx+wKAWIbKuFm4LnLXwbwiJWc4BnsCezUdYc3sM=;
        b=gBirjThpLjTF/siWOI9OyBY/GSXpQYTic0ZvrXzTQc1aI70VBvfQG0/TXiyV5e7Dcj
         Cb4w7e6SX9T1gA6iFgNkm2skFhtP9J7wlhfoHjmbVY6h3xY3Ys6Q1ofIqZCps7YkLHXP
         5OtSuEUASaynQI1TL5dHNdHXpcCMDAbwvBNclMHTB0zTMnjtn1TJbVhIUn5/QDmstCQf
         A0UIuHSuY2hhHeCkyEqPnfYACptW8DcFV7VU4oYwotGF73sOWarp1+DRn0TMDxQ8h2sn
         Qg/FU10LATDvcNh36qA2/xaL5ZwpEME5HL8kOd1ff3WpIPpqu78aUSiE3jT4/uRiiL50
         UXTA==
X-Gm-Message-State: AOAM532/biX26ttTjtKrybDYEr+/oY3sAAZNmoggPwxOVcFqzp7zo9mS
        WTHgzcvbLXuXk/vrqt+0WfkccgJDAmJj7ZXn
X-Google-Smtp-Source: ABdhPJzGPKdXUny+epDEYahw3mO/tST1Qn7idQVzLqZ/A0x72nx8O4cJCUr6bK9l36Gv79YdN1OmAQ==
X-Received: by 2002:a17:902:6b02:b029:da:c6c0:d650 with SMTP id o2-20020a1709026b02b02900dac6c0d650mr3364377plk.74.1612360224157;
        Wed, 03 Feb 2021 05:50:24 -0800 (PST)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id x63sm2532560pfc.145.2021.02.03.05.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:50:23 -0800 (PST)
From:   Coiby Xu <coiby.xu@gmail.com>
X-Google-Original-From: Coiby Xu <Coiby.Xu@gmail.com>
Date:   Wed, 3 Feb 2021 21:50:09 +0800
To:     Colin King <colin.king@canonical.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH][next] staging: qlge: fix read of an uninitialized pointer
Message-ID: <20210203135009.4boh3fhpaydysxej@Rk>
References: <20210203133834.22388-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210203133834.22388-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 01:38:34PM +0000, Colin King wrote:
>From: Colin Ian King <colin.king@canonical.com>
>
>Currently the pointer 'reporter' is not being initialized and is
>being read in a netdev_warn message.  The pointer is not used
>and is redundant, fix this by removing it and replacing the reference
>to it with priv->reporter instead.
>
>Addresses-Coverity: ("Uninitialized pointer read")
>Fixes: 1053c27804df ("staging: qlge: coredump via devlink health reporter")
>Signed-off-by: Colin Ian King <colin.king@canonical.com>
>---
> drivers/staging/qlge/qlge_devlink.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
>index c6ef5163e241..86834d96cebf 100644
>--- a/drivers/staging/qlge/qlge_devlink.c
>+++ b/drivers/staging/qlge/qlge_devlink.c
>@@ -150,7 +150,6 @@ static const struct devlink_health_reporter_ops qlge_reporter_ops = {
>
> void qlge_health_create_reporters(struct qlge_adapter *priv)
> {
>-	struct devlink_health_reporter *reporter;
> 	struct devlink *devlink;
>
> 	devlink = priv_to_devlink(priv);
>@@ -160,5 +159,5 @@ void qlge_health_create_reporters(struct qlge_adapter *priv)
> 	if (IS_ERR(priv->reporter))
> 		netdev_warn(priv->ndev,
> 			    "Failed to create reporter, err = %ld\n",
>-			    PTR_ERR(reporter));
>+			    PTR_ERR(priv->reporter));
> }
>--
>2.29.2
>

Thanks for fixing this issue.

Reviewed-by: Coiby Xu <coiby.xu@gmail.com>

--
Best regards,
Coiby
