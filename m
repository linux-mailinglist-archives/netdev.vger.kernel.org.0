Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C073F7F33
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 02:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhHZACL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 20:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhHZACK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 20:02:10 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E559CC061757;
        Wed, 25 Aug 2021 17:01:23 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c8-20020a7bc008000000b002e6e462e95fso5546632wmb.2;
        Wed, 25 Aug 2021 17:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gn0+R/7R58c152OdsQfm46+uKGwqkw5R5Zqn3EfO2Pk=;
        b=UWblJmUdrjsPOcnJvcY+zYG8DLWSlVT0cYwkUUWPlQFikm27sqluzhjHlp2KaWzLs7
         SEz0hhFR0DlqHLE7FAq/Iuor8O2E/COWxkLLDEeeMmz4F2jCV4o7Wb+fmCyW+2lJQdnr
         w1KetvDe5p8Tk9j/6eIUI1Xwj7jmhObjKdOjegBhZ3zF8lr1ebKF5p0QmN4yII8UgR9Y
         muxq9I++Iss50UCIP0ORghJdAnac5asNaw0qzTFl39OMZ/ol5/WEryFENRKyDkqzpnHM
         pMaAD1gYgkexorDkVC60yK+uxqzoe30tEAyiZ+YDOOVub7RijQN1NdOmVSqlhpXs1nv0
         YqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gn0+R/7R58c152OdsQfm46+uKGwqkw5R5Zqn3EfO2Pk=;
        b=ZELHYumiK0vaRsxx2lpr6GQ+AeUredTe8NyyL0XX9wRnU/41y3rRIUt63atP6Du46F
         Wwxa8rUlnhO9ivjRIlYul604lQq8J+kafABIjHiOaYqsXSUoEYEBezO9FoXmp0gbOjzR
         99uSdKGhvtgkbPLrUR2Ux0ZVkuAznM70FQx+d8bApU8EoKfCK8J2YYFMZWehvSOqd+gQ
         FxZ5Lc7L+KvdrP4Obt/6TTs5ZY09IpvmppJSeFlzd75LA0hSH8G4w8uNxiDVXngzqXYx
         gKsmCYQyi9nrI815ezbVS4H4w80yaxPfGLmUgABlhFO7eqlKTTvoIuucttCzw2/6rRpF
         A+DQ==
X-Gm-Message-State: AOAM530vE+zGg39DIprAqf1QS6PKmGtAml/lZYC8rgB8Wrzu+lbWiQmd
        /tfNaHS1Jba0Lpeir9LM3Mc=
X-Google-Smtp-Source: ABdhPJxKyb1ON6kX34ngYPEawdE1OTzU9XvKOLg25OBlQqg6Jboa9MJpjBPYcKMAoD38YcmPeLwj4w==
X-Received: by 2002:a05:600c:3798:: with SMTP id o24mr11403587wmr.18.1629936082544;
        Wed, 25 Aug 2021 17:01:22 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id x21sm11092wmi.15.2021.08.25.17.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 17:01:22 -0700 (PDT)
Date:   Thu, 26 Aug 2021 03:01:20 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC net-next 1/2] net: dsa: allow taggers to customise netdev
 features
Message-ID: <20210826000120.isvbsdjwpvyszglb@skbuf>
References: <20210825083832.2425886-1-dqfext@gmail.com>
 <20210825083832.2425886-2-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825083832.2425886-2-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 04:38:30PM +0800, DENG Qingfang wrote:
> Allow taggers to add netdev features, such as VLAN offload, to slave
> devices, which will make it possible for taggers to handle VLAN tags
> themselves.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
