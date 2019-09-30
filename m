Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE1C2AD1
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732270AbfI3X0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:26:07 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39492 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731127AbfI3X0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:26:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so19279256qtb.6
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ocetQFj9q803IP/jkt+4H/mkehh1rco/rSt8i2izBeo=;
        b=OeMwI02mbDZKoGAw1+dc+iuI/4WooYQshGOPTiDfA8Xc3FoR9/FWH07mi6raQLPCyP
         2Tbjywx/2M3saN1SR/epSp/ejE7FU8dxNrV0I/s6nUrwE29mzZrnXTUYrSHf/dftXshs
         3IV1XLL+cM3UJRgzRFlAjdWBbI6z7HDG7LWTsqpOBXCWFLibuGwOVxxHv8dgFu3QRf9Q
         44jIKJqqszte0WHTTMVCNnT6br56kLrFs3rPaAqw+Q1M8ompVa3vJgEr0v6igdWvNcBg
         5jwN7bk7LH48D5Dg9OX3IOjNw2LCRvIvuvFxf5op4AobtqLKin8ifsrAQOieGzkTHfys
         8uDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ocetQFj9q803IP/jkt+4H/mkehh1rco/rSt8i2izBeo=;
        b=hmHx1Nsyg4NWzqvNQPTrBS+vc22SDwwKEuTY15dfKZ7/Ku96ci/CY46UfDjJDJ428f
         A8O2MaIqvdxaEDZH2tYgLrxfahJ7Yey19jQPIHZXRvjk2W5dah+Z2dXt/um4D2RcnQ+s
         G3pIoxFIgIM+EbmuJdxp2d2goEpAvZKL81R7rzDndBpotbv//NZeytBWYNT+Focav668
         Z0dqhKBVTwCuGog/GOtFcvmVDKh3BnzZwrPg72FtmJDR3ZdSMEYohQMUGdi92NVii1Th
         yasNbZ81By1EavyevXEMDifMjYPJOuUh4UeRax8VWtaKXJQZE3SEWdaJumzfGsouQ11W
         MUJQ==
X-Gm-Message-State: APjAAAVU3wtvk6x5PqTTSvamWhegkNzv3VTqW65FoPaLT5JiAEM1SWfn
        tRb0PsRWWV//nYpk6F/QYyC+Jpg9FiA=
X-Google-Smtp-Source: APXvYqzxc3pZvkrxWCGuVKycTVPa4JAadtHG9hY3zBbG0xs4FAIvM9vj8w0fLq8zKWfbhXHyrgrT1w==
X-Received: by 2002:ac8:1767:: with SMTP id u36mr27372813qtk.152.1569885965889;
        Mon, 30 Sep 2019 16:26:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f27sm7556541qtv.85.2019.09.30.16.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 16:26:05 -0700 (PDT)
Date:   Mon, 30 Sep 2019 16:26:02 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v2 net-next 1/5] ionic: simplify returns in devlink info
Message-ID: <20190930162602.3d0ada9f@cakuba.netronome.com>
In-Reply-To: <20190930214920.18764-2-snelson@pensando.io>
References: <20190930214920.18764-1-snelson@pensando.io>
        <20190930214920.18764-2-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Sep 2019 14:49:16 -0700, Shannon Nelson wrote:
> There is no need for a goto in this bit of code.
> 
> Fixes: fbfb8031533c9 ("ionic: Add hardware init and device commands")

IMHO the fixes tag is disputable here, since this doesn't even generate
a warning.

> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index af1647afa4e8..6fb27dcc5787 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -19,31 +19,30 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>  
>  	err = devlink_info_driver_name_put(req, IONIC_DRV_NAME);
>  	if (err)
> -		goto info_out;
> +		return err;
>  
>  	err = devlink_info_version_running_put(req,
>  					       DEVLINK_INFO_VERSION_GENERIC_FW,
>  					       idev->dev_info.fw_version);
>  	if (err)
> -		goto info_out;
> +		return err;
>  
>  	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_type);
>  	err = devlink_info_version_fixed_put(req,
>  					     DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
>  					     buf);
>  	if (err)
> -		goto info_out;
> +		return err;
>  
>  	snprintf(buf, sizeof(buf), "0x%x", idev->dev_info.asic_rev);
>  	err = devlink_info_version_fixed_put(req,
>  					     DEVLINK_INFO_VERSION_GENERIC_ASIC_REV,
>  					     buf);
>  	if (err)
> -		goto info_out;
> +		return err;
>  
>  	err = devlink_info_serial_number_put(req, idev->dev_info.serial_num);
>  
> -info_out:
>  	return err;

Perhaps return the result directly while at it? I'm pretty sure you'll
get a half-automated patch from someone soon if you don't do it ;)

>  }
>  

