Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33E42D0633
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 18:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgLFRJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 12:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgLFRJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 12:09:24 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A00FC0613D0
        for <netdev@vger.kernel.org>; Sun,  6 Dec 2020 09:08:38 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id q3so6842728pgr.3
        for <netdev@vger.kernel.org>; Sun, 06 Dec 2020 09:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2XlscYPRkM2oALq6ey4T2bXvW+IR4L9vsAT9XkOJxGU=;
        b=GuVTDhuMfgW9frGinKVVClfLxWuH6u8UBGfGDckc0Q7GVR6w7craDnwOjuUp8AxLSg
         8ESuVhaoLFqMSHdpGGiorFY+NxTcnRYAz25yEts15K/8RVJYVwulaoCQh1ucqYpu/mag
         5d+CvcFbNXsVSd2WHyZ8SsSmM4gAVnybbqPs9iKmXe66jR8rG68Pj54VasnETAFJMGP+
         voZI4mytxvgk+JoIjlhKvBP6xFElQ+DQSXfdu2vk80NCErt3MyHf3sJSCqgZdjwQi46Y
         9/hO+VKk63mHDiLyQk9jWXVVh1B5q5dU+Aik0GCcWQQEFFKImu9vpH6gnz/s00EhjXZO
         r/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2XlscYPRkM2oALq6ey4T2bXvW+IR4L9vsAT9XkOJxGU=;
        b=A990MN4VSCWC3CH6s2dxu5DJgG+w+1xxqNxQN3JsE2i5fpkqn+nEFhkV6fIfI8svPO
         1AZzuwaeCPhAtvTIq9W+VOyuuNIrhnXxZ2cYLUQd0L1rt5UJEuC/6RQRYMqwtTGjq8YL
         sGKW//ZJt8sef8b9gKvJ1BMZ1awBVk0mGPAyUmNlWlKym+LgMq7xENtyqPPpxfvyTkYr
         hsorSbo/i5P7kOgZc6S24rCqK983B6bpTNWDSw3V13si28AUrVJPLpXY9yLUYLtRTbWU
         15FL0rQjLy24heRPqxFChaqQeZoPW6sNiIARkgQUNA2y0LAMg/BnlwQ+u6XVbSZCw6Hu
         pJzQ==
X-Gm-Message-State: AOAM530SwKDqvNjHNRAel0HeDdzPDEbs8L/qTx6jVXng8AxlyO8y9EaI
        bCVmQ3gpWNor20raYxF7CYo=
X-Google-Smtp-Source: ABdhPJyoT7xsm3Md2kDK+B/pAl2gvhpHdn0jhnRmEh6clfg6RSelrJA+5HmoUVZ7oVqwODVBXHN+OQ==
X-Received: by 2002:a63:575a:: with SMTP id h26mr15567052pgm.228.1607274517856;
        Sun, 06 Dec 2020 09:08:37 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id a11sm11494997pfc.31.2020.12.06.09.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 09:08:37 -0800 (PST)
Date:   Sun, 6 Dec 2020 09:08:34 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
Message-ID: <20201206170834.GA4342@hoboy.vegasvil.org>
References: <20201203042108.232706-1-saeedm@nvidia.com>
 <20201203042108.232706-9-saeedm@nvidia.com>
 <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
 <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <999c9328747d4edbfc8d2720b886aaa269e16df8.camel@kernel.org>
 <20201204151743.4b55da5c@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a20290fa3448849e84d2d97b2978d4e05033cd80.camel@kernel.org>
 <20201204162426.650dedfc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4a8adc8-4d4c-3b09-6c2f-ce1d12e0b9bc@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 03:37:47PM +0200, Eran Ben Elisha wrote:
> Adding new enum to the ioctl means we have add
> (HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY for example) all the way - drivers,
> kernel ptp, user space ptp, ethtool.
> 
> My concerns are:
> 1. Timestamp applications (like ptp4l or similar) will have to add support
> for configuring the driver to use HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY if
> supported via ioctl prior to packets transmit. From application point of
> view, the dual-modes (HWTSTAMP_TX_ON_TIME_CRITICAL_ONLY , HWTSTAMP_TX_ON)
> support is redundant, as it offers nothing new.

Well said.

> 2. Other vendors will have to support it as well, when not sure what is the
> expectation from them if they cannot improve accuracy between them.

If there were multiple different devices out there with this kind of
implementation (different levels of accuracy with increasing run time
performance cost), then we could consider such a flag.  However, to my
knowledge, this feature is unique to your device.

> This feature is just an internal enhancement, and as such it should be added
> only as a vendor private configuration flag. We are not offering here about
> any standard for others to follow.

+1

Thanks,
Richard
