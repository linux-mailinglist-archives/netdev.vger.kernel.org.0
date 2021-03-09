Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD1E2331B79
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 01:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232058AbhCIALB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 19:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhCIAKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 19:10:55 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CFAC06174A;
        Mon,  8 Mar 2021 16:10:55 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id b13so17431858edx.1;
        Mon, 08 Mar 2021 16:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rxq/xJxY3DqLAmjLM6cvna4Yitem+l+1E4HBbU5jPrs=;
        b=fDdFd2JFUEIYtLPTWTY4sTteRWf3LocORfP96LyvRWnVU1TFOyienaH9hN48HJZX11
         RXwQRz2XQvCvFZNLg3FUO8LjTk2J64SZWZJC9WeqWesN9eRtB5hp4XzSjJcn31X2Znbj
         dWv8Ifb46i+m5X8SjHnMgnd7vfresgWoiaq1dK0PaS8VXfDkQea3eiFg0I6iKz05T3fM
         U8SA7qb1F1+DdOjIG1a3gvapPd9UL2+8GI7Hjb3x9Tm+Z8MlM19+3mfQ+Zsxwb73uELz
         EaXTleMDPCLpsDcL8bULAd9p6GVNrzDIr/zaJRa6dGkF6vYX41/8LoxTVj0ovSSq9/nU
         uMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rxq/xJxY3DqLAmjLM6cvna4Yitem+l+1E4HBbU5jPrs=;
        b=o4vPOC6tpomvZPNwQoFGhiRjpz4alrPB7WRP3sKkjIMVGdDVyoKseC6bAedTy+017X
         oi2YHh1iwAHy+1H61LY1hUo50ZKBZ8G2kzFM0FoPw2xffWCSu2RGXUzKiQwtNQecj1Ja
         JrYyyrTp3BwREH1Uu34MRGERlDq07/PsUotogVK0xTlPFQme0+pcvaHO2sOukF4sRCHi
         s65NxNk1axkX2NR2ZHcZImptYJLlLFgw50AHEKZZvu5ZXyRxTesjlsTYwnMI/6RNtF7e
         OKz4XG+HQaTmNjq54S+QCvExwY7UYtRqVuOUUD/I79YfBbEOhMjeq2nGy+7YYKauOSVh
         0J6A==
X-Gm-Message-State: AOAM530Skir7ts778IJEA0jeN4Dpu03crSFCddEErUGzCq5346ctezk1
        0QvgDDpsso31CGY9S7uLsio=
X-Google-Smtp-Source: ABdhPJwQhn2EZ5rkqr/cVDjPkrcWWUJFsf8Kcp54r0EV5AV7YkTW8vR5GUAcsLtMimHKucWUUleHcA==
X-Received: by 2002:a50:e80c:: with SMTP id e12mr1070531edn.229.1615248654097;
        Mon, 08 Mar 2021 16:10:54 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id n16sm6649136edr.42.2021.03.08.16.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:10:53 -0800 (PST)
Date:   Tue, 9 Mar 2021 02:10:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: xrs700x: check if partner is same as port
 in hsr join
Message-ID: <20210309001052.jxta3e7eilkgo64u@skbuf>
References: <20210308233822.59729-1-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308233822.59729-1-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 05:38:22PM -0600, George McCollister wrote:
> Don't assign dp to partner if it's the same port that xrs700x_hsr_join
> was called with. The partner port is supposed to be the other port in
> the HSR/PRP redundant pair not the same port. This fixes an issue
> observed in testing where forwarding between redundant HSR ports on this
> switch didn't work depending on the order the ports were added to the
> hsr device.
> 
> Fixes: bd62e6f5e6a9 ("net: dsa: xrs700x: add HSR offloading support")
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
