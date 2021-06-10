Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6E3A3779
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhFJXAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJXAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:00:44 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3065C061574;
        Thu, 10 Jun 2021 15:58:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id cb9so35019314edb.1;
        Thu, 10 Jun 2021 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a0WxUB1rSvbS4Ruvft/3V1doKSwifPTvGACvaoKiR0A=;
        b=p8PTqhCXGui8EF/KLNjMPyuwgYDHpjhMS9mWx6O0KARUl4Y3d+lEGI+vU+hCRVTeVv
         g3KQlMt6K4ktn5G0TKpnLfvGTeQWjYUObSj+2ImvdhNiBwdWIJ0zfNyiPj3APjBna/yH
         Sh/XCHvkh9Zkg+SXoJ9IIZV/8qKQV4+3EyJctQn9N0t1G0EQ6oVYIZVktPCLZB1ugjk2
         0ekQK82GEcM7/w3W+r9lgswc/JONJHDQFz3ui6awh5nGF1QHxFtMB/M/5mJenwF5qXrv
         foPJI6GbSWzJNy98UqdPQ6eZ5+uSQS6kgC7ocumFeSpOFCo/3f37dzCG48gkju2PI5ox
         05vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0WxUB1rSvbS4Ruvft/3V1doKSwifPTvGACvaoKiR0A=;
        b=CnfU+5Jw5HkiaG3BoHTdU5xhGmyZq2/YSNT5iEhnrfY/Hb7LdlsdmfITTVC0KixRrs
         xFuS9Bj4lKJdqcAG6C3h2KBviNYURazJltVF3/dbPKVnlRshZ5ttV8Ote9x1b/a1QWQl
         OVWpzVjI02sHYuLEhVbe/vOwvgoeCXGPKZQ6GGu1f3Pobu646tNNmdGZPNNTNbIgj+qS
         KH8LC+2frw1P+/Q8CqqiC4rcPd4vD9Es7CYAixvXYL52qaVJcff3toxouXckbp2dOBCR
         4oZlw88ku3nqspZq9PSDpBOmr3p5yW2njQ5yFdLScxAHXCyAOXsnyS7iZWaGYBXLB/by
         N5bQ==
X-Gm-Message-State: AOAM533BIp0XGFOkD8xj2IzVVSMYbf7SsW79RIApYRezN0Y51vBlZaLB
        SbHusSpJRBX/nxtvnBbdsThM9JrJQA0=
X-Google-Smtp-Source: ABdhPJwGInWsk+q0DnWcBtVL0z43cuIyc7LEOl7K8V5HPDnvlMG5rvSEgZ/xK4qv6bJ5ZQF61S2xqg==
X-Received: by 2002:aa7:d798:: with SMTP id s24mr743711edq.243.1623365908509;
        Thu, 10 Jun 2021 15:58:28 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id lu21sm1488620ejb.31.2021.06.10.15.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 15:58:28 -0700 (PDT)
Date:   Fri, 11 Jun 2021 01:58:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>
Subject: Re: [PATCH v2 3/3] net: marvell: prestera: add LAG support
Message-ID: <20210610225826.uzrufkacbo3vsps4@skbuf>
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
 <20210610154311.23818-4-vadym.kochan@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610154311.23818-4-vadym.kochan@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 06:43:11PM +0300, Vadym Kochan wrote:
> From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> 
> The following features are supported:
> 
>     - LAG basic operations
>         - create/delete LAG
>         - add/remove a member to LAG
>         - enable/disable member in LAG
>     - LAG Bridge support
>     - LAG VLAN support
>     - LAG FDB support
> 
> Limitations:
> 
>     - Only HASH lag tx type is supported
>     - The Hash parameters are not configurable. They are applied
>       during the LAG creation stage.
>     - Enslaving a port to the LAG device that already has an
>       upper device is not supported.
> 
> Co-developed-by: Andrii Savka <andrii.savka@plvision.eu>
> Signed-off-by: Andrii Savka <andrii.savka@plvision.eu>
> Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> Co-developed-by: Vadym Kochan <vkochan@marvell.com>
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
