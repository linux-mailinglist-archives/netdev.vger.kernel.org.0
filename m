Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA3C719E277
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 05:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgDDDTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 23:19:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42930 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgDDDTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 23:19:22 -0400
Received: by mail-ot1-f68.google.com with SMTP id z5so9498431oth.9;
        Fri, 03 Apr 2020 20:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RTly8p3iJA54wQveLK6xwcKTq81ZrBUHxfgTAcTA1Z8=;
        b=PBPm3xk3Zhyh4WEtZGT4iZUioZXpoQWPKvTJlrPLgJIW7R3KHXQyy44rW7bb3gQmRr
         MAjFLXSHLR0/mMeCx1NsP108UpaOg6DZEj2Ay8Emby/wekk51VdfVEjYYXypWVpMgSWu
         9lmbohH8AYCxPu68IG6shouyhXXUV3g+xyYs3XRaoOQw8it4wZnSDokQTSyL8dZ8JWlH
         4NMi1/IIEQB84ELgmXBy20XjVB8gUbbxGZ+HhVim6pc84LVBKvPWziEk2VoJBESoTXiN
         H4+67Ph/bJYjsO9JJjJBJVqeUjS4M6usqoDjjvjSNJbVoConiSJpeAwCxCItb7j3wg1K
         sjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RTly8p3iJA54wQveLK6xwcKTq81ZrBUHxfgTAcTA1Z8=;
        b=sltS6n4vgQIO6lAVYp7j2ea/UrKV+Z5hP3/zwCkRCdE1zqOLYlkIHmOf+Sr3vWwkuN
         q7VHLSMhZneeXMNKrAdB8/60Be1ngdisJW5vBQUg7lylwKpxELq/6z1SzHUgmdxhtbxm
         AucCX7tncJXi0q4Y+ksOTMF9JjwmCqCLX/bWoENcBXbShwYUJLy7SUXIoiA9xuvUCKSQ
         QwyaNbVxQyXqTmo1ctIWPgiv+sHQScwZi3xaLstZ2Ffbh04ahwQ2qk8zogTpWI0SNO6O
         TOXiXcT+cFqh09KMVHRBqxF9j0RGOyEbUzhxdPJj5K3bYmmaiYOtw9Jn1na0cFy6GpRc
         K/AA==
X-Gm-Message-State: AGi0Pub3+Dqb9etj14kyxionhwsfXubaOpLEmE1OmBsEbQZB9ykBv/IV
        XbZhzFbmeq9Cg/Vn9fM5w+S/JgVrwu5foOrgERQ=
X-Google-Smtp-Source: APiQypLv6No4WClkuaXzzhXvWFmPvXoxH6GZGX5Z0oivPxYgzY5GBClyMuhj5EwhtDn3Wicr/GZFbALmhg+fsa11XJc=
X-Received: by 2002:a9d:1b6d:: with SMTP id l100mr8444823otl.70.1585970361154;
 Fri, 03 Apr 2020 20:19:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200403112830.505720-1-gch981213@gmail.com> <20200403180911.Horde.9xqnJvjcRDe-ttshlJbG6WE@www.vdorst.com>
In-Reply-To: <20200403180911.Horde.9xqnJvjcRDe-ttshlJbG6WE@www.vdorst.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sat, 4 Apr 2020 11:19:10 +0800
Message-ID: <CAJsYDVJj1JajVxeGifaOprXYstG-gC_OYwd5LrALUY_4BdtR3A@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in port5 setup
To:     =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Sat, Apr 4, 2020 at 2:09 AM Ren=C3=A9 van Dorst <opensource@vdorst.com> =
wrote:
>
> Quoting Chuanhong Guo <gch981213@gmail.com>:
>
> Hi Chuanhong,
>
> > The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
> > and a phy-handle isn't always available.
> > Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
> > connected to switch port 5 and setup mt7530 according to phy address
> > of 2nd gmac node, causing null pointer dereferencing when phy-handle
> > isn't defined in dts.
>
> MT7530 tries to detect if 2nd GMAC is using a phy with phy-address 0 or 4=
.

What if the 2nd GMAC connects to an external PHY on address 0 on a
different mdio-bus? This is already happening on mt7629 where the
integrated PHY connected to gmac2 is on address 0 and gmac1
connects to external mt753x switch.
On mt7621, the RGMII2 is always wired to switch mac5 as well as
external pins, and one should disable switch mac5 in this case or
there's pin conflict.

> If so, switch port 5 needs to be setup so that PHY 0 or 4 is available
> via port 5 of the switch. Any MAC can talk to PHY 0/4 directly via port 5=
.
> This is also explained in the kernel docs mt7530.txt.
>
> May be there are better way to detect that any node is using phy 0/4 of
> the switch.

It should never be detected. This piece of code is to configure how
RGMII2 on mt7530 is wired: PHY0/PHY4/switch MAC5/off. And it
should be implemented as a configurable dt property. We should
not make assumption that 2 RGMIIs always connected to the two
macs on mtk_eth_soc and we should never parse parent eth dts
in DSA driver.

--=20
Regards,
Chuanhong Guo
