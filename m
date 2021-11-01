Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEF2E441D12
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 16:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhKAPFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 11:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhKAPFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 11:05:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D801C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 08:03:09 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v127so13481867wme.5
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 08:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hNW4Ixcay0dGNrznHOns1UxaQHFHjWDg3N8pJvJFqno=;
        b=ex+CUgRmjpNeOH4KEiWT6LNCRsWIt0aXB+6dlwTfwFZk/rgbHEhuVmCM/tK4aoMHxH
         x07MDAs2Ip4qvpWRFKdQUVo8gbaKMW6XUNBieSMnW3BubKw+T7nJbPd24S7RAQ6iN0el
         rCmiJLitn8XdsnKlB6dDo8jrON6oEczqsaxGsS5Rzva8G2Yi/+dzOyHHyb2hYm76b5pa
         xEAGr2bXxfKNiMM7WpA7fHaUpuuvmFWbVKfMhtyZDYCzbSMG1CEyMJIovRNt3qxnbWb8
         DYEwA6t0//Q8PjR2TbGqt59+3k1yoBBGLOdKcLXMfrpUCxC6VlgoesXoBEjjI/4kelsc
         vbdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hNW4Ixcay0dGNrznHOns1UxaQHFHjWDg3N8pJvJFqno=;
        b=kTWXepfvVxH53j2pSp5MBPWSE7+3O+lag5bbWFa3ERvixQajVemwMXlPKV5oLb7D4w
         kflkw6j3Z7bQ/nfZ9WEApu1CylXn9HhB5f8fGMGDVgrlR6bTDbnIZyWWpa7+UJlORaYe
         /HNoxFlI069PWtb0RbW0ZAeFl719ENmoASGHoG9yzGz0fQIeBleOCejFo196g0cjkrMk
         POAgqP7BTQ4pnPQA55iKzWUA/b09BpfE+uz8DmOG9LpmMAipwFbXAG5Eg6EL9Sjni/S3
         58YeElwdglfEFMj4ZVY5tQ/x3mBtyXi2qGbQsj+kpjZgSO5V6cAgxCDJSz4mQyAjfSr7
         9J1A==
X-Gm-Message-State: AOAM531/BeC/QCCZ/P/BGeT9ApInU4D838jFNLykI8G98hJng1Ez9lVK
        rAZlp6FFbPFC0ZVAHIrrQWQeBg==
X-Google-Smtp-Source: ABdhPJwbSkfrRv896OFRnYQBtg+wMg8ZmNTYt4yupDg+yRlbMnlLvW1VjPmF54wREkDH2p6uwzqOSA==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr32860015wmc.121.1635778987465;
        Mon, 01 Nov 2021 08:03:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q4sm9330749wrs.56.2021.11.01.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 08:03:06 -0700 (PDT)
Date:   Mon, 1 Nov 2021 16:03:05 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, idosch@idosch.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <YYABqfFy//g5Gdis@nanopsycho>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Oct 31, 2021 at 06:35:56PM CET, leon@kernel.org wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>Devlink reload was implemented as a special command which does _SET_
>operation, but doesn't take devlink->lock, while recursive devlink
>calls that were part of .reload_up()/.reload_down() sequence took it.
>
>This fragile flow was possible due to holding a big devlink lock
>(devlink_mutex), which effectively stopped all devlink activities,
>even unrelated to reloaded devlink.
>
>So let's make sure that devlink reload behaves as other commands and
>use special nested locking primitives with a depth of 1. Such change
>opens us to a venue of removing devlink_mutex completely, while keeping
>devlink locking complexity in devlink.c.
>
>Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Looks fine to me.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
