Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C5D2C8703
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgK3OnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:43:15 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50781 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgK3OnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:43:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606747393; x=1638283393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MeoCuwYzk9FZHmVsCWWQGz51LHhUS5ecw0YQrZF+gTs=;
  b=IQOU98rfvZB+0fUH+SWVYuHrbh6JlCzuIyZj2Uaso/uFyVgWUZ5kjrMD
   dbEuLSiC/huh9mF7/vpKRH3IfZZ8W8l6GLXp2TUIEPAYXWMoT6Fu6mho3
   Yeuvxg67erDVV8/vPpjUAKITOhXQlDmvQsf9mm05fE0rem0CYlqM/KpnV
   4Hwr2xekoUcHoAHo6B+uxzeWD1uHUH2fYlyrrjsqsAVupBDE1To4mDFi7
   kXF07eOA4e+zNp+tefNAZ2UyAQGUx50xCkq3Q7YGAk9QpbU//+MvWBcOh
   R1khni2wP2sH0P1v4fNRPYwOMQo0EOciHVeGKexEp586Zr232Ept1lmBI
   w==;
IronPort-SDR: Ub3N7TXnR9VGpx3adA/rXPQhQo4rn1wE5Nx19iHQ/us3OYwjqi0okK2CqHm/vFUmbhkgq5xmkR
 fbLOeZ/JLQGBEinSu6oPBnucbC1H/5FGp8ZFc8qhW6KxwkUMqxQ8YowsyVg0V9XsPnSkNxluPt
 X4VTyKZFGpwzoTRf3HjE7BqhUctzhAHaspOiMdsYKKk8uqxv/wL70qdCPyR6gpwKyO4/6/6BTh
 MIojR5Ep8nBhCL/FtHgyTt/azdNv5YO5uZK89XCzvKHtS0b2L3F7TD235mAZ2uWO/UthRVvOn5
 oUI=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="105481257"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 07:42:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 07:42:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 07:42:07 -0700
Date:   Mon, 30 Nov 2020 15:42:06 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130144206.g7hnvwrtbblgblpm@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201129173520.GF2234159@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129173520.GF2234159@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 18:35, Andrew Lunn wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>> +#define SPX5_RD_(sparx5, id, tinst, tcnt,                    \
>> +              gbase, ginst, gcnt, gwidth,                    \
>> +              raddr, rinst, rcnt, rwidth)                    \
>> +     readl(spx5_addr((sparx5)->regs, id, tinst, tcnt,        \
>> +                     gbase, ginst, gcnt, gwidth,             \
>> +                     raddr, rinst, rcnt, rwidth))
>> +
>> +#define SPX5_INST_RD_(iomem, id, tinst, tcnt,                        \
>> +                   gbase, ginst, gcnt, gwidth,               \
>> +                   raddr, rinst, rcnt, rwidth)               \
>> +     readl(spx5_inst_addr(iomem,                             \
>> +                          gbase, ginst, gcnt, gwidth,        \
>> +                          raddr, rinst, rcnt, rwidth))
>> +
>> +#define SPX5_WR_(val, sparx5, id, tinst, tcnt,                       \
>> +              gbase, ginst, gcnt, gwidth,                    \
>> +              raddr, rinst, rcnt, rwidth)                    \
>> +     writel(val, spx5_addr((sparx5)->regs, id, tinst, tcnt,  \
>> +                           gbase, ginst, gcnt, gwidth,       \
>> +                           raddr, rinst, rcnt, rwidth))
>> +
>> +#define SPX5_INST_WR_(val, iomem, id, tinst, tcnt,           \
>> +                   gbase, ginst, gcnt, gwidth,               \
>> +                   raddr, rinst, rcnt, rwidth)               \
>> +     writel(val, spx5_inst_addr(iomem,                       \
>> +                                gbase, ginst, gcnt, gwidth,  \
>> +                                raddr, rinst, rcnt, rwidth))
>> +
>> +#define SPX5_RMW_(val, mask, sparx5, id, tinst, tcnt,                        \
>> +               gbase, ginst, gcnt, gwidth,                           \
>> +               raddr, rinst, rcnt, rwidth)                           \
>> +     do {                                                            \
>> +             u32 _v_;                                                \
>> +             u32 _m_ = mask;                                         \
>> +             void __iomem *addr =                                    \
>> +                     spx5_addr((sparx5)->regs, id, tinst, tcnt,      \
>> +                               gbase, ginst, gcnt, gwidth,           \
>> +                               raddr, rinst, rcnt, rwidth);          \
>> +             _v_ = readl(addr);                                      \
>> +             _v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));               \
>> +             writel(_v_, addr);                                      \
>> +     } while (0)
>> +
>> +#define SPX5_INST_RMW_(val, mask, iomem, id, tinst, tcnt,            \
>> +                    gbase, ginst, gcnt, gwidth,                      \
>> +                    raddr, rinst, rcnt, rwidth)                      \
>> +     do {                                                            \
>> +             u32 _v_;                                                \
>> +             u32 _m_ = mask;                                         \
>> +             void __iomem *addr =                                    \
>> +                     spx5_inst_addr(iomem,                           \
>> +                                    gbase, ginst, gcnt, gwidth,      \
>> +                                    raddr, rinst, rcnt, rwidth);     \
>> +             _v_ = readl(addr);                                      \
>> +             _v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));               \
>> +             writel(_v_, addr);                                      \
>> +     } while (0)
>> +
>> +#define SPX5_REG_RD_(regaddr)                        \
>> +     readl(regaddr)
>> +
>> +#define SPX5_REG_WR_(val, regaddr)           \
>> +     writel(val, regaddr)
>> +
>> +#define SPX5_REG_RMW_(val, mask, regaddr)                \
>> +     do {                                                \
>> +             u32 _v_;                                    \
>> +             u32 _m_ = mask;                             \
>> +             void __iomem *_r_ = regaddr;                \
>> +             _v_ = readl(_r_);                           \
>> +             _v_ = ((_v_ & ~(_m_)) | ((val) & (_m_)));   \
>> +             writel(_v_, _r_);                           \
>> +     } while (0)
>> +
>> +#define SPX5_REG_GET_(sparx5, id, tinst, tcnt,                       \
>> +                   gbase, ginst, gcnt, gwidth,               \
>> +                   raddr, rinst, rcnt, rwidth)               \
>> +     spx5_addr((sparx5)->regs, id, tinst, tcnt,              \
>> +               gbase, ginst, gcnt, gwidth,                   \
>> +               raddr, rinst, rcnt, rwidth)
>> +
>> +#define SPX5_RD(...)  SPX5_RD_(__VA_ARGS__)
>> +#define SPX5_WR(...)  SPX5_WR_(__VA_ARGS__)
>> +#define SPX5_RMW(...) SPX5_RMW_(__VA_ARGS__)
>> +#define SPX5_INST_RD(...) SPX5_INST_RD_(__VA_ARGS__)
>> +#define SPX5_INST_WR(...) SPX5_INST_WR_(__VA_ARGS__)
>> +#define SPX5_INST_RMW(...) SPX5_INST_RMW_(__VA_ARGS__)
>> +#define SPX5_INST_GET(sparx5, id, tinst) ((sparx5)->regs[(id) + (tinst)])
>> +#define SPX5_REG_RMW(...) SPX5_REG_RMW_(__VA_ARGS__)
>> +#define SPX5_REG_WR(...) SPX5_REG_WR_(__VA_ARGS__)
>> +#define SPX5_REG_RD(...) SPX5_REG_RD_(__VA_ARGS__)
>> +#define SPX5_REG_GET(...) SPX5_REG_GET_(__VA_ARGS__)
>
>I don't see any reason for macro magic here. If this just left over
>from HAL code? Please turn this all into functions.
>
>     Andrew
>

Thanks for the comment.  I will transform this into functions.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
