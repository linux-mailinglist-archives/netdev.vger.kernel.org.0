Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4767480EAE
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 02:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbhL2Bpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 20:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhL2Bpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 20:45:46 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3180CC061574;
        Tue, 28 Dec 2021 17:45:46 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so13649235wmj.5;
        Tue, 28 Dec 2021 17:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kMVKjCl04dw0PGuDwWt7IinMb2TiSh25Rh+lXPqPFbI=;
        b=SCCNyvQg7iXPbiZPdRR2LY1DBUkkHUrTJQ9Ulv0ztBotO32vDDmJDNTn7lSppjcgoe
         SyxAFqH2cfu9oIPFSpPFSiOBJrnGdL9rA5pgxnScrQduKqzAj7Cbi83i9MKnXlV1D6AW
         Ndd1/Jwe7y4aZrJ+YKaKdnn9jEqTRp+h8f+/HEVq5aChQsS5Sp1K0bFfDZ6k2KlTR0Ft
         DxJ8Jq2TA5jZUOWJH2Nj1cUmXoffzm2wews31upvF/dQ618wghnzJBNYKtg5SDjB1m2A
         +oy1eezZiellDqdDXydB+7W4wRpKOlTTmNGXWi+bEXtGgIp3t4VOOEN/o+u8lhsT/QSK
         NL4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kMVKjCl04dw0PGuDwWt7IinMb2TiSh25Rh+lXPqPFbI=;
        b=PCulj9+hZAo3NqpcjbtyQp3AaUVvsaqRi60Xn3/ad03NfaKU/RIFdaANLXkHlf49uv
         yX2vPJjmElk0NPgv52ZG9Pt6MR3z6NllAfsNgovWzSLBp83uLEcW4SITpwKjxCSHkJxx
         VaAg0EQYP69k08DADVmwfSFD/3aDNEpV6KstHLLvw5lA5o5Non024Fy9TpL5HUextuWj
         lc5e/1HTV0TFX4YT80xz6KN7Yfl0VwksW+4qsouV6YRqxyr9E/d/09uT8CkGiwNAvDmU
         xoXKcpajuExd+3JST1hxjquhvZ/rsYNKmng9UeG3BvyJ+4OAc8MCWKeMv8I8rnwDUO5h
         SWyA==
X-Gm-Message-State: AOAM532AmW4YyoNa/luyTH0zMyDAIupmkEtzWqYZyc2Z/c4EcQWiUZYO
        +9qSqu0jaSX3XhfebkqHSumwqVukCj5Fdve03Jo=
X-Google-Smtp-Source: ABdhPJx0tjGKzj8i/l6FP7eKW9dyVRnwdtuuj/WDM9AR3Mmhc8CSeoTst/aSp0ee1EAyiFDU+TzkIgUf4wrd7BYO4oU=
X-Received: by 2002:a7b:c745:: with SMTP id w5mr19219810wmk.167.1640742344307;
 Tue, 28 Dec 2021 17:45:44 -0800 (PST)
MIME-Version: 1.0
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
 <20211222155743.256280-9-miquel.raynal@bootlin.com> <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
In-Reply-To: <CAB_54W786n6_4FAMc7VMAX0nuyd6r2Hi+wYEEbd5Bjdrd8ArpA@mail.gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Tue, 28 Dec 2021 20:45:33 -0500
Message-ID: <CAB_54W5pj=zFwfDh7=0Nh-FivGb6Edjosd19dzmH_k0C5mszmw@mail.gmail.com>
Subject: Re: [net-next 08/18] net: ieee802154: Add support for internal PAN management
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 28 Dec 2021 at 17:22, Alexander Aring <alex.aring@gmail.com> wrote:
...
> That means as far I see you should move the most of those attributes
> to per wpan_dev instead of per cfg802154.

Sorry that's wrong.

I see now, that the result for a scan on every possible wpan_dev for a
specific wpan_phy should return the same result, that's why it belongs
to cfg802154 and this is correct (as a cfg802154 has a 1:1 mapping to
wpan_phy).
Same as in wireless...

- Alex
