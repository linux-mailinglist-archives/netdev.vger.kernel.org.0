Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40153E9E37
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 08:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbhHLGEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 02:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbhHLGEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 02:04:44 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C00C061765;
        Wed, 11 Aug 2021 23:04:19 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c17so603836plz.2;
        Wed, 11 Aug 2021 23:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=nKkNOKnR0BjeJ53ALM7gQ03JCstACfSRC5kNtfzT4yk=;
        b=P0XbE8UYynS6GdhVuBw2y3O0dZ+pvc02m/UylndyPNK85wfDC6Gq59QMnx+hMXD4nI
         yCmncJO5qEPDBI0Y9J84bgG6LxAOOx+WTVY8OLTgn1KYIyLATAWYU2FuapnCogqrjuO/
         rBckONFW6CLiyURRvVq4zBgjBcfyOA06tcb0Lrk4f4VPPd3ZK7QMsVYUi+F+P9OJAAoX
         wXH4q72e3n7sZQqX5TPQKpGhmQWalzjvSnKs+DjrTRnKrmjLtdQtnINr85PSLhnsvKzC
         IbirWZdD7XapV5M0ZEMmq36msmXy9bwiBNuChoaDNSmxmHCj0hqb3Ch8xkfvo/tM+c+n
         ZqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=nKkNOKnR0BjeJ53ALM7gQ03JCstACfSRC5kNtfzT4yk=;
        b=fqkQvFl7TuDugobx7zb3253UAGwDKZEix/Nez96Ag9+SNNAKbmeR9nSL0p+PiVlUFj
         tXXDqac1uYAuJkWertfJZrKOhR+fGN5Tctw2bsWzNraEf+cclioFhUTPHFnUgcSsl9Iz
         UBXZXif7Mam0yWRCRySVin6vgHfHlXF1morQb03aqGP+6J1XCXeAKB3Mz/qs1kGUFygs
         GlxXX2QOobNBQQcCrx9vgSJOhegqhdDfpVLcHmKFgat7Cub/S5Ljh7uFaTsY5LUNmqjY
         UDdhXNrv1xS1L6FozeV3H194kucPRlUZjRgg9IH803F7QOjgotCQEca7vDTus/CNXmDZ
         gWlw==
X-Gm-Message-State: AOAM530bbChX12lRp/MkLzBLxP5Gjf9G2Bhf9NmqHEC0ELmRX6lD0iPq
        jZYf5rku3Xwx7STFOHbZ65I=
X-Google-Smtp-Source: ABdhPJzFYLWTNVJ+SHnUGsH+wt/Q9EbQiiyLesQa6R68Ta19VJ20+YhgGgRwnBotLuVURb0jPWYH8w==
X-Received: by 2002:a65:641a:: with SMTP id a26mr2428982pgv.340.1628748259363;
        Wed, 11 Aug 2021 23:04:19 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id p21sm1666469pfo.8.2021.08.11.23.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 23:04:18 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next] net: bridge: switchdev: allow port isolation to be offloaded
Date:   Thu, 12 Aug 2021 14:04:10 +0800
Message-Id: <20210812060410.1848228-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210811215833.yst5tzgfvih2q4y2@skbuf>
References: <20210811135247.1703496-1-dqfext@gmail.com> <YRRDcGWaWHgBkNhQ@shredder> <20210811214506.4pf5t3wgabs5blqj@skbuf> <YRRGsL60WeDGQOnv@shredder> <20210811215833.yst5tzgfvih2q4y2@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 12:58:33AM +0300, Vladimir Oltean wrote:
> On Thu, Aug 12, 2021 at 12:52:48AM +0300, Ido Schimmel wrote:
> > 
> > If the purpose is correctness, then this is not the only flag that was
> > missed. BR_HAIRPIN_MODE is also relevant for the data path, for example.
> 
> I never wanted to suggest that I'm giving a comprehensive answer, I just
> answered Qingfang's punctual question here:
> https://lore.kernel.org/netdev/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/
> 
> Tobias also pointed out the same issue about BR_MULTICAST_TO_UNICAST in
> conjunction with tx_fwd_offload (although the same is probably true even
> without it):
> https://patchwork.kernel.org/project/netdevbpf/cover/20210426170411.1789186-1-tobias@waldekranz.com/
> 
> > Anyway, the commit message needs to be reworded to reflect the true
> > purpose of the patch.
> 
> Agree, and potentially extended with all the bridge port flags which are
> broken without switchdev driver intervention.

So, what else flags should be added to BR_PORT_FLAGS_HW_OFFLOAD?
