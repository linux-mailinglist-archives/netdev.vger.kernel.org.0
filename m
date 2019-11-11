Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5BFF77FA
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 16:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfKKPoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 10:44:46 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34784 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbfKKPop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 10:44:45 -0500
Received: by mail-wr1-f67.google.com with SMTP id e6so15220954wrw.1
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 07:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OTPVxnQFejq+AoNfEY9ziHLlBKyMve0E2Eb7D8CDsvM=;
        b=NlZMZ6JNKrmFbgq1d+v60CJLMAEcPitVUMyH8CO8Oabh4/hijRW+hFrF4gOCzJHOSH
         nxTuVd/pZ5G2nGvcoz9DfIDhIxLVdINocZqhHVdo766p2D7td1MnJtojV7OGdcVkD0Zg
         o6gsI8Ecqq+51r8pD6bdlhAtsRA36E0K/CmYpbsNummwK2MAhlBD//uK5to/HKA6c/1y
         vDmURgwu+WNn0Po0spr5qYSGS2L/DMsyHZUPFiv/Xbr2nCLx1ppqHzMnoW3YnZCR4v+Q
         Ut0KV6/S/Tm2jTteNJyUvoF3IlBskkIaHXGfSS+8sqZZJDc09ZROpg852P6tvqYs2dgD
         UxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=OTPVxnQFejq+AoNfEY9ziHLlBKyMve0E2Eb7D8CDsvM=;
        b=XskOS0njjOrTrusdmYHlIde+AoT36g6VsNxGIKGInUwswJbfMCaAnoxWrL41y5nURQ
         DCiiV6GmUb1iQyQhZb3EryiX8fQ7cTHlFK0rbvdAGl5BrSnPQ8Yc118wEGd4gxYv+q7v
         JlpRGBHTSsQsZuuhI+dgu7vXRTAjrg5dhVlgMUFd2tsJk5d4WqWUh+bnmdcd72K7F6s+
         sDzZIbLUkItjpZSCkho0s7bDzZYf8LeXbJSWUcGbAr5837TJb0IeUz6hvOq2yaJnyWTg
         8gBRIhmjBBfXvr0YYtu5cfJyXu4OK1qlZyBi4+8EnG28VR71MiP5YmYsfkQiC6nnBuJU
         82lQ==
X-Gm-Message-State: APjAAAWc8/13G3YxbZqJbcSaNYtM4bv49aD2MVD7zcWsPpQuZ1cb/aTR
        qfZC8l1ZSfpxfUxRJ2VhEi7GlA==
X-Google-Smtp-Source: APXvYqxb5lV2vP+fMkclWvxE7Ml+3jil7wNaTNQRgPvSM5vEA13rUp7frW173OTD/hcCik/EbCb1FA==
X-Received: by 2002:a5d:6706:: with SMTP id o6mr727306wru.54.1573487083488;
        Mon, 11 Nov 2019 07:44:43 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id p10sm18000080wmi.44.2019.11.11.07.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 07:44:43 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:44:40 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Olof Johansson <olof@lixom.net>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Venkat Duvvuru <venkatkumar.duvvuru@broadcom.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bnxt_en: Fix array overrun in
 bnxt_fill_l2_rewrite_fields()
Message-ID: <20191111154440.GA29052@netronome.com>
References: <20191111020855.20775-1-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111020855.20775-1-olof@lixom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 06:08:55PM -0800, Olof Johansson wrote:
> This is caused by what seems to be a fragile typing approach by
> the Broadcom firmware/driver:
> 
> /* FW expects smac to be in u16 array format */
> 
> So the driver uses eth_addr and eth_addr_mask as u16[6] instead of u8[12],
> so the math in bnxt_fill_l2_rewrite_fields does a [6] deref of the u16
> pointer, it goes out of bounds on the array.
> 
> Just a few lines below, they use ETH_ALEN/2, so this must have been
> overlooked. I'm surprised original developers didn't notice the compiler
> warnings?!
> 
> Fixes: 90f906243bf6 ("bnxt_en: Add support for L2 rewrite")
> Signed-off-by: Olof Johansson <olof@lixom.net>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

