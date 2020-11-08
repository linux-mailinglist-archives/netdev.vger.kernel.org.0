Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D102AAB2F
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 14:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgKHNgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 08:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgKHNgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 08:36:49 -0500
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B3F6C0613CF;
        Sun,  8 Nov 2020 05:36:49 -0800 (PST)
Received: by mail-vk1-xa44.google.com with SMTP id q77so1301556vkq.1;
        Sun, 08 Nov 2020 05:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r6YNxZOIj6dnwGpflutnampsTdxRa2ubNoPmM/Zqnyk=;
        b=ugG/Hr3s871gdJHAW47OarxcQTl6ONX5gcdHgFgcavhV0rwSBc8p+vj54Sd96+MyOb
         Jmju/GrRvcfgveo20Wzvw5LUSiWAISIM9FgiQENWwWS2qMrefGY6OPN4xZ8iEMlNEnkw
         TDL8DLzmFkHO/hRgZ6EJT46+9JLt/WT00MGPRLMbQTVXRvQ0exDmPWLXzc9YOop9Qbla
         aJ5DL4XqsPumO0D0CsWfEg7iCW7oGr7rOc750VtmT+4qPzPu/MBAElwovBO3VstOU1m+
         rD6cm2SI7N1wigojX5sWzTAKgLh94UevlpHOPGsciN9I2UROqaLNfdO3vDqAX4nk8HOy
         WK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r6YNxZOIj6dnwGpflutnampsTdxRa2ubNoPmM/Zqnyk=;
        b=KrpfasnVQH7YFA/lnG6J1QcrLbYT9capNPRoCPx7LVlg2kywgLBtv8PyA1emGjmxaj
         RvYmW4VZ/XwejVyfnI7fMfJHNKGQ0+WTNa2CXQzP0ygnb341zCO0rV78mgDWbNyZn2qx
         BEfm6SnWBKnmDr/9DmllFQN5u21oFRDeSWUd2JB9rQoSQNHCR0Tr+wNU/iwBwzWwqHgj
         +tOonnugA3EivuT8cpbUcdQZTdBSJktuT8ImrTMhyQ79V4XG7+IOuc52GR28lQqnioi5
         gQA6IUpSMyxf2/ddVxGBXUiQTpxi9k6UFzX93DqOYMDd4bt6tsqWZgyp9hOtcv4UThWe
         VYew==
X-Gm-Message-State: AOAM532EO+uUes6pOlJ+L5kTQk1GqFeSWvKPgyJwcEhj6Xmu0FfS1DLj
        1x/11BM8C/O/mnOxYDpLZr964cJMc7hZtHAgZM0=
X-Google-Smtp-Source: ABdhPJxoRUROmcpJt+BeZfblyJTkUpQibj3Ll0LDvF0SysX/5yzF8Xbz4pr6vQGNUUS8AqNQJOW/Tkv74qJeluRCsak=
X-Received: by 2002:a1f:2e13:: with SMTP id u19mr4804572vku.5.1604842608604;
 Sun, 08 Nov 2020 05:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20201108041447.GZ933237@lunn.ch> <180E897D-A99A-43E2-8033-AE1C2499C5BF@berg-solutions.de>
In-Reply-To: <180E897D-A99A-43E2-8033-AE1C2499C5BF@berg-solutions.de>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Sun, 8 Nov 2020 08:36:38 -0500
Message-ID: <CAGngYiUVnq2BanL_JwDGVwRapO_oU0=-2xFmaPPmHB5XJft4MA@mail.gmail.com>
Subject: Re: [PATCH v2] lan743x: correctly handle chips with internal PHY
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roelof, great to meet another user of the lan743x !

On Sun, Nov 8, 2020 at 2:43 AM Roelof Berg <rberg@berg-solutions.de> wrote:
>
> My last customer has a fixed link setup, contact me if you need one. Maybe they let me have it and I can test all future patches on fixed link as well.

Is this a commercially available product? I could test this out if it
can be ordered
inexpensively from my location (Canada).

> I tested the current driver version on a Lan7430 EVM in a PC by the way and it seemed to be working. I have the EVM still here if needed.

Yes it will work on a PC, because the device doesn't have a devicetree
entry there.
In my case I am running on ARM, and I'm manually creating a devicetree
entry in the fdt, so that the bootloader can assign a mac address to the chip.

I must be one of the first to use this chip on ARM, because I have
encountered 2 or 3 issues with the current driver, which crash the
kernel on ARM.

I'll try to contribute those changes once this fix is accepted and merged.

Sven
