Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89160376691
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbhEGOCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:02:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:25752 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237359AbhEGOCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:02:16 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20210507140114euoutp02aaf3676d5813d8781490445dad15e4f3~8zaUTDsHf1986919869euoutp02t
        for <netdev@vger.kernel.org>; Fri,  7 May 2021 14:01:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20210507140114euoutp02aaf3676d5813d8781490445dad15e4f3~8zaUTDsHf1986919869euoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620396074;
        bh=oxIapUBNQR3k7aZPKU/KtkFdGurWbp1SPZSx7pMXtCE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=osznObsEm18nIwlH4HV5DxIsTG9ovNTn2ps10zn94XiOYgrB2ScRPwElhIKWb+mpD
         9fwGTC4DePHvE0b+e/tQF1l6i8/EZnQ9bs0g+JRE1V7j0ZRip/OrkkB7ZZgmdAlau3
         TPxeeAZA4bm10HMvmgFoDODPr3foKsKAFpVTSSZc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210507140113eucas1p228c7eebaaf9a5bca5d4867ff11170c7d~8zaTXVvGl0929309293eucas1p21;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C4.CD.09452.92845906; Fri,  7
        May 2021 15:01:13 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210507140113eucas1p21220dba3bb049a157df40fe778e39893~8zaS4goqL2080320803eucas1p2-;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210507140113eusmtrp2d1cd130e7520e6f838e111a289e8155d~8zaS3p3ax1970319703eusmtrp2Q;
        Fri,  7 May 2021 14:01:13 +0000 (GMT)
X-AuditID: cbfec7f2-a9fff700000024ec-f6-609548298d03
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 5E.51.08705.92845906; Fri,  7
        May 2021 15:01:13 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210507140112eusmtip2d874c70c70e7e399b8a428561b19aa14~8zaSlwp3T3137331373eusmtip2D;
        Fri,  7 May 2021 14:01:12 +0000 (GMT)
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
Subject: [PATCH net-next v12 0/3] AX88796C SPI Ethernet Adapter
Date:   Fri,  7 May 2021 16:01:07 +0200
Message-Id: <20210507140110.6323-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsWy7djPc7qaHlMTDDYvU7c4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI4rLJiU1J7MstUjfLoErY8HEo4wFu/Uq7u+9zt7AOF2li5GTQ0LA
        ROL4tlesXYxcHEICKxgl1mx6yALhfGGUmHGmgQ3C+cwosef8J1aYltdXt7BDJJYzSnQ/ugNV
        9ZxR4v7UJWBVbAKOEv1LT4ANFhG4xyyxvv0BI4jDLLCPUWLnvSnMIFXCAvYSi7rWMoHYLAKq
        EktONLOD2LwCVhJ71j+A2icv0b58OxtEXFDi5MwnLCA2v4CWxJqm62A2M1BN89bZzCALJASW
        c0o0zfrIDNHsIvF//kF2CFtY4tXxLVC2jMT/nfOBFnMA2fUSkyeZQfT2MEpsm/ODBaLGWuLO
        uV9sIDXMApoS63fpQ4QdJS5e/MAI0conceOtIMQJfBKTtk1nhgjzSnS0CUFUq0is698DNVBK
        ovfVCkYI20PiQ/N29gmMirOQPDYLyTOzEPYuYGRexSieWlqcm55abJiXWq5XnJhbXJqXrpec
        n7uJEZjsTv87/mkH49xXH/UOMTJxMB5ilOBgVhLhPb1ocoIQb0piZVVqUX58UWlOavEhRmkO
        FiVx3lWz18QLCaQnlqRmp6YWpBbBZJk4OKUamKZ9khepmHvqNNeUr2p6hpuE5seZKPc3n53t
        w7fGteaDdGqJfH1wdFfOzOXMS2L+LNtzvOHGsphNtR0HQmdozpF4I6n8J3CSmn/KLLH+no2r
        9e0XbbVX2yotb/E8cPp6m+dL3R9mal6PNp0S7LI4qmhi/3XlM+u8vyXO/jhdq3NlSgTTcZ52
        pi6H1H0mDw6tdD9wpNL2MN+hY7HOpeZByYcWxNxzlpnCL37NO4+rda3jOa63Rc7JM7bGszqW
        lbBcecaZfvS2w6WCm1+mPBc4dnsV+/2Zn+d3uzfcOh/W8Krb3GPlWcF7ZXv6fOZz1wcULpZZ
        P6Wt8ZDhqssL1neu6pRpnMN6tUfm5rrEnZuXPFViKc5INNRiLipOBACb79a75QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t/xe7qaHlMTDO5tZrc4f/cQs8XGGetZ
        Leacb2GxmH/kHKvFovczWC2uvb3DatH/+DWzxfnzG9gtLmzrY7W4eWgFo8Wmx9dYLS7vmsNm
        MeP8PiaLQ1P3MlqsPXKX3eLYAjGL1r1H2B0EPS5fu8jssWXlTSaPnbPusntsWtXJ5rF5Sb3H
        zh2fmTz6tqxi9Pi8SS6AI0rPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzWyshUSd/O
        JiU1J7MstUjfLkEvY8HEo4wFu/Uq7u+9zt7AOF2li5GTQ0LAROL11S3sXYxcHEICSxklzj6a
        xdTFyAGUkJJYOTcdokZY4s+1LjYQW0jgKaPEqiY1EJtNwFGif+kJVpBeEYE3zBJN996CDWIW
        2Mcosf/oYnaQKmEBe4lFXWuZQGwWAVWJJSeaweK8AlYSe9Y/YIXYIC/Rvnw7G0RcUOLkzCcs
        IEcwC6hLrJ8nBBLmF9CSWNN0nQXEZgYqb946m3kCo8AsJB2zEDpmIalawMi8ilEktbQ4Nz23
        2FCvODG3uDQvXS85P3cTIzBOtx37uXkH47xXH/UOMTJxMB5ilOBgVhLhPb1ocoIQb0piZVVq
        UX58UWlOavEhRlOgDyYyS4km5wMTRV5JvKGZgamhiZmlgamlmbGSOO/WuWvihQTSE0tSs1NT
        C1KLYPqYODilGpjYD7zt+Jr1x0ZSQLtsi5art9ub+J9KqX73ZphZXL72ytjyzC+2eln+VdlG
        IqYaXHvqA89wK5+48Z3tdsxJFa204Mc7Ds2Veypx+dfpsL+F945lRdzO7c1Y/MTS0enhJ8XU
        /v2dp0x+CSr3c6ssFAx6LLBU1/zKrnPq1iqXwmIvtD798e1ouvXFrQvXS83clbJJ9kjWKbuT
        iy9Eb16wmu2N9dMfWS5uV8KNVmn/Dn2890y3/3Sf5yI9qrJxP6JeiNaENChdYmdd97S/1KRU
        8iKb2u5A96I3a+q2hDxcY55k6VZ5VK6E3WTah2kKzydO/SoX3r/EQGnnJwFtk83XTbdK7jTt
        ebxlrUVmgejNOG4lluKMREMt5qLiRADfR+qPXAMAAA==
X-CMS-MailID: 20210507140113eucas1p21220dba3bb049a157df40fe778e39893
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210507140113eucas1p21220dba3bb049a157df40fe778e39893
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210507140113eucas1p21220dba3bb049a157df40fe778e39893
References: <CGME20210507140113eucas1p21220dba3bb049a157df40fe778e39893@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a driver for AX88796C Ethernet Adapter connected in SPI mode as
found on ARTIK5 evaluation board. The driver has been ported from a
v3.10.9 vendor kernel for ARTIK5 board.

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
 drivers/net/ethernet/asix/ax88796c_main.c     | 1146 +++++++++++++++++
 drivers/net/ethernet/asix/ax88796c_main.h     |  568 ++++++++
 drivers/net/ethernet/asix/ax88796c_spi.c      |  115 ++
 drivers/net/ethernet/asix/ax88796c_spi.h      |   69 +
 13 files changed, 2287 insertions(+)
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

