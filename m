Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AED2C8D24
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388194AbgK3SnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:43:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40130 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbgK3SnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:43:21 -0500
Received: by mail-wr1-f66.google.com with SMTP id o1so3614064wrx.7;
        Mon, 30 Nov 2020 10:42:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0z4kMZ/L26HA3bimUDjYY1jt90FsNiuc+VpOhte22TQ=;
        b=NR0fCLUqP6hySFY9eXBKI69/FdYZTwtP0UXTMxKpAoXAcNZfvx5HD6xgyTvD+oaHjT
         tdjW2aUuvb7pq3u9UFT9UTB6Ch0Hdf5jDxUNR1kGtG2IcqBLgy6Y51TqKGFmorxD0UwK
         bqkjvWPLvty7/TcfCzL3OedcLAu6NLDaQ0SFHXdCt+l2beBx2fvR1cV3NUI8dE2pdDrV
         2K18susVkFkvZL6SwHaKcUYB1BaCGoSruJ99enBlVBdFT/t0cDja/OII93tx+8XIeceI
         5n3OCfeeNKDWcveOrIaB8gj5u54/tL4jjoET471PjPjFQZOi9Uzc0eLYO2GtwMZ44o1g
         Srbw==
X-Gm-Message-State: AOAM5317Cqs8gWjrA+SCDA1or3Er0kqHXK9BEWUPWbQZYgfI2kz8Huk/
        u4QhCl9gL0YK7Wqm+IOjGk8=
X-Google-Smtp-Source: ABdhPJzS5rKeyCdk7vXGyB027nSu2wXtFxZrWsRmSCyWSC+2I/zY4xZDJCEwxue7oPvvwvvIKto80Q==
X-Received: by 2002:adf:e88a:: with SMTP id d10mr31071993wrm.29.1606761752819;
        Mon, 30 Nov 2020 10:42:32 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id y7sm10350445wrp.3.2020.11.30.10.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:42:31 -0800 (PST)
Date:   Mon, 30 Nov 2020 20:42:30 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v3 net-next 3/4] nfc: s3fwrn5: extract the common phy
 blocks
Message-ID: <20201130184230.GC28735@kozik-lap>
References: <1606737829-29586-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606737829-29586-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:03:49PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Extract the common phy blocks to reuse it.
> The UART module will use the common blocks.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  Changes in v3:
>    - move the phy_common object to s3fwrn.ko to avoid duplication.
>    - include the header files to include everything which is used inside.
>    - wrap the lines.
> 
>  Changes in v2:
>    - remove the common function's definition in common header file.
>    - make the common phy_common.c file to define the common function.
>    - wrap the lines.
>    - change the Header guard.
>    - remove the unused common function.
> 
>  drivers/nfc/s3fwrn5/Makefile     |   2 +-
>  drivers/nfc/s3fwrn5/i2c.c        | 117 +++++++++++++--------------------------
>  drivers/nfc/s3fwrn5/phy_common.c |  63 +++++++++++++++++++++
>  drivers/nfc/s3fwrn5/phy_common.h |  36 ++++++++++++
>  4 files changed, 139 insertions(+), 79 deletions(-)
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
>  create mode 100644 drivers/nfc/s3fwrn5/phy_common.h

I am sorry, but I am not going to review this. Please send properly a
next version - v4 of entire patchset - while fixing issues pointed out
in my other email (so use proper workflow).

Best regards,
Krzysztof
