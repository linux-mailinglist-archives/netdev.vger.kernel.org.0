Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19B5D394CBB
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 17:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhE2PSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 11:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhE2PSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 11:18:11 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E900CC061574
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:16:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u7so3041314plq.4
        for <netdev@vger.kernel.org>; Sat, 29 May 2021 08:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a/DXzL6xVd+6IK1tO7Dg59f+qNrmIZbMGU3nnk4Qy5s=;
        b=hnapLScJ2NpftAxnHk4kyQOGJ6glOUnhwXoFjQPt1I6H/Eb2Wv/fVDwtH6w/PQlBh3
         eb6jqwazSi5Sb5rPFqn3lsgydSvpfegx35bz0BdojOal6/vF+s/M4QKcREirhxFfbqSp
         nYW49Slgn11x07Xq8+WQq5F64vwKXNWO5hmw+r9/JJlj/DxQ3wQ9oOO6Tgdk7ZAXA/lV
         osu9WyVR8JcIU5s6vnFwdXnvy0SwAO7pQ4pWDZjJ6ABNC+LLAJ+irbYHzad058S5oW0s
         GM9VCrIp18O1VrFrpoTK+0t2kXuJnbAVkeYMZvY+HHeqHfHDwQRyP0gamNfIFo1xvF0n
         KC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a/DXzL6xVd+6IK1tO7Dg59f+qNrmIZbMGU3nnk4Qy5s=;
        b=nVCUMJe11s20jPnCbDNX+96KeU9rRnXgB5E9v4/EKMNosY0oUoI+99ZPoUqi51oYIS
         bVUTimptSUgS1gMOx5JzS0CzzREzYafQY/BRREf/KP2INqWYQGGBlQhVNejEgej4wTRW
         NbD+Bs+ejDKBjmNVkD7QTea46Qj8+09DZbD1EQ22UE+P9wxn5vn6TY2t4y7GQXDPUQ3S
         5gEFlo7xbHDgMTxtzWQwO7rprBqbP2OKJ+ZBAiSwNh1E8CCmxhi0vI/OAkvaR0qVESHy
         M9wtADW/9I+lbS7Ph45oX4TWeCT8o5STUgE7mMx3JWBrCuHwo6jS+4e4CxVOgKxOQZQb
         pGlA==
X-Gm-Message-State: AOAM532P1Ejnp8JAYPyEE84R5ybErYpCEr7Hhia5v0HN4upiVp0h6B+O
        qubF//Fs+g8LaUvt2n7Y4so=
X-Google-Smtp-Source: ABdhPJz0ReSu1BTJYa/JI5KNmHVWa9TvhvOSZfTv3eNqGhyKU2T4KFZUq2xqxGUWyFYh9PHK669LWg==
X-Received: by 2002:a17:902:da8a:b029:f1:f2a1:cfe4 with SMTP id j10-20020a170902da8ab02900f1f2a1cfe4mr12712683plx.46.1622301391324;
        Sat, 29 May 2021 08:16:31 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id o5sm6944886pfp.196.2021.05.29.08.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 May 2021 08:16:30 -0700 (PDT)
Date:   Sat, 29 May 2021 08:16:28 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, gospo@broadcom.com,
        pavan.chebbi@broadcom.com, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next 3/7] bnxt_en: Add PTP clock APIs, ioctls, and
 ethtool methods.
Message-ID: <20210529151628.GA13274@hoboy.vegasvil.org>
References: <1622249601-7106-1-git-send-email-michael.chan@broadcom.com>
 <1622249601-7106-4-git-send-email-michael.chan@broadcom.com>
 <20210528183515.3c1b6320@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210528183515.3c1b6320@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 06:35:15PM -0700, Jakub Kicinski wrote:
> I think you're missing locking in all clock callbacks and timecounter
> accesses from the data path.

+1
