Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3224295990
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 09:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508881AbgJVHqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 03:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2507291AbgJVHqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 03:46:50 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13387C0613CE;
        Thu, 22 Oct 2020 00:46:50 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so629842pfb.4;
        Thu, 22 Oct 2020 00:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=DjVsY0xAnNtykPjvDvdv0gDbonayFSuWFGNvaQeMQys=;
        b=lcWG0fxegSY3gQG71WBdHrJXocCZ+nMibr/5nkOHiUO6N9cb8ujW76q2uLskTqtrvQ
         BgCUYWasFQflP8nvmsXROA9/oDCvzFqgVLUnvnQcqnw8byD9vTseo9YKbuyA7Vm6yQW1
         yQzO0DpNKUw/d11vZ8mNDo03TYaBDeUgbdYeK04RqepgO30rIOmBXFMGFGJJpbnADvwg
         t7A2HFP6IniqXvgjj9l4nElEs2e+A/XpRhH2CECZMaR0o/uEzKHXcf3OWHdfX0agvYY6
         CPbY5xYdCG2QhV+HJADqoft+BfvVGdD37+StaSNJkNLFa2Jgv3QXTIbbVenFMky781d/
         42aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=DjVsY0xAnNtykPjvDvdv0gDbonayFSuWFGNvaQeMQys=;
        b=EUv9FtF5hvIeFIhYAkglzY6z/N+QXNJko1Rn4Q0SBSswwMdJ1c3yroE9GPS6TN9Xgt
         Ypd/IBLRNHfeITCtudn2QhRgXMLY8Jkwt7DzVWI3K50Mm/9s6aSTUCYRApQdsDRPHWfJ
         6tog+Id0a2I7l7RooqNOrPn3xmvEvml7WBY/Xaogaz3aClQ8PjMqRQgBYlDLKwouFTRO
         Uiex/8tZyj7E1i51ic351+SDCNI/7nqh7VpGsCz8VlcARDCRej9tPKFEYEzVbgKr+Kae
         nWl2LqpZiG29LVmgSNg2GFiaBwIF0gzKmcbiZkQgB2p+KOhro/1ffhEpQFr0Vgj/htdp
         pDXg==
X-Gm-Message-State: AOAM532runaTIBEqn0AYmbc3sfeTVbb2TY3ESbHfDLtjSX34BRonM15S
        BGs1cGHpv2pYHA0zkdaAKrfvoWDkAubl9tg7Oe8PszL6J8k=
X-Google-Smtp-Source: ABdhPJweZnF5kuJtxfCE257vphXsmrJ09m8YyALSO8OyyTYWy3KFCdJyI3U3VkTfske0F2l0D++YMg/kIvk9TseQIxQ=
X-Received: by 2002:a65:52cb:: with SMTP id z11mr1188109pgp.368.1603352809612;
 Thu, 22 Oct 2020 00:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201022072814.91560-1-xie.he.0141@gmail.com>
In-Reply-To: <20201022072814.91560-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 22 Oct 2020 00:46:38 -0700
Message-ID: <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry. I spotted some errors in this patch. Some drivers use "ndev" as
the variable name but I mistakenly used "dev".

It was very hard for me to attempt fixing. There are too many drivers
that need to be fixed. Fixing them is very time-consuming and may also
be error-prone. So I think it may be better to just remove
IFF_TX_SKB_SHARING from ether_setup. Drivers that support this feature
should add this flag by themselves. This also makes our code cleaner.
