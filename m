Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFC41B4558
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDVMqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726082AbgDVMqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:46:42 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D02C03C1A8
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:46:40 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so2217408wrb.8
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 05:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EuT/fEOlZIC1WMcbeBP0QRgC14FMSWwARYB0ycLTxi4=;
        b=YQSA1dvXDoptGkDZ8cA3QF6KMExx+bW/o52vI9F91tk43laEhfwGjvb/hTfDlW2Fxn
         ioWIUEHPxxW9czEn3CuF/+2gCBi4IWDoh2fylwSOsR26oejwJiCGMPRtL4/HbrmV8eBK
         VjF5IManKVyV/yLBbWoVpd6bA5/hLIBk2BVRfEGzw2mssTPNFGMvWrrfESJP+CKqwxRI
         fYbrctEC7Wjfym3n4fZmSfFux0s71r8gxp8B7k8iLxkbrWsZ0VSpgHx+rlFuFmkXJcqg
         ucY6cHqplv0l691VIjI+Gk9eIVZPHs3ckJX+T50gIlAkx9oBGvnKO3WYaN0sZZtbfSqo
         HPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EuT/fEOlZIC1WMcbeBP0QRgC14FMSWwARYB0ycLTxi4=;
        b=rDAcITtXgn3WlNDlWvp5Me/VYPzegbt2/y8zygvgIY60T+yv3C3S1KA8Xz9GMX8cND
         hyLc5aX91CIZ6sCNqtJ8rGehn1gCM27Ub4+7/uySqDNTnnD1dRZ9IOwqg4g6l/TpIAWp
         2yGmpMzZMhiwtC3SVl7HniHVjts/fU5V2DByFIrfidIESE4ivGt3uVhfQ/3ZarFyE4YE
         Yy83PGo0ynxsCkLNFOJIGkuOy9VY1OJWgn7DSxMya4q7BLcdOl3oZ2IXVb2g8vYgShjp
         iGELIIhkY+Bpj1vQGFfcGBR14NJSGLDFd20EkWKmY2VfSjC/1z4MKa+hzV5FrHJYVzzN
         ma0w==
X-Gm-Message-State: AGi0Pub+KkA0ssBg+VpllGVMsvPtIg0J1KhFY2uBAllqLbGqFpTxmKpn
        M1D0XICrjPCJ4qd/fGE64yE0Tg==
X-Google-Smtp-Source: APiQypK+UHJLrc00nBiZskVSi344kmJMw1MTGPUu7AR8Ey2WS0qKD+/2ugdZeuYUmVq+iiCjKub9Ug==
X-Received: by 2002:adf:80ee:: with SMTP id 101mr18065519wrl.156.1587559599393;
        Wed, 22 Apr 2020 05:46:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v16sm7531861wml.30.2020.04.22.05.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 05:46:38 -0700 (PDT)
Date:   Wed, 22 Apr 2020 14:46:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, jgg@mellanox.com, dledford@redhat.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, jiri@mellanox.com, dsahern@kernel.org,
        leonro@mellanox.com, saeedm@mellanox.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alexr@mellanox.com
Subject: Re: [PATCH V4 mlx5-next 00/15] Add support to get xmit slave
Message-ID: <20200422124638.GK6581@nanopsycho.orion>
References: <20200422083951.17424-1-maorg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422083951.17424-1-maorg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Apr 22, 2020 at 10:39:36AM CEST, maorg@mellanox.com wrote:

[...]

>
>Change log:
>v4: 1. Rename master_get_xmit_slave to netdev_get_xmit_slave and move the implementation to dev.c 
>    2. Remove unnecessary check of NULL pointer.
>    3. Fix typo.

It is really hard to follow the changes if you don't have the changelog
per patch. Could you have it per patch next time please?


>v3: 1. Move master_get_xmit_slave to netdevice.h and change the flags arg.

>to bool.
>    2. Split helper functions commit to multiple commits for each bond
>mode.
>    3. Extract refcotring changes to seperate commits.
>v2: The first patch wasn't sent in v1.
>v1: https://lore.kernel.org/netdev/ac373456-b838-29cf-645f-b1ea1a93e3b0@gmail.com/T/#t 
>
