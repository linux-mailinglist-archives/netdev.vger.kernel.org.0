Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1483700AB
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhD3SoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 14:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3SoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 14:44:02 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C614DC06174A;
        Fri, 30 Apr 2021 11:43:13 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b19-20020a05600c06d3b029014258a636e8so2172377wmn.2;
        Fri, 30 Apr 2021 11:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=dBsvXDXquw1zBTgS0vLX+6A7jTM++QDpHc4jhzohuzw=;
        b=BDlNnYwKejPczZXCKknRSlfOlr5NC+OJmcPLbve+nFGD4CRYj6lEQ2RUPBww4XZ/qQ
         xpPe0qvnGqa0mArabnez5buWksZTax9JAhLtEcZZ3CJ5gi2SMsIn+ddS1/UiIgfnHJb/
         TXWY+H46MKIxQ86p+11BXNJFsEDnLeiBvAqgn97FDgtTVK1z6ydDO+4yZzIWVs5lW3ru
         5togt3KBB67AIkNjFb5Ar4Ng05NIocrzMELdBkk+ikohu9ZOWLY5twy8Al4HBJyV9i+F
         8Os/lVlxRJhMHDcTo6smuHC5Sg+M1QIWsvHei39rNMWv446C6HBssYkh4Ti8eibSdRqU
         3XDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=dBsvXDXquw1zBTgS0vLX+6A7jTM++QDpHc4jhzohuzw=;
        b=O3KPgmQeo1hoiH2r/7X+5Uxtc69r2cCij7sI1O52urvbktCkt+1SYVD7oxxoxgx0cz
         +qH0cMWkxL9Lt3QBRaH6P9JI7LNUxfLyuA8IYui07eb+JXW9RhWtAi3iNAiB/7i2dIKW
         qIkEFQXbHMplagGzEvklpbLsXhqksNzE1eK1ecIt0eZumXeJ5B1dHM4r9LZl0gwP+8C8
         mGO00E2HR8jQ+ms76R2FolquDF8n61OAH2+P82OY1JCSjm3JoSPAhjRYe/IVtmRTD29h
         rqnNdazYxP1GsytaqbkcbA4OGYsK7gEEfeZP1Zzvn6hQQBs0lTVU1GVrWtDL/7HOhQT/
         53lg==
X-Gm-Message-State: AOAM5302VeCUZ9vZqC8+e6jpsI6VV7Tk+YcDDgDhPSSsoVMioFLG7YUo
        Tsy8KSCuPtNItsiO/0D7VMU=
X-Google-Smtp-Source: ABdhPJzshtKGSkBKbF4haPfNVxr104tZYmJNuhxbF0laWTSbbulEgyZLzyfm8bIv2OXyXZcdSvp9Mw==
X-Received: by 2002:a7b:ce14:: with SMTP id m20mr4063683wmc.179.1619808192496;
        Fri, 30 Apr 2021 11:43:12 -0700 (PDT)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id o17sm3603200wrg.80.2021.04.30.11.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 11:43:12 -0700 (PDT)
Date:   Fri, 30 Apr 2021 20:43:09 +0200
From:   Petr Vorel <petr.vorel@gmail.com>
To:     Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2-next v2] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
Message-ID: <YIxPve/JoSv3GAwm@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210430062632.21304-1-heiko.thiery@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430062632.21304-1-heiko.thiery@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiko,

...
> +++ b/lib/fs.c
> +int name_to_handle_at(int dirfd, const char *pathname,
> +	struct file_handle *handle, int *mount_id, int flags)
> +{
> +	return syscall(name_to_handle_at, 5, dirfd, pathname, handle,
I overlooked this in v1. name_to_handle_at must be replaced by __NR_name_to_handle_at:
(name_to_handle_at is the function name, not a syscall number).
It also requires to include <sys/syscall.h>:

#include <sys/syscall.h>
...
	return syscall(__NR_name_to_handle_at, 5, dirfd, pathname, handle,
	               mount_id, flags);

> +	               mount_id, flags);
> +}
> +
> +int open_by_handle_at(int mount_fd, struct file_handle *handle, int flags)
> +{
> +	return syscall(open_by_handle_at, 3, mount_fd, handle, flags);
And here needs to be __NR_open_by_handle_at

Kind regards,
Petr

> +}
> +#endif
> +
>  /* return mount path of first occurrence of given fstype */
>  static char *find_fs_mount(const char *fs_to_find)
>  {
