Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71867360FD9
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhDOQIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233772AbhDOQID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 12:08:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833EEC061574;
        Thu, 15 Apr 2021 09:07:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id z22so7207608plo.3;
        Thu, 15 Apr 2021 09:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PVJw4038PgUmxGcieIbiJS2zotfnoqq1wvHFzGjgM0w=;
        b=jnOs+huCcoazzZ4svfGsQIw3+lWgfkINtTakGNirUOEAiTjPf2QqVTD15FYv6vXKES
         7EbUxQp1hyK8SY3Yvqm713MyjUs0TouxcWx/gYiRIalLqioSh/TyraIVgJAI5CtBWfvU
         AnB+Q1R1yRhEWc3hSwcS7bMoeyeeB/ECfF2A/rhjN0nl363M5dMuBCwHKz/uDjKkYSfu
         GDvpajNJedQAtob9avxJnowAa2pZ3K9iJZYwMNuzDOu1o3Ex6E0NCh3QhAhqHS0OgRcM
         FTFR3MOBhF17H/1T2nQ/GFX9tyRLhlp05IuNmPjKFJ6bjRSzfTqmafwwKd966t3pzxJF
         ar5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PVJw4038PgUmxGcieIbiJS2zotfnoqq1wvHFzGjgM0w=;
        b=JH5GewQZYbjNoorv7jBCcP8q6Lk122zMu734eq+shE78A8GImU1mN6d7sbg8iB2Z/N
         XYCkDizCYEgHoXJIEFeTEs6McEozFIrRWfXpLCR23FBzw4FGNx8BzqmcKnv9h99MQWku
         YbbIOdJb+Vk3nfR2hu+t7Ug3/GhZDxVisbTUM9ReJZbz1jcNzn+8YR5kKJjPA5XzoB/c
         HVEKkPWJcyGKcVn6zkyuoNxwu/bS3yxPAweuNSmgQh9vtYhSMPHbGK3L+YmGPJ6j0w43
         9xfIdlIDwYoEtjzyp0L5HXfK7+aFR2wA1Htoj1k/xir1Ci6ZfyNGNrUGq2dfaO06Z1H+
         ATkw==
X-Gm-Message-State: AOAM532+9YYGvLWEPAHvsnDAeIudQjy3DCZ7l2DPawNhLgGhSe5lT29M
        ref7zpNZcWznsVZTx5r8hhc=
X-Google-Smtp-Source: ABdhPJxgIQCRPI6NGcThHQo+DmiL4gFtzKT48engDAqiP/S4Yeb6lLDowbSM5cSu+3OxuXrJ5mBj6g==
X-Received: by 2002:a17:902:8c92:b029:e8:fa73:ad22 with SMTP id t18-20020a1709028c92b02900e8fa73ad22mr4464291plo.66.1618502860137;
        Thu, 15 Apr 2021 09:07:40 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id k13sm2918012pji.14.2021.04.15.09.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 09:07:39 -0700 (PDT)
Date:   Thu, 15 Apr 2021 19:07:29 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: Only notify CPU ports of
 changes to the tag protocol
Message-ID: <20210415160729.ilaalnejzvcxfifz@skbuf>
References: <20210415092610.953134-1-tobias@waldekranz.com>
 <20210415092610.953134-4-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415092610.953134-4-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:26:08AM +0200, Tobias Waldekranz wrote:
> Previously DSA ports were also included, on the assumption that the
> protocol used by the CPU port had to the matched throughout the entire
> tree.
> 
> As there is not yet any consumer in need of this, drop the call.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
