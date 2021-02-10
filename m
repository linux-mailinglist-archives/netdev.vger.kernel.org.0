Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71283163C7
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 11:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBJK0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 05:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhBJKYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 05:24:11 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE41C061756;
        Wed, 10 Feb 2021 02:23:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hs11so3179062ejc.1;
        Wed, 10 Feb 2021 02:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QQ6ibbCKatXHbmogp1EYUWCfgYRqjn+iKPBMKIlVQ9Y=;
        b=OkJLE9Z6va0hGpYeZtIu0b6Wy37PWF448S8/SjiY1YwifTyTSCGyrf8vP3VuzJhXd1
         BKN95vIGZ0/+gbavKal1KBQKQdB3ZaRKur+vj8sqClkSST3DEdCtAtwirYgQUdQ58+Dc
         pthI/LlvvBEWvwPtcsKOLF8FPsPT1Kr0SBfl3uQZEqjdnKGZqenIo5nneu+75/k9NCZ8
         gGQAESEpycLRXJpav6xndQBQlyVKQ1TuBqZI3SBkRN5q2teM1/dNOJXeqK4FUh7avo26
         6FKcCdariok/z2pdUMdr2L4ysXMcBTnVzieWTdRKyENiEY7tgAhbEbwibXo5bTffHb+8
         zLDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QQ6ibbCKatXHbmogp1EYUWCfgYRqjn+iKPBMKIlVQ9Y=;
        b=duOKHEFXgoBdnRdqHHJYiST76HgzwpHuPNU3wg8mxcFLGE54pByiDxBzA2PhXh2fHO
         mhIPYgWm1cC/ee30ilAMxxYFiWiyr2kl4AeYisardEQ2yvq6JFpUe1e6IM8172wiHYYe
         jDq/fawOd4gKGzLZqvC00wBH6s+OlBz4PCP/7C/hQFqB3daMtp9E5kGP9wnUAqWOeugN
         CqOHw8LyFTMakQMJZ1UeBf2euYdatT2D7B3S/ivNJ1cVNxwq23Gnu3fl6EPKinrrtKLW
         OOGT0GU5/NYfjPbCO/ivRUoegwdU+S/vWncrxE2F7DGyEZnuZGHfhMyii2y9ZsIGA0j8
         aRDQ==
X-Gm-Message-State: AOAM532UPYbr4tY3KXc2NYLDHB0PAmV9ZSfPpxu9k9HX8mdBMJz7VkAJ
        hOus+myLPBSr78oABYPB0nQ=
X-Google-Smtp-Source: ABdhPJw2FGF6YWFnpCNhD/33aoau3KgLTwQFsjmdbteKV+TtEEpI1WvYjNKHm2SDYZnTS8CgonhE3A==
X-Received: by 2002:a17:906:ecb6:: with SMTP id qh22mr2311964ejb.252.1612952610145;
        Wed, 10 Feb 2021 02:23:30 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q16sm801100ejd.39.2021.02.10.02.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 02:23:29 -0800 (PST)
Date:   Wed, 10 Feb 2021 12:23:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v3 net-next 07/11] net: prep switchdev drivers for
 concurrent SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
Message-ID: <20210210102328.7jpzlobpwotdo63z@skbuf>
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-8-olteanv@gmail.com>
 <20210210101257.GA287766@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210210101257.GA287766@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:12:57PM +0200, Ido Schimmel wrote:
> On Wed, Feb 10, 2021 at 11:14:41AM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Because the bridge will start offloading SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS
> > while not serialized by any lock such as the br->lock spinlock, existing
> > drivers that treat that attribute and cache the brport flags might no
> > longer work correctly.
> 
> Can you explain the race? This notification is sent from sysfs/netlink
> call path, both of which take rtnl.

Replying here to both you and Nikolay: there isn't any race, sorry, I
missed the fact that brport_store takes the rtnl_mutex and by extension
I thought that RTM_SETLINK runs unlocked too, without really checking.
Well, at least that's good news, the implementation can be a lot more
straightforward then...
