Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1BD33D9BE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhCPQqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbhCPQpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 12:45:36 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4C9C0613E2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:44:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id u4so22325452edv.9
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CjvmGjGENW3EynITI1PM5rJpSWhpBFbiElJR0zq7GdQ=;
        b=aBWY1WRQWDe+xXKy8frrjs6IoWKBiXiNp1HYJg+LHxS7+v4yl+FX47ykalEQ/TbxSs
         UuJ0RBcnKygMKNkWQBQrpln4IljGE2H3oFTQUUZsscpJ1LhhafIZHzH3SL48nrPf5bX7
         0KqgeBszB5YsF7Y+FJ7YzDsljwLlzsSpYL+bHOuMWjTHgrRubSm8D+JeDREqfs5lh4Q6
         ndj26o8TtSf3AJukDemOK92uJoBT4lk1AAW4JsP+VCJPjc1D3Ff5mW/6T5MeBxvDHila
         3PnGaBB3L4+UQhcEsg1V0K/CjqusbzYY7V7w8K4GZW4OMr+L4M8q1kVRKN0TCiR/Jf4h
         eV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CjvmGjGENW3EynITI1PM5rJpSWhpBFbiElJR0zq7GdQ=;
        b=SSg321+dWS8TGR1CRWSNqweWI8smBjDF/jdL4HVV0WlZo9ZRXEL4F0XxsXEksKmkGY
         Rcdqv1Q05nwNFne0/I3NEPeEDYqq6EzLm9S0gne2X39iO7XigyGwl6FfA3wVrdWme8sX
         D5cJJO4rRnQbQoSxiY+1Wh2aCQvprjxXK7JA9ltBP7VAyuV2cJ3BwSKcl3SggUijkLbk
         ZoM/x9XZzJYuR3joV+/4sDngO0ffBZqLkkh58VBC7mLe5gI3nLYjA87OmyInJv9rYD83
         SjqRebG2W6gYgYqAZy10QHWv5QoXpurbzDPGUOfg+ITwGo7dRGCpJ4DyblR1a2ZkkIPp
         KJ9Q==
X-Gm-Message-State: AOAM5323p+80wlCk7FAJz6x084B+0/HjXuVqMvzedBjiXlacnjw7Hb39
        edHSOMcvaEQPvRcMNod2qUY=
X-Google-Smtp-Source: ABdhPJxf+AhLQjXu5v/kRuULYbKtwCp+Xcc2/Bp2XsYLEcSWzrt/hu6zmGayCjcjZYenSS9vwP1YNQ==
X-Received: by 2002:a05:6402:3047:: with SMTP id bu7mr37149187edb.227.1615913083711;
        Tue, 16 Mar 2021 09:44:43 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id i2sm10909791edy.72.2021.03.16.09.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 09:44:43 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 16 Mar 2021 18:44:42 +0200
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: use indirect call wrappers
Message-ID: <20210316164442.zz7wzv2z4srry3vk@skbuf>
References: <20210316144730.2150767-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316144730.2150767-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 04:47:27PM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The dpaa2-eth driver uses two indirect calls in fast-path, one invoked
> on each FD to consume the packet and one for each Tx packet to be
> enqueued.
> 
> Use the indirect call wrappers infrastructure in both dpaa2-eth and
> dpaa2-switch drivers so that we avoid any RETPOLINE overhead.

Please disregard these patches, somehow I failed to include all the
changes and it fails to build. Sorry.

