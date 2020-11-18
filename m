Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9ED2B820F
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbgKRQjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgKRQjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:39:01 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D24BC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:39:01 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 10so3650277wml.2
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qLCTzVhQJLTsRIBZ7JeZwl8s+Rb2VI2/f9BYU4yDXGQ=;
        b=2I1A+KVt99FqDJGHeaTQkV3BqcTnhrsXFbEbNXXj7hruZe20iE2ektH3brew34XAQK
         1RQuIsbAuNr/9c7D8RgvgJ9ILarMAz7BWiU62GuVZYLQ+o3CWpr3kCncT1AupiPme+A9
         LQTtW3x8/uy5nQd3xG50xWILpvPI/56AsYYea5CzUUIZBXRR9BLYXnKLrlOXi+7ft9EX
         XFgO4mJjR52Wo+thw7dAge+WZmUVcVfM8upjdE4WcihIgEJXpC4G4YjsCztLfIhoO/pS
         niao1Mmd/OH1EVX7HhcmxQhk6JvWoRPDtefKDGOCzjDo4MfoiuIvd6zBX6k2VbB1BvZ+
         /geg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qLCTzVhQJLTsRIBZ7JeZwl8s+Rb2VI2/f9BYU4yDXGQ=;
        b=oxIj/LJFeOZ4ubjhaQJjqySBhKTjUUVRsxVfKzYs024bCnRbP9qYt3eymRTQDU3EJM
         w2vzQ1+bnb/w4lWXgA11Go04tDGLqQUZzsYa9O7afjfsxzy8GbJ0SQMsudNEb/1RbT49
         t4NXK6AGHvV4ptHzK9oMKVR0iQmgf+8hjF3QyO+42nt27EkjNfjTrMyngUQ0iSmZUY/5
         FxehUm4zKP0DmZwf1BgIhtUGj8s+rdTWSb0Xo76AwA1FKu43jtJqDUCnwWp5CnrYBIQk
         QUehguEIy0lGR8rnisasc9QH/vANS8Nc/9Dll9z7UTYeDA/3MA0eu1/QZKeusjdrBLVL
         0C5w==
X-Gm-Message-State: AOAM530pQsSM/vLJu4KLSHp6NbZDNLE0Obg5jceCKRh6Aqsutvsx2HX1
        l8wRUWDSZnNTKdd+v+ONFUp5sQ==
X-Google-Smtp-Source: ABdhPJzXZnCuRB6U7IdUNWYY6GJ4wEv+ZFa5pj1ebVTKxkVDsmk5ztyn3jPfKzB+yXbvG6T5IZviyA==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr904116wml.174.1605717540324;
        Wed, 18 Nov 2020 08:39:00 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id d3sm36955855wrg.16.2020.11.18.08.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 08:38:59 -0800 (PST)
Date:   Wed, 18 Nov 2020 17:38:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Subject: Re: [net-next v3 1/2] devlink: move request_firmware out of driver
Message-ID: <20201118163858.GC3055@nanopsycho.orion>
References: <20201117200820.854115-1-jacob.e.keller@intel.com>
 <20201117200820.854115-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117200820.854115-2-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 17, 2020 at 09:08:19PM CET, jacob.e.keller@intel.com wrote:
>All drivers which implement the devlink flash update support, with the
>exception of netdevsim, use either request_firmware or
>request_firmware_direct to locate the firmware file. Rather than having
>each driver do this separately as part of its .flash_update
>implementation, perform the request_firmware within net/core/devlink.c
>
>Replace the file_name parameter in the struct devlink_flash_update_params
>with a pointer to the fw object.
>
>Use request_firmware rather than request_firmware_direct. Although most
>Linux distributions today do not have the fallback mechanism
>implemented, only about half the drivers used the _direct request, as
>compared to the generic request_firmware. In the event that
>a distribution does support the fallback mechanism, the devlink flash
>update ought to be able to use it to provide the firmware contents. For
>distributions which do not support the fallback userspace mechanism,
>there should be essentially no difference between request_firmware and
>request_firmware_direct.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
