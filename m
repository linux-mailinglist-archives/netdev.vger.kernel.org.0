Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45371432917
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 23:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbhJRVfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 17:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRVfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 17:35:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71AC06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:33:40 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y12so4955441eda.4
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 14:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S1s0IBIc40TBfXaYRhIwMHyafQO6Pizyc7lI/K9Rn4A=;
        b=W+S6j/OtcMIrGSRl6DFNpN5PnjJluUBzkyFnRHG0QWhujo30MvkuxRT/FZg7g5PXX6
         4w6d+spN9V0Ww4H1y9hHFfT3p3OdoYx4uIydNm+SGETLl3rZQ/r2JS44AjZTfNLR2FfX
         2jIdnmNZIUGgwsowHZcp+ruARCW9PHtYH9QtgFG0xfZIBkIeJxgHPt8p5uTjaHXms3Xq
         Cdz35L+e15/JOHiJT+eu5SClN+SKuIIWErCd9ctMujT1TYEf2zA62LBgAW2iGbhEOBPS
         q92izuj0Nrhwj9SrYB1aox8B8avpxy5AcEfMRlX88B9WEkmG5KQZNk+Pobs4dxAM/Mbe
         V8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1s0IBIc40TBfXaYRhIwMHyafQO6Pizyc7lI/K9Rn4A=;
        b=balUIlF+HIDzEMyWwp7udeqX80vNv31PEIhrIkKhIIGE/aWWcC/WbE25e5hpVvUBWX
         7YLcwbNrHaAe8SykZV/59KjZI1P6X6oWq1nINjkM/xy1ZGKVkKvfosFc8V9y+SosMwyr
         TgYa6zaNJCCNgqR4W+DilohQoay2i4Hzuf2P2EgLRTQWcwwG1NHYZoG4o6tYgI7CboFh
         FhliIOIsVcCPvq5Lzej7SD+LAXNK+8kT0lW8MtEakgt+/F/ewjktxRNJ3/u474hsJ143
         JLZ+fhstsjAik0FmfDIKMlg2QNxYC59iQ/ShkpG2GDePoVvPtRdZl2qWpAIuTr1oJXn/
         QikQ==
X-Gm-Message-State: AOAM533XpFyfSYLZVTfeeZob6EytKJP/I7YliyIX7Z4rHbIELwY7qps2
        Y38gJv7KAYjKZDsL+0cGV9o=
X-Google-Smtp-Source: ABdhPJwxzG7U3seCoOougZ8hCUuCigtSpolbGkOqjuQ4/YOQn3au+N2hZ5gutAsEXlm2T41CcbhYmQ==
X-Received: by 2002:a17:906:2606:: with SMTP id h6mr33226619ejc.301.1634592819083;
        Mon, 18 Oct 2021 14:33:39 -0700 (PDT)
Received: from skbuf ([188.26.184.231])
        by smtp.gmail.com with ESMTPSA id u4sm9214988ejc.19.2021.10.18.14.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 14:33:38 -0700 (PDT)
Date:   Tue, 19 Oct 2021 00:33:37 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        idosch@idosch.org, f.fainelli@gmail.com, snelson@pensando.io
Subject: Re: [PATCH net-next 2/6] ethernet: ocelot: use eth_hw_addr_gen()
Message-ID: <20211018213337.lebu6mycyyamurvr@skbuf>
References: <20211018211007.1185777-1-kuba@kernel.org>
 <20211018211007.1185777-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018211007.1185777-3-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:10:03PM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
