Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEDF617615A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgCBRoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:44:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54415 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727104AbgCBRn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:43:59 -0500
Received: by mail-wm1-f67.google.com with SMTP id z12so199678wmi.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DMR7rkyMs+5mqv8/PZrKNA+z1T08ymoajO02T+XyN2c=;
        b=Qe+HwxXhv4YAgn5HHTp+skNDGpbmP9ghlFiN6UcRFYruvZdgEUjQs7YHTB6s/ImjDq
         eye8J73ULu6e3ArGGHxcAS+5VIRWArsDDFkHUTwmC7uGtucA5npk9iE9dkIYXft6spRS
         1MkftaGA8eiEKIyI9TNh7+kUPUA52F/1kVQrPiO2UhhtNCIPAjQvOlZZCMfSeslAzFA7
         lRGwKqXkBPb2IOPhpLvTiXaqX9RjTdebvtSOL3q48TXoh8mv3q2uidtoCgIjtAgfc2Mu
         rtyZZW7FJ1E4q6BzRgn4E/aoPGB124UsTlfWZRFTOWYooOIxp+JPzb41DNfvZoFv+q5o
         YFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DMR7rkyMs+5mqv8/PZrKNA+z1T08ymoajO02T+XyN2c=;
        b=mbofbiH9OF8u+O7ztBVIfBkoBm6vPrGwJNSLlPuP1gawpTyytSF3J9di6WvEXy9fLJ
         V1DUIDHhMoXNQmEM/6bEUe558L/yBENdVWtw6BeUS5vWy60FMbs5xUn3D1YDkaOMpj+H
         Reea7hytLI++sBRrLTSe/cxuMDdWn5sIPbZbWsIT8gVr2/7MvNZaIH7+bCMKJIhZG5zo
         2tlXXLqlDqdlUSJBz1TTWdq0kU5OKmqwZ1fg08kym88QGwphcTBZQIQloSk1JYoAC3Ai
         Zm6Q06aTSybNxTD9eSPiaKImoc/2NxBpgCR/+ZVPJAfK7+8hmyHB6g1X6OFwfmM2E5kF
         pUkQ==
X-Gm-Message-State: ANhLgQ3j5s9OYpu2X8GIMrwVQ2YdAswqG7RqA1Cdlk4G82NV7D+xOoN5
        0xu6TaVEceFnaCQoFcBsh7Pg6g==
X-Google-Smtp-Source: ADFU+vsCwCjLxXh66sFV3Ah+4sZEzKYRhGbS/V69pbtNDUglgiQQBamtEPU/TFbJSRpDFCdaLT60Zw==
X-Received: by 2002:a1c:a9c3:: with SMTP id s186mr218299wme.82.1583171036996;
        Mon, 02 Mar 2020 09:43:56 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id u1sm10734212wrt.78.2020.03.02.09.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:43:56 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:43:55 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 11/22] devlink: add functions to take snapshot
 while locked
Message-ID: <20200302174355.GG2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-12-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-12-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:10AM CET, jacob.e.keller@intel.com wrote:
>A future change is going to add a new devlink command to request
>a snapshot on demand. This function will want to call the
>devlink_region_snapshot_id_get and devlink_region_snapshot_create
>functions while already holding the devlink instance lock.
>
>Extract the logic of these two functions into static functions prefixed
>by `__` to indicate they are internal helper functions. Modify the
>original functions to be implemented in terms of the new locked
>functions.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>


>---
> net/core/devlink.c | 93 ++++++++++++++++++++++++++++++----------------
> 1 file changed, 61 insertions(+), 32 deletions(-)
>
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index fef93f48028c..0e94887713f4 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3760,6 +3760,65 @@ static void devlink_nl_region_notify(struct devlink_region *region,
> 	nlmsg_free(msg);
> }
> 
>+/**
>+ *	__devlink_region_snapshot_id_get - get snapshot ID
>+ *	@devlink: devlink instance
>+ *
>+ *	Returns a new snapshot id. Must be called while holding the
>+ *	devlink instance lock.
>+ */

You don't need this docu comment for static functions.


>+static u32 __devlink_region_snapshot_id_get(struct devlink *devlink)
>+{
>+	lockdep_assert_held(&devlink->lock);
>+	return ++devlink->snapshot_id;
>+}
>+
>+/**
>+ *	__devlink_region_snapshot_create - create a new snapshot
>+ *	This will add a new snapshot of a region. The snapshot
>+ *	will be stored on the region struct and can be accessed
>+ *	from devlink. This is useful for future analyses of snapshots.
>+ *	Multiple snapshots can be created on a region.
>+ *	The @snapshot_id should be obtained using the getter function.
>+ *
>+ *	Must be called only while holding the devlink instance lock.
>+ *
>+ *	@region: devlink region of the snapshot
>+ *	@data: snapshot data
>+ *	@snapshot_id: snapshot id to be created
>+ */
>+static int
>+__devlink_region_snapshot_create(struct devlink_region *region,
>+				 u8 *data, u32 snapshot_id)
>+{
>+	struct devlink *devlink = region->devlink;
>+	struct devlink_snapshot *snapshot;
>+
>+	lockdep_assert_held(&devlink->lock);
>+
>+	/* check if region can hold one more snapshot */
>+	if (region->cur_snapshots == region->max_snapshots)
>+		return -ENOMEM;
>+
>+	if (devlink_region_snapshot_get_by_id(region, snapshot_id))
>+		return -EEXIST;
>+
>+	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
>+	if (!snapshot)
>+		return -ENOMEM;
>+
>+	snapshot->id = snapshot_id;
>+	snapshot->region = region;
>+	snapshot->data = data;
>+
>+	list_add_tail(&snapshot->list, &region->snapshot_list);
>+
>+	region->cur_snapshots++;
>+
>+	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
>+	return 0;
>+}
>+
> static void devlink_region_snapshot_del(struct devlink_region *region,
> 					struct devlink_snapshot *snapshot)
> {
>@@ -7618,7 +7677,7 @@ u32 devlink_region_snapshot_id_get(struct devlink *devlink)
> 	u32 id;
> 
> 	mutex_lock(&devlink->lock);
>-	id = ++devlink->snapshot_id;
>+	id = __devlink_region_snapshot_id_get(devlink);
> 	mutex_unlock(&devlink->lock);
> 
> 	return id;
>@@ -7641,42 +7700,12 @@ int devlink_region_snapshot_create(struct devlink_region *region,
> 				   u8 *data, u32 snapshot_id)
> {
> 	struct devlink *devlink = region->devlink;
>-	struct devlink_snapshot *snapshot;
> 	int err;
> 
> 	mutex_lock(&devlink->lock);
>-
>-	/* check if region can hold one more snapshot */
>-	if (region->cur_snapshots == region->max_snapshots) {
>-		err = -ENOMEM;
>-		goto unlock;
>-	}
>-
>-	if (devlink_region_snapshot_get_by_id(region, snapshot_id)) {
>-		err = -EEXIST;
>-		goto unlock;
>-	}
>-
>-	snapshot = kzalloc(sizeof(*snapshot), GFP_KERNEL);
>-	if (!snapshot) {
>-		err = -ENOMEM;
>-		goto unlock;
>-	}
>-
>-	snapshot->id = snapshot_id;
>-	snapshot->region = region;
>-	snapshot->data = data;
>-
>-	list_add_tail(&snapshot->list, &region->snapshot_list);
>-
>-	region->cur_snapshots++;
>-
>-	devlink_nl_region_notify(region, snapshot, DEVLINK_CMD_REGION_NEW);
>+	err = __devlink_region_snapshot_create(region, data, snapshot_id);
> 	mutex_unlock(&devlink->lock);
>-	return 0;
> 
>-unlock:
>-	mutex_unlock(&devlink->lock);
> 	return err;
> }
> EXPORT_SYMBOL_GPL(devlink_region_snapshot_create);
>-- 
>2.25.0.368.g28a2d05eebfb
>
