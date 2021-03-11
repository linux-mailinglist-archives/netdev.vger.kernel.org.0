Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A768336D43
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 08:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229867AbhCKHr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 02:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhCKHrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 02:47:37 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF309C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 23:47:36 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id y16so701640wrw.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 23:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nqfb5eVBl/kN2CHQkBMfaJMflmNuESTcEWjCD6aSO6Q=;
        b=rZSkDyS+r4PfFT+pB4nNDQcZAFeB3KkkL62Re6T8MDCV4H7fHG5Nam7T6EZ10aIjd+
         BQoq2Wy4Ti2LLb0eveqDmhmGk6RJtop9+jbKNwy5mMiPWVMYnhg/0X2gT5jZyfERYydo
         GtU1/7AvbcnH78JQev4xVCdtmDAJVNg55wo4PE3UDf2WBtxXf7S7IAMw7vYQV1bwVZJf
         BCd4y4bPP4hl8zSnlVnF4UZH3aVUFqLnH0noCKCVnJ3ag1twpjb47cVpAC4w9qRGVomV
         dU6OS4HBW88kvDeh+KuunC0gWH+r8ZpXeCU+/iRw8aOu9XBgbGaxmrdiaoOAH/IWCp2h
         922Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nqfb5eVBl/kN2CHQkBMfaJMflmNuESTcEWjCD6aSO6Q=;
        b=ZzHLPerh+Xmeaqx/PfR6SG4b+5z+6Ohme5n8IDvEozbXcw8QfTSIscfbafPV+g0ZkS
         tjcwoCe4k1vfd8IW30GA7KJ41AtJ08O0zzgUAaPUsPvXYl1hiXWBM7emt6i+LQf5mNo3
         DPIZ4aheC8qQOEYnn7mTPhm2qIAZOrYXw6DE+ATrZbw2rlY32Xg1iEI86SxuLUMfIev/
         89mZrHn5gPlvplSLyIt2fhrTAoU2iKNCqUgtP24sdwq7Ad5RQLtEcjnjNVYATRb6FjCC
         tiS3QxMpQpTD+6Z9stRYHYZRe48PKK+ZlvODs7Wrnv1E3G9NsckOmRqoSrWNEWt/J6VL
         KHHQ==
X-Gm-Message-State: AOAM5310BZeQhfmQ/FTiSNGxiJFAb8WqK6Bh5KJI/Wx32WM+uNFW8Kbt
        p4ffXkd3qKcZKwuru3WkWZv1YA==
X-Google-Smtp-Source: ABdhPJzTZFTtiP04tDI+C4PIZXE1lKZMoGXTLBH2qDgJ93yth/AZBpUvq7mZXLqqRr/ts8wGdL5r0A==
X-Received: by 2002:a5d:4e83:: with SMTP id e3mr7334145wru.82.1615448855536;
        Wed, 10 Mar 2021 23:47:35 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p12sm2472475wrx.28.2021.03.10.23.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 23:47:34 -0800 (PST)
Date:   Thu, 11 Mar 2021 08:47:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     f242ed68-d31b-527d-562f-c5a35123861a@intel.com
Cc:     netdev@vger.kernel.org, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC net-next v2 1/3] devlink: move health state to uAPI
Message-ID: <20210311074734.GN4652@nanopsycho.orion>
References: <20210311032613.1533100-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311032613.1533100-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 11, 2021 at 04:26:11AM CET, kuba@kernel.org wrote:
>Move the health states into uAPI, so applications can use them.
>
>Note that we need to change the name of the enum because
>user space is likely already defining the same values.
>E.g. iproute2 does.
>
>Use this opportunity to shorten the names.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>---
> .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  4 ++--
> .../ethernet/mellanox/mlx5/core/en/health.c    |  4 ++--
> include/net/devlink.h                          |  7 +------
> include/uapi/linux/devlink.h                   | 12 ++++++++++++
> net/core/devlink.c                             | 18 +++++++++---------
> 5 files changed, 26 insertions(+), 19 deletions(-)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index 64381be935a8..cafc98ab4b5e 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -252,9 +252,9 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
> 	u8 state;
> 
> 	if (healthy)
>-		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
>+		state = DL_HEALTH_STATE_HEALTHY;
> 	else
>-		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
>+		state = DL_HEALTH_STATE_ERROR;

I don't like the inconsistencies in the uapi (DL/DEVLINK). Can't we
stick with "DEVLINK" prefix for all, which is what we got so far?

