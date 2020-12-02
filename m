Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665102CC8F2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbgLBVaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgLBVaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:30:22 -0500
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90680C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 13:29:41 -0800 (PST)
Received: by mail-lj1-x241.google.com with SMTP id t22so140493ljk.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=bN6/3YT7eenbqDrzGNkCBGT/+dNMwaAtSZofmBm7sME=;
        b=JKaxV8vROiFL34s4WBWl4g6tF6AkeKHmms5CkvV0fW4dqPsLNQKPGXbQy/vnCh/w4F
         XEJojV096j+TBepc6Oo60mPxS5zZqqsWHww/TrL6tmXW5lw2lMG5Dh41c521j2rapigQ
         Jq9j//As0stO8H7iSs/Ja2Lahnp4VjwM/wIy1qpMcrlNRyfyXTG6VMx9WpvGl26l6cZV
         /+WusgPX/O1FlfhcSj5o3NiOrUFdI8+03MlbtMZ92wkQCB4dFICUyUnMBLzIcza/ayMp
         P2qxA+KwBpoyMw+r6goROUtGbouJR57+gV0A/6FqkD5hnqLo/HaJMqBSTxw0Pein+N19
         9ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bN6/3YT7eenbqDrzGNkCBGT/+dNMwaAtSZofmBm7sME=;
        b=NXhGmbWcyuDtCPtWM+DZUryFyb6tE8INX8bsNoKixT9BvbfTTW+n11AHaNB9GXQqT6
         Dewl6XJitSjSo2DGdXuoinfxl7CTnbd3VzeTfMyz9/GANYzjRLnjU4E5M5VTVi7OdMUs
         5CrplXUjAxDEXdxil0bIdzyIxULvQoJvA6Na2G2K/gsnZEqVlhnkMjiNN12fj37r0ezM
         va9XdV/ghMzYF1E3IkcqVkYrWAdpryfVUzKgkQ+NklzokYWWNKQRGow3i3nkJmLYMQgh
         xAaj0HKmcZADSOtOwdEOGKzDyoK5g7iSIMwCaUI2L4LfjidzQ7MHHs50MnEVWQMvqTNG
         TbTQ==
X-Gm-Message-State: AOAM533U6cBblIIRjIqq63addIQ4/MkYEXPOAwzag0HxRICqOtvQuKZY
        8G3jYR5qa25Qm8OXZj1NPt7DWImeGp+CWONy
X-Google-Smtp-Source: ABdhPJxLevHf5O83SXY6nCJ5ht2/E8DIUeyherQi4DBj1OhT+wheAaHI/IW57clCZiJneXI40tyqXw==
X-Received: by 2002:a2e:95cd:: with SMTP id y13mr2121057ljh.305.1606944579443;
        Wed, 02 Dec 2020 13:29:39 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id v20sm882884lfd.267.2020.12.02.13.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:29:38 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201202105820.4de653a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201202105820.4de653a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Wed, 02 Dec 2020 22:29:38 +0100
Message-ID: <87k0tz7v7h.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:58, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed,  2 Dec 2020 10:13:54 +0100 Tobias Waldekranz wrote:
>> Monitor the following events and notify the driver when:
>> 
>> - A DSA port joins/leaves a LAG.
>> - A LAG, made up of DSA ports, joins/leaves a bridge.
>> - A DSA port in a LAG is enabled/disabled (enabled meaning
>>   "distributing" in 802.3ad LACP terms).
>> 
>> Each LAG interface to which a DSA port is attached is represented by a
>> `struct dsa_lag` which is globally reachable from the switch tree and
>> from each associated port.
>> 
>> When a LAG joins a bridge, the DSA subsystem will treat that as each
>> individual port joining the bridge. The driver may look at the port's
>> LAG pointer to see if it is associated with any LAG, if that is
>> required. This is analogue to how switchdev events are replicated out
>> to all lower devices when reaching e.g. a LAG.
>> 
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>
> Any idea where this is coming from?
>
> net/dsa/slave.c: note: in included file:
> net/dsa/dsa_priv.h:194:31: error: incompatible types in comparison expression (different address spaces):
> net/dsa/dsa_priv.h:194:31:    struct net_device [noderef] __rcu *
> net/dsa/dsa_priv.h:194:31:    struct net_device *

Sorry about this. I missed an rtnl_dereference in the refactor between
v2->v3. I have now integrated sparse into my workflow so at least this
should not happen again.
