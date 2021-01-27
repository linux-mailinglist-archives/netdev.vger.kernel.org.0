Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B93305AE0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 13:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbhA0MIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 07:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343502AbhA0MEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 07:04:39 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1B3C06174A
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 04:03:51 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id g3so2273695ejb.6
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 04:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1iAsCyt9ugR6fCLo4HoG6lzbnQBawmadP/yf/JYt8WU=;
        b=QRNTwbP2rYVLSA1m85t+Yo05GeacMwwH4AEKQthUoB+soDOmw06dvekLbK0SgNLzyo
         d5H53NggfRVxaxmQRB0NRK0aDFHnK5MLt39pgnJI7AgQCFAEHO6hxxL70XJYkVJDEqZb
         K9LWr4IszVNouYo6urtULqmBRpC9vn6wB7gzwn1dyRBPcVc5gG+q2197va9jp54JX4Yq
         MTP0ZYSCPCYETauZHH5mpOUfO9Kz/XrurfsqAb6yOtwyEWYBvxWZwwE8CdC4cdV7szov
         Fsfz59Qx8ey/i64TTK5a3gcorpml7CZk0Rd+SZcOTEQwsZKbY2SDPwrzE8ghSDxo/MMI
         vCSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1iAsCyt9ugR6fCLo4HoG6lzbnQBawmadP/yf/JYt8WU=;
        b=JIudHEN74hoMS6/GDPLpkz4Q8qvBdWBnbPlYV/4kiNlTDe+uTgaTuXJXuI7RqTP08v
         zHdzKJ7fS5Qs8bvpv1jT7abq74fUUghG84xLpVlBO1A5ruegH89W+yLBg0O/V0R8/pyL
         mUYeVdJM3xTpgMZfqDTdyZzOtaGV3WGfYAjRDLBxKpNFu7VQWbIm41k64lWO4SCcw/BK
         vJgoYHZ1rZNOFmYVkKT6wcKOBTLfGNWjWP12WSR8TToecKAtJkef2P36UxNekIuWtdZR
         FU4cDMp1QlKSiMK+roHNmJeAY26RoyvrVlNgfaoki2dmH24GJ2AYlIsyvzEV3KJ2rHW4
         rGnw==
X-Gm-Message-State: AOAM532UvttoRY50eHBlqFmTFUfFqRCrKrjvif8+g8HTunK5dNrhhrfV
        gebeZTEVRV9+Um2oy0sdEwDuUeGThK4=
X-Google-Smtp-Source: ABdhPJxVfxjXeoBpLyNHvFi9nwm4iCloFSmJs9gVVltrrdKVfSQMn7qrpn5aYu/PZkX4hzMnvHv8QQ==
X-Received: by 2002:a17:906:b2d5:: with SMTP id cf21mr6629399ejb.387.1611749030178;
        Wed, 27 Jan 2021 04:03:50 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id pg19sm752089ejb.0.2021.01.27.04.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 04:03:49 -0800 (PST)
Date:   Wed, 27 Jan 2021 14:03:47 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/4] Automatically manage DSA master interface
 state
Message-ID: <20210127120347.ekuzelx2vik3eoa7@skbuf>
References: <20210127010028.1619443-1-olteanv@gmail.com>
 <20210127012546.bdad5fmu7vg2ki7t@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127012546.bdad5fmu7vg2ki7t@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 03:25:46AM +0200, Vladimir Oltean wrote:
> Please treat this as RFC. There's still some debugging I need to do with
> nfsroot.

Sorry, please treat this as non-RFC again. The problem I had with
nfsroot was completely unrelated.
