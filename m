Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F212A9533
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 12:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgKFLZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 06:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgKFLZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 06:25:14 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59D8C0613CF;
        Fri,  6 Nov 2020 03:25:13 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h6so710801pgk.4;
        Fri, 06 Nov 2020 03:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mB5fwGqdf8GYUjQarYKzei/oazwXbZmsmBYQhWu5IT8=;
        b=rZuJo4P5dTRkmDpxPz8PnDj+07wXqJyAJpSC07VDYGNf/HKgv27KGcyG5lKnbXIIj7
         jBqQwzzWDPpA5sBlbmXNMZEK94/QLfQ/cikgDeE9LyF847qF2/LvklsCoag+qh0igSo8
         wY5Shyc7YdY914v+UJmUDQWN45jJagcmhCNTDRX2KsRuF8ursWoPV35QeqZmWPKt2Q39
         ZxFON3X6xbk135sb1OZFgOSBHXuDsMcZ6Chi6PryJuA62OQzmNOMYJqs5yEIcPpnlWtF
         xOZqQ1+Cp7YvaBEZ6Tg2vLw2GlwoAaZH9kEM0b7zGMPXxeKDE1WJ0gYE8g8f5Q5Dh7co
         lGWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mB5fwGqdf8GYUjQarYKzei/oazwXbZmsmBYQhWu5IT8=;
        b=ihaJ2wTO34GsQpYQuPDLmceebmRzSzPwLFzR3WgqHe8bpCIiqTTk1OIVNLKEOeW65a
         +AAvNqFG4zoYVI1bA3dtB0O5jA2dyPkulBr+7vti0VNBvn8/wFWbSc9f9ufP/85tELAU
         b9yo6SF3vhbtxAGjhb4tWi6HwCJmNbsCzZ7RAhjhIGF/sB95UklTAx8dmOBJ20XE285A
         MF7JFFtoCstM5l2Cjmng9psN5t3XkM159VEXASiLM41usk/sQWuLXsIUVLPonifO4jpZ
         hQqbJ34qTr2kgPozjzHN69Ol5MabDfYTYuaYDIpQyWr47FnzZfQsgYn33FxNg/nhGmdY
         h6dQ==
X-Gm-Message-State: AOAM530Fply1A18vgLCAyzE4wXp3As14SVO9Ym/vsaVHXBoDdmY3wj7+
        pg5TahxxmN9re/twkk8wtps6TxfCqhhbpHPYjYs=
X-Google-Smtp-Source: ABdhPJxfbcV6Xwm5MFhA1xoDJ5mzK+Wn6Sk8KEOBJSPYEcpgPNR+DaFHqfS7D+yK0jaB5dCuxBscKy0fdtxVdZ0BLkk=
X-Received: by 2002:a05:6a00:14c4:b029:18b:92e2:6f3a with SMTP id
 w4-20020a056a0014c4b029018b92e26f3amr1486192pfu.76.1604661913499; Fri, 06 Nov
 2020 03:25:13 -0800 (PST)
MIME-Version: 1.0
References: <20201105073434.429307-1-xie.he.0141@gmail.com>
 <CAK8P3a2bk9ZpoEvmhDpSv8ByyO-LevmF-W4Or_6RPRtV6gTQ1w@mail.gmail.com>
 <CAJht_EPP_otbU226Ub5mC_OZPXO4h0O2-URkpsrMBFovcdDHWQ@mail.gmail.com>
 <CAK8P3a2jd3w=k9HC-kFWZYuzAf2D4npkWdrUn6UBj6JzrrVkpQ@mail.gmail.com>
 <CAJht_EPAqy_+Cfh1TXoNeC_j7JDgPWrG-=mMMmQ3ot2gNZuB8A@mail.gmail.com> <f4b59cfa4f6b4cc89bf2f111974bb86e@AcuMS.aculab.com>
In-Reply-To: <f4b59cfa4f6b4cc89bf2f111974bb86e@AcuMS.aculab.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 6 Nov 2020 03:25:02 -0800
Message-ID: <CAJht_ENiEi1u-fNuE+3NSBY=3BOWL4cC8ndJAH04f-jBR-CW1w@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25_asy: Delete the x25_asy driver
To:     David Laight <David.Laight@aculab.com>
Cc:     Arnd Bergmann <arnd@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 1:03 AM David Laight <David.Laight@aculab.com> wrote:
>
> Hmmm.... LAPB would expect to have an X.25 level 3 and maybe ISO
> transport (class 0, 2 or 3) sat on top of it.

I actually used AF_PACKET sockets to transport data directly over LAPB
and it worked.

LAPB doesn't need anything from layer 3. It just sees the layer 3
packets as a sequence of packets, numbers them and reliably transports
them in order. It doesn't read the internal contents of the packets.
