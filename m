Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7822F571C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbhANB67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbhAMXj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 18:39:57 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC85C0617A3;
        Wed, 13 Jan 2021 15:26:38 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id q22so5563874eja.2;
        Wed, 13 Jan 2021 15:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cqg0wNGRTTkRJwGtfx/C5BvxZwI3bxOus+69CkzX8pw=;
        b=o2QRiIAkVgwzuSeSCIuaYpLbiKd66o6IlbF5tzRMkJHIaVX9zMlzGr5u7q5/oazqkX
         rjST24rT5ff+Zvegxuk22uuI5B4ErY32Z5zK++NKg4YqpQoRyhVFm2F+yl1sn7IK2EiD
         ruu2oPI+lQeFiMUK4K9U/TBZgrcvSH8CT7ciWoGYmT14oodB7X+KZarmBUicask5aWkb
         6nr7mSj6KGDcawgKLLESOaZO3YbXYh3WsfNJd1D4qHCzzIX7AXnPYz4jaZSQE1GVYfVm
         QpCloFhqcefJ136zyHeVZlXSW8ScagBZJzsITTXUHjwO4g/fW/yqAVowRnQihtW2ORWM
         DaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cqg0wNGRTTkRJwGtfx/C5BvxZwI3bxOus+69CkzX8pw=;
        b=c9ZOiCW6FOvoBggvtSAcDELCYfP/UNgjQW/KoTkq5tX4mcw+9n3pBlXOCwnduGnh4s
         Px5mo8s9ffJCmESzzNLTlVdmS7S3OI5SSCSPGqklagOo27bX2C/2tNkR+LjQrBmvZZSG
         0Ff89tteH89++BQ+NNYo5scOBaKOoieI4sHqCZ6czJzAP7+gfYvuNhFzb/HvTAmeY2ow
         57Qa+Q6Xqx/ca7HYMUWDCqGtP+MDAnvnw6g67zCW83kMsmr/nLM28QWt7oIr/jxa6nPZ
         4Qb9XHFH+D15kpzu/nIIHx22VAvJ67Ll8/hkXgZ1KCAcGmdu4MTU1GbJ+HdbC0Sj0M8T
         x0Bw==
X-Gm-Message-State: AOAM531CAkOVeBv/JpQtYjaGaSiUckNEdv0xnQDGiqGA1Usd0B/Zyqwa
        li/yXopvta3dncXrL+ixpIA=
X-Google-Smtp-Source: ABdhPJzehR9zw8MncRaIdYBxxdbLrzNqmElPtZGGpIejvwz+M2v13W/c9CLYiJ+XDd4C0DWWPxcCig==
X-Received: by 2002:a17:906:7689:: with SMTP id o9mr3327438ejm.324.1610580397107;
        Wed, 13 Jan 2021 15:26:37 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id r21sm1470219eds.91.2021.01.13.15.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 15:26:36 -0800 (PST)
Date:   Thu, 14 Jan 2021 01:26:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/6] net: dsa: ksz: fix FID management
Message-ID: <20210113232635.gcqohiuhwpeb2oqc@skbuf>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com>
 <c5c35fb4a3e4784a5e26a7b7181a0a2925674712.1610540603.git.gilles.doffe@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5c35fb4a3e4784a5e26a7b7181a0a2925674712.1610540603.git.gilles.doffe@savoirfairelinux.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 01:45:17PM +0100, Gilles DOFFE wrote:
> The FID (Filter ID) is a 7 bits field used to link the VLAN table
> to the static and dynamic mac address tables.
> Until now the KSZ8795 driver could only add one VLAN as the FID was
> always set to 1.

What do you mean the ksz8769 driver could only add one VLAN? That is
obviously a false statement.

All VLANs use the same FID of 1 means that the switch is currently
configured for shared address learning. Whereas each VLAN having a
separate FID would mean that it is configured for individual address
learning.

> This commit allows setting a FID for each new active VLAN.
> The FID list is stored in a static table dynamically allocated from
> ks8795_fid structure.
> Each newly activated VLAN is associated to the next available FID.
> Only the VLAN 0 is not added to the list as it is a special VLAN.
> As it has a special meaning, see IEEE 802.1q.
> When a VLAN is no more used, the associated FID table entry is reset
> to 0.

Why is this patch targeting the "net" tree? What is the problem that it
resolves?
