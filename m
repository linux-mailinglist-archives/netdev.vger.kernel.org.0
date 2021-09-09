Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AC2404849
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 12:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbhIIKQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 06:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbhIIKQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 06:16:04 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871E5C06175F;
        Thu,  9 Sep 2021 03:14:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id n27so2513299eja.5;
        Thu, 09 Sep 2021 03:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ufx5aLQHEqxHso6qEYibiVseetvvPctAZYkyxXCLvhQ=;
        b=ZYDWtwPAc2btsuzQvd5JTyajb4TE1k/rihy2b+cXjrqhsYP1QMpPXrtIVIbNKnV24S
         99I6wAfbKjZKgCKvb8kX/KQBJMc+fdyhMIIVl/A2m7iz7BXxGpshCpj1iQjRwScXUcU7
         8fRkFfz3FviniUtUQskIZzqIfn8gw4lu+bQ4jmbpiutKQX8YBu65pyWZ9/0TVRNjbvs0
         u1VKkBImqCdozhYRq5yEWTtatafXkjHoLL2GyTuBbH+0eVDuR3yXuFTaZZ8Qym2q/Hdt
         YmfA4NNTiqqpdzKgVenl6GDbHRc3UKMwaaFWONMl3lxVR7Ahz8QNyhv+SgXRolHli7iY
         2maQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ufx5aLQHEqxHso6qEYibiVseetvvPctAZYkyxXCLvhQ=;
        b=N8pGVzWw6pkMTnjyOIk39lSNxy8I6cBSHgTv3INtk3yhQFePfFpPaF6gmJ1bFDCXOz
         fm2Y+KwZ1Cn1AZAMAuZ9aW/2/RVTS4lrxb5TH8xMUsneJsYRwCOzsRvA5OcsZ6zdJXGO
         cCXdT+psEq6xBqQUIov1k/HpKCdlNqRswBNhlMDluwT83Oqosu31EezubqY5C9LFWwP8
         yknJbY5bMfjhly28wngD+qprXqa59y8SRpMTjJySK791fFmqg8lkpwJVJmDW/g3nD7l9
         /kxL5FG3jYQxVMfvK92PqH0GrhpNDcdESJUB2eTmtruY5KdHZ7XAjEPYMlp/sRGYN2ku
         H3Xw==
X-Gm-Message-State: AOAM532j+dkgSiyIBlR0jY/GaCpLbaXxH8536U+szOC85AzQiHns6Vk/
        ql8cdRalc9Hu4dNLBrvSNTo=
X-Google-Smtp-Source: ABdhPJzxwejgpFNfsrCjgyYmRLMeRrUV8+fyCS6p0G1uZkMZtJLPYU9TJ+d31Q82unEJHWJHkXdlsA==
X-Received: by 2002:a17:906:c249:: with SMTP id bl9mr2543083ejb.225.1631182493135;
        Thu, 09 Sep 2021 03:14:53 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id bj10sm689334ejb.17.2021.09.09.03.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 03:14:52 -0700 (PDT)
Date:   Thu, 9 Sep 2021 13:14:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210909101451.jhfk45gitpxzblap@skbuf>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 11:53:21AM +0200, Lino Sanfilippo wrote:
> This patch series fixes a system hang I got each time i tried to shutdown
> or reboot a system that uses a KSZ9897 as a DSA switch with a broadcom
> GENET network device as the DSA master device. At the time the system hangs
> the message "unregister_netdevice: waiting for eth0 to become free. Usage
> count = 2." is dumped periodically to the console.
> 
> After some investigation I found the reason to be unreleased references to
> the master device which are still held by the slave devices at the time the
> system is shut down (I have two slave devices in use).
> 
> While these references are supposed to be released in ksz_switch_remove()
> this function never gets the chance to be called due to the system hang at
> the master device deregistration which happens before ksz_switch_remove()
> is called.
> 
> The fix is to make sure that the master device references are already
> released when the device is unregistered. For this reason PATCH1 provides
> a new function dsa_tree_shutdown() that can be called by DSA drivers to
> untear the DSA switch at shutdown. PATCH2 uses this function in a new
> helper function for KSZ switches to properly shutdown the KSZ switch.
> PATCH 3 uses the new helper function in the KSZ9477 shutdown handler.
> 
> Theses patches have been tested on a Raspberry PI 5.10 kernel with a
> KSZ9897. The patches have been adjusted to apply against net-next and are
> compile tested with next-next.

Can you try this patch

commit 07b90056cb15ff9877dca0d8f1b6583d1051f724
Author: Vladimir Oltean <vladimir.oltean@nxp.com>
Date:   Tue Jan 12 01:09:43 2021 +0200

    net: dsa: unbind all switches from tree when DSA master unbinds

    Currently the following happens when a DSA master driver unbinds while
    there are DSA switches attached to it:
