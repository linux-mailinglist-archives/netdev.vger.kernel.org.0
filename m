Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F63F2E282
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfE2Qr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:47:59 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35478 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfE2Qr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:47:59 -0400
Received: by mail-pl1-f193.google.com with SMTP id p1so1302261plo.2
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LArDVKRa2Hzf5PlnwX4cyFiSYWQYWyR8ZEKtVR4D5g0=;
        b=wZvjiLkMjxIV3U605ucfGcHlTeqqqEyPbkHoEG0bR5Yc1l7/jTbywqQSebf9rf6u6a
         D0pSapazx0IpZu1vahEgwwUB7dHZByLrGOqtmWiJjlzvmiUpu+WecHvNCu4+owbN1VSu
         1LbVESAaGpJk8Gd3NpOlHfZCohtESYfH0ll9F0ZJuG4ff+dTNwzqPT0TQl5CPbVjC8jw
         UcNcmgSrFD8AYFnMj/6YSI2JNzc8EXgauJwe+IcDNLvQ2qjAE+VVAqMJh2Q4TablssOU
         lRVEJeU17QtXUOAdJMx8Mg/y4QaL6J0dRKv8ePMFRSeGoHjwJwbNtiwdZ47TaKBvw5MP
         +kRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LArDVKRa2Hzf5PlnwX4cyFiSYWQYWyR8ZEKtVR4D5g0=;
        b=AOE6muI8MiSbIbVZs2JfBt5Dy0SzgLOT711ekHVs4CIgA74ok4PxKMyOs2qSkp4/FA
         TPEIAfbXi7Tq2Xy5XrRG+XfVWzA2YsxFp4MpSETh9nH9kUK/VsjNTARtKGNazo7VT452
         UBAGCIRApVnCGHMplqJaUVBOMJjWjnyvU5ksjSzOU96/I90S3i45mx3QqlzZR069NaTs
         Vg6ZeW2H1cz0AiAcSHjh5FKy9x5pRyycw3fNd2wQF+4wGIINZdqN0RHfu6CiVmPGWyLO
         BufBU1AGORCXeJUg/oqNIWHZODG+ju+vhRFvJMXzsGAjMiBcsu2Iv4yjMF5/AbqLCmCN
         Ak+w==
X-Gm-Message-State: APjAAAUEHiyrHKDY9mOtoPFKpiFwpB7S8xS7WPE0FGOph7NxvQ76KJu6
        HyJ+8szku/9Q9VXMTL0GDP6Jtw==
X-Google-Smtp-Source: APXvYqwRy4QHiFsgMTSRreFgKpnfxh+hV5epAT62qU5fz/u3hiRqzhJSXzFmL5UXecq+g+OMxS6vvg==
X-Received: by 2002:a17:902:b204:: with SMTP id t4mr90696012plr.285.1559148478587;
        Wed, 29 May 2019 09:47:58 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id c127sm161004pfb.107.2019.05.29.09.47.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 29 May 2019 09:47:58 -0700 (PDT)
Date:   Wed, 29 May 2019 09:47:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com,
        sthemmin@microsoft.com, dsahern@gmail.com, saeedm@mellanox.com,
        leon@kernel.org, f.fainelli@gmail.com
Subject: Re: [patch net-next v2 7/7] netdevsim: implement fake flash
 updating with notifications
Message-ID: <20190529094754.49a15c20@cakuba.netronome.com>
In-Reply-To: <20190529080016.GD2252@nanopsycho>
References: <20190528114846.1983-1-jiri@resnulli.us>
        <20190528114846.1983-8-jiri@resnulli.us>
        <20190528130115.5062c085@cakuba.netronome.com>
        <20190529080016.GD2252@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 10:00:16 +0200, Jiri Pirko wrote:
> Tue, May 28, 2019 at 10:01:15PM CEST, jakub.kicinski@netronome.com wrote:
> >On Tue, 28 May 2019 13:48:46 +0200, Jiri Pirko wrote:  
> >> From: Jiri Pirko <jiri@mellanox.com>
> >> 
> >> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> >> ---
> >> v1->v2:
> >> - added debugfs toggle to enable/disable flash status notifications  
> >
> >Could you please add a selftest making use of netdevsim code?  
> 
> How do you imagine the selftest should look like. What should it test
> exactly?

Well you're adding notifications, probably that the notifications
arrive correctly?  Plus that devlink doesn't hung when there are no
notifications.  It doesn't have to be a super advanced test, just
exercising the code paths in the kernel is fine.

In principle netdevsim is for testing and you add no tests, its not
the first time you're doing this.

> >Sorry, I must have liked the feature so much first time I missed this :)
> >  
> >> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> >> index b509b941d5ca..c5c417a3c0ce 100644
> >> --- a/drivers/net/netdevsim/dev.c
> >> +++ b/drivers/net/netdevsim/dev.c
> >> @@ -220,8 +222,49 @@ static int nsim_dev_reload(struct devlink *devlink,
> >>  	return 0;
> >>  }
> >>  
> >> +#define NSIM_DEV_FLASH_SIZE 500000
> >> +#define NSIM_DEV_FLASH_CHUNK_SIZE 1000
> >> +#define NSIM_DEV_FLASH_CHUNK_TIME_MS 10
> >> +
> >> +static int nsim_dev_flash_update(struct devlink *devlink, const char *file_name,
> >> +				 const char *component,
> >> +				 struct netlink_ext_ack *extack)
> >> +{
> >> +	struct nsim_dev *nsim_dev = devlink_priv(devlink);
> >> +	int i;
> >> +
> >> +	if (nsim_dev->fw_update_status) {
> >> +		devlink_flash_update_begin_notify(devlink);
> >> +		devlink_flash_update_status_notify(devlink,
> >> +						   "Preparing to flash",
> >> +						   component, 0, 0);
> >> +	}
> >> +
> >> +	for (i = 0; i < NSIM_DEV_FLASH_SIZE / NSIM_DEV_FLASH_CHUNK_SIZE; i++) {
> >> +		if (nsim_dev->fw_update_status)
> >> +			devlink_flash_update_status_notify(devlink, "Flashing",
> >> +							   component,
> >> +							   i * NSIM_DEV_FLASH_CHUNK_SIZE,
> >> +							   NSIM_DEV_FLASH_SIZE);
> >> +		msleep(NSIM_DEV_FLASH_CHUNK_TIME_MS);  
> >
> >In automated testing it may be a little annoying if this takes > 5sec  
> 
> I wanted to emulate real device. I can make this 5 sec if you want, no
> problem.

Is my maths off?  The loop is 5 sec now:

 500000 / 1000 * 10 ms = 5000 ms = 5 sec?
