Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCA9360628
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhDOJth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbhDOJtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 05:49:35 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC19C061574;
        Thu, 15 Apr 2021 02:49:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id d10so16528069pgf.12;
        Thu, 15 Apr 2021 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=MLJSeXjPoZhwM9OSDgG8lC1iJnB13aPm/yKl+/yfCV4=;
        b=pRp6PcDwdUPowwS48+n5Vcn7b/Qu7Q0Bq2YvCP3A8ZlqeThBV3w1DUWLE2e8USg8pm
         p56e0NTf8FPp/4keeaxSxU8itqoXcygZWccJHjzPYw6twkrPCaCeIa7t8UWAaOi13xiX
         Ve6vDa0hTMEKVIEsbLjuxRulV/n9kQ+m5aOD6Vkf6r2/Bwusr+eQ/S2dwwn2oMFwp3Lc
         2GkmtQYNPNgQcVe/+isx2vnEXxpY4KB3qC1LUVEX/QDmUFhh3+H3Qlnrawi6wO8qPSXX
         n9LXQW/2cwdJBiHYuTEtqQ1QFQjXIxdEl7Z+WptTF8OVwNjIWlQO0gCPwfl0HQmBLn9z
         KTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=MLJSeXjPoZhwM9OSDgG8lC1iJnB13aPm/yKl+/yfCV4=;
        b=njomCBQASrMGDIrAB2ac1RY1Xp6y/SpXWX96EaS5PsxiHXMZa6nj/hAEhGeWvXE+fs
         Qa+TIabsNVV803M6JV9uUtQYVFtRqhej5u4Ey3z0eeHbmfqowO/f/qqRmHHZbxzTVZwj
         oE6FawiUMe1Jht0P0ZMFhoKTXMbR+irzYY2ao/U0//pp/RrnCyzIJZeX/Akbxr7pYYNR
         e/eaPEnd7kVbFMj1CFuyIwxpfc7Twhd5yND49cgVqtCrG3Ak9H8qzdHAGDULNwTM9BP7
         rVByJ0z/R5MdiNgURmEP3GfJojDp53/FK0HWlHIUokQVYdERxvqVyRkPo/mNWhdQfAfS
         pV1g==
X-Gm-Message-State: AOAM533yOavwkUmDhaPsMH2vjMzwNre838gkcRmXH14ZWDvncwj3C6Ii
        ne272fSCU9Am7J1aw0EhHco=
X-Google-Smtp-Source: ABdhPJz/296Ukvru+pRPqrOVz6BD93FwhsGWGwnliuGvZd2ixls4Ij1dvumbp8/IpFDe3RglPXeWtw==
X-Received: by 2002:a62:7d07:0:b029:21b:d1bc:f6c8 with SMTP id y7-20020a627d070000b029021bd1bcf6c8mr2278450pfc.45.1618480152634;
        Thu, 15 Apr 2021 02:49:12 -0700 (PDT)
Received: from localhost.localdomain ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id g10sm1581765pfj.137.2021.04.15.02.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 02:49:11 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC v4 net-next 1/4] net: phy: add MediaTek PHY driver
Date:   Thu, 15 Apr 2021 17:49:02 +0800
Message-Id: <20210415094902.2946-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413131259.GP1463@shell.armlinux.org.uk>
References: <20210412034237.2473017-1-dqfext@gmail.com> <20210412034237.2473017-2-dqfext@gmail.com> <20210412070449.Horde.wg9CWXW8V9o0P-heKYtQpVh@www.vdorst.com> <20210412150836.929610-1-dqfext@gmail.com> <20210413035920.1422364-1-dqfext@gmail.com> <20210413131259.GP1463@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 02:12:59PM +0100, Russell King - ARM Linux admin wrote:
> On Tue, Apr 13, 2021 at 11:59:20AM +0800, DENG Qingfang wrote:
> > Within 12 hours, I got some spontaneous link down/ups when EEE is enabled:
> > 
> > [16334.236233] mt7530 mdio-bus:1f wan: Link is Down
> > [16334.241340] br-lan: port 3(wan) entered disabled state
> > [16337.355988] mt7530 mdio-bus:1f wan: Link is Up - 1Gbps/Full - flow control rx/tx
> > [16337.363468] br-lan: port 3(wan) entered blocking state
> > [16337.368638] br-lan: port 3(wan) entered forwarding state
> > 
> > The cable is a 30m Cat.6 and never has such issue when EEE is disabled.
> > Perhaps WAKEUP_TIME_1000/100 or some PHY registers need to be fine-tuned,
> > but for now I think it should be disabled by default.
> 
> Experience with Atheros AR8035 which has a very similar issue would
> suggest that before resorting to the blunt hammer of disabling
> SmartEEE, one should definitely experiment with the 1G Tw settings.
> 
> Using 24us for 1G speeds on AR8035 helps a great deal, whereas the PHY
> defaults to 17us for 1G and 23us for 100M.

I set the 1G Tw to maximum 255us and still got the link issue..
