Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA569134D92
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgAHU3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:29:13 -0500
Received: from mga06.intel.com ([134.134.136.31]:45383 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgAHU3M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 15:29:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 12:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,411,1571727600"; 
   d="scan'208";a="223034363"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006.jf.intel.com with ESMTP; 08 Jan 2020 12:29:09 -0800
Subject: Re: [PATCH v2 3/9] ntb: intel: Constify ioreadX() iomem argument (as
 in generic implementation)
To:     Krzysztof Kozlowski <krzk@kernel.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Alexey Brodkin <abrodkin@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Dave Airlie <airlied@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Ben Skeggs <bskeggs@redhat.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jon Mason <jdmason@kudzu.us>, Allen Hubbe <allenbh@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-ntb@googlegroups.com,
        virtualization@lists.linux-foundation.org,
        linux-arch@vger.kernel.org
References: <20200108200528.4614-1-krzk@kernel.org>
 <20200108200528.4614-4-krzk@kernel.org>
From:   Dave Jiang <dave.jiang@intel.com>
Message-ID: <64659f77-f807-7c8e-7595-731056c73bf4@intel.com>
Date:   Wed, 8 Jan 2020 13:29:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200108200528.4614-4-krzk@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/20 1:05 PM, Krzysztof Kozlowski wrote:
> The ioreadX() helpers have inconsistent interface.  On some architectures
> void *__iomem address argument is a pointer to const, on some not.
> 
> Implementations of ioreadX() do not modify the memory under the address
> so they can be converted to a "const" version for const-safety and
> consistency among architectures.
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Dave Jiang <dave.jiang@intel.com>

> 
> ---
> 
> Changes since v1:
> 1. Add Geert's review.
> ---
>   drivers/ntb/hw/intel/ntb_hw_gen1.c  | 2 +-
>   drivers/ntb/hw/intel/ntb_hw_gen3.h  | 2 +-
>   drivers/ntb/hw/intel/ntb_hw_intel.h | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> index bb57ec239029..9202502a9787 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
> +++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
> @@ -1202,7 +1202,7 @@ int intel_ntb_peer_spad_write(struct ntb_dev *ntb, int pidx, int sidx,
>   			       ndev->peer_reg->spad);
>   }
>   
> -static u64 xeon_db_ioread(void __iomem *mmio)
> +static u64 xeon_db_ioread(const void __iomem *mmio)
>   {
>   	return (u64)ioread16(mmio);
>   }
> diff --git a/drivers/ntb/hw/intel/ntb_hw_gen3.h b/drivers/ntb/hw/intel/ntb_hw_gen3.h
> index 75fb86ca27bb..d1455f24ec99 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_gen3.h
> +++ b/drivers/ntb/hw/intel/ntb_hw_gen3.h
> @@ -91,7 +91,7 @@
>   #define GEN3_DB_TOTAL_SHIFT		33
>   #define GEN3_SPAD_COUNT			16
>   
> -static inline u64 gen3_db_ioread(void __iomem *mmio)
> +static inline u64 gen3_db_ioread(const void __iomem *mmio)
>   {
>   	return ioread64(mmio);
>   }
> diff --git a/drivers/ntb/hw/intel/ntb_hw_intel.h b/drivers/ntb/hw/intel/ntb_hw_intel.h
> index e071e28bca3f..3c0a5a2da241 100644
> --- a/drivers/ntb/hw/intel/ntb_hw_intel.h
> +++ b/drivers/ntb/hw/intel/ntb_hw_intel.h
> @@ -102,7 +102,7 @@ struct intel_ntb_dev;
>   struct intel_ntb_reg {
>   	int (*poll_link)(struct intel_ntb_dev *ndev);
>   	int (*link_is_up)(struct intel_ntb_dev *ndev);
> -	u64 (*db_ioread)(void __iomem *mmio);
> +	u64 (*db_ioread)(const void __iomem *mmio);
>   	void (*db_iowrite)(u64 db_bits, void __iomem *mmio);
>   	unsigned long			ntb_ctl;
>   	resource_size_t			db_size;
> 
