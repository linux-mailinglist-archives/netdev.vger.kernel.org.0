Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612BC339DED
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 12:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhCMLjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 06:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233907AbhCMLik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 06:38:40 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A938C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:38:39 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bm21so58309809ejb.4
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 03:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4CFnklQ0KsYvW2LXc4yaIZTzhMq4EIYrmcUbidgjT2k=;
        b=ZZ2sSxylv9whFuV+0c7fgpEQSyBHQk+XNo2NvIazT08fvl+9yaWbBmuGQSdDkWz7iF
         J4L2rr4Wpz1ClWuaumjm6Cg3eblFCP4SZ4g4Tkgm0mYAdV0lQEu41voBoXdo4ac2cdOE
         HbxciEUtZNmWMyReilqR/3suusSB9ECFPz57nHYHxoCXm6qxszvU0q0SABf5AZ+QgGAN
         r7ToEKOcLgB4GI5FAc+AUVoa0Bqys1sQmW5e2QMdAMO0YyZBiOBqMkw2fr4DGRhvDYQC
         cYP7I7zzqnqMFYXX6+UXNc0iCdgui5aoFBUvMSL0qKB2GHo7CmegdXr54bn2yLb5sF+k
         mVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4CFnklQ0KsYvW2LXc4yaIZTzhMq4EIYrmcUbidgjT2k=;
        b=hk8QFlN7FSR4yQiwnTbzyC3TgMrrviBwpBcQz7dXxDr4pp68Us0Frdjp8NzV0AGsU9
         9ppxmQwRmp1haYcAQCmrkuMqpP2PVz124M6i/j4w7p0p9rPWCUMCVpnTtn7gtwO3XHIj
         jVchKAdnygJ2kFjZEgCPUE/dXm3YTFFi5Us24fCbrzp8NP0q/6c5O9oJjsYCtLrnO54f
         5dwYqnXud7DreEn3QKlOOU76qfwW3XwvbxQU2sl4hNyFxJLDm935D71wZcAC1uVKDS0b
         Fa7vpxhW+XX0b8k9UDhnJQY6f/F8JbrZ1jp0c8ebb6HtTnk1oIo3b4bwI2OaNqBkm6an
         ZNrQ==
X-Gm-Message-State: AOAM533op8hFcLq+gBez0KMIqKAnoHR29zjMqokQ0gWslkBMksq7jgA7
        5G8kBq2WqTXE4KnZ6VRVroI=
X-Google-Smtp-Source: ABdhPJyFVx3Hr4U1ZRHuPlaCyRIPYWFndMg/vlTRJSyJpxIbyxZNSWyd0C31n3q+vmx9VLo6CZ4rAw==
X-Received: by 2002:a17:906:c181:: with SMTP id g1mr13154917ejz.96.1615635517810;
        Sat, 13 Mar 2021 03:38:37 -0800 (PST)
Received: from skbuf ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id mp36sm849433ejc.48.2021.03.13.03.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 03:38:37 -0800 (PST)
Date:   Sat, 13 Mar 2021 13:38:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] net: dsa: hellcreek: Add devlink VLAN
 region
Message-ID: <20210313113836.mrbeazfkkpm77eio@skbuf>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
 <20210313093939.15179-2-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313093939.15179-2-kurt@kmk-computers.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 10:39:36AM +0100, Kurt Kanzenbach wrote:
> Allow to dump the VLAN table via devlink. This especially useful, because the
> driver internally leverages VLANs for the port separation. These are not visible
> via the bridge utility.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
