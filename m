Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6860F32A328
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381991AbhCBIsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbhCBD7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 22:59:03 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4151FC06178A;
        Mon,  1 Mar 2021 19:58:23 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id f20so20291705ioo.10;
        Mon, 01 Mar 2021 19:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJRzvE5eiYAz/YzEvGsPOyIIxPQYjHRb8NRxUog9dPA=;
        b=rIdvnoyMYbOmuSwLAfCoreLUhLtR3un0AXpH/FQs9ypgDvUahSj0FuE1LnE6NFHbs0
         dd+hHnc9BAuPLWs0SnW377D7D6pZsSApk2DmehXp4v+E4wzmFpFjViklAbVNsoq3WFRl
         o935aM8XAZerxkhWc2YDl6GTdXT05tx3/tvIJDbngV8ppYSAJUSGC0eXhHM/YtdifMsk
         4xXWJR6Nq4OkAocojqMPVWrZWCUWAPp2/TZkKxq6a6wepklwK9k3W/xuqL9OuT0X2DAU
         urLn0VPEyt5QKm8w3aUL6PyQU2hzfKAP8qmJzYrCn2rPzazTZaLXLVQ1t+ZZ+Nrq02uH
         DJHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJRzvE5eiYAz/YzEvGsPOyIIxPQYjHRb8NRxUog9dPA=;
        b=YUq727ml0VmkNqChQEjZ23D7dab45ZAxnb6s+pbFZNn4Gv5i01bYnAC3V8aTRT1Vvg
         8Sd84d3gM8sU8Izf4F2lOI4zUsNSCZIxv9CSEEkkcUGcb5TB4MR1+UVoFYqJF1emYBUP
         8uLN1QVanZNcySpu2JKXGx50z8v0lFobF/X0pSgNK5TG5p6UMlMu2YQAmi2UOIVOBPXd
         n2S91AQBuwC03wqiuII9tWiYg+STnkI+I7fv85ZRECtbQhoqEQ3HpLbr3hd60gH4Yx4l
         o95QsJML25tG7pFbMxGxA43PjweHugGQtvwuzGYzVqXlZZAqLxVkpIPYo26/I4GLq042
         Ahgg==
X-Gm-Message-State: AOAM532XdVBTaNqU47CcNI67vWKKOT1c5JX0+thyYx/xhX3XZnm8OejI
        xlqZPuK4G51zIxeikyQC38UqkExlPGKBaHh3QmY=
X-Google-Smtp-Source: ABdhPJzmdHmYl3W7NtLOa5jltK6vOFHlrVPNOk9Q0ZH6Zvux+KhxL2sxWztbz8W0PiMtm836U6JL5cJxoUSyCMQiyXI=
X-Received: by 2002:a02:1c49:: with SMTP id c70mr19804852jac.136.1614657502800;
 Mon, 01 Mar 2021 19:58:22 -0800 (PST)
MIME-Version: 1.0
References: <20210224061205.23270-1-dqfext@gmail.com> <CACRpkdZykWgxM7Ge40gpMBaVUoa7WqJrOugrvSpm2Lc52hHC8w@mail.gmail.com>
In-Reply-To: <CACRpkdZykWgxM7Ge40gpMBaVUoa7WqJrOugrvSpm2Lc52hHC8w@mail.gmail.com>
From:   DENG Qingfang <dqfext@gmail.com>
Date:   Tue, 2 Mar 2021 11:58:12 +0800
Message-ID: <CALW65jYRaUHX7JBWbQa+y83_3KBStaMK1-_2Zj25v9isFKCLpQ@mail.gmail.com>
Subject: Re: [RFC net-next] net: dsa: rtl8366rb: support bridge offloading
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 1, 2021 at 9:48 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> With my minor changes:
> Tested-by: Linus Walleij <linus.walleij@linaro.org>

How about using a mutex lock in port_bridge_{join,leave} ?
In my opinion all functions that access multiple registers should be
synchronized.

> Yours,
> Linus Walleij
