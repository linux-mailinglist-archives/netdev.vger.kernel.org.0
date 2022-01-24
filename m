Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C9B4983AA
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbiAXPhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232541AbiAXPhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 10:37:21 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F29C06173B;
        Mon, 24 Jan 2022 07:37:20 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so16190385pju.2;
        Mon, 24 Jan 2022 07:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9OMf/40UVFi8Z23FZR/rr9aBU90w2IsNflq/1Hwh6Ss=;
        b=Mti2Rsw/zwpT+S4lV1SrNr5YfsrgGaPusGo4uOT90M0E5O0TfgAnO9RyHxNGBvIqnr
         RYHcm9L7/rto98Zd4szt5yeo9e2YM3aWkmarnYQoFobEDci4xiNOufWc7y/WGbnp5A7I
         hmrNeEvxJUHCN3s1vFSixXAfO4GzFmJDSyOvOPse9oYrRIzECZcw8/0UZ3w/Y6QKe/bb
         WXK0PdrRCxkFPhYEDPqpyD78zZSmifC1LYaIq9342QpAkQilwKWffpa0/3ZF7JCVZWcD
         3i5OeST9BoAmGe5qt4gDB0BGxVPs0+1iWcrX2somfsgkoVz4/i2XmdijxBuCigwu2vY/
         A2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9OMf/40UVFi8Z23FZR/rr9aBU90w2IsNflq/1Hwh6Ss=;
        b=xawN4NU5J5CheJ8inIWa5SgFJXNt1nIDxct1Y1Xn6hHJlNMx8s1dXJFLeY+gnbYK5h
         N0tpEvaRvTKYMcBCho5hlu6aOracKZLurzin75PBAPCMIQPYTAs+BW/5zuLu3xbNVroD
         i++h8yDvenlp4XmlwlCov+PD4o+BBfJOtUtu7fTZ063NXYdQeES4NizVaVoQAB5K7ELV
         KQs/WvwtmFGAiytYoMdzVW4rPRcQnc2nRaNbEJYygMFi+JPGw5roUoNPZXt5DHpO0JRx
         vRtkcrzsHklNdHEtwI5ly3tt0bFbuoBOttsvBNrNDtkmrKmoBobN2EDIn4kLe+bFvRYf
         ExqQ==
X-Gm-Message-State: AOAM533nZGYaCmR3M7RFIzKJVv2VlPs4OuceFEU9ywQeZZ6dFeP7dDG4
        NSU3Bx3U621I+yX5pYwLYJY=
X-Google-Smtp-Source: ABdhPJyuAko6BqHAbwc+WyfRV8cOUqe0bLDeMt5BMhvXJgCwrGmCCFWNdwJ4EbxclP5ElRf5M3QaYg==
X-Received: by 2002:a17:90a:50f:: with SMTP id h15mr2479903pjh.78.1643038640499;
        Mon, 24 Jan 2022 07:37:20 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r14sm20000509pjo.39.2022.01.24.07.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 07:37:19 -0800 (PST)
Date:   Mon, 24 Jan 2022 07:37:16 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220124153716.GB28194@hoboy.vegasvil.org>
References: <20220103232555.19791-4-richardcochran@gmail.com>
 <20220120164832.xdebp5vykib6h6dp@skbuf>
 <Yeoqof1onvrcWGNp@lunn.ch>
 <20220121040508.GA7588@hoboy.vegasvil.org>
 <20220121145035.z4yv2qsub5mr7ljs@skbuf>
 <20220121152820.GA15600@hoboy.vegasvil.org>
 <Ye5xN6sQvsfX1lmn@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ye5xN6sQvsfX1lmn@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:28:23AM +0100, Miroslav Lichvar wrote:

> FWIW, scm_timestamping has three fields and the middle one no longer
> seems to be used. If a new socket/timestamping option enabled all
> three (SW, MAC, PHY) timestamps in the cmsg, I think that would be a
> nice feature.

This won't work because:

- There would need to be seven^W eight, not three slots.

- Even with just three, the CMSG would have to have a bit that clearly
  identifies the new format.
 
> From an admin point of view, it makes sense to me to have an option to
> disable PHY timestamps for the whole device if there are issues with
> it. For debugging and applications, it would be nice to have an option
> to get all of them at the same time.

Right.  Those are two different use cases.  The present series
addresses the first one.  The second one entails making a new flavor
of time stamping API.

Thanks,
Richard
