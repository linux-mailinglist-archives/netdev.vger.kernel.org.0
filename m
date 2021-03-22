Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380D93449FA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbhCVP6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 11:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhCVP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:58:36 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50144C061756
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:58:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 16so21678512ljc.11
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 08:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=GZRr9jbufQ2tgNzlMNa/gP7G4K2WltzYEPBk861waJk=;
        b=jVR0sTkiVcqaZRx+UXHzi8dHe+SKO0rtuDL24tK9m6dlT+xYdpD/ZI1H6FHD8aNpl1
         5Oeo0dtdsXZ32Oblvv27BGRIK4YFjMq33zF4046Ub9wid9WIxFaV+Cz2XpqFLQ5qnDos
         F/9/FzE32bWgNXcNTcOGumxN3Nun0N0NCXTlORpKUBQbTXSGDXmUnNu+QfecT6Wb/d0k
         o2tcDK/xsEAhJqm8q56HWpXVNZ96d4ODSdtEm3X9kBPS2zeUN2/QjfUyQfqoDII/rEUE
         PO8S/j18zEGKAgmfndKPccSo5DY3nyLc1VQYQsbYs/4xgkAyvaTCsT9uaoPubzeoZd4t
         sn2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GZRr9jbufQ2tgNzlMNa/gP7G4K2WltzYEPBk861waJk=;
        b=U5G1HNnTLy3d61d5BlhQZOL0YbmupOcY4eAXRWh6WYAWRqoRLb90nvIO2T7+z4mOA/
         jqeAL9SL9idsaFO9kjrZcrZbRALOtK9x0DBF1X6ORaZ4OnqiXHVjH1gl6frN28+BK+FP
         U1HtgxX0UMiYWSmT163OygKyDVCTgx7VkZXXTXVkvAthWI7Q039If4aQgrNlqgqA7BA1
         govGlbmcQP3raE3Sm5KtCfETDKvzCIJHSq5vW5NyDB2wEdLeO9EzlOqHCIzciiTMAa51
         AOZn7D5nE8/eBAPkyWu473i/mGltZ66/DDLd55j0NWOv5jgjnlHWzZi2XrT53/9VIb2H
         CdVw==
X-Gm-Message-State: AOAM532dotUcfmOz+0tIe4bCdC5Wl6r1CLFvsb+uI4SEPim/SOP/g7xS
        4ctGLeECEP0YVpmGaoHg67QBtw==
X-Google-Smtp-Source: ABdhPJzcynmtRN64W8T6iFzfVhW8EJA/FfnkdIzyMTQMViP+DIpTp5jzwa4IQF0SoXBc66IlchtItg==
X-Received: by 2002:a2e:22c6:: with SMTP id i189mr183085lji.346.1616428713695;
        Mon, 22 Mar 2021 08:58:33 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t142sm1597443lff.255.2021.03.22.08.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 08:58:33 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 net-next 15/16] net: dsa: return -EOPNOTSUPP when driver does not implement .port_lag_join
In-Reply-To: <20210318231829.3892920-16-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com> <20210318231829.3892920-16-olteanv@gmail.com>
Date:   Mon, 22 Mar 2021 16:58:32 +0100
Message-ID: <87tup3mb87.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The DSA core has a layered structure, and even though we end up
> returning 0 (success) to user space when setting a bonding/team upper
> that can't be offloaded, some parts of the framework actually need to
> know that we couldn't offload that.
>
> For example, if dsa_switch_lag_join returns 0 as it currently does,
> dsa_port_lag_join has no way to tell a successful offload from a
> software fallback, and it will call dsa_port_bridge_join afterwards.
> Then we'll think we're offloading the bridge master of the LAG, when in
> fact we're not even offloading the LAG. In turn, this will make us set
> skb->offload_fwd_mark = true, which is incorrect and the bridge doesn't
> like it.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
