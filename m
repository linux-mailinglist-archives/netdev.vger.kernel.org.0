Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303122566A4
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgH2Jr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:47:58 -0400
Received: from mout.gmx.net ([212.227.17.21]:41697 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgH2Jrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:47:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598694423;
        bh=3F15H2PNzBIc0EFjrxqHH0XfkEEFa8OSmYddqGK8H+0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=hRmWoz6rZevnpTgcGALcudzkz+sRJOQ0ltLUeGjQ1hiGHADIz7w+PLuQnJplTpS25
         Qto8lTm0NsBGfkg2KJTy+wnqmbnRguZCa00cMk7o+ZMXlFDTxk3DNxHoapovDbfSzV
         MAj78BvYtiEvWHkojaanyM4LFeVjGHtFgvra5dlY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.20.60] ([92.116.169.105]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MryTF-1kzqb42Rgj-00nwOw; Sat, 29
 Aug 2020 11:47:03 +0200
Subject: Re: a saner API for allocating DMA addressable pages
To:     Christoph Hellwig <hch@lst.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
References: <20200819065555.1802761-1-hch@lst.de>
From:   Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
 c2TFWAS8k6RLkk41ZUU8ENX8+qZx/Q==
Message-ID: <73b81ba2-3f1c-cce9-0bcf-e739c2a2f6d8@gmx.de>
Date:   Sat, 29 Aug 2020 11:46:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:oJ0DWTaeXj/z2c6/t19vHP7YStT4MiWtTWeFmCetTtBo49Hh4sa
 MXIOt4fOrWhKcajKOQn9yDtXPWoBtqQjT0jJihKGRY7MdilOq6ZLvEQJAHP/3tQc3VMSqjw
 8nrw+oyKRGNPfYAhYsTPKH1SOnK7ozn1tLaEFYkGuZxVaZV1fMUaMHgotwKVH1EV+Qr8QAH
 zOF0hIOTIYaJkqfweauPA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mkE72tOExKA=:aTlUtADXpjDZT7OxFiuYUj
 v8/4kHwb2Mua8hEhk7Go/U2/ZVjYzuTKybn/zEYMtbMxrUlv2KV8hlNK/aX0VjGkoOI0DwG22
 n3rsdAjGaSUVVg/X62fzzWnbNoOST8/wh+BbxtDxG02I7XrmtJ6pPsi6+sFOMvHTB9vOrNvXG
 AwrT6QlUq2sykd+XUwh5bjMi1ghb1VeBINeLz01bZMxgasdT3SwXsBly2VULyLKKMWvqsBIFQ
 C/pu6CzlTJwktGeYeOmP93ppFx8zyomEinE6j97hLi8ACR2Vv4+EdRnza7fHIwzn6Z4o/e68T
 CL+o7ZMuMfdCf83r3xd+wKzNEpL8MUbkQsj81LCh/N4+7EAwcj2sY9eCAeIS734k2x9WKzhOm
 k5p/dzqW4h3NVw/bvw1II7RtoSntk6Nu2jssSbqE+e5UGhYAO64IRI100wLj0j+ydVaVBiMEr
 ewBbRKh2MG35gTQhi2tbxYtq3AMM79pnsf/DEKNe1Vhfn3oXdPr0xR3d5+51lntmf5Cszy0Sh
 4gIARnAPzJtKh/Ftm7D1haHNvG6EMaYJm/1016zyvm8wFY+xMfndGAtOJGBg2gl72/OklVTTU
 4r8J65WvqyNxCGHBlcYl13FQo0ig1JukwtnidnbUgGPh1vPmVSUh0QGRlo+FZ/9rCQG6emvf6
 sYQUlP0/rJjjQvVqS9WpipHHEhsDh/tVYqOFC9hbLhoxzsgqHiNe31n96SHCT9n5eeprzIQnY
 zKs2u4K2cB+S/ewejdeXOepPMED8Z/Yvf3CYwTT/W1YWuMpJtOqDHA+B9gOkRixd9kH9WPDwl
 Yq8YwexQ2fo0rXZ6Hb/LNMwtILrHFTAdqcmwQ30yHCqZs71Ka4yRR1YO0J0lMlVan091rWU3P
 XmdvZ/T1ABg8LZuI9xFe4NeHLjSlHmrq2qIi+D10YlCZv5iYCBg7odt83vpLZQNixoDJ/PWSA
 ZUoS3p7GoFjjm+scTc3Z+vtqks5pWfXGgKvq7FgERXN5SoVS1DDUGkbsyoEMLpFCiPARvSnC9
 Zw5byRRwwNj766pNE2YDmj3LOYWf9x4zwovaUS1T3ywgN7ZtUkr4Wgr7YKIoGBbAmQ+PW3oI0
 mhMcdUTFFR/wrCYaY2SZvOHJANBD9TdeGyZCpOIBtqGlXbwTfRnIVypZEfee2tKfCWnFrRngi
 xV4RAwdwqSQkWctal3BkGgiFZbu3byNVAX4Phev8myjqyGmpeZ1XvNcHSGoismCnziw8e3+Lp
 ihUo0gzdHci+IKtQW
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christoph,

On 19.08.20 08:55, Christoph Hellwig wrote:
> this series replaced the DMA_ATTR_NON_CONSISTENT flag to dma_alloc_attrs
> with a separate new dma_alloc_pages API, which is available on all
> platforms.  In addition to cleaning up the convoluted code path, this
> ensures that other drivers that have asked for better support for
> non-coherent DMA to pages with incurring bounce buffering over can final=
ly
> be properly supported.
> ....
> A git tree is available here:
>
>     git://git.infradead.org/users/hch/misc.git dma_alloc_pages

I've tested this tree on my parisc machine which uses the 53c700
and lasi_82596 drivers.
Everything worked as expected, so you may add:

Tested-by: Helge Deller <deller@gmx.de> # parisc

Thanks!
Helge

>
> Gitweb:
>
>     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/dma_=
alloc_pages
>
>
> Diffstat:
>  Documentation/core-api/dma-api.rst                       |   92 ++----
>  Documentation/core-api/dma-attributes.rst                |    8
>  Documentation/userspace-api/media/v4l/buffer.rst         |   17 -
>  Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst |    1
>  arch/alpha/kernel/pci_iommu.c                            |    2
>  arch/arm/include/asm/dma-direct.h                        |    4
>  arch/arm/mm/dma-mapping-nommu.c                          |    2
>  arch/arm/mm/dma-mapping.c                                |    4
>  arch/ia64/Kconfig                                        |    3
>  arch/ia64/hp/common/sba_iommu.c                          |    2
>  arch/ia64/kernel/dma-mapping.c                           |   14
>  arch/ia64/mm/init.c                                      |    3
>  arch/mips/Kconfig                                        |    1
>  arch/mips/bmips/dma.c                                    |    4
>  arch/mips/cavium-octeon/dma-octeon.c                     |    4
>  arch/mips/include/asm/dma-direct.h                       |    4
>  arch/mips/include/asm/jazzdma.h                          |    2
>  arch/mips/jazz/jazzdma.c                                 |  102 +------
>  arch/mips/loongson2ef/fuloong-2e/dma.c                   |    4
>  arch/mips/loongson2ef/lemote-2f/dma.c                    |    4
>  arch/mips/loongson64/dma.c                               |    4
>  arch/mips/mm/dma-noncoherent.c                           |   48 +--
>  arch/mips/pci/pci-ar2315.c                               |    4
>  arch/mips/pci/pci-xtalk-bridge.c                         |    4
>  arch/mips/sgi-ip32/ip32-dma.c                            |    4
>  arch/parisc/Kconfig                                      |    1
>  arch/parisc/kernel/pci-dma.c                             |    6
>  arch/powerpc/include/asm/dma-direct.h                    |    4
>  arch/powerpc/kernel/dma-iommu.c                          |    2
>  arch/powerpc/platforms/ps3/system-bus.c                  |    4
>  arch/powerpc/platforms/pseries/vio.c                     |    2
>  arch/s390/pci/pci_dma.c                                  |    2
>  arch/x86/kernel/amd_gart_64.c                            |    8
>  drivers/gpu/drm/exynos/exynos_drm_gem.c                  |    2
>  drivers/gpu/drm/nouveau/nvkm/subdev/instmem/gk20a.c      |    3
>  drivers/iommu/dma-iommu.c                                |    2
>  drivers/iommu/intel/iommu.c                              |    6
>  drivers/media/common/videobuf2/videobuf2-core.c          |   36 --
>  drivers/media/common/videobuf2/videobuf2-dma-contig.c    |   19 -
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c        |    3
>  drivers/media/common/videobuf2/videobuf2-v4l2.c          |   12
>  drivers/net/ethernet/amd/au1000_eth.c                    |   15 -
>  drivers/net/ethernet/i825xx/lasi_82596.c                 |   36 +-
>  drivers/net/ethernet/i825xx/lib82596.c                   |  148 +++++--=
---
>  drivers/net/ethernet/i825xx/sni_82596.c                  |   23 -
>  drivers/net/ethernet/seeq/sgiseeq.c                      |   24 -
>  drivers/nvme/host/pci.c                                  |   79 ++---
>  drivers/parisc/ccio-dma.c                                |    2
>  drivers/parisc/sba_iommu.c                               |    2
>  drivers/scsi/53c700.c                                    |  120 ++++---=
-
>  drivers/scsi/53c700.h                                    |    9
>  drivers/scsi/sgiwd93.c                                   |   14
>  drivers/xen/swiotlb-xen.c                                |    2
>  include/linux/dma-direct.h                               |   55 ++-
>  include/linux/dma-mapping.h                              |   32 +-
>  include/linux/dma-noncoherent.h                          |   21 -
>  include/linux/dmapool.h                                  |   23 +
>  include/linux/gfp.h                                      |    6
>  include/media/videobuf2-core.h                           |    3
>  include/uapi/linux/videodev2.h                           |    2
>  kernel/dma/Kconfig                                       |    9
>  kernel/dma/Makefile                                      |    1
>  kernel/dma/coherent.c                                    |   17 +
>  kernel/dma/direct.c                                      |  112 +++++--
>  kernel/dma/mapping.c                                     |  104 ++-----
>  kernel/dma/ops_helpers.c                                 |   86 ++++++
>  kernel/dma/pool.c                                        |    2
>  kernel/dma/swiotlb.c                                     |    4
>  kernel/dma/virt.c                                        |    2
>  mm/dmapool.c                                             |  211 +++++++=
++------
>  sound/mips/hal2.c                                        |   58 +---
>  71 files changed, 872 insertions(+), 803 deletions(-)
>

