Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E7219E289
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 05:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDDDhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 23:37:42 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:35298 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgDDDhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 23:37:42 -0400
Received: by mail-ot1-f68.google.com with SMTP id v2so9567437oto.2;
        Fri, 03 Apr 2020 20:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4WbluZDhw2UVjup7ga4DOtaPANEI0o4JCWjagoCmgy8=;
        b=W3YeCMAF9MApJBdYEFhU9WsZL11NUkjdvzGUS1f5iLxFQzYg1glMKciGmHzRkrgiig
         XS9a2TvTBLi69fV799tgOqiWowIg0UZWX4LgIy5YzskVoSr5YwPO4ty9hFxyTjexG0vd
         z9AaXdon2RpwUukaf1JCnOl/mbITMlZdWHNiPo06XwCzDy64aeO9uXx83shizIKEYxG4
         4pr5vOtVIK1+y8DXlynJXCcXSrQ++70A60vUXdCYljk/+HfcjP5TxzcmMsmxvrzA3XbN
         QsHelQ9GJ6O53g/Svw1kEHnRYhaZ58f5tJRGuaV9pdREYNiqSyXVq+9nAj8ddc8KbCD8
         UMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4WbluZDhw2UVjup7ga4DOtaPANEI0o4JCWjagoCmgy8=;
        b=YtX1Aac5ALYe6/68AzqeXkkGc90WdWqTUBBp//UGGkcI9eW6ygoBBiAc/LYKI/E8pE
         3kRszgWEOu8v2DkRZlG9XsL1PKeLWAJR6Ke2QYtxV/i5T7Oby+DcZTvGi4UMaw6pUmFm
         9kNByanEYD00c5sPvB1ZA7vuD9m27d8aWjQkieanJBBkJGJgMy0AiLb6CKEr6JtyO2OC
         jpqoIPqJBvnbuehojPFs+llG2ggCI/f3XngR5IYl1RB8DOVuszqLWZVz1tf8+uCLsQe7
         kqF/P9avz9/KfChXkK/0XslzPi2CzHpBmMECojcjYlWT8PrJWn+AO9Tk/Ld3g6FAM98F
         WaMg==
X-Gm-Message-State: AGi0PuYyTKYvMigrFPll8sfQSVejgEzI90wHEbKfaJuJpKteYDbpc1JK
        zZxCSMLMxJHuQ6YMNZ5Agny5c4wGBredQaNpyrc=
X-Google-Smtp-Source: APiQypKyHxYIf+5TXgFLUWui2aNL0tjRUUYrTHIDbSYafaUkC7PU2HOOf4l4UI+ukKt8ZQLbURBm/vE4UafQw2ZP9Is=
X-Received: by 2002:a9d:1b6d:: with SMTP id l100mr8477327otl.70.1585971461014;
 Fri, 03 Apr 2020 20:37:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200403112830.505720-1-gch981213@gmail.com> <20200403.161139.2115986079787627095.davem@davemloft.net>
In-Reply-To: <20200403.161139.2115986079787627095.davem@davemloft.net>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sat, 4 Apr 2020 11:37:29 +0800
Message-ID: <CAJsYDVLGi3xczRqDC-d9q8=jHK=kfYh886erUxULoMNidSX8JA@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in port5 setup
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sat, Apr 4, 2020 at 7:11 AM David Miller <davem@davemloft.net> wrote:
> > Cc: stable@vger.kernel.org
>
> Please do not CC: stable for networking changes, as per:
>
>         Documentation/networking/netdev-FAQ.rstq

Oh! I'm not aware of this doc. Thanks for pointing it out.

-- 
Regards,
Chuanhong Guo
