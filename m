Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1C22F9564
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 22:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730114AbhAQVJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 16:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729248AbhAQVJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 16:09:42 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65F1C061573;
        Sun, 17 Jan 2021 13:09:00 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id w1so20899876ejf.11;
        Sun, 17 Jan 2021 13:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=42BoXCicoex6TQQF6Ij53CzsLLz+oD2qad6RLNHaXRc=;
        b=jV1rnTkggvSuTP4wPeAGTs2dYEvyRBI95SlW2HSPELN46fd8FbvyZznpYG/Xbjoez2
         F0ZptvtCXuHYSsW3dh/FNwlxqBTNxvNXCFSnls8CQcl1I+3mNyr4jg8GA2JYpv/Lbew3
         DnzVElkU4VxbVZovbox0XDzKEUx2MV/39PNH9RFAjrFcW8CvTn4/Ymi9x9f8hPn3QjYN
         Ze7QUvkoGCVXhMYRGl/Yj3rVCHvo8xL8wLZYfStwzhHnM5mSjZzoYob7EKB3HXyLGdVf
         UC2Th9ZPOZN3A2FkFV7rOK9BYsvyaGYCUuO9fKpAQnWYZ4brA+IaqDycbm/K0XYkkIxZ
         gBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=42BoXCicoex6TQQF6Ij53CzsLLz+oD2qad6RLNHaXRc=;
        b=kVYZ4tfFIzC7Nube2+dCK4+so/8AfvDepdCDC/DiPh7EfLvRaacTfgtOcr2yJoJvSs
         0OvcAvIO1EKv7f2ECbhwh7y8FXre0jhK81nHCYki37Zb+37ExLY3/PEnzcMHcMTPftmo
         wgOMy0xWwWiGARgd2jdVUV/1ArXOCmYf1/amKnYzjAnhjlv8dTjnGLLL8a6DExz1HCqv
         7GdttlGnYDcS13+eCudkEoyu9aOqmyrJ+N76gsjw2GZiNwV2rHGk5uC4ru72oPNy6prY
         4TmDB7qj5XkedrtZLZvW+kifrxF7AlzklGdwvuCMK1ZHEwjrzygYhehaAQEVPIRpuL09
         1uUQ==
X-Gm-Message-State: AOAM530pkboxSjvZLZRbHBFti8yuD3H/BrRXjB19m71Ycz68gzfZD+bb
        TaITdc/wgQm2/myLBVYuzv4=
X-Google-Smtp-Source: ABdhPJxaF+v+fqDX/V50ECIncMO+Fb7aGgPiCTs3QtpJQiSVuE3csyE5D4/t5kgzf8wXYrYFBPnqNw==
X-Received: by 2002:a17:906:1288:: with SMTP id k8mr15019921ejb.206.1610917739614;
        Sun, 17 Jan 2021 13:08:59 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u2sm6554766edp.12.2021.01.17.13.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 13:08:59 -0800 (PST)
Date:   Sun, 17 Jan 2021 23:08:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH 0/2] net: dsa: mv88e6xxx: fix vlan filtering for 6250
Message-ID: <20210117210858.276rk6svvqbfbfol@skbuf>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On Sat, Jan 16, 2021 at 03:39:34AM +0100, Rasmus Villemoes wrote:
> I finally managed to figure out why enabling VLAN filtering on the
> 6250 broke all (ingressing) traffic,
> cf. https://lore.kernel.org/netdev/6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk/
> .
> 
> The first patch is the minimal fix and for net, while the second one
> is a little cleanup for net-next.
> 
> Rasmus Villemoes (2):
>   net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
>   net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250

It's strange to put a patch for net and one for net-next in the same
series. Nobody will keep a note for you to apply the second patch after
net has been merged back into net-next. So if you want to keep the
two-patch approach, you'd have to send just the "net" patch now, and the
"net-next" patch later.
But is there any reason why you don't just apply the second patch to
"net"?
