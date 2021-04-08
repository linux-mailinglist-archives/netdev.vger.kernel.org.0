Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE0C358FD0
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 00:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbhDHW1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 18:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhDHW1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 18:27:31 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFAFC061760;
        Thu,  8 Apr 2021 15:27:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p22so1922453wmc.3;
        Thu, 08 Apr 2021 15:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cNFW9CO6o+fHZ4Oo9ONB4bDMu3YCQn5zOTz+ySKu5eY=;
        b=b9M+TJcA2rVCDGWaTsLy5WijRxnxfbunWMsjoNNSqS54ah7c0P1il83pCy4t63Febk
         UE1MxLZsDinslK8JbcehSjHejtu10wlvMrJhUcotgAsVEBn4Q0zhAXxAcZs7+eJkktM3
         maQsdU34G7z9ytQ0rg/d/w1RrX3kjNy+D3G8UoSEe9Eo5qhJrKzuksajFVxtHl/KQbaO
         aDnGb2/kuMC4dNjwrzU1JSgK2xO7WtVIiYgExQUls5MvOFWiw2mo8ThNLy9vgLsWKQcH
         MmMQ4PpAjkEL+v8vQd+EMwarJf8r5DFrR2Hhv71ksOfhmy7GNMxWTAAQEYMUym8EmaLA
         Mazg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNFW9CO6o+fHZ4Oo9ONB4bDMu3YCQn5zOTz+ySKu5eY=;
        b=DHHwjzUax/fQbGmAYQwaaGXT0ZEVOvfV6C37UMXhKqXbcVHyCNMtR1Feq1JLmQ+qQ5
         jMjnU7GCCRwUVsUd/+ABdJ87AHtFTXRlJWbU+tFKwKHCWTHTC+yS1y7682H4ovxX9web
         tGVHNRE6EuwMVFKVLOvwbgt4bv2I49zU3nKvKAjw15v6SGYfziG/kB6hBur7o9iDt2SZ
         ++1atEiNeIa/19nOi/n9ImtCMVd1CBoX2cnKe5h4UBsJuF9qdsLh31YFhtcC7uJ0MYlT
         aBu5wc41ARTTXujNikiGiO9kzowfKLmIJLH7ZtmxiBu4uzLy2bc4uy/V8f/oUWz/zLnP
         32cA==
X-Gm-Message-State: AOAM530fosvFH+A0CtIcv4cc3Fbrrqt2pjOvpbfVl0VVre3tYPK2ESlz
        GJ8oDXqVAMoGSCh0B9Gs1AzXDN3nLMxqs0ohTV+x5FDLEW4=
X-Google-Smtp-Source: ABdhPJyCn7Z9g2Pl3Q9whOfG9yCQ4y3iHY77zihSd6G/5OpLN+edc3ODpe6FtJHxJdWSHL8kN+ybBHm2dmPd3huJDUg=
X-Received: by 2002:a1c:4045:: with SMTP id n66mr1676462wma.94.1617920838445;
 Thu, 08 Apr 2021 15:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com> <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
 <CAGngYiVg+XXScqTyUQP-H=dvLq84y31uATy4DDzzBvF1OWxm5g@mail.gmail.com>
 <CAFSKS=P3Skh4ddB0K_wUxVtQ5K9RtGgSYo1U070TP9TYrBerDQ@mail.gmail.com>
 <820ed30b-90f4-2cba-7197-6c6136d2e04e@gmail.com> <CAGngYiU=v16Z3NHC0FyxcZqEJejKz5wn2hjLubQZKJKHg_qYhw@mail.gmail.com>
 <CAGngYiXH8WsK347ekOZau+oLtKa4RFF8RCc5dAoSsKFvZAFbTw@mail.gmail.com> <da81fa46-fbbd-7694-6212-d7eb2c03ac94@gmail.com>
In-Reply-To: <da81fa46-fbbd-7694-6212-d7eb2c03ac94@gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 8 Apr 2021 18:27:07 -0400
Message-ID: <CAGngYiVuvm4Z9zFUQTWVyZgAHVC0uap1+-XE_vLoXAmrpXKEyw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On Thu, Apr 8, 2021 at 3:06 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> A completely unrelated question:
> How about VLAN packets with a 802.1Q tag? Should VLAN_ETH_HLEN be used?

That's a good question. My use-case does not involve 802.1Q though, so
I'm unable to test.

Thank you so much for your suggestion earlier, I'll put a proper
attribution to you in the new patch's commit message.
