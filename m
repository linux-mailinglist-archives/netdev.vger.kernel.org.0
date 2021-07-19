Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650E23CEDC1
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386913AbhGSTmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:42:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50706 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385145AbhGSStM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 14:49:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210719192909euoutp0125c119f67a677e3a14308dbe90af899d~TR_d39CI61234612346euoutp01H
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 19:29:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210719192909euoutp0125c119f67a677e3a14308dbe90af899d~TR_d39CI61234612346euoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626722949;
        bh=UFhQCAUhDC67lyBepVSYJIp63pxFJ7hGHiMoJW2jyvo=;
        h=From:To:Cc:Subject:Date:References:From;
        b=saIw8irCj7oJhFFNqZIFS5IImu8+rArCyjWMlYp62lXHLahWrKwBsz1CHVFKM4ede
         ytACaBv5Vj5XT2Wu48x0ioz0rnsAau8XhhbbAR7BjNJ/GUvK+yKGClS0kAGu9yDG6z
         hSzjrtdme4CNc0p1bNRdmfIasULUlI6w04TW3i4g=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210719192909eucas1p11c5b8fcf47b203cc5df483ffb7fafc26~TR_dMYigk1229512295eucas1p1q;
        Mon, 19 Jul 2021 19:29:09 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id FF.02.42068.482D5F06; Mon, 19
        Jul 2021 20:29:09 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210719192908eucas1p230d8bc4d30fc1da8d9c9e162b5fc0bff~TR_cxiVgC0845108451eucas1p2k;
        Mon, 19 Jul 2021 19:29:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210719192908eusmtrp2c6d7f57d27fef9e7793f42ff773282ee~TR_cwppYI2699226992eusmtrp2Z;
        Mon, 19 Jul 2021 19:29:08 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-83-60f5d284cd7f
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7B.DC.20981.482D5F06; Mon, 19
        Jul 2021 20:29:08 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210719192908eusmtip1eddf836528162c3a4bb55fbf07bd4c05~TR_cjtZhZ1435214352eusmtip1b;
        Mon, 19 Jul 2021 19:29:08 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     =?UTF-8?q?Bart=C5=82omiej=20=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH net-next v14 0/3] AX88796C SPI Ethernet Adapter
Date:   Mon, 19 Jul 2021 21:28:49 +0200
Message-Id: <20210719192852.27404-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djPc7qtl74mGOztYLY4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DVQyfkN7BYXtvWxWtw8tILRYtPja6wWl3fNYbOY
        cX4fk8WhqXsZLdYeuctucWyBmEXr3iPsDoIel69dZPbYsvImk8fOWXfZPTat6mTz2Lyk3mPn
        js9MHn1bVjF6fN4kF8ARxWWTkpqTWZZapG+XwJXRfWUtY8Eag4rnbVtZGxhvqnYxcnJICJhI
        LH7fzdzFyMUhJLCCUWLBwsmMEM4XRon1fduhMp8ZJdY93MoC03Jr23GoquWMEu03n0NVPWeU
        eHnjHCtIFZuAo0T/0hOsIAkRgXvMEuvbH4C1MAvsY5TYeW8KM0iVsIC9xIXGZWA2i4CqxJP9
        lxlBbF4Ba4l71xvYIfbJS7Qv384GEReUODnzCdgd/AJaEmuaroPZzEA1zVtng50hIbCcU6J1
        xz8miGYXiesb37NB2MISr45vgRoqI/F/53ygGg4gu15i8iQziN4eRoltc35APWotcefcLzaQ
        GmYBTYn1u/Qhyh0lbqyThzD5JG68FYS4gE9i0rbpzBBhXomONiGIGSoS6/r3QM2Tkuh9tYIR
        wvaQ2H3tK+sERsVZSP6aheSXWQhrFzAyr2IUTy0tzk1PLTbKSy3XK07MLS7NS9dLzs/dxAhM
        daf/Hf+yg3H5q496hxiZOBgPMUpwMCuJ8KoUfU0Q4k1JrKxKLcqPLyrNSS0+xCjNwaIkzpu0
        ZU28kEB6YklqdmpqQWoRTJaJg1Oqgamw7DL7iRdtdzQF6yPOOCn9+dMwL/LoZdEvHBM0HyUw
        l4j+3juBZXbpPsY/y5I6ZeW8/9dvOsXf3NrBontwZpw8G+tCBs1v6qtW31z5/vOrqdaTHlT1
        SRbyNdbrnnVWr/jYmp1arH3RNsJfIPyih6gU95voK5/1/hpty1W6K5f7uv3IjjmPDvZEMIi8
        VHSZ4eN332fh9A9MzCnZre1y7xtLw/f5T/1SvkJOwqh6g8SBA20vIiNknQ//PKfB0Ng2pWGl
        VfYXA9+10w8ulT83Tax/5vtrjlKG9d2Nlj+Fsmeuqlyj2bq5oi4szdFGxvPD5OKGipU1Svyd
        r6YIGyTwvOWIsnr5fX7fnKkT9gVKKLEUZyQaajEXFScCAM1Fxe/kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t/xu7otl74mGFw7omZx/u4hZouNM9az
        Wsw538JiMf/IOVaLRe9nsFpce3uH1aL/8Wtmi/PnN7BbXNjWx2px89AKRotNj6+xWlzeNYfN
        Ysb5fUwWh6buZbRYe+Quu8WxBWIWrXuPsDsIely+dpHZY8vKm0weO2fdZffYtKqTzWPzknqP
        nTs+M3n0bVnF6PF5k1wAR5SeTVF+aUmqQkZ+cYmtUrShhZGeoaWFnpGJpZ6hsXmslZGpkr6d
        TUpqTmZZapG+XYJeRveVtYwFawwqnrdtZW1gvKnaxcjJISFgInFr23HGLkYuDiGBpYwSp++d
        Zuli5ABKSEmsnJsOUSMs8edaFxtEzVNGiQXXXzGDJNgEHCX6l55gBUmICLxhlmi695YdxGEW
        2Mcosf/oYnaQKmEBe4kLjcvAOlgEVCWe7L/MCGLzClhL3LvewA6xQl6iffl2Noi4oMTJmU/A
        rmAWUJdYP08IJMwvoCWxpuk6C4jNDFTevHU28wRGgVlIOmYhdMxCUrWAkXkVo0hqaXFuem6x
        kV5xYm5xaV66XnJ+7iZGYKRuO/Zzyw7Gla8+6h1iZOJgPMQowcGsJMKrUvQ1QYg3JbGyKrUo
        P76oNCe1+BCjKdAHE5mlRJPzgakiryTe0MzA1NDEzNLA1NLMWEmc1+TImnghgfTEktTs1NSC
        1CKYPiYOTqkGpi3TbJ21V2ZUbd2YlzyDsXGGU86npzmPFR96Rpz5uHl2U+XeyfKW7wMFwu3m
        3Q9hfZe3Y+cCj4tpmyZ27iiauiLm7vpqwfeTZpeyPd+wJkT4rM/W+yn1NruM9xf4nHvtsGqC
        zey53/uc13IvndskPX1z692Wub/jZ3w6cLfEJrg/zEukLnaTm01GwZ7q60uX9h/sjg63TL0d
        P0u4+uWNxE87E8TjMhyTp8sdvFlknHBpm8sNpqknD5qdYPBnWsO7bOfWU6EvRZ0uLliSzf4z
        I/jt8iSP0PnLM0qV2/2zuqbd5I2s3ePtf0nzINf/UMtlHyaekTnlpbDG89bTxG6m1K0/dwVt
        lFI8MG9Zs4ij6RElluKMREMt5qLiRADQLIE1XQMAAA==
X-CMS-MailID: 20210719192908eucas1p230d8bc4d30fc1da8d9c9e162b5fc0bff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210719192908eucas1p230d8bc4d30fc1da8d9c9e162b5fc0bff
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210719192908eucas1p230d8bc4d30fc1da8d9c9e162b5fc0bff
References: <CGME20210719192908eucas1p230d8bc4d30fc1da8d9c9e162b5fc0bff@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

Changes in v14:
  - rebased onto net-next 5.14-rc1 (0d6835ffe50c)

Changes in v13:
  - rebased onto net-next (ebbf5fcb94a7)
  - minor fix: use u64_stats_update_{begin_irqsave,end_irqrestore}
  - minor fix: initialize the syncp lock

Changes in v12:
  - rebased to net-next-5.13
  - added missing spaces after commas
  - corrected indentation

Changes in v11:
  - changed stat counters to 64-bit
  - replaced WARN_ON(!mutex_is_locked()) with lockdep_assert_held()
  - replaced ax88796c_free_skb_queue() with __skb_queue_purge()
  - added cancel_work_sync() for ax_work
  - removed unused fields of struct skb_data
  - replaced MAX() with max() from minmax.h
  - rebased to net-next (resend)

Changes in v10:
  - removed unused variable
 
Changes in v9:
  - used pskb_extend_head()
  - used ethtool private flags instead of tunables to switch SPI
    compression
  - changed
    - alloc_skb() to netdev_alloc(skb)
    - __pskb_trim() to pskb_trim()
  - removed:
    - chages to skb->truesize
    - unnecessary casting to short
    - return f() in a void function
    - IRQF_SHARED flags
    - unnecessary memset(0) of kzalloc()ed buffer
    - unused endiannes detection
    - unnecessary __packed attribute for some structures
  - added:
    - temporary variable in AX_WRITE/READ sequences
    - missin mutex_unlock() in error paths
  - axspi_read_reg() returns a constant value in case of an error
  
Changes in v8:
  - fixed the entry in MAINTAINERS
  - removed unnecessary netif_err()
  - changed netif_rx() to netif_rx_ni() for code running in a process
    context
  - added explicit type casting for ~BIT()

Changes in v7:
  - removed duplicate code
  - moved a constant buffer definition away from a header file

Changes in v6:
  - fixed typos in Kconfig
  - checked argument value in ax88796c_set_tunable
  - updated tags in commit messages

Changes in v5:
  - coding style (local variable declarations)
  - added spi0 node in the DT binding example and removed
    interrupt-parent
  - removed comp module parameter
  - added CONFIG_SPI_AX88796C_COMPRESSION option to set the initial
    state of SPI compression
  - introduced new ethtool tunable "spi-compression" to controll SPI
    transfer compression
  - removed unused fields in struct ax88796c_device
  - switched from using buffers allocated on stack for SPI transfers
    to DMA safe ones embedded in struct ax_spi and allocated with
    kmalloc()

Changes in v4:
  - fixed compilation problems in asix,ax88796c.yaml and in
  ax88796c_main.c introduced in v3

Changes in v3:
  - modify vendor-prefixes.yaml in a separate patch
  - fix several problems in the dt binding
    - removed unnecessary descriptions and properties
    - changed the order of entries
    - fixed problems with missing defines in the example
  - change (1 << N) to BIT(N), left a few (0 << N)
  - replace ax88796c_get_link(), ax88796c_get_link_ksettings(),
    ax88796c_set_link_ksettings(), ax88796c_nway_reset(),
    ax88796c_set_mac_address() with appropriate kernel functions.
  - disable PHY auto-polling in MAC and use PHYLIB to track the state
    of PHY and configure MAC
  - propagate return values instead of returning constants in several
    places
  - add WARN_ON() for unlocked mutex
  - remove local work queue and use the system_wq
  - replace phy_connect_direct() with phy_connect() and move
    devm_register_netdev() to the end of ax88796c_probe()
    (Unlike phy_connect_direct() phy_connect() does not crash if the
    network device isn't registered yet.)
  - remove error messages on ENOMEM
  - move free_irq() to the end of ax88796c_close() to avoid race
    condition
  - implement flow-control

Changes in v2:
  - use phylib
  - added DT bindings
  - moved #includes to *.c files
  - used mutex instead of a semaphore for locking
  - renamed some constants
  - added error propagation for several functions
  - used ethtool for dumping registers
  - added control over checksum offloading
  - remove vendor specific PM
  - removed macaddr module parameter and added support for reading a MAC
    address from platform data (e.g. DT)
  - removed dependency on SPI from NET_VENDOR_ASIX
  - added an entry in the MAINTAINERS file
  - simplified logging with appropriate netif_* and netdev_* helpers
  - lots of style fixes

Łukasz Stelmach (3):
  dt-bindings: vendor-prefixes: Add asix prefix
  dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
  net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver

 .../bindings/net/asix,ax88796c.yaml           |   73 ++
 .../devicetree/bindings/vendor-prefixes.yaml  |    2 +
 MAINTAINERS                                   |    6 +
 drivers/net/ethernet/Kconfig                  |    1 +
 drivers/net/ethernet/Makefile                 |    1 +
 drivers/net/ethernet/asix/Kconfig             |   35 +
 drivers/net/ethernet/asix/Makefile            |    6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c    |  239 ++++
 drivers/net/ethernet/asix/ax88796c_ioctl.h    |   26 +
 drivers/net/ethernet/asix/ax88796c_main.c     | 1149 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2290 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h

-- 
2.26.2

