Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242243916BD
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhEZL4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232990AbhEZL4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:56:11 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B8AC06129D
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 04:52:11 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ss26so1725699ejb.5
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 04:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DNQTSTfoXdQ+c8GSKVTyBukWrtZQQdvpVTOPh2VhLCU=;
        b=aJhLz7nVSueJgwESwVqST+1FM8M6xUnQhQf/qXFWQMMwmZybk7v5mWOpdk5R09SD4n
         DxugiQzkzX1LEteueqx8+h3ORJD5aeywvAFsffBok1heGverKPg7s+ee2L7zEyEbWMNm
         VRak5m3Vfw43VU1N1rD/JFiy8IbP6MpwEljNP7+QhCO/vA7UcFxb+MUHIGUWZQMh1P1J
         LVusKfqYiFtxk5XuBNpDZOUcSEOwHAH/Srg/jzGFtE5vuKvcwZgn1XWOu5m3aa0bJyeN
         maIKg4YnVTdDUxlLAQ1FC4ogtKAg6HNri3A+Ujes6/p65OqURE1rdCIxT3B7Y+8QQAnF
         0qXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DNQTSTfoXdQ+c8GSKVTyBukWrtZQQdvpVTOPh2VhLCU=;
        b=OFio6d5KarzTr5gRtZoRmInnIjQdOpY3Az9Y3aZuVHDPNrGXyZ0PBhjH9mW6yq4u9N
         FvGc5rvnyAjbDh50FiKJtR5oXGyxlR3sbRZtY+OVFOxKOyS+6KK5SQF1TXH5n4kpvHue
         do6fwvPt7z6XZCJTFg5jI+V99sQQ3EFn5zLJWOKopbzzFHb+m6KqMzTi3bgg364A3OTS
         m+xKC8knt+9IIkKjW8sA8oNJpvwaTSKIYeQW/WbtaLmsjer4c8gV+lweKBkLfdH1Fn1a
         T0JHy2KxxC15U7g3419dPvjwbRR/C+5GzvH7zEovCpEDwc0S4RZ7wyRQ6mB3zGxRHbIp
         NI4g==
X-Gm-Message-State: AOAM533abl4Cxf+DxVpODtKl9CI1NIKxBAehj9QogFa8h+MITlQN+6W9
        m26D8mfwcmO5wJrKfGzaMsY=
X-Google-Smtp-Source: ABdhPJxkDhouro68b/Vb6rc5wl9Tul3SH87OxNphCttgxRJiipSg8iLmXxCSQ40HExLiBy8VFCb9EQ==
X-Received: by 2002:a17:906:b10e:: with SMTP id u14mr32588561ejy.546.1622029929642;
        Wed, 26 May 2021 04:52:09 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id a22sm11667507edu.39.2021.05.26.04.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 04:52:09 -0700 (PDT)
Date:   Wed, 26 May 2021 14:52:08 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Message-ID: <20210526115208.t7ddva7weoo7hjls@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com>
 <YKxecB8aDJ4m5x7R@lunn.ch>
 <20210525115429.6bj4pvmudur3ixyy@skbuf>
 <YKz4xA3QNIoEv5pp@lunn.ch>
 <20210525132117.gvjr4zcmpnhcwxyc@skbuf>
 <YKz+8QcRS3Px7tZR@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKz+8QcRS3Px7tZR@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 03:43:13PM +0200, Andrew Lunn wrote:
> > Just to be clear, what is your suggestion for this? I am not a great fan
> > of 2 internal MDIO buses, but as mentioned, the PHY access procedure is
> > different for the 100base-TX and the 100base-T1 PHYs.
> 
> Do what the mv88e6xxx driver does. Have two busses, but do not put
> them into a container node. You then avoid issues with the yaml
> validater and not need the reg values etc.

It's funny, because marvell,mv88e6xxx-mdio-external is not covered by
any yaml schema, and even if it was, the "mdio1" node name would not
match the pattern "^mdio(@.*)?" required by mdio.yaml (which reads
'must be "mdio" or "mdio@some number", and "mdio1" is neither of those).
