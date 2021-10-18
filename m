Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3118C43245A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhJRREL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 13:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbhJRREK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 13:04:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636CFC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:01:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id qe4-20020a17090b4f8400b0019f663cfcd1so14950703pjb.1
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 10:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/I9J3P31boI1XKLBs2K675bnHHS64wpGLIx+qFAYY20=;
        b=vztpI2qL0rJLIJ6uYoAV+VpasyYUnE0bXaJWeT0Vi8b51csHnDZmny0bTOks6dffEi
         nNkQhyJkFxNDJgWqMOXgR0XgUD/QBxarRw7aOO+mnt6anLFlU4WIm55htyhm0OnB6XOW
         jqiGrTkfmzDJvFmlY+OcCzm42nWzfkilhuf+zZNB55ZoK7vZf6Ymh0JiZSaD1QbRVg+Z
         tIG4umBzZJDwrAUdchepC6/bGr58u0phqnEQ75QLyv/3bVCobXAM4QGrROQl91cklh1n
         tojxD2TeB6WIouhhpIws/zns+SIYx8rWR7YOBfsN4YeQEl8qxXY7JrQaX+f8eXnnN/QJ
         Qh1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/I9J3P31boI1XKLBs2K675bnHHS64wpGLIx+qFAYY20=;
        b=JZgo2t4RndWuYHOO8Ve32wUakGwDC4XS4tVV7Pqnjfvpicnn4pGb3m04MB65qCfpbM
         3wE/p5w/NKJG063JXJ6eQe1IZnHs1inB9oYBscTzD8EPmwniFepM1fl6RV82owzaVc3w
         Ti4N4PhXa9JfTeNjPOTzlQOkHd0vc2rVVx3NB/Vz82cLqPTG9hgAS2vQHHVA40E9ukLv
         5ITya/6nSgP0fEEuE+D/hTEEu9803puzD5C5KeRj65oV5nss/DybFhNneZCv5XVGkRnZ
         ywEqx2og3qv6fXkaUTTJecliW9XRer0yWBY6rfdtb5DGM+cxU5wy+ZACGdOD8WWJUB5/
         uCrw==
X-Gm-Message-State: AOAM533fqWvY67z1NGGDoRBAc4mi/oOMTvE4cN/+OykDcZa7tPvz0mwW
        sPlyowOTnQrAafa1hkZNjsPZEA==
X-Google-Smtp-Source: ABdhPJwMqzWB1aFCAmIq/7mov4j0b9+irq3q5PhAPnXHcKhNCJm/CqCClI5HrSZb1rJzr4cL4lZCsA==
X-Received: by 2002:a17:90a:c08d:: with SMTP id o13mr26390pjs.181.1634576518819;
        Mon, 18 Oct 2021 10:01:58 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d137sm14071155pfd.72.2021.10.18.10.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 10:01:58 -0700 (PDT)
Date:   Mon, 18 Oct 2021 10:01:48 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mlindner@marvell.com
Subject: Re: [PATCH net-next 02/12] ethernet: sky2/skge: use
 eth_hw_addr_set()
Message-ID: <20211018100148.75ab3f23@hermes.local>
In-Reply-To: <20211018142932.1000613-3-kuba@kernel.org>
References: <20211018142932.1000613-1-kuba@kernel.org>
        <20211018142932.1000613-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Oct 2021 07:29:22 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Read the address into an array on the stack, then call
> eth_hw_addr_set().
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: mlindner@marvell.com
> CC: stephen@networkplumber.org

Looks ok. Don't even use any of that hardware anymore.

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
