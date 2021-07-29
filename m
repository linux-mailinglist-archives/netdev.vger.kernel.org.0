Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177BD3DA792
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbhG2P2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhG2P2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:28:13 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A56C061765;
        Thu, 29 Jul 2021 08:28:09 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id x11so10432043ejj.8;
        Thu, 29 Jul 2021 08:28:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KE22c1Ad5gonkCTcGvngPYElxeArkuqbrIzxFeSwHAY=;
        b=JetzgI9snLh9gHSQtjDoTivcJXzq1kKOvclnaK+MCZ6DvY89LFB0CWrkt7ZCuJ+Imw
         oB54aTWQ4dVe347xR6K8GxDEpafJTNsyhUyElIoXoAVIHZmy/MB3De8fBIPBFxRRQC6r
         NjuFkuN6LYbH50BwQAGT1LtYaZjgK39dqXb7tjlTIArnQTYmMbTUE8afU326KCPopZmr
         ZCtIAz/vmWa/RcKY1RwK6W2OYB99AVSvRkaHzawiCEB5tv9nnvW5gFArxAJbUSm8tA/O
         H/meAr4DXD2Zft0pG8yFMhj9m9qPf6zM4Z09PxCqpHo/eNy3acpI08loYwi30vcTNRKe
         qIZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KE22c1Ad5gonkCTcGvngPYElxeArkuqbrIzxFeSwHAY=;
        b=Y9jjY+5+BTDg3R9jTMfyzu/PuHWNIDvnyhkQpJR8GKNeGVz71Y2o2mMFuhNyRr7Fy7
         /VgQC0iMZZvubiYVhqCy/Pf/NFqdyw9mBGPo6RfdBSy/pHS6mBq5FABe5G9xHn6ihZVJ
         Wa6pqUqX414PAGBpvWAKAmacAGn2XEhmAy7bE8SZD5a3tyzLrEem+iiBrTXQkJfdF59d
         WDWY7Zy8+gltVKIq9dDVntgi6I5Xkd03N/wn527gMS8e7w1Ar8UEUYNhNEVS57IE+D3/
         jEzOY7L1SBEa1ReeWQd+DSM1yu43fx1h+Acjj98jRaqW9MhT8R4YlIi5TXwcoJi612sS
         y9Dg==
X-Gm-Message-State: AOAM530cU0g9hzFATlUUpgb6IIfEmEytn0aFTsbaSKIPnWbH+k6NUeom
        u14ayJEhfA3b0MaEPHi7q9w=
X-Google-Smtp-Source: ABdhPJws25x+5xhXV2Dr2zU8FJu9Q1J/fMCHNUU0hFEyvnt6R1J0U3UzIcVhhlrThKtW/vR6GCg4Vg==
X-Received: by 2002:a17:907:629c:: with SMTP id nd28mr5019983ejc.403.1627572487725;
        Thu, 29 Jul 2021 08:28:07 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id ck25sm1340106edb.96.2021.07.29.08.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:28:07 -0700 (PDT)
Date:   Thu, 29 Jul 2021 18:28:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from
 standalone ports to the CPU
Message-ID: <20210729152805.o2pur7pp2kpxvvnq@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-3-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210728175327.1150120-3-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 01:53:26AM +0800, DENG Qingfang wrote:
> MT7530's FDB has 8 filter IDs, but they are only available for shared
> VLAN learning, and all VLAN-unaware ports use 0 as the default filter
> ID.

Actually, on second thought...
If MT7530 supports 8 FIDs and it has 7 ports, then you can assign one
FID to each standalone port or VLAN-unaware bridge it is a member of.
The drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c driver has a
similar concept, only instead of FID, it manages FDB IDs - each port is
assigned to an FDB ID and it learns and looks up MAC addresses only
within that FDB ID. Every standalone port uses its own fdb_id, and every
port under the same bridge shares the same fdb_id (the fdb_id associated
with a bridge is equal with the fdb_id of the first standalone port that
joins that bridge; every other standalone port that joins a bridge will
change its fdb_id to that of the bridge). When a port leaves a bridge
and becomes standalone again, its fdb_id will again change to the first
unused value. My point is that if you search for "fdb_id" in that driver
you will maybe find some inspiration for how things like this can be
managed. I know it's not 100% the same as your situation (the FDBs in
the dpaa2-switch are selected by the VLAN table, and for that reason,
the dpaa2-switch can only operate as VLAN-aware, and with shared VLAN
learning per FDB), but the same concept can be reused, I think. With
each port and VLAN-unaware bridge having its own FID, I think you will
not have the shortcircuit issue any longer (and with VLAN-aware bridges
you shouldn't have it anyway).
