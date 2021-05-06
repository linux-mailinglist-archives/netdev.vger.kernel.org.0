Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97F33752EE
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbhEFLUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhEFLUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:20:05 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79A3C061574;
        Thu,  6 May 2021 04:19:06 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d11so5182092wrw.8;
        Thu, 06 May 2021 04:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RIYSSOTqbU4bjWd1UhczfEIR8FFE4HUiKHsG2UQGJzI=;
        b=AzcR3V4gEQBZbbZ/YQkC3rGH7hIfHeMZglHNMGJ41o0qyCJ8YJhj4Sc1zb+Kq/5JQS
         ntBYM7n5q6H8TEzjM9zSFt9/JH5r8LJhqM7vQQcJwwR8qSFWAPOZx0EOG5AfHWQjAlun
         uz2w6g9rbx0+jU4+vnUPVy+usmG4cDkO66VmThrxbOqYV88TWMrvVW/Lf2klAItmlbP4
         QtFsY1R6C/4jRPLYZaZ9wYRztbpb2XC5CQkqUJXcVQUr9KfWrWfPbpQCPxD9/caA9nYq
         qWtrPx6XWHPC2rC3QkqLrmvsGkNeLzmTrdXBhRozXOfl55T2X7eTEPaBe4Jd/mZ86gD2
         upBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RIYSSOTqbU4bjWd1UhczfEIR8FFE4HUiKHsG2UQGJzI=;
        b=tFa8uROM+zr8tV+dnlxRB3S2X+uP2vRomEmNjaVxryMhWd6xZqLzs6wpffhiWk8PKA
         67MQbT5K7y58yUJQr4sYH34Qu2IwB72Q2gGLk+YhtHcj3x3+Lr2AxlGK0nMgfyAdfB2+
         FTzCHnq6FZ9CRbO4VbvMucegizHBwO8TxHS37RWcwWZ4a5zKRiAOCgrpsDGzrXnXaG4E
         Ls3fe9HpXjGGzQg4pHaBOOcCZoPKOQPR8kjIrg5umtSpAb135I3BCEOFXK+BsSW1NJsX
         l1p3gGPSXikA23OBuyzwufUPUnK8YMhcCUe9KA9bb0rUXSWqMmfabK9HRXK3C14kwHil
         AJDg==
X-Gm-Message-State: AOAM530Ogb48p053vBR4ANEIomEqsqV83bhWb5Hy8P2G1kw2dXncezWx
        pegX8RQr7RqpZ2oE/f9p4PY=
X-Google-Smtp-Source: ABdhPJwI7oAa4sNMywqlZW+7NLyKSGIQNR+wtC6dt/qZ3Aw3TNq4DqymcBFrkKu3WNWy892dKO4oBQ==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr4601542wrw.250.1620299945217;
        Thu, 06 May 2021 04:19:05 -0700 (PDT)
Received: from skbuf ([86.127.41.210])
        by smtp.gmail.com with ESMTPSA id m13sm3813148wrw.86.2021.05.06.04.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:19:04 -0700 (PDT)
Date:   Thu, 6 May 2021 14:19:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v3 06/20] net: dsa: qca8k: handle error with
 qca8k_write operation
Message-ID: <20210506111903.2cczm4cldyqbpnyw@skbuf>
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-6-ansuelsmth@gmail.com>
 <YJHptHS8eN2gGaRd@lunn.ch>
 <YJHrHV+kSmNxf1GD@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJHrHV+kSmNxf1GD@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 05, 2021 at 02:47:25AM +0200, Ansuel Smith wrote:
> On Wed, May 05, 2021 at 02:41:24AM +0200, Andrew Lunn wrote:
> > dev_err()
> > 
> > In general, always use dev_err(), dev_warn(), dev_info() etc, so we
> > know which device returned an error.
> >
> 
> I notice that in the driver we use pr function so I assumed this was the
> correct way to report errors with a dsa driver.

Nope.
